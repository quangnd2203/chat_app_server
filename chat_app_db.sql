
-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 12, 2022 at 04:09 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `conversationCreate` (IN `pUid` TEXT, IN `pPartnerUid` TEXT)   BEGIN
	DECLARE `pConversationId` INT;
   	SET @json = (SELECT `getConversationIdByUids`(`pUid`, `pPartnerUid`));
    SET @count = (SELECT JSON_EXTRACT(@json, "$.count"));
    IF(@count > 1) THEN BEGIN
    	SET `pConversationId` = (SELECT JSON_EXTRACT(@json, "$.conversationId"));
    END;
    ELSE BEGIN
    	INSERT INTO `Conversation` VALUES();
        SET `pConversationId` = LAST_INSERT_ID();
        INSERT INTO `UserConversation` (`uid`, `conversationId`)
            VALUES (`pUid`, `pConversationId`), (`pPartnerUid`, `pConversationId`);
    END;
    END IF;
    CALL `conversationGetById`(`pConversationId`);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `conversationGetAll` (IN `pUid` TEXT, IN `pLimit` INT, IN `pOffset` INT)   SELECT `Conversation`.`id`, (
    SELECT CONCAT(
        "[", GROUP_CONCAT(JSON_OBJECT(
            "id",`User`.`id`,
            "uid", `User`.`uid`,
            "name", `User`.`name`,
            "email", `User`.`email`,
           	"accountType", `User`.`accountType`,
            "avatar", `User`.`avatar`,
            "background", `User`.`background`,
            "createdAt", `User`.`createdAt`,
            "updatedAt", `User`.`updatedAt`
        ) SEPARATOR ',') ,"]"
    ) 
    FROM `User` INNER JOIN `UserConversation` 
    ON `UserConversation`.`uid` = `User`.`uid` AND `UserConversation`.`conversationId` = `Conversation`.`id`
) as `users`, 
(
	SELECT messageGetById(`Conversation`.`lastMessageId`)
) as `lastMessage`,
`Conversation`.`createdAt`, `Conversation`.`updatedAt`
FROM `Conversation` INNER JOIN `UserConversation` ON `UserConversation`.`uid` = `pUid` GROUP BY `Conversation`.`id` LIMIT pLimit OFFSET pOffset$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `conversationGetById` (IN `pConversationId` INT)   SELECT `Conversation`.`id`, (
    SELECT CONCAT(
        "[", GROUP_CONCAT(JSON_OBJECT(
            "id",`User`.`id`,
            "uid", `User`.`uid`,
            "name", `User`.`name`,
            "email", `User`.`email`,
           	"accountType", `User`.`accountType`,
            "avatar", `User`.`avatar`,
            "background", `User`.`background`,
            "created_at", `User`.`created_at`,
            "updated_at", `User`.`updated_at`
        ) SEPARATOR ',') ,"]"
    ) 
    FROM `User` INNER JOIN `UserConversation` 
    ON `UserConversation`.`uid` = `User`.`uid` AND `UserConversation`.`conversationId` = `Conversation`.`id`
) as `users`, 
(
	SELECT messageGetById(`Conversation`.`lastMessageId`)
) as `lastMessage`,
`Conversation`.`createdAt`, `Conversation`.`updatedAt`
FROM `Conversation` WHERE `Conversation`.`id` = `pConversationId`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `conversationGetUsers` (IN `pConversationId` INT)   SELECT * 
    FROM `User` INNER JOIN `UserConversation` 
    ON `UserConversation`.`uid` = `User`.`uid` AND `UserConversation`.`conversationId` = `pConversationId`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `messageCreate` (IN `pConversationId` INT, IN `pUid` TEXT, IN `pText` TEXT, IN `pMedia` TEXT)   BEGIN
	INSERT INTO `Message` (`conversationId`, `uid`, `text`, `media`) VALUES (`pConversationId`, `pUid`, `pText`, `pMedia`);
	CALL `messageGetById`(LAST_INSERT_ID());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `messageGetByConversationId` (IN `pConversationId` INT, IN `pLimit` INT, IN `pOffset` INT)   SELECT 
	`Message`.`id`, 
    `Message`.`conversationId`, 
    `Message`.`text`, 
    `Message`.`media`,
    `Message`.`createdAt`,
    `Message`.`updatedAt`,
    (SELECT JSON_OBJECT(
    	'id', `User`.`id`,
        'uid', `User`.`uid`,
        'name', `User`.`name`,
        'email', `User`.`email`,
        'accountType', `User`.`accountType`,
        'avatar', `User`.`avatar`,
        'background', `User`.`background`,
        'createdAt',`User`.`createdAt`,
        'updatedAt',`User`.`updatedAt`
	) FROM `User` WHERE `User`.uid = `Message`.uid) as `user`
