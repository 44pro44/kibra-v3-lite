ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_hospital:pay')
AddEventHandler('esx_hospital:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	--xPlayer.removeMoney(Config.Price)
    xPlayer.removeAccountMoney('bank', Config.Price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(Config.Price)))

end)

ESX.RegisterServerCallback('esx_hospital:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getMoney() >= Config.Price)
end)

--[[ESX.RegisterServerCallback('npc-doktor:getOnlinePolice', function(source, cd)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            cops = cops + 1
        end
    end
    Wait(25)
    cd(cops)
end)--]]

ESX.RegisterServerCallback('npc-doktor:getOnlineAmbulance', function(source, cb)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)