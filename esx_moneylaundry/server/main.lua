ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

------------------------------ esx_moneylaundry ----------------------------------------

local hasLaundryStarted = false
local moneyToLaunder = 0

-- Laundry's logic
RegisterNetEvent("pnp:startLaundry")
Citizen.CreateThread(function()
    AddEventHandler("pnp:startLaundry", function()
        xPlayer = ESX.GetPlayerFromId(source)
        local blackMoney = xPlayer.getAccount("black_money").money

        moneyToLaunder = blackMoney > Config.MaxMoneyPerLaundry and Config.MaxMoneyPerLaundry or blackMoney

        if not hasLaundryStarted and moneyToLaunder > 0 then
            TriggerClientEvent("pnp:notifyPlayer", source, _U("started_washing", moneyToLaunder))
            startLaundry(source)
        elseif moneyToLaunder <= 0 then
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
    local cleanMoney = calculateMoneyAfterTax(moneyToLaunder, Config.Tax)
    TriggerClientEvent("pnp:notifyPlayer", pedId, _U("picked_up", cleanMoney))
    xPlayer.addMoney(cleanMoney)
end)

-- Calculates the amount of clean money to give to a player
function calculateMoneyAfterTax(dirtyMoney, tax)
    tax = tax / 100
    math.randomseed(os.time())
    local moneyAfterTax = dirtyMoney - (dirtyMoney * 0.30)
    local minPayout = math.floor(moneyAfterTax - moneyAfterTax * 0.10)
    local maxPayout = math.floor(moneyAfterTax + moneyAfterTax * 0.10)
    return math.random(minPayout, maxPayout)
end

-- Starts the laundry proccess
function startLaundry(source)
    xPlayer.removeAccountMoney("black_money", moneyToLaunder)

    hasLaundryStarted = true
    for i = 1, Config.TimeToLaunder do
        TriggerClientEvent("pnp:updatePrompt", source, i)
        Wait(1000)
    end
    TriggerClientEvent("pnp:updatePrompt", source, _U("laundry_prompt"))

    TriggerClientEvent("pnp:onFinishedLaundering", source)
    TriggerClientEvent("pnp:notifyPlayer", source, _U("finished"))

    hasLaundryStarted = false
end