-- ARCHERY DUELS DIAGNOSTIC - V3 CACHE-CHECK
-- BUILD: 2026-11-27-V3-TRAJECTORY
-- Read-only inspection. No remote calls, hooks, firing, or value changes.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local keys = {"aim","arrow","archer","archery","bow","shoot","fire","projectile","trajectory","power","angle","target","damage","attack","accuracy","duel","hit","velocity","charge"}
local out, seen = {}, 0
local function add(s)
    if seen >= 900 then return end
    seen += 1
    out[#out+1] = tostring(s)
end
local function relevant(s)
    s = string.lower(tostring(s))
    for _, k in ipairs(keys) do
        if s:find(k, 1, true) then return true end
    end
    return false
end
local function full(o)
    local ok, v = pcall(function() return o:GetFullName() end)
    return ok and v or o.Name
end
local function val(v)
    if typeof(v) == "Vector3" then
        return string.format("%.1f, %.1f, %.1f", v.X, v.Y, v.Z)
    end
    return tostring(v)
end

add("ARCHERY DUELS DIAGNOSTIC - V3")
add("BUILD: 2026-11-27-V3-TRAJECTORY")
add("SOURCE CHECK: archery_duels_diagnostic.lua")
add("PlaceId: "..game.PlaceId)
add("Player: "..LP.Name.." ("..LP.UserId..")")

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
add("Character: "..tostring(char ~= nil))
add("Position: "..(root and val(root.Position) or "N/A"))
add("Health: "..(hum and (hum.Health.."/"..hum.MaxHealth) or "N/A"))

local cam = Workspace.CurrentCamera
if cam then
    add("Camera: "..val(cam.CFrame.Position).." | Look: "..val(cam.CFrame.LookVector))
end

add("")
add("[TOOLS]")
local bag = LP:FindFirstChildOfClass("Backpack")
for _, container in ipairs({char, bag}) do
    if container then
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("Tool") then add(full(obj)) end
        end
    end
end

add("")
add("[MATCHING UI]")
local pg = LP:FindFirstChildOfClass("PlayerGui")
local uiN = 0
if pg then
    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("GuiObject") and relevant(obj.Name) then
            uiN += 1
            if uiN <= 45 then
                local txt = ""
                pcall(function() txt = obj.Text end)
                add(full(obj).." | "..obj.ClassName.." | text="..tostring(txt):sub(1,90).." | visible="..tostring(obj.Visible))
            end
        end
    end
end
add("UI matches: "..uiN)

add("")
add("[MATCHING REMOTES - NAMES/PATHS ONLY]")
local remoteN = 0
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj.ClassName == "UnreliableRemoteEvent") and relevant(obj.Name) then
        remoteN += 1
        if remoteN <= 45 then add(obj.ClassName.." | "..full(obj)) end
    end
end
add("Remote matches: "..remoteN)
add("Note: remotes were NOT invoked.")

add("")
add("[MATCHING WORLD OBJECTS]")
local worldN = 0
for _, obj in ipairs(Workspace:GetDescendants()) do
    if relevant(obj.Name) then
        worldN += 1
        if worldN <= 55 then
            local extra = ""
            if obj:IsA("BasePart") then
                extra = " | pos="..val(obj.Position)
            elseif obj:IsA("ValueBase") then
                extra = " | value="..val(obj.Value)
            end
            add(obj.ClassName.." | "..full(obj)..extra)
        end
    end
end
add("World matches: "..worldN)

add("")
add("[OTHER PLAYERS]")
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then
        local c = p.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local h = c and c:FindFirstChildOfClass("Humanoid")
        add(p.Name.." | pos="..(r and val(r.Position) or "N/A").." | hp="..(h and (h.Health.."/"..h.MaxHealth) or "N/A"))
    end
end


