-- Nito Defense | Elite Menu (UI-Only)
-- Place as a LocalScript in StarterPlayerScripts

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- STATE
-- =========================
local State = {
    DefenseMode = false,
    AutoCounter = false,
    AutoEquip = false,
    AutoBuy = false,
    AutoStomp = false,
    SelectedWeapon = "None",
    GUIVisible = true
}

-- =========================
-- THEME
-- =========================
local Theme = {
    Bg = Color3.fromRGB(16,16,18),
    Panel = Color3.fromRGB(22,22,26),
    Accent = Color3.fromRGB(120, 90, 255),
    Text = Color3.fromRGB(235,235,235),
    Muted = Color3.fromRGB(150,150,160),
    On = Color3.fromRGB(90, 200, 140),
    Off = Color3.fromRGB(200, 90, 90)
}

-- =========================
-- GUI ROOT
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NitoDefenseGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(360, 420)
Main.Position = UDim2.fromScale(0.06, 0.18)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 14)

-- =========================
-- HEADER
-- =========================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,54)
Header.BackgroundColor3 = Theme.Panel
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-24,1,0)
Title.Position = UDim2.fromOffset(12,0)
Title.Text = "Nito  •  Defense"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Theme.Text
Title.TextXAlignment = Left
Title.Parent = Header

-- =========================
-- CONTENT
-- =========================
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(0,64)
Content.Size = UDim2.new(1,0,1,-74)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0,10)

local function pad(h)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1,-24,0,h)
    p.BackgroundTransparency = 1
    p.Parent = Content
end

pad(0)

-- =========================
-- HELPERS
-- =========================
local function makeRow(height)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1,-24,0,height)
    r.BackgroundColor3 = Theme.Panel
    r.BorderSizePixel = 0
    Instance.new("UICorner", r).CornerRadius = UDim.new(0,12)
    r.Parent = Content
    return r
end

local function toggleRow(text, key)
    local row = makeRow(52)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-120,1,0)
    lbl.Position = UDim2.fromOffset(14,0)
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextColor3 = Theme.Text
    lbl.TextXAlignment = Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(84,30)
    btn.Position = UDim2.new(1,-98,0.5,-15)
    btn.BackgroundColor3 = State[key] and Theme.On or Theme.Off
    btn.BorderSizePixel = 0
    btn.Text = State[key] and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        btn.Text = State[key] and "ON" or "OFF"
        btn.BackgroundColor3 = State[key] and Theme.On or Theme.Off
        print("[Nito] "..text..":", State[key])
    end)
end

local function dropdownRow(labelText, options)
    local row = makeRow(62)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-120,1,0)
    lbl.Position = UDim2.fromOffset(14,0)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextColor3 = Theme.Text
    lbl.TextXAlignment = Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(140,34)
    btn.Position = UDim2.new(1,-154,0.5,-17)
    btn.BackgroundColor3 = Theme.Bg
    btn.BorderSizePixel = 0
    btn.Text = State.SelectedWeapon
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Theme.Text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.Parent = row

    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx += 1
        if idx > #options then idx = 1 end
        State.SelectedWeapon = options[idx]
        btn.Text = State.SelectedWeapon
        print("[Nito] Selected weapon:", State.SelectedWeapon)
    end)
end

local function statusRow()
    local row = makeRow(80)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-24,1,-12)
    lbl.Position = UDim2.fromOffset(12,6)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Theme.Muted
    lbl.TextXAlignment = Left
    lbl.TextYAlignment = Top
    lbl.TextWrapped = true
    lbl.Parent = row

    local function refresh()
        lbl.Text =
            "Status\n"..
            "Defense: "..(State.DefenseMode and "ON" or "OFF")..
            "  |  Weapon: "..State.SelectedWeapon.."\n"..
            "AutoCounter: "..tostring(State.AutoCounter)..
            "  AutoEquip: "..tostring(State.AutoEquip)..
            "  AutoBuy: "..tostring(State.AutoBuy)..
            "  AutoStomp: "..tostring(State.AutoStomp)
    end

    refresh()
    for k,_ in pairs(State) do
        -- lightweight refresh
        task.spawn(function()
            while true do
                refresh()
                task.wait(0.4)
            end
        end)
        break
    end
end

-- =========================
-- BUILD MENU
-- =========================
toggleRow("Defense Mode", "DefenseMode")
toggleRow("Auto Counter", "AutoCounter")
toggleRow("Auto Equip Weapon", "AutoEquip")
toggleRow("Auto Buy Weapon", "AutoBuy")
toggleRow("Auto Stomp", "AutoStomp")

dropdownRow("Weapon Selector", {
    "None",
    "Revolver",
    "Shotgun",
    "SMG",
    "AR",
    "Knife"
})

statusRow()

-- =========================
-- HOTKEYS
-- =========================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F2 then
        State.GUIVisible = not State.GUIVisible
        ScreenGui.Enabled = State.GUIVisible
        print("[Nito] GUI:", State.GUIVisible)
    end
end)

print("Nito Defense Menu loaded. F2 toggles GUI.")
