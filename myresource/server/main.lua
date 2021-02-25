RegisterNetEvent("pnp:helpServer")
AddEventHandler("pnp:helpServer", function()
    TriggerClientEvent("pnp:sendHelp", -1)
end)