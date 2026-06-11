package com.str.backend.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "events")
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String location;
    private Double ticketPrice;
    private Integer capacity;
    private String eventDate;

    @ManyToMany(mappedBy = "events")
    private Set<User> users;

    public Event() {}

    public Event(String name, String description, String location, Double ticketPrice, Integer capacity, String eventDate) {
        this.name = name;
        this.description = description;
        this.location = location;
        this.ticketPrice = ticketPrice;
        this.capacity = capacity;
        this.eventDate = eventDate;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
    
    public Double getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(Double ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }
}