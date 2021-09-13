ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if model ~= nil and skin ~= nil then 
        exports.ghmattimysql:execute('DELETE FROM playerskins WHERE citizenid=@citizenid', {['@citizenid'] = Player.identifier}, function()
            exports.ghmattimysql:execute('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (@citizenid, @model, @skin, @active)', {
                ['@citizenid'] = Player.identifier,
                ['@model'] = model,
                ['@skin'] = skin,
                ['@active'] = 1
            })
        end)
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin")
AddEventHandler('qb-clothes:loadPlayerSkin', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local result = exports.ghmattimysql:executeSync('SELECT * FROM playerskins WHERE citizenid=@citizenid AND active=@active', {['@citizenid'] = Player.identifier, ['@active'] = 1})
    if result[1] ~= nil then
        TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("qb-clothes:loadSkin", src, true)
    end
end)

RegisterServerEvent("qb-clothes:saveOutfit")
AddEventHandler("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        exports.ghmattimysql:execute('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)', {
            ['@citizenid'] = Player.identifier,
            ['@outfitname'] = outfitName,
            ['@model'] = model,
            ['@skin'] = json.encode(skinData),
            ['@outfitId'] = outfitId
        }, function()
            local result = exports.ghmattimysql:executeSync('SELECT * FROM player_outfits WHERE citizenid=@citizenid', {['@citizenid'] = Player.identifier})
            if result[1] ~= nil then
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit")
AddEventHandler("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    exports.ghmattimysql:execute('DELETE FROM player_outfits WHERE citizenid=@citizenid AND outfitname=@outfitname AND outfitId=@outfitId', {
        ['@citizenid'] = Player.identifier,
        ['@outfitname'] = outfitName,
        ['@outfitId'] = outfitId
    }, function()
        local result = exports.ghmattimysql:executeSync('SELECT * FROM player_outfits WHERE citizenid=@citizenid', {['@citizenid'] = Player.identifier})
        if result[1] ~= nil then
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

ESX.RegisterServerCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local anusVal = {}

    local result = exports.ghmattimysql:executeSync('SELECT * FROM player_outfits WHERE citizenid=@citizenid', {['@citizenid'] = Player.identifier})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
        cb(anusVal)
    end
    cb(anusVal)
end)