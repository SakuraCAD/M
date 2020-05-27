-- Events

RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")



function Return911()
    TriggerClientEvent("911CallReturn")
end
-- callback 

function returnDiscord(player,errorCode, resultData, resultHeaders)
    print("Returned error code:" .. tostring(errorCode))
    print("Returned data:" .. tostring(resultData))
    print("Returned result Headers:" .. tostring(resultHeaders))
    Return911(player,errorCode)
end


-- Handle Client 911 Calls
AddEventHandler("call911", function(player, calldata)
    print('Got Event')
    local authority = calldata.authority
    local location = calldata.location
    local reason = calldata.reason
    local coords = calldata.coords
    local testDiscordWebhook = "https://discordapp.com/api/webhooks/715224849500471407/nPW6sR56dyUg9YeBPMxuh3H3pVE9R1fNwT2A9_Wmlu6MpXCNtxK9O_zLGA5xLoqQst3I"
    local data = json.encode({content = "**Crime in Progress**\nAuthority Requested :" .. authority .. "\nStreet : " .. location .. "\nCoordinates (X, Y and Z) : `" .. coords.x .. " | "..coords.y .. "| " .. coords.z .. "`\nCaller Information : \n```\n" .. reason .. "\n```"})
    PerformHttpRequest(testDiscordWebhook, returnDiscord(player), 'POST', data, {["Content-Type"] = "application/json"})
end)

print(convarValue)