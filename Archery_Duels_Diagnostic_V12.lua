-- ARCHERY DUELS DIAGNOSTIC V12
-- READ-ONLY: compares local character, owned clone, enemy clone lanes,
-- bow/tool origin, camera, and nearby projectile/target objects.
-- No firing, remotes, aim changes, or movement.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local started = os.clock()
local lines = {}
local function add(s) lines[#lines + 1] = tostring(s) end
local function xyz(v)
    if not v then return "nil" end
    return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
end
local function fullName(o)
    local ok, result = pcall(function() return o:GetFullName() end)
    return ok and result or o.Name
end
local function rootOf(m)
    if not m then return nil end
    return m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
end
local function addPart(label, p)
    if p and p:IsA("BasePart") then
        add(label .. "=" .. xyz(p.Position) .. " | " .. fullName(p))
    else
        add(label .. "=nil")
    end
end

add("=== ARCHERY DUELS DIAGNOSTIC V12 ===")
add("READ-ONLY | PlaceId=" .. game.PlaceId .. " | Player=" .. player.Name .. "/" .. player.UserId)
local char = player.Character
local charRoot = rootOf(char)
local charHead = char and char:FindFirstChild("Head")
add("-- LOCAL CHARACTER --")
addPart("CharacterRoot", charRoot)
addPart("CharacterHead", charHead)
if charRoot and charHead then
    add("HeadToRoot=" .. string.format("%.2f", (charHead.Position - charRoot.Position).Magnitude))
end

local camera = Workspace.CurrentCamera
add("-- CAMERA --")
if camera then
    add("CameraPosition=" .. xyz(camera.CFrame.Position))
    add("CameraLook=" .. xyz(camera.CFrame.LookVector))
    add("CameraSubject=" .. tostring(camera.CameraSubject))
end

add("-- EQUIPPED TOOL --")
local tool
if char then
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then tool = child break end
    end
end
add("Tool=" .. (tool and tool.Name or "nil"))
if tool then
    local handle = tool:FindFirstChild("Handle")
    addPart("ToolHandle", handle)
    local n = 0
    for _, d in ipairs(tool:GetDescendants()) do
        if d:IsA("BasePart") and d ~= handle and n < 8 then
            n += 1
            addPart("ToolPart" .. n, d)
        end
    end
end

add("-- OWNED CLONE COMPARISON --")
local ownClone = Workspace:FindFirstChild("PlayerClone_" .. player.Name)
if ownClone then
    local ownRoot = rootOf(ownClone)
    local ownHead = ownClone:FindFirstChild("Head")
    add("OwnClone=" .. fullName(ownClone))
    addPart("OwnCloneRoot", ownRoot)
    addPart("OwnCloneHead", ownHead)
    if charRoot and ownRoot then
        add("CharacterToOwnClone=" .. string.format("%.2f", (charRoot.Position - ownRoot.Position).Magnitude))
        add("CharacterMinusClone=" .. xyz(charRoot.Position - ownRoot.Position))
    end
else
    add("OwnClone=nil")
end

add("-- ALL CLONE LANES --")
local cloneCount = 0
for _, obj in ipairs(Workspace:GetChildren()) do
    if obj:IsA("Model") and obj.Name:match("^PlayerClone_") then
        cloneCount += 1
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local head = obj:FindFirstChild("Head")
        local rt = rootOf(obj)
        local p = (head and head:IsA("BasePart") and head.Position) or (rt and rt.Position)
        local ownerName = obj.Name:gsub("^PlayerClone_", "")
        local owner = Players:FindFirstChild(ownerName)
        local hp = hum and string.format("%.0f/%.0f", hum.Health, hum.MaxHealth) or "no-humanoid"
        local offset = (p and charRoot) and (p - charRoot.Position) or nil
        add(string.format("%02d) %s | Owner=%s | HP=%s | Parts=%d | Anchor=%s | DeltaFromCharacter=%s",
            cloneCount, obj.Name, owner and (owner.Name .. "/" .. owner.UserId) or "not-in-Players",
            hp, #obj:GetDescendants(), xyz(p), xyz(offset)))
    end
end
add("CloneCount=" .. cloneCount)

add("-- TRAJECTORY PREVIEW --")
local folder = Workspace:FindFirstChild("ArcheryTrajectory")
local dots = {}
if folder then
    for _, d in ipairs(folder:GetDescendants()) do
        if d:IsA("BasePart") and d.Name == "TrajectoryDot" then
            table.insert(dots, d)
        end
    end
end
add("TrajectoryFolder=" .. (folder and fullName(folder) or "nil") .. " | DotCount=" .. #dots)
if #dots > 0 then
    local minX, maxX, minY, maxY, minZ, maxZ
    local sum = Vector3.zero
    for _, d in ipairs(dots) do
        local p = d.Position
        sum += p
        minX = minX and math.min(minX, p.X) or p.X
        maxX = maxX and math.max(maxX, p.X) or p.X
        minY = minY and math.min(minY, p.Y) or p.Y
        maxY = maxY and math.max(maxY, p.Y) or p.Y
        minZ = minZ and math.min(minZ, p.Z) or p.Z
        maxZ = maxZ and math.max(maxZ, p.Z) or p.Z
    end
    add("DotCentroid=" .. xyz(sum / #dots))
    add(string.format("DotBounds X=%.2f..%.2f Y=%.2f..%.2f Z=%.2f..%.2f", minX, maxX, minY, maxY, minZ, maxZ))
    for i = 1, math.min(4, #dots) do addPart("Dot" .. i, dots[i]) end
end

add("-- WORKSPACE OBJECT NAME SCAN --")
local keywords = {"arrow", "projectile", "target", "dummy", "bow", "trajectory"}
local found, seen = 0, {}
for _, d in ipairs(Workspace:GetDescendants()) do
    if found >= 45 then break end
    local low = string.lower(d.Name)
    local match = false
    for _, k in ipairs(keywords) do
        if string.find(low, k, 1, true) then match = true break end
    end
    if match and not seen[d] then
        seen[d] = true
        found += 1
        local pos = d:IsA("BasePart") and xyz(d.Position) or "n/a"
        local attrs = {}
        for k, v in pairs(d:GetAttributes()) do
            if #attrs < 5 then table.insert(attrs, k .. "=" .. tostring(v)) end
        end
        add(string.format("%02d) %s | %s | Pos=%s | Attr=%s",
            found, d.ClassName, fullName(d), pos, #attrs > 0 and table.concat(attrs, ", ") or "none"))
    end
end
add("NameMatches=" .. found)
add("-- END --")
local output = table.concat(lines, "\n")
if writefile then pcall(writefile, "Archery_Duels_Diagnostic_V12.txt", output) end
if setclipboard then pcall(setclipboard, output) end
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Archery Duels V12",
        Text = "Read-only report copied to clipboard",
        Duration = 5
    })
end)
print(output)
