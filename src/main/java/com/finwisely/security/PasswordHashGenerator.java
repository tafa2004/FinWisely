package com.finwisely.security;

import java.util.Scanner;

public class PasswordHashGenerator {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter a test password: ");
        String password = scanner.nextLine();

        String hashedPassword = SecurityUtils.hashPassword(password);

        System.out.println("\nBCrypt Hash:");
        System.out.println(hashedPassword);

        scanner.close();
    }
}
