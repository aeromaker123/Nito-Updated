-- NITO GUI | Full Xeno-Compatible with Da Hood Guns Dropdown + Search

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ================= CONFIG =================
local UI = {
    Open = true,
    Dragging = false,
    CurrentTab = "Main",
    Binding = false,
    Sliding = false
}

local Tabs = {"Main","Movement","Visuals","Misc"}

local DaHoodGuns = {"Glock","Revolver","AR","AK-47","Shotgun","P90","Drum Gun","Rifle","AUG"}

local State = {
    Aimbot = false,
    Orbit = false,
    Triggerbot = false,
    OrbitSpeed = 5,
    OrbitDistance = 10,
    OrbitMode = "Random",
    ToggleKey = Enum.KeyCode.F,
    ShootShooter = false,
    TP = false,
    SelectedGun = "Glock"
}

-- ================= SCREENGUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NITO_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,520,0,360)
Frame.Position = UDim2.new(0.5,-260,0.5,-180)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "N I T O"
Title.Size = UDim2.new(0,200,0,30)
Title.Position = UDim2.new(0.5,-100,0,10)
Title.TextColor3 = Color3.fromRGB(155,115,255)
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

-- ================= CREATE TABS =================
local function CreateTab(name)
    local tab = Instance.new("Frame")
    tab.Size = UDim2.new(1,-140,1,-60)
    tab.Position = UDim2.new(0,140,0,50)
    tab.BackgroundTransparency = 1
    tab.Visible = (name=="Main")
    tab.Name = name.."Tab"
    tab.Parent = Frame
    return tab
end

local TabsFrames = {}
for _,name in ipairs(Tabs) do
    TabsFrames[name] = CreateTab(name)
end

local MainTab = TabsFrames["Main"]

-- ================= MAIN TAB ELEMENTS =================
-- Helper: Toggle Button
local function createToggle(text,posY,parent)
    local btn = Instance.new("TextButton")
    btn.Text = text..": OFF"
    btn.Size = UDim2.new(0,200,0,25)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    return btn
end

-- Left-side toggles
local AimbotBtn = createToggle("Aimbot",10,MainTab)
local OrbitBtn = createToggle("Orbit",45,MainTab)
local TriggerBtn = createToggle("Triggerbot",270,MainTab)

-- Divider on right side
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0,2,1,0)
Divider.Position = UDim2.new(0.75,0,0,0)
Divider.BackgroundColor3 = Color3.fromRGB(155,115,255)
Divider.BorderSizePixel = 0
Divider.Parent = MainTab

-- Right-side toggles
local ShootBtn = createToggle("Shoot the Shooter",60,MainTab)
ShootBtn.Position = UDim2.new(0.76,0,0,60)
local TPBtn = createToggle("TP Toggle",100,MainTab)
TPBtn.Position = UDim2.new(0.76,0,0,100)

-- Gun dropdown with search
local GunDropdownBtn = Instance.new("TextButton")
GunDropdownBtn.Text = "Gun: "..State.SelectedGun
GunDropdownBtn.Size = UDim2.new(0,150,0,25)
GunDropdownBtn.Position = UDim2.new(0.76,0,0,140)
GunDropdownBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
GunDropdownBtn.TextColor3 = Color3.fromRGB(220,220,220)
GunDropdownBtn.BorderSizePixel = 0
GunDropdownBtn.Parent = MainTab

