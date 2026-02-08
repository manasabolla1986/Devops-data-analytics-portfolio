# Deployment Configuration Examples

## AWS Elastic Beanstalk

Create `.ebextensions/01_java.config`:

```yaml
option_settings:
  aws:elasticbeanstalk:container:java:
    JVMOptions: '-Xmx512m -Xms256m'
  aws:elasticbeanstalk:application:environment:
    SERVER_PORT: 5000
```

Deploy command:
```bash
eb init -p java-17 java-cicd-demo
eb create prod-env
eb deploy
```

## Google Cloud Platform (App Engine)

Create `app.yaml`:

```yaml
runtime: java17
instance_class: F2

env_variables:
  JAVA_OPTS: "-Xmx512m"

automatic_scaling:
  min_instances: 1
  max_instances: 10
```

Deploy command:
```bash
gcloud app deploy
```

## Azure App Service

Deploy using Azure CLI:

```bash
az webapp create --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name java-cicd-demo \
  --runtime "JAVA:17-java17"

az webapp deploy --resource-group myResourceGroup \
  --name java-cicd-demo \
  --src-path target/java-cicd-demo-1.0.0.jar \
  --type jar
```

## Kubernetes Deployment

Create `k8s-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-cicd-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: java-cicd-demo
  template:
    metadata:
      labels:
        app: java-cicd-demo
    spec:
      containers:
      - name: app
        image: your-registry/java-cicd-demo:latest
        ports:
        - containerPort: 8080
        env:
        - name: JAVA_OPTS
          value: "-Xmx512m -Xms256m"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: java-cicd-demo
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: java-cicd-demo
```

Deploy:
```bash
kubectl apply -f k8s-deployment.yaml
```

## Docker Registry Push

GitHub Actions can be configured to push to Docker registries:

```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: |
      your-registry/java-cicd-demo:latest
      your-registry/java-cicd-demo:${{ github.sha }}
```

## Environment Variables

Common environment variables for production:

```bash
JAVA_OPTS="-Xmx1024m -Xms512m -XX:+UseG1GC"
SERVER_PORT=8080
LOG_LEVEL=INFO
ENVIRONMENT=production
```
