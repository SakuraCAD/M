-- Events

RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")



function Return911()
    TriggerClientEvent("911CallReturn")
end
-- callback 

function returnDiscord(player,errorCode, resultData, resultHeaders)
    Return911(player,errorCode)
end


-- Handle Client 911 Calls
AddEventHandler("call911", function(player, calldata)
    print('Got Event')
    local authority = calldata.authority
    local location = calldata.location
    local reason = calldata.reason
    local coords = calldata.coords
    local testDiscordWebhook = "removed_for_security_reasons"
    local data = json.encode({content = "**Crime in Progress**\nAuthority Requested :" .. authority .. "\nStreet : " .. location .. "\nCoordinates (X, Y and Z) : `" .. coords.x .. " | "..coords.y .. "| " .. coords.z .. "`\nCaller Information : \n```\n" .. reason .. "\n```"})
    PerformHttpRequest(testDiscordWebhook, returnDiscord(player), 'POST', data, {["Content-Type"] = "application/json"})
end)

