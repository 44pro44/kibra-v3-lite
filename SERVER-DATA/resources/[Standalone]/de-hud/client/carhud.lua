-- Lil Becha Bir Orospu Çocuğudur!

local tekerPatlak, sikiKemer, cruiseIsOn, seatbelt, vehIsMovingFwd, alarmset, engineRunning = false, false, false, false, false, false, false

local curSpeed, prevSpeed, kemerSayi, cruiseSpeed, speedLimit = 0.0, 0.0, 0, 999.0, 80.0

local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}

local compassOn = true

local vehAcc = false

local inVehSetState = false

local clock = ""

local zoneNames = {

    AIRP = "Los Santos Uluslararası Havalimanı",

    ALAMO = "Alamo Denizi",

    ALTA = "Alta",

    ARMYB = "Fort Zancudo",

    BANHAMC = "Banham Kanyonu",

    BANNING = "Banning",

    BAYTRE = "Baytree Kanyonu", 

    BEACH = "Vespucci Sahili",

    BHAMCA = "Banham Kanyonu",

    BRADP = "Braddock Geçişi",

    BRADT = "Braddock Tüneli",

    BURTON = "Burton",

    CALAFB = "Calafia Köprüsü",

    CANNY = "Raton Kanyonu",

    CCREAK = "Cassidy Deresi",

    CHAMH = "Chamberlain Tepeleri",

    CHIL = "Vinewood Tepeleri",

    CHU = "Chumash",

    CMSW = "Chiliad Dağ Eyaleti",

    CYPRE = "Cypress Bölgesi",

    DAVIS = "Davis",

    DELBE = "Del Perro Sahili",

    DELPE = "Del Perro",

    DELSOL = "La Puerta",

    DESRT = "Grand Senora Çölü",

    DOWNT = "Downtown",

    DTVINE = "Downtown Vinewood",

    EAST_V = "Doğu Vinewood",

    EBURO = "El Burro Tepeleri",

    ELGORL = "El Gordo Deniz Feneri",

    ELYSIAN = "Elysian Adası",

    GALFISH = "Galilee",

    GALLI = "Galileo Parkı",

    golf = "GWC ve Golf Sosyetesi",

    GRAPES = "Grapeseed",

    GREATC = "Great Chaparral",

    HARMO = "Harmony",

    HAWICK = "Hawick",

    HORS = "Vinewood Yarış Pisti",

    HUMLAB = "Humane Laboratuvarı",

    JAIL = "Bolingbroke Arazisi",

    KOREAT = "Little Seoul",

    LACT = "Land Act Rezervuarı",

    LAGO = "Lago Zancudo",

    LDAM = "Land Act Barajı",

    LEGSQU = "Legion Meydanı",

    LMESA = "La Mesa",

    LOSPUER = "La Puerta",

    MIRR = "Mirror Parkı",

    MORN = "Morningwood",

    MOVIE = "Richards Majestic",

    MTCHIL = "Chiliad Dağı",

    MTGORDO = "Gordo Dağı",

    MTJOSE = "Josiah Dağı",

    MURRI = "Murrieta Tepeleri",

    NCHU = "North Chumash",

    NOOSE = "N.O.O.S.E",

    OCEANA = "Pasifik Okyanusu",

    PALCOV = "Paleto Koyu",

    PALETO = "Paleto Bay",

    PALFOR = "Paleto Ormanı",

    PALHIGH = "Palomino Tepeleri",

    PALMPOW = "Palmer-Taylor Enerji Santrali",

    PBLUFF = "Pasifik Uçurumu",

    PBOX = "Pillbox Tepesi",

    PROCOB = "Procopio Sahili",

    RANCHO = "Rancho",

    RGLEN = "Richman Glen",

    RICHM = "Richman",

    ROCKF = "Rockford Tepeleri",

    RTRAK = "Redwood Işıkları Pisti",

    SanAnd = "San Andreas",

    SANCHIA = "San Chianski Dağ Arazisi",

    SANDY = "Sandy Kıyıları",

    SKID = "Mission Row",

    SLAB = "Stab Şehri",

    STAD = "Maze Bank Arenası",

    STRAW = "Strawberry",

    TATAMO = "Tataviam Dağları",

    TERMINA = "Terminal",

    TEXTI = "Tekstil Şehri",

    TONGVAH = "Tongva Tepeleri",

    TONGVAV = "Tongva Vadisi",

    VCANA = "Vespucci Kanalları",

    VESP = "Vespucci",

    VINE = "Vinewood",

    WINDF = "Ron Alternates Rüzgar Çiftliği",

    WVINE = "West Vinewood",

    ZANCUDO = "Zancudo Deresi",

    ZP_ORT = "Güney Los Santos Limanı",

    ZQ_UAR = "Davis Quartz"

}



