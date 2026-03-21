# CI/CD Patterns

Complete CI/CD pipeline configurations for different platforms and use cases.

## GitHub Actions Patterns

### Standard Node.js Pipeline

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run type check
        run: npm run type-check
      
      - name: Run unit tests
        run: npm run test:unit
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/test
          REDIS_URL: redis://localhost:6379
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/test
          REDIS_URL: redis://localhost:6379
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: false

  security:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Run SAST
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/security-audit
            p/secrets
            p/owasp-top-ten
      
      - name: Scan dependencies
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

  build:
    runs-on: ubuntu-latest
    needs: [test, security]
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=
            type=ref,event=branch
            type=semver,pattern={{version}}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          platforms: linux/amd64,linux/arm64
      
      - name: Scan image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-image-results.sarif'
      
      - name: Upload Trivy image results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: 'trivy-image-results.sarif'

  deploy-staging:
    runs-on: ubuntu-latest
    needs: build
    environment: staging
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'v1.28.0'
      
      - name: Configure kubeconfig
        run: |
          mkdir -p ~/.kube
          echo "${{ secrets.KUBE_CONFIG_STAGING }}" | base64 -d > ~/.kube/config
      
      - name: Deploy to staging
        run: |
          kubectl set image deployment/app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          kubectl rollout status deployment/app --timeout=300s
      
      - name: Run smoke tests
        run: |
          ./scripts/smoke-tests.sh
        env:
          BASE_URL: https://staging.example.com

  deploy-production:
    runs-on: ubuntu-latest
    needs: deploy-staging
    environment: production
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'v1.28.0'
      
      - name: Configure kubeconfig
        run: |
          mkdir -p ~/.kube
          echo "${{ secrets.KUBE_CONFIG_PRODUCTION }}" | base64 -d > ~/.kube/config
      
      - name: Create database backup
        run: |
          ./scripts/backup-database.sh
      
      - name: Deploy to production
        run: |
          kubectl set image deployment/app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          kubectl rollout status deployment/app --timeout=600s
      
      - name: Run smoke tests
        run: |
          ./scripts/smoke-tests.sh
        env:
          BASE_URL: https://api.example.com
      
      - name: Notify success
        if: success()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "✅ Deployment successful: ${{ github.sha }}",
              "channel": "#deployments"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
      
      - name: Notify failure
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "❌ Deployment failed: ${{ github.sha }}",
              "channel": "#deployments"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Blue-Green Deployment Workflow

```yaml
name: Blue-Green Deployment

on:
  push:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
      
      - name: Setup kubectl
        uses: azure/setup-kubectl@v3
      
      - name: Configure kubeconfig
        run: |
          mkdir -p ~/.kube
          echo "${{ secrets.KUBE_CONFIG_PRODUCTION }}" | base64 -d > ~/.kube/config
      
      - name: Get current active environment
        id: current
        run: |
          CURRENT=$(kubectl get configmap active-environment -o jsonpath='{.data.environment}')
          echo "current=$CURRENT" >> $GITHUB_OUTPUT
          echo "Current active: $CURRENT"
      
      - name: Determine next environment
        id: next
        run: |
          CURRENT="${{ steps.current.outputs.current }}"
          NEXT=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")
          echo "next=$NEXT" >> $GITHUB_OUTPUT
          echo "Next environment: $NEXT"
      
      - name: Deploy to inactive environment
        run: |
          NEXT="${{ steps.next.outputs.next }}"
          kubectl set image deployment/$NEXT-app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          kubectl rollout status deployment/$NEXT-app --timeout=300s
      
      - name: Run smoke tests on inactive
        run: |
          NEXT="${{ steps.next.outputs.next }}"
          ./scripts/smoke-tests.sh $NEXT
        env:
          BASE_URL: "https://${{ steps.next.outputs.next }}.example.com"
      
      - name: Switch traffic
        run: |
          NEXT="${{ steps.next.outputs.next }}"
          kubectl patch service main-app -p '{"spec":{"selector":{"environment":"'$NEXT'"}}}'
          
          # Update active environment config
          kubectl patch configmap active-environment -p '{"data":{"environment":"'$NEXT'"}}'
      
      - name: Verify traffic switch
        run: |
          sleep 10
          ./scripts/verify-traffic.sh
      
      - name: Scale down old environment
        run: |
          CURRENT="${{ steps.current.outputs.current }}"
          kubectl scale deployment/$CURRENT-app --replicas=0
      
      - name: Cleanup old deployments
        run: |
          CURRENT="${{ steps.current.outputs.current }}"
          kubectl rollout history deployment/$CURRENT-app | head -n -3 | tail -n +3 | awk '{print $1}' | while read revision; do
            kubectl rollout undo deployment/$CURRENT-app --to-revision=$revision --dry-run=client || true
          done
```

