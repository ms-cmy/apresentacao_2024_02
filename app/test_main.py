import pytest
from app.main import app


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_health_response(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.data == b'OK'
    return 