- table of Contents
	- what is experiment and run in MLflow?
	- overview on Experiments
	- overview on Runs
	- set Up the Environment
	- start the MLflow Tracking Server
	- train Models and Log with MLflow
	- visualizations
- **run**: a run is a single execution of a machine learning pipeline under certain conditions such as model type, hyperparameters, dataset version etc. It logs parameters, metrics, artifacts. In summary, every time a model is trained or any variations tried is a run.
- **experiment**: an experiment is a logical container for a set of related runs. More of a project which represents a high-level goal like “Churn Prediction Model”. Each experiment consist a unique name or ID.

![[experiment-tracking.svg]]

```sh
# setup env and install necessary packages
$ sudo su
$ apt update && apt upgrade -y && apt install -y python3 python3-pip python3-venv python3-full

# setup virtual env
$ python3 -m venv experiment_tracking && source experiment_tacking/bin/activate

# install mlflow and scikit-learn
$ pip install mlflow scikit-learn pandas matplotlib seaborn

# start mlflow tracking server
$ mlflow server --host 0.0.0.0 --port 5000 --allowed-hosts '*' --cors-allowed-origins '*'

# grab private ip and create a load balancer
$ ifconfig
$ create load balancer -> enter ip: private ip, port: 5000 -> expose
```

```python
# experiments.py
import mlflow

mlflow.set_tracking_uri("http://localhost:5000")

# experiment = mlflow.create_experiment("testing_mlflow2", tags={"topic":"experiment-number2", "version": "v1"})

experiment= mlflow.set_experiment(experiment_name="testing_mlflow2")
    with mlflow.start_run() as run:
    print(f"Active run_id: {run.info.run_id}")

experiment= mlflow.get_experiment_by_name(name="poridhi-experiment")
    if experiment is None:
    print("Experiment does not exist")

experiment= mlflow.get_experiment_by_name(name="testing_mlflow2")
    print(experiment.name)
    print(experiment.experiment_id)
    print(experiment.to_proto())

## creating two new experiments
experiment= mlflow.set_experiment(experiment_name="testing-mlflow3")
experiment= mlflow.set_experiment(experiment_name="testing-mlflow4")

## activating MLflow client
client= mlflow.MlflowClient()

## getting the experiment by its name
experiment= client.get_experiment_by_name("testing-mlflow3")
print(experiment.name)
print(experiment.experiment_id)
print(experiment.lifecycle_stage)

## deleting the experiment
client.delete_experiment(experiment_id= experiment.experiment_id)

## getting the experiment after deletion
experiment= client.get_experiment_by_name("testing-mlflow3")
print(experiment.lifecycle_stage)

## getting the experiment we deleted using client
experiment= client.get_experiment_by_name("testing-mlflow3")

## restoring it
client.restore_experiment(experiment_id=experiment.experiment_id)
print(experiment.name)
print(experiment.lifecycle_stage)

## checking for the current lifecycle stage
experiment= client.get_experiment_by_name("testing-mlflow3")
print(experiment.name)
print(experiment.lifecycle_stage)

## create a run and add params to it
run= mlflow.start_run()
print(type(run).__name__)
print(run.info.to_proto())
print(run.data.to_dictionary())

## logging some random parameters
mlflow.log_param("param1", 5)
mlflow.log_param("param2", 9)
mlflow.log_param("param3", 5)

## logging some random metrics
mlflow.log_metric("metric1",14)
mlflow.log_metric("metric2",20)
mlflow.log_metric("metric3",12)
```

