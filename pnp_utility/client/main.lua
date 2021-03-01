--Enable PvP
AddEventHandler("playerSpawned", function(spawn)
    if Config.EnablePvP then
        SetCanAttackFriendly(PlayerPedId(), true, false)
        NetworkSetFriendlyFireOption(true)
    end
end)

--Show a player's own ID
Citizen.CreateThread(function()
    while true do
        SetTextFont(4)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextEdge(0, 0, 0, 0, 255)
        SetTextScale(0.50, 0.50)
        SetTextColour(185, 185, 185, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString("~y~ID: ~s~" .. GetPlayerServerId(PlayerId()))
        DrawText(0.175, 0.95)

        Wait(10)
    end
end)
