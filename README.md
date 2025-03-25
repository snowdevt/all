# Snow  - Projects

## MVEF.

The roblox library that will make creating particles/effects easily. Example listed below.:

``-- LocalScript: Advanced Water Effects Example
local mvef = require(game.ReplicatedStorage:WaitForChild("mvef")) -- Use loadstring if external

-- Create a water splash effect
mvef:CreateEffect("Water Splash")

-- Edit the effect for advanced water behavior
mvef:EditEffect("Water Splash", "loop", "fast", "WaterSplash") -- Infinite fast-moving water particles

-- Display the effect (attached to the player's character)
mvef:DisplayEffect("Water Splash")

-- Simulate a water burst after 3 seconds, then stop
task.delay(3, function()
    mvef:StopEffect("Water Splash")
    
    -- Create a secondary effect for a water burst
    mvef:CreateEffect("Water Burst")
    mvef:EditEffect("Water Burst", 50, "slow", "WaterSplash") -- 50 slow particles
    mvef:DisplayEffect("Water Burst")
    
    -- Stop the burst after 2 seconds
    task.delay(2, function()
        mvef:StopEffect("Water Burst")
    end)
end)
``
