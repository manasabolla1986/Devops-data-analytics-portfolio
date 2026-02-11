package com.example.app;

import com.example.app.model.Product;
import com.example.app.service.ProductRepository;
import com.example.app.service.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ApplicationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductService productService;

    @BeforeEach
    void setUp() {
        productRepository.deleteAll();
    }

    // ========== Unit Tests ==========

    @Test
    void contextLoads() {
        assertNotNull(productService);
        assertNotNull(productRepository);
    }

    @Test
    void shouldCreateProduct() {
        Product product = new Product("Test Widget", 19.99, "A test product");
        Product saved = productService.createProduct(product);

        assertNotNull(saved.getId());
        assertEquals("Test Widget", saved.getName());
        assertEquals(19.99, saved.getPrice());
    }

    @Test
    void shouldRetrieveAllProducts() {
        productService.createProduct(new Product("Widget A", 10.00, "Desc A"));
        productService.createProduct(new Product("Widget B", 20.00, "Desc B"));

        assertEquals(2, productService.getAllProducts().size());
    }

    @Test
    void shouldUpdateProduct() {
        Product product = productService.createProduct(new Product("Old Name", 5.00, "Old"));
        Product updated = productService.updateProduct(product.getId(), new Product("New Name", 9.99, "New"));

        assertEquals("New Name", updated.getName());
        assertEquals(9.99, updated.getPrice());
    }

    @Test
    void shouldDeleteProduct() {
        Product product = productService.createProduct(new Product("Delete Me", 1.00, "Temp"));
        productService.deleteProduct(product.getId());

        assertTrue(productService.getProductById(product.getId()).isEmpty());
    }

    // ========== Integration Tests (REST API) ==========

    @Test
    void healthEndpointShouldReturn200() throws Exception {
        mockMvc.perform(get("/api/products/health"))
               .andExpect(status().isOk())
               .andExpect(content().string("OK"));
    }

    @Test
    void shouldCreateAndRetrieveProductViaApi() throws Exception {
        String productJson = """
                {
                    "name": "API Widget",
                    "price": 29.99,
                    "description": "Created via API"
                }
                """;

        mockMvc.perform(post("/api/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(productJson))
               .andExpect(status().isCreated())
               .andExpect(jsonPath("$.name").value("API Widget"))
               .andExpect(jsonPath("$.price").value(29.99));

        mockMvc.perform(get("/api/products"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$[0].name").value("API Widget"));
    }

    @Test
    void shouldReturn404ForMissingProduct() throws Exception {
        mockMvc.perform(get("/api/products/999"))
               .andExpect(status().isNotFound());
    }

    @Test
    void actuatorHealthShouldBeUp() throws Exception {
        mockMvc.perform(get("/actuator/health"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.status").value("UP"));
    }
}
