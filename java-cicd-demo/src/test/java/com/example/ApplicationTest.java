package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ApplicationTest {
    
    @Test
    public void testGetGreeting() {
        Application app = new Application();
        String greeting = app.getGreeting();
        assertEquals("Hello from Java CI/CD Demo!", greeting);
    }
    
    @Test
    public void testAdd() {
        Application app = new Application();
        assertEquals(5, app.add(2, 3));
        assertEquals(0, app.add(-1, 1));
        assertEquals(-5, app.add(-2, -3));
    }
    
    @Test
    public void testMultiply() {
        Application app = new Application();
        assertEquals(6, app.multiply(2, 3));
        assertEquals(0, app.multiply(0, 5));
        assertEquals(-10, app.multiply(-2, 5));
    }
}
