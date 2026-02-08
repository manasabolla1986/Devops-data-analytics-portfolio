package com.example;

public class Application {
    
    public static void main(String[] args) {
        Application app = new Application();
        String message = app.getGreeting();
        System.out.println(message);
    }
    
    public String getGreeting() {
        return "Hello from Java CI/CD Demo!";
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
}
