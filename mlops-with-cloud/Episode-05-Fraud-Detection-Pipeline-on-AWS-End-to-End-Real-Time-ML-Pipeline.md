[Skip to content](https://tahnik.notion.site/Episode-5-Fraud-Detection-Pipeline-on-AWS-End-to-End-Real-Time-ML-Pipeline-24d3eab61742804aa4bfd8085f9f6333#main)

# Episode 5 — Fraud Detection Pipeline on AWS (End-to-End Real-Time ML Pipeline)

Objective:

Guide learners through building a production-grade fraud detection system using AWS EC2, Kafka, Feast, MLflow, Prometheus, and Grafana — covering the full lifecycle from data ingestion to real-time inference, monitoring, and continual learning.

#### Module 1: Project Scaffolding, Environment Setup & Cost Guardrails

Structuring the repository for an MLOps project (

infra/

,

services/

,

features/

,

mlops/

)

Setting up pre-commit hooks, linting, and tests (

ruff

,

black

,

pytest

)

AWS CLI profiles, SSM Parameter Store for secrets

AWS Budgets and cost alerts for student environments

Writing teardown scripts for resource cleanup

#### Module 2: Streaming Infrastructure with Kafka on AWS EC2

Deploying a 3-broker Kafka cluster on EC2 with schema registry

Setting replication factor and ISR settings for fault tolerance

Creating topics for transactions, scores, and dead letters

Adding Kafka exporters for monitoring

Schema evolution and compatibility tests

#### Module 3: Raw Event Storage (S3 + MongoDB)

Streaming data ingestion from Kafka to S3 in partitioned Parquet format

Setting up MongoDB replica set for low-latency recent lookups

Configuring Kafka Connect S3 and Mongo sinks

TTL indexes in Mongo for cost control

Verifying data freshness and schema compliance

#### Module 4: Experiment Tracking & Model Registry with MLflow

Deploying MLflow on EC2 with RDS (PostgreSQL) backend and S3 artifact store

Enabling TLS and authentication via Nginx reverse proxy

Logging metrics, parameters, and artifacts from experiments

Registering and versioning models in the MLflow Model Registry

Integrating Prometheus metrics from MLflow

#### Module 5: Baseline Model Training & Logging

Loading IEEE-CIS fraud dataset from S3

Performing time-based train-test splits to avoid leakage

Handling class imbalance (class weights, resampling)

Evaluating with PR-AUC, ROC-AUC, calibration curves

Logging all runs to MLflow with reproducibility artifacts

#### Module 6: Feature Store with Feast

Defining entities, features, and TTL policies

Using S3 for offline storage, Redis for online storage

Materializing features and performing online lookups

Integrating feature freshness and hit/miss metrics into Prometheus

#### Module 7: Real-Time Feature Aggregation

Implementing streaming aggregations (e.g., 5-min, 30-min transaction counts) with Kafka Streams or Faust

Backfilling features for historical data

Ensuring idempotency and correctness in streaming updates

#### Module 8: Model Serving — Streaming Scoring Service

Building a Kafka consumer service to:

Fetch features from Feast

Score using MLflow model

Publish scores to Kafka and S3

Handle failed events with a dead-letter topic

Performance tuning for p95 latency under 150ms

#### Module 9: Ad-hoc Prediction API with FastAPI

Implementing an API for investigation teams

Single and batch prediction endpoints

API key authentication and rate limiting

Exposing Prometheus metrics for API health

#### Module 10: Containerization & Deployment to AWS

Containerizing all services with Docker

Multi-arch builds (ARM/x86) for EC2 Graviton

Pushing to AWS ECR with automated scans

Deploying scoring service and API in an Auto Scaling Group with ALB

#### Module 11: CI/CD for Fraud Detection Services

Building GitHub Actions workflows for building, testing, and deploying services

Canary and blue/green deployments with AWS CodeDeploy

Rollback strategies on latency/accuracy regression

#### Module 12: Monitoring & Observability

Setting up Prometheus on EC2 to scrape exporters from all components

Grafana dashboards for:

Inference latency

Kafka consumer lag

Feature freshness

Model health metrics

Alerting on SLO violations with Alertmanager + SNS/Slack

#### Module 13: Load Testing & Latency Optimization

Running load tests with Locust or k6

Identifying bottlenecks in feature lookup, model scoring, or Kafka

Tuning workers, connection pools, and caching layers

#### Module 14: Continual Learning & Drift Detection

Implementing Evidently AI for concept drift detection

Triggering retraining pipelines on drift events

Automating model evaluation gates before promotion

#### Module 15: Governance, Explainability & Cost Intelligence

Dataset and pipeline versioning with DVC

Feature contract tests to prevent train-serve skew

SHAP values for per-prediction explanations

Tracking cost per 1K predictions and gating deployments if cost regresses

![📌](<Base64-Image-Removed>)This episode ties together:

AWS infra skills (from later AWS episode)

Docker/containerization skills (Episode 3)

Data engineering (Episode 4)

MLOps tools from Episode 1 & 2