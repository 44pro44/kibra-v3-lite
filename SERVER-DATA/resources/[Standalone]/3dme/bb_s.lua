ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("me",function(source, args)
	local src = source
	args = table.concat(args, ' ')
	TriggerClientEvent('bb-3dme:client:triggerDisplay', -1, src, args, "me")
    TriggerEvent('DiscordBot:ToDiscord', 'medo', '/me ' .. args, src)
end)

RegisterCommand("do", function(source, args)
	local src = source
	args = table.concat(args, ' ')
	TriggerClientEvent('bb-3dme:client:triggerDisplay', -1, src, args, "do")
	TriggerEvent('DiscordBot:ToDiscord', 'medo', '/do ' .. args, src)
end)

RegisterServerEvent('3dme:display')
AddEventHandler('3dme:display', function(text, key, mod)
    local src = source
		if mod == nil then mod = "me" end
        TriggerClientEvent('bb-3dme:client:triggerDisplay', -1, src, text, mod)
		TriggerEvent('DiscordBot:ToDiscord', 'medo', '/'..mod..' ' .. text, src)
end)

RegisterServerEvent('3dme:server:tgiann-doctor')
AddEventHandler('3dme:server:tgiann-doctor', function(text, coords, key)
	local src = source
		TriggerClientEvent('3dme:client:tgiann-doctor', -1, text, coords)
end)
