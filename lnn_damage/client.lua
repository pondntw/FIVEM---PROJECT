ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        if HasEntityBeenDamagedByWeapon(PlayerPedId(), 0, 2) then 
            appydamage()
        end 
        for k, v in pairs(Config.WeaponList) do 
            SetWeaponDamageModifier(k, 0.000001)
        end     
    end 
end)

function appydamage()
    TriggerEvent('lnn_trainingitem:damage')
    local Ped = PlayerPedId()
    local Health = GetEntityHealth(Ped)
    for k,v in pairs(Config.WeaponList) do
        if HasEntityBeenDamagedByWeapon(Ped, GetHashKey(k), 0) then 
            TriggerEvent('DamageEvents:helloword', GetHashKey(k))
            ClearEntityLastDamageEntity(Ped)
            if GetPedArmour(Ped) > 0 then 
                SetEntityHealth(Ped, GetEntityHealth(Ped) + 1)
                if GetPedArmour(Ped) < v then 
                    local damage = v-GetPedArmour(Ped)
                    SetPedArmour(Ped, 0)
                    SetEntityHealth(Ped, GetEntityHealth(Ped)-damage)
                else
                    SetPedArmour(Ped, GetPedArmour(Ped)-v)
                end
            else
                SetEntityHealth(Ped, GetEntityHealth(Ped) - (v - 1))
            end
        end
    end
end

RegisterNetEvent('lnn_damage:vest')
AddEventHandler('lnn_damage:vest', function()
    local Ped = PlayerPedId()
    if GetPedArmour(Ped) < 100 then 
        local playerPed = PlayerPedId()
        RequestAnimDict("clothingshirt")
        while not HasAnimDictLoaded("clothingshirt") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(GetPlayerPed(PlayerId()), "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0) 
        Citizen.Wait(5000)
        SetPedArmour(playerPed, 100) 
        StopAnimTask(playerPed, 'clothingshirt', 'try_shirt_positive_d', 1.0)
        SetPedComponentVariation(playerPed, 9, 27, 5, 0)
        TriggerServerEvent('lnn_damage:deleteitem', Config.ArmourItem)
    end  
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end