RegisterCommand('911',function(source,args)
    local playerPed = PlayerPedId()
    local locationStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(playerPed))))
    TriggerEvent('chat:addMessage',{
        args = {'You attempted to call 911 with the reason ' .. args[1] .. ' at the location of ' .. locationStreet }
    })
end,false)

