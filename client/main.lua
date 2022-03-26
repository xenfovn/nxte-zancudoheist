local QBCore = exports['qb-core']:GetCoreObject()

-- props
local trolly = nil
local trolly2 = nil
-- blips
local hackBlip = nil
local lootBlip = nil
local bombBlip = nil

-- variables
local Buyer = nil
local CopCount = 0

local isActive = nil
local isHacked = nil
local isExploded = nil
local isLooted = nil
local isLooted2 = nil

---------------
-- FUNCTIONS --
---------------

-- send notification to police
local function CallCops()
 -- code to call cops here
end 

-- spawn the needed props
local function SpawnProps() 
    if trolly == nil then 
        trolly = CreateObject(`hei_prop_hei_cash_trolly_01`,-2111.0, 3289.83, 31.8, true, false, false)
        SetEntityHeading(trolly, 151.96)
        FreezeEntityPosition(trolly, true)
    else 
        DeleteEntity(trolly)
        trolly = nil
        trolly = CreateObject(`hei_prop_hei_cash_trolly_01`,-2111.0, 3289.83, 31.8, true, false, false)
        SetEntityHeading(trolly, 151.96)
        FreezeEntityPosition(trolly, true)
    end 

    if trolly2 == nil then 
        trolly2 = CreateObject(`hei_prop_hei_cash_trolly_01`,-2116.8, 3293.2, 31.8, true, false, false)
        SetEntityHeading(trolly2, 151.96)
        FreezeEntityPosition(trolly2, true)
    else 
        DeleteEntity(trolly2)
        trolly2 = nil 
        trolly2 = CreateObject(`hei_prop_hei_cash_trolly_01`,-2116.8, 3293.2, 31.8, true, false, false)
        SetEntityHeading(trolly2, 151.96)
        FreezeEntityPosition(trolly2, true)
    end

end

-- remove the props
local function RemoveProps()
    DeleteEntity(trolly)
    DeleteEntity(trolly2)
    trolly = nil
    trolly2 = nil
end

-- set blip on hack location
local function HackBlip()
    hackBlip = AddBlipForCoord(-2390.03, 2966.77, 33.83)
    SetBlipSprite(hackBlip, 606)
    SetBlipColour(hackBlip, 66)
    SetBlipDisplay(hackBlip, 4)
    SetBlipScale(hackBlip, 0.8)
    SetBlipAsShortRange(hackBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Hack')
    EndTextCommandSetBlipName(hackBlip)
end

-- set blip on loot location
local function BombBlip()
    bombBlip = AddBlipForCoord(-2512.73,  3300.02, 34.01)
    SetBlipSprite(bombBlip, 486)
    SetBlipColour(bombBlip, 66)
    SetBlipDisplay(bombBlipp, 4)
    SetBlipScale(bombBlip, 0.8)
    SetBlipAsShortRange(bombBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Bomb')
    EndTextCommandSetBlipName(bombBlip)
end

-- set blip on loot location
local function LootBlip()
    lootBlip = AddBlipForCoord(-2119.24, 3283.08, 31.8)
    SetBlipSprite(lootBlip, 272)
    SetBlipColour(lootBlip, 66)
    SetBlipDisplay(lootBlip, 4)
    SetBlipScale(lootBlip, 0.8)
    SetBlipAsShortRange(lootBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Items')
    EndTextCommandSetBlipName(lootBlip)
end

-- function for when hack is done 
local function OnHackDone(success)
    if success then 
        QBCore.Functions.Notify('You hacked the alarm system','success')
        RemoveBlip(hackBlip)
        BombBlip()
        TriggerServerEvent('nxte-zancudo:server:SetHack', true)
        CallCops()
        TriggerServerEvent('QBCore:Server:RemoveItem', Config.HackItem, 1, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.HackItem], 'remove')
    else
        QBCore.Functions.Notify('You failed to hack the alarm system','error')
        CallCops()
        TriggerServerEvent('QBCore:Server:RemoveItem', Config.HackItem, 1, slot, info)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.HackItem], 'remove')
    end
end

-- anim place the bomb
local PlantBomb = function(index)
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do Wait(50) end
    local ped = PlayerPedId() --33
    local pos = vector4(-2512.81, 3299.71, 33, 328.59)
    SetEntityHeading(ped, pos.w)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local charge = CreateObject(`ch_prop_ch_explosive_01a`, x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(charge, false, true)
    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(5000)
    DetachEntity(charge, 1, 1)
    FreezeEntityPosition(charge, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)
    CreateThread(function()
        QBCore.Functions.Notify('The bomb will go off in '..Config.BombTime.. ' seconds', 'success')
        Wait(Config.BombTime * 1000)
        DeleteEntity(charge)  
        AddExplosion(-2512.73,  3300.02, 34.01, 50, 5.0, true, false, 15.0)
        QBCore.Functions.Notify('You disabled the communication tower', 'success')
        RemoveBlip(bombBlip)
        LootBlip()
    end)
end



------------
-- EVENTS --
------------

-- sync all info on player Load to prevent exploiting 
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('nxte-zancudo:server:OnPlayerLoad')
end)

