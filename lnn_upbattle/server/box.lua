AddEventHandler('lnn_upbattle:box', function()
    local BoxCount = 0
    local boxList = Config.UpbattleBox.coords
    Citizen.CreateThread(function()
        while true do  
            if BoxCount < Config.UpbattleBox.MaxBox then
                local rdm = math.random(1, #Config.UpbattleBox.ItemInBox)
                local item = Config.UpbattleBox.ItemInBox[rdm]
                local farmpoint = math.random(1, #boxList)
                local data = {
                    itemname = item[1],
                    itemcount = item[2],
                    itemlabel = Variable.ESX.GetItemLabel(item[1]),
                    coords = boxList[farmpoint]
                }
                if data.coords ~= nil then 
                    boxList[farmpoint] = nil
                    table.insert(Variable.Box, data)
                    BoxCount = BoxCount + 1
                    boxList[rdm] = nil
                end
            else 
                break
            end
            Citizen.Wait(10)
        end 
    end)
end)

RegisterNetEvent('lnn_upbattle:pickupbox')
AddEventHandler('lnn_upbattle:pickupbox', function(k)
    if Variable.Box[k] ~= nil then 
        TriggerClientEvent('lnn_upbattle:pickup', source, Variable.Box[k].itemname, Variable.Box[k].itemcount)  
        TriggerClientEvent('lnn_upbattle:deletebox', -1, k)
        Variable.Box[k] = nil
    end 
end)

AddEventHandler('lnn_upbattle:ResetBox', function()
    Variable.Box = {}
    TriggerClientEvent('lnn_upbattle:ResetBox', -1)
end)