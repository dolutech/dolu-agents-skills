# Deployment Strategies

Detailed implementations of rolling, blue-green, and canary deployment strategies.

## Rolling Deployment

### Kubernetes Implementation

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Can create 1 extra pod during rollout
      maxUnavailable: 0  # Never have less than desired replicas
      
  selector:
    matchLabels:
      app: my-app
      
  template:
    metadata:
      labels:
        app: my-app
        version: v1.2.3
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        
    spec:
      serviceAccountName: my-app
      terminationGracePeriodSeconds: 30
      
      containers:
      - name: app
        image: registry.example.com/my-app:v1.2.3
        imagePullPolicy: Always
        
        ports:
        - containerPort: 8080
          name: http
          protocol: TCP
        
        # Health checks
        livenessProbe:
          httpGet:
            path: /health/live
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 5
          failureThreshold: 3
          successThreshold: 1
        
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
          successThreshold: 1
        
        # Resource limits
        resources:
          requests:
            cpu: "250m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        
        # Environment variables
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: api-key
        
        # Lifecycle hooks
        lifecycle:
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 10 && kill -TERM $$"]
          postStart:
            exec:
              command: ["/bin/sh", "-c", "echo 'Container started'"]
      
      # Pod disruption budget
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: my-app
              topologyKey: kubernetes.io/hostname

---
# Pod Disruption Budget
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 3
  selector:
    matchLabels:
      app: my-app
```

### Rolling Deployment Script

```bash
#!/bin/bash
# Rolling deployment script with monitoring

set -euo pipefail

DEPLOYMENT_NAME="my-app"
NAMESPACE="production"
IMAGE="registry.example.com/my-app:v1.2.3"
TIMEOUT=600  # 10 minutes

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_exit() {
    log "ERROR: $1"
    # Automatic rollback
    log "Initiating automatic rollback..."
    kubectl rollout undo deployment/$DEPLOYMENT_NAME -n $NAMESPACE
    exit 1
}

log "Starting rolling deployment..."

