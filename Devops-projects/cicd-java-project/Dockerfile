# =============================================================
# Multi-Stage Dockerfile for Spring Boot CI/CD Demo App
# =============================================================
# Stage 1: Builder  — compiles & packages the fat JAR
# Stage 2: Extractor — explodes the layered JAR for caching
# Stage 3: Runtime   — minimal distroless image (no shell, no OS)
# =============================================================

# ---- Stage 1: Build ----
FROM eclipse-temurin:17-jdk-alpine AS builder

LABEL maintainer="your-team@example.com"

WORKDIR /workspace

# Copy Maven wrapper and pom first so dependency layer is cached
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (cached unless pom.xml changes)
RUN ./mvnw dependency:go-offline -q

# Copy source and build (skip tests here — tests run earlier in CI)
COPY src src
RUN ./mvnw package -DskipTests -q

# ---- Stage 2: Extract layered JAR ----
FROM eclipse-temurin:17-jdk-alpine AS extractor

WORKDIR /workspace
COPY --from=builder /workspace/target/*.jar app.jar

# Explode the Spring Boot layered JAR
RUN java -Djarmode=layertools -jar app.jar extract

# ---- Stage 3: Runtime ----
FROM eclipse-temurin:17-jre-alpine AS runtime

# Security: run as non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

WORKDIR /app

# Copy layered content (order = least-changed → most-changed for cache efficiency)
COPY --from=extractor /workspace/dependencies/        ./
COPY --from=extractor /workspace/spring-boot-loader/  ./
COPY --from=extractor /workspace/snapshot-dependencies/ ./
COPY --from=extractor /workspace/application/         ./

# Expose application port
EXPOSE 8080

# Health check (Docker/docker-compose level)
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# JVM tuning for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["java", \
    "-XX:+UseContainerSupport", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "org.springframework.boot.loader.launch.JarLauncher"]
