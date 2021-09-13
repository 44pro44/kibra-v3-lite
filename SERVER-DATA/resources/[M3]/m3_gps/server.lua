
ESX, bliptable = nil, {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('gps', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if GetCurrentResourceName() == 'm3_gps' then
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
            TriggerClientEvent('m3:gps:client:Used', src)
        end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Script adını m3_gps olarak ayarlayınız!'})
	end
end)

RegisterServerEvent('m3:gps:server:openGPS')
AddEventHandler('m3:gps:server:openGPS', function(code)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local result = exports.ghmattimysql:execute('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    bliptable[src] = {firstname = result[1].firstname, lastname = result[1].lastname, src = src, job = xPlayer.job.name, code = code}
end)

RegisterServerEvent('m3:gps:server:closeGPS')
AddEventHandler('m3:gps:server:closeGPS', function()
    local src = source

    TriggerClientEvent('m3:gps:client:forceCloseAllRemoveBlip', src)

    bliptable[src] = nil

    for k, v in pairs(bliptable) do
        TriggerClientEvent('m3:gps:client:removeBlip', k, src)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if bliptable ~= {} then
            for i, z in pairs(bliptable) do
                local player = GetPlayerPed(i)
                local coord = GetEntityCoords(player)
                for k, v in pairs(bliptable) do
                    TriggerClientEvent('m3:gps:client:getPlayerInfo', k, {
                        coord = coord,
                        job = z.job,
                        src = i,
                        text = '['..z.code..'] - '..z.firstname..' '..z.lastname,
                    })
                end
            end
        end
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if item == 'gps' and count < 1 then
        TriggerClientEvent('m3:gps:client:forceCloseAllRemoveBlip', src)

		for k, v in pairs(bliptable) do
            TriggerClientEvent('m3:gps:client:removeBlip', k, src)
        end

        bliptable[src] = nil
	end
end)

AddEventHandler('playerDropped', function(_)

    bliptable[source] = nil

    for k, v in pairs(bliptable) do
        TriggerClientEvent('m3:gps:client:removeBlip', k, source) 
    end
end)