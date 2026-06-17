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

import com.str.backend.model.Event;
import com.str.backend.model.Product;
import com.str.backend.repository.EventRepository;
import com.str.backend.repository.ProductRepository;

@RestController
@RequestMapping("/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductRepository productRepository;
    private final EventRepository eventRepository;

    public ProductController(ProductRepository productRepository, EventRepository eventRepository) {
        this.productRepository = productRepository;
        this.eventRepository = eventRepository;
    }

    @GetMapping("/event/{eventId}")
    public List<Product> getProductsByEvent(@PathVariable Long eventId) {
        return productRepository.findByEventId(eventId);
    }

    @PostMapping
    public Product createProduct(@RequestBody Product product, @RequestParam Long eventId) {
        Event event = eventRepository.findById(eventId)
            .orElseThrow(() -> new RuntimeException("Evento no encontrado"));
        product.setEvent(event);
        return productRepository.save(product);
    }

    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable Long id, @RequestBody Product updatedProduct) {
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        product.setName(updatedProduct.getName());
        product.setDescription(updatedProduct.getDescription());
        product.setPrice(updatedProduct.getPrice());
        product.setStock(updatedProduct.getStock());
        product.setCategory(updatedProduct.getCategory());
        return productRepository.save(product);
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        productRepository.deleteById(id);
    }
}