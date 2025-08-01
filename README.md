Project Overview

Data scientists can securely upload and retrieve ML models via AWS Lambda (and optionally API Gateway), while compliance teams have read-only access with full audit logging powered by AWS CloudTrail.

Built with Terraform (Infrastructure as Code) and Python automation, this project demonstrates best practices in cloud security, role-based access control, DevOps automation, and ML platform governance.

⸻

💡 Key Features
	•	🔐 Secure, versioned model storage on Amazon S3
	•	🛡️ Role-based access control using IAM policies and roles
	•	⚙️ Serverless upload/download via AWS Lambda functions
	•	📊 Full traceability with AWS CloudTrail audit logs
	•	🔄 Infrastructure managed and versioned with Terraform
	•	🧑‍💻 Designed for easy use by Data Scientists and Compliance teams

⸻

🚀 Technologies & Concepts
	•	AWS (S3, Lambda, IAM, CloudTrail, API Gateway)
	•	Terraform (IaC)
	•	Python (Lambda automation)
	•	Cloud Security & Access Management
	•	DevOps & Infrastructure Automation
	•	ML Model Lifecycle Management
	•	Compliance & Governance

⸻

📌 Use Cases
	•	Internal ML model registry supporting deployment pipelines
	•	Secure, auditable model storage for regulated or compliance-focused environments
	•	Infrastructure template for ML model governance in production systems

⸻

🛠️ Project Flow
	1.	User Access & Authentication
	•	Users (Data Scientists and Compliance) authenticate via IAM roles or AWS Cognito.
	•	Permissions are enforced based on team roles.
	2.	Model Artifact Operations
	•	Uploads trigger Lambda functions via API Gateway.
	•	Downloads are securely authorized and served, optionally via presigned URLs.
	3.	Secure Storage
	•	Models stored in encrypted, versioned S3 buckets with strict bucket policies.
	4.	Access Control & Auditing
	•	All access logged via CloudTrail and S3 Access Logs.
	•	Compliance team reviews logs for governance.
	5.	Monitoring & Alerts
	•	CloudWatch monitors service health and security events.
	•	Alerts can be configured for suspicious activity.
	6.	Data Delivery
	•	Authorized artifacts delivered securely to users.
secure-model-artifact-store/


secure-model-artifact-store/
│
├── README.md
├── .gitignore
├── requirements.txt
│
├── infra/
│   ├── main.tf              # Root Terraform entry
│   ├── s3.tf                # S3 config with versioning + lifecycle
│   ├── lambda.tf            # Lambda infra config
│   ├── iam.tf               # IAM roles/policies for Lambda & S3
│   ├── cloudwatch.tf        # (Optional) Monitoring and alerts
│   └── cloudtrail/
│       └── main.tf          # CloudTrail audit logging setup
│
├── lambda/
│   ├── upload_model.py
│   ├── download_model.py
│   ├── upload_event.json
│   └── download_event.json
│
└── docs/
    └── architecture.png     # Optional: Add architecture diagram

    Deployment Instructions

1. Deploy Core Infrastructure & CloudTrail Together

CloudTrail is included as a Terraform module inside the infra folder. To deploy all AWS resources (S3 bucket, IAM roles, Lambda roles, CloudTrail, etc.):

cd infra
terraform init
terraform apply

2. Deploy CloudTrail Separately (Optional)

If you want to deploy CloudTrail independently for modular management:
cd ../cloudtrail
terraform init
terraform apply

3. Deploy Lambda Functions

The Lambda function code is in the lambda/ folder:
	•	Package each Lambda function:

 cd lambda
zip upload_model.zip upload_model.py
zip download_model.zip download_model.py

4. Verify & Monitor
	•	CloudTrail logs all AWS API calls in the designated S3 bucket and streams logs to CloudWatch.
	•	we can Use CloudWatch dashboards and alarms for monitoring Lambda and S3 usage.
	•	Compliance teams can audit access through CloudTrail logs.



✅ Operational Enhancements
	•	Monitoring & Alerting (CloudWatch + CloudTrail)
Integrated AWS CloudWatch to monitor Lambda execution metrics and trigger alarms on failures.
Enabled CloudTrail to audit AWS API activity for security and compliance, helping detect unauthorized access or suspicious behavior.
	•	Scaling, Backup & Disaster Recovery
	•	Configured Lambda auto-scaling using concurrency settings to handle varying workloads without service degradation.
	•	Enabled S3 versioning and lifecycle rules to support automated backups and disaster recovery, reducing the risk of data loss.

