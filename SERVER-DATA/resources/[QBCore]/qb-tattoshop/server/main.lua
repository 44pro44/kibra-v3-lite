ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		table.insert(tattooList, tattoo)

		exports.ghmattimysql:execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(tattooList),
			['@identifier'] = xPlayer.identifier
		})
        ExecuteCommand("yenile")
		TriggerClientEvent('okokNotify:Alert', source, "Dövmeci", "Dövme satın alarak "..ESX.Math.GroupDigits(price)..'$ ödediniz.', 3000, 'success')

		cb(true)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('okokNotify:Alert', source, "Dövmeci", "Dövme satın alacak paranız yok!", 3000, 'error')

		cb(false)
	end
end)
