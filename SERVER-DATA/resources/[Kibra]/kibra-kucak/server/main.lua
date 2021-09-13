ESX = nil

local give = false
local usedRope = false
local isKucaklandi = false

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_barbie_lyftupp:checkRope')
AddEventHandler('esx_barbie_lyftupp:checkRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getQuantity('rope') > 0 then
		TriggerClientEvent('esx_barbie_lyftupp:trueRope', source) -- true
	else
		TriggerClientEvent('esx_barbie_lyftupp:falseRope', source) -- false
	end
end)

RegisterServerEvent('esx_barbie_lyftupp:removeRope')
AddEventHandler('esx_barbie_lyftupp:removeRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('rope', 1)
	TriggerClientEvent('esx_barbie_lyftupp:trueUsedRope', source)
	
end)

RegisterServerEvent('esx_barbie_lyftupp:lyfter')
AddEventHandler('esx_barbie_lyftupp:lyfter', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_barbie_lyftupp:upplyft', targetPlayer.source, source)
end)

RegisterServerEvent('esx_barbie_lyftupp:lyfteruppn')
AddEventHandler('esx_barbie_lyftupp:lyfteruppn', function(source)
	local _source = source

end)

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_omuzlama:checkRope')
AddEventHandler('esx_omuzlama:checkRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getQuantity('rope') > 0 then
		TriggerClientEvent('esx_omuzlama:trueRope', source) -- true
	else
		TriggerClientEvent('esx_omuzlama:falseRope', source) -- false
	end
end)

RegisterServerEvent('esx_omuzlama:removeRope')
AddEventHandler('esx_omuzlama:removeRope', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('rope', 1)
	TriggerClientEvent('esx_omuzlama:trueUsedRope', source)
end)

RegisterServerEvent('esx_omuzlama:lyfter')
AddEventHandler('esx_omuzlama:lyfter', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_omuzlama:upplyft', targetPlayer.source, source)
end)

RegisterServerEvent('esx_omuzlama:lyfteruppn')
AddEventHandler('esx_omuzlama:lyfteruppn', function(source)
	if isKucaklandi == false then
		TriggerClientEvent("swt_notifications:Warning",source,"Kucaklama","Birisi seni omzuna alıyor","top",2000,true)


		isKucaklandi = true
	elseif isKucaklandi == true then
		TriggerClientEvent("swt_notifications:Warning",source,"Kucaklama","Birisi seni omzundan indiriyor!","top",2000,true)

		isKucaklandi = false
	end

end)
