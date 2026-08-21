[Skip to content](https://tahnik.notion.site/Episode-14-Time-Series-Prediction-Pipeline-in-Edge-Deployment-24d3eab617428056bf07d1ec395b1a0f#main)

# Episode 14 — Time Series Prediction Pipeline in Edge Deployment

Guide learners through building production-grade time series forecasting pipelines for both batch and streaming predictions, integrating distributed training/inference with Ray, orchestration with Kubeflow Pipelines, and complete monitoring, drift detection, and mobile/edge deployment.

#### Module 1: Project Scaffolding, Environment Setup & Cost Guardrails

Repository layout for time series projects (

infra/

,

data/

,

models/

,

pipelines/

,

services/

)

Poetry or

uv

for dependency management

Pre-commit hooks, linting (

ruff

,

black

), testing (

pytest

)

AWS CLI profile + SSM Parameter Store for credentials

GPU/CPU-aware environment setup for deep learning-based forecasting models

AWS Budgets & cost alerts, teardown automation for EC2/EKS resources

#### Module 2: Time Series Data Engineering & Preprocessing

Ingesting streaming time series data from Kafka and batch data from S3

Resampling, missing value imputation, and time zone normalization

Windowed feature creation (rolling averages, lags, seasonal indicators)

Handling multiple time series (entity-based forecasting)

Versioning datasets with DVC (both raw and transformed datasets)

Distributed preprocessing using Ray Data

#### Module 3: Experiment Tracking & Model Registry with MLflow

Logging parameters, metrics (MAE, RMSE, MAPE), forecast plots

Storing models with metadata (forecast horizon, data frequency)

Registering models for batch vs. streaming use cases

Integrating Ray Tune for distributed hyperparameter optimization

#### Module 4: Baseline & Advanced Forecasting Models

Classical: ARIMA, Prophet, ETS

Deep learning: LSTM, GRU, Temporal Convolutional Networks (TCN), Transformer-based forecasting models (Informer, TFT)

Distributed training with Ray Train across multiple GPUs/CPUs

Mixed precision training for efficiency

#### Module 5: Feature Store for Time Series

Using Feast to store derived features (rolling statistics, seasonal encodings, anomalies)

Redis for online feature store, S3 for offline store

Materialization pipelines for low-latency lookups during inference

#### Module 6: Batch Forecasting Pipeline

Scheduled batch inference jobs with Kubeflow Pipelines

Exporting forecasts to S3, RDS, and BI tools

Automating report generation with AWS Lambda

#### Module 7: Real-Time Forecasting Pipeline

Streaming ingestion with Kafka → real-time feature aggregation → inference endpoint

Handling late-arriving data with watermarking

Ensuring inference SLA (p95 latency < 200ms)

#### Module 8: Deployment Infrastructure

Containerizing forecasting services with Docker (CPU & GPU variants)

Multi-model serving with Ray Serve

Deploying to AWS EKS with GPU autoscaling

Canary deployments for new forecasting models

#### Module 9: API Development & Edge/Mobile Deployment

FastAPI service exposing endpoints for:

Single entity forecast

Multi-entity batch forecast

Model metadata retrieval

Exporting lightweight models (ONNX, TensorRT) for mobile & edge

Deploying to Android app for on-device inference (TFLite, PyTorch Mobile)

#### Module 10: CI/CD for Time Series Models

GitHub Actions workflows for pipeline testing, model validation, and automated deployment

Model evaluation gates (accuracy thresholds, latency limits)

Rollback workflows for performance regressions

#### Module 11: Monitoring & Observability

Prometheus + Grafana dashboards for:

Forecast accuracy over time

Latency of streaming/batch predictions

Drift in seasonal patterns

Alertmanager rules for:

Drop in accuracy

Increased forecast error variance

#### Module 12: Drift Detection & Continual Learning

Using Evidently AI for detecting concept drift (seasonality changes, trends)

Triggering retraining workflows via Kubeflow Pipelines on drift detection

Automating data ingestion for retraining sets

![📌](<Base64-Image-Removed>)This episode ties together:

Ray for distributed time series model training & serving

Kubernetes + GPU scaling for large forecasting workloads

Feast for time series feature management

Mobile/edge deployment patterns for real-world consumption