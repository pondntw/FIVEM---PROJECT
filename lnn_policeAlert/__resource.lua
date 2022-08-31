client_script '@X.Brain/Shared/xGuardPlayer.lua'
server_script '@X.Brain/Shared/xGuardServer.lua'
description "Simple Notification Script using https://notifyjs.com/"

ui_page "html/index.html"



files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav",
    "html/main.mp3",
}

client_scripts {
	'config.lua',
	'client.lua',
	'cl_notify.lua'
}

server_scripts {
	'config.lua',
	'server.lua'
}

export "SetQueueMax"
export "SendNotification"