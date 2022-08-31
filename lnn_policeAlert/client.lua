
local ESX = nil
local gender = "male"

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end
	if not ESX.PlayerData.job then
		return false
	end
	for k,v in ipairs({'police'}) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end
	return false
end

RegisterNetEvent("lnn_policeAlert:Notify")
AddEventHandler("lnn_policeAlert:Notify", function(text, pos, color, type)
	if isPlayerWhitelisted then
		local id = GetGameTimer()..math.random(1000000,9999999)
		TriggerEvent("lonenoti:SendNotification", {
			text = text,
			layout = Config["alert_position"],
			queue = "police_alert", 
			type = "alert",
			type2 = type,
			id = id,
			theme = "gta",
			timeout = Config["duration"] * 800,
			color = color
		})
		TriggerEvent("lnn_policeAlert:alertArea", pos)
	end
end)

RegisterNetEvent("lnn_policeAlert:sendLocation")
AddEventHandler("lnn_policeAlert:sendLocation", function(pos)
	SetNewWaypoint(pos.x, pos.y)
	TriggerEvent("lonenoti:SendNotification",  {
		text = "ตั้ง GPS ไปยังจุดเกิดเหตุแล้ว",
		type = "success",
		timeout = 2000,
		layout = Config["alert_position"]
	})
end)

local ispressed = function(input, key)
	return IsControlPressed(input, key) or IsDisabledControlPressed(input, key)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local num
		
		if ispressed(1, 157) then
			num = 1
		elseif ispressed(1, 158) then
			num = 2
		elseif ispressed(1, 160) then
			num = 3
		elseif ispressed(1, 164) then
			num = 4
		elseif ispressed(1, 165) then
			num = 5
		elseif ispressed(1, 159) then
			num = 6
		elseif ispressed(1, 161) then
			num = 7
		elseif ispressed(1, 162) then
			num = 8
		elseif ispressed(1, 163) then
			num = 9
		end

		if ispressed(1, Config["base_key"]) and num and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			TriggerServerEvent("lnn_policeAlert:getLocation", num)
			Citizen.Wait(1000)
		end
		
				if ispressed(1, Config["base_key"]) and num and ESX.PlayerData.job and ESX.PlayerData.job.name == 'army' then
			TriggerServerEvent("lnn_policeAlert:getLocation", num)
			Citizen.Wait(1000)
		end
	end
end)

local getStreetName = function()
	local pos = GetEntityCoords(PlayerPedId())
	local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
	streetName = GetStreetNameFromHashKey(streetName)
	return streetName
end

AddEventHandler('skinchanger:loadSkin', function(c)
	gender = (c.sex == 0 and "male" or "female")
end)

RegisterNetEvent('lnn_policeAlert:alertArea')
AddEventHandler('lnn_policeAlert:alertArea', function(pos)
	Citizen.CreateThread(function()
		SendNUIMessage({
			type = 'playsound',
		})
	
		local v = AddBlipForRadius(pos.x, pos.y, pos.z, Config["red_radius"])
		
		SetBlipHighDetail(v, true)
		SetBlipColour(v, 1)
		SetBlipAlpha(v, 200)
		SetBlipAsShortRange(v, true)
		
		local a = 200
		local t = (a / Config["duration"]) * 100
		local r = (a / Config["duration"])
		while a > 0 do
			a = a - r
			if a <= 0 then
				RemoveBlip(v)
			else
				SetBlipAlpha(v, math.floor(a))
			end
			Citizen.Wait(t)
		end
	end)
end)

AddEventHandler("lnn_policeAlert:alertNet", function(event_type,color,position)
	local ped = PlayerPedId()
	local pos
	if position == nil then 
	 	pos = GetEntityCoords(ped)
	else 
		pos = position
	end 
	TriggerServerEvent("lnn_policeAlert:defaultAlert", event_type, gender, getStreetName(), pos,color)
end)

RegisterNetEvent("lnn_policeAlert:getalertNet")
AddEventHandler("lnn_policeAlert:getalertNet", function(event_type,color)
	local ped = PlayerPedId()
	
	local pos = GetEntityCoords(ped)
	TriggerServerEvent("lnn_policeAlert:defaultAlert", event_type, gender, getStreetName(), pos)
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if Config["alert_section"]["carjacking"] and IsPedJacking(ped) then
			Citizen.Wait(1)
			local car = GetVehiclePedIsIn(ped)
			local seat = GetPedInVehicleSeat(car,-1)
			if seat == ped then
				local pos = GetEntityCoords(ped)
				TriggerServerEvent("lnn_policeAlert:defaultAlert", "carjacking", gender, getStreetName(), pos,"rgb(0,229,0,0.5)")
			end
			Citizen.Wait(Config["duration"] * 1000)
		elseif Config["alert_section"]["melee"] and IsPedInMeleeCombat(ped) then
			Citizen.Wait(1)
			for k, v in pairs(Config.MeleeWeapon) do 
				for key , value in pairs(Config.MeleeGang) do 
					if GetSelectedPedWeapon(ped) == GetHashKey(v) and ESX.GetPlayerData().job.name == value then 
						Citizen.Wait(1)
						local pos = GetEntityCoords(ped)
						TriggerServerEvent("lnn_policeAlert:defaultAlert", "ตรวจพบการใช้อาวุธ", gender, getStreetName(), pos,"rgb(0,0,0,0.5)")
						Citizen.Wait(Config["duration"] * 1000)
					end
				end
			end
		elseif Config["alert_section"]["gunshot"] and IsPedShooting(ped) and not IsPedCurrentWeaponSilenced(ped) then
			Citizen.Wait(1)
			if ESX.GetPlayerData().job.name == 'police' then
			local pos = GetEntityCoords(ped)
			TriggerServerEvent("lnn_policeAlert:defaultAlert", "gunshot", gender, getStreetName(), pos,"rgb(246,0,34,0.5)")
			Citizen.Wait(Config["duration"] * 1000)
			end
		end
	end
end)