local currentTattoos, cam, CurrentActionData = {}, -1, {}
local HasAlreadyEnteredMarker, CurrentAction, CurrentActionMsg
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local eskiSkin = {}


AddEventHandler('qb-clothing:client:loadPlayerClothing', function()
	Wait(5000)
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
				print(v.collection)
			end
			currentTattoos = tattooList
		end
	end)
end)




function OpenShopMenu()
	local elements = {}

	for k,v in pairs(Config.TattooCategories) do
		table.insert(elements, {label= v.name, value = v.value})
	end

	if DoesCamExist(cam) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
	end
 
	local ped = PlayerPedId()
	eskiSkin.ust = GetPedDrawableVariation(ped, 8)
	eskiSkin.ust_t = GetPedTextureVariation(ped, 8)
	eskiSkin.ceket = GetPedDrawableVariation(ped, 11)
	eskiSkin.ceket_t = GetPedTextureVariation(ped, 11)
	eskiSkin.pantol = GetPedDrawableVariation(ped, 4)
	eskiSkin.pantol_t = GetPedTextureVariation(ped, 4)
	eskiSkin.kol = GetPedDrawableVariation(ped, 5)
	eskiSkin.kol_t = GetPedTextureVariation(ped, 5)
 

	  if IsMpPed(ped) == "Male" then
		SetPedComponentVariation(ped, 11, 252, 0, 2)
		SetPedComponentVariation(ped, 4, 18, 7, 2) -- DON
	  else 
		SetPedComponentVariation(ped, 11, 74, 0, 2)
		SetPedComponentVariation(ped, 4, 18, 7, 2) -- DON
	  end
	  
	  SetPedComponentVariation(ped, 8, 15, 2, 2)
	  SetPedComponentVariation(ped, 3, 15, 0, 2)
	  SetPedComponentVariation(ped, 10, 0, 0, 2)
 
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop', {
		title    = _U('tattoos'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local currentLabel, currentValue = data.current.label, data.current.value

		if data.current.value then
			elements = {{label = _U('go_back_to_menu'), value = nil}}

			for k,v in pairs(Config.TattooList[data.current.value]) do
				table.insert(elements, {
					label = _U('tattoo_item', k, _U('money_amount', ESX.Math.GroupDigits(v.price))),
					value = k,
					price = v.price
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				title    = _U('tattoos') .. ' | '..currentLabel,
				align    = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				local price = data2.current.price
				if data2.current.value ~= nil then

					ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
						if success then
							table.insert(currentTattoos, {collection = currentValue, texture = data2.current.value})
						end
					end, currentTattoos, price, {collection = currentValue, texture = data2.current.value})

				else
					OpenShopMenu()
					RenderScriptCams(false, false, 0, 1, 0)
					DestroyCam(cam, false)
					cleanPlayer()
				end

			end, function(data2, menu2)
				menu2.close()
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
				setPedSkin()
			end, function(data2, menu2) -- when highlighted
				if data2.current.value ~= nil then
					drawTattoo(data2.current.value, currentValue)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
		setPedSkin()
		SetPedComponentVariation(ped, 8, eskiSkin.ust, eskiSkin.ust_t, 2)
		SetPedComponentVariation(ped, 11, eskiSkin.ceket, eskiSkin.ceket_t, 2)
		SetPedComponentVariation(ped, 4, eskiSkin.pantol, eskiSkin.pantol_t, 2)
		SetPedComponentVariation(ped, 5, eskiSkin.kol, eskiSkin.kol_t, 2)
	end)
end

function IsMpPed(ped)
	local Male = GetHashKey("mp_m_freemode_01") local Female = GetHashKey("mp_f_freemode_01")
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == Male then return "Male" elseif CurrentModel == Female then return "Female" else return false end
end



-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v, true) < 2) then
				DrawMarker(Config.Type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				DrawText3D(v.x, v.y, v.z + 0.1, '~r~E~r~ - Dövmeci')
				if IsControlJustReleased(0, 38) then 
					OpenShopMenu()
				end

				letSleep = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone, LastZone

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v, true) < Config.Size.x then
				isInMarker  = true
				currentZone = 'TattooShop'
				LastZone    = 'TattooShop'
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_tattooshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_tattooshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('esx_tattooshop:hasEnteredMarker', function(zone)
	if zone == 'TattooShop' then
		CurrentAction     = 'tattoo_shop'
		CurrentActionMsg  = _U('tattoo_shop_prompt')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('esx_tattooshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'tattoo_shop' then
					OpenShopMenu()
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function setPedSkin()
 
	Citizen.Wait(1000)

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

function drawTattoo(current, collection)
	SetEntityHeading(PlayerPedId(), 297.7296)
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end

 

	ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(Config.TattooList[collection][current].nameHash))

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
		SetCamRot(cam, 0.0, 0.0, 0.0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
	end

	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

	SetCamCoord(cam, x + Config.TattooList[collection][current].addedX, y + Config.TattooList[collection][current].addedY, z + Config.TattooList[collection][current].addedZ)
	SetCamRot(cam, 0.0, 0.0, Config.TattooList[collection][current].rotZ)
end

function cleanPlayer()
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

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
