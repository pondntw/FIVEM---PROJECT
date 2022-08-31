ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('lnn_theif:update:server')
AddEventHandler('lnn_theif:update:server', function(value)
    PlayerData[source] = value
    -- print(ESX.DumpTable(PlayerData))
    TriggerClientEvent('lnn_thief:update:client', -1, source, value)
end)

AddEventHandler('playerDropped', function(reason)
    PlayerData[source] = nil
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    for k, v in pairs(PlayerData) do 
        TriggerClientEvent('lnn_thief:update:client', playerData, k, v)
    end 
end)
