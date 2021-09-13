data_file 'DLC_ITYP_REQUEST' 'stream/submarinepatoche/submarin_ladder1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/submarinepatoche/patoche_submarin1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/submarinepatoche/patoche_cap1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/houseRobberiesMap/shellprops.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'
data_file "SCALEFORM_DLC_FILE" "stream/ada_map/int3232302352.gfx"
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

--MRPD
data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

data_file 'TIMECYCLEMOD_FILE' 'bs_timecycmod.xml'
data_file 'SCALEFORM_DLC_FILE' 'stream/burger/int1756029552.gfx'

client_script {
    "main.lua"
}

files {
    'gabz_timecycle_mods_1.xml',
    'gabz_mrpd_timecycle.xml',
    'bs_timecycmod.xml',
    "stream/ada_map/int3232302352.gfx",
    "interiorproxies.meta",
}

this_is_a_map 'yes'

fx_version 'adamant'
game 'gta5'