ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Status = {
    Aed = false,
    Aedfinal = false,
    Painkiller = false,
}

function GetTrainingItem()
    if Status.Painkiller then 
        return false 
    elseif Status.Aed then 
        return false 
    elseif Status.Aedfinal then 
        return false 
    else 
        return true
    end 
end 

AddEventHandler('lnn_trainingitem:slide', function()
    Citizen.Wait(250)
    local Ped = PlayerPedId()
    if Status.Aed then 
        TaskPlayAnim(Ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 3.0, -8.0, -1, 1, 0, 0, 0, 0 )     
    end 
    if Status.Aedfinal then 
        TriggerEvent('mythic_progbar:client:cancel')
    end     
end)

AddEventHandler('lnn_trainingitem:checkaed', function()
    local Ped = PlayerPedId()
    if Status.Aed then 
        TaskPlayAnim(Ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 3.0, -8.0, -1, 1, 0, 0, 0, 0 )     
    end
end)

AddEventHandler('lnn_trainingitem:damage', function()
    local Ped = PlayerPedId()
    if Status.Aed then 
        TaskPlayAnim(Ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 3.0, -8.0, -1, 1, 0, 0, 0, 0 )     
    end 
end)

AddEventHandler('lnn_trainingitem:checkpain', function()
    local Ped = PlayerPedId()
    if Status.Painkiller then 
        ESX.Streaming.RequestAnimDict('anim@heists@narcotics@funding@gang_idle', function()
            TaskPlayAnim(Ped, 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01', -8.0, -8.0, -1, 0, 0, false, false, false)
        end)
    end 
end)

RegisterNetEvent('lnn_trainingitem:painkiller')
AddEventHandler('lnn_trainingitem:painkiller', function(training)
    local Ped = PlayerPedId()
    if not Status.Bandage and not Status.Painkiller then 
        Status.Painkiller = true
        ESX.Streaming.RequestAnimDict('anim@heists@narcotics@funding@gang_idle', function()
            TaskPlayAnim(Ped, 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01', -8.0, -8.0, -1, 0, 0, false, false, false)
            Citizen.Wait(Config.Painkiller.Time)
            Status.Painkiller = false
            if not Status.Aed then 
                ClearPedTasks(Ped)
            end
            TriggerEvent('lnn_trainingitem:checkaed')
            if not IsEntityDead(Ped) and HasItem(Config.Painkiller.Itemname) then 
                SetEntityHealth(Ped, GetEntityHealth(PlayerPedId()) + 40) 
                TriggerServerEvent('lnn_trainingitem:deleteitem', Config.Painkiller.Itemname)
            end 
        end)
    end
end)


RegisterNetEvent('lnn_trainingitem:aed')
AddEventHandler('lnn_trainingitem:aed', function(training)
    local Ped = PlayerPedId()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if closestPlayer == -1 or closestDistance > 2.0 then         
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นอยู่ใกล้ๆ", 
            type = "error", 
        })
        return
    end 
    if not IsPedDeadOrDying(closestPlayerPed, 1) then 
        return
    end 
    if not Status.Aed and not Status.Aedfinal then 
        Status.Aed = true
        Status.EnableRun = false
        ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_str', function()
            TaskPlayAnim(Ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 3.0, -8.0, -1, 1, 0, 0, 0, 0 )     
            Citizen.Wait(Config.Aed.Time1)
            ClearPedTasks(Ped)
            Status.Aed = false 
            if not IsEntityDead(Ped) then 
                Status.Aedfinal = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "unique_action_name",
                    duration = Config.Aed.Time2,
                    label = "กำลังชุบ",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false,
                    },
                }, function(status)
                    Status.Aedfinal = false
                    if not status then
                        if not IsEntityDead(Ped) and HasItem(Config.Aed.Itemname) then 
                            TriggerServerEvent('lnn_trainingitem:revivecloset', GetPlayerServerId(closestPlayer))
                            TriggerEvent('lnn_trainingitem:checkpain')
                            TriggerServerEvent('lnn_trainingitem:deleteitem', Config.Aed.Itemname)
                        end 
                    end
                end)
            end
        end)
    end 
end)

function HasItem(Itemname)
    for k, v in pairs(ESX.GetPlayerData().inventory) do 
        if Itemname == v.name and v.count >= 1 then 
            return true 
        end 
    end 
    return false
end 
