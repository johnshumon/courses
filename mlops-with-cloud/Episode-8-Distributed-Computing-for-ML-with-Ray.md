[Skip to content](https://tahnik.notion.site/Episode-8-Distributed-Computing-for-ML-with-Ray-24d3eab617428062b5d6fd77ff02058f#main)

# Episode 8 — Distributed Computing for ML with Ray

> Goal: Learn how to scale ML training, hyperparameter tuning, reinforcement learning, and serving using Ray in both local and Kubernetes environments.
>
> End Result: Students will be able to design distributed ML pipelines with Ray, run large-scale experiments, and serve high-throughput model inference.

#### Module 7.1 — Introduction to Ray for MLOps

Why Ray? Scaling beyond single-node training.

Ray architecture: head node, worker nodes, object store.

Ray vs Spark for ML workloads.

Ray ecosystem: Ray Core, Ray Data, Ray Train, Ray Tune, Ray Serve, RLlib.

Lab: Install Ray locally and run a distributed "Hello World" example.

#### Module 7.2 — Running Ray on Cloud & on Kubernetes

Setting up Ray on AWS with multiple workers.

Deploying Ray cluster on Kubernetes (Helm chart).

Connecting Ray cluster to AWS S3 and other cloud storage.

Scaling up/down Ray workers dynamically.

Lab: Deploy a Ray cluster on EKS and verify distributed task execution.

#### Module 7.3 — Distributed Data Processing with Ray Data

Reading/writing large datasets in parallel.

Preprocessing pipelines for ML (feature engineering at scale).

Integrating Ray Data with Feature Stores (Feast, Redis).

Streaming vs batch data ingestion.

Lab: Ingest and preprocess 10M+ records using Ray Data on Kubernetes.

#### Module 7.4 — Distributed Training with Ray Train

Training ML/DL models across multiple GPUs/nodes.

Distributed PyTorch & TensorFlow training with Ray.

Fault tolerance & checkpointing.

Using Spot Instances with Ray.

Lab: Train a ResNet model with distributed PyTorch using Ray Train.

#### Module 7.5 — Hyperparameter Tuning with Ray Tune

Defining search spaces and schedulers (ASHA, PBT, HyperBand).

Integrating with MLflow for experiment tracking.

Distributed tuning on heterogeneous hardware.

Early stopping strategies for cost savings.

Lab: Run distributed hyperparameter search on AWS EKS with Ray Tune + MLflow.

#### Module 7.6 — Serving Models with Ray Serve

Serving multiple models on a single Ray cluster.

Scaling inference endpoints dynamically.

Deploying ensemble models.

Integrating Ray Serve with FastAPI and Kubernetes ingress.

Lab: Deploy a Ray Serve model endpoint behind NGINX Ingress on EKS.

#### Module 7.7 — Ray for Reinforcement Learning

Intro to RLlib for distributed reinforcement learning.

Multi-agent RL workflows.

Logging RL experiments with MLflow.

Lab: Train a CartPole RL agent using Ray RLlib on Kubernetes.

#### Module 7.8 — Monitoring & Debugging Ray Workloads

Ray Dashboard for cluster observability.

Integrating Ray metrics into Prometheus/Grafana.

Profiling distributed ML workloads.

Debugging failed Ray tasks.

Lab: Create a Grafana dashboard tracking Ray cluster health and ML workload performance.

#### Module 7.9 — CI/CD for Ray Pipelines

Automating Ray pipeline deployments to Kubernetes.

Canary deployment for distributed inference.

Rollbacks & scaling policies.

Lab: Deploy an updated Ray Serve model to EKS using GitHub Actions.

![🎯](<Base64-Image-Removed>) Outcome of Episode 07:

By the end, student will be able to scale ML pipelines across many nodes, perform massive hyperparameter sweeps, and deploy high-throughput inference services using Ray in production.

If we follow the natural progression, Episode 08 should be Kubeflow Pipelines for End-to-End Orchestration on Kubernetes — where Ray, MLflow, Feast, and monitoring all come together in orchestrated workflows.