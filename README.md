# Snow  - Projects

## MVEF.

The roblox library that will make creating particles/effects easily. Example listed below.:


``local mvef = loadstring(game:HttpGet("https://raw.githubusercontent.com/snowdevt/all/refs/heads/main/mvef.lua"))()
mvef:CreateEffect("Water Splash")
mvef:EditEffect("Water Splash", "loop", "fast", "WaterSplash")
mvef:DisplayEffect("Water Splash")
task.delay(3, function()
    mvef:StopEffect("Water Splash")
    mvef:CreateEffect("Water Burst")
    mvef:EditEffect("Water Burst", 50, "slow", "WaterSplash") -- 50 slow particles
    mvef:DisplayEffect("Water Burst")
    task.delay(2, function()
        mvef:StopEffect("Water Burst")
    end)
end)``
