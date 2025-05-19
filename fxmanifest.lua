fx_version 'cerulean'
game 'gta5'

author 'N9HunterX'
description 'n9_Goldplant - Script đào vàng cho QBCore'
version '1.0.0'

shared_script 'config.lua'

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    'qb-core',
    'qb-target',
    'qb-inventory'
}