-- FOCUSED V2 SECTION: AIM UI + BOW STRUCTURE
add("")
add("[V2: AIM UI DETAILS]")
local function detail(o)
    add(full(o).." ["..o.ClassName.."]")
    if o:IsA("GuiObject") then
        add("  Visible="..tostring(o.Visible).." Active="..tostring(o.Active))
        add("  Position="..tostring(o.Position).." Size="..tostring(o.Size))
        add("  AbsolutePosition="..tostring(o.AbsolutePosition).." AbsoluteSize="..tostring(o.AbsoluteSize))
        add("  AnchorPoint="..tostring(o.AnchorPoint).." ZIndex="..o.ZIndex)
        if o:IsA("ImageLabel") or o:IsA("ImageButton") then
            add("  Image="..tostring(o.Image))
        end
    elseif o:IsA("ValueBase") then
        add("  Value="..val(o.Value))
    elseif o:IsA("BasePart") then
        add("  Position="..val(o.Position).." Size="..val(o.Size))
    end
    for k,v in pairs(o:GetAttributes()) do
        add("  Attribute "..k.."="..val(v))
    end
end

local fireGui = pg and pg:FindFirstChild("FireButtonGui")
if fireGui then
    local canvas = fireGui:FindFirstChild("Canvas")
    if canvas then
        for _,name in ipairs({"AimBar","FireButton","EasyAimHost"}) do
            local obj = canvas:FindFirstChild(name)
            if obj then
                detail(obj)
                for _,d in ipairs(obj:GetDescendants()) do
                    if d:IsA("GuiObject") or d:IsA("ValueBase") then detail(d) end
                end
            end
        end
    else
        add("FireButtonGui.Canvas NOT FOUND")
    end
else
    add("FireButtonGui NOT FOUND")
end

add("")
add("[V2: EQUIPPED BOW DETAILS]")
local equipped
if char then
    for _,obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then equipped=obj break end
    end
end
if equipped then
    add("Tool="..full(equipped).." Enabled="..tostring(equipped.Enabled).." RequiresHandle="..tostring(equipped.RequiresHandle))
    for _,d in ipairs(equipped:GetDescendants()) do
        if d:IsA("BasePart") or d:IsA("Attachment") or d:IsA("ValueBase")
        or d:IsA("Motor6D") or d:IsA("Weld") or d:IsA("Constraint")
        or d:IsA("Animation") then
            detail(d)
        end
    end
else
    add("No equipped Tool found")
end

add("")
add("[V2: AIM/FIRE LOCAL SCRIPT NAMES]")
local scriptN=0
if pg then
    for _,d in ipairs(pg:GetDescendants()) do
        local n=d:GetFullName():lower()
        if (d:IsA("LocalScript") or d:IsA("ModuleScript"))
        and (n:find("aim",1,true) or n:find("fire",1,true) or n:find("reactarenahud",1,true)) then
            scriptN=scriptN+1
            add(d.ClassName.." "..full(d))
        end
    end
end
add("Script matches="..scriptN)


