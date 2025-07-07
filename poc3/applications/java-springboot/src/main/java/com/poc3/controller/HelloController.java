package com.poc3.controller;

import com.poc3.model.HelloResponse;
import com.poc3.model.InfoResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * REST Controller for POC3 Java Spring Boot Hello World endpoints
 */
@RestController
public class HelloController {

    @Value("${spring.application.name:poc3-java-springboot}")
    private String applicationName;

    @Value("${app.version:1.0.0}")
    private String version;

    @Value("${spring.profiles.active:development}")
    private String environment;

    /**
     * Root endpoint serving HTML page
     */
    @GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)
    public String home() {
        return """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>POC3 - Java Spring Boot Hello World</title>
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="logo">☕</div>
                    <h1>POC3 Hello World</h1>
                    <div class="subtitle">Java Spring Boot Application</div>
                    
                    <div class="tech-stack">
                        <div class="tech-item">Java 17</div>
                        <div class="tech-item">Spring Boot</div>
                        <div class="tech-item">Maven</div>
                        <div class="tech-item">Docker</div>
                        <div class="tech-item">AWS ECS</div>
                    </div>

                    <div class="api-info">
                        <h3>🔗 Available API Endpoints</h3>
                        <code class="endpoint">GET /actuator/health - Health check</code>
                        <code class="endpoint">GET /api/hello - Hello world message</code>
                        <code class="endpoint">GET /api/info - Application information</code>
                        <code class="endpoint">GET /actuator - Spring Boot Actuator</code>
                        
                        <div style="margin-top: 15px;">
                            <strong>🔒 Security Scanning:</strong> SAST, DAST, SCA Enabled<br>
                            <strong>📦 Artifacts:</strong> ECR, JFrog, S3<br>
                            <strong>🚀 Deployment:</strong> Octopus Deploy → AWS ECS
                        </div>
                        
                        <span class="status">✅ Active</span>
                    </div>
                </div>
            </body>
            </html>
            """;
    }

    /**
     * Hello world endpoint
     */
    @GetMapping("/api/hello")
    public ResponseEntity<HelloResponse> hello() {
        HelloResponse response = new HelloResponse(
            "Hello World from Java Spring Boot POC3!",
            LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME),
            environment,
            "java-springboot-api"
        );
        return ResponseEntity.ok(response);
    }

    /**
     * Application information endpoint
     */
    @GetMapping("/api/info")
    public ResponseEntity<InfoResponse> info() {
        Map<String, String> endpoint1 = new HashMap<>();
        endpoint1.put("path", "/actuator/health");
        endpoint1.put("method", "GET");
        endpoint1.put("description", "Health check via Spring Boot Actuator");

        Map<String, String> endpoint2 = new HashMap<>();
        endpoint2.put("path", "/api/hello");
        endpoint2.put("method", "GET");
        endpoint2.put("description", "Hello world message");

        Map<String, String> endpoint3 = new HashMap<>();
        endpoint3.put("path", "/api/info");
        endpoint3.put("method", "GET");
        endpoint3.put("description", "Application information");

        Map<String, String> endpoint4 = new HashMap<>();
        endpoint4.put("path", "/actuator");
        endpoint4.put("method", "GET");
        endpoint4.put("description", "Spring Boot Actuator endpoints");

        InfoResponse response = new InfoResponse(
            "POC3 Java Spring Boot Hello World",
            version,
            Arrays.asList("Java 17", "Spring Boot", "Maven", "Spring Boot Actuator"),
            "Complete CI/CD pipeline demonstration with Java Spring Boot",
            Arrays.asList(endpoint1, endpoint2, endpoint3, endpoint4)
        );
        
        return ResponseEntity.ok(response);
    }
}