```python
# nested_run.py
import mlflow
mlflow.set_tracking_uri= ("http://localhost:5000")

with mlflow.start_run(run_name="parent") as parent_run:
    print("parent run_id:", parent_run.info.run_id)
    mlflow.log_param("parent_param1",2)

with mlflow.start_run(run_name="child", nested=True) as child_run:
    print("Child run_id:", child_run.info.run_id)
    mlflow.log_param("param1",1)
    mlflow.log_metric("metric1", 2.0)

with mlflow.start_run(run_name="grandchild", nested=True) as grandchild_run:
    print("Grandchil run_id:", grandchild_run.info.run_id)
    mlflow.log_param("param1", 3)
    mlflow.log_metric("metric1", 4.0)

### ---------------------

# import mlflow

with mlflow.start_run(run_name="parent") as parent_run:
    print("Parent run_id:", parent_run.info.run_id)
    mlflow.log_param("parent_param1", 2)

with mlflow.start_run(run_name="child", parent_run_id=parent_run.info.run_id) as child_run:
    print("child run_id:", child_run.info.run_id)
    mlflow.log_param("parent_param1", 2)

with mlflow.start_run(run_name="grandchild", parent_run_id=child_run.info.run_id) as grandchild_run:
    print("Parent run_id:", parent_run.info.run_id)
    mlflow.log_param("parent_param1", 2)

### --------------------

import mlflow

mlflow.set_tracking_uri= ("http://localhost:5000")

with mlflow.start_run() as run:
    mlflow.log_param("a", 1)
    run_id = run.info.run_id

# Deleting the run after the context (run) has ended
mlflow.delete_run(run_id)

#check if the run is deleted
lifecycle_stage= mlflow.get_run(run_id).info.lifecycle_stage
print(f"run_id: {run_id}; lifecycle_stage: {lifecycle_stage}")
```

- train models and log with MLflow
```sh
$ mkdir wine_quality_experiment && cd wine_quality_experiment 
$ python3 -m venv mlflow_tracking_env && source mlflow_tracking_env/bin/activate
$ pip install mlflow scikit-learn pandas kaggle
$ curl -L -o ./red-wine-quality-cortez-et-al-2009.zip\
  https://www.kaggle.com/api/v1/datasets/download/uciml/red-wine-quality-cortez-et-al-2009
$ unzip red-wine-quality-cortez-et-al-2009.zip
```

```python
# wine_quality_tracking.py
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load dataset
data = pd.read_csv("winequality-red.csv")
X = data.drop("quality", axis=1)
y = (data["quality"] >= 7).astype(int)  # Binary classification: quality >= 7 is "good"
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Set experiment
mlflow.set_experiment("Wine_Quality_Classification")

# Model 1: Random Forest
with mlflow.start_run(run_name="RandomForest_Trial"):
    rf_params = {"n_estimators": 100, "max_depth": 5}
    rf_model = RandomForestClassifier(**rf_params, random_state=42)
    rf_model.fit(X_train, y_train)
    rf_pred = rf_model.predict(X_test)
    rf_accuracy = accuracy_score(y_test, rf_pred)

    # Log parameters and metrics
    mlflow.log_params(rf_params)
    mlflow.log_metric("accuracy", rf_accuracy)

    # Log confusion matrix as artifact
    cm = confusion_matrix(y_test, rf_pred)
    plt.figure(figsize=(5, 5))
    sns.heatmap(cm, annot=True, fmt="d")
    plt.title("Random Forest Confusion Matrix")
    plt.savefig("rf_confusion_matrix.png")
    mlflow.log_artifact("rf_confusion_matrix.png")

    # Log model
    mlflow.sklearn.log_model(rf_model, "random_forest_model")
    print(f"Random Forest Accuracy: {rf_accuracy}")

# Model 2: Logistic Regression
with mlflow.start_run(run_name="LogisticRegression_Trial"):
    lr_params = {"C": 1.0, "max_iter": 200}
    lr_model = LogisticRegression(**lr_params, random_state=42)
    lr_model.fit(X_train, y_train)
    lr_pred = lr_model.predict(X_test)
    lr_accuracy = accuracy_score(y_test, lr_pred)

    # Log parameters and metrics
    mlflow.log_params(lr_params)
    mlflow.log_metric("accuracy", lr_accuracy)

    # Log confusion matrix as artifact
    cm = confusion_matrix(y_test, lr_pred)
    plt.figure(figsize=(5, 5))
    sns.heatmap(cm, annot=True, fmt="d")
    plt.title("Logistic Regression Confusion Matrix")
    plt.savefig("lr_confusion_matrix.png")
    mlflow.log_artifact("lr_confusion_matrix.png")

    # Log model
    mlflow.sklearn.log_model(lr_model, "logistic_regression_model")
    print(f"Logistic Regression Accuracy: {lr_accuracy}")

```