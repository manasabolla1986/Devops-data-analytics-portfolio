# Java CI/CD Demo Project

A sample Java application demonstrating a complete CI/CD pipeline using GitHub Actions.

## 🚀 Features

- **Java 17** - Modern Java development
- **Maven** - Dependency management and build automation
- **JUnit 5** - Unit testing framework
- **JaCoCo** - Code coverage reporting
- **GitHub Actions** - Automated CI/CD pipeline

## 📋 Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Git

## 🛠️ Project Structure

```
java-cicd-demo/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # GitHub Actions CI/CD pipeline
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/example/
│   │           └── Application.java
│   └── test/
│       └── java/
│           └── com/example/
│               └── ApplicationTest.java
├── pom.xml                    # Maven configuration
├── .gitignore
└── README.md
```

## 🔧 Local Development

### Build the project
```bash
mvn clean compile
```

### Run tests
```bash
mvn test
```

### Generate code coverage report
```bash
mvn jacoco:report
```
Coverage report will be available at `target/site/jacoco/index.html`

### Package the application
```bash
mvn package
```

### Run the application
```bash
java -jar target/java-cicd-demo-1.0.0.jar
```

## 🔄 CI/CD Pipeline

The GitHub Actions pipeline includes the following stages:

### 1. **Build and Test**
   - Checkout code
   - Set up JDK 17
   - Build with Maven
   - Run unit tests
   - Generate code coverage report
   - Package application
   - Upload artifacts

### 2. **Code Quality Analysis**
   - Run Maven verify
   - Check code coverage
   - Ensure quality standards

### 3. **Security Scanning**
   - Dependency tree analysis
   - Optional OWASP dependency check

### 4. **Deploy to Staging**
   - Triggered on push to `develop` branch
   - Downloads build artifacts
   - Deploys to staging environment

### 5. **Deploy to Production**
   - Triggered on push to `main` branch
   - Requires manual approval (environment protection)
   - Downloads build artifacts
   - Deploys to production environment
   - Creates release tags

## 🌿 Branch Strategy

- `main` - Production-ready code, triggers production deployment
- `develop` - Development branch, triggers staging deployment
- Feature branches - Create PRs to `develop`

## 📊 Pipeline Triggers

The CI/CD pipeline runs on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual trigger via workflow_dispatch

## 🚀 Getting Started with GitHub Actions

1. **Fork or clone this repository**
2. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/java-cicd-demo.git
   git push -u origin main
   ```

3. **Enable GitHub Actions**
   - Go to your repository on GitHub
   - Click on the "Actions" tab
   - The workflow will run automatically on push

4. **Configure deployment secrets (if needed)**
   - Go to Settings → Secrets and variables → Actions
   - Add required secrets for deployment:
     - `DEPLOY_HOST`
     - `DEPLOY_USER`
     - `DEPLOY_KEY`
     - etc.

5. **Set up environment protection (optional)**
   - Go to Settings → Environments
   - Create `production` environment
   - Add required reviewers for production deployments

## 📈 Viewing Pipeline Results

- Navigate to the "Actions" tab in your GitHub repository
- Click on any workflow run to see detailed logs
- Download artifacts (JAR files, coverage reports) from completed runs

## 🧪 Testing

The project includes sample unit tests demonstrating:
- Basic assertions
- Multiple test cases
- Edge case handling

Run tests locally:
```bash
mvn test
```

View test results:
```bash
open target/surefire-reports/index.html
```

## 📦 Artifacts

The pipeline generates and uploads:
- **Application JAR** - Executable Java application
- **Coverage Reports** - JaCoCo code coverage analysis

## 🔒 Security

- Dependency scanning included
- OWASP Dependency Check available (uncomment in workflow)
- Environment-based deployment protection
- Secrets management via GitHub Secrets

## 🤝 Contributing

1. Create a feature branch from `develop`
2. Make your changes
3. Write/update tests
4. Create a pull request to `develop`
5. Wait for CI checks to pass
6. Request review

## 📝 License

This project is open source and available under the MIT License.

## 🔗 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Maven Documentation](https://maven.apache.org/guides/)
- [JUnit 5 Documentation](https://junit.org/junit5/docs/current/user-guide/)
- [JaCoCo Documentation](https://www.jacoco.org/jacoco/trunk/doc/)

## 📞 Support

For issues and questions, please open an issue in the GitHub repository.