local GunDropdownOpen = false
local GunDropdownFrame = Instance.new("Frame")
GunDropdownFrame.Size = UDim2.new(0,150,0,#DaHoodGuns*25+30)
GunDropdownFrame.Position = UDim2.new(0,0,0,25)
GunDropdownFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
GunDropdownFrame.BorderSizePixel = 0
GunDropdownFrame.Visible = false
GunDropdownFrame.Parent = GunDropdownBtn

-- Search bar
local SearchBox = Instance.new("TextBox")
SearchBox.PlaceholderText = "Search gun..."
SearchBox.Size = UDim2.new(1,-10,0,25)
SearchBox.Position = UDim2.new(0,5,0,0)
SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
SearchBox.TextColor3 = Color3.fromRGB(220,220,220)
SearchBox.BorderSizePixel = 0
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = GunDropdownFrame

local function refreshGunList()
    for i,v in pairs(GunDropdownFrame:GetChildren()) do
        if v:IsA("TextButton") and v ~= SearchBox then v:Destroy() end
    end
    local y = 30
    local filter = string.lower(SearchBox.Text)
    for _,gun in ipairs(DaHoodGuns) do
        if string.find(string.lower(gun),filter) then
            local option = Instance.new("TextButton")
            option.Text = gun
            option.Size = UDim2.new(1,0,0,25)
            option.Position = UDim2.new(0,0,0,y)
            option.BackgroundColor3 = Color3.fromRGB(40,40,45)
            option.TextColor3 = Color3.fromRGB(220,220,220)
            option.BorderSizePixel = 0
            option.Parent = GunDropdownFrame

            option.MouseButton1Click:Connect(function()
                State.SelectedGun = gun
                GunDropdownBtn.Text = "Gun: "..gun
                GunDropdownFrame.Visible = false
                GunDropdownOpen = false
            end)
            y = y + 25
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshGunList)
refreshGunList()

GunDropdownBtn.MouseButton1Click:Connect(function()
    GunDropdownOpen = not GunDropdownOpen
    GunDropdownFrame.Visible = GunDropdownOpen
end)

-- ================= SLIDERS =================
local function createSlider(name,posY,min,max,parent)
    local label = Instance.new("TextLabel")
    label.Text = name..": "..min
    label.Size = UDim2.new(0,200,0,20)
    label.Position = UDim2.new(0,10,0,posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Parent = parent

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,200,0,5)
    bar.Position = UDim2.new(0,10,0,posY+20)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    bar.Parent = parent

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0,10,0,10)
    handle.Position = UDim2.new(0,0,0,posY+17)
    handle.BackgroundColor3 = Color3.fromRGB(155,115,255)
    handle.Parent = parent

    return {label=label,bar=bar,handle=handle,min=min,max=max,value=min}
end

local OrbitSpeedSlider = createSlider("Orbit Speed",80,1,20,MainTab)
local OrbitDistanceSlider = createSlider("Orbit Distance",125,1,50,MainTab)

-- Orbit Mode dropdown
local OrbitModeBtn = Instance.new("TextButton")
OrbitModeBtn.Text = "Orbit Mode: "..State.OrbitMode
OrbitModeBtn.Size = UDim2.new(0,200,0,25)
OrbitModeBtn.Position = UDim2.new(0,10,0,170)
OrbitModeBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
OrbitModeBtn.TextColor3 = Color3.fromRGB(220,220,220)
OrbitModeBtn.BorderSizePixel = 0
OrbitModeBtn.Parent = MainTab

-- Keybind
local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Text = "Toggle Key: "..State.ToggleKey.Name
KeybindBtn.Size = UDim2.new(0,200,0,25)
KeybindBtn.Position = UDim2.new(0,10,0,305)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
KeybindBtn.TextColor3 = Color3.fromRGB(220,220,220)
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Parent = MainTab

-- ================= INPUT LOGIC =================
-- Tab switching
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        UI.CurrentTab = name
        for _,tab in pairs(TabsFrames) do
            tab.Visible = false
        end
        TabsFrames[name].Visible = true
    end)
end

-- Toggles
local function setupToggle(btn, stateKey)
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.Text = btn.Text:match("^(.-):")..": "..(State[stateKey] and "ON" or "OFF")
    end)
end

setupToggle(AimbotBtn,"Aimbot")
setupToggle(OrbitBtn,"Orbit")
setupToggle(TriggerBtn,"Triggerbot")
setupToggle(ShootBtn,"ShootShooter")
setupToggle(TPBtn,"TP")

-- Orbit Mode
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
