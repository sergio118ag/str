package com.str.backend.controller;

import com.str.backend.model.Reward;
import com.str.backend.repository.RewardRepository;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/rewards")
public class RewardController {

    private final RewardRepository rewardRepository;

    public RewardController(
            RewardRepository rewardRepository) {

        this.rewardRepository = rewardRepository;
    }

    @PostMapping
    public Reward createReward(
            @RequestBody Reward reward) {

        return rewardRepository.save(reward);
    }

    @GetMapping
    public List<Reward> getAllRewards() {

        return rewardRepository.findAll();
    }
}