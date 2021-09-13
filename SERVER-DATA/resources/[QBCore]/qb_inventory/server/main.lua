ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

Drops = {}
Trunks = {}
Gloveboxes = {}

Stashes = {}
ShopItems = {}
local ownedcars = {}
local Garbages = {}

ESX.RegisterServerCallback(
    "GetCharacterNameServer",
    function(source, cb, target) -- added by morph3
        local xTarget = GetPlayerFromServerId(target)

        local result =
            exports.ghmattimysql:executeSync(
            "SELECT firstname, lastname FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = xTarget.identifier
            }
        )

        local firstname = result[1].firstname
        local lastname = result[1].lastname

        cb("" .. firstname .. " " .. lastname .. "")
    end
)

RegisterServerEvent("inventory:server:LoadDrops")
AddEventHandler(
    "inventory:server:LoadDrops",
    function()
        local src = source
        if next(Drops) ~= nil then
            TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source)
            TriggerClientEvent("inventory:client:AddDropItem", src, Drops)
        end
    end
)

RegisterServerEvent("inventory:server:addTrunkItems")
AddEventHandler(
    "inventory:server:addTrunkItems",
    function(plate, items)
        Trunks[plate] = {}
        Trunks[plate].items = items
    end
)
RegisterServerEvent("qb_inventory:server:freezeGarbages")
AddEventHandler(
    "qb_inventory:server:freezeGarbages",
    function()
        for i = 1, #Config.GarbageProps, 1 do
            if Config.GarbageProps[i] ~= nil then
                TriggerClientEvent("qb_inventory:client:freezeGarbage", source, Config.GarbageProps[i])
            end
        end
    end
)

RegisterServerEvent("inventory:server:combineItem")
AddEventHandler(
    "inventory:server:combineItem",
    function(item, fromItem, toItem)
        local src = source
        local ply = ESX.GetPlayerFromId(src)

        ply.addInventoryItem(item, 1)
        ply.removeInventoryItem(fromItem, 1)
        ply.removeInventoryItem(toItem, 1)
    end
)

RegisterServerEvent("inventory:server:CraftItems")
AddEventHandler(
    "inventory:server:CraftItems",
    function(itemName, itemCosts, count, toSlot, points)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local count = tonumber(count)
        if itemName ~= nil and itemCosts ~= nil then
            for k, v in pairs(itemCosts) do
                Player.removeInventoryItem(k, (v * count))
            end
            Player.addInventoryItem(itemName, count, toSlot)
            --Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+(points*count))
            TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
        end
    end
)

RegisterServerEvent("inventory:server:CraftAttachment")
AddEventHandler(
    "inventory:server:CraftAttachment",
    function(itemName, itemCosts, count, toSlot, points)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local count = tonumber(count)
        if itemName ~= nil and itemCosts ~= nil then
            for k, v in pairs(itemCosts) do
                Player.removeInventoryItem(k, (v * count))
            end
            Player.addInventoryItem(itemName, count, toSlot)
            --Player.Functions.SetMetaData("attachmentcraftingrep", Player.PlayerData.metadata["attachmentcraftingrep"]+(points*count))
            TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
        end
    end
)

RegisterServerEvent("inventory:server:GiveItem")
AddEventHandler(
    "inventory:server:GiveItem",
    function(inventory, item)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local kullanilabiliritem = Player.GetItemByName(item.name)
        if inventory == "player" or inventory == "hotbar" then
            if kullanilabiliritem ~= nil then
                if item.count then
                    TriggerClientEvent("inventory:server:yakin_oyuncular", src, inventory, item)
                end
            end
        end
    end
)

RegisterServerEvent("inventory:server:VerItem")
AddEventHandler(
    "inventory:server:VerItem",
    function(inventory, item, player)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local zPlayer = ESX.GetPlayerFromId(player)

        if item.count then
            local agirlik = 0
            local itemagirlik = (item.weight * item.count)
            for _, v in pairs(zPlayer.inventory) do
                agirlik = agirlik + (v.weight * v.count)
            end

            itemagirlik = itemagirlik + agirlik

            if itemagirlik < ESX.GetConfig().MaxWeight then
                xPlayer.removeInventoryItem(item.name, item.count, item.slot)
                TriggerClientEvent("inventory:client:CheckWeapon", src, item.name)
                if item.info then
                    zPlayer.addInventoryItem(item.name, item.count, false, item.info)
                else
                    zPlayer.addInventoryItem(item.name, item.count)
                end
            end
        end
    end
)

RegisterServerEvent("inventory:server:SetIsOpenState")
AddEventHandler(
    "inventory:server:SetIsOpenState",
    function(IsOpen, type, id)
        if not IsOpen then
            if type == "stash" then
                Stashes[id].isOpen = false
            elseif type == "trunk" then
                Trunks[id].isOpen = false
            elseif type == "glovebox" then
                Gloveboxes[id].isOpen = false
            end
        end
    end
)

