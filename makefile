
# NOTE THAT setup_vv, setup_py and setup_dvc unlike the targets
# are only run from the command-line interactively and not in the
# GitHub Actions workflows.

setup_vv:
	python3 -m venv venv
	export "PATH=$(pwd)/venv/bin:$PATH"
	echo "!!! Make sure to run 'source venv/bin/activate' next before 'make setup_py'"

setup_py:
	python3 -m pip install --upgrade pip
	pip install -r requirements.txt

setup_dvc:
	dvc init
	git add .
	git commit -m "initialise dvc tracking"
	git push

train:
	python3 main.py

test:
	python3 -m pytest
		
cleanup:
	rm -rf steps/__pycache__
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf tests/__pycache__
	rm -f data/*.csv
	rm -f data/*.csv.dvc
	rm -f models/model.pkl
	rm -f models/*.pkl.dvc
	aws s3 rm s3://ce7-grp-1-bucket/DVC_artefacts/files/ --recursive

remove:
	rm -rf venv
	dvc destroy -fq
	rm -rf .dvc
