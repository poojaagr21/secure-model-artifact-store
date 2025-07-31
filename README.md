Data scientists can upload and retrieve models via AWS Lambda and (optionally) API Gateway, while compliance teams have read-only access with full audit logging via AWS CloudTrail.

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
	•	Infrastructure template for model governance in production ML system



 Project Flow Explanation

1. User Access & Authentication

Data Science and Compliance team members attempt to access the service (via web portal or API).
Users are authenticated using AWS IAM roles or AWS Cognito (for web/mobile access).
Authorization ensures users have appropriate permissions based on their team and role.
2. Model Artifact Operations

Upload Artifact:
A user (typically from the Data Science team) uploads a model artifact (e.g., a trained ML model file).
The request goes through an API Gateway (REST or GraphQL endpoint).
API Gateway triggers serverless backend logic (via AWS Lambda or containerized service).
Retrieve Artifact:
A user (Data Science or Compliance) requests to download/view an artifact.
The request again passes through API Gateway and backend logic for validation and processing.
3. Secure Storage

Artifacts are stored in Amazon S3 buckets with:
Encryption at rest (SSE-S3 or SSE-KMS).
Bucket policies to enforce least-privilege access.
Versioning (optional) for auditability and rollback.
4. Access Control & Auditing

Every upload, download, or access attempt is logged:
AWS CloudTrail records API activity.
S3 Access Logs record object-level operations.
Compliance team can review logs for audit and governance.
5. Monitoring & Alerts

Amazon CloudWatch monitors service health, usage patterns, and abnormal activities.
Alerts can be set up for unauthorized access attempts or failures.
6. Data Delivery

After successful authorization and logging, the requested artifact is delivered (downloaded or made available through a presigned URL).
Data Science and Compliance teams can use the service securely, knowing all access is tracked.
