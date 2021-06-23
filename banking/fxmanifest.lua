fx_version "bodacious"
game "gta5"

shared_script '@es_extended/imports.lua'


client_scripts{
    'client.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
}

server_scripts {
    'server.lua',
    'config.lua',
}

ui_page('html/index.html')

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/img/logo.png',
    'html/img/logo-red.png',
    'html/img/logo-blue.png',
}
