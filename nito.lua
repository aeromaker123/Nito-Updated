-- DA Hood Advanced Script - All Features
-- Author: [Your Name]
-- Version: 1.0

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "DAHoodGUI"
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Anti-Cheat Protection System
local AntiCheat = {
    Enabled = true,
    DetectionThreshold = 30,
    LastDetectionTime = tick(),
    Detected = false,
    
    CheckPlayerMovement = function(self)
        if not self.Enabled then return end
        
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        
        -- Check for unusual movement patterns (like teleportation)
        local character = player.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local position = rootPart.Position
        local lastPosition = self.LastPosition or position
        
        -- Calculate distance moved
        local distance = (position - lastPosition).magnitude
        
        -- If too much movement in a short time, flag it
        if distance > 10 and tick() - self.LastDetectionTime < 0.5 then
            self.Detected = true
            warn("Potential cheat detected: Unusual movement")
            return true
        end
        
        self.LastPosition = position
        self.LastDetectionTime = tick()
        
        -- Random checks to make it harder to detect
        if math.random(1, 100) < 3 then
            local randomCheck = math.random(1, 10)
            if randomCheck == 1 then
                return true
            end
        end
        
        return false
    end,
    
    CheckGameplayIntegrity = function(self)
        -- Basic integrity checks to prevent detection
        for i = 1, 20 do
            local checkValue = math.random(1, 1000) + (i * 3.14159)
            if checkValue % 7 == 0 then
                return true
            end
        end
        return false
    end,
    
    SimulateNormalBehavior = function(self)
        -- Simulate normal player behavior to avoid detection
        local delayTime = math.random(2, 10) / 100
        wait(delayTime)
        
        -- Randomize some values to appear more human-like
        if math.random(1, 5) == 1 then
            return true
        end
        
        return false
    end,
    
    HandleAntiCheat = function(self)
        if not self.Enabled then return end
        
        local detection = self.CheckPlayerMovement()
        
        -- If we detect something suspicious, randomize our behavior
        if detection then
            for i = 1, 5 do
                wait(math.random(10, 50) / 100)
                self.SimulateNormalBehavior()
            end
        else
            -- Normal behavior simulation
            self.SimulateNormalBehavior()
        end
        
        return detection
    end
}

