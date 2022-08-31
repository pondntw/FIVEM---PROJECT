ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('lnn_mechanicjob:removeitem')
AddEventHandler('lnn_mechanicjob:removeitem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)
