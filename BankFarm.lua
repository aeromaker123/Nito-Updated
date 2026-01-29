-- DA HOOD AUTO ROBBERY — MAX LEVEL CORE
-- Hardened, loopable, anti-death, expandable

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--------------------------------------------------
-- CHARACTER HANDLING
--------------------------------------------------
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    return getChar():WaitForChild("HumanoidRootPart")
end

local function alive()
    local hum = getChar():FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

--------------------------------------------------
-- SAFE TELEPORT
--------------------------------------------------
local function safeTP(cf)
    if not alive() then return end
    local root = getRoot()
    root.Velocity = Vector3.zero
    root.CFrame = cf + Vector3.new(0, 4, 0)
end

--------------------------------------------------
-- DESCENDANT FINDER
--------------------------------------------------
local function find(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == name then
            return v
        end
    end
end

local function findAll(name)
    local t = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == name then
            table.insert(t, v)
        end
    end
    return t
end

--------------------------------------------------
-- TOOL HANDLING
--------------------------------------------------
local function equip(toolName)
    local char = getChar()
    local bp = player.Backpack:FindFirstChild(toolName)
    if bp then
        bp.Parent = char
        task.wait(0.2)
        return true
    end
end

--------------------------------------------------
-- AUTO FIRE (REMOTE STUB)
--------------------------------------------------
local function fireTool()
    -- 🔥 YOU PATCH THIS WITH REMOTE CALL
    -- Example (NOT REAL):
    -- ReplicatedStorage.MainEvent:FireServer("Fire", target)

    task.wait(0.15)
end

--------------------------------------------------
-- FLAMETHROWER + AMMO
--------------------------------------------------
local function getFlame()
    local flamer = find("FlameThrower") or find("Flame Thrower")
    if not flamer then return end

    if flamer:IsA("BasePart") then
        safeTP(flamer.CFrame)
    elseif flamer:IsA("Model") and flamer.PrimaryPart then
        safeTP(flamer.PrimaryPart.CFrame)
    end

    task.wait(0.6)
    equip("FlameThrower")
end

--------------------------------------------------
-- BANK DOORS
--------------------------------------------------
local function breakDoors()
    local doors = find("Bank Doors")
    if not doors then return end

    equip("FlameThrower")

    for _, door in ipairs(doors:GetChildren()) do
        if door:IsA("BasePart") then
            safeTP(door.CFrame)
            fireTool()
            task.wait(0.8)
        end
    end
end

--------------------------------------------------
-- SAFES
--------------------------------------------------
local function breakSafes()
    local safes = find("Safes")
    if not safes then return end

    equip("FlameThrower")

    for _, safe in ipairs(safes:GetChildren()) do
        if safe:IsA("BasePart") and not safe.Name:lower():find("big") then
            safeTP(safe.CFrame)
            fireTool()
            task.wait(0.7)
        end
    end
end

--------------------------------------------------
-- MONEY VACUUM
--------------------------------------------------
local function vacuumMoney()
    for _, cash in ipairs(findAll("Money")) do
        if cash:IsA("BasePart") then
            safeTP(cash.CFrame)
            task.wait(0.15)
        end
    end
end

--------------------------------------------------
-- ANTI VOID / RESET
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    if alive() then
        local root = getRoot()
        if root.Position.Y < -20 then
            root.CFrame = CFrame.new(0, 15, 0)
        end
    end
end)

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------
task.spawn(function()
    while task.wait(3) do
        if alive() then
            getFlame()
            breakDoors()
            breakSafes()
            vacuumMoney()
        end
    end
end)

print("🔥 DA HOOD AUTO ROBBERY — MAX CORE LOADED 🔥")
