function JobLoop()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            Variable.SleepLoop = true
            for k, v in pairs(Config.Hospitals) do 
                for key, value in pairs(v.Vehicles) do 
                    local distance = #(Coords - value.Spawner)
                    if distance <= 50.0 then 
                        Variable.SleepLoop = false
                        DrawMarker(value.Marker.type, value.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, value.Marker.x, value.Marker.y, value.Marker.z, value.Marker.r, value.Marker.g, value.Marker.b, value.Marker.a, false, false, 2, value.Marker.rotate, nil, nil, false)
                        if distance <= 3.0 then 
                            if IsControlJustReleased(0, 38) then
                                OpenVehicleMenu(k, key)
                            end 
                        end 
                    end
                end 
            end 
            for k, v in pairs(Config.Hospitals) do 
                for key, value in pairs(v.Helicopters) do 
                    local distance = #(Coords - value.Spawner)
                    if distance <= 50.0 then 
                        Variable.SleepLoop = false
                        DrawMarker(value.Marker.type, value.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, value.Marker.x, value.Marker.y, value.Marker.z, value.Marker.r, value.Marker.g, value.Marker.b, value.Marker.a, false, false, 2, value.Marker.rotate, nil, nil, false)
                        if distance <= 3.0 then 
                            if IsControlJustReleased(0, 38) then
                                OpenHelicopterMenu(k, key)
                            end 
                        end 
                    end
                end 
            end 
            for k, v in pairs(Config.Hospitals) do 
                for key, value in pairs(v.FastTravels) do 
                    local distance = #(Coords - value.From)
                    if distance <= 50.0 then 
                        Variable.SleepLoop = false
                        DrawMarker(value.Marker.type, value.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, value.Marker.x, value.Marker.y, value.Marker.z, value.Marker.r, value.Marker.g, value.Marker.b, value.Marker.a, false, false, 2, value.Marker.rotate, nil, nil, false)
                        if distance <= 3.0 then 
                            if IsControlJustReleased(0, 38) then 
                                DoScreenFadeOut(800)

                                while not IsScreenFadedOut() do
                                    Citizen.Wait(500)
                                end
                                FreezeEntityPosition(Ped, true)
                                SetEntityCoords(Ped, value.To.coords)
                                Citizen.Wait(1000)
                                FreezeEntityPosition(Ped, false)
                                DoScreenFadeIn(800)
                            end
                        end 
                    end
                end 
            end
            if Variable.Job.grade_name == 'boss' then  
                for k, v in pairs(Config.Hospitals) do 
                    for key, value in pairs(v.AmbulanceActions) do 
                        local distance = #(Coords - value)
                        if distance <= 50.0 then 
                            Variable.SleepLoop = false
                            DrawMarker(Config.Marker.type, value, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
                            if distance <= 3.0 then 
                                if IsControlJustReleased(0, 38) then 
                                    OpenAmbulanceActionsMenu()
                                end 
                            end 
                        end
                    end 
                end 
            end
            if Variable.Job.name ~= 'ambulance' then 
                break
            end 
            if Variable.SleepLoop then 
                Citizen.Wait(500)
            end 
        end 
    end)

    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            if IsControlJustReleased(0, 167) then 
                OpenAmbulanceMenu()
            end 
            if Variable.Job.name ~= 'ambulance' then 
                break
            end 
        end     
    end)    
end 

