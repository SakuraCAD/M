-- Resource Metadata
fx_version 'bodacious'
games {'gta5'}

author 'SakuraCAD'
description 'SakuraCAD Server Plugin for FiveM'
version '1.0.0'

dependency 'yarn'

-- What to run
client_script 'client/client.lua'

server_script 'server/horizon.js'
server_script 'server/server.lua'