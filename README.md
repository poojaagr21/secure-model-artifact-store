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


│
├── README.md                      # Project overview and setup guide
├── .gitignore                    # Ignore files (e.g., .zip, __pycache__)
├── requirements.txt              # Python dependencies for Lambda 
│
├── infra/                       # Core Terraform configurations
│   └── main.tf                  # S3, IAM policies, Lambda roles, etc.
│
├── cloudtrail/                  # Separate Terraform for CloudTrail audit logging
│   └── main.tf                  # CloudTrail setup: logs bucket, IAM role, CloudWatch integration
│
├── lambda/                      # Lambda source code and configs
│   ├── upload_model.py          # Upload model function
│   ├── upload_model.json        # Upload Lambda deployment/config JSON
│   ├── download_model.py        # Download model function
│   ├── download_model.json      # Download Lambda deployment/config JSON
│
└── docs/                        # Optional documentation and diagrams
    └── architecture.png         # Architecture overview diagram


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




NEXT STEPS:

 to deploy the Terraform infrastructure (S3 buckets, IAM roles, CloudTrail, Lambda functions).
	•	set up and maintain monitoring and alerting using CloudWatch and CloudTrail to detect issues like failures or unauthorized access.
	•	manage scaling, backups, and disaster recovery for the S3 storage and Lambda services.
	
