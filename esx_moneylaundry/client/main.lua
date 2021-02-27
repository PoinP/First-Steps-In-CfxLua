--ToDo Clean the money, then add the clean money to user's inventory(or drop it and force a user to get it)

ESX              = nil
local PlayerData = {}

local laundryCoords = Config.Location
local laundryString = Config.LaundryString

local pedCoords
local distance

local isNear = false
local hasSoundPlayed = false
local hasLaundryStarted = false

local didPlayerStartLaunder = false

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

RegisterCommand("coord", function(source)
	print(GetEntityCoords(PlayerPedId()))
	print(hasLaundryStarted)
end, false)

--EventHandlers

RegisterNetEvent("startLaundry")
AddEventHandler("startLaundry", function(cleanMoney)	
	for i=1, Config.TimeToLaunder do
		TriggerEvent("onTimerTicked", i)
		Wait(1000)
	end

	TriggerEvent("onLaundryFinished", cleanMoney)
	hasLaundryStarted = false
end)

AddEventHandler("onTimerTicked", function(num)
	laundryString = tonumber(num)
end)

--Functions

Citizen.CreateThread(function()
	AddEventHandler("onLaundryFinished", function(money)
		ESX.Game.SpawnObject(GetHashKey("prop_poly_bag_money"), laundryCoords, function(obj)
			ApplyForceToEntity(obj, 3, 1, 1, 1, 0, 0, 0, 0, false, true, true, false, true)
			while true do
				nearestPlayer = GetNearestPlayerToEntity(obj)
				ped = GetPlayerPed(nearestPlayer)
				if Vdist(GetEntityCoords(ped), GetEntityCoords(obj)) < 2 then
					ESX.Game.DeleteObject(obj)
					TriggerServerEvent("laundryFinished", GetPlayerServerId(nearestPlayer), money)
					print("You have finished laundiring " .. money .. " money!!!") -- Ui
					didPlayerStartLaunder = false
				end
				Wait(5)
			end
		end)
	end)
end)

Citizen.CreateThread(function()
	while true do
		pedCoords = GetEntityCoords(PlayerPedId())
		distance = Vdist(pedCoords, laundryCoords)

		--This logic could be better
		if (type(laundryString) == "number" 
		and tonumber(laundryString) >= Config.TimeToLaunder) then
			laundryString = Config.LaundryString
		end

		if distance < Config.Distance then
			draw3DText(laundryCoords.x,
				laundryCoords.y,
				laundryCoords.z,
				laundryString, 0.4)
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
			if(didPlayerStartLaunder) then
				return
			end
			
			local inventory = ESX.GetPlayerData().inventory
			local amountOfDirtyMoney = 0

			--local item = PlayerData.getInventoryItem("black_money")

			for i, v in ipairs(inventory) do
				if(v == GetHashKey("black_money")) then
					amountOfDirtyMoney = amountOfDirtyMoney + 1
				end
			end
			
			didPlayerStartLaunder = true
			TriggerServerEvent("onServerLaundry", PlayerPedId())
			hasLaundryStarted = true
		end

		if isNear and not hasSoundPlayed and not hasLaundryStarted then
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
			hasSoundPlayed = true
		end

		Wait(10)
	end
end)

-- Draws a 3D text over a vertain location (Can be used as a 3D text boilerplate)
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
end


function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end