local crouched = false

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 1 )

        local ped = PlayerPedId()

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK  

            if ( not IsPauseMenuActive() ) then 
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                    RequestAnimSet( "move_ped_crouched" )

                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                        Citizen.Wait( 100 )
                    end 

                    if ( crouched == true ) then 
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false 
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end )

local Blips = {
  [1] = {
    name = 'market',
    show = false,
    info = true,
    blip = {
      [1] = {title="Market", colour=2, id=52, x=-50.72, y=-1754.38, z=29.42, np = nil},
      [2] = {title="Market", colour=2, id=52, x=2557.458, y=382.282, np = nil},
      [3] = {title="Market", colour=2, id=52, x=-3038.939, y=585.954, np = nil},
      [4] = {title="Market", colour=2, id=52, x=-3241.927, y=1001.462, np = nil},
      [5] = {title="Market", colour=2, id=52, x=547.431, y=2671.710, z=42.156, np = nil},
      [6] = {title="Market", colour=2, id=52, x=1961.464, y=3740.672, z=32.343, np = nil},
      [7] = {title="Market", colour=2, id=52, x=2678.916, y=3280.671, z=55.241, np = nil},
      [8] = {title="Market", colour=2, id=52, x=1729.563, y=6414.126, z=36.037, np = nil},
      [9] = {title="Market", colour=2, id=52, x=26.18, y=-1347.37, z=29.5, np = nil},
      [10] = {title="Market", colour=2, id=52, x=-48.519, y=-1757.514, z=29.421, np = nil},
      [11] = {title="Market", colour=2, id=52, x=-707.501, y=-914.260, z=19.215, np = nil},
      [12] = {title="Market", colour=2, id=52, x=-1820.523, y=792.518, z=138.118, np = nil},
      [13] = {title="Market", colour=2, id=52, x=1698.388, y=4924.404, z=42.063, np = nil},
      --[14] = {title="Kahve Mağazası", colour=56, id=93, x=-625.858, y=237.1013, z=81.881, np = nil},
      [14] = {title="Market", colour=2, id=52, x=373.74, y=325.96, z=103.57, np = nil}
    }
  },
  [2] = {
    name = 'Garajlar',
    show = false,
    info = true,
    blip = {
      [1] = {title="Garaj", colour=3, id=357, x = 211.8094329834, y = -934.98626708984, z = 24.275938034058, np = nil},
      [2] = {title="Garaj", colour=3, id=357, x = -129.56, y = 1005.71, z = 235.73, np = nil},
      [3] = {title="Garaj", colour=3, id=357, x = -189.3, y = -1288.06, z = 31.3, np = nil},
      [4] = {title="Garaj", colour=3, id=357, x = 306.21, y = -2023.75, z = 20.33, np = nil},
      [5] = {title="Garaj", colour=3, id=357, x = -1122.05, y = -1614.05, z = 4.38, np = nil},
      [6] = {title="Garaj", colour=3, id=357, x = 273.67422485352, y = -344.15573120117, z = 44.919834136963, np = nil},
      [7] = {title="Garaj", colour=3, id=357, x = 959.33, y = -129.83, z = 74.37, np = nil},
      [8] = {title="Garaj", colour=3, id=357, x = -1918.34, y = 2053.78, z = 140.74, np = nil},
      [9] = {title="Garaj", colour=29, id=357, x = -1803.8967285156, y = -341.45928955078, z = 43.986347198486, np = nil},
      [10] = {title="Garaj", colour=29, id=357, x = 1733.94, y = 3711.99, z = 34.15, np = nil},
      [11] = {title="Garaj", colour=29, id=357, x = 52.56, y = 6487.27, z = 31.43, np = nil},
      [12] = {title="Garaj", colour=29, id=357, x = 366.0082, y = 291.6496, z = 103.40, np = nil},
      [13] = {title="Garaj", colour=29, id=357, x = -110.393, y = -1600.76, z = 31.670, np = nil},
      [14] = {title="Garaj", colour=29, id=357, x = 102.4567, y = -1956.12, z = 20.749, np = nil},
      [15] = {title="Garaj", colour=29, id=357, x = -240.09, y = 609.52, z = 187.55, np = nil},
      [16] = {title="Garaj", colour=29, id=357, x = 1383.76, y = -739.37, z = 67.2, np = nil},
      [17] = {title="Garaj", colour=29, id=357, x = 453.815, y = -979.06, z = 25.6998, np = nil},
      [18] = {title="Garaj", colour=29, id=357, x = 280.864, y = -608.93, z = 43.0888, np = nil},
      [19] = {title="Garaj", colour=29, id=357, x = 1411.164, y = 1117.955, z = 114.83, np = nil},
      [20] = {title="Garaj", colour=29, id=357, x = -370.934, y = -110.912, z = 38.680, np = nil},
      [21] = {title="Garaj", colour=29, id=357, x = -11.1526, y = -1099.69, z = 26.672, np = nil},
      [22] = {title="Garaj", colour=29, id=357, x = -1525.44, y = 82.77, z = 56.55, np = nil},
      [23] = {title="Garaj", colour=29, id=357, x = 2567.93, y = 4652.38, z = 34.08, np = nil}

      



    }
  },
  [3] = {
    name = 'Berber',
    show = false,
    info = true,
    blip = {
      [1] = {title="Berber", colour=1, id=71, x = -814.308,  y = -183.823,  z = 36.568, np = nil},
      [2] = {title="Berber", colour=1, id=71, x = 136.826,   y = -1708.373, z = 28.291, np = nil},
      [3] = {title="Berber", colour=1, id=71, x = -1282.604, y = -1116.757, z = 5.990, np = nil},
      [4] = {title="Berber", colour=1, id=71, x = 1931.513,  y = 3729.671,  z = 31.844, np = nil},
      [5] = {title="Berber", colour=1, id=71, x = 1212.840,  y = -472.921,  z = 65.208, np = nil},
      [6] = {title="Berber", colour=1, id=71, x = -32.885,   y = -152.319,  z = 56.076, np = nil},
      [7] = {title="Berber", colour=1, id=71, x = -278.077,  y = 6228.463,  z = 30.695, np = nil}
    }
  },
  [4] = {
    name = 'Dövmeci',
    show = false,
    info = true,
    blip = {
      [1] = {title="Dövmeci", colour=1, id=75, x = 1322.6, y = -1651.9, z = 51.2, np = nil},
      [2] = {title="Dövmeci", colour=1, id=75, x = -1153.6, y = -1425.6, z = 4.9, np = nil},
      [3] = {title="Dövmeci", colour=1, id=75, x = 322.1, y = 180.4, z = 103.5, np = nil},
      [4] = {title="Dövmeci", colour=1, id=75, x = -3170.0, y = 1075.0, z =  20.8, np = nil},
      [5] = {title="Dövmeci", colour=1, id=75, x = 1864.6, y = 3747.7, z =  33.0, np = nil},
      [6] = {title="Dövmeci", colour=1, id=75, x = -293.7, y = 6200.0, z =  31.4, np = nil}
    }
  },
  [5] = {
    name = 'Kıyafetçiler',
    show = false,
    info = true,
    blip = {
      [1] = {title="Kıyafetçi", colour=47, id=73, x = 72.3, y = -1399.1, z = 28.4, np = nil},
      [2] = {title="Kıyafetçi", colour=47, id=73, x = -703.8, y = -152.3, z = 36.4, np = nil},
      [3] = {title="Kıyafetçi", colour=47, id=73, x = -167.9, y = -299.0, z = 38.7, np = nil},
      [4] = {title="Kıyafetçi", colour=47, id=73, x = 428.7, y = -800.1, z = 28.5, np = nil},
      [5] = {title="Kıyafetçi", colour=47, id=73, x =-829.4, y = -1073.7, z = 10.3, np = nil},
      [6] = {title="Kıyafetçi", colour=47, id=73, x = -1447.8, y = -242.5, z = 48.8, np = nil},
      [7] = {title="Kıyafetçi", colour=47, id=73, x = 11.6, y =  6514.2, z = 30.9, np = nil},
      [8] = {title="Kıyafetçi", colour=47, id=73, x = 123.6, y = -219.4, z = 53.6, np = nil},
      [9] = {title="Kıyafetçi", colour=47, id=73, x = 1696.3, y = 4829.3, z = 41.1, np = nil},
      [10] = {title="Kıyafetçi", colour=47, id=73, x =618.1, y = 2759.6, z = 41.1, np = nil},
      [11] = {title="Kıyafetçi", colour=47, id=73, x =1190.6, y = 2713.4, z = 37.2, np = nil},
      [12] = {title="Kıyafetçi", colour=47, id=73, x =-1193.4, y = -772.3, z = 16.3, np = nil},
      [13] = {title="Kıyafetçi", colour=47, id=73, x =-3172.5, y = 1048.1, z = 19.9, np = nil},
      [14] = {title="Kıyafetçi", colour=47, id=73, x =-1108.4, y = 2708.9, z = 18.1, np = nil}
    }
  },
  [6] = {
    name = 'Pizza',
    show = false,        
    info = false,
    blip = {
      [1] = {title="Kahve Dükkanı", colour=56, id=93, x = -625.858, y = 237.1013, z = 81.881, np = nil},       
    }
  },
  [7] = {
    name = 'Gang',
    show = false,
    info = true,
    blip = {
      [1] = {title="Grove", colour=2, id=543, x = -176.956, y = -1630.39, z = 33.344, np = nil},
      [2] = {title="Vagos", colour=5, id=543, x = 331.7966, y = -2042.10, z = 20.889, np = nil},
      [3] = {title="Ballas", colour=58, id=543, x = 99.61661, y = -1942.27, z = 20.803, np = nil},
    }
  },
  [8] = {
    name = 'Banka',
    show = false,
    info = true,
    blip = {
      [1] = {title="Banka", colour=11, id=108, x = 150.266, y = -1040.203, z = 29.374, np = nil},
      [2] = {title="Banka", colour=11, id=108, x = -1212.980, y = -330.841, z = 37.787, np = nil},
      [3] = {title="Banka", colour=11, id=108, x = -2962.582, y = 482.627, z = 15.703, np = nil},
      [4] = {title="Banka", colour=11, id=108, x = -112.202, y = 6469.295, z = 31.626, np = nil},
      [5] = {title="Banka", colour=11, id=108, x = 314.187, y = -278.621, z = 54.170, np = nil},
      [6] = {title="Banka", colour=11, id=108, x = -351.534, y = -49.529, z = 49.042, np = nil},
      [7] = {title="Banka", colour=11, id=108, x = 241.727, y = 220.706, z = 106.286, np = nil},
      [8] = {title="Banka", colour=11, id=108, x = 1175.0643310547, y = 2706.6435546875, z = 38.094036102295, np = nil}
    }
  },
  [9] = {
    name = 'Mekanik',
    show = false,
    info = true,
    blip = {
      [1] = {title="Los Santos Custom", colour=3, id=446, x = -338.88, y = -136.84, z = 239.01, np = nil},
      [2] = {title="Benny Custom", colour=6, id=446, x = -203.40, y = -1320.2, z = 30.9135, np = nil},
      [3] = {title="Air Custom", colour=1, id=446, x = -1617.6, y = -820.06, z = 10.0748, np = nil}

    }
  },

  [10] = {
    name = 'Motel',
    show = false,
    info = true,
    blip = {
      [1] = {title="Pinkcage Motel", colour=27, id=475, x = 324.71, y = -230.12, z = 54.22, np = nil},
      [2] = {title="LS Hotel", colour=11, id=475, x = -1018.09, y = -757.85, z = 19.84, np = nil},
      [3] = {title="NothinIllegal Motel", colour=3, id=475, x = 964.85, y = -192.86, z = 73.21, np = nil},
    }
  },

}

