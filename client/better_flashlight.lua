local Animations = {
	[11] = {
		anim = "base",
		dict = "police@torch@anim@betterflashlight",
		animName = "PoliceTorchAnim",
		coords = { 0.1, 0.09, -0.01, 100.0, 100.0, 10.0 },
		hand = "SKEL_R_Hand",
		hasLoaded = false
	},
	[12] = {
		anim = "idle_a",
		dict = "amb@world_human_security_shine_torch@male@idle_a",
		animName = "SecGuard1Anim",
		coords = { 0.1, -0.02, 0.04, -35.0, 90.0, 300.0 },
		hand = "SKEL_L_Hand",
		hasLoaded = false
	},
	[13] = {
		anim = "idle_b",
		dict = "amb@world_human_security_shine_torch@male@idle_a",
		animName = "SecGuard2Anim",
		coords = { 0.1, 0.0, 0.04, -40.0, 90.0, 300.0 },
		hand = "SKEL_L_Hand",
		hasLoaded = false
	},
	[14] = {
		anim = "idle_c",
		dict = "amb@world_human_security_shine_torch@male@idle_a",
		animName = "SecGuard3Anim",
		coords = { 0.1, 0.0, 0.04, -35.0, 90.0, 300.0 },
		hand = "SKEL_L_Hand",
		hasLoaded = false
	},
	[15] = {
		anim = "idle_d",
		dict = "amb@world_human_security_shine_torch@male@idle_b",
		animName = "SecGuard4Anim",
		coords = { 0.1, -0.02, 0.04, -35.0, 90.0, 300.0 },
		hand = "SKEL_L_Hand",
		hasLoaded = false
	},
	[16] = {
		anim = "idle_e",
		dict = "amb@world_human_security_shine_torch@male@idle_b",
		animName = "SecGuard5Anim",
		coords = { 0.1, -0.02, 0.04, -35.0, 90.0, 300.0 },
		hand = "SKEL_L_Hand",
		hasLoaded = false
	},
	[17] = {
		anim = "default",
		dict = "default",
		animName = "Default",
		toogle = Config.Anims.Default,
		coords = { 0.05, -0.05, 0.0, -80.0, 90.0, 10.0 },
		hand = "PH_R_Hand",
		hasLoaded = false
	}
}

local playerPed = PlayerPedId()
local playerServerId = GetPlayerServerId(NetworkGetEntityOwner(playerPed))
local isFlashlightActive = false
local isFlashlightOn = false
local isAnimPlaying = false

local currentAnimIndex = 11
local defaultAnimIndex = 17

for i = currentAnimIndex, defaultAnimIndex do
	for key, animName in pairs(Config.Anims) do
		if Animations[i] and animName == Animations[i].animName then
			Animations[key] = Animations[i]
			Animations[i] = nil
			break
		end
	end
end

for key, animData in pairs(Animations) do
	if key > 10 then
		Animations[key] = nil
	end
end

local totalAnims = #Animations
currentAnimIndex = 1
local currentAnimData = Animations[currentAnimIndex]
local currentAnimDict = currentAnimData.dict
local currentAnimation = currentAnimData.anim
local currentAnimName = currentAnimData.animName
local currentAnimHasLoaded = currentAnimData.hasLoaded

local activeFlashlightWeapon = 0
local flashlightHash = GetHashKey("weapon_flashlight")
local pocketlightHash = GetHashKey("WEAPON_POCKETLIGHT")

function StoreFlashlight()
	isFlashlightActive = false
	SetFlashLightKeepOnWhileMoving(false)
	SetFlashLightEnabled(playerPed, false)
	ClearPedSecondaryTask(playerPed)
	currentAnimIndex = 1
	
	lib.hideTextUI()
	
	if Config.CustomHelpEvent then
		TriggerEvent("jf:CustomHelpMenu", currentAnimName, "~INPUT_D1EC696A~", "~INPUT_C9F6FF3B~", isFlashlightActive)
	end
	isAnimPlaying = false
end

function EquipFlashlight()
	isAnimPlaying = true
	isFlashlightActive = true
	currentAnimData = Animations[currentAnimIndex]
	currentAnimation = currentAnimData.anim
	currentAnimDict = currentAnimData.dict
	currentAnimName = currentAnimData.animName
	currentAnimHasLoaded = currentAnimData.hasLoaded

	if Config.CustomHelpEvent then
		TriggerEvent("jf:CustomHelpMenu", currentAnimName, "~INPUT_D1EC696A~", "~INPUT_C9F6FF3B~", isFlashlightActive)
	end

	Citizen.CreateThread(function()
		if currentAnimName ~= "Default" then
			RequestAnimDict(currentAnimDict)
			while not HasAnimDictLoaded(currentAnimDict) do
				Citizen.Wait(1)
			end

			if not currentAnimHasLoaded then
				Animations[currentAnimIndex].hasLoaded = true
			end
			currentAnimHasLoaded = currentAnimData.hasLoaded

			Citizen.Wait(500)
			TaskPlayAnim(playerPed, currentAnimDict, currentAnimation, 1.0, -1.0, -1, 49, 1, false, false, false)
		end
		playerServerId = GetPlayerServerId(NetworkGetEntityOwner(playerPed))
		TriggerServerEvent("jf:Sync", currentAnimName, playerServerId)
	end)
