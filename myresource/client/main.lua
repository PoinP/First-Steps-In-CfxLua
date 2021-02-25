local spawnPos = vector3(-1006.402, 6272.383, 1.503)

AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = spawnPos.x,
            y = spawnPos.y,
            z = spawnPos.z,
            model = 'a_m_m_skater_01'
        }, function()
            TriggerEvent('chat:addMessage', {
                args = { 'Welcome to the party!~' }
            })
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

RegisterCommand('spawncar', function(source, args)
    local vehicleName = args[1] or "null"

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent("chat:addMessage", {
            args = {"Sorry, no such car exists!"}
        })

        return
    end

    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Citizen.Wait(500)
    end

    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)

    local vehicle = CreateVehicle(vehicleName, playerPos.x, playerPos.y, playerPos.z, GetEntityHeading(player), true, false)

    SetPedIntoVehicle(player, vehicle, 0)

    SetEntityAsNoLongerNeeded(vehicle)

    SetModelAsNoLongerNeeded(vehicleName)

    TriggerEvent("chat:addMessage", "You have successfully spawned a car!")

end, false)

RegisterCommand("tp", function(source, args)
    TriggerEvent("chat:addMessage", {
        args = {"You will now go to coordinates " .. args[1] .. " " .. args[2] .. " " .. args[3]}
    })

    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    local player = PlayerPedId();

    SetEntityCoords(player, x, y, z, false, false, false, true)

    local currentPos = GetEntityCoords(player)
    print(currentPos)
end, false)

RegisterCommand("giveweapon", function(source, args)
    local weapon = args[1]
    local ammo = tonumber(args[2])
    local ped = PlayerPedId()

    if not IsWeaponValid(weapon) then
        TriggerEvent("chat:addMessage", "No such weapon exists!")
        return
    end

    TriggerEvent("chat:addMessage", "Spawining item...")
    GiveWeaponToPed(ped, weapon, ammo, false, true)
end,false)

RegisterCommand("suicide", function(source)
    SetEntityHealth(PlayerPedId(), 0)
end, false)

AddEventHandler("baseevents:onPlayerDied", function()
    print("You just died")
end)

RegisterCommand("help", function()
    TriggerEvent("chat:addMessage", {
        color = {255, 0, 0},
        args = {"CONSOLE~w~", "This is a client only message"}
    })
end, false)

RegisterCommand("helpServer", function()
    TriggerServerEvent("pnp:helpServer")
end, false)

RegisterNetEvent("pnp:sendHelp")
AddEventHandler("pnp:sendHelp", function()
    TriggerEvent("chat:addMessage", {
        color = {255, 0, 0},
        multiline = true,
        args = {"CONSOLE~w~", "This is a server wide message"}
    })
end)