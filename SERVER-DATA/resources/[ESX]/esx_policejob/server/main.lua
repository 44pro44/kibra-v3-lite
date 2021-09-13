ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' then
		print(('esx_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:handcuff', target)
	else
		print(('esx_policejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	TriggerClientEvent('esx_policejob:drag', target, source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Başarılı", "Şirket kasasından "..inventoryItem.name..' '..count..' tane aldınız.', 3000, 'success')

			else
				TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Geçersiz Miktar", 3000, 'error')
			end
		else
			TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Geçersiz Değer Girdiniz", 3000, 'error')
		end
	end)
end)

RegisterNetEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Başarılı", "Şirket kasasına"..inventoryItem.name..' '..count..' tane koydunuz.', 3000, 'success')

		else
			TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Geçersiz Miktar", 3000, 'error')
		end
	end)
end)


ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = exports.ghmattimysql:executeSync('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	exports.ghmattimysql:execute('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

	exports.ghmattimysql:execute('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			exports.ghmattimysql:execute('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	exports.ghmattimysql:execute('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			exports.ghmattimysql:execute('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)




ESX.RegisterServerCallback('esx_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			info = {
				plaka = vehicleProps.plate,
				model = vehicleProps.model
			}, 
			exports.ghmattimysql:execute('INSERT INTO owned_vehicles (owner, vehicle, plate, model, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @model, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@model'] = vehicleProps.model,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
			xPlayer.addInventoryItem("carkey", 1, false, info)   
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = exports.ghmattimysql:executeSync('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		exports.ghmattimysql:execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]
		local shared = Config.AuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

--[[AddEventHandler('playerDropped', function()
    -- Save the source in case we lose it (which happens a lot)
    local _source         = source
    local xPlayer         = ESX.GetPlayerFromId(_source)

    -- Did the player ever join?
    if _source ~= nil then
      

        -- Is it worth telling all clients to refresh?
        if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
            local currentGPS    = xPlayer.getInventoryItem('gps').count
            Citizen.Wait(5000)
            if currentGPS > 0 then
                TriggerClientEvent('esx_policejob:updateBlip', -1)
            end
        end
    end
end)]]

--[[RegisterServerEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
    local _source             = source
    local xPlayer             = ESX.GetPlayerFromId(_source)

    if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        local currentGPS         = xPlayer.getInventoryItem('gps').count
        Citizen.Wait(5000)
        if currentGPS > 0 then
            TriggerClientEvent('esx_policejob:updateBlip', -1)
        end
    end
end)]]

--[[RegisterServerEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local currentGPS     = xPlayer.getInventoryItem('gps').count

    if currentGPS > 0 then
        TriggerClientEvent('esx_policejob:updateBlip', -1)
    end
end)]]

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('esx_policejob:getItem', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventoryItem(item)
	if items == nil then
		cb(0)
	else
		cb(items.count)
	end
end)

--[[AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        if item.name == 'gps' and item.count > 0 then
            TriggerClientEvent('esx_policejob:updateBlip', source)
        end
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        if item.name == 'gps' and item.count < 1 then
            TriggerClientEvent('esx_policejob:removeBlip', source) -- bu event cliente sonradan ekleniyor
        end
    end
end)]]

RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:douncuffing', _source)
end)

function getorfirstname (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local firstname = getFirstname(identifier)
    local lastname = getLastname(identifier)
end

function getFirstname(identifier)
    local result = exports.ghmattimysql:executeSync("SELECT users.firstname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].firstname
    end
    return nil
end

function getLastname(identifier)
    local result = exports.ghmattimysql:executeSync("SELECT users.lastname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].lastname
    end
    return nil
end
--[[
ESX.RegisterServerCallback('GetCharacterNameServer', function(source, cb, target) -- sikleks
	--local xTarget = ESX.GetPlayerFromId(target)
	local xPlayer = ESX.GetPlayerFromId(target)

    local result = exports.ghmattimysql:executeSync("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    cb(''.. firstname .. ' ' .. lastname ..'')
end)--]]

-----------------------------------------------------SPYDAY--------------------------------------------------------
--[[
local GPSList = {}

RegisterServerEvent('exelds:addGPSList')
AddEventHandler('exelds:addGPSList', function(rozetNum)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    exports.ghmattimysql:execute("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = xPlayer.identifier }, function(result)
    local name = string.format("%s %s", result[1].firstname, result[1].lastname)
    table.insert(GPSList, {_source, name, xPlayer.job.name, rozetNum})
    TriggerClientEvent('exelds:refreshGPS', -1)
    end)
end)

RegisterServerEvent('exelds:removeGPSList')
AddEventHandler('exelds:removeGPSList', function()
    local _source = source
    for i = 1, #GPSList do
        if GPSList[i] and GPSList[i][1] == _source then
            table.remove(GPSList, i)
        end
    end
    TriggerClientEvent('exelds:refreshGPS', -1)
end)

ESX.RegisterServerCallback('exelds:getGPSList', function(source, cb)
    cb(GPSList)
end)


AddEventHandler('playerDropped', function()
    local _source         = source
    local xPlayer         = ESX.GetPlayerFromId(_source)
    if _source ~= nil then  
        if xPlayer ~= nil and xPlayer.job ~= nil and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance') then
            for i = 1, #GPSList do
                if GPSList[i] and GPSList[i][1] == _source then
                    table.remove(GPSList, i)
                end
            end
        end
    end
end)


ESX.RegisterServerCallback('esx_policejob:getItemAmount', function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil and xPlayer.job ~= nil and (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance') then
        if item.name == 'gps' and item.count < 1 then
            TriggerClientEvent('exelds:GPSStop', source) 
        end
    end
end)

ESX.RegisterUsableItem('gps', function(source)
    TriggerClientEvent('exelds:gpsAcKapat', source)
end)
]]
-----------------------------------------------------SPYDAY--------------------------------------------------------


------------------------- YİNDİR - YBİNDİR

RegisterServerEvent('hasan:yaralibindir')
AddEventHandler('hasan:yaralibindir', function(target)
    TriggerClientEvent('hasan:ybindir', target)
end)

RegisterServerEvent('hasan:yaralindir')
AddEventHandler('hasan:yaralindir', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('hasan:yaralıindir', target)
end)

ESX.RegisterServerCallback('policejob:isplayerdead', function(source, cb, target)
    local player = ESX.GetPlayerFromId(target)
    exports.ghmattimysql:execute('SELECT is_dead FROM users WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(result)
        local isDead = result[1].is_dead
        cb(isDead)
    end)
end)