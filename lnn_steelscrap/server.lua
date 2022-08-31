ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('lnn_steelscrap:Additem')
AddEventHandler('lnn_steelscrap:Additem', function(netid)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(Config.ItemReward[1])
	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = 'กระเป๋าของคุณเต็ม',
			type = "error",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		}) 
	else
		if xItem.limit ~= -1 and (xItem.count + Config.ItemReward[2]) > xItem.limit then
			xPlayer.setInventoryItem(xItem.name, xItem.limit)
		else
			xPlayer.addInventoryItem(xItem.name, Config.ItemReward[2])
		end
	end
end)
