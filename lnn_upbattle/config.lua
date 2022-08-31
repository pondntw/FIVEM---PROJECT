Config = {}

Config.UpbattleMain = {
    Command = 'upbattlestart',
    AutoStart = true, 
    AutostartTime = {'18:00', '23:20'},
    TimeBeforeStart = 1, 
    JoinEventCoords = vector3(-429.08, 1110.72, 327.68), 
    Npc = {
        Heading = 348.87,
        Model = 'csb_mweather',
    },
    ParachuteCoords = { --จุดโดดล่มตั้งได้หลายจุด
        vector3(-311.56, -1019.25, 1420.96),
        vector3(-418.64, -1056.06, 1420.82),
        vector3(-249.82, -1155.54, 1420.82),
        vector3(-296.11, -949.66, 1385.6),
        vector3(-418.64, -1056.06, 1420.82),
        vector3(-357.25, -1082.41, 1385.6),
        vector3(-319.8, -1060.79, 1368.05),
        vector3(-333.94, -962.94, 1344.79),
        vector3(-313.06, -1012.16, 1373.33),
        vector3(-356.59, -1035.51, 1402.36),
    },
    FarmTime = 1,
    FarmCoords = vector3(-208.66, -1254.43, 955.6),
    BattleTime = 10,
    BattleCoords = vector3(-315.91, -1018.8, 959.18),
    BattleArea = 150,
}

Config.ItemReward = { --ไอเทมที่ทุกคนจะได้ไม่ว่าแพ้หรือชนะ
    {'upbattle', 1},
    {'eventticket', 1}
}

Config.RandomWeapon = {
    {'weapon_bat', 1},
    {'weapon_golfclub', 1},
    {'weapon_poolcue', 1},
    {'weapon_knuckle', 1},
    {'weapon_bottle', 1}
}

