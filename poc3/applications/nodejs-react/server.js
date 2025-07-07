const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'poc3-nodejs-react',
    version: '1.0.0'
  });
});

// API endpoints
app.get('/api/hello', (req, res) => {
  res.json({
    message: 'Hello World from Node.js/React POC3!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    service: 'nodejs-react-api'
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    application: 'POC3 Node.js/React Hello World',
    version: '1.0.0',
    technologies: ['Node.js', 'Express', 'React'],
    description: 'Complete CI/CD pipeline demonstration',
    endpoints: [
      { path: '/health', method: 'GET', description: 'Health check' },
      { path: '/api/hello', method: 'GET', description: 'Hello world message' },
      { path: '/api/info', method: 'GET', description: 'Application info' }
    ]
  });
});

// Serve React app for all other routes
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`🚀 POC3 Node.js/React app listening on port ${PORT}`);
  console.log(`📍 Health check: http://localhost:${PORT}/health`);
  console.log(`🌐 API endpoint: http://localhost:${PORT}/api/hello`);
});

module.exports = app;