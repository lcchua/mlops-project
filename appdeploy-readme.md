### Insurance Buying Prediction Application Deployment & Rollback
_fill in the workflow pipeline steps to check, install, build and execute_<br>
_remove this section as according_
#### Dependencies
As we are deploying our FastAPI app into an AWS Elastic Kubernetes Service(EKS) Cluster, we used Skaffold, a command line tool meant for continuous integration and continuous deployment/delivery with Docker and Kubernetes. Skaffold has both build and deploy capabilities which can be used together or each by itself.

Build and deploy configurations are described within the skaffold.yaml file which is required for Skaffold to work correctly.

Initially, we used the _skaffold run_ command to build, push artifacts into ECR image repository and deploy the repository image into our EKS cluster. This is the most direct 'Continuous Delivery' setup. However, due to our use of DVC for tracking machine learning code and integrating the .pbx model file into our API, the build image is incomplete. 

Eventually, we used _skaffold deploy_ in our Continuous Delivery Github workflow, which only deploys image to our EKS Cluster and decoupled the Continuous Integration(CI) process which is described here [docs/getting_started_clc-A.md](https://github.com/lcchua/mlops-project/blob/main/docs/getting_started_clc-A.md) 

![Screenshot Skaffold yaml](https://github.com/user-attachments/assets/920552ef-e211-4d9d-ad35-948c60f9a086)



[Skaffold Documentation](https://skaffold.dev/docs/workflows/ci-cd/)
#### Application or Repo Structure
_describe the application or repo structure if any_

![Screenshot folder structure](https://github.com/user-attachments/assets/ee65e023-d5fe-47fe-a819-11cf18ff6f8d)

#### Branching Strategies
_describe the branching strategy if any_
#### Production Branch
_describe the branch actions for prod env if any_
#### Non-Production Branch
_describe the branch actions for nonprod env if any_
#### CICD Pipeline
_describe the pipeline workflow including output samples if any_
#### Learning Journey
_add what "little secrets" have been learnt that you like to share with others_ 

