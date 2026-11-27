-- ARCHERY DUELS DIAGNOSTIC
-- Read-only: does not fire, aim, invoke remotes, or modify game state.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local lines = {}
local function add(s) lines[#lines + 1] = tostring(s) end
local function vec(v)
    return string.format("(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z)
end
local function safePath(obj)
    local ok, result = pcall(function() return obj:GetFullName() end)
    return ok and result or obj.Name
end
local function getPos(obj)
    if not obj then return "nil" end
    if obj:IsA("BasePart") then return vec(obj.Position) end
    if obj:IsA("Model") then
        local ok, cf = pcall(function() return obj:GetPivot() end)
        if ok then return vec(cf.Position) end
    end
    return "n/a"
end

add("=== ARCHERY DUELS DIAGNOSTIC ===")
add("PlaceId: " .. tostring(game.PlaceId))
add("Player: " .. LocalPlayer.Name .. " | UserId: " .. tostring(LocalPlayer.UserId))
add("Gravity: " .. tostring(Workspace.Gravity))

local camera = Workspace.CurrentCamera
if camera then
    add("Camera: " .. vec(camera.CFrame.Position))
    add("CameraLook: " .. vec(camera.CFrame.LookVector))
    add("FOV: " .. tostring(camera.FieldOfView))
end

local char = LocalPlayer.Character
if char then
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    add("-- LOCAL CHARACTER --")
    add("Root: " .. getPos(root))
    add("Head: " .. getPos(head))
    add("MoveDirection: " .. (hum and vec(hum.MoveDirection) or "nil"))
    add("AssemblyLinearVelocity: " .. (root and vec(root.AssemblyLinearVelocity) or "nil"))
    local equipped = {}
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            equipped[#equipped + 1] = obj.Name
            for _, d in ipairs(obj:GetDescendants()) do
                if d:IsA("BasePart") then
                    add("ToolPart: " .. safePath(d) .. " | Pos=" .. getPos(d))
                end
            end
        end
    end
    add("EquippedTools: " .. (#equipped > 0 and table.concat(equipped, ", ") or "none"))
else
    add("Character: nil")
end

add("-- OTHER PLAYERS / HEAD TARGETS --")
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        local c = p.Character
        local h = c and c:FindFirstChild("Head")
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if c then
            add(string.format("%s | Head=%s | Root=%s | HP=%s | RootVel=%s",
                p.Name, getPos(h), getPos(r),
                hum and string.format("%.0f/%.0f", hum.Health, hum.MaxHealth) or "nil",
                r and vec(r.AssemblyLinearVelocity) or "nil"))
        end
    end
end

add("-- AIM / TRAJECTORY OBJECTS --")
local wanted = {
    AimDot = true, AimBar = true, FireButton = true, AimMedallion = true,
    TrajectoryDot = true, ArcheryTrajectory = true, PlayerArrow = true,
    StuckArrow = true, Arrow = true, Bow = true
}
local found = 0
for _, root in ipairs({Workspace, LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer, ReplicatedStorage}) do
    for _, obj in ipairs(root:GetDescendants()) do
        if wanted[obj.Name] then
            found = found + 1
            local extra = ""
            if obj:IsA("BasePart") then
                extra = " | Pos=" .. getPos(obj) .. " | Vel=" .. vec(obj.AssemblyLinearVelocity)
            elseif obj:IsA("GuiObject") then
                extra = " | Visible=" .. tostring(obj.Visible) .. " | Size=" .. tostring(obj.AbsoluteSize)
            end
            add(safePath(obj) .. " [" .. obj.ClassName .. "]" .. extra)
            if found >= 60 then break end
        end
    end
    if found >= 60 then break end
end
if found == 0 then add("No named aim/trajectory objects found") end

add("-- REMOTE NAMES ONLY (NOT CALLED) --")
local remoteCount = 0
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
        local n = string.lower(obj.Name)
        if string.find(n, "fire") or string.find(n, "aim") or string.find(n, "arrow") or string.find(n, "project") or string.find(n, "damage") then
            remoteCount = remoteCount + 1
            add(safePath(obj) .. " [" .. obj.ClassName .. "]")
            if remoteCount >= 30 then break end
        end
    end
end
if remoteCount == 0 then add("No matching remotes found") end

local report = table.concat(lines, "\n")
local saved = false
if typeof(writefile) == "function" then
    local ok = pcall(function() writefile("Archery_Duels_Diagnostic.txt", report) end)
    saved = ok
end
if typeof(setclipboard) == "function" then
    pcall(function() setclipboard(report) end)
end
if not saved then
    warn("Diagnostic could not save file. Report follows:\n" .. report)
else
    print("Diagnostic saved: Archery_Duels_Diagnostic.txt")
end
