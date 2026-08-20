- components of MLflow
	- MLflow Tracking: Tracks experiments, parameters, metrics, and artefacts associated with machine learning models.
	- MLflow Projects: Packages machine learning code into a reusable and reproducible format.
	- MLflow Models: Provides a standard format for packaging machine learning models for deployment.
	- MLflow Model Registry: Centralizes model management and governance by tracking mo del versions, stages and allows for collaborations.
- applications
	- **reproducibility:** Ensures that experiments can be reproduced by tracking all necessary information, including code versions and datasets.
	- **experiment Tracking:** Logs and compares different model training runs, helping identify the best-performing model based on specific criteria.
	- **performance comparison:** Allows for easy comparison of model performance over time and across different runs.
	- **code sharing:** Facilitates sharing of ML code with other data scientists or teams, promoting collaboration and knowledge transfer.
	- **model deployment:** Simplifies the process of deploying models to various platforms, including real-time serving through REST APIs or batch inference on Apache Spark.
	- **model packaging:** Provides a standardized way to package models for different environments, ensuring consistency and portability.
	- **model versioning:** Keeps track of different versions of a model, allowing for easy rollback to previous versions if needed.

![[mlflow-fundamentals.svg]]

```sh
# setup env
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install -y python3 python3-pip python3-venv

$ python3 -m venv mlflow_fundamentals_env
$ source mlflow_fundamentals_env/bin/activate

# install mlflow and scikit-learn
$ pip install mlflow scikit-learn

# start mlflow tracking server
$ mlflow server --host 0.0.0.0 --port 5000 --allowed-hosts '*' --cors-allowed-origins '*'
```

```python
# train script: mlflow_fundamentals.py

import mlflow
from sklearn.datasets import load_diabetes
from sklearn.model_selection import train_test_split
from sklearn.linear_model import SGDRegressor
from sklearn.metrics import mean_squared_error
import numpy as np

# Set the experiment name
mlflow.set_experiment("Diabetes_Regression")

# Load dataset
diabetes = load_diabetes()
X, y = diabetes.data, diabetes.target
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Define hyperparameters
learning_rate = 0.01
n_iterations = 1000  # Increased for better convergence

# Start a run
with mlflow.start_run(run_name="SGD_Regression_Trial"):
    # Train model
    model = SGDRegressor(
        learning_rate='constant',
        eta0=learning_rate,
        max_iter=n_iterations,
        random_state=42,
        tol=1e-3
    )
    model.fit(X_train, y_train)
    
    # Predict and calculate metric
    y_pred = model.predict(X_test)
    mse = mean_squared_error(y_test, y_pred)
    
    # Log parameters
    mlflow.log_param("learning_rate", learning_rate)
    mlflow.log_param("n_iterations", n_iterations)
    
    # Log metric
    mlflow.log_metric("mse", mse)
    
    # Log artifact (save a text file with model details)
    with open("model_summary.txt", "w") as f:
        f.write(f"Model: SGDRegressor\nMSE: {mse}\nLearning Rate: {learning_rate}\nIterations: {n_iterations}")
    mlflow.log_artifact("model_summary.txt")
    
    print(f"Run completed with MSE: {mse}")
```

```sh
# run the script
$ source mlflow_fundamentals_env/bin/activate
$ python mlflow_fundamentals.py
```