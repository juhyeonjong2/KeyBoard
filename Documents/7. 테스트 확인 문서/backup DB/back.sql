-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: allkeyboard
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `mno` int unsigned NOT NULL,
  `pno` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  KEY `mno` (`mno`),
  KEY `pno` (`pno`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`mno`) REFERENCES `member` (`mno`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`pno`) REFERENCES `product` (`pno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cert`
--

DROP TABLE IF EXISTS `cert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cert` (
  `hash` char(64) NOT NULL COMMENT '해쉬값',
  `expiretime` timestamp NULL DEFAULT NULL COMMENT '만료기간',
  `mno` int unsigned NOT NULL COMMENT '회원번호',
  UNIQUE KEY `mno` (`mno`),
  CONSTRAINT `cert_ibfk_1` FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cert`
--

LOCK TABLES `cert` WRITE;
/*!40000 ALTER TABLE `cert` DISABLE KEYS */;
INSERT INTO `cert` VALUES ('d8663a621f49519c4f55a30ad3228f9b10adcb1aef2d6c3ce1273912d92a62e4','2024-01-18 12:08:11',1),('1c1b90ef9726fcce920819f36fb785bacc21276a0816eaddff9a5014353f7ef2','2024-01-18 12:08:13',2);
/*!40000 ALTER TABLE `cert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `mno` int unsigned NOT NULL AUTO_INCREMENT COMMENT '회원번호',
  `mid` varchar(255) NOT NULL COMMENT '아이디',
  `mname` text NOT NULL COMMENT '이름',
  `mphone` varchar(13) NOT NULL COMMENT '연락처',
  `memail` varchar(100) DEFAULT NULL COMMENT '이메일',
  `maddr` text COMMENT '주소',
  `rdate` timestamp NULL DEFAULT NULL COMMENT '가입일',
  `mpw` char(32) NOT NULL COMMENT '비밀번호',
  `mlevel` int DEFAULT NULL COMMENT '권한',
  `delyn` char(1) DEFAULT NULL COMMENT '탈퇴여부',
  `allowemail` char(1) NOT NULL COMMENT '이메일수신동의',
  `allowphone` char(1) NOT NULL COMMENT '연락처수신동의',
  PRIMARY KEY (`mno`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'admin','관리자','000-0000-0000','admin@allkeyboard.com','전주시 덕진구','2024-01-18 09:21:51','81dc9bdb52d04dc20036dbd8313ed055',2,'n','n','n'),(2,'admin2','관리자','000-0000-0000','admin2@allkeyboard.com','전주시 덕진구','2024-01-18 09:22:04','81dc9bdb52d04dc20036dbd8313ed055',2,'n','n','n');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `nno` int unsigned NOT NULL AUTO_INCREMENT,
  `ntitle` text NOT NULL,
  `ncontent` text,
  `rdate` timestamp NULL DEFAULT NULL,
  `nhit` int unsigned DEFAULT NULL,
  `delyn` char(1) DEFAULT NULL,
  PRIMARY KEY (`nno`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,'첫번째 공지입니다.','이미지 없어요','2024-01-18 10:39:02',0,'n'),(2,'MD770 RGB BT 모델 및 MD770 RGB 블랙 저소음 적축 모델 입고','MD770 RGB BT 모델 및 MD770 RGB 블랙 저소음 적축 모델 입고!!','2024-01-18 10:39:51',0,'n'),(3,'세번째 공지입니다.','세번째','2024-01-18 10:40:05',0,'n'),(4,'레오폴드 MX2A 시리즈 예약 판매 안내',' ','2024-01-18 10:40:37',1,'n'),(5,'다섯번째 공지','5555','2024-01-18 10:40:51',0,'n'),(6,'6번째!!','6666666','2024-01-18 10:41:00',0,'n');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificationattach`
--

DROP TABLE IF EXISTS `notificationattach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificationattach` (
  `nfno` int unsigned NOT NULL AUTO_INCREMENT,
  `nno` int unsigned NOT NULL,
  `nfrealname` varchar(100) NOT NULL,
  `nforeignname` varchar(100) NOT NULL,
  `rdate` timestamp NOT NULL,
  `nfidx` int unsigned NOT NULL COMMENT '관리번호',
  PRIMARY KEY (`nfno`),
  KEY `nno` (`nno`),
  CONSTRAINT `notificationattach_ibfk_1` FOREIGN KEY (`nno`) REFERENCES `notification` (`nno`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificationattach`
--

LOCK TABLES `notificationattach` WRITE;
/*!40000 ALTER TABLE `notificationattach` DISABLE KEYS */;
INSERT INTO `notificationattach` VALUES (1,2,'d874db57b00e3864.jpg','d874db57b00e3864.jpg','2024-01-18 10:39:51',0),(2,4,'mx2a_event.jpg','mx2a_event.jpg','2024-01-18 10:40:37',0);
/*!40000 ALTER TABLE `notificationattach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderitem`
--

DROP TABLE IF EXISTS `orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderitem` (
  `ino` int unsigned NOT NULL AUTO_INCREMENT COMMENT '항목번호',
  `ono` int unsigned NOT NULL COMMENT '주문번호',
  `pno` int unsigned NOT NULL COMMENT '상품번호',
  `price` int unsigned NOT NULL COMMENT '판매가',
  `quantity` int unsigned NOT NULL COMMENT '수량',
  PRIMARY KEY (`ino`),
  KEY `ono` (`ono`),
  KEY `pno` (`pno`),
  CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`ono`) REFERENCES `orders` (`ono`),
  CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`pno`) REFERENCES `product` (`pno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderitem`
--

LOCK TABLES `orderitem` WRITE;
/*!40000 ALTER TABLE `orderitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `ono` int unsigned NOT NULL AUTO_INCREMENT COMMENT '주문번호',
  `mno` int unsigned NOT NULL COMMENT '회원번호',
  `oname` varchar(20) NOT NULL COMMENT '주문자명',
  `otell` varchar(13) DEFAULT NULL COMMENT '주문자전화번호',
  `ophone` varchar(13) NOT NULL COMMENT '주문자휴대폰번호',
  `oemail` varchar(100) NOT NULL COMMENT '주문자이메일',
  `rdate` timestamp NULL DEFAULT NULL COMMENT '주문날짜',
  `recipient` text NOT NULL COMMENT '받으실분',
  `arrivallocation` text NOT NULL COMMENT '받으실 곳',
  `recipienttell` varchar(13) DEFAULT NULL COMMENT '받는사람 전화번호',
  `recipientphone` varchar(13) NOT NULL COMMENT '받는사람 휴대폰 번호',
  `onote` text COMMENT '남길말',
  `paymenttype` char(2) NOT NULL COMMENT '결제타입',
  `deliveryfee` int unsigned NOT NULL COMMENT '배송비',
  `state` varchar(10) DEFAULT NULL COMMENT '주문상태',
  `depositor` char(20) NOT NULL COMMENT '입금자',
  PRIMARY KEY (`ono`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `pno` int unsigned NOT NULL AUTO_INCREMENT COMMENT '상품번호',
  `pname` text NOT NULL COMMENT '상품명',
  `price` int NOT NULL COMMENT '판매가',
  `brand` varchar(20) DEFAULT NULL COMMENT '브랜드',
  `description` varchar(200) DEFAULT NULL COMMENT '상세설명',
  `inventory` int DEFAULT NULL COMMENT '재고',
  `delyn` char(1) DEFAULT NULL COMMENT '삭제유무',
  `type` varchar(20) DEFAULT NULL COMMENT '타입',
  PRIMARY KEY (`pno`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'마제스터치 2S 영문 저소음 적축',165000,'FILCO','',5,'n','마제스터치'),(2,'Realforce R3 BT 블랙 저소음 APC 45g 균등 영문 (풀사이즈) R3HB11',395000,'CAPACITY','',5,'n',''),(3,'Realforce R3M BT 블랙 저소음 APC 45g 균등 영문 (맥용-풀사이즈) R3HF11',395000,'CAPACITY','',8,'n',''),(4,'Realforce R3TL BT 화이트 저소음 APC 45g 균등 영문 (텐키레스) R3HD21',390000,'CAPACITY','',2,'n',''),(5,'마제스터치 컨버터블3 크림치즈 영문 적축',207000,'FILCO','',4,'n','마제스터치'),(6,'마제스터치 컨버터블3 하쿠아 영문 텐키레스 저소음 적축',205000,'FILCO','',100,'n','마제스터치'),(7,'Filco 마제스터치 텐키패드 2 프로페셔널 매트화이트',57000,'NUMPAD','',5,'n',''),(8,'마제스터치3 영문 갈축',178000,'FILCO','',40,'n','마제스터치'),(9,'Filco 마제스터치 텐키패드 2 프로페셔널 블랙',57000,'NUMPAD','',2,'n',''),(10,'마제스터치 2 닌자 영문 넌클릭 - 갈축',165000,'FILCO','',88,'n','닌자'),(11,'마제스터치 2 닌자 텐키레스 한글 넌클릭 - 갈축',165000,'FILCO','',55,'n','닌자'),(12,'레오폴드 FC650MDSBT 그레이블루 영문',127000,'LEOPOLD','',11,'n','FC650NDS'),(13,'마제스터치3 닌자 영문 적축',178000,'FILCO','',44,'n','닌자'),(14,'레오폴드 FC650MDSBT 그레이블루 한글',127000,'LEOPOLD','',15,'n','FC650NDS'),(15,'마제스터치 컨버터블 2 텐키레스-영문-클릭(청축)',187500,'FILCO','',55,'n','컨버터블'),(16,'마제스터치 컨버터블 2 핑크-영문-넌클릭(갈축)',187500,'FILCO','',23,'n','컨버터블'),(17,'레오폴드 FC650MDS PD 그레이블루 영문',107000,'LEOPOLD','',5,'n','FC650NDS'),(18,'레오폴드 FC650MDS PD 그레이블루 한글',107000,'LEOPOLD','',9,'n','FC650NDS'),(19,'마제스터치 MINILA 영문 - 청축 - 클릭',89000,'FILCO','',23,'n','MINILA'),(20,'레오폴드 FC750RBT PD 그레이 블루 한글',145000,'LEOPOLD','',9,'n','FC750R'),(21,'마제스터치 MINILA-R 컨버터블 영문 넌클릭 스카이',165000,'FILCO','',32,'n','MINILA'),(22,'레오폴드 FC750RBT PD 그레이퍼플 한글',145000,'LEOPOLD','',1,'n','FC750R'),(23,'마제스터치 2 하쿠아 영문 리니어 - 저소음 적축',165000,'FILCO','',44,'n','하쿠아'),(24,'레오폴드 FC750RBT PD 밀크 터쿼이즈 한글',145000,'LEOPOLD','',14,'n','FC750R'),(25,'마제스터치 2 하쿠아 텐키레스 영문 넌클릭 - 갈축',165000,'FILCO','',55,'n','하쿠아'),(26,'레오폴드 FC750RBT PD 스웨디시 화이트 영문',145000,'LEOPOLD','',4,'n','FC750R'),(27,'레오폴드 FC750RBT PD 스웨디시 화이트 한글',145000,'LEOPOLD','',7,'n','FC750R'),(28,'Mistel AIRONE 슬림 기계식 키보드 그레이 영문 택타일(넌클릭)',235000,'Mistel','',23,'n',''),(29,'Mistel Sleeker 텐키레스 실버 영문 (키캡 OEM Profile)',215000,'Mistel','',8,'n',''),(30,'레오폴드 FC900R PD 화이트 그레이 한글',149500,'LEOPOLD','',7,'n','FC900R'),(31,'Mistel 인체공학미니 키보드 MD770 RGB BT',205000,'Mistel','',23,'n',''),(32,'레오폴드 FC900RBT PD 그레이 블루 한글',146500,'LEOPOLD','',1,'n','FC900R'),(33,'레오폴드 FC900RBT PD 다크블루 한글',146500,'LEOPOLD','',11,'n','FC900R'),(34,'Vortex Cypher US1',117000,'Vortex','',33,'n',''),(35,'Vortex Race 3',165000,'Vortex','',28,'n',''),(36,'레오폴드 FC900RBT PD 스웨디시화이트 영문',146500,'LEOPOLD','',8,'n','FC900R'),(37,'Vortex Race 3 RGB',175000,'Vortex','',66,'n',''),(38,'레오폴드 FC900RBT PD 애쉬옐로우 한글',146500,'LEOPOLD','',2,'n','FC900R'),(39,'iKBC CD-108 염료승화키보드 먹각',78000,'iKBC','',33,'n',''),(40,'iKBC W200 텐키레스 무선 기계식 키보드 한글판 정품',107000,'iKBC','',22,'n',''),(41,'레오폴드 FC750RBT MX2A 코랄 블루 한글',175000,'LEOPOLD','',22,'n','FC750R_MX2A'),(42,'iKBC W210 무선 기계식 키보드 화이트 한글판 정품',107000,'iKBC','',55,'n',''),(43,'레오폴드 FC750RBT MX2A 그레이 블루 한글',175000,'LEOPOLD','',11,'n','FC750R_MX2A'),(44,'레오폴드 FC900RBT MX2A 코랄 블루 영문',175000,'LEOPOLD','',11,'n','FC900R_MX2A'),(45,'레오폴드 FC900RBT MX2A 코랄 블루 한글',175000,'LEOPOLD','',11,'n','FC900R_MX2A'),(46,'레오폴드 FC900RBT MX2A 그레이 블루 한글',178000,'LEOPOLD','',6,'n','FC900R_MX2A');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productattach`
--

DROP TABLE IF EXISTS `productattach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productattach` (
  `pfno` int unsigned NOT NULL AUTO_INCREMENT COMMENT '이미지파일번호',
  `pno` int unsigned NOT NULL COMMENT '상품번호',
  `pfrealname` varchar(100) NOT NULL COMMENT '실제이름',
  `pforeignname` varchar(100) NOT NULL COMMENT '외부이름',
  `rdate` timestamp NOT NULL COMMENT '등록일',
  `pfidx` int unsigned NOT NULL COMMENT '관리번호',
  PRIMARY KEY (`pfno`),
  KEY `pno` (`pno`),
  CONSTRAINT `productattach_ibfk_1` FOREIGN KEY (`pno`) REFERENCES `product` (`pno`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productattach`
--

LOCK TABLES `productattach` WRITE;
/*!40000 ALTER TABLE `productattach` DISABLE KEYS */;
INSERT INTO `productattach` VALUES (1,1,'1000000005_detail_034.jpg','1000000005_detail_034.jpg','2024-01-18 10:11:15',0),(2,1,'mj2s.jpg','mj2s.jpg','2024-01-18 10:11:15',2),(3,1,'switch_noti_700.jpg','switch_noti_700.jpg','2024-01-18 10:11:15',1),(4,2,'1000000606_detail_087.jpg','1000000606_detail_087.jpg','2024-01-18 10:11:48',0),(5,2,'realr3bl.jpg','realr3bl.jpg','2024-01-18 10:11:48',2),(6,2,'nonotice.jpg','nonotice.jpg','2024-01-18 10:11:48',1),(7,3,'1000000647_detail_085.jpg','1000000647_detail_085.jpg','2024-01-18 10:13:48',0),(8,3,'r3btmacb.jpg','r3btmacb.jpg','2024-01-18 10:13:48',2),(9,3,'nonotice1.jpg','nonotice.jpg','2024-01-18 10:13:48',1),(10,4,'1000000625_detail_015.jpg','1000000625_detail_015.jpg','2024-01-18 10:14:48',0),(11,4,'nonotice2.jpg','nonotice.jpg','2024-01-18 10:14:48',1),(12,5,'1000000673_detail_045.jpg','1000000673_detail_045.jpg','2024-01-18 10:14:51',0),(13,5,'cv3ccfunction.jpg','cv3ccfunction.jpg','2024-01-18 10:14:51',3),(14,5,'cv3ccred.jpg','cv3ccred.jpg','2024-01-18 10:14:51',2),(15,5,'switch_noti.jpg','switch_noti.jpg','2024-01-18 10:14:51',1),(16,6,'1000000678_detail_039.jpg','1000000678_detail_039.jpg','2024-01-18 10:16:15',0),(17,6,'cv3hakufunction.jpg','cv3hakufunction.jpg','2024-01-18 10:16:15',3),(18,6,'cv3hakutklsilred.jpg','cv3hakutklsilred.jpg','2024-01-18 10:16:15',2),(19,6,'switch_noti1.jpg','switch_noti.jpg','2024-01-18 10:16:15',1),(20,7,'1000000402_detail_098.jpg','1000000402_detail_098.jpg','2024-01-18 10:16:50',0),(21,7,'tp2_maw.jpg','tp2_maw.jpg','2024-01-18 10:16:50',1),(22,8,'1000000656_detail_067.jpg','1000000656_detail_067.jpg','2024-01-18 10:16:59',0),(23,8,'ma3brown.jpg','ma3brown.jpg','2024-01-18 10:16:59',2),(24,8,'switch_noti2.jpg','switch_noti.jpg','2024-01-18 10:16:59',1),(25,9,'1000000401_detail_028.jpg','1000000401_detail_028.jpg','2024-01-18 10:17:41',0),(26,9,'tp2_black.jpg','tp2_black.jpg','2024-01-18 10:17:41',1),(27,10,'1000000046_detail_066.jpg','1000000046_detail_066.jpg','2024-01-18 10:18:36',0),(28,10,'NINJA_M.jpg','NINJA_M.jpg','2024-01-18 10:18:36',2),(29,10,'switch_noti_7001.jpg','switch_noti_700.jpg','2024-01-18 10:18:36',1),(30,11,'1000000342_detail_084.jpg','1000000342_detail_084.jpg','2024-01-18 10:19:16',0),(31,11,'ninja_tkl_kr.jpg','ninja_tkl_kr.jpg','2024-01-18 10:19:16',1),(32,12,'1000000557_detail_09.jpg','1000000557_detail_09.jpg','2024-01-18 10:19:41',0),(33,12,'FC650MDSBT.jpg','FC650MDSBT.jpg','2024-01-18 10:19:41',2),(34,12,'leopold_noti.jpg','leopold_noti.jpg','2024-01-18 10:19:41',1),(35,13,'1000000651_detail_04.jpg','1000000651_detail_04.jpg','2024-01-18 10:19:52',0),(36,13,'ma3ninred.jpg','ma3ninred.jpg','2024-01-18 10:19:52',2),(37,13,'switch_noti3.jpg','switch_noti.jpg','2024-01-18 10:19:52',1),(38,14,'1000000556_detail_062.jpg','1000000556_detail_062.jpg','2024-01-18 10:20:32',0),(39,14,'FC650MDSBT1.jpg','FC650MDSBT.jpg','2024-01-18 10:20:32',2),(40,14,'leopold_noti1.jpg','leopold_noti.jpg','2024-01-18 10:20:32',1),(41,15,'1000000074_detail_030.jpg','1000000074_detail_030.jpg','2024-01-18 10:20:47',0),(42,15,'convert2_tkl.jpg','convert2_tkl.jpg','2024-01-18 10:20:47',2),(43,15,'switch_noti_7002.jpg','switch_noti_700.jpg','2024-01-18 10:20:47',1),(44,16,'1000000355_detail_044.jpg','1000000355_detail_044.jpg','2024-01-18 10:21:27',0),(45,16,'cv_full2.jpg','cv_full2.jpg','2024-01-18 10:21:27',2),(46,16,'cv2_pink.jpg','cv2_pink.jpg','2024-01-18 10:21:27',1),(47,17,'1000000520_detail_033.jpg','1000000520_detail_033.jpg','2024-01-18 10:21:30',0),(48,17,'650_gb.jpg','650_gb.jpg','2024-01-18 10:21:30',2),(49,17,'leopold_noti2.jpg','leopold_noti.jpg','2024-01-18 10:21:30',1),(50,18,'1000000519_detail_067.jpg','1000000519_detail_067.jpg','2024-01-18 10:22:05',0),(51,18,'650_gb1.jpg','650_gb.jpg','2024-01-18 10:22:05',2),(52,18,'leopold_noti3.jpg','leopold_noti.jpg','2024-01-18 10:22:05',1),(53,19,'1000000531_detail_013.jpg','1000000531_detail_013.jpg','2024-01-18 10:22:34',0),(54,19,'minila_click.jpg','minila_click.jpg','2024-01-18 10:22:34',2),(55,19,'switch_noti_7003.jpg','switch_noti_700.jpg','2024-01-18 10:22:34',1),(56,20,'1000000554_detail_093.jpg','1000000554_detail_093.jpg','2024-01-18 10:23:14',0),(57,20,'FC750RBT.jpg','FC750RBT.jpg','2024-01-18 10:23:14',2),(58,20,'leopold_noti4.jpg','leopold_noti.jpg','2024-01-18 10:23:14',1),(59,21,'1000000538_detail_036.jpg','1000000538_detail_036.jpg','2024-01-18 10:23:20',0),(60,21,'r_sky_non.jpg','r_sky_non.jpg','2024-01-18 10:23:20',2),(61,21,'switch_noti_7004.jpg','switch_noti_700.jpg','2024-01-18 10:23:20',1),(62,22,'1000000634_detail_045.jpg','1000000634_detail_045.jpg','2024-01-18 10:23:56',0),(63,22,'750rbtgp.jpg','750rbtgp.jpg','2024-01-18 10:23:56',2),(64,22,'exleo.jpg','exleo.jpg','2024-01-18 10:23:56',1),(65,23,'1000000006_detail_097.jpg','1000000006_detail_097.jpg','2024-01-18 10:24:05',0),(66,23,'hakua.jpg','hakua.jpg','2024-01-18 10:24:05',2),(67,23,'switch_noti_7005.jpg','switch_noti_700.jpg','2024-01-18 10:24:05',1),(68,24,'1000000645_detail_06.jpg','1000000645_detail_06.jpg','2024-01-18 10:24:34',0),(69,24,'750btmiltu.jpg','750btmiltu.jpg','2024-01-18 10:24:34',2),(70,24,'exleo1.jpg','exleo.jpg','2024-01-18 10:24:34',1),(71,25,'1000000015_detail_066.jpg','1000000015_detail_066.jpg','2024-01-18 10:24:41',0),(72,25,'hakua1.jpg','hakua.jpg','2024-01-18 10:24:41',2),(73,25,'switch_noti_7006.jpg','switch_noti_700.jpg','2024-01-18 10:24:41',1),(74,26,'1000000594_detail_082.jpg','1000000594_detail_082.jpg','2024-01-18 10:25:09',0),(75,26,'750btsww.jpg','750btsww.jpg','2024-01-18 10:25:09',2),(76,26,'exleo2.jpg','exleo.jpg','2024-01-18 10:25:09',1),(77,27,'1000000594_detail_082 (1).jpg','1000000594_detail_082 (1).jpg','2024-01-18 10:25:58',0),(78,27,'750btsww1.jpg','750btsww.jpg','2024-01-18 10:25:58',2),(79,27,'exleo3.jpg','exleo.jpg','2024-01-18 10:25:58',1),(80,28,'1000000697_detail_062.jpg','1000000697_detail_062.jpg','2024-01-18 10:26:02',0),(81,28,'aironegray.jpg','aironegray.jpg','2024-01-18 10:26:02',1),(82,29,'1000000368_detail_015.jpg','1000000368_detail_015.jpg','2024-01-18 10:26:43',0),(83,29,'sleeker.jpg','sleeker.jpg','2024-01-18 10:26:43',2),(84,29,'pre_sleeker.jpg','pre_sleeker.jpg','2024-01-18 10:26:43',1),(85,30,'1000000493_detail_017.jpg','1000000493_detail_017.jpg','2024-01-18 10:27:00',0),(86,30,'900r_wh_gray.jpg','900r_wh_gray.jpg','2024-01-18 10:27:00',2),(87,30,'leopold_noti5.jpg','leopold_noti.jpg','2024-01-18 10:27:00',1),(88,31,'1000000577_detail_05.jpg','1000000577_detail_05.jpg','2024-01-18 10:27:38',0),(89,31,'MD770RGBBT_KR.jpg','MD770RGBBT_KR.jpg','2024-01-18 10:27:38',2),(90,31,'MD770RGBBT_KR2.jpg','MD770RGBBT_KR2.jpg','2024-01-18 10:27:38',1),(91,32,'1000000558_detail_049.jpg','1000000558_detail_049.jpg','2024-01-18 10:27:44',0),(92,32,'FC900RBT.jpg','FC900RBT.jpg','2024-01-18 10:27:44',2),(93,32,'leopold_noti6.jpg','leopold_noti.jpg','2024-01-18 10:27:44',1),(94,33,'1000000621_detail_013.jpg','1000000621_detail_013.jpg','2024-01-18 10:28:47',0),(95,33,'900rbtdb.jpg','900rbtdb.jpg','2024-01-18 10:28:47',2),(96,33,'exleo4.jpg','exleo.jpg','2024-01-18 10:28:47',1),(97,34,'1000000373_detail_039.jpg','1000000373_detail_039.jpg','2024-01-18 10:29:00',0),(98,34,'cypher_2.jpg','cypher_2.jpg','2024-01-18 10:29:00',2),(99,34,'cypher_1.jpg','cypher_1.jpg','2024-01-18 10:29:00',1),(100,35,'1000000371_detail_012.jpg','1000000371_detail_012.jpg','2024-01-18 10:29:31',0),(101,35,'race3.jpg','race3.jpg','2024-01-18 10:29:31',1),(102,36,'1000000664_detail_034.jpg','1000000664_detail_034.jpg','2024-01-18 10:29:32',0),(103,36,'900rbtsww.jpg','900rbtsww.jpg','2024-01-18 10:29:32',2),(104,36,'exleo5.jpg','exleo.jpg','2024-01-18 10:29:32',1),(105,37,'1000000372_detail_096.jpg','1000000372_detail_096.jpg','2024-01-18 10:30:08',0),(106,37,'race3_rgb.jpg','race3_rgb.jpg','2024-01-18 10:30:08',1),(107,38,'1000000583_detail_023.jpg','1000000583_detail_023.jpg','2024-01-18 10:31:05',0),(108,38,'900rbtye.jpg','900rbtye.jpg','2024-01-18 10:31:05',2),(109,38,'exleo6.jpg','exleo.jpg','2024-01-18 10:31:05',1),(110,39,'1000000378_detail_081.jpg','1000000378_detail_081.jpg','2024-01-18 10:31:28',0),(111,39,'cd108.jpg','cd108.jpg','2024-01-18 10:31:28',2),(112,39,'cd108_noti.jpg','cd108_noti.jpg','2024-01-18 10:31:28',1),(113,40,'1000000480_detail_080.jpg','1000000480_detail_080.jpg','2024-01-18 10:32:00',0),(114,40,'W200.jpg','W200.jpg','2024-01-18 10:32:00',1),(115,41,'1000000693_detail_089.jpg','1000000693_detail_089.jpg','2024-01-18 10:32:25',0),(116,41,'750R_MX2A_CB.jpg','750R_MX2A_CB.jpg','2024-01-18 10:32:25',2),(117,41,'leopold_noti7.jpg','leopold_noti.jpg','2024-01-18 10:32:25',1),(118,42,'1000000480_detail_0801.jpg','1000000480_detail_080.jpg','2024-01-18 10:32:42',0),(119,42,'W2001.jpg','W200.jpg','2024-01-18 10:32:42',1),(120,43,'1000000691_detail_05.jpg','1000000691_detail_05.jpg','2024-01-18 10:39:04',0),(121,43,'750R_MX2A_GB.jpg','750R_MX2A_GB.jpg','2024-01-18 10:39:04',2),(122,43,'leopold_noti8.jpg','leopold_noti.jpg','2024-01-18 10:39:04',1),(123,44,'1000000690_detail_064.jpg','1000000690_detail_064.jpg','2024-01-18 10:40:20',0),(124,44,'900R_MX2A_CB.jpg','900R_MX2A_CB.jpg','2024-01-18 10:40:20',2),(125,44,'leopold_noti9.jpg','leopold_noti.jpg','2024-01-18 10:40:20',1),(126,45,'1000000689_detail_065.jpg','1000000689_detail_065.jpg','2024-01-18 10:41:12',0),(127,45,'900R_MX2A_CB1.jpg','900R_MX2A_CB.jpg','2024-01-18 10:41:12',2),(128,45,'leopold_noti10.jpg','leopold_noti.jpg','2024-01-18 10:41:12',1),(129,46,'1000000687_detail_013.jpg','1000000687_detail_013.jpg','2024-01-18 10:41:57',0),(130,46,'900R_MX2A_GB.jpg','900R_MX2A_GB.jpg','2024-01-18 10:41:57',2),(131,46,'leopold_noti11.jpg','leopold_noti.jpg','2024-01-18 10:41:57',1);
/*!40000 ALTER TABLE `productattach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `rno` int unsigned NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
  `rnote` text NOT NULL COMMENT '내용',
  `rwritedate` timestamp NULL DEFAULT NULL COMMENT '작성일',
  `mno` int unsigned NOT NULL COMMENT '회원번호',
  `pno` int unsigned NOT NULL COMMENT '상품번호',
  PRIMARY KEY (`rno`),
  KEY `mno` (`mno`),
  KEY `pno` (`pno`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`mno`) REFERENCES `member` (`mno`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`pno`) REFERENCES `product` (`pno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-18 19:50:13
