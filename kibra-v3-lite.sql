CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `steam` longtext DEFAULT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `position` varchar(255) DEFAULT '{"x":-269.4,"y":-955.3,"z":31.2,"heading":205.8}',
  `firstname` varchar(50) DEFAULT '',
  `lastname` varchar(50) DEFAULT '',
  `dateofbirth` varchar(25) DEFAULT '',
  `sex` varchar(10) DEFAULT '0',
  `height` varchar(5) DEFAULT '',
  `status` longtext DEFAULT NULL,
  `tattoos` longtext DEFAULT NULL,
  `ped` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `citizenid` varchar(25) NOT NULL,
  `cid` varchar(25) NOT NULL,
  `iban` varchar(6) NOT NULL DEFAULT '0',
  `mugshot` varchar(255) DEFAULT 'https://i.imgur.com/HAF61R9.png',
  `aranma` mediumtext DEFAULT '[]',
  `phone_number` varchar(10) DEFAULT NULL,
  `armor` varchar(255) NOT NULL,
  `photo` mediumtext NULL;
  'loadout' varchar(25) DEFAULT '[]',
  `crypto` varchar(255) DEFAULT '{"bitcoin": 0, "ethereum": 0, "bitcoin-cash": 0, "bitcoin-sv": 0, "litecoin": 0, "binance-coin": 0, "monero": 0, "dash": 0, "zcash": 0, "maker": 0}',
  `is_dead` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=43010 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `outfitId` (`outfitId`)
) ENGINE=InnoDB AUTO_INCREMENT=8970 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` float NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  `type` longtext DEFAULT 'item',
  `unique` longtext DEFAULT 'false',
  `description` longtext DEFAULT 'Bilinmiyor',
  `image` longtext DEFAULT NULL,
  `shouldClose` longtext DEFAULT '0',
  `combinable` varchar(50) DEFAULT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`, `type`, `unique`, `description`, `image`, `shouldClose`, `combinable`, `id`) VALUES
