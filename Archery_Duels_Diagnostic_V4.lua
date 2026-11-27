-- Archery Duels Diagnostic V4
-- READ-ONLY: samples the vertical aim control and trajectory while the player
-- manually moves the aim scroll. Does not fire, alter aim, or invoke remotes.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local playerGui = lp:FindFirstChildOfClass("PlayerGui")
local camera = Workspace.CurrentCamera
local char = lp.Character
local root = char and char:FindFirstChild("HumanoidRootPart")

local function vec(v)
    if typeof(v) ~= "Vector3" then return "nil" end
    return string.format("(%.2f,%.2f,%.2f)",v.X,v.Y,v.Z)
end
local function uiInfo(obj)
    if not obj then return "missing" end
    local p,s = "?", "?"
    pcall(function() p=string.format("(%.1f,%.1f)",obj.AbsolutePosition.X,obj.AbsolutePosition.Y) end)
    pcall(function() s=string.format("(%.1f,%.1f)",obj.AbsoluteSize.X,obj.AbsoluteSize.Y) end)
    local vis = "?"
    pcall(function() vis=tostring(obj.Visible) end)
    local pos = "?"
    pcall(function() pos=tostring(obj.Position) end)
    return obj:GetFullName().." | "..obj.ClassName.." | Visible="..vis.." | AbsPos="..p.." | AbsSize="..s.." | Pos="..pos
end
local function findNamed(rootObj,name)
    return rootObj and rootObj:FindFirstChild(name,true)
end

local fireGui = playerGui and findNamed(playerGui,"FireButtonGui")
local aimBar = fireGui and findNamed(fireGui,"AimBar")
local aimDot = aimBar and findNamed(aimBar,"AimDot")

local out = {}
local function put(s) out[#out+1]=tostring(s) end
put("=== ARCHERY DUELS DIAGNOSTIC V4 ===")
put("PlaceId: "..game.PlaceId.." | Player: "..lp.Name.." | UserId: "..lp.UserId)
put("Gravity: "..Workspace.Gravity.." | SampleDuration: 8s | Interval: 0.20s")
put("-- AIM UI --")
put("FireButtonGui: "..tostring(fireGui and fireGui:GetFullName() or "missing"))
put("AimBar: "..uiInfo(aimBar))
put("AimDot: "..uiInfo(aimDot))
if root then put("Root: "..vec(root.Position)) end
put("-- LIVE SAMPLES (move the vertical aim scroll during this capture) --")

local function trajectoryStats()
    local folder=Workspace:FindFirstChild("ArcheryTrajectory")
    local pts={}
    local total=0
    if folder then
        for _,o in ipairs(folder:GetDescendants()) do
            if o:IsA("BasePart") and o.Name=="TrajectoryDot" then
                total=total+1
                if o.Position.Magnitude>0.01 then
                    pts[#pts+1]={p=o.Position,d=root and (o.Position-root.Position).Magnitude or 0}
                end
            end
        end
    end
    table.sort(pts,function(a,b) return a.d<b.d end)
    if #pts==0 then return total,0,"nil","nil","nil","nil" end
    local first,last=pts[1].p,pts[#pts].p
    local minY,maxY=first.Y,first.Y
    for _,v in ipairs(pts) do
        if v.p.Y<minY then minY=v.p.Y end
        if v.p.Y>maxY then maxY=v.p.Y end
    end
    return total,#pts,vec(first),vec(last),string.format("%.2f",maxY-minY),string.format("%.2f",pts[#pts].d)
end

for i=0,40 do
    local t=i*0.20
    local cam=Workspace.CurrentCamera
    local look=cam and vec(cam.CFrame.LookVector) or "nil"
    local dotPos,dotY,dotX="missing","?","?"
    if aimDot then
        pcall(function()
            dotPos=string.format("(%.1f,%.1f)",aimDot.AbsolutePosition.X,aimDot.AbsolutePosition.Y)
            dotX=string.format("%.3f",aimDot.Position.X.Scale+aimDot.Position.X.Offset/10000)
            dotY=string.format("%.3f",aimDot.Position.Y.Scale+aimDot.Position.Y.Offset/10000)
        end)
    end
    local total,valid,startPos,endPos,height,range=trajectoryStats()
    put(string.format("T=%4.1fs | AimDotAbs=%s | AimDotY=%s | CamLook=%s | Dots=%d/%d | Start=%s | End=%s | ArcHeight=%s | Range=%s",
        t,dotPos,dotY,look,valid,total,startPos,endPos,height,range))
    if i<40 then task.wait(0.20) end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V4.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V4 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
