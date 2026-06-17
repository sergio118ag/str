package com.str.backend.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Reward {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    private Integer pointsRequired;

    public Reward() {
    }

    public Reward(String name,
                  String description,
                  Integer pointsRequired) {

        this.name = name;
        this.description = description;
        this.pointsRequired = pointsRequired;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getPointsRequired() {
        return pointsRequired;
    }

    public void setPointsRequired(Integer pointsRequired) {
        this.pointsRequired = pointsRequired;
    }
    private Boolean active = true;

    public Boolean getActive() { return active; }
    
    public void setActive(Boolean active) { this.active = active; }
}