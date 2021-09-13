Citizen.CreateThread(function()
	RequestIpl("gabz_import_milo_")
	local interiorID = GetInteriorAtCoords(941.00840000, -972.66450000, 39.14678000)
	if IsValidInterior(interiorID) then
		EnableInteriorProp(interiorID, "branded_style_set")
		EnableInteriorProp(interiorID, "car_floor_hatch")
		RefreshInterior(interiorID)
	end
end)

Citizen.CreateThread(function()
	RequestIpl("gabz_pillbox_milo_")
	local interiorID = GetInteriorAtCoords(311.2546, -592.4204, 42.32737)
	if IsValidInterior(interiorID) then
		RemoveIpl("rc12b_fixed")
		RemoveIpl("rc12b_destroyed")
		RemoveIpl("rc12b_default")
		RemoveIpl("rc12b_hospitalinterior_lod")
		RemoveIpl("rc12b_hospitalinterior")
		RefreshInterior(interiorID)
	end
end)

-- Citizen.CreateThread(function()
-- 	local blip = AddBlipForCoord(-1153.11, -2172.08, 13.26)
-- 	SetBlipSprite(blip, 523)
-- 	SetBlipScale(blip, 0.5)
-- 	SetBlipColour(blip, 2)
-- 	SetBlipAsShortRange(blip, true)
-- 	BeginTextCommandSetBlipName('STRING')
-- 	AddTextComponentSubstringPlayerName("Go Kart")
-- 	EndTextCommandSetBlipName(blip)

-- 	local blip = AddBlipForCoord(-151.92510986328, -2145.5776367188, 16.70502281189)
-- 	SetBlipSprite(blip, 523)
-- 	SetBlipScale(blip, 0.5)
-- 	SetBlipColour(blip, 2)
-- 	SetBlipAsShortRange(blip, true)
-- 	BeginTextCommandSetBlipName('STRING')
-- 	AddTextComponentSubstringPlayerName("Go Kart")
-- 	EndTextCommandSetBlipName(blip)

-- 	RequestIpl("breze_gokart_milo")
-- 	local interiorID = GetInteriorAtCoords(-1123.117,-2108.477,23.23311)
-- 	if IsValidInterior(interiorID) then 
-- 		EnableInteriorProp(interiorID, "0x71348381")
-- 		EnableInteriorProp(interiorID, "breze_gokart")
-- 		RefreshInterior(interiorID)
-- 	end 
-- end)

