Project Overview

Problem Statement:
In cloud-based ML systems, managing machine learning model deployment manually can lead to:
- Security risks due to improper access control
- Downtime caused by single-instance failures
- Poor performance during traffic spikes
- Limited visibility into system health
- Slow and error-prone operational processes

This project addresses these challenges by building a cloud infrastructure that is **secure by design**, **highly available**, and **automated**.

Key Objectives:
- Secure storage and controlled access to ML model artifacts
- Highly available and scalable model-serving infrastructure
- Automated provisioning using Infrastructure as Code
- Continuous monitoring and alerting for system health
- Fault tolerance and self-healing capabilities

Architecture Overview
The system consists of the following components:

Compute Layer
  - EC2 instances or containerized services for model serving
  - Auto Scaling Groups to handle traffic variations

Storage Layer
  - S3 bucket for storing ML model artifacts
  - Versioning enabled for model rollback and recovery

Security
  - IAM roles with least-privilege access
  - Secure access between services without hard-coded credentials

Networking
  - VPC with public and private subnets
  - Security Groups controlling inbound and outbound traffic

Monitoring and Observability
  - CloudWatch metrics for CPU, memory, and request latency
  - Alarms for threshold breaches
  - Logs for troubleshooting and incident analysis

Automation
  - Infrastructure provisioning using Terraform
  - Automated backup and recovery 

Reliability and SRE Practices
This project follows core SRE principles:

Scalability
  - Automatic scaling based on traffic and resource usage
High Availability
  - Multi-instance deployment with health checks
Observability
  - Metrics, logs, and alerts to detect issues early
Automation*
  - Reduced manual intervention using Infrastructure as Code and scripts
Security
  - Least-privilege IAM policies and secure storage practices

Optional Enhancements
The architecture is designed to support future enhancements such as:
- Predictive scaling and anomaly detection using GenAI
- Agent-based automated remediation for common failure scenarios
- CI/CD pipelines for automated model

Outcome
This project demonstrates how cloud infrastructure for ML workloads can be operated reliably at scale using SRE best practices. It reflects real-world responsibilities of a Cloud SRE, including infrastructure automation, monitoring, security enforcement, and incident 

Technologies Used
- AWS (EC2, S3, IAM, CloudWatch, Auto Scaling, VPC)
- Terraform
- Linux
- Bash / Python scripting
- Monitoring and alerting tools