RegisterNetEvent("ryder-hud:hizsabitle")

AddEventHandler("ryder-hud:hizsabitle", function(args)

    if args[1] == nil then args[1] = 1 end

    if driverSeat and tonumber(args[1]) > 0 then

        if not IsVehicleTyreBurst(vehicle, 0) and not IsVehicleTyreBurst(vehicle, 1) and not IsVehicleTyreBurst(vehicle, 4) and not IsVehicleTyreBurst(vehicle, 5) then 

            cruiseIsOn = true

            cruiseSpeed = (tonumber(args[1] + 2) / 3.6)

        end

    end

end)


RegisterNetEvent('remove:harness')
AddEventHandler('remove:harness', function()
    if seatbeltDisableExit then 
        if seatbelt then
            exports['mythic_progbar']:Progress({
                name = "seatbelt",
                duration = 12000,
                label = 'Kemeri Çıkartıyorsun',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(cancelled)
                if not cancelled then
                    ESX.ShowNotification("Kemer çıkartıldı", "error")
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    -- TriggerEvent('InteractSound_CL:PlayOnOne', 'cikar', 0.5)
                    seatbelt = false
                    seatbeltDisableExit = false
                end
            end)
        end
    end
end)



Citizen.CreateThread(function()

    while true do
    local time = 1000
        if inVehicle then 
            time = 50
            SendNUIMessage({
                type = "vehSpeed",
                speed = string.format("%.0f", prevSpeed * 3.6)
            })
        end
    Citizen.Wait(time)
    end

end)



local offRoad = 0

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(500)

        if isLoggedIn then

            local hours = GetClockHours()

            local mins = GetClockMinutes()

            if string.len(tostring(hours)) == 1 then hours = '0'..hours end

            if string.len(tostring(mins)) == 1 then mins = '0'..mins end

            clock = hours .. ':' .. mins



            local street = ""

            local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)

            local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)

            local zone = tostring(GetNameOfZone(x, y, z))

            

            if not zone then

                zone = "UNKNOWN"

                zoneNames['UNKNOWN'] = zone

            elseif not zoneNames[zone] then

                local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z

                zoneNames[zone] = "Bilinmiyor"

            end



            street = zoneNames[zone]

            

            if intersectStreetName ~= nil and intersectStreetName ~= "" then

                street = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[zone] .. "]"

            elseif currentStreetName ~= nil and currentStreetName ~= "" then

                street = currentStreetName .. " | [" .. zoneNames[zone] .. "]"

            else

                street = "[".. zoneNames[tostring(zone)] .. "]"

            end



            if inVehicle then 

                if not inVehSetState then

                    inVehSetState = true

                    SendNUIMessage({

                        type = "inVeh",

                        data = true

                    })

                end



                -- araç arazi vs

                if DoesEntityExist(vehicle) then

                    local wheel_type = GetVehicleWheelType(vehicle)

                    if wheel_type ~= 3 and wheel_type ~= 4 and wheel_type ~= 6 then -- If have Off-road/Suv's/Motorcycles wheel grip its equal

                        if not cruiseIsOn then

                            local maxSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")

                            SetEntityMaxSpeed(vehicle, maxSpeed)

                        end

        

                        local material_id = GetVehicleWheelSurfaceMaterial(vehicle, 1)

                        if material_id == 4 or material_id == 1 or material_id == 3 then -- All road (sandy/los santos/paleto bay)

                            offRoad = 0

                            SetVehicleGravityAmount(vehicle, 9.8000001907349) -- On road

                        else

                            offRoad = offRoad + 1

                            if offRoad > 4 then

                                SetVehicleGravityAmount(vehicle, 5.8000001907349) -- Off road

                            end

                        end

                    else

                        if not cruiseIsOn then

                            local maxSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")

                            SetEntityMaxSpeed(vehicle, maxSpeed*0.7)

                        end

                    end



                    if Fuel < 20 then

                        TriggerEvent("CarFuelAlarm")

                    else

                        if Fuel < 10 then

                            TriggerEvent("CarFuelAlarm")

                        end

                    end

                end

       

                local p1,p2,lightsOn = GetVehicleLightsState(vehicle)

                if not engineRunning then

                    SendNUIMessage({

                        type = "carHud",

                        fuel = Fuel,

                        street = street,

                        compass = degreesToIntercardinalDirection(),

                        belt = vehicleClass == 8 and "close" or seatbelt,

                        time = clock,

                        cruise = cruiseIsOn,

                        seatbeltmod = sikiKemer,

                        engine = false,

                        yukseklik =  false,

                        trunk = vehicleClass == 8 and "close" or GetVehicleDoorAngleRatio(vehicle, 5) > 0,

                        light = false,

                        engineHealth = 1000,

                        doors = vehicleClass == 8 and "close" or (GetVehicleDoorAngleRatio(vehicle, 0) > 0 or GetVehicleDoorAngleRatio(vehicle, 1) > 0 or GetVehicleDoorAngleRatio(vehicle, 2) > 0 or GetVehicleDoorAngleRatio(vehicle, 3) > 0) 

                    }) 

                else

                    SendNUIMessage({

                        type = "carHud",

                        fuel = Fuel,

                        street = street,

                        compass = degreesToIntercardinalDirection(),

                        belt = vehicleClass == 8 and "close" or seatbelt,

                        time = clock,

                        cruise = cruiseIsOn,

                        seatbeltmod = sikiKemer,

                        engine = true,

                        yukseklik = (GetVehicleClass(vehicle) == 15 or GetVehicleClass(vehicle) == 16) and GetEntityHeightAboveGround(vehicle) or false,

                        trunk = vehicleClass == 8 and "close" or GetVehicleDoorAngleRatio(vehicle, 5) > 0,

                        light = lightsOn,

                        engineHealth = GetVehicleEngineHealth(vehicle),

                        doors = vehicleClass == 8 and "close" or (GetVehicleDoorAngleRatio(vehicle, 0) > 0 or GetVehicleDoorAngleRatio(vehicle, 1) > 0 or GetVehicleDoorAngleRatio(vehicle, 2) > 0 or GetVehicleDoorAngleRatio(vehicle, 3) > 0)  

                    }) 

                end

            else

                if inVehSetState then

                    inVehSetState = false

                    SendNUIMessage({

                        type = "inVeh",

                        data = false

                    })

                else

                    SendNUIMessage({

                        type = "clockStreet",

                        time = clock,

                        street = street,

                        compass = degreesToIntercardinalDirection(),

                    })

                end

            end

        end



    end

