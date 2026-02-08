# Contributing to Java CI/CD Demo

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Development Workflow

1. **Fork the repository** and clone it locally
2. **Create a feature branch** from `develop`:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following our coding standards
4. **Write tests** for new functionality
5. **Run tests locally** to ensure everything passes:
   ```bash
   mvn clean test
   ```

6. **Commit your changes** with clear, descriptive messages:
   ```bash
   git commit -m "Add feature: description of what you added"
   ```

7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request** to the `develop` branch

## Coding Standards

- Follow Java naming conventions
- Use meaningful variable and method names
- Add JavaDoc comments for public methods
- Keep methods focused and concise
- Write unit tests for all new code
- Maintain code coverage above 80%

## Testing Requirements

- All new features must include unit tests
- Tests should cover happy paths and edge cases
- Run `mvn test` before submitting PR
- Ensure all tests pass in the CI pipeline

## Pull Request Process

1. Update README.md if needed
2. Ensure CI/CD pipeline passes
3. Request review from maintainers
4. Address review feedback
5. Once approved, your PR will be merged

## Code Review Checklist

- [ ] Code follows project conventions
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No merge conflicts
- [ ] CI/CD pipeline is green

## Questions?

Feel free to open an issue for any questions or concerns!
