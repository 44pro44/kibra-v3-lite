ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vehicleshop.requestInfo')
AddEventHandler('vehicleshop.requestInfo', function()
    local src = source
    local rows    

    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = GetPlayerIdentifiers(src)[1]

    local result = exports.ghmattimysql:executeSync("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    local firstname = result[1].firstname 

    local resultVehicles = exports.ghmattimysql:executeSync('SELECT * FROM vehicles')

    TriggerClientEvent('vehicleshop.receiveInfo', src, xPlayer.getAccount('bank').money, firstname)    

    TriggerClientEvent("vehicleshop.vehiclesInfos", src , resultVehicles)

    TriggerClientEvent("vehicleshop.notify", src, 'error', _U('rotate_keys'))
end)

ESX.RegisterServerCallback('kibra-galeri-sayi', function(source, cb)
    cb(getGaleri("galeri"))
end)

function getGaleri(jobName)
    local sayi = 0
    local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if jobName == "galeri" then
            if xPlayer.job.name == "galeri" then
                sayi = sayi + 1
            end
        else
            if xPlayer.job.name == jobName  then
                sayi = sayi + 1
            end
        end
    end
    return sayi
end

ESX.RegisterServerCallback('vehicleshop.isPlateTaken', function (source, cb, plate)
	exports.ghmattimysql:execute('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

RegisterServerEvent('vehicleshop.CheckMoneyForVeh')
AddEventHandler('vehicleshop.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
	local source = source

	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer == nil then
        return
    end

    exports.ghmattimysql:execute('SELECT * FROM vehicles WHERE model = @model LIMIT 1', {
		['@model'] = veh
    }, function (result)
        if #result > 0 then
            local veiculo = result[1]
            local _source = source
            local vehicleModel = veh
            local isim1 = exports.ghmattimysql:executeSync("SELECT * FROM users WHERE identifier = @identifier", { ['@identifier'] = xPlayer.identifier })
            local ad_soyad = isim1[1].firstname.." "..isim1[1].lastname
            local vehiclePrice = price
            local stockQtd = result[1].stock       
            if stockQtd > 0 then           
                if xPlayer.getAccount('bank').money >= tonumber(vehiclePrice) then
                    xPlayer.removeAccountMoney('bank', tonumber(vehiclePrice))
                    stockQtd = stockQtd - 1	                    
                    local vehiclePropsjson = json.encode(vehicleProps)
                    
                    local stateVehicle = 0 

                    if Config.SpawnVehicle then
                        stateVehicle = 0
                    else
                        stateVehicle = 1
                    end
                    
                    exports.ghmattimysql:execute('INSERT INTO owned_vehicles (owner, plate, vehicle, model, state) VALUES (@owner, @plate, @vehicle, @model, @state)',
                    {
                        ['@owner']   = xPlayer.identifier,
                        ['@plate']   = vehicleProps.plate,
                        ['@vehicle'] = vehiclePropsjson,
                        ['@model'] = vehicleModel,
                        ['@state'] = stateVehicle,
                    },
    
                    function (rowsChanged)                     
                        exports.ghmattimysql:execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
                        {
                            ['@stock'] = stockQtd,
                            ['@model'] = vehicleModel
                        })
                        info = {
                            plaka = vehicleProps.plate,
                            model = vehicleModel
                        }  
                        exports.ghmattimysql:execute('INSERT INTO gloveboxitemsnew (plate,items) VALUES (@plate, @items)', {
                            ["@plate"] = vehicleProps.plate,
                            ["@items"] = "[]"
                        })
                        TriggerClientEvent("vehicleshop.sussessbuy", source, name, vehicleProps.plate, vehiclePrice)
                        TriggerClientEvent('vehicleshop.receiveInfo', source, xPlayer.getAccount('bank').money)
                        TriggerClientEvent('vehicleshop.spawnVehicle', source, vehicleModel, vehicleProps.plate)         
                        xPlayer.addInventoryItem("carkey", 1, false, info)   
                       -- xPlayer.addInventoryItem("sparekeys", 1, false, info)

                        dclog(xPlayer, '** '..ad_soyad..' '..vehicleModel..' model araç satın aldı. Plaka: '..vehicleProps.plate..' Araba Fiyatı: '..vehiclePrice..' $**')
                     
              
                    end)
                else
                    TriggerClientEvent('okokNotify:Alert', source, "Araç Galerisi", "Paranız Yetersiz", 3000, 'error')




                end
            else
                TriggerClientEvent('okokNotify:Alert', source, "Araç Galerisi", "Bu Araca Sahip Değilsiniz", 3000, 'error')
            end  
        end
	end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
      exports.ghmattimysql:ready(function() SQLVehiclesAndCategories() end)
    end
  end)
  
  function SQLVehiclesAndCategories()
    exports.ghmattimysql:execute('SELECT * FROM `vehicle_categories`', {}, function(_categories)
          categories = _categories
  
          exports.ghmattimysql:execute('SELECT * FROM `vehicles`', {}, function(_vehicles)
              vehicles = _vehicles
  
              GetVehiclesAndCategories(categories, vehicles)
          end)
  
      end)
  end

  function GetVehiclesAndCategories(categories, vehicles)
	for k,v in ipairs(vehicles) do
		for k2,v2 in ipairs(categories) do
			if v2.name == v.category then
				vehicles[k].categoryLabel = v2.label
				break
			end
		end
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, categories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vehicles)
end

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(categories)
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
    

    local discord_webhook = "https://discord.com/api/webhooks/855503524456300615/UbMonP6WTe3OUEuixouB0JRQcZxVL9HVk6mBUrGLGMmqaVjtGTlwJ71nxJHd-k4lR18Z"
    if discord_webhook == '' then
        return
    end
    local headers = {
        ['Content-Type'] = 'application/json'
    }
    local data = {
        ["username"] = "Kibra-V2 Araç Galerisi",
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/854984858437550080/855464129762689075/62299912.png",
        ["embeds"] = {{
            ["author"] = {
                ["name"] = playerName.. ' - ' ..xPlayer.identifier
            },
            ["color"] = 1942002,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
    :gsub('[&<>\n]', replacements)
    :gsub(' +', function(s)
        return ' '..('&nbsp;'):rep(#s-1)
    end)
end

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	exports.ghmattimysql:execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_vehicleshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)


ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	exports.ghmattimysql:execute('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)