ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k, v in pairs(Config.DrugList) do 
    ESX.RegisterUsableItem(k, function(source)
        TriggerClientEvent('lnn_selldrug:StartSelldrug', source, k, v)
    end)
end 

RegisterServerEvent('lnn_selldrug:SuccessSell')
AddEventHandler('lnn_selldrug:SuccessSell', function(itemname, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, 1)
    if data.Dirtymoney then 
        xPlayer.addAccountMoney('black_money', math.random(data.Price[1],data.Price[2]))
    else
        xPlayer.addMoney(math.random(data.Price[1],data.Price[2]))
    end 
end)