[Go back Part A](getting_started_clc-A.md)

#### Dependencies
The event trigger dependecies of the GitHub Actions workflows can be described as follows:
  ![MLOps CICD Plan](https://github.com/user-attachments/assets/bd768c7e-b205-4e3d-8f6f-431a1ec079d7)
For the ML Python environment dependencies, the following package libraries are required as listed in the `requirements.txt` file:
  ![Screenshot 2024-12-04 at 2 26 03 PM](https://github.com/user-attachments/assets/632a7ba6-e8a6-4c51-b97f-520beebb2931)
#### Project Repo Structure
  |  ![repo-structure-screenshot1](https://github.com/user-attachments/assets/bdeb2d4e-dea3-4b3c-9860-cf04d154442d)  |  ![repo-structure-screenshot2](https://github.com/user-attachments/assets/15fca66b-0545-4136-9710-b1c8caca164e)  |
#### Branching Strategies
The branching strategy adopted in this project is adapted from Trunk-based and GitFlow branching, and can be depicted as follows:
  ![adapted-branching-strategy](https://github.com/user-attachments/assets/29d59e48-0818-4895-b7ea-a9b403ee043e)
#### Feature Branch (short-lived)
The Feature branch is "short-lived" and are used by data engineers, data scietntists, application developers and cloud infra engineers for their feature-set by feature-set workstreams.

  ![feature-branch-cicd-diagram](https://github.com/user-attachments/assets/74bc0afd-3b59-4f69-bcc5-5afba0d6cc68)
#### Main and Develop Branches (stable)
The production branch is denoted as the Main branch. Only the `Promote Tested App Image` workflow runs here that will promote a (SIT) tested `predict_buy_app` from the Develop branch to the Main branch for production release. Both the Develop and Main branches are stable branches used for Testing and Production release purposes.

The CICD pipeline workflows spanning between the Develop and Main branches is illustrated as follows:

  ![develop-main-branch-cicd-diagramjScope-Page-6](https://github.com/user-attachments/assets/4c8a7b58-8d6d-4f84-a312-1e3667aed192)
#### CICD Pipeline
  ![ci_tf_workflow-screenshot1](https://github.com/user-attachments/assets/a1904669-5a34-4980-8422-8ac46a0dc56c)
  ![ci_tf_workflow-screenshot2](https://github.com/user-attachments/assets/b174effe-d68e-4979-b6b5-5941dbc7f2a4)
  ![ci_tf_workflow-screenshot3](https://github.com/user-attachments/assets/f7d7e01c-16f1-407c-a292-256290ef7721)
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
Some of the "little secrets" uncovered uin implementing this part of the MLOps Project are:
  - `workflow_run` event trigger of GitHub Actions workflows

    Originally, we wanted to make use of the event trigger of `on: workflow_run workflows: ["Train ML Model"] types: completed branches: feature*` for the `build_app` workflow, however we came to realize that:
    
      > _"This event will only trigger a workflow run if the workflow file is on the default branch."_ which happens to be the Main branch. And having to switch the GitHub default branch between Main and Feature branches was just not feasible.
      > ![gha-workflow_run_event_notes](https://github.com/user-attachments/assets/b3142eb2-30cd-444d-8156-d13dcd633d52)

    So at the end, we decided switching to using the workflow event trigger of `on: pull_request` though it was possible to use `on: workflow_call`.

  - As the process of the developing the project's MLOPs CICD workflow files, it is much easier to code, test and debug each workflow job execution script files without using GitHub Actions first. Especially where appopriate without for Bash shell scripting. Only until the execution scripts are tested working properly then we transfer them into GitHub Actions `.yml files` where we next test on the workflow automated orchestration steps in the GitHub cloud. For this reason, a `Makefile` has been created to make this local development of the CICD workflow script files easier. 

    ![mlops_makefile-screenshot](https://github.com/user-attachments/assets/ca114246-8336-46ac-9bbd-e0fd23537402)

    For example, to help with installing and setting up the Python environment for machine learning and ata science analytics starting from scratch, run `make setup_vv`, `make setup_py` followed by `make setup_dvc`. Or to start the ML model training or post-training testing, run `make train` or `make test`. And to clean up the model training environment fo restart, run `make cleanup`, or to reset the local development environment back to scratch prior to the installation and setup, run `make remove`. Do make sure that the Git repo has been cloned as mentioned in the Getting Started section of this README document beforehand otherwise the `Makefile` does not work.

[Go back Part A](getting_started_clc-A.md)