function OpenAmbulanceActionsMenu()
	local elements = {
		-- {label = _U('cloakroom'), value = 'cloakroom'}
	}

	-- if Config.EnablePlayerManagement and Job.grade_name == 'boss' then
		table.insert(elements, {label = 'เมนูบอส', value = 'boss_actions'})
	-- end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = 'เมนูจัดการ',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false, grades= false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleMenu(k, key)
    local v = Config.Hospitals[k].Vehicles[key]
    local elements = {
        { label = 'ซื้อรถ', value = 'buy'},
        { label = 'เบิกรถ', value = 'getout'},
        { label = 'เก็บรถ', value = 'getin'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
        title    = 'เมนูรถ',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'buy' then
            local shopCoords = Config.Hospitals[k].Vehicles[key].InsideShop
            local shopElements = {}

            local authorizedVehicles = Config.AuthorizedVehicles[Variable.Job.grade_name]

            if #authorizedVehicles > 0 then
                for k,vehicle in ipairs(authorizedVehicles) do
                    table.insert(shopElements, {
                        label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label,  ESX.Math.GroupDigits(vehicle.price)),
                        name  = vehicle.label,
                        model = vehicle.model,
                        price = vehicle.price,
                        type  = 'car'
                    })
                end
            else
                return
            end

            OpenShopMenu(shopElements, GetEntityCoords(PlayerPedId()), shopCoords)
        elseif data.current.value == 'getout' then
            local garage = {}
			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)
						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format('stored')
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format('not in garage')
						end
						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = 'รายการรถ',
						align    = 'top-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(k, 'Vehicles', key)
							if foundSpawn then
								menu2.close()
								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
                                    exports.pNotify:SendNotification({
                                        text = "เบิกรถเรียบร้อย",
                                        type = "success",
                                    })
								end)
							end
						else
                            exports.pNotify:SendNotification({
                                text = "รถของคุณไม่อยู่ในการาจ",
                                type = "error",
                            })
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
                    exports.pNotify:SendNotification({
                        text = "คุณไม่มีรถในการาจ",
                        type = "error",
                    })
				end
			end, 'car')
        elseif data.current.value == 'getin' then 
            StoreNearbyVehicle(GetEntityCoords(PlayerPedId()))
        end
    end, function(data, menu)
        menu.close()
    end)
end 

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}
	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
        exports.pNotify:SendNotification({
            text = "ไม่มีรถในบริเวณนี้",
            type = "error",
        })
		return
	end
	ESX.TriggerServerCallback('lnn:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1
				if attempts > 30 then
					break
				end
				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end
			IsBusy = false
            exports.pNotify:SendNotification({
                text = "เก็บรถเรียบร้อย",
                type = "success",
            })
		else
            exports.pNotify:SendNotification({
                text = "ไม่มีรถที่เป็นของคุณในบริเวณนี้",
                type = "error",
            })
		end
	end, vehiclePlates)
end

function StoreNearbyHelicopter(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}
	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
        exports.pNotify:SendNotification({
            text = "ไม่มีเฮลิคอปเตอร์ในบริเวณนี้",
            type = "error",
        })
		return
	end
	ESX.TriggerServerCallback('lnn:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1
				if attempts > 30 then
					break
				end
				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end
			IsBusy = false
            exports.pNotify:SendNotification({
                text = "เก็บเฮลิคอปเตอร์เรียบร้อย",
                type = "success",
            })
		else
            exports.pNotify:SendNotification({
                text = "ไม่มีเฮลิคอปเตอร์ที่เป็นของคุณในบริเวณนี้",
                type = "error",
            })
		end
	end, vehiclePlates)
end

function OpenHelicopterMenu(k, key)
    local v = Config.Hospitals[k].Helicopters[key]
    local elements = {
        { label = 'ซื้อเฮลิคอปเตอร์', value = 'buy'},
        { label = 'เบิกเฮลิคอปเตอร์', value = 'getout'},
        { label = 'เก็บเฮลิคอปเตอร์', value = 'getin'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
        title    = 'เมนูเฮลิคอปเตอร์',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'buy' then
            local shopCoords = Config.Hospitals[k].Helicopters[key].InsideShop
            local shopElements = {}

            local authorizedVehicles = Config.AuthorizedHelicopters[Variable.Job.grade_name]

            if #authorizedVehicles > 0 then
                for k,vehicle in ipairs(authorizedVehicles) do
                    table.insert(shopElements, {
                        label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label,  ESX.Math.GroupDigits(vehicle.price)),
                        name  = vehicle.label,
                        model = vehicle.model,
                        price = vehicle.price,
                        type  = 'helicopter'
                    })
                end
            else
                return
            end

            OpenHelicopterShopMenu(shopElements, GetEntityCoords(PlayerPedId()), shopCoords)
        elseif data.current.value == 'getout' then
            local garage = {}
			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)
						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format('stored')
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format('not in garage')
						end
						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = 'รายการเฮลิคอปเตอร์',
						align    = 'top-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(k, 'Helicopters', key)
							if foundSpawn then
								menu2.close()
								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
                                    exports.pNotify:SendNotification({
                                        text = "เบิกเฮลิคอปเตอร์เรียบร้อย",
                                        type = "success",
                                    })
								end)
							end
						else
                            exports.pNotify:SendNotification({
                                text = "เฮลิคอปเตอร์ของคุณไม่อยู่ในการาจ",
                                type = "error",
                            })
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
                    exports.pNotify:SendNotification({
                        text = "คุณไม่มีเฮลิคอปเตอร์ในการาจ",
                        type = "error",
                    })
				end
			end, 'helicopter')
        elseif data.current.value == 'getin' then 
            StoreNearbyHelicopter(GetEntityCoords(PlayerPedId()))
        end
    end, function(data, menu)
        menu.close()
    end)
