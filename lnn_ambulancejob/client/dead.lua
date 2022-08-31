RegisterNetEvent('lnn_ambulance:onPlayerDead')
AddEventHandler('lnn_ambulance:onPlayerDead', function()
    onPlayerDead()
end)

function onPlayerDead()
    exports["pma-voice"]:setRadioChannel(0)
    local Ped = PlayerPedId()
    local medicOnline = exports["sm-data"]:SM_GET_DATA('ambulance')
    Variable.IsDead = true
    ESX.UI.Menu.CloseAll()
    ClearPedTasksImmediately(Ped)
    if Variable.Job.name == 'ambulance' then 
        if medicOnline == 1 then 
            AutoRespawn()
            KeyX()
        else
            TimeRespawn()
            KeyX()
            KeyG()
        end
    else 
        if medicOnline == 0 then 
            AutoRespawn()
            KeyX()
        else
            TimeRespawn()
            KeyX()
            KeyG()
        end 
    end
end 

function AutoRespawn()
    AutoRespawnTime = ESX.Round(Config.AutoRespawnTime*Variable.minute/1000)

    Citizen.CreateThread(function()
        while AutoRespawnTime > 0 and Variable.IsDead do 
            Citizen.Wait(1000)
            if AutoRespawnTime > 0 then 
                AutoRespawnTime = AutoRespawnTime - 1
            end 
        end 
    end)

    Citizen.CreateThread(function()
        while AutoRespawnTime > 0 and Variable.IsDead do 
            Citizen.Wait(0)
            local min, sec = secondsToClock(AutoRespawnTime)
            SetTextFont(Sarabun)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(185, 185, 185, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName('respawn available in ~r~'..min..' ~s~minutes  ~r~'..sec..' ~s~seconds~s~')
            EndTextCommandDisplayText(0.40, 0.88)
            if AutoRespawnTime == 0 then 
                if IsEntityInWater(PlayerPedId()) then 
                    TriggerServerEvent('lnn_ambulancejob:revive', GetPlayerServerId(PlayerId()), Config.RespawnPoint)
                else 
                    TriggerServerEvent('lnn_ambulancejob:revive')
                end 
            end 
        end 
    end)
end 

function TimeRespawn()
    RespawnTime = ESX.Round(Config.RespawnTime*Variable.minute/1000)
    if exports.Tarn_playerwrap:CheckWrap() then 
        
    else 

    end 
    Citizen.CreateThread(function()
        while RespawnTime > 0 and Variable.IsDead do 
            Citizen.Wait(1000)
            if RespawnTime > 0 then 
                RespawnTime = RespawnTime - 1
            end 
        end 
    end)

    Citizen.CreateThread(function()
        while RespawnTime > 0 and Variable.IsDead do 
            Citizen.Wait(0)
            local min, sec = secondsToClock(RespawnTime)
            SetTextFont(Sarabun)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(185, 185, 185, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName('respawn available in ~r~'..min..' ~s~minutes  ~r~'..sec..' ~s~seconds~s~')
            EndTextCommandDisplayText(0.40, 0.88)
            if RespawnTime < 1 then 
                BleedOutTimer()
            end 
        end 
    end)
end 

function BleedOutTimer()
    BleedOutTime = ESX.Round(Config.BleedOutTime*Variable.minute/1000)

    Citizen.CreateThread(function()
        while BleedOutTime > 0 and Variable.IsDead do 
            Citizen.Wait(1000)
            if BleedOutTime > 0 then 
                BleedOutTime = BleedOutTime - 1
            end 
        end 
    end)

    Citizen.CreateThread(function()
        while BleedOutTime > 0 and Variable.IsDead do 
            Citizen.Wait(0)
            local min, sec = secondsToClock(BleedOutTime)
            SetTextFont(Sarabun)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(185, 185, 185, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName('you will bleed out in  ~r~'..min..' ~s~minutes  ~r~'..sec..' ~s~seconds~s~')
            EndTextCommandDisplayText(0.40, 0.88)
            if BleedOutTime < 1 then 
                if exports.Tarn_playerwrap:CheckWrap() then 
                    TriggerEvent('lnn_ambulancejob:revive')
                    Citizen.Wait(1000)
                    TriggerServerEvent('lnn_jail:jail', GetPlayerServerId(PlayerId()), 2, 30, 'หมดเวลาสลบ', 'ambulance')
                    TriggerServerEvent('lnn_ambulancejob:removeItemsAfterRPDeath')
                else 
                    TriggerEvent('lnn_ambulancejob:revive')
                    TriggerServerEvent('lnn_jail:jail', GetPlayerServerId(PlayerId()), 2, 30, 'หมดเวลาสลบ', 'ambulance')
                end 
            end 
        end 
    end)
end 

function KeyX()
    canx = true
    Ped = PlayerPedId()
    Citizen.CreateThread(function()
        while Variable.IsDead and canx do 
            Citizen.Wait(0)
            SetTextProportional(0)
            SetTextFont(Sarabun)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(185, 185, 185, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName('Press [~b~X~s~] to jump body')
            EndTextCommandDisplayText(0.45, 0.85)
            if IsControlJustReleased(0, 105) then 
                ClearPedTasksImmediately(Ped)
                canx = false 
                Citizen.Wait(15000)
                canx = true
            end 
        end 
    end)
end 

function KeyG()
    cang = true 
    Citizen.CreateThread(function()
        while Variable.IsDead and cang do 
            Citizen.Wait(0)
            SetTextFont(Sarabun)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(185, 185, 185, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName('press [~b~G~s~] to send distress signal')
            EndTextCommandDisplayText(0.435, 0.91)
            if IsControlJustReleased(0, 47) then 
                SendDistressSignalEMS()
                cang = false 
                Citizen.Wait(300000)
                cang = true
            end 
        end 
    end)
end

RegisterNetEvent('lnn_ambulancejob:reviveupbattle')
AddEventHandler('lnn_ambulancejob:reviveupbattle', function(Coords)
	local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
    TriggerServerEvent('lnn_ambulancejob:setDeathStatus', false)
    Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(Ped, formattedCoords, 0.0)
        if Coords ~= nil then 
            SetEntityCoords(Ped, Coords.coords)
            SetEntityHeading(Ped, Coords.heading)
        end 
        SetEntityHealth(Ped, 200)
		TriggerEvent('esx_status:set', 'thirst', 400000)
		TriggerEvent('esx_status:set', 'hunger', 400000)
		TriggerEvent('esx_status:set', 'stress', 400000)
		DoScreenFadeIn(800)
	end)
end)

RegisterNetEvent('lnn_ambulancejob:revive')
AddEventHandler('lnn_ambulancejob:revive', function(Coords)
	local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
    TriggerServerEvent('lnn_ambulancejob:setDeathStatus', false)
    Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(Ped, formattedCoords, 0.0)
        if Coords ~= nil then 
            SetEntityCoords(Ped, Coords.coords)
            SetEntityHeading(Ped, Coords.heading)
        else 
            SetEntityCoords(Ped, coords)
        end 
        SetEntityHealth(Ped, 120)
		TriggerEvent('esx_status:set', 'thirst', 400000)
		TriggerEvent('esx_status:set', 'hunger', 400000)
		TriggerEvent('esx_status:set', 'stress', 400000)
		DoScreenFadeIn(800)
	end)
end)

RegisterNetEvent('lnn_ambulancejob:revive_inzone')
AddEventHandler('lnn_ambulancejob:revive_inzone', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('lnn_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)
		SetEntityHealth(playerPed, 200)
		TriggerEvent('esx_status:set', 'thirst', 400000)
		TriggerEvent('esx_status:set', 'hunger', 400000)
		TriggerEvent('esx_status:set', 'stress', 400000)
		
		DoScreenFadeIn(800)
	end)
end)

RegisterNetEvent('lnn_ambulancejob:reviveaed')
AddEventHandler('lnn_ambulancejob:reviveaed', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('lnn_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)
		SetEntityHealth(playerPed, 150)
		TriggerEvent('esx_status:set', 'hunger', 250000)
		TriggerEvent('esx_status:set', 'stress', 250000)
	
		DoScreenFadeIn(800)
	end)
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
    Variable.IsDead = false
	ESX.UI.Menu.CloseAll()
    if exports.Tarn_playerwrap:CheckWrap() then 
        TriggerServerEvent('Tarn_playerwrap:deletecheck:ambulancerevive')
    end
end

function SendDistressSignalEMS()
    local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    exports.pNotify:SendNotification({
        text = "ส่งตำเเหน่งไปยังเเพทย์เเล้ว",
        type = "success",
    })

    TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', 'medical attention required: unconscious citizen! ', PlayerCoords, {
		PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
    if exports.Tarn_playerwrap:CheckWrap() then 
	    TriggerEvent("maxez-ambulance:alertNet", "er")
    else 
	    TriggerEvent("maxez-ambulance:alertNet", "dead")
    end 
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0
	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return mins, secs
	end
end

RegisterNetEvent('lnn_ambulancejob:reviveall')
AddEventHandler('lnn_ambulancejob:reviveall', function()
    if IsEntityDead(PlayerPedId()) then 
        TriggerEvent('lnn_ambulancejob:revive')
    end 
end)

