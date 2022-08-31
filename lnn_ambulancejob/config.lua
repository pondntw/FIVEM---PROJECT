Config = {}

Config.AutoRespawnTime = 5

Config.RespawnTime = 40

Config.BleedOutTime = 5

Config.WeaponProtect = 'protectweapon'

Config.NotremoveItemsAfterRPDeath = {
    
--แฟชั่น
'bb1',
'bb2',
'bb3',
'bbb1',
'bbb3',
'bbb4',
'bbb5',
'bbb6',
'BearShibaNita',
'Bunny',
'Candy',
'CatExcited',
'Charmander',
'ChubbyDog',
'ChubbyFox',
'corgifood_01',
'Dino',
'DogHat',
'Dragonbule',
'fas_anmbananaback',
'fas_anmcathead',
'fas_anmpighead',
'fas_anmrabbit1',
'fas_anmrabbit2',
'fas_avengers1',
'fas_avengers2',
'fas_avengers3',
'fas_avengers4',
'fas_avengers5',
'fas_avengers6',
'fas_avengers7',
'fas_avengers8',
'fas_bearbrowna',
'fas_bearbrownb',
'fas_bearbrownc',
'fas_bearpinka',
'fas_bearpinkb',
'fas_bearpinkc',
'fas_birdcooper',
'fas_buzz',
'fas_chubbypanda',
'fas_chubbypig',
'fas_corgi01',
'fas_corgi02',
'fas_corgi03',
'fas_corgi04',
'fas_corgi05',
'fas_corgi06',
'fas_corgi07',
'fas_corgi08',
'fas_cypher',
'fas_demonhunter',
'fas_devilbunny1',
'fas_devilbunny10',
'fas_devilbunny2',
'fas_devilbunny3',
'fas_devilbunny4',
'fas_devilbunny5',
'fas_devilbunny6',
'fas_devilbunny7',
'fas_devilbunny8',
'fas_devilbunny9',
'fas_dickkyb',
'fas_dickkyh',
'fas_dickkyl',
'fas_dickkyr',
'fas_dinohat',
'fas_dinosaur',
'fas_doggy',
'fas_fuzzybear',
'fas_godzillabl',
'fas_godzillabp',
'fas_godzillabr',
'fas_godzillahat',
'fas_godzillahl',
'fas_godzillahr',
'fas_guluxing',
'fas_hatsluffy',
'fas_ishar',
'fas_jett',
'fas_joobag',
'fas_killjoy',
'fas_lbrown',
'fas_lcony',
'fas_lsally',
'fas_medusa',
'fas_mickeymouse',
'fas_mochilaardilla',
'fas_mochilacerdito',
'fas_mochiladino',
'fas_mochilagallina',
'fas_mochilagato',
'fas_mochilamono',
'fas_mochilaoso',
'fas_mochilaperro',
'fas_mochilavaquita',
'fas_pigcute',
'fas_pighat',
'fas_pooh1',
'fas_pooh2',
'fas_pooh3',
'fas_pooh4',
'fas_potatohead',
'fas_razor',
'fas_retopology',
'fas_reyna',
'fas_sage',
'fas_samar',
'fas_seal',
'fas_street',
'fas_towerofpower',
'fas_upbreado',
'fas_upbreadp',
'fas_woody',
'headphone_04',
'headphone_05',
'headphone_07',
'headphone_08',
'konckkid_babyshop',
'konckkid_babyshop2',
'konckkid_babyshop3',
'konckkid_babyshop4',
'konckkid_babyshop5',
'konckkid_babyshop6',
'mamuang_acc_cat_perched',
'Pawberry',
'SharkCat',
'shinchan',
'TeaPotRex',

--ลำโพงแฟชั่น
'hifi_gachass7_b',
'hifi_gachass7_g',
'hifi_gachass7_r',

--Gachapon SS
'gachass1',
'gachass2',
'gachass3',
'gachass4',
'gachass5',
'gachass6',
'gachass7',
'gachass8',

--Item Donate
'number_lucky_01',
'number_lucky_02',
'number_phone_01',
'number_phone_02',
'number_phone_03',
'number_phone_04',
'skinweapon_bat1',
'skinweapon_bottle1',
'skinweapon_golfclub1',
'skinweapon_knuckle1',
'skinweapon_poolcue1',

--แหวนแต่งงาน
'weddingring_fm',

--บัตรแก๊ง
'gang_lucifer',
'gang_nicotine',
'gang_scyther',
'gang_youngblood',

--เหรียญแก๊ง
'upgang_lcf',
'upgang_nct',
'upgang_str',
'upgang_yb',

--ผ้าเช็ดรถ
'rag',

}

