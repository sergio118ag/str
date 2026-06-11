package com.str.backend.repository;

import com.str.backend.model.RedeemedReward;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RedeemedRewardRepository
        extends JpaRepository<RedeemedReward, Long> {

    List<RedeemedReward> findByUserId(Long userId);
}