FROM `Message` WHERE `Message`.`conversationId` = `pConversationId`
ORDER BY `Message`.`createdAt` DESC LIMIT `pLimit` OFFSET `pOffset`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `messageGetById` (IN `pMessageId` INT)   SELECT 
        `Message`.`id`, 
        `Message`.`conversationId`, 
        `Message`.`text`, 
        `Message`.`media`,
        `Message`.`createdAt`,
        `Message`.`updatedAt`,
        (SELECT JSON_OBJECT(
            'id', `User`.`id`,
            'uid', `User`.`uid`,
            'name', `User`.`name`,
            'email', `User`.`email`,
            'accountType', `User`.`accountType`,
            'avatar', `User`.`avatar`,
            'background', `User`.`background`,
            'createdAt',`User`.`createdAt`,
            'updatedAt',`User`.`updatedAt`
        ) FROM `User` WHERE `User`.uid = `Message`.uid) as `user`
    	FROM `Message` WHERE `Message`.`id` = pMessageId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `systemGetStatus` (IN `pMessage` VARCHAR(50), IN `pStatus` INT)   SELECT `pMessage` AS message, `pStatus` AS 'status'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userAuthorize` (IN `pEmail` VARCHAR(50), IN `pAccessToken` VARCHAR(500))   BEGIN
SELECT * FROM `User` WHERE `email` = pEmail AND `accessToken` = pAccessToken;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userGetAll` (IN `pUid` TEXT, IN `pLimit` INT, IN `pOffset` INT)   SELECT * FROM User WHERE `uid` != pUid LIMIT pLimit OFFSET pOffset$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userLogin` (IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pAccountType` ENUM('normal','facebook','google'), IN `pAccessToken` VARCHAR(500))   BEGIN
IF(`pAccountType` = 'normal') THEN
	BEGIN
        UPDATE `User` SET `accessToken` = pAccessToken WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
        SELECT * FROM `User` WHERE `email` = pEmail AND `password` = pPassword AND `accountType` = pAccountType;
    END;
ELSE
	BEGIN
		UPDATE `User` SET `accessToken` = pAccessToken WHERE `email` = pEmail AND `accountType` = pAccountType;
        SELECT * FROM `User` WHERE `email` = pEmail AND `accountType` = pAccountType;
	END;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userRegister` (IN `pName` VARCHAR(50), IN `pEmail` VARCHAR(50), IN `pPassword` VARCHAR(200), IN `pAccountType` VARCHAR(50), IN `pAccessToken` VARCHAR(500), OUT `pMessage` VARCHAR(100), OUT `pStatus` INT)   BEGIN
  DECLARE `pUid` VARCHAR(50);
  SET `pStatus` = 0;
  SELECT COUNT(*) INTO @count FROM `User` WHERE `email` = `pEmail`;
  IF (@count > 0) THEN BEGIN
  		SET `pMessage` = 'email_exits';
    END;
 	ELSE BEGIN 
    	SET `pUid` = CONCAT('uid-',UUID());
  		INSERT INTO `User`(`uid`, `name`, `email`, `password` ,`accountType`, `accessToken`)
  		VALUES (`pUid`, `pName`, `pEmail`, `pPassword` ,`pAccountType`, `pAccessToken`); 	
  		SELECT * FROM User WHERE `uid` = `pUid`;
        SET `pStatus` = 1;
    END;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userUpdateFcmToken` (IN `pUid` TEXT, IN `pFcmToken` TEXT)   BEGIN
	UPDATE `User` SET `fcmToken` = NULL WHERE `fcmToken` = pFcmToken;
    UPDATE `User` SET `fcmToken` = pFcmToken WHERE `uid` = pUid;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getConversationIdByUids` (`pUid` TEXT, `pPartnerUid` TEXT) RETURNS LONGTEXT CHARSET utf8mb4 COLLATE utf8mb4_bin  BEGIN
SELECT `conversationId` INTO @conversationId FROM `UserConversation`
	GROUP BY `UserConversation`.`uid` HAVING `UserConversation`.`uid` IN (`pUid`, `pPartnerUid`) LIMIT 1;
SET @count = (SELECT COUNT(*) FROM (
	SELECT * FROM `UserConversation`
    GROUP BY `UserConversation`.`uid`
    HAVING `UserConversation`.`uid` IN (`pUid`, `pPartnerUid`)) AS Z);
    RETURN JSON_OBJECT("conversationId", @conversationId, "count", @count);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `messageGetById` (`pMessageId` INT) RETURNS LONGTEXT CHARSET utf8mb4  BEGIN
SET @json = (
    SELECT JSON_OBJECT(
        'id', `Message`.`id`,
        'conversationId', `Message`.`conversationId`,
        'text', `Message`.`text`,
        'media', `Message`.`media`,
        'user', (SELECT JSON_OBJECT(
            'id', `User`.`id`,
            'uid', `User`.`uid`,
            'name', `User`.`name`,
            'email', `User`.`email`,
            'accountType', `User`.`accountType`,
            'avatar', `User`.`avatar`,
            'background', `User`.`background`,
            'createdAt',`User`.`createdAt`,
            'updatedAt',`User`.`updatedAt`
        ) FROM `User` WHERE `User`.uid = `Message`.uid),
        'createdAt', `Message`.`createdAt`,
        'updatedAt', `Message`.`updatedAt`
    ) FROM `Message`WHERE `Message`.id = pMessageId
);
RETURN @json;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Conversation`
--

