
inInventory = false
hotbarOpen = false
inhotbar = false
local inventoryTest = {}
local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil
inventorylocked = false
local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false 
local currentGarbage = nil
local showTrunkPos = false
PlayerData = {}
local anan = 2500 
local progre = true


ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)



local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

RandomStr = function(length)
	if length > 0 then
		return RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

RandomInt = function(length)
	if length > 0 then
		return RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerServerEvent('qb-inventory:server:freezeGarbages')
end)
RegisterNetEvent('qb_inventory:client:freezeGarbage')
AddEventHandler('qb_inventory:client:freezeGarbage', function(entity)
    FreezeEntityPosition(entity, true)
end)

SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

RegisterNetEvent('inventory:client:CheckOpenState')
AddEventHandler('inventory:client:CheckOpenState', function(type, id, label)
    local name = SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent("inventory:setbool")
AddEventHandler("inventory:setbool",function(bool)
    inventorylocked = bool
    print(inventorylocked)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 50.0, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function DrawText3Ds(x, y, z, text)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
  if exports['esx_policejob']:Handcuffed() == true then
      inventorylocked = true
  elseif exports['esx_policejob']:Handcuffed() == false then
    inventorylocked = false
  end
end
end)

Citizen.CreateThread(function()
    while true do
        local uyku = 2
        DisableControlAction(0, 37, true)
        for i = 19, 20 do 
            HideHudComponentThisFrame(i)
        end
        DisableControlAction(0, Keys["1"], true)
        DisableControlAction(0, Keys["2"], true)
        DisableControlAction(0, Keys["3"], true)
        DisableControlAction(0, Keys["4"], true)
        DisableControlAction(0, Keys["5"], true)
        local pCoords = GetEntityCoords(PlayerPedId())

        if IsDisabledControlJustPressed(0, Keys["F2"]) and inventorylocked == false  then

            uyku = 200
           -- TriggerEvent("randPickupAnim")
                    local pCoords = GetEntityCoords(PlayerPedId())
                    local entitys, entityDsts = ESX.Game.GetClosestObject(Config.GarbageProps)
                    local x, y, z = table.unpack(GetEntityCoords(entitys))
                    local _, floorZ = GetGroundZFor_3dCoord(x, y, z)
                    local name = 'Çöp Konteyneri-'..getOwnerFromCoordsForGarbage(vector3(x, y, floorZ))
                    local name2 = getOwnerFromCoordsForGarbage(vector3(x, y, floorZ))
                    if DoesEntityExist(entitys) and entityDsts <= 2 then
                        currentGarbage = name2
                    else
                        currentGarbage = nil
                    end
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                        curVeh = vehicle
                        CurrentVehicle = nil
                    else
                        local vehicle = ESX.Game.GetClosestVehicle()
                        if vehicle ~= 0 and vehicle ~= nil then
                            local pos = GetEntityCoords(PlayerPedId())
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            end
                            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 2.0) and not IsPedInAnyVehicle(PlayerPedId()) then
                                if GetVehicleDoorLockStatus(vehicle) < 2 then
                                    CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                    curVeh = vehicle
                                    CurrentGlovebox = nil
                                else
                                    ESX.Notify("error","Araç Kilitli")

                                    
                                end
                            else
                                CurrentVehicle = nil
                            end
                        else
                            CurrentVehicle = nil
                        end
                    end

                    if CurrentVehicle ~= nil then
                        local maxweight = 0
                        local slots = 0
                        if GetVehicleClass(curVeh) == 0 then
                            maxweight = 35
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 1 then
                            maxweight = 45
                            slots = 20
                        elseif GetVehicleClass(curVeh) == 2 then
                            maxweight = 55
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 3 then
                            maxweight = 15
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 4 then
                            maxweight = 25
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 5 then
                            maxweight = 15
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 6 then
                            maxweight = 15
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 7 then
                            maxweight = 20
                            slots = 15
                        elseif GetVehicleClass(curVeh) == 8 then
                            maxweight = 25
                            slots = 8
                        elseif GetVehicleClass(curVeh) == 9 then
                            maxweight = 60
                            slots = 30
                        elseif GetVehicleClass(curVeh) == 12 then
                            maxweight = 120
                            slots = 50
                        else
                            maxweight = 30
                            slots = 10
                        end

                        local other = {
                            maxweight = maxweight,
                            slots = slots,
                        }
                        TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                        OpenTrunk()
                        ExecuteCommand("me Kişi Bagajı Açar.")
                    elseif currentGarbage ~= nil then
                        ESX.TriggerServerCallback('garbage:ac',function(items)
                            local ShopItems = {}
                            ShopItems.label = 'Çöp Konteyneri'..currentGarbage
                            ShopItems.items = items
                            ShopItems.slots = 15
                            TriggerServerEvent("inventory:server:OpenInventory", "garbage", currentGarbage, ShopItems)
                            ExecuteCommand("me Kişi Cöpleri Karıştırır.")
                        end,currentGarbage)
                    elseif CurrentGlovebox ~= nil then
                        TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                        ExecuteCommand("me Kişi Torpidoyu Açar.")
                    elseif CurrentDrop ~= 0 then
                        TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
                    else
                        TriggerServerEvent("inventory:server:OpenInventory")
                    end
        end

        if IsDisabledControlJustPressed(0, 37) and inventorylocked == false then
            if not inhotbar then
                ToggleHotbar(true)
                inhotbar = true
            else
                inhotbar = false
                ToggleHotbar(false)
            end
        end

        if IsDisabledControlJustReleased(0, Keys["1"]) and inventorylocked == false then
            --QBCore.Functions.GetPlayerData(function(PlayerData)
              --  if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 1)
              --  end
            --end)
        end

        if IsDisabledControlJustReleased(0, Keys["2"]) and inventorylocked == false then
            --QBCore.Functions.GetPlayerData(function(PlayerData)
              --  if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 2)
               -- end
            --end)
        end

        if IsDisabledControlJustReleased(0, Keys["3"]) and inventorylocked == false then
           -- QBCore.Functions.GetPlayerData(function(PlayerData)
             --   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 3)
               -- end
            --end)
        end

        if IsDisabledControlJustReleased(0, Keys["4"]) and inventorylocked == false then
           -- QBCore.Functions.GetPlayerData(function(PlayerData)
             --   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 4)
               -- end
            --end)
        end

        if IsDisabledControlJustReleased(0, Keys["5"]) and inventorylocked == false then
           -- QBCore.Functions.GetPlayerData(function(PlayerData)
             --   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 5)
               -- end
            --end)
        end
        -- if IsDisabledControlJustReleased(0, Keys["6"]) and inventorylocked == false then
        --    -- QBCore.Functions.GetPlayerData(function(PlayerData)
        --      --   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
        --             TriggerServerEvent("inventory:server:UseItemSlot", 41)
        --        -- end
        --     --end)
        -- end
        Citizen.Wait(uyku)
    end
