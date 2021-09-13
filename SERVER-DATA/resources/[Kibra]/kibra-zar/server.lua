ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem("zar", function(source)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("K1.CLIENT.ZARAT", source)
end)

