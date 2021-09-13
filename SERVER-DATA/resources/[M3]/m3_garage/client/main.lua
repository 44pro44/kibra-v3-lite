ESX = nil

cachedData = {}

-- blips
-- Citizen.CreateThread(function()
-- 	for k, v in pairs(Config.Garages) do
-- 		local gblip = AddBlipForCoord(v.positions.menu.position)
-- 		SetBlipSprite(gblip, 357)
-- 		SetBlipDisplay(gblip, 4)
-- 		SetBlipScale (gblip, 0.4)
-- 		SetBlipColour(gblip, 67)
-- 		SetBlipAsShortRange(gblip, true)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString("Garaj")
-- 		EndTextCommandSetBlipName(gblip)
-- 	end
-- end)


-- imp blips
Citizen.CreateThread(function()
	for k, v in pairs(Config.Impounds) do
		local iblip = AddBlipForCoord(v.positions.impmenu.position)
		SetBlipSprite(iblip, 357)
		SetBlipDisplay(iblip, 4)
		SetBlipScale (iblip, 0.4)
		SetBlipColour(iblip, 59)
		SetBlipAsShortRange(iblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bağlanmış Araçlar Garajı")
		EndTextCommandSetBlipName(iblip)
	end
end)

--markers
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	while true do
		local wait = 500

		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)

		for k, v in pairs(Config.Garages) do
			for i, j in pairs(v.positions) do
				local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, j.position.x, j.position.y, j.position.z, true)

				if distance <= 10.0 then
					wait = 5

					if IsPedInAnyVehicle(PlayerPedId()) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId())
		
						if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
							if i == "vehicle" then
								if distance <= 10.0 then
									DrawMarker(6, j.position - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 5.0, 1.0, 5.0, 0, 150, 150, 100, false, true, 2, false, false, false, false)
									if distance <= 1.5 then
										ESX.ShowHelpNotification("Aracınızı garaja koymak için ~INPUT_CONTEXT~ tuşuna basınız.")
										if IsControlJustPressed(0, 38) then
											PutVehiclesMenu('car')
										end
									end
								else
									ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
								end
							elseif i == "menu" then
								if distance <= 5.0 then
									DrawMarker(6, j.position - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 150, 150, 100, false, true, 2, false, false, false, false)
								end
							end
						end
					else
						if i == "menu" then
							if distance <= 5.0 then
								DrawMarker(6, j.position - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 150, 150, 100, false, true, 2, false, false, false, false)
								if distance <= 1.5 then
									ESX.ShowHelpNotification("Aracınızı seçmek için ~INPUT_CONTEXT~ tuşuna basınız.")
									if IsControlJustPressed(0, 38) then
										GetVehiclesMenu('car')
										cachedData.currentGarage = k
									end
								end
							else
								ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
							end
						end
					end
				end
			end
		end

		for k, v in pairs(Config.Impounds) do
			for i, j in pairs(v.positions) do
				local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, j.position.x, j.position.y, j.position.z, false)

				if distance <= 10.0 then
					wait = 5

					if not IsPedInAnyVehicle(PlayerPedId()) then
						if i == "impmenu" then
							if distance <= 5.0 then
								DrawMarker(6, j.position - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
								if distance <= 1.5 then
									ESX.ShowHelpNotification("Bağlanmış araçlara bakmak için ~INPUT_CONTEXT~ tuşuna basınız.")
									if IsControlJustPressed(0, 38) then
										GetImpVehMenu()
										cachedData.currentGarage = k
									end
								end
							else
								ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
							end
						end
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

function GetImpVehMenu()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback("m3:garage:fetchImpVehicles", function(fetchedVehicles)
        local menuElements = {}
        for k, v in ipairs(fetchedVehicles) do
            local vehicleProps = v.props
				if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
					table.insert(menuElements, {
						label = "Model: Bilinmiyor - Plaka: " .. v.plate,
						vehicle = v
					})
				else
					table.insert(menuElements, {
						label = "Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) .. " - Plaka: " .. v.plate,
						vehicle = v
					})
				end
		end
		if PlayerData.job.name == 'police' then
			for k, v in ipairs(fetchedVehicles) do
				local vehicleProps = v.props
				if v.job == "police" then
					if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
						table.insert(menuElements, {
							label = "LSPD - Model: Bilinmiyor - Plaka: " .. v.plate,
							vehicle = v
						})
					else
						table.insert(menuElements, {
							label = "LSPD - Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) .. " - Plaka: " .. v.plate,
							vehicle = v
						})
					end
				end
			end
		end
		if PlayerData.job.name == 'ambulance' then
			for k, v in ipairs(fetchedVehicles) do
				local vehicleProps = v.props
				if v.job == "ambulance" then
					if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
						table.insert(menuElements, {
							label = "LSMS - Model: Bilinmiyor - Plaka: " .. v.plate,
							vehicle = v
						})
					else
						table.insert(menuElements, {
							label = "LSMS - Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) .. " - Plaka: " .. v.plate,
							vehicle = v
						})
					end
				end
			end
		end
		-- if PlayerData.job.name == 'sheriff' then
		-- 	for k, v in ipairs(fetchedVehicles) do
		-- 		local vehicleProps = v.props
		-- 		if v.job == "sheriff" then
		-- 			if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
		-- 				table.insert(menuElements, {
		-- 					label = "LSSD - Model: Bilinmiyor - Plaka: " .. v.plate,
		-- 					vehicle = v
		-- 				})
		-- 			else
		-- 				table.insert(menuElements, {
		-- 					label = "LSSD - Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) .. " - Plaka: " .. v.plate,
		-- 					vehicle = v
		-- 				})
		-- 			end
		-- 		end
		-- 	end
		-- end

		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_garage_menu", {
            title = "Bağlanmış Araçlar",
			elements = menuElements,
			align = Config.AlignMenu
        }, function(data, menu)
            local currentVehicle = data.current.vehicle

            if currentVehicle then
				-- ESX.UI.Menu.CloseAll()
				
				local vehicleElements = {}

				table.insert(vehicleElements, {label = "Aracı Çağır", value = "spawn"})

				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "vehicleprops", {
					title = "Araç Özellikleri",
					align = Config.AlignMenu,
					elements = vehicleElements
				}, function(data2, menu2)

					if data2.current.value == "spawn" then
						SpawnImpVehicle(currentVehicle.props)
						ESX.UI.Menu.CloseAll()
					elseif nil then
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
        end, function(data, menu)
			ESX.UI.Menu.CloseAll()
        end)
    end)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	while true do
		local wait = 500

		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)

		for k, v in pairs(Config.HeliGarages) do
			for i, j in pairs(v.positions) do
				local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, j.position.x, j.position.y, j.position.z, true)

				if distance <= 30.0 then
					wait = 5

					if IsPedInAnyVehicle(PlayerPedId()) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId())
		
						if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
							if i == "vehicle" then
								if distance <= 30.0 then
									DrawMarker(6, j.position - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 5.0, 1.0, 5.0, 0, 150, 150, 100, false, true, 2, false, false, false, false)
									if distance <= 5.5 then
										ESX.ShowHelpNotification("Aracınızı garaja koymak için ~INPUT_CONTEXT~ tuşuna basınız.")
										if IsControlJustPressed(0, 38) then
											PutVehiclesMenu('helicopter')
										end
									end
								else
									ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
								end
							elseif i == "menu" then
								if distance <= 30.0 then
									DrawMarker(34, j.position - vector3(0.0, 0.0, 0.185), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 150, 100, false, true, 2, false, nil, nil, false)
								end
							end
						end
					else
						if i == "menu" then
							if distance <= 15.0 then
								DrawMarker(34, j.position - vector3(0.0, 0.0, 0.185), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 150, 100, false, true, 2, false, nil, nil, false)
								if distance <= 1.5 then
									ESX.ShowHelpNotification("Aracınızı seçmek için ~INPUT_CONTEXT~ tuşuna basınız.")
									if IsControlJustPressed(0, 38) then
										GetVehiclesMenu('helicopter')
										cachedData.currentGarage = k
									end
								end
							else
								ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
							end
						end
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	while true do
		local wait = 500

		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)

		for k, v in pairs(Config.BoatGarages) do
			for i, j in pairs(v.positions) do
				local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, j.position.x, j.position.y, j.position.z, true)

				if distance <= 30.0 then
					wait = 5

					if IsPedInAnyVehicle(PlayerPedId()) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId())
		
						if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
							if i == "vehicle" then
								if distance <= 30.0 then
									DrawMarker(35, j.position, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
									if distance <= 3.5 then
										ESX.ShowHelpNotification("Aracınızı garaja koymak için ~INPUT_CONTEXT~ tuşuna basınız.")
										if IsControlJustPressed(0, 38) then
											PutVehiclesMenu('boat')
										end
									end
								else
									ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
								end
							elseif i == "menu" then
								if distance <= 30.0 then
									DrawMarker(35, j.position, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 150, 100, false, true, 2, false, nil, nil, false)
								end
							end
						end
					else
						if i == "menu" then
							if distance <= 15.0 then
								DrawMarker(35, j.position, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 150, 100, false, true, 2, false, nil, nil, false)
								if distance <= 1.5 then
									ESX.ShowHelpNotification("Aracınızı seçmek için ~INPUT_CONTEXT~ tuşuna basınız.")
									if IsControlJustPressed(0, 38) then
										GetVehiclesMenu('boat')
										cachedData.currentGarage = k
									end
								end
							else
								ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'main_garage_menu')
							end
						end
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)


