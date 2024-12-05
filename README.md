# NTU CE7 Group 1 Capstone Project Use-Case Documentation
<br>

<img src="https://github.com/user-attachments/assets/b7e4e120-6c5d-41c1-aac1-2c69889b8f95" alt="MLOps Overview" width="1000" />
<br>

### Our Company Profile
Quantum AI is a Singapore-based tech startup specializing in AI platform engineering for the insurance industry. We are a team of 4 'hardcore' engineers who is responsible for the "development and operations" ('DevOps') of Quantum's cloud AI platform. It offers customer up-selling and cross-selling predictions for insurance and bancassurance companies. Each member of this team has specialised tech skills and subject-matter expertise working collectively to ensure the continuous advancement and resilience of the platform.
### The 'Hardcore' Engineering Team
| **Name**                  | **Roles**                           |  **Expertise**                               |
|---------------------------|-------------------------------------|----------------------------------------------|
| Stephen Tan               | DevOps/DevSecOps Engineer           | GitHub & CICD Wizard                         |
| Tan Yuan                  | Cloud & On-Premise Infra Engineer   | Kubernetes & Cloud Master                    |
| Jun Jie                   | Platform Monitoring Engineer        | Prometheus & Grafana Spymmaster              | 
| Chua Lai Chwang           | MLOps Engineer & Project Manager    | GitHub Actions Scrum Master                  |

<br>

## The Project
Project Name: **Machine-Learning (ML) DevOps with DevSecOps and SRE Monitoring**<br>
- Our organization repository [CE7-Group1-Capstone](https://github.com/CE7-Group1-Capstone) consists of: 
  - [CI & Docker Image Registry Pipeline for ML Model Training & Publishing](https://github.com/CE7-Group1-Capstone/mlops-project)
  - [CI/CD Pipeline for AWS EKS/K8S Clusters Infrastructure & Monitoring Tools](https://github.com/CE7-Group1-Capstone/Capstone-Infrastructure)
  - CD Pipeline for Insurance Buying Prediction Application Deployment & Rollback is part of the above 2 repos

### Scope, Context and Motivation 
The primary use-case of this project centres on DevOps combined with basic use-cases of DevSecOps and SRE monitoring. This project covers the developing and deploying of machine learning (ML) models to the resilient, cloud-native Kubernetes (K8S) clusters in the non-production and production environments. The maintenance of ML models is excluded from this capstone due to time limitation. This CICD automation process of "DevOps for ML application" is known as MLOps which is generally illustrated as below. 

![MLOps Process](https://github.com/user-attachments/assets/a8f49323-ff20-44a9-b9ca-c5feccc7d8dc)

For our capstone scope, we have impelmented the source repository, CI/CD pipelines, data engineering, ML model engineering, ML metadata store including the ML model and data version control, model registry (of FastAPI app Docker images) and CD stage (of ML models serving as container Pods/Services/Deployments in the K8S clusters).

In this project context, the ML application is a prediction of whether an insurance customer is most likely to buy or renew an insurance policy or not, That is predicting the customer's propensity to buy an insurance product or otherwise. For ML model training, the aplication uses 3 different data classification algorithms of decision tree cliassifer, gradient boosting classifier and random forest classifier. 

Our motivation for electing the implementation coverage of MLOps, Kubernetes and SRE Monitoring for our capstone project lies with our desire to apply what we have learnt and in learning through hands-on practice. Though we did not implement the end-to-end MLOps process, we believe what we have started serve as as good baseline for us to learn further subsequently as we sought to extend our capstone implementation in the future. 

With the currrent proliferation of AI, it is imperative that the field of MLOps or AIOps will be a necessity in the technological advancement and mass adoption of AI wherein the process automation of AI/ML operation and security is essential.

### Solution Architecture Overview
The solution architecture can be described as follows:

![capstone-project-solution-architecture](https://github.com/user-attachments/assets/e3912b6b-ca5f-4c00-8ad5-942d20a491e5)

It comprises of 3 major domains:
  -  **Machine Learning Development**: ML Model Training and Publishing to AWS Elastic Container Registry (ECR) with AWS S3 bucket for the ML model version control metatdata and training datasets storage
  -  **Kubernetes Cluster Infra Deployment**: Terraform creation for AWS Elastic Kubernetes Service (EKS), Prometheus / Grafana monitoring tools, K8S / AWS CloudWatch / Loki logging stack
  -  **Prediction Application Deployment & Rollback**: GitHub Actions CD workflow pipeline from ECR to EKS for deployment to prod environment

<br>

## Getting Started
Firstly, clone the Git repositories mentioned under The Project section above and get started with the project through the following sections:
- [ML Model Training and Publishing](docs/getting_started_clc-A.md)
- [AWS EKS/Kubernetes Cluster Infrastructure](docs/getting_started_ty.md)
- [Prometheus & Grafana SRE Monitoring Tools](docs/getting_started_jj.md)
- [Insurance Buying Prediction Application Deployment & Rollback](docs/getting_started_st.md)


<br>

## Licensing and Credits
Credits to the 'hardcore' team:
- Jun Jie
- Tan Yuan
- Stephen Tan
- Chua Lai Chwang

<br>

## Additional Resources if any
1. [Machine Learning Operations (MLOps) For Beginners](https://medium.com/@prasadmahamulkar/machine-learning-operations-mlops-for-beginners-a5686bfe02b2)
2. [GitHub repo for MLOps For Beginners](https://github.com/prsdm/mlops-project)
