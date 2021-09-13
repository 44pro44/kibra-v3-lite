local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local messages = {}

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function( author, ctype, text, test, t)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)

  end
  table.insert(messages, text)
  local ctype = ctype ~= false and ctype or "normal"

  if test then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        template = '<div class="chat-message ' ..ctype.. '"><div class="chat-message-body"><span style="color: white; margin-right: .3rem"> {0} </span><strong>{1}</strong> {2} </div></div>',
        args = {t,author, text}
      }
    })
  elseif test == false then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        template = '<div class="chat-message '..ctype.. '"><div class="chat-message-body"><strong>{0} </strong>{1}</div></div>',
        args = {author, text}
      }
    })
  elseif test == nil then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        template = '<div class="chat-message '..ctype.. '"><div class="chat-message-body"><strong>{0} </strong>{1}</div></div>',
        args = {author, text}
      }
    })

  end
end)



AddEventHandler('chat:addMessage', function(message)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false, false)
  TriggerServerEvent('lucid-s-chat:syncforeveryone', "sa", false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end

local function refreshThemes()
  local themes = {}

  for resIdx = 0, GetNumResources() - 1 do
    local resource = GetResourceByFindIndex(resIdx)

    if GetResourceState(resource) == 'started' then
      local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

      if numThemes > 0 then
        local themeName = GetResourceMetadata(resource, 'chat_theme')
        local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

        if themeName and themeData then
          themeData.baseUrl = 'nui://' .. resource .. '/'
          themes[themeName] = themeData
        end
      end
    end
  end

  SendNUIMessage({
    type = 'ON_UPDATE_THEMES',
    themes = themes
  })
end

AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  refreshCommands()
  refreshThemes()

  chatLoaded = true

  cb('ok')
end)



local dot = "."
local str = nil

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
        dot = dot .. " ."
        if string.len(dot) > 6 then
          dot = ""
      end
  end
end)


local defaultScale = 0.4 -- Text scale

function DrawText(coords, text)
  local camCoords = GetGameplayCamCoord()

  
  local dist = #(coords - camCoords)
  
  -- Experimental math to scale the text down
  local scale = 200 / (GetGameplayCamFov() * dist)

  --if onScreen then

      -- Format the text
      SetTextColour(255, 255, 255, 255)
      SetTextFont(fontId)
      SetTextScale(0.0, defaultScale * scale)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextDropShadow()
      SetTextCentre(true)

      -- Diplay the text
      BeginTextCommandDisplayText("STRING")
      AddTextComponentSubstringPlayerName(text)
      SetDrawOrigin(coords, 0)
      EndTextCommandDisplayText(0.0, 0.0)
      ClearDrawOrigin()

  --end
  end

local players = {}
Citizen.CreateThread(function()
  local lstr = ""
  local offset = 0.8
  while true do
      Wait(0)
      local tick = GetGameTimer()
      local str = ""
      local removes = {}
      for a, b in next, players do
        if not b.shouldOpen  then
          removes[#removes+1] = a
        end
          local p = GetPlayerFromServerId(a)
          if NetworkIsPlayerActive(p) then
              local ped = GetPlayerPed(p)
              local monid = PlayerId()
              if DoesEntityExist(ped) then
                if #(GetEntityCoords(GetPlayerPed(b.monId)) - GetEntityCoords(GetPlayerPed(b.sonId))) > 7.0 then
               
                end
                  local coords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.0) --HEAD
                  local ons, x, y = GetHudScreenPositionFromWorldPosition(coords.x, coords.y, coords.z-0.4)
                  
                if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(b.sonId))) < 6.0 then
                  local x, y, z = table.unpack(GetEntityCoords(ped))
                  z = z + offset
                  DrawText(vector3(x, y, z+0.2), dot)
                else
                  dot = ""
                end

           
              end
          end

      end
      if #removes > 0 then
          for a, b in ipairs(removes) do
              players[b] = nil
          end
      end
      if str ~= lstr then
          SendNUIMessage({meta = "me", html = str})
          lstr = str
      end
  end

end)


function fix(string)
  string = string.gsub(string, "&", "&amp")
  string = string.gsub(string, "<", "&lt")
  string = string.gsub(string, ">", "&gt")
  string = string.gsub(string, "\"", "&quot")
  string = string.gsub(string, "'", "&#039")
  return string
end
RegisterNetEvent("lucid_chat:sync")
AddEventHandler("lucid_chat:sync", function(source, message, toggle)

  source = tonumber(source)
  local sonid = GetPlayerFromServerId(source)
  local monid = PlayerId()
  players[source] = {message = fix(message), rtime = 7000+GetGameTimer(), shouldOpen = toggle, monId = monid, sonId = sonid} 

end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false, false)

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true
        dot = ""

        TriggerServerEvent('lucid-s-chat:syncforeveryone', "ss", true)

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        chatInputActivating = false
      end
    end

    if chatLoaded then
      local shouldBeHidden = false

      if IsScreenFadedOut() or IsPauseMenuActive() then
        shouldBeHidden = true
      end

      if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
        chatHidden = shouldBeHidden

        SendNUIMessage({
          type = 'ON_SCREEN_STATE_CHANGE',
          shouldHide = shouldBeHidden
        })
      end
    end
  end
end)