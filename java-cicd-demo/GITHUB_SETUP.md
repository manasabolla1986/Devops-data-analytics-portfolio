# GitHub Setup Guide

This guide will help you set up this project in your GitHub repository with the CI/CD pipeline.

## Prerequisites

- GitHub account
- Git installed locally
- Java 17+ and Maven installed

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon in the top right corner
3. Select "New repository"
4. Name it `java-cicd-demo` (or your preferred name)
5. **Do NOT initialize** with README, .gitignore, or license
6. Click "Create repository"

## Step 2: Push Local Project to GitHub

```bash
# Navigate to your project directory
cd java-cicd-demo

# Initialize git repository
git init

# Add all files
git add .

# Commit the files
git commit -m "Initial commit: Java CI/CD project with GitHub Actions"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/java-cicd-demo.git

# Create main branch and push
git branch -M main
git push -u origin main

# Create develop branch
git checkout -b develop
git push -u origin develop
```

## Step 3: Enable GitHub Actions

GitHub Actions should be enabled by default. To verify:

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. You should see the CI/CD workflows listed
4. The pipeline will automatically run on your first push

## Step 4: Configure Branch Protection (Optional but Recommended)

Protect your main and develop branches:

1. Go to Settings → Branches
2. Click "Add rule"
3. For `main` branch:
   - Branch name pattern: `main`
   - ✓ Require a pull request before merging
   - ✓ Require status checks to pass before merging
   - Select: Build and Test, Code Quality Analysis, Security Scanning
   - ✓ Require branches to be up to date before merging
4. Click "Create"
5. Repeat for `develop` branch

## Step 5: Set Up Deployment Secrets (If Needed)

For actual deployments, add secrets:

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add required secrets:

### For SSH Deployment
```
Name: SSH_PRIVATE_KEY
Value: [Your SSH private key]

Name: DEPLOY_HOST
Value: your-server.com

Name: DEPLOY_USER
Value: deployer
```

### For AWS Deployment
```
Name: AWS_ACCESS_KEY_ID
Value: [Your AWS access key]

Name: AWS_SECRET_ACCESS_KEY
Value: [Your AWS secret key]

Name: AWS_REGION
Value: us-east-1
```

### For Docker Hub
```
Name: DOCKERHUB_USERNAME
Value: your-username

Name: DOCKERHUB_TOKEN
Value: [Your access token]
```

## Step 6: Configure Environments (Optional)

Set up deployment environments with protection:

1. Go to Settings → Environments
2. Click "New environment"
3. Name it `production`
4. Configure protection rules:
   - ✓ Required reviewers: Add team members
   - ✓ Wait timer: 0 minutes (or set a delay)
5. Add environment secrets if needed
6. Click "Save protection rules"

## Step 7: Test the Pipeline

1. Make a small change to README.md
2. Commit and push to `develop`:
   ```bash
   git checkout develop
   git add README.md
   git commit -m "Test CI/CD pipeline"
   git push
   ```
3. Go to Actions tab on GitHub
4. Watch your pipeline run!

## Step 8: Create Your First Pull Request

1. Create a feature branch:
   ```bash
   git checkout develop
   git checkout -b feature/my-first-feature
   ```

2. Make changes and commit:
   ```bash
   git add .
   git commit -m "Add new feature"
   git push -u origin feature/my-first-feature
   ```

3. On GitHub, create a Pull Request from `feature/my-first-feature` to `develop`
4. Watch the CI checks run automatically
5. Once green, merge the PR

## Pipeline Overview

Your pipeline will now run on:

- **Every push** to `main` or `develop`
- **Every pull request** to `main` or `develop`
- **Manual trigger** from Actions tab

### Artifacts Generated

Each successful build produces:
- Compiled JAR file
- Test coverage reports
- Build logs

Download artifacts from the Actions tab after each run.

## Customizing the Pipeline

Edit `.github/workflows/ci-cd.yml` to customize:

- Add more jobs
- Change Java version
- Add integration tests
- Configure deployment targets
- Add notifications (Slack, email, etc.)

## Troubleshooting

### Pipeline Fails on First Run

- Check that `pom.xml` is valid
- Ensure all tests pass locally: `mvn test`
- Check Actions logs for specific errors

### Can't Push to Main

- Branch protection may be enabled
- Create a PR instead of direct push

### Deployment Fails

- Verify secrets are configured correctly
- Check deployment commands in workflow file
- Review deployment logs in Actions tab

## Next Steps

- Add integration tests
- Set up code quality tools (SonarQube, Checkstyle)
- Configure notifications
- Add performance tests
- Implement database migrations
- Set up monitoring and logging

## Support

For issues:
1. Check GitHub Actions documentation
2. Review workflow logs
3. Open an issue in the repository

Happy deploying! 🚀
