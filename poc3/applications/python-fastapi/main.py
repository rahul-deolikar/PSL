from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from datetime import datetime
import uvicorn
import os

# Create FastAPI instance
app = FastAPI(
    title="POC3 Python FastAPI Hello World",
    description="Complete CI/CD pipeline demonstration with Python FastAPI",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class HealthResponse(BaseModel):
    status: str
    timestamp: str
    service: str
    version: str

class HelloResponse(BaseModel):
    message: str
    timestamp: str
    environment: str
    service: str

class InfoResponse(BaseModel):
    application: str
    version: str
    technologies: list[str]
    description: str
    endpoints: list[dict]

# Root endpoint with HTML response
@app.get("/", response_class=HTMLResponse)
async def root():
    html_content = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>POC3 - Python FastAPI Hello World</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .container {
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                text-align: center;
                max-width: 600px;
                margin: 20px;
            }
            .logo { font-size: 3em; margin-bottom: 20px; }
            h1 { color: #333; margin-bottom: 10px; }
            .subtitle { color: #666; margin-bottom: 30px; }
            .tech-stack {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin: 30px 0;
                flex-wrap: wrap;
            }
            .tech-item {
                background: #f0f0f0;
                padding: 10px 20px;
                border-radius: 25px;
                font-size: 14px;
                color: #555;
            }
            .api-info {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                margin-top: 30px;
                text-align: left;
            }
            .endpoint {
                background: #e9ecef;
                padding: 8px 12px;
                border-radius: 5px;
                font-family: monospace;
                margin: 5px 0;
                display: block;
            }
            .status {
                display: inline-block;
                background: #28a745;
                color: white;
                padding: 5px 15px;
                border-radius: 15px;
                font-size: 12px;
                margin-top: 10px;
            }
            .docs-link {
                background: #007bff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin: 10px 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="logo">🐍</div>
            <h1>POC3 Hello World</h1>
            <div class="subtitle">Python FastAPI Application</div>
            
            <div class="tech-stack">
                <div class="tech-item">Python</div>
                <div class="tech-item">FastAPI</div>
                <div class="tech-item">Uvicorn</div>
                <div class="tech-item">Docker</div>
                <div class="tech-item">AWS ECS</div>
            </div>

            <div class="api-info">
                <h3>🔗 Available API Endpoints</h3>
                <code class="endpoint">GET /health - Health check</code>
                <code class="endpoint">GET /api/hello - Hello world message</code>
                <code class="endpoint">GET /api/info - Application information</code>
                
                <div style="margin-top: 15px;">
                    <strong>🔒 Security Scanning:</strong> SAST, DAST, SCA Enabled<br>
                    <strong>📦 Artifacts:</strong> ECR, JFrog, S3<br>
                    <strong>🚀 Deployment:</strong> Octopus Deploy → AWS ECS
                </div>
                
                <div style="margin-top: 20px;">
                    <a href="/docs" class="docs-link">📚 OpenAPI Docs</a>
                    <a href="/redoc" class="docs-link">📖 ReDoc</a>
                </div>
                
                <span class="status">✅ Active</span>
            </div>
        </div>
    </body>
    </html>
    """
    return html_content

# Health check endpoint
@app.get("/health", response_model=HealthResponse)
async def health_check():
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now().isoformat(),
        service="poc3-python-fastapi",
        version="1.0.0"
    )

# Hello world endpoint
@app.get("/api/hello", response_model=HelloResponse)
async def hello_world():
    return HelloResponse(
        message="Hello World from Python FastAPI POC3!",
        timestamp=datetime.now().isoformat(),
        environment=os.getenv("ENVIRONMENT", "development"),
        service="python-fastapi-api"
    )

# Application info endpoint
@app.get("/api/info", response_model=InfoResponse)
async def app_info():
    return InfoResponse(
        application="POC3 Python FastAPI Hello World",
        version="1.0.0",
        technologies=["Python", "FastAPI", "Uvicorn", "Pydantic"],
        description="Complete CI/CD pipeline demonstration with Python FastAPI",
        endpoints=[
            {"path": "/health", "method": "GET", "description": "Health check"},
            {"path": "/api/hello", "method": "GET", "description": "Hello world message"},
            {"path": "/api/info", "method": "GET", "description": "Application info"},
            {"path": "/docs", "method": "GET", "description": "OpenAPI documentation"},
            {"path": "/redoc", "method": "GET", "description": "ReDoc documentation"}
        ]
    )

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8000")),
        reload=False
    )