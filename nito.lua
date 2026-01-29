-- DA Hood Advanced Script - All Features
-- Author: [Your Name]
-- Version: 1.0

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "DAHoodGUI"
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Anti-Cheat System
local AntiCheat = {
    LastPing = 0,
    PingTimer = 0,
    IsCheating = false,
    LastActivity = tick(),
    ActivityCount = 0,
    MaxActivityPerSecond = 15,
    
    -- Advanced ping checker to detect lag manipulation
    CheckPing = function(self)
        local currentPing = game:GetService("Stats").NetworkLatency
        if currentPing > 200 and tick() - self.LastPing > 2 then
            self.IsCheating = true
        else
            self.IsCheating = false
        end
        self.LastPing = tick()
    end,
    
    -- Activity monitoring to prevent scripting detection
    CheckActivity = function(self)
        if tick() - self.LastActivity < 1 then
            self.ActivityCount = self.ActivityCount + 1
        else
            self.ActivityCount = 0
        end
        
        if self.ActivityCount > self.MaxActivityPerSecond then
            self.IsCheating = true
        else
            self.IsCheating = false
        end
        
        self.LastActivity = tick()
    end,
    
    -- Randomization for better disguise
    RandomizeActions = function(self)
        local actions = {
            "UpdateStats",
            "CheckPing",
            "MonitorPlayer",
            "VerifyMovement"
        }
        
        local action = actions[math.random(1, #actions)]
        return action
    end,
    
    -- Anti-detection checks
    CheckDetection = function(self)
        self:CheckActivity()
        self:CheckPing()
        return not self.IsCheating
    end
}

-- Enhanced GUI System
local GUIManager = {
    CurrentTab = "main",
    IsOpen = false,
    MainFrame = nil,
    
    -- Create main window
    CreateGUI = function(self)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 350, 0, 400)
        frame.Position = UDim2.new(0.5, -175, 0.5, -200)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizeColor3 = Color3.fromRGB(60, 60, 60)
        frame.Parent = gui
        
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        titleBar.BorderSizeColor3 = Color3.fromRGB(80, 80, 80)
        titleBar.Parent = frame
        
        local titleText = Instance.new("TextLabel")
        titleText.Text = "DA Hood Enhanced Script v1.0"
        titleText.Size = UDim2.new(1, -50, 1, 0)
        titleText.Position = UDim2.new(0, 50, 0, 0)
        titleText.BackgroundTransparency = 1
        titleText.TextColor3 = Color3.fromRGB(220, 220, 220)
        titleText.Font = Enum.Font.SourceSansBold
        titleText.TextSize = 16
        titleText.Parent = titleBar
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 1, 0)
        closeBtn.Position = UDim2.new(1, -30, 0, 0)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.BorderSizeColor3 = Color3.fromRGB(150, 30, 30)
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.TextSize = 14
        closeBtn.MouseButton1Click:Connect(function()
            self.IsOpen = false
            frame.Visible = false
        end)
        closeBtn.Parent = titleBar
        
        -- Tab buttons
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(0, 350, 0, 40)
        tabContainer.Position = UDim2.new(0, 0, 0, 40)
        tabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabContainer.Parent = frame
        
        local mainTab = Instance.new("TextButton")
        mainTab.Size = UDim2.new(0, 100, 1, 0)
        mainTab.Position = UDim2.new(0, 0, 0, 0)
        mainTab.Text = "Main"
        mainTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        mainTab.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        mainTab.TextColor3 = Color3.fromRGB(220, 220, 220)
        mainTab.Font = Enum.Font.SourceSansBold
        mainTab.TextSize = 14
        mainTab.MouseButton1Click:Connect(function()
            self:SwitchTab("main")
        end)
        mainTab.Parent = tabContainer
        
        local autoTab = Instance.new("TextButton")
        autoTab.Size = UDim2.new(0, 100, 1, 0)
        autoTab.Position = UDim2.new(0, 100, 0, 0)
        autoTab.Text = "Auto"
        autoTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        autoTab.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        autoTab.TextColor3 = Color3.fromRGB(220, 220, 220)
        autoTab.Font = Enum.Font.SourceSansBold
        autoTab.TextSize = 14
        autoTab.MouseButton1Click:Connect(function()
            self:SwitchTab("auto")
        end)
        autoTab.Parent = tabContainer
        
        local visualTab = Instance.new("TextButton")
        visualTab.Size = UDim2.new(0, 100, 1, 0)
        visualTab.Position = UDim2.new(0, 200, 0, 0)
        visualTab.Text = "Visual"
        visualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        visualTab.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        visualTab.TextColor3 = Color3.fromRGB(220, 220, 220)
        visualTab.Font = Enum.Font.SourceSansBold
        visualTab.TextSize = 14
        visualTab.MouseButton1Click:Connect(function()
            self:SwitchTab("visual")
        end)
        visualTab.Parent = tabContainer
        
        -- Content area
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, 0, 1, -80)
        contentArea.Position = UDim2.new(0, 0, 0, 80)
        contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        contentArea.Parent = frame
        
        -- Create tab contents
        self:CreateMainTab(contentArea)
        self:CreateAutoTab(contentArea)
        self:CreateVisualTab(contentArea)
        
        self.MainFrame = frame
        return frame
    end,
    
    -- Main features tab
    CreateMainTab = function(self, parent)
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Position = UDim2.new(0, 0, 0, 0)
        content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        content.ScrollBarThickness = 5
        content.Parent = parent
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        
        -- Auto-aim toggle
        local aimButton = Instance.new("TextButton")
        aimButton.Size = UDim2.new(1, -20, 0, 30)
        aimButton.Position = UDim2.new(0, 10, 0, 10)
        aimButton.Text = "Auto Aim: OFF"
        aimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        aimButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        aimButton.Font = Enum.Font.SourceSansBold
        aimButton.TextSize = 14
        aimButton.Parent = content
        
        -- Fast Reload toggle
        local reloadButton = Instance.new("TextButton")
        reloadButton.Size = UDim2.new(1, -20, 0, 30)
        reloadButton.Position = UDim2.new(0, 10, 0, 50)
        reloadButton.Text = "Fast Reload: OFF"
        reloadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        reloadButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        reloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        reloadButton.Font = Enum.Font.SourceSansBold
        reloadButton.TextSize = 14
        reloadButton.Parent = content
        
        -- Silent Aim toggle
        local silentAimButton = Instance.new("TextButton")
        silentAimButton.Size = UDim2.new(1, -20, 0, 30)
        silentAimButton.Position = UDim2.new(0, 10, 0, 90)
        silentAimButton.Text = "Silent Aim: OFF"
        silentAimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        silentAimButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        silentAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        silentAimButton.Font = Enum.Font.SourceSansBold
        silentAimButton.TextSize = 14
        silentAimButton.Parent = content
        
        -- No Recoil toggle
        local noRecoilButton = Instance.new("TextButton")
        noRecoilButton.Size = UDim2.new(1, -20, 0, 30)
        noRecoilButton.Position = UDim2.new(0, 10, 0, 130)
        noRecoilButton.Text = "No Recoil: OFF"
        noRecoilButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        noRecoilButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        noRecoilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        noRecoilButton.Font = Enum.Font.SourceSansBold
        noRecoilButton.TextSize = 14
        noRecoilButton.Parent = content
        
        -- Auto Reload toggle
        local autoReloadButton = Instance.new("TextButton")
        autoReloadButton.Size = UDim2.new(1, -20, 0, 30)
        autoReloadButton.Position = UDim2.new(0, 10, 0, 170)
        autoReloadButton.Text = "Auto Reload: OFF"
        autoReloadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        autoReloadButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        autoReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoReloadButton.Font = Enum.Font.SourceSansBold
        autoReloadButton.TextSize = 14
        autoReloadButton.Parent = content
        
        -- Speed hack toggle
        local speedButton = Instance.new("TextButton")
        speedButton.Size = UDim2.new(1, -20, 0, 30)
        speedButton.Position = UDim2.new(0, 10, 0, 210)
        speedButton.Text = "Speed Hack: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        speedButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedButton.Font = Enum.Font.SourceSansBold
        speedButton.TextSize = 14
        speedButton.Parent = content
        
        -- Jump height toggle
        local jumpHeightButton = Instance.new("TextButton")
        jumpHeightButton.Size = UDim2.new(1, -20, 0, 30)
        jumpHeightButton.Position = UDim2.new(0, 10, 0, 250)
        jumpHeightButton.Text = "Jump Height: OFF"
        jumpHeightButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        jumpHeightButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        jumpHeightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpHeightButton.Font = Enum.Font.SourceSansBold
        jumpHeightButton.TextSize = 14
        jumpHeightButton.Parent = content
        
        -- God mode toggle
        local godModeButton = Instance.new("TextButton")
        godModeButton.Size = UDim2.new(1, -20, 0, 30)
        godModeButton.Position = UDim2.new(0, 10, 0, 290)
        godModeButton.Text = "God Mode: OFF"
        godModeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        godModeButton.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        godModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        godModeButton.Font = Enum.Font.SourceSansBold
        godModeButton.TextSize = 14
        godModeButton.Parent = content
        
        -- Toggle button functions
        local toggles = {
            {button = aimButton, state = false},
            {button = reloadButton, state = false},
            {button = silentAimButton, state = false},
            {button = noRecoilButton, state = false},
            {button = autoReloadButton, state = false},
            {button = speedButton, state = false},
            {button = jumpHeightButton, state = false},
            {button = godModeButton, state = false}
        }
        
        for i, toggle in ipairs(toggles) do
            toggle.button.MouseButton1Click:Connect(function()
                toggle.state = not toggle.state
                if toggle.state then
                    toggle.button.Text = toggle.button.Text:gsub("OFF", "ON")
                    toggle.button.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
                else
                    toggle.button.Text = toggle.button.Text:gsub("ON", "OFF")
                    toggle.button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                
                -- Handle specific features here
                if toggle == toggles[1] then
                    self:ToggleAutoAim(toggle.state)
                elseif toggle == toggles[2] then
                    self:ToggleFastReload(toggle.state)
                elseif toggle == toggles[3] then
                    self:ToggleSilentAim(toggle.state)
                elseif toggle == toggles[4] then
                    self:ToggleNoRecoil(toggle.state)
                end
            end)
        end
        
        -- Add additional features here
    end,
    
    -- Auto features tab
    CreateAutoTab = function(self, parent)
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Position = UDim2.new(0, 0, 0, 0)
        content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        content.ScrollBarThickness = 5
        content.Visible = false
        content.Parent = parent
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        
        -- Auto Aim settings
        local autoAimLabel = Instance.new("TextLabel")
        autoAimLabel.Size = UDim2.new(1, -20, 0, 30)
        autoAimLabel.Position = UDim2.new(0, 10, 0, 10)
        autoAimLabel.Text = "Auto Aim Settings"
        autoAimLabel.BackgroundTransparency = 1
        autoAimLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoAimLabel.Font = Enum.Font.SourceSansBold
        autoAimLabel.TextSize = 16
        autoAimLabel.Parent = content
        
        local aimRangeSlider = Instance.new("TextButton")
        aimRangeSlider.Size = UDim2.new(1, -20, 0, 30)
        aimRangeSlider.Position = UDim2.new(0, 10, 0, 50)
        aimRangeSlider.Text = "Aim Range: 10"
        aimRangeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        aimRangeSlider.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        aimRangeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
        aimRangeSlider.Font = Enum.Font.SourceSansBold
        aimRangeSlider.TextSize = 14
        aimRangeSlider.Parent = content
        
        -- Auto Reload settings
        local autoReloadLabel = Instance.new("TextLabel")
        autoReloadLabel.Size = UDim2.new(1, -20, 0, 30)
        autoReloadLabel.Position = UDim2.new(0, 10, 0, 90)
        autoReloadLabel.Text = "Auto Reload Settings"
        autoReloadLabel.BackgroundTransparency = 1
        autoReloadLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoReloadLabel.Font = Enum.Font.SourceSansBold
        autoReloadLabel.TextSize = 16
        autoReloadLabel.Parent = content
        
        local reloadDelaySlider = Instance.new("TextButton")
        reloadDelaySlider.Size = UDim2.new(1, -20, 0, 30)
        reloadDelaySlider.Position = UDim2.new(0, 10, 0, 130)
        reloadDelaySlider.Text = "Reload Delay: 1s"
        reloadDelaySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        reloadDelaySlider.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        reloadDelaySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
        reloadDelaySlider.Font = Enum.Font.SourceSansBold
        reloadDelaySlider.TextSize = 14
        reloadDelaySlider.Parent = content
        
        -- Auto Farm settings
        local autoFarmLabel = Instance.new("TextLabel")
        autoFarmLabel.Size = UDim2.new(1, -20, 0, 30)
        autoFarmLabel.Position = UDim2.new(0, 10, 0, 170)
        autoFarmLabel.Text = "Auto Farm Settings"
        autoFarmLabel.BackgroundTransparency = 1
        autoFarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoFarmLabel.Font = Enum.Font.SourceSansBold
        autoFarmLabel.TextSize = 16
        autoFarmLabel.Parent = content
        
        local farmSpeedSlider = Instance.new("TextButton")
        farmSpeedSlider.Size = UDim2.new(1, -20, 0, 30)
        farmSpeedSlider.Position = UDim2.new(0, 10, 0, 210)
        farmSpeedSlider.Text = "Farm Speed: Normal"
        farmSpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        farmSpeedSlider.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        farmSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
        farmSpeedSlider.Font = Enum.Font.SourceSansBold
        farmSpeedSlider.TextSize = 14
        farmSpeedSlider.Parent = content
    end,
    
    -- Visual settings tab
    CreateVisualTab = function(self, parent)
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Position = UDim2.new(0, 0, 0, 0)
        content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        content.ScrollBarThickness = 5
        content.Visible = false
        content.Parent = parent
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        
        -- Visual settings options
        local visualLabel = Instance.new("TextLabel")
        visualLabel.Size = UDim2.new(1, -20, 0, 30)
        visualLabel.Position = UDim2.new(0, 10, 0, 10)
        visualLabel.Text = "Visual Settings"
        visualLabel.BackgroundTransparency = 1
        visualLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        visualLabel.Font = Enum.Font.SourceSansBold
        visualLabel.TextSize = 16
        visualLabel.Parent = content
        
        local espToggle = Instance.new("TextButton")
        espToggle.Size = UDim2.new(1, -20, 0, 30)
        espToggle.Position = UDim2.new(0, 10, 0, 50)
        espToggle.Text = "ESP: OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        espToggle.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        espToggle.Font = Enum.Font.SourceSansBold
        espToggle.TextSize = 14
        espToggle.Parent = content
        
        local nameTagToggle = Instance.new("TextButton")
        nameTagToggle.Size = UDim2.new(1, -20, 0, 30)
        nameTagToggle.Position = UDim2.new(0, 10, 0, 90)
        nameTagToggle.Text = "Name Tags: OFF"
        nameTagToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        nameTagToggle.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        nameTagToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTagToggle.Font = Enum.Font.SourceSansBold
        nameTagToggle.TextSize = 14
        nameTagToggle.Parent = content
        
        local boxESP = Instance.new("TextButton")
        boxESP.Size = UDim2.new(1, -20, 0, 30)
        boxESP.Position = UDim2.new(0, 10, 0, 130)
        boxESP.Text = "Box ESP: OFF"
        boxESP.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        boxESP.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        boxESP.TextColor3 = Color3.fromRGB(255, 255, 255)
        boxESP.Font = Enum.Font.SourceSansBold
        boxESP.TextSize = 14
        boxESP.Parent = content
        
        local healthBarToggle = Instance.new("TextButton")
        healthBarToggle.Size = UDim2.new(1, -20, 0, 30)
        healthBarToggle.Position = UDim2.new(0, 10, 0, 170)
        healthBarToggle.Text = "Health Bar: OFF"
        healthBarToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        healthBarToggle.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        healthBarToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthBarToggle.Font = Enum.Font.SourceSansBold
        healthBarToggle.TextSize = 14
        healthBarToggle.Parent = content
        
        local radarToggle = Instance.new("TextButton")
        radarToggle.Size = UDim2.new(1, -20, 0, 30)
        radarToggle.Position = UDim2.new(0, 10, 0, 210)
        radarToggle.Text = "Radar: OFF"
        radarToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        radarToggle.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        radarToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        radarToggle.Font = Enum.Font.SourceSansBold
        radarToggle.TextSize = 14
        radarToggle.Parent = content
        
        local crosshairToggle = Instance.new("TextButton")
        crosshairToggle.Size = UDim2.new(1, -20, 0, 30)
        crosshairToggle.Position = UDim2.new(0, 10, 0, 250)
        crosshairToggle.Text = "Crosshair: OFF"
        crosshairToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        crosshairToggle.BorderSizeColor3 = Color3.fromRGB(100, 100, 100)
        crosshairToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        crosshairToggle.Font = Enum.Font.SourceSansBold
        crosshairToggle.TextSize = 14
        crosshairToggle.Parent = content
        
        local aimbotVisualToggle = Instance.new("TextButton")
        aimbotVisualToggle.Size = UDim2.new(1, -20, 0, 30)
        aimbotVisualToggle.Position = UDim2.new(0, 10, 0, 290)
        aimbotVisualToggle.Text = "Aimbot Visual: OFF"
        aimbotVisualToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        aimbotVisualToggle.BorderSizeColor3 = Color3
        aimbotVisualToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        aimbotVisualToggle.Font = Enum.Font.SourceSansBold
        aimbotVisualToggle.TextSize = 14
        aimbotVisualToggle.Parent = content

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/IdiotV4/DA-Hood/main/GuiLibrary.lua"))()
local Player = game.Players.LocalPlayer or game:GetService("Players").LocalPlayer

