[Skip to content](https://tahnik.notion.site/Episode-06-Kubernetes-for-MLOps-Poridhi-k8s-Cluster-EKS-24d3eab617428007bd8ec25e6be866af#main)

# Episode 06 — Kubernetes for MLOps (Poridhi k8s Cluster, EKS)

> Goal: Build strong Kubernetes skills tailored for MLOps workloads. Learn to deploy, scale, monitor, and secure ML services in Kubernetes, both locally with K3s and on the cloud with AWS EKS.
>
> End Result: You’ll be able to run containerized ML workloads on Kubernetes, integrate with storage, scale GPU/CPU workloads, manage secrets/configs, and connect Kubernetes to MLOps tools like MLflow, Feast, and Ray.

#### Module 6.1 — Kubernetes Fundamentals for MLOps

Why Kubernetes is essential for modern ML pipelines.

Kubernetes architecture: API server, scheduler, controller manager, kubelet, etcd.

Pods, ReplicaSets, Deployments, Services, and Ingress.

Kubernetes vs Docker Compose for ML workloads.

Local development with K3s.

Lab: Deploy a basic FastAPI ML service to K3s with a LoadBalancer service.

#### Module 6.2 — Setting Up Kubernetes Environments (K3s & AWS EKS)

Installing K3s locally with Helm support.

Creating an EKS cluster with Terraform (IaC approach).

Understanding EKS networking (VPC, CNI, security groups, IAM roles).

kubectl configuration & context switching between clusters.

Lab: Deploy a sample ML API on both K3s and EKS, verify load balancing.

#### Module 6.3 — Kubernetes Resource Management for ML

CPU, GPU, and memory requests & limits.

GPU scheduling in Kubernetes (NVIDIA device plugin).

Node affinity, taints, and tolerations for ML workloads.

Autoscaling: HPA (Horizontal Pod Autoscaler) & VPA (Vertical Pod Autoscaler).

Lab: Deploy a GPU-based inference service with autoscaling.

#### Module 6.4 — Storage & Data in Kubernetes

Persistent Volumes (PV) and Persistent Volume Claims (PVC) for ML.

Mounting S3 buckets to pods (S3 CSI driver).

Connecting PVCs to ML training jobs.

Managing feature store data in Feast with Kubernetes storage.

Lab: Run an ML pipeline that reads/writes datasets from PVC/S3 inside Kubernetes.

#### Module 6.5 — Networking & Service Exposure

ClusterIP, NodePort, LoadBalancer, and Ingress for ML services.

NGINX ingress controller setup.

Securing ML endpoints with TLS and authentication.

Internal vs public-facing ML APIs.

Lab: Deploy MLflow tracking server behind an NGINX ingress with TLS.

#### Module 6.6 — Configurations, Secrets, and Environment Management

ConfigMaps for environment-specific configs.

Secrets management with Kubernetes Secrets and AWS Secrets Manager.

Rolling updates with zero downtime for ML models.

Versioning model configurations.

Lab: Deploy a versioned ML model service that loads configs from a ConfigMap.

#### Module 6.7 — Observability for ML Workloads in Kubernetes

Integrating Prometheus & Grafana with Kubernetes metrics.

Collecting ML-specific metrics from pods (latency, throughput, drift).

Logging with Loki or EFK stack.

Lab: Create a Grafana dashboard for an ML inference service deployed on EKS.

#### Module 6.8 — CI/CD for Kubernetes MLOps

GitHub Actions → EKS deploy pipeline.

Canary and Blue/Green deployments for ML models.

Rollbacks on performance degradation.

Lab: Build a CI/CD pipeline that deploys a new model version to EKS and rolls back on SLO violation.

![🎯](<Base64-Image-Removed>) Outcome of Episode 06:

By the end, you’ll have deployed multiple ML services to both K3s and AWS EKS, integrated storage, implemented autoscaling, secured services, and built monitoring dashboards — all in a production-ready way for MLOps pipelines.