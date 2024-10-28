# Omitted Python virtual environment creation in this project
 python = venv/bin/python
 pip = venv/bin/pip

setup:
	python3 -m venv venv
	$(python) -m pip install --upgrade pip
	$(pip) install -r requirements.txt

get_data:
	source venv/bin/activate
	$(python) dataset.py
	venv/bin/deactivate

run:
	source venv/bin/activate
	$(python) main.py
	venv/bin/deactivate

test:
	source venv/bin/activate
	$(python) -m pytest
	venv/bin/deactivate
		
clean:
	rm -rf steps/__pycache__
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf tests/__pycache__
	rm data/*.csv

remove:
	rm -rf venv
	dvc destroy -f
