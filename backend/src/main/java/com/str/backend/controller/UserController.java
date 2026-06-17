package com.str.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.str.backend.dto.LoginRequest;
import com.str.backend.model.User;
import com.str.backend.repository.UserRepository;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*")
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

    // Obtener todos los usuarios (incluye roles)
    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Obtener todos los usuarios con roles (para admin)
    @GetMapping("/all")
    public List<User> getAllUsersWithRoles() {
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

    @PutMapping("/{id}")
    public User updateUser(
            @PathVariable Long id,
            @RequestBody User updatedUser) {

        User user = userRepository.findById(id)
                .orElseThrow();

        user.setName(updatedUser.getName());
        user.setEmail(updatedUser.getEmail());
        user.setAddress(updatedUser.getAddress());
        user.setPostalCode(updatedUser.getPostalCode());
        user.setCity(updatedUser.getCity());
        user.setAge(updatedUser.getAge());
        user.setPhone(updatedUser.getPhone());

        return userRepository.save(user);
    }

    // ADMIN - Cambiar rol de usuario
    @PutMapping("/{id}/role")
    public User updateUserRole(@PathVariable Long id, @RequestParam String role) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        user.setRole(role);
        return userRepository.save(user);
    }

    // ADMIN - Eliminar usuario (borrado físico)
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        userRepository.deleteById(id);
    }
}