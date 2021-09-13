Config = {}

Config.Shops = { 

    
  ['LSPD Silah Marketi'] = {
    label = "LSPD Silah Marketi",
    coords = {
        vector3(482.622, -995.26, 30.6898)
    },
    Shop = {
    items = {
        [1] = { name = "weapon_pistol", price = 1, count = 100,  info = {},  type = "weapon", slot = 1, },
        [2] = { name = "weapon_appistol", price = 1, count = 100,  info = {},  type = "weapon", slot = 2, },
        [3] = { name = "weapon_minismg", price = 1, count = 100,  info = {},  type = "weapon", slot = 3, },
        [4] = { name = "MedArmor", price = 1, count = 100,  info = {},  type = "item", slot = 4, },
        [5] = { name = "HeavyArmor", price = 1, count = 100,  info = {},  type = "item", slot = 5, },
        [6] = { name = "gps", price = 1, count = 100,  info = {},  type = "item", slot = 6, },
        [7] = { name = "pistol_ammo", price = 1, count = 100,  info = {},  type = "weapon", slot = 7, },
        [8] = { name = "smg_ammo", price = 1, count = 100,  info = {},  type = "weapon", slot = 8, },
        [9] = { name = "rifle_ammo", price = 1, count = 100,  info = {},  type = "weapon", slot = 9, },
        [10] = { name = "weapon_nightstick", price = 1, count = 100,  info = {},  type = "weapon", slot = 10, },
        [11] = { name = "weapon_stungun", price = 1, count = 100,  info = {},  type = "weapon", slot = 11, },
        [12] = { name = "weapon_carbinerifle_mk2", price = 1, count = 100,  info = {},  type = "weapon", slot = 12, },
        [13] = { name = "telsiz", price = 1, count = 100,  info = {},  type = "item", slot = 13, },
        [16] = { name = "mdt", price = 1, count = 100,  info = {},  type = "item", slot = 16, },



    },
    markerType = 2,
    markerSize = vector3(0.2, 0.2, 0.2),
    markerColour = { r = 255, g = 255, b = 255 },
    use3dtext = true,
    msg =  '[E] - Silah Marketi',
    blip = false, --{id = 521, scale = 0.5, color = 3, title = 'Teknoloji Market'},
    job = {'police'}
 }

},

  
    ['Teknoloji Marketi'] = {
        label = "Teknoloji Marketi",
        coords = {
            vector3(-657.30, -857.43, 24.4900)
        },
        Shop = {
        items = {
            [1] = { name = "telsiz", price = 100, count = 100,  info = {},  type = "item", slot = 1, },
            [2] = { name = "phone", price = 100, count = 100,  info = {},  type = "item", slot = 2, },


        },
        markerType = 2,
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg =  '[E] - Teknoloji Mağazası',
        blip = {id = 521, scale = 0.5, color = 3, title = 'Teknoloji Market'},
        job = {'all'}
     }

  },

    ['MegaMall'] = {
        label = "MegaMall",
        coords = {
            vector3(46.5430, -1749.6, 29.6342)
        },
        Shop = {
        items = {
            [1] = { name = "zar", price = 100, count = 100,  info = {},  type = "item", slot = 1, },
            [2] = { name = "kazma", price = 100, count = 100,  info = {},  type = "item", slot = 2, },
            [3] = { name = "basketboltop", price = 100, count = 100,  info = {},  type = "item", slot = 3, },

        },
        markerType = 2,
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg =  '[E] - MegaMall',
        blip = {id = 59, scale = 0.5, color = 27, title = 'MegaMall'},
        job = {'all'}
     }
  },

  ['EMS Market'] = {
    label = "EMS Market",
    coords = {
        vector3(306.674, -601.78, 43.2840)
    },
    Shop = {
    items = {
        [1] = { name = "medikit", price = 100, count = 1,  info = {},  type = "item", slot = 1, },
        [2] = { name = "bandage", price = 100, count = 1,  info = {},  type = "item", slot = 2, },
        [3] = { name = "telsiz", price = 100, count = 1,  info = {},  type = "item", slot = 3, },
        [4] = { name = "emsmdt", price = 100, count = 1,  info = {},  type = "item", slot = 4, },



       
    },
    markerType = 2,
    markerSize = vector3(0.2, 0.2, 0.2),
    markerColour = { r = 255, g = 255, b = 255 },
    use3dtext = true,
    msg =  '[E] - EMS Marketi',
    blip = false, --{id = 59, scale = 0.5, color = 2, title = 'Market'},
    job = {'ambulance'}
 }
},

  

    ['Market'] = {
        label = "Market",
        coords = {
            vector3(25.95, -1347.27, 29.5),
            vector3(373.875, 325.896, 103.566),
            vector3(2557.458, 382.282, 106.622),
            vector3(-3038.939, 585.954, 7.908),
            vector3(-3241.927, 1001.462, 12.830),
            vector3(547.431, 2671.710, 42.156),
            vector3(1961.464, 3740.672, 32.343),
            vector3(2678.916, 3280.671, 55.241),
            vector3(1729.563, 6414.126, 36.037),
            vector3(-48.519, -1757.514, 29.421),
            vector3(1163.373, -323.801, 68.205),
            vector3(-707.501, -914.260, 19.215),
            vector3(-1820.523, 792.518, 138.118),
            vector3(1698.388, 4924.404, 42.063),
            vector3(1135.808, -982.281, 46.415),
            vector3(-1487.553, -379.107, 40.163),
            vector3(-2968.243, 390.910, 15.043),
            vector3(1166.024, 2708.930, 38.157),
            vector3(1392.562, 3604.684, 34.980),
        },
        Shop = {
        items = {
            [1] = { name = "hamburger", price = 100, count = 100,  info = {},  type = "item", slot = 1, },
            [2] = { name = "water", price = 100, count = 100,  info = {},  type = "item", slot = 2, },
            [3] = { name = "cola", price = 100, count = 100,  info = {},  type = "item", slot = 3, },
            [4] = { name = "sandvic", price = 100, count = 100,  info = {},  type = "item", slot = 4, },
            [5] = { name = "bread", price = 100, count = 100,  info = {},  type = "item", slot = 5, },
            [6] = { name = "redbull", price = 100, count = 100,  info = {},  type = "item", slot = 6, },

        },
        markerType = 2,
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg =  '[E] - Market',
        blip = false, --{id = 59, scale = 0.5, color = 2, title = 'Market'},
        job = {'all'}
     }
  }

}

