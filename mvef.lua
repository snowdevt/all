-- ModuleScript: mvef
local mvef = {}

-- Storage for effects (client-side only)
local effects = {}

-- Predefined particle IDs (real asset IDs will be used in the example)
local particlePresets = {
    Snowflake = "rbxassetid://243664v670",
    Explosion = "rbxassetid://987654321",
    Orb = "rbxassetid://456789123",
    WaterSplash = "rbxassetid://7028856938" -- Example water splash asset ID
}

-- Function to create a new effect
function mvef:CreateEffect(effectName)
    if effects[effectName] then
        warn("Effect '" .. effectName .. "' already exists!")
        return
    end
    
    effects[effectName] = {
        ParticleEmitter = nil,
        Loop = 10,
        Speed = "null",
        ParticleType = nil
    }
    
    print("Created effect: " .. effectName)
    return effects[effectName]
end

-- Function to edit an existing effect
function mvef:EditEffect(effectName, loop, speed, particleType)
    local effect = effects[effectName]
    if not effect then
        warn("Effect '" .. effectName .. "' does not exist!")
        return
    end
    
    if loop then
        if loop == "loop" then
            effect.Loop = math.huge
        elseif tonumber(loop) then
            effect.Loop = tonumber(loop)
        end
    end
    
    if speed then
        effect.Speed = speed
    end
    
    if particleType then
        if particlePresets[particleType] then
            effect.ParticleType = particlePresets[particleType]
        else
            effect.ParticleType = particleType
        end
    end
    
    print("Edited effect: " .. effectName)
end

-- Function to display the effect client-side
function mvef:DisplayEffect(effectName)
    local effect = effects[effectName]
    if not effect then
        warn("Effect '" .. effectName .. "' does not exist!")
        return
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    if not effect.ParticleEmitter then
        local emitter = Instance.new("ParticleEmitter")
        emitter.Parent = rootPart
        effect.ParticleEmitter = emitter
    end
    
    local emitter = effect.ParticleEmitter
    emitter.Enabled = true
    
    if effect.ParticleType then
        emitter.Texture = effect.ParticleType
    end
    
    if effect.Speed == "slow" then
        emitter.Speed = NumberRange.new(1, 2)
    elseif effect.Speed == "fast" then
        emitter.Speed = NumberRange.new(5, 10)
    else
        emitter.Speed = NumberRange.new(0, 0)
    end
    
    if effect.Loop == math.huge then
        emitter.Rate = 10
    else
        emitter.Rate = effect.Loop
        emitter:Emit(effect.Loop)
        task.delay(5, function()
            emitter.Enabled = false
        end)
    end
end

-- Function to stop an effect
function mvef:StopEffect(effectName)
    local effect = effects[effectName]
    if not effect then
        warn("Effect '" .. effectName .. "' does not exist!")
        return
    end
    
    if effect.ParticleEmitter then
        effect.ParticleEmitter.Enabled = false
        effect.ParticleEmitter:Destroy()
        effect.ParticleEmitter = nil
    end
    
    print("Stopped effect: " .. effectName)
end

return mvef
