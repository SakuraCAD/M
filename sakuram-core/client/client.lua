RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")


RegisterCommand('911',function(source,args)
    local strings = {}
    local playerPed = PlayerPedId(-1)
    local coords = GetEntityCoords(playerPed)
    local locationStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(playerPed))))
    local authoritiesCalled = string.lower(args[1])
    for index, argument in pairs(args) do
        if index ~= 1 then 
            table.insert(strings,index,argument)
        end
    end
    local callReason = table.concat(strings," ")


    if authoritiesCalled ~= "police" or authoritiesCalled ~= "ems" or authoritiesCalled ~= "fire" then

    else
        TriggerServerEvent("call911", playerPed, {authorities = authoritiesCalled, location = locationStreet, reason = callReason, coords = {x = coords.x, y = coords.y, z = coords.z}})
        TriggerEvent('chat:addMessage',{
            args = {'Calling 911'}
        })
    end
end,false)

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