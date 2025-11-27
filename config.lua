---------------------------
----- FLASHLIGHT CONFIG ---
---------------------------

Config = {}

Config['DefaultToogle'] = 'E'
Config['DefaultChangeAnim'] = 'O'
Config['Locale'] = 'en' -- en
Config['HelpBox'] = true -- true/false
Config['ShowAuthorInHelpBox'] = false -- true/false
Config['KeyMapping'] = true -- true/false (if false use commands 'toogleflash' and 'changeflashanim')
Config['CustomHelpEvent'] = false -- true/false
Config['FixAnimWhenStop'] = true -- true/false (Fixes the anim breaking when walking through a door)
Config['FixPresistentFlashlight'] = true -- true/false (If you have any scripts with the 'Presistent Flashlight' option, set this to true)

Config['Anims'] = {
    'PoliceTorchAnim',
    'SecGuard1Anim',
    'SecGuard2Anim',
    'SecGuard3Anim',
    'SecGuard4Anim',
    'SecGuard5Anim',
    'Default',
}

---------------------------|
----- JF  GUN CLUTCH ------|
---------------------------|

JF = {}

JF.Debug = false

JF.Framework = "qb"

JF.Clutch = {
    ["EnableCooldown"] = true,
    ["CooldownTime"] = 3000,
    ["ClutchDuration"] = 1800,
    ["BlockedJobs"] = {
        police = true,
        ambulance = true,
        sheriff = true
--         lägg till mer om du vill 
--         realestate = true,
--         taxi = true,
--         mechanic = true,
--         cardealer = true 
    }
}

---------------------------|
----- JF  GUN JAMMING -----|
---------------------------|

JF.Jamming = {
    ["Enabled"] = true,
    ["Cooldown"] = 5,
    ["Animation"] = { 
        ["Dict"] = "mp_missheist_countrybank@nervous",
        ["Anim"] = "nervous_idle"
    },
    -- bara vapen som är skrivet här blir jammade 
    ["Weapons"] = {
        ["WEAPON_PISTOL"] = {
            [100] = 1,
            [80] = 3,
            [60] = 6,
            [50] = 10,
            [40] = 15,
            [30] = 20,
            [20] = 25,
            [10] = 35,
        },
        ["WEAPON_BROWNING"] = {
            [100] = 100,
            [80] = 3,
            [60] = 6,
            [50] = 10,
            [40] = 15,
            [30] = 20,
            [20] = 25,
            [10] = 35,
        },
        -- Addon Vapen - lägg till dina egna här ## FÖLJ MALLEN ##
--        ["WEAPON_GLOCK19"] = {
--            [100] = 1,      -- Durabillity = 100
--            [80] = 2,       -- Durabillity = 80
--            [60] = 5,       -- Durabillity = 60
--            [50] = 8,       -- Durabillity = 50
--            [40] = 12,      -- Durabillity = 40
--            [30] = 18,      -- Durabillity = 30
--            [20] = 25,      -- Durabillity = 20
--            [10] = 35,      -- Durabillity = 10
--        },
    },
}

JF.Notification = function(data)
    lib.notify(data)
end

JF.Labels = {
    ["has_jammed"] = {
        ["title"] = "Vapnet Jammade!",
        ["description"] = "Ditt vapen har jammat! Kolla dess skick!",
        ["type"] = "error",
        ["icon"] = "fa-solid fa-triangle-exclamation",
    },
    ["has_unjammed"] = {
        ["title"] = "Ojammat!",
        ["description"] = "Du har ojammat ditt vapen!",
        ["type"] = "success",
        ["icon"] = "fa-solid fa-person-rifle",
    },
}

JF.Notification = function(data)
    lib.notify(data)
end

JF.Labels = {
    ["has_jammed"] = {
        ["title"] = "Vapnet Jammade!",
        ["description"] = "Ditt vapen har jammat! Kolla dess skick!",
        ["type"] = "error",
        ["icon"] = "fa-solid fa-triangle-exclamation",
    },
    ["has_unjammed"] = {
        ["title"] = "Ojammat!",
        ["description"] = "Du har ojammat ditt vapen!",
        ["type"] = "success",
        ["icon"] = "fa-solid fa-person-rifle",
    },
}
