[Skip to content](https://tahnik.notion.site/Episode-11-Anomaly-Detection-in-Production-24d3eab617428083b27ff2d26a147ae5#main)

# Episode 11 — Anomaly Detection in Production

Guide learners through building a production-grade real-time anomaly detection system for streaming and time-series data using AWS EC2, Kafka, Feast, MLflow, Prometheus, and Grafana — covering ingestion, feature pipelines, model serving, monitoring, and continual learning.

#### Module 1: Project Scaffolding, Environment Setup & Cost Guardrails

Repository structure for streaming anomaly detection (

infra/

,

services/

,

features/

,

mlops/

)

Pre-commit hooks, linting, testing (

ruff

,

black

,

pytest

)

AWS CLI profiles, SSM Parameter Store for secrets

AWS Budgets and SNS alerts for infra spend

Automated teardown scripts for all AWS resources

#### Module 2: Streaming Infrastructure with Kafka on AWS EC2

Deploy 3-broker Kafka cluster with schema registry

Configure replication factor, ISR, and retention for time-series workloads

Topics:

raw\_events

,

anomaly\_scores

,

alerts

,

dead\_letters

Enable Kafka JMX exporter for monitoring

Schema evolution and backward compatibility testing

#### Module 3: Raw Event Storage & Historical Store

Stream ingestion from Kafka to S3 in partitioned Parquet format (for batch retraining)

MongoDB or PostgreSQL for low-latency lookup of recent events

Kafka Connect S3/Mongo/Postgres sinks

TTL indexes for storage cost optimization

Data freshness verification pipelines

#### Module 4: Experiment Tracking & Model Registry with MLflow

Deploy MLflow on EC2 with RDS + S3 backend

Secure with TLS + Nginx reverse proxy

Log anomaly detection experiments (Isolation Forest, Autoencoders, LSTM, etc.)

Version models in MLflow Model Registry

Expose metrics from MLflow to Prometheus

#### Module 5: Baseline Model Training & Evaluation

Use simulated IoT/financial/log data for anomalies

Handle extreme class imbalance

Evaluate with precision-recall curves, F1@fixed recall, anomaly score distributions

Log parameters, metrics, and artifacts to MLflow

Store train/test splits in DVC for reproducibility

#### Module 6: Feature Store with Feast

Define entities (device\_id, account\_id) and anomaly-relevant features

Use S3 for offline store, Redis for online store

Materialize real-time features for streaming scoring

Monitor feature hit/miss ratio with Prometheus

#### Module 7: Real-Time Feature Aggregation

Compute rolling statistics (mean, std dev, min/max) over multiple windows (5 min, 1 hr, 24 hr)

Implement aggregations using Kafka Streams / Faust

Backfill missing features from historical store

Ensure consistency between batch and streaming pipelines

#### Module 8: Model Serving — Streaming Anomaly Detection Service

Kafka consumer fetches features from Feast

Scores events using deployed MLflow model

Publishes anomaly scores to Kafka + writes to S3 for audit

Dead-letter handling for invalid events

Maintain p95 latency < 200ms

#### Module 9: Alerting API with FastAPI

Expose REST API for on-demand anomaly checks

Endpoint for batch investigation

API key auth + rate limiting

Prometheus metrics for API health & anomaly counts

#### Module 10: Containerization & Deployment

Containerize services with Docker

Optimize images for low cold-start latency

Push to ECR with vulnerability scans

Deploy on EC2 Auto Scaling Group or EKS

Load balancing via ALB/NLB

#### Module 11: CI/CD for Anomaly Detection

GitHub Actions workflows for test → build → deploy

Canary deploys with AWS CodeDeploy

Automated rollback on regression in latency or alert volume

#### Module 12: Monitoring & Observability

Prometheus to scrape metrics from all services

Grafana dashboards for:

Anomaly detection rate

Consumer lag

Feature freshness

Model scoring latency

Alertmanager rules for anomaly spikes & system failures

#### Module 13: Load Testing & Latency Optimization

Simulate high event throughput with Locust/k6

Identify bottlenecks in feature lookup, scoring, and Kafka consumers

Optimize workers, concurrency, and batch processing

#### Module 14: Continual Learning & Drift Detection

Use Evidently AI for detecting concept drift & data drift

Retrain model automatically on confirmed drifts

Validate retrained model before promotion to production

![📌](<Base64-Image-Removed>)This episode reuses and extends skills from:

AWS infra (Episode 2)

Docker (Episode 3)

Data engineering (Episode 4)

MLOps tools (Episode 1)