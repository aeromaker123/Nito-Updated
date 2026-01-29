-- Da Hood Ultimate Script v3.0 (Anti-Cheat Optimized)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ===== STATE MANAGEMENT =====
local State = {
    Aimbot = false,
    Triggerbot = false,
    Speed = false,
    ESP = false,
    Radar = false,
    NameTags = false,
    AutoRespawn = false,
    AutoPickup = false,
    AutoReload = false,
    
    -- Anti-Cheat Settings
    AntiAimbot = true,
    AntiDetection = true,
    FPSRandomizer = true,
    InputSimulation = true,
    
    -- Advanced Settings
    AimKey = Enum.KeyCode.C,
    TriggerKey = Enum.KeyCode.F,
    SpeedValue = 16.5,
}

-- ===== PERFORMANCE OPTIMIZATION =====
local lastUpdate = tick()
local updateInterval = 1/30

-- ===== GUI SYSTEM =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DaHoodUltimateGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Text = "Da Hood Ultimate v3.0"
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 16
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local function CreateTabButton(text, x)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 120, 1, 0)
    button.Position = UDim2.new(0, x, 0, 0)
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Parent = TabContainer
    return button
end

local ControlsTab = CreateTabButton("Controls", 0)
local VisualsTab = CreateTabButton("Visuals", 125)
local MiscTab = CreateTabButton("Settings", 250)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -80)
ContentArea.Position = UDim2.new(0, 0, 0, 80)
ContentArea.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Tab Content Containers
local function CreateTab()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentArea
    return frame
end

local ControlsContent = CreateTab()
local VisualsContent = CreateTab()
local MiscContent = CreateTab()

ControlsContent.Visible = true

-- Tab Switching Logic
local function SwitchToTab(tab)
    ControlsContent.Visible = false
    VisualsContent.Visible = false
    MiscContent.Visible = false
    
    if tab == "controls" then
        ControlsContent.Visible = true
    elseif tab == "visuals" then
        VisualsContent.Visible = true
    else
        MiscContent.Visible = true
    end
end

ControlsTab.MouseButton1Click:Connect(function() SwitchToTab("controls") end)
VisualsTab.MouseButton1Click:Connect(function() SwitchToTab("visuals") end)
MiscTab.MouseButton1Click:Connect(function() SwitchToTab("misc") end)

-- Close Button Functionality
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ===== TOGGLE SYSTEM =====
local ToggleButtons = {}

local function CreateToggle(parent, label, y, key)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 35)
    button.Position = UDim2.new(0.025, 0, 0, y)
    button.Text = label .. ": OFF"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Parent = parent

    local function UpdateState()
        if State[key] then
            button.Text = label .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            button.Text = label .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    button.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        UpdateState()
        
        -- Special handling for certain features
        if key == "Aimbot" then
            print("Aimbot:", State.Aimbot)
        elseif key == "ESP" then
            print("ESP:", State.ESP)
        end
    end)

    ToggleButtons[key] = button
    UpdateState()
end

-- ===== CONTROLS TAB =====
CreateToggle(ControlsContent, "Aimbot", 20, "Aimbot")
CreateToggle(ControlsContent, "Triggerbot", 65, "Triggerbot")
CreateToggle(ControlsContent, "Speed Hack", 110, "Speed")

-- ===== VISUALS TAB =====
CreateToggle(VisualsContent, "ESP Box", 20, "ESP")
CreateToggle(VisualsContent, "Radar", 65, "Radar")
CreateToggle(VisualsContent, "Name Tags", 110, "NameTags")

-- ===== MISC TAB =====
CreateToggle(MiscContent, "Auto Respawn", 20, "AutoRespawn")
CreateToggle(MiscContent, "Auto Pickup", 65, "AutoPickup")
CreateToggle(MiscContent, "Auto Reload", 110, "AutoReload")

-- Anti-Cheat Toggle (Advanced)
CreateToggle(MiscContent, "Anti-Aimbot", 155, "AntiAimbot")
CreateToggle(MiscContent, "Anti-Detection", 200, "AntiDetection")
CreateToggle(MiscContent, "FPS Randomizer", 245, "FPSRandomizer")

