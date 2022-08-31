function StartEvent()
    if not Variable.EventStart then 
        Variable.EventStart = true
        Variable.Time = Config.UpbattleMain.TimeBeforeStart * 60 
        TriggerEvent('lnn_upbattle:timeloop')
        TriggerEvent('lnn_upbattle:box')
        Citizen.Wait(1000)
        TriggerClientEvent('lnn_upbattle:StartMain', -1)
        Variable.ESX.SetTimeout(Config.UpbattleMain.TimeBeforeStart * 60 * 1000,function()
            Variable.Time = Config.UpbattleMain.FarmTime * 60 
            TriggerClientEvent('lnn_upbattle:StartFarm', -1)
            TriggerClientEvent('lnn_upbattle:BoxSpawn', -1, Variable.Box)
            Citizen.Wait(1000)
            Variable.ESX.SetTimeout(Config.UpbattleMain.FarmTime * 60 * 1000,function()
                TriggerEvent('lnn_upbattle:ResetBox')
                TriggerClientEvent('lnn_upbatle:StartBattle', -1)
                Variable.Time = Config.UpbattleMain.BattleTime * 60 
                Citizen.Wait(1000)
                Variable.ESX.SetTimeout(Config.UpbattleMain.BattleTime * 60 * 1000,function()
                    if Variable.IsEventStart then 
                        if Variable.PlayerCount > 1 then 
                            
                        end 
                    end 
                end)
            end)
        end)
    end
end 