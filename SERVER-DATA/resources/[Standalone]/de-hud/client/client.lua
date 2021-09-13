PlayerData = {}
isLoggedIn, inVehicle, driverSeat, Show, phoneOpen = false, false, false, false, false
playerPed, vehicle, vehicleClass, Fuel, vehicleClass = 0, 0, 0, 0, 0

ESX = nil
Citizen.CreateThread(function() 
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
    DisplayRadar(false)
end)

local bigMap = false
local onMap = false
local minimap = nil

Citizen.CreateThread(function()
    while true do
      local playerPed = PlayerPedId()
        inVehicle = false
        if IsPedInAnyVehicle(playerPed, false)  then
            vehicle = GetVehiclePedIsIn(playerPed, false)
            vehicleClass = GetVehicleClass(vehicle)
            inVehicle = not IsVehicleModel(vehicle, 'wheelchair') and vehicleClass ~= 13 and not IsVehicleModel(vehicle, 'windsurf')
            vehicleClass = GetVehicleClass(vehicle)
            driverSeat = GetPedInVehicleSeat(vehicle, -1) == playerPed
            Fuel = GetVehicleFuelLevel(vehicle)
        end
        SendNUIMessage({
            type = 'tick',
            heal = (GetEntityHealth(playerPed)-100),
            zirh = GetPedArmour(playerPed),
            stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            oxy = IsPedSwimmingUnderWater(playerPed) and GetPlayerUnderwaterTimeRemaining(PlayerId()) or 100,
            vehicle = inVehicle,
            phoneOpen = phoneOpen
        })
        Citizen.Wait(200)
    end
end)

local miniMapUi = false
function UIStuff()
    Citizen.CreateThread(function()
        while Show do
            Citizen.Wait(0)

            if inVehicle and not onMap then
                SetPedConfigFlag(playerPed, 35, false)
                onMap = true
                DisplayRadar(true)
                circleMap()
            elseif not inVehicle and onMap then
                onMap = false
                DisplayRadar(false)
                circleMap()
            end

            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()

            if IsPauseMenuActive() then
                if miniMapUi then
                    SendNUIMessage({type = "ui", show = false})
                    miniMapUi = false
                end
            elseif not IsPauseMenuActive() then
                if not miniMapUi then
                    SendNUIMessage({type = "ui", show = true})
                    miniMapUi = true
                end
            end
        end
        onMap = false
    end)
end

RegisterCommand('hud', function()
    TriggerEvent('ryder-hud:open-hud')
end)

RegisterNetEvent("reka:hud:sendStatus") -- reka:hud:sendStatus
AddEventHandler("reka:hud:sendStatus", function(status)
    SendNUIMessage({
        type = "updateStatus",
        data = {
            yemek = status.hunger,
            su = status.thirst,
        },
    })
end)


function circleMap()
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(100)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition("minimap", "L", "B", 0.025, -0.03, 0.153, 0.30)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135, 0.12, 0.093, 0.164)
    SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)
    SetBlipAlpha(GetNorthRadarBlip(), 0)

    minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(100)
    SetRadarBigmapEnabled(false, false)
end

RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(seviye)
    if seviye == 2.0 then
        SendNUIMessage({type = 'voice', lvl = "1"})
    elseif seviye == 7.0 then
        SendNUIMessage({type = 'voice', lvl = "2"})
    elseif seviye == 15.0 then
        SendNUIMessage({type = 'voice', lvl = "3"})
    end
end)

local normalKonusmaAktif = false
RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(status)
    if status and not normalKonusmaAktif then
        normalKonusmaAktif = true
        SendNUIMessage({type = 'speak', active = true})
    elseif not status and normalKonusmaAktif then
        normalKonusmaAktif = false
        SendNUIMessage({type = 'speak', active = false})
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.PlayerData = ESX.GetPlayerData()
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({action = 'showui'})
    UIStuff()
    isLoggedIn = true
    Show = true
    Citizen.Wait(10000)
end)

function firstLogin()
    ESX.PlayerData = ESX.GetPlayerData()
    TriggerEvent("hud:client:SetMoney")
    UIStuff()
    isLoggedIn = true
    Show = true
    TriggerEvent("tgian-hud:load-data")
end

RegisterNetEvent('ryder-hud:ui')
AddEventHandler('ryder-hud:ui', function(open)
    if open then 
        UIStuff()
        Show = true
        SendNUIMessage({action = 'showui'})
    else
        Show = false
        SendNUIMessage({action = 'hideui'})
        Citizen.Wait(500)
        DisplayRadar(false)
    end
end)

RegisterNetEvent('esx:playerUnloaded')
AddEventHandler('esx:playerUnloaded', function()
    SendNUIMessage({action = 'hideui'})
    isLoggedIn = false
    Show = false
end)

RegisterNetEvent('ryder-hud:open-hud')
AddEventHandler('ryder-hud:open-hud', function()
    if not Show then
        ESX.PlayerData = ESX.GetPlayerData()
        TriggerEvent("tgian-hud:load-data")
        SendNUIMessage({action = 'ui'})
        UIStuff()
        isLoggedIn = true
        Show = true
    end
end)
RegisterNetEvent('ryder-hud:open-hud1')
AddEventHandler('ryder-hud:open-hud1', function()
    if not Show then
        ESX.PlayerData = ESX.GetPlayerData()
        TriggerEvent("tgian-hud:load-data")
        SendNUIMessage({action = 'showui'})
        UIStuff()
        isLoggedIn = true
        Show = true
    end
end)

RegisterNUICallback('close-ayar-menu', function()
    SetNuiFocus(false, false)
end)

local disSes = false
Citizen.CreateThread(function()
    RegisterKeyMapping('+raidoSpeaker', 'Telsiz Hoparlör Modu', 'keyboard', 'F5')
end)

RegisterCommand("+raidoSpeaker", function()
    disSes = not disSes
    TriggerServerEvent("ls-radio:set-disses", disSes)
    SendNUIMessage({action = 'disSes', disSes = disSes})
end, false)

RegisterNUICallback('set-emotechat', function(data)
    TriggerEvent("3dme-chat", data.status)
end)

RegisterNetEvent('ryder-hud:parasut')
AddEventHandler('ryder-hud:parasut', function()
	GiveWeaponToPed(playerPed, `gadget_parachute`, 1, false, false)
	SetPedComponentVariation(playerPed, 5, 8, 3, 0)
end)

RegisterNetEvent('phone:open')
AddEventHandler('phone:open', function(bool)
    phoneOpen = bool
    print(phoneOpen)
    if not phoneOpen then Citizen.Wait(500) end
    SendNUIMessage({type = 'phone', phoneOpen = phoneOpen})
end)