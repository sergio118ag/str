package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Waste;

public interface WasteRepository extends JpaRepository<Waste, Long> {
    List<Waste> findByEventId(Long eventId);
    List<Waste> findByUserId(Long userId);
    List<Waste> findByRecycledFalse();
    Waste findByQrCode(String qrCode);
}