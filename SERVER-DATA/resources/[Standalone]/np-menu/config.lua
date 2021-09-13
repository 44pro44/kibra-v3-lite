local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isCarry 				  = false
local isKucak 				  = false
local hasRope 				  = true
local hasUsedRope 			= true
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isLSCustom = false 
local isBenny = false
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local PlayerData = {}
ESX                           = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('kibra-kamu');
AddEventHandler('kibra-kamu', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        SendToCommunityService(GetPlayerServerId(closestPlayer))
    end
end)


function SendToCommunityService(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
		title = "Kamu Menüsü",
	}, function (data2, menu)
		local community_services_count = tonumber(data2.value)
		
		if community_services_count == nil then
			ESX.ShowNotification('Geçersiz Miktar')
		else
			TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("yg_blip:tatto")
AddEventHandler("yg_blip:tatto", function()
	TriggerEvent("turn:blip", 4)
end)

RegisterNetEvent("yg_blip:bank")
AddEventHandler("yg_blip:bank", function()
	TriggerEvent("turn:blip", 8)
end)

RegisterNetEvent("yg_blip:mechanic")
AddEventHandler("yg_blip:mechanic", function()
	TriggerEvent("turn:blip", 9)
end)

RegisterNetEvent("yg_blip:berber")
AddEventHandler("yg_blip:berber", function()
	TriggerEvent("turn:blip", 3)
end)

RegisterNetEvent("blipmotel")
AddEventHandler("blipmotel", function()
	TriggerEvent("turn:blip", 11)
end)

RegisterNetEvent("garajblip")
AddEventHandler("garajblip", function()
	TriggerEvent("turn:blip", 2)
end)

RegisterNetEvent("yg_blip:gas")
AddEventHandler("yg_blip:gas", function()
	TriggerEvent("turn:blip", 6)
end)

RegisterNetEvent("yg_blip:kiyafet")
AddEventHandler("yg_blip:kiyafet", function()
	TriggerEvent("turn:blip", 5)
end)

RegisterNetEvent("yg_blip:market")
AddEventHandler("yg_blip:market", function()
	TriggerEvent("turn:blip", 1)
end)

RegisterNetEvent("yg_blip:gang")
AddEventHandler("yg_blip:gang", function()
	TriggerEvent("turn:blip", 7)
end)

RegisterNetEvent("yg_blip:motels")
AddEventHandler("yg_blip:motels", function()
	TriggerEvent("turn:blip", 10)
end)

RegisterNetEvent("yg_blip:garages")
AddEventHandler("yg_blip:garages", function()
	TriggerEvent("turn:blip", 2)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)ESX                           = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('st:menuimpound');
AddEventHandler('st:menuimpound', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if vehicle ~= nil then
        exports["aex-bar"]:taskBar(3500, "Araç Çekiliyor..")
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Citizen.Wait(10000)
        ClearPedTasks(playerPed)
        DeleteVehicle(vehicle)
        exports['mythic_notify']:SendAlert('success', 'Araba Çekildi.')
        Citizen.Wait(100)
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında Araba Yok.')
    end
end)

RegisterNetEvent('Kibra:ceza');
AddEventHandler('Kibra:ceza', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        OpenFineMenu(closestPlayer)
    end
end)

RegisterNetEvent('Kibra:cezasheriff');
AddEventHandler('Kibra:cezasheriff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        OpenFineMenuSheriff(closestPlayer)
    end
end)

function OpenFineMenu(player)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
	{
		title    = 'Ceza Kes',
		align    = 'top-left',
		elements = {
			{label = 'Trafik Cezaları', value = 0},
			{label = 'Küçük Cezalar',   value = 1},
			{label = 'Ortalama Cezalar', value = 2},
			{label = 'Önemli Cezalar',   value = 3}
		}
	}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)

end

function OpenFineCategoryMenu(player, category)

	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: green;"> $' .. fines[i].amount .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
		{
			title    = 'Ceza Kes',
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)

			local label  = data.current.fineLabel
			local amount = data.current.amount

			menu.close()

            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', label, amount)

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, category)

end