end 

function GetAvailableVehicleSpawnPoint(hospital, part, partNum)
	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil
	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end
	if found then
		return true, foundSpawnPoint
	else
        exports.pNotify:SendNotification({
            text = "ไม่มีที่ว่างในการเบิกรถ",
            type = "error",
        })
		return false
	end
end

function OpenHelicopterShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	Variable.isInShopMenu = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = 'ร้านเฮลิคอปเตอร์',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = ('ยืนยันที่จะซื้อ '..data.current.name..' ในราคา '..data.current.price..' $'),
			align    = 'top-right',
			elements = {
				{ label = 'ยกเลิก', value = 'no' },
				{ label = 'ซื้อ', value = 'yes' }
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate
                if ESX.getAccount('money') >= data.current.price then 
                    print(data.current.type)
                    TriggerServerEvent('lnn_ambulancejob:buyJobVehicle', props, data.current.type, data.current.price)
                    Variable.isInShopMenu = false
                    ESX.UI.Menu.CloseAll()
                    DeleteSpawnedVehicles()
                    FreezeEntityPosition(playerPed, false)
                    SetEntityVisible(playerPed, true)
                    ESX.Game.Teleport(playerPed, restoreCoords)
                    TriggerServerEvent('takzobye-inventory:getCarKeys')
                    exports.pNotify:SendNotification({
                        text = "คุณซื้อรถ "..data.current.name.." ในราคา "..ESX.Math.GroupDigits(data.current.price).. "$",
                        type = "success",
                    })
                else
                    exports.pNotify:SendNotification({
                        text = "คุณมีเงินไม่เพียงพอ",
                        type = "error",
                    })
                    menu2.close()
                end 
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
		end, function(data, menu)
		Variable.isInShopMenu = false
		ESX.UI.Menu.CloseAll()
		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(Variable.spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)
    WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(Variable.spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	Variable.isInShopMenu = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = 'ร้านขายรถ',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = ('ยืนยันที่จะซื้อ '..data.current.name..' ในราคา '..data.current.price..' $'),
			align    = 'top-right',
			elements = {
				{ label = 'ยกเลิก', value = 'no' },
				{ label = 'ซื้อ', value = 'yes' }
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate
                if ESX.getAccount('money') >= data.current.price then 
                    TriggerServerEvent('lnn_ambulancejob:buyJobVehicle', props, data.current.type, data.current.price)
                    Variable.isInShopMenu = false
                    ESX.UI.Menu.CloseAll()
                    DeleteSpawnedVehicles()
                    FreezeEntityPosition(playerPed, false)
                    SetEntityVisible(playerPed, true)
                    ESX.Game.Teleport(playerPed, restoreCoords)
                    TriggerServerEvent('takzobye-inventory:getCarKeys')
                    exports.pNotify:SendNotification({
                        text = "คุณซื้อรถ "..data.current.name.." ในราคา "..ESX.Math.GroupDigits(data.current.price).. "$",
                        type = "success",
                    })
                else
                    exports.pNotify:SendNotification({
                        text = "คุณมีเงินไม่เพียงพอ",
                        type = "error",
                    })
                    menu2.close()
                end 
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
		end, function(data, menu)
		Variable.isInShopMenu = false
		ESX.UI.Menu.CloseAll()
		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(Variable.spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)
    WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(Variable.spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableControlAction(0, 27, true)
			DisableControlAction(0, 173, true)
			DisableControlAction(0, 174, true)
			DisableControlAction(0, 175, true)
			DisableControlAction(0, 176, true) 
			DisableControlAction(0, 177, true)
			drawLoadingText('the vehicle is currently ~g~DOWNLOADING & LOADING~s~ please wait', 255, 255, 255, 255)
		end
	end
end

function DeleteSpawnedVehicles()
	while #Variable.spawnedVehicles > 0 do
		local vehicle = Variable.spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(Variable.spawnedVehicles, 1)
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenAmbulanceMenu()
	local elements = {
        { label = 'ชุบผู้เล่น', value = 'revive'},
        { label = 'ฮีลใหญ่', value = 'healbig'},
        { label = 'ฮีลเล็ก', value = 'healsmall'},
        { label = 'บิล', value = 'bill'},
        { label = 'อุ้ม', value = 'hold'},
        { label = 'ปล่อยอุ้ม', value = 'unhold'},
        { label = 'ตรวจบัตรประชาชน', value = 'identity'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = 'เมนูเเพทย์',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'revive' then
            reiveplayer()
        elseif data.current.value == 'healbig' then
            HealPlayer('big')
        elseif data.current.value == 'healsmall' then 
            HealPlayer('small')
        elseif data.current.value == 'bill' then 
            Billing()
        elseif data.current.value == 'hold' then
            Hold()
        elseif data.current.value == 'unhold' then 
            UnHold()
        elseif data.current.value == 'identity' then
            identityCheck()
		end
	end, function(data, menu)
		menu.close()
	end)
end 

function reiveplayer()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    local Ped = PlayerPedId()
    if Variable.InAction then return end 
    if closestPlayer == -1 or closestDistance > 3.0 then
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นใกล้ๆ",
            type = "error",
        })
    else
        if IsPedDeadOrDying(closestPlayerPed, 1) then 
            if ESX.HasItem('medikit') then 
                ESX.UI.Menu.CloseAll()
                Variable.InAction = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "unique_action_name",
                    duration = 10000,
                    label = "กำลังชุบชีวิต",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false,
                    },
                    animation = {
                        animDict = "mini@cpr@char_a@cpr_str",
                        anim = "cpr_pumpchest",
                    },
                }, function(status)
                    Variable.InAction = false
                    StopAnimTask(Ped, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1.0)
                    ClearPedSecondaryTask(Ped)
                    if not status then
                        if not IsEntityDead(Ped) and ESX.HasItem('medikit') then
                            TriggerServerEvent('lnn_ambulancejob:removeitem', 'medikit', 1)
                            TriggerServerEvent('lnn_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                        end 
                    end
                end)
            else
                exports.pNotify:SendNotification({
                    text = "ต้องการไอเทม "..ESX.GetItem()['medikit'].label.." 1 ชิ้น",
                    type = "error",
                })
            end 
        end 
    end 
end 

function HealPlayer(data)
    if data == 'small' then 
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        local Ped = PlayerPedId()
        if Variable.InAction then return end 
        if closestPlayer == -1 or closestDistance > 3.0 then
            exports.pNotify:SendNotification({
                text = "ไม่มีผู้เล่นใกล้ๆ",
                type = "error",
            })
        else
            if ESX.HasItem('bandage') then 
                ESX.UI.Menu.CloseAll()
                Variable.InAction = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "unique_action_name",
                    duration = 10000,
                    label = "กำลังฮีล",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false,
                    },
                    animation = {
                        task = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
                    },
                }, function(status)
                    Variable.InAction = false
                    ClearPedSecondaryTask(Ped)
                    if not status then
                        if not IsEntityDead(Ped) and ESX.HasItem('bandage') then
                            TriggerServerEvent('lnn_ambulancejob:removeitem', 'bandage', 1)
                            TriggerServerEvent('lnn_ambulancejob:heal', GetPlayerServerId(closestPlayer), 50)
                        end 
                    end
                end)
            else
                exports.pNotify:SendNotification({
                    text = "ต้องการไอเทม "..ESX.GetItem()['bandage'].label.." 1 ชิ้น",
                    type = "error",
                })
            end 
        end
    else 
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        local Ped = PlayerPedId()
        if Variable.InAction then return end 
        if closestPlayer == -1 or closestDistance > 3.0 then
            exports.pNotify:SendNotification({
                text = "ไม่มีผู้เล่นใกล้ๆ",
                type = "error",
            })
        else
            -- if IsPedDeadOrDying(closestPlayerPed, 1) then 
                if ESX.HasItem('medikit') then 
                    ESX.UI.Menu.CloseAll()
                    Variable.InAction = true
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "unique_action_name",
                        duration = 10000,
                        label = "กำลังฮีล",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false,
                        },
                        animation = {
                            task = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
                        },
                    }, function(status)
                        Variable.InAction = false
                        ClearPedSecondaryTask(Ped)
                        if not status then
                            if not IsEntityDead(Ped) and ESX.HasItem('medikit') then
                                TriggerServerEvent('lnn_ambulancejob:removeitem', 'medikit', 1)
                                TriggerServerEvent('lnn_ambulancejob:heal', GetPlayerServerId(closestPlayer), 100)
                            end 
                        end
                    end)
                else
                    exports.pNotify:SendNotification({
                        text = "ต้องการไอเทม "..ESX.GetItem()['medikit'].label.." 1 ชิ้น",
                        type = "error",
                    })
                end 
            -- end 
        end    
    end 