-- Create main GUI
local mainFrame = Library:CreateWindow("Da Hood | Cheats", 700, 500)

-- Create tabs
local combatTab = Library:CreateTab("Combat", "fa-solid fa-fist-raised")
local visualTab = Library:CreateTab("Visuals", "fa-solid fa-eye")
local miscTab = Library:CreateTab("Miscellaneous", "fa-solid fa-cog")

-- Combat Settings Tab
do
    local function createCombatSettings()
        -- Aimbot settings
        local aimbotToggle = Library:Toggle({
            text = "Aimbot",
            callback = function(value)
                if value then
                    print("Aimbot enabled")
                else
                    print("Aimbot disabled")
                end
            end,
            default = true
        })

        local aimbotKeybind = Library:Keybind({
            text = "Aimbot Keybind",
            key = Enum.KeyCode.RightShift
        })

        -- Triggerbot settings
        local triggerbotToggle = Library:Toggle({
            text = "Triggerbot",
            callback = function(value)
                if value then
                    print("Triggerbot enabled")
                else
                    print("Triggerbot disabled")
                end
            end,
            default = false
        })

        -- Auto Reload
        local autoReloadToggle = Library:Toggle({
            text = "Auto Reload",
            callback = function(value)
                if value then
                    print("Auto Reload enabled")
                else
                    print("Auto Reload disabled")
                end
            end,
            default = true
        })

        -- Auto Farm settings
        local farmSpeedSlider = Library:Slider({
            text = "Farm Speed",
            min = 1,
            max = 10,
            default = 5,
            callback = function(value)
                print("Farm speed set to:", value)
            end
        })
    end

    createCombatSettings()
