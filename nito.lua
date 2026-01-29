-- Da Hood Ultimate - Functional Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local Config = {
    SpeedHack = true,
    SpeedValue = 32, -- noticeable speed
    ESP = true,
    ESPColor = Color3.new(1, 0, 0),
    AutoPickup = true,
    AimKey = Enum.KeyCode.F1,
    ToggleGUIKey = Enum.KeyCode.F2,
    UpdateInterval = 0.1
}

local State = {
    SpeedHack = Config.SpeedHack,
    ESP = Config.ESP,
    AutoPickup = Config.AutoPickup,
    GUIVisible = true,
    lastUpdate = 0
}

-- =========================
-- Input Handling
-- =========================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.AimKey then
        State.SpeedHack = not State.SpeedHack
        print("SpeedHack toggled:", State.SpeedHack)
    elseif input.KeyCode == Config.ToggleGUIKey then
        State.GUIVisible = not State.GUIVisible
        print("ESP visibility toggled:", State.GUIVisible)
        -- Hide or show ESP
        for _, gui in pairs(Workspace:GetDescendants()) do
            if gui:IsA("BillboardGui") and gui.Name == "ESP" then
                gui.Enabled = State.GUIVisible
            end
        end
    end
end)

-- =========================
-- Speed Hack
-- =========================
local function applySpeedHack()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = State.SpeedHack and Config.SpeedValue or 16
        end
    end
end

-- =========================
-- ESP
-- =========================
local ESPs = {}

local function createESP(targetPlayer)
    if ESPs[targetPlayer] then return end
    local char = targetPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = char.Head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Enabled = State.GUIVisible

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Config.ESPColor
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = targetPlayer.Name
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    billboard.Parent = Workspace
    ESPs[targetPlayer] = billboard
end

local function updateESP()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= player then
            if ply.Character and ply.Character:FindFirstChild("Head") then
                createESP(ply)
            end
        end
    end
end

-- =========================
-- Auto Pickup
-- =========================
local function applyAutoPickup()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Model") and (item.Name == "Weapon" or item.Name == "Ammo") then
            local primary = item:FindFirstChild("PrimaryPart")
            if primary then
                local distance = (primary.Position - root.Position).Magnitude
                if distance < 10 then
                    print("AutoPickup:", item.Name)
                    -- Teleport item to player as a placeholder pickup
                    primary.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end
end

-- =========================
-- Main Update Loop
-- =========================
RunService.Heartbeat:Connect(function()
    if tick() - State.lastUpdate < Config.UpdateInterval then return end
    State.lastUpdate = tick()

    applySpeedHack()
    updateESP()
    if State.AutoPickup then applyAutoPickup() end
end)

print("Da Hood Ultimate Loaded! F1: SpeedHack toggle, F2: ESP toggle")