RegisterNetEvent("turn:blip")
AddEventHandler("turn:blip", function(i)
    if i ~= nil then
        if i <= #Blips then
            if Blips[i].show == true then
                TurnOffBlip(i)
                ESX.Notify("Blip Kapadın!",Blips[i].name.." kapadın!",3000,"error")

            else
                TurnOnBlip(i)
                ESX.Notify("Blip Açtın",Blips[i].name.." açtın!",3000,"success")
            end
        end
    end
end)

RegisterCommand("blip", function(source, args)
    if args[1] == 'yardım' then
        InformBlips()
    else
        i = tonumber(args[1])
        TriggerEvent("turn:blip", i)
    end
end)

function TurnOffBlip(i)
    for j=1, #Blips[i].blip, 1 do
        if Blips[i].blip[j].np ~= nil then
            SetBlipDisplay(Blips[i].blip[j].np, 0)
            Blips[i].show = false
        end
    end
end

function TurnOnBlip(i)
    for j=1, #Blips[i].blip, 1 do
        if Blips[i].blip[j].np ~= nil then
            SetBlipDisplay(Blips[i].blip[j].np, 4)
            Blips[i].show = true
        end
    end
end

function InformBlips()
    for i=1, #Blips, 1 do
        if Blips[i].info then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args =  {'Blip' ,Blips[i].name .. ' = ' .. i}
            })
        end
    end
end

function AddBlips()
    for i=1, #Blips, 1 do
        for j=1, #Blips[i].blip, 1 do
              Blips[i].blip[j].np = AddBlipForCoord(Blips[i].blip[j].x, Blips[i].blip[j].y, Blips[i].blip[j].z)
              SetBlipSprite(Blips[i].blip[j].np, Blips[i].blip[j].id)
              if Blips[i].show then
                  SetBlipDisplay(Blips[i].blip[j].np, 4)
              else
                  SetBlipDisplay(Blips[i].blip[j].np, 0)
              end
              SetBlipScale(Blips[i].blip[j].np, 0.6)
              SetBlipColour(Blips[i].blip[j].np, Blips[i].blip[j].colour)
              SetBlipAsShortRange(Blips[i].blip[j].np, true)
              BeginTextCommandSetBlipName("STRING")
              AddTextComponentString(Blips[i].blip[j].title)
              EndTextCommandSetBlipName(Blips[i].blip[j].np)
        end
    end
end



Citizen.CreateThread(function()
    AddBlips()
end)
