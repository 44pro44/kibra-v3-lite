ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Yediniz", "Ekmek Yediniz", 3000, 'info')
end)

ESX.RegisterUsableItem('sandvic', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandvic', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Yediniz", "Sandwich Yediniz", 3000, 'info')
end)

ESX.RegisterUsableItem('hamburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Yediniz", "Hamburger Yediniz", 3000, 'info')
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "İçtiniz", "Kola içtiniz", 3000, 'info')
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "İçtiniz", "Su içtiniz", 3000, 'info')
end)

ESX.RegisterUsableItem('redbull', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('redbull', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.source, "İçtiniz", "Redbull içtiniz", 3000, 'info')
end)

ESX.RegisterUsableItem('cigarette', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette', 1)
		TriggerClientEvent('esx_basicneeds:onSmoke', source)
		TriggerClientEvent('esx_status:remove', source, 'stress', 50000) -- %5
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Sigara içiyorsun.'})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Çakmağa ihtiyacın var!'})
	end
end)

ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:healPlayer')
	args.playerId.triggerEvent('chat:addMessage', {args = {'^5HEAL', 'You have been healed.'}})
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})
