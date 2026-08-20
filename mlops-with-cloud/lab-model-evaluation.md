
A crucial step in any ML pipeline which helps to understand how well the models perform and enables to compare different versions based on key metrics and artifacts.

MLflow provides built-in support for logging, visualizing, and comparing model evaluation results across experiments and runs, where model.evaluate() is used to perform this operation.

**objectives:**

- setup MLflow tracking for a model training pipeline
- log metrics, parameters, and evaluation artifacts such as confusion matrices and SHAP plots
- use mlflow.evaluate() to generate standardized evaluation reports
- visualize and compare model performance using the MLflow UI

**table of contents**

- what is model evaluation
- setting up the environment
- evaluation of classification model
- evaluation of regression model

```sh
cat << 'EOF' > setup.sh #!/bin/bash
# setup env
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip

mkdir model_evaluation_lab && cd model_evaluation_lab && python3 -m venv mlops && source mlops/bin/activate
pip install mlflow scikit-learn xgboost shap
EOF

$ mlflow server --host 0.0.0.0 --port 5000 --allowed-hosts '*' --cors-allowed-origins '*'
```


- model training and registry
```python
# classification.py
# This script demonstrates model evaluation using MLflow for a classification task

import mlflow
import xgboost as xgb
import shap
from sklearn.model_selection import train_test_split
from mlflow.models import infer_signature

#Set mlflow tracking uri
mlflow.set_tracking_uri("http://localhost:5000")

experiment_name= "evaluation"
try:
    _ = mlflow.create_experiment(name=experiment_name)
except mlflow.exceptions.MlflowException:
    experiment= mlflow.get_experiment_by_name(name= experiment_name)

#Set experiment
experiment= mlflow.set_experiment(experiment_name)

# Load the UCI Adult Dataset
X, y = shap.datasets.adult()
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.33, random_state=42
)

# Train model
model = xgb.XGBClassifier().fit(X_train, y_train)

# Create evaluation dataset
eval_data = X_test.copy()
eval_data["label"] = y_test

with mlflow.start_run():
    # Log model with signature
    signature = infer_signature(X_test, model.predict(X_test))
    mlflow.sklearn.log_model(model, artifact_path="model", signature=signature)
    model_uri = mlflow.get_artifact_uri("model")

    # Comprehensive evaluation
    result = mlflow.models.evaluate(
        model_uri,
        eval_data,
        targets="label",
        model_type="classifier",
        evaluators=["default"],
    )

    print(f"Accuracy: {result.metrics['accuracy_score']:.3f}")
    print(f"F1 Score: {result.metrics['f1_score']:.3f}")
    print(f"ROC AUC: {result.metrics['roc_auc']:.3f}")

```

