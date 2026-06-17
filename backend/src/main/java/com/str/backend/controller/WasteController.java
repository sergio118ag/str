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
import com.str.backend.model.User;
import com.str.backend.model.Waste;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.UserRepository;
import com.str.backend.repository.WasteRepository;

@RestController
@RequestMapping("/waste")
@CrossOrigin(origins = "*")
public class WasteController {

    private final WasteRepository wasteRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    public WasteController(WasteRepository wasteRepository,
                           UserRepository userRepository,
                           EventRepository eventRepository) {
        this.wasteRepository = wasteRepository;
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
    }

    @PostMapping
    public Waste createWaste(@RequestParam Long userId,
                             @RequestParam Long eventId,
                             @RequestParam String location,
                             @RequestParam String type) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Evento no encontrado"));

        Waste waste = new Waste();
        waste.setQrCode("waste-" + System.currentTimeMillis());
        waste.setLocation(location);
        waste.setType(type);
        waste.setRecycled(false);
        waste.setDate(LocalDateTime.now());
        waste.setUser(user);
        waste.setEvent(event);

        return wasteRepository.save(waste);
    }

    @GetMapping
    public List<Waste> getAllWaste() {
        return wasteRepository.findAll();
    }

    @GetMapping("/event/{eventId}")
    public List<Waste> getWasteByEvent(@PathVariable Long eventId) {
        return wasteRepository.findByEventId(eventId);
    }

    @GetMapping("/user/{userId}")
    public List<Waste> getWasteByUser(@PathVariable Long userId) {
        return wasteRepository.findByUserId(userId);
    }

    @GetMapping("/qr/{qrCode}")
    public Waste getWasteByQr(@PathVariable String qrCode) {
        return wasteRepository.findByQrCode(qrCode);
    }

    @PutMapping("/{id}/recycle")
    public Waste markAsRecycled(@PathVariable Long id) {
        Waste waste = wasteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Residuo no encontrado"));
        waste.setRecycled(true);
        return wasteRepository.save(waste);
    }
}