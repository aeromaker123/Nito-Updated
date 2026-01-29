-- Clean Da Hood GUI Framework (Safe & Stable)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ===== STATE =====
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
}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CleanDaHoodGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 460)
Main.Position = UDim2.new(0.5, -180, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
Main.BorderColor3 = Color3.fromRGB(70,70,70)
Main.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Da Hood GUI (Framework)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
Title.Parent = Main

-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, 0, 0, 40)
Tabs.Position = UDim2.new(0,0,0,40)
Tabs.BackgroundColor3 = Color3.fromRGB(50,50,50)
Tabs.Parent = Main

local function TabButton(text, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,110,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = text
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(65,65,65)
	b.BorderColor3 = Color3.fromRGB(90,90,90)
	b.Parent = Tabs
	return b
end

local ControlsBtn = TabButton("Controls", 5)
local VisualsBtn  = TabButton("Visuals", 120)
local MiscBtn     = TabButton("Misc", 235)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-80)
Content.Position = UDim2.new(0,0,0,80)
Content.BackgroundColor3 = Color3.fromRGB(40,40,40)
Content.Parent = Main

local function NewTab()
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1,0,1,0)
	f.BackgroundTransparency = 1
	f.Visible = false
	f.Parent = Content
	return f
end

local Controls = NewTab()
local Visuals  = NewTab()
local Misc     = NewTab()
Controls.Visible = true

local function Switch(tab)
	Controls.Visible = false
	Visuals.Visible = false
	Misc.Visible = false
	tab.Visible = true
end

ControlsBtn.MouseButton1Click:Connect(function() Switch(Controls) end)
VisualsBtn.MouseButton1Click:Connect(function() Switch(Visuals) end)
MiscBtn.MouseButton1Click:Connect(function() Switch(Misc) end)

-- Toggle creator
local function Toggle(parent, label, y, key)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,32)
	btn.Position = UDim2.new(0,10,0,y)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.BorderColor3 = Color3.fromRGB(90,90,90)
	btn.Parent = parent

	local function Refresh()
		btn.Text = label .. ": " .. (State[key] and "ON" or "OFF")
	end

	btn.MouseButton1Click:Connect(function()
		State[key] = not State[key]
		Refresh()
		print(label, State[key])
	end)

	Refresh()
end

-- Controls
Toggle(Controls,"Aimbot",20,"Aimbot")
Toggle(Controls,"Triggerbot",60,"Triggerbot")
Toggle(Controls,"Speed",100,"Speed")

-- Visuals
Toggle(Visuals,"ESP",20,"ESP")
Toggle(Visuals,"Radar",60,"Radar")
Toggle(Visuals,"Name Tags",100,"NameTags")

-- Misc
Toggle(Misc,"Auto Respawn",20,"AutoRespawn")
Toggle(Misc,"Auto Pickup",60,"AutoPickup")
Toggle(Misc,"Auto Reload",100,"AutoReload")

-- Hide GUI with RightShift
UserInputService.InputBegan:Connect(function(input,gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Main.Visible = not Main.Visible
	end
end)

print("Clean GUI loaded successfully")