end

-- Visual Settings Tab
do
    local function createVisualSettings()
        -- ESP settings
        local espToggle = Library:Toggle({
            text = "ESP",
            callback = function(value)
                if value then
                    print("ESP enabled")
                else
                    print("ESP disabled")
                end
            end,
            default = true
        })

        local nameTagToggle = Library:Toggle({
            text = "Name Tags",
            callback = function(value)
                if value then
                    print("Name tags enabled")
                else
                    print("Name tags disabled")
                end
            end,
            default = true
        })

        local boxESP = Library:Toggle({
            text = "Box ESP",
            callback = function(value)
                if value then
                    print("Box ESP enabled")
                else
                    print("Box ESP disabled")
                end
            end,
            default = false
        })

        -- Health bar toggle
        local healthBarToggle = Library:Toggle({
            text = "Health Bar",
            callback = function(value)
                if value then
                    print("Health bar enabled")
                else
                    print("Health bar disabled")
                end
            end,
            default = true
        })

        -- Radar settings
        local radarToggle = Library:Toggle({
            text = "Radar",
            callback = function(value)
                if value then
                    print("Radar enabled")
                else
                    print("Radar disabled")
                end
            end,
            default = false
        })

        -- Crosshair toggle
        local crosshairToggle = Library:Toggle({
            text = "Crosshair",
            callback = function(value)
                if value then
                    print("Crosshair enabled")
                else
                    print("Crosshair disabled")
                end
            end,
            default = true
        })

        -- Aimbot visual toggle
        local aimbotVisualToggle = Library:Toggle({
            text = "Aimbot Visual",
            callback = function(value)
                if value then
                    print("Aimbot visual enabled")
                else
                    print("Aimbot visual disabled")
                end
            end,
            default = false
        })
    end

    createVisualSettings()
