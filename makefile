# Omitted Python virtual environment creation in this project
# python = venv/bin/python
# pip = venv/bin/pip

setup:
#	python3 -m venv venv
#	$(python) -m pip install --upgrade pip
#	$(pip) install -r requirements.txt
	python3 -m pip install --upgrade pip
	pip install -r requirements.txt

get_data:
#	$(python) dataset.py
	python3 src_ml/dataset.py

run:
#	$(python) main.py
	python3 src_ml/main.py

test:
#	$(python) -m pytest
	python3 -m pytest
		
clean:
	rm -rf steps/__pycache__
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf tests/__pycache__

remove:
#	rm -rf venv
#	rm -rf mlruns
	dvc destroy
