package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Purchase;

public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    Purchase findByQrCode(String qrCode);
    
    List<Purchase> findByUser_Id(Long userId);
    
    List<Purchase> findByEventId(Long eventId);
}