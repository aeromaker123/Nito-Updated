-- NITO GUI | CoreGui Xeno-Compatible

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ================= CONFIG =================
local UI = {
    Open = true,
    Pos = UDim2.new(0, 450, 0, 250),
    Size = UDim2.new(0, 560, 0, 360),
    Accent = Color3.fromRGB(155,115,255),
    Dragging = false,
    CurrentTab = "Main",
    Binding = false,
    Sliding = false
}

local Tabs = {"Main","Movement","Visuals","Misc"}

local State = {
    Aimbot = false,
    Orbit = false,
    Triggerbot = false,
    OrbitSpeed = 5,
    OrbitDistance = 10,
    OrbitMode = "Random",
    ToggleKey = Enum.KeyCode.F
}

-- ================= SCREENGUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NITO_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UI.Size
Frame.Position = UI.Pos
Frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "N I T O"
Title.Size = UDim2.new(0,100,0,30)
Title.Position = UDim2.new(0.5,-50,0,10)
Title.TextColor3 = UI.Accent
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,130,1,0)
Sidebar.Position = UDim2.new(0,0,0,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

-- Tab Buttons
local TabButtons = {}
for i,name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0,110,0,30)
    btn.Position = UDim2.new(0,10,0,60+(i-1)*40)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(180,180,180)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    TabButtons[name] = btn
end

-- ================= MAIN TAB =================
local MainTab = Instance.new("Frame")
MainTab.Size = UDim2.new(1, -140, 1, -20)
MainTab.Position = UDim2.new(0,140,0,10)
MainTab.BackgroundTransparency = 1
MainTab.Parent = Frame

-- Helper to create toggle buttons
local function createToggle(text,posY)
    local btn = Instance.new("TextButton")
    btn.Text = text..": OFF"
    btn.Size = UDim2.new(0,200,0,25)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.BorderSizePixel = 0
    btn.Parent = MainTab
    return btn
end

local AimbotBtn = createToggle("Aimbot",10)
local OrbitBtn = createToggle("Orbit",45)
local TriggerBtn = createToggle("Triggerbot",270)

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0,MainTab.Size.X.Offset-20,0,2)
Divider.Position = UDim2.new(0,10,0,230)
Divider.BackgroundColor3 = Color3.fromRGB(80,80,80)
Divider.BorderSizePixel = 0
Divider.Parent = MainTab

-- Keybind
local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Text = "Toggle Key: "..State.ToggleKey.Name
KeybindBtn.Size = UDim2.new(0,200,0,25)
KeybindBtn.Position = UDim2.new(0,10,0,305)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
KeybindBtn.TextColor3 = Color3.fromRGB(220,220,220)
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Parent = MainTab

-- Sliders
local function createSlider(name,posY,min,max)
    local label = Instance.new("TextLabel")
    label.Text = name..": "..min
    label.Size = UDim2.new(0,200,0,20)
    label.Position = UDim2.new(0,10,0,posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Parent = MainTab

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,200,0,5)
    bar.Position = UDim2.new(0,10,0,posY+20)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    bar.Parent = MainTab

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0,10,0,10)
    handle.Position = UDim2.new(0,0,0,posY+17)
    handle.BackgroundColor3 = UI.Accent
    handle.Parent = MainTab

    return {label=label,bar=bar,handle=handle,min=min,max=max,value=min}
end

local OrbitSpeedSlider = createSlider("Orbit Speed",80,1,20)
local OrbitDistanceSlider = createSlider("Orbit Distance",125,1,50)

-- Dropdown
local OrbitModeBtn = Instance.new("TextButton")
OrbitModeBtn.Text = "Orbit Mode: "..State.OrbitMode
OrbitModeBtn.Size = UDim2.new(0,200,0,25)
OrbitModeBtn.Position = UDim2.new(0,10,0,170)
OrbitModeBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
OrbitModeBtn.TextColor3 = Color3.fromRGB(220,220,220)
OrbitModeBtn.BorderSizePixel = 0
OrbitModeBtn.Parent = MainTab

-- ================= INPUT =================
-- Tab switching
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        UI.CurrentTab = name
        -- Hide all tabs
        MainTab.Visible = (name=="Main")
    end)
end

-- Toggles
AimbotBtn.MouseButton1Click:Connect(function()
    State.Aimbot = not State.Aimbot
    AimbotBtn.Text = "Aimbot: "..(State.Aimbot and "ON" or "OFF")
end)

OrbitBtn.MouseButton1Click:Connect(function()
    State.Orbit = not State.Orbit
    OrbitBtn.Text = "Orbit: "..(State.Orbit and "ON" or "OFF")
end)

TriggerBtn.MouseButton1Click:Connect(function()
    State.Triggerbot = not State.Triggerbot
    TriggerBtn.Text = "Triggerbot: "..(State.Triggerbot and "ON" or "OFF")
end)

OrbitModeBtn.MouseButton1Click:Connect(function()
    State.OrbitMode = (State.OrbitMode=="Random") and "Velocity" or "Random"
    OrbitModeBtn.Text = "Orbit Mode: "..State.OrbitMode
end)

-- Keybind
KeybindBtn.MouseButton1Click:Connect(function()
    UI.Binding = true
    KeybindBtn.Text = "Press a key..."
end)

UIS.InputBegan:Connect(function(input)
    if UI.Binding and input.UserInputType == Enum.UserInputType.Keyboard then
        State.ToggleKey = input.KeyCode
        KeybindBtn.Text = "Toggle Key: "..State.ToggleKey.Name
        UI.Binding = false
    end
end)

-- Slider dragging
local function updateSlider(slider,mouseX)
    local barX = slider.bar.AbsolutePosition.X
    local barWidth = slider.bar.AbsoluteSize.X
    local relative = math.clamp(mouseX - barX,0,barWidth)/barWidth
    local value = slider.min + (slider.max-slider.min)*relative
    slider.value = math.floor(value*100)/100
    slider.label.Text = slider.label.Text:match("^(.-):")..": "..slider.value
    slider.handle.Position = UDim2.new(0,relative*barWidth-5,0,slider.handle.Position.Y.Offset)
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = UIS:GetMouseLocation()
        if mouse.X >= OrbitSpeedSlider.bar.AbsolutePosition.X and mouse.X <= OrbitSpeedSlider.bar.AbsolutePosition.X+OrbitSpeedSlider.bar.AbsoluteSize.X
        and mouse.Y >= OrbitSpeedSlider.bar.AbsolutePosition.Y and mouse.Y <= OrbitSpeedSlider.bar.AbsolutePosition.Y+OrbitSpeedSlider.bar.AbsoluteSize.Y then
            UI.Sliding = "OrbitSpeed"
        elseif mouse.X >= OrbitDistanceSlider.bar.AbsolutePosition.X and mouse.X <= OrbitDistanceSlider.bar.AbsolutePosition.X+OrbitDistanceSlider.bar.AbsoluteSize.X
        and mouse.Y >= OrbitDistanceSlider.bar.AbsolutePosition.Y and mouse.Y <= OrbitDistanceSlider.bar.AbsolutePosition.Y+OrbitDistanceSlider.bar.AbsoluteSize.Y then
            UI.Sliding = "OrbitDistance"
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        UI.Sliding = false
    end
end)

RS.RenderStepped:Connect(function()
    local mouse = UIS:GetMouseLocation()
    if UI.Sliding=="OrbitSpeed" then
        updateSlider(OrbitSpeedSlider,mouse.X)
    elseif UI.Sliding=="OrbitDistance" then
        updateSlider(OrbitDistanceSlider,mouse.X)
    end
end)