function SpawnImpVehicle(vehicleProps)
	local spawnpoint = Config.Impounds[cachedData.currentGarage].positions.impvehicle
	local deliverypoint = Config.Impounds[cachedData.currentGarage].positions.deliverypoint

	WaitForModel(vehicleProps.model)

	if not ESX.Game.IsSpawnPointClear(spawnpoint.position, 3.0) then
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Çıkartma noktası dolu!'})

		return
	end

	
	ESX.TriggerServerCallback('m3:garage:plateCheck', function(result)
		if not result then
			local gameVehicles = ESX.Game.GetVehicles()

			for i = 1, #gameVehicles do
				local vehicle = gameVehicles[i]

			    if DoesEntityExist(vehicle) then
					if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(vehicleProps.plate) then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bu araç dışarıda! Konumu GPS\'te işaretlendi!', length = 5000})
						local vCoords = GetEntityCoords(vehicle)
						SetNewWaypoint(vCoords.x,vCoords.y)
						return
					end
				end
			end
			
			local yourVehicle = CreateVehicle(vehicleProps.model, spawnpoint.position.x, spawnpoint.position.y, spawnpoint.position.z, spawnpoint.heading, true, false)

			local pedhash = GetHashKey('ig_milton')

			RequestModel(pedhash)

			SetVehicleProperties(yourVehicle, vehicleProps)
	
			-- NetworkFadeInEntity(yourVehicle, true, true)
	
			SetModelAsNoLongerNeeded(vehicleProps.model)
	
			-- SetEntityAsMissionEntity(yourVehicle, true, true)

			-- SetVehRadioStation(yourVehicle, "OFF")
			
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracınız teslim ediliyor!'})

			TriggerServerEvent("m3:garage:vehicleOut", vehicleProps.plate)

			while not HasModelLoaded(pedhash) do
				Citizen.Wait(1)
			end

			local d1 = CreatePedInsideVehicle(yourVehicle, 4, pedhash, -1, true, 0)

			TaskVehiclePark(d1, yourVehicle, deliverypoint.position.x, deliverypoint.position.y, deliverypoint.position.z, deliverypoint.heading, 1, 100.0, true)

			while true do
				local d1Coords = GetEntityCoords(d1)

				local ldistance = GetDistanceBetweenCoords(d1Coords, deliverypoint.position.x, deliverypoint.position.y, deliverypoint.position.z, true)
				Citizen.Wait(10)
				if not IsPedInAnyVehicle(d1, false) then
					Citizen.Wait(500)

					NetworkFadeOutEntity(vehicle, true, true)

					Citizen.Wait(100)

					DeletePed(d1)
					break
				end

				if ldistance <= 1.5 then
					Citizen.Wait(5)
					TaskLeaveVehicle(d1, yourVehicle, 256)
					Citizen.Wait(30)
				end
				
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Aracınız burada değil!'})
		end
	end, vehicleProps.plate)
