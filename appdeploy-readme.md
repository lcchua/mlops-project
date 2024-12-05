### Insurance Buying Prediction Application Deployment & Rollback
_fill in the workflow pipeline steps to check, install, build and execute_<br>
_remove this section as according_
#### Dependencies
As we are deploying our FastAPI app into an AWS Elastic Kubernetes Service(EKS) Cluster, we used Skaffold, a command line tool meant for continuous integration(CI) and continuous deployment/delivery with Docker and Kubernetes. Skaffold has both build and deploy capabilities which can be used together or each by itself.

More on Skaffold at: [Skaffold Documentation](https://skaffold.dev/docs/workflows/ci-cd/)


Build(CI) and deploy(CD) configurations are described within the skaffold.yaml file which is required for Skaffold to work correctly.

Initially, we used the _skaffold run_ command to build, push artifacts into ECR image repository and deploy the repository image into our EKS cluster. This is the most direct 'Continuous Delivery' setup. However, due to our use of DVC for tracking machine learning code and integrating the .pbx model file into our API, the build image is incomplete as Skaffold is incompatible with DVC due to DVC not being a separate repo frp, a Git Repo. 

Eventually, we used _skaffold deploy_ in our Continuous Delivery Github workflow, which only deploys image to our EKS Cluster and decoupled the Continuous Integration(CI) process which is described here [docs/getting_started_clc-A.md](https://github.com/lcchua/mlops-project/blob/main/docs/getting_started_clc-A.md) 

![Screenshot Skaffold yaml](https://github.com/user-attachments/assets/920552ef-e211-4d9d-ad35-948c60f9a086)



#### Application or Repo Structure

The deployment work flow can be found within cd.yml under .github/workflows as dictated by conventions.

![Screenshot folder structure](https://github.com/user-attachments/assets/ee65e023-d5fe-47fe-a819-11cf18ff6f8d)

The Kubernetes manifest files can be found in the .k8s folder. Deployment and service to deployment is found in flask-deployment-template.yml. There are some placeholders which will be replaced when the cd.yaml jobs run based on the environment.

![Screenshot fastapi_k8s_manifest](https://github.com/user-attachments/assets/67c6f109-526a-49d7-b9de-5fde86da735a)


#### Branching Strategies
_describe the branching strategy if any_
#### Production Branch vs Non-Production Branch
We have adopted a modified approach to GitHub Flow branching strategy. The Main branch remains the production branch and the Develop branch is the other long lived branch for non-production/testing environment.

Triggering the flow on _Main_ branch will deploy the image from AWS ECR to the production namespace in the EKS cluster and likewise, triggering flow on _Develop_ branch will deploy to the nonprod namespace.

This is achieved by doing a replacement of placeholder values with environment specific values

![Screenshot set env values based on workflow branch](https://github.com/user-attachments/assets/839f4ea9-e97a-489d-8d0a-edcfbba425f1)

#### CICD Pipeline
The workflow will be dispatched manually. User will provide following inputs:
- choice of y/n
- Release tag in semver format i.e. vx.x.x

![Screenshot workflow dispatch inputs](https://github.com/user-attachments/assets/b8fd4161-775b-4062-8417-9e31dc642357)

User has to select a release tag from the releases within the repository. As it is a string input, there are validation checks in place.

- Check that input tag is in semver format
- Check that input tag can be found within the Git repo's release tag


![Screenshot checkout and tag validation](https://github.com/user-attachments/assets/735bafd1-0857-4c62-bb85-5bb82034dfed)



Performing ECR login is necessary to prevent authentication errors. As mentioned above, we used _skaffold deploy_ instead of _skaffold run_ to only deploy the image from AWS ECR

Final step of the deployment is to verify that the deployment is running by running a _kubectl get pods_ command

![Screenshot login and deployment](https://github.com/user-attachments/assets/44e2b7d5-0db2-4a78-a230-a08620c73cf9)


#### Learning Journey

**Separation of Concerns**

The .pbx model file is bundled wit API code and ideally should be decoupled and maintained in an AWS S3 storage. By doing so, we can fully utilize Skaffold's complete pipeline tool for CI/CD purposes. Such an implementation would have the API to connect to the .pbx model file when required. Any updates in the model file would not require rebuild of the FASTIAPI image.

**Add an action to deploy on release**

In addition to the manual workflow dispatch step, we could have used a release action to trigger the workflow

![image](https://github.com/user-attachments/assets/03d94c2e-cb1b-4d57-b1f0-78d417b4c54b)