end

function RotateFlashlight(animName, sourceServerId)
	local targetPlayer = GetPlayerFromServerId(sourceServerId)
	local targetPed = GetPlayerPed(targetPlayer)
	local pedWeapon = GetSelectedPedWeapon(targetPed)
	local weaponEntity = GetCurrentPedWeaponEntityIndex(targetPed)
	local weaponModel = GetEntityModel(weaponEntity)

	local bones = {
		SKEL_R_Hand = GetPedBoneIndex(targetPed, 57005),
		SKEL_L_Hand = GetPedBoneIndex(targetPed, 18905),
		PH_R_Hand = GetPedBoneIndex(targetPed, 28422)
	}

	if pedWeapon == flashlightHash or pedWeapon == pocketlightHash then
		DetachEntity(weaponEntity)
		Citizen.Wait(10)

		local syncBone
		local syncCoords
		for i, animData in pairs(Animations) do
			if animData.animName == animName then
				syncBone = animData.hand
				syncCoords = animData.coords
			end
		end

		AttachEntityToEntity(weaponEntity, targetPed, bones[syncBone], syncCoords[1], syncCoords[2], syncCoords[3], syncCoords[4], syncCoords[5], syncCoords[6], true, false, false, true, 1, true)
	end
end

function ShowHelp()
	if Config.HelpBox and not Config.CustomHelpEvent then
		Citizen.CreateThread(function()
			while isFlashlightActive do
				local animName = _('PoliceTorchAnim')
				if currentAnimData and currentAnimData.animName then
					animName = _(currentAnimData.animName)
				end
				
				local textLines = {
					string.format("**%s:** %s", _("HelpString1"):gsub("Animation Name: ~h~%%s~h~~s~", "Animation"), animName)
				}
				
				local toggleKey = Config.DefaultToogle or "E"
				local changeKey = Config.DefaultChangeAnim or "O"
				
				table.insert(textLines, string.format("[%s] - Slå på/av", toggleKey))
				table.insert(textLines, string.format("[%s] - Byt animation", changeKey))
				
				lib.showTextUI(table.concat(textLines, "  \n"), {
					position = "right-center",
					icon = "fa-solid fa-flashlight",
					iconColor = "#FFA500"
				})
				
				Citizen.Wait(1000)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		playerPed = PlayerPedId()
		if playerPed then
			if IsPedInAnyVehicle(playerPed, true) then
				if isFlashlightActive then
					StoreFlashlight()
				end
				Citizen.Wait(500)
			else
				local currentSelectedWeapon = GetSelectedPedWeapon(playerPed)
				if currentSelectedWeapon == flashlightHash or currentSelectedWeapon == pocketlightHash then
					if not isFlashlightActive then
						activeFlashlightWeapon = currentSelectedWeapon
						EquipFlashlight()
						ShowHelp()
					end
				else
					if isFlashlightActive and activeFlashlightWeapon ~= currentSelectedWeapon then
						StoreFlashlight()
					end
				end
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

if Config.FixAnimWhenStop then
	Citizen.CreateThread(function()
		Citizen.Wait(2000)
		while true do
			Citizen.Wait(1000)
			if isFlashlightActive and isAnimPlaying and currentAnimName ~= "Default" and currentAnimHasLoaded then
				if not IsEntityPlayingAnim(playerPed, currentAnimDict, currentAnimation, 3) then
					TaskPlayAnim(playerPed, currentAnimDict, currentAnimation, 1.0, -1.0, -1, 49, 1, false, false, false)
				end
			end
			Citizen.Wait(1000)
		end
	end)
end

if Config.FixPresistentFlashlight then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2500)
			if isFlashlightActive then
				SetFlashLightKeepOnWhileMoving(true)
			end
		end
	end)
end

RegisterCommand("changeflashanim", function()
	if isFlashlightActive then
		ClearPedSecondaryTask(playerPed)
		if currentAnimIndex == totalAnims then
			currentAnimIndex = 1
		else
			currentAnimIndex = currentAnimIndex + 1
		end
		currentAnimData = Animations[currentAnimIndex]
		
		lib.hideTextUI()
		EquipFlashlight()
		ShowHelp()
	end
end, false)

RegisterCommand("toogleflash", function()
	if isFlashlightActive then
		isFlashlightOn = not isFlashlightOn
		SetFlashLightKeepOnWhileMoving(isFlashlightOn)
		SetFlashLightEnabled(playerPed, isFlashlightOn)
	end
end, false)

if Config.KeyMapping then
	RegisterKeyMapping("toogleflash", _("KeyMappingToogleFlash"), "keyboard", Config.DefaultToogle)
	RegisterKeyMapping("changeflashanim", _("KeyMappingChangeFlashAnim"), "keyboard", Config.DefaultChangeAnim)
end

RegisterNetEvent("jf:SyncClient")
AddEventHandler("jf:SyncClient", function(animName, sourceServerId)
	RotateFlashlight(animName, sourceServerId)
end)