## GitLab CI Patterns

### Complete GitLab CI Pipeline

```yaml
stages:
  - validate
  - test
  - build
  - security
  - deploy-staging
  - deploy-production

variables:
  DOCKER_REGISTRY: registry.gitlab.com
  IMAGE_NAME: $CI_PROJECT_PATH
  POSTGRES_DB: test_db
  POSTGRES_USER: postgres
  POSTGRES_PASSWORD: postgres

.default-interrupt: &default-interrupt
  interruptible: true

.validate-template: &validate-template
  <<: *default-interrupt
  stage: validate
  image: node:20-alpine
  cache:
    paths:
      - node_modules/
  before_script:
    - npm ci

lint:
  <<: *validate-template
  script:
    - npm run lint
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"

type-check:
  <<: *validate-template
  script:
    - npm run type-check
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"

.test-template: &test-template
  <<: *default-interrupt
  stage: test
  image: node:20-alpine
  services:
    - postgres:15
    - redis:7
  cache:
    paths:
      - node_modules/
  before_script:
    - npm ci
  variables:
    DATABASE_URL: postgres://postgres:postgres@postgres:5432/test_db
    REDIS_URL: redis://redis:6379

test:unit:
  <<: *test-template
  script:
    - npm run test:unit -- --coverage
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week

test:integration:
  <<: *test-template
  script:
    - npm run test:integration
  artifacts:
    when: on_failure
    paths:
      - logs/
    expire_in: 1 week

test:e2e:
  <<: *test-template
  stage: deploy-staging
  image: cypress/included:latest
  script:
    - npm run test:e2e
  variables:
    BASE_URL: https://staging.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
    - if: $CI_COMMIT_BRANCH == "main"

build:
  <<: *default-interrupt
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA .
    - docker push $DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA
    - docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:latest .
    - docker push $DOCKER_REGISTRY/$IMAGE_NAME:latest
  artifacts:
    paths:
      - docker-image-digest.txt
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_BRANCH == "develop"

security:
  <<: *default-interrupt
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy image --exit-code 0 --severity HIGH,CRITICAL --format sarif --output trivy.sarif $DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA
    - trivy image --exit-code 1 --severity CRITICAL $DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA || echo "Critical vulnerabilities found"
  artifacts:
    reports:
      container_scanning: trivy.sarif
  allow_failure: true
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy:staging:
  <<: *default-interrupt
  stage: deploy-staging
  image: bitnami/kubectl:latest
  environment:
    name: staging
    url: https://staging.example.com
  variables:
    KUBECONFIG_PATH: /tmp/kubeconfig
  before_script:
    - echo "$KUBE_CONFIG_STAGING" | base64 -d > $KUBECONFIG_PATH
    - export KUBECONFIG=$KUBECONFIG_PATH
  script:
    - kubectl set image deployment/app app=$DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA
    - kubectl rollout status deployment/app --timeout=300s
    - ./scripts/smoke-tests.sh
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
    - if: $CI_COMMIT_BRANCH == "main"

deploy:production:
  <<: *default-interrupt
  stage: deploy-production
  image: bitnami/kubectl:latest
  environment:
    name: production
    url: https://api.example.com
    action_on_start: protect
    action_on_stop: unprotect
  variables:
    KUBECONFIG_PATH: /tmp/kubeconfig
  before_script:
    - echo "$KUBE_CONFIG_PRODUCTION" | base64 -d > $KUBECONFIG_PATH
    - export KUBECONFIG=$KUBECONFIG_PATH
    - echo "Creating database backup..."
    - ./scripts/backup-database.sh
  script:
    - kubectl set image deployment/app app=$DOCKER_REGISTRY/$IMAGE_NAME:$CI_COMMIT_SHA
    - kubectl rollout status deployment/app --timeout=600s
    - ./scripts/smoke-tests.sh
    - echo "Deployment completed successfully"
  after_script:
    - echo "Cleaning up..."
    - rm -f $KUBECONFIG_PATH
  when: manual
  allow_failure: false
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

## Jenkins Patterns

### Declarative Pipeline

```groovy
pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }
    
    environment {
        REGISTRY = 'registry.example.com'
        IMAGE_NAME = "${env.JOB_NAME.toLowerCase()}"
        DOCKER_CREDS = credentials('docker-credentials')
        KUBE_CONFIG = credentials('kubeconfig-prod')
    }
    
    stages {
        stage('Validate') {
            stages {
                stage('Lint') {
                    agent any
                    steps {
                        sh 'npm run lint'
                    }
                }
                stage('Type Check') {
                    agent any
                    steps {
                        sh 'npm run type-check'
                    }
                }
            }
        }
        
        stage('Test') {
            agent any
            stages {
                stage('Unit Tests') {
                    steps {
                        container('node') {
                            sh 'npm run test:unit -- --coverage'
                        }
                    }
                    post {
                        always {
                            publishCoverage adapters: [coberturaAdapter('coverage/cobertura-coverage.xml')]
                        }
                    }
                }
                stage('Integration Tests') {
                    steps {
                        container('node') {
                            withEnv(['DATABASE_URL=postgres://postgres:postgres@postgres:5432/test']) {
                                sh 'npm run test:integration'
                            }
                        }
                    }
                }
            }
            services {
                postgresql {
                    image = 'postgres:15'
                    environment = [POSTGRES_PASSWORD: 'postgres']
                }
                redis {
                    image = 'redis:7'
                }
            }
        }
        
        stage('Security') {
            parallel {
                stage('SAST') {
                    steps {
                        container('semgrep') {
                            sh 'semgrep --config auto --json --output semgrep.json .'
                        }
                    }
                }
                stage('Dependency Scan') {
                    steps {
                        container('trivy') {
                            sh 'trivy fs --format sarif --output trivy.sarif .'
                        }
                    }
                }
                stage('Secret Scan') {
                    steps {
                        sh 'gitleaks detect --source . --report-path gitleaks.json'
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    docker.withRegistry("https://${env.REGISTRY}", env.DOCKER_CREDS) {
                        def customImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}")
                        
                        withEnv(['TRIVY_IGNORE_UNFIXED=true']) {
                            container('trivy') {
                                sh "trivy image --exit-code 0 --severity HIGH,CRITICAL ${env.IMAGE_NAME}:${env.BUILD_ID}"
                            }
                        }
                        
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
        
        stage('Deploy Staging') {
            when {
                branch 'develop'
            }
            steps {
                container('kubectl') {
                    withKubeConfig([credentialsId: 'kubeconfig-staging']) {
                        sh """
                            kubectl set image deployment/app app=${env.REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_ID}
                            kubectl rollout status deployment/app --timeout=300s
                        """
                    }
                }
            }
        }
        
        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                container('kubectl') {
                    withKubeConfig([credentialsId: 'kubeconfig-prod']) {
                        sh """
                            ./scripts/backup-database.sh
                            kubectl set image deployment/app app=${env.REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_ID}
                            kubectl rollout status deployment/app --timeout=600s
                            ./scripts/smoke-tests.sh
                        """
                    }
                }
            }
            post {
                always {
                    emailext (
                        subject: "${currentBuild.fullDisplayName} - ${currentBuild.currentResult}",
                        body: """
                            Build: ${env.BUILD_URL}
                            Job: ${env.JOB_NAME}
                            Build Number: ${env.BUILD_NUMBER}
                            Result: ${currentBuild.currentResult}
                        """,
                        to: 'team@example.com',
                        recipientProviders: [developers(), requestor()]
                    )
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}
```

## Database Migration Patterns

### Safe Migration Workflow

```yaml
name: Database Migration

on:
  push:
    branches: [main]
    paths:
      - 'migrations/**'

jobs:
  validate-migrations:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run migrations on test database
        run: |
          npm run db:migrate
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/test
      
      - name: Run migrations rollback
        run: |
          npm run db:rollback
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/test
      
      - name: Verify schema
        run: |
          npm run db:verify

  deploy-migrations:
    runs-on: ubuntu-latest
    needs: validate-migrations
    environment: production
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Create database backup
        run: |
          ./scripts/backup-database.sh
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
      
      - name: Run migrations
        run: |
          npm run db:migrate
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
      
      - name: Verify migrations
        run: |
          npm run db:verify
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
      
      - name: Notify completion
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "✅ Database migrations completed successfully",
              "channel": "#database"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```
