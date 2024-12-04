### ML Model Training & Publishing
In general, a typical ML Pipeline has 3 workflow stages - Data Preparation, Model Training, Model Deployment, as depicted in the diagram below. 
![ML Pipeline](https://github.com/user-attachments/assets/1dc7dcd8-a8c5-4944-b24a-31df6cf235fd)

#### 1. Clone the Specific Git Repo for ML Model Training and Publishing
After the CE7-Group1-Capstone organisation "mlops-project" repository is cloned from GitHub, you will see the following screen from the Web browser.
```bash
  git clone https://github.com/CE7-Group1-Capstone/mlops-project.git
```
![git-repo-screenshot](https://github.com/user-attachments/assets/0572bcbc-d36a-4021-95f6-11ca19be007f)
Before we proceed to the next step, we need to configure the GitHub repo as follows:
![github-env-variables-screenshot](https://github.com/user-attachments/assets/8f4fdc67-b663-4042-bd01-a24eb4c09133)
![github-secret-variables-screenshot](https://github.com/user-attachments/assets/ac4666fc-42fb-42be-8456-9a751a4782fe)
### 2. First-time infra resource creation of the AWS S3 bucket and ECR private repos
For the first-time deployment, you will need to create a S3 bucket and the 2 ECR private repos. Click on `Actions` menu tab and you will see the following screen of the available GitHub Actions workflows:
![gha-ci-tf-screenshot](https://github.com/user-attachments/assets/b5fe8dff-de6d-4246-80d9-e75b7eb91a8f)
Next click on `CI Terraform` followed by click on `Run workflow`, then select _Use workflow from_ `Branch: main` and finally clicking on the `Run workflow` button. This will trigger a series of Terraform initialising, linting, formatting and validating checks - tflint, checkov, terraform init/fmt/validate.
After the `CI Terraform` workflow runs successfully, click on the next workflow of `CD Terraform` to run. Select `Branch: main` and choose `y` for the _Do you really want to proceed (y/n)?_ prompt.
![gha-cd-tf-screenshot](https://github.com/user-attachments/assets/e938c533-9145-4c80-a814-0a9f6a615cee)
This will trigger the Terraform AWS resources creation of the S3 bucket and ECR private repos:
  - S3 bucket `ce7-grp-1-bucket`
    - `new_ML_data` folder where the model training dataset (named as `train.csv`) and the model testing dataset (named as `test.csv`) are stored
    - `DVC_Artefacts` folder where the version control metadata of the trained ML models are saved by the [Data Version Control](https://dvc.org/) (DVC) tool that is used in the other workflows

> Data Version Control (DVC) is an open-source version control system
> for Data Science and Machine Learning projects. Git-like experience
> to organize your data, models, and experiments.
> 
  ![s3-bucket-screenshot](https://github.com/user-attachments/assets/a8e40738-a771-4785-b5be-cb91eec92aef)
  - ECR private repos of `ce7-grp-1/nonprod/predict_buy_app` and `ce7-grp-1/prod/predict_buy_app`
  ![ecr-repos-screenshot](https://github.com/user-attachments/assets/48a4102c-8405-4d10-99cf-6de3ec05dd56)
Now that the AWS resources for ML model Training and Publishing are created, we can then proceed with the Data Prep Stage of the ML Pipeline.
#### 2. Preparing the ML training and testing datasets
Upload the `train.csv` and `'test.csv` files  into the S3 bucket.
![new-datasets-s3-bucket-screenshot](https://github.com/user-attachments/assets/a5da19c2-235a-48d6-a2c7-e22f3eec636e)
Example datasets to unzip-then-upload: [ml-datasets.zip](https://github.com/user-attachments/files/17989198/ml-datasets.zip)
#### 3. Train the Model using Python with Scikit-Learn
Now that the new datasets have been uploaded, we then proceed to the Training Stage of the ML Pipeline. The `train_model.yml` pipeline executes the ML model training job which also includes the steps for testing the model using the test dataset post-training as well as the first-time initialisation of the DVC tracking, version-controlling the trained ML model and the associated training dataset used, and scanning the model for vulnerabilities. It is located in the `github/workflows` folder.
This `Train ML Model` workflow is triggered `on: push` to `branches: feature*` whenever any of `paths: main.py config.yml steps/*py requirements.txt trigger_test.py` changes. The latter `trigger_test.py` is a dummy Python program that can be changed with no impact whenever you wish to test-run this workflow. Alternatively this workflow may also be triggered by manually running in from the GitHub Actions menu tab.
Here's an illustration of the workflow summary screens:
![train_model-workflow-summary-screenshot1](https://github.com/user-attachments/assets/1ac5ee58-2786-4ce2-9c6f-9caf0b9a9692)
![train_model-workflow-summary-screenshot2](https://github.com/user-attachments/assets/9780aaa1-6dfb-448e-a86d-50e36ab9fd9c)
And the screenshot of the trained ML model binaries that are saved and version-controlled by DVC into the S3 bucket `DVC_artefacts` folder:
![ml_model-artefacts-screenshot](https://github.com/user-attachments/assets/43bb3833-6170-4805-9564-7e853c46fb74)
#### 4. Build the ML Application using FastAPI
After the trained ML model is ready, the `build_app.yml` pipeline runs next to build the application Docker image, then scan it for vulnerabilities and publishing it to the image registry which in AWS ECR `ce7-grp-1/nonprod/predict_buy_app` repo. This is the last step of the Training Stage. This `Build Docker App Image` workflow is triggered `on: pull_request` of `types: closed` on `branches: feature*` whenever any of `paths: models/*.pkl.dvc` changes. Alternatively this workflow may also be triggered by manually running in from the GitHub Actions menu tab.
Here's an illustration of the workflow summary screens:
![build_app-workflow-summary-screenshot1](https://github.com/user-attachments/assets/139348d1-39a1-4c37-a4c0-5babcb42fb60)
![build_app-workflow-summary-screenshot2](https://github.com/user-attachments/assets/c2d486c7-0dfe-4c1f-bc4c-bcf0c1534bd1)
After the Docker image is built, it is tagged with the next release version number as well as being tagged as `:latest`, before pushing it into the ECR nonprod repo `ce7-grp-1/nonprod/predict_buy_app`. We are basing on [SemVer](https://semver.org/) for our release versioning notation.
Here's a screenshot of the regustry repo `ce7-grp-1/nonprod/predict_buy_app` where all the `predict_buy_app` Docker images are pushed and can be subsequently merged ino the `Develop` branch to be deployed for SIT in the nonprod/staging environment.
![ecr_nonprod_repo-screenshot](https://github.com/user-attachments/assets/87df773d-a8b2-4411-9855-3d8f640341a9)
#### 5. Promote the Application Docker Image from nonprod to prod ECR private registeries

#### 6. Test run the `predict_buy_app` using Postman

#### Dependencies
![MLOps CICD Plan](https://github.com/user-attachments/assets/bd768c7e-b205-4e3d-8f6f-431a1ec079d7)
#### Application or Repo Structure
|![repo-structure-screenshot1](https://github.com/user-attachments/assets/0abb694f-9581-4e45-ab59-f02d45e77932)|
![repo-structure-screenshot2](https://github.com/user-attachments/assets/91e99fee-e5d6-4318-89e8-bb2028ec6c15) |
#### Branching Strategies
![Adapted Branching Strategy](https://github.com/user-attachments/assets/0ffa771d-574b-400a-ba0d-20d7fb1ea65e)
#### Production Branch
_describe the branch actions for prod env if any_
#### Non-Production Branch
_describe the branch actions for nonprod env if any_
#### CICD Pipeline
_describe the pipeline workflow including output samples if any_
#### Learning Journey
_add what "little secrets" have been learnt that you like to share with others_ 

