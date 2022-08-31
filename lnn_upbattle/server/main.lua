Variable = {
    ESX = nil,
    EventStart = false,
    Time = 0,
    Box = {},
    PlayerInEvent = {},
    PlayerCount = 0,
}

TriggerEvent('esx:getSharedObject', function(obj) Variable.ESX = obj end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        for k, v in pairs(Config.UpbattleMain.AutostartTime) do 
            local time = os.date('%H:%M:%S', os.time())
            local timestart = v..':00'
            if time == timestart then 
                StartEvent()
            end
        end 
    end     
end)

AddEventHandler('lnn_upbattle:timeloop', function()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1000)
            if Variable.Time >= 1 then 
                Variable.Time = Variable.Time - 1
                TriggerClientEvent('lnn_upbattle:updatetime', -1, Variable.Time)
            end 
            if not Variable.EventStart then 
                break
            end 
        end     
    end)
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if Variable.EventStart and PlayerInEvent[_source] then 
        local location = vector3(data.victimCoords.x, data.victimCoords.y, data.victimCoords.z)
        local distance = #(location - Config.UpbattleMain.BattleCoords)
        if distance <= Config.UpbattleMain.BattleArea then 
            Variable.PlayerCount = Variable.PlayerCount - 1
            Variable.PlayerInEvent[source] = nil 
            TriggerClientEvent('lnn_upbattle:exitloser', _source)
            for k, v in pairs(Config.ItemReward) do 
                xPlayer.addInventoryItem(v[1], v[2])
            end 
            if Variable.PlayerCount == 1 then 
                for k, v in pairs(Variable.PlayerInEvent) do 
                    TriggerClientEvent('lnn_upbattle:exitwinner', k)
                end 
                TriggerEvent('lnn_upbattle:clearvariable')
            end 
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    if Variable.EventStart and PlayerInEvent[_source] then 
        Variable.PlayerCount = Variable.PlayerCount - 1
        Variable.PlayerInEvent[source] = nil 
        if Variable.PlayerCount == 1 then 
            for k, v in pairs(Variable.PlayerInEvent) do 
                TriggerClientEvent('lnn_upbattle:exitwinner', k)
            end 
            TriggerEvent('lnn_upbattle:clearvariable')
        end 
        if Variable.PlayerCount == 0 then 
            TriggerEvent('lnn_upbattle:clearvariable')
        end 
    end
end)

RegisterNetEvent('lnn_upbattle:reward')
AddEventHandler('lnn_upbattle:reward', function(data)
    local xPlayer = ESX.GetPlayerFromId(soruce)
    for k, v in pairs(data) do 
        xPlayer.addInventoryItem(v[1], v[2])
    end 
end)

RegisterNetEvent('lnn_upbattle:clearvariable')
AddEventHandler('lnn_upbattle:clearvariable', function()
    Variable.EventStart = false 
    Variable.Time = 0
    Variable.Box = {}
    Variable.PlayerInEvent = {}
    Variable.PlayerCount = 0
end)

RegisterNetEvent('lnn_upbattle:joinevent')
AddEventHandler('lnn_upbattle:joinevent', function()
    Variable.PlayerInEvent[source] = true 
    Variable.PlayerCount = Variable.PlayerCount + 1
    TriggerClientEvent('lnn_upbattle;:updatePlayerCount', -1 , Variable.PlayerCount)
end)

RegisterNetEvent('lnn_upbattle:exitevent')
AddEventHandler('lnn_upbattle:exitevent', function()
    Variable.PlayerInEvent[source] = true 
    Variable.PlayerCount = Variable.PlayerCount - 1
    TriggerClientEvent('lnn_upbattle;:updatePlayerCount', -1 , Variable.PlayerCount)
end)