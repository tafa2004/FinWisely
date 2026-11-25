-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: finwisely
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `account_type` varchar(20) NOT NULL,
  `balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`account_id`),
  KEY `fk_accounts_customer` (`customer_id`),
  CONSTRAINT `fk_accounts_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_account_type` CHECK ((`account_type` in (_utf8mb4'Savings',_utf8mb4'Current'))),
  CONSTRAINT `chk_balance` CHECK ((`balance` >= 0)),
  CONSTRAINT `chk_status` CHECK ((`status` in (_utf8mb4'ACTIVE',_utf8mb4'FROZEN',_utf8mb4'CLOSED')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,1,'Savings',4500.00,'ACTIVE'),(2,2,'Current',10000.00,'ACTIVE'),(3,3,'Savings',4500.00,'ACTIVE'),(4,4,'Current',22000.00,'ACTIVE'),(5,5,'Savings',7000.00,'ACTIVE');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `record_id` int DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,'root@localhost','INSERT','transactions',1,'2026-11-24 15:48:16'),(2,'root@localhost','INSERT','transactions',2,'2026-11-24 15:48:16'),(3,'root@localhost','INSERT','transactions',3,'2026-11-24 15:48:16'),(4,'root@localhost','INSERT','transactions',4,'2026-11-24 15:48:16'),(5,'root@localhost','INSERT','transactions',5,'2026-11-24 15:48:16'),(6,'root@localhost','INSERT','transactions',6,'2026-11-24 15:48:16'),(7,'root@localhost','INSERT','transactions',7,'2026-11-24 15:48:16'),(8,'root@localhost','INSERT','transactions',8,'2026-11-24 15:48:16'),(9,'root@localhost','INSERT','transactions',9,'2026-11-24 15:48:16'),(10,'root@localhost','INSERT','transactions',10,'2026-11-24 15:48:16');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `national_id` varchar(20) NOT NULL,
  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `national_id` (`national_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'John','Banda','johnbanda@email.com','+260967788948','789011/24/1','2026-11-24 15:48:16'),(2,'Mary','Phiri','maryphiri@email.com','+260971674589','346712/29/1','2026-11-24 15:48:16'),(3,'Brian','Tembo','briantembo@email.com','+260954906754','345690/23/1','2026-11-24 15:48:16'),(4,'Grace','Mwansa','gracemwansa@email.com','+260578452345','265783/45/1','2026-11-24 15:48:16'),(5,'Peter','Zulu','peterzulu@email.com','+260960137469','107449/29/1','2026-11-24 15:48:16');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `transaction_type` varchar(20) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `performed_by` varchar(50) NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `fk_transactions_account` (`account_id`),
  CONSTRAINT `fk_transactions_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_amount` CHECK ((`amount` > 0)),
  CONSTRAINT `chk_txn_type` CHECK ((`transaction_type` in (_utf8mb4'DEPOSIT',_utf8mb4'WITHDRAWAL',_utf8mb4'TRANSFER')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,'DEPOSIT',5000.00,'2026-11-24 15:48:16','teller'),(2,2,'DEPOSIT',12000.00,'2026-11-24 15:48:16','teller'),(3,3,'DEPOSIT',3000.00,'2026-11-24 15:48:16','teller'),(4,4,'DEPOSIT',25000.00,'2026-11-24 15:48:16','teller'),(5,5,'DEPOSIT',8000.00,'2026-11-24 15:48:16','teller'),(6,1,'WITHDRAWAL',500.00,'2026-11-24 15:48:16','teller'),(7,2,'WITHDRAWAL',2000.00,'2026-11-24 15:48:16','teller'),(8,3,'DEPOSIT',1500.00,'2026-11-24 15:48:16','teller'),(9,4,'TRANSFER',3000.00,'2026-11-24 15:48:16','teller'),(10,5,'WITHDRAWAL',1000.00,'2026-11-24 15:48:16','teller');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-24 17:58:58