function OpenFineMenuSheriff(player)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
	{
		title    = 'Ceza Kes',
		align    = 'top-left',
		elements = {
			{label = 'Trafik Cezaları', value = 0},
			{label = 'Küçük Cezalar',   value = 1},
			{label = 'Ortalama Cezalar', value = 2},
			{label = 'Önemli Cezalar',   value = 3}
		}
	}, function(data, menu)
		OpenFineCategoryMenuSheriff(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenuSheriff(player, category)

	ESX.TriggerServerCallback('esx_sheriffjob:getFineList', function(fines)

		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: green;"> $' .. fines[i].amount .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
		{
			title    = 'Ceza Kes',
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)

			local label  = data.current.fineLabel
			local amount = data.current.amount

			menu.close()

            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_sheriff', label, amount)

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenuSheriff(player, category)
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, category)

end

RegisterNetEvent('idcard:goster')
AddEventHandler('idcard:goster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
    else
    exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('idcard:ehliyetgor')
AddEventHandler('idcard:ehliyetgor', function()
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
end)

RegisterNetEvent('idcard:ehliyetgoster')
AddEventHandler('idcard:ehliyetgoster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
    else
        exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('idcard:ruhsatgor')
AddEventHandler('idcard:ruhsatgor', function()
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'license')
end)

RegisterNetEvent('idcard:ruhsatgoster')
AddEventHandler('idcard:ruhsatgoster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'license')
    else
        exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('anananam');
AddEventHandler('anananam', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent("kibra:omuz")
AddEventHandler("kibra:omuz", function()
    TriggerServerEvent('esx_omuzlama:checkRope')
    if isKucak == false then
      ESX.Notify("Omuzlama","Kişiyi Omzuna alıyorsun!",3000,"info")

        isKucak = true;
    elseif isKucak == true then
        ESX.Notify("Omuzlama","Kişiyi Omzundan indiriyorsun",3000,"info")
        isKucak = false
    end

    TriggerServerEvent('esx_omuzlama:lyfteruppn', GetPlayerServerId(player))
    Citizen.Wait(1000)
    if hasRope == true then
        local dict = "missfinale_c2mcs_1"
        
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        
        local player, distance = ESX.Game.GetClosestPlayer()
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        
        if distance ~= -1 and distance <= 3.0 then
            local closestPlayer, distance = ESX.Game.GetClosestPlayer()
            TriggerServerEvent('esx_omuzlama:lyfter', GetPlayerServerId(closestPlayer))		
            
            TaskPlayAnim(GetPlayerPed(-1), dict, "fin_c2_mcs_1_camman", 8.0, 8.0, -1, 50, 0, false, false, false)
            isCarry = true
        else
          exports['swt_notifications']:Warning("Kucaklama/Omuzlama","Yakında oyuncu yok!","top",2000,true)

            isKucak = false;

        end
    else
        exports['swt_notifications']:Warning("Kucaklama/Omuzlama","Halatın yok!","top",2000,true)


        isKucak = false;

end
end)

RegisterNetEvent('CanlandirRevive');
AddEventHandler('CanlandirRevive', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.0 then
        exports['mythic_notify']:SendAlert('error', 'Yakında Kimse Yok.')
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            if quantity > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)

                if IsPedDeadOrDying(closestPlayerPed, 1) then
                    local playerPed = PlayerPedId()


                    local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

                    for i=1, 15, 1 do
                        Citizen.Wait(900)
                
                        ESX.Streaming.RequestAnimDict(lib, function()
                            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                        end)
                    end

                    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                    TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                else
                    exports['mythic_notify']:SendAlert('inform', 'Kişinin Kritik Durumu Yok.')
                end
            else
                exports['mythic_notify']:SendAlert('error', 'İlk Yardım Kitin Yok.')
            end

        end, 'medikit')
    end
end)
RegisterNetEvent("Kibra:BuyukTedavi")
AddEventHandler("Kibra:BuyukTedavi", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.0 then
        exports['mythic_notify']:SendAlert('error', 'Yakında Kimse Yok.')
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            if quantity > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(closestPlayerPed)

                if health > 0 then
                    local playerPed = PlayerPedId()

                    IsBusy = true
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    Citizen.Wait(10000)
                    ClearPedTasks(playerPed)

                    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                    TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                    IsBusy = false
                else
                    exports['mythic_notify']:SendAlert('inform', 'Kişinin Kritik Durumu Yok.')
                end
            else
                exports['mythic_notify']:SendAlert('error', 'İlk Yardım Kitin Yok.')
            end
        end, 'medikit')
    end
end)

RegisterNetEvent("Kibra:SmallTedavi")
AddEventHandler("Kibra:SmallTedavi", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.0 then
        exports['mythic_notify']:SendAlert('error', 'Yakında Kimse Yok.')
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            if quantity > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(closestPlayerPed)

                if health > 0 then
                    local playerPed = PlayerPedId()

                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    Citizen.Wait(10000)
                    ClearPedTasks(playerPed)

                    TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                    TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                else
                    exports['mythic_notify']:SendAlert('inform', 'Kişi Sağlıklı Gözüküyor.')
                end
            else
                exports['mythic_notify']:SendAlert('error', 'Bandajın Yok.')
            end
        end, 'bandage')
    end
end)

