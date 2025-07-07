package com.poc3.model;

/**
 * Response model for hello world endpoint
 */
public class HelloResponse {
    private String message;
    private String timestamp;
    private String environment;
    private String service;

    public HelloResponse() {
    }

    public HelloResponse(String message, String timestamp, String environment, String service) {
        this.message = message;
        this.timestamp = timestamp;
        this.environment = environment;
        this.service = service;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }
}