end)



RegisterNetEvent("ryder-hud:car:eject-other-player-car-client")

AddEventHandler("ryder-hud:car:eject-other-player-car-client", function(velocity)

    ejectPlayer()

end)



-- Secondary thread to update strings

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(4000)

        if inVehicle and vehIsMovingFwd and not seatbelt and driverSeat and engineRunning and vehicleClass ~= 13 and vehicleClass ~= 8 and vehicleClass ~= 21 and vehicleClass ~= 14 and vehicleClass ~= 16 and vehicleClass ~= 15 then

            TriggerEvent('InteractSound_CL:PlayOnOne', 'alarm', 0.5)

        end

    end

end)



-- CODE --

local zone = "Unknown";

local time = "12:00"

local busy = false

local VehicleNormalMaxSpeed = false

local lastsikiKemer = false



Citizen.CreateThread(function()

    RegisterKeyMapping('+seatbelt', 'Araç (Kemer)', 'keyboard', 'k')

    RegisterKeyMapping('cruise', 'Araç (Hız Sabitleme)', 'keyboard', 'y')

end)



RegisterCommand("-seatbelt", function()

    kemerSayi = 0

end, false)



RegisterCommand("+seatbelt", function()
    if inVehicle and vehicleClass and vehicleClass ~= 8 and not busy then
        Citizen.Wait(250)
        while IsControlPressed(0, 311) do
            if not seatbelt then
                if kemerSayi > 0 then
                    if sikiKemer then
                        ESX.ShowNotification('Sıkı Kemer Modu Devre Bırakılıyor '..(3-kemerSayi)+1)
                    else
                        ESX.ShowNotification('Sıkı Kemer Modu Aktifleştiriliyor '..(3-kemerSayi)+1)
                    end
                end
                if kemerSayi == 3 then
                    local result = nil
                    ESX.TriggerServerCallback("malvlad:item-kontrol", function(data)
                        result = data
                    end,"kemer")
                    while result == nil do Citizen.Wait(1) end
                    if result > 0 then
                        if sikiKemer then
                            sikiKemer = false
                            ESX.ShowNotification('Sıkı Kemer Modu Devre Dışı', 'error')
                        else
                            if math.random(1,100) < 4 then
                                --TriggerServerEvent("tgiann-basicneeds:esya-sil", "kemer")
                                ESX.ShowNotification('Sıkı Kemeri Bağlarken Koptu!', 'error')
                                return
                            else
                                sikiKemer = true
                                ESX.ShowNotification('Sıkı Kemer Modu Devrede', 'success')
                            end
                        end
                    else
                        ESX.ShowNotification('Üzerinde Kemer Yok!', 'error')
                        return
                    end
                    break
                end
                kemerSayi = kemerSayi + 1
            else
                ESX.ShowNotification('Kemer Takılı İken Kemer Modunu Değiştiremezsin!', 'error')
                return
            end
            Citizen.Wait(1000)
        end

        if sikiKemer or lastsikiKemer then 
            if seatbelt then
                busy = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "seatbelt",
                    duration = 12000,
                    label = "Sıkı Kemer Çıkartılıyor",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                    ESX.ShowNotification("Kemer Çıkarıldı", "error")
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'carunbuckle', 0.5)
                    seatbelt = false
                    busy = false
                    end
                end)
                busy = false
            else
                busy = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "seatbelt",
                    duration = 12000,
                    label = "Sıkı Kemer Takılıyor",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                    ESX.ShowNotification("Kemer Bağlandı", "success")
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'tak', 0.5)
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    seatbelt = true
                    busy = false
                    end
                end)
                busy = false
            end
        else
            seatbelt = not seatbelt
            if seatbelt then
                ESX.ShowNotification("Kemer Bağlandı", "success")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'tak', 0.5)
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
            else
                ESX.ShowNotification("Kemer Çıkarıldı", "error")
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                TriggerEvent('InteractSound_CL:PlayOnOne', 'cikar', 0.5)
            end
        end
        lastsikiKemer = sikiKemer
    end
