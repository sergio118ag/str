package com.str.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PruebaController {

    @GetMapping("/prueba")
    public String prueba() {
        return "El backend funciona";
    }
}