-- Barbie was here --
local Keys = {
	["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57
  }
  
  local PlayerData              = {}
  local HasAlreadyEnteredMarker = false
  local LastZone                = nil
  local CurrentAction           = nil
  local CurrentActionMsg        = ''
  local CurrentActionData       = {}
  local Blips                   = {}
  
  local isCarry 				  = false
  local isKucak 				  = false
  local hasRope 				  = true
  local hasUsedRope 			= true
  
  ESX                     = nil
  
  Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	end
  end)
  
  
  function OpenActionMenuInteraction(target)
  
	  local elements = {}
  
	  table.insert(elements, {label = ('Kucakla'), value = 'drag'})
	  table.insert(elements, {label = ('Omzuna Al'), value = 'omuzla'})
	  table.insert(elements, {label = ('Menüden Çık'), value = 'menu.close()'})
	  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'action_menu',
		  {
			  title    = ('Kucakla'),
			  align    = 'top-left',
			  elements = elements
		  },
	  function(data, menu)
  
		  local player, distance = ESX.Game.GetClosestPlayer()
  
		  ESX.UI.Menu.CloseAll()	
		  
		  if data.current.value == 'drag' then			
			  TriggerServerEvent('esx_barbie_lyftupp:checkRope')
			  if isKucak == false then
				exports['swt_notifications']:Info("Kucaklama/Omuzlama","Kişiyi kucağına alıyorsun!","top",2000,true)
				  isKucak2 = true;
			  elseif isKucak == true then
				exports['swt_notifications']:Info("Kucaklama/Omuzlama","Kişiyi kucağından indiriyorsun!","top",2000,true)
  
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
					exports['swt_notifications']:Negative("Kucaklama/Omuzlama","Yakında oyuncu yok!","top",2000,true)
  
					  isKucak = false;
				  end
			  end
			  menu.close()
		  end
  
		  if data.current.value == 'omuzla' then			
			  TriggerServerEvent('esx_omuzlama:checkRope')
			  if isKucak == false then
				exports['swt_notifications']:Info("Kucaklama/Omuzlama","Kişiyi omuzuna alıyorsun!","top",2000,true)
  
				  isKucak = true;
			  elseif isKucak == true then
				exports['swt_notifications']:Info("Kucaklama/Omuzlama","Kişiyi omuzdan indiriyorsun!","top",2000,true)
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
			  menu.close()
		  end
  
  
	end)
  
  
  
  
  end
  
  function LoadAnimationDictionary(animationD)
	  while(not HasAnimDictLoaded(animationD)) do
		  RequestAnimDict(animationD)
		  Citizen.Wait(1)
	  end
  end
  
  RegisterNetEvent('esx_barbie_lyftupp:upplyft')
  AddEventHandler('esx_barbie_lyftupp:upplyft', function(target)
	  local playerPed = GetPlayerPed(-1)
	  local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	  local lPed = GetPlayerPed(-1)
	  local dict = "amb@code_human_in_car_idles@low@ps@"
	  
	  if isCarry == false then
		  LoadAnimationDictionary("amb@code_human_in_car_idles@generic@ps@base")
		  TaskPlayAnim(lPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
		  
		  AttachEntityToEntity(GetPlayerPed(-1), targetPed, 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)
		  
		  isCarry = true
	  else
		  DetachEntity(GetPlayerPed(-1), true, false)
		  ClearPedTasksImmediately(targetPed)
		  ClearPedTasksImmediately(GetPlayerPed(-1))
		  
		  isCarry = false
	  end
  end)
  
  RegisterNetEvent('esx_omuzlama:upplyft')
  AddEventHandler('esx_omuzlama:upplyft', function(target)
	  local playerPed = GetPlayerPed(-1)
	  local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	  local lPed = GetPlayerPed(-1)
	  local dict = "nm"
	  
	  if isCarry == false then
		  
		  LoadAnimationDictionary("nm")
		  TaskPlayAnim(lPed, "nm", "firemans_carry", 8.0, -8, -1, 33, 0, 0, 40, 0)	
		  AttachEntityToEntity(GetPlayerPed(-1), targetPed, 9816, 0.23, 0.10, 0.58, 0.9, 0.30, 370.0, false, false, false, false, 2, false)
		  
		  isCarry = true
	  else
		  DetachEntity(GetPlayerPed(-1), true, false)
		  ClearPedTasksImmediately(targetPed)
		  ClearPedTasksImmediately(GetPlayerPed(-1))
		  
		  
		  isCarry = false
	  end
  end)
  
  

  
  RegisterNetEvent('esx_barbie_lyftupp')
  AddEventHandler('esx_barbie_lyftupp', function()
	OpenActionMenuInteraction()
  end)
  
  RegisterNetEvent('hir:openmenu')
  AddEventHandler('hir:openmenu', function()
	  OpenActionMenuInteraction()
  end)