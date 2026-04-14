package com.str.backend.controller;

import com.str.backend.model.*;
import com.str.backend.repository.*;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/purchases")
public class PurchaseController {

    private final PurchaseRepository purchaseRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    public PurchaseController(PurchaseRepository purchaseRepository,
                              UserRepository userRepository,
                              EventRepository eventRepository) {
        this.purchaseRepository = purchaseRepository;
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
    }

    @PostMapping
    public Purchase createPurchase(@RequestParam Long userId,
                                   @RequestParam Long eventId,
                                   @RequestParam String productName,
                                   @RequestParam Double price) {

        User user = userRepository.findById(userId).orElseThrow();
        Event event = eventRepository.findById(eventId).orElseThrow();

        Purchase purchase = new Purchase();
        purchase.setUser(user);
        purchase.setEvent(event);
        purchase.setProductName(productName);
        purchase.setPrice(price);
        purchase.setDate(LocalDateTime.now());

        return purchaseRepository.save(purchase);
    }

    @GetMapping
    public List<Purchase> getAll() {
        return purchaseRepository.findAll();
    }
}