('cash', 'Nakit Para', 0, 0, 1, 'item', 'false', 'Nakit Para', 'cash.png', '0', NULL, 1),
('phone', 'Telefon', 1, 0, 1, 'item', 'true', 'Bilinmiyor', 'phone.png', '0', NULL, 3),
('pistol_ammo', 'Tabanca Mermisi', 0.1, 0, 1, 'item', 'false', 'Tabanca mermi kutusu.', 'pistol_ammo.png', '0', NULL, 4),
('pistol_extended', 'Tab. Uzatılmış', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'extendedclip.png', '0', NULL, 5),
('pistol_flashlight', 'Tab. Fener', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'flashlight.png', '0', NULL, 6),
('pistol_scope', 'Tab. Dürbünü', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'scope.png', '0', NULL, 7),
('pistol_suppressor', 'Tab. Susturucu', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'suppressor.png', '0', NULL, 8),
('rifle_ammo', 'Rifle Mermisi', 0.1, 0, 1, 'item', 'false', 'Rifle mermi kutusu.', 'rifle_ammo.png', '0', NULL, 9),
('rifle_extendedclip', 'Rifle Uzatılmış', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'extendedclip.png', '0', NULL, 10),
('rifle_flashlight', 'Rifle Fener', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'flashlight.png', '0', NULL, 11),
('rifle_scope', 'Rifle Dürbün', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'scope.png', '0', NULL, 12),
('rifle_suppressor', 'Rifle Susturucu', 0.3, 0, 1, 'item', 'true', 'Ateş Sesini Muazzam Ölçüde Azaltan Ekipman.', 'suppressor.png', '0', NULL, 13),
('shotgun_ammo', 'Shotgun Mermisi', 0.1, 0, 1, 'item', 'false', 'Shotgun mermi kutusu.', 'shotgun_ammo.png', '0', NULL, 14),
('smg_ammo', 'Smg Mermisi', 0.1, 0, 1, 'item', 'false', 'Smg mermi kutusu', 'smg_ammo.png', '0', NULL, 15),
('smg_extendedclip', 'SMG Uzatılmış', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'extendedclip.png', '0', NULL, 16),
('smg_flashlight', 'SMG Feneri', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'flashlight.png', '0', NULL, 17),
('smg_scope', 'SMG Dürbünü', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'scope.png', '0', NULL, 18),
('smg_suppressor', 'SMG Susturucu', 0.3, 0, 1, 'item', 'true', 'Bilinmiyor', 'suppressor.png', '0', NULL, 19),
('water', 'Su', 0.01, 0, 1, 'item', 'false', 'Bilinmiyor', 'water.png', '0', NULL, 20),
('weapon_advancedrifle', 'Geliştirilmiş Tüfek', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_ADVANCEDRIFLE.png', '0', NULL, 21),
('weapon_appistol', 'Ap Pistol', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_appistol.png', '0', NULL, 22),
('weapon_assaultrifle', 'Ak-47', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_ASSAULTRIFLE.png', '0', NULL, 23),
('weapon_assaultsmg', 'PD F40', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_assaultsmg.png', '0', NULL, 24),
('weapon_bat', 'Beyzbol Sopasi', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_BAT.png', '0', NULL, 25),
('weapon_battleaxe', 'Balta', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_BATTLEAXE.png', '0', NULL, 26),
('weapon_carbinerifle_mk2', 'PD 762', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_CARBINERIFLE_MK2.png', '0', NULL, 27),
('weapon_combatpdw', 'SAUER MPX', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_combatpdw.png', '0', NULL, 28),
('weapon_combatpistol', 'GLOCK 17', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_combatpistol.png', '0', NULL, 29),
('weapon_compactrifle', 'DRACO', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_compactrifle.png', '0', NULL, 30),
('weapon_crowbar', 'Levye', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_CROWBAR.png', '0', NULL, 31),
('weapon_flashlight', 'El Feneri', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'flashlight.png', '0', NULL, 32),
('weapon_garbagebag', 'Bin bag', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', NULL, '0', NULL, 33),
('weapon_gusenberg', 'TOMMY', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_GUSENBERG.PNG', '0', NULL, 34),
('weapon_heavypistol', 'Desert Eagle', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_heavypistol.png', '0', NULL, 35),
('weapon_knife', 'Bicak', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_knife.png', '0', NULL, 36),
('weapon_knuckle', 'Musta', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_KNUCKLE.png', '0', NULL, 37),
('weapon_machinepistol', 'Tec-9', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_machinepistol.png', '0', NULL, 38),
('weapon_microsmg', 'Micro SMG', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_microsmg.png', '0', NULL, 39),
('weapon_minismg', 'Mini SMG', 1.5, 0, 1, 'weapon', 'false', 'Bilinmiyor', 'weapon_minismg.png', '0', NULL, 40),
('weapon_nightstick', 'Jop', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_nightstick.png', '0', NULL, 41),
('weapon_pistol', 'Colt 1911', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_PISTOL.png', '0', NULL, 42),
('weapon_pistol50', 'Desert Eagle', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_PISTOL50.png', '0', NULL, 43),
('weapon_pistol_mk2', 'PD 9MM', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_PISTOL_MK2.png', '0', NULL, 44),
('weapon_poolcue', 'Sopa', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_poolcue.png', '0', NULL, 45),
('weapon_revolver', 'Revolver', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_REVOLVER_MK2.png', '0', NULL, 46),
('weapon_sawnoffshotgun', 'SAWED OFF', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_SAWNOFFSHOTGUN.png', '0', NULL, 47),
('weapon_smg', 'MP-5 SMG', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_smg.png', '0', NULL, 48),
('weapon_smg_mk2', 'MP5-K', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'WEAPON_SMG_MK2.png', '0', NULL, 49),
('weapon_snspistol', 'BU9 Nano', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_snspistol.png', '0', NULL, 50),
('weapon_stungun', 'Teaser', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_stungun.png', '0', NULL, 51),
('weapon_switchblade', 'Kelebek', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_switchblade.png', '0', NULL, 52),
('weapon_vintagepistol', 'Vintage', 1, 0, 1, 'weapon', 'true', 'Bilinmiyor', 'weapon_vintagepistol.png', '0', NULL, 53),
('motel_key', 'Motel Anahtarı', 1, 0, 1, 'item', 'true', 'Bilinmiyor', 'anahtar.png', '0', NULL, 56),
('bandage', 'Bandaj', 2, 0, 1, 'item', 'false', 'Bilinmiyor', 'bandage.png', '0', NULL, 58),
('medikit', 'Medikit', 2, 0, 1, 'item', 'false', 'Bilinmiyor', 'medikit.png', '0', NULL, 59),
('carkey', 'Araç Anahtarı', 1, 0, 1, 'item', 'true', 'Bilinmiyor', 'vehiclekey.png', '0', NULL, 60),
('telsiz', 'Telsiz', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'radio.png', '0', NULL, 76),
('gps', 'GPS', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'gps.png', '0', NULL, 77),
('MedArmor', 'Orta Seviye Zırh', 0.5, 0, 1, 'item', 'false', 'Bilinmiyor', 'medarmor.png', '0', NULL, 78),
('HeavyArmor', 'Güçlü Zırh', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'celikyelek.png', '0', NULL, 79),
('mdt', 'Polis Tableti', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'tablet.png', '0', NULL, 80),
('fixkit', 'Kit réparation', 3, 0, 1, 'item', 'false', 'Bilinmiyor', NULL, '0', NULL, 93),
('tamirkiti', 'Tamir Kiti', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'fixkit.png', '0', NULL, 94),
('das', 'Taş', 1, 10, 1, 'item', 'false', 'Bilinmiyor', 'tas.png', '0', NULL, 99),
('dastoken', 'Madenci Tokeni', 0, 10, 1, 'item', 'false', 'Bilinmiyor', 'token.png', '0', NULL, 100),
('kazma', 'Kazma', 1, 10, 1, 'item', 'false', 'Bilinmiyor', 'kazma.png', '0', NULL, 101),
('blowtorch', 'Kaynak Makinesi', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'kaynakmakine.png', '0', NULL, 102),
('c4', 'C4', 1, 0, 1, 'item', 'false', 'Bilinmiyor', 'c4.png', '0', NULL, 103),
('thermite', 'Termit', 0.31, 0, 1, 'item', 'false', 'Bilinmiyor', 'thermite.png', '0', NULL, 114),
('cola', 'Kola', 0.4, 0, 1, 'item', 'false', 'Bilinmiyor', 'cola.png', '0', NULL, 123),
('redbull', 'Redbull', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'redbull.png', '0', NULL, 124),
('bread', 'Ekmek', 0.5, 0, 1, 'item', 'false', 'Bilinmiyor', 'bread.png', '0', NULL, 125),
('hamburger', 'Hamburger', 0.3, 0, 1, 'item', 'false', 'Bilinmiyor', 'hamburger.png', '0', NULL, 126);

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `jobs` (`name`, `label`) VALUES
('ambulance', 'EMS'),
('benny', 'BennyMekanik'),
('cardealer', 'Concessionnaire'),
('galeri', 'Araç Galerisi'),
('kargocu', 'Kargocu'),
('lscustom', 'LS Custom'),
('oduncu', 'Oduncu'),
('offambulance', 'Mesai Dışı Ambulans'),
('offpolice', 'Mesai Dışı Polis'),
('police', 'LSPD'),
('sheriff', 'LSSD'),
('unemployed', 'Sivil');


CREATE TABLE communityservice (
	`identifier` VARCHAR(100) NOT NULL,
	`actions_remaining` int(10) NOT NULL,
	PRIMARY KEY (identifier)
);

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Sivil', 200, '{}', '{}'),
(2, 'ambulance', 0, 'ambulance', 'Ambulans Şöförü', 20, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(3, 'ambulance', 1, 'doctor', 'Doktor', 40, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(4, 'ambulance', 2, 'chief_doctor', 'Başhekim', 60, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(5, 'ambulance', 3, 'boss', 'Hastane Sahibi', 80, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(6, 'police', 0, 'recruit', 'Stajyer Polis', 20, '{}', '{}'),
(7, 'police', 1, 'officer', 'Polis Memuru', 40, '{}', '{}'),
(8, 'police', 2, 'sergeant', 'Kıdemli Polis Memuru', 60, '{}', '{}'),
(9, 'police', 3, 'lieutenant', 'Baş Polis Memuru', 85, '{}', '{}'),
(10, 'police', 4, 'boss', 'Komiser Yardımcısı', 100, '{}', '{}'),
(11, 'police', 5, 'boss1', 'Komiser', 100, '{}', '{}'),
(12, 'police', 6, 'boss2', 'Başkomiser', 100, '{}', '{}'),
(13, 'police', 7, 'boss3', 'Şef', 100, '{}', '{}'),
(14, 'galeri', 1, 'galeri', 'Patron', 200, '{}', '{}'),
(15, 'cardealer', 0, 'recruit', 'Recrue', 10, '{}', '{}'),
(16, 'cardealer', 1, 'novice', 'Novice', 25, '{}', '{}'),
(17, 'cardealer', 2, 'experienced', 'Experimente', 40, '{}', '{}'),
(18, 'cardealer', 3, 'boss', 'Patron', 0, '{}', '{}'),
(19, 'sheriff', 0, 'recruit', 'Çaylak Şerif', 20, '{}', '{}'),
(20, 'sheriff', 1, 'officer', 'Memur Şerif', 40, '{}', '{}'),
(21, 'sheriff', 2, 'sergeant', 'Dedektif', 60, '{}', '{}'),
(22, 'sheriff', 3, 'lieutenant', 'Şerif Amiri', 85, '{}', '{}'),
(23, 'sheriff', 4, 'boss', 'Şef', 100, '{}', '{}'),
(24, 'lscustom', 0, 'recrue', 'Stajyer', 12, '{}', '{}'),
(25, 'lscustom', 1, 'novice', 'Tekniker', 24, '{}', '{}'),
(26, 'lscustom', 2, 'experimente', 'Usta', 36, '{}', '{}'),
(27, 'lscustom', 3, 'chief', 'Muhasebe', 48, '{}', '{}'),
(28, 'lscustom', 4, 'boss', 'Patron', 0, '{}', '{}'),
(29, 'benny', 0, 'recrue', 'Recrue', 12, '{}', '{}'),
(30, 'benny', 1, 'novice', 'Novice', 24, '{}', '{}'),
(31, 'benny', 2, 'experimente', 'Experimente', 36, '{}', '{}'),
(32, 'benny', 3, 'chief', 'Muhasebe', 48, '{}', '{}'),
(33, 'benny', 4, 'boss', 'Patron', 0, '{}', '{}');




CREATE TABLE IF NOT EXISTS `crew_phone_bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT 1,
  `identifier` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `crew_phone_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) NOT NULL COMMENT '',
  `num` varchar(10) NOT NULL COMMENT '',
  `incoming` int(11) NOT NULL COMMENT '',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16291 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45219 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=992 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `twitter_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1624 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_tweets_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10712 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
  KEY `FK_twitter_likes_twitter_tweets` (`tweetId`),
  CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
  CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=605 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `yellowpages_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `likes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_yellowpages_posts_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_yellowpages_posts_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

- tablo yapısı dökülüyor qbus.tgiann_mdt_arananlar
CREATE TABLE IF NOT EXISTS `tgiann_mdt_arananlar` (
  `citizenid` varchar(50) DEFAULT NULL,
  `sebep` longtext DEFAULT NULL,
  `baslangic` varchar(255) DEFAULT NULL,
  `bitis` varchar(255) DEFAULT NULL,
  `isim` varchar(255) DEFAULT NULL,
  `img` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tgiann_mdt_cezalar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `aciklama` longtext DEFAULT NULL,
  `ceza` varchar(255) DEFAULT NULL,
  `polis` mediumtext DEFAULT NULL,
  `zanli` mediumtext DEFAULT NULL,
  `cezalar` longtext DEFAULT NULL,
  `olayid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1634 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tgiann_mdt_olaylar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aciklama` longtext DEFAULT NULL,
  `polis` mediumtext DEFAULT NULL,
  `zanli` mediumtext DEFAULT NULL,
  `zaman` varchar(50) DEFAULT current_timestamp(),
  `esyalar` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1188 DEFAULT CHARSET=utf8;

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



