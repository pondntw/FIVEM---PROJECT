ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local PlayerData = {}

local WeaponData = {}

local DisableJob = {}

RegisterNetEvent('lnn_thief:update:client')
AddEventHandler('lnn_thief:update:client', function(id, value)
    PlayerData[id] = value
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if not ESX.GetPlayerData().newPlayer then  
    	TriggerServerEvent('lnn_theif:update:server', true)
	end
end)

Citizen.CreateThread(function()
	local handsup = false
	dict = "random@arrests"

	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end

	dict = "random@arrests@busted"
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end

    for k, v in pairs(Config.AllowWeapons) do 
        WeaponData[GetHashKey(v)] = true
    end 

	for k, v in pairs(Config.DisableJobRob) do 
		DisableJob[v] = true
	end 	

	while true do
		Citizen.Wait(0)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
        if IsControlJustPressed(0, 57) and IsPedOnFoot(Ped) then 
			if closestPlayer == -1 or closestDistance > 1.0 then 
				exports.pNotify:SendNotification({
					text = "ไม่มีผู้เล่นอยู่ใกล้ๆ", 
					type = "error", 
					timeout = 2000,
					layout = "centerLeft",
					queue = "left"
				})
			else 
				if DisableJob[ESX.GetPlayerData().job.name] then 
					exports.pNotify:SendNotification({
						text = "คุณไม่สามารถปล้นได้", 
						type = "error", 
						timeout = 2000,
						layout = "centerLeft",
						queue = "left"
					})
				else 
					if exports.Porpy_Check:Check('Police') >= Config.NeedPolice then 
						if WeaponData[GetSelectedPedWeapon(Ped)] then 
							if PlayerData[GetPlayerServerId(closestPlayer)] then 
								TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_BIN", 0, true)
								exports['mythic_progbar']:Progress({
									name = "unique_action_name",
									duration = 3000,
									label = "กำลังปล้น",
									useWhileDead = false,
									canCancel = false,
									controlDisables = {
										disableMovement = true,
										disableCarMovement = true,
										disableMouse = false,
										disableCombat = true,
									}
								}, function(a)
									if not a then
										ClearPedTasks(Ped)
										TriggerEvent('esx_inventoryhud:openPlayerInventory',GetPlayerServerId(closestPlayer))
										TriggerEvent("lnn_policeAlert:alertNet", "มีเหตุปล้นผู้เล่น", "rgb(130,125,221,0.5)")
									end
								end)
							else 
								exports.pNotify:SendNotification({
									text = "ไม่สามารถปล้นผู้เล่นนี้ได้", 
									type = "error", 
									timeout = 2000,
									layout = "centerLeft",
									queue = "left"
								})
							end 
						else 
							exports.pNotify:SendNotification({
								text = "ไม่สามารถใช้อาวุธนี้ปล้นได้", 
								type = "error", 
								timeout = 2000,
								layout = "centerLeft",
								queue = "left"
							})
						end 
					else 
						exports.pNotify:SendNotification({
							text = "ตำรวจไม่เพียงพอ", 
							type = "error", 
							timeout = 2000,
							layout = "centerLeft",
							queue = "left"
						})
					end
				end
			end
        end 

		if IsEntityPlayingAnim(Ped, "random@arrests@busted", "idle_a", 3 ) then 
			SetPedCurrentWeaponVisible(Ped, 0, 1, 1, 1)
		end

		if handsup == true then
			DisableControlAction(0,73,true) 
		end

		if IsControlJustPressed(1, 311) and IsPedOnFoot(Ped) then
			loadAnimDict( "random@arrests" )
			loadAnimDict( "random@arrests@busted" )
			if ( IsEntityPlayingAnim( Ped, "random@arrests@busted", "idle_a", 3 ) ) then 
				TaskPlayAnim( Ped, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Citizen.Wait(3000)
				TaskPlayAnim( Ped, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
				handsup = false
				if not ESX.GetPlayerData().newPlayer then  
					TriggerServerEvent('lnn_theif:update:server', nil)
				end
			else
				TaskPlayAnim( Ped, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Citizen.Wait(4000)
				TaskPlayAnim( Ped, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Citizen.Wait(500)
				TaskPlayAnim( Ped, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Citizen.Wait(1000)
				TaskPlayAnim( Ped, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
				handsup = true
				if not ESX.GetPlayerData().newPlayer then  
					TriggerServerEvent('lnn_theif:update:server', handsup)
				end
			end     
		end
	end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end 
