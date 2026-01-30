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
local TriggerBtn = createToggle("Triggerbot",80,MainTab)

-- Divider on right side
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0,2,1,0)
Divider.Position = UDim2.new(0.74,0,0,0)
Divider.BackgroundColor3 = Color3.fromRGB(155,115,255)
Divider.BorderSizePixel = 0
Divider.Parent = MainTab

-- Right-side toggles and dropdown container
local RightColumnX = 0.76
local RightStartY = 10
local RightSpacing = 40

local ShootBtn = createToggle("Shoot the Shooter",RightStartY,MainTab)
ShootBtn.Position = UDim2.new(RightColumnX,0,0,RightStartY)

local TPBtn = createToggle("TP Toggle",RightStartY+RightSpacing,MainTab)
TPBtn.Position = UDim2.new(RightColumnX,0,0,RightStartY+RightSpacing)

-- Gun dropdown with search
local GunDropdownBtn = Instance.new("TextButton")
GunDropdownBtn.Text = "Gun: "..State.SelectedGun
GunDropdownBtn.Size = UDim2.new(0,150,0,25)
GunDropdownBtn.Position = UDim2.new(RightColumnX,0,0,RightStartY+2*RightSpacing)
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

-- Refresh gun list function
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