Config.UpbattleBox = {
    MaxPickUp = 5,
    MaxBox = 50,
    ItemInBox = {
        --กลุ่มมณี 7 แสง
        {'mineralamethyst_01', 1},
        {'mineralaquamarin_01', 1},
        {'mineralzircon_01', 1},
        {'mineralmoonstone_01', 1},
        {'mineraltanzanite_01', 1},
        {'mineraltourmaline_01', 1},
        {'mineralopal_01', 1},

        --กลุ่มเพชร 7 สี
        {'mineralturquoise_01', 1},
        {'mineralcitrine_01', 1},
        {'mineralsapphire_01', 1},
        {'mineralpearl_01', 1},
        {'mineralemerald_01', 1},
        {'mineralruby_01', 1},
        {'mineralgarnet_01', 1},
        
        --ของเฉพาะทางขั้นกลาง
        {'rare_crystal', 2},
        {'rare_diamond', 2},
        {'rare_heartwood', 2}
    },
    coords = {
        vector3(-399.41, 1197.17, 324.64),
        vector3(-398.1, 1203.28, 324.64),
        vector3(-396.51, 1208.96, 324.64),
        vector3(-394.73, 1215.38, 324.64),
        vector3(-151.67, -1303.45, 955.6),
        vector3(-145.83, -1298.95, 955.6),
        vector3(-144.36, -1290.66, 955.6),
        vector3(-140.91, -1286.23, 955.6),
        vector3(-144.24, -1280.14, 955.6),
        vector3(-138.86, -1274.78, 955.6),
        vector3(-141.1, -1269.69, 955.6),
        vector3(-139.42, -1264.73, 955.6),
        vector3(-136.15, -1268.38, 955.6),
        vector3(-147.29, -1262.42, 955.6),
        vector3(-149.19, -1258.38, 955.6),
        vector3(-141.37, -1259.85, 955.6),
        vector3(-136, -1254.36, 955.6),
        vector3(-142.7, -1251.42, 955.6),
        vector3(-138.3, -1246.15, 955.6),
        vector3(-144.9, -1244.43, 955.6),
        vector3(-143.7, -1240.8, 955.6),
        vector3(-140.56, -1235.51, 955.6),
        vector3(-144.55, -1230.33, 955.6),
        vector3(-150.64, -1235.19, 955.6),
        vector3(-154.3, -1247.22, 955.6),
        vector3(-156.68, -1254.73, 955.6),
        vector3(-158.02, -1248.78, 955.6),
        vector3(-149.54, -1245.19, 955.6),
        vector3(-142.09, -1241.04, 955.6),
        vector3(-144.14, -1232.57, 955.6),
        vector3(-157.24, -1239.39, 955.6),
        vector3(-164.05, -1245.62, 955.6),
        vector3(-167.41, -1252.81, 955.6),
        vector3(-170.16, -1243.4, 955.6),
        vector3(-171.65, -1237.39, 955.6),
        vector3(-169.08, -1232.83, 955.6),
        vector3(-162.47, -1228.34, 955.6),
        vector3(-160.62, -1217.71, 955.6),
        vector3(-164.08, -1210.18, 955.6),
        vector3(-171.28, -1213.23, 955.6),    
        vector3(-177.4, -1223.59, 955.6),
        vector3(-179.76, -1231.02, 955.6),
        vector3(-183.56, -1223.67, 955.6),    
        vector3(-186.39, -1212.85, 955.6),
        vector3(-186.17, -1201.99, 955.6),
        vector3(-191.2299957275391, -1203.760009765625, 955.5999755859376),
        vector3(-192.1999969482422, -1208.7099609375, 955.5999755859376),
        vector3(-189.3000030517578, -1214.47998046875, 955.5999755859376),
        vector3(-184.75999450683597, -1221.010009765625, 955.5999755859376),
        vector3(-183.4499969482422, -1231.02001953125, 955.5999755859376),
        vector3(-186, -1241.010009765625, 955.5999755859376),
        vector3(-181.38999938964844, -1246.31005859375, 955.5999755859376),
        vector3(-180.4799957275391, -1253.760009765625, 955.5999755859376),
        vector3(-188.97000122070312, -1254.4599609375, 955.5999755859376),
        vector3(-189.9900054931641, -1260.3900146484375, 955.5999755859376),
        vector3(-197.9499969482422, -1259.8399658203125, 955.5999755859376),
        vector3(-205.8800048828125, -1256.3599853515625, 955.5999755859376),
        vector3(-211.83999633789065, -1250.510009765625, 955.5999755859376),
        vector3(-217.0800018310547, -1259.510009765625, 955.5999755859376),
        vector3(-209.7100067138672, -1262.050048828125, 955.5999755859376),
        vector3(-201.77999877929688, -1266.77001953125, 955.5999755859376),
        vector3(-199.27999877929688, -1274.8399658203125, 955.5999755859376),
        vector3(-200.5800018310547, -1280.4200439453125, 955.5999755859376),
        vector3(-208.6999969482422, -1282.47998046875, 955.5999755859376),
        vector3(-214.9900054931641, -1275.8299560546875, 955.5999755859376),
        vector3(-221, -1271.97998046875, 955.5999755859376),
        vector3(-230, -1271.1800537109375, 955.5999755859376),
        vector3(-229.85000610351565, -1277.3399658203125, 955.5999755859376),
        vector3(-222.5399932861328, -1282.3900146484375, 955.5999755859376),
        vector3(-217.5526, -1283.7766, 955.6009), 
        vector3(-213.5511, -1289.4158, 955.6012), 
        vector3(-218.8865, -1296.2222, 955.6013), 
        vector3(-221.2521, -1303.0822, 955.6011), 
        vector3(-219.9249, -1311.0697, 955.6011),
        vector3(-221.4969, -1320.9056, 955.6011), 
        vector3(-217.2589, -1329.2311, 955.6011), 
        vector3(-210.8849, -1325.7043, 955.6010), 
        vector3(-203.1292, -1328.3837, 955.6012), 
        vector3(-199.8953, -1321.1624, 955.6011),
        vector3(-188.6675, -1314.1788, 955.6016), 
        vector3(-181.9776, -1307.6886, 955.6011), 
        vector3(-176.5572, -1313.6736, 955.6012), 
        vector3(-170.1225, -1321.0953, 955.6011),
        vector3(-163.7419, -1315.3383, 955.6009), 
        vector3(-164.4833, -1307.5763, 955.6012), 
        vector3(-156.9098, -1310.8922, 955.6011), 
        vector3(-154.7799, -1304.5526, 955.6012), 
        vector3(-154.9199, -1296.3422, 956.8959), 
        vector3(-161.5225, -1296.5679, 959.8536), 
        vector3(-163.8873, -1286.8444, 961.5911), 
        vector3(-174.3167, -1291.7140, 962.0114), 
        vector3(-181.9816, -1288.9911, 960.7223), 
        vector3(-173.9146, -1279.8005, 962.6361), 
        vector3(-168.6824, -1280.0024, 962.6362),
        vector3(-164.6469, -1276.6378, 962.6353), 
        vector3(-161.7926, -1277.3240, 961.6788), 
        vector3(-159.5187, -1267.4089, 959.7657), 
        vector3(-170.6490, -1263.2175, 959.3193),
        vector3(-175.3445, -1258.1631, 956.8970), 
        vector3(-219.0100, -1244.3898, 956.8959),
        vector3(-222.1455, -1257.9691, 956.8971),
        vector3(-228.0536, -1261.6145, 959.7579), 
        vector3(-233.1801, -1266.6327, 957.8530), 
        vector3(-237.1465, -1264.2507, 959.7638), 
        vector3(-237.9669, -1259.1323, 961.6798),
        vector3(-244.6316, -1255.2832, 961.6796),
        vector3(-246.7297, -1247.5393, 961.6799), 
        vector3(-250.9548, -1249.0431, 960.7222), 
        vector3(-256.4647, -1242.2382, 959.7655), 
        vector3(-250.8264, -1235.5151, 960.7223),
        vector3(-247.1546, -1235.2290, 961.6787), 
        vector3(-241.8360, -1238.3677, 962.6352), 
        vector3(-235.5661, -1243.0591, 962.6363), 
        vector3(-229.5173, -1238.1216, 961.6786), 
        vector3(-228.7690, -1235.2986, 960.7233), 
        vector3(-234.8788, -1228.7891, 959.7659),
        vector3(-226.8885, -1229.4061, 959.7667), 
        vector3(-225.0619, -1235.4271, 959.7665), 
        vector3(-220.8988, -1235.8866, 957.8529), 
        vector3(-225.1885, -1227.2975, 957.8536),
        vector3(-233.0686, -1221.2374, 956.8971), 
        vector3(-241.2838, -1222.2925, 956.8944),
        vector3(-217.6054, -1215.4608, 956.2465),
        vector3(-217.7235, -1295.4181, 955.6002), 
        vector3(-216.5001, -1292.0751, 955.6002), 
        vector3(-214.4264, -1284.4551, 955.6002), 
        vector3(-210.7485, -1278.7592, 955.6003),
        vector3(-203.8281, -1273.9561, 955.6011),
        vector3(-208.0389, -1266.9703, 955.6010), 
        vector3(-205.2606, -1262.5479, 955.6009), 
        vector3(-198.2631, -1257.7286, 955.6012), 
        vector3(-200.3444, -1249.2061, 955.6012), 
        vector3(-197.3316, -1241.8573, 955.6013), 
        vector3(-200.1988, -1235.4988, 955.6013), 
        vector3(-209.4032, -1225.5704, 955.6011), 
        vector3(-208.3552, -1216.2803, 955.6012), 
        vector3(-200.6359, -1214.2821, 955.6010), 
        vector3(-199.3393, -1210.4359, 955.6012), 
        vector3(-207.0198, -1206.6821, 955.6011), 
        vector3(-212.3775, -1199.0748, 955.6012), 
        vector3(-224.9937, -1198.7406, 955.6011), 
        vector3(-229.5497, -1200.1556, 955.6013),
        vector3(-234.5613, -1206.6107, 955.5994),
        vector3(-239.0202, -1204.6373, 955.6017), 
        vector3(-242.7274, -1206.5323, 955.6007), 
        vector3(-244.2291, -1209.9326, 955.6003), 
        vector3(-248.2246, -1210.3097, 955.6003),
        vector3(-250.1834, -1214.8923, 955.6002),
        vector3(-254.9293, -1216.6268, 955.6002),
        vector3(-253.3735, -1221.3860, 955.6009),
        vector3(-259.4377, -1227.5540, 955.6016), 
        vector3(-258.2283, -1232.4973, 956.8962), 
        vector3(-253.4879, -1234.3740, 959.7656),
        vector3(-256.5883, -1242.6935, 959.7667), 
        vector3(-251.8277, -1245.1807, 960.7222), 
        vector3(-251.3384, -1249.4940, 960.7222),
        vector3(-250.7796, -1253.9397, 960.7222),
        vector3(-242.4156, -1257.9774, 961.7545),
        vector3(-240.0599, -1255.3051, 962.0309),
        vector3(-235.5612, -1258.3207, 961.6799), 
        vector3(-235.6857, -1263.8469, 959.7703), 
        vector3(-233.0349, -1268.8619, 956.8972),
        vector3(-226.0003, -1262.4155, 957.8530),
        vector3(-221.7145, -1259.1150, 956.8970),
        vector3(-221.1224, -1254.0734, 956.8962), 
        vector3(-215.6974, -1248.2662, 955.6002), 
        vector3(-208.0568, -1246.9580, 955.6011), 
        vector3(-203.0557, -1250.3457, 955.6011), 
        vector3(-195.1722, -1245.9368, 955.6012), 
        vector3(-190.1138, -1250.0276, 955.6012),
        vector3(-183.1678, -1250.2024, 955.6010), 
        vector3(-181.3603, -1247.0873, 955.6010), 
        vector3(-172.9488, -1242.2356, 955.6013)
    }
}