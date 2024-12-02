# Insurance Cross Sell Prediction 
[![GitHub](https://img.shields.io/badge/GitHub-code-blue?style=flat&logo=github&logoColor=white&color=red)](https://github.com/lcchua/mlops-project.git) 

Welcome to the Insurance Cross-Selling Prediction project! The goal of this project is to predict which customers are most likely to purchase additional insurance products using a machine learning model.

## ML Pipeline
![Screenshot 2024-11-25 at 3 55 19 PM](https://github.com/user-attachments/assets/76a7a2b1-cbb7-42b9-ac47-7a02e7f73e2e)
![Screenshot 2024-12-02 at 5 57 54 PM](https://github.com/user-attachments/assets/b1299a8f-4a25-49dd-84eb-97dbcde31310)


## Capstone Project Overview
![Screenshot 2024-12-02 at 5 52 40 PM](https://github.com/user-attachments/assets/018a89eb-9673-4d9c-9cee-b94349f56df4)


## DevOps / DevSecOps Workflows
![Screenshot 2024-11-28 at 4 50 01 PM](https://github.com/user-attachments/assets/5aca691f-dda0-4933-b529-e573b3198c4f)


## Adapted Trunk-based / GitFlow Branching Strategy
![Screenshot 2024-12-02 at 5 49 01 PM](https://github.com/user-attachments/assets/4d8cfeb7-660c-4934-8f08-548073f2101d)

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

Source Reference: [![Medium](https://img.shields.io/badge/Medium-view_article-green?style=flat&logo=medium&logoColor=white&color=green)](https://medium.com/@prasadmahamulkar/machine-learning-operations-mlops-for-beginners-a5686bfe02b2)