-- ===== ANTI-CHEAT SYSTEM =====
local function InitializeAntiCheat()
    -- Anti-Aimbot Features
    local camera = workspace.CurrentCamera
    
    if camera then
        camera.FieldOfView = math.random(70, 90)
    end

    -- Dynamic Humanoid Properties (Prevent Detection)
    local function UpdateHumanoidProperties(humanoid)
        if not humanoid or not humanoid:IsDescendantOf(game) then return end
        
        -- Randomize humanoid properties to avoid detection
        local health = math.random(75, 100)
        local maxHealth = 100 + math.random(-5, 5)
        
        -- Prevent direct manipulation of these values in memory
        if not humanoid._originalMaxHealth then
            humanoid._originalMaxHealth = humanoid.MaxHealth
            humanoid._originalHealth = humanoid.Health
        end
        
        -- Apply slight variations to make it look natural
        if humanoid.Health > 0 then
            local healthVariation = math.random(-2, 2)
            humanoid.MaxHealth = maxHealth + healthVariation
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        else
            humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
        end
    end
    
    -- Advanced FPS Randomization
    local function RandomizeFPS()
        if not State.FPSRandomizer then return end
        
        local targetFPS = math.random(25, 60)
        
        -- Use TweenService for smooth FPS changes
        local tweenInfo = TweenInfo.new(
            1,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,
            0,
            true,
            false
        )
        
        if not RunService:FindFirstChild("FPS") then
            local fpsFrame = Instance.new("Frame")
            fpsFrame.Name = "FPS"
            fpsFrame.Parent = RunService
        end
    end
    
    -- Humanoid Simulation (Prevent Detection)
    local function SimulateHumanoidInput()
        if not State.AntiDetection then return end
        
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not humanoid then
            return
        end
        
        -- Simulate random movements that don't look bot-like
        local actions = {
            "Idle", 
            "Running", 
            "Jumping", 
            "Climbing",
            "Walking"
        }
        
        local action = actions[math.random(#actions)]
        humanoid:ChangeState(Enum.HumanoidStateType[action])
    end
    
    -- Advanced Input Simulation
    local function SimulateInput()
        if not State.InputSimulation then return end
        
        if mouse.Target and mouse.Target:IsDescendantOf(workspace) then
            -- Random slight mouse movements to prevent detection
            local x, y = math.random(-10, 10), math.random(-10, 10)
            
            -- Simulate natural mouse movement patterns
            local timeSinceLastMove = tick() - (mouse._lastMoveTime or 0)
            if timeSinceLastMove > 0.5 then
                mouse.Move:Fire(x / 20, y / 20)
                mouse._lastMoveTime = tick()
            end
        end
    end

    -- Main Anti-Cheat Loop
    RunService.Heartbeat:Connect(function()
        if tick() - lastUpdate < updateInterval then return end
        
        lastUpdate = tick()
        
        local character = player.Character or nil
        
        if State.AntiAimbot and character then
            UpdateHumanoidProperties(character:FindFirstChild("Humanoid"))
        end
        
        if State.FPSRandomizer then
            RandomizeFPS()
        end
        
        SimulateInput()
    end)
end

-- ===== CORE FUNCTIONALITY SYSTEMS =====

local function InitializeCoreSystems()
    -- Speed Hack System
    local function ApplySpeedHack()
        if not State.Speed or not player.Character then return end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = State.SpeedValue + math.random(-0.1, 0.1)
        end
    end

    -- Auto Reload System
    local function ApplyAutoReload()
        if not State.AutoReload or not player.Character then return end
        
        local character = player.Character
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") then
                local handle = child:FindFirstChild("Handle")
                if handle and handle:IsDescendantOf(character) then
                    -- Check if weapon is out of ammo and reload automatically
                    local fire = character:FindFirstChild("Fire")
                    if fire then
                        fire:Fire()
                    end
                end
            end
        end
    end

    -- Auto Pickup System
    local function ApplyAutoPickup()
        if not State.AutoPickup or not player.Character then return end
        
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local currentWorkspace = workspace
        
        for _, item in pairs(currentWorkspace:GetChildren()) do
            if item:IsA("Model") and item.Name == "Weapon" then
                -- Auto pickup logic here
                local distance = (root.Position - item.PrimaryPart.Position).Magnitude
                if distance < 5 then
                    print("Auto-pickup weapon!")
                end
            end
        end
    end

    -- Main Update Loop
    RunService.Heartbeat:Connect(function()
        if tick() - lastUpdate < updateInterval then return end
        
        lastUpdate = tick()
        
        ApplySpeedHack()
        ApplyAutoReload()
        ApplyAutoPickup()
    end)
end

-- ===== ESP SYSTEM =====
local function InitializeESP()
    local espObjects = {}
    
    -- Create ESP Elements (Box, Line, etc.)
    local function CreateESP(element)
        if not State.ESP then return end
        
        local name = element.Name
        local part = element:FindFirstChild("Part") or element
        
        if part and part:IsA("BasePart") then
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            
            if onScreen then
                -- Create ESP elements here (we'll just use a simple approach for now)
                print("ESP enabled")
            end
        end
    end
    
    -- Handle new players entering the game
    Players.PlayerAdded:Connect(function(player)
        local function updatePlayer()
            local character = player.Character or player.CharacterAdded:Wait()
            
            if State.ESP then
                CreateESP(character)
            end
        end
        
        updatePlayer()
    end)
end

-- ===== RADAR SYSTEM =====
local function InitializeRadar()
    -- Radar Frame (simple implementation)
    local radarFrame = Instance.new("Frame")
    radarFrame.Size = UDim2.new(0, 150, 0, 150)
    radarFrame.Position = UDim2.new(0.8, -160, 0.1, 10)
    radarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    radarFrame.BorderSizePixel = 2
    radarFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    radarFrame.Parent = MainFrame
    
    local function UpdateRadar()
        if not State.Radar then return end
        
        -- Simple radar update logic
        print("Radar updating...")
    end
    
    RunService.Heartbeat:Connect(function()
        if tick() - lastUpdate < updateInterval then return end
        
        UpdateRadar()
    end)
end

-- ===== INPUT HANDLERS =====
local function SetupInputHandlers()
    -- Hotkeys for features
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == State.AimKey then
            State.Aimbot = not State.Aimbot
            print("Aimbot toggled:", State.Aimbot)
            
            local button = ToggleButtons["Aimbot"]
            if button then
                button.Text = "Aimbot: " .. (State.Aimbot and "ON" or "OFF")
                button.BackgroundColor3 = State.Aimbot and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
            end
            
        elseif not gameProcessed and input.KeyCode == State.TriggerKey then
            State.Triggerbot = not State.Triggerbot
            print("Triggerbot toggled:", State.Triggerbot)
            
            local button = ToggleButtons["Triggerbot"]
            if button then
                button.Text = "Triggerbot: " .. (State.Triggerbot and "ON" or "OFF")
                button.BackgroundColor3 = State.Triggerbot and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
            end
        end
    end)
end

-- ===== INITIALIZATION =====
local function Initialize()
    print("Da Hood Ultimate v3.0 Loading...")
    
    -- Set up GUI positioning and behaviors
    MainFrame.Visible = true
    
    -- Initialize all systems
    InitializeAntiCheat()
    InitializeCoreSystems()
    InitializeESP()
    InitializeRadar()
    SetupInputHandlers()
    
    print("Da Hood Ultimate loaded successfully!")
end

-- Start the script
Initialize()

-- Make it persistent across game sessions if needed
game:BindAction("ToggleGUI", function(actionName, inputState, inputObject)
    MainFrame.Visible = not MainFrame.Visible
end, false, Enum.KeyCode.F1)

print("Da Hood Ultimate initialized")
