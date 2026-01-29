-- Nito - Da Hood Ultimate Script
-- Author: You
-- Date: 2026

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- Configuration
-- =========================
local Config = {
    SpeedHackValue = 32,
    ESPColor = Color3.fromRGB(255, 0, 0),
    UpdateInterval = 0.05,
    PickupRange = 10
}

-- =========================
-- State
-- =========================
local State = {
    Aimbot = false,
    SpeedHack = true,
    AutoPickup = true,
    ESP = true,
    Radar = true,
    AutoReload = true,
    GUIVisible = true,
    lastUpdate = 0
}

-- =========================
-- GUI
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NitoGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.05,0,0.2,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Nito"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = MainFrame

local function createToggle(name, stateKey, posY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 220, 0, 35)
    button.Position = UDim2.new(0, 15, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
    button.Parent = MainFrame

    button.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        button.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
    end)
end

createToggle("Aimbot", "Aimbot", 50)
createToggle("SpeedHack", "SpeedHack", 90)
createToggle("AutoPickup", "AutoPickup", 130)
createToggle("ESP", "ESP", 170)
createToggle("Radar", "Radar", 210)
createToggle("AutoReload", "AutoReload", 250)

-- =========================
-- Input Hotkeys
-- =========================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        State.Aimbot = not State.Aimbot
        print("Aimbot toggled:", State.Aimbot)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        State.GUIVisible = not State.GUIVisible
        ScreenGui.Enabled = State.GUIVisible
        print("GUI visibility toggled:", State.GUIVisible)
    end
end)

-- =========================
-- SpeedHack
-- =========================
local function applySpeedHack()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = State.SpeedHack and Config.SpeedHackValue or 16
        end
    end
end

-- =========================
-- ESP
-- =========================
local ESPs = {}
local function createESP(target)
    if ESPs[target] then return end
    local head = target.Character and target.Character:FindFirstChild("Head")
    if not head then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP"
    gui.Adornee = head
    gui.Size = UDim2.new(0,100,0,50)
    gui.AlwaysOnTop = true
    gui.Enabled = State.ESP

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Config.ESPColor
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = target.Name
    label.Parent = gui

    gui.Parent = Workspace
    ESPs[target] = gui
end

local function updateESP()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= player then
            createESP(ply)
        end
    end
end

-- =========================
-- AutoPickup
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
                if distance < Config.PickupRange then
                    primary.CFrame = root.CFrame + Vector3.new(0,3,0)
                end
            end
        end
    end
end

-- =========================
-- Radar (Console)
-- =========================
local function updateRadar()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= player and ply.Character then
            local root = ply.Character:FindFirstChild("HumanoidRootPart")
            if root then
                print("Radar:", ply.Name, "at", root.Position)
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
    if State.ESP then updateESP() end
    if State.AutoPickup then applyAutoPickup() end
    if State.Radar then updateRadar() end
end)

print("Nito Loaded! F1 = Aimbot toggle, F2 = GUI toggle")