end

function PutVehiclesMenu(type)
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())

	if DoesEntityExist(vehicle) then
		local vehicleProps = GetVehicleProperties(vehicle)
		
		if isValidforThisGarage(vehicle, type) then
			ESX.TriggerServerCallback("m3:garage:validateVehicle", function(result)
				if result then
					TaskLeaveVehicle(PlayerPedId(), vehicle, 0)

					while IsPedInVehicle(PlayerPedId(), vehicle, true) do
						Citizen.Wait(0)
					end

					Citizen.Wait(500)

					NetworkFadeOutEntity(vehicle, true, true)

					Citizen.Wait(100)

					SetEntityCollision(vehicle, false, false)
					SetEntityAlpha(vehicle, 0.0, true)
					SetEntityAsMissionEntity(vehicle, false, true)
					DeleteEntity(vehicle)

					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracı garaja parkettiniz!'})
				end
			end, vehicleProps)
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Burası uygun değil!'})
		end
	end
end

function isValidforThisGarage(vehicle, type)
	local vehicletype = {
		['car'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 17, 18, 19, 20},
		['helicopter'] = {15, 16},
		['boat'] = {14},
	}
	local vehicleClass = GetVehicleClass(vehicle)
	for k, v in pairs(vehicletype[type]) do
		if vehicleClass == v then
			return true
		end
	end
	return false
