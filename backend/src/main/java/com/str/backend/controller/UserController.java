package com.str.backend.controller;

import com.str.backend.model.User;
import com.str.backend.repository.UserRepository;
import org.springframework.web.bind.annotation.*;
import com.str.backend.dto.LoginRequest;

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
    
    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) {
        return userRepository.findById(id).orElseThrow();
    }

    @PostMapping("/{id}/add-points")
    public User addPoints(@PathVariable Long id,
                        @RequestParam Integer amount) {

        User user = userRepository.findById(id).orElseThrow();

        user.setPoints(user.getPoints() + amount);

        return userRepository.save(user);
    }

    @PostMapping("/{id}/remove-points")
    public User removePoints(@PathVariable Long id,
                            @RequestParam Integer amount) {

        User user = userRepository.findById(id).orElseThrow();

        int newPoints = user.getPoints() - amount;

        if (newPoints < 0) {
            newPoints = 0;
        }

        user.setPoints(newPoints);

        return userRepository.save(user);
    }

    @PostMapping("/login")
    public User login(
            @RequestBody LoginRequest request) {

        User user = userRepository
                .findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new RuntimeException("Usuario no encontrado")
                );

        if (!user.getPassword().equals(
                request.getPassword())) {

            throw new RuntimeException(
                    "Contraseña incorrecta"
            );
        }

        return user;
    }
}