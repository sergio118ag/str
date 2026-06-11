package com.str.backend.repository;

import com.str.backend.model.Reward;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RewardRepository
        extends JpaRepository<Reward, Long> {
}