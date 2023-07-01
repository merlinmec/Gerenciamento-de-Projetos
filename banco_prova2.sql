CREATE DATABASE  IF NOT EXISTS `banco_prova2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `banco_prova2`;

DROP TABLE IF EXISTS `documento`;

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


LOCK TABLES `documento` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `habilidade`;

CREATE TABLE `habilidade` (
  `id_habilid` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id_habilid`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `habilidade` WRITE;

UNLOCK TABLES;


DROP TABLE IF EXISTS `membro`;

CREATE TABLE `membro` (
  `id_membro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `funcao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOCK TABLES `membro` WRITE;

UNLOCK TABLES;


DROP TABLE IF EXISTS `membro_habilidade`;

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


LOCK TABLES `membro_habilidade` WRITE;

UNLOCK TABLES;


DROP TABLE IF EXISTS `membros_projeto`;

CREATE TABLE `membros_projeto` (
  `id_proj` int NOT NULL,
  `id_membro` int NOT NULL,
  PRIMARY KEY (`id_proj`,`id_membro`),
  KEY `id_membro` (`id_membro`),
  CONSTRAINT `membros_projeto_ibfk_1` FOREIGN KEY (`id_proj`) REFERENCES `projeto` (`id_proj`),
  CONSTRAINT `membros_projeto_ibfk_2` FOREIGN KEY (`id_membro`) REFERENCES `membro` (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOCK TABLES `membros_projeto` WRITE;

UNLOCK TABLES;


DROP TABLE IF EXISTS `projeto`;

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


LOCK TABLES `projeto` WRITE;

UNLOCK TABLES;


DROP TABLE IF EXISTS `relatorio`;

CREATE TABLE `relatorio` (
  `id_relat` int NOT NULL AUTO_INCREMENT,
  `data_ger` date DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `id_proj` int DEFAULT NULL,
  PRIMARY KEY (`id_relat`),
  KEY `id_proj` (`id_proj`),
  CONSTRAINT `relatorio_ibfk_1` FOREIGN KEY (`id_proj`) REFERENCES `projeto` (`id_proj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOCK TABLES `relatorio` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `tarefa`;

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

LOCK TABLES `tarefa` WRITE;

UNLOCK TABLES;

