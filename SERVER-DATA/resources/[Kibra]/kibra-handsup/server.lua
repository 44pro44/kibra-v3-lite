ESX               = nil
local Users = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('god:update')
AddEventHandler('god:update', function(bool)
	local _source = source
	Users[_source] = {value = bool, time = os.time()}
end)