add("")
add("[V3: ARCHERY TRAJECTORY DETAILS]")
local trajectoryFolder = Workspace:FindFirstChild("ArcheryTrajectory")
if trajectoryFolder then
    add("Folder="..full(trajectoryFolder).." children="..#trajectoryFolder:GetChildren())
    for _,obj in ipairs(trajectoryFolder:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Attachment") or obj:IsA("ValueBase") then
            add(obj.ClassName.." | "..full(obj))
            if obj:IsA("BasePart") then
                add("  Position="..val(obj.Position).." Size="..val(obj.Size))
                add("  Anchored="..tostring(obj.Anchored).." CanCollide="..tostring(obj.CanCollide).." Transparency="..tostring(obj.Transparency))
                add("  Material="..tostring(obj.Material).." Color="..tostring(obj.Color))
            elseif obj:IsA("Attachment") then
                add("  WorldPosition="..val(obj.WorldPosition).." Position="..val(obj.Position))
            elseif obj:IsA("ValueBase") then
                add("  Value="..val(obj.Value))
            end
            for k,v in pairs(obj:GetAttributes()) do
                add("  Attribute "..k.."="..val(v))
            end
        end
    end
else
    add("Workspace.ArcheryTrajectory NOT FOUND")
end


-- V4 INTERACTIVE AIM / TRAJECTORY COMPARISON
-- Capture A while aim is still, move the aim, then capture B.
local function getAimDot()
    local gui = pg and pg:FindFirstChild("FireButtonGui")
    local canvas = gui and gui:FindFirstChild("Canvas")
    local bar = canvas and canvas:FindFirstChild("AimBar")
    return bar and bar:FindFirstChild("AimDot", true)
end

local function takeSnapshot()
    local snap = {dots={}, lastDots={}}
    local camera = Workspace.CurrentCamera
    snap.cameraPos = camera and camera.CFrame.Position or Vector3.zero
    snap.cameraLook = camera and camera.CFrame.LookVector or Vector3.zero
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    snap.playerPos = r and r.Position or Vector3.zero

    local aim = getAimDot()
    if aim and aim:IsA("GuiObject") then
        snap.aim = {
            path=full(aim),
            pos=aim.AbsolutePosition,
            size=aim.AbsoluteSize,
            visible=aim.Visible
        }
    end

    local folder = Workspace:FindFirstChild("ArcheryTrajectory")
    if folder then
        local trajectory, last = {}, {}
        for _,obj in ipairs(folder:GetChildren()) do
            if obj:IsA("BasePart") then
                if obj.Name == "TrajectoryDot" then
                    trajectory[#trajectory+1] = obj.Position
                elseif obj.Name == "LastShotDot" then
                    last[#last+1] = obj.Position
                end
            end
        end
        local function sample(source, dest, limit)
            if #source == 0 then return end
            local count = math.min(limit, #source)
            for i=1,count do
                local index = count == 1 and 1 or math.floor(1 + (i-1)*(#source-1)/(count-1))
                dest[#dest+1] = source[index]
            end
        end
        snap.trajectoryCount=#trajectory
        snap.lastShotCount=#last
        sample(trajectory,snap.dots,16)
        sample(last,snap.lastDots,8)
    end
    return snap
end

local function vec(v)
    return string.format("%.2f, %.2f, %.2f",v.X,v.Y,v.Z)
end

local function buildComparison(a,b)
    local lines={
        "ARCHERY DUELS AIM / TRAJECTORY COMPARISON - V4",
        "BUILD: 2026-11-27-V4-AIM-COMPARE",
        "PlaceId: "..game.PlaceId.." | Player: "..LP.Name,
        "",
        "[CAPTURE A - BEFORE AIM MOVEMENT]",
        "Player="..vec(a.playerPos),
        "CameraPosition="..vec(a.cameraPos),
        "CameraLook="..vec(a.cameraLook),
        "TrajectoryDotCount="..tostring(a.trajectoryCount or 0),
        "LastShotDotCount="..tostring(a.lastShotCount or 0)
    }
    if a.aim then
        lines[#lines+1]="AimDot="..a.aim.path
        lines[#lines+1]="AimDotAbsolutePosition="..vec(Vector3.new(a.aim.pos.X,a.aim.pos.Y,0))
        lines[#lines+1]="AimDotVisible="..tostring(a.aim.visible)
    else
        lines[#lines+1]="AimDot=NOT FOUND"
    end
    for i,p in ipairs(a.dots) do lines[#lines+1]="Trajectory A["..i.."]="..vec(p) end
    for i,p in ipairs(a.lastDots) do lines[#lines+1]="LastShot A["..i.."]="..vec(p) end

    lines[#lines+1]=""
    lines[#lines+1]="[CAPTURE B - AFTER AIM MOVEMENT]"
    lines[#lines+1]="Player="..vec(b.playerPos)
    lines[#lines+1]="CameraPosition="..vec(b.cameraPos)
    lines[#lines+1]="CameraLook="..vec(b.cameraLook)
    lines[#lines+1]="TrajectoryDotCount="..tostring(b.trajectoryCount or 0)
    lines[#lines+1]="LastShotDotCount="..tostring(b.lastShotCount or 0)
    if b.aim then
        lines[#lines+1]="AimDot="..b.aim.path
        lines[#lines+1]="AimDotAbsolutePosition="..vec(Vector3.new(b.aim.pos.X,b.aim.pos.Y,0))
        lines[#lines+1]="AimDotVisible="..tostring(b.aim.visible)
    else
        lines[#lines+1]="AimDot=NOT FOUND"
    end
    for i,p in ipairs(b.dots) do lines[#lines+1]="Trajectory B["..i.."]="..vec(p) end
    for i,p in ipairs(b.lastDots) do lines[#lines+1]="LastShot B["..i.."]="..vec(p) end

    lines[#lines+1]=""
    lines[#lines+1]="[DELTA A TO B]"
    lines[#lines+1]="CameraLookDelta="..vec(b.cameraLook-a.cameraLook)
    lines[#lines+1]="PlayerPositionDelta="..vec(b.playerPos-a.playerPos)
    if a.aim and b.aim then
        lines[#lines+1]=string.format("AimDotPixelDelta=%.1f, %.1f",b.aim.pos.X-a.aim.pos.X,b.aim.pos.Y-a.aim.pos.Y)
    end
    lines[#lines+1]="TrajectorySampleCount A/B="..#a.dots.."/"..#b.dots
    for i=1,math.min(#a.dots,#b.dots) do
        lines[#lines+1]="TrajectoryDelta["..i.."]="..vec(b.dots[i]-a.dots[i])
    end
    lines[#lines+1]="Note: read-only snapshots; no remotes fired and no gameplay values changed."
    return table.concat(lines,"\n")
end

local existing = (gethui and gethui()) or game:GetService("CoreGui")
local oldGui = existing:FindFirstChild("ArcheryDiagV4")
if oldGui then oldGui:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name="ArcheryDiagV4"
gui.ResetOnSpawn=false
gui.Parent=existing

local frame=Instance.new("Frame")
frame.Size=UDim2.fromOffset(280,154)
frame.Position=UDim2.new(0.5,-140,0.18,0)
frame.BackgroundColor3=Color3.fromRGB(22,24,30)
frame.BorderSizePixel=0
frame.Parent=gui
local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,10); corner.Parent=frame

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-16,0,28)
title.Position=UDim2.fromOffset(8,4)
title.BackgroundTransparency=1
title.Text="ARCHERY DIAG V4"
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.GothamBold
title.TextSize=14
title.Parent=frame

local status=Instance.new("TextLabel")
status.Size=UDim2.new(1,-16,0,34)
status.Position=UDim2.fromOffset(8,32)
status.BackgroundTransparency=1
status.Text="Tekan A, gerakkan bidikan, lalu tekan B."
status.TextWrapped=true
status.TextColor3=Color3.fromRGB(210,215,225)
status.Font=Enum.Font.Gotham
status.TextSize=11
status.Parent=frame

local function makeButton(textValue,y)
    local button=Instance.new("TextButton")
    button.Size=UDim2.new(0.44,0,0,30)
    button.Position=UDim2.new(y and 0.04 or 0.52,0,0,76)
    button.BackgroundColor3=Color3.fromRGB(55,65,85)
    button.TextColor3=Color3.new(1,1,1)
    button.Font=Enum.Font.GothamBold
    button.TextSize=12
    button.Text=textValue
    button.Parent=frame
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,7); c.Parent=button
    return button
end
local btnA=makeButton("CAPTURE A",true)
local btnB=makeButton("CAPTURE B",false)
local btnClose=Instance.new("TextButton")
btnClose.Size=UDim2.new(1,-16,0,24)
btnClose.Position=UDim2.fromOffset(8,118)
btnClose.BackgroundTransparency=1
btnClose.Text="TUTUP"
btnClose.TextColor3=Color3.fromRGB(180,190,205)
btnClose.Font=Enum.Font.Gotham
btnClose.TextSize=11
btnClose.Parent=frame

local captureA
btnA.MouseButton1Click:Connect(function()
    captureA=takeSnapshot()
    status.Text="Capture A tersimpan. Sekarang gerakkan bidikan, lalu tekan B."
end)
btnB.MouseButton1Click:Connect(function()
    if not captureA then
        status.Text="Ambil Capture A terlebih dahulu."
        return
    end
    local captureB=takeSnapshot()
    local result=buildComparison(captureA,captureB)
    local copied=false
    if typeof(setclipboard)=="function" then copied=pcall(setclipboard,result) end
    if not copied then
        local output=Instance.new("TextBox")
        output.Size=UDim2.new(1,0,1,0)
        output.BackgroundColor3=Color3.fromRGB(12,14,18)
        output.TextColor3=Color3.new(1,1,1)
        output.TextSize=12
        output.TextXAlignment=Enum.TextXAlignment.Left
        output.TextYAlignment=Enum.TextYAlignment.Top
        output.TextWrapped=false
        output.MultiLine=true
        output.ClearTextOnFocus=false
        output.Text=result
        output.Parent=frame
        status.Text="Perbandingan tampil di kotak teks. Select all lalu copy."
    else
        status.Text="V4 selesai. Hasil perbandingan sudah disalin."
    end
end)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

warn("ARCHERY DIAGNOSTIC V4 READY | Capture A, move aim, Capture B.")
