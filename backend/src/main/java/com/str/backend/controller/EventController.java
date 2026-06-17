package com.str.backend.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Event;
import com.str.backend.model.Purchase;
import com.str.backend.model.User;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.PurchaseRepository;
import com.str.backend.repository.UserRepository;

@RestController
@RequestMapping("/events")
@CrossOrigin(origins = "*")
public class EventController {

    private final EventRepository eventRepository;
    private final UserRepository userRepository;
    private final PurchaseRepository purchaseRepository;

    public EventController(EventRepository eventRepository, UserRepository userRepository, PurchaseRepository purchaseRepository) {
        this.eventRepository = eventRepository;
        this.userRepository = userRepository;
        this.purchaseRepository = purchaseRepository;
    }

    @PostMapping
    public Event createEvent(@RequestBody Event event, @RequestParam Long organizerId) {
        User organizer = userRepository.findById(organizerId)
            .orElseThrow(() -> new RuntimeException("Organizador no encontrado"));
        
        event.setOrganizer(organizer);
        event.setActive(true);
        event.setAvailable(event.getCapacity());
        
        return eventRepository.save(event);
    }

    @GetMapping
    public List<Event> getAllEvents() {
        return eventRepository.findByActiveTrue();
    }

    @GetMapping("/{id}")
    public Event getEventById(@PathVariable Long id) {
        return eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
    }

    @GetMapping("/organizer/{organizerId}")
    public List<Event> getEventsByOrganizer(@PathVariable Long organizerId) {
        return eventRepository.findByOrganizerIdAndActiveTrue(organizerId);
    }

    @GetMapping("/{id}/stats")
    public Map<String, Object> getEventStats(@PathVariable Long id) {
        Event event = eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
        
        List<Purchase> purchases = purchaseRepository.findByEventId(id);
        
        long totalAttendees = purchases.stream().map(Purchase::getUser).distinct().count();
        int totalTicketsSold = purchases.size();
        double totalRevenue = purchases.stream().mapToDouble(Purchase::getPrice).sum();
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("eventName", event.getName());
        stats.put("totalAttendees", totalAttendees);
        stats.put("totalTicketsSold", totalTicketsSold);
        stats.put("totalRevenue", totalRevenue);
        stats.put("capacity", event.getCapacity());
        stats.put("available", event.getAvailable());
        
        return stats;
    }

    @PutMapping("/{id}")
    public Event updateEvent(@PathVariable Long id, @RequestBody Event updatedEvent) {
        Event event = eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
        
        event.setName(updatedEvent.getName());
        event.setDescription(updatedEvent.getDescription());
        event.setLocation(updatedEvent.getLocation());
        event.setTicketPrice(updatedEvent.getTicketPrice());
        event.setCapacity(updatedEvent.getCapacity());
        event.setEventDate(updatedEvent.getEventDate());
        event.setImageUrl(updatedEvent.getImageUrl());
        event.setCategory(updatedEvent.getCategory());
        
        return eventRepository.save(event);
    }

    @DeleteMapping("/{id}")
    public void deleteEvent(@PathVariable Long id) {
        Event event = eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
        event.setActive(false);
        eventRepository.save(event);
    }

    @PutMapping("/{id}/capacity")
    public Event updateCapacity(@PathVariable Long id, @RequestParam Integer newCapacity) {
        Event event = eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
        
        event.setCapacity(newCapacity);
        if (event.getAvailable() > newCapacity) {
            event.setAvailable(newCapacity);
        }
        
        return eventRepository.save(event);
    }
    @GetMapping("/staff/{staffId}")
    public List<Event> getEventsByStaff(@PathVariable Long staffId) {
        return eventRepository.findByActiveTrue();
    }
}