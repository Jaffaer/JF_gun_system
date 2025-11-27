if not JF.Jamming["Enabled"] then return end

local utils = require 'utils'

local jammedWeapons = {}

local jamAnim = JF.Jamming["Animation"]
local currentWeapon = nil

local isDoingSkillcheck = false
local waitingForInput = false
local cancelFix = false

local function getWeaponJamChance(weaponName, durability)
    if not weaponName or not durability then return nil end
    
    weaponName = string.upper(weaponName)
    
    local weaponConfig = JF.Jamming["Weapons"][weaponName]
    
    if not weaponConfig then return nil end
    
    local closestDur = nil
    local minDiff = math.huge
    
    for dur, _ in pairs(weaponConfig) do
        local diff = math.abs(durability - dur)
        if diff < minDiff then
            minDiff = diff
            closestDur = dur
        end
    end
    
    return weaponConfig[closestDur]
end

local function shouldWeaponJam(weaponName, durability)
    local jamChance = getWeaponJamChance(weaponName, durability)

    if not jamChance then return false end
    
    local roll = math.random(1, 100)
    return roll <= jamChance
end

local function showFixNotification()
    lib.showTextUI(
        "[E] Fixa vapen",
        { position = "right-center" }
    )
    waitingForInput = true
end

local function showCancelNotification()
    lib.showTextUI(
        "[X] Avbryt",
        { position = "right-center" }
    )
end

local function clearFixNotification()
    lib.hideTextUI()
end

AddEventHandler("ox_inventory:currentWeapon", function(data)
    currentWeapon = data

    clearFixNotification()
    waitingForInput = false

    if currentWeapon and currentWeapon.metadata and currentWeapon.metadata.serial then
        local serial = currentWeapon.metadata.serial
        if jammedWeapons[serial] then
            showFixNotification()
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if currentWeapon and currentWeapon.metadata and currentWeapon.metadata.serial then
            local serial = currentWeapon.metadata.serial
            if jammedWeapons[serial] then
                local ped = cache.ped
                
                DisablePlayerFiring(cache.playerId, true)
                DisableControlAction(0, 25, false)
                
                if IsPedInAnyVehicle(ped, false) then
                    DisableControlAction(0, 69, true) 
                    DisableControlAction(0, 92, true)  
                    DisableControlAction(0, 114, true) 
                    DisableControlAction(0, 331, true) 
                    
                    SetPlayerCanDoDriveBy(cache.playerId, false)
                end
            else
                if IsPedInAnyVehicle(cache.ped, false) then
                    SetPlayerCanDoDriveBy(cache.playerId, true)
                end
            end
        end
    end
end)

local function playFixAnimation()
    CreateThread(function()
        lib.requestAnimDict(jamAnim.Dict)

        while isDoingSkillcheck and not cancelFix do
            TaskPlayAnim(cache.ped, jamAnim.Dict, jamAnim.Anim, 1.0, 1.0, -1, 49, 0.0, false, false, false)
            Wait(3000)
        end

        ClearPedTasks(cache.ped)
    end)
end

local function doSkillCheck()
    if isDoingSkillcheck then return end
    isDoingSkillcheck = true
    waitingForInput = false
    cancelFix = false

    clearFixNotification()

    showCancelNotification()

    CreateThread(function()
        while isDoingSkillcheck do
            if IsControlJustPressed(0, 73) then
                cancelFix = true
                break
            end
            Wait(0)
        end
    end)

    playFixAnimation()

    Wait(500)

    local success = lib.skillCheck(
        { 'easy', 'easy', { areaSize = 50, speedMultiplier = 1 }, 'easy' },
        { '1', '2', '3' }
    )

    if cancelFix then
        isDoingSkillcheck = false
        clearFixNotification()
        JF.Notification("Du avbröt fixningen.")
        return
    end

    if success and currentWeapon and currentWeapon.metadata and currentWeapon.metadata.serial then
        local serial = currentWeapon.metadata.serial
        jammedWeapons[serial] = false
        
        SetPlayerCanDoDriveBy(cache.playerId, true)
        
        JF.Notification(JF.Labels["has_unjammed"])
    end

    clearFixNotification()
    isDoingSkillcheck = false
end

CreateThread(function()
    while true do
        Wait(0)

        if currentWeapon and currentWeapon.metadata and currentWeapon.metadata.serial then
            local serial = currentWeapon.metadata.serial
            if waitingForInput and jammedWeapons[serial] and IsControlJustPressed(0, 38) then -- E
                waitingForInput = false
                doSkillCheck()
            end
        end
    end
end)

local lastAmmoCount = nil
local checkCooldown = false

CreateThread(function()
    while true do
        Wait(0)
        
        if currentWeapon and currentWeapon.metadata and currentWeapon.metadata.serial then
            local serial = currentWeapon.metadata.serial
            
            if jammedWeapons[serial] then 
                lastAmmoCount = nil
                goto continue 
            end
            
            local ped = cache.ped
            local weaponHash = GetSelectedPedWeapon(ped)
            
            if IsControlPressed(0, 24) and not checkCooldown then
                local _, currentAmmo = GetAmmoInClip(ped, weaponHash)
                
                if lastAmmoCount and currentAmmo < lastAmmoCount then
                    local weaponName = currentWeapon.name
                    local dur = currentWeapon.metadata.durability
                    
                    if dur and shouldWeaponJam(weaponName, dur) then
                        jammedWeapons[serial] = true
                        
                        SetPlayerCanDoDriveBy(cache.playerId, false)
                        
                        JF.Notification(JF.Labels["has_jammed"])

                        if not isDoingSkillcheck then
                            showFixNotification()
                        end
                        
                        checkCooldown = true
                        SetTimeout(JF.Jamming["Cooldown"] * 1000, function()
                            checkCooldown = false
                        end)
                    end
                end
                
                lastAmmoCount = currentAmmo
            else
                local _, currentAmmo = GetAmmoInClip(ped, weaponHash)
                lastAmmoCount = currentAmmo
            end
        else
            lastAmmoCount = nil
        end
        
        ::continue::
    end
end)