CREATE TABLE `Conversation` (
  `id` int(11) NOT NULL,
  `lastMessageId` int(11) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Conversation`
--

INSERT INTO `Conversation` (`id`, `lastMessageId`, `createdAt`, `updatedAt`) VALUES
(55, 18, '2022-08-11 09:47:20', NULL);

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
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Message`
--

INSERT INTO `Message` (`id`, `conversationId`, `uid`, `text`, `media`, `status`, `createdAt`, `updatedAt`) VALUES
(3, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'sssssssssss', '', 'active', '2022-08-09 01:24:44', NULL),
(4, 55, 'uid-41f58522-0f0f-11ed-903b-c6ef0857e0cf', 'sssssssssss', '', 'active', '2022-08-09 01:29:01', NULL),
(6, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'sssssssssss', '', 'active', '2022-08-09 01:44:28', NULL),
(7, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-09 08:45:19', NULL),
(8, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-09 08:46:55', NULL),
(9, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-09 08:55:56', NULL),
(10, 55, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-09 08:59:02', NULL),
(11, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-11 08:29:41', NULL),
(12, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'aaaaa', NULL, 'active', '2022-08-11 08:29:49', NULL),
(13, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'tesst nhe', NULL, 'active', '2022-08-11 08:40:04', NULL),
(14, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'tesst nhe', NULL, 'active', '2022-08-11 08:40:07', NULL),
(15, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'chao cau', NULL, 'active', '2022-08-11 08:40:15', NULL),
(16, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'chao cau minh la trma', NULL, 'active', '2022-08-11 08:40:26', NULL),
(17, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'chao cau minh la trma', NULL, 'active', '2022-08-11 09:47:00', NULL),
(18, 55, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'chao cau minh la trma', NULL, 'active', '2022-08-11 09:47:20', NULL);

--
-- Triggers `Message`
--
DELIMITER $$
CREATE TRIGGER `messageUpdateLatest` AFTER INSERT ON `Message` FOR EACH ROW UPDATE `Conversation` SET `Conversation`.`lastMessageId` = NEW.id WHERE `Conversation`.id = NEW.`conversationId`
$$
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
  `password` varchar(200) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `background` varchar(500) DEFAULT NULL,
  `accessToken` varchar(500) DEFAULT NULL,
  `fcmToken` varchar(500) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `uid`, `name`, `email`, `accountType`, `password`, `avatar`, `background`, `accessToken`, `fcmToken`, `createdAt`, `updatedAt`) VALUES
(487, 'uid-23990c54-16fb-11ed-bdc5-c6ef0857e0ce', 'quassssng', 'quangtesst@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicXVhbmd0ZXNzdEBnbWFpbC5jb20iLCJpYXQiOjE2NTk5NTAzNDAsImV4cCI6MTY5MTQ4NjM0MH0.tjTpPShGB2ydh3L3F7HHoC3bzK4i3SLKndSKr0tL4JDH_IobJjoDFYf5VXNwlq0uH0DZ61uz75kigfsFRYgM7g', 'sss', '2022-08-08 09:19:00', '2022-08-08 16:19:00'),
(437, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'Kathleen Mitchell', 'kathleen.mitchell.54195562@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoia2F0aGxlZW4ubWl0Y2hlbGwuNTQxOTU1NjJAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.mCXsD0YkmErrnBwIv6zwcbDSl3RkUu38PSC_18DOkmWGFsYzLNF44CywQ_bbpFwzo_4OOAyOzSsKiNr2uqC2Ow', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(438, 'uid-41ef215a-0f0f-11ed-903b-c6ef0857e0cf', 'Denise Buchanan', 'denise.buchanan.40861892@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZGVuaXNlLmJ1Y2hhbmFuLjQwODYxODkyQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.R4fsk1TTYQ5B5GrVdLFISYFCm0lcLC74vfW3rdJOSKsAPj105HFrxDouE1DfhImNQ3odCDM7_i1p7-TE0v-5jw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(439, 'uid-41f25f6e-0f0f-11ed-903b-c6ef0857e0cf', 'Carolyn Sumrall', 'carolyn.sumrall.9456285@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiY2Fyb2x5bi5zdW1yYWxsLjk0NTYyODVAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.tTWlOfmdOlu_BnxB-LsmnUoC9lEj4284ojKUXgSu4J0y34DZ-EYFamSRHkoQRZaTffaLw5gkFl7gbWDvQgekRg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(440, 'uid-41f58522-0f0f-11ed-903b-c6ef0857e0cf', 'Beatrice Good', 'beatrice.good.6150120@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYmVhdHJpY2UuZ29vZC42MTUwMTIwQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.vTw_6uWJqdluIo8xZgdT53kRzWlgGuyQ0ejH_r7kO1JZEoGzoh7b-ml1mGy4QYcvQSbkmd9Ey1uH9dvt-7Rk2w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(441, 'uid-41f5a8a4-0f0f-11ed-903b-c6ef0857e0cf', 'Maria Abshire', 'maria.abshire.64838307@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWFyaWEuYWJzaGlyZS42NDgzODMwN0BnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.RiRjrKjKIdueYAJOr7la0v_LSB4H-X9ti-tA6nRphkjVh2gLMhV2FDUEXjUq0zAi_ESTQHhR60x8moVHJ2xdnQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(442, 'uid-41f5c8c0-0f0f-11ed-903b-c6ef0857e0cf', 'Blair Mahan', 'blair.mahan.30851069@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYmxhaXIubWFoYW4uMzA4NTEwNjlAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.WD4Ato443asPJ0LVATwXD5_fKsyLm2qoJRs8MLhjNVtAmUBLmUeeoK869fzz3bO05pQKygX3kd1CHryHmmHGsg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(443, 'uid-41f5f9f8-0f0f-11ed-903b-c6ef0857e0cf', 'Gayle Bower', 'gayle.bower.89118171@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZ2F5bGUuYm93ZXIuODkxMTgxNzFAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.srIB3uXtqr6_o4uo4Bo9o0S6LmB4IrlVydaZjkcFjB4_syp_KxarJbu517MSPFvwlF6NpRp0ErFnv4mESW0Kgw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(444, 'uid-41f6231a-0f0f-11ed-903b-c6ef0857e0cf', 'Aileen Boone', 'aileen.boone.57705488@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYWlsZWVuLmJvb25lLjU3NzA1NDg4QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.9r9BhFac8qjNOmdbXGvCpoSsLjT2kxsds3DvT12Pf2NfKxNGqRjXqloRcYbzeKTqJZZD44DnciFTna9ylfKYSA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(445, 'uid-41f65844-0f0f-11ed-903b-c6ef0857e0cf', 'Ethel Donaldson', 'ethel.donaldson.72159997@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZXRoZWwuZG9uYWxkc29uLjcyMTU5OTk3QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.7lRkhD0H4EkfyBP8B6ZuQLaCkHU4jMi8qfqdA-itLIXzuy8mR5fmZLdOSY_pflUL_WekoWLhfRVKpEmiddofJg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(446, 'uid-41f6829c-0f0f-11ed-903b-c6ef0857e0cf', 'Frances Lathrop', 'frances.lathrop.16047163@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnJhbmNlcy5sYXRocm9wLjE2MDQ3MTYzQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.MiJK4zAUKV91TylqxpiymMj6GoKfFXTidva5UyhSO2A2aUOndascI9RWY9TWB1HyILLz61X_pvTv3grjeCAhHw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(447, 'uid-41f6a970-0f0f-11ed-903b-c6ef0857e0cf', 'Louise Williamson', 'louise.williamson.33930625@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibG91aXNlLndpbGxpYW1zb24uMzM5MzA2MjVAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.eeEDgMnRw_j1rl1Gj9KhASFDGClaivgT6H3Ywb_DUjSblUTTnqmBb3ixGDxUimmRllg4xtGoEvGl_BJQWdjpPQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(448, 'uid-41f6cdd8-0f0f-11ed-903b-c6ef0857e0cf', 'Edna Ray', 'edna.ray.98261470@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZWRuYS5yYXkuOTgyNjE0NzBAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.9Orjl2BRRCBmDmo2sW9VdC8YKJ5r8UM8FzhgJN6Ev4xaaTR1bzcIoy9z0JjIPZpKNVQvqwpdTpRIMPixbHcNdQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(449, 'uid-41f6f1dc-0f0f-11ed-903b-c6ef0857e0cf', 'Florence Elem', 'florence.elem.57658888@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZmxvcmVuY2UuZWxlbS41NzY1ODg4OEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.fIgRKh5OVgONSMyToSJagt4d9m4drGE8xdCBnEQx3z4j5cM89nRTHH5jfqIV7un5gGtMJiczt_C8dYtqYRXk2w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(450, 'uid-41f71676-0f0f-11ed-903b-c6ef0857e0cf', 'Deborah Callahan', 'deborah.callahan.25321285@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZGVib3JhaC5jYWxsYWhhbi4yNTMyMTI4NUBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.Cb8PcwgLKoYWBr0tUsnhWjKwDV3Q1WKoibQZchHdkixd8MFItE7qO9WVXnGcSAngp3BX1PC6TSJRVOQXWgWJow', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(451, 'uid-41f73b6a-0f0f-11ed-903b-c6ef0857e0cf', 'Freda Eason', 'freda.eason.61530291@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZnJlZGEuZWFzb24uNjE1MzAyOTFAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.z_C8b-LziocQWAZKFcfooDEp0zRz3gPSeFqm5xkP4ZkDMhdi2INULvtXoIThzi8AEpwVhQ8eIOfuyy8Ln3ADJg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(452, 'uid-41f762ac-0f0f-11ed-903b-c6ef0857e0cf', 'Diane Banks', 'diane.banks.91907542@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZGlhbmUuYmFua3MuOTE5MDc1NDJAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.umTBiGYZvhyFGBdP1dqUb3r3EhGE4cGHmi07C3Tb0wUfHkrQbiU8F1WVEK3BNlfsLggiu9kFtb6gEZFwzCgYjg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(453, 'uid-41f7857a-0f0f-11ed-903b-c6ef0857e0cf', 'Maria Stockdale', 'maria.stockdale.28445575@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWFyaWEuc3RvY2tkYWxlLjI4NDQ1NTc1QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.M4-yQ62rBrab0sOXhj-fneS_BcV5bXfxPnl7i98pz0oFhaKMzBTUu9JZxlDDo9EDXudgog62D9Xxk1uIqLryIw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(454, 'uid-41f7a4ec-0f0f-11ed-903b-c6ef0857e0cf', 'Nora Stith', 'nora.stith.59668048@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibm9yYS5zdGl0aC41OTY2ODA0OEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.-rM4qhXf1EVCGAV5uzL3VFJ5js6k45rWmo7RxFtLqxwm4Utqj7xeRA4AtbOuwgvl4kedcEZusRyCf1hpfnCjZg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(455, 'uid-41f7c800-0f0f-11ed-903b-c6ef0857e0cf', 'Mary Beverly', 'mary.beverly.15655320@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWFyeS5iZXZlcmx5LjE1NjU1MzIwQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.XkfBtNjEFsQHtLnvlvodt1eO61vCxHhBCaI3HWF8HZtj8oAqjKgWcdPw6ppX-MZ90xCyeM9vQOjNi2PDZGT57A', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(456, 'uid-41f7e70e-0f0f-11ed-903b-c6ef0857e0cf', 'Tammi Luna', 'tammi.luna.6755021@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoidGFtbWkubHVuYS42NzU1MDIxQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.DpasJdD4XIWuEquKxoYFSw1eUfwDIt0KkYlgoLL2f6WsobdlXf4c43x-Hs-mYqBoMhbd5ie5DleWLKSzp6m7VQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(457, 'uid-41f802fc-0f0f-11ed-903b-c6ef0857e0cf', 'Flora Quinones', 'flora.quinones.214812@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZmxvcmEucXVpbm9uZXMuMjE0ODEyQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.DXDB-2qTNeKnWN-nEXxuFa6qRnvcjDui_EIaKF73id1dgejD6uoaXzeFlsRm2Ayl82qeG0cRhPpAR7SXFxDpGg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(458, 'uid-41f81eea-0f0f-11ed-903b-c6ef0857e0cf', 'Margaret Garcia', 'margaret.garcia.98279025@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWFyZ2FyZXQuZ2FyY2lhLjk4Mjc5MDI1QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.N_AgU2nr7HQhbjKburc9pVrOQNy8yiFyaeXUpEm1My8hHO-l1ms8QqPlapKcF5bswqjbgGPYyexubia-UUxNTg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(459, 'uid-41f8397a-0f0f-11ed-903b-c6ef0857e0cf', 'Jennifer Fields', 'jennifer.fields.2985165@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiamVubmlmZXIuZmllbGRzLjI5ODUxNjVAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.8kqZXdM1kvgA4aSoh9YpLWQBDYcEmAjBKBCetoVGyJ8cQT-S6LbcZb14ttRL51BdeGboxmwbo66zdjYHG3uc3w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(460, 'uid-41f85522-0f0f-11ed-903b-c6ef0857e0cf', 'Linda Dixon', 'linda.dixon.35194324@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibGluZGEuZGl4b24uMzUxOTQzMjRAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.PZt57P7WxxDKMlFxp4DjZqgY5O7lJ8rFgsqUwnr3zVMBoHBneWHSNOZU_UVT2h83T9eUPjWwFw-v06r1z2r_-A', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(461, 'uid-41f870ac-0f0f-11ed-903b-c6ef0857e0cf', 'Anita Hyman', 'anita.hyman.34916038@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYW5pdGEuaHltYW4uMzQ5MTYwMzhAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.UCJZJWyPQiVxsrpFQi-X3M5rbiJqBz9JZAbrIVvpomfIQg1oOzHBRwSMVvv0iGnmQy0WESuPQIhR8AdHoR4DCw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(462, 'uid-41f89370-0f0f-11ed-903b-c6ef0857e0cf', 'Joy Hughes', 'joy.hughes.29674550@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiam95Lmh1Z2hlcy4yOTY3NDU1MEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.VBiAaFoJodEi2napV-3oEdfg0yuHBpgjEJUzVh4yVcMek8rAClN9SR76REq6usS2s_SMSsFexXcf07BrQKtb-w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(463, 'uid-41f8ae78-0f0f-11ed-903b-c6ef0857e0cf', 'Eleanor Ward', 'eleanor.ward.26987845@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZWxlYW5vci53YXJkLjI2OTg3ODQ1QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.b2GWygNWnP7P3aHNPeI0fQieLQ1vZHxwEE9EYSSri--_9epzBV3FlVKJoNHedvuxHzMpWSCeXuv5z5A31BUP_Q', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(464, 'uid-41f8c99e-0f0f-11ed-903b-c6ef0857e0cf', 'Ashley Sosa', 'ashley.sosa.76332736@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYXNobGV5LnNvc2EuNzYzMzI3MzZAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.JCrMsV57Y6naWD9u98ojS3QzzY6i1Ck-gUXibDKViPzggthxHemApCDS7_6qu8NYZJ8awVEYlWck02odtu983g', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(465, 'uid-41f8e41a-0f0f-11ed-903b-c6ef0857e0cf', 'Nancy Gallup', 'nancy.gallup.12344437@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibmFuY3kuZ2FsbHVwLjEyMzQ0NDM3QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.XyVdIJwQ2yr7ByTmE72O6-LeXMVwBW633Mjf3OHz5JymWrxOCQ32RmIMWiI6n_c89GndkTLyL6CZIPpQloX_nA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(466, 'uid-41f9077e-0f0f-11ed-903b-c6ef0857e0cf', 'Melissa Fournier', 'melissa.fournier.19940444@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWVsaXNzYS5mb3Vybmllci4xOTk0MDQ0NEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.Kh8e1mpB5e1HE2TW3BIEOlkVLL_-SzZ2C44gNy2qzTEcVcM424qjAeYNjaX1lSE42b5DHzsxMBWXrUQdcLhH5g', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(467, 'uid-41f91bd8-0f0f-11ed-903b-c6ef0857e0cf', 'Kimberly Craig', 'kimberly.craig.33486684@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoia2ltYmVybHkuY3JhaWcuMzM0ODY2ODRAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.8RoNlVgU8bUyLXJWD-Jwk3vWTqtQae0AtuxZziVyUYwyEZ0zP0KF5WGsKLhg5gr8naRYy_7wKcdkPAIkQUdMAQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(468, 'uid-41f93730-0f0f-11ed-903b-c6ef0857e0cf', 'Joyce Martinez', 'joyce.martinez.79427679@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiam95Y2UubWFydGluZXouNzk0Mjc2NzlAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.z_EmBDTM_d_JQYZHryGptHJ2HUHjd3rRtRqC1bPstzz1TIqLRRY0WDEU7_lrEihJFSj_Qgj6v2lDsJaj7fjoDQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(469, 'uid-41f94ee6-0f0f-11ed-903b-c6ef0857e0cf', 'Rosalie Parsons', 'rosalie.parsons.94072852@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicm9zYWxpZS5wYXJzb25zLjk0MDcyODUyQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.pXyfw-u4GZ59dKj74IddqSKNRX9CzZdST99LJ_wzSIcg76UhA0epYwSprnu5zVoeHc08Pb9Iucep5KN6qO-rVg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(470, 'uid-41f96c28-0f0f-11ed-903b-c6ef0857e0cf', 'Dorothy Reyes', 'dorothy.reyes.13516260@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZG9yb3RoeS5yZXllcy4xMzUxNjI2MEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.0WlroNCy5e8Aou2AFYeItxd3yCO6rD3I4lbpR6R8W4i25SiFfWLYUcq7zDb4E0JOwmg-iYMAqAtGCgCg51utQA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(471, 'uid-41f99a04-0f0f-11ed-903b-c6ef0857e0cf', 'Shayna Burns', 'shayna.burns.53912875@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoic2hheW5hLmJ1cm5zLjUzOTEyODc1QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.yUpSOEGduLQYdpwjUYdUY9QspVy1dekmMUUoO5wIBCGEzSGjzIGag2a9lxAIenpdR6q8bIB6yA5D0LNN_W1x-A', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(472, 'uid-41f9b566-0f0f-11ed-903b-c6ef0857e0cf', 'Wilma Pagan', 'wilma.pagan.13960006@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoid2lsbWEucGFnYW4uMTM5NjAwMDZAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.HbBAhRfdXOX2kknqz_6n_1aVoKPTylffkz4BLOk087WERkD4bvwOsH2T7bW1Cc6IgIuIRnPE2bBs_yyL2kQYGg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(473, 'uid-41f9cbb4-0f0f-11ed-903b-c6ef0857e0cf', 'Bonnie Granger', 'bonnie.granger.11311813@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYm9ubmllLmdyYW5nZXIuMTEzMTE4MTNAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.4_7lfqnosT7ryrC1VrVpkFe0sQBZ8ThKmJE0JTXVfqiiNmXehETfOodlACTLtcZNOHZw77ewL9xzgsq8Qw0IQA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(474, 'uid-41f9dfb4-0f0f-11ed-903b-c6ef0857e0cf', 'Lisa Hill', 'lisa.hill.97599370@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibGlzYS5oaWxsLjk3NTk5MzcwQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.UjgVfiFuFPMa1qpFPa-DQJwz0IO0eaL8TxzPjU4axiMVk7lF5c6rPHpU1VvVi8MXank7igmR38YPdURNvDEq6w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(475, 'uid-41f9f99a-0f0f-11ed-903b-c6ef0857e0cf', 'Linda Leff', 'linda.leff.56967965@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibGluZGEubGVmZi41Njk2Nzk2NUBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.O5bFqa8A1ryvHFfeqQ06XiMzxZywmT4FaWq1btM_CrLErD-kJZGH_-8-Dez5aapiYE9ScRRF2jWxZmC1cNpzcQ', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(476, 'uid-41fa0d22-0f0f-11ed-903b-c6ef0857e0cf', 'Stephanie Presler', 'stephanie.presler.52528279@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoic3RlcGhhbmllLnByZXNsZXIuNTI1MjgyNzlAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.lzJdH9I_illxZpQjtx_HNi1-09IyvVyGgFatJQVcICmNdSCwuvEfS1fdUFLj34tivhhyL-2GvzyCBVOjIRmkpA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(477, 'uid-41fa21c2-0f0f-11ed-903b-c6ef0857e0cf', 'Charlotte Leonard', 'charlotte.leonard.35629525@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiY2hhcmxvdHRlLmxlb25hcmQuMzU2Mjk1MjVAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.KWXXuvp33vEGpxYrvnD-whUGNPV7tNonHgWC4YGbZmEuM5CiUnLc3p5wzPZh9iGyYdkM9gTyQsSCQ2jG_Wq5tA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(478, 'uid-41fa38e2-0f0f-11ed-903b-c6ef0857e0cf', 'Hilary Roderick', 'hilary.roderick.38107526@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiaGlsYXJ5LnJvZGVyaWNrLjM4MTA3NTI2QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.wog2LiWtcTPEUG2H5_CBUnrD6wD3hrZ6Egmr0lepyAGuAMBK8w6vQWsjOvLqLVP1EH2xfVeXeWwn1mNym2CL4A', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(479, 'uid-41fa4c60-0f0f-11ed-903b-c6ef0857e0cf', 'Carolyn Dahl', 'carolyn.dahl.13259393@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiY2Fyb2x5bi5kYWhsLjEzMjU5MzkzQGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.FcuA4GXgoXJPg14-AyTAccjGS4R0_i0wxeVxs36dhsUU61CST_1eTLFEqTK5j91-2xICQoLWbutRGzzremXKBg', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(480, 'uid-41fa5ebc-0f0f-11ed-903b-c6ef0857e0cf', 'Hazel Headrick', 'hazel.headrick.60828423@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiaGF6ZWwuaGVhZHJpY2suNjA4Mjg0MjNAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.tDeoQLHxXKyyFg2ltvA638axjrTTaWcntF5F6Q_2yd8kXw2u8orvos0GEqcIuvZ-oWNkcaXUXp5b1VfIZXJvGw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(481, 'uid-41fa7104-0f0f-11ed-903b-c6ef0857e0cf', 'Maria Looney', 'maria.looney.15226067@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoibWFyaWEubG9vbmV5LjE1MjI2MDY3QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.MCAhMztBKWtpTHJ0AE0KkkHNBE9bDFxWE3t0iy3-Jt0KKe6w4g0qK_ck-wLxHBKC9TspwFNmhoB9CKOYybLOKw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(482, 'uid-41fa83e2-0f0f-11ed-903b-c6ef0857e0cf', 'Barbara Mathews', 'barbara.mathews.27472784@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYmFyYmFyYS5tYXRoZXdzLjI3NDcyNzg0QGdtYWlsLmNvbSIsImlhdCI6MTY1OTA3OTM3MiwiZXhwIjoxNjkwNjE1MzcyfQ.-UqV_WOvMbrStxBdpjhcDwj_QvxDzoKQBSpIqDe2-4RmLmkRJ6YfSZHdEf4qHJLXhtIMlXRWz5MRnzjdKJ9EHA', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(483, 'uid-41fa9ec2-0f0f-11ed-903b-c6ef0857e0cf', 'Ellen Wadkins', 'ellen.wadkins.25347535@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZWxsZW4ud2Fka2lucy4yNTM0NzUzNUBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.d7_QkTR1b5ThxKyLhoBuNyvzQ0Tj5p_XPtheQ1XF7KCZDD3IMvz4uts_uyuuMJW2fRSkLQ694NNrq3Y_GmiyOw', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(484, 'uid-41fab574-0f0f-11ed-903b-c6ef0857e0cf', 'Juanita Lopez', 'juanita.lopez.42037462@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoianVhbml0YS5sb3Blei40MjAzNzQ2MkBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.MBA64yBYUQTU0oE30_dNEj_gTfpqS_VC6eodPatIK3ZkgRsIhvxsnRB-SZ54qhdmzvlnP7Zfc0iOiN__hPuAog', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(485, 'uid-41fac7da-0f0f-11ed-903b-c6ef0857e0cf', 'Audrey Sims', 'audrey.sims.82613616@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiYXVkcmV5LnNpbXMuODI2MTM2MTZAZ21haWwuY29tIiwiaWF0IjoxNjU5MDc5MzcyLCJleHAiOjE2OTA2MTUzNzJ9.U2KG42B1OW9DPfCkhNNf10uRnPbuWWzoqKE3-zjjesdHpyCmlrfGzIBst9QHD3a70GsIFr6Nnf-iTqULO8-45w', NULL, '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(486, 'uid-41fadad6-0f0f-11ed-903b-c6ef0857e0cf', 'Sherry Warren', 'sherry.warren.63619010@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoic2hlcnJ5LndhcnJlbi42MzYxOTAxMEBnbWFpbC5jb20iLCJpYXQiOjE2NTkwNzkzNzIsImV4cCI6MTY5MDYxNTM3Mn0.ZVYy67UM_TRlGM2VreMYndFMDO5fXWrfciU6b3rVs161iPj5oRqslfYpw7jpTVU-ndo9wyFPPBa1e3vRTVbbAg', 'flEBJM_xRGGM9-0s8PGDkC:APA91bGWRtCQF51I_dOHp3mWqbJFDruVK0p5wO-LUdkZm-jh5vvWa1SZCWMyG6dQn0S083XS5yDsSx4bEAEW1AMKaj7DUrYAjkabcxEIBHva9C3ZKNKkbmq2ubYAh2gYNMijTEdERBt1', '2022-07-29 07:22:52', '2022-07-29 14:22:52'),
(436, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 'Nguyen Dang Quang', 'quangnd.nta@gmail.com', 'normal', '32ff5fea7d6c46c0590a4f3bbc3293f54025ab332a59d5d3a3c8271920b857470f3c71b90c3b4f70cba88c0d3a2a5ce8d065332b3e9e539a5f7e7ec0fcfaaf3f', NULL, NULL, 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoicXVhbmduZC5udGFAZ21haWwuY29tIiwiaWF0IjoxNjYwMjAxNjAyLCJleHAiOjE2OTE3Mzc2MDJ9.QurOppSEhHYn-w4OMhPfL6jQRtMx9ISuEMnDdEFr9nB-o_swt5z4IWjU3G0KobJsu0srZgCqnmENwBzuNrNVIg', 'fXmu9e0XTZyZe7sJCHmZRj:APA91bFl7XCsG95T1301tzPzYkBBI5XWIjc8CObUAXWO43czOeidJcGbCNDcbT8GEql_pZ5VQYT8TiyBm4e865wZpwIrjJjN7-oGUNvJmphD9a7TgB2ZCsqjpkNRr5Ge96zdw0WAgvt2', '2022-07-29 07:11:41', '2022-08-11 14:06:42');

-- --------------------------------------------------------

--
-- Table structure for table `UserConversation`
--

CREATE TABLE `UserConversation` (
  `id` int(11) NOT NULL,
  `uid` varchar(50) NOT NULL,
  `conversationId` int(11) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `UserConversation`
--

INSERT INTO `UserConversation` (`id`, `uid`, `conversationId`, `createdAt`, `updatedAt`) VALUES
(93, 'uid-b215d4bc-0f0d-11ed-903b-c6ef0857e0cf', 55, '2022-08-09 01:03:23', '2022-08-12 08:35:28'),
(94, 'uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 55, '2022-08-09 01:03:23', '2022-08-12 08:35:28');

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversationId` (`conversationId`),
  ADD KEY `uid` (`uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Conversation`
--
ALTER TABLE `Conversation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `Message`
--
ALTER TABLE `Message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=488;

--
-- AUTO_INCREMENT for table `UserConversation`
--
ALTER TABLE `UserConversation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

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
