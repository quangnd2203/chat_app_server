-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 27, 2022 at 11:44 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.29

DROP DATABASE chat_app_db;
CREATE DATABASE chat_app_db;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chat_app_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `systemGetStatus` (IN `pMessage` VARCHAR(50), IN `pStatus` INT)   SELECT `pMessage` AS message, `pStatus` AS 'status'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userAuthorize` (IN `pEmail` VARCHAR(50), IN `pAccessToken` VARCHAR(500))   BEGIN
SELECT * FROM `User` WHERE `email` = pEmail AND `accessToken` = pAccessToken;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userGetAll` (IN `pUid` TEXT)   SELECT * FROM User WHERE `uid` != pUid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userLogin` (IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pAccountType` ENUM('normal','facebook','google'), IN `pAccessToken` VARCHAR(500), IN `pFcmToken` VARCHAR(200))   BEGIN
IF(`pAccountType` = 'normal') THEN
	BEGIN
        UPDATE `User` SET `accessToken` = pAccessToken, `fcmToken` = pFcmToken WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
        SELECT * FROM `User` WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
    END;
ELSE
	BEGIN
		UPDATE `User` SET `accessToken` = pAccessToken, `fcmToken` = pFcmToken WHERE `email` = pEmail AND `accountType` = pAccountType;
        SELECT * FROM `User` WHERE `email` = pEmail AND `accountType` = pAccountType;
	END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userRegister` (IN `pName` VARCHAR(50), IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pAccountType` VARCHAR(50), IN `pAccessToken` VARCHAR(500), IN `pFcmToken` VARCHAR(500), OUT `pMessage` VARCHAR(100), OUT `pStatus` INT)   BEGIN
  DECLARE `pUid` VARCHAR(50);
  SET `pStatus` = 0;
  SELECT COUNT(*) INTO @count FROM `User` WHERE `email` = `pEmail`;
  IF (@count > 0) THEN BEGIN
  		SET `pMessage` = 'email_exits';
    END;
 	ELSE BEGIN 
    	SET `pUid` = CONCAT('uid-',UUID());
  		INSERT INTO `User`(`uid`, `name`, `email`, `password` ,`accountType`, `fcmToken`, `accessToken`)
  		VALUES (`pUid`, `pName`, `pEmail`, `pPassword` ,`pAccountType`, `pFcmToken`, `pAccessToken`); 	
  		SELECT * FROM User WHERE `uid` = `pUid`;
        SET `pStatus` = 1;
    END;
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Conversation`
--

CREATE TABLE `Conversation` (
  `id` int(11) NOT NULL,
  `lastMessageId` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `Message`
--

CREATE TABLE `Message` (
  `id` int(11) NOT NULL,
  `conversationId` int(11) NOT NULL,
  `uid` varchar(50) NOT NULL,
  `text` varchar(2000) DEFAULT NULL,
  `media` text DEFAULT NULL,
  `status` enum('active','disable','deleted') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `uid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `accountType` enum('normal','facebook','google') NOT NULL DEFAULT 'normal',
  `password` varchar(200) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `background` varchar(500) DEFAULT NULL,
  `accessToken` varchar(500) DEFAULT NULL,
  `fcmToken` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `uid`, `name`, `email`, `accountType`, `password`, `avatar`, `background`, `accessToken`, `fcmToken`, `created_at`, `updated_at`) VALUES
(33, 'uid-89172ad8-0e28-11ed-b1fe-c6ef0857e0cf', 'Nguyễn Đăng Quang', 'quangnd.nta@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicXVhbmduZC5udGFAZ21haWwuY29tIiwiaWF0IjoxNjU4OTgwMjc3LCJleHAiOjE2OTA1MTYyNzd9.i19ZDp6kmqZbEeDnnMarGoHogNOjE6sNDNnMzF46rtKV1rB4FGXgFIRfI78yXJR9-zrE6z176jY-aIXeo2VLJA', 'cypWnjRyRaGrvxldi17k1X:APA91bFZ8g_kG3wStXZr-Nf72AqrAEPHDdUqHpuEcTnTrymwe5miTWYy8cGZbhgU11wyWiGo5IORhI0mfa5f7v1izxvqjpvP5_mmoj5XIdVVKOrZsWLhaArtIeoBG6tzlOy-QF39TpG1', '2022-07-28 03:51:17', '2022-07-28 10:51:17'),
(31, 'uid-c5122900-0e20-11ed-b1fe-c6ef0857e0cf', 'Kim Trâm Lê Thị', '111471591272174862520', 'google', NULL, NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiMTExNDcxNTkxMjcyMTc0ODYyNTIwIiwiaWF0IjoxNjU4OTc2OTQyLCJleHAiOjE2OTA1MTI5NDJ9.VOi541BAy3YHmlFJk26djWh2ADWPBtIBFlIrBWXuSjURovJE16MjOWJqb1Jb3iaSO34VaAeMXFW1nflLD12DTg', 'cypWnjRyRaGrvxldi17k1X:APA91bFZ8g_kG3wStXZr-Nf72AqrAEPHDdUqHpuEcTnTrymwe5miTWYy8cGZbhgU11wyWiGo5IORhI0mfa5f7v1izxvqjpvP5_mmoj5XIdVVKOrZsWLhaArtIeoBG6tzlOy-QF39TpG1', '2022-07-28 02:55:42', '2022-07-28 09:55:42');

-- --------------------------------------------------------

--
-- Table structure for table `UserConversation`
--

CREATE TABLE `UserConversation` (
  `uid` varchar(50) NOT NULL,
  `conversationId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Conversation`
--
ALTER TABLE `Conversation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lastMessageId` (`lastMessageId`);

--
-- Indexes for table `Message`
--
ALTER TABLE `Message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uid` (`uid`),
  ADD KEY `conversationId` (`conversationId`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `UserConversation`
--
ALTER TABLE `UserConversation`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `conversationId` (`conversationId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Conversation`
--
ALTER TABLE `Conversation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Message`
--
ALTER TABLE `Message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Conversation`
--
ALTER TABLE `Conversation`
  ADD CONSTRAINT `conversation_ibfk_1` FOREIGN KEY (`lastMessageId`) REFERENCES `Message` (`id`);

--
-- Constraints for table `Message`
--
ALTER TABLE `Message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `User` (`uid`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`conversationId`) REFERENCES `Conversation` (`id`);

--
-- Constraints for table `UserConversation`
--
ALTER TABLE `UserConversation`
  ADD CONSTRAINT `userconversation_ibfk_1` FOREIGN KEY (`conversationId`) REFERENCES `Conversation` (`id`),
  ADD CONSTRAINT `userconversation_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `User` (`uid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
