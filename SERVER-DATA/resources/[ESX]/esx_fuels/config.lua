Config = {}

-- Are you using ESX? Turn this to true if you would like fuel & jerry cans to cost something.
Config.UseESX = true

-- What should the price of jerry cans be?
Config.JerryCanCost = 5000
Config.RefillCost = 1400 -- If it is missing half of it capacity, this amount will be divided in half, and so on.
Config.FuelDecor = "_FUEL_LEVEL"
-- What keys are disabled while you're fueling.
Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Want to use the HUD? Turn this to true.
Config.EnableHUD = false

-- Configure blips here. Turn both to false to disable blips all together.
Config.ShowNearestGasStationOnly = false
Config.ShowAllGasStations = true

-- Configure the strings as you wish here.
Config.Strings = {
	ExitVehicle = "Benzin Doldurmak İçin Araçtan İnin",
	EToRefuel = "~g~[E]~w~ Araca Benzin Doldur",
	JerryCanEmpty = "Benzin bidonu bos",
	FullTank = "Araç Deposu Full",
	PurchaseJerryCan = "~g~[E]~w~ ile dolu bir benzin bidonu satın al ~g~$" .. Config.JerryCanCost,
	CancelFuelingPump = "~g~[E]~w~ Benzin Doldurmayı İptal Et",
	CancelFuelingJerryCan = "~g~[E]~w~ ile benzin doldurmayı iptal et",
	NotEnoughCash = "Yeterli paranız yok",
	RefillJerryCan = "~g~[E]~w~ ile benzin bidonunu doldurabilirsin $",
	NotEnoughCashJerryCan = "Benzin bidonunu doldurmak için yeterli paranız yok",
	JerryCanFull = "Benzin Bidonu Dolu",
	TotalCost = "Tutar",
}

if not Config.UseESX then
	Config.Strings.PurchaseJerryCan = "~g~[E]~w~ ile benzin bidonu al"
	Config.Strings.RefillJerryCan = "~g~[E]~w~ ile benzin bidonunu doldur"
end

Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	--"Adder",
	-- Boats
	1033245328,
	276773164,
	509498602,
	867467158,
	861409633,
	-1043459709,
	-1030275036,
	-616331036,
	-311022263,
	231083307,
	437538602,
	400514754,
	771711535,
	-1066334226,
	-282946103,
	1070967343,
	908897389,
	290013743,
	1448677353,
	-2100640717,

	-- Helikopter
	837858166,
	788747387,
	745926877,
	-50547061,
	1621617168,
	1394036463,
	2025593404,
	744705981,
	1949211328,
	-1660661558,
	-82626025,
	1044954915,
	710198397,
	-1671539132,
	-339587598,
	1075432268,
	-1600252419,
	1543134283,
	-1845487887,

	-- Elektrikli araçlar
	1560980623,
	-1130810103,
	1682114128,
	544021352,
	-1622444098,
	989294410,
	"tezeract",
	"cyclone",
	"neon",
	"raiden",
	"khamelion",
	"surge"
}

-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
Config.Classes = {
	[0] = 0.3, -- Compacts
	[1] = 0.3, -- Sedans
	[2] = 0.3, -- SUVs
	[3] = 0.3, -- Coupes
	[4] = 0.3, -- Muscle
	[5] = 0.3, -- Sports Classics
	[6] = 0.3, -- Sports
	[7] = 0.3, -- Super
	[8] = 0.3, -- Motorcycles
	[9] = 0.3, -- Off-road
	[10] = 0.3, -- Industrial
	[11] = 0.3, -- Utility
	[12] = 0.3, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 0.0, -- Boats
	[15] = 0.0, -- Helicopters
	[16] = 0.0, -- Planes
	[17] = 0.3, -- Service
	[18] = 0.3, -- Emergency
	[19] = 0.3, -- Military
	[20] = 0.3, -- Commercial
	[21] = 0.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.GasStations = {
	[1] = { coords = vector3(49.4187, 2778.793, 58.043), r = 15},
	[2] =  { coords = vector3(263.894, 2606.463, 44.983), r = 15},
	[3] =  { coords = vector3(1039.958, 2671.134, 39.550), r = 15},
	[4] =  { coords = vector3(1207.260, 2660.175, 37.899), r = 15},
	[5] =  { coords = vector3(2539.685, 2594.192, 37.944), r = 15},
	[6] =  { coords = vector3(2679.858, 3263.946, 55.240), r = 15},
	[7] =  { coords = vector3(2005.055, 3773.887, 32.403), r = 15},
	[8] =  { coords = vector3(1687.156, 4929.392, 42.078), r = 15},
	[9] =  { coords = vector3(1701.314, 6416.028, 32.763), r = 15},
	[10] =  { coords = vector3(179.857, 6602.839, 31.868), r = 15},
	[11] =  { coords = vector3(-94.4619, 6419.594, 31.489), r = 15},
	[12] =  { coords = vector3(-2554.996, 2334.40, 33.078), r = 15},
	[13] =  { coords = vector3(-1800.375, 803.661, 138.651), r = 15},
	[14] =  { coords = vector3(-1437.622, -276.747, 46.207), r = 15},
	[15] =  { coords = vector3(-2096.243, -320.286, 13.168), r = 15},
	[16] =  { coords = vector3(-724.619, -935.1631, 19.213), r = 15},
	[17] =  { coords = vector3(-526.019, -1211.003, 18.184), r = 15},
	[18] =  { coords = vector3(-70.2148, -1761.792, 29.534), r = 15},
	[19] =  { coords = vector3(265.648, -1261.309, 29.292), r = 15},
	[20] =  { coords = vector3(819.653, -1028.846, 26.403), r = 15},
	[21] =  { coords = vector3(1208.951, -1402.567,35.224), r = 15},
	[22] =  { coords = vector3(1181.381, -330.847, 69.316), r = 15},
	[23] =  { coords = vector3(620.843, 269.100, 103.089), r = 15},
	[24] =  { coords = vector3(2581.321, 362.039, 108.468), r = 15},
	[25] =  { coords = vector3(176.631, -1562.025, 29.263), r = 15},
	[26] =  { coords = vector3(176.631, -1562.025, 29.263), r = 15},
	[27] =  { coords = vector3(-319.292, -1471.715, 30.549), r = 15},
	[28] =  { coords = vector3(1784.324, 3330.55, 41.253), r = 15}
}