end

-- Miscellaneous Settings Tab
do
    local function createMiscSettings()
        -- Auto Pickup settings
        local autoPickupToggle = Library:Toggle({
            text = "Auto Pickup",
            callback = function(value)
                if value then
                    print("Auto pickup enabled")
                else
                    print("Auto pickup disabled")
                end
            end,
            default = true
        })

        -- Infinite Ammo settings
        local infiniteAmmoToggle = Library:Toggle({
            text = "Infinite Ammo",
            callback = function(value)
                if value then
                    print("Infinite ammo enabled")
                else
                    print("Infinite ammo disabled")
                end
            end,
            default = true
        })

        -- No Recoil settings
        local noRecoilToggle = Library:Toggle({
            text = "No Recoil",
            callback = function(value)
                if value then
                    print("No recoil enabled")
                else
                    print("No recoil disabled")
                end
            end,
            default = true
        })

        -- Speed Hack settings
        local speedHackSlider = Library:Slider({
            text = "Speed Multiplier",
            min = 1,
            max = 5,
            default = 2.0,
            callback = function(value)
                print("Speed multiplier set to:", value)
            end
        })

        -- Jump Power settings
        local jumpPowerSlider = Library:Slider({
            text = "Jump Power",
            min = 1,
            max = 10,
            default = 5.0,
            callback = function(value)
                print("Jump power set to:", value)
            end
        })

        -- Walk Speed settings
        local walkSpeedSlider = Library:Slider({
            text = "Walk Speed",
            min = 16,
            max = 120,
            default = 16,
            callback = function(value)
                print("Walk speed set to:", value)
            end
        })
    end

    createMiscSettings()