end)




RegisterNetEvent('inventory:client:ItemBox')
AddEventHandler('inventory:client:ItemBox', function(itemData, type,count)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type,
        count = count
    })
end)

RegisterNetEvent('inventory:client:requiredItems')
AddEventHandler('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = items[k].label,
                image = items[k].image,
            })
        end
    end
    
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)




Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if distance <= 7.5 then
                        sleep = 2
                        CurrentDrop = 0
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                        if distance <= 1.0 then
                            CurrentDrop = k
                        end
                    end                  
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    --TriggerServerEvent("inventory:server:LoadDrops")
end)

RegisterNetEvent('inventory:server:RobPlayer')
AddEventHandler('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    if data.type == 'error' then
        type = 2
    else
        type = 1
    end
    ESX.Bildirim("error",data.message)


end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(PlayerAmmo, inventory, other)
   -- if not exports['mythic_progbar']:onScreen() then
        if not IsEntityDead(PlayerPedId()) then
            ToggleHotbar(false)
            SetNuiFocus(true, true)
            if other ~= nil then
                currentOtherInventory = other.name
            end
            SendNUIMessage({
                action = "open",
                inventory = inventory,
                slots = MaxInventorySlots,
                other = other,
                maxweight = ESX.GetPlayerData().maxWeight,
                Ammo = PlayerAmmo,
                maxammo = Config.MaximumAmmoValues,
            })
            inInventory = true
        end
  --  end
end)



RegisterNetEvent("inventory:client:ShowTrunkPos")
AddEventHandler("inventory:client:ShowTrunkPos", function()
    showTrunkPos = true
end)

