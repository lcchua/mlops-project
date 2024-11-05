
setup_vv:
	python3 -m venv venv
	export "PATH=$(pwd)/venv/bin:$PATH"

setup_py:
	source venv/bin/activate
	python3 -m pip install --upgrade pip
	pip install -r requirements.txt

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
	rm -f models/model.pkl

remove:
	rm -rf venv
	dvc destroy -fq
