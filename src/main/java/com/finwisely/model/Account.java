package com.finwisely.model;

import java.math.BigDecimal;

public class Account {

    // Account attributes
    private int accountId;
    private int customerId;
    private String accountType;
    private BigDecimal balance;
    private String status;

    // Constructor
    public Account(int accountId, int customerId,
                   String accountType, BigDecimal balance,
                   String status) {

        this.accountId = accountId;
        this.customerId = customerId;
        this.accountType = accountType;
        this.balance = balance;
        this.status = status;
    }

    // Getters
    public int getAccountId() {
        return accountId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public String getAccountType() {
        return accountType;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public String getStatus() {
        return status;
    }

    // Setters
    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}