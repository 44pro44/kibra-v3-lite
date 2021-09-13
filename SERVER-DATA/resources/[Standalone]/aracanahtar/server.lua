ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('carkey', function() end)
ESX.RegisterUsableItem('sparekeys', function() end)

ESX.RegisterServerCallback('tq-vehiclekey:server:checkKey', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local anahtarhocam = ESX.GetSlotsByItem(xPlayer.inventory, "carkey")
	local anahtarhocam1 = ESX.GetSlotsByItem(xPlayer.inventory, "sparekeys")
    cb(anahtarhocam)
	cb(anahtarhocam1)
end)

ESX.RegisterServerCallback('aracanahtar:isVehicleOwner', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source, 0)
	local inventory = xPlayer.getInventory()
	local plate = ESX.Math.Trim(plate)
		cb(IsAllowed(inventory, plate))
end)

function IsAllowed(inventory, plate)
	for k,v in pairs(inventory) do
		if v.name == 'carkey' or 'sparekeys' then
			if v.info.plaka == plate then
				return true
			end
		end
	end
		return false
end

ESX.RegisterServerCallback("tq-vehiclekey:server:getPlayerVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT plate, vehicle FROM owned_vehicles WHERE owner = @identifier', {
		["@identifier"] = xPlayer.identifier,
	}, function(result)
		local vehicles = {}
		for k, v in ipairs(result) do
			table.insert(vehicles, {
				plate = v.plate,
				props = json.decode(v.vehicle)
			})
		end
		cb(vehicles)
	end)
end)

RegisterServerEvent("tq-vehiclekey:server:needKey")
AddEventHandler("tq-vehiclekey:server:needKey", function(plate, vehicleModel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    info = {
        plaka = plate,
        model = vehicleModel
    }    
    xPlayer.addInventoryItem("carkey", 1, false, info)
--	xPlayer.addInventoryItem("sparekeys", 1, false, info)    
    
end)