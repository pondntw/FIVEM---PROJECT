ESX = nil
local ped 
local timeout = 0
local min, sec = 0 , 0
local Isselling = false
local InAction = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('lnn_selldrug:StartSelldrug')
AddEventHandler('lnn_selldrug:StartSelldrug', function(itemname, data)
    if not Isselling then 
        if data.CopCount <= GetPolice() then 
            StartSelldrug(itemname, data)
            Isselling = true
        else
            exports.pNotify:SendNotification({
                text = "ตำรวจไม่เพียงพอ",
                type = "error",
                timeout = math.random(2000),
                layout = "centerLeft",
                queue = "left"
            })
        end
    end
end)

function StartSelldrug(itemname, data)
    local point = math.random(1, #Config.CoordsRandom) 
    local coords = Config.CoordsRandom[point]
    local x, y, z = table.unpack(coords)
    SetNewWaypoint(x, y)
    SpawnNPC(x, y, z)
    SetTimeOut(data.Timeout, itemname)
    StartSellingLoop(itemname, data)
end 

function StartSellingLoop(itemname, data)
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local coords = GetEntityCoords(ped)
            local pedCoordsx,pedCoordsy,pedCoordsz = table.unpack(coords)
            if Isselling then 
                drawTxt('Time left '..min..':'..sec..' minutes', 4, {255, 255, 255}, 0.35, 0.0,0.07500)
                if GetDistanceBetweenCoords(Coords, coords, true) < 2 then 
                    if not InAction and IsPedOnFoot(Ped) then 
                        Draw3DTextWithRect(pedCoordsx,pedCoordsy,pedCoordsz," ~w~Press ~b~[E] ~w~to ~y~Selling",20.0)
                        if IsControlJustPressed(0, 38) then 
                            InAction = true
                            local rdm = math.random(1, 100)
                            if rdm <= data.SellPerCent then 
                                v = data.Success
                                local rdm = math.random(1,100)
                                if rdm <= v.PercentFreezeCallCop then
                                    PoliceAlert()
                                    TriggerEvent("mythic_progbar:client:progress", {
                                        name = "unique_action_name",
                                        duration = v.Freeze,
                                        label = "ขายสำเร็จตำรวจกำลังมา",
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                        animation = {
                                            animDict = "missheistdockssetup1clipboard@idle_a",
                                            anim = "idle_a",
                                        },
                                        prop = {
                                            model = "prop_paper_bag_small",
                                        }
                                    }, function(status)
                                        Deleteped()
                                        timeout = 0
                                        Isselling = false
                                        InAction = false
                                        if not status then
                                            if HasItem(itemname) then 
                                                TriggerServerEvent('lnn_selldrug:SuccessSell', itemname, data)
                                            end 
                                        end
                                    end)
                                else 
                                    exports.pNotify:SendNotification({
                                        text = "ขายสำเร็จ",
                                        type = "error",
                                        timeout = math.random(2000),
                                        layout = "centerLeft",
                                        queue = "left"
                                    })
                                    Deleteped()
                                    timeout = 0
                                    Isselling = false
                                    InAction = false
                                    if HasItem(itemname) then 
                                        TriggerServerEvent('lnn_selldrug:SuccessSell', itemname, data)
                                    end 
                                end
                            else 
                                v = data.Fail
                                local rdm = math.random(1,100)
                                if rdm <= v.PercentFreezeCallCop then 
                                    PoliceAlert()
                                    TriggerEvent("mythic_progbar:client:progress", {
                                        name = "unique_action_name",
                                        duration = v.Freeze,
                                        label = "ขายไม่สำเร็จตำรวจกำลังมา",
                                        useWhileDead = false,
                                        canCancel = false,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                    }, function(status)
                                        Deleteped()
                                        timeout = 0
                                        Isselling = false
                                        InAction = false
                                    end)
                                else 
                                    exports.pNotify:SendNotification({
                                        text = "ขายไม่สำเร็จ",
                                        type = "error",
                                        timeout = math.random(2000),
                                        layout = "centerLeft",
                                        queue = "left"
                                    })
                                    Deleteped()
                                    timeout = 0
                                    Isselling = false
                                    InAction = false
                                end
                            end 
                        end 
                    end 
                end 
            else 
                break
            end 
        end 
    end)
end 

function SpawnNPC(x, y, z)
    RequestModel(GetHashKey(Config.Model))
    while not HasModelLoaded(GetHashKey(Config.Model)) do
        Wait(1)
    end
    ped =  CreatePed(4, GetHashKey(Config.Model),x, y, z-1.0, 3374176, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end 

function SetTimeOut(time,itemname)
    timeout = time 
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1000)
            if timeout > 0 then 
                if not InAction then 
                    timeout = timeout - 1 
                end 
                min, sec = secondsToClock(timeout)
            else 
                Deleteped()
                Isselling = false 
                local InAction = false
                break
            end 
        end 
    end)
end 

function Deleteped()
    DeleteEntity(ped)
    ped = nil
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

function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

Draw3DTextWithRect = function(x,y,z, text,radius,size)
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	if(Vdist(pos.x, pos.y, pos.z, x, y, z) < radius) then
		local fontSize = size and size or 0.35 -- initialize size if not mentioned
		local onScreen,_x,_y=World3dToScreen2d(x,y,z)
		local px,py,pz=table.unpack(GetGameplayCamCoords())

		SetTextScale(fontSize, fontSize)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor
		_, count = text:gsub("~", '')
		if count > 0 then
			local total_additional = count / 2
			local result = count + total_additional
			factor = (string.len(text) - result) / 370
		else
			factor = (string.len(text)) / 370
		end
		DrawRect(_x,_y+0.0065+(fontSize/45), factor+(fontSize/(8-(fontSize*(factor*50)))), 0.03+(fontSize/(20-factor)), 35, 36, 37, 150)
	end
end

function HasItem(itemname) 
    for k, v in pairs(ESX.GetPlayerData().inventory) do 
        if itemname == v.name and v.count >= 0 then 
            return true 
        end     
    end 
    return false
end 