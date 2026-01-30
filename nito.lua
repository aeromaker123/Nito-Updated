-- Nito Defense Menu (UI Only)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if it exists
if PlayerGui:FindFirstChild("NitoGUI") then
    PlayerGui.NitoGUI:Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "NitoGUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Main Frame
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(0.35, 0.45)
main.Position = UDim2.fromScale(0.325, 0.275)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "NITO — DEFENSE SYSTEM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Container
local container = Instance.new("Frame")
container.Parent = main
container.Position = UDim2.new(0, 0, 0, 60)
container.Size = UDim2.new(1, 0, 1, -70)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = container
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Toggle creator
local function createToggle(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Text = text .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and " : ON" or " : OFF")
        btn.BackgroundColor3 = enabled
            and Color3.fromRGB(60, 120, 255)
            or Color3.fromRGB(35, 35, 50)
        print(text, enabled)
    end)

    btn.Parent = container
end

-- Toggles
createToggle("Defense Mode")
createToggle("Auto Counter")
createToggle("Auto Equip Weapon")
createToggle("Auto Buy Weapon")
createToggle("Auto Stomp")

-- Footer
local footer = Instance.new("TextLabel")
footer.Parent = main
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Text = "Status: UI Loaded"
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