end

function GetVehiclesMenu(type)
	ESX.TriggerServerCallback("m3:garage:fetchPlayerVehicles", function(fetchedVehicles)
        local menuElements = {}
        for k, v in ipairs(fetchedVehicles) do
            local vehicleProps = v.props
			--if v.job == "sivil" then
				if type == 'car' then
					if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
						table.insert(menuElements, {
							label = "Model: Bilinmiyor - Plaka: " .. v.plate,
							vehicle = v
						})
					else
						table.insert(menuElements, {
							label = "Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) .. " - Plaka: " .. v.plate,
							vehicle = v
						})
					end
				else
					if GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)) == "NULL" then
						table.insert(menuElements, {
							label = "Model: Bilinmiyor",
							vehicle = v
						})
					else
						table.insert(menuElements, {
							label = "Model: " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)),
							vehicle = v
						})
					end
				end
            --end
		end
		
		local title = nil if type == 'car' then title = 'Araçlar' elseif type == 'helicopter' then title = 'Helikopterler' elseif type == 'boat' then title = 'Deniz Araçları' end
        
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_garage_menu", {
            title = title,
			elements = menuElements,
			align = Config.AlignMenu
        }, function(data, menu)
            local currentVehicle = data.current.vehicle

            if currentVehicle then
				-- ESX.UI.Menu.CloseAll()
				
				local vehicleElements = {}

				table.insert(vehicleElements, {label = "Aracı Çıkart", value = "spawn"})

				if currentVehicle.props.engineHealth < 1000.0 then
					oldDamage = currentVehicle.props.engineHealth
					repairCost = math.ceil((1000.0 - oldDamage) * 0.2)
					table.insert(vehicleElements, {label = "Motor hasarı: -" ..math.ceil(1000.0 - oldDamage).. " Tutar: " ..repairCost.. "$", value = "fixengine"})
				end
				
				-- if currentVehicle.props.bodyHealth < 1000.0 then
				-- 	oldbDamage = currentVehicle.props.bodyHealth
				-- 	repairbCost = math.ceil((1000.0 - oldbDamage) * 0.1)
				-- 	table.insert(vehicleElements, {label = "Kaput hasarı: -" ..math.ceil(1000.0 - oldbDamage).. " Tutar: " ..repairbCost.. "$", value = "fixbody"})
				-- end

				if math.ceil(currentVehicle.props.fuelLevel) < 100.0 then
					oldFuel = math.ceil(currentVehicle.props.fuelLevel)
					fuelCost = (100 - oldFuel) * 3
					table.insert(vehicleElements, {label = "Mevcut Benzin: %" ..math.ceil(currentVehicle.props.fuelLevel).. " Tutar: " ..fuelCost.. "$", value = "takefuel"})
				end

				-- tyrescount = 0
				-- if currentVehicle.props.tyres then
				-- 	for tyreId = 1, 7, 1 do
				-- 		if currentVehicle.props.tyres[tyreId] ~= false then
				-- 			tyrescount = tyrescount + 1
				-- 		end
				-- 	end
				-- 	if tyrescount > 0 then
				-- 		-- table.insert(vehicleElements, {label = "Lastik: "..tyrescount.."x Patlak Tutar: "..(tyrescount * 20).."$", value = "repairtyres"})
				-- 		table.insert(vehicleElements, {label = "Lastikler: Patlak Tutar: "..(tyrescount * 20).."$", value = "repairtyres"})
				-- 	end
				-- end

				-- doorscount = 0
				-- if currentVehicle.props.doors then
				-- 	for doorId = 0, 5, 1 do
				-- 		if currentVehicle.props.doors[doorId] ~= false then
				-- 			doorscount = doorscount + 1
				-- 		end
				-- 	end
				-- 	if doorscount > 0 then
				-- 		table.insert(vehicleElements, {label = "Kapı: "..doorscount.."x Sökük Tutar: "..(doorscount * 25).."$", value = "repairdoors"})
				-- 	end
				-- end

				-- windowscount = 0
				-- if currentVehicle.props.windows then
				-- 	for windowId = 1, 13, 1 do
				-- 		if currentVehicle.props.windows[windowId] == false then
				-- 			windowscount = windowscount + 1
				-- 		end
				-- 	end
				-- 	if windowscount > 0 then
				-- 		table.insert(vehicleElements, {label = "Cam: "..windowscount.."x Kırık Tutar: "..(windowscount * 7).."$", value = "repairwds"})
				-- 	end
				-- end

				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "vehicleprops", {
					title = "Araç Özellikleri",
					align = Config.AlignMenu,
					elements = vehicleElements
				}, function(data2, menu2)
					-- local value = data2.current.value

					if data2.current.value == "spawn" then
						if Config.CheckBills then
							ESX.TriggerServerCallback('m3:garage:checkBills', function(nobills)
								if nobills then
									SpawnVehicle(currentVehicle.props, type)
								else
									TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Ödenmemiş faturalarınız bulunduğundan dolayı aracınızı teslim alamıyorsunuz!'})
								end
							end)
						else
							SpawnVehicle(currentVehicle.props, type)
						end
						ESX.UI.Menu.CloseAll()
					elseif data2.current.value == "takefuel" then
						ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
							if result then
								currentVehicle.props.fuelLevel = 100.0
								TriggerServerEvent("m3:garage:Save", currentVehicle.props)
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın deposu dolduruldu! Ücret: ' ..fuelCost.. '$'})
								ESX.UI.Menu.CloseAll()
								Citizen.Wait(50)
								GetVehiclesMenu(type)
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
							end
						end, fuelCost)
					elseif data2.current.value == "fixengine" then
						ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
							if result then
								currentVehicle.props.engineHealth = 1000.0
								TriggerServerEvent("m3:garage:Save", currentVehicle.props)
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın motoru onarıldı! Ücret: ' ..repairCost.. '$'})
								ESX.UI.Menu.CloseAll()
								Citizen.Wait(50)
								GetVehiclesMenu(type)
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
							end
						end, repairCost)
					elseif data2.current.value == "fixbody" then
						ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
							if result then
								currentVehicle.props.bodyHealth = 1000.0
								TriggerServerEvent("m3:garage:Save", currentVehicle.props)
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın kaput hasarı onarıldı! Ücret: ' ..repairbCost.. '$'})
								ESX.UI.Menu.CloseAll()
								Citizen.Wait(50)
								GetVehiclesMenu(type)
							else
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
							end
						end, repairbCost)
					-- elseif data2.current.value == "repairtyres" then
					-- 	ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
					-- 		if result then
					-- 			tyrescount = 0
					-- 			for tyreId = 1, 7, 1 do
					-- 				if currentVehicle.props.tyres[tyreId] ~= false then
					-- 					currentVehicle.props.tyres[tyreId] = false
					-- 					tyrescount = tyrescount + 1
					-- 				end
					-- 			end
					-- 			TriggerServerEvent("m3:garage:Save", currentVehicle.props)
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın lastikleri onarıldı! Ücret: '..(tyrescount * 20)..'$'})
					-- 			ESX.UI.Menu.CloseAll()
					-- 			Citizen.Wait(50)
					-- 			GetVehiclesMenu(type)
					-- 		else
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
					-- 		end
					-- 	end, (tyrescount * 20))
					-- elseif data2.current.value == "repairdoors" then
					-- 	ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
					-- 		if result then
					-- 			doorscount = 0
					-- 			for doorId = 0, 5, 1 do
					-- 				if currentVehicle.props.doors[doorId] ~= false then
					-- 					currentVehicle.props.doors[doorId] = false
					-- 					doorscount = doorscount + 1
					-- 				end
					-- 			end
					-- 			TriggerServerEvent("m3:garage:Save", currentVehicle.props)
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın kapıları onarıldı! Ücret: '..(doorscount * 25)..'$'})
					-- 			ESX.UI.Menu.CloseAll()
					-- 			Citizen.Wait(50)
					-- 			GetVehiclesMenu(type)
					-- 		else
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
					-- 		end
					-- 	end, (doorscount * 25))
					-- elseif data2.current.value == "repairwds" then
					-- 	ESX.TriggerServerCallback("m3:garage:getMoney", function(result)
					-- 		if result then
					-- 			windowscount = 0
					-- 			for windowId = 1, 13, 1 do
					-- 				if currentVehicle.props.windows[windowId] == false then
					-- 					currentVehicle.props.windows[windowId] = 1
					-- 					windowscount = windowscount + 1
					-- 				end
					-- 			end
					-- 			TriggerServerEvent("m3:garage:Save", currentVehicle.props)
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracın camları onarıldı! Ücret: '..(windowscount * 7)..'$'})
					-- 			ESX.UI.Menu.CloseAll()
					-- 			Citizen.Wait(50)
					-- 			GetVehiclesMenu(type)
					-- 		else
					-- 			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanızda yeterli para yok!'})
					-- 		end
					-- 	end, (windowscount * 7))
					elseif nil then
					end
				end, function(data2, menu2)
					menu2.close()
				end)
            end
        end, function(data, menu)
			ESX.UI.Menu.CloseAll()
        end)
    end, type)
