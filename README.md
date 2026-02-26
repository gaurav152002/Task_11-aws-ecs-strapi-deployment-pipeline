# 🚀 AWS ECS Blue/Green Deployment Pipeline with GitHub Actions

This project demonstrates a **production-grade CI/CD pipeline** for deploying a Strapi application on AWS using:

- Docker
- Amazon ECR
- Amazon ECS (Fargate)
- Application Load Balancer (ALB)
- AWS CodeDeploy (Blue/Green with Canary strategy)
- Terraform (Modular Infrastructure as Code)
- GitHub Actions (CI/CD Automation)

---

# 🏗 Architecture Overview

The system implements:

- VPC with public and private subnets
- Security groups for ALB, ECS, and RDS
- Application Load Balancer with Blue & Green target groups
- ECS Fargate service
- PostgreSQL RDS database
- CodeDeploy for zero-downtime deployments
- GitHub Actions for CI/CD automation

Deployment strategy used:

Traffic shift flow:

1. Deploy new task set (Green)
2. Route 10% traffic to Green
3. Wait 5 minutes
4. If healthy → shift 100% traffic
5. Terminate old task set (Blue)

Zero downtime.

---


---

# 🔁 CI/CD Workflow

## 1️⃣ Infrastructure Creation (Manual)

File: Triggered manually.

Creates:

- VPC
- Subnets
- Security Groups
- ALB + Target Groups
- RDS PostgreSQL
- ECS Cluster & Service
- CodeDeploy Application & Deployment Group

Uses:
- Terraform
- S3 remote backend

---

## 2️⃣ Deployment Workflow (Automatic on Push)

File:
Triggered on push to `main`.

Steps:

1. Build Docker image
2. Tag image with Git commit SHA
3. Push image to Amazon ECR
4. Fetch existing ECS task definition
5. Register new task definition revision with updated image
6. Trigger CodeDeploy deployment
7. Perform Blue/Green canary deployment

Image tagging example:gaurav-strapi-task:<commit-sha>

Each commit creates a unique immutable container version.

---

## 3️⃣ Destroy Infrastructure (Manual)

File:
Each commit creates a unique immutable container version.

---

## 3️⃣ Destroy Infrastructure (Manual)

File:
Removes:

- ECS
- ALB
- RDS
- VPC
- Security groups
- CodeDeploy

---

# 🔐 GitHub Secrets Required

Repository → Settings → Secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

# 🧠 Deployment Flow

1. Developer pushes code
2. GitHub Actions builds Docker image
3. Image pushed to ECR
4. ECS task definition updated dynamically
5. CodeDeploy creates new task set
6. Canary traffic shifting begins
7. Health checks validated
8. Traffic moves fully to new version
9. Old version terminated

Fully automated.

---

# 🩺 Health Check Configuration

Target group health check:

- Path: `/admin`
- Matcher: `200-399`
- Interval: 30 seconds
- Grace period configured

Ensures stable Strapi startup and prevents premature task failures.

---

# 🛡 Automatic Rollback

Enabled via:
If deployment fails:

- Traffic shifts back to Blue
- Deployment marked failed
- No downtime

---

# 🎯 Key Features Implemented

- Modular Terraform architecture
- Remote state using S3 backend
- Docker commit-based versioning
- Blue/Green deployment with Canary strategy
- Zero downtime deployments
- Automatic rollback
- Infrastructure lifecycle automation
- Production-grade CI/CD pipeline

---

# 🏆 What This Demonstrates

This project showcases:

- Infrastructure as Code (Terraform)
- Containerization (Docker)
- AWS ECS Fargate
- Application Load Balancer routing
- CodeDeploy Blue/Green strategy
- GitHub Actions automation
- Health check tuning & debugging
- Zero-downtime production deployment patterns

---

# 🚀 Future Improvements

- Store secrets in AWS SSM instead of hardcoding
- Add deployment status polling in GitHub
- Add Slack/Teams notifications
- Add staging environment
- Add multi-environment promotion flow


