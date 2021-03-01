fx_version 'cerulean'

game 'gta5'

author 'PoinP'
version "0.9.9"
description 'A simple moneylaundry script.'

server_scripts {
	'@es_extended/locale.lua',
	'locales/bg.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/bg.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}