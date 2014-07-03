--
-- Each message in the system
--
DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `callid` varchar(255) DEFAULT NULL,
  `callerid` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `replyto` mediumint(9) DEFAULT NULL,
  `archived` tinyint(1) DEFAULT NULL,
  `dt` datetime,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;

--
-- Used to store user meta data
--
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `callerid` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `language` varchar(3) DEFAULT 'bn',
   PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;

--
-- Used to store listened messages 
--
DROP TABLE IF EXISTS `listened`;

CREATE TABLE `listened` (
  `message_id` mediumint(9) NOT NULL,
  `user_id` mediumint(9) NOT NULL
) ENGINE=MyISAM;

-- 
-- Logging table
--
DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
  `dt` datetime DEFAULT NULL,
  `callid` varchar(255) DEFAULT NULL,
  `callerid` varchar(255) DEFAULT NULL,
  `user_id` mediumint(8) DEFAULT NULL,
  `context` varchar(255) DEFAULT NULL,
  `exten` varchar(255) DEFAULT NULL,
  `prio` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `action_params` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
