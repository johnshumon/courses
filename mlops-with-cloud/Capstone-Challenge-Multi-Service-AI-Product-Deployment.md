[Skip to content](https://tahnik.notion.site/Details-Capstone-Challenge-Multi-Service-AI-Product-Deployment-24d3eab6174280a99d19c046883d6eb6#main)

# Details: Capstone Challenge — Multi-Service AI Product Deployment

### Capstone Challenge — Multi-Service AI Product Deployment

Objective:

Demonstrate mastery of end-to-end MLOps & AI engineering by designing, implementing, and deploying a production-grade multi-model AI platform that integrates:

Real-time inference

Batch processing

Multiple ML services (CV, NLP, tabular ML)

Unified observability, security, and cost governance

#### Challenge Brief

You are tasked with building an AI-powered marketplace platform for a fictional client that requires:

Fraud Detection Service (tabular, real-time, Kafka + Feast + MLflow)

Recommendation Service (batch + real-time, candidate generation, ranking models)

Image Moderation Service (YOLO-based object detection, batch + streaming)

NLP Query Understanding Service (BERT or LLM-based intent classification)

#### Requirements

#### Infrastructure & Deployment

All services containerized (Docker multi-stage builds)

Deployed on Kubernetes (EKS or K3s) with Helm

Centralized feature store for shared features

CI/CD pipelines for each service (GitHub Actions + ArgoCD or CodeDeploy)

#### Data Flow & Orchestration

Kafka for real-time ingestion

Airflow/Kubeflow for batch workflows

Schema registry + data contracts across services

#### Observability

Unified Prometheus + Grafana dashboards for all services

Model-level metrics (latency, drift, accuracy)

System-level metrics (CPU, memory, Kafka lag)

Alerts via Slack/SNS

#### Security & Compliance

IAM least privilege for all workloads

Data encryption (S3 + EBS + TLS)

PII handling with anonymization in pipelines

#### Cost Optimization

Auto-scaling policies for inference

Spot instance strategy for training

Cost dashboards in AWS Cost Explorer

Auto-teardown scripts for unused resources

#### Resilience & Self-Healing

Liveness/readiness probes for all services

Retry policies for workflows

Automated rollback on failed deployments

#### Deliverables

Architecture Diagram (service-to-service data flow, cloud resources, security boundaries)

GitHub Repository with:

Infrastructure as Code (Terraform or Pulumi)

Service source code + Dockerfiles

CI/CD pipeline definitions

Monitoring dashboards JSON configs

Deployment Documentation (step-by-step instructions)

Demo Video showcasing:

Services running in production

Real-time and batch inference examples

Observability dashboards with live metrics

#### Evaluation Criteria

Completeness — all services functional and integrated

Performance — inference latency, throughput, scalability

Reliability — fault tolerance, drift detection, automated recovery

Security — IAM, encryption, compliance

Cost Efficiency — scaling strategies, resource usage optimization

Documentation & Clarity — professional, reproducible deployment steps

![📌](<Base64-Image-Removed>)By completing this challenge, learners will:

Prove they can design, deploy, and operate an enterprise-grade AI system

Showcase a portfolio-ready project that uses the full MLOps tech stack from Episodes 1–15

Gain confidence to lead real-world AI infrastructure projects