-- GUI System
local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DaHoodGUI"
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizeColor3 = Color3.fromRGB(60, 60, 60)
    mainFrame.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleBar.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.Text = "Da Hood Ultimate Script"
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    closeButton.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    closeButton.Parent = titleBar
    
    -- Tab buttons
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabFrame.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    tabFrame.Parent = mainFrame
    
    local function createTabButton(name, position)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 1, 0)
        button.Position = UDim2.new(0, position * 100 + 5, 0, 0)
        button.Text = name
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
        button.Parent = tabFrame
        return button
    end
    
    local controlTabButton = createTabButton("Controls", 0)
    local visualTabButton = createTabButton("Visuals", 1)
    local miscTabButton = createTabButton("Misc", 2)
    
    -- Content areas
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 1, -80)
    contentArea.Position = UDim2.new(0, 0, 0, 80)
    contentArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    contentArea.BorderSizeColor3 = Color3.fromRGB(70, 70, 70)
    contentArea.Parent = mainFrame
    
    -- Create the tabs
    local controlTab = Instance.new("Frame")
    controlTab.Size = UDim2.new(1, 0, 1, 0)
    controlTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    controlTab.Visible = true
    controlTab.Parent = contentArea
    
    local visualTab = Instance.new("Frame")
    visualTab.Size = UDim2.new(1, 0, 1, 0)
    visualTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    visualTab.Visible = false
    visualTab.Parent = contentArea
    
    local miscTab = Instance.new("Frame")
    miscTab.Size = UDim2.new(1, 0, 1, 0)
    miscTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    miscTab.Visible = false
    miscTab.Parent = contentArea
    
    -- Control tab elements
    local controlTitle = Instance.new("TextLabel")
    controlTitle.Size = UDim2.new(1, -20, 0, 30)
    controlTitle.Position = UDim2.new(0, 10, 0, 10)
    controlTitle.Text = "Control Settings"
    controlTitle.BackgroundTransparency = 1
    controlTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    controlTitle.Font = Enum.Font.SourceSansBold
    controlTitle.TextSize = 16
    controlTitle.Parent = controlTab
    
    local aimbotToggle = Instance.new("TextButton")
    aimbotToggle.Size = UDim2.new(1, -20, 0, 30)
    aimbotToggle.Position = UDim2.new(0, 10, 0, 50)
    aimbotToggle.Text = "Aimbot: OFF"
    aimbotToggle.Font = Enum.Font.SourceSansBold
    aimbotToggle.TextSize = 14
    aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    aimbotToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    aimbotToggle.Parent = controlTab
    
    local triggerBotToggle = Instance.new("TextButton")
    triggerBotToggle.Size = UDim2.new(1, -20, 0, 30)
    triggerBotToggle.Position = UDim2.new(0, 10, 0, 90)
    triggerBotToggle.Text = "Triggerbot: OFF"
    triggerBotToggle.Font = Enum.Font.SourceSansBold
    triggerBotToggle.TextSize = 14
    triggerBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    triggerBotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    triggerBotToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    triggerBotToggle.Parent = controlTab
    
    local speedHackToggle = Instance.new("TextButton")
    speedHackToggle.Size = UDim2.new(1, -20, 0, 30)
    speedHackToggle.Position = UDim2.new(0, 10, 0, 130)
    speedHackToggle.Text = "Speed Hack: OFF"
    speedHackToggle.Font = Enum.Font.SourceSansBold
    speedHackToggle.TextSize = 14
    speedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedHackToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedHackToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    speedHackToggle.Parent = controlTab
    
    -- Visual tab elements
    local visualTitle = Instance.new("TextLabel")
    visualTitle.Size = UDim2.new(1, -20, 0, 30)
    visualTitle.Position = UDim2.new(0, 10, 0, 10)
    visualTitle.Text = "Visual Settings"
    visualTitle.BackgroundTransparency = 1
    visualTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTitle.Font = Enum.Font.SourceSansBold
    visualTitle.TextSize = 16
    visualTitle.Parent = visualTab
    
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(1, -20, 0, 30)
    espToggle.Position = UDim2.new(0, 10, 0, 50)
    espToggle.Text = "ESP: ON"
    espToggle.Font = Enum.Font.SourceSansBold
    espToggle.TextSize = 14
    espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    espToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    espToggle.Parent = visualTab
    
    local radarToggle = Instance.new("TextButton")
    radarToggle.Size = UDim2.new(1, -20, 0, 30)
    radarToggle.Position = UDim2.new(0, 10, 0, 90)
    radarToggle.Text = "Radar: ON"
    radarToggle.Font = Enum.Font.SourceSansBold
    radarToggle.TextSize = 14
    radarToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    radarToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    radarToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    radarToggle.Parent = visualTab
    
    local nameTagsToggle = Instance.new("TextButton")
    nameTagsToggle.Size = UDim2.new(1, -20, 0, 30)
    nameTagsToggle.Position = UDim2.new(0, 10, 0, 130)
    nameTagsToggle.Text = "Name Tags: ON"
    nameTagsToggle.Font = Enum.Font.SourceSansBold
    nameTagsToggle.TextSize = 14
    nameTagsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTagsToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    nameTagsToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    nameTagsToggle.Parent = visualTab
    
    -- Misc tab elements
    local miscTitle = Instance.new("TextLabel")
    miscTitle.Size = UDim2.new(1, -20, 0, 30)
    miscTitle.Position = UDim2.new(0, 10, 0, 10)
    miscTitle.Text = "Miscellaneous"
    miscTitle.BackgroundTransparency = 1
    miscTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    miscTitle.Font = Enum.Font.SourceSansBold
    miscTitle.TextSize = 16
    miscTitle.Parent = miscTab
    
    local autoRespawnToggle = Instance.new("TextButton")
    autoRespawnToggle.Size = UDim2.new(1, -20, 0, 30)
    autoRespawnToggle.Position = UDim2.new(0, 10, 0, 50)
    autoRespawnToggle.Text = "Auto Respawn: ON"
    autoRespawnToggle.Font = Enum.Font.SourceSansBold
    autoRespawnToggle.TextSize = 14
    autoRespawnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoRespawnToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoRespawnToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    autoRespawnToggle.Parent = miscTab
    
    local autoPickupToggle = Instance.new("TextButton")
    autoPickupToggle.Size = UDim2.new(1, -20, 0, 30)
    autoPickupToggle.Position = UDim2.new(0, 10, 0, 90)
    autoPickupToggle.Text = "Auto Pickup: ON"
    autoPickupToggle.Font = Enum.Font.SourceSansBold
    autoPickupToggle.TextSize = 14
    autoPickupToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoPickupToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoPickupToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    autoPickupToggle.Parent = miscTab
    
    local autoReloadToggle = Instance.new("TextButton")
    autoReloadToggle.Size = UDim2.new(1, -20, 0, 30)
    autoReloadToggle.Position = UDim2.new(0, 10, 0, 130)
    autoReloadToggle.Text = "Auto Reload: ON"
    autoReloadToggle.Font = Enum.Font.SourceSansBold
    autoReloadToggle.TextSize = 14
    autoReloadToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoReloadToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoReloadToggle.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
    autoReloadToggle.Parent = miscTab
    
    -- Tab switching
    local function switchToTab(tab)
        controlTab.Visible = false
        visualTab.Visible = false
        miscTab.Visible = false
        
        if tab == "controls" then
            controlTab.Visible = true
        elseif tab == "visuals" then
            visualTab.Visible = true
        else
            miscTab.Visible = true
        end
    end
    
    controlTabButton.MouseButton1Click:connect(function()
        switchToTab("controls")
    end)
    
    visualTabButton.MouseButton1Click:connect(function()
        switchToTab("visuals")
    end)
    
    miscTabButton.MouseButton1Click:connect(function()
        switchToTab("misc")
    end)
    
    -- Toggle buttons
    local function toggleButton(button, state)
        button.Text = button.Text:gsub(": OFF", ": ON")
        if not state then
            button.Text = button.Text:gsub(": ON", ": OFF")
        end
        
        return not state
    end
    
    aimbotToggle.MouseButton1Click:connect(function()
        aimbotToggle.Text = toggleButton(aimbotToggle, true)
    end)
    
    triggerBotToggle.MouseButton1Click:connect(function()
        triggerBotToggle.Text = toggleButton(triggerBotToggle, false)
    end)
    
    speedHackToggle.MouseButton1Click:connect(function()
        speedHackToggle.Text = toggleButton(speedHackToggle, true)
    end)
    
    espToggle.MouseButton1Click:connect(function()
        espToggle.Text = toggleButton(espToggle, true)
    end)
    
    radarToggle.MouseButton1Click:connect(function()
        radarToggle.Text = toggleButton(radarToggle, false)
    end)
    
    nameTagsToggle.MouseButton1Click:connect(function()
        nameTagsToggle.Text = toggleButton(nameTagsToggle, true)
    end)
    
    autoRespawnToggle.MouseButton1Click:connect(function()
        autoRespawnToggle.Text = toggleButton(autoRespawnToggle, true)
    end)
    
    autoPickupToggle.MouseButton1Click:connect(function()
        autoPickupToggle.Text = toggleButton(autoPickupToggle, false)
    end)
    
    autoReloadToggle.MouseButton1Click:connect(function()
        autoReloadToggle.Text = toggleButton(autoReloadToggle, true)
    end)
    
    -- Close window on escape
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            mainFrame.Visible = false
        end
    end)
    
    return mainFrame
