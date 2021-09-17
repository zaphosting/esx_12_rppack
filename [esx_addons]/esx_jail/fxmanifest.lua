--	esx-qalle-jail | 2018 | Carl "Qalle"

fx_version 'adamant'
game 'gta5'

description "Jail Script With Working Job"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}

dependencies {
	'es_extended',
	'esx_jail_map'
}
