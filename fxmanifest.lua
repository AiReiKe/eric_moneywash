fx_version 'cerulean'
game 'gta5'

version '1.0.1'
author 'AiReiKe'
description 'Eric Advanced Money Wash'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'locales/*.lua',
    'config.lua'
}

server_scripts {
    'server/*.lua'
}

client_script 'client.lua'

dependencies {
    'es_extended',
}