function SpawnPedAndJoinEvent()
    local v = Config.UpbattleMain
    local location = vector3(v.JoinEventCoords.x, v.JoinEventCoords.y, v.JoinEventCoords.z - 1.0)
    LoadModels(GetHashKey(v.Npc.Model))
    Variable.NpcPed = CreatePed(5, v.Npc.Model, location, v.Npc.Heading, false)
    SetEntityAsMissionEntity(Variable.NpcPed, true, true)
    SetEntityAsMissionEntity(Variable.NpcPed, true, true)
    SetBlockingOfNonTemporaryEvents(Variable.NpcPed, true)
    SetEntityInvincible(Variable.NpcPed, true, true)
    FreezeEntityPosition(Variable.NpcPed, true, true)
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local sleep = true
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local NpcCoords = GetEntityCoords(Variable.NpcPed)
            local distance = #(Coords - NpcCoords)
            if distance <= 3 then 
                sleep = false 
                if Variable.IsInEvent then 
                    Draw3DTextWithRect(v.JoinEventCoords, '~w~Press ~b~[E] ~w~to ~r~exit ~y~event',20.0)
                    if IsControlJustReleased(0, 38) then 
                        Variable.IsInEvent = false 
                        TriggerServerEvent('lnn_upbattle:exitevent')
                    end 
                else 
                    Draw3DTextWithRect(v.JoinEventCoords, '~w~Press ~b~[E] ~w~to ~g~join ~y~event',20.0)
                    if IsControlJustReleased(0, 38) then 
                        Variable.IsInEvent = true 
                        TriggerServerEvent('lnn_upbattle:joinevent')
                        IsInEventLoop()
                    end 
                end 
            end 
            if sleep then 
                Citizen.Wait(500)
            end 
            if Variable.NpcPed == nil then 
                break
            end 
        end 
    end)
end 

function IsInEventLoop()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local min, sec = secondsToClock(Variable.Time)
            DrawTimerBar("TIME LEFT", ''..min..':'..sec..'', 3)
            DrawTimerBar2("ALIVE", Variable.PlayerCount,3)
            if not Variable.IsInEvent then 
                break
            end 
        end 
    end)
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

function DrawTimerBar2(title, text, barIndex)
	local width = 0.13
	local hTextMargin = 0.003
	local rectHeight = 0.038
	local textMargin = 0.008
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = 0.85
	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, 0.038, 0, 0, 0, 0, 128)
	DrawText2d(title, GetSafeZoneSize() - width + hTextMargin, rectY - textMargin, 0.32)
	DrawText2d(string.upper(text), GetSafeZoneSize() - hTextMargin, rectY - 0.0175, 0.5, true, width / 2)
end

function DrawTimerBar(title, text, barIndex)
	local width = 0.13
	local hTextMargin = 0.003
	local rectHeight = 0.038
	local textMargin = 0.008
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = 0.80
	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, 0.038, 0, 0, 0, 0, 128)
	DrawText2d(title, GetSafeZoneSize() - width + hTextMargin, rectY - textMargin, 0.32)
	DrawText2d(string.upper(text), GetSafeZoneSize() - hTextMargin, rectY - 0.0175, 0.5, true, width / 2)
end

function DrawText2d(text, x, y, scale, right, width)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(254, 254, 254, 255)
	if right then
		SetTextWrap(x - width, x)
		SetTextRightJustify(true)
	end
	BeginTextCommandDisplayText("STRING")	
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

function LoadModels(models)
    if IsModelValid(models) then
        while not HasModelLoaded(models) do
            RequestModel(models)
            Citizen.Wait(10)
        end
    end
end
    
function DrawText3D(x, y, z, text,r,g,b,a)
    SetTextScale(0.35, 0.35)
    SetTextFont(fontId)
    SetTextProportional(1)
	if r and g and b and a then
		SetTextColour(r, g, b, a)
	else
		SetTextColour(255, 255, 255, 215)
	end
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    ClearDrawOrigin()
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

function RandomWeapon()
    local Ped = PlayerPedId()
    local key = math.random(1, #Config.RandomWeapon)
    if not HasPedGotWeapon(Ped, GetHashKey(Config.RandomWeapon[key][1]), false) then 
        GiveWeaponToPed(Ped, GetHashKey(Config.RandomWeapon[key][1]), Config.RandomWeapon[key][2], true, true)
        Variable.Weapondata = Config.RandomWeapon[key][1]
        TriggerEvent("pNotify:SendNotification", {
            text = 'คุณได้รับอาวุธ '..Variable.ESX.GetWeaponLabel(Config.RandomWeapon[key][1])..'',
            type = "success",
        })
    else 
		Citizen.Wait(10)
        RandomWeapon()
    end 
end 

function RemoveWeapon()
    Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(0)
			local Ped = PlayerPedId()
			if HasPedGotWeapon(Ped, GetHashKey(Variable.Weapondata), false) == 1 then 
				RemoveWeaponFromPed(Ped, Variable.Weapondata)
			else 
				break
			end
		end 
	end)
end 
