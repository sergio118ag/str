package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Incident;

public interface IncidentRepository extends JpaRepository<Incident, Long> {
    List<Incident> findByEventId(Long eventId);
    List<Incident> findByUserId(Long userId);
    List<Incident> findByStaffId(Long staffId);
    List<Incident> findByStatus(String status);
}