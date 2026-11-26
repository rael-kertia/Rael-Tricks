-- ARCHERY DUELS DIAGNOSTIC V2
-- Focus: AimBar/AimDot, FireButton, EasyAim, equipped bow.
-- READ ONLY: no input simulation, remote calls, hooks, or value changes.

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local out = {}
local limit = 180
local function add(s)
    if #out < limit then out[#out+1] = tostring(s) end
end
local function path(o)
    local ok, v = pcall(function() return o:GetFullName() end)
    return ok and v or o.Name
end
local function fmt(v)
    if typeof(v) == "UDim2" then
        return string.format("X(%g,%g) Y(%g,%g)",v.X.Scale,v.X.Offset,v.Y.Scale,v.Y.Offset)
    elseif typeof(v) == "Vector2" then
        return string.format("(%.2f, %.2f)",v.X,v.Y)
    elseif typeof(v) == "Vector3" then
        return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z)
    elseif typeof(v) == "Color3" then
        return string.format("(%.2f, %.2f, %.2f)",v.R,v.G,v.B)
    end
    return tostring(v)
end
local function props(o)
    add(path(o).." ["..o.ClassName.."]")
    if o:IsA("GuiObject") then
        add("  Visible="..tostring(o.Visible).." Active="..tostring(o.Active))
        add("  Position="..fmt(o.Position).." Size="..fmt(o.Size))
        add("  AbsolutePosition="..fmt(o.AbsolutePosition).." AbsoluteSize="..fmt(o.AbsoluteSize))
        add("  AnchorPoint="..fmt(o.AnchorPoint).." ZIndex="..o.ZIndex)
        if o:IsA("GuiButton") then
            add("  AutoButtonColor="..tostring(o.AutoButtonColor))
        end
        if o:IsA("ImageLabel") or o:IsA("ImageButton") then
            add("  Image="..tostring(o.Image).." ImageRectOffset="..fmt(o.ImageRectOffset).." ImageRectSize="..fmt(o.ImageRectSize))
        end
    elseif o:IsA("UIListLayout") or o:IsA("UIGridLayout") then
        add("  FillDirection="..tostring(o.FillDirection).." SortOrder="..tostring(o.SortOrder))
    elseif o:IsA("Attachment") then
        add("  Position="..fmt(o.Position).." WorldPosition="..fmt(o.WorldPosition))
    elseif o:IsA("BasePart") then
        add("  Position="..fmt(o.Position).." Size="..fmt(o.Size))
    elseif o:IsA("ValueBase") then
        add("  Value="..fmt(o.Value))
    end
    local attrs = o:GetAttributes()
    for k,v in pairs(attrs) do add("  Attribute "..k.."="..fmt(v)) end
end

add("ARCHERY DUELS DIAGNOSTIC V2")
add("PlaceId="..game.PlaceId.." Player="..LP.Name)
add("")
add("[AIM UI]")
local fireGui = PG:FindFirstChild("FireButtonGui")
if not fireGui then
    add("FireButtonGui NOT FOUND")
else
    local targets = {
        fireGui:FindFirstChild("Canvas"),
        fireGui:FindFirstChild("Canvas") and fireGui.Canvas:FindFirstChild("AimBar"),
        fireGui:FindFirstChild("Canvas") and fireGui.Canvas:FindFirstChild("AimBar") and fireGui.Canvas.AimBar:FindFirstChild("AimDot"),
        fireGui:FindFirstChild("Canvas") and fireGui.Canvas:FindFirstChild("FireButton"),
        fireGui:FindFirstChild("Canvas") and fireGui.Canvas:FindFirstChild("EasyAimHost"),
    }
    for _,o in ipairs(targets) do if o then props(o) end end
    local canvas = fireGui:FindFirstChild("Canvas")
    if canvas then
        for _,name in ipairs({"AimBar","AimDot","FireButton","EasyAimHost"}) do
            local root = canvas:FindFirstChild(name)
            if root then
                for _,d in ipairs(root:GetDescendants()) do
                    if d:IsA("GuiObject") or d:IsA("UIBase") or d:IsA("ValueBase") then
                        props(d)
                    end
                end
            end
        end
    end
end

add("")
add("[EQUIPPED BOW]")
local char = LP.Character
local bow
if char then
    for _,o in ipairs(char:GetChildren()) do
        if o:IsA("Tool") then bow=o break end
    end
end
if not bow then
    add("No equipped Tool found in Character")
else
    add("Tool="..path(bow).." RequiresHandle="..tostring(bow.RequiresHandle))
    add("ToolTip="..tostring(bow.ToolTip).." Enabled="..tostring(bow.Enabled))
    for _,d in ipairs(bow:GetDescendants()) do
        if d:IsA("BasePart") or d:IsA("Attachment") or d:IsA("ValueBase")
        or d:IsA("Motor6D") or d:IsA("Weld") or d:IsA("Constraint")
        or d:IsA("Animation") then
            props(d)
        end
    end
end

add("")
add("[AIM RELATED LOCAL SCRIPTS - NAMES ONLY]")
local scriptN=0
for _,d in ipairs(PG:GetDescendants()) do
    if (d:IsA("LocalScript") or d:IsA("ModuleScript"))
    and (d:GetFullName():lower():find("fire",1,true)
    or d:GetFullName():lower():find("aim",1,true)
    or d:GetFullName():find("ReactArenaHUD",1,true)) then
        scriptN=scriptN+1
        add(d.ClassName.." "..path(d))
    end
end
add("Script matches="..scriptN)
add("")
add("READ ONLY. No remotes called. No controls moved. No shots fired.")

local report=table.concat(out,"\n")
local copied=false
if typeof(setclipboard)=="function" then copied=pcall(setclipboard,report) end
if not copied then
    local gui=Instance.new("ScreenGui")
    gui.Name="ArcheryDiagV2"
    gui.ResetOnSpawn=false
    local parent=(gethui and gethui()) or game:GetService("CoreGui")
    gui.Parent=parent
    local box=Instance.new("TextBox")
    box.Size=UDim2.fromScale(.9,.78)
    box.Position=UDim2.fromScale(.05,.1)
    box.BackgroundColor3=Color3.fromRGB(20,22,28)
    box.TextColor3=Color3.new(1,1,1)
    box.TextSize=12
    box.TextXAlignment=Enum.TextXAlignment.Left
    box.TextYAlignment=Enum.TextYAlignment.Top
    box.TextWrapped=false
    box.MultiLine=true
    box.ClearTextOnFocus=false
    box.Text=report
    box.Parent=gui
end
warn("ARCHERY DIAGNOSTIC V2 DONE | clipboard="..tostring(copied).." | chars="..#report)
