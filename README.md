# Insurance Cross Sell Prediction 🏠🏥
[![GitHub](https://img.shields.io/badge/GitHub-code-blue?style=flat&logo=github&logoColor=white&color=red)](https://github.com/lcchua/mlops-project.git) Source Reference: [![Medium](https://img.shields.io/badge/Medium-view_article-green?style=flat&logo=medium&logoColor=white&color=green)](https://medium.com/@prasadmahamulkar/machine-learning-operations-mlops-for-beginners-a5686bfe02b2)

Welcome to the Insurance Cross-Selling Prediction project! The goal of this project is to predict which customers are most likely to purchase additional insurance products using a machine learning model.

## ML Pipeline
![image](https://github.com/user-attachments/assets/9c202824-6b32-4c9d-b9b6-af09270bff2b)
![image](https://github.com/user-attachments/assets/abc6aa2c-5ee7-4c09-8f9f-15807399a5b5)

## Capstone Project Overview
![alt text](image.png)

## DevOps / DevSecOps Workflows
![alt text](image-4.png)

## Adapted Branching Strategy
![alt text](image-2.png)

## Get Started
To get started with the project, follow the steps below:

#### 1. Clone the Repository
Clone the project repository from GitHub:
```bash
git clone https://github.com/lcchua/mlops-project.git
```
```bash
cd mlops-project
```
#### 2. Set Up the Environment
Ensure you have Python 3.8+ installed. Create a virtual environment and install the necessary dependencies:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```
Alternatively, you can use the Makefile command:
```bash
make setup
```
#### 3. Data Preparation
Pull the data from DVC. If this command doesn't work, the train and test data are already present in the data folder:
```bash
dvc pull
```

#### 4. Train the Model
To train the model, run the following command:

```bash
python main.py 
```
Or use the Makefile command:

```bash
make run
```
This script will load the data, preprocess it, train the model, and save the trained model to the models/ directory.

#### 5. FastAPI
Start the FastAPI application by running:

```bash
uvicorn app:app --reload
```

#### 6. Docker
To build the Docker image and run the container:

```bash
docker build -t my_fastapi .
```
```bash
docker run -p 80:80 my_fastapi
```
Once your Docker image is built, you can push it to Docker Hub, making it accessible for deployment on any cloud platform.
#### 7. Push the Model to a Docker Image registry
......
```

