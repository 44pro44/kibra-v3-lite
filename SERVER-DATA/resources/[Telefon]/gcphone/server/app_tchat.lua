--
--  LEAKED BY S3NTEX -- 
--  https://discord.gg/aUDWCvM -- 
--  fivemleak.com -- 
--  fkn crew -- 

function TchatGetMessageChannel(a,b)
    exports.ghmattimysql:execute("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100",{['@channel']=a},b)
end

function TchatAddMessage(a,b)
   exports.ghmattimysql:execute("INSERT INTO phone_app_chat (channel, message) VALUES(@channel, @message)",{['@channel']=a,['@message']=b},function(c)
    local result = exports.ghmattimysql:executeSync("SELECT * from phone_app_chat WHERE id = '"..c.insertId.."'")
        TriggerClientEvent('gcPhone:tchat_receive',-1,result[1])
    end)
end

RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel',function(a)
    local b=tonumber(source)TchatGetMessageChannel(a,function(c)
        TriggerClientEvent('gcPhone:tchat_channel',b,a,c)
    end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage',function(a,b)
    TchatAddMessage(a,b)
end)


