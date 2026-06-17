package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Product;

public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByEventId(Long eventId);
    List<Product> findByEventIdAndStockGreaterThan(Long eventId, Integer stock);
}