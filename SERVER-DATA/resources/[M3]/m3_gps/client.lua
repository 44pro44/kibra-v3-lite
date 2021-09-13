ESX, gps, blips = nil, false, {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('m3:gps:client:Used')
AddEventHandler('m3:gps:client:Used', function()
    local elements = {}
	
	table.insert(elements, {label = 'GPS Aç', value = 'gpson'})
	table.insert(elements, {label = 'GPS Kapat', value = 'gpsoff'})
    
    ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gps', {
		title    = 'GPS',
		align    = 'right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'gpson' then
			if not gps then
                ESX.UI.Menu.CloseAll()
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'GPS\'te görünmesini istediğiniz kodunuzu giriniz!', length = 5000})
                local code = keyboardInput('GPS Kodu:', '', 5)
                    
                if code == '' or code == nil then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS kodunuz boş olamaz!', length = 5000})
                else
                    gps = true
                    TriggerServerEvent('m3:gps:server:openGPS', code)
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'GPS\'iniz açıldı!', length = 5000})
                end
            else
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz zaten açık!', length = 5000})
            end
        elseif data.current.value == 'gpsoff' then
            if gps then
                gps = false
                TriggerServerEvent('m3:gps:server:closeGPS')
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz kapatıldı!', length = 5000})
            else
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz zaten kapalı!', length = 5000})
            end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

function keyboardInput(arg1, arg2, arg3) 
    AddTextEntry('FMMC_KEY_TIP1', arg1) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", arg2, "", "", "", arg3) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        TriggerEvent('m3:inventoryhud:client:invUseable', false)
        Citizen.Wait(0) 
    end 
    if UpdateOnscreenKeyboard() ~= 2 then 
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        TriggerEvent('m3:inventoryhud:client:invUseable', true)
        return result 
    else 
        Citizen.Wait(500)
        TriggerEvent('m3:inventoryhud:client:invUseable', true)
        return nil 
    end 
end

RegisterNetEvent('m3:gps:client:getPlayerInfo')
AddEventHandler('m3:gps:client:getPlayerInfo', function(bliptable)
    if GetPlayerServerId(PlayerId()) ~= bliptable.src then
        if DoesBlipExist(blips[bliptable.src]) then
            SetBlipCoords(blips[bliptable.src], bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
        else
            blips[bliptable.src] = AddBlipForCoord(bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
            SetBlipSprite(blips[bliptable.src], 1)
            if bliptable.job == 'police' then
                SetBlipColour(blips[bliptable.src], 57)
            elseif bliptable.job == 'sheriff' then
                SetBlipColour(blips[bliptable.src], 60)
            elseif bliptable.job == 'ambulance' then
                SetBlipColour(blips[bliptable.src], 49)
            end
            SetBlipScale(blips[bliptable.src], 0.85)
            SetBlipAsShortRange(blips[bliptable.src], true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bliptable.text)
            EndTextCommandSetBlipName(blips[bliptable.src])
        end
    end
end)

--[[
RegisterNetEvent('m3:gps:client:getPlayerInfo')
AddEventHandler('m3:gps:client:getPlayerInfo', function(bliptable)
    if GetPlayerServerId(PlayerId()) ~= bliptable.src then
        if DoesBlipExist(blips[bliptable.src]) then
            SetBlipCoords(blips[bliptable.src], bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
        else
            blips[bliptable.src] = AddBlipForCoord(bliptable.coord.x, bliptable.coord.y, bliptable.coord.z)
            SetBlipSprite(blips[bliptable.src], 1)
            if bliptable.job == 'police' then
                SetBlipColour(blips[bliptable.src], 57)
            elseif bliptable.job == 'sheriff' then
                SetBlipColour(blips[bliptable.src], 60)
            elseif bliptable.job == 'ambulance' then
                SetBlipColour(blips[bliptable.src], 49)
            end
            SetBlipScale(blips[bliptable.src], 0.85)
            SetBlipAsShortRange(blips[bliptable.src], true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bliptable.text)
            EndTextCommandSetBlipName(blips[bliptable.src])
        end
    end
end)
]]--
RegisterNetEvent('m3:gps:client:removeBlip')
AddEventHandler('m3:gps:client:removeBlip', function(src)
    local blip = blips[src]
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blips[src] = nil
    end
end)

RegisterNetEvent('m3:gps:client:forceCloseAllRemoveBlip')
AddEventHandler('m3:gps:client:forceCloseAllRemoveBlip', function()
    gps = false
    for k, v in pairs(blips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
        Citizen.Wait(0)
    end
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'GPS\'iniz kapatıldı!', length = 5000})
end)