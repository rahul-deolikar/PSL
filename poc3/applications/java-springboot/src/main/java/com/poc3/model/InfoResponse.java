package com.poc3.model;

import java.util.List;
import java.util.Map;

/**
 * Response model for application info endpoint
 */
public class InfoResponse {
    private String application;
    private String version;
    private List<String> technologies;
    private String description;
    private List<Map<String, String>> endpoints;

    public InfoResponse() {
    }

    public InfoResponse(String application, String version, List<String> technologies, 
                       String description, List<Map<String, String>> endpoints) {
        this.application = application;
        this.version = version;
        this.technologies = technologies;
        this.description = description;
        this.endpoints = endpoints;
    }

    public String getApplication() {
        return application;
    }

    public void setApplication(String application) {
        this.application = application;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public List<String> getTechnologies() {
        return technologies;
    }

    public void setTechnologies(List<String> technologies) {
        this.technologies = technologies;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Map<String, String>> getEndpoints() {
        return endpoints;
    }

    public void setEndpoints(List<Map<String, String>> endpoints) {
        this.endpoints = endpoints;
    }
}