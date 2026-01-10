fx_version 'cerulean'
game 'gta5'
author 'ABTresources'
description 'Custom Loading Screen with Progress Bar'
version '1.0.0'

lua54 'yes'

loadscreen 'web/index.html'
loadscreen_cursor 'yes'

client_script 'client.lua'

files {
    'web/index.html',
    'web/img/*.png',
    'web/musicc.mp3'
}

loadscreen_manual_shutdown 'yes'