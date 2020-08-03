-- Error Handler

function errorHandle(err)
    TriggerEvent("sakura:logerror", err)
end

-- Events

RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")


-- Return 911 Call
function Return911(player,error)
    xpcall(TriggerClientEvent("911CallReturn", player, error),errorHandle)
end

-- Callback

function returnDiscord(player,errorCode, resultData, resultHeaders)
    xpcall(Return911(player,errorCode), errorHandle)
end




-- Handle Client 911 Calls
AddEventHandler("call911", function(player, calldata)
    local authority = calldata.authorities
    print(authority)
    local location = calldata.location
    local reason = calldata.reason
    local coords = calldata.coords
    local data = json.encode({content = "@everyone\n**Crime in Progress**\nAuthority Requested :" .. authority .. "\nStreet : " .. location .. "\nCoordinates (X, Y and Z) : `" .. coords.x .. " | "..coords.y .. "| " .. coords.z .. "`\nCaller Information : \n```\n" .. reason .. "\n```"})
    print("preparing to fire html")
    PerformHttpRequest("", xpcall(returnDiscord(player), errorHandle), 'POST', data, {["Content-Type"] = "application/json"})
end)