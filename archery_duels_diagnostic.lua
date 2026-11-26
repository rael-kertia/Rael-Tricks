-- ARCHERY DUELS DIAGNOSTIC
-- Read-only inspection. No remote calls, hooks, firing, or value changes.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local keys = {"aim","arrow","archer","archery","bow","shoot","fire","projectile","trajectory","power","angle","target","damage","attack","accuracy","duel","hit","velocity","charge"}
local out, seen = {}, 0
local function add(s)
    if seen >= 380 then return end
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

add("ARCHERY DUELS DIAGNOSTIC")
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

local report = table.concat(out, "\n")
local copied = false
if typeof(setclipboard) == "function" then
    copied = pcall(setclipboard, report)
end

if not copied then
    local gui = Instance.new("ScreenGui")
    gui.Name = "ArcheryDiag"
    gui.ResetOnSpawn = false
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    gui.Parent = parent
    local box = Instance.new("TextBox")
    box.Size = UDim2.fromScale(0.9, 0.75)
    box.Position = UDim2.fromScale(0.05, 0.12)
    box.BackgroundColor3 = Color3.fromRGB(20,20,25)
    box.TextColor3 = Color3.new(1,1,1)
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.TextWrapped = false
    box.MultiLine = true
    box.ClearTextOnFocus = false
    box.Text = report
    box.Parent = gui
end

warn("ARCHERY DIAGNOSTIC COMPLETE | clipboard="..tostring(copied).." | chars="..#report)
