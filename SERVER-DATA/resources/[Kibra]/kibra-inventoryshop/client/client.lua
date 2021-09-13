ESX = nil
local PlayerData = {}


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)



RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        if ESX ~= nil and ESX.PlayerData.job ~= nil then
            local playerPed = PlayerPedId()
            local pcoords = GetEntityCoords(playerPed)
            for k, v in pairs(Config.Shops) do
                for z, t in pairs(v.Shop.job) do
                    if t == 'all' or ESX.PlayerData.job.name == t then
                        for val, coords in pairs(v.coords) do
                            local distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, coords.x, coords.y, coords.z, true)
                            if distance < 1 then 
                                sleep = 2
                                DrawMarker(v.Shop.markerType or 1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Shop.markerSize.x or 0.2, v.Shop.markerSize.y or 0.2, v.Shop.markerSize.z or 0.2, v.Shop.markerColour.r or 55, v.Shop.markerColour.g or 255, v.Shop.markerColour.b or 55, 100, false, true, 2, true, false, false, false)
                                if distance < 1 then
                                    if v.Shop.use3dtext then
                                        DrawText3D(coords.x, coords.y, coords.z + 0.2, v.Shop.msg or '[E]')
                                    else
                                        ESX.ShowHelpNotification(v.Shop.msg or '~INPUT_CONTEXT~')
                                    end
                                    if IsControlJustPressed(0, 38) then
                                        OpenMarket(v)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread( function()
    while true do
        local sleep = 2000
        if ESX ~= nil and ESX.PlayerData.job ~= nil then
            local playerPed = PlayerPedId()
            local pcoords = GetEntityCoords(playerPed)
            for k, v in pairs(Config.Stashs) do
                if (v.Stash.job == 'all' or ESX.PlayerData.job.name == v.Stash.job) and v.Stash.useMarker then
                    for val, coords in pairs(v.coords) do
                        local distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, coords.x, coords.y, coords.z, true)
                        if distance < 1 then
                            sleep = 2
                            DrawMarker(v.Stash.markerType or 1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Stash.markerSize.x or 0.2, v.Stash.markerSize.y or 0.2, v.Stash.markerSize.z or 0.2, v.Stash.markerColour.r or 55, v.Stash.markerColour.g or 255, v.Stash.markerColour.b or 55, 100, false, true, 2, true, false, false, false)
                            if distance < 1 then
                                if v.Stash.use3dtext then
                                    DrawText3D(coords.x, coords.y, coords.z + 0.2, v.Stash.msg or '[E]')
                                else
                                    ESX.ShowHelpNotification(v.Stash.msg or '~INPUT_CONTEXT~')
                                end
                                if IsControlJustPressed(0, 38) then
                                    OpenStash(v)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

OpenStash = function(v)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'stashopen', 0.7)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", v.label)
    TriggerEvent("inventory:client:SetCurrentStash", v.label)
end


OpenMarket = function(v)
    local ShopItems = {}
    ShopItems.label = v.label.. " Shop"
    ShopItems.items = v.Shop.items
    ShopItems.slots = #v.Shop.items
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..math.random(11111,99999), ShopItems)
end


Citizen.CreateThread( function()
    while ESX == nil or ESX.PlayerData.job == nil do 
        Citizen.Wait(10)
    end

    for k, v in pairs(Config.Shops) do
        if v.Shop.blip then
            for z, t in pairs(v.Shop.job) do
                if t == 'all' or ESX.PlayerData.job.name == t then
                    for val, coords in pairs(v.coords) do
                        local _blip = AddBlipForCoord(coords.x, coords.y, coords.z)

                        SetBlipSprite(_blip, v.Shop.blip.id or 1)
                        SetBlipDisplay(_blip, 4)
                        SetBlipScale(_blip, v.Shop.blip.scale or 0.5)
                        SetBlipColour(_blip, v.Shop.blip.color or 1)
                        SetBlipAsShortRange(_blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(v.Shop.blip.title or 'nil')
                        EndTextCommandSetBlipName(_blip)
                    end
                end
            end
        end
    end
end)

DrawText3D = function (x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

