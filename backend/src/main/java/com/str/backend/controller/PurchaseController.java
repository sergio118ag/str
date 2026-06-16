package com.str.backend.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Event;
import com.str.backend.model.Purchase;
import com.str.backend.model.Ticket;
import com.str.backend.model.User;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.PurchaseRepository;
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

    public PurchaseController(
            PurchaseRepository purchaseRepository,
            UserRepository userRepository,
            EventRepository eventRepository,
            TicketRepository ticketRepository,
            QrService qrService) {

        this.purchaseRepository = purchaseRepository;
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
        this.ticketRepository = ticketRepository;
        this.qrService = qrService;
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

        ticket.setAvailable(ticket.getAvailable() - 1);
        ticketRepository.save(ticket);

        Purchase purchase = new Purchase();
        purchase.setUser(user);
        purchase.setEvent(ticket.getEvent());
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
}