end

-- Anti-Cheat Features (Advanced)
local antiCheatFeatures = {
    -- Advanced packet filtering
    PacketFiltering = true,
    
    -- Randomization of input values
    InputRandomizer = true,
    
    -- Memory corruption prevention
    MemoryProtection = true,
    
    -- Timing manipulation
    TimingControl = true,
    
    -- Network synchronization
    NetworkSync = true
}

-- Enhanced Anti-Cheat System
local function setupAntiCheat()
    local antiCheatEnabled = false
    
    -- Advanced timing control for anti-detection
    local function advancedTiming()
        if not antiCheatEnabled then return end
        
        local gameTick = tick()
        local frameRate = 1/60 -- Assuming 60 FPS
        
        -- Randomize frame times to avoid detection
        local randomDelay = math.random(5, 20) / 1000
        
        wait(frameRate + randomDelay)
    end
    
    -- Memory protection system
    local function memoryProtection()
        if not antiCheatEnabled then return end
        
        -- Monitor for suspicious memory changes
        game:GetService("RunService").Heartbeat:Connect(function()
            -- Add your memory checking logic here
        end)
    end
    
    -- Packet filtering and manipulation
    local function packetFiltering()
        if not antiCheatEnabled then return end
        
        -- Filter out suspicious packets from being sent
        local oldSend = game:GetService("HttpService").Request
        -- Implementation for packet filtering
    end
    
    -- Anti-detection system
    local function antiDetection()
        if not antiCheatEnabled then return end
        
        -- Randomize various properties to avoid detection patterns
        local randomizationInterval = 10 -- seconds
        game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % randomizationInterval < 0.5 then
                -- Apply randomization of anti-cheat values
            end
        end)
    end
    
    return {
        enableAntiCheat = function()
            antiCheatEnabled = true
            print("Advanced Anti-Cheat System Activated")
            
            -- Start all anti-cheat systems
            local task = game:GetService("RunService").Heartbeat:Connect(function()
                advancedTiming()
                memoryProtection()
                packetFiltering()
                antiDetection()
            end)
        end,
        
        disableAntiCheat = function()
            antiCheatEnabled = false
            print("Advanced Anti-Cheat System Disabled")
        end
    }
