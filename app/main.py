from flask import Flask, render_template, request, jsonify
from utils.model_necessary.preprocessing import *
from io import BytesIO
import pandas as pd
from utils.cloud.io import read_file_from_gcs
from google.cloud import pubsub_v1
import logging
import joblib
import json

logger = logging.getLogger(__name__)
app = Flask(__name__)


model_bytes = read_file_from_gcs("gs://us_central_1_bucket/models/aula_quinta_modelo_titanic_arvore/model.pkl")
bytes_container = BytesIO(model_bytes)
model = joblib.load(bytes_container)

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project="silicon-garage-438603-m6", topic='topic-project-titanic') 

# def send_pubsub(data):
#     topic_path = pub_sub_client.topic_path('gcp_project_id', 'topic_name')
#     data = data.encode('utf-8')
#     future = pub_sub_client.publish(topic_path, data)
#     return future.result()

@app.route('/health')
def health():
    return 'OK'

@app.route('/predict', methods=['POST'])
def predict():
    name = request.form['name'] if request.form.get('name') != '' else 'Não informado'
    fare = float(request.form['fare']) if request.form.get('fare') != '' else 30
    age = int(request.form.get('age', 25)) if request.form.get('age') != '' else 25
    sex = request.form['sex'] 
    alone = int(request.form['alone'])
    new_data = pd.DataFrame([[sex, fare, age, alone]], columns=['sex', 'fare', 'age', 'alone'])
    output = model.predict(new_data)[0]
    proba = model.predict_proba(new_data)[0]
    input_data = {
            'SEX': sex, 
            'FARE': fare, 
            'AGE': age, 
            'ALONE': alone
        }
    input_data = str(input_data)
    data = {
        'NOME': name,
        'INPUTS': input_data,
        'CHANCE_SOBREVIVER': float(proba[1]),  
    }
    data_str = json.dumps(data).encode('utf-8')  
    future = publisher.publish(topic_path, data=data_str)
    print(f'Published message ID: {future.result()}')
    return render_template('result.html', prediction=int(output))

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        parameter = request.form['parameter']
        return render_template('result.html', parameter=parameter)
    else:
        return render_template('index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)