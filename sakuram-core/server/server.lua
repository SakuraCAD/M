-- Events

RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")


-- Return 911 Call
function Return911(player,error)
    TriggerClientEvent("911CallReturn", player, error)
end

-- Callback

function returnDiscord(player,errorCode, resultData, resultHeaders)
    Return911(player,errorCode)
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
    PerformHttpRequest("https://discordapp.com/api/webhooks/739813592890736742/O2bYksber1Yep8eB0vE3rsHBRnGhnjRzZfJvSw8_A9DgJUqTmybSethbGC4b_1NOypGJ", returnDiscord(player), 'POST', data, {["Content-Type"] = "application/json"})
end)