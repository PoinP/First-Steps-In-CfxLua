ESX              = nil
local PlayerData = {}

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

------------------------------ esx_moneylaundry ----------------------------------------

local laundryX, laundryY, laundryZ = table.unpack(Config.Location)

local playerCoords = GetEntityCoords(PlayerPedId())
local distanceToLaundry = Vdist(playerCoords, Config.Location)
local laundryPrompt = _U("laundry_prompt")

-- Used to notify the player of the laundry's status
RegisterNetEvent("pnp:notifyPlayer")
AddEventHandler("pnp:notifyPlayer", function(string)
    notifyPlayer(string)
end)

-- Used to update the laundry's prompt
RegisterNetEvent("pnp:updatePrompt")
AddEventHandler("pnp:updatePrompt", function(updatedPrompt)
    laundryPrompt = updatedPrompt
    print(laundryPrompt)
end)

-- Spawns an object(a money bag)
RegisterNetEvent("pnp:onFinishedLaundering")
Citizen.CreateThread(function()
    AddEventHandler("pnp:onFinishedLaundering", function()
        ESX.Game.SpawnObject(GetHashKey("prop_poly_bag_money"), Config.Location, function(obj)
        ApplyForceToEntity(obj, 3, 1, 1, 1, 0, 0, 0, 0, false, true, true, false, true)
		trackForPickup(obj)
		end)
    end)
end)

-- Tracks for pickup of the spawned object(a money bag)
function trackForPickup(obj)
	while true do
		nearestPlayer = GetNearestPlayerToEntity(obj)
		ped = GetPlayerPed(nearestPlayer)
		if Vdist(GetEntityCoords(ped), GetEntityCoords(obj)) < 1.2 then
			ESX.Game.DeleteObject(obj)
			TriggerServerEvent("pnp:onMoneyPickup", GetPlayerServerId(nearestPlayer))
            break
		end
		Wait(50)
	end
end

-- Tracks for a player's coords and it's distance to the laundry
Citizen.CreateThread(function()
    while true do
        playerCoords = GetEntityCoords(PlayerPedId())
        distanceToLaundry = Vdist(playerCoords, Config.Location)
        Wait(200)
    end
end)

-- Shows a prompt for the laundry
Citizen.CreateThread(function()
    laundryPrompt = _U("laundry_prompt")
    while true do
        if distanceToLaundry < 1 then
            draw3DText(laundryX, laundryY, laundryZ, laundryPrompt, 0.6)
            if(IsControlJustPressed(0, 38)) then -- button E
                TriggerServerEvent("pnp:startLaundry", PlayerPedId())
            end
        end
        Wait(5)
    end
end)

-- Draws a 3D text on specific coordinates
function draw3DText(x, y, z, string, scale)
	local onScreen, xCoord, yCoord = GetScreenCoordFromWorldCoord(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	BeginTextCommandDisplayText("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentSubstringPlayerName(string)
	EndTextCommandDisplayText(xCoord, yCoord)
end

-- Shows a notification over the map
function notifyPlayer(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(string)
    DrawNotification(true, false)
end