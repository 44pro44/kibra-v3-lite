-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.5.10-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`, `type`, `unique`, `description`, `image`, `shouldClose`, `combinable`) VALUES ('motelkeys', 'Motel Anahtarı', 0.2, 0, 1, 'item', 'true', 'Oda anahtarına benziyor...', 'motelkeys.png', '0', NULL);
-- Dumping structure for table essentialmode.almez_motels
CREATE TABLE IF NOT EXISTS `almez_motels` (
  `key` varchar(50) DEFAULT NULL,
  `owner` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table essentialmode.almez_motels: ~49 rows (approximately)
/*!40000 ALTER TABLE `almez_motels` DISABLE KEYS */;
INSERT INTO `almez_motels` (`key`, `owner`) VALUES
	('1', ''),
	('2', ''),
	('3', ''),
	('4', ''),
	('5', ''),
	('6', ''),
	('7', ''),
	('8', ''),
	('9', ''),
	('10', ''),
	('11', ''),
	('12', ''),
	('13', ''),
	('14', ''),
	('15', ''),
	('16', ''),
	('17', ''),
	('18', ''),
	('19', ''),
	('20', ''),
	('21', ''),
	('22', ''),
	('23', ''),
	('24', ''),
	('25', ''),
	('26', ''),
	('27', ''),
	('28', ''),
	('29', ''),
	('30', ''),
	('31', ''),
	('32', ''),
	('33', ''),
	('34', ''),
	('35', ''),
	('36', ''),
	('37', ''),
	('38', ''),
	('39', ''),
	('40', ''),
	('41', ''),
	('42', ''),
	('43', ''),
	('44', ''),
	('45', ''),
	('46', ''),
	('47', ''),
	('48', ''),
	('49', ''),
	('50', ''),
	('51', ''),
	('52', ''),
	('53', ''),
	('54', ''),
	('55', ''),
	('56', ''),
	('57', ''),
	('58', ''),
	('59', ''),
	('60', ''),
	('61', ''),
	('62', ''),
	('63', ''),
	('64', ''),
	('65', ''),
	('66', ''),
	('67', ''),
	('68', ''),
	('69', ''),
	('70', ''),
	('71', ''),
	('72', ''),
	('73', ''),
	('74', ''),
	('75', ''),
	('76', ''),
	('77', ''),
	('78', ''),
	('79', ''),
	('80', ''),
	('81', ''),
	('82', ''),
	('83', ''),
	('84', ''),
	('85', ''),
	('86', ''),
	('87', ''),
	('88', ''),
	('89', ''),
	('90', ''),
	('91', '');

CREATE TABLE IF NOT EXISTS `almez_motels_pinkcage` (
  `key` varchar(50) DEFAULT NULL,
  `owner` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `almez_motels_pinkcage` (`key`, `owner`) VALUES
	('92', ''),
	('93', ''),
	('94', ''),
	('95', ''),
	('96', ''),
	('97', ''),
	('98', ''),
	('99', ''),
	('100', ''),
	('101', ''),
	('102', ''),
	('103', ''),
	('104', ''),
	('105', '');
