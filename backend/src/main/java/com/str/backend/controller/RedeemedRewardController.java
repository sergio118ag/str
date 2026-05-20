package com.str.backend.controller;

import com.str.backend.model.*;
import com.str.backend.repository.*;
import com.str.backend.service.QrService;

import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/redeemed-rewards")
public class RedeemedRewardController {

    private final RedeemedRewardRepository redeemedRewardRepository;
    private final UserRepository userRepository;
    private final RewardRepository rewardRepository;
    private final QrService qrService;

    public RedeemedRewardController(
            RedeemedRewardRepository redeemedRewardRepository,
            UserRepository userRepository,
            RewardRepository rewardRepository,
            QrService qrService) {

        this.redeemedRewardRepository = redeemedRewardRepository;
        this.userRepository = userRepository;
        this.rewardRepository = rewardRepository;
        this.qrService = qrService;
    }

    @PostMapping("/redeem")
    public RedeemedReward redeemReward(
            @RequestParam Long userId,
            @RequestParam Long rewardId) {

        User user = userRepository.findById(userId)
                .orElseThrow();

        Reward reward = rewardRepository.findById(rewardId)
                .orElseThrow();

        if (user.getPoints() < reward.getPointsRequired()) {
            throw new RuntimeException("No tienes puntos suficientes");
        }

        user.setPoints(
                user.getPoints() - reward.getPointsRequired()
        );

        userRepository.save(user);

        RedeemedReward redeemedReward =
                new RedeemedReward();

        redeemedReward.setUser(user);
        redeemedReward.setReward(reward);

        redeemedReward.setRedeemedAt(
                LocalDateTime.now()
        );

        redeemedReward.setQrCode(
                "reward-" + System.currentTimeMillis()
        );

        redeemedReward.setUsed(false);

        return redeemedRewardRepository.save(
                redeemedReward
        );
    }

    @PostMapping("/use/{id}")
    public RedeemedReward useReward(
            @PathVariable Long id) {

        RedeemedReward reward =
                redeemedRewardRepository
                        .findById(id)
                        .orElseThrow();

        if (reward.isUsed()) {
            throw new RuntimeException(
                    "La recompensa ya fue utilizada"
            );
        }

        reward.setUsed(true);

        reward.setUsedAt(
                LocalDateTime.now()
        );

        return redeemedRewardRepository.save(
                reward
        );
    }

    @GetMapping("/user/{userId}")
    public List<RedeemedReward> getUserRewards(
            @PathVariable Long userId) {

        return redeemedRewardRepository.findByUserId(
                userId
        );
    }

    @GetMapping(
            value = "/qr-image/{id}",
            produces = "image/png"
    )
    public byte[] getQrImage(
            @PathVariable Long id
    ) throws Exception {

        RedeemedReward reward =
                redeemedRewardRepository
                        .findById(id)
                        .orElseThrow();

        return qrService.generateQr(
                reward.getQrCode()
        );
    }
}