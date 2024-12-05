[Go to Part B](getting_started_clc-B.md)

### ML Model Training & Publishing
General a typical ML Pipeline has 3 workflow stages - Data Preparation, Model Training, Model Deployment, as depicted in the diagram below. 
![ML Pipeline](https://github.com/user-attachments/assets/1dc7dcd8-a8c5-4944-b24a-31df6cf235fd)

<br>

To get started,
#### 1. Clone the specific Git Repo for `mlops-project` and set up the GitHub repo
After the CE7-Group1-Capstone organisation `mlops-project` repository is cloned from GitHub, you will see the following screen from the Web browser. 
```bash
  git clone https://github.com/CE7-Group1-Capstone/mlops-project.git
```
  ![git-repo-screenshot](https://github.com/user-attachments/assets/0572bcbc-d36a-4021-95f6-11ca19be007f)
Before we proceed to the next step, we need to create the following variables and secrets for this GitHub repo:
  ![github-env-variables-screenshot](https://github.com/user-attachments/assets/8f4fdc67-b663-4042-bd01-a24eb4c09133)
  ![github-secret-variables-screenshot](https://github.com/user-attachments/assets/ac4666fc-42fb-42be-8456-9a751a4782fe)

And as well as making sure to set up and configure the following:
  - Environments
      - Create 2 environments, one is named`prod` and the other `nondprod`
          - Select `Allow administrators to bypass configured protection rules` and leave the other parameters unselected.
  - Branch protection rules
      - Create 2 protection rules, one for the branch named `main`and the other for branch named `develop`
          - Select `Require a pull request before merging` and leave the other parameters unselected.
  - Actions under General
      - Select the permissions `Allow all actions and reusable workflows`, `Require approval for all external contributors` and `Read and write permissions` and leave the other parameters unselected or as defaulted.
### 2. First-time infra resource creation of the AWS S3 bucket and ECR private repos
For the first-time deployment, you will need to create a S3 bucket and the 2 ECR private repos. Click on `Actions` menu tab and you will see the following screen of the available GitHub Actions workflows of the left-hand side panel:
  ![gha-ci-tf-screenshot](https://github.com/user-attachments/assets/c46beac4-b340-4d54-b576-c91bce557c29)
Next click on `CI Terraform` followed by click on `Run workflow`, then select _Use workflow from_ `Branch: main` and finally clicking on the `Run workflow` button. This will trigger a series of Terraform initialising, linting, formatting and validating checks - `tflint`, `checkov`, `terraform init/fmt/validate`.
Here's an illustration of the Terraform Checkov scan output:

![Screenshot 2024-12-05 at 4 24 22 PM](https://github.com/user-attachments/assets/0f1310e7-5067-4822-9108-a03387902c99)
After the `CI Terraform` workflow runs successfully, click on the next workflow of `CD Terraform` to run. Select `Branch: main` and choose `y` for the _Do you really want to proceed (y/n)?_ prompt. This will trigger Terraform init/plan/apply to run.
  ![gha-cd-tf-screenshot](https://github.com/user-attachments/assets/e938c533-9145-4c80-a814-0a9f6a615cee)

This will create the AWS infra resources of the S3 bucket and ECR private repos:
  - S3 bucket `ce7-grp-1-bucket`
    - `new_ML_data` folder where the model training dataset (named as `train.csv`) and the model testing dataset (named as `test.csv`) are stored
    - `DVC_Artefacts` folder where the version control metadata of the trained ML models and the associated training datasets used are saved using the [Data Version Control](https://dvc.org/) (DVC) tool.

> Data Version Control (DVC) is an open-source version control system
> for Data Science and Machine Learning projects. Git-like experience
> to organize your data, models, and experiments.
> 
  ![s3-bucket-screenshot](https://github.com/user-attachments/assets/a8e40738-a771-4785-b5be-cb91eec92aef)
  - ECR private repos of `ce7-grp-1/nonprod/predict_buy_app` and `ce7-grp-1/prod/predict_buy_app`
  ![ecr-repos-screenshot](https://github.com/user-attachments/assets/48a4102c-8405-4d10-99cf-6de3ec05dd56)
Now that the AWS resources for ML model Training and Publishing are created, we can then proceed with the Data Prep Stage of the ML Pipeline.
#### 2. Preparing the ML training and testing datasets
After the training dataset has been cleaned, reformmated, pre-processed and prepped into 2 .csv files of `train.csv` and `test.csv`, then proceed to upload these files into the S3 bucket `new_ML_data` folder.
  ![new-datasets-s3-bucket-screenshot](https://github.com/user-attachments/assets/a5da19c2-235a-48d6-a2c7-e22f3eec636e)
Example datasets: [ml-datasets.zip](https://github.com/user-attachments/files/17989198/ml-datasets.zip) to unzip then upload.
#### 3. Train the ML Model using Python with Scikit-Learn
Now that the new datasets have been uploaded, we next proceed to the Training Stage of the ML Pipeline. The `train_model.yml` pipeline executes the ML model training job which also includes the steps for testing the model using the test dataset post-training as well as the first-time initialisation of the DVC tracking, version-controlling the trained ML model and the associated training dataset used, and scanning the model for vulnerabilities using `protectai modelscan`. It is located in the `.github/workflows` folder.

This `Train ML Model` workflow is triggered by the `on: push branches: feature* paths: main.py config.yml steps/*py requirements.txt trigger_test.py` event whenever any of the ML program files change. The latter `trigger_test.py` is a dummy Python program that can be changed with no impact whenever you wish to test-run this workflow. Alternatively this workflow may also be triggered by manually running in from the GitHub Actions menu tab.

After each run of the workflow steps of `Train the prediction model` and `Test the trained model` in sequence, it outputs respectively the following:

  ![train_the_prediction_model-screenshot](https://github.com/user-attachments/assets/5c50d34d-2271-4db4-aba0-bd3eafd9ceb9)
  ![test_the_trained_model-screenshot](https://github.com/user-attachments/assets/82b00c1c-b8af-4921-a954-bccaa56e6e8c)

Here's an illustration of the workflow summary screen:
  ![train_model-workflow-summary-screenshot1](https://github.com/user-attachments/assets/1ac5ee58-2786-4ce2-9c6f-9caf0b9a9692)
  ![modelscan_output-screenshot](https://github.com/user-attachments/assets/2d4ef06f-21b3-4d9b-9e01-b77594c1b0f2)

And the screenshot of the trained ML model binaries that are saved and version-controlled by DVC into the S3 bucket `DVC_artefacts` folder:
  ![s3-ml-model-artefacts-screenshot](https://github.com/user-attachments/assets/43bb3833-6170-4805-9564-7e853c46fb74)
#### 4. Build the ML Application using FastAPI
After the trained ML model is ready, the `build_app.yml` pipeline runs next to build the application Docker image, then scanning it for vulnerabilities using `snyk container test` and publishing it to the private image registry of AWS ECR `ce7-grp-1/nonprod/predict_buy_app` repo. It is the last step of the Training Stage.

This `Build Docker App Image` workflow is triggered by the `on: pull_request types: closed on branches: feature* paths: models/*.pkl.dvc` event whenever the ML model `.pkl file` changes. An automatic merge PR (pull_request) action generated by a `github-actions[bot]` ([Generate Pull request](https://github.com/peter-evans/create-pull-request)) running at the end of the `Train ML Model` workflow invokes the trigger for the `Build Docker App Image` workflow to run. Alternatively this workflow may also be triggered by manually running in from the GitHub Actions menu tab.

In this workflow, the ML application of `predict_buy_app` is built using [FastAPI](https://fastapi.tiangolo.com/) with a Dockerfile that creates the application Docker image.
>
> FastAPI is a modern, fast (high-performance), web framework for building APIs with Python based on standard Python type hints.
>
> Dockerfile:
>```FROM python:3.12
>
>WORKDIR /app
>
>COPY app.py .
>COPY models/ ./models/
>
>COPY requirements.txt .
>RUN pip install --no-cache-dir -r requirements.txt
>
>CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]```
>
Here's an illustration of the workflow summary screen:
  ![build_app-workflow-summary-screenshot1](https://github.com/user-attachments/assets/139348d1-39a1-4c37-a4c0-5babcb42fb60)
  ![snyk_container_test_output-screenshot](https://github.com/user-attachments/assets/75b5af35-f951-4ed9-80a5-1a8c039ffbc6)

After the Docker image is built, it is tagged with the next release version number as well as being tagged as `:latest`, before pushing it into the ECR nonprod repo `ce7-grp-1/nonprod/predict_buy_app`. We are basing on [SemVer](https://semver.org/) for our release versioning notation of <major_no>.<minor_no>.<patch_no>.
  ![github-rel-tagging-screenshot1](https://github.com/user-attachments/assets/1b29d29a-31b4-408b-be8d-428fe57a1828)
  ![github-rel-tagging-screenshot2](https://github.com/user-attachments/assets/2e004865-7d54-411f-bdb3-eaf58af63933)
Here's a screenshot of the registry repo `ce7-grp-1/nonprod/predict_buy_app` where all the `predict_buy_app` Docker images are pushed to: 
  ![ecr-nonprod-repo-screenshot](https://github.com/user-attachments/assets/87df773d-a8b2-4411-9855-3d8f640341a9)
Note that after this `Build Docker App Image` workflow completes, a manual Pull Request has to be created for code review and upon approval merges the Feature branch into the Develop branch for automated testing cycle to begin. 

And when there's a merge Pull Request on either the Feature or Develop branch, it will automatically run the CI checks on all the Python programs too - `flake8` linting, `black` formatting, `snyk code test` scanning.
#### 5. Promote the Application Docker Image from nonprod to prod ECR private registeries
After the latest `predict_buy_app` version has successfully completed the testing cycle, a manual Pull Request has to be created for code review and upon approval, merges the Develop branch with the Main branch. This will automatically trigger the `Promote Tested App Image` workflow to run on the event of `on: pull_request types: closed branches: main paths: models/*.pkl.dvc app.py requirements.txt dockerfile trigger_test.py` whenever the ML model `.pkl file` or the  FastAPI app codes change.

Here's an illustration of the workflow summary screen:
  ![promote_app-workflow-summary-screenshot1](https://github.com/user-attachments/assets/ae6c75c7-654b-418f-bfca-74351e59f1ea)
#### 6. Test run the `predict_buy_app` using Postman
Finally after Steps 5 or 6, you can test-run the latest-trained ML application via Postman or `curl` command. This is assuming that the the application has been deployed into the K8S cluster from the CD workflow of [Insurance Buying Prediction Application Deployment & Rollback](docs/getting_started_st.md).
<img width="1431" alt="Screenshot 2024-12-03 at 7 50 58 PM" src="https://github.com/user-attachments/assets/6f8fe669-2475-4de9-8c50-8c19b118b0d2">
Or alternatively, run the curl command of:
```bash
curl --location 'http://mlops.ce7-grp-1.sctp-sandbox.com:80/predict' \
--header 'Content-Type: application/json' \
--data \
'{
    "Gender": "Female",
    "Age": 46,
    "HasDrivingLicense": 1,
    "RegionID": 21.0,
    "Switch": 0,
    "PastAccident": "Yes",
    "AnnualPremium": "2305.40"
}'
```
If the appication has not been deployed into the K8S cluster, you can also run the following Bash commands from your local terminal to load and execute the application Docker image from the ECR:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

docker pull <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/ce7-grp-1/<nonprod|prod>/predict_buy_app:latest

docker run -d -p 80:80 predict_buy_app:latest
```
Then you can proceed to test-run the application via Post or `curl` command as mentioned above but replacing the target location URL with that of your local or server host.

[Go to Part B](getting_started_clc-B.md)
