package com.str.backend.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Event;
import com.str.backend.model.Incident;
import com.str.backend.model.User;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.IncidentRepository;
import com.str.backend.repository.UserRepository;

@RestController
@RequestMapping("/incidents")
@CrossOrigin(origins = "*")
public class IncidentController {

    private final IncidentRepository incidentRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    public IncidentController(IncidentRepository incidentRepository,
                              UserRepository userRepository,
                              EventRepository eventRepository) {
        this.incidentRepository = incidentRepository;
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
    }

    @PostMapping
    public Incident createIncident(@RequestParam Long userId,
                                   @RequestParam Long staffId,
                                   @RequestParam Long eventId,
                                   @RequestParam String title,
                                   @RequestParam String description,
                                   @RequestParam String type,
                                   @RequestParam(required = false) Integer pointsPenalty) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        User staff = userRepository.findById(staffId)
                .orElseThrow(() -> new RuntimeException("Staff no encontrado"));
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Evento no encontrado"));

        Incident incident = new Incident();
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setType(type);
        incident.setStatus("PENDIENTE");
        incident.setDate(LocalDateTime.now());
        incident.setUser(user);
        incident.setStaff(staff);
        incident.setEvent(event);
        incident.setPointsPenalty(pointsPenalty != null ? pointsPenalty : 0);

        // Si hay penalización, restar puntos al usuario
        if (pointsPenalty != null && pointsPenalty > 0) {
            int newPoints = user.getPoints() - pointsPenalty;
            if (newPoints < 0) newPoints = 0;
            user.setPoints(newPoints);
            userRepository.save(user);
        }

        return incidentRepository.save(incident);
    }

    @GetMapping
    public List<Incident> getAllIncidents() {
        return incidentRepository.findAll();
    }

    @GetMapping("/event/{eventId}")
    public List<Incident> getIncidentsByEvent(@PathVariable Long eventId) {
        return incidentRepository.findByEventId(eventId);
    }

    @GetMapping("/user/{userId}")
    public List<Incident> getIncidentsByUser(@PathVariable Long userId) {
        return incidentRepository.findByUserId(userId);
    }

    @PutMapping("/{id}/status")
    public Incident updateStatus(@PathVariable Long id, @RequestParam String status) {
        Incident incident = incidentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Incidencia no encontrada"));
        incident.setStatus(status);
        return incidentRepository.save(incident);
    }
}