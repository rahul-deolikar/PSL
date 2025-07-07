package com.poc3;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * POC3 Java Spring Boot Hello World Application
 * 
 * This application demonstrates a complete CI/CD pipeline with:
 * - Spring Boot REST APIs
 * - Health checks via Actuator
 * - Docker containerization
 * - Security scanning (SAST, DAST, SCA)
 * - Artifact storage in ECR/JFrog
 * - Deployment via Octopus Deploy to AWS ECS
 */
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}