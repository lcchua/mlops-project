
get_data:
	python3 dataset.py

run:
	python3 main.py

test:
	python3 -m pytest
		
clean:
	rm -rf steps/__pycache__
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf tests/__pycache__
	rm -f data/*.csv

remove:
	rm -rf venv
	dvc destroy -fq
