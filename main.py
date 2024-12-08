from flask import Flask

app = Flask(__name__)

@app.route('/health')
def health():
    return 'OK'

@app.route('/')
def hello():
    return 'Hello, World!'