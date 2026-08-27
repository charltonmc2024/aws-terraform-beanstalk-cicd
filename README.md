# AWS Terraform CI/CD Project

## 📌 Project Overview

This project demonstrates an AWS cloud infrastructure and CI/CD pipeline built with Terraform.
The infrastructure is deployed as code and the application is automatically tested, built, containerized, pushed to Amazon ECR, and deployed to an AWS Elastic Beanstalk environment.

The goal of this project is to demonstrate a practical Infrastructure as Code (IaC), containerization, and CI/CD workflow on AWS.

---

## 🏗️ Architecture

![My Architecture Diagram](architecture/aws-terraform-cicd-architecture.png)

---

## 🚀 CI/CD Workflow

The pipeline follows this workflow:

1. Developer pushes code to the `main` branch.
2. GitHub triggers AWS CodePipeline.
3. CodePipeline retrieves the source code.
4. **Test stage** runs validation and Terraform tests.
5. **Build stage** builds the Docker image.
6. The Docker image is pushed to **Amazon ECR**.
7. **Deploy stage** creates an Elastic Beanstalk application version.
8. Elastic Beanstalk deploys the application.
9. The updated application becomes available through the Elastic Beanstalk environment URL.

---





