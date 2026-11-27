-- Archery Duels Diagnostic V2
-- Read-only: does not fire arrows, alter aim, or invoke remotes.
-- Output: Archery_Duels_Diagnostic_V2.txt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function vec(v)
    if typeof(v) ~= "Vector3" then return "nil" end
    return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
end

local function safe(fn, fallback)
    local ok, value = pcall(fn)
    if ok then return value end
    return fallback
end

local lines = {}
local function add(s) lines[#lines + 1] = tostring(s) end

add("=== ARCHERY DUELS DIAGNOSTIC V2 ===")
add("PlaceId: " .. tostring(game.PlaceId))
add("Player: " .. LocalPlayer.Name .. " | UserId: " .. LocalPlayer.UserId)
add("Gravity: " .. tostring(Workspace.Gravity))

local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
local tool = char and char:FindFirstChildOfClass("Tool")
add("-- LOCAL --")
add("Root: " .. vec(root and root.Position))
add("Head: " .. vec(head and head.Position))
add("RootVelocity: " .. vec(root and root.AssemblyLinearVelocity))
add("Tool: " .. tostring(tool and tool.Name))
if Camera then
    add("CameraPos: " .. vec(Camera.CFrame.Position))
    add("CameraLook: " .. vec(Camera.CFrame.LookVector))
    add("FOV: " .. tostring(Camera.FieldOfView))
end

add("-- PLAYERS --")
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        local c = plr.Character
        local h = c and c:FindFirstChild("Head")
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if h or r then
            add(string.format("%s | Head=%s | Root=%s | Vel=%s | HP=%s",
                plr.Name, vec(h and h.Position), vec(r and r.Position),
                vec(r and r.AssemblyLinearVelocity),
                hum and string.format("%.0f/%.0f", hum.Health, hum.MaxHealth) or "nil"))
        else
            add(plr.Name .. " | Character/Head not streamed")
        end
    end
end

local folder = Workspace:FindFirstChild("ArcheryTrajectory")
add("-- TRAJECTORY SNAPSHOT --")
if folder then
    local dots = {}
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "trajectory") or (obj:IsA("BasePart") and obj.Name == "TrajectoryDot") then
            dots[#dots + 1] = obj
        end
    end
    table.sort(dots, function(a,b)
        local da = root and (a.Position-root.Position).Magnitude or 0
        local db = root and (b.Position-root.Position).Magnitude or 0
        return da < db
    end)
    add("DotCount: " .. #dots)
    for i = 1, math.min(#dots, 12) do
        add(string.format("Dot%d: %s", i, vec(dots[i].Position)))
    end
else
    add("ArcheryTrajectory folder missing")
end

add("-- LIVE AIM SAMPLING (2.5s, 0.1s interval) --")
for sample = 1, 25 do
    local cf = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame
    local currentFolder = Workspace:FindFirstChild("ArcheryTrajectory")
    local pts = {}
    if currentFolder then
        for _, obj in ipairs(currentFolder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "TrajectoryDot" then
                pts[#pts + 1] = obj.Position
            end
        end
    end
    table.sort(pts, function(a,b)
        if root then return (a-root.Position).Magnitude < (b-root.Position).Magnitude end
        return a.Z < b.Z
    end)
    local p1 = pts[1]
    local pm = pts[math.max(1, math.floor(#pts/2))]
    local plast = pts[#pts]
    add(string.format("T%02d | dots=%d | camLook=%s | first=%s | mid=%s | last=%s",
        sample, #pts, vec(cf and cf.LookVector), vec(p1), vec(pm), vec(plast)))
    task.wait(0.1)
end

add("-- END --")
local output = table.concat(lines, "\n")
local saved = pcall(function()
    if writefile then writefile("Archery_Duels_Diagnostic_V2.txt", output) end
end)
local copied = pcall(function()
    if setclipboard then setclipboard(output) end
end)
if not saved and not copied then
    warn("Diagnostic complete, but writefile/setclipboard unavailable.")
else
    print("Archery Duels Diagnostic V2 complete. " ..
        (saved and "Saved file. " or "") .. (copied and "Copied to clipboard." or ""))
end
