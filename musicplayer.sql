-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: musicplayer
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `contains`
--

DROP TABLE IF EXISTS `contains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contains` (
  `playlistID` int NOT NULL,
  `playlistOwner` varchar(50) NOT NULL,
  `trackID` int NOT NULL,
  `track_trackOwner` varchar(50) NOT NULL,
  PRIMARY KEY (`playlistID`,`playlistOwner`,`trackID`,`track_trackOwner`),
  KEY `fk_playlist_has_track_track1_idx` (`trackID`,`track_trackOwner`),
  KEY `fk_playlist_has_track_playlist1_idx` (`playlistID`,`playlistOwner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contains`
--

LOCK TABLES `contains` WRITE;
/*!40000 ALTER TABLE `contains` DISABLE KEYS */;
INSERT INTO `contains` VALUES (1,'gigi_',1,'dina_adel'),(3,'dina_adel',1,'dina_adel'),(1,'gigi_',2,'gigi_'),(2,'ahmed_ali',2,'gigi_'),(2,'ahmed_ali',3,'ahmed_ali'),(4,'gigi_',3,'ahmed_ali');
/*!40000 ALTER TABLE `contains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows_playlist`
--

DROP TABLE IF EXISTS `follows_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follows_playlist` (
  `userName` varchar(50) NOT NULL,
  `playlistID` int NOT NULL,
  `playlistOwner` varchar(50) NOT NULL,
  KEY `fk_user_has_playlist_playlist1_idx` (`playlistID`,`playlistOwner`),
  KEY `fk_user_has_playlist_user1_idx` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows_playlist`
--

LOCK TABLES `follows_playlist` WRITE;
/*!40000 ALTER TABLE `follows_playlist` DISABLE KEYS */;
INSERT INTO `follows_playlist` VALUES ('gigi_',1,'gigi_'),('gigi_',3,'dina_aziz'),('gigi_',2,'ahmed_ali');
/*!40000 ALTER TABLE `follows_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows_user`
--

DROP TABLE IF EXISTS `follows_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follows_user` (
  `userName` varchar(50) NOT NULL,
  `following` varchar(50) NOT NULL,
  KEY `fk_user_has_user_user2_idx` (`following`),
  KEY `fk_user_has_user_user1_idx` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows_user`
--

LOCK TABLES `follows_user` WRITE;
/*!40000 ALTER TABLE `follows_user` DISABLE KEYS */;
INSERT INTO `follows_user` VALUES ('ahmed_ali','dina_adel'),('dina_adel','gigi_'),('reem_k','gigi_'),('ahmed_ali','gigi_'),('gigi_','dina_adel'),('gigi_','ali_5');
/*!40000 ALTER TABLE `follows_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `userName` varchar(50) NOT NULL,
  `trackID` int NOT NULL,
  `trackOwner` varchar(50) NOT NULL,
  PRIMARY KEY (`userName`,`trackID`,`trackOwner`),
  KEY `fk_user_has_track_track1_idx` (`trackID`,`trackOwner`),
  KEY `fk_user_has_track_user1_idx` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES ('gigi_',2,'gigi_'),('gigi_',7,'gigi_');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `playlistID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) DEFAULT NULL,
  `playlistOwner` varchar(50) NOT NULL,
  PRIMARY KEY (`playlistID`,`playlistOwner`),
  KEY `fk_platlist_user1_idx` (`playlistOwner`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES (1,'random songs','gigi_'),(2,'gym songs','ahmed_ali'),(3,'night life','dina_aziz'),(4,'morning songs','gigi_');
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track`
--

DROP TABLE IF EXISTS `track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track` (
  `trackID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `path` varchar(100) NOT NULL,
  `trackOwner` varchar(50) NOT NULL,
  PRIMARY KEY (`trackID`,`trackOwner`),
  KEY `fk_track_user_idx` (`trackOwner`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track`
--

LOCK TABLES `track` WRITE;
/*!40000 ALTER TABLE `track` DISABLE KEYS */;
INSERT INTO `track` VALUES (1,'delicate taylor swift','tracks/delicate taylor swift.mp3','dina_adel'),(2,'a world alone lorde','tracks/a world alone lorde.mp3','gigi_'),(3,'supercut lorde','tracks/supercut lorde.mp3','ahmed_ali'),(7,'maybe','tracks/maybe.mp3','gigi_'),(8,'party favor','tracks/party favor.mp3','gigi_'),(10,'team','tracks/team.mp3','gigi_'),(11,'ff','tracks/ff.mp3','gigi_');
/*!40000 ALTER TABLE `track` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userName` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(45) NOT NULL,
  `gender` enum('f','m','o') NOT NULL,
  `displayName` varchar(50) NOT NULL,
  `age` smallint NOT NULL,
  PRIMARY KEY (`userName`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `userName_UNIQUE` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('ahmed_ali','ahmed@yaho.com','123456','m','ahmed ali',26),('ali_5','alihesh@hotmail.com','fgf558HH','m','ali tarek',31),('diana_','dia@gmail.com','12345','f','diana',24),('dina_adel','dinadde@gmail.com','hgfHH887','f','dina adel',25),('gigi_','gigit@gmail.com','35487','f','gigi t',24),('ramii','ramiiu@gmail.com','bv57Fkk','m','rami',20),('reem_k','reemiu@hotmail.com','12547JUbv','f','reem karem',30);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-14 10:02:47
