Config = {}

Config.Marker = { type = 21, x = 1.0, y = 1.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.Mechanic = {

	Mechanic = {

		Blip = {
			coords = vector3(1108.25, -787.6, 59.86),
			sprite = 181,
			scale  = 1.2,
			color  = -1
		},

		MechanicActions = {
			vector3(1108.25, -787.6, 59.86)
		},

		Vehicles = {
			{
				Spawner = vector3(1156.39, -782.01, 59.41),
                InsideShop = vector3(1154.31, -734.72, 57.7),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1160.16, -779.42, 59.41), heading = 84.99, radius = 4.0 },
					{ coords = vector3(1160.03, -776.07, 59.41), heading = 84.99, radius = 4.0 },
					{ coords = vector3(1160.18, -772.59, 59.41), heading = 84.99, radius = 4.0 }
				},
			}
		},
	}
}

Config.AuthorizedVehicles = {
    recrue = {

    },

    novice = {

    },

    experimente = {

    },

    chief = {

    },

    boss = {
        { model = '12hiace', label = 'รถตู้', price = 1000 }
    }
}
