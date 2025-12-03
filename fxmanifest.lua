fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jf_jamming'
author 'JF'
version '1.0.0'
description '(Weapon jamming based on durability) / (Weapon inspection) / (Weapon Clutching) (FLASHLIGHT) / (Drive By)'

dependencies { 
    'ox_lib', 
    'ox_inventory' 
}

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'locale.lua',           
    'locales/*.lua',        
    'customhelp.lua',       
    'client/**/*.lua'       
}

server_scripts {
    'server/**/*.lua'
}

files {
    'utils.lua',
    'data/clip_set.xml',
	'data/vehiclelayouts.meta',
    'stream/cxsht_clutching_arm@animation.ycd',
    'stream/cxsht_clutching_back@animation.ycd',
    'stream/cxsht_bp_clutching@animation.ycd',
    'stream/cxsht_clutching_front@animation.ycd',
    'stream/94glockypocket@animation.ycd',
    'stream/handspocket3@94glocky.ycd',
    'stream/onehands@from94.ycd',
    'stream/police@torch@anim@betterflashlight.ycd'
}

-- Data Files
data_file 'ANIM_DICT' 'stream/cxsht_clutching_arm@animation.ycd'
data_file 'ANIM_DICT' 'stream/cxsht_clutching_back@animation.ycd'
data_file 'ANIM_DICT' 'stream/cxsht_bp_clutching@animation.ycd'
data_file 'ANIM_DICT' 'stream/cxsht_clutching_front@animation.ycd'
data_file 'ANIM_DICT' 'stream/police@torch@anim@betterflashlight.ycd'
data_file 'ANIM_DICT' 'stream/94glockypocket@animation.ycd'
data_file 'ANIM_DICT' 'stream/handspocket3@94glocky.ycd'
data_file 'ANIM_DICT' 'stream/onehands@from94.ycd'
data_file 'CLIP_SETS_FILE' 'data/clip_set.xml'

data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
