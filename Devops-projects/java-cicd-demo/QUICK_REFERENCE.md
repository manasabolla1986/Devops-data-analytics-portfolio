# CI/CD Pipeline Quick Reference

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         TRIGGER EVENTS                          │
│  • Push to main/develop    • Pull Request    • Manual Trigger  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │  BUILD & TEST   │
                    │  ┌────────────┐ │
                    │  │ Checkout   │ │
                    │  │ Setup JDK  │ │
                    │  │ Compile    │ │
                    │  │ Run Tests  │ │
                    │  │ Coverage   │ │
                    │  │ Package    │ │
                    │  └────────────┘ │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
    ┌───────▼────────┐ ┌────▼──────┐ ┌──────▼────────┐
    │ CODE QUALITY   │ │ SECURITY  │ │   ARTIFACTS   │
    │ ┌────────────┐ │ │ SCANNING  │ │ ┌───────────┐ │
    │ │ Verify     │ │ │ ┌────────┐│ │ │ JAR file  │ │
    │ │ Coverage   │ │ │ │ Deps   ││ │ │ Coverage  │ │
    │ └────────────┘ │ │ │ OWASP  ││ │ └───────────┘ │
    └────────────────┘ │ └────────┘│ └───────────────┘
                       └───────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
    ┌───────▼────────┐      │      ┌─────────▼─────────┐
    │   STAGING      │      │      │   PRODUCTION      │
    │  (develop)     │      │      │     (main)        │
    │ ┌────────────┐ │      │      │  ┌─────────────┐  │
    │ │ Deploy     │ │      │      │  │ Approval    │  │
    │ │ Test       │ │      │      │  │ Deploy      │  │
    │ └────────────┘ │      │      │  │ Tag Release │  │
    └────────────────┘      │      │  └─────────────┘  │
                            │      └───────────────────┘
                            │
                    ┌───────▼────────┐
                    │ NOTIFICATIONS  │
                    │   & REPORTS    │
                    └────────────────┘
```

## Command Cheat Sheet

### Local Development
```bash
# Build project
mvn clean compile

# Run tests
mvn test

# Run tests with coverage
mvn clean test jacoco:report

# Package application
mvn package

# Run application
java -jar target/java-cicd-demo-1.0.0.jar

# Skip tests during package
mvn package -DskipTests

# Clean and rebuild
mvn clean install
```

### Git Workflow
```bash
# Create feature branch
git checkout develop
git checkout -b feature/my-feature

# Commit changes
git add .
git commit -m "Description of changes"

# Push to remote
git push -u origin feature/my-feature

# Update from develop
git checkout develop
git pull
git checkout feature/my-feature
git merge develop

# Merge to develop
git checkout develop
git merge feature/my-feature
git push
```

### Docker Commands
```bash
# Build image
docker build -t java-cicd-demo:latest .

# Run container
docker run -p 8080:8080 java-cicd-demo:latest

# Using docker-compose
docker-compose up -d
docker-compose down
docker-compose logs -f

# Clean up
docker system prune -a
```

### Pipeline Status Checks

| Job | Purpose | Triggers On |
|-----|---------|------------|
| Build and Test | Compile code, run tests, generate coverage | All pushes & PRs |
| Code Quality | Verify code standards, check coverage | All pushes & PRs |
| Security Scan | Dependency checking, vulnerability scan | All pushes & PRs |
| Deploy Staging | Deploy to test environment | Push to `develop` |
| Deploy Production | Deploy to live environment | Push to `main` |

### Pipeline Files

| File | Purpose |
|------|---------|
| `.github/workflows/ci-cd.yml` | Main CI/CD pipeline |
| `.github/workflows/docker.yml` | Docker build and push |
| `pom.xml` | Maven configuration |
| `Dockerfile` | Container image definition |
| `docker-compose.yml` | Local container orchestration |

### Environment Variables

```bash
# Java options
JAVA_OPTS="-Xmx512m -Xms256m"

# Application settings
SERVER_PORT=8080
ENVIRONMENT=production

# Logging
LOG_LEVEL=INFO
```

### GitHub Actions Secrets

Required secrets for deployment:

**SSH Deployment:**
- `SSH_PRIVATE_KEY`
- `DEPLOY_HOST`
- `DEPLOY_USER`

**AWS:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

**Docker Hub:**
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Tests fail locally | Run `mvn clean test` and check logs |
| Build fails in CI | Check Java version matches (17) |
| Deployment fails | Verify secrets are configured |
| Coverage too low | Write more tests, target >80% |
| Docker build fails | Check Dockerfile syntax |

### Coverage Reports

View after running tests:
```bash
# Open coverage report
open target/site/jacoco/index.html

# Or manually navigate to:
target/site/jacoco/index.html
```

### Useful Links

- Pipeline Runs: `https://github.com/YOUR_USERNAME/java-cicd-demo/actions`
- Test Reports: In build artifacts
- Coverage: Download from workflow artifacts
- Issues: `https://github.com/YOUR_USERNAME/java-cicd-demo/issues`

## Quick Start Checklist

- [ ] Clone repository
- [ ] Install Java 17+
- [ ] Install Maven 3.6+
- [ ] Run `./quickstart.sh`
- [ ] Create feature branch
- [ ] Make changes
- [ ] Run tests locally
- [ ] Commit and push
- [ ] Create pull request
- [ ] Wait for CI checks
- [ ] Merge when green

## Best Practices

1. **Always** run tests locally before pushing
2. **Never** commit to `main` directly
3. **Use** feature branches for all changes
4. **Write** tests for new features
5. **Review** CI logs when builds fail
6. **Keep** commits small and focused
7. **Update** documentation when needed

---

*For detailed information, see README.md and GITHUB_SETUP.md*