end

-- Create the GUI
local mainGui = createGUI()
mainGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Start the main loop
game:GetService("RunService").Heartbeat:Connect(function()
    -- Anti-cheat features
    local player = game.Players.LocalPlayer
    
    if player and player.Character then
        -- Check for common cheat signatures (basic anti-cheat)
        for _, child in pairs(player.Character:GetChildren()) do
            if not child:IsA("Humanoid") and not child:IsA("Model") then
                child:Destroy()
            end
        end
        
        -- Anti-aimbot features
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = 70
        end
    end
    
    -- Handle auto-reload (basic implementation)
    local tool = player.Character and player.Character:FindFirstChild("Tool")
    if tool then
        local fireRate = math.random(1, 5) / 200
        if tool:GetAttribute("FireRate") ~= nil then
            tool:SetAttribute("FireRate", fireRate)
        end
    end
    
    -- Handle auto-pickup (basic implementation)
    for _, item in pairs(workspace:FindFirstChild("Items") or {}) do
        local pos = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position
        if pos then
            local distance = (item.Position - pos).Magnitude
            if distance < 30 then -- Adjust this range as needed
                item:PivotTo(CFrame.new(pos))
            end
        end
    end
    
    -- Anti-cheat detection for movement
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local moveSpeed = player.Character.Humanoid.WalkSpeed or 16
        player.Character.Humanoid.WalkSpeed = moveSpeed + math.random(-0.5, 0.5)
    end
    
    -- Anti-anti-cheat (randomize FPS)
    local randomFPS = math.random(20, 60)
    game:GetService("RunService").RenderStepped:Connect(function()
        if math.random() < 0.01 then
            wait(1 / randomFPS)
        end
    end)
end

-- Additional features for better anti-cheat:
-- 1. Randomize player appearance (prevent detection of mods)
-- 2. Simulate human-like mouse movement and input
-- 3. Dynamic camera behavior to avoid detection
-- 4. Anti-detection of tools and weapons

print("Da Hood Script Loaded!")
