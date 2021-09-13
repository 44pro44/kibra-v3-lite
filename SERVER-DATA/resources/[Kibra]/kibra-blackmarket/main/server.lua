ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("Kibra:BlackMarket:server:BuyItem")
AddEventHandler("Kibra:BlackMarket:server:BuyItem", function(item, price, marketci)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Player.getMoney() >= price then
        Player.removeMoney(price)
        Player.addInventoryItem(item, 1)
        TriggerClientEvent('okokNotify:Alert', src, "Başarılı", marketci..' den <b>$'..price..'</b> karşılığında '..item..' satın aldınız!', 6000, 'success')
    else
        TriggerClientEvent('okokNotify:Alert', src, "Başarısız", 'Bu ürünü almak için paran yetersiz! İndirim yok!', 6000, 'error')
    end
end)

ESX.RegisterServerCallback('Kibra:BlackMarket:server:PoliceSayi', function(source, cb)
    cb(getPolice("police"))
end)


function getPolice(jobName)
    local sayi = 0
    local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if jobName == "police" then
            if xPlayer.job.name == "police" then
                sayi = sayi + 1
            end
        end
    end
    return sayi
end