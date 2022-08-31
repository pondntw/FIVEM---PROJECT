local key = nil
key = 'lone'
local ServerUrl = "http://154.202.2.121//license_server"
local resourceName = GetCurrentResourceName()
if key == "" or key == " " or key == nil then
    key = ""
else
    key = key
end
PerformHttpRequest(ServerUrl.."/scriptserver.php?script="..resourceName.."&license="..key, function(Error, Status, Header)
    if Status then
        if tonumber(Status) == tonumber(1) then
            print('\n['..resourceName..'] ---> Check Success.Thanks you to buy this scripts <---')
        elseif tonumber(Status) == tonumber(2) then
            print('\n['..resourceName..']---> license is not have in database. please buy the license <---')
            StopResource(resourceName)
        elseif tonumber(Status) == tonumber(3) then
            print('\n['..resourceName..'] ---> IP Error please check the IP <--- ')
            StopResource(resourceName)
        elseif tonumber(Status) == tonumber(4) then
            print('\n['..resourceName..'] ---> Please put the key in to the Config.UserLicense <---')
        end
    else
        print("[\n"..resourceName.."\n]\nServer Error ")
        StopResource(resourceName)
    end
    Citizen.Wait(3600000)
end, "GET", "", {what = 'this'})