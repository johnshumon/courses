[Skip to content](https://tahnik.notion.site/Episode-01-MLOps-Cloud-Foundations-24d3eab617428042bcaffba7fb451cb3#main)

# Episode 01 — MLOps & Cloud Foundations

![💡 Callout icon](<Base64-Image-Removed>)

This episode sets up the learner’s complete MLOps toolbox — both conceptual and practical — before starting the first project (Fraud Detection). The goal is to have AWS, MLOps core tools, and workflow basics ready so they can be applied immediately in Project 1.

(Runs in parallel with Episode 02: AWS Cloud Infrastructure for ML)

This episode introduces essential MLOps tooling so learners have their “toolbox” ready before tackling larger projects. All tools will be deployed on AWS as they learn AWS infra in Episode 2.

#### Module 1 — Experiment Tracking & Model Metadata Management (MLflow)

MLflow components: tracking, registry, models, projects

Deploy MLflow on AWS EC2 with RDS (Postgres) and S3 artifact storage

Authentication and TLS setup with Nginx reverse proxy

Logging metrics, parameters, and artifacts

Integrating MLflow with scikit-learn, PyTorch, TensorFlow

#### Module 2 — Data & Pipeline Versioning (DVC, git-lfs)

Versioning datasets alongside code

Using DVC with S3 remote storage

Git LFS for large file handling

Data lineage and reproducibility with DVC

Integrating DVC with MLFlow

#### Module 3 — Feature Stores & Databases (Feast, Redis, Postgres)

Feature store fundamentals: entities, feature views, materialization

Deploy Feast with S3 offline store and Redis online store on AWS

Freshness metrics and monitoring feature health

Online/offline feature consistenfcy

#### Module 4 — API Development with FastAPI for Model Serving

Designing inference APIs for ML models

Loading and serving MLflow-registered models in FastAPI

Securing endpoints with API keys and rate limiting

Instrumentation with Prometheus metrics endpoints

#### Module 5 — CI/CD for ML Services

GitHub Actions workflows for ML model CI

Docker build & push to AWS ECR

Canary and blue/green deployment strategies overview

Connecting CI/CD with MLflow model promotion

#### Module 6 — Monitoring & Observability for ML Systems

Metrics: infra, application, model

Deploy Prometheus & Grafana on AWS EC2

Dashboarding model accuracy, latency, drift indicators

Alerting with Alertmanager + SNS

![💡](<Base64-Image-Removed>)Goal: By the end of Episode 1, students have all MLOps core tools deployed and integrated on AWS (MLflow, DVC, Feast, FastAPI, Prometheus/Grafana) and ready to use in projects. AWS infra is learned in Episode 2.