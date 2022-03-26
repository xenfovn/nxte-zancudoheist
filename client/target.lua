local QBCore = exports['qb-core']:GetCoreObject()

-----------------------
--- QB-Target stuff --- vector3(-1704.94, 217.51, 63.57)
-----------------------

-- trigger start mission
exports['qb-target']:AddBoxZone("nxte-zancudo:start", vector3(-1704.94, 217.51, 63.57), 0.5, 2.5, {
	name = "nxte-zancudo:start",
	heading = 161.14,
	debugPoly = false,
	minZ = 61.4,
	maxZ = 63.6,
}, {
	options = {
		{
            type = "client",
            event = "nxte-zancudo:client:startheist",
			icon = "fas fa-circle",
			label = "Knock on door",
		},
	},
	distance = 2.5
})

-- trigger hack
exports['qb-target']:AddBoxZone("nxte-zancudo:hack", vector3(-2390.03, 2966.77, 33.83), 1.1, 1.4, {
	name = "nxte-zancudo:hack",
	heading = 192.5,
	debugPoly = false,
	minZ = 32,
	maxZ = 33.7,
}, {
	options = {
		{
            type = "client",
            event = "nxte-zancudo:client:hack",
			icon = "fas fa-circle",
			label = "Disable alarm system",
		},
	},
	distance = 2.5
})

-- trigger bomb
exports['qb-target']:AddBoxZone("nxte-zancudo:bomb", vector3(-2512.73, 3300.02, 34.01), 0.8, 2, {
	name = "nxte-zancudo:bomb",
	heading = 331.08,
	debugPoly = false,
	minZ = 32,
	maxZ = 34,
}, {
	options = {
		{
            type = "client",
            event = "nxte-zancudo:client:bomb",
			icon = "fas fa-circle",
			label = "Place bomb",
		},
	},
	distance = 2.5
})

-- trigger anim cash pile 1
exports['qb-target']:AddBoxZone("nxte-zancudo:cash1", vector3(-2111.0, 3289.83, 32.0), 0.5, 1.2, {
	name = "nxte-zancudo:startheist",
	heading = 151.96,
	debugPoly = false,
	minZ = 32,
	maxZ = 33.2,
}, {
	options = {
		{
            type = "client",
            event = "nxte-zancudo:client:cash1",
			icon = "fas fa-circle",
			label = "Grab items",
		},
	},
	distance = 2.5
})

-- trigger anim cash pile 2
exports['qb-target']:AddBoxZone("nxte-zancudo:cash2", vector3(-2116.8, 3293.2, 32.0), 0.5, 1.2, {
	name = "nxte-zancudo:startheist",
	heading = 151.96,
	debugPoly = false,
	minZ = 32,
	maxZ = 33.2,
}, {
	options = {
		{
            type = "client",
            event = "nxte-zancudo:client:cash2",
			icon = "fas fa-circle",
			label = "Grab items",
		},
	},
	distance = 2.5
})
