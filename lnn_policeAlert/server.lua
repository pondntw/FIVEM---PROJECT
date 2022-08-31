

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local queue = {}

Config["translate"] = {
	title = "",
	male = "<span  style=\"color:white;\">(</span><span style=\"color:red;\">male</span><span  style=\"color:white;\">)</span>",
	female = "<span  style=\"color:white;\">(</span> <span  style=\"color:red;\">female</span><span  style=\"color:white;\">)</span>",
	text = "<div style=\"color:white; margin-left: 90px\"><span style=\"color:green;\"><b>%s</b></span></div><div style=\"color:white;\"><b style=\"color: yellow;margin-left: 90px\">📌 :  %s <span style=\"color:orange;\"><b>%s</b></span></b></div>",
	tip = "<b style=\"color: white;\"> To mark location</b>",
}

Config["alert_position"] = "bottomCenter" 

local function CopAlert(text, pos,color,type)
	TriggerClientEvent("lnn_policeAlert:Notify", -1, text, pos, color, type)
end

local function InsertQueue(pos)
	local num
	for i=1, 9 do
		local v = queue[i]
		if v == nil then
			num = i
			queue[i] = {
				time = GetGameTimer() + (Config["duration"] * 800),
				pos = pos
			}
			break
		end
	end
	return num
end

RegisterServerEvent("lnn_policeAlert:getLocation")
AddEventHandler("lnn_policeAlert:getLocation", function(num)
	local data = queue[num]
	if data then
		TriggerClientEvent("lnn_policeAlert:sendLocation", source, data.pos)
	end
end)

local player_report = {}
RegisterServerEvent("lnn_policeAlert:defaultAlert")
AddEventHandler("lnn_policeAlert:defaultAlert", function(type, gender, location, pos, color)
	if player_report[source] and player_report[source] > GetGameTimer() then	
		return
	end
	--print(type, gender, location, pos)
	local num = InsertQueue(pos)
	if not num then return end
	
	local action
	action = "<span style=\"font-size:20px;color:gold;\">"..type.."</span>"

	player_report[source] = GetGameTimer() + (Config["duration"] * 800)
	

local text = ''..Config["translate"]["title"]..''..string.format(Config["translate"]["text"],  action, location, Config["translate"][gender])..'<span style="line-height: 20px;"><b style=" font-size:14px;line-height: 40px;color:black; background:white; border-radius:3px; padding:0.4% 2% 0.4% 2%;margin-left:90px">'.. Config["base_key_text"]..'</b><span style="color: white; "> + </span><b style=" font-size:13px;color:black; background:white; border-radius:3px; padding:0.5% 2% 0.5% 2%;">'..num..'</b>'..Config["translate"]["tip"]..'<br></span>'
CopAlert(text, pos,color,type)
end)

Citizen.CreateThread(function()
	while true do
		for i=1, 9 do
			local v = queue[i]
			if v and v.time < GetGameTimer() then
				queue[i] = nil
			end
		end
		Citizen.Wait(500)
	end
end)