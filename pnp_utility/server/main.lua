RegisterNetEvent("pnp:addLog")
AddEventHandler("pnp:addLog", function(source, scriptName, log, discordSettings)
    if Config.Logging.Enabled then
        if Config.Logging.Console then
            print("^5" .. scriptName .. ": ^7" .. log)
        end

        if discordSettings ~= nil and discordSettings.webHook ~= "" then
            makeDiscordLog(source, scriptName, log, discordSettings)
        end

        local date = os.date("*t", os.time())
        local fileName = scriptName .. "_" .. date.day .. "_" .. date.month .. "_" .. date.year .. ".txt"
        local logFile = io.open(Config.Logging.Directory .. fileName, "a")
        local log = "[" .. date.hour .. ":" .. date.min .. ":" .. date.sec .. "] " .. log

        io.output(logFile)
        io.write(log .. "\n")
        io.close(logFile)
    end
end)

function makeDiscordLog(source, scriptName, log, discordSettings)
    local steamid
			
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        end
    end

    local embed = {
        {
            ["color"] = discordSettings.color,
            ["title"] = "**".. scriptName .."**",
            ["description"] = log,
            ["footer"] = {
                ["text"] = "Issued by: " .. tostring(steamid),
            },
        }
    }

    PerformHttpRequest(discordSettings.webHook,
        function(err, text, headers) end,
        'POST', json.encode({username = name, embeds = embed}),
        { ['Content-Type'] = 'application/json' })
end