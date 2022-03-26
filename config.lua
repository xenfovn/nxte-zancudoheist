Config = {}

Config.MinCop = 1 -- minimum cops needed to be able to do the heist
Config.JobPrice = 10000 -- Price to pay to start the job
Config.TimeOut = 45 -- how long you want the heist to not be able to do after a successfull hit in minuits

-- Hack
Config.HackItem = 'electronickit' -- item used to do the hack
Config.HackTime = 12 -- time player has to complete the hack 
Config.HackSquares = 4 -- amount of squares the player has to hack
Config.HackRepeat = 1 -- amount of times player has to complete the hack

-- bomb
Config.BombItem = 'weapon_pipebomb' -- item needed to be able to place the bomb
Config.BombTime = 10 -- time in sec the bomb needs to explode after placing it 

-- rewards
Config.TrolleyItem = 'markedbills'
Config.TrolleyMinAmount = 1
Config.TrolleyMaxAmount = 5
--- only needed if you use marked bills as reward
Config.TrolleyMinValue = 1000
Config.TrolleyMaxValue = 5000

--NPC
Config.PedGun = 'weapon_microsmg' -- weapon NPC's use

-- NPC coords
Config.Shooters = {
    ['soldiers'] = {
        locations = {
            [1] = { -- on Hack
                peds = {vector3(-2136.14, 3279.22, 32.81),vector3(-2148.97, 3276.1, 32.81),vector3(-2163.11, 3260.84, 32.81),vector3(-2152.41, 3285.73, 38.73),vector3(-2143.18, 3293.77, 38.73),vector3(-2130.1, 3286.68, 38.73),vector3(-2111.92, 3274.85, 38.73),vector3(-2106.97, 3271.12, 38.73),vector3(-2114.89, 3241.7, 32.81),vector3(-2109.35, 3254.45, 32.81),vector3(-2115.32, 3266.13, 32.81)}
            },
        },
    }
}