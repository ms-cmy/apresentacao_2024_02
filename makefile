run:
	GOOGLE_APPLICATION_CREDENTIALS=key.json  python app/main.py

install_requirements:
	pip install -r app/requirements.txt