ESX = nil

local cachedData = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("m3:garage:fetchPlayerVehicles", function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT plate, vehicle, job FROM owned_vehicles WHERE owner = @cid AND type = @type', {
			["@cid"] = xPlayer.identifier,
			["@type"] = type
		}, function(responses)
			local playerVehicles = {}
			for key, vehicleData in ipairs(responses) do
				table.insert(playerVehicles, {
					plate = vehicleData.plate,
					props = json.decode(vehicleData.vehicle),
					job = vehicleData.job
				})
			end

			cb(playerVehicles)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("m3:garage:checkBills", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT * FROM billing WHERE identifier = @identifier', {
			["@identifier"] = xPlayer.identifier

		}, function(result)
			if result[1] == nil then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("m3:garage:fetchImpVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT plate, vehicle, job FROM owned_vehicles WHERE owner = @cid AND `stored` = @stored AND type = "car"', {
			["@cid"] = xPlayer.identifier,
			["@stored"] = false

		}, function(responses)
			local playerVehicles = {}
			for key, vehicleData in ipairs(responses) do
				table.insert(playerVehicles, {
					plate = vehicleData.plate,
					props = json.decode(vehicleData.vehicle),
					job = vehicleData.job
				})
			end

			cb(playerVehicles)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("m3:garage:validateVehicle", function(source, cb, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		updateProps(vehicleProps)
		cb(true)
	else
		cb(false)
	end
end)

function updateProps(vehicleProps)
	exports.ghmattimysql:execute('UPDATE owned_vehicles SET `stored` = @stored, vehicle = @vehicle WHERE plate = @plate', {
		["@plate"] = vehicleProps.plate,
		["@stored"] = true,
		["@vehicle"] = json.encode(vehicleProps)})
end

ESX.RegisterServerCallback("m3:garage:plateCheck", function(source, cb, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT * FROM owned_vehicles WHERE plate = @plate', {
			["@plate"] = plate
		}, function(responses)
			if responses[1].stored == true then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('m3:garage:getMoney', function(source, cb, money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getAccount('bank').money >= money then
		xPlayer.removeAccountMoney('bank', money)
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('m3:garage:Save')
AddEventHandler('m3:garage:Save', function(vehicleProps, garage)
	if garage == nil then
		exports.ghmattimysql:execute("UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate", { ["@plate"] = vehicleProps.plate, ["@vehicle"] = json.encode(vehicleProps)})
	else
		exports.ghmattimysql:execute("UPDATE owned_vehicles SET vehicle = @vehicle, `stored` = @stored WHERE plate = @plate", { ["@plate"] = vehicleProps.plate, ["@stored"] = true, ["@vehicle"] = json.encode(vehicleProps)})
	end
end)

-- MySQL.ready(function()
 	-- exports.ghmattimysql:execute("UPDATE owned_vehicles SET stored = 1", {})
-- end)

-- return helicopters
exports.ghmattimysql.ready(function()
	if Config.StoreVehicleOnServerRestart then
		exports.ghmattimysql:execute("UPDATE owned_vehicles SET `stored` = 1")
		print('[^2m3:garage^0] - Restored all vehicles!')
	end
end)

RegisterNetEvent('m3:garage:vehicleOut')
AddEventHandler('m3:garage:vehicleOut', function(plate)
	exports.ghmattimysql:execute("UPDATE owned_vehicles SET `stored` = 0 WHERE plate = @plate", {["@plate"] = plate})
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		print('[^2m3:garage^0] - Started!')
	end
end)