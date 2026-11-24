package com.finwisely.dao;

import com.finwisely.config.DatabaseConnection;
import com.finwisely.model.Customer;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

class CustomerDAOTest {

    @Test
    void shouldRetrieveCustomerById() throws SQLException {

        CustomerDAO customerDAO = new CustomerDAO();

        try (Connection connection = DatabaseConnection.getConnection()) {

            Customer customer = customerDAO.getCustomerById(connection, 1001);

            assertNotNull(customer, "Customer should exist");
            assertEquals("John", customer.getFirstName());
            assertEquals("Banda", customer.getLastName());

            System.out.println("Customer retrieved successfully!");
            System.out.println("Name: " + customer.getFirstName()
                    + " " + customer.getLastName());
            System.out.println("Email: " + customer.getEmail());
        }
    }
}