Config.Marker = { type = 21, x = 1.0, y = 1.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.RespawnPoint = { coords = vector3(341.0, -1397.3, 32.5), heading = 48.5 }

Config.Hospitals = {

CentralLosSantos = {

Blip = {
    coords = vector3(307.7,  -1433.4, 28.9),
    sprite = 176,
    scale  = 1.2,
    color  =  1
    },

AmbulanceActions = {
    vector3(366.47,  -1419.34, 32.50)
    },

Vehicles = {
    {
        Spawner = vector3(311.71,  -1385.67, 31.89),
        InsideShop = vector3(446.7,  -1355.6, 43.5),
        Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
        SpawnPoints = {
            { coords = vector3(295.82,  -1393.76, 30.19), heading = 320.50, radius = 4.0 },
            { coords = vector3(300.02,  -1388.74, 30.60), heading = 320.50, radius = 4.0 },
            { coords = vector3(303.79,  -1384.06, 30.91), heading = 320.50, radius = 4.0 }
        },
    }
},

Helicopters = {
    {
        Spawner = vector3(317.5,  -1449.5, 46.5),
        InsideShop = vector3(305.6,  -1419.7, 41.5),
        Marker = {type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true},
        SpawnPoints = {
            {coords = vector3(313.5,  -1465.1, 46.5), heading = 142.7, radius = 10.0},
            {coords = vector3(299.5,  -1453.2, 46.5), heading = 142.7, radius = 10.0}
        }
    }
},
         
FastTravels = {
    {
        From = vector3(294.7,  1448.1, 29.0),
        To = {coords = vector3(272.8,  1358.8, 23.5), heading = 0.0},
        Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },

    {
        From = vector3(275.3,  1361, 23.5),
        To = {coords = vector3(295.8,  1446.5, 28.9), heading = 0.0},
        Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },

    {
        From = vector3(247.3,  1371.5, 23.5),
        To = {coords = vector3(333.1,  1434.9, 45.5), heading = 138.6},
        Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },

    {
        From = vector3(335.5,  1432.0, 45.50),
        To = {coords = vector3(249.1,  1369.6, 23.5), heading = 0.0},
        Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },

    {
        From = vector3(234.5,  1373.7, 20.9),
        To = {coords = vector3(320.9,  1478.6, 28.8), heading = 0.0},
        Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },

    {
        From = vector3(317.9,  1476.1, 28.9),
        To = {coords = vector3(238.6,  1368.4, 23.5), heading = 0.0},
        Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
    },
    {
        From = vector3(237.4,  1373.8, 26.0),
        To = {coords = vector3(251.9,  1363.3, 38.5), heading = 0.0},
        Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
    },
    {   
        From = vector3(256.5,  1357.7, 36.0),
        To = {coords = vector3(235.4,  1372.8, 26.3), heading = 0.0},
        Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
    }
    },
    }
}

Config.AuthorizedVehicles = {
    ambulance = {
        {model = 'apolicec6',label = 'Best EMS', price = 20000},
    },
    doctor = {
        { model = 'polrrstart', label = 'Ambulance SUV', price = 50000},
        {model = 'apolicec6',label = 'Best EMS', price = 20000}
    },
    chief_doctor = {
        { model = 'polrrstart', label = 'Ambulance SUV', price = 50000},
        {model = 'apolicec6',label = 'Best EMS', price = 20000}
    },
    boss = {
        { model = 'polrrstart', label = 'Ambulance SUV', price = 50000},
        {model = 'apolicec6',label = 'Best EMS', price = 20000}
    }
}

Config.AuthorizedHelicopters = {
    ambulance = {
        { model = 'seasparrow2', label = 'Sparrow', price = 15000 }

    },
    doctor = {
        { model = 'seasparrow2', label = 'Sparrow', price = 15000 }

    },
    chief_doctor = {
        { model = 'seasparrow2', label = 'Sparrow', price = 15000 }

    },
    boss = {
        --{ model = 'buzzard2', label = 'Buzzard', price = 15000 },
        { model = 'seasparrow2', label = 'Sparrow', price = 15000 }
    }
}