# ==========================================
# Stage 1: Build with Maven
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# Cache Maven dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build war
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Lightweight, Secure Production JRE
# ==========================================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Run as dedicated unprivileged user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy compiled artifact from build stage
COPY --from=builder /build/target/dptweb-*.war /app/app.war

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

# Health check using Spring Boot Actuator
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.war"]
