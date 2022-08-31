function JobLoop()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            Variable.SleepLoop = true
            for k, v in pairs(Config.Mechanic) do 
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
            if Variable.Job.grade_name == 'boss' then  
                for k, v in pairs(Config.Mechanic) do 
                    for key, value in pairs(v.MechanicActions) do 
                        local distance = #(Coords - value)
                        if distance <= 50.0 then 
                            Variable.SleepLoop = false
                            DrawMarker(Config.Marker.type, value, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
                            if distance <= 3.0 then 
                                if IsControlJustReleased(0, 38) then 
                                    OpenMechanicActionsMenu()
                                end 
                            end 
                        end
                    end 
                end 
            end
            if Variable.SleepLoop then 
                Citizen.Wait(500)
            end 
            if Variable.Job.name ~= 'mechanic' then 
                break
            end 
        end     
    end)   
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            if IsControlJustReleased(0, 167) then 
                OpenMechanicMenu()
            end 
            if Variable.Job.name ~= 'mechanic' then 
                break
            end 
        end     
    end)   
    Citizen.CreateThread(function()
        local sleep = true
        local trackedEntities = {
            'prop_roadcone02a',
            'prop_toolchest_01'
        }
        while true do
            Citizen.Wait(0)
            sleep = true
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local closestDistance = -1
            local closestEntity = nil
            for i=1, #trackedEntities, 1 do
                local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)
                if DoesEntityExist(object) then
                    local objCoords = GetEntityCoords(object)
                    local distance  = GetDistanceBetweenCoords(coords, objCoords, true)
                    if closestDistance == -1 or closestDistance > distance then
                        closestDistance = distance
                        closestEntity   = object
                    end
                end
            end
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                sleep = false
                ESX.ShowHelpNotification('press ~INPUT_CONTEXT~ to remove the object')
                if IsControlJustReleased(0, 38) then 
                    DeleteEntity(closestEntity)
                end 
            end
            if sleep then 
                Citizen.Wait(500)
            end 
            if Variable.Job.name ~= 'mechanic' then 
                break
            end 
        end
    end)
end 

function OpenMechanicMenu()
	local elements = {
        { label = 'ซ่อมรถ', value = 'fix'},
        { label = 'เช็ดรถ', value = 'wash'},
        { label = 'งัดรถ', value = 'hijack'},
        { label = 'พาวน์รถ', value = 'pown'},
        { label = 'วางกล่อง', value = 'placebox'},
        { label = 'บิล', value = 'bill'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = 'เมนูช่าง',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'fix' then
            fixcar()
        elseif data.current.value == 'wash' then
            washcar()
        elseif data.current.value == 'hijack' then 
            hijack()
        elseif data.current.value == 'pown' then 
            impound()
        elseif data.current.value == 'placebox' then
            placebox()
        elseif data.current.value == 'bill' then 
            bill()
		end
	end, function(data, menu)
		menu.close()
	end)
end 

function fixcar()
    local Ped = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if Variable.InAction then return end 
    if IsPedSittingInAnyVehicle(Ped) then 
        exports.pNotify:SendNotification({
            text = "กรุณาลงจากรถก่อน",
            type = "error",
        })
        return
    end
    if DoesEntityExist(vehicle) then
        Variable.InAction = true 
        if ESX.HasItem('fixkit02') then 
            ESX.UI.Menu.CloseAll()
            Variable.InAction = true
            local fuel = GetFuel(vehicle)
            SetVehicleDoorOpen(vehicle, 4, false, false)
            TriggerEvent("mythic_progbar:client:progress", {
                name = "unique_action_name",
                duration = 20000,
                label = "กำลังซ่อมรถ",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                },
                animation = {
                    animDict = "mini@repair",
                    anim = "fixing_a_player",
                },
            }, function(status)
                Variable.InAction = false
                if not status then
                    if not IsEntityDead(Ped) and ESX.HasItem('fixkit02') then
                        TriggerServerEvent('lnn_mechanicjob:removeitem', 'fixkit02', 1)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                        SetVehicleUndriveable(vehicle, false)
                        SetVehicleEngineOn(vehicle, true, true)
                        SetFuel(vehicle, fuel)
                        exports.pNotify:SendNotification({
                            text = "ซ่อมรถเรียบร้อย",
                            type = "success",
                        })
                    end 
                end
            end)
        else
            exports.pNotify:SendNotification({
                text = "ต้องการไอเทม "..ESX.GetItem()['fixkit02'].label.." 1 ชิ้น",
                type = "error",
            })
        end 
    else
        exports.pNotify:SendNotification({
            text = "ไม่มีรถใกล้ๆ",
            type = "error",
        })
    end 
end 

function washcar()
    local Ped = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if Variable.InAction then return end 
    if IsPedSittingInAnyVehicle(Ped) then 
        exports.pNotify:SendNotification({
            text = "กรุณาลงจากรถก่อน",
            type = "error",
        })
        return
    end
    if DoesEntityExist(vehicle) then
        Variable.InAction = true 
        ESX.UI.Menu.CloseAll()
        Variable.InAction = true
        TriggerEvent("mythic_progbar:client:progress", {
            name = "unique_action_name",
            duration = 10000,
            label = "กำลังเช็ดรถ",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                task = 'WORLD_HUMAN_MAID_CLEAN'
            },
        }, function(status)
            Variable.InAction = false
            if not status then
                if not IsEntityDead(Ped) then
                    SetVehicleDirtLevel(vehicle, 0)
                    exports.pNotify:SendNotification({
                        text = "เช็ดรถเรียบร้อย",
                        type = "success",
                    })
                end 
            end
        end)
    else
        exports.pNotify:SendNotification({
            text = "ไม่มีรถใกล้ๆ",
            type = "error",
        })
    end 
end 

function hijack()
    local Ped = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if Variable.InAction then return end 
    if IsPedSittingInAnyVehicle(Ped) then 
        exports.pNotify:SendNotification({
            text = "กรุณาลงจากรถก่อน",
            type = "error",
        })
        return
    end
    if DoesEntityExist(vehicle) then
        Variable.InAction = true 
        ESX.UI.Menu.CloseAll()
        Variable.InAction = true
        TriggerEvent("mythic_progbar:client:progress", {
            name = "unique_action_name",
            duration = 10000,
            label = "กำลังงัดรถ",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                task = 'WORLD_HUMAN_WELDING'
            },
        }, function(status)
            Variable.InAction = false
            if not status then
                if not IsEntityDead(Ped) then
                    SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    exports.pNotify:SendNotification({
                        text = "งัดรถเรียบร้อย",
                        type = "success",
                    })
                end 
            end
        end)
    else
        exports.pNotify:SendNotification({
            text = "ไม่มีรถใกล้ๆ",
            type = "error",
        })
    end 
end 

function impound()
    local Ped = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if Variable.InAction then return end 
    if IsPedSittingInAnyVehicle(Ped) then 
        exports.pNotify:SendNotification({
            text = "กรุณาลงจากรถก่อน",
            type = "error",
        })
        return
    end
    if DoesEntityExist(vehicle) then
        Variable.InAction = true 
        ESX.UI.Menu.CloseAll()
        Variable.InAction = true
        TriggerEvent("mythic_progbar:client:progress", {
            name = "unique_action_name",
            duration = 10000,
            label = "กำลังพาวน์รถ",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                task = 'CODE_HUMAN_MEDIC_TEND_TO_DEAD'
            },
        }, function(status)
            Variable.InAction = false
            if not status then
                if not IsEntityDead(Ped) then
					ESX.Game.DeleteVehicle(vehicle)
                    exports.pNotify:SendNotification({
                        text = "พาวน์รถเรียบร้อย",
                        type = "success",
                    })
                end 
            end
        end)
    else
        exports.pNotify:SendNotification({
            text = "ไม่มีรถใกล้ๆ",
            type = "error",
        })
    end 
end

function placebox()
    local Ped = PlayerPedId()

    if IsPedSittingInAnyVehicle(Ped) then
        exports.pNotify:SendNotification({
            text = "กรุณาลงจากรถก่อน",
            type = "error",
        })
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions_spawn', {
        title    = 'อุปกรณ์',
        align    = 'top-right',
        elements = {
            {label = 'กรวย', value = 'prop_roadcone02a'},
            {label = 'กล่องเครื่องมือช่าง',  value = 'prop_toolchest_01'}
    }}, function(data2, menu2)
        local model   = data2.current.value
        local coords  = GetEntityCoords(Ped)
        local forward = GetEntityForwardVector(Ped)
        local x, y, z = table.unpack(coords + forward * 1.0)

        if model == 'prop_roadcone02a' then
            z = z - 2.0
        elseif model == 'prop_toolchest_01' then
            z = z - 2.0
        end

        ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
            SetEntityHeading(obj, GetEntityHeading(Ped))
            PlaceObjectOnGroundProperly(obj)
        end)
    end, function(data2, menu2)
        menu2.close()
    end)
end 

function bill()
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
                        TriggerServerEvent('lnn_mechanicjob:sendBill', GetPlayerServerId(closestPlayer), '', input.value , data1.value)
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

function OpenVehicleMenu(k, key)
    local v = Config.Mechanic[k].Vehicles[key]
    local elements = {
        { label = 'ซื้อรถ', value = 'buy'},
        { label = 'เบิกรถ', value = 'getout'},
        { label = 'เก็บรถ', value = 'getin'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
        title    = 'เมนูรถ',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'buy' then
            local shopCoords = Config.Mechanic[k].Vehicles[key].InsideShop
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
                    TriggerServerEvent('lnn_mechanicjob:buyJobVehicle', props, data.current.type, data.current.price)
                    Variable.isInShopMenu = false
                    ESX.UI.Menu.CloseAll()
                    DeleteSpawnedVehicles()
                    FreezeEntityPosition(playerPed, false)
                    SetEntityVisible(playerPed, true)
                    ESX.Game.Teleport(playerPed, restoreCoords)
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

function OpenMechanicActionsMenu()
	local elements = {
	}
	table.insert(elements, {label = 'เมนูบอส', value = 'boss_actions'})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = 'เมนูจัดการ',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end, {wash = false, grades= false})
		end
	end, function(data, menu)
		menu.close()
	end)
end