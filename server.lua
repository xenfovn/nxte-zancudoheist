local QBCore = exports['qb-core']:GetCoreObject()

local CopCount = 0
local isActive = nil
local isHacked = nil
local isExploded = nil
local isLooted = nil
local isLooted2 = nil

-- on player load
RegisterNetEvent('nxte-zancudo:server:OnPlayerLoad', function()
    TriggerEvent('nxte-zancudo:server:GetActive')
    TriggerEvent('nxte-zancudo:server:GetHack')
    TriggerEvent('nxte-zancudo:server:GetBomb')
    TriggerEvent('nxte-zancudo:server:GetLoot1')
    TriggerEvent('nxte-zancudo:server:GetLoot2')
end)

RegisterNetEvent('nxte:zancudo:server:ResetMission', function()
    TriggerEvent('nxte-zancudo:server:SetActive', false)
    TriggerEvent('nxte-zancudo:server:SetHack', false)
    TriggerEvent('nxte-zancudo:server:SetBomb', false)
    TriggerEvent('nxte-zancudo:server:SetLoot1', false)
    TriggerEvent('nxte-zancudo:server:SetLoot2', false)
end)

-- getting active cops
RegisterNetEvent('nxte-zancudo:server:GetCops', function()
	local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    CopCount = amount
    TriggerClientEvent('nxte-zancudo:client:GetCops', -1, amount)
end)

-- remove money
RegisterNetEvent('nxte-zancudo:server:removemoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', tonumber(amount))
end)

-- is active
RegisterNetEvent('nxte-zancudo:server:GetActive', function()
    if isActive then
        TriggerClientEvent('nxte-zancudo:client:SetActive', -1, true)
    else
        TriggerClientEvent('nxte-zancudo:client:SetActive', -1, false)
    end
end)

RegisterNetEvent('nxte-zancudo:server:SetActive', function(status)
    isActive = status
    TriggerClientEvent('nxte-zancudo:client:SetActive', -1, status)
end)

-- is hacked
RegisterNetEvent('nxte-zancudo:server:GetHack', function()
    if isHacked then
        TriggerClientEvent('nxte-zancudo:client:SetHack', -1, true)
    else
        TriggerClientEvent('nxte-zancudo:client:SetHack', -1, false)
    end
end)

RegisterNetEvent('nxte-zancudo:server:SetHack', function(status)
    isHacked = status
    TriggerClientEvent('nxte-zancudo:client:SetHack', -1, status)
end)

-- is exploded
RegisterNetEvent('nxte-zancudo:server:GetBomb', function()
    if isExploded then
        TriggerClientEvent('nxte-zancudo:client:SetBomb', -1, true)
    else
        TriggerClientEvent('nxte-zancudo:client:SetBomb', -1, false)
    end
end)

RegisterNetEvent('nxte-zancudo:server:SetBomb', function(status)
    isExploded = status
    TriggerClientEvent('nxte-zancudo:client:SetBomb', -1, status)
end)

-- is looted 1
RegisterNetEvent('nxte-zancudo:server:GetLoot1', function()
    if isLooted then
        TriggerClientEvent('nxte-zancudo:client:SetLoot1', -1, true)
    else
        TriggerClientEvent('nxte-zancudo:client:SetLoot1', -1, false)
    end
end)

RegisterNetEvent('nxte-zancudo:server:SetLoot1', function(status)
    isLooted = status
    TriggerClientEvent('nxte-zancudo:client:SetLoot1', -1, status)
end)

-- is looted 2
RegisterNetEvent('nxte-zancudo:server:GetLoot2', function()
    if isLooted2 then
        TriggerClientEvent('nxte-zancudo:client:SetLoot2', -1, true)
    else
        TriggerClientEvent('nxte-zancudo:client:SetLoot2', -1, false)
    end
end)

RegisterNetEvent('nxte-zancudo:server:SetLoot2', function(status)
    isLooted2 = status
    TriggerClientEvent('nxte-zancudo:client:SetLoot2', -1, status)
end)

-- give loot 
RegisterNetEvent('nxte-zancudo:server:GiveItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    if Config.TrolleyItem == 'markedbills' then 
        local info = { 
            worth = math.random(Config.TrolleyMinValue, Config.TrolleyMaxValue)
        }
        ply.Functions.AddItem(Config.TrolleyItem, math.random(Config.TrolleyMinAmount,Config.TrolleyMaxAmount), false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TrolleyItem], "add")
    else
        ply.Functions.AddItem(Config.TrolleyItem, math.random(Config.TrolleyMinAmount,Config.TrolleyMaxAmount), false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TrolleyItem], "add")
    end
end)

-- NPC 
local peds = { 
    `mp_m_securoguard_01`,
    `s_m_m_security_01`,
    `s_m_m_highsec_01`,
    `s_m_m_highsec_02`,
    `s_m_m_marine_01`,
    `s_m_m_prisguard_01`,
    `s_m_m_strpreach_01`,
    `s_m_y_armymech_01`,
}

local getRandomNPC = function()
    return peds[math.random(#peds)]
end

QBCore.Functions.CreateCallback('nxte-zancudo:server:SpawnNPC', function(source, cb, loc)
    local netIds = {}
    local netId
    local npc
    for i=1, #Config.Shooters['soldiers'].locations[loc].peds, 1 do
        npc = CreatePed(30, getRandomNPC(), Config.Shooters['soldiers'].locations[loc].peds[i], true, false)
        while not DoesEntityExist(npc) do Wait(10) end
        netId = NetworkGetNetworkIdFromEntity(npc)
        netIds[#netIds+1] = netId
    end
    cb(netIds)
end)

