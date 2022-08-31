RegisterServerEvent('lnn_mechanicjob:sendBill')
AddEventHandler('lnn_mechanicjob:sendBill', function(playerId, sharedAccountName, label, amount)
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

RegisterServerEvent('lnn_mechanicjob:buyJobVehicle')
AddEventHandler('lnn_mechanicjob:buyJobVehicle',function(vehicleProps, type, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('money', price)
	-- TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", source)
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