```python
# wine_quality_mlfow_lab/serve.py

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import mlflow
import mlflow.sklearn
import pandas as pd
import numpy as np

app = FastAPI()

# Set MLflow tracking URI
mlflow.set_tracking_uri("http://localhost:5000")

# Load the registered model
model_uri = "models:/WineQuality-RandomForest-Model/4"
try:
    model = mlflow.sklearn.load_model(model_uri)
    print(f"Model loaded successfully")
    print(f"Model type: {type(model)}")
    if hasattr(model, 'feature_names_in_'):
        expected_features = list(model.feature_names_in_)
        print(f"Model expects these feature names: {expected_features}")
    else:
        print("No feature_names_in_ attribute")
except Exception as e:
    raise Exception(f"Failed to load model: {str(e)}")

# Define input data schema
class WineFeatures(BaseModel):
    fixed_acidity: float
    volatile_acidity: float
    citric_acid: float
    residual_sugar: float
    chlorides: float
    free_sulfur_dioxide: float
    total_sulfur_dioxide: float
    density: float
    pH: float
    sulphates: float
    alcohol: float

@app.get("/")
def read_root():
    return {"message": "Wine Quality Prediction API"}

@app.get("/test")
def test_prediction():
    """Test endpoint with hardcoded values"""
    try:
        # Test with exact column names the model expects
        test_data = pd.DataFrame([{
            "fixed acidity": 7.4,
            "volatile acidity": 0.7,
            "citric acid": 0.0,
            "residual sugar": 1.9,
            "chlorides": 0.076,
            "free sulfur dioxide": 11.0,
            "total sulfur dioxide": 34.0,
            "density": 0.9978,
            "pH": 3.51,
            "sulphates": 0.56,
            "alcohol": 9.4
        }])
        
        print(f"Test DataFrame columns: {list(test_data.columns)}")
        print(f"Test DataFrame:\n{test_data}")
        
        # Try prediction
        prediction = model.predict(test_data)
        return {"test_prediction": float(prediction[0]), "status": "success"}
        
    except Exception as e:
        print(f"Test prediction failed: {str(e)}")
        return {"error": str(e), "status": "failed"}

@app.post("/predict/")
def predict(wine: WineFeatures):
    try:
        # Method 1: Direct dictionary approach (what we've been trying)
        print("=== Method 1: Direct dictionary ===")
        data1 = pd.DataFrame([{
            "fixed acidity": wine.fixed_acidity,
            "volatile acidity": wine.volatile_acidity,
            "citric acid": wine.citric_acid,
            "residual sugar": wine.residual_sugar,
            "chlorides": wine.chlorides,
            "free sulfur dioxide": wine.free_sulfur_dioxide,
            "total sulfur dioxide": wine.total_sulfur_dioxide,
            "density": wine.density,
            "pH": wine.pH,
            "sulphates": wine.sulphates,
            "alcohol": wine.alcohol
        }])
        print(f"Method 1 columns: {list(data1.columns)}")
        
        # Method 2: Using numpy array with explicit columns
        print("=== Method 2: Numpy array with columns ===")
        values = np.array([[
            wine.fixed_acidity, wine.volatile_acidity, wine.citric_acid,
            wine.residual_sugar, wine.chlorides, wine.free_sulfur_dioxide,
            wine.total_sulfur_dioxide, wine.density, wine.pH,
            wine.sulphates, wine.alcohol
        ]])
        
        columns = [
            "fixed acidity", "volatile acidity", "citric acid", "residual sugar",
            "chlorides", "free sulfur dioxide", "total sulfur dioxide", 
            "density", "pH", "sulphates", "alcohol"
        ]
        
        data2 = pd.DataFrame(values, columns=columns)
        print(f"Method 2 columns: {list(data2.columns)}")
        
        # Method 3: Try without feature name validation (if possible)
        print("=== Method 3: Check sklearn version and model properties ===")
        import sklearn
        print(f"Sklearn version: {sklearn.__version__}")
        
        # Try to disable feature name validation if sklearn version supports it
        try:
            if hasattr(model, 'set_params'):
                print("Model has set_params method")
            prediction = model.predict(data1)
            return {"prediction": float(prediction[0]), "method": "success with method 1"}
        except Exception as e1:
            print(f"Method 1 failed: {e1}")
            try:
                prediction = model.predict(data2)
                return {"prediction": float(prediction[0]), "method": "success with method 2"}
            except Exception as e2:
                print(f"Method 2 failed: {e2}")
                raise Exception(f"All methods failed. Method 1: {e1}, Method 2: {e2}")
        
    except Exception as e:
        print(f"Final error: {str(e)}")
        raise HTTPException(status_code=400, detail=f"Prediction error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

```


```json
# POST /predict/
{ "fixed_acidity": 7.4, "volatile_acidity": 0.7, "citric_acid": 0.0, "residual_sugar": 1.9, "chlorides": 0.076, "free_sulfur_dioxide": 11.0, "total_sulfur_dioxide": 34.0, "density": 0.9978, "pH": 3.51, "sulphates": 0.56, "alcohol": 9.4 }
```