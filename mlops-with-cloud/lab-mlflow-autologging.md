- objective
	- learn to use MLflow’s autolog() feature to automatically log parameters, metrics, and models
	- to compare autologging with manual logging using the Wine Quality dataset.
- what is autologging: autologging automatically captures information from popular ML libraries (e.g., `scikit-learn`, `tensorflow`, `xgboost`, `pytorch`, etc.) without explicitly writing logging code.

```sh
cat << 'EOF' > setup.sh #!/bin/bash
# setup env
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv python3-full

mkdir wine_quality_autologging
cd wine_quality_autologging
python3 -m venv mlops
source mlops/bin/activate
pip install mlflow scikit-learn pandas matplotlib seaborn kaggle
EOF

$ curl -L -o ./red-wine-quality-cortez-et-al-2009.zip\
  https://www.kaggle.com/api/v1/datasets/download/uciml/red-wine-quality-cortez-et-al-2009
$ unzip red-wine-quality-cortez-et-al-2009.zip

$ mlflow server --host 0.0.0.0 --port 5000 --allowed-hosts '*' --cors-allowed-origins '*'
```

- this script:
	- loads the Wine Quality dataset and performs binary classification (quality >= 7 is "good").
	- runs a Random Forest model twice: once with mlflow.sklearn.autolog() and once with manual logging.
	- autologging automatically captures parameters (e.g., n_estimators, max_depth), metrics (e.g., accuracy, precision), and the model.
	- manual logging explicitly logs parameters, accuracy, a confusion matrix, and the model.
```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
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
mlflow.set_experiment("Wine_Quality_Autologging")

# Run 1: Autologging with Random Forest
mlflow.sklearn.autolog()  # Enable autologging
with mlflow.start_run(run_name="RandomForest_Autolog"):
    rf_model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
    rf_model.fit(X_train, y_train)
    rf_pred = rf_model.predict(X_test)
    rf_accuracy = accuracy_score(y_test, rf_pred)
    print(f"Random Forest (Autolog) Accuracy: {rf_accuracy}")
mlflow.sklearn.autolog(disable=True)  # Disable autologging for next run

# Run 2: Manual logging with Random Forest
with mlflow.start_run(run_name="RandomForest_Manual"):
    rf_params = {"n_estimators": 100, "max_depth": 5}
    rf_model = RandomForestClassifier(**rf_params, random_state=42)
    rf_model.fit(X_train, y_train)
    rf_pred = rf_model.predict(X_test)
    rf_accuracy = accuracy_score(y_test, rf_pred)

    # Manual logging
    mlflow.log_params(rf_params)
    mlflow.log_metric("accuracy", rf_accuracy)

    # Log confusion matrix as artifact
    cm = confusion_matrix(y_test, rf_pred)
    plt.figure(figsize=(5, 5))
    sns.heatmap(cm, annot=True, fmt="d")
    plt.title("Random Forest Manual Confusion Matrix")
    plt.savefig("rf_manual_confusion_matrix.png")
    mlflow.log_artifact("rf_manual_confusion_matrix.png")

    # Log model
    mlflow.sklearn.log_model(rf_model, "random_forest_manual")
    print(f"Random Forest (Manual) Accuracy: {rf_accuracy}")

```