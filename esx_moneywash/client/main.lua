--ToDo Clean the money, then add the clean money to user's inventory(or drop it and force a user to get it)

ESX              = nil
local PlayerData = {}
local washerCoords = Config.Location

local pedCoords
local distance

local isNear = false
local isTextDrawn = false
local hasSoundPlayed = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterCommand("coord", function()
	print(GetEntityCoords(PlayerPedId()))
end, false)

Citizen.CreateThread(function()
	while true do
		pedCoords = GetEntityCoords(PlayerPedId())
		distance = Vdist(pedCoords, washerCoords)

		if distance < Config.Distance then
			draw3DText(washerCoords.x,
			 	washerCoords.y,
			  	washerCoords.z,
				"Press ~y~[E] ~s~to ~y~wash money", 0.4)
			isTextDrawn = true
			isNear = true
		else
			isNear = false
			hasSoundPlayed = false
		end

		Wait(5)
	end
end)

Citizen.CreateThread(function()
	while true do
		if isNear and IsControlJustPressed(0, 38) then
			TriggerEvent("chat:addMessage", "test")
		end

		if isNear and not hasSoundPlayed then
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
			hasSoundPlayed = true
		end

		Wait(10)
	end
end)

function draw3DText(x, y, z, text, scale)
	local onScreen, xCoord, yCoord = GetScreenCoordFromWorldCoord(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	BeginTextCommandDisplayText("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(xCoord, yCoord)
	local factor = (string.len(text)) / 700
end