RegisterServerEvent("inventory:server:OpenInventory")
AddEventHandler(
    "inventory:server:OpenInventory",
    function(name, id, other)
        local src = source
        local ply = Player(src)
        local Player = ESX.GetPlayerFromId(src)
        if name ~= nil and id ~= nil then
            local secondInv = {}
            if name == "stash" then
                if Stashes[id] ~= nil then
                    if Stashes[id].isOpen then
                        local Target = ESX.GetPlayerFromId(Stashes[id].isOpen)
                        if Target ~= nil then
                            TriggerClientEvent(
                                "inventory:client:CheckOpenState",
                                Stashes[id].isOpen,
                                name,
                                id,
                                Stashes[id].label
                            )
                        else
                            Stashes[id].isOpen = false
                        end
                    end
                end
                local maxweight = 1000000
                local slots = 50
                if other ~= nil then
                    maxweight = other.maxweight ~= nil and other.maxweight or 1000000
                    slots = other.slots ~= nil and other.slots or 50
                end
                secondInv.name = "stash-" .. id
                secondInv.label = "Stash-" .. id
                secondInv.maxweight = maxweight
                secondInv.inventory = {}
                secondInv.slots = slots
                if Stashes[id] ~= nil and Stashes[id].isOpen then
                    secondInv.name = "none-inv"
                    secondInv.label = "Stash-None"
                    secondInv.maxweight = 1000000
                    secondInv.inventory = {}
                    secondInv.slots = 0
                else
                    local stashItems = GetStashItems(id)
                    if next(stashItems) ~= nil then
                        secondInv.inventory = stashItems
                        Stashes[id] = {}
                        Stashes[id].items = stashItems
                        Stashes[id].isOpen = src
                        Stashes[id].label = secondInv.label
                    else
                        Stashes[id] = {}
                        Stashes[id].items = {}
                        Stashes[id].isOpen = src
                        Stashes[id].label = secondInv.label
                    end
                end
            elseif name == "trunk" then
                if Trunks[id] ~= nil then
                    if Trunks[id].isOpen then
                        local Target = ESX.GetPlayerFromId(Trunks[id].isOpen)
                        if Target ~= nil then
                            TriggerClientEvent(
                                "inventory:client:CheckOpenState",
                                Trunks[id].isOpen,
                                name,
                                id,
                                Trunks[id].label
                            )
                        else
                            Trunks[id].isOpen = false
                        end
                    end
                end
                secondInv.name = "trunk-" .. id
                secondInv.label = "Trunk-" .. id
                secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
                secondInv.inventory = {}
                secondInv.slots = other.slots ~= nil and other.slots or 50
                if
                    (Trunks[id] ~= nil and Trunks[id].isOpen) or
                        (SplitStr(id, "PLZI")[2] ~= nil and Player.job.name ~= "police")
                 then
                    secondInv.name = "none-inv"
                    secondInv.label = "Trunk-None"
                    secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
                    secondInv.inventory = {}
                    secondInv.slots = 0
                else
                    if id ~= nil then
                        local ownedItems = GetOwnedVehicleItems(id)
                        if IsVehicleOwned(id) and next(ownedItems) ~= nil then
                            secondInv.inventory = ownedItems
                            Trunks[id] = {}
                            Trunks[id].items = ownedItems
                            Trunks[id].isOpen = src
                            Trunks[id].label = secondInv.label
                        elseif Trunks[id] ~= nil and not Trunks[id].isOpen then
                            secondInv.inventory = Trunks[id].items
                            Trunks[id].isOpen = src
                            Trunks[id].label = secondInv.label
                        else
                            Trunks[id] = {}
                            Trunks[id].items = {}
                            Trunks[id].isOpen = src
                            Trunks[id].label = secondInv.label
                        end
                    end
                end
            elseif name == "glovebox" then
                if Gloveboxes[id] ~= nil then
                    if Gloveboxes[id].isOpen then
                        local Target = ESX.GetPlayerFromId(Gloveboxes[id].isOpen)
                        if Target ~= nil then
                            TriggerClientEvent(
                                "inventory:client:CheckOpenState",
                                Gloveboxes[id].isOpen,
                                name,
                                id,
                                Gloveboxes[id].label
                            )
                        else
                            Gloveboxes[id].isOpen = false
                        end
                    end
                end
                secondInv.name = "glovebox-" .. id
                secondInv.label = "Glovebox-" .. id
                secondInv.maxweight = 10000
                secondInv.inventory = {}
                secondInv.slots = 5
                if Gloveboxes[id] ~= nil and Gloveboxes[id].isOpen then
                    secondInv.name = "none-inv"
                    secondInv.label = "Glovebox-None"
                    secondInv.maxweight = 10000
                    secondInv.inventory = {}
                    secondInv.slots = 0
                else
                    local ownedItems = GetOwnedVehicleGloveboxItems(id)
                    if Gloveboxes[id] ~= nil and not Gloveboxes[id].isOpen then
                        secondInv.inventory = Gloveboxes[id].items
                        Gloveboxes[id].isOpen = src
                        Gloveboxes[id].label = secondInv.label
                    elseif IsVehicleOwned(id) and next(ownedItems) ~= nil then
                        secondInv.inventory = ownedItems
                        Gloveboxes[id] = {}
                        Gloveboxes[id].items = ownedItems
                        Gloveboxes[id].isOpen = src
                        Gloveboxes[id].label = secondInv.label
                    else
                        Gloveboxes[id] = {}
                        Gloveboxes[id].items = {}
                        Gloveboxes[id].isOpen = src
                        Gloveboxes[id].label = secondInv.label
                    end
                end
            elseif name == "shop" then
                secondInv.name = "itemshop-" .. id
                secondInv.label = other.label
                secondInv.maxweight = 900000
                secondInv.inventory = SetupShopItems(id, other.items)
                ShopItems[id] = {}
                ShopItems[id].items = other.items
                secondInv.slots = #other.items
            elseif name == "traphouse" then
                secondInv.name = "traphouse-" .. id
                secondInv.label = other.label
                secondInv.maxweight = 900000
                secondInv.inventory = other.items
                secondInv.slots = other.slots
            elseif name == "crafting" then
                secondInv.name = "crafting"
                secondInv.label = other.label
                secondInv.maxweight = 900000
                secondInv.inventory = other.items
                secondInv.slots = #other.items
            elseif name == "attachment_crafting" then
                secondInv.name = "attachment_crafting"
                secondInv.label = other.label
                secondInv.maxweight = 900000
                secondInv.inventory = other.items
                secondInv.slots = #other.items
            elseif name == "otherplayer" then
                local OtherPlayer = ESX.GetPlayerFromId(tonumber(id))
                if OtherPlayer ~= nil then
                    secondInv.name = "otherplayer-" .. id
                    secondInv.label = "Player-" .. id
                    secondInv.maxweight = OtherPlayer.maxWeight
                    secondInv.inventory = OtherPlayer.inventory
                    if Player.job.name == "police" then
                        secondInv.slots = 41
                    else
                        secondInv.slots = 41
                    end
                    Citizen.Wait(250)
                end
            else
                if Drops[id] ~= nil and not Drops[id].isOpen then
                    secondInv.name = id
                    secondInv.label = "Dropped-" .. tostring(id)
                    secondInv.maxweight = 100000
                    secondInv.inventory = Drops[id].items
                    secondInv.slots = 30
                    Drops[id].isOpen = src
                    Drops[id].label = secondInv.label
                else
                    secondInv.name = "none-inv"
                    secondInv.label = "Dropped-None"
                    secondInv.maxweight = 100000
                    secondInv.inventory = {}
                    secondInv.slots = 0
                end
            end
            TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.inventory, secondInv)
        else
            TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.inventory)
        end
    end
)