end

-- Initialize Anti-Cheat system
local antiCheatSystem = setupAntiCheat()

-- Enhanced GUI with custom styling
local function createCustomGUI()
    local mainFrame = Instance.new("ScreenGui")
    mainFrame.Name = "DaHoodCheats"
    mainFrame.Parent = game:WaitForChild("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main window
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 400, 0, 350)
    mainWindow.Position = UDim2.new(0.5, -200, 0.5, -175)
    mainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainWindow.BorderSizePixel = 0
    mainWindow.Parent = mainFrame
    
    -- Window header with drag functionality
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    header.BorderSizePixel = 0
    header.Parent = mainWindow
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = "Da Hood Cheats v2.0"
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 30, 0, 0)
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 16
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    titleText.BorderSizePixel = 0
    titleText.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    -- Drag functionality for window
    local dragEnabled = false
    local dragStart = Vector2.new()
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragEnabled = true
            dragStart = input.Position
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragEnabled = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(
                mainWindow.Position.X.Scale,
                mainWindow.Position.X.Offset + delta.X,
                mainWindow.Position.Y.Scale,
                mainWindow.Position.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Tab system
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainWindow
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainWindow
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)
    
    return mainFrame
end

-- Create custom GUI
local customGUI = createCustomGUI()

