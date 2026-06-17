package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.Reward;

public interface RewardRepository extends JpaRepository<Reward, Long> {
        List<Reward> findByActiveTrue();
}