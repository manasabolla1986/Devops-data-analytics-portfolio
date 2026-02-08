#FROM eclipse-temurin:17-jdk-alpine AS build
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven wrapper and pom.xml
#COPY .mvn/ .mvn
#COPY mvnw pom.xml ./
COPY pom.xml ./

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/java-cicd-demo-*.jar app.jar

# Create non-root user
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup appuser && \
    chown -R appuser:appgroup /app

USER appuser

# Expose port (adjust as needed)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD java -version || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
