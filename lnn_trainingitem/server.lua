ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(Config.Aed.Itemname, function(source)
    TriggerClientEvent('lnn_trainingitem:aed', source)
end)

ESX.RegisterUsableItem('painkiller', function(source)
    TriggerClientEvent('lnn_trainingitem:painkiller', source)
end)

RegisterNetEvent('lnn_trainingitem:deleteitem')
AddEventHandler('lnn_trainingitem:deleteitem', function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, 1)
end)

RegisterNetEvent('lnn_trainingitem:revivecloset')
AddEventHandler('lnn_trainingitem:revivecloset', function(Id)
    TriggerClientEvent('lnn_ambulancejob:reviveaed', Id)
end)