--[[________      ______                      _______________________ 
__  ___/_____ ___  /_____  ______________ __  ____/__    |__  __ \
_____ \_  __ `/_  //_/  / / /_  ___/  __ `/  /    __  /| |_  / / /
____/ // /_/ /_  ,<  / /_/ /_  /   / /_/ // /___  _  ___ |  /_/ / 
/____/ \__,_/ /_/|_| \__,_/ /_/    \__,_/ \____/  /_/  |_/_____/  
      
    SakuraCAD Client for FiveM
    Developed by Friz#8136 and LewisTehMinerz#1337
    https://sakuracad.app
    Made using Visual Studio Code - Insiders

    Open Source Credits : Sheamle/notif (Notifications Library)
]]--

-- Setup Convars and Events


RegisterNetEvent("call911")
RegisterNetEvent("911CallReturn")

-- LIBRARY : Sheamle/notif

-- --------------------------------------------
-- Settings
-- --------------------------------------------

local body = {
	-- Text
	scale = 0.3,
	offsetLine = 0.02,
	-- Warp
	offsetX = 0.005,
	offsetY = 0.004,
	-- Sprite
	dict = 'commonmenu',
	sprite = 'gradient_bgd',
	width = 0.14,
	height = 0.012,
	heading = -90.0,
	-- Betwenn != notifications
	gap = 0.002,
}

local defaultText = '~r~~h~ERROR : ~h~~s~The text of the notification is nil.'
local defaultType = 'topRight'
local defaultTimeout = 6000

RequestStreamedTextureDict(body.dict) -- Load the sprite dict. properly

-- --------------------------------------------
-- Calculus functions
-- --------------------------------------------

local function goDown(v, id) -- Notifications will go under the previous notifications
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y + (body.height + (v[id].lines*2 + 1)*body.offsetLine)/2 + body.gap
		end
	end
end

local function goUp(v, id) -- Notifications will go above the previous notifications
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y - (body.height + (v[id].lines*2 + 1)*body.offsetLine)/2 - body.gap
		end
	end
end

local function centeredDown(v, id) -- Notification will stay centered from the default position and new notification will go at the bottom
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y - (body.height + (v[id].lines*2 + 1)*body.offsetLine)/4 - body.gap/2
			v[id].y = v[i].y + (body.height + (v[id].lines*2 + 1)*body.offsetLine)/2 + body.gap
		end
	end
end

local function centeredUp(v, id) -- Notification will stay centered from the default position and new notification will go at the top
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y + (body.height + (v[id].lines*2 + 1)*body.offsetLine)/4 + body.gap/2
			v[id].y = v[i].y - (body.height + (v[id].lines*2 + 1)*body.offsetLine)/2 - body.gap
		end
	end
end

local function CountLines(v, text)
	BeginTextCommandLineCount("STRING")
    SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)
	AddTextComponentSubstringPlayerName(text)
	local nbrLines = GetTextScreenLineCount(v.x + body.offsetX, v.y + body.offsetY)
	return nbrLines
end

local function DrawText(v, text)
	SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(v.x + body.offsetX, v.y + body.offsetY)
end

local function DrawBackground(v)
	DrawSprite(body.dict, body.sprite, v.x + body.width/2, v.y + (body.height + v.lines*body.offsetLine)/2, body.width, body.height + v.lines*body.offsetLine, body.heading, 255, 255, 255, 255)
end

-- --------------------------------------------
-- Different options
-- --------------------------------------------

local positions = {
	['centerRight'] = { x = 0.85, y = 0.5, notif = {}, offset = centeredUp },
	['centerLeft'] = { x = 0.01, y = 0.5, notif = {}, offset = centeredUp },
	['topRight'] = { x = 0.85, y = 0.015, notif = {}, offset = goDown },
	['topLeft'] = { x = 0.01, y = 0.015, notif = {}, offset = goDown },
	['bottomRight'] = { x = 0.85, y = 0.955, notif = {}, offset = goUp },
	['bottomLeft'] = { x = 0.015, y = 0.75, notif = {}, offset = goUp },
	-- ['position name'] = { starting x, starting y, notif = {} (nothing toput here it's juste the handle), offset = the way multiple notifications will stack up}
}

-- --------------------------------------------
-- Main
-- --------------------------------------------

function SendNotification(options)
	local text = options.text or defaultText
	local type = options.type or defaultType
	local timeout = options.timeout or defaultTimeout

	local p = positions[type]
	local id = #p.notif + 1
	local nbrLines = CountLines(p, text)

	p.notif[id] = {
		x = p.x,
		y = p.y,
		lines = nbrLines, 
		draw = true,
	}

	if id > 1 then
		p.offset(p.notif, id)
	end

	Citizen.CreateThread(function()
		Wait(timeout)
		p.notif[id].draw = false
	end)

	Citizen.CreateThread(function()
		while p.notif[id].draw do
			Wait(0)
			DrawBackground(p.notif[id])
			DrawText(p.notif[id], text)
		end
	end)
end

-- Register Command and deal with 911 Resources
RegisterCommand('911',function(source,args)
    local strings = {}
    local playerPed = PlayerPedId(-1)
    local coords = GetEntityCoords(playerPed)
    local locationStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(playerPed))))
    for index, argument in pairs(args) do
        table.insert(strings,index,argument)
    end
    local authoritiesCalled = string.lower(strings[1])
    local callReason = table.concat(strings," ")
    if string.find(authoritiesCalled,"police") or string.find(authoritiesCalled,"ems") or string.find(authoritiesCalled,"fire")  then
        local data = {authorities = authoritiesCalled, location = locationStreet, reason = callReason, coords = {x = coords.x, y = coords.y, z = coords.z}}
        TriggerServerEvent("call911", playerPed, data)
        SendNotification({
            text = string.upper(authoritiesCalled) .." has been called, remain at your current location!",
            type = "bottomRight",
            timeout = 15000,
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