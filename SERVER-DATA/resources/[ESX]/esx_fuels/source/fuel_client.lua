ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local aktifblipler = {}
local blip = false
local isFueling = false
local currentCost = 0
local fuelLevel = 0.0
local wait = 1000

local fuelSynced = false
local inBlacklisted = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(wait)
		wait = 1000
	end
end)

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(wait)
		local PlayerPed = PlayerPedId()
		if not IsPedInAnyVehicle(PlayerPed, true) then		
			local playerCoords = GetEntityCoords(PlayerPed)
			for i=1, #Config.GasStations do
				local distance = #(playerCoords - Config.GasStations[i].coords)
				if distance < Config.GasStations[i].r then
					wait = 1
					local lastVehicle = GetPlayersLastVehicle(PlayerPed)
					local lastVehicleCoords = GetEntityCoords(lastVehicle)
					if #(playerCoords - GetEntityCoords(lastVehicle)) < 5 then
						fuelLevel = GetVehicleFuelLevel(lastVehicle)
						
						if fuelLevel < 100.0 then
							text = "[E] Benzini Doldur"
							if IsControlJustReleased(0, 38) then
								currentCost = 0
								local benzinFiyat = '3.5'
								TaskTurnPedToFaceEntity(PlayerPed, lastVehicle, 1000)
								isFueling = true
								
								TriggerEvent("LegacyFuel:draw-text", lastVehicleCoords, lastVehicle, PlayerPed)
								local oldFuel = DecorGetFloat(lastVehicle, "_FUEL_LEVEL")
								DecorSetFloat(lastVehicle, "_FUEL_LEVEL", oldFuel)
								while isFueling do
									Citizen.Wait(500)
									
									local fuelToAdd = 1.5
									local extraCost = fuelToAdd / benzinFiyat
									
									fuelLevel = fuelLevel + fuelToAdd
									if fuelLevel > 100.0 then
										fuelLevel = 100.0
										isFueling = false
									end
									currentCost = currentCost + extraCost
								end

								local seatPlayerId = {}
								for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(lastVehicle)) do
									if not IsVehicleSeatFree(lastVehicle, i-2) then 
										local otherPlayerId = GetPedInVehicleSeat(lastVehicle, i-2) 
										local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
										local playerServerId = GetPlayerServerId(playerHandle)
										table.insert(seatPlayerId, playerServerId)
									end
								end
								SetVehicleFuelLevel(lastVehicle, fuelLevel+0.0)
								DecorSetFloat(lastVehicle, "_FUEL_LEVEL", fuelLevel+0.0)
								if #seatPlayerId > 0 then
									TriggerServerEvent("LegacyFuel:set-all-client", fuelLevel+0.0, seatPlayerId)
								end
								TriggerServerEvent("fuel:pay", currentCost)
						
							end
						else
							text = "Aracın Deposu Full"
						end
						DrawMarker(2, lastVehicleCoords.x, lastVehicleCoords.y, lastVehicleCoords.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
						DrawText3D(lastVehicleCoords.x, lastVehicleCoords.y, lastVehicleCoords.z+1.1, text)

					end
				end

			end
		end

	end
end)

RegisterNetEvent('LegacyFuel:set-all-client-server')
AddEventHandler('LegacyFuel:set-all-client-server', function(fuelLevel)
	local PlayerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPed, false)
	SetVehicleFuelLevel(vehicle, fuelLevel+0.0)
	DecorSetFloat(vehicle, "_FUEL_LEVEL", fuelLevel+0.0)
end)

AddEventHandler('LegacyFuel:draw-text', function(lastVehicleCoords, vehicle, ped)
	LoadAnimDict("timetable@gardener@filling_can")
	while isFueling do
		Citizen.Wait(1)
		disableControl()

		DrawText3D(lastVehicleCoords.x, lastVehicleCoords.y, lastVehicleCoords.z + 0.8, "[Del] Iptal Et / " .. "Tutar: $" .. string.format("%.2f", currentCost).. " / Depo: " .. string.format("%.1f", fuelLevel) .. "%")
		if IsControlJustReleased(0, 178) then
			isFueling = false
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end
	end
	ClearPedTasks(ped)
end)

function disableControl()
	DisableControlAction(0, 0)
	DisableControlAction(0, 22)
	DisableControlAction(0, 23)
	DisableControlAction(0, 24)
	DisableControlAction(0, 29)
	DisableControlAction(0, 30)
	DisableControlAction(0, 31)
	DisableControlAction(0, 37)
	DisableControlAction(0, 44)
	DisableControlAction(0, 56)
	DisableControlAction(0, 82)
	DisableControlAction(0, 140)
	DisableControlAction(0, 166)
	DisableControlAction(0, 167)
	DisableControlAction(0, 168)
	DisableControlAction(0, 170)
	DisableControlAction(0, 288)
	DisableControlAction(0, 289)
	DisableControlAction(0, 311)
	DisableControlAction(0, 323)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 140)
end

RegisterNetEvent("LegacyFuel:blipAcKapa")
AddEventHandler("LegacyFuel:blipAcKapa", function()
	if blip then
		pasifblip()
		blip = false
	else
		aktifblip()
		blip = true
	end
end)

function aktifblip()
	for k,v in pairs(Config.GasStations) do
		print(v.coords)
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite(blip, 361)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 60)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Benzin İstasyonu")
		EndTextCommandSetBlipName(blip)
		table.insert(aktifblipler, blip)
	end
end

function pasifblip()
	for i = 1, #aktifblipler do
		RemoveBlip(aktifblipler[i])
	end

	for i = 1, #aktifblipler do
		table.remove(aktifblipler)
	end
end

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, "_FUEL_LEVEL") then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, DecorGetFloat(vehicle, "_FUEL_LEVEL"))
		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

function SetFuel(vehicle, fuel)
	if fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	end
end

Citizen.CreateThread(function()
	DecorRegister("_FUEL_LEVEL", 1)

	for i = 1, #Config.Blacklist do
		if type(Config.Blacklist[i]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[i])] = true
		else
			Config.Blacklist[Config.Blacklist[i]] = true
		end
	end

	for i = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, i)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)