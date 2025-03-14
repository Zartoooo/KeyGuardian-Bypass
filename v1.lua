rconsoleclear()

local function Main(LibraryTable)
    local trueData = ""

    if not rawget(LibraryTable, "Set") or not rawget(LibraryTable, "validateDefaultKey") then warn("Failed to hook set or validateDefaultKey") return end

    local oldSet;oldSet = hookfunction(LibraryTable.Set, newcclosure(function(config)
        if config.trueData then
            trueData = config.trueData
            rconsoleprint("[+] Found trueData: " .. tostring(trueData))
        end

        return oldSet(config)
    end))

    local oldvalidateDefaultKey; oldvalidateDefaultKey = hookfunction(LibraryTable.validateDefaultKey, newcclosure(function(key)
        return trueData
    end))
end

local oldLoadstring; oldLoadstring = hookfunction(loadstring, newcclosure(function(code, ...)
    if code == game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua") then
        local res = oldLoadstring(code, ...)()
        return function(...)
            rconsoleprint("[+] Found Library: " .. tostring(res))
            Main(res)
            return res
        end
    end

    return oldLoadstring(code, ...)
end))