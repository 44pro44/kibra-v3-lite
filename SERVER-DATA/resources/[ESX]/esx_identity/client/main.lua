local guiEnabled, hasIdentity, isDead = false, false, false
local myIdentity, myIdentifiers = {}, {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state
	})
end

RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	if not isDead then
		EnableGui(true)
	end
end)

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('escape', function(data, cb)
	if hasIdentity then
		EnableGui(false)
	else
		ESX.Notify("Başarılı!","Karakteriniz Başarılı Bir Şekilde Oluşturuldu!",3000,"success")
	end
end)

RegisterNUICallback('register', function(data, cb)
	local reason = ""
	myIdentity = data
	for theData, value in pairs(myIdentity) do
		if theData == "firstname" or theData == "lastname" then
			reason = verifyName(value)
			
			if reason ~= "" then
				break
			end
		elseif theData == "dateofbirth" then
			if value == "invalid" then
				ESX.Notify("Geçersiz!","Girdiğiniz Doğum Tarihi Değeri Geçersiz!",3000,"error")
				break
			end
		elseif theData == "height" then
			local height = tonumber(value)
			if height then
				if height > 200 or height < 140 then
					ESX.Notify("Geçersiz!","Girdiğiniz Boy Değeri Geçersiz!",3000,"error")
					break
				end
			else
				ESX.Notify("Geçersiz!","Girdiğiniz Boy Değeri Geçersiz!",3000,"error")
				break
			end
		end
	end
	
	if reason == "" then
		TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers)
		EnableGui(false)
		Citizen.Wait(500)
		TriggerEvent('qb-clothes:client:CreateFirstCharacter', myIdentifiers.id)
	else
		ESX.ShowNotification(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if guiEnabled then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function verifyName(name)
	-- Don't allow short user names
	local nameLength = string.len(name)
	if nameLength > 25 or nameLength < 2 then
		ESX.Notify("Geçersiz!","Girdiğiniz İsim Çok Uzun! <b>Maks: 25</b>",3000,"error")
	end
	
	-- Don't allow special characters (doesn't always work)
	local count = 0
	for i in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do
		count = count + 1
	end
	if count ~= nameLength then 
		ESX.Notify("Geçersiz!","Oyuncu adınız bu sunucuda izin verilmeyen özel karakterler içeriyor.",3000,"error")
	end
	
	-- Does the player carry a first and last name?
	-- 
	-- Example:
	-- Allowed:     'Bob Joe'
	-- Not allowed: 'Bob'
	-- Not allowed: 'Bob joe'
	local spacesInName    = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, '%S+') do

		if string.match(word, '%u') then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 2 then
		ESX.Notify("Geçersiz!","Adınız ikiden fazla boşluk içeriyor",3000,"error")
	end
	
	if spacesWithUpper ~= spacesInName then
		ESX.Notify("Geçersiz!","Adınız Büyük Harfle Başlamalıdır.",3000,"error")

	end

	return ''
end