end, false)


RegisterCommand("cruise", function()
    if driverSeat and engineRunning then
        if not cruiseIsOn and vehIsMovingFwd then
            ESX.ShowNotification("Hız Sabitleyici Aktif", "success")
            cruiseSpeed = prevSpeed
            cruiseIsOn = not cruiseIsOn
        elseif cruiseIsOn then
            ESX.ShowNotification("Hız Sabitleyici Pasif", "error")
            cruiseIsOn = not cruiseIsOn
        end
    end
end, false)



Citizen.CreateThread(function()

    while true do

        local time = 1000

        if isLoggedIn then

            if inVehicle then

                time = 1

                engineRunning = GetIsVehicleEngineRunning(vehicle)

                prevSpeed = curSpeed

                curSpeed =  GetEntitySpeed(vehicle)

                vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0

                if sikiKemer and seatbelt then DisableControlAction(0, 75) else EnableControlAction(0, 75) end  -- Sıkı Kemer Engel

                vehAcc = (prevSpeed - curSpeed) / GetFrameTime() > 981

                if not seatbelt then

                    if vehIsMovingFwd and prevSpeed*3.6 > 80 and vehAcc then

                        ejectPlayer()

                        tyreBrustSet(math.random(1, 2) == 1 and true or false)

                    else

                        prevVelocity = GetEntityVelocity(vehicle)

                    end

                end



                if not GetPedConfigFlag(playerPed, 184, 1) then SetPedConfigFlag(playerPed, 184, true) end

                if GetIsTaskActive(playerPed, 165) then

                    if GetSeatPedIsTryingToEnter(playerPed) == -1 then

                        if GetPedConfigFlag(playerPed, 184, 1) then

                            SetPedIntoVehicle(playerPed, vehicle, 0)

                            SetVehicleCloseDoorDeferedAction(vehicle, 0)

                        end

                    end

                end

 

                -- When playerPed in driver seat, handle cruise control

                if driverSeat and engineRunning then

                    if IsEntityInAir(vehicle) then

                        DisableControlAction(2, 59)

                        DisableControlAction(2, 60)

                    end



                    local cruiseOn = cruiseIsOn and cruiseSpeed or tekerPatlak and 50.0

                    if not VehicleNormalMaxSpeed and not cruiseOn then

                        VehicleNormalMaxSpeed = true

                        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")

                        SetEntityMaxSpeed(vehicle, maxSpeed)

                    elseif cruiseOn and VehicleNormalMaxSpeed  then

                        VehicleNormalMaxSpeed = false

                        maxSpeed = cruiseOn

                    end

                    

                    if prevSpeed > maxSpeed then

                        SetEntityMaxSpeed(vehicle, prevSpeed-0.5)

                    end



                    if vehicleClass ~= 13 and vehicleClass ~= 8 and vehicleClass ~= 14 then

                        if vehIsMovingFwd and vehAcc then

                            if prevSpeed*3.6 > 140.0 then

                                TriggerEvent("iens:motortamiret", vehicle, 10.0)

                                tyreBrustSet(math.random(1, 2) == 1 and true or false)

                                local seatPlayerId = {}

                                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do

                                    if i ~= 1 then

                                        if not IsVehicleSeatFree(vehicle, i-2) then 

                                            local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 

                                            local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)

                                            local playerServerId = GetPlayerServerId(playerHandle)

                                            table.insert(seatPlayerId, playerServerId)

                                        end

                                    end

                                end

                                

                                if #seatPlayerId > 0 then

                                    TriggerServerEvent("ryder-hud:car:eject-other-player-car", seatPlayerId, prevVelocity)

                                end

                                ejectPlayer()

                            end

                        end

                    end



                    if IsVehicleTyreBurst(vehicle, 0) or IsVehicleTyreBurst(vehicle, 1) or IsVehicleTyreBurst(vehicle, 4) or IsVehicleTyreBurst(vehicle, 5) then 

                        tekerPatlak = true

                    else

                        tekerPatlak = false

                    end



                    prevVelocity = GetEntityVelocity(vehicle)

                else

                    cruiseIsOn = false

                end



            else

                inVehicle = false

                cruiseIsOn = false

                vehAcc = false

                seatbelt = false

                prevSpeed = 0

                vehIsMovingFwd = false

                curSpeed = 0

            end

        end

        Citizen.Wait(time)

    end

