fx_version 'cerulean'
game 'gta5'

version '1.0.0'
author 'AiReiKe'
description 'Eric Advanced Money Wash'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
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