RegisterNetEvent('esx_policejob:TasiBro');
AddEventHandler('esx_policejob:TasiBro', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent("melepcele")
AddEventHandler("melepcele", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(PlayerPedId())
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(PlayerPedId())
    local target_id = GetPlayerServerId(target)
    print(distance)
    if distance <= 2.0 then
        if distance == -1 then
            ESX.Notify("Bulunamadı!","Yakında Oyuncu Yok!",3000,"error")
        else
            TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
        end
    else
        ESX.Notify("Bulunamadı!","Yakında Oyuncu Yok!",3000,"error")
    end
end)

RegisterNetEvent("esx_policejob:kelepceCoz")
AddEventHandler("esx_policejob:kelepceCoz", function()
local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(PlayerPedId())
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(PlayerPedId())
    local target_id = GetPlayerServerId(target)
    print(distance)
    if distance <= 2.0 then
        if distance == -1 then
            exports.pNotify:SendNotification({text = "Yakınında Oyuncu Yok!", type = "error", timeout = math.random(1000, 4000)})
        else
            TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
        end
    else
        exports.pNotify:SendNotification({text = "Yakınında Oyuncu Yok!", type = "error", timeout = math.random(1000, 4000)})
    end
end)

RegisterNetEvent("esx_policejob:kelepcele")
AddEventHandler("esx_policejob:kelepcele", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(PlayerPedId())
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(PlayerPedId())
    local target_id = GetPlayerServerId(target)
    print(distance)
    if distance <= 2.0 then
        if distance == -1 then
            ESX.Notify("Bulunamadı!","Yakında Oyuncu Yok!",3000,"error")
        else
            TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
        end
    else
        ESX.Notify("Bulunamadı!","Yakında Oyuncu Yok!",3000,"error")
    end
end)

RegisterNetEvent('kibra:kucak')
AddEventHandler('kibra:kucak', function()
    TriggerServerEvent('esx_barbie_lyftupp:checkRope')
			  if isKucak == false then
                ESX.Notify("Kucaklama/Omuzlama","Kişiyi Kucağına Alıyorsun!",3000,"info")
				  isKucak2 = true;
			  elseif isKucak == true then
                ESX.Notify("Kucaklama/Omuzlama","Kişiyi Kucağından indiriyorsun",3000,"info")
  
				  isKucak2 = false
			  end
			  TriggerServerEvent('esx_barbie_lyftupp:lyfteruppn', GetPlayerServerId(player))
			  Citizen.Wait(1000)
			  if hasRope == true then
				  local dict = "anim@heists@box_carry@"
				  
				  RequestAnimDict(dict)
				  while not HasAnimDictLoaded(dict) do
					  Citizen.Wait(100)
				  end
				  
				  local player, distance = ESX.Game.GetClosestPlayer()
				  local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
				  
				  if distance ~= -1 and distance <= 3.0 then
					  local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					  TriggerServerEvent('esx_barbie_lyftupp:lyfter', GetPlayerServerId(closestPlayer))		
					  
					  TaskPlayAnim(GetPlayerPed(-1), dict, "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
					  isCarry = true
				  else
                    ESX.Notify("Kucaklama/Omuzlama","Yakında kimse yok",3000,"error")
					  isKucak = false;
				  end
			  end
end)

RegisterNetEvent('esx_policejob:AractanCikar');
AddEventHandler('esx_policejob:AractanCikar', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent("esx_policejob:AracaKoy")
AddEventHandler("esx_policejob:AracaKoy", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
        ESX.Notify("Bulunamadı!","Yakında Oyuncu Yok!",3000,"error")
    else
           TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local isJudge = false
local isPolice = false
local isSheriff = false
local isMedic = false
local isDoctor = false
local isNews = false
local isTaksi = false
local isMechanic = false
local isMechanic3 = false
local isBenny = false
local isDead = false
local isInstructorMode = false
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local HandcuffTimer = {}


rootMenuConfig =  {
    {
        id = "general",
        displayName = "Blip Ayarları",
        icon = "#k9-huntfind",
        enableMenu = function()

            return not isDead 
        end,
        subMenus = {"blips:berber","blips:dovmeci", "blips:banka", "blips:market1", "blips:mechanic1", "blips:kiyafetci", "blips:motels", "blips:garages"}
    },
    {
        id = "general",
        displayName = "Genel",
        icon = "#globe-europe",
        enableMenu = function()

            return not isDead 
        end,
        subMenus = {"bilgiler", "emsihbar" }
    },
    {
        id = "vatandas",
        displayName = "Sivil",
        icon = "#vatandas",
        enableMenu = function()

            return not isDead 
        end,
        subMenus = {  "carry:omzundatasi","carry:kucagindatasi", "elkoy", "ustunuara"}
    },

    {
        id = "police-action",
        displayName = "Polis Eylemleri",
        icon = "#police-action",
        enableMenu = function()

            return  (isPolice and not isDead)
            
        end,
    
        subMenus = {"police:hapisegonder", "gsr", "police:bill", "police:frisk", "kelepcecoz", "police:ara" , "police:tasi","police:aracakoy", "police:aractancıkar", "policearac:kilitac", "policearac:aracbagla", "policearac:aracinfo", "policearac:radarac" ,"SilahBulundurmaLisans", "SilahTasimaLisans", "AvciLisans","LisansBak", "ShowPlayerLicense"}
    },
    {
        id = "police-action",
        displayName = "Şerif Eylemleri",
        icon = "#police-action",
        enableMenu = function()

            return  (isSheriff and not isDead)
            
        end,
    
        subMenus = {"police:hapisegonder", "gsr", "sheriff:bill", "police:frisk", "kelepcecoz", "police:ara" , "police:mdt","police:aracakoy", "police:aractancıkar", "policearac:kilitac", "policearac:aracbagla", "policearac:aracinfo", "policearac:radarac" ,"SilahBulundurmaLisans", "SilahTasimaLisans", "AvciLisans","LisansBak", "ShowPlayerLicense"}
    },
    {
        id = "emsaction",
        displayName = "Doktor",
        icon = "#ambulance",
        enableMenu = function()
            return (isMedic and not isDead)
        end,
        subMenus = { "ems:tedavi", "ems:kucukyaralar", "ems:buyukyaralar", "ems:aracakoy", "ems:aractancıkar", "general:escort","ems:kucagindatasi" }

    },
    {
        id = "animations",
        displayName = "Animasyonlar",
        icon = "#walking",
        functionName = "dp:RecieveMenu",

        enableMenu = function()
            return not isDead
        end,
    },
    -- {
    --     id = "expressions",
    --     displayName = "Giyim",
    --     icon = "#expressions",
    --     enableMenu = function()
    --         return not isDead
    --     end,
    --     subMenus = { "giyim:normal", "giyim:maske","giyim:giyin", "giyim:kask", "giyim:canta", "giyim:pantolon", "giyim:ayakkabı"}
    -- },
    {
        id = "giysi-dukkan",
        displayName = "Kıyafet Dukkanı",
        icon = "#kiyafetci",
        functionName = "qb-clothing:open",
        enableMenu = function()
            local data = exports["qb-clothing"]:checkclothe()
            local clot, ber = data[1], data[2]
            return not IsPedInAnyVehicle(PlayerPedId()) and clot
        end
    },
    {
        id = "jagen-inventory",
        displayName = "Dövmeci",
        icon = "#dovmecix",
        functionName = "qb-clothing:open",
        enableMenu = function()
            local data = exports["qb-clothing"]:checkclothe()
            local clot, ber = data[1], data[2]
            return not IsPedInAnyVehicle(PlayerPedId()) and clot
        end
    },
    {
        id = "berber-dukkan",
        displayName = "Berber Dukkanı",
        icon = "#berberx",
        functionName = "qb-clothing:open",
        enableMenu = function()
            local data = exports["qb-clothing"]:checkclothe()
            local clot, ber = data[1], data[2]
            return not IsPedInAnyVehicle(PlayerPedId()) and ber and not isDead
        end
    },
    {
        id = "mechanic",
        displayName = "LS Custom Mekanik",
        icon = "#mekanik",
        enableMenu = function()
            return  (isMechanic and not isDead )
        end,
        subMenus = { "mekanik:faturakes", "mekanik:kilit", "mekanik:tamir", "mekanik:temizlik", "mekanik:aracbagla", "mekanik:flatbed"}
    },
    {
        id = "mechanic",
        displayName = "Benny Mekanik",
        icon = "#mekanik",
        enableMenu = function()
            return  (isBenny and not isDead )
        end,
        subMenus = { "mekanik:faturakes", "mekanik:kilit", "mekanik:tamir", "mekanik:temizlik", "mekanik:aracbagla", "mekanik:flatbed"}
    },

    -- {
    --     id = "weazel",
    --     displayName = "Haberci Eşyaları",
    --     icon = "#prop-list",
    --     enableMenu = function()
    --         return (PlayerData.job.name == 'reporter' and not isDead)
    --     end,
    --     subMenus = {  "props:delete", "props:background", "props:spotlight", "props:fence" }
    -- },
    -- {
    --     id = "doc-prop",
    --     displayName = "Doktor Eşyaları",
    --     icon = "#prop-list",
    --     enableMenu = function()
    --         return (PlayerData.job.name == 'ambulance' and not isDead)
    --     end,
    --     subMenus = {  "props:delete", "props:medbag", "props:medbox" }
    -- },
    {
        id = "mech",
        displayName = "Mekanik Eşyaları",
        icon = "#prop-list",
        enableMenu = function()
            return (PlayerData.job.name == 'mechanic' and not isDead)
        end,
        subMenus = {  "props:delete", "props:carbattery", "props:tire", "props:mechtable", "props:mechbag", "props:tampon", "props:cardoor", "props:carbonnet", "props:hidrolik", "props:koni" }
    },
    {
        id = "taksi",
        displayName = "Taksi",
        icon = "#vehicle-options-vehicle",
        enableMenu = function()
            return  ( isTaksi and not isDead )
        end,
        subMenus = { "taxi:taksimetre", "taxi:fatura","taxi:taksimetrekapat" }
    },
    {
        id = "vehicle",
        displayName = "Araç Menüsü",
        icon = "#vehicle-options-vehicle",
        functionName = "AcSesiAc",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "vehicle",
        displayName = "Yan Koltuk",
        icon = "#vehicle-options-vehicle",
        functionName = "SeatShuffle",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },


    {
        id = "kimlik",
        displayName = "Kimlik",
        icon = "#blips",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"idcard:goster", "idcard:gor", "idcard:ehliyetgor", "idcard:ehliyetgoster", "idcard:ruhsatgoster", "idcard:ruhsatgor"}
    },



}

newSubMenus = {
    ['idcard:gor'] = {
        title = "Kimlik Gör",
        icon = "#id-card-symbol-v3",
        functionName = "idcard:gor"
    },    
    ['idcard:goster'] = {
        title = "Kimlik Göster",
        icon = "#id-card-symbol-v3",
        functionName = "idcard:goster"
    },  
    ['idcard:ehliyetgoster'] = {
        title = "Ehliyet Göster",
        icon = "#id-card-symbol-v2",
        functionName = "idcard:ehliyetgoster"
    },
    ['idcard:ehliyetgor'] = {
        title = "Ehliyet Gör",
        icon = "#id-card-symbol-v2",
        functionName = "idcard:ehliyetgor"
    },  
    ['idcard:ruhsatgor'] = {
        title = "Silah Ruhsatı Gör",
        icon = "#police-vehicle-plate",
        functionName = "idcard:ruhsatgor"
    }, 
    ['idcard:ruhsatgoster'] = {
        title = "Silah Ruhsatı Göster",
        icon = "#police-vehicle-plate",
        functionName = "idcard:ruhsatgoster"
    },
    ['policearac:kilitac'] = {
        title = "Kilidi Aç",
        icon = "#kilitac",
        functionName = "AracKilit"
    },
    ['policearac:aracbagla'] = {
        title = "Araç Bağla",
        icon = "#policearac:aracbagla",
        functionName = "st:menuimpound"
    },
    ['blips:banka'] = {
        title = "Bankalar",
        icon = "#police-check-bank",
        functionName = "yg_blip:bank"
    },
    ['blips:mechanic1'] = {
        title = "Mekanikler",
        icon = "#police-vehicle",
        functionName = "yg_blip:mechanic"
    },
    
    ['blips:berber'] = {
        title = "Berber",
        icon = "#berberx",
        functionName = "yg_blip:berber"
    },
    ['blips:motels'] = {
        title = "Motel",
        icon = "#general-apart-givekey",
        functionName = "yg_blip:motels"
    },
    ['blips:garages'] = {
        title = "Garajlar",
        icon = "#policearac:aracbagla",
        functionName = "yg_blip:garages"
    },
    ['blips:gangs1'] = {
        title = "Ceteler",
        icon = "#gangblip",
        functionName = "yg_blip:gang"
    },
    ['blips:market1'] = {
        title = "Market",
        icon = "#marketaq",
        functionName = "esx-kr-advanced-shops:blipAcKapa"
    },
    ['blips:kiyafetci'] = {
        title = "Kıyafetçi",
        icon = "#kiyafetci",
        functionName = "yg_blip:kiyafet"
    },    		
    ['blips:dovmeci'] = {
        title = "Dövme",
        icon = "#dovmecix",
        functionName = "yg_blip:tatto"
    },
    ['ustunuara'] = {
        title = "Üstünü Ara",
        icon = "#police-ara",
        functionName = "police:client:RobPlayer"
    },
    ['kelepce'] = {
        title = "Kelepçele",
        icon = "#police-action-frisk",
        functionName = "cuffanim"
    },
    ['police:tasi'] = {
        title = "Taşı",
        icon = "#general-escort",
        functionName = "esx_policejob:TasiBro"
    },

    ['police:badge'] = {
        title = "Kimliğini Göster",
        icon = "#police-mdt",
        functionName = "idcard:goster"
    },
    ['police:hapisegonder'] = {
        title = "Kamuya Gönder",
        icon = "#jail",
        functionName = "kibra-kamu"
    },
    ['emsihbar'] = {
        title = "EMS İhbar",
        icon = "#ambulance",
        functionName = "emsihbar3"
    },
    -- ['policearac:radarac'] = {
    --     title = "Radarı Etkinleştir",
    --     icon = "#radar",
    --     functionName = "wk:radarRC"
    -- },
    ['SilahTasima'] = {
        title = " Taşıma Ruhsatı Ver",
        icon = "#kimlikgör",
        functionName = "SilahTasima"
    },
    ['BulundurmaRuhsati'] = {
        title = " Bulundurma Ruhsatı Ver",
        icon = "#kimlikgör",
        functionName = "BulundurmaRuhsati"
    },
    ['avruhsati'] = {
        title = "Avcı İzni ver",
        icon = "#kimlikgör",
        functionName = "avruhsati"
    },

    ['K9:cikar'] = {
        title = "Çıkar",
        icon = "#k9-spawn",
        functionName = "k9spawn"
    },
    ['K9:koy'] = {
        title = "İndir/Bindir",
        icon = "#k9-vehicle",
        functionName = "aracakoy"
    },
    ['K9:oturkalk'] = {
        title = "Otur/Kalk",
        icon = "#k9-sit",
        functionName = "oturkalk"
    },
    ['K9:saldir'] = {
        title = "Saldır",
        icon = "#k9-dismiss",
        functionName = "saldir"
    },
    ['K9:uyusturucuara'] = {
        title = "Koklat",
        icon = "#k9-sniff",
        functionName = "uyusturucuara"
    },


    ['police:bill'] = {
        title = "Ceza Kes",
        icon = "#police-bill",
        functionName = "Kibra:ceza"
    },
    ['sheriff:bill'] = {
        title = "Ceza Kes",
        icon = "#police-bill",
        functionName = "Kibra:ceza"
    },

    ['gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "gsr"
    },

    ['mekanik:faturakes'] = {
        title = "Fatura Kes",
        icon = "#police-bill",
        functionName = "kibra-mechanic:client:FaturaKes"
    },

    ['mekanik:kilit'] = {
        title = "Kilidi Aç",
        icon = "#kilitac",
        functionName = "kibra-mechanic:client:KapiAc"
    },

    ['mekanik:tamir'] = {
        title = "Tamir Et",
        icon = "#tamir",
        functionName = "kibra-mechanic:client:AracTamir"
    },

    ['mekanik:temizlik'] = {
        title = "Temizle",
        icon = "#temizle2",
        functionName = "kibra-mechanic:client:AracTemizle"
    },
    ['mekanik:aracbagla'] = {
        title = "Araç Bağla",
        icon = "#policearac:aracbagla",
        functionName = "kibra-mechanic:client:AracBagla"
    },
    ['mekanik:flatbed'] = {
        title = "Flatbed",
        icon = "#aracakoy",
        functionName = "kibra-mechanic:client:Dorse"
    },
    ['police:aracakoy'] = {
        title = "Araca Koy",
        icon = "#aracakoy",
        functionName = "esx_policejob:AracaKoy"
    },
   ['police:aractancıkar'] = {
        title = "Araçtan İndir",
        icon = "#police-aractancıkar",
        functionName = "esx_policejob:AractanCikar"
    },

    ['ems:aracakoy'] = {
        title = "Araca Koy",
        icon = "#aracakoy",
        functionName = "anananam"
    },

    ['ems:tedavi'] = {
        title = "Canlandır",
        icon = "#ilkyardim",
        functionName = "CanlandirRevive"
    },

    ['ems:kucukyaralar'] = {
        title = "Küçük Yaralar",
        icon = "#kucukyara",
        functionName = "Kibra:SmallTedavi"
    },

    ['ems:buyukyaralar'] = {
        title = "Büyük Yaralar",
        icon = "#buyukyara",
        functionName = "Kibra:BuyukTedavi"
    },

    ['ems:aractancıkar'] = {
        title = "Araçtan İndir",
        icon = "#police-aractancıkar",
        functionName = "kibra:araccikar"
    },
    ['police:ara'] = {
        title = "Üstünü Ara",
        icon = "#police-ara",
        functionName = "police:client:RobPlayerr"
    },

    ['taxi:fatura'] = {
        title = "Fatura Kes",
        icon = "#police-bill",
        functionName = "taxi:fatura"
    },
    ['bilgiler'] = {
        title = "Cüzdanını Gör",
        icon = "#aracbilgi",
        functionName = "bilgiler2"
    },

    ['taxi:taksimetre'] = {
        title = "Taksimetreyi Aç",
        icon = "#vehicle-options-vehicle",
        functionName = "taksimetre"
    },

    ['taxi:taksimetrekapat'] = {
        title = "Taksimetreyi Kapat",
        icon = "#aracbilgi",
        functionName = "taksimetre"
    },
    
    ['props:medbag'] = {
        title = "Med Çanta",
        icon = "#prop-medbag",
        functionName = "sup_props:medbag"
    },
    ['props:koni'] = {
        title = "Koni",
        icon = "#prop-koni",
        functionName = "sup_props:koni"
    },
    ['props:laptop'] = {
        title = "Laptop",
        icon = "#prop-laptop",
        functionName = "sup_props:laptop"
    },
    ['props:delete'] = {
        title = "Prop Sil",
        icon = "#prop-delete",
        functionName = "sup_props:propsil"
    },
    ['props:background'] = {
        title = "Arkaplan",
        icon = "#prop-background",
        functionName = "sup_props:background"
    },
    ['props:spotlight'] = {
        title = "Spotlight",
        icon = "#prop-spotlight",
        functionName = "sup_props:spotlight"
    },
    ['props:box'] = {
        title = "Kutu",
        icon = "#prop-box",
        functionName = "sup_props:box"
    },
    ['props:bag'] = {
        title = "Çanta",
        icon = "#prop-bag",
        functionName = "sup_props:bag"
    },
    ['props:carbattery'] = {
        title = "Batarya",
        icon = "#prop-battery",
        functionName = "sup_props:battery"
    },
    ['props:tire'] = {
        title = "Tekerlek",
        icon = "#prop-tire",
        functionName = "sup_props:tire"
    },
    ['props:table'] = {
        title = "Masa",
        icon = "#prop-table",
        functionName = "sup_props:table"
    },
    ['props:chair'] = {
        title = "Sandalye",
        icon = "#prop-chair",
        functionName = "sup_props:chair"
    },
    ['props:mechtable'] = {
        title = "Mekanik Masası",
        icon = "#prop-table",
        functionName = "sup_props:mechtable"
    },
    ['props:medbox'] = {
        title = "Med Kutusu",
        icon = "#prop-medbox",
        functionName = "sup_props:medbox"
    },
    ['props:fence'] = {
        title = "Bariyer",
        icon = "#prop-fence",
        functionName = "sup_props:fence"
    },
    ['props:mechbag'] = {
        title = "Alet Çantası",
        icon = "#prop-suitcase",
        functionName = "sup_props:mechbag"
    },
    ['props:tampon'] = {
        title = "Tampon",
        icon = "#prop-buffer",
        functionName = "sup_props:tampon"
    },
    ['props:cardoor'] = {
        title = "Araba Kapısı",
        icon = "#prop-door",
        functionName = "sup_props:cardoor"
    },
    ['props:carbonnet'] = {
        title = "Kaput",
        icon = "#prop-car",
        functionName = "sup_props:carbonnet"
    },
    ['props:hidrolik'] = {
        title = "Hidrolik",
        icon = "#prop-fence",
        functionName = "sup_props:hidrolik"
    },

    -- ['policearac:aracinfo'] = {
    --     title = "Araç Bilgisi",
    --     icon = "#aracbilgi",
    --     functionName = "VehicleInfo"
    -- },
    -- ['general:escort'] = {
    --     title = "Taşı",
    --     icon = "#general-escort",
    --     functionName = "st:escort"
    -- },

    ['carry:omzundatasi'] = {
        title = "Omzunda Taşı",
        icon = "#general-escort",
        functionName = "kibra:omuz"
    },

    ['carry:kucagindatasi'] = {
        title = "Kucağında Taşı",
        icon = "#police-action-frisk",
        functionName = "kibra:kucak"
    },

    ['ShowPlayerLicense'] = {
        title = "Lisanslara Bak",
        icon = "#police-action-frisk",
        functionName = "ShowPlayerLicense"
    },
    
    
    ['ems:kucagindatasi'] = {
        title = "Kucağında Taşı",
        icon = "#police-action-frisk",
        functionName = "kibra:kucak"
    },

    
    ['elkoy'] = {
        title = "Rehin Al",
        icon = "#rehinal",
        functionName = "Kibra:RehinAl"
    },

    ['kimlik:ehliyetbak'] = {
        title = "Ehliyetine Bak",
        icon = "#ehliyetgör",
        functionName = "ehliyetgör"
    },    
    ['kimlik:kimlikbak'] = {
        title = "Kimliğine Bak",
        icon = "#kimlikgör",
        functionName = "idcard:gor"
    },
    ['kimlik:ehliyetver'] = {
        title = "Ehliyetini Ver",
        icon = "#ehliyetgör",
        functionName = "ehliyetver"
    },    
    ['kimlik:kimlikver'] = {
        title = "Kimliğini Ver",
        icon = "#kimlikgör",
        functionName = "idcard:goster"
    },
    ['police:frisk'] = {
        title = "Kelepçele",
        icon = "#police-action-frisk",
        functionName = "esx_policejob:kelepcele"
    },

    ['kelepcecoz'] = {
        title = "Kelepçeyi Çöz",
        icon = "#police-action-frisk",
        functionName = "esx_policejob:kelepceCoz"
    },

    -- ['SilahBulundurmaLisans'] = {
    --     title = "Silah Bulundurma Lisansı Ver",
    --     icon = "#kimlikgör",
    --     functionName = "SilahBulundurmaLisans"
    -- },

    ['SilahTasimaLisans'] = {
        title = "Silah Taşıma Lisansı Ver",
        icon = "#kimlikgör",
        functionName = "SilahTasimaLisans"
    },
    
    ["giyim:kask"] = {
        title="Kask",
        icon="#giyim-kask",
        functionName = "kask"
        },
    ["giyim:maske"] = {
        title="Maske",
        icon="#giyim-maske",
        functionName = "maske",
    },
    ["giyim:canta"] = {
        title="Çanta",
        icon="#giyim-canta",
        functionName = "canta"
        },
    ["giyim:pantolon"] = {
        title="Pantolon",
        icon="#giyim-pantolon",
        functionName = "pantolon",
    },
    ["giyim:ayakkabı"] = {
        title="Ayakkabı",
        icon="#giyim-ayakkabı",
        functionName = "ayakkabı"
        },
    ["giyim:giyin"] = {
        title="Giyin",
        icon="#giyin-happy",
        functionName = "giyin"
        },

    ["giyim:normal"]  = {
        title="Tişört",
        icon="#giyim-tshirt",
        functionName = "tshirt"
    }
}

RegisterNetEvent('tshirt')
AddEventHandler('tshirt', function()  
    TriggerEvent('skinchanger:getSkin', function(skin)
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict('clothingshirt')
        while not HasAnimDictLoaded('clothingshirt') do
            Citizen.Wait(1)
        end

        TaskPlayAnim(playerPed, "clothingshirt", "check_out_b", 3.5, -8, -1, 49, 0, 0, 0, 0) 
        Citizen.Wait(3500)
        ClearPedTasks(playerPed)


        local clothesSkin = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 15, ['torso_2'] = 0,
        ['arms'] = 15, ['arms_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent("esx_policejob:putInVehicle")
AddEventHandler("esx_policejob:putInVehicle", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
        ESX.Notify("Kimse Yok!","Yakında Kimse Yok!",3000,"error")
    else
         TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
    end
end)


RegisterNetEvent('kibra:araccikar');
AddEventHandler('kibra:araccikar', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        TriggerServerEvent('esx_ambulancejob:OutVehicle', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('st:takeoutvehicle');
AddEventHandler('st:takeoutvehicle', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestDistance <= 2.0 then
        TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
    end
end)

    Citizen.CreateThread(function(job, name)
        while true do
    
            Citizen.Wait(0)

    if isMedic and job ~= "ems" then isMedic = false end
    if isPolice and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then isPolice = false end
    if isSheriff and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'sheriff' then isSheriff = false end
    if isTaksi and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'taxi' then isTaksi = false end
    if isMechanic and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'lscustom' then isMechanic = false end
    if isMechanic3 and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'mekanik3' then isMechanic3 = false end
    if isBenny and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'benny' then isBenny = false end

    if isDoctor and job ~= "doctor" then isDoctor = false end
    if isNews and job ~= "news" then isNews = false end
    if  ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then isPolice = true end
    if  ESX.PlayerData.job and ESX.PlayerData.job.name == 'sheriff' then isSheriff = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then isMedic = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then isTaksi = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'lscustom' then isMechanic = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mekanik3' then isMechanic3 = true end

    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'benny' then isBenny = true end


    if job == "news" then isNews = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then isDoctor = true end
        end
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)



function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end


RegisterNetEvent('maske')
AddEventHandler('maske', function()
    local playerPed = GetPlayerPed(-1)

    RequestAnimDict('misscommon@std_take_off_masks')
    while not HasAnimDictLoaded('misscommon@std_take_off_masks') do
        Citizen.Wait(1)
    end

    RequestAnimDict('mp_masks@on_foot')
    while not HasAnimDictLoaded('mp_masks@on_foot') do
        Citizen.Wait(1)
    end

    if not mask then
    mask = true
    MaskDrawable, MaskTexture, MaskPalette = GetPedDrawableVariation(playerPed, 1), GetPedTextureVariation(playerPed, 1), GetPedPaletteVariation(playerPed, 1)
    TaskPlayAnim(playerPed, "misscommon@std_take_off_masks", "take_off_mask_rps", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1000)
    SetPedComponentVariation(playerPed, 1, 0, 0, MaskPalette)
    ClearPedTasks(playerPed)
end
end)



RegisterNetEvent('kask')
AddEventHandler('kask', function() 
       local playerPed = GetPlayerPed(-1)

    RequestAnimDict('veh@common@fp_helmet@')
    while not HasAnimDictLoaded('veh@common@fp_helmet@') do
        Citizen.Wait(1)
    end

    RequestAnimDict('missheistdockssetup1hardhat@')
    while not HasAnimDictLoaded('missheistdockssetup1hardhat@') do
        Citizen.Wait(1)
    end

    if not hat then 
    hat = true
    HatDrawable, HatTexture = GetPedPropIndex(playerPed, 0), GetPedPropTextureIndex(playerPed, 0)
    TaskPlayAnim(playerPed, "veh@common@fp_helmet@", "take_off_helmet_stand", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(800)
    ClearPedProp(playerPed, 0)
    Citizen.Wait(400)
    ClearPedTasks(playerPed)
end
end)

    RegisterNetEvent('canta')
AddEventHandler('canta', function()  
    local playerPed = GetPlayerPed(-1)

    RequestAnimDict('missclothing')
    while not HasAnimDictLoaded('missclothing') do
        Citizen.Wait(1)
    end

    if not ryg then
    ryg = true
    rygDrawable, rygTexture, rygPalette = GetPedDrawableVariation(playerPed, 5), GetPedTextureVariation(playerPed, 5), GetPedPaletteVariation(playerPed, 5)
    TaskPlayAnim(playerPed, "missclothing", "wait_choice_a_storeclerk", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(3000)
    SetPedComponentVariation(playerPed, 5, 0, 0, rygPalette)
    ClearPedTasks(playerPed)
else 
    ryg = false
    TaskPlayAnim(playerPed, "missclothing", "wait_choice_a_storeclerk", 3.5, -8, -1, 49, 0, 0, 0, 0) 
    Citizen.Wait(3000)
    SetPedComponentVariation(playerPed, 5, rygDrawable, rygTexture, rygPalette)
    ClearPedTasks(playerPed)
end
end)


    RegisterNetEvent('tshirt')
AddEventHandler('tshirt', function()  
    TriggerEvent('skinchanger:getSkin', function(skin)
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict('clothingshirt')
        while not HasAnimDictLoaded('clothingshirt') do
            Citizen.Wait(1)
        end

        TaskPlayAnim(playerPed, "clothingshirt", "check_out_b", 3.5, -8, -1, 49, 0, 0, 0, 0) 
        Citizen.Wait(3500)
        ClearPedTasks(playerPed)


        local clothesSkin = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 15, ['torso_2'] = 0,
        ['arms'] = 15, ['arms_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)


RegisterNetEvent('AracBagla')
AddEventHandler('AracBagla', function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

     Citizen.Wait(10000)
     TriggerEvent('pogressBar:drawBar', 10000, 'Aracı bağlıyorsun.')

     ClearPedTasksImmediately(playerPed)

    if IsPedInAnyVehicle(playerPed, true) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    end

    if DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
        Citizen.Wait(10000)
    end
end)



RegisterNetEvent('pantolon')
AddEventHandler('pantolon', function() 
        TriggerEvent('skinchanger:getSkin', function(skin)

        local playerPed = GetPlayerPed(-1)

        RequestAnimDict('clothingtrousers')
        while not HasAnimDictLoaded('clothingtrousers') do
            Citizen.Wait(1)
        end
        TaskPlayAnim(playerPed, "clothingtrousers", "try_trousers_negative_a", 3.5, -8, -1, 49, 0, 0, 0, 0) 
        Citizen.Wait(3000)
        ClearPedTasks(playerPed)
        local clothesSkin = {
        ['pants_1'] = 21, ['pants_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

    RegisterNetEvent('ayakkabı')
AddEventHandler('ayakkabı', function() 
    TriggerEvent('skinchanger:getSkin', function(skin)
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict('clothingshoes')
        while not HasAnimDictLoaded('clothingshoes') do
            Citizen.Wait(1)
        end
        TaskPlayAnim(playerPed, "clothingshoes", "check_out_a", 3.5, -8, -1, 49, 0, 0, 0, 0) 
        Citizen.Wait(2500)
        ClearPedTasks(playerPed)

        local clothesSkin = {
        ['shoes_1'] = 34, ['shoes_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)


    RegisterNetEvent('giyin')
    AddEventHandler('giyin', function() 
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
        end)

end)

function AracKilit()
    local playerPed = PlayerPedId()

    local coords  = GetEntityCoords(playerPed)
  local  vehicle = ESX.Game.GetVehicleInDirection()

if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
    Citizen.Wait(20000)
    TriggerEvent('pogressBar:drawBar', 20000, 'Araç kilidini açıyorsun.')

    ClearPedTasksImmediately(playerPed)

    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    ESX.ShowNotification("Araç Açıldı")
end
end

RegisterNetEvent('AracKilit')
AddEventHandler('AracKilit', function()
AracKilit()

end)







function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end