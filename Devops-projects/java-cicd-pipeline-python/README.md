# CI/CD Pipeline for a Java Application (Using Python)

This project shows how to orchestrate a Java CI/CD pipeline with a lightweight Python helper that runs build, test, and packaging commands. The pipeline definition can be used in GitHub Actions or Jenkins, while the Python script keeps build logic centralized and portable.

## ✅ What This Pipeline Covers

- **Checkout & environment setup**
- **Java build and unit tests (Maven)**
- **Artifact packaging (JAR)**
- **Optional Docker image build**
- **Deployment trigger placeholder**

## 🧰 Tools & Requirements

- Java 17+
- Maven 3.8+
- Python 3.10+
- Docker (optional for image build)

## 📦 Python Helper Script

The script below runs Maven build tasks and outputs a build status suitable for CI usage.

```bash
python scripts/build_and_test.py --maven-project /path/to/java-app
```

## 🛠 Example GitHub Actions Workflow

```yaml
name: Java CI/CD (Python Orchestrated)

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: "temurin"
          java-version: "17"

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Build & Test
        run: |
          python Devops-projects/java-cicd-pipeline-python/scripts/build_and_test.py \
            --maven-project ./my-java-app

      - name: Archive JAR
        uses: actions/upload-artifact@v4
        with:
          name: app-jar
          path: my-java-app/target/*.jar
```

## 🧩 Jenkins Pipeline Example

```groovy
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test') {
      steps {
        sh 'python Devops-projects/java-cicd-pipeline-python/scripts/build_and_test.py --maven-project ./my-java-app'
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'my-java-app/target/*.jar', fingerprint: true
      }
    }
  }
}
```

## 📌 Notes

- Replace `./my-java-app` with your Java app path.
- You can extend the script to deploy to AWS, Kubernetes, or an artifact repository.
- Add a Docker build stage if containerization is required.