end)



function tyreBrustSet(engine)

    local lastVehicle = GetPlayersLastVehicle(playerPed)

    local RastgeleTeker = (math.random(1,4))

    if RastgeleTeker == 1 then

        SetVehicleTyreBurst(lastVehicle, 0, 1, 100.0)

    elseif RastgeleTeker == 2 then

        SetVehicleTyreBurst(lastVehicle, 0, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 4, 1, 100.0)

    elseif RastgeleTeker == 3 then

        SetVehicleTyreBurst(lastVehicle, 0, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 1, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 4, 1, 100.0)

    elseif RastgeleTeker == 4 then

        SetVehicleTyreBurst(lastVehicle, 0, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 1, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 4, 1, 100.0)

        SetVehicleTyreBurst(lastVehicle, 5, 1, 100.0)

    end

    if engine then TriggerEvent("iens:motortamiret", lastVehicle, 10.0) end

end



function ejectPlayer()

    if not sikiKemer then 

        local position = GetEntityCoords(playerPed)

        SetEntityCoords(playerPed, position.x, position.y, position.z - 0.47, true, true, true)

        SetEntityVelocity(playerPed, prevVelocity.x, prevVelocity.y, prevVelocity.z)

        Citizen.Wait(1)

        SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)

        Citizen.Wait(1000)

        if math.random(1, 3) == 1 then SetEntityHealth(playerPed, 0) end

    end

end



RegisterNetEvent("CarFuelAlarm")

AddEventHandler("CarFuelAlarm",function()

    if not alarmset then

        alarmset = true

        local i = 5

        TriggerEvent("DoLongHudText", "Low fuel.",1)

        while i > 0 do

            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)

            i = i - 1

            Citizen.Wait(300)

        end

        Citizen.Wait(60000)

        alarmset = false

    end

end)



function degreesToIntercardinalDirection()

    local playerHeadingDegrees = 360.0 - GetEntityHeading(playerPed)

    local dgr = playerHeadingDegrees - 180 / 2

	local dgr = dgr % 360.0

	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then

		return "KD"

	elseif dgr >= 22.5 and dgr < 67.5 then

		return "D"

	elseif dgr >= 67.5 and dgr < 112.5 then

		return "GD"

	elseif dgr >= 112.5 and dgr < 157.5 then

		return "G"

	elseif dgr >= 157.5 and dgr < 202.5 then

		return "GB"

	elseif dgr >= 202.5 and dgr < 247.5 then

		return "B"

	elseif dgr >= 247.5 and dgr < 292.5 then

		return "KB"

	elseif dgr >= 292.5 and dgr < 337.5 then

		return "K"

	end

end