-- remove props on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        RemoveProps()
    end
end)

-- on mission reset
RegisterNetEvent('nxte-zancudo:client:ResetMission', function()
    TriggerServerEvent('nxte:zancudo:server:ResetMission')
    RemoveBlip(hackBlip)
    RemoveBlip(bombBlip)
    RemoveBlip(lootBlip)
    RemoveProps()
end)

-- start heist
RegisterNetEvent('nxte-zancudo:client:startheist', function()
    TriggerServerEvent('nxte-zancudo:server:GetCops')
    TriggerServerEvent('nxte-zancudo:server:GetActive')
    local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(-1705.22, 216.76, 61.4))
    SetEntityHeading(ped, 345.8)
    TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
    QBCore.Functions.Progressbar("start", "Knocking on door...", 4000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if not isActive then 
            if CopCount >= Config.MinCop then 
                if cash >= Config.JobPrice then
                    TriggerServerEvent('nxte-zancudo:server:removemoney', Config.JobPrice)
                    TriggerServerEvent('nxte-zancudo:server:SetActive', true)
                    QBCore.Functions.Notify('You paid $'..Config.JobPrice.. ' for the GPS locations', 'success')
                    Buyer = Player.citizenid
                    HackBlip()
                    SpawnProps()
                else
                    QBCore.Functions.Notify('Are you a amature ? ofcourse i want it cash')
                end
            else
                QBCore.Functions.Notify('There is not enough police right now', 'error')
            end
        else 
            QBCore.Functions.Notify('No one seems to be home right now' , 'error')
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify('Cancelled knocking on the door', 'error')
    end)
end)


-- start Hack 
RegisterNetEvent('nxte-zancudo:client:hack', function()
    TriggerServerEvent('nxte-zancudo:server:GetHack')
    if isActive then 
        if not isHacked then 
            if QBCore.Functions.HasItem(Config.HackItem) then 
                TriggerEvent('nxte-zancudo:anim:hack1')
            else
                QBCore.Functions.Notify('You do not have the right tool to do this', 'error')
            end
        else 
                QBCore.Functions.Notify('This terminal has alrady been hacked', 'error')
        end
    else 
        QBCore.Functions.Notify('You currently can not do this', 'error')
    end
end)

-- animation for the hack
RegisterNetEvent('nxte-zancudo:anim:hack1', function()
    local loc = {x,y,z,h}
    loc.x = -2389.72
    loc.y = 2965.3
    loc.z = 34.06
    loc.h = 14.95

    local animDict = 'anim@heists@ornate_bank@hack'
    RequestAnimDict(animDict)
    RequestModel('hei_prop_hst_laptop')
    RequestModel('hei_p_m_bag_var22_arm_s')

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded('hei_prop_hst_laptop')
        or not HasModelLoaded('hei_p_m_bag_var22_arm_s') do
        Wait(100)
    end

    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, 'hack_enter', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, 'hack_loop', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, 'hack_exit', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey('hei_prop_hst_laptop'), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, 'hack_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, 'hack_enter_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, 'hack_enter_laptop', 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, 'hack_loop_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, 'hack_loop_laptop', 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, 'hack_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, 'hack_exit_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, 'hack_exit_laptop', 4.0, -8.0, 1)

    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Wait(2000)

    exports['hacking']:OpenHackingGame(Config.HackTime, Config.HackSquares, Config.HackRepeat, function(success)
        NetworkStartSynchronisedScene(netScene3)
        NetworkStopSynchronisedScene(netScene3)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, Config.BagUseID, 0, 1)
        DeleteObject(laptop)
        FreezeEntityPosition(ped, false)
        OnHackDone(success)
    end)
end)

-- start bomb
RegisterNetEvent('nxte-zancudo:client:bomb', function()
    TriggerServerEvent('nxte-zancudo:server:GetBomb')
    if isActive then
        if isHacked then
            if not isExploded then 
                if QBCore.Functions.HasItem(Config.BombItem) then 
                    TriggerServerEvent('QBCore:Server:RemoveItem', Config.BombItem, 1, slot, info)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.BombItem], 'remove')
                    PlantBomb(1)
                    TriggerServerEvent('nxte-zancudo:server:SetBomb', true)
                    TriggerEvent('nxte-zancudo:client:SpawnNPC', 1)
                else
                    QBCore.Functions.Notify('You do not have the right tool to do this', 'error')
                end
            else 
                QBCore.Functions.Notify('Their communicationis already destroyed', 'error')
            end
        else 
            QBCore.Functions.Notify('The alarm is still active', 'error')
        end
    else 
        QBCore.Functions.Notify('You currently can not do this', 'error')
    end
end)

