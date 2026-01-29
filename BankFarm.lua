-- Da Hood Auto Robbery Script (FIXED)
-- Safer teleporting, no PrimaryPart crashes, better searching

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function getChar()
    character = player.Character or player.CharacterAdded:Wait()
    return character
end

local function getRoot()
    return getChar():WaitForChild("HumanoidRootPart")
end

-- Safe teleport function
local function tp(cf)
    local root = getRoot()
    if root then
        root.CFrame = cf + Vector3.new(0, 3, 0)
    end
end

-- Recursive finder
local function find(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == name then
            return v
        end
    end
end

--------------------------------------------------
-- Flame Thrower + Ammo
--------------------------------------------------
function getFlameThrower()
    local flamer = find("FlameThrower") or find("Flame Thrower")
    if not flamer then
        warn("Flame Thrower not found")
        return false
    end

    if flamer:IsA("BasePart") then
        tp(flamer.CFrame)
    elseif flamer:IsA("Model") and flamer.PrimaryPart then
        tp(flamer.PrimaryPart.CFrame)
    end

    task.wait(1)

    local ammo = find("Ammo")
    if ammo and ammo:IsA("BasePart") then
        tp(ammo.CFrame)
        task.wait(1)
    end

    return true
end

--------------------------------------------------
-- LMG
--------------------------------------------------
function getLMG()
    local lmg = find("LMG")
    if not lmg then
        warn("LMG not found")
        return false
    end

    if lmg:IsA("BasePart") then
        tp(lmg.CFrame)
    elseif lmg:IsA("Model") and lmg.PrimaryPart then
        tp(lmg.PrimaryPart.CFrame)
    end

    print("Got LMG")
    return true
end

--------------------------------------------------
-- Bank Doors
--------------------------------------------------
function breakBankDoors()
    local doorsFolder = find("Bank Doors")
    if not doorsFolder then
        warn("No bank doors found")
        return false
    end

    for _, door in ipairs(doorsFolder:GetChildren()) do
        if door:IsA("BasePart") then
            tp(door.CFrame)
            task.wait(1.5)
        end
    end

    return true
end

--------------------------------------------------
-- Small Safes
--------------------------------------------------
function breakLittleSafes()
    local safes = find("Safes")
    if not safes then
        warn("No safes found")
        return false
    end

    for _, safe in ipairs(safes:GetChildren()) do
        if safe:IsA("BasePart") and not safe.Name:lower():find("big") then
            tp(safe.CFrame)
            task.wait(1.5)
        end
    end

    return true
end

--------------------------------------------------
-- Collect Money
--------------------------------------------------
function collectMoney()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "Money" or v.Name == "Cash" or v.Name == "Coin" then
            if v:IsA("BasePart") then
                tp(v.CFrame)
                task.wait(0.4)
            end
        end
    end
end

--------------------------------------------------
-- Main
--------------------------------------------------
function runRobbery()
    print("Starting Da Hood Auto Robbery")

    if not getFlameThrower() then return end
    task.wait(1)

    if not getLMG() then return end
    task.wait(1)

    breakBankDoors()
    task.wait(1)

    breakLittleSafes()
    task.wait(1)

    collectMoney()
    print("Robbery Complete")
end

task.spawn(runRobbery)

--------------------------------------------------
-- Background Auto Collect
--------------------------------------------------
task.spawn(function()
    while task.wait(8) do
        collectMoney()
    end
end)

print("Da Hood Auto Robbery Script Loaded (Fixed)")
