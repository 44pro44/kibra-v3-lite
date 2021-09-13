local cashAmount = 0
local bankAmount = 0

RegisterNetEvent("tgiannHudMoney")
AddEventHandler("tgiannHudMoney", function(show)
    SendNUIMessage({
        type = "money",
        show = show,
        money = cashAmount
    })
end)

RegisterNetEvent("hud:client:SetMoney")
AddEventHandler("hud:client:SetMoney", function(nPlayerData)
    if PlayerData and PlayerData.money then
        cashAmount = ESX.Math.Round(ESX.PlayerData.money.cash)
    end
end)

RegisterNetEvent("hud:client:OnMoneyChange")
AddEventHandler("hud:client:OnMoneyChange", function(type, amount, isMinus)
    if type == "cash" then
        ESX.PlayerData = ESX.GetPlayerData()
        cashAmount = ESX.Math.Round(ESX.PlayerData.money.cash)
        SendNUIMessage({
            type = "moneyUpdate",
            money = amount,
            newCashAmount = cashAmount,
            isMinus = isMinus
        })
    end
end)