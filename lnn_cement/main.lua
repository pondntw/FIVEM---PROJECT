local ESX = nil
local cachedPlant = {}
local closestPlant = {
    GetHashKey("prop_cementbags01"),
	GetHashKey("prop_cons_cements01")
}

local isPickingUp = false
local duration = 25000

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)


RegisterNetEvent("lnn_cement:fetchCooldown")
AddEventHandler("lnn_cement:fetchCooldown", function(netid, time)
	cachedPlant[netid] = GetGameTimer() + (time * 1000)
end)

local bid = {}
local delay = 0
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestPlant do
            local x = GetClosestObjectOfType(playerCoords, 1.40, closestPlant[i], false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                entity = x
                Plant    = GetEntityCoords(entity)
                sleep  = 0
				local netid = string.format("%.2f%.2f%.2f",Plant.x,Plant.y,Plant.z)
				
				if cachedPlant[netid] and cachedPlant[netid] > GetGameTimer() then
					DrawText3D(Plant.x, Plant.y, Plant.z + 1.5, "There's no ~b~Cement~s~ left")  
				else
					DrawText3D(Plant.x, Plant.y, Plant.z + 1.5, 'Press [~g~E~s~] to steal ~b~Cement~s~')  
				end
				local lPed = GetPlayerPed(-1)
				if IsControlJustReleased(0, 38) and delay < GetGameTimer() and not IsPedInAnyVehicle(lPed, false) and IsPedOnFoot(lPed) and not isPickingUp then
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -255.94, -983.93, 30.21) < 1800 then 
					if not isPickingUp then 
						if not cachedPlant[netid] or cachedPlant[netid] and cachedPlant[netid] < GetGameTimer() then
							if bid[netid] and bid[netid] > GetGameTimer() then
								TriggerEvent("pNotify:SendNotification", {
									text = 'มีคนกำลังขโมยซีเมนต์กองนี้อยู่',
									type = "error",
									timeout = 5000,
									layout = "bottomCenter",
									queue = "global"
								})
							else
								delay = GetGameTimer() + 1000
								local police = exports.Porpy_Check:Check('Police')
								if police >= Config.Cops then
									TriggerEvent('lnn_policeAlert:alertNet','ขโมยปูน',"rgb(0,255,127,0.5)")
									if StartMinigame() then 
										TriggerServerEvent('lnn_cement:fetchCement', netid)
										OpenPlant(entity)
									else 
										OpenPlant2()
									end
								else
									TriggerEvent("pNotify:SendNotification", {
										text = 'ตำรวจไม่เพียงพอ',
										type = "error",
										timeout = 5000,
										layout = "bottomCenter",
										queue = "global"
									})
								end

							end
						else
							TriggerEvent("pNotify:SendNotification", {
								text = 'มีคนขโมยซีเมนต์ไปเเล้ว',
								type = "error",
								timeout = 5000,
								layout = "bottomCenter",
								queue = "global"
							})
						end
					end
				else 
					TriggerEvent("pNotify:SendNotification", {
						text = 'ไกลจากเมืองเกินไป',
						type = "error",
						timeout = 5000,
						layout = "bottomCenter",
						queue = "global"
					})
				end
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

function OpenPlant2() 
	isPickingUp = true
	TriggerEvent("mythic_progbar:client:progress", {
        name = "cment",
        duration = duration,
        label = "กำลังขโมยปูน",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
		animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 49,
        },
    }, function(status)
        if not status then
			isPickingUp = false
        end
    end)
end 

function OpenPlant(entity)
	isPickingUp = true
	    TriggerEvent("mythic_progbar:client:progress", {
        name = "cment",
        duration = duration,
        label = "กำลังขโมยปูน",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 49,
        },
    }, function(status)
        if not status then
        end
    end)
	
	Citizen.CreateThread(function()
		local netid = string.format("%.2f%.2f%.2f",Plant.x,Plant.y,Plant.z)
        local time = GetGameTimer() + duration
		
		while time > GetGameTimer() do
			Citizen.Wait(50)
			if cachedPlant[netid] and cachedPlant[netid] > GetGameTimer() then
				ESX.ShowNotification('~r~Action interrupted~s~, cement is already been stolen.')
				return
			end
		end
		
		TriggerServerEvent('lnn_cement:getItem', netid)
		ClearPedTasksImmediately(PlayerPedId())
		isPickingUp = false
	end)
end

RegisterNetEvent("lnn_cement:fetchCement")
AddEventHandler("lnn_cement:fetchCement", function(netid, src)
	if src ~= GetPlayerServerId(PlayerId()) then
		bid[netid] = GetGameTimer() + duration
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isPickingUp == true then
			DisableAllControlActions(0)
		end
	end
end)

DrawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	local scale = 0.45
   
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		--SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
	end
end

function StartMinigame()
	local Result = exports['xzero_skillcheck']:startGameSync({
		textTitle           = 'cement', -- ข้อความที่แสดง
		speedMin            = 9,         -- ความเร็วสุ่มตั้งแต่เท่าไหร่  (ยิ่งน้อยยิ่งเร็ว)
		speedMax            = 13,         -- ความเร็วสุ่มถึงเท่าไหร่    (ยิ่งน้อยยิ่งเร็ว)
		countSuccessMax     = 2,          -- กำหนดจำนวนครั้งที่สำเร็จ (เมื่อถึงเป้าจะ success)
		countFailedMax      = 1,          -- กำหนดจำนวนครั้งที่ล้มเหลว (เมื่อถึงเป้าจะ failed)
		layOut              = bottom,   -- ตำแหน่งที่แสดง | center กลาง | bottom ล่าง | top บน
		freezePos           = true,       -- true = ล็อคตำแหน่งผู้เล่นไม่ให้ขยับ
		playScenario        = '',         -- เล่นอนิเมชั่นประเภท TaskStartScenarios
		playAnim =  { 
			'',
			''
		}
	})
	return Result.status
end 