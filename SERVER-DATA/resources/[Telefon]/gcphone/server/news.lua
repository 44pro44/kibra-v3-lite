--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 
RegisterServerEvent("crew-phone:new-news")
AddEventHandler("crew-phone:new-news", function(a, b, c, d)
    local e = {}
    e.name = a;
    e.content = b;
    e.img = c;
    if d ~= nil then
        e.video = d
    end;
    exports.ghmattimysql:execute("INSERT INTO crew_phone_news (`data`) VALUES (@data);", {["@data"] = json.encode(e)})
    TriggerClientEvent("gcPhone:twitter_showSuccess", -1, a, c)
end)

RegisterServerEvent("crew-phone:delete-news")
AddEventHandler("crew-phone:delete-news", function(a)
    exports.ghmattimysql:execute("DELETE from crew_phone_news WHERE id = @id", {["@id"] = a}) end)

ESX.RegisterServerCallback("crew-phone:get-news", function(a, b)
    exports.ghmattimysql:execute("SELECT * FROM crew_phone_news ORDER BY id DESC", {}, function(c)
        local d = {}
        for e = 1, #c, 1 do table.insert(d, {alldata = c[e].data, id = c[e].id})
        end; 
        b(d)
    end)
end)

ESX.RegisterServerCallback("crewPhone:getWanted", function(a, b)
    exports.ghmattimysql:execute("SELECT * FROM epc_bolos order by id", {}, function(c)
        b(c)
    end)
end)
