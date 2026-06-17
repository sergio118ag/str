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
@Table(name = "incidents")
public class Incident {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;
    private String type; // "RESIDUO", "COMPORTAMIENTO", "OTRO"
    private String status; // "PENDIENTE", "RESUELTO", "CERRADO"
    private LocalDateTime date;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // Usuario responsable

    @ManyToOne
    @JoinColumn(name = "staff_id")
    private User staff; // Staff que registró la incidencia

    @ManyToOne
    @JoinColumn(name = "event_id")
    private Event event;

    private Integer pointsPenalty; // Penalización en puntos

    public Incident() {}

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public User getStaff() { return staff; }
    public void setStaff(User staff) { this.staff = staff; }

    public Event getEvent() { return event; }
    public void setEvent(Event event) { this.event = event; }

    public Integer getPointsPenalty() { return pointsPenalty; }
    public void setPointsPenalty(Integer pointsPenalty) { this.pointsPenalty = pointsPenalty; }
}