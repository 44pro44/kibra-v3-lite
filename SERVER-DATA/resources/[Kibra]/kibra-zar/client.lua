ESX = nil
   print("ZAR")
Citizen.CreateThread(function()
      while ESX == nil do
         TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
         Citizen.Wait(0)
     end
end)

RegisterNetEvent("K1.CLIENT.ZARAT")
AddEventHandler("K1.CLIENT.ZARAT", function(source)
    local number = 0
    number = math.random(1,12)
    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent('3dme:display', 'Atılan Zar: ' .. number)
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

