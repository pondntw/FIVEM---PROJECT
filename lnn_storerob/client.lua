ESX = nil
StoreList = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for k, v in pairs(Config.StoreList) do 
            local distance = #(Coords - v.Coords) 
            if distance <= 2.0 then 
                if StoreList[k] then 
                    Draw3DTextWithRect(v.Coords, '~r~robbery ~y~delay',20.0)
                else 
					local onhand = GetSelectedPedWeapon(Ped)
                    Draw3DTextWithRect(v.Coords, 'Press ~y~E ~w~to ~r~robbery',20.0)
					if IsControlJustPressed(0, 38) then 
						if exports.Porpy_Check:Check('Police') >= v.Police then 
							if onhand == GetHashKey('weapon_wrench') then
								local Minigame = exports['sm-amongus-math']:SkillCheck(6000)
								if Minigame then
									local Minigame = exports['sm-amongus-math']:SkillCheck(6000)
									if Minigame then
										local Minigame = exports['sm-amongus-math']:SkillCheck(6000)
										if Minigame then
											TriggerEvent("lnn_policeAlert:alertNet", "ปล้นร้านค้า", "rgb(255,127,80,0.5)")
											local res = createSafe({math.random(0,99)})
											if res then 
												TriggerServerEvent('lnn_storerob:Delay', k)
												TriggerServerEvent('lnn_storerob:AddItem', k)
											else 

											end 
										else

										end
									else

									end
								else

								end
							else 
								exports.pNotify:SendNotification({text = "ต้องถือประเเจ", type = "error", timeout = math.random(2000, 2000)})
							end 
						else 
							exports.pNotify:SendNotification({text = "ตำรวจไม่เพียงพอ", type = "error", timeout = math.random(2000, 2000)})
						end
					end
                end 
            end 
        end 
    end 
end)

RegisterNetEvent('lnn_storerob:update')
AddEventHandler('lnn_storerob:update', function(data)
	StoreList = data
end)

RegisterNetEvent('lnn_storerob:Delay')
AddEventHandler('lnn_storerob:Delay', function(k, v)
	StoreList[k] = v
end)

function Draw3DTextWithRect(coords, text,radius,size)
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

-------------MINIGAMEZONE----------------
_onSpot = false
isMinigame = false
_SafeCrackingStates = "Setup"

function createSafe(combination)
	local res
	isMinigame = not isMinigame
	RequestStreamedTextureDict("MPSafeCracking",false)
	RequestAmbientAudioBank("SAFE_CRACK",false)

	if isMinigame then
		InitializeSafe(combination)
		while isMinigame do
			playFx("mini@safe_cracking","idle_base")
			DrawSprites(true)
			res = RunMiniGame()

			if res == true then
				return res
			elseif res == false then
				return res
			end

			Citizen.Wait(0)
		end
	end
end

function InitializeSafe(safeCombination)
	_initDialRotationDirection = "Clockwise"
	_safeCombination = safeCombination

	RelockSafe()
	SetSafeDialStartNumber()
end

function DrawSprites(drawLocks)
	local textureDict = "MPSafeCracking"
	local _aspectRatio = GetAspectRatio(true)
    
	DrawSprite(textureDict,"Dial_BG",0.48,0.3,0.3,_aspectRatio*0.3,0,255,255,255,255)
	DrawSprite(textureDict,"Dial",0.48,0.3,0.3*0.5,_aspectRatio*0.3*0.5,SafeDialRotation,255,255,255,255)

	if not drawLocks then
		return
	end

	local xPos = 0.6
	local yPos = (0.3*0.5)+0.035
	for _,lockActive in pairs(_safeLockStatus) do
		local lockString
		if lockActive then
			lockString = "lock_closed"
		else
			lockString = "lock_open"
		end

		DrawSprite(textureDict,lockString,xPos,yPos,0.025,_aspectRatio*0.015,0,231,194,81,255)
		yPos = yPos + 0.05
	end
end