end 

function Billing()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    local Ped = PlayerPedId()
    if closestPlayer == -1 or closestDistance > 3.0 then
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นใกล้ๆ",
            type = "error",
        })
    else
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bill_choice', { title = "บิลค่า" },
        function(input, dialog)
            if input.value == nil then
                exports.pNotify:SendNotification({
                    text = "ต้องกรอกข้อมูลนี้",
                    type = "error",
                })
            else
                dialog.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bill_money',
                { title = "เป็นจำนวนเงิน" },
                function(data1, menu1)
                    local money = tonumber(data1.value)
                    if money == nil then
                        exports.pNotify:SendNotification({
                            text = "กรอกข้อมูลเป็นตัวเลข",
                            type = "error",
                        })
                    else
                        menu1.close()
                        print(GetPlayerServerId(closestPlayer), '', input.value , data1.value)
                        -- TriggerServerEvent('lnn_ambulancejob:sendBill', GetPlayerServerId(closestPlayer), '', input.value , data1.value)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', input.value , data1.value)
                    end
                end,function(data1, menu1)
                    menu1.close()
                end)
            end
        end,function(input, dialog)
            dialog.close()
        end)
    end 
end

function identityCheck()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    local Ped = PlayerPedId()
    if closestPlayer == -1 or closestDistance > 3.0 then
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นใกล้ๆ",
            type = "error",
        })
    else
        ESX.TriggerServerCallback('lnn_ambulancejob:getOtherPlayerData', function(data)
            local elements = {
                {label = 'ชื่อ:'..data.name..''},
                {label = 'อาชีพ: '..data.job..' '..data.grade..''}
                -- {label = ('อาชีพ: %s', ('%s - %s'):format(data.job, data.grade))}
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title    = 'ข้อมูลของ '..data.name,
                align    = 'top-right',
                elements = elements
            }, nil, function(data, menu)
                menu.close()
            end)
        end, GetPlayerServerId(closestPlayer))
    end 
