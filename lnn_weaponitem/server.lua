ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k, v in pairs(Config.ItemLists) do 
    ESX.RegisterUsableItem(k, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer.hasWeapon(v.weapon) then 
            xPlayer.addWeapon(v.weapon, v.ammo)
            xPlayer.removeInventoryItem(k, 1)
        end 
    end)
end 