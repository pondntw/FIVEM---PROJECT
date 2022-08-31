ESX = nil
JobCount = {}
PlayerCount = 0
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Wait(1000)
    for k, v in pairs(Config.JobList) do JobCount[v] = 0 end
end)

RegisterNetEvent('lnn_checkjob:onresourcestart')
AddEventHandler('lnn_checkjob:onresourcestart', function(Job)
    JobCount[Job] = JobCount[Job] + 1
    TriggerClientEvent('lnn_checkjob:update', -1, Job, JobCount[Job])
end)

RegisterNetEvent('lnn_checkjob:setjob')
AddEventHandler('lnn_checkjob:setjob', function(oldjob, newjob, updatenewjob)
    JobCount[oldjob] = JobCount[oldjob] - 1
    TriggerClientEvent('lnn_checkjob:update', -1, oldjob, JobCount[oldjob])
    if updatenewjob then 
        JobCount[newjob] = JobCount[newjob] + 1
        TriggerClientEvent('lnn_checkjob:update', -1, newjob, JobCount[newjob])
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId)
    PlayerCount = PlayerCount + 1
    TriggerClientEvent('lnn_checkjob:updateplserver', -1, PlayerCount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent('lnn_checkjob:updateall', playerId, JobCount)
    Citizen.Wait(1000)
    if JobCount[xPlayer.job.name] ~= nil then 
        JobCount[xPlayer.job.name] = JobCount[xPlayer.job.name] + 1
        TriggerClientEvent('lnn_checkjob:update', -1, xPlayer.job.name, JobCount[xPlayer.job.name])
    end 
end)

AddEventHandler('esx:playerDropped', function(playerId)
    PlayerCount = PlayerCount - 1
    TriggerClientEvent('lnn_checkjob:updateplserver', -1, PlayerCount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if JobCount[xPlayer.job.name] ~= nil then 
        JobCount[xPlayer.job.name] = JobCount[xPlayer.job.name] - 1
        TriggerClientEvent('lnn_checkjob:update', -1, xPlayer.job.name, JobCount[xPlayer.job.name])
    end 
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Wait(500)
    PlayerCount = GetNumPlayerIndices()
    TriggerClientEvent('lnn_checkjob:updateplserver', -1, PlayerCount)
end)
