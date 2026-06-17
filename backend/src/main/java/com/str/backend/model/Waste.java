package com.str.backend.model;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "waste")
public class Waste {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String qrCode;
    private String location;
    private String type; // "PLÁSTICO", "VIDRIO", "PAPEL", "ORGÁNICO", "OTRO"
    private Boolean recycled;
    private LocalDateTime date;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // Usuario que generó el residuo

    @ManyToOne
    @JoinColumn(name = "event_id")
    private Event event;

    public Waste() {}

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Boolean getRecycled() { return recycled; }
    public void setRecycled(Boolean recycled) { this.recycled = recycled; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Event getEvent() { return event; }
    public void setEvent(Event event) { this.event = event; }
}