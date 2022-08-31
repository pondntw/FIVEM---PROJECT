--client_script '@X.Brain/Shared/xGuardPlayer.lua'
--server_script '@X.Brain/Shared/xGuardServer.lua'


fx_version 'adamant'

game 'gta5'

client_scripts {
    'client/main.lua',
    'client/job.lua',
    'client/dead.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/job.lua',
    'server/dead.lua',
}

shared_scripts {
    'config.lua'
}