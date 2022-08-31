ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
IsInBoat = false
Vehicle = nil 
currentSeat = 0

AddEventHandler('lnn_anchor:enteredVehicle', function(vehicle, seat)
	Vehicle = vehicle 
	currentSeat = seat
	if GetVehicleClass(vehicle) == 14 then 
		IsInBoat = true
		if currentSeat == -1 then 
			if IsBoatAnchoredAndFrozen(Vehicle) then 
				SendNUIMessage({
					type = "logo",
					display = true
				})
			else 
				SendNUIMessage({
					type = "logo",
					display = false
				})
			end 
		end
	end 
end)

AddEventHandler('lnn_anchor:leftVehicle', function()
	if IsInBoat then 
		IsInBoat = false
		Vehicle = nil
		currentSeat = 0
		SendNUIMessage({
			type = "logo",
			display = false
		})
	end 
end)

RegisterKeyMapping(Config.Command, 'Anchor', 'keyboard', Config.KeyMapping)

RegisterCommand(Config.Command, function()
	local speed = GetEntitySpeed(Vehicle)
	local kmh = tonumber(math.ceil(speed * 3.6))
	if IsInBoat and currentSeat == -1 then 
		if CanAnchorBoatHere(Vehicle) and not IsBoatAnchoredAndFrozen(Vehicle) then 
			if kmh >= Config.LowSpeed then 
				TriggerEvent("pNotify:SendNotification", {
					text = Config.Notify[3],
					type = "error",
				})
				return
			end 
			TriggerEvent("pNotify:SendNotification", {
				text = Config.Notify[1],
				type = "success",
			})
			SendNUIMessage({
				type = "logo",
				display = true
			})
			SetBoatAnchor(Vehicle,true)
			SetBoatFrozenWhenAnchored(Vehicle,true)
		elseif IsBoatAnchoredAndFrozen(Vehicle) then 
			if kmh >= Config.LowSpeed then 
				TriggerEvent("pNotify:SendNotification", {
					text = Config.Notify[3],
					type = "error",
				})
				return
			end 
			TriggerEvent("pNotify:SendNotification", {
				text = Config.Notify[2],
				type = "success",
			})
			SendNUIMessage({
				type = "logo",
				display = false
			})
			SetBoatAnchor(Vehicle,false)
			SetBoatFrozenWhenAnchored(Vehicle,false)
		end
	end 
end, false)
