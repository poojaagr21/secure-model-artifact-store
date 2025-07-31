Secure Model Artifact Store is a cloud-native solution built on AWS to securely store, version, and retrieve machine learning model artifacts, designed for both data science and compliance teams.

The system uses Amazon S3 with encryption at rest, bucket versioning, and fine-grained IAM access controls to ensure models are safely stored and only accessible to authorized roles. Data scientists can upload and retrieve models via AWS Lambda and (optionally) API Gateway, while compliance teams have read-only access with full audit logging via AWS CloudTrail.

Built using Terraform for infrastructure-as-code and Python for Lambda automation, this project demonstrates best practices in cloud security, role-based access, DevOps, and ML platform design.

💡 Key Features
	•	🔐 Secure, versioned model storage using Amazon S3
	•	🛡️ Access control with IAM roles and policies
	•	⚙️ Upload/download via serverless Lambda functions
	•	📊 Full traceability using CloudTrail logs
	•	🔄 Infrastructure managed via Terraform
	•	🧑‍💻 Designed for data scientists and compliance teams

🚀 Technologies & Concepts
	•	AWS (S3, Lambda, IAM, CloudTrail, API Gateway)
	•	Terraform (IaC)
	•	Python (Automation)
	•	Cloud Security & Access Management
	•	DevOps & Infrastructure Automation
	•	ML Model Lifecycle Management
	•	Compliance & Governance

📌 Use Cases
	•	Internal ML model registry for deployment pipelines
	•	Secure, auditable ML storage for regulated environments
	•	Infrastructure template for model governance in production ML systems
