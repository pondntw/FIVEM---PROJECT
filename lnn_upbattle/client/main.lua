Variable = {
    ESX = nil,
    Time = 0,
    Box = {},
    NpcPed = nil,
    IsEventStart = false,
    IsInEvent = false,
    PlayerCount = 0,
    Weapondata = nil,
    Pickupdata = {},
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) Variable.ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('lnn_upbattle:updatetime')
AddEventHandler('lnn_upbattle:updatetime', function(time)
    Variable.Time = time
end)

RegisterNetEvent('lnn_upbattle:StartMain')
AddEventHandler('lnn_upbattle:StartMain', function()
    SpawnPedAndJoinEvent()
end)

RegisterNetEvent('lnn_upbattle:SetVariable')
AddEventHandler('lnn_upbattle:SetVariable', function(k, v)
    Variable[k] = v
end)

RegisterNetEvent('lnn_upbattle;:updatePlayerCount')
AddEventHandler('lnn_upbattle;:updatePlayerCount', function(count)
    Variable.PlayerCount = count
end)

RegisterNetEvent('lnn_upbattle:StartFarm')
AddEventHandler('lnn_upbattle:StartFarm', function()
    local Ped = PlayerPedId()
    DeletePed(Variable.NpcPed)
    Variable.NpcPed = nil
    SetEntityCoords(Ped, Config.UpbattleMain.FarmCoords)
end)

RegisterNetEvent('lnn_upbatle:StartBattle')
AddEventHandler('lnn_upbatle:StartBattle', function()
    local point = math.random(1, #Config.UpbattleMain.ParachuteCoords)
    local Ped = PlayerPedId()
    if Variable.IsInEvent then 
		GiveWeaponToPed(Ped, GetHashKey('gadget_parachute'), 1, true, true)
        SetEntityCoords(Ped, Config.UpbattleMain.ParachuteCoords[point])
        RandomWeapon()
    end 
end)

RegisterNetEvent('lnn_upbattle:exitloser')
AddEventHandler('lnn_upbattle:exitloser', function()
    local Ped = PlayerPedId()
    RemoveWeapon()
    SetEntityCoords(Ped, Config.UpbattleMain.JoinEventCoords)
    TriggerEvent('lnn_upbattle:clearvariable')
end)

RegisterNetEvent('lnn_upbattle:exitloser')
AddEventHandler('lnn_upbattle:exitloser', function()
    local Ped = PlayerPedId()
    RemoveWeapon()
    SetEntityCoords(Ped, Config.UpbattleMain.JoinEventCoords)
    TriggerServerEvent('lnn_upbattle:reward', Variable.Pickupdata)
    TriggerEvent('lnn_upbattle:clearvariable')
end)


RegisterNetEvent('lnn_upbattle:clearvariable')
AddEventHandler('lnn_upbattle:clearvariable', function()
    Variable.Time = 0
    Variable.Box = {}
    Variable.NpcPed = nil
    Variable.IsEventStart = false
    Variable.IsInEvent = false
    Variable.PlayerCount = 0
    Variable.Weapondata = nil
    Variable.Pickupdata = {}
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    DeletePed(Variable.NpcPed)
    DeleteBox()
end)

