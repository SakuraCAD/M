--[[________      ______                      _______________________ 
__  ___/_____ ___  /_____  ______________ __  ____/__    |__  __ \
_____ \_  __ `/_  //_/  / / /_  ___/  __ `/  /    __  /| |_  / / /
____/ // /_/ /_  ,<  / /_/ /_  /   / /_/ // /___  _  ___ |  /_/ / 
/____/ \__,_/ /_/|_| \__,_/ /_/    \__,_/ \____/  /_/  |_/_____/  
      
    SakuraCAD Client for FiveM
    Developed by Friz#8136 and LewisTehMinerz#1337
    https://sakuracad.app
    Made using Visual Studio Code - Insiders
]]--

-- Setup Convars and Events


RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")


-- Register Command and deal with 911 Resources
RegisterCommand('911',function(source,args)
    local strings = {}
    local playerPed = PlayerPedId(-1)
    local coords = GetEntityCoords(playerPed)
    local locationStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(playerPed))))
    print("Preparing Call for Player Located At " .. locationStreet)
    for index, argument in pairs(args) do
        table.insert(strings,index,argument)
    end
    local authoritiesCalled = string.lower(strings[1])
    local callReason = table.concat(strings," ")
    if string.find(authoritiesCalled,"police") or string.find(authoritiesCalled,"ems") or string.find(authoritiesCalled,"fire")  then
        local data = {authorities = authoritiesCalled, location = locationStreet, reason = callReason, coords = {x = coords.x, y = coords.y, z = coords.z}}
        TriggerServerEvent("call911", playerPed, data)
        TriggerEvent('chat:addMessage',{
            args = {'Dialling 911 to request '.. authoritiesCalled}
        })
    else
        TriggerEvent('chat:addMessage',{
            args = {'Please select an emergency service using the options : police | ems | fire'}
        })
    end
    strings = {}
end,false)

-- Handle Return Event from Server
AddEventHandler("911CallReturn", function(CallbackMsg, Status)
   if Status == 200 then
    TriggerEvent('chat:addMessage',{
        args = {'The ' .. CallbackMsg .. ' are en-route to your current location!'}
    })   
   else
    TriggerEvent('chat:addMessage',{
        args = {'Your 911 Call was Terminated due to ' .. CallbackMsg}
    })    
   end
end)