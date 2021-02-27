ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("onServerLaundry")
AddEventHandler("onServerLaundry", function()
    xPlayer = ESX.GetPlayerFromId(source)
    local dirtyMoney = xPlayer.getAccount("black_money").money

    if dirtyMoney < Config.AmountPerLaundry then
        print("Not enough money! Sorry!") --Add ui notification
        return
    end

    math.randomseed(os.time())
    xPlayer.removeAccountMoney("black_money", Config.AmountPerLaundry)
    local cleanMoney = math.random(Config.MinPayout, Config.MaxPayout)

    TriggerClientEvent("startLaundry", source, cleanMoney)
end)

RegisterNetEvent("laundryFinished")
AddEventHandler("laundryFinished", function(_source, money)
    xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(money)
end)