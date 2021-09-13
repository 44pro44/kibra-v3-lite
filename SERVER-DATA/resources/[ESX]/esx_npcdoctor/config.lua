Config = {}
Config.Locale = 'en'

Config.MarkerType   = 25
Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 2.0, y = 2.0, z = 0.5}
Config.MarkerColor  = {r = 255, g = 0, b = 0}

Config.BlipHospital = {
	Sprite = 403,
	Color = 2,
	Display = 2,
	Scale = 0.9
}

Config.Price = 5000 -- Edit this to your liking.

Config.EnableUnemployedOnly = false -- If true it will only show Blips to Unemployed Players | false shows it to Everyone.
Config.EnableBlips = false -- If true then it will show blips | false does the Opposite.
Config.EnablePeds = true -- If true then it will add Peds on Markers | false does the Opposite.

Config.Locations = {
	--{ x = 338.85, y = -1394.56, z = 31.51, heading = 49.404 },
	--{ x = -449.67, y = -340.83, z = 33.50, heading = 82.17 },
	--{ x = 246.47, y = -1365.71, z = 28.64, heading = 221.25 },
	--{ x = -874.79, y = -307.56, z = 38.58, heading = 350.95 },
	{ x = 309.606, y = -593.87, z = 42.2840, heading = 6.23 },
--	{ x = 323.45, y = -585.02, z = 42.28, heading = 68.15},
	--{ x = -240.31, y = 6324.13, z = 31.43, heading = 221.37 }
}

Config.Zones = {}

for i=1, #Config.Locations, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Locations[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
