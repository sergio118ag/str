package com.str.backend.controller;

import com.str.backend.model.User;
import com.str.backend.repository.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Crear usuario
    @PostMapping
    public User createUser(@RequestBody User user) {
        return userRepository.save(user);
    }

    // Obtener todos
    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}