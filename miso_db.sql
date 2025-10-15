-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: miso_db
-- ------------------------------------------------------
-- Server version	8.0.40

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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,1,'Nomer R. Alvez','San Antonio, Zambales','nomeralvez@gmail.com','09123456789','000000000','IT Supervisor Officer','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','2024-12-31 16:00:00','2024-12-31 16:00:00'),(2,2,'Jeffrey J. Culanag','Duhat Stree, Gordon Height','jeffculanag@gmail.com','09995556321','000000001','OJT','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','2025-04-03 03:55:50','2025-04-03 03:55:50'),(3,3,'Gian Carlo Anonat','Balic-Balic, Gordon Heights','giancarloanonat@gmail.com','09991234567','000000002','OJT','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','2025-04-03 03:57:57','2025-04-03 03:57:57'),(4,4,'Genie Rose V. Vicente','Gordon Height','genievicente@gmail.com','09999123455','000000003','Department Manager III','Accounting Department','Rm. 214, Bldg. 229, Waterfront Road, Subic Bay Freeport Zone','2025-04-03 04:17:13','2025-04-03 04:17:13');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrow_notifications`
--

DROP TABLE IF EXISTS `borrow_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrow_notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `notified_to` bigint NOT NULL,
  `notified_by` bigint DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow_notifications`
--

LOCK TABLES `borrow_notifications` WRITE;
/*!40000 ALTER TABLE `borrow_notifications` DISABLE KEYS */;
INSERT INTO `borrow_notifications` VALUES (1,1,1,' requested a borrow equipment Laptop','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 04:00:14','2025-04-03 04:00:14'),(2,2,1,' requested a borrow equipment Laptop','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 04:00:14','2025-04-03 04:00:14'),(3,1,3,'Gian Carlo Anonat requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":1,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:12:45','2025-04-03 04:12:45'),(4,2,3,'Gian Carlo Anonat requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":1,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:12:45','2025-04-03 04:12:45'),(5,3,3,'you requested borrow equipmentQP812AA#11','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":1,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:12:45','2025-04-03 04:12:45'),(6,1,3,'Gian Carlo Anonat requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":2,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:13:30','2025-04-03 04:13:30'),(7,2,3,'Gian Carlo Anonat requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":2,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:13:30','2025-04-03 04:13:30'),(8,3,3,'you requested borrow equipmentQP812AA#11','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":2,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 04:13:30','2025-04-03 04:13:30'),(9,1,4,'Genie Rose V. Vicente requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":3,\"is_read\":0,\"created_by\":4}',0,'2025-04-03 04:18:57','2025-04-03 04:18:57'),(10,2,4,'Genie Rose V. Vicente requested a borrow equipment ','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":3,\"is_read\":0,\"created_by\":4}',0,'2025-04-03 04:18:57','2025-04-03 04:18:57'),(11,3,4,'you requested borrow equipmentQP812AA#11','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":3,\"is_read\":0,\"created_by\":4}',0,'2025-04-03 04:18:57','2025-04-03 04:18:57'),(12,4,4,'you requested borrow equipmentQP812AA#11','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":3,\"is_read\":0,\"created_by\":4}',0,'2025-04-03 04:18:57','2025-04-03 04:18:57'),(13,1,1,' requested a borrow equipment monitor','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":2,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:56:51','2025-04-03 05:56:51'),(14,2,1,' requested a borrow equipment monitor','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":2,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:56:51','2025-04-03 05:56:51'),(15,1,1,' requested a borrow equipment touch screen tv','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":3,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:58:17','2025-04-03 05:58:17'),(16,2,1,' requested a borrow equipment touch screen tv','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":3,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:58:17','2025-04-03 05:58:17'),(17,1,1,' requested a borrow equipment projector','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":4,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:59:34','2025-04-03 05:59:34'),(18,2,1,' requested a borrow equipment projector','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":4,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 05:59:34','2025-04-03 05:59:34'),(19,1,1,' requested a borrow equipment mouse','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":5,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:00:53','2025-04-03 06:00:53'),(20,2,1,' requested a borrow equipment mouse','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":5,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:00:53','2025-04-03 06:00:53'),(21,1,1,' requested a borrow equipment keyboard','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":6,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:01:42','2025-04-03 06:01:42'),(22,2,1,' requested a borrow equipment keyboard','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":6,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:01:42','2025-04-03 06:01:42'),(23,1,3,'Gian Carlo Anonat requested a borrow equipment DWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":4,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:17:05','2025-04-03 06:17:05'),(24,2,3,'Gian Carlo Anonat requested a borrow equipment DWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":4,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:17:05','2025-04-03 06:17:05'),(25,3,3,'you requested borrow equipmentDWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":4,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:17:05','2025-04-03 06:17:05'),(26,4,3,'you requested borrow equipmentDWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":4,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:17:05','2025-04-03 06:17:05'),(27,1,1,' you updated the equipment status GFWU3621','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":6,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:20:52','2025-04-03 06:20:52'),(28,2,1,' you updated the equipment status GFWU3621','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":6,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:20:52','2025-04-03 06:20:52'),(29,1,3,'Gian Carlo Anonat requested a borrow equipment JHEI62347','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":5,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:21:34','2025-04-03 06:21:34'),(30,2,3,'Gian Carlo Anonat requested a borrow equipment JHEI62347','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":5,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:21:34','2025-04-03 06:21:34'),(31,3,3,'you requested borrow equipmentJHEI62347','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":5,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:21:34','2025-04-03 06:21:34'),(32,4,3,'you requested borrow equipmentJHEI62347','{\"module_type\":\"App\\\\Models\\\\Borrow\",\"module_id\":5,\"is_read\":0,\"created_by\":3}',0,'2025-04-03 06:21:34','2025-04-03 06:21:34'),(33,1,1,' you updated the equipment status QP812AA#11','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:47:12','2025-04-03 06:47:12'),(34,2,1,' you updated the equipment status QP812AA#11','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:47:12','2025-04-03 06:47:12'),(35,1,1,' you updated the equipment status QP812AA#11','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:47:30','2025-04-03 06:47:30'),(36,2,1,' you updated the equipment status QP812AA#11','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":1,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 06:47:30','2025-04-03 06:47:30'),(37,1,1,' you updated the equipment status DWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":2,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 16:12:06','2025-04-03 16:12:06'),(38,2,1,' you updated the equipment status DWH@1CA2','{\"module_type\":\"App\\\\Models\\\\Equipment\",\"module_id\":2,\"is_read\":0,\"created_by\":1}',0,'2025-04-03 16:12:06','2025-04-03 16:12:06');
/*!40000 ALTER TABLE `borrow_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrows`
--

DROP TABLE IF EXISTS `borrows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrows` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint DEFAULT NULL,
  `equipment_id` bigint NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL,
  `purpose` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_borrow` date NOT NULL,
  `date_return` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrows`
--

LOCK TABLES `borrows` WRITE;
/*!40000 ALTER TABLE `borrows` DISABLE KEYS */;
INSERT INTO `borrows` VALUES (1,3,1,'Gian Carlo Anonat','000000002','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','Laptop','HP','Pavilion p2 Series','QP812AA#11','OJT','09991234567',1,'I want to borrow','2025-04-03','2025-04-30','2025-04-03 04:12:45','2025-04-03 04:12:45'),(2,3,1,'Gian Carlo Anonat','000000002','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','Laptop','HP','Pavilion p2 Series','QP812AA#11','OJT','09991234567',1,'I want to borrow again for personal use','2025-04-03','2025-04-30','2025-04-03 04:13:30','2025-04-03 04:13:30'),(3,4,1,'Genie Rose V. Vicente','000000003','Accounting Department','Rm. 214, Bldg. 229, Waterfront Road, Subic Bay Freeport Zone','Laptop','HP','Pavilion p2 Series','QP812AA#11','Department Manager III','09999123455',1,'For presentation use','2025-04-03','2025-04-30','2025-04-03 04:18:57','2025-04-03 04:18:57'),(4,3,2,'Gian Carlo Anonat','000000002','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','monitor','DELL','DELL s2','DWH@1CA2','OJT','09991234567',1,'Borrow','2025-04-03','2025-04-30','2025-04-03 06:17:05','2025-04-03 06:17:05'),(5,3,5,'Gian Carlo Anonat','000000002','Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','mouse','ZUES','S5','JHEI62347','OJT','09991234567',1,'Test','2025-04-03','2025-04-30','2025-04-03 06:21:34','2025-04-03 06:21:34');
/*!40000 ALTER TABLE `borrows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendars`
--

DROP TABLE IF EXISTS `calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendars` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `place` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `time_from` time NOT NULL,
  `time_to` time NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendars`
