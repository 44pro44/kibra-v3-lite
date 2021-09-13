ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local Sleep = 2000
        local PlayerPedId = PlayerPedId()
        local PlayerCoord = GetEntityCoords(PlayerPedId)
        for i = 1, #KIBRA.BlackMarketler, 1 do
            local DistanceBlackMarket = #(PlayerCoord - KIBRA.BlackMarketler[i].NPCKordinat)
            if DistanceBlackMarket < 3.0 then
                Sleep = 2
                DrawText3D(KIBRA.BlackMarketler[i].NPCKordinat.x, KIBRA.BlackMarketler[i].NPCKordinat.y, KIBRA.BlackMarketler[i].NPCKordinat.z + 2.0, '~r~E~w~ - '..KIBRA.BlackMarketler[i].SaticiAd)
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback('Kibra:BlackMarket:server:PoliceSayi', function(count)
                        if count >= KIBRA.BlackMarketler[i].MinPolice then
                            OpenBlackMarket()
                        else
                            ESX.Notify("Şuan Olmaz!","Şehirde yeteri kadar polis yok!",3000,"warning")
                        end
                    end)
                end
            end
        end
        Citizen.Wait(Sleep)
    end
end)

function OpenBlackMarket()
    ESX.UI.Menu.CloseAll()
	local elements = {}
    for g = 1, #KIBRA.BlackMarketler, 1 do
		for i=1, #KIBRA.BlackMarketler[g].Items, 1 do
			table.insert(elements, {label =  KIBRA.BlackMarketler[g].Items[i].label .. ' $' .. KIBRA.BlackMarketler[g].Items[i].price .. ' ',	value = KIBRA.BlackMarketler[g].Items[i].itemname, price = KIBRA.BlackMarketler[g].Items[i].price})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shipitem',
			{
			title    = KIBRA.BlackMarketler[g].SaticiAd..' Black Market',
			align    = 'left',
			elements = elements
			},
			function(data, menu)
				TriggerServerEvent('Kibra:BlackMarket:server:BuyItem',  data.current.value, data.current.price, KIBRA.BlackMarketler[g].SaticiAd)
                menu.close()
				end, function(data2, menu2)
				menu2.close()
				end)
            end

end

Citizen.CreateThread(function()
    for i = 1, #KIBRA.BlackMarketler, 1 do
    RequestModel(KIBRA.BlackMarketler[i].NPCHash)
    while not HasModelLoaded(KIBRA.BlackMarketler[i].NPCHash) do
        Wait(1)
    end
    npc = CreatePed(1, KIBRA.BlackMarketler[i].NPCHash, KIBRA.BlackMarketler[i].NPCKordinat.x, KIBRA.BlackMarketler[i].NPCKordinat.y, KIBRA.BlackMarketler[i].NPCKordinat.z, KIBRA.BlackMarketler[i].Heading, false, true)
    SetPedCombatAttributes(npc, 46, true)               
    SetPedFleeAttributes(npc, 0, 0)               
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    end
end)

DrawText3D = function(x,y,z,text)
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