-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
-- BU PAKET KİBRAYA AİTTİR KİBRA#9999
local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

RandomStr = function(length)
	if length > 0 then
		return RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end
RandomInt = function(length)
	if length > 0 then
		return RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end
-- ESX.RegisterCommand('setcoords', 'admin', function(xPlayer, args, showError)
-- 	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
-- end, false, {help = _U('command_setcoords'), validate = true, arguments = {
-- 	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
-- 	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
-- 	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
-- }})

ESX.RegisterCommand('tp', 'admin', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:spawnVehicle', args.car)
end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})

ESX.RegisterCommand({'cardel', 'dv'}, 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveitem','admin',function(source,args)
	local Player = ESX.GetPlayerFromId(tonumber(args[1]))
	local count = tonumber(args[3])
	local itemData = ESX.Items[tostring(args[2])] --ESX.Items[tostring(args[2])]
	local sex
	if itemData == nil then TriggerClientEvent("notification",Player.source,"Item bulunamadı",2) return end
	if Player ~= nil then
		if Player.sex == "f" then
			sex = "Kadın"
		else
			sex= "Erkek"
		end
		if count ~= nil and count > 0 then
				local info = {}
				if itemData.name == "wallet" then
					info.firstname = Player.get("firstName")
					info.lastname = Player.get("lastName")
					info.birthdate = Player.get('dateofbirth')
					info.gender = sex
					info.fingerprint = Player.getFingerprint()
					count = 1
				elseif itemData.type == "weapon" then
					count = 1
					info.serie = tostring(RandomInt(2) .. RandomStr(3) .. RandomInt(1) .. RandomStr(2) .. RandomInt(3) .. RandomStr(4))
					info.quality = 100
				end
				Player.addInventoryItem(itemData.name, count, false, info) 
				--local webhooks = exports["fizzfau-base"]:getwebhooks()
				--local discord = exports["fizzfau-base"]:getid(source)["discord"]
				--local discord2 = exports["fizzfau-base"]:getid(tonumber(args[1]))["discord"]
				-- local player = ESX.GetPlayerFromId(source)
				-- local identifier = player.identifier
				--exports["fizzfau-base"]:dclog(webhooks.vezne, "Vezne Log", "**Soygun Başlatan Discord:** " ..discord.. "\n **Karakter Adı:** " ..karakteradi.. "\n **Identifier:** " ..identifier)
				--exports["fizzfau-base"]:dclog(webhooks.giveitem, "giveitem", "\n **Eşyayı Alan: **"..discord2.. "\n **Identifier:** "..Player.identifier.. "\n **Alınan Eşya:** "..itemData.name.. "\n **Adet:** " ..count ) 
				TriggerClientEvent('notification',source,'Item alındı')
				TriggerClientEvent('inventory:client:ItemBox', tonumber(args[1]), ESX.GetItems()[itemData.name], "add",tonumber(args[3]))
		else
			TriggerClientEvent('notification',source,'Değer 0 dan büyük olmalı',2)
		end
	else
		TriggerClientEvent('notification',source,'Oyuncu aktif değil',2)
	end
end)




-- ESX.RegisterCommand('giveweapon', 'admin', function(xPlayer, args, showError)
-- 	if args.playerId.hasWeapon(args.weapon) then
-- 		showError(_U('command_giveweapon_hasalready'))
-- 	else
-- 		xPlayer.addWeapon(args.weapon, args.ammo)
-- 	end
-- end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
-- 	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
-- 	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
-- 	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
-- }})

-- ESX.RegisterCommand('giveweaponcomponent', 'admin', function(xPlayer, args, showError)
-- 	if args.playerId.hasWeapon(args.weaponName) then
-- 		local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

-- 		if component then
-- 			if xPlayer.hasWeaponComponent(args.weaponName, args.componentName) then
-- 				showError(_U('command_giveweaponcomponent_hasalready'))
-- 			else
-- 				xPlayer.addWeaponComponent(args.weaponName, args.componentName)
-- 			end
-- 		else
-- 			showError(_U('command_giveweaponcomponent_invalid'))
-- 		end
-- 	else
-- 		showError(_U('command_giveweaponcomponent_missingweapon'))
-- 	end
-- end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
-- 	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
-- 	{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
-- 	{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'}
-- }})

ESX.RegisterCommand({'clearall', 'clsall'}, 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
			RemoveAllPedWeapons(PlayerPedId(), true)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('clearloadout', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.loadout) do
		args.playerId.removeWeapon(v.name)
	end
end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('setgroup', 'admin', function(xPlayer, args, showError)
	args.playerId.setGroup(args.group)
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

-- ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
-- 	ESX.SavePlayer(args.playerId)
-- end, true, {help = _U('command_save'), validate = true, arguments = {
-- 	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
-- }})

ESX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	ESX.SavePlayers()
end, true, {help = _U('command_saveall')})
