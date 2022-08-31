local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

local Hat = {}
local sleep = true 

RegisterNetEvent('lnn_openhat:placehat')
AddEventHandler('lnn_openhat:placehat', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent('lnn_openhat:Createtable', coords)
end)

RegisterNetEvent('lnn_openhat:Createprop')
AddEventHandler('lnn_openhat:Createprop', function(identifier,data)
    Hat[identifier] = data 
    CreateObject(data.Coords)
end)

RegisterNetEvent('lnn_openhat:updateMoneyCl')
AddEventHandler('lnn_openhat:updateMoneyCl', function(k,money)
    Hat[k].Money = Hat[k].Money + money
end)

RegisterNetEvent('lnn_openhat:deleteHat')
AddEventHandler('lnn_openhat:deleteHat', function(k)
    local x,y,z = table.unpack(Hat[k].Coords)
    DeleteObjects(x,y,z)
    Hat[k] = nil 
end)

RegisterNetEvent('lnn_openhat:Firstjoin')
AddEventHandler('lnn_openhat:Firstjoin', function(data)
    PlayerData = ESX.GetPlayerData()
    Hat = data 
    for k, v in pairs(Hat) do 
        CreateObject(v.Coords)
    end 
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        sleep = true 
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for k, v in pairs(Hat) do 
            if GetDistanceBetweenCoords(Coords, v.Coords, true) < 5 then 
                sleep = false
                if PlayerData.identifier == k then
                    Draw3DTextWithRect(v.Coords, 'Tips ~y~'..math.floor(v.Money)..' $ ~w~Press ~b~[E] ~w~to pickup',20.0)
                    if IsControlJustPressed(0, 38) then 
                        OpenManageMenu(k)
                    end 
                else 
                    Draw3DTextWithRect(v.Coords, 'Tips ~y~'..math.floor(v.Money)..' $ ~w~Press ~b~[E] ~w~to tips',20.0)
                    if IsControlJustPressed(0, 38) then 
                        OpenTipsMenu(k,v)
                    end 
                end 
            end 
        end 
        if sleep then 
            Citizen.Wait(500)
        end 
    end 
end)

DeleteObjects = function(x,y,z)
    local chair = GetClosestObjectOfType(x,y,z, 1.0, GetHashKey(Config.Prop), false, false, false)
    DeleteObject(chair)
end 

CreateObject = function(coords)
    local x,y,z = table.unpack(coords)
    local location = { x = x, y = y, z = z-1}
    
    ESX.Game.SpawnLocalObject(Config.Prop, location, function(object)
        PlaceObjectOnGroundProperly(object)
        FreezeEntityPosition(object, true)
    end)
end 

OpenManageMenu = function(k)
    TriggerServerEvent('lnn_openhat:Pickup', k)
end 

OpenTipsMenu = function(k,v)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tips', {
		title = 'ระบุจำนวนเงิน',
	}, function(data, menu)
        ESX.UI.Menu.CloseAll()
        if GetMoney(tonumber(data.value)) then 
            TriggerServerEvent('lnn_openhat:updateMoney', k, data.value)
        else 
            ESX.ShowNotification('You dont have enough money')
        end 
	end, function(data, menu)
		menu.close()
	end)
end 

GetMoney = function(count)
    found = false
    if Config.ExtendedWeight then 
    for k, v in pairs(ESX.GetPlayerData().accounts) do 
        if v.name == 'money' then 
            if v.money >= count then 
                found = true
            end 
        end 
    end 
else 
    if ESX.GetPlayerData().money >= count then 
        found = true 
    end 
end 
    return found
end 

Draw3DTextWithRect = function(coords, text,radius,size)
    local x,y,z = table.unpack(coords)
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

