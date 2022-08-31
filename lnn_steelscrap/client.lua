ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Entity = nil
Indelay = {}

Citizen.CreateThread(function()
    for k, v in pairs(Config.Coords) do
       local blip = AddBlipForCoord(v.coords)
       SetBlipSprite(blip, Config.Blip.BlipId)
       SetBlipScale (blip, Config.Blip.BlipSize)
       SetBlipColour(blip, Config.Blip.BlipColor)
       SetBlipAsShortRange(blip, true)
       BeginTextCommandSetBlipName('STRING')
       AddTextComponentSubstringPlayerName(Config.Blip.BlipName)
       EndTextCommandSetBlipName(blip)
    end 
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for key, value in pairs(Config.Coords) do  
            local distance = #(Coords - value.coords)
            if distance <= value.area then 
                for k, v in pairs(Config.ModelList) do 
                    local entity = GetClosestObjectOfType(Coords, 2.0, GetHashKey(v), false, false, false)
                    if DoesEntityExist(entity) then 
                        local coords = GetEntityCoords(entity)
                        local distance = #(Coords - coords)
                        if distance <= 3.0 then 
                            if Entity == nil then 
                                Entity = entity
                            end
                        end 
                    end 
                end 
            end
        end
    end 
end)

Citizen.CreateThread(function()
    sleep = true
    inAction = false 
    while true do 
        Citizen.Wait(0)
        sleep = true
        local Ped = PlayerPedId() 
        local Coords = GetEntityCoords(Ped)
        local coords = GetEntityCoords(Entity)
        local distance = #(Coords - coords)
        if Entity ~= nil then 
            sleep = false
            if distance <= 2 then 
                local netid = string.format("%.2f%.2f%.2f",coords.x,coords.y,coords.z)
                if not inAction then 
                    if Indelay[netid] then 
                        Draw3DTextWithRect(coords, "There's no ~y~scrap~s~ left",20.0)
                    else 
                        Draw3DTextWithRect(coords, 'Press ~b~E ~w~to ~y~steel scrap',20.0)
                        if IsControlJustPressed(0, 38) then 
                            inAction = true
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "unique_action_name",
                                duration = Config.Bar.time,
                                label = Config.Bar.text,
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    task = "WORLD_HUMAN_WELDING"
                                },
                            }, function(status)
                                inAction = false 
                                if not status then
                                    if not Indelay[netid] then 
                                        TriggerServerEvent('lnn_steelscrap:Additem', netid)
                                        Delay(netid)
                                    end 
                                end
                            end)
                        end
                    end
                end
            else 
                Entity = nil
            end     
        end 
        if sleep then 
            Citizen.Wait(500)
        end 
    end 
end)

function Delay(netid)
    Indelay[netid] = true 
    Citizen.Wait(Config.DelayPickUp * 60 * 1000)
    Indelay[netid] = false 
end 

function Draw3DTextWithRect(coords, text,radius,size)
    local x,y,z = table.unpack(coords)
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	if(Vdist(pos.x, pos.y, pos.z, x, y, z) < radius) then
		local fontSize = size and size or 0.35 -- initialize size if not mentioned
		local onScreen,_x,_y=World3dToScreen2d(x,y,z+1.0)
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