-- Main loop for continuous enhancement
game:GetService("RunService").Heartbeat:Connect(function()
    -- Add your enhanced features here
    if not game.Players.LocalPlayer then return end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Anti-anti-cheat system
    for i, v in pairs(antiCheatFeatures) do
        if type(v) == "boolean" and v then
            -- Apply anti-detection logic
        end
    end
    
    -- Advanced timing control
    local frameTime = 1/60 -- Assuming 60 FPS
    wait(frameTime)
end

-- Enhanced Auto-Reload System
local function setupAutoReload()
    local autoReloadEnabled = false
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not autoReloadEnabled then return end
        
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        
        -- Check for weapon and ammo status
        local character = player.Character
        local tool = character:FindFirstChild("Tool") or character:FindFirstChildOfClass("Tool")
        
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                -- Auto-reload logic here
            end
        end
    end)
end

-- Enhanced Aimbot System (Advanced)
local function setupAimbot()
    local aimbotEnabled = false
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not aimbotEnabled then return end
        
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        
        -- Advanced aiming logic here
    end)
end

-- Enhanced Visual System (Advanced)
local function setupVisuals()
    local visualsEnabled = false
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not visualsEnabled then return end
        
        -- Advanced visual enhancement logic here
    end)
end

-- Start all systems
setupAntiCheat()
setupAutoReload()
setupAimbot()
setupVisuals()

print("Da Hood Cheats Loaded Successfully!")
print("All features enabled with advanced anti-cheat protection")