function RunMiniGame()
	if _SafeCrackingStates == "Setup" then
		_SafeCrackingStates = "Cracking"
	elseif _SafeCrackingStates == "Cracking" then
		local isDead = GetEntityHealth(PlayerPedId()) <= 101
		if isDead then
			EndMiniGame(false)
			return false
		end

		if IsControlJustPressed(0,191) then
			if _onSpot then
				ReleaseCurrentPin()
				_onSpot = false
				if IsSafeUnlocked() then
					EndMiniGame(true,false)
					return true
				end
			else
				EndMiniGame(false)
				return false
			end
 		end

		HandleSafeDialMovement()

		local incorrectMovement = _currentLockNum ~= 0 and _requiredDialRotationDirection ~= "Idle" and _currentDialRotationDirection ~= "Idle" and _currentDialRotationDirection ~= _requiredDialRotationDirection

		if not incorrectMovement then
			local currentDialNumber = GetCurrentSafeDialNumber(SafeDialRotation)
			local correctMovement = _requiredDialRotationDirection ~= "Idle" and (_currentDialRotationDirection == _requiredDialRotationDirection or _lastDialRotationDirection == _requiredDialRotationDirection)  
			if correctMovement then
				local pinUnlocked = _safeLockStatus[_currentLockNum] and currentDialNumber == _safeCombination[_currentLockNum]
				if pinUnlocked then
					PlaySoundFrontend(0,"TUMBLER_PIN_FALL","SAFE_CRACK_SOUNDSET",true)
					_onSpot = true
				end
			end
		elseif incorrectMovement then
			_onSpot = false
		end
	end
end

function HandleSafeDialMovement()
	if IsControlJustPressed(0,34) then
		RotateSafeDial("Anticlockwise")
	elseif IsControlJustPressed(0,35) then
		RotateSafeDial("Clockwise")
	else
		RotateSafeDial("Idle")
	end
end

function RotateSafeDial(rotationDirection)
	if rotationDirection == "Anticlockwise" or rotationDirection == "Clockwise" then
		local multiplier
		local rotationPerNumber = 3.6
		if rotationDirection == "Anticlockwise" then
			multiplier = 1
		elseif rotationDirection == "Clockwise" then
			multiplier = -1
		end

		local rotationChange = multiplier * rotationPerNumber
		SafeDialRotation = SafeDialRotation + rotationChange
		PlaySoundFrontend(0,"TUMBLER_TURN","SAFE_CRACK_SOUNDSET",true)
	end

	_currentDialRotationDirection = rotationDirection
	_lastDialRotationDirection = rotationDirection
end

function SetSafeDialStartNumber()
	local dialStartNumber = math.random(0,100)
	SafeDialRotation = 3.6 * dialStartNumber
end

function RelockSafe()
	if not _safeCombination then
		return
	end
    
	_safeLockStatus = InitSafeLocks()
	_currentLockNum = 1
	_requiredDialRotationDirection = _initDialRotationDirection
	_onSpot = false

	for i = 1,#_safeCombination do
		_safeLockStatus[i] = true
	end
end

function InitSafeLocks()
	if not _safeCombination then
		return
	end
    
	local locks = {}
 	for i = 1,#_safeCombination do
		table.insert(locks,true)
	end

	return locks
end

function GetCurrentSafeDialNumber(currentDialAngle)
	local number = math.floor(100*(currentDialAngle/360))
	if number > 0 then
		number = 100 - number
	end

	return math.abs(number)
end

function ReleaseCurrentPin()
	_safeLockStatus[_currentLockNum] = false
	_currentLockNum = _currentLockNum + 1

	if _requiredDialRotationDirection == "Anticlockwise" then
		_requiredDialRotationDirection = "Clockwise"
	else
		_requiredDialRotationDirection = "Anticlockwise"
	end

	PlaySoundFrontend(0,"TUMBLER_PIN_FALL_FINAL","SAFE_CRACK_SOUNDSET",true)
end

function IsSafeUnlocked()
	return _safeLockStatus[_currentLockNum] == nil
end

function EndMiniGame(safeUnlocked)
	if safeUnlocked then
		PlaySoundFrontend(0,"SAFE_DOOR_OPEN","SAFE_CRACK_SOUNDSET",true)
	else
		PlaySoundFrontend(0,"SAFE_DOOR_CLOSE","SAFE_CRACK_SOUNDSET",true)
	end
	isMinigame = false
	SafeCrackingStates = "Setup"
	ClearPedTasksImmediately(PlayerPedId())
end

function playFx(dict,anim)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end

	TaskPlayAnim(PlayerPedId(),dict,anim,3.0,3.0,-1,1,0,0,0,0)
end


