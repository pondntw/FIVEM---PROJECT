Variable = {
    DisableRemove = {},
	DeadData = {}
}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.NotremoveItemsAfterRPDeath) do 
        Variable.DisableRemove[v] = true
    end 
end)

ESX.RegisterCommand('revive', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('lnn_ambulancejob:revive')
end, true, {help = 'revive a player', validate = true, arguments = {
	{name = 'playerId', help = 'The player id', type = 'player'}
}})

RegisterCommand('reviveall', function()
	TriggerClientEvent('lnn_ambulancejob:reviveall', -1)
end, true)

RegisterNetEvent('lnn_ambulancejob:removeitem')
AddEventHandler('lnn_ambulancejob:removeitem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)

