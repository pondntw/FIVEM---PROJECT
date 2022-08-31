RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    TriggerEvent('lnn_ambulancejob:setDeathStatus', true, source)
    TriggerClientEvent('lnn_ambulance:onPlayerDead', source)
end)

RegisterNetEvent('lnn_ambulancejob:setDeathStatus')
AddEventHandler('lnn_ambulancejob:setDeathStatus', function(isDead, id)
    if id ~= nil then xPlayer = ESX.GetPlayerFromId(id) else xPlayer = ESX.GetPlayerFromId(source) end 
    local identifier = xPlayer.getIdentifier()
    DeadData[identifier] = nil
    MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)

RegisterNetEvent('lnn_ambulancejob:setdeathdata')
AddEventHandler('lnn_ambulancejob:setdeathdata', function(Time, Phase, Shroud)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    DeadData[identifier].time = Time
    if Phase ~= nil then 
        DeadData[identifier].phase = Phase
    end 
    if Shroud ~= nil then 
        DeadData[identifier].shroud = Shroud 
    end 
end)

ESX.RegisterServerCallback('lnn_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then 
			local sendToDiscord = '' .. xPlayer.name .. ' Combat Logging'
            TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'combatlogging', sendToDiscord, xPlayer.source, '^2')
		end 
		cb(isDead)
	end)
end)

RegisterNetEvent('lnn_ambulancejob:revive')
AddEventHandler('lnn_ambulancejob:revive', function(id, coords)
    if id ~= nil then 
        TriggerClientEvent('lnn_ambulancejob:revive', id, coords)
    else
        TriggerClientEvent('lnn_ambulancejob:revive', source, coords)
    end 
end)

RegisterNetEvent('lnn_ambulancejob:removeItemsAfterRPDeath')
AddEventHandler('lnn_ambulancejob:removeItemsAfterRPDeath', function(wrap)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory(minimal)
    local account = xPlayer.getAccounts()
    local loadout = xPlayer.loadout
    local xItem = xPlayer.getInventoryItem(Config.WeaponProtect)
    for k, v in pairs(inventory) do 
        if v.count > 0 and not Variable.DisableRemove[v.name] then 
            xPlayer.setInventoryItem(v.name, 0)
            local sendToDiscord = '' .. xPlayer.name .. ' เสียชีวิต ถูกลบ ' .. ESX.GetItemLabel(v.name) .. ' จำนวน ' .. ESX.Math.GroupDigits(v.count) .. ''
            TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'DocRemoveRPDeath', sendToDiscord, xPlayer.source, '^7')
        end 
    end 
    
    if xItem.count < 1 then 
        for k, v in pairs(xPlayer.loadout) do 
            xPlayer.removeWeapon(v.name)
            TriggerEvent('lnn_weaponskin:givebackitem', source, v.name)
            local sendToDiscord = '' .. xPlayer.name .. ' เสียชีวิต ถูกลบ ' .. ESX.GetWeaponLabel(v.name) .. ''
            TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'DocRemoveRPDeath', sendToDiscord, xPlayer.source, '^1')
        end 
    else 
        xPlayer.removeInventoryItem(Config.WeaponProtect, 1)
    end

    for k, v in pairs(account) do 
        if v.name ~= 'bank' then 
            if v.money > 0 then 
                xPlayer.removeAccountMoney(v.name, v.money)
                local sendToDiscord = '' .. xPlayer.name .. ' เสียชีวิต ถูกลบ Money $' .. ESX.Math.GroupDigits(v.name) .. ' เเละ Dirty Money $' .. ESX.Math.GroupDigits(v.money) .. ''
                TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'DocRemoveRPDeath', sendToDiscord, xPlayer.source, '^3')
            end 
        end
    end 

end)