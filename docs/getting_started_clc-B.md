[Go back Part A](getting_started_clc-A.md)

#### Dependencies
The event trigger dependecies of the GitHub Actions workflows can be described as follows:
  ![MLOps CICD Plan](https://github.com/user-attachments/assets/bd768c7e-b205-4e3d-8f6f-431a1ec079d7)
For the ML Python environment dependencies, the following package libraries are required as listed in the `requirements.txt` file:
  ![Screenshot 2024-12-04 at 2 26 03 PM](https://github.com/user-attachments/assets/632a7ba6-e8a6-4c51-b97f-520beebb2931)
#### Project Repo Structure
  |![repo-structure-screenshot1](https://github.com/user-attachments/assets/0abb694f-9581-4e45-ab59-f02d45e77932)|
  ![repo-structure-screenshot2](https://github.com/user-attachments/assets/91e99fee-e5d6-4318-89e8-bb2028ec6c15) |
#### Branching Strategies
The branching strategy adopted in this project is adapted from Trunk-based and GitFlow branching, and can be depicted as follows:
  ![adapted-branching-strategy](https://github.com/user-attachments/assets/29d59e48-0818-4895-b7ea-a9b403ee043e)
#### Main Branch
The production branch is denoted as the Main branch. Only the `Promote Tested App Image` workflow runs here that will promote a (SIT) tested `predict_buy_app` from the Develop branch to the Main branch for production release.
  ![develop-main-branch-cicd-diagram](https://github.com/user-attachments/assets/c7ef152b-897c-4651-8048-4f3ba96945c9)
#### Develop Branch
  ![feature-branch-cicd-diagram](https://github.com/user-attachments/assets/9f21271d-bf15-4fee-96d0-54972e96a209)
#### CICD Pipeline
  ![ci_tf_workflow-screenshot](https://github.com/user-attachments/assets/a1904669-5a34-4980-8422-8ac46a0dc56c)
  ![ci_tf_checkov_output-screenshot](https://github.com/user-attachments/assets/72ee43d8-4819-4dff-b356-e53c73480062)
  ![cd_tf_workflow-screenshot1](https://github.com/user-attachments/assets/0409d9a6-c6f8-42e1-a26f-34e30578fdd8)
  ![cd_tf_workflow_screenshot2](https://github.com/user-attachments/assets/a3a422cb-ab5a-41cd-9ca8-8b6c8dbb2e39)
  ![train_model-workflow-summary-screenshot2](https://github.com/user-attachments/assets/9780aaa1-6dfb-448e-a86d-50e36ab9fd9c)
  ![build_app-workflow-summary-screenshot2](https://github.com/user-attachments/assets/c2d486c7-0dfe-4c1f-bc4c-bcf0c1534bd1)
  ![promote_app-workflow-summary-screenshot2](https://github.com/user-attachments/assets/226ac1e9-875f-414a-b036-10ea14dea1be)
  ![ci_py-pr-trigger-screenshot](https://github.com/user-attachments/assets/85178d62-1813-46d3-bd8f-cf7cd55f199f)
  ![py-flake8-linting-screenshot](https://github.com/user-attachments/assets/9e9d7c47-5fd4-42a5-be3c-00fe36b96cd5)
  ![py-black-formatting-screenshot](https://github.com/user-attachments/assets/7029a197-654c-40e0-bc67-f16f1c72fbd3)
  ![py-snyk-scanning-screenshot](https://github.com/user-attachments/assets/35882bac-bae0-4fea-a292-2784a82fb9f7)
#### Learning Journey
_add what "little secrets" have been learnt that you like to share with others_ 

[Go back Part A](getting_started_clc-A.md)
