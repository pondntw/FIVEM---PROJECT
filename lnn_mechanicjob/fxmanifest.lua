fx_version 'adamant'

game 'gta5'

client_scripts {
    'client/main.lua',
    'client/job.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/job.lua'
}

shared_scripts {
    'config.lua'
}