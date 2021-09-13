fx_version 'adamant'

game 'gta5'

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/classes/status.lua'
}

server_scripts {
	'server/main.lua',
	'config.lua',
	'server/classes/status.lua'
}

export 'getStatus'