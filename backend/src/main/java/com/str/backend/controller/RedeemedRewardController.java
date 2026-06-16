package com.str.backend.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.model.RedeemedReward;
import com.str.backend.model.Reward;
import com.str.backend.model.User;
import com.str.backend.repository.RedeemedRewardRepository;
import com.str.backend.repository.RewardRepository;
import com.str.backend.repository.UserRepository;
import com.str.backend.service.QrService;

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
    public User redeemReward(
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

        RedeemedReward redeemedReward = new RedeemedReward();
        redeemedReward.setUser(user);
        redeemedReward.setReward(reward);
        redeemedReward.setRedeemedAt(LocalDateTime.now());
        redeemedReward.setQrCode("reward-" + System.currentTimeMillis());
        redeemedReward.setUsed(false);
        
        redeemedRewardRepository.save(redeemedReward);
        
        return user;
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