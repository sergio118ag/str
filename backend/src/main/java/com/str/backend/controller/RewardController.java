package com.str.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.Reward;
import com.str.backend.repository.RewardRepository;

@RestController
@RequestMapping("/rewards")
public class RewardController {

    private final RewardRepository rewardRepository;

    public RewardController(
            RewardRepository rewardRepository) {

        this.rewardRepository = rewardRepository;
    }

    @PostMapping
    public Reward createReward(@RequestBody Reward reward) {
        reward.setActive(true);
        return rewardRepository.save(reward);
    }

        // ADMIN - Obtener todas las recompensas (con inactivas)
    @GetMapping("/all")
    public List<Reward> getAllRewards() {
        return rewardRepository.findAll();
    }
    @GetMapping
    public List<Reward> getAllActiveRewards() {
        return rewardRepository.findByActiveTrue();
    }

    // ADMIN - Actualizar recompensa
    @PutMapping("/{id}")
    public Reward updateReward(@PathVariable Long id, @RequestBody Reward updatedReward) {
        Reward reward = rewardRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Recompensa no encontrada"));
        reward.setName(updatedReward.getName());
        reward.setDescription(updatedReward.getDescription());
        reward.setPointsRequired(updatedReward.getPointsRequired());
        reward.setActive(updatedReward.getActive());
        return rewardRepository.save(reward);
    }

    // ADMIN - Eliminar recompensa (borrado lógico)
    @DeleteMapping("/{id}")
    public void deleteReward(@PathVariable Long id) {
        Reward reward = rewardRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Recompensa no encontrada"));
        reward.setActive(false);
        rewardRepository.save(reward);
    }
}