end

function SpawnVehicle(vehicleProps, type)
	local garage = nil
	local spawnpoint = nil
	if type == 'car' then
		spawnpoint = Config.Garages[cachedData.currentGarage].positions.vehicle
	elseif type == 'boat' then
		spawnpoint = Config.BoatGarages[cachedData.currentGarage].positions.vehicle
	elseif type == 'helicopter' then
		spawnpoint = Config.HeliGarages[cachedData.currentGarage].positions.vehicle
	end

	WaitForModel(vehicleProps.model)

	if not ESX.Game.IsSpawnPointClear(spawnpoint.position, 3.0) then
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Çıkartma noktası dolu!'})

		return
	end

	
	ESX.TriggerServerCallback('m3:garage:plateCheck', function(result)
		if result then
			ESX.Game.SpawnVehicle(vehicleProps.model, spawnpoint.position, spawnpoint.heading, function(yourVehicle)
				SetVehicleProperties(yourVehicle, vehicleProps)
		
				NetworkFadeInEntity(yourVehicle, true, true)
		
				SetModelAsNoLongerNeeded(vehicleProps.model)
		
				TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
		
				SetEntityAsMissionEntity(yourVehicle, true, true)

				SetVehRadioStation(yourVehicle, "OFF")
				
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Aracınız çıkartıldı!'})

				TriggerServerEvent("m3:garage:vehicleOut", vehicleProps.plate)
			end)
		else
			local gameVehicles = ESX.Game.GetVehicles()

			for i = 1, #gameVehicles do
				local vehicle = gameVehicles[i]

			    if DoesEntityExist(vehicle) then
					if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(vehicleProps.plate) then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bu araç dışarıda! Konumu GPS\'te işaretlendi!', length = 5000})
						local vCoords = GetEntityCoords(vehicle)
						SetNewWaypoint(vCoords.x,vCoords.y)
						return
					end
				end
			end
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bu araç garajda değil!'})
		end
	end, vehicleProps.plate)
