ESX = nil
Delay = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('lnn_storerob:Delay')
AddEventHandler('lnn_storerob:Delay', function(k)
    Delay[k] = true
    TriggerClientEvent('lnn_storerob:Delay', -1, k, true)
    DelayLoop(k)
end)

RegisterNetEvent('lnn_storerob:AddItem')
AddEventHandler('lnn_storerob:AddItem', function(k)
    local xPlayer = ESX.GetPlayerFromId(source)
    local rdm = math.random(1, 100)
    local Reward = {}
    for k, v in pairs(Config.StoreList[k].ItemList) do 
        if rdm <= v[3] then 
            table.insert(Reward, v)
        end 
    end 
    local key = math.random(1, #Reward)
    if Reward[key][1] == 'money' then 
        xPlayer.addMoney(Reward[key][2]) 
    elseif Reward[key][1] == 'black_money' then 
        xPlayer.addAccountMoney('black_money', Reward[key][2])
    else 
        local xItem = xPlayer.getInventoryItem(Reward[key][1])
        if xItem.limit ~= -1 and (xItem.count + Reward[key][2]) > xItem.limit then
			xPlayer.setInventoryItem(xItem.name, xItem.limit)
		else
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = 'กระเป๋าของคุณเต็ม',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "global"
            }) 
		end
    end
end)

function DelayLoop(k)
    Citizen.Wait(Config.StoreList[k].Delay*60*1000)
    Delay[k] = false
    TriggerClientEvent('lnn_storerob:Delay', -1, k, false)
end 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerClientEvent('lnn_storerob:update', playerData, Delay)
end)