--

LOCK TABLES `calendars` WRITE;
/*!40000 ALTER TABLE `calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `office_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tell_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Management Information Systems Office','2/F, Bldg. N, Quezon Road, Central Business District, Subic Bay Freeport Zone, Philippines 2222','(63-47) 252.4471','(63-47) 252.4388','2025-04-03 03:53:30','2025-04-03 03:53:30'),(2,'Accounting Department','Rm. 214, Bldg. 229, Waterfront Road, Subic Bay Freeport Zone','+6347.252.4045','','2025-04-03 04:15:42','2025-04-03 04:15:42'),(3,'Accreditation Office / Regulatory Monitoring Unit','/F Regulatory Bldg. Labitan Street, corner Rizal Highway, Subic Bay Freeport Zone, Philippines 2222','(63-47) 252.4088',NULL,'2025-04-03 04:24:18','2025-04-03 04:24:18'),(5,'Airport Department','Passenger Terminal Building 8015, Argonaut Highway, Subic Bay Freeport Zone','+6347.252.3131',NULL,'2025-04-03 04:32:00','2025-04-03 04:32:00'),(6,'Labor Department','Room 116, Bldg. 255, Barryman Road, Subic Bay Freeport Zone','+6347.252.4494','+6347.252.4494','2025-04-03 04:32:37','2025-04-03 04:32:37'),(7,'Land & Asset Development Department','Bldg. 332, Burgos Street, Subic Bay Freeport Zone','+6347.252.4479','+6347.252.4715','2025-04-03 04:33:12','2025-04-03 04:33:12'),(8,'Law Enforcement Department','Building No. 657, 1st Floor, Burgos Street, Subic Bay Freeport Zone','+6347.252.4550','+6347.252.4667','2025-04-03 04:33:58','2025-04-03 04:33:58'),(9,'Legal Department','Departments > Legal Department Room 203-207 Bldg. 255 Barryman Road , Subic Bay Freeport Zone','+6347.252.4783-86','+6347.252.4780','2025-04-03 04:34:35','2025-04-03 04:34:35'),(10,'Planning and Development Office','2/F, Bldg. 662, Taft St., Central Business District, Subic Bay Freeport Zone','(63-47) 252.4077','(63-47) 252.4098','2025-04-03 04:35:13','2025-04-03 04:35:13'),(11,'Procurement and Property Management Department','Rm. 201, Bldg. 255, Barryman Road, Central Business District, Subic Bay Freeport Zone','No.:	+6347.252.4214','+6347.252.4284','2025-04-03 04:35:54','2025-04-03 04:35:54'),(12,'Public Health & Safety Department','Bldg. 280, Dewey Avenue, Central Business District, Subic Bay Freeport Zone','+6347.252.4106','+6347.252.4106','2025-04-03 04:36:36','2025-04-03 04:36:36'),(13,'Public Relations Office','Rm. 105 Bldg. 255, Barryman St., Subic Bay Freeport Zone','+6347.252.4368','+6347.252.4000','2025-04-03 04:37:14','2025-04-03 04:37:14'),(14,'Board Secretariat','Room 113, Bldg. 229, Waterfront Road, Subic Bay Freeport Zone','(63-47) 252.4173','(63-47) 252.4170','2025-04-03 04:38:42','2025-04-03 04:38:42'),(15,'Building Permit and Safety Department','2/F, Regulatory Building Labitan Street, corner Rizal Highway, Subic Bay Freeport Zone','+6347.252.4723','+6347.252.4015','2025-04-03 04:41:15','2025-04-03 04:41:15'),(16,'Business and Investment Department (BID) for General Business','Room 104, Building 662, Taft Street, Central Business District, Subic Bay Freeport Zone','+6347.252.4397',NULL,'2025-04-03 04:42:36','2025-04-03 04:42:36'),(17,'Business and Investment Department (BID) for Information and Communications Technology (ICT)','Bldg. 662, Taft Street','+6347.252.4215',NULL,'2025-04-03 04:46:32','2025-04-03 04:46:32'),(18,'Business and Investment Department (BID) for Leisure','Room 128, Bldg. 225, Dewey Ave., Subic Bay Freeport','+6347.252.4331','+6347.252.4023','2025-04-03 04:49:07','2025-04-03 04:49:07'),(19,'Business and Investment Department (BID) for Logistics','Room 120, Bldg. 225, Dewey Avenue, Central Business District, Subic Bay Freeport Zone','+6347.252.4626','+6347.252.4216','2025-04-03 04:50:42','2025-04-03 04:50:42'),(20,'Business and Investment Department (BID) for Manufacturing and Maritime','Room 104, Bldg. 225, Dewey Avenue, Central Business District, Subic Bay Freeport Zone','+6347.252.4632','+6347.252.4633','2025-04-03 04:52:06','2025-04-03 04:52:06'),(21,'Maintenance & Transportation Department','Lot 69 Transportation Bldg., Canal Road, Subic Bay Freeport Zone','+6347.252.4802','+6347.252.4072','2025-04-03 04:54:09','2025-04-03 04:54:09'),(22,'Media Production Department','Rm. 105-B, Bldg. 255, Barryman Road, Subic Bay Freeport Zone','+6347.252.4014','+6347.252.4279','2025-04-03 04:54:58','2025-04-03 04:54:58'),(23,'Motor Vehicle Registration Office','Ground Floor, Regulatory Building, Rizal Highway corner Labitan Street, Subic Bay Freeport Zone','+6347.252.4249',NULL,'2025-04-03 04:55:41','2025-04-03 04:55:41'),(24,'Seaport Department','New Seaport Administration Building, Waterfront Road corner Sampson Road, Subic Bay Freeport Zone, Philippines 2222','+6347.252.4225',NULL,'2025-04-03 04:56:27','2025-04-03 04:56:27'),(25,'Telecommunications Department','SBMA Regulatory Building, Labitan St. corner Rizal Ave., Subic Bay Freeport Zone','+6347.252.429','+6347.252.4449','2025-04-03 04:57:13','2025-04-03 04:57:13'),(26,'Total Quality Management Office','G/F, Seaport Admin Bldg., Waterfront Road, Subic Bay Freeport Zone','+6347.252.4026','+6347.252.4024','2025-04-03 04:57:53','2025-04-03 04:57:53'),(27,'Tourism Department','2/F, Subic Bay Exhibition & Convention Center, Efficiency Road Subic Bay Gateway Park, Subic Bay Freeport Zone','+6347.252.4655','+6347.252.4194','2025-04-03 04:58:31','2025-04-03 04:58:31'),(28,'Trade Facilitation & Compliance Department','Seaport Administration Building Central Business District, Subic Bay Freeport Zone','+6347.252.4361','+6347.252.4360','2025-04-03 04:59:11','2025-04-03 04:59:11'),(29,'Treasury Department','Bldg. 229, Waterfront Road, Central Business District, Subic Bay Freeport Zone','+6347.252.4050','+6347.252.4051','2025-04-03 05:01:29','2025-04-03 05:01:29'),(30,'Utilities Department','Rm. 224, Bldg. 255 Barryman Road, Subic Bay Freeport Zone','+6347.252.4577','+6347.252.4713','2025-04-03 05:05:48','2025-04-03 05:05:48'),(31,'Visa Processing Office','Second (2nd) Floor Subic Regulatory Bldg., Labitan Street corner Rizal Avenue, Subic Bay Freeport Zone','(63-47) 252.4257','(63-47) 252.4203','2025-04-03 05:08:52','2025-04-03 05:08:52'),(32,'Ecology Center','Regulatory Building, Rizal Highway corner Labitan Street, Subic Bay Freeport Zone','+6347.252.4656',NULL,'2025-04-03 05:09:39','2025-04-03 05:09:39'),(33,'Engineering Department','Rm. 228, Bldg. 255 Barryman Road, Subic Bay Freeport Zone','(63-47) 252.4713','(63-47) 252.4713','2025-04-03 05:11:21','2025-04-03 05:11:21');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo` longtext COLLATE utf8mb4_unicode_ci,
  `property_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `condition` tinyint NOT NULL,
  `availability` tinyint NOT NULL,
  `registered_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'Laptop','HP','Pavilion p2 Series','uploads/photos/9b945iAdZOkKNqY7qve9aN0qy5BYaau13JSQe8bh.png','QP812AA#11','MYL12345678',1,2,'2025-01-01','2025-04-03 04:00:14','2025-04-03 06:47:30'),(2,'monitor','DELL','DELL s2','uploads/photos/KxofkYOu9tJ6Q1dvjIirpx5yA7C4y9XUm39ihso9.jpg','DWH@1CA2','MWFJ2134',1,2,'2025-04-03','2025-04-03 05:56:51','2025-04-03 16:12:06'),(3,'touch screen tv','LG','S4','uploads/photos/14wWR9Wu0uNn9ebwLXo8BOx6g9bBT6SqtUdwAian.jpg','SJFDU2134','ASHH232485',1,1,'2025-04-03','2025-04-03 05:58:17','2025-04-03 05:58:17'),(4,'projector','EPSON','S1','uploads/photos/NJBXNjUoxc1owMQYYxis8OTZMNULUxxO788i47rh.png','GHFY23652','HFE7481',1,1,'2025-04-03','2025-04-03 05:59:34','2025-04-03 05:59:34'),(5,'mouse','ZUES','S5','uploads/photos/bjrcAcQrgEl2cpzwqMiBfWuFO1NU83JNs0yk1Yrr.jpg','JHEI62347','HASH1243',1,1,'2025-04-03','2025-04-03 06:00:53','2025-04-03 06:00:53'),(6,'keyboard','LOGITECH','SV5','uploads/photos/bDQBaI8tLjCYwnWfa6GnCJwjqxm9MB10lQtrx0Xu.png','GFWU3621','HSDU24721',1,2,'2025-04-03','2025-04-03 06:01:42','2025-04-03 06:20:52');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_resets_table',1),(3,'2019_08_19_000000_create_failed_jobs_table',1),(4,'2019_12_14_000001_create_personal_access_tokens_table',1),(5,'2025_02_09_031122_create_equipment_table',1),(6,'2025_02_12_115054_create_borrows_table',1),(7,'2025_02_14_142541_create_accounts_table',1),(8,'2025_03_02_025813_create_notification_table',1),(9,'2025_03_10_054436_create_track_equipment_table',1),(10,'2025_03_30_083912_create_calendars_table',1),(11,'2025_03_31_035632_create_departments_table',1),(12,'2025_04_01_045510_create_borrow_notifications_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (1,'App\\Models\\User',1,'eMISO-App-Token','ed3bb4ddaa6adf851f3cbc87324f4d0ca33eec0170b7dbbb262b3ead09413c6b','[\"*\"]','2025-04-03 03:58:02','2025-04-03 03:52:05','2025-04-03 03:58:02'),(2,'App\\Models\\User',3,'eMISO-App-Token','4ad91b53ef6723aa117c9b0720d451042b0233dd276a0ad49d370f21f5b88593','[\"*\"]','2025-04-03 03:58:26','2025-04-03 03:58:22','2025-04-03 03:58:26'),(3,'App\\Models\\User',1,'eMISO-App-Token','630fc383a6dfc0932989bad75c93897fc681a9b519672d04208ea2805b2cb99d','[\"*\"]','2025-04-03 04:00:20','2025-04-03 03:58:35','2025-04-03 04:00:20'),(4,'App\\Models\\User',3,'eMISO-App-Token','146645715a563e0cde552087dd9e33b84395d78d64c1538e86c9310e53bc06f0','[\"*\"]','2025-04-03 04:14:11','2025-04-03 04:00:34','2025-04-03 04:14:11'),(5,'App\\Models\\User',1,'eMISO-App-Token','3b63871cc3addd0135d95ff2fd91cc7e831e829d41930fa7e34a4652de62c919','[\"*\"]','2025-04-03 04:17:16','2025-04-03 04:14:20','2025-04-03 04:17:16'),(6,'App\\Models\\User',4,'eMISO-App-Token','338204ba72ba3c992a4a36098597b39797cd757a8b951cf1637829c0eefe9d21','[\"*\"]','2025-04-03 04:18:59','2025-04-03 04:17:28','2025-04-03 04:18:59'),(7,'App\\Models\\User',1,'eMISO-App-Token','8750f64f3a2b82a4e0a69e5a4c8de30a577f6e09abedbe160315b6d1f41f5fd5','[\"*\"]','2025-04-03 05:16:54','2025-04-03 04:19:08','2025-04-03 05:16:54'),(8,'App\\Models\\User',3,'eMISO-App-Token','51f7f1e59d5a9c6b766c54c4d9b9ff485cf1090505ac010c3cfaedf93c82367c','[\"*\"]','2025-04-03 05:27:15','2025-04-03 05:17:08','2025-04-03 05:27:15'),(9,'App\\Models\\User',1,'eMISO-App-Token','cf7c2b819e9cc0b5aad9f74dd9dc27fd1fbb9c9d6c581e7868a5c162d36f1f64','[\"*\"]','2025-04-03 05:27:35','2025-04-03 05:27:23','2025-04-03 05:27:35'),(10,'App\\Models\\User',3,'eMISO-App-Token','eaa8bc7caacb2b5a6c354b992a464ddaa3a296d12dc643bf44833b3fb03ca702','[\"*\"]','2025-04-03 05:27:55','2025-04-03 05:27:49','2025-04-03 05:27:55'),(11,'App\\Models\\User',3,'eMISO-App-Token','c139cf0381b9df86bd6c537f1d4ca9ee466cef628bd4a739eb8e5a1c90cef341','[\"*\"]','2025-04-03 05:54:59','2025-04-03 05:28:17','2025-04-03 05:54:59'),(12,'App\\Models\\User',1,'eMISO-App-Token','0aebcf0d972b9f923c424c808140431dc7414d0a93762e2fdc9357717465fcf5','[\"*\"]','2025-04-03 07:15:56','2025-04-03 05:28:34','2025-04-03 07:15:56'),(13,'App\\Models\\User',3,'eMISO-App-Token','6984414cfae2e9f41dca927d3f9aed6db39189b9c0a476528933debc5ab35a95','[\"*\"]','2025-04-03 06:09:03','2025-04-03 06:02:34','2025-04-03 06:09:03'),(14,'App\\Models\\User',3,'eMISO-App-Token','5215f3348449429c82df5839c96a153a1679858c4201b5b4797e90249e5412bb','[\"*\"]','2025-04-03 06:24:01','2025-04-03 06:09:20','2025-04-03 06:24:01'),(15,'App\\Models\\User',3,'eMISO-App-Token','7548bfc0b9478ca8cf1cca922889cbd8d2cf4c25288f33f71dae58ab6b34446c','[\"*\"]','2025-04-03 07:29:39','2025-04-03 07:16:12','2025-04-03 07:29:39'),(16,'App\\Models\\User',1,'eMISO-App-Token','eaa866b39fd22949a909e235e15e30e1b21449627ae904eac3c6941c150509c9','[\"*\"]','2025-04-03 16:17:26','2025-04-03 07:29:47','2025-04-03 16:17:26'),(17,'App\\Models\\User',3,'eMISO-App-Token','c4d3e62e8bf8b3acdd98051adc5b5272ca348d7a5347367afce423901a24b873','[\"*\"]','2025-04-03 16:17:13','2025-04-03 16:11:40','2025-04-03 16:17:13');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_equipment`
--

DROP TABLE IF EXISTS `track_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_equipment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint NOT NULL,
  `equipment_id` bigint NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `office_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_equipment`
--

LOCK TABLES `track_equipment` WRITE;
/*!40000 ALTER TABLE `track_equipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `track_equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` tinyint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2y$10$sVQCwbzC/KxcAodyNSc8Uu3bT77RoE4GwJStrxmDh3OCA/tpJ6mQi',1,'2024-12-31 16:00:00','2024-12-31 16:00:00'),(2,'jeffculanag','$2y$10$GKioPA.1qNrVYt9q7yysl.4yimq9s5c.cmEs6lAjh5SLLIAvmgQFa',1,'2025-04-03 03:55:50','2025-04-03 03:55:50'),(3,'giancarloanonat','$2y$10$Uzr7ukSESjpoiu22DQKuNutcxacz8lweyvEa6OhSbe2gcR4jG9HwC',2,'2025-04-03 03:57:57','2025-04-03 03:57:57'),(4,'genievicente','$2y$10$HtbhDaXYWSh8rMMKja1UH.R0LNHRvZ4p/z6vQKVwi6N2Gq93.iOZ.',2,'2025-04-03 04:17:13','2025-04-03 04:17:13');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04  8:17:30
