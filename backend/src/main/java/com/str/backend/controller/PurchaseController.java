package com.str.backend.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Event;
import com.str.backend.model.Purchase;
import com.str.backend.model.RedeemedReward;
import com.str.backend.model.Ticket;
import com.str.backend.model.User;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.PurchaseRepository;
import com.str.backend.repository.RedeemedRewardRepository;
import com.str.backend.repository.TicketRepository;
import com.str.backend.repository.UserRepository;
import com.str.backend.service.QrService;

@RestController
@RequestMapping("/purchases")
public class PurchaseController {

    private final PurchaseRepository purchaseRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final TicketRepository ticketRepository;
    private final QrService qrService;
    private final RedeemedRewardRepository redeemedRewardRepository;

    public PurchaseController(
            PurchaseRepository purchaseRepository,
            UserRepository userRepository,
            EventRepository eventRepository,
            TicketRepository ticketRepository,
            QrService qrService,
            RedeemedRewardRepository redeemedRewardRepository) {

        this.purchaseRepository = purchaseRepository;
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
        this.ticketRepository = ticketRepository;
        this.qrService = qrService;
        this.redeemedRewardRepository = redeemedRewardRepository;
    }

    @PostMapping
    public Purchase createPurchase(
            @RequestParam Long userId,
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
        purchase.setUsed(false);
        purchase.setQrCode("purchase-" + System.currentTimeMillis());

        return purchaseRepository.save(purchase);
    }

    @PostMapping("/ticket")
    public Purchase buyTicket(
            @RequestParam Long userId,
            @RequestParam Long ticketId) {

        User user = userRepository.findById(userId).orElseThrow();
        Ticket ticket = ticketRepository.findById(ticketId).orElseThrow();

        if (ticket.getAvailable() <= 0) {
            throw new RuntimeException("No quedan entradas disponibles");
        }

        // 1. Reducir stock del ticket
        ticket.setAvailable(ticket.getAvailable() - 1);
        ticketRepository.save(ticket);

        // 2. Actualizar el aforo del evento
        Event event = ticket.getEvent();
        event.setAvailable(event.getAvailable() - 1);
        eventRepository.save(event);

        // 3. Crear la compra
        Purchase purchase = new Purchase();
        purchase.setUser(user);
        purchase.setEvent(event);
        purchase.setTicket(ticket);
        purchase.setProductName(ticket.getName());
        purchase.setPrice(ticket.getPrice());
        purchase.setDate(LocalDateTime.now());
        purchase.setUsed(false);
        purchase.setQrCode("ticket-" + System.currentTimeMillis());

        return purchaseRepository.save(purchase);
    }

    @GetMapping
    public List<Purchase> getAll() {
        return purchaseRepository.findAll();
    }

    @GetMapping("/user/{userId}")
    public List<Purchase> getPurchasesByUser(@PathVariable Long userId) {
        return purchaseRepository.findByUser_Id(userId);
    }

    @GetMapping("/qr")
    public Purchase getByQr(@RequestParam String qrCode) {
        return purchaseRepository.findByQrCode(qrCode);
    }

    @GetMapping(value = "/qr-image/{id}", produces = "image/png")
    public byte[] getQrImage(@PathVariable Long id) throws Exception {
        Purchase purchase = purchaseRepository.findById(id).orElseThrow();
        return qrService.generateQr(purchase.getQrCode());
    }

    @GetMapping("/event/{eventId}/attendees")
    public List<User> getAttendeesByEvent(@PathVariable Long eventId) {
        List<Purchase> purchases = purchaseRepository.findByEventId(eventId);
        return purchases.stream()
            .map(Purchase::getUser)
            .distinct()
            .collect(Collectors.toList());
    }

    // Validar QR de entrada (para Staff)
    @GetMapping("/validate/{qrCode}")
    public Purchase validateQR(@PathVariable String qrCode) {
        Purchase purchase = purchaseRepository.findByQrCode(qrCode);
        
        if (purchase == null) {
            throw new RuntimeException("QR no válido");
        }
        
        if (purchase.getUsed()) {
            throw new RuntimeException("Esta entrada ya ha sido utilizada");
        }
        
        purchase.setUsed(true);
        purchaseRepository.save(purchase);
        
        return purchase;
    }

    // Validar QR de recompensa (para Staff)
    @GetMapping("/validate-reward/{qrCode}")
    public RedeemedReward validateRewardQR(@PathVariable String qrCode) {
        RedeemedReward reward = redeemedRewardRepository.findByQrCode(qrCode);
        
        if (reward == null) {
            throw new RuntimeException("QR no válido");
        }
        
        if (reward.isUsed()) {
            throw new RuntimeException("Esta recompensa ya ha sido utilizada");
        }
        
        reward.setUsed(true);
        reward.setUsedAt(LocalDateTime.now());
        redeemedRewardRepository.save(reward);
        
        return reward;
    }

    // Obtener compra por QR (sin validar)
    @GetMapping("/info/{qrCode}")
    public Purchase getPurchaseByQR(@PathVariable String qrCode) {
        Purchase purchase = purchaseRepository.findByQrCode(qrCode);
        
        if (purchase == null) {
            throw new RuntimeException("QR no válido");
        }
        
        return purchase;
    }
}