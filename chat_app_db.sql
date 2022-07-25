-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 25, 2022 at 11:51 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `userLoginNormal` (IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pToken` VARCHAR(500))   BEGIN
UPDATE `User` SET `accessToken` = pToken WHERE `email` = pEmail AND `password` = pPassword;
SELECT * FROM `User` WHERE `email` = pEmail AND `password` = pPassword;
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
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `uid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `accountType` enum('normal','facebook','google') NOT NULL DEFAULT 'normal',
  `password` varchar(200) NOT NULL,
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
(4, 'uid-25016d36-040c-11ed-b42c-c6ef0857e0cf', 'Nguyễn Đăng Quang', 'quangnd.nta@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicXVhbmduZC5udGFAZ21haWwuY29tIiwiaWF0IjoxNjU4NzMyMjU2LCJleHAiOjE2OTAyNjgyNTZ9.M5ixcNR0Iif_x1TI33V5sG3Zxi9rPcTkZzyrQZ7JwES6P_cF7Lk73uz0E8Ja78rfMsUPc4cRGOJcMIA4oEJLYA', 'test', '2022-07-15 07:02:52', '2022-07-25 13:57:36'),
(24, 'uid-3cac1894-0bfc-11ed-aca7-c6ef0857e0cf', 'Kim Tram Le', 'kimtramle@gmail.com', 'normal', 'Aa22032001!', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoia2ltdHJhbWxlQGdtYWlsLmNvbSIsImlhdCI6MTY1ODc0MTM0OSwiZXhwIjoxNjkwMjc3MzQ5fQ.EQ8pF0oL2861q0WhGw1LLsZ12Wb-0v3xYYEwHQAe_CE6s7_BMNx7WRChwn6ZJ8Q7vOYUGGwFhgM_kZbi4giMJg', 'test', '2022-07-25 09:29:09', '2022-07-25 16:29:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
