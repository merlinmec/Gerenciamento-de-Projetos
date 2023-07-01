CREATE DATABASE  IF NOT EXISTS `banco_prova2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `banco_prova2`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: banco_prova2
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `documento`
--

DROP TABLE IF EXISTS `documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documento` (
  `id_doc` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `descric` text,
  `data_cri` date DEFAULT NULL,
  `versao` varchar(255) DEFAULT NULL,
  `id_proj` int DEFAULT NULL,
  PRIMARY KEY (`id_doc`),
  KEY `id_proj` (`id_proj`),
  CONSTRAINT `documento_ibfk_1` FOREIGN KEY (`id_proj`) REFERENCES `projeto` (`id_proj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documento`
--

LOCK TABLES `documento` WRITE;
/*!40000 ALTER TABLE `documento` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `habilidade`
--

DROP TABLE IF EXISTS `habilidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `habilidade` (
  `id_habilid` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id_habilid`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `habilidade`
--

LOCK TABLES `habilidade` WRITE;
/*!40000 ALTER TABLE `habilidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `habilidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membro`
--

DROP TABLE IF EXISTS `membro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membro` (
  `id_membro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `funcao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membro`
--

LOCK TABLES `membro` WRITE;
/*!40000 ALTER TABLE `membro` DISABLE KEYS */;
/*!40000 ALTER TABLE `membro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membro_habilidade`
--

DROP TABLE IF EXISTS `membro_habilidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membro_habilidade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_habilid` int DEFAULT NULL,
  `id_membro` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_habilid` (`id_habilid`),
  KEY `id_membro` (`id_membro`),
  CONSTRAINT `membro_habilidade_ibfk_1` FOREIGN KEY (`id_habilid`) REFERENCES `habilidade` (`id_habilid`),
  CONSTRAINT `membro_habilidade_ibfk_2` FOREIGN KEY (`id_membro`) REFERENCES `membro` (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membro_habilidade`
--

LOCK TABLES `membro_habilidade` WRITE;
/*!40000 ALTER TABLE `membro_habilidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `membro_habilidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membros_projeto`
--

DROP TABLE IF EXISTS `membros_projeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membros_projeto` (
  `id_proj` int NOT NULL,
  `id_membro` int NOT NULL,
  PRIMARY KEY (`id_proj`,`id_membro`),
  KEY `id_membro` (`id_membro`),
  CONSTRAINT `membros_projeto_ibfk_1` FOREIGN KEY (`id_proj`) REFERENCES `projeto` (`id_proj`),
  CONSTRAINT `membros_projeto_ibfk_2` FOREIGN KEY (`id_membro`) REFERENCES `membro` (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membros_projeto`
--

LOCK TABLES `membros_projeto` WRITE;
/*!40000 ALTER TABLE `membros_projeto` DISABLE KEYS */;
/*!40000 ALTER TABLE `membros_projeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projeto`
--

DROP TABLE IF EXISTS `projeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projeto` (
  `id_proj` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `descric` text,
  `data_ini` date DEFAULT NULL,
  `data_term` date DEFAULT NULL,
  `status` enum('em andamento','concluído','cancelado') DEFAULT NULL,
  `respons` int DEFAULT NULL,
  PRIMARY KEY (`id_proj`),
  KEY `respons` (`respons`),
  CONSTRAINT `projeto_ibfk_1` FOREIGN KEY (`respons`) REFERENCES `membro` (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projeto`
--

LOCK TABLES `projeto` WRITE;
/*!40000 ALTER TABLE `projeto` DISABLE KEYS */;
/*!40000 ALTER TABLE `projeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relatorio`
--

DROP TABLE IF EXISTS `relatorio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relatorio` (
  `id_relat` int NOT NULL AUTO_INCREMENT,
  `data_ger` date DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `id_proj` int DEFAULT NULL,
  PRIMARY KEY (`id_relat`),
  KEY `id_proj` (`id_proj`),
  CONSTRAINT `relatorio_ibfk_1` FOREIGN KEY (`id_proj`) REFERENCES `projeto` (`id_proj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relatorio`
--

LOCK TABLES `relatorio` WRITE;
/*!40000 ALTER TABLE `relatorio` DISABLE KEYS */;
/*!40000 ALTER TABLE `relatorio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarefa`
--

DROP TABLE IF EXISTS `tarefa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefa` (
  `id_taref` int NOT NULL AUTO_INCREMENT,
  `descric` text,
  `data_ini` date DEFAULT NULL,
  `data_term` date DEFAULT NULL,
  `status` enum('pendente','em andamento','concluída') DEFAULT NULL,
  `respons` int DEFAULT NULL,
  `proj_assoc` int DEFAULT NULL,
  PRIMARY KEY (`id_taref`),
  KEY `respons` (`respons`),
  KEY `proj_assoc` (`proj_assoc`),
  CONSTRAINT `tarefa_ibfk_1` FOREIGN KEY (`respons`) REFERENCES `membro` (`id_membro`),
  CONSTRAINT `tarefa_ibfk_2` FOREIGN KEY (`proj_assoc`) REFERENCES `projeto` (`id_proj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarefa`
--

LOCK TABLES `tarefa` WRITE;
/*!40000 ALTER TABLE `tarefa` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarefa` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-28 16:49:47