RegisterNetEvent("inventory:client:UpdatePlayerInventory")
AddEventHandler("inventory:client:UpdatePlayerInventory", function(isError)
    SendNUIMessage({
        action = "update",
        inventory = ESX.GetPlayerData().inventory,
        maxweight = ESX.GetConfig().MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent("inventory:client:CraftItems")
AddEventHandler("inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        --TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
        isCrafting = false
end)

RegisterNetEvent('inventory:client:CraftAttachment')
AddEventHandler('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        --TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
        isCrafting = false
end)

-- RegisterNetEvent("inventory:client:PickupSnowballs")
-- AddEventHandler("inventory:client:PickupSnowballs", function()
--     LoadAnimDict('anim@mp_snowball')
--     TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
--     QBCore.Functions.Progressbar("pickupsnowball", "Kartopu aliniyor..", 1500, false, true, {
--         disableMovement = true,
--         disableCarMovement = true,
--         disableMouse = false,
--         disableCombat = true,
--     }, {}, {}, {}, function() -- Done
--         ClearPedTasks(PlayerPedId())
--         TriggerServerEvent('QBCore:Server:AddItem', "snowball", 1)
--         TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["snowball"], "add")
--     end, function() -- Cancel
--         ClearPedTasks(PlayerPedId())
--         QBCore.Functions.Notify("Iptal edildi..", "error")
--     end)
-- end)

-- RegisterNetEvent("inventory:client:UseSnowball")
-- AddEventHandler("inventory:client:UseSnowball", function(amount)
--     GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_snowball"), amount, false, false)
--     SetPedAmmo(PlayerPedId(), GetHashKey("weapon_snowball"), amount)
--     SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_snowball"), true)
-- end)

RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponData, shootbool)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        ESX.Bildirim("inform","Silahi Beline Koydun ; "..weaponData.label)


        currentWeapon = nil
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        ESX.TriggerServerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "WEAPON_PETROLCAN" or weaponName == "WEAPON_FIREEXTINGUISHER" then --fireextinguisher
                ammo = 4000 
            end
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
            ESX.Bildirim("inform","Silahi Eline Aldın ; "..weaponData.label)

            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

WeaponAttachments = {
    ["WEAPON_PISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP_02",
            label = "Susturucu",
            item = "pistol_suppressor",
        }, 
        ["extended"] = {
            component = "COMPONENT_PISTOL_CLIP_02",
            label = "Uzatılmış Şarjör",
            item = "pistol_extended",
        },                                                      
    },
    ["WEAPON_HEAVYPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Susturucu",
            item = "pistol_suppressor",
        },     
        ["extended"] = {
            component = "COMPONENT_HEAVYPISTOL_CLIP_02",
            label = "Susturucu",
            item = "pistol_extended",
        },                                                   
    },
    ["WEAPON_SNSPISTOL"] = {
        ["extended"] = {
            component = "COMPONENT_SNSPISTOL_CLIP_02",
            label = "Susturucu",
            item = "pistol_extended",
        },                                                       
    },
    ["WEAPON_APPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Susturucu",
            item = "pistol_suppressor",
        }, 
        ["extended"] = {
            component = "COMPONENT_APPISTOL_CLIP_02",
            label = "Uzatılmış Şarjör",
            item = "pistol_extended",
        }, 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "pistol_flashlight",
        },                                                      
    },
    ["WEAPON_MACHINEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Susturucu",
            item = "pistol_suppressor",
        }, 
        ["extended"] = {
            component = "COMPONENT_MACHINEPISTOL_CLIP_02",
            label = "Uzatılmış Şarjör",
            item = "pistol_extended",
        },                                                      
    },
    ["WEAPON_COMBATPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Susturucu",
            item = "pistol_suppressor",
        }, 
        ["extended"] = {
            component = "COMPONENT_COMBATPISTOL_CLIP_02",
            label = "Uzatılmış Şarjör",
            item = "pistol_extended",
        }, 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "pistol_flashlight",
        },                                                      
    },
    ["WEAPON_MICROSMG"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Susturucu",
            item = "smg_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_MICROSMG_CLIP_02",
            label = "Uzatılmış Şarjor",
            item = "smg_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "smg_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Uzatılmış Şarjör",
            item = "smg_scope",
        },
    },
    ["WEAPON_MINISMG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_MINISMG_CLIP_02",
            label = "Uzatılmış Şarjör",
            item = "smg_extendedclip",
        },
    },
}

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data2 = {
        WeaponData = Config.Weapons[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data2)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = Config.Weapons[data.WeaponData.name]
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    
    ESX.TriggerServerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNetEvent("inventory:client:CheckWeapon")
AddEventHandler("inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("inventory:client:RemoveDropItem")
AddEventHandler("inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("inventory:client:DropItemAnim")
AddEventHandler("inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end)

------------------------------------ infinity

 RegisterNetEvent("inventory:client:ShowId")
 AddEventHandler("inventory:client:ShowId", function(sourceId, character)
     local player = GetPlayerFromServerId(sourceId)
     if player ~= -1 then
         local gender = "Erkek"
         TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><strong>Ad:</strong> {1} <br><strong>Soyad:</strong> {2} <br><strong>Dogum T.:</strong> {3} <br><strong>Cinsiyet:</strong> {4} <br></div></div>',
            args = {'Kimlik Kartı', character.firstname, character.lastname, character.birthdate, gender}
         })
         --TriggerEvent("notification",character)
     end
 end)

 RegisterNetEvent("inventory:client:ShowDriverLicense")
 AddEventHandler("inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
     local player = GetPlayerFromServerId(sourceId)
     if player ~= -1 then
         TriggerEvent('chat:addMessage', {
             template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Ad:</strong> {1} <br><strong>Soyad:</strong> {2} <br><strong>Dogum T.:</strong> {3} <br><strong>Surucu lisansı:</strong> {4}</div></div>',
             args = {'Ehliyet', character.firstname, character.lastname, character.birthdate, character.type}
         })
     end
 end)

------------------------------------------------------------------

RegisterNetEvent("inventory:client:ShowId")
AddEventHandler("inventory:client:ShowId", function(sourceId, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Erkek"
        TriggerEvent('chat:addMessage', {
           template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><strong>Ad:</strong> {1} <br><strong>Soyad:</strong> {2} <br><strong>Dogum T.:</strong> {3} <br><strong>Cinsiyet:</strong> {4} <br></div></div>',
           args = {'Kimlik Kartı', character.firstname, character.lastname, character.birthdate, gender}
        })
        --TriggerEvent("notification",character)
    end
end)

RegisterNetEvent("inventory:client:ShowDriverLicense")
AddEventHandler("inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Ad:</strong> {1} <br><strong>Soyad:</strong> {2} <br><strong>Dogum T.:</strong> {3} <br><strong>Surucu lisansı:</strong> {4}</div></div>',
            args = {'Ehliyet', character.firstname, character.lastname, character.birthdate, character.type}
        })
    end
end)

RegisterNetEvent("inventory:client:SetCurrentStash")
AddEventHandler("inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(ESX.Items[tostring(data.item)])
end)


RegisterCommand('f2fix',function()
    CurrentDrop = 0
    CurrentVehicle = nil
    CurrentGlovebox = nil
    CurrentStash = nil
    SetNuiFocus(false, false)
    inInventory = false
    ClearPedTasks(PlayerPedId())
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    inInventory = false
end)
RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNetEvent("inventory:server:yakin_oyuncular")
AddEventHandler("inventory:server:yakin_oyuncular", function(inventory, item)
 
  
        if not IsEntityDead(PlayerPedId()) then
            --ToggleHotbar(false)
            --SetNuiFocus(true, true)

       
local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestPlayerDistance > 1.0 then
    ESX.Bildirim("error",'Yakında oyuncu yok!')
else
     
     ExecuteCommand("me Kişiye "..item.count.." adet "..item.label.." uzatır.")
     TriggerServerEvent("inventory:server:VerItem", inventory, item, GetPlayerServerId(closestPlayer))
end
                   
 
 end
end) 

RegisterNUICallback("GiveItem", function(data, cb)
    TriggerServerEvent("inventory:server:GiveItem", data.inventory, data.item)
end) 

RegisterNUICallback("combineItem", function(data)
    Citizen.Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    TriggerEvent('inventory:client:ItemBox', ESX.Items[tostring(data.reward)], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
        StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
        TriggerEvent('inventory:client:ItemBox', ESX.Items[tostring(combineData.reward)], 'add')
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

function OpenTrunk()
    local vehicle = ESX.Game.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = ESX.Game.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = ESX.GetPlayerData().inventory[1],
        [2] = ESX.GetPlayerData().inventory[2],
        [3] = ESX.GetPlayerData().inventory[3],
        [4] = ESX.GetPlayerData().inventory[4],
        [5] = ESX.GetPlayerData().inventory[5],
        [41] = ESX.GetPlayerData().inventory[41],
    } 

    
    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
        TriggerServerEvent("bank:cashbal")
        TriggerServerEvent("bank:bankbal")
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent("inventory:client:useitemkkkkk")
AddEventHandler("inventory:client:useitemkkkkk",function(item)
    --print(item.name)
    TriggerServerEvent("esx:useItem", item)
  --  ESX.Bildirim("inform","Item Kullandın: ; "..item.label)


end)



RegisterCommand("olusoy", function(source)
    GetPlayerFromServerId(player)
    TriggerServerEvent("police:client:RobDeadPlayer")
end)

RegisterNetEvent('police:client:RobPlayer')
AddEventHandler('police:client:RobPlayer', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    targetplayer = GetPlayerFromServerId(player)
   -- local dead = exports["esx_ambulancejob"]:GetDeath()
    if not dead then
        if player ~= -1 and distance < 2.5 then
            local playerPed = GetPlayerPed(player)
            local playerId = GetPlayerServerId(player)
            if IsEntityPlayingAnim(GetPlayerPed(player), 'random@mugging3', 'handsup_standing_base', 3) then
                    local plyCoords = GetEntityCoords(playerPed)
                    local pos = GetEntityCoords(PlayerPedId())
                    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                    if dist < 2.5 then
                        loadAnimDict('random@shop_robbery')
                        TaskPlayAnim(PlayerPedId(),'random@shop_robbery', 'robbery_action_b',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                        local cancelled = exports['aex-bar']:taskBar(2500,'Cepler aranıyor')
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        --if cancelled == 100 then
                            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                            TriggerEvent("inventory:server:RobPlayer", playerId)
                            TriggerServerEvent("police:server:SearchPlayer", playerId)
                        --end
                    else
                        exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')

                    end
                    --StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
            else
                exports['okokNotify']:Alert("Envanter", "Kişi ellerini kaldırmamış", 2500, 'error')
            end
        else
            exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
        end
    end
end)


RegisterNetEvent('police:client:RobPlayerr')
AddEventHandler('police:client:RobPlayerr', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    targetplayer = GetPlayerFromServerId(player)
   -- local dead = exports["esx_ambulancejob"]:GetDeath()
    if not dead then
        if player ~= -1 and distance < 2.5 then
            local playerPed = GetPlayerPed(player)
            local playerId = GetPlayerServerId(player)
                    local plyCoords = GetEntityCoords(playerPed)
                    local pos = GetEntityCoords(PlayerPedId())
                    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                    if dist < 2.5 then
                        loadAnimDict('random@shop_robbery')
                        TaskPlayAnim(PlayerPedId(),'random@shop_robbery', 'robbery_action_b',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                        local cancelled = exports['aex-bar']:taskBar(2500,'Kişiyi arıyorsun...')
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        --if cancelled == 100 then
                            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                            TriggerEvent("inventory:server:RobPlayer", playerId)
                            TriggerServerEvent("police:server:SearchPlayer", playerId)
                        --end
                    else
                        exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')

                    end
                    --StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
        else
            exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
        end
    end
end)

RegisterNetEvent('police:client:RobDeadPlayer')
AddEventHandler('police:client:RobDeadPlayer', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    targetplayer = GetPlayerFromServerId(player)
   -- local dead = exports["esx_ambulancejob"]:GetDeath()
    if dead then
        if player ~= -1 and distance < 2.5 then
            local playerPed = GetPlayerPed(player)
            local playerId = GetPlayerServerId(player)
            if IsEntityPlayingAnim(GetPlayerPed(player), 'random@mugging3', 'misslamar1dead_body', 3) then
                    local plyCoords = GetEntityCoords(playerPed)
                    local pos = GetEntityCoords(PlayerPedId())
                    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                    if dist < 2.5 then
                        loadAnimDict('random@shop_robbery')
                        TaskPlayAnim(PlayerPedId(),'random@shop_robbery', 'robbery_action_b',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                        local cancelled = exports['aex-bar']:taskBar(2500,'Cepler aranıyor')
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        --if cancelled == 100 then
                            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                            TriggerEvent("inventory:server:RobPlayer", playerId)
                            TriggerServerEvent("police:server:SearchPlayer", playerId)
                        --end
                    else
                        exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
                    end
                    --StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
            else
                exports['okokNotify']:Alert("Envanter", "Kişi ölü değil", 2500, 'error')
            end
        else
            exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
        end
    end
end)

RegisterNetEvent('inventory:client:paraçal')
AddEventHandler('inventory:client:paraçal', function(amount)
    local player, distance = ESX.Game.GetClosestPlayer()
    targetplayer = GetPlayerFromServerId(player)
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(GetPlayerPed(player), 'random@mugging3', 'handsup_standing_base', 3) then
                local plyCoords = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                if dist < 2.5 then
                    loadAnimDict('random@shop_robbery')
                    TaskPlayAnim(PlayerPedId(),'random@shop_robbery', 'robbery_action_b',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                    local cancelled = exports['aex-bar']:taskBar(2500,'Cepler aranıyor')
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
					local cancelled = 100
                    if cancelled == 100 then
                        TriggerServerEvent("inventory:server:paraçal", playerId, amount)
                    end
                else
                    exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
                end
                --StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
        else
            exports['okokNotify']:Alert("Envanter", "Kişi ellerini kaldırmamış!", 2500, 'error')
        end
    else
        exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)



RegisterCommand("paracal",function(source,args,raw)
	local amount = tonumber(args[1])
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local dead = exports["esx_ambulancejob"]:GetDeath()
    if not dead then
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			TriggerServerEvent('inventory:paraçal',GetPlayerServerId(closestPlayer),amount)
		else
            exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
        end
    end
end)

RegisterCommand("nakitver",function(source,args,raw)
	local amount = tonumber(args[1])
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local dead = exports["esx_ambulancejob"]:GetDeath()
    if not dead then
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			TriggerServerEvent('inventory:paraver',GetPlayerServerId(closestPlayer),amount)
		else
            exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
        end
    end
end)



RegisterCommand("oluara",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    targetplayer = GetPlayerFromServerId(player)
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local health = GetEntityHealth(playerPed)
         

        --local dead = exports["esx_ambulancejob"]:GetDeath()
        if not dead then
                local plyCoords = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                if dist < 2.5 then
                
                if health <= 5 then
                    playerId = GetPlayerServerId(player)
                    loadAnimDict('random@shop_robbery')
                    TaskPlayAnim(PlayerPedId(),'random@shop_robbery', 'robbery_action_b',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                   exports['aex-bar']:taskBar(2500,'Üst aranıyor')
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                    TriggerEvent("inventory:server:RobPlayer", playerId)
                    TriggerServerEvent("police:server:SearchPlayer", playerId)
                else
                    exports['okokNotify']:Alert("Envanter", "Kişi ölü veya yaralı değil", 2500, 'error')
                end
                
            else
                exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
            end
        end
    else
        exports['okokNotify']:Alert("Envanter", "Yakında kimse yok!", 2500, 'error')
    end
end)

function getOwnerFromCoordsForGarbage(coords)
    local x, y, z = table.unpack(coords)
    x = math.floor(math.round(x, 0))
    y = math.floor(math.round(y, 0))
    return 'x' .. x .. 'y' .. y
end


function math.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(data)
    PlayerData.job = data
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k,v in pairs(Config.Jobs) do
            if PlayerData.job ~= nil then
                if PlayerData.job.name == k then
                    wait = 500
                    local distance = #(coords - vector3(v.Stash.coords.x, v.Stash.coords.y, v.Stash.coords.z))
                    if distance <= 3.0 then
                        wait = 0
                        text = v.Stash.text
                        if distance <= 1.5 then
                            text = "E - " ..text
                            if IsControlJustPressed(0, 46) then
                                -- stash açma kodu
                                OpenStash(v)
                            end
                        end
                        DrawText3Ds(v.Stash.coords.x, v.Stash.coords.y, v.Stash.coords.z, text)
                    end
                    local distance = #(coords - vector3(v.Shop.coords.x, v.Shop.coords.y, v.Shop.coords.z))
                    if distance <= 3.0 then
                        wait = 0
                        text = v.Shop.text
                        if distance <= 1.5 then
                            text = "E - " ..text
                            if IsControlJustPressed(0, 46) then
                                -- stash açma kodu
                                OpenMarket(v)
                            end
                        end
                        DrawText3Ds(v.Shop.coords.x, v.Shop.coords.y, v.Shop.coords.z, text)
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

OpenMarket = function(v)
    local ShopItems = {}
    ShopItems.label = v.label.. " Shop"
    ShopItems.items = v.Shop.Items
    ShopItems.slots = #v.Shop.Items
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..math.random(11111,99999), ShopItems)
end

OpenStash = function(v)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'stashopen', 0.7)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", v.label.."Deposu")
    TriggerEvent("inventory:client:SetCurrentStash", v.label.."Deposu")
end