end 

function Hold()
    local Ped = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(Ped), 3.0)
    local valPlayers = false
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            valPlayers = true
            TriggerServerEvent('lnn_ambulancejob:Hold',GetPlayerServerId(players[i]))
        end
    end
    if not valPlayers then 
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นใกล้ๆ",
            type = "error",
        })
    end
end

function UnHold()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 5.0 then
        TriggerServerEvent('lnn_ambulancejob:unHold',GetPlayerServerId(closestPlayer))
    else
        exports.pNotify:SendNotification({
            text = "ไม่มีผู้เล่นใกล้ๆ",
            type = "error",
        })
    end
end 

RegisterNetEvent('lnn_ambulancejob:heal')
AddEventHandler('lnn_ambulancejob:heal', function(heal)
    local Ped = PlayerPedId()
    local Health = GetEntityHealth(Ped)
    SetEntityHealth(Ped, Health+heal)

    exports.pNotify:SendNotification({
        text = "คุณถูกฟื่นฟูโดยเเพทย์",
        type = "error",
    })
end)

RegisterNetEvent('lnn_ambulancejob:Hold')
AddEventHandler('lnn_ambulancejob:Hold', function(ID)
	if Variable.IsDead then
	playerPed = PlayerPedId()
	targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(ID)))
	AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	ClearPedTasksImmediately(playerPed)
	FreezeEntityPosition(playerPed, false)
	end
end)

RegisterNetEvent('lnn_ambulancejob:unHold')
AddEventHandler('lnn_ambulancejob:unHold', function(ID)
	if Variable.IsDead then
	Ped = PlayerPedId()
	targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(ID)))
	DetachEntity(Ped, true, false)
	ClearPedTasksImmediately(Ped)
	FreezeEntityPosition(Ped, false)
	end
end)