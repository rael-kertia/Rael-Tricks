-- ARCHERY DUELS DIAGNOSTIC V13
-- READ-ONLY projectile/arrow attribute sampler. No remotes, firing, movement, or aim changes.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local lines = {}
local function add(s) lines[#lines+1] = tostring(s) end
local function xyz(v)
    if typeof(v) == "Vector3" then return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end
    return tostring(v)
end
local function val(v)
    if typeof(v) == "Vector3" then return xyz(v) end
    if typeof(v) == "CFrame" then return xyz(v.Position) end
    return tostring(v)
end
local function attrs(o)
    local out = {}
    for k,v in pairs(o:GetAttributes()) do out[#out+1] = k.."="..val(v) end
    table.sort(out)
    return #out > 0 and table.concat(out," | ") or "none"
end
local function path(o)
    local ok,s=pcall(function() return o:GetFullName() end)
    return ok and s or o.Name
end
local function pos(o)
    if o:IsA("BasePart") then return xyz(o.Position) end
    if o:IsA("Model") then
        local p=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart
        return p and xyz(p.Position) or "no-root"
    end
    return "n/a"
end
add("=== ARCHERY DUELS DIAGNOSTIC V13 ===")
add("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
local char=player.Character
local root=char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
local tool=char and char:FindFirstChildOfClass("Tool")
local handle=tool and tool:FindFirstChild("Handle")
add("-- CURRENT FIRING ORIGIN CONTEXT --")
add("CharacterRoot="..(root and xyz(root.Position) or "nil"))
add("Tool="..(tool and tool.Name or "nil"))
add("BowHandle="..(handle and xyz(handle.Position) or "nil"))
local pg=player:FindFirstChildOfClass("PlayerGui")
local gui=pg and pg:FindFirstChild("FireButtonGui",true)
local aim=gui and gui:FindFirstChild("AimBar",true)
local dot=aim and aim:FindFirstChild("AimDot",true)
add("AimDotY="..(dot and tostring(dot.AbsolutePosition.Y) or "nil"))
add("-- EXISTING STUCK ARROWS --")
local count=0
for _,o in ipairs(Workspace:GetDescendants()) do
    if o.Name=="StuckArrow" then
        count+=1
        add(string.format("%02d) %s | Class=%s | Pos=%s",count,path(o),o.ClassName,pos(o)))
        add("    ATTRS "..attrs(o))
        if o:IsA("BasePart") then
            add("    Size="..xyz(o.Size).." | Anchored="..tostring(o.Anchored).." | CanQuery="..tostring(o.CanQuery))
        end
    end
end
add("StuckArrowCount="..count)
add("-- LIVE PROJECTILE CANDIDATES --")
local keys={"arrow","projectile","bolt"}
local candidates={}
for _,o in ipairs(Workspace:GetDescendants()) do
    local n=string.lower(o.Name)
    local match=false
    for _,k in ipairs(keys) do if string.find(n,k,1,true) then match=true break end end
    if match and (o:IsA("BasePart") or o:IsA("Model")) and o.Name~="StuckArrow" then
        candidates[#candidates+1]=o
    end
end
add("CandidateCount="..#candidates)
for i=1,math.min(35,#candidates) do
    local o=candidates[i]
    add(string.format("%02d) %s | %s | Pos=%s | Attrs=%s",i,o.ClassName,path(o),pos(o),attrs(o)))
end
add("-- SAMPLE NEW/CHANGING STUCK ARROWS FOR 8 SECONDS --")
local seen={}
local samples=0
local started=os.clock()
while os.clock()-started<8 do
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name=="StuckArrow" and not seen[o] then
            seen[o]=true
            samples+=1
            add(string.format("NEW #%d t=%.2f | %s | Pos=%s | Attrs=%s",samples,os.clock()-started,path(o),pos(o),attrs(o)))
        end
    end
    task.wait(0.25)
end
add("NewStuckArrowsDuringSample="..samples)
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V13.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V13",Text="Read-only report copied",Duration=5}) end)
print(output)
