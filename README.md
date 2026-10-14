# Enterprise AWS 3-Tier Web Application & DevOps Pipeline

[![CI/CD Pipeline](https://github.com/riteshkumar141068-hub/aws-3tier-cloud-architecture/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/riteshkumar141068-hub/aws-3tier-cloud-architecture/actions)
![Java](https://img.shields.io/badge/Java-17%20LTS-orange.svg)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7.18-brightgreen.svg)
![Docker](https://img.shields.io/badge/Docker-Multi--stage-blue.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.8%2B-purple.svg)
![AWS](https://img.shields.io/badge/AWS-3--Tier%20Cloud-yellow.svg)

A modernized, secure, and production-ready implementation of a **3-Tier Web Application deployed on AWS Infrastructure** using Terraform, Docker, and GitHub Actions.

---

## 🏛️ Architecture Overview

```mermaid
flowchart TD
    Client[Client / Web Browser] -->|HTTP:80 / HTTPS:443| ALB[Application Load Balancer]
    
    subgraph VPC["AWS Custom Multi-AZ VPC (192.168.0.0/16)"]
        subgraph PublicSubnets["Public Subnets (Multi-AZ)"]
            ALB
            NAT1[NAT Gateway AZ-1]
            NAT2[NAT Gateway AZ-2]
        end
        
        subgraph PrivateAppSubnets["Private Application Subnets"]
            ASG[Auto Scaling Group (EC2 Instances)]
            AppContainer["Spring Boot Container (Port 8080)"]
            ASG --- AppContainer
        end
        
        subgraph PrivateDBSubnets["Private Database Subnets"]
            RDS[(Amazon RDS MySQL 8.0 - Multi-AZ)]
        end
    end

    ALB -->|Forward Traffic Port 8080| AppContainer
    AppContainer -->|HikariCP Connection Pool Port 3306| RDS
    AppContainer -.->|Metrics & Alarms| CloudWatch[AWS CloudWatch & SNS Alerts]
```

---

## 🚀 Key Improvements & Engineering Upgrades

| Area | Previous State | Modernized Production State |
| :--- | :--- | :--- |
| **Security** | Critical SQL Injection (`' OR 1=1`), Plaintext Passwords | Parameterized `PreparedStatement`, BCrypt Password Hashing, Spring Security |
| **Concurrency** | State stored in singleton `@Controller` instance variables | Completely thread-safe, stateless controllers with HTTP Session |
| **Database Access** | Raw unpooled `DriverManager.getConnection()` per request | Managed **HikariCP** Connection Pooling with automated schema init |
| **Containerization** | None (manual bare-VM Tomcat provisioning) | Multi-stage production `Dockerfile` with non-root user & `docker-compose.yml` |
| **Infrastructure as Code** | Broken security group collision, hardcoded AMI | Clean modular Terraform (AWS Provider 5.x), dynamic AL2023 AMI, gp3 storage |
| **CI/CD & Testing** | Missing automated pipeline, zero test coverage | Automated GitHub Actions CI/CD with unit tests, H2 in-memory mocks & Trivy scanner |
| **Observability** | Incomplete CloudWatch alarms (`alarm_actions = []`) | Spring Boot Actuator (`/actuator/health`) + CloudWatch Alarms wired to SNS |

---

## ⚡ Quickstart: Local Development (1-Command Run)

### Prerequisites
- [Docker Desktop](https://www.docker.com/)

### Step 1: Start Application & Database
From the project root folder, run:

```bash
docker compose up --build
```

Docker will automatically:
1. Build the Spring Boot container using a multi-stage Docker build.
2. Spin up a MySQL 8.0 container.
3. Automatically initialize the database table (`Employee`) on startup.
4. Expose the web application on `http://localhost:8080`.

### Step 2: Access Endpoints
- **Home Page:** [http://localhost:8080/](http://localhost:8080/)
- **Register:** [http://localhost:8080/register](http://localhost:8080/register)
- **Login:** [http://localhost:8080/login](http://localhost:8080/login)
- **Health Check:** [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health)

---

## 🛠️ Testing Locally via Maven

If you have Java 17 and Maven installed:

```bash
cd Java-Login-App

# Run unit tests (uses in-memory H2 database)
mvn clean test

# Build war package
mvn clean package -DskipTests
```

---

## ☁️ Cloud Deployment via Terraform (AWS)

### 1. Configure AWS Credentials
```bash
aws configure
```

### 2. Configure Variables
Create an `infrastructure/terraform.tfvars` file:

```hcl
environment       = "prod"
aws_region        = "us-east-1"
vpc_cidr          = "192.168.0.0/16"
public_subnets    = ["192.168.1.0/24", "192.168.2.0/24"]
private_subnets   = ["192.168.3.0/24", "192.168.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
db_name           = "userdb"
db_username       = "admin"
db_password       = "YourStrongPassword123!"
instance_type     = "t3.micro"
asg_min_size      = 2
asg_max_size      = 4
asg_desired_capacity = 2
```

### 3. Deploy
```bash
cd infrastructure

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 4. Outputs
After deployment completes, Terraform outputs the public ALB URL:
```text
Outputs:
alb_dns_name = "prod-alb-123456789.us-east-1.elb.amazonaws.com"
rds_endpoint = "prod-database.xxxxxx.us-east-1.rds.amazonaws.com:3306"
```

---

## 📁 Repository Directory Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml                # Automated GitHub Actions test, build, scan pipeline
├── docker-compose.yml               # Local orchestration (Spring Boot + MySQL)
├── README.md                        # Project documentation & runbook
├── Java-Login-App/                  # Spring Boot Web Application
│   ├── Dockerfile                   # Multi-stage production container build
│   ├── .dockerignore                # Container build exclusions
│   ├── pom.xml                      # Maven project configuration & dependencies
│   ├── src/main/java/com/dpt/demo/
│   │   ├── config/SecurityConfig.java # Spring Security & BCrypt configuration
│   │   ├── service/UserService.java  # Thread-safe service with parameterized SQL
│   │   ├── HomeController.java      # Route controller for / and /home
│   │   ├── login.java               # Secure login controller
│   │   ├── register.java            # Secure registration controller
│   │   ├── MyWebAppApplication.java # Bootstrap entrypoint
│   │   └── ServletInitializer.java  # WAR container initializer
│   ├── src/main/resources/
│   │   ├── application.properties   # Environment-driven properties & HikariCP
│   │   └── schema.sql               # Database table auto-initialization script
│   └── src/test/java/               # Unit and integration tests
└── infrastructure/                  # Terraform Infrastructure as Code
    ├── main.tf                      # Root Terraform orchestration
    ├── variables.tf                 # Global input variables
    ├── outputs.tf                   # Root deployment outputs (ALB DNS, RDS endpoint)
    └── modules/
        ├── vpc/                     # Multi-AZ VPC, subnets, NAT gateways, flow logs
        ├── security/                # Unified security groups (ALB, App, DB, Bastion)
        ├── alb/                     # Application Load Balancer & HTTP listeners
        ├── asg/                     # Launch template (AL2023) & Auto Scaling Group
        ├── rds/                     # Multi-AZ MySQL RDS instance (gp3 storage)
        └── monitoring/              # CloudWatch metric alarms & SNS alerts
```

---

## 🛡️ License
This project is open-source and licensed under the [MIT License](LICENSE).
