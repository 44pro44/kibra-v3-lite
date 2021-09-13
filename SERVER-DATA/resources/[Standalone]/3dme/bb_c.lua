ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local pedDisplaying = {}
local displayTime = 5000
local strin = ""
local chatEmote = false

Citizen.CreateThread(function()
	while true do
		local currentTime, html = GetGameTimer(), ""
        for k, v in pairs(pedDisplaying) do
            if k ~= "npc" then
                local player = GetPlayerFromServerId(tonumber(k))
                if player ~= -1 then
                    local sourcePed, targetPed = GetPlayerPed(player), PlayerPedId()
                    local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)
                    local pedCoords = GetPedBoneCoords(sourcePed, 0x2e28, 0.0, 0.0, 0.0)
        
                    if #(sourceCoords - targetCoords) < 15 then
                        if chatEmote then
                            if not v.chat then
                                v.chat = true
                                TriggerEvent('chatMessage', string.upper(v.type), v.type, v.msg)
                            end
                        end

                        local onScreen, xxx, yyy = GetHudScreenPositionFromWorldPosition(pedCoords.x, pedCoords.y, pedCoords.z + 0.35)
                        if v.type == "me" then
                            if not onScreen then
                            html = html .. '<p class="me" style="left: '.. xxx * 100 ..'%;top: '.. yyy * 100 ..'%;"><b">⠀'..v.msg..'⠀</b></p>'
                            end
                        elseif v.type == "do" then
                            if not onScreen then
                                html = html .. '<p class="do" style="left: '.. xxx * 100 ..'%;top: '.. yyy * 100 ..'%;"><b">⠀'..v.msg..'⠀</b></p>'
                            end
                        end
                    end
                end
            else
                local sourceCoords = GetEntityCoords(PlayerPedId())
                if #(sourceCoords - vector3(v.coords.x, v.coords.y, v.coords.z)) < 15 then
                    if chatEmote then
                        if not v.chat then
                            v.chat = true
                            TriggerEvent('chatMessage', string.upper(v.type), v.type, v.msg)
                        end
                    end

                    local onScreen, xxx, yyy = GetHudScreenPositionFromWorldPosition(v.coords.x, v.coords.y, v.coords.z + 0.35)
                    if v.type == "me" then
                        if not onScreen then
                            html = html .. '<p class="me" style="left: '.. xxx * 100 ..'%;top: '.. yyy * 100 ..'%;"><b">⠀'..v.msg..'⠀</b></p>'
                        end
                    elseif v.type == "do" then
                        if not onScreen then
                            html = html .. '<p class="do" style="left: '.. xxx * 100 ..'%;top: '.. yyy * 100 ..'%;"><b">⠀'..v.msg..'⠀</b></p>'
                        end
                    end
                end
            end
        	if v.time <= currentTime then pedDisplaying[k] = nil end
        end

        if strin ~= html then
            SendNUIMessage({
                type = "txt", 
                html = html
            })
            strin = html
        end
        
		Wait(0)
    end
end)

RegisterNetEvent("bb-3dme:client:triggerDisplay")
AddEventHandler("bb-3dme:client:triggerDisplay", function(playerId, message, typ)
    pedDisplaying[tostring(playerId)] = {type = typ, msg = message, time = GetGameTimer() + displayTime, chat = false}
end)

RegisterNetEvent("bb-3dme:client:triggerZar")
AddEventHandler("bb-3dme:client:triggerZar", function(playerId, message, typ)
    pedDisplaying[tostring(playerId)] = {type = typ, msg = message, time = GetGameTimer() + displayTime, chat = false}
end)

RegisterNetEvent("3dme:client:tgiann-doctor")
AddEventHandler("3dme:client:tgiann-doctor", function(text, coords)
    pedDisplaying["npc"] = {coords = coords, type = "me", msg = text, time = GetGameTimer() + 15000, chat = false}
end)

RegisterNetEvent('3dme-chat')
AddEventHandler('3dme-chat', function(bool)
    chatEmote = bool
end)

RegisterNetEvent('3dme:xp')
AddEventHandler('3dme:xp', function()
   -- exports["tgiann-levelsistemi"]:expVer("me-do", QBCore.Key)
end)