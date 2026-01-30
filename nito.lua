-- MainTab container sizes
local LeftColumnWidth = 0.45
local RightColumnWidth = 0.5
local Padding = 10

-- Clear old children (optional)
for _,v in pairs(MainTab:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextButton") then
        v:Destroy()
    end
end

-- Left-side container
local LeftColumn = Instance.new("Frame")
LeftColumn.Size = UDim2.new(LeftColumnWidth, -Padding, 1, -Padding)
LeftColumn.Position = UDim2.new(0, Padding, 0, Padding)
LeftColumn.BackgroundTransparency = 1
LeftColumn.Parent = MainTab

-- Right-side container
local RightColumn = Instance.new("Frame")
RightColumn.Size = UDim2.new(RightColumnWidth, -Padding, 1, -Padding)
RightColumn.Position = UDim2.new(LeftColumnWidth, Padding, 0, Padding)
RightColumn.BackgroundTransparency = 1
RightColumn.Parent = MainTab

-- Left toggles
local y = 0
for _,name in ipairs({"Aimbot","Orbit","Triggerbot"}) do
    local btn = createToggle(name, y, LeftColumn)
    btn.Position = UDim2.new(0,0,0,y)
    y = y + 35
end

-- Sliders inside left column
local OrbitSpeedSlider = createSlider("Orbit Speed",y,1,20,LeftColumn)
y = y + 55
local OrbitDistanceSlider = createSlider("Orbit Distance",y,1,50,LeftColumn)
y = y + 55

-- Orbit mode dropdown
local OrbitModeBtn = Instance.new("TextButton")
OrbitModeBtn.Text = "Orbit Mode: "..State.OrbitMode
OrbitModeBtn.Size = UDim2.new(1,0,0,25)
OrbitModeBtn.Position = UDim2.new(0,0,0,y)
OrbitModeBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
OrbitModeBtn.TextColor3 = Color3.fromRGB(220,220,220)
OrbitModeBtn.BorderSizePixel = 0
OrbitModeBtn.Parent = LeftColumn
y = y + 35

-- Keybind button
local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Text = "Toggle Key: "..State.ToggleKey.Name
KeybindBtn.Size = UDim2.new(1,0,0,25)
KeybindBtn.Position = UDim2.new(0,0,0,y)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
KeybindBtn.TextColor3 = Color3.fromRGB(220,220,220)
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Parent = LeftColumn

-- Right-side toggles
local ry = 0
for _,name in ipairs({"Shoot the Shooter","TP Toggle"}) do
    local btn = createToggle(name, ry, RightColumn)
    btn.Position = UDim2.new(0,0,0,ry)
    ry = ry + 35
end

-- Gun dropdown with search inside right column
local GunDropdownBtn = Instance.new("TextButton")
GunDropdownBtn.Text = "Gun: "..State.SelectedGun
GunDropdownBtn.Size = UDim2.new(1,0,0,25)
GunDropdownBtn.Position = UDim2.new(0,0,0,ry)
GunDropdownBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
GunDropdownBtn.TextColor3 = Color3.fromRGB(220,220,220)
GunDropdownBtn.BorderSizePixel = 0
GunDropdownBtn.Parent = RightColumn
ry = ry + 30

local GunDropdownFrame = Instance.new("Frame")
GunDropdownFrame.Size = UDim2.new(1,0,0,#DaHoodGuns*25+30)
GunDropdownFrame.Position = UDim2.new(0,0,0,25)
GunDropdownFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
GunDropdownFrame.BorderSizePixel = 0
GunDropdownFrame.Visible = false
GunDropdownFrame.Parent = GunDropdownBtn

-- Search box
local SearchBox = Instance.new("TextBox")
SearchBox.PlaceholderText = "Search gun..."
SearchBox.Size = UDim2.new(1,-10,0,25)
SearchBox.Position = UDim2.new(0,5,0,0)
SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,45)
SearchBox.TextColor3 = Color3.fromRGB(220,220,220)
SearchBox.BorderSizePixel = 0
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = GunDropdownFrame

-- Gun list refresh
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
            end)
            y = y + 25
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshGunList)
refreshGunList()

GunDropdownBtn.MouseButton1Click:Connect(function()
    GunDropdownFrame.Visible = not GunDropdownFrame.Visible
end)
