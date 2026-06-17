package com.str.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Event;

public interface EventRepository extends JpaRepository<Event, Long> {
    List<Event> findByOrganizerId(Long organizerId);
    List<Event> findByActiveTrue();
    List<Event> findByCategory(String category);
    List<Event> findByActiveTrueAndAvailableGreaterThan(Integer available);
    List<Event> findByOrganizerIdAndActiveTrue(Long organizerId);
    Optional<Event> findByName(String name);
}