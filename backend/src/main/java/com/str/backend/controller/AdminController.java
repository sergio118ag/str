package com.str.backend.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Event;
import com.str.backend.model.Purchase;
import com.str.backend.model.User;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.PurchaseRepository;
import com.str.backend.repository.UserRepository;

@RestController
@RequestMapping("/admin/stats")
@CrossOrigin(origins = "*")
public class AdminController {

    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final PurchaseRepository purchaseRepository;

    public AdminController(UserRepository userRepository,
                           EventRepository eventRepository,
                           PurchaseRepository purchaseRepository) {
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
        this.purchaseRepository = purchaseRepository;
    }

    @GetMapping("/dashboard")
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // Usuarios
        List<User> allUsers = userRepository.findAll();
        long totalUsers = allUsers.size();
        long totalAsistentes = allUsers.stream()
            .filter(u -> "asistente".equals(u.getRole()))
            .count();
        long totalOrganizadores = allUsers.stream()
            .filter(u -> "event_manager".equals(u.getRole()))
            .count();
        long totalStaff = allUsers.stream()
            .filter(u -> "staff".equals(u.getRole()))
            .count();
        long totalAdmins = allUsers.stream()
            .filter(u -> "admin".equals(u.getRole()))
            .count();

        // Eventos
        List<Event> allEvents = eventRepository.findAll();
        long totalEvents = allEvents.size();
        long activeEvents = allEvents.stream().filter(Event::getActive).count();

        // Compras
        List<Purchase> allPurchases = purchaseRepository.findAll();
        long totalPurchases = allPurchases.size();
        double totalRevenue = allPurchases.stream()
            .mapToDouble(Purchase::getPrice)
            .sum();

        // Puntos totales
        int totalPoints = allUsers.stream()
            .mapToInt(User::getPoints)
            .sum();

        stats.put("totalUsers", totalUsers);
        stats.put("totalAsistentes", totalAsistentes);
        stats.put("totalOrganizadores", totalOrganizadores);
        stats.put("totalStaff", totalStaff);
        stats.put("totalAdmins", totalAdmins);
        stats.put("totalEvents", totalEvents);
        stats.put("activeEvents", activeEvents);
        stats.put("totalPurchases", totalPurchases);
        stats.put("totalRevenue", totalRevenue);
        stats.put("totalPoints", totalPoints);

        return stats;
    }
}