# Get current state
CURRENT_IMAGE=$(kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')
log "Current image: $CURRENT_IMAGE"
log "New image: $IMAGE"

# Start rollout
log "Updating deployment..."
kubectl set image deployment/$DEPLOYMENT_NAME app=$IMAGE -n $NAMESPACE

# Monitor rollout with timeout
log "Monitoring rollout (timeout: ${TIMEOUT}s)..."
START_TIME=$(date +%s)

while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    if [ $ELAPSED -gt $TIMEOUT ]; then
        error_exit "Rollout timeout exceeded"
    fi
    
    STATUS=$(kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=10s 2>&1 || true)
    
    if echo "$STATUS" | grep -q "successfully rolled out"; then
        log "✅ Rollout completed successfully!"
        break
    fi
    
    if echo "$STATUS" | grep -q "error:"; then
        error_exit "Rollout failed: $STATUS"
    fi
    
    # Show progress
    READY=$(kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
    DESIRED=$(kubectl get deployment/$DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')
    log "Progress: $READY/$DESIRED pods ready (${ELAPSED}s elapsed)"
    
    sleep 5
done

# Verify health
log "Verifying deployment health..."
sleep 10  # Wait for pods to stabilize

ERROR_RATE=$(curl -s http://prometheus/api/v1/query?query=rate\(http_errors_total\[5m\]\) | jq '.data.result[0].value[1]' || echo "0")
log "Current error rate: $ERROR_RATE"

if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
    error_exit "Error rate too high after deployment: $ERROR_RATE"
fi

log "✅ Deployment verified successfully!"
log "New image: $IMAGE"
```

## Blue-Green Deployment

### Kubernetes Implementation

```yaml
# Blue Environment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-blue
  labels:
    app: my-app
    environment: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      environment: blue
  template:
    metadata:
      labels:
        app: my-app
        environment: blue
    spec:
      containers:
      - name: app
        image: registry.example.com/my-app:v1.2.3
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10

---
# Green Environment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-green
  labels:
    app: my-app
    environment: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      environment: green
  template:
    metadata:
      labels:
        app: my-app
        environment: green
    spec:
      containers:
      - name: app
        image: registry.example.com/my-app:v1.2.3
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10

---
# Main Service (points to active environment)
apiVersion: v1
kind: Service
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  type: ClusterIP
  selector:
    app: my-app
    environment: blue  # Changed during deployment
  ports:
  - port: 80
    targetPort: 8080
    name: http

---
# ConfigMap to track active environment
apiVersion: v1
kind: ConfigMap
metadata:
  name: active-environment
data:
  environment: blue

---
# Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app
            port:
              number: 80
```

### Blue-Green Deployment Script

```bash
#!/bin/bash
# Blue-Green deployment script

set -euo pipefail

NAMESPACE="production"
IMAGE="registry.example.com/my-app:v1.2.3"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Get current active environment
CURRENT=$(kubectl get configmap active-environment -n $NAMESPACE -o jsonpath='{.data.environment}')
NEXT=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")

log "Current active environment: $CURRENT"
log "Deploying to: $NEXT"

# Deploy to inactive environment
log "Deploying new version to $NEXT environment..."
kubectl set image deployment/my-app-$NEXT app=$IMAGE -n $NAMESPACE

# Wait for rollout
log "Waiting for rollout to complete..."
kubectl rollout status deployment/my-app-$NEXT -n $NAMESPACE --timeout=300s

# Verify health in inactive environment
log "Running smoke tests on $NEXT environment..."
NEXT_POD=$(kubectl get pods -n $NAMESPACE -l app=my-app,environment=$NEXT -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $NAMESPACE $NEXT_POD -- ./scripts/health-check.sh || exit 1

# Verify metrics
log "Checking error rates..."
ERROR_RATE=$(curl -s http://prometheus/api/v1/query?query=rate\(http_errors_total\{environment=\"$NEXT\"\}\[5m\]\) | jq '.data.result[0].value[1]' || echo "0")
log "Error rate in $NEXT: $ERROR_RATE"

if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
    log "❌ Error rate too high in $NEXT environment. Aborting traffic switch."
    exit 1
fi

# Switch traffic
log "Switching traffic from $CURRENT to $NEXT..."
kubectl patch service my-app -n $NAMESPACE -p "{\"spec\":{\"selector\":{\"environment\":\"$NEXT\"}}}"

# Update active environment config
kubectl patch configmap active-environment -n $NAMESPACE -p "{\"data\":{\"environment\":\"$NEXT\"}}"

# Wait for traffic to stabilize
log "Waiting for traffic to stabilize..."
sleep 30

# Verify traffic switch
log "Verifying traffic switch..."
for i in {1..5}; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://app.example.com/health)
    if [ "$RESPONSE" = "200" ]; then
        log "✅ Health check passed ($i/5)"
    else
        log "❌ Health check failed ($i/5) - HTTP $RESPONSE"
        exit 1
    fi
    sleep 5
done

# Scale down old environment
log "Scaling down $CURRENT environment..."
kubectl scale deployment/my-app-$CURRENT -n $NAMESPACE --replicas=0

log "✅ Blue-Green deployment completed successfully!"
log "Active environment: $NEXT"
log "Previous environment: $CURRENT (scaled down)"

# Optional: Send notification
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"✅ Blue-Green deployment completed. Active: $NEXT\"}" \
    "${SLACK_WEBHOOK_URL:-}" || true
```

## Canary Deployment

### Kubernetes with Argo Rollouts

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: my-app
spec:
  replicas: 10
  strategy:
    canary:
      steps:
      - setWeight: 10       # 10% of traffic
        pause: {duration: 5m}  # Wait 5 minutes
      
      - setWeight: 25       # 25% of traffic
        pause: {duration: 10m} # Wait 10 minutes
      
      - setWeight: 50       # 50% of traffic
        pause: {duration: 15m}
      
      - setWeight: 75       # 75% of traffic
        pause: {duration: 15m}
      
      - setWeight: 100      # Full rollout
      
      # Analysis at each step
      analysis:
        templates:
        - templateName: success-rate
        - templateName: error-rate
        - templateName: latency-p95
        startingStep: 1
        args:
        - name: service-name
          value: my-app
        - name: namespace
          value: production
      
      # Traffic routing
      trafficRouting:
        nginx:
          stableService: my-app-stable
          canaryService: my-app-canary
          ingress:
            name: my-app-ingress
            class: nginx
      
      # Failure handling
      abortScaleDownDelaySeconds: 300
      
      # Analysis run failure
      analysisRunMetadata:
        labels:
          app: my-app

---
# Stable Service (current version)
apiVersion: v1
kind: Service
metadata:
  name: my-app-stable
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080

---
# Canary Service (new version)
apiVersion: v1
kind: Service
metadata:
  name: my-app-canary
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080

---
# Analysis Template: Success Rate
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: success-rate
spec:
  args:
  - name: service-name
  - name: namespace
  metrics:
  - name: success-rate
    interval: 1m
    successCondition: result[0] >= 0.99
    failureLimit: 3
    provider:
      prometheus:
        address: http://prometheus:9090
        query: |
          sum(rate(http_requests_total{service="{{args.service-name}}",status!~"5.."}[5m])) 
          / 
          sum(rate(http_requests_total{service="{{args.service-name}}"}[5m]))

---
# Analysis Template: Error Rate
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: error-rate
spec:
  args:
  - name: service-name
  - name: namespace
  metrics:
  - name: error-rate
    interval: 1m
    successCondition: result[0] <= 0.01
    failureLimit: 3
    provider:
      prometheus:
        address: http://prometheus:9090
        query: |
          sum(rate(http_requests_total{service="{{args.service-name}}",status~"5.."}[5m])) 
          / 
          sum(rate(http_requests_total{service="{{args.service-name}}"}[5m]))

---
# Analysis Template: P95 Latency
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: latency-p95
spec:
  args:
  - name: service-name
  - name: namespace
  metrics:
  - name: latency-p95
    interval: 1m
    successCondition: result[0] <= 500
    failureLimit: 3
    provider:
      prometheus:
        address: http://prometheus:9090
        query: |
          histogram_quantile(0.95, 
            sum(rate(http_request_duration_seconds_bucket{service="{{args.service-name}}"}[5m])) 
            by (le)
          )
```

### Canary Deployment Script (Manual)

```bash
#!/bin/bash
# Manual canary deployment script

set -euo pipefail

NAMESPACE="production"
DEPLOYMENT="my-app"
IMAGE="registry.example.com/my-app:v1.2.3"
TOTAL_REPLICAS=10

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to update canary percentage
set_canary_weight() {
    local weight=$1
    local canary_replicas=$((TOTAL_REPLICAS * weight / 100))
    local stable_replicas=$((TOTAL_REPLICAS - canary_replicas))
    
    log "Setting canary weight to ${weight}% ($canary_replicas canary, $stable_replicas stable)"
    
    kubectl scale deployment/$DEPLOYMENT-canary -n $NAMESPACE --replicas=$canary_replicas
    kubectl scale deployment/$DEPLOYMENT-stable -n $NAMESPACE --replicas=$stable_replicas
    
    # Wait for scaling
    sleep 30
}

# Function to verify metrics
verify_metrics() {
    log "Verifying metrics..."
    
    # Check error rate
    ERROR_RATE=$(curl -s http://prometheus/api/v1/query?query=rate\(http_requests_total\{version=\"canary\",status~\"5..\"\}\[5m\]\) | jq '.data.result[0].value[1]' || echo "0")
    log "Canary error rate: $ERROR_RATE"
    
    if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
        log "❌ Error rate too high: $ERROR_RATE"
        return 1
    fi
    
    # Check latency
    LATENCY_P95=$(curl -s http://prometheus/api/v1/query?query=histogram_quantile\(0.95,sum\(rate\(http_request_duration_seconds_bucket\{version=\"canary\"\}\[5m\]\)\)\) | jq '.data.result[0].value[1]' || echo "0")
    log "Canary P95 latency: ${LATENCY_P95}ms"
    
    if (( $(echo "$LATENCY_P95 > 500" | bc -l) )); then
        log "❌ Latency too high: ${LATENCY_P95}ms"
        return 1
    fi
    
    log "✅ Metrics verification passed"
    return 0
}

# Start canary deployment
log "Starting canary deployment..."

# Deploy canary version
kubectl set image deployment/$DEPLOYMENT-canary app=$IMAGE -n $NAMESPACE
kubectl rollout status deployment/$DEPLOYMENT-canary -n $NAMESPACE --timeout=300s

# Gradual rollout
STEPS=(10 25 50 75 100)
PAUSE_MINUTES=(5 10 15 15 0)

for i in "${!STEPS[@]}"; do
    WEIGHT=${STEPS[$i]}
    PAUSE=${PAUSE_MINUTES[$i]}
    
    log "=== Step $((i+1))/${#STEPS[@]}: ${WEIGHT}% ==="
    
    set_canary_weight $WEIGHT
    
    if [ $PAUSE -gt 0 ]; then
        log "Monitoring for $PAUSE minutes..."
        
        for ((minute=1; minute<=PAUSE; minute++)); do
            log "Minute $minute/$PAUSE"
            
            if ! verify_metrics; then
                log "❌ Canary verification failed. Rolling back..."
                kubectl scale deployment/$DEPLOYMENT-canary -n $NAMESPACE --replicas=0
                exit 1
            fi
            
            sleep 60
        done
    fi
done

log "✅ Canary deployment completed successfully!"
log "All traffic now routing to new version"
```

## Deployment Strategy Comparison

| Aspect | Rolling | Blue-Green | Canary |
|--------|---------|------------|--------|
| **Downtime** | None | None | None |
| **Infrastructure** | Normal | 2x | Normal |
| **Risk** | Medium | Low | Lowest |
| **Rollback Speed** | Fast | Instant | Fast |
| **Complexity** | Low | Medium | High |
| **Traffic Control** | None | All-or-nothing | Granular |
| **Best For** | Frequent deploys | Critical apps | High-traffic apps |

## When to Use Each Strategy

### Rolling Deployment
✅ **Use when:**
- Frequent deployments (multiple per day)
- Limited infrastructure budget
- Low-risk changes (bug fixes, minor features)
- Good automated testing

❌ **Avoid when:**
- Zero tolerance for errors
- Database schema changes
- Major architectural changes

### Blue-Green Deployment
✅ **Use when:**
- Zero-downtime required
- Need instant rollback
- Database migrations
- Major version upgrades
- High-confidence releases

❌ **Avoid when:**
- Infrastructure cost is concern
- Very frequent deployments
- Large stateful applications

### Canary Deployment
✅ **Use when:**
- High-traffic applications
- Risk mitigation critical
- Want real-user validation
- A/B testing needed
- Performance validation

❌ **Avoid when:**
- Simple infrastructure
- Low traffic
- No monitoring in place
- Quick deployments needed
