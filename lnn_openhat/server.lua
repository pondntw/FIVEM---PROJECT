ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Hat = {}

ESX.RegisterUsableItem(Config.Itemname , function(source)
    TriggerClientEvent('lnn_openhat:placehat', source)
end)

RegisterNetEvent('lnn_openhat:Createtable')
AddEventHandler('lnn_openhat:Createtable', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = { Coords = coords, Money = 0 }
    Hat[xPlayer.getIdentifier()] = data 
    TriggerClientEvent('lnn_openhat:Createprop', -1, xPlayer.getIdentifier(), data)
end)

RegisterNetEvent('lnn_openhat:updateMoney')
AddEventHandler('lnn_openhat:updateMoney', function(k, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(money)
    Hat[k].Money = Hat[k].Money + money
    TriggerClientEvent('lnn_openhat:updateMoneyCl', -1, k, money)
end)

RegisterNetEvent('lnn_openhat:Pickup')
AddEventHandler('lnn_openhat:Pickup', function(k)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = Hat[k].Money - Hat[k].Money*Config.Tax/100 
    xPlayer.addMoney(money)
    Hat[k] = nil 
    TriggerClientEvent('lnn_openhat:deleteHat',-1,k)    
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerClientEvent('lnn_openhat:Firstjoin',playerData,Hat)
end)

