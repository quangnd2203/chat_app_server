-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 27, 2022 at 11:44 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.29

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `userAuthorize` (IN `pEmail` VARCHAR(50), IN `pAccessToken` VARCHAR(500))   SELECT * FROM `User` WHERE `email` = pEmail AND `accessToken` = pAccessToken$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userGetAll` ()   SELECT * FROM User$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userLogin` (IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pAccountType` ENUM('normal','facebook','google'), IN `pAccessToken` VARCHAR(500), IN `pFcmToken` VARCHAR(200))   BEGIN
IF(`pAccountType` = 'normal') THEN
	BEGIN
    	SELECT * FROM `User` WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
        UPDATE `User` SET `accessToken` = pAccessToken, `fcmToken` = pFcmToken WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
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
(25, 'uid-1ba6d01c-0cb5-11ed-876f-c6ef0857e0cf', 'quang nguyen', '110886710069326929110', 'google', NULL, NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiMTEwODg2NzEwMDY5MzI2OTI5MTEwIiwiaWF0IjoxNjU4ODIxODg0LCJleHAiOjE2OTAzNTc4ODR9.ojASS1m_LJlBUCjubO4XeEMtUcHXHpZMF6iwLZRGsrXGjBzRISMlC9uylMxs8KGFbD6Yc48jiqXm1IOK8Eb5bw', NULL, '2022-07-26 07:32:31', '2022-07-26 14:51:24'),
(4, 'uid-25016d36-040c-11ed-b42c-c6ef0857e0cf', 'Nguyễn Đăng Quang', 'quangnd.nta@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicXVhbmduZC5udGFAZ21haWwuY29tIiwiaWF0IjoxNjU4OTA5ODA5LCJleHAiOjE2OTA0NDU4MDl9.xQR2n0y-0oJLxwNzn7n3ysG7-XyUH9EMxFhb4RDY5CCgQ-1F8qwrqV71WpLbZVYsN61q2QKDTkRjXfD-hdgqaQ', 'sdsdsd', '2022-07-15 07:02:52', '2022-07-27 15:16:49'),
(26, 'uid-375100e6-0cc7-11ed-876f-c6ef0857e0cf', 'Nguyễn Đăng Quang', '413376224136632', 'facebook', NULL, NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNDEzMzc2MjI0MTM2NjMyIiwiaWF0IjoxNjU4ODI4ODczLCJleHAiOjE2OTAzNjQ4NzN9.g4IN5Ssd0Mt1TyQtgFxD7bNsghSU-w4TUPoVv5Uk9Zl5wElSBMaMkU6RlvrliJZawo6P0c7VeN5WA3ZNdE6lCg', NULL, '2022-07-26 09:42:08', '2022-07-26 16:47:53'),
(27, 'uid-37ed85fa-0cc8-11ed-876f-c6ef0857e0cf', 'Kim Trâm Lê Thị', '111471591272174862520', 'google', NULL, NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiMTExNDcxNTkxMjcyMTc0ODYyNTIwIiwiaWF0IjoxNjU4ODI4OTU4LCJleHAiOjE2OTAzNjQ5NTh9.--AAMhkJXkPMKr0-W3H5-V4hxD39-iUgyBG3P7JR1bv6UoEqQLnWm-r5R7SSZsjOtbxqUAF3uE2Ps9y0xmmdMQ', NULL, '2022-07-26 09:49:18', '2022-07-26 16:49:18'),
(24, 'uid-3cac1894-0bfc-11ed-aca7-c6ef0857e0cf', 'Kim Tram Le', 'kimtramle@gmail.com', 'normal', 'Aa22032001!', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoia2ltdHJhbWxlQGdtYWlsLmNvbSIsImlhdCI6MTY1ODc0MTM0OSwiZXhwIjoxNjkwMjc3MzQ5fQ.EQ8pF0oL2861q0WhGw1LLsZ12Wb-0v3xYYEwHQAe_CE6s7_BMNx7WRChwn6ZJ8Q7vOYUGGwFhgM_kZbi4giMJg', 'test', '2022-07-25 09:29:09', '2022-07-25 16:29:09');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

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
