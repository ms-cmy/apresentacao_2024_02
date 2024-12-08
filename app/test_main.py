import pytest
from utils.model_necessary.preprocessing import *
import __main__
__main__.KMeansTransformer = KMeansTransformer
from main import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_health_response(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.data == b'OK'
    return

def test_predict_with_all_data(client):
    data = {'fare': '50', 'age': '30', 'sex': 'male', 'alone': '1'}
    response = client.post('/predict', data=data)
    assert response.status_code == 200