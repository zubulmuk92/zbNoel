fx_version 'adamant'

game 'gta5'

author 'zubulmuk92'

description 'Script evenement pour Noel.'

version '1.0.0'

shared_script {
    "zbConfig.lua"
}

client_scripts {
    "cl_main.lua",
    "cl_bouledeneige.lua"
}

server_scripts {
    "srv_main.lua"
}

files {
    "peds.meta"
}

data_file "PED_METADATA_FILE" "peds.meta"