ESX = nil
Job = nil
JobList = {}
JobCount = {}
PlayerCount = 0
Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
	Job = ESX.GetPlayerData().job.name
    for k, v in pairs(Config.JobList) do JobList[v] = true JobCount[v] = 0 end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Wait(1000)
    if JobList[Job] then 
        TriggerServerEvent('lnn_checkjob:onresourcestart', Job)
    end 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if Job == job.name then return end
    if JobList[Job] then 
        TriggerServerEvent('lnn_checkjob:setjob', Job, job.name, JobList[job.name])
        Job = job.name
    end 
end)

RegisterNetEvent('lnn_checkjob:update')
AddEventHandler('lnn_checkjob:update', function(job, count)
    JobCount[job] = count
end)

RegisterNetEvent('lnn_checkjob:updateall')
AddEventHandler('lnn_checkjob:updateall', function(data)
    JobCount = data
end)

RegisterNetEvent('lnn_checkjob:updateplserver')
AddEventHandler('lnn_checkjob:updateplserver', function(data)
    print(data)
    PlayerCount = data
end)

function GetJob(jobname)
    if JobCount[jobname] ~= nil then 
        return JobCount[jobname]
    end     
end 

function GetPlayerInServer()
    return PlayerCount
end 




  