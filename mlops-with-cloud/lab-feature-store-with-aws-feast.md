![feature-store-with-aws-feast](./scenarios/feature-store-with-aws-feast.svg)

- objective
  - create AWS infrastructure using Pulumi (VPC, EC2, subnets, networking, security groups, S3).
  - install and configure Feast (both script-based and manual methods).
  - verify that Feast is working with an online store (Redis or SQLite) and offline store.
  - launch a simple Feast Feature Server to store and retrieve feature data.

-  what is a Feature Store: a Feature Store is a centralized system that manages and serves features for machine learning models. It acts as a bridge between raw data and model inputs, ensuring that the features used during training are consistent, up-to-date, and available during inference.

- why do we use Feature Stores:
  - now real-world ML systems, data pipelines can be messy and fragmented. Engineers often end up duplicating feature logic for training and serving, which can lead to training-serving skew, inconsistent results, and slower iteration. A Feature Store solves this by:
    - Storing precomputed features for reuse
    - Serving features in real-time or batch mode
    - Tracking feature lineage and versioning

- architecture Overview

  - bastion host in a public subnet
  - ec2 instance in private subnet
  - public and private Route Tables
  - NAT gateway to expose the private instance