-- start table 1
RegisterNetEvent('nxte-zancudo:client:cash1', function()
    TriggerServerEvent('nxte-zancudo:server:GetLoot1')
    if isActive then
        if isExploded then
            if not isLooted then
                TriggerServerEvent('nxte-zancudo:server:SetLoot1', true)
                TriggerEvent('nxte-zancudo:client:StartGrab')
            else
                QBCore.Functions.Notify('This table already got looted', 'error')
            end
        else
            QBCore.Functions.Notify('The communication tower is still up', 'error')
        end
    else 
        QBCore.Functions.Notify('You currently can not do this', 'error')
    end
end)

-- start table 2
RegisterNetEvent('nxte-zancudo:client:cash2', function()
    TriggerServerEvent('nxte-zancudo:server:GetLoot2')
    if isActive then
        if isExploded then
            if not isLooted2 then
                TriggerServerEvent('nxte-zancudo:server:SetLoot2', true)
                TriggerEvent('nxte-zancudo:client:StartGrab')
            else
                QBCore.Functions.Notify('This table already got looted', 'error')
            end
        else
            QBCore.Functions.Notify('The communication tower is still up', 'error')
        end
    else 
        QBCore.Functions.Notify('You currently can not do this', 'error')
    end
end)


--- trolly anim
RegisterNetEvent('nxte-zancudo:client:StartGrab', function()
    LocalPlayer.state:set("inv_busy", true, true)
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"
    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)
        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)
	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()
	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, `CASH_APPEAR`) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    emptyobj = `hei_prop_hei_cash_trolly_03`

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end

    local rot = GetEntityHeading(trollyobj)
    local targetPosition = GetEntityCoords(trollyobj)
    local targetRotation = vector3(0.0, 0.0, rot)
    local animPos = GetAnimInitialOffsetPosition('anim@heists@ornate_bank@grab_cash', "intro", targetPosition[1], targetPosition[2], targetPosition[3], targetRotation, 0, 2)
    local targetHeading = rot
    Wait(100)

    local baghash = `ch_p_m_bag_var03_arm_s`
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, true, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)

    TriggerServerEvent('nxte-zancudo:server:GiveItem')

	Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var03_arm_s`)
    LocalPlayer.state:set("inv_busy", false, true)
end)



-----------
--- NPC ---
-----------
-- set NPC data
RegisterNetEvent('nxte-zancudo:client:SpawnNPC', function(position)
    QBCore.Functions.TriggerCallback('nxte-zancudo:server:SpawnNPC', function(netIds, position)
        Wait(1000)
        local ped = PlayerPedId()
        for i=1, #netIds, 1 do
            local npc = NetworkGetEntityFromNetworkId(netIds[i])
            SetPedDropsWeaponsWhenDead(npc, false)
            GiveWeaponToPed(npc, Config.PedGun, 250, false, true)
            SetPedMaxHealth(npc, 300)
            SetPedArmour(npc, 200)
            SetCanAttackFriendly(npc, true, false)
            TaskCombatPed(npc, ped, 0, 16)
            SetPedCombatAttributes(npc, 46, true)
            SetPedCombatAttributes(npc, 0, false)
            SetPedCombatAbility(npc, 100)
            SetPedAsCop(npc, true)
            SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
            SetPedAccuracy(npc, 60)
            SetPedFleeAttributes(npc, 0, 0)
            SetPedKeepTask(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
        end
    end, position)
end)





-----------------
-- Server Sync --
-----------------

-- get cops
RegisterNetEvent('nxte-zancudo:client:GetCops',function(amount)
    CopCount = amount
end)

-- get isactive
RegisterNetEvent('nxte-zancudo:client:SetActive', function(status)
    isActive = status
end)

-- get ishacked
RegisterNetEvent('nxte-zancudo:client:SetHack', function(status)
    isHacked = status
end)

-- get isexploded
RegisterNetEvent('nxte-zancudo:client:SetBomb', function(status)
    isExploded = status
end)

-- get isexploded
RegisterNetEvent('nxte-zancudo:client:SetLoot1', function(status)
    isLooted = status
end)

-- get isexploded
RegisterNetEvent('nxte-zancudo:client:SetLoot2', function(status)
    isLooted2 = status
end)


-- Check if player is dead to stop mission
Citizen.CreateThread(function()
    while true do
        if isActive then
            local Player = QBCore.Functions.GetPlayerData()
            local Playerid = Player.citizenid
            if Playerid == Buyer then
                if Player.metadata["inlaststand"] or Player.metadata["isdead"] then
                    QBCore.Functions.Notify('Mission Failed', 'error')
                    TriggerServerEvent('nxte-zancudo:client:ResetMission')
                    Citizen.Wait(2000)
                    Buyer = nil
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

-- check if mission is complete to reset
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if isLooted and isLooted2 then 
            RemoveBlip(lootBlip)
            Citizen.Wait(Config.TimeOut*60000)
           TriggerEvent('nxte-zancudo:client:ResetMission')
        end
    end
end)
