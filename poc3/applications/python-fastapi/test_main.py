import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_root():
    """Test the root endpoint returns HTML"""
    response = client.get("/")
    assert response.status_code == 200
    assert "text/html" in response.headers["content-type"]
    assert "POC3 Hello World" in response.text

def test_health_check():
    """Test the health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "poc3-python-fastapi"
    assert data["version"] == "1.0.0"
    assert "timestamp" in data

def test_hello_world():
    """Test the hello world endpoint"""
    response = client.get("/api/hello")
    assert response.status_code == 200
    data = response.json()
    assert "Hello World from Python FastAPI POC3!" in data["message"]
    assert data["service"] == "python-fastapi-api"
    assert "timestamp" in data

def test_app_info():
    """Test the application info endpoint"""
    response = client.get("/api/info")
    assert response.status_code == 200
    data = response.json()
    assert data["application"] == "POC3 Python FastAPI Hello World"
    assert data["version"] == "1.0.0"
    assert "Python" in data["technologies"]
    assert "FastAPI" in data["technologies"]
    assert len(data["endpoints"]) >= 4

def test_openapi_docs():
    """Test that OpenAPI docs are accessible"""
    response = client.get("/docs")
    assert response.status_code == 200
    
def test_redoc():
    """Test that ReDoc is accessible"""
    response = client.get("/redoc")
    assert response.status_code == 200