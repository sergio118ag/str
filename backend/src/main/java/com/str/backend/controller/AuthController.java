package com.str.backend.controller;

import com.str.backend.model.User;
import com.str.backend.repository.UserRepository;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@CrossOrigin
public class AuthController {

    private final UserRepository userRepository;

    public AuthController(
            UserRepository userRepository
    ) {

        this.userRepository = userRepository;
    }

    @PostMapping("/login")
    public User login(
            @RequestParam String email
    ) {

        return userRepository
                .findByEmail(email)
                .orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );
    }
}