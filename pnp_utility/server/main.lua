RegisterNetEvent("pnp:addLog")
AddEventHandler("pnp:addLog", function(scriptName, log)
    if Config.Logging.Enabled then
        if Config.Logging.Console then
            print("^5" .. scriptName .. ": ^7" .. log)
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