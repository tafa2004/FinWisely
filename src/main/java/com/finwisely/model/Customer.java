package com.finwisely.model;

import java.time.LocalDateTime;

public class Customer {

    private int customerId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String nationalId;
    private LocalDateTime dateCreated;

    // Constructor
    public Customer(int customerId, String firstName,
                    String lastName, String email,
                    String phone, String nationalId,
                    LocalDateTime dateCreated) {

        this.customerId = customerId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.nationalId = nationalId;
        this.dateCreated = dateCreated;
    }

    // Getters
    public int getCustomerId() {
        return customerId;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getNationalId() {
        return nationalId;
    }

    public LocalDateTime getDateCreated() {
        return dateCreated;
    }
}