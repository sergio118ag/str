package com.str.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.str.backend.model.RedeemedReward;

public interface RedeemedRewardRepository
        extends JpaRepository<RedeemedReward, Long> {

    List<RedeemedReward> findByUserId(Long userId);
    
    RedeemedReward findByQrCode(String qrCode);
}