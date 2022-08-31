RegisterNetEvent('lnn_upbattle:BoxSpawn')
AddEventHandler('lnn_upbattle:BoxSpawn', function(box)
    Variable.Box = box 
    for k, v in pairs(Variable.Box) do 
        Variable.ESX.Game.SpawnLocalObject('ba_prop_battle_chest_closed', v.coords, function(object)
			PlaceObjectOnGroundProperly(object)
			FreezeEntityPosition(object, true)
			Variable.Box[k].PropId = object
		end)
    end 
    BoxLoop()
end)

RegisterNetEvent('lnn_upbattle:pickup')
AddEventHandler('lnn_upbattle:pickup', function(itemname, itemcount)
	table.insert(Variable.Pickupdata, {itemname, itemcount})
    exports.pNotify:SendNotification({
        text = "ได้รับ "..Variable.ESX.GetItem()[itemname].label.." "..itemcount.." ชิ้น",
        type = "success",
    })
end)

RegisterNetEvent('lnn_upbattle:deletebox')
AddEventHandler('lnn_upbattle:deletebox', function(k)
    DeleteEntity(Variable.Box[k].PropId)
    Variable.Box[k] = nil 
end)

RegisterNetEvent('lnn_upbattle:ResetBox')
AddEventHandler('lnn_upbattle:ResetBox', function()
    for k, v in pairs(Variable.Box) do 
        DeleteEntity(v.PropId)
    end 
    Variable.Box = {}
end)

function BoxLoop()
    local pickupcount = 0
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(0)
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            for k, v in pairs(Variable.Box) do
                local distance = #(Coords - v.coords)
                if distance <= 3 then 
                    local x,y,z = table.unpack(v.coords)
                    DrawText3D(x,y,z, ''..v.itemlabel..'~y~X'..v.itemcount..'')
                    if IsControlJustReleased(0, 38) then 
                        if pickupcount == Config.UpbattleBox.MaxPickUp then 
                            exports.pNotify:SendNotification({
                                text = "สามารถเก็บได้เเค่ "..Config.UpbattleBox.MaxPickUp.." ครั้ง",
                                type = "error",
                            })
                            return
                        end 
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "unique_action_name",
                            duration = 3000,
                            label = "กำลังเก็บกล่อง",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = false,
                            },
                            animation = {
                                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                anim = "machinic_loop_mechandplayer",
                            },
                        }, function(status)
                            if not status then
                                TriggerServerEvent('lnn_upbattle:pickupbox', k)
                                pickupcount = pickupcount + 1
                            end
                        end)
                    end 
                end 
            end 
            if Variable.Box == nil then 
                break
            end 
        end 
    end)
end

function DeleteBox()
    for k, v in pairs(Variable.Box) do 
        DeleteEntity(v.PropId)
    end 
end 