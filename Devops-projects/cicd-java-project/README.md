# 🚀 Java Spring Boot — CI/CD Pipeline for Containerized Application

A production-ready Spring Boot REST API wired up with a full CI/CD pipeline using **GitHub Actions**, **Docker**, and **Kubernetes**.

---

## 📁 Project Structure

```
cicd-java-project/
├── src/
│   ├── main/java/com/example/app/
│   │   ├── Application.java              # Spring Boot entry point
│   │   ├── controller/ProductController  # REST endpoints
│   │   ├── service/ProductService        # Business logic
│   │   ├── service/ProductRepository     # JPA data access
│   │   └── model/Product                 # JPA entity
│   ├── main/resources/
│   │   ├── application.properties        # Dev / default config (H2)
│   │   └── application-prod.properties   # Production config (PostgreSQL)
│   └── test/
│       ├── java/.../ApplicationTest.java # Unit + integration tests
│       └── resources/application-test.properties
├── .github/workflows/
│   └── ci-cd.yml                         # Full GitHub Actions pipeline
├── k8s/
│   └── deployment.yaml                   # K8s Deployment, Service, Ingress, HPA, PDB
├── scripts/
│   ├── smoke-test.sh                     # Post-deploy smoke tests
│   └── prometheus.yml                    # Prometheus scrape config
├── Dockerfile                            # Multi-stage build
├── docker-compose.yml                    # Local dev orchestration
└── pom.xml                               # Maven build + JaCoCo + Jib
```

---

## 🧱 Technology Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.2 |
| Build | Maven + JaCoCo (coverage) + Jib (Docker) |
| Database | H2 (dev/test), PostgreSQL (production) |
| Containerization | Docker (multi-stage), Docker Compose |
| Orchestration | Kubernetes (Deployment, HPA, Ingress, PDB) |
| CI/CD | GitHub Actions |
| Security Scan | Trivy |
| Observability | Spring Actuator, Micrometer, Prometheus |

---

## 🔄 CI/CD Pipeline Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Push to main / develop                                                        │
└────────────────────────────────────────┬─────────────────────────────────────┘
                                         │
                                    ┌────▼────┐
                                    │  TEST   │  compile + unit tests
                                    │         │  + integration tests
                                    │         │  + JaCoCo coverage (≥70%)
                                    └────┬────┘
                                         │ pass
                                    ┌────▼────┐
                                    │  BUILD  │  docker buildx
                                    │         │  multi-arch (amd64/arm64)
                                    │         │  push to registry
                                    └────┬────┘
                                         │
                                    ┌────▼────┐
                                    │SECURITY │  Trivy CVE scan
                                    │  SCAN   │  fail on CRITICAL/HIGH
                                    └────┬────┘
                           ┌─────────────┴──────────────┐
                      develop                           main
                           │                             │
                    ┌──────▼──────┐             ┌───────▼───────┐
                    │   STAGING   │             │  PRODUCTION   │
                    │   deploy    │             │  (manual gate)│
                    │ smoke tests │             │  deploy       │
                    └─────────────┘             │  smoke tests  │
                                                │  Slack notify │
                                                └───────────────┘
```

---

## 🚀 Quick Start — Local Development

### 1. Run with H2 (in-memory, no dependencies)
```bash
./mvnw spring-boot:run
# App: http://localhost:8080
# H2 Console: http://localhost:8080/h2-console
```

### 2. Run with Docker Compose
```bash
# App only (H2)
docker-compose up --build

# App + PostgreSQL
docker-compose --profile postgres up --build
```

### 3. Build Docker image locally
```bash
docker build -t cicd-demo-app:local .
docker run -p 8080:8080 cicd-demo-app:local
```

---

## 🧪 Tests & Coverage

```bash
# Run all tests
./mvnw verify

# Run with coverage report
./mvnw verify -P test
# Report: target/site/jacoco/index.html
```

Coverage gate is set to **70% line coverage** — the build fails if not met (configurable in `pom.xml`).

---

## 📡 API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/api/products` | List all products |
| GET | `/api/products/{id}` | Get product by ID |
| POST | `/api/products` | Create a product |
| PUT | `/api/products/{id}` | Update a product |
| DELETE | `/api/products/{id}` | Delete a product |
| GET | `/api/products/health` | App health check |
| GET | `/actuator/health` | Spring Actuator health (K8s probes) |
| GET | `/actuator/prometheus` | Prometheus metrics |

**Example:**
```bash
# Create a product
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Widget","price":9.99,"description":"A great widget"}'

# List products
curl http://localhost:8080/api/products
```

---

## ☸️ Kubernetes Deployment

```bash
# Apply all K8s manifests
kubectl apply -f k8s/deployment.yaml -n production

# Check rollout
kubectl rollout status deployment/cicd-demo-app -n production

# Scale manually
kubectl scale deployment/cicd-demo-app --replicas=5 -n production

# View HPA status
kubectl get hpa -n production
```

---

## 🔐 GitHub Actions Secrets Required

Set these in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |
| `KUBE_CONFIG_STAGING` | base64-encoded kubeconfig for staging cluster |
| `KUBE_CONFIG_PROD` | base64-encoded kubeconfig for production cluster |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook for deploy notifications |

---

## 🔧 Customization

| What to change | Where |
|---|---|
| Docker image name | `pom.xml` → `docker.image.name` property |
| Registry (ECR/GCR etc.) | `.github/workflows/ci-cd.yml` → `REGISTRY` env |
| Coverage threshold | `pom.xml` → JaCoCo `minimum` |
| K8s replica count | `k8s/deployment.yaml` → `replicas` |
| Target hostname | `k8s/deployment.yaml` → Ingress `host` |
| DB connection | K8s Secret + `application-prod.properties` |
