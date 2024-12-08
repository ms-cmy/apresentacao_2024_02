run:
	GOOGLE_APPLICATION_CREDENTIALS=key.json  python app/main.py

test:
	GOOGLE_APPLICATION_CREDENTIALS=key.json  pytest app/

install_requirements:
	pip install -r app/requirements.txt