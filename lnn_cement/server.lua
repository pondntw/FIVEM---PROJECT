local reset_duration = Config.Delay * 60

local ESX = nil
local Cement = {}
local Cement2 = {}
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterServerEvent('lnn_cement:getItem')
AddEventHandler('lnn_cement:getItem', function(netid)
    local _source = source
	
	if Cement2[netid] and Cement2[netid] > GetGameTimer() then
		TriggerClientEvent('esx:showNotification', _source, "~r~There's no cement left")
		return
	end
	
	local item = 'bcement'
	
	local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)

	if not xItem then
		return
	end
	
	if xItem.limit ~= -1 and xItem.count >= xItem.limit then  
		TriggerClientEvent('esx:showNotification', _source, ('Full inventory'))
	else
		Cement2[netid] = GetGameTimer() + (reset_duration * 1000)
		xPlayer.addInventoryItem(item, 1)
		TriggerClientEvent("lnn_cement:fetchCooldown", -1, netid, reset_duration)
	end
end)

RegisterServerEvent("lnn_cement:fetchCement")
AddEventHandler("lnn_cement:fetchCement", function(netid)
	if Cement[netid] then return end
	Cement[netid] = GetGameTimer() + (reset_duration * 1000)
	local src = source
	TriggerClientEvent("lnn_cement:fetchCement", -1, netid, src)
end)

Citizen.CreateThread(function()
	while true do
		for k,v in pairs(Cement) do
			if v < GetGameTimer() then
				Cement[k] = nil
			end
		end
		Citizen.Wait(30000)
	end
end)