RegisterServerEvent("inventory:server:SaveInventory")
AddEventHandler(
    "inventory:server:SaveInventory",
    function(type, id)
        if type == "trunk" then
            if (IsVehicleOwned(id)) then
                SaveOwnedVehicleItems(id, Trunks[id].items)
            else
                Trunks[id].isOpen = false
            end
        elseif type == "glovebox" then
            if (IsVehicleOwned(id)) then
                SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
            else
                Gloveboxes[id].isOpen = false
            end
        elseif type == "stash" then
            SaveStashItems(id, Stashes[id].items)
        elseif type == "drop" then
            if Drops[id] ~= nil then
                Drops[id].isOpen = false
                if Drops[id].items == nil or next(Drops[id].items) == nil then
                    Drops[id] = nil
                    TriggerClientEvent("inventory:client:RemoveDropItem", -1, id)
                end
            end
        end
    end
)

RegisterServerEvent("inventory:server:UseItemSlot")
AddEventHandler(
    "inventory:server:UseItemSlot",
    function(slot)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local itemData = Player.GetItemBySlot(slot)
        if itemData ~= nil then
            local itemInfo = ESX.GetItems()[tostring(itemData.name)]
            if itemData.type == "weapon" then
                if itemData.info.quality ~= nil then
                    if itemData.info.quality >= 0 then
                        TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
                    else
                        TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
                    end
                else
                    TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
                end
                TriggerClientEvent("inventory:client:ItemBox", src, itemInfo, "use")
            elseif itemData.usable then
                TriggerClientEvent("inventory:client:useitemkkkkk", src, itemData)
                TriggerClientEvent("inventory:client:ItemBox", src, itemInfo, "use")
                if itemData.name == "sparekeys" then
                    TriggerClientEvent("tq-vehiclekey:client:arabayikilitlememlazim", src, itemData.info.plaka)
                end
                if itemData.name == "carkey" then
                    TriggerClientEvent("tq-vehiclekey:client:arabayikilitlememlazim", src, itemData.info.plaka)
                end
                if itemData.name == "cantax" then
                    TriggerClientEvent("K8.CNT.USE", src, itemData.info.id)
                    TriggerClientEvent("inventory:client:ItemBox", src, itemData, "use")
                    TriggerClientEvent("inventory:client:useitemkkkkk", src, itemData)
                end
            end
        end
    end
)

RegisterServerEvent("inventory:server:UseItem")
AddEventHandler(
    "inventory:server:UseItem",
    function(inventory, item)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local kullanilabiliritem = Player.GetItemByName(item.name)
        if inventory == "player" or inventory == "hotbar" then
            if kullanilabiliritem ~= nil then
                if kullanilabiliritem.usable then
                    local itemData = Player.GetItemBySlot(item.slot)
                    TriggerClientEvent("inventory:client:ItemBox", src, itemData, "use")
                    if item.name == "carkey" then
                        TriggerClientEvent("tq-vehiclekey:client:arabayikilitlememlazim", src, itemData.info.plaka)
                    end
                    TriggerClientEvent("inventory:client:useitemkkkkk", src, itemData)
                    if item.name == "cantax" then
                        TriggerClientEvent("KIBRA.CNT.USE", src, itemData.info.id)
                        print(itemData.info.id)
                    end
                end
            end
        end
    end
)

RegisterServerEvent("inventory:server:SetInventoryData")
AddEventHandler(
    "inventory:server:SetInventoryData",
    function(fromInventory, toInventory, fromSlot, toSlot, fromcount, tocount)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local geveje =
            exports.ghmattimysql:executeSync(
            "SELECT * from users where identifier = @identifier",
            {["@identifier"] = Player.identifier}
        )
        local AdSoyad = geveje[1].firstname .. " " .. geveje[1].lastname
        local identifier = Player.identifier
        local fromSlot = tonumber(fromSlot)
        local toSlot = tonumber(toSlot)
        local ExportData =
            exports.ghmattimysql:executeSync(
            "SELECT * from users WHERE identifier = @identifier",
            {["@identifier"] = Player.identifier}
        )
        local AdSoyad = ExportData[1].firstname .. " " .. ExportData[1].lastname
        local name = GetPlayerName(src)
        local isim1 =
            exports.ghmattimysql:executeSync(
            "SELECT * FROM users WHERE identifier = @identifier",
            {["@identifier"] = Player.identifier}
        )
        local ad_soyad = isim1[1].firstname .. " " .. isim1[1].lastname
        local firstname, lastname = Player.get("firstName"), Player.get("lastName")
        if
            (fromInventory == "player" or fromInventory == "hotbar") and
                (SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting")
         then
            return
        end
        if fromInventory == "player" or fromInventory == "hotbar" then
            local fromItemData = Player.GetItemBySlot(fromSlot)
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)
                    Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    if toItemData ~= nil then
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                    end
                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                elseif SplitStr(toInventory, "-")[1] == "otherplayer" then
                    local playerId = tonumber(SplitStr(toInventory, "-")[2])
                    local OtherPlayer = ESX.GetPlayerFromId(playerId)
                    local toItemData = OtherPlayer.inventory[toSlot]
                    Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
                        if string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord = v
                        end
                    end
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            OtherPlayer.removeInventoryItem(itemInfo.name, tocount, fromSlot)
                            Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                        local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                        TriggerEvent(
                            "qb-log:server:CreateLog",
                            "drop",
                            AdSoyad .. " İTEMİ YERE ATTI",
                            "red",
                            "Yere Atılan Item: **" ..
                                itemInfo.name ..
                                    "**\n Miktar: **" .. fromcount .. "**\n Hex ID: **" .. Player.identifier .. "**"
                        )
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    OtherPlayer.addInventoryItem(itemInfo.name, fromcount, toSlot, fromItemData.info)
                elseif SplitStr(toInventory, "-")[1] == "trunk" then
                    local plate = SplitStr(toInventory, "-")[2]
                    local toItemData = Trunks[plate].items[toSlot]
                    Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromTrunk(plate, fromSlot, itemInfo.name, tocount)
                            Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                        local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToTrunk(plate, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                elseif SplitStr(toInventory, "-")[1] == "glovebox" then
                    local plate = SplitStr(toInventory, "-")[2]
                    local toItemData = Gloveboxes[plate].items[toSlot]
                    Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    --Player.PlayerData.items[toSlot] = fromItemData
                    if toItemData ~= nil then
                        --Player.PlayerData.items[fromSlot] = toItemData
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromGlovebox(plate, fromSlot, itemInfo.name, tocount)
                            Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                        local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                        TriggerEvent(
                            "qb-log:server:CreateLog",
                            "glovebox",
                            "Torpidoya Eşya Bırakıldı",
                            "red",
                            "**" ..
                                GetPlayerName(src) ..
                                    "** (Hex ID: *" ..
                                        Player.identifier ..
                                            "* | id: *" ..
                                                src ..
                                                    "*) Koyulan Item: **" ..
                                                        itemInfo.name ..
                                                            "**, Miktar: **" ..
                                                                fromcount .. "** - Plaka: *" .. plate .. "*"
                        )
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToGlovebox(plate, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                elseif SplitStr(toInventory, "-")[1] == "stash" then
                    local stashId = SplitStr(toInventory, "-")[2]
                    local toItemData = Stashes[stashId].items[toSlot]
                    Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromStash(stashId, toSlot, itemInfo.name, tocount)
                            Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                        end
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToStash(stashId, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                elseif SplitStr(toInventory, "-")[1] == "traphouse" then
                    -- Traphouse
                    local traphouseId = SplitStr(toInventory, "-")[2]
                    local toItemData = exports["qb-traphouses"]:GetInventoryData(traphouseId, toSlot)
                    local IsItemValid = exports["qb-traphouses"]:CanItemBeSaled(fromItemData.name:lower())
                    if IsItemValid then
                        Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                        TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                        if toItemData ~= nil then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                            if toItemData.name ~= fromItemData.name then
                                exports["qb-traphouses"]:RemoveHouseItem(traphouseId, fromSlot, itemInfo.name, tocount)
                                Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                            end
                        else
                            local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                        end
                        local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    else
                        TriggerClientEvent(
                            "okokNotify:Alert",
                            source,
                            "Envanter",
                            "Bu Eşyayı Satamazsın!",
                            3000,
                            "error"
                        )
                    end
                else
                    -- drop
                    toInventory = tonumber(toInventory)
                    if toInventory == nil or toInventory == 0 then
                        CreateNewDrop(src, fromSlot, toSlot, fromcount)
                    else
                        local toItemData = Drops[toInventory].items[toSlot]
                        Player.removeInventoryItem(fromItemData.name, fromcount, fromSlot)
                        TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                        if toItemData ~= nil then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                            if toItemData.name ~= fromItemData.name then
                                Player.addInventoryItem(toItemData.name, tocount, fromSlot, toItemData.info)
                                RemoveFromDrop(toInventory, fromSlot, itemInfo.name, tocount)
                            end
                        else
                            local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                        end
                        local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                        AddToDrop(toInventory, toSlot, itemInfo.name, fromcount, fromItemData.info)
                        if itemInfo.name == "gps" then
                            TriggerClientEvent("exelds:GPSStop", src)
                        elseif itemInfo.name == "radio" then
                            TriggerClientEvent("sup_radio:close-radio", src)
                        end
                    end
                end
            else
                TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Bu Eşyaya sahip değilsin!", 3000, "error")
            end
        elseif SplitStr(fromInventory, "-")[1] == "otherplayer" then
            local playerId = tonumber(SplitStr(fromInventory, "-")[2])
            local OtherPlayer = ESX.GetPlayerFromId(playerId)
            local fromItemData = OtherPlayer.inventory[fromSlot]
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)
                    OtherPlayer.removeInventoryItem(itemInfo.name, fromcount, fromSlot)
                    TriggerClientEvent("inventory:client:CheckWeapon", OtherPlayer.source, fromItemData.name)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            OtherPlayer.addInventoryItem(itemInfo.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                    end
                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                    if itemInfo.name == "radio" then
                        TriggerClientEvent("sup_radio:close-radio", OtherPlayer.source)
                    end
                else
                    local toItemData = OtherPlayer.inventory[toSlot]
                    OtherPlayer.removeInventoryItem(itemInfo.name, fromcount, fromSlot)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            OtherPlayer.removeInventoryItem(itemInfo.name, tocount, toSlot)
                            OtherPlayer.addInventoryItem(itemInfo.name, tocount, fromSlot, toItemData.info)
                        end
                    else
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    OtherPlayer.addInventoryItem(itemInfo.name, fromcount, toSlot, fromItemData.info)
                end
            else
                TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Nesne Mevcut Değil!", 3000, "error")
            end
        elseif SplitStr(fromInventory, "-")[1] == "trunk" then
            local plate = SplitStr(fromInventory, "-")[2]
            local fromItemData = Trunks[plate].items[fromSlot]
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)
                    RemoveFromTrunk(plate, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            AddToTrunk(plate, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    else
                    end
                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                else
                    local toItemData = Trunks[plate].items[toSlot]
                    RemoveFromTrunk(plate, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            RemoveFromTrunk(plate, toSlot, itemInfo.name, tocount)
                            AddToTrunk(plate, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToTrunk(plate, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                end
            else
                TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Nesne Mevcut Değil", 3000, "error")
            end
        elseif SplitStr(fromInventory, "-")[1] == "glovebox" then
            local plate = SplitStr(fromInventory, "-")[2]
            local fromItemData = Gloveboxes[plate].items[fromSlot]
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)
                    RemoveFromGlovebox(plate, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            AddToGlovebox(plate, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    end
                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                else
                    local toItemData = Gloveboxes[plate].items[toSlot]
                    RemoveFromGlovebox(plate, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            RemoveFromGlovebox(plate, toSlot, itemInfo.name, tocount)
                            AddToGlovebox(plate, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    else
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToGlovebox(plate, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                end
            else
                TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Böyle bir item yok!", 3000, "error")
            end
        elseif SplitStr(fromInventory, "-")[1] == "stash" then
            local stashId = SplitStr(fromInventory, "-")[2]
            local fromItemData = Stashes[stashId].items[fromSlot]
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)
                    RemoveFromStash(stashId, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            AddToStash(stashId, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    end
                    SaveStashItems(stashId, Stashes[stashId].items)
                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                else
                    local toItemData = Stashes[stashId].items[toSlot]
                    RemoveFromStash(stashId, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            RemoveFromStash(stashId, toSlot, itemInfo.name, tocount)
                            AddToStash(stashId, fromSlot, toSlot, itemInfo.name, tocount, toItemData.info)
                        end
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToStash(stashId, toSlot, fromSlot, itemInfo.name, fromcount, fromItemData.info)
                end
            end
        elseif SplitStr(fromInventory, "-")[1] == "itemshop" then
            local shopType = SplitStr(fromInventory, "-")[2]
            local itemData = ShopItems[shopType].items[fromSlot]
            local itemInfo = ESX.GetItems()[tostring(itemData.name)]
            local bankBalance = Player.getMoney()
            local price = tonumber((itemData.price * fromcount))
            if SplitStr(shopType, "_")[1] == "Dealer" then
                if SplitStr(itemData.name, "_")[1] == "weapon" then
                    price = tonumber(itemData.price)
                    if bankBalance >= price then
                        itemData.info.serie =
                            tostring(
                            Config.RandomInt(2) ..
                                Config.RandomStr(3) ..
                                    Config.RandomInt(1) ..
                                        Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4)
                        )
                        Player.addInventoryItem(itemData.name, 1, toSlot, itemData.info)
                        Player.removeMoney(price)
                    else
                        TriggerClientEvent("okokNotify:Alert", src, "Envanter", "Yeterli paranız yok!", 3000, "error")
                    end
                else
                    if bankBalance >= price then
                        Player.removeMoney(price)
                        Player.addInventoryItem(itemData.name, fromcount, toSlot, itemData.info)
                    else
                        TriggerClientEvent("okokNotify:Alert", src, "Envanter", "Yeterli paranız yok!", 3000, "error")
                    end
                end
            elseif SplitStr(shopType, "_")[1] == "Itemshop" then
                local EsxItems = ESX.GetItems()
                if bankBalance >= price then
                    if itemData.type == "weapon" then
                        itemData.info.serie =
                            tostring(
                            Config.RandomInt(2) ..
                                Config.RandomStr(3) ..
                                    Config.RandomInt(1) ..
                                        Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4)
                        )
                    end
                    Player.removeMoney(price)
                    Player.addInventoryItem(itemData.name, fromcount, toSlot, itemData.info)
                    TriggerClientEvent("inventory:client:ItemBox", src, EsxItems[itemData.name], "add", fromcount)
                else
                    TriggerClientEvent("okokNotify:Alert", src, "Envanter", "Yeterli paranız yok!", 3000, "error")
                end
            else
                if bankBalance >= price then
                    Player.removeMoney(price)
                    Player.addInventoryItem(itemData.name, fromcount, toSlot, itemData.info)
                    TriggerClientEvent("inventory:client:ItemBox", src, EsxItems[itemData.name], "add", fromcount)
                elseif bankBalance >= price then
                    Player.removeMoney(price)
                    Player.addInventoryItem(itemData.name, fromcount, toSlot, itemData.info)
                    TriggerClientEvent("inventory:client:ItemBox", src, EsxItems[itemData.name], "add", fromcount)
                else
                    TriggerClientEvent("okokNotify:Alert", src, "Envanter", "Yeterli paranız yok!", 3000, "error")
                end
            end
        elseif fromInventory == "crafting" then
            local itemData = Config.CraftingItems[fromSlot]
            if hasCraftItems(src, itemData.costs, fromcount) then
                TriggerClientEvent(
                    "inventory:client:CraftItems",
                    src,
                    itemData.name,
                    itemData.costs,
                    fromcount,
                    toSlot,
                    itemData.points
                )
            else
                TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
                TriggerClientEvent(
                    "okokNotify:Alert",
                    src,
                    "Envanter",
                    "Yeterli eşyalara sahip değilsin!",
                    3000,
                    "error"
                )
            end
        elseif fromInventory == "attachment_crafting" then
            local identifier = Player.identifier
            local itemData = Config.AttachmentCrafting[craftid[identifier]][fromSlot]
            if hasCraftItems(src, itemData.costs, fromcount) then
                TriggerClientEvent(
                    "inventory:client:CraftAttachment",
                    src,
                    itemData.name,
                    itemData.costs,
                    fromcount,
                    toSlot,
                    itemData.points
                )
            else
                TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
                TriggerClientEvent(
                    "okokNotify:Alert",
                    src,
                    "Envanter",
                    "Yeterli eşyalara sahip değilsin!",
                    3000,
                    "error"
                )
            end
        elseif SplitStr(fromInventory, "-")[1] == "garbage" then
            local garbageId = fromInventory:sub(9)
            local toItemData = Garbages[garbageId].items[fromSlot]
            local essxItem = ESX.GetItems()
            if toItemData.name ~= nil then
                Player.addInventoryItem(toItemData.name, fromcount, toSlot, toItemData.info)
                RemoveFromGarbage(garbageId, fromSlot, toItemData.name, fromcount)
                TriggerClientEvent("inventory:client:ItemBox", src, essxItem[toItemData.name], "add", fromcount)
            end
        else
            fromInventory = tonumber(fromInventory)
            if fromSlot == nil or fromInventory == nil then
                print("cylex_inventory :1015 nil cikti.")
                return
            end
            local fromItemData = Drops[fromInventory].items[fromSlot]
            local fromcount = tonumber(fromcount) ~= nil and tonumber(fromcount) or fromItemData.count
            if fromItemData ~= nil and fromItemData.count >= fromcount then
                local itemInfo = ESX.GetItems()[fromItemData.name:lower()]

                if toInventory == "player" or toInventory == "hotbar" then
                    local toItemData = Player.GetItemBySlot(toSlot)

                    RemoveFromDrop(fromInventory, fromSlot, fromItemData.name, fromcount)
                    if toItemData ~= nil then
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            Player.removeInventoryItem(toItemData.name, tocount, toSlot)
                            AddToDrop(fromInventory, fromSlot, toItemData.name, tocount, toItemData.info)
                            if itemInfo.name == "gps" then
                                TriggerClientEvent("exelds:GPSStop", src)
                            elseif itemInfo.name == "radio" then
                                TriggerClientEvent("sup_radio:close-radio", src)
                            end
                        end
                    end

                    Player.addInventoryItem(fromItemData.name, fromcount, toSlot, fromItemData.info)
                else
                    toInventory = tonumber(toInventory)
                    local toItemData = Drops[toInventory].items[toSlot]
                    RemoveFromDrop(fromInventory, fromSlot, itemInfo.name, fromcount)
                    if toItemData ~= nil then
                        local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                        local tocount = tonumber(tocount) ~= nil and tonumber(tocount) or toItemData.count
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = ESX.GetItems()[tostring(toItemData.name)]
                            RemoveFromDrop(toInventory, toSlot, itemInfo.name, tocount)
                            AddToDrop(fromInventory, fromSlot, itemInfo.name, tocount, toItemData.info)
                            if itemInfo.name == "gps" then
                                TriggerClientEvent("exelds:GPSStop", src)
                            elseif itemInfo.name == "radio" then
                                TriggerClientEvent("sup_radio:close-radio", src)
                            end
                        end
                    end
                    local itemInfo = ESX.GetItems()[tostring(fromItemData.name)]
                    AddToDrop(toInventory, toSlot, itemInfo.name, fromcount, fromItemData.info)
                    if itemInfo.name == "gps" then
                        TriggerClientEvent("exelds:GPSStop", src)
                    elseif itemInfo.name == "radio" then
                        TriggerClientEvent("sup_radio:close-radio", src)
                    end
                end
            end
        end
    end
)

function hasCraftItems(source, CostItems, count)
    local Player = ESX.GetPlayerFromId(source)
    for k, v in pairs(CostItems) do
        if Player.GetItemByName(k) ~= nil then
            if Player.GetItemByName(k).count < (v * count) then
                return false
            end
        else
            return false
        end
    end
    return true
end

function IsVehicleOwned(plate)
    local result =
        exports.ghmattimysql:scalarSync(
        "SELECT * from owned_vehicles WHERE plate = @plate",
        {
            ["@plate"] = plate
        }
    )
    if result then
        return true
    else
        return false
    end
end

local function escape_str(s)
    local in_char = {"\\", '"', "/", "\b", "\f", "\n", "\r", "\t"}
    local out_char = {"\\", '"', "/", "b", "f", "n", "r", "t"}
    for i, c in ipairs(in_char) do
        s = s:gsub(c, "\\" .. out_char[i])
    end
    return s
end

-- Shop Items
function SetupShopItems(shop, shopItems)
    local Player = ESX.GetPlayerFromId(source)
    local items = {}
    if shopItems ~= nil and next(shopItems) ~= nil then
        for k, item in pairs(shopItems) do
            local itemInfo = ESX.GetItems()[tostring(item.name)]
            items[item.slot] = {
                name = itemInfo.name,
                count = item.count,
                info = item.info ~= nil and item.info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                price = item.price,
                image = itemInfo.image,
                slot = item.slot
            }
        end
    end
    return items
end

-- Stash Items
function GetStashItems(stashId)
    local Player = ESX.GetPlayerFromId(source)
    local items = {}
    local result = exports.ghmattimysql:executeSync("SELECT * FROM `stashitems` WHERE `stash` = '" .. stashId .. "'")
    if result[1] ~= nil then
        if result[1].items ~= nil then
            result[1].items = json.decode(result[1].items)
            if result[1].items ~= nil then
                for k, item in pairs(result[1].items) do
                    local itemInfo = ESX.GetItems()[tostring(item.name)]
                    items[item.slot] = {
                        name = itemInfo.name,
                        count = tonumber(item.count),
                        info = item.info ~= nil and item.info or "",
                        label = itemInfo.label,
                        description = itemInfo.description ~= nil and itemInfo.description or "",
                        weight = itemInfo.weight,
                        type = itemInfo.type,
                        unique = itemInfo.unique,
                        usable = itemInfo.usable,
                        image = itemInfo.image,
                        slot = item.slot
                    }
                end
            end
        end
    end
    return items
end

ESX.RegisterServerCallback(
    "qb-inventory:server:GetStashItems",
    function(source, cb, stashId)
        cb(GetStashItems(stashId))
    end
)

RegisterServerEvent("qb-inventory:server:SaveStashItems")
AddEventHandler(
    "qb-inventory:server:SaveStashItems",
    function(stashId, items)
        exports.ghmattimysql:execute(
            "INSERT INTO stashitems (stash, items) VALUES (@stash, @items) ON DUPLICATE KEY UPDATE items = @items",
            {
                ["@stash"] = stashId,
                ["@items"] = json.encode(items)
            }
        )
    end
)

function SaveStashItems(stashId, items)
    if Stashes[stashId].label ~= "Stash-None" then
        if items ~= nil then
            for slot, item in pairs(items) do
                item.description = nil
            end
            exports.ghmattimysql:execute(
                "INSERT INTO stashitems (stash, items) VALUES (@stash, @items) ON DUPLICATE KEY UPDATE items = @items",
                {
                    ["@stash"] = stashId,
                    ["@items"] = json.encode(items)
                }
            )
            Stashes[stashId].isOpen = false
        end
    end
end

function AddToStash(stashId, slot, otherslot, itemName, count, info)
    local count = tonumber(count)
    local Player = ESX.GetPlayerFromId(source)
    local ItemData = ESX.GetItems()[tostring(itemName)]
    if not ItemData.unique then
        if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
            Stashes[stashId].items[slot].count = Stashes[stashId].items[slot].count + count
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Stashes[stashId].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = slot
            }
        end
    else
        if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Stashes[stashId].items[otherslot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = otherslot
            }
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Stashes[stashId].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = slot
            }
        end
    end
end

function RemoveFromStash(stashId, slot, itemName, count)
    local count = tonumber(count)
    if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
        if Stashes[stashId].items[slot].count > count then
            Stashes[stashId].items[slot].count = Stashes[stashId].items[slot].count - count
        else
            Stashes[stashId].items[slot] = nil
            if next(Stashes[stashId].items) == nil then
                Stashes[stashId].items = {}
            end
        end
    else
        Stashes[stashId].items[slot] = nil
        if Stashes[stashId].items == nil then
            Stashes[stashId].items[slot] = nil
        end
    end
end

-- Trunk items
function GetOwnedVehicleItems(plate)
    local items = {}
    local result =
        exports.ghmattimysql:executeSync("SELECT items FROM trunkitems WHERE plate=@plate", {["@plate"] = plate})
    if result[1] ~= nil then
        if result[1].items ~= nil then
            result[1].items = json.decode(result[1].items)
            if result[1].items ~= nil then
                for k, item in pairs(result[1].items) do
                    local itemInfo = ESX.GetItems()[tostring(item.name)]
                    items[item.slot] = {
                        name = itemInfo.name,
                        count = tonumber(item.count),
                        info = item.info ~= nil and item.info or "",
                        label = itemInfo.label,
                        description = itemInfo.description ~= nil and itemInfo.description or "",
                        weight = itemInfo.weight,
                        type = itemInfo.type,
                        unique = itemInfo.unique,
                        useable = itemInfo.useable,
                        image = itemInfo.image,
                        slot = item.slot
                    }
                end
            end
        end
    end
    return items
end

function SaveOwnedVehicleItems(plate, items)
    if Trunks[plate].label ~= "Trunk-None" then
        if items ~= nil then
            for slot, item in pairs(items) do
                item.description = nil
            end
            exports.ghmattimysql:execute(
                "INSERT INTO trunkitems (plate, items) VALUES (@plate, @items) ON DUPLICATE KEY UPDATE items = @items",
                {
                    ["@plate"] = plate,
                    ["@items"] = json.encode(items)
                }
            )
            Trunks[plate].isOpen = false
        end
    end
end

function AddToTrunk(plate, slot, otherslot, itemName, count, info)
    local Player = ESX.GetPlayerFromId(source)
    local count = tonumber(count)
    local ItemData = ESX.GetItems()[tostring(itemName)]

    if not ItemData.unique then
        if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
            Trunks[plate].items[slot].count = Trunks[plate].items[slot].count + count
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Trunks[plate].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = slot
            }
        end
    else
        if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Trunks[plate].items[otherslot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = otherslot
            }
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Trunks[plate].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                usable = itemInfo.usable,
                image = itemInfo.image,
                slot = slot
            }
        end
    end
end

function RemoveFromTrunk(plate, slot, itemName, count)
    if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
        if Trunks[plate].items[slot].count > count then
            Trunks[plate].items[slot].count = Trunks[plate].items[slot].count - count
        else
            Trunks[plate].items[slot] = nil
            if next(Trunks[plate].items) == nil then
                Trunks[plate].items = {}
            end
        end
    else
        Trunks[plate].items[slot] = nil
        if Trunks[plate].items == nil then
            Trunks[plate].items[slot] = nil
        end
    end
end

-- Glovebox items
function GetOwnedVehicleGloveboxItems(plate)
    local items = {}
    local result =
        exports.ghmattimysql:executeSync("SELECT items FROM gloveboxitems WHERE plate=@plate", {["@plate"] = plate})
    if result[1] ~= nil then
        if result[1].items ~= nil then
            result[1].items = json.decode(result[1].items)
            if result[1].items ~= nil then
                for k, item in pairs(result[1].items) do
                    local itemInfo = ESX.GetItems()[tostring(item.name)]
                    items[item.slot] = {
                        name = itemInfo.name,
                        count = tonumber(item.count),
                        info = item.info ~= nil and item.info or "",
                        label = itemInfo.label,
                        description = itemInfo.description ~= nil and itemInfo.description or "",
                        weight = itemInfo.weight,
                        type = itemInfo.type,
                        unique = itemInfo.unique,
                        useable = itemInfo.useable,
                        image = itemInfo.image,
                        slot = item.slot
                    }
                end
            end
        end
    end
    return items
end

function SaveOwnedGloveboxItems(plate, items)
    if Gloveboxes[plate].label ~= "Glovebox-None" then
        if items ~= nil then
            for slot, item in pairs(items) do
                item.description = nil
            end
            exports.ghmattimysql:execute(
                "INSERT INTO gloveboxitems (plate, items) VALUES (@plate, @items) ON DUPLICATE KEY UPDATE items = @items",
                {
                    ["@plate"] = plate,
                    ["@items"] = json.encode(items)
                }
            )
            Gloveboxes[plate].isOpen = false
        end
    end
end

function AddToGlovebox(plate, slot, otherslot, itemName, count, info)
    local count = tonumber(count)
    local ItemData = ESX.GetItems()[tostring(itemName)]

    if not ItemData.unique then
        if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
            Gloveboxes[plate].items[slot].count = Gloveboxes[plate].items[slot].count + count
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Gloveboxes[plate].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                useable = itemInfo.useable,
                image = itemInfo.image,
                slot = slot
            }
        end
    else
        if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Gloveboxes[plate].items[otherslot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                useable = itemInfo.useable,
                image = itemInfo.image,
                slot = otherslot
            }
        else
            local itemInfo = ESX.GetItems()[tostring(itemName)]
            Gloveboxes[plate].items[slot] = {
                name = itemInfo.name,
                count = count,
                info = info ~= nil and info or "",
                label = itemInfo.label,
                description = itemInfo.description ~= nil and itemInfo.description or "",
                weight = itemInfo.weight,
                type = itemInfo.type,
                unique = itemInfo.unique,
                useable = itemInfo.useable,
                image = itemInfo.image,
                slot = slot
            }
        end
    end
end

function RemoveFromGlovebox(plate, slot, itemName, count)
    if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
        if Gloveboxes[plate].items[slot].count > count then
            Gloveboxes[plate].items[slot].count = Gloveboxes[plate].items[slot].count - count
        else
            Gloveboxes[plate].items[slot] = nil
            if next(Gloveboxes[plate].items) == nil then
                Gloveboxes[plate].items = {}
            end
        end
    else
        Gloveboxes[plate].items[slot] = nil
        if Gloveboxes[plate].items == nil then
            Gloveboxes[plate].items[slot] = nil
        end
    end
end

ESX.RegisterServerCallback(
    "garbage:ac",
    function(source, cb, garbageId)
        if Garbages[garbageId] ~= nil then
            cb(Garbages[garbageId].items)
        else
            local items = {}
            for k, item in pairs(Config.GarbageItems) do
                local itemInfo = ESX.GetItems()[tostring(item.name)]
                local random = math.random(#Config.GarbageItems)
                items[random] = {
                    name = itemInfo.name,
                    count = tonumber(item.count),
                    info = item.info ~= nil and item.info or "",
                    label = itemInfo.label,
                    description = itemInfo.description ~= nil and itemInfo.description or "",
                    weight = itemInfo.weight,
                    type = itemInfo.type,
                    unique = itemInfo.unique,
                    usable = itemInfo.usable,
                    image = itemInfo.image,
                    slot = random
                }
            end
            Garbages[garbageId] = {}
            Garbages[garbageId].items = items
            cb(items)
        end
    end
)

-- Drop items
function AddToDrop(dropId, slot, itemName, count, info)
    local Player = ESX.GetPlayerFromId(source)
    local count = tonumber(count)
    if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
        Drops[dropId].items[slot].count = Drops[dropId].items[slot].count + count
    else
        local itemInfo = ESX.GetItems()[tostring(itemName)]
        Drops[dropId].items[slot] = {
            name = itemInfo.name,
            count = count,
            info = info ~= nil and info or "",
            label = itemInfo.label,
            description = itemInfo.description ~= nil and itemInfo.description or "",
            weight = itemInfo.weight,
            type = itemInfo.type,
            unique = itemInfo.unique,
            usable = itemInfo.usable,
            image = itemInfo.image,
            slot = slot,
            id = dropId
        }
        if itemInfo.name == "radio" then
            TriggerClientEvent("sup_radio:close-radio", source)
        end
    end
end

function RemoveFromDrop(dropId, slot, itemName, count)
    if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
        if Drops[dropId].items[slot].count > count then
            Drops[dropId].items[slot].count = Drops[dropId].items[slot].count - count
        else
            Drops[dropId].items[slot] = nil
            if Drops[dropId].items == nil then
                Drops[dropId].items = {}
            --TriggerClientEvent("inventory:client:RemoveDropItem", -1, dropId)
            end
        end
    else
        Drops[dropId].items[slot] = nil
        if Drops[dropId].items == nil then
            Drops[dropId].items[slot] = nil
        --TriggerClientEvent("inventory:client:RemoveDropItem", -1, dropId)
        end
    end
end

function CreateDropId()
    if Drops ~= nil then
        local id = math.random(10000, 99999)
        local dropid = id
        while Drops[dropid] ~= nil do
            id = math.random(10000, 99999)
            dropid = id
        end
        return dropid
    else
        local id = math.random(10000, 99999)
        local dropid = id
        return dropid
    end
end

function CreateNewDrop(source, fromSlot, toSlot, itemcount)
    local Player = ESX.GetPlayerFromId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local itemData = Player.GetItemBySlot(fromSlot)
    if Player.removeInventoryItem(itemData.name, itemcount, itemData.slot) then
        TriggerClientEvent("inventory:client:CheckWeapon", source, itemData.name)
        local itemInfo = ESX.GetItems()[tostring(itemData.name)]
        local dropId = CreateDropId()
        Drops[dropId] = {}
        Drops[dropId].items = {}

        Drops[dropId].items[toSlot] = {
            name = itemInfo.name,
            count = itemcount,
            info = itemData.info ~= nil and itemData.info or "",
            label = itemInfo.label,
            description = itemInfo.description ~= nil and itemInfo.description or "",
            weight = itemInfo.weight,
            type = itemInfo.type,
            unique = itemInfo.unique,
            usable = itemInfo.usable,
            image = itemInfo.image,
            slot = toSlot,
            id = dropId
        }
        TriggerClientEvent("inventory:client:DropItemAnim", source)
        TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
        if itemData.name == "gps" then
            TriggerClientEvent("exelds:GPSStop", source)
        elseif itemData.name == "radio" then
            TriggerClientEvent("sup_radio:close-radio", source)
        end
    else
        TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Yeterli eşyalara sahip değilsin!", 3000, "ERROR")
        return
    end
end

RegisterCommand(
    "inv",
    function(source, args)
        local Player = ESX.GetPlayerFromId(source)
        TriggerClientEvent("inventory:client:OpenInventory", source, Player.inventory)
    end
)

function Sanitize(str)
    local replacements = {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ["\n"] = "<br/>"
    }

    return str:gsub("[&<>\n]", replacements):gsub(
        " +",
        function(s)
            return " " .. ("&nbsp;"):rep(#s - 1)
        end
    )
end

RegisterCommand(
    "ustara",
    function(source, args)
        TriggerClientEvent("police:client:RobPlayer", source)
    end
)

RegisterCommand(
    "nakitcal",
    function(source, args)
        local count = tonumber(args[1])
        TriggerClientEvent("inventory:client:paraçal", source, count)
    end
)

ESX.RegisterUsableItem(
    "id_card",
    function(source, item)
        local Player = ESX.GetPlayerFromId(source)
        if Player.GetItemBySlot(item.slot) ~= nil then
            TriggerClientEvent("inventory:client:ShowId", -1, source, Player.getIdentifier(), item.info)
        end
    end
)

ESX.RegisterUsableItem(
    "snowball",
    function(source, item)
        local Player = ESX.GetPlayerFromId(source)
        local itemData = Player.GetItemBySlot(item.slot)
        if Player.GetItemBySlot(item.slot) ~= nil then
            TriggerClientEvent("inventory:client:UseSnowball", source, itemData.count)
        end
    end
)

ESX.RegisterUsableItem(
    "driver_license",
    function(source, item)
        local Player = ESX.GetPlayerFromId(source)
        if Player.GetItemBySlot(item.slot) ~= nil then
            TriggerClientEvent("inventory:client:ShowDriverLicense", -1, source, Player.PlayerData.citizenid, item.info)
        end
    end
)

local StringCharset = {}
local NumberCharset = {}

for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end
for i = 65, 90 do
    table.insert(StringCharset, string.char(i))
end
for i = 97, 122 do
    table.insert(StringCharset, string.char(i))
end

RandomStr = function(length)
    if length > 0 then
        return RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
    else
        return ""
    end
end

RandomInt = function(length)
    if length > 0 then
        return RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

SplitStr = function(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

RegisterServerEvent("inventory:server:paraçal")
AddEventHandler(
    "inventory:server:paraçal",
    function(targetid, count)
        local src = source
        local target = ESX.GetPlayerFromId(targetid)
        local Player = ESX.GetPlayerFromId(src)
        if target ~= nil then
            if target.getMoney() >= count then
                target.removeMoney(count)
                Player.addMoney(count)
            else
                TriggerClientEvent(
                    "okokNotify:Alert",
                    source,
                    "Para Çalma",
                    "Bu kişide bu kadar para yok!",
                    3000,
                    "error"
                )
            end
        else
            print("Oyuncu bulunamadı qb_inventory/server:1690")
        end
    end
)

RegisterServerEvent("inventory:paraver")
AddEventHandler(
    "inventory:paraver",
    function(targetid, count)
        local src = source
        local target = ESX.GetPlayerFromId(targetid)
        local Player = ESX.GetPlayerFromId(src)
        if target then
            if Player.getMoney() >= count then
                target.addMoney(count)
                Player.removeMoney(count)
            else
                TriggerClientEvent("okokNotify:Alert", source, "Envanter", "Yeterli paranız yok!", 3000, "error")
            end
        else
            print("Oyuncu bulunamadı qb_inventory/server:1690")
        end
    end
)