Config.Stashs = {

    ['LSPD Deposu'] = {   
        label = "LSPD Deposu",                                         
        coords = {vector3(481.209, -995.30, 30.6898)},   
        Stash = {    
        useMarker = true, 
        markerType = 2,  
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg = '[E] - LSPD Deposu',
        job = 'police',
        maxweight = 1000 -- if u use weight, uncomment this line
    },
},

['Sheriff Deposu'] = {   
    label = "Sheriff Deposu",                                         
    coords = {vector3(-449.84, 6010.36, 31.7163)},   
    Stash = {    
    useMarker = true, 
    markerType = 2,  
    markerSize = vector3(0.2, 0.2, 0.2),
    markerColour = { r = 255, g = 255, b = 255 },
    use3dtext = true,
    msg = '[E] - Sheriff Deposu',
    job = 'sheriff',
    maxweight = 1000 -- if u use weight, uncomment this line
},
},

    ['Ballas Deposu'] = {   
        label = "Ballas Deposu",                                         
        coords = {vector3(116.928, -1962.9, 21.3223)},   
        Stash = {    
        useMarker = true, 
        markerType = 2,  
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg = '[E] - Ballas',
        job = 'ballas',
        maxweight = 1000 -- if u use weight, uncomment this line
    },
},

    ['Vagos Deposu'] = {   
        label = "Vagos Deposu",                                         
        coords = {vector3(345.003, -2021.9, 22.3949)},   
        Stash = {    
        useMarker = true, 
        markerType = 2,  
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg = '[E] - Vagos',
        job = 'vagos',
        maxweight = 1000 -- if u use weight, uncomment this line
    },
},

    ['Grove Deposu'] = {   
        label = "Grove Deposu",                                         
        coords = {vector3(-143.56, -1596.8, 34.8314)},   
        Stash = {    
        useMarker = true, 
        markerType = 2,  
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg = '[E] - Grove',
        job = 'grove',
        maxweight = 1000 -- if u use weight, uncomment this line
    },
},

    ['EMS Depo'] = {   
        label = "EMS Depo",                                         
        coords = {vector3(298.696, -598.01, 43.2841)},   
        Stash = {    
        useMarker = true, 
        markerType = 2,  
        markerSize = vector3(0.2, 0.2, 0.2),
        markerColour = { r = 255, g = 255, b = 255 },
        use3dtext = true,
        msg = '[E] - EMS Depo',
        job = 'ambulance',
        maxweight = 1000 -- if u use weight, uncomment this line
    },
}
   
}