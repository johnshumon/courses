- table of contents
	- what is model registry?
	- registering a model
	- registering using SDK
	- create model version
	- updating model metadata
	- get model version
	- delete Information or Metadata
	- conclusion
- **model registry**:
	- model registry is a centralized model store, set of APIs to collaboratively manage the full lifecycle of an ML model from scratch to production. It offers APIs and UI support for registering, versioning, annotating (with tags/aliases), transitioning models through stages (e.g., Staging, Production), and tracking model lineage.
	- purpose
		- centralized Management
		- version Control
		- lifecycle Management
		- deployment Readiness

![[model-registry.svg]]

```sh
cat << 'EOF' > setup.sh
#!/bin/bash

# setup env
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv python3-full

# setup venv
python3 -m venv mlops && source mlops/bin/activate
pip install mlflow scikit-learn pandas matplotlib seaborn
EOF

# lb
$ ifconfig
```

```python
# model_registry.py

import mlflow
from sklearn.ensemble import RandomForestClassifier

mlflow.set_tracking_uri("http://localhost:5000")
client = mlflow.MlflowClient()

## instantiate a model
rfc = RandomForestClassifier()

## log the model

with mlflow.start_run(run_name="logging-model") as run:
    mlflow.sklearn.log_model(sk_model=rfc, artifact_path=rfc.__class__.__name__)


"""
  > register model with mlflow client
"""
model_name= "registered-model-via-client"

try:
    result= client.create_registered_model(name=model_name)
except Exception as e:
    print(e)

print(f"Model {result.name} created")
print(f"Model description {result.description}")
print(f"Model creation timestamp {result.creation_timestamp}")
print(f"Model tags {result.tags}")

## print(f"Model Alias {result.aliases}")

"""
  > updating model metadata
"""

rfc= RandomForestClassifier()

registered_model_name= "random-forest classifier"

with mlflow.start_run(run_name="registering-model")as run:
    mlflow.sklearn.log_model(sk_model=rfc, artifact_path=rfc.__class__.__name__, registered_model_name=registered_model_name)

## adding model description

client.update_registered_model(name= registered_model_name, description="This is a random forest classifier model")

## updating model tags
registered_model_tags= {
    "project_name":"UNDERFINED",
    "task":"classification",
    "framework":"sklearn",

}

for key, value in registered_model_tags.items():
    client.set_registered_model_tag(name=registered_model_name, key=key, value=value)

## updating model alias
model_aliases= ["Champion", "candidate", "development"]

for model_alias in model_aliases:
    client.set_registered_model_alias(name=registered_model_name, alias= model_alias, version="1")

with mlflow.start_run(run_name="registering-model")as run:
    mlflow.sklearn.log_model(sk_model=rfc, artifact_path=rfc.__class__.__name__, registered_model_name=registered_model_name)

## adding alias
client.set_registered_model_alias(name=registered_model_name, alias="Champion", version="2")

## add tags to versions
client.set_model_version_tag(name=registered_model_name, version="1", key="validation_status", value="pending")

client.set_model_version_tag(name=registered_model_name, version="2", key="validation_status", value="Ready for deployment")

"""
  > get Model Version
"""

model_version_1= client.get_model_version(name=registered_model_name, version="1")

print(f"Model version: {model_version_1.version}")
print(f"Model version creation time: {model_version_1.creation_timestamp}")
print(f"Model version description: {model_version_1.description}")
print(f"Model version source: {model_version_1.source}")
print(f"Model version status: {model_version_1.status}")
print(f"Model version run_id: {model_version_1.run_id}")
print(f"Model version tags: {model_version_1.tags}")
print(f"Model version aliases: {model_version_1.aliases}")

  

print("##################################################")

  

model_version_champ = client.get_model_version_by_alias(name=registered_model_name, alias="Champion")

print(f"Model version: {model_version_champ.version}")

print(f"Model version creation time: {model_version_champ.creation_timestamp}")

print(f"Model version description: {model_version_champ.description}")

print(f"Model version source: {model_version_champ.source}")

print(f"Model version status: {model_version_champ.status}")

print(f"Model version run_id: {model_version_champ.run_id}")

print(f"Model version tags: {model_version_champ.tags}")

print(f"Model version aliases: {model_version_champ.aliases}")

  

## delete metadata

client.delete_model_version_tag(name=registered_model_name, version="1", key="validation_status")
```