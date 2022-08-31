RegisterNetEvent('lnn_ambulancejob:heal')
AddEventHandler('lnn_ambulancejob:heal', function(Id,Heal)
    TriggerClientEvent('lnn_ambulancejob:heal', Id, Heal)
end)

ESX.RegisterServerCallback('lnn_ambulancejob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
		}
		cb(data)
	end
end)

RegisterServerEvent('lnn_ambulancejob:Hold')
AddEventHandler('lnn_ambulancejob:Hold', function(Id)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('lnn_ambulancejob:Hold', Id, source)
end)

RegisterServerEvent('lnn_ambulancejob:unHold')
AddEventHandler('lnn_ambulancejob:unHold', function(Id)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('lnn_ambulancejob:unHold', Id, source)
end)

RegisterServerEvent('lnn_ambulancejob:buyJobVehicle')
AddEventHandler('lnn_ambulancejob:buyJobVehicle',function(vehicleProps, type, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('money', price)
	TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", source)
	MySQL.update('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
		['@owner'] = xPlayer.getIdentifier(),
		['@vehicle'] = json.encode(vehicleProps),
		['@plate'] = vehicleProps.plate,
		['@type'] = type,
		['@job'] = xPlayer.job.name,
		['@stored'] = true
	}, function (rowsChanged)
		local sendToDiscord = ''	.. xPlayer.name .. ' ซื้อรถ ' .. vehicleProps.model .. ' ทะเบียน ' .. vehicleProps.plate .. ' ราคา $' .. ESX.Math.GroupDigits(price) .. ''
		TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'DocBuyCar', sendToDiscord, xPlayer.source, '^2')
	end)
end)

ESX.RegisterServerCallback('lnn:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.query.await('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end
	if not foundPlate then
		cb(false)
	else
		MySQL.update('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

RegisterServerEvent('lnn_ambulancejob:sendBill')
AddEventHandler('lnn_ambulancejob:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)
	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
				function(rowsChanged)
					-- xTarget.showNotification(_U('received_invoice'))

					local sendToDiscord = '' .. xPlayer.name .. ' เรียกเก็บเงินค่า ' .. label .. ' กับ ' .. xTarget.name .. ' จำนวน $' .. ESX.Math.GroupDigits(amount) .. ' Target: [' .. sharedAccountName .. ']'
					TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'SendBill', sendToDiscord, xPlayer.source, '^2')
																			
					local sendToDiscord2 = '' .. xTarget.name .. ' ค้างชำระค่า ' .. label .. ' กับ ' .. xPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(amount) .. ' Target: [' .. sharedAccountName .. ']'
					TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'SendBill', sendToDiscord2, xTarget.source, '^1')
				end)
			else
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'player', xPlayer.identifier, label, amount},
				function(rowsChanged)
					-- xTarget.showNotification(_U('received_invoice'))

					local sendToDiscord = '' .. xPlayer.name .. ' เรียกเก็บเงินค่า ' .. label .. ' กับ ' .. xTarget.name .. ' จำนวน $' .. ESX.Math.GroupDigits(amount) .. ''
					TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'SendBill', sendToDiscord, xPlayer.source, '^2')
																			
					local sendToDiscord2 = '' .. xTarget.name .. ' ค้างชำระค่า ' .. label .. ' กับ ' .. xPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(amount) .. ''
					TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'SendBill', sendToDiscord2, xTarget.source, '^1')
				end)
			end
		end)
	end
end)