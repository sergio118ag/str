package com.str.backend.controller;

import com.str.backend.model.Event;
import com.str.backend.model.Ticket;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.TicketRepository;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tickets")
public class TicketController {

    private final TicketRepository ticketRepository;
    private final EventRepository eventRepository;

    public TicketController(
            TicketRepository ticketRepository,
            EventRepository eventRepository) {

        this.ticketRepository = ticketRepository;
        this.eventRepository = eventRepository;
    }

    @PostMapping
    public Ticket createTicket(
            @RequestParam Long eventId,
            @RequestParam String name,
            @RequestParam Double price,
            @RequestParam Integer available) {

        Event event = eventRepository.findById(eventId).orElseThrow();

        Ticket ticket = new Ticket();
        ticket.setName(name);
        ticket.setPrice(price);
        ticket.setAvailable(available);
        ticket.setEvent(event);

        return ticketRepository.save(ticket);
    }

    @GetMapping
    public List<Ticket> getAllTickets() {
        return ticketRepository.findAll();
    }

    @GetMapping("/event/{eventId}")
    public List<Ticket> getTicketsByEvent(@PathVariable Long eventId) {
        return ticketRepository.findByEventId(eventId);
    }
}