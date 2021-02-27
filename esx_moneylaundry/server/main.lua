ESX = nil

local hasLaundryStarted = false

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

------------------------------ esx_moneylaundry ----------------------------------------

-- Laundry's logic
RegisterNetEvent("pnp:startLaundry")
Citizen.CreateThread(function()
    AddEventHandler("pnp:startLaundry", function()
        xPlayer = ESX.GetPlayerFromId(source)
        local blackMoney = xPlayer.getAccount("black_money").money
        local doesPlayerHaveEnoughMoney = blackMoney >= Config.AmountPerLaundry

        if not hasLaundryStarted and doesPlayerHaveEnoughMoney then
            TriggerClientEvent("pnp:notifyPlayer", source, _U("started_washing" ,Config.AmountPerLaundry))
            startLaundry(source)
        elseif not doesPlayerHaveEnoughMoney then
            TriggerClientEvent("pnp:notifyPlayer", source, _U("not_enough"))
        elseif hasLaundryStarted then
            TriggerClientEvent("pnp:notifyPlayer", source, _U("occupied"))
        end
    end)
end)

-- When a player picks up the cleaned money it adds it to his account
RegisterNetEvent("pnp:onMoneyPickup")
AddEventHandler("pnp:onMoneyPickup", function(pedId)
    xPlayer = ESX.GetPlayerFromId(pedId)
    local cleanMoney = calculateMoneyAfterTax(Config.MinPayout, Config.MaxPayout)
    TriggerClientEvent("pnp:notifyPlayer", pedId, _U("picked_up", cleanMoney))
    xPlayer.addMoney(cleanMoney)
end)

-- Calculates the amount of clean money to give to a player
function calculateMoneyAfterTax(minMoneyAfterTax, maxMoneyAfterTax)
    math.randomseed(os.time())
    local moneyAfterTax = math.random(minMoneyAfterTax, maxMoneyAfterTax)
    return moneyAfterTax
end

-- Starts the laundry proccess
function startLaundry(source)
    xPlayer.removeAccountMoney("black_money", Config.AmountPerLaundry)

    hasLaundryStarted = true
    for i = 1, Config.TimeToLaunder do
        TriggerClientEvent("pnp:updatePrompt", source, i)
        Wait(1000)
    end
    TriggerClientEvent("pnp:updatePrompt", source, _U("laundry_prompt"))

    TriggerClientEvent("pnp:onLaundryFinished", source)
    TriggerClientEvent("pnp:notifyPlayer", source, _U("finished"))

    hasLaundryStarted = false
end