#!/bin/bash

# Quick Start Script for Java CI/CD Demo
# This script helps you get started quickly with the project

set -e

echo "🚀 Java CI/CD Demo - Quick Start Script"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Java installation
echo -e "${BLUE}Checking Java installation...${NC}"
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
    echo -e "${GREEN}✓ Java is installed (version: $JAVA_VERSION)${NC}"
    if [ "$JAVA_VERSION" -lt 17 ]; then
        echo -e "${RED}⚠ Warning: Java 17 or higher is recommended${NC}"
    fi
else
    echo -e "${RED}✗ Java is not installed${NC}"
    echo "Please install Java 17 or higher from: https://adoptium.net/"
    exit 1
fi

# Check Maven installation
echo -e "${BLUE}Checking Maven installation...${NC}"
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version | grep "Apache Maven" | awk '{print $3}')
    echo -e "${GREEN}✓ Maven is installed (version: $MVN_VERSION)${NC}"
else
    echo -e "${RED}✗ Maven is not installed${NC}"
    echo "Please install Maven from: https://maven.apache.org/download.cgi"
    exit 1
fi

echo ""
echo -e "${BLUE}Building the project...${NC}"
mvn clean install

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run tests: ${BLUE}mvn test${NC}"
    echo "2. Run application: ${BLUE}java -jar target/java-cicd-demo-1.0.0.jar${NC}"
    echo "3. View coverage: ${BLUE}open target/site/jacoco/index.html${NC}"
    echo "4. Push to GitHub to trigger CI/CD pipeline"
    echo ""
    echo "Happy coding! 🎉"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi
