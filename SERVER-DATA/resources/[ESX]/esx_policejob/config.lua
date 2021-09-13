Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(458.051, -997.73, 30.6895),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.5,
			Colour  = 3
		},

		Cloakrooms = {
		--	vector3(471.346, -989.06, 25.7346)
		},

		Armories = {
		--	vector3(484.316, -1002.0, 25.7346)
		},

		Vehicles = {
			{
				Spawner = vector3(461.328, -981.82, 25.6998),
				InsideShop = vector3(454.462, -981.16, 25.6998),
				SpawnPoints = {
					{ coords = vector3(445.129, -986.28, 25.6998), heading = 269.8, radius = 1.0 },
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(461.40036010742,-985.91961669922,43.691867828369),
				InsideShop = vector3(449.36776733398,-981.13262939453,43.691741943359),
				SpawnPoints = {
					{ coords = vector3(449.36776733398,-981.13262939453,43.691741943359), heading = 92.91, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(460.730, -985.55, 30.7280)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = { --Stajyer Polis
		--{ weapon = 'WEAPON_COMBATPISTOL', price = 5 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	officer = { --Polis
		{ weapon = 'WEAPON_COMBATPISTOL', price = 5 },
		--{ weapon = 'WEAPON_CARBINERIFLE', price = 1500 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	sergeant = { -- Kıdemli Polis
		{ weapon = 'WEAPON_COMBATPISTOL', price = 5 },
		{ weapon = 'WEAPON_CARBINERIFLE', price = 1 },
		{ weapon = 'WEAPON_SMG', price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	intendent = { -- Komiser
		{ weapon = 'WEAPON_COMBATPISTOL', price = 5 },
		{ weapon = 'WEAPON_CARBINERIFLE', price = 1 },
		{ weapon = 'WEAPON_SMG', price = 1 },
		--{ weapon = 'WEAPON_PUMPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	lieutenant = { -- Başkomiser
		{ weapon = 'WEAPON_COMBATPISTOL', price = 1 },
		{ weapon = 'WEAPON_CARBINERIFLE', price = 1 },
		{ weapon = 'WEAPON_SMG', price = 1 },
		--{ weapon = 'WEAPON_PUMPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	chef = { -- Amir
		{ weapon = 'WEAPON_COMBATPISTOL', price = 5 },
		{ weapon = 'WEAPON_CARBINERIFLE', price = 1 },
		--{ weapon = 'WEAPON_PUMPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_SMG', price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 1 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},

	boss = { -- Şef
		{ weapon = 'WEAPON_COMBATPISTOL', price = 1 },
		{ weapon = 'WEAPON_CARBINERIFLE', price = 1 },
		--{ weapon = 'WEAPON_PUMPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_SMG', price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 1 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'polchar', label = 'Police Dodge', price = 1 },
		{ model = 'polraptor', label = 'Police Raptor', price = 1 },
		{ model = 'poltah', label = 'Police SUV', price = 1 },
		{ model = 'poltaurus', label = 'Police Taurus', price = 1 },
		{ model = 'polvic', label = 'Police Victoria', price = 1 },
		{ model = 'polvic2', label = 'Police Victoria2', price = 1 },
		{ model = 'policeb', label = 'Police Motor', price = 1 },
		{ model = 'riot', label = 'Police Riot', price = 1 },
		{ model = '2015polstang', label = 'Mustang', price = 1 },

	},

	recruit = {},
	
	officer = {},

	sergeant = {},

	intendent = {},

    lieutenant = {},

	lieutenants = {},

	boss1 = {},

	boss2 = {},

	boss3 = {},

	chef = {
		{ model = '2015polstang', label = 'Police Mustang', price = 1 }
	},

	boss = {}

}

Config.AuthorizedHelicopters = {
	recruit = {},
	
	officer = {},

	sergeant = {},

	intendent = {},

    lieutenant = {},

	lieutenants = {},

	boss1 = {		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 200000 }
},

	boss2 = {		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 200000 }
},

	boss3 = {		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 200000 }
},

	malibaba = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 200000 }
	},

	chef = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 150000 }
	},

	boss = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 15000 }
	}

}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			--['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			--['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	malibaba = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			--['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			--['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenants = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			--['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			--['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 24,   ['pants_2'] = 0,
			--['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 27,   ['pants_2'] = 0,
			--['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			--['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 16,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}