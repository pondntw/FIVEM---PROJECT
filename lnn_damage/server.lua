ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(Config.ArmourItem, function(source)
    xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('lnn_damage:vest', source)
end)

RegisterNetEvent('lnn_damage:deleteitem')
AddEventHandler('lnn_damage:deleteitem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)
