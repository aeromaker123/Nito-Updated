-- Da Hood Ultimate - Fixed Version (No GUI)
local Config = {
    Aimbot = true,
    Triggerbot = false,
    SpeedHack = true,
    AutoReload = true,
    AutoPickup = true,
    ESP = true,
    Radar = true,
    AntiAimbot = true,
    AimKey = Enum.KeyCode.F1,
    ToggleGUIKey = Enum.KeyCode.F2,
    SpeedValue = 16,
    UpdateInterval = 0.05,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local scriptState = {
    Aimbot = Config.Aimbot,
    SpeedHack = Config.SpeedHack,
    AutoReload = Config.AutoReload,
    AutoPickup = Config.AutoPickup,
    ESP = Config.ESP,
    Radar = Config.Radar,
    AntiAimbot = Config.AntiAimbot,
    SpeedValue = Config.SpeedValue,
    GUIVisible = true,
    lastUpdate = 0
}

-- Input Handlers
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.AimKey then
        scriptState.Aimbot = not scriptState.Aimbot
        print("Aimbot toggled:", scriptState.Aimbot)
    elseif input.KeyCode == Config.ToggleGUIKey then
        scriptState.GUIVisible = not scriptState.GUIVisible
        print("GUI toggled:", scriptState.GUIVisible)
    end
end)

-- Speed Hack
local function applySpeedHack()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = scriptState.SpeedValue
        end
    end
end

-- AutoReload placeholder
local function applyAutoReload()
    -- Add your weapon reload logic here
end

-- AutoPickup placeholder
local function applyAutoPickup()
    -- Add your item pickup logic here
end

-- ESP placeholder
local function updateESP()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= player and ply.Character then
            -- Placeholder: print nearby players
            print("ESP Check:", ply.Name)
        end
    end
end

-- Radar placeholder
local function updateRadar()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= player and ply.Character then
            local root = ply.Character:FindFirstChild("HumanoidRootPart")
            if root then
                print("Radar:", ply.Name, root.Position)
            end
        end
    end
end

-- AntiAimbot placeholder
local function updateHumanoidProperties(humanoid)
    if not humanoid then return end
    humanoid.JumpPower = math.random(50, 80)
    humanoid.AutoRotate = true
end

-- Main Update Loop
RunService.Heartbeat:Connect(function()
    if tick() - scriptState.lastUpdate < Config.UpdateInterval then return end
    scriptState.lastUpdate = tick()
    
    if scriptState.SpeedHack then applySpeedHack() end
    if scriptState.AutoReload then applyAutoReload() end
    if scriptState.AutoPickup then applyAutoPickup() end
    if scriptState.ESP then updateESP() end
    if scriptState.Radar then updateRadar() end
    
    if scriptState.AntiAimbot then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                updateHumanoidProperties(humanoid)
            end
        end
    end
end)

print("Da Hood Ultimate Loaded! F1: Aimbot Toggle, F2: GUI Toggle")
