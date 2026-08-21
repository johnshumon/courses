[Skip to content](https://tahnik.notion.site/Episode-4-Data-Engineering-for-MLOps-Kafka-Spark-Batch-Streaming-Pipelines-Data-Quality-24d3eab61742805da74de39b1aafd85a#main)

# Episode 4 — Data Engineering for MLOps (Kafka, Spark, Batch & Streaming Pipelines, Data Quality)

Equip learners with the data ingestion, transformation, quality assurance, and orchestration skills required to feed high-quality, production-ready datasets into ML pipelines — both batch and streaming — using cloud and open-source tooling.

Prerequisites:

Episode 1: MLOps Tooling Foundations (MLflow, DVC, Feast, CI/CD, Monitoring)

Episode 2: AWS Cloud Infrastructure Foundations (S3, RDS, IAM basics)

Episode 3: Docker & Containerization for MLOps

#### Module 1 — Data Engineering Concepts for MLOps

The role of data engineering in production ML systems

Batch vs streaming pipelines in ML use cases

Latency, throughput, and freshness trade-offs

Data schema evolution and governance for ML

Common pitfalls (e.g., train–serve skew, stale features, poor data quality)

#### Module 2 — Event Streaming with Kafka

Kafka architecture for ML: brokers, topics, partitions, replication

Kafka KRaft vs ZooKeeper mode

Designing topics for ML use cases (keying, partitioning, retention)

Installing Kafka (local + AWS EC2)

Producers & consumers in Python (

confluent-kafka

,

aiokafka

)

Kafka Connect for ingestion (S3 sink, JDBC sink)

Schema Registry (Avro/Protobuf/JSON) for ML feature contracts

Metrics & monitoring (lag, ISR, partition skew)

#### Module 3 — Batch Processing with Apache Spark

Spark fundamentals (RDD vs DataFrame API)

Reading from S3, JDBC, and Kafka

Transformations for ML (feature engineering in Spark)

Writing partitioned Parquet to S3 for offline ML training

Spark on AWS EMR vs standalone cluster on EC2

Optimization techniques (partitioning, bucketing, caching)

#### Module 4 — Streaming Feature Pipelines

Use cases for streaming in ML (fraud detection, recommender freshness, real-time personalization)

Building sliding window aggregations with Kafka Streams & Faust

Joining real-time data with static reference datasets

Handling late/out-of-order data

Monitoring freshness & processing latency

#### Module 5 — Data Quality for ML

Why ML needs stricter data quality checks

Great Expectations for batch pipelines

Pandera for Python dataframe validation

Detecting drift at the data layer (statistical checks pre-model)

Automated quality gates in CI/CD pipelines

#### Module 6 — Workflow Orchestration with Airflow

Airflow basics: DAGs, tasks, scheduling, retries

Setting up Airflow locally & on AWS EC2

Integrating batch feature engineering with Airflow DAGs

Sensors for data availability checks

Airflow with KubernetesPodOperator for scalable ML jobs

#### Module 7 — Integration with Feature Stores

Role of feature stores in MLOps

Connecting Kafka/Spark outputs to Feast

Offline vs online stores (S3/Parquet vs Redis/Postgres)

TTL & freshness guarantees

Example: ingesting Spark output to Feast for model training & real-time lookup

Next Episode:

![📌](<Base64-Image-Removed>)Episode 4 — Fraud Detection Pipeline on AWS

Builds directly on this episode, using Kafka + Spark + Airflow + Feast from here as the backbone of the real-time ML system.