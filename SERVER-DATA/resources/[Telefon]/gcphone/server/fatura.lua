--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
ESX.RegisterServerCallback("crew:getBills", function(a, b)
    local c = ESX.GetPlayerFromId(a)
    exports.ghmattimysql:execute("SELECT amount, id, target, label FROM billing WHERE identifier = @identifier", {["@identifier"] = c.identifier}, function(d)
        b(d)
    end)
end)

RegisterServerEvent("gcPhone:faturapayBill")
AddEventHandler("gcPhone:faturapayBill", function(a)
    local b = ESX.GetPlayerFromId(source)
    exports.ghmattimysql:execute("SELECT * FROM billing WHERE id = @id", {["@id"] = a}, function(c)
        local d = c[1].sender;
        local e = c[1].target_type;
        local f = c[1].target;
        local g = c[1].amount;
        local h = ESX.GetPlayerFromIdentifier(d)
        if e == "player" then 
            if h ~= nil then
                if b.getAccount("bank").money >= g then
                    exports.ghmattimysql:execute("DELETE from billing WHERE id = @id", {["@id"] = a}, function(i)
                        b.removeAccountMoney("bank", g)
                        h.addAccountMoney("bank", g)
                        TriggerClientEvent("esx:showNotification", b.source, _U("paying_bill"))
                        TriggerClientEvent("esx:showNotification", h.source, _U("payed_bill"))
                        TriggerClientEvent("gcPhone:updateFaturalar", b.source) 
                    end)
                end
            end
        else
            TriggerEvent("esx_addonaccount:getSharedAccount", f, function(j)
                if b.getAccount("bank").money >= g then
                    exports.ghmattimysql:execute("DELETE from billing WHERE id = @id", {["@id"] = a}, function(i)
                        local k = ESX.Math.Round(g)
                        local l = ESX.Math.Round(g)
                        b.removeAccountMoney("bank", g)
                        j.addMoney(l)
                        TriggerClientEvent("esx:showNotification", b.source, _U("payed_bill_complete") .. g)
                        TriggerClientEvent("gcPhone:updateFaturalar", b.source)
                    end)
                else 
                    TriggerClientEvent("esx:showNotification", b.source, _U("not_enough_money"))
                end
            end)
        end
    end)
end)