end

function GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        -- vehicleProps.tyres = {}
        -- vehicleProps.windows = {}
        vehicleProps.doors = {}

        -- for id = 1, 7 do
        --     local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
        --     if tyreId then
        --         vehicleProps.tyres[#vehicleProps.tyres + 1] = tyreId
        
        --         if tyreId == false then
        --             tyreId = IsVehicleTyreBurst(vehicle, id, true)
        --             vehicleProps.tyres[#vehicleProps.tyres] = tyreId
        --         end
        --     else
        --         vehicleProps.tyres[#vehicleProps.tyres + 1] = false
        --     end
        -- end

        -- for id = 1, 13 do
        --     local windowId = IsVehicleWindowIntact(vehicle, id)

        --     if windowId ~= nil then
        --         vehicleProps.windows[#vehicleProps.windows + 1] = windowId
        --     else
        --         vehicleProps.windows[#vehicleProps.windows + 1] = true
        --     end
        -- end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps.doors[#vehicleProps.doors + 1] = doorId
            else
                vehicleProps.doors[#vehicleProps.doors + 1] = false
            end
        end

        vehicleProps.engineHealth = GetVehicleEngineHealth(vehicle)
        vehicleProps.bodyHealth = GetVehicleBodyHealth(vehicle)
        vehicleProps.fuelLevel = exports["esx_fuels"]:GetFuel(vehicle)

		return vehicleProps
	end
end

function SetVehicleProperties(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

	SetVehicleEngineHealth(vehicle, vehicleProps.engineHealth and vehicleProps.engineHealth + 0.0 or 1000.0)
	
	SetVehicleBodyHealth(vehicle, vehicleProps.bodyHealth and vehicleProps.bodyHealth + 0.0 or 1000.0)

	if vehicleProps.bodyHealth and vehicleProps.bodyHealth + 0.0 or 1000.0 > 990.0 then
		SetVehicleDeformationFixed(vehicle)
	end

    exports["esx_fuels"]:SetFuel(vehicle, vehicleProps.fuelLevel) -- legacy fuel esx

    -- SetVehicleDoorsLockedForAllPlayers(yourVehicle, true)

    -- if vehicleProps.windows then
    --     for windowId = 1, 13, 1 do
    --         if vehicleProps.windows[windowId] == false then
    --             SmashVehicleWindow(vehicle, windowId)
    --         end
    --     end
    -- end

    -- if vehicleProps.tyres then
    --     for tyreId = 1, 7, 1 do
    --         if vehicleProps.tyres[tyreId] ~= false then
    --             SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
    --         end
    --     end
    -- end

    if vehicleProps.doors then
        for doorId = 0, 5, 1 do
            if vehicleProps.doors[doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
	end
end

WaitForModel = function(model)
    local DrawScreenText = function(text, red, green, blue, alpha)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(red, green, blue, alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
    
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.5)
    end

    if not IsModelValid(model) then
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bu model oyun içerisinde mevcut değil!'})
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)

		DrawScreenText("Model Yükleniyor: " .. GetLabelText(GetDisplayNameFromVehicleModel(model)) .. "...", 255, 255, 255, 150)
	end
end
	