Citizen.CreateThread(function()
	local int_id = GetInteriorAtCoords(345.4899597168,294.95315551758,98.191421508789)
	if IsValidInterior(int_id) then 
		EnableInteriorProp(int_id , "Int01_ba_security_upgrade")
		EnableInteriorProp(int_id , "Int01_ba_equipment_setup")
		DisableInteriorProp(int_id , "Int01_ba_Style01") -- дешовый
		EnableInteriorProp(int_id , "Int01_ba_Style02") -- средний
		DisableInteriorProp(int_id , "Int01_ba_Style03") -- дорогой
		DisableInteriorProp(int_id , "Int01_ba_style01_podium") -- дешовый
		EnableInteriorProp(int_id , "Int01_ba_style02_podium") -- средний
		DisableInteriorProp(int_id , "Int01_ba_style03_podium") -- дорогой
		DisableInteriorProp(int_id , "int01_ba_lights_screen")
		DisableInteriorProp(int_id , "Int01_ba_Screen")
		EnableInteriorProp(int_id , "Int01_ba_bar_content")
		DisableInteriorProp(int_id , "Int01_ba_booze_01") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_booze_02") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_booze_03") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_dj01")
		DisableInteriorProp(int_id , "Int01_ba_dj02")
		EnableInteriorProp(int_id , "Int01_ba_dj03")
		DisableInteriorProp(int_id , "Int01_ba_dj04")

		DisableInteriorProp(int_id , "DJ_01_Lights_01")
		DisableInteriorProp(int_id , "DJ_01_Lights_02")
		EnableInteriorProp(int_id , "DJ_01_Lights_03")
		DisableInteriorProp(int_id , "DJ_01_Lights_04")

		DisableInteriorProp(int_id , "DJ_02_Lights_01")
		DisableInteriorProp(int_id , "DJ_02_Lights_02")
		DisableInteriorProp(int_id , "DJ_02_Lights_03")
		DisableInteriorProp(int_id , "DJ_02_Lights_04")


		DisableInteriorProp(int_id , "DJ_03_Lights_01")
		DisableInteriorProp(int_id , "DJ_03_Lights_02")
		DisableInteriorProp(int_id , "DJ_03_Lights_03")
		DisableInteriorProp(int_id , "DJ_03_Lights_04")

		DisableInteriorProp(int_id , "DJ_04_Lights_01")
		DisableInteriorProp(int_id , "DJ_04_Lights_02")
		DisableInteriorProp(int_id , "DJ_04_Lights_03")
		DisableInteriorProp(int_id , "DJ_04_Lights_04")

		DisableInteriorProp(int_id , "light_rigs_off")
		EnableInteriorProp(int_id , "Int01_ba_lightgrid_01")
		DisableInteriorProp(int_id , "Int01_ba_Clutter")
		EnableInteriorProp(int_id , "Int01_ba_equipment_upgrade")
		EnableInteriorProp(int_id , "Int01_ba_clubname_01") -- galaxy
		DisableInteriorProp(int_id , "Int01_ba_clubname_02") --studio
		DisableInteriorProp(int_id , "Int01_ba_clubname_03") --omega
		DisableInteriorProp(int_id , "Int01_ba_clubname_04") --tehnology
		DisableInteriorProp(int_id , "Int01_ba_clubname_05") --gefangnis
		DisableInteriorProp(int_id , "Int01_ba_clubname_06") --maisonnette
		DisableInteriorProp(int_id , "Int01_ba_clubname_07") -- tony 
		DisableInteriorProp(int_id , "Int01_ba_clubname_08") -- the palace
		DisableInteriorProp(int_id , "Int01_ba_clubname_09") -- paradise

		EnableInteriorProp(int_id , "Int01_ba_dry_ice")
		DisableInteriorProp(int_id , "Int01_ba_deliverytruck")
		DisableInteriorProp(int_id , "Int01_ba_trophy04")
		DisableInteriorProp(int_id , "Int01_ba_trophy05")
		DisableInteriorProp(int_id , "Int01_ba_trophy07")
		DisableInteriorProp(int_id , "Int01_ba_trophy09")
		DisableInteriorProp(int_id , "Int01_ba_trophy08")
		DisableInteriorProp(int_id , "Int01_ba_trophy11")
		DisableInteriorProp(int_id , "Int01_ba_trophy10")
		DisableInteriorProp(int_id , "Int01_ba_trophy03")
		DisableInteriorProp(int_id , "Int01_ba_trophy01")
		DisableInteriorProp(int_id , "Int01_ba_trophy02")
		EnableInteriorProp(int_id , "Int01_ba_trad_lights")
		DisableInteriorProp(int_id , "Int01_ba_Worklamps") -- работа
		RefreshInterior(int_id )
	end
end)

Citizen.CreateThread(function()
	RequestIpl("gabz_mrpd_milo_")
	local interiorID = GetInteriorAtCoords(451.0129, -993.3741, 29.1718)
	if IsValidInterior(interiorID) then      
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm1")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm2")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm3")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm4")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm5")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm6")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm7")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm8")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm9")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm10")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm11")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm12")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm13")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm14")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm15")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm16")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm17")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm18")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm19")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm20")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm21")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm22")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm23")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm24")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm25")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm26")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm27")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm28")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm29")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm30")
		EnableInteriorProp(interiorID, "v_gabz_mrpd_rm31")
		RefreshInterior(interiorID)
	end
end)

