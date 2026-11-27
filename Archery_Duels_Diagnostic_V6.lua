-- Archery Duels Diagnostic V6
-- READ-ONLY: compares streamed opponent heads against the ACTUAL trajectory axis.
-- Does not fire, change aim, move camera, or invoke remotes.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer
local char = lp.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local gui = lp:FindFirstChildOfClass("PlayerGui")
local fireGui = gui and gui:FindFirstChild("FireButtonGui", true)
local aimBar = fireGui and fireGui:FindFirstChild("AimBar", true)
local aimDot = aimBar and aimBar:FindFirstChild("AimDot", true)
local folder = Workspace:FindFirstChild("ArcheryTrajectory")
local out = {}
local function put(s) out[#out+1]=tostring(s) end
local function vstr(v) return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end

put("=== ARCHERY DUELS DIAGNOSTIC V6 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Gravity="..Workspace.Gravity)
if not root then
    put("ERROR: HumanoidRootPart missing")
else
    local origin=root.Position
    put("Root="..vstr(origin))
    local cam=Workspace.CurrentCamera
    if cam then put("CameraLook="..vstr(cam.CFrame.LookVector)) end
    if aimBar and aimDot then
        put(string.format("AimDotYScale=%.4f | AimDotAbsY=%.2f | AimBarTop=%.2f | AimBarHeight=%.2f",
            aimDot.Position.Y.Scale,aimDot.AbsolutePosition.Y,aimBar.AbsolutePosition.Y,aimBar.AbsoluteSize.Y))
    else
        put("Aim UI missing")
    end

    local pts={}
    local total=0
    if folder then
        for _,obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name=="TrajectoryDot" then
                total=total+1
                if obj.Position.Magnitude>0.01 then pts[#pts+1]=obj.Position end
            end
        end
    end
    put("-- ACTUAL TRAJECTORY AXIS --")
    put("TotalDots="..total.." | ValidDots="..#pts)
    local axis,side
    if #pts>=2 then
        local lo,hi=pts[1],pts[1]
        for _,p in ipairs(pts) do
            if (p-origin).Magnitude < (lo-origin).Magnitude then lo=p end
            if (p-origin).Magnitude > (hi-origin).Magnitude then hi=p end
        end
        local delta=hi-lo
        local horizontal=Vector3.new(delta.X,0,delta.Z)
        if horizontal.Magnitude>0 then
            axis=horizontal.Unit
            side=Vector3.new(-axis.Z,0,axis.X)
            put("NearDot="..vstr(lo).." | FarDot="..vstr(hi))
            put("TrajectoryFlatDirection="..vstr(axis))
            local ordered={}
            for _,p in ipairs(pts) do
                local rel=p-lo
                ordered[#ordered+1]={p=p,f=rel:Dot(axis),l=rel:Dot(side),y=p.Y-origin.Y}
            end
            table.sort(ordered,function(a,b) return a.f<b.f end)
            put("-- TRAJECTORY SAMPLES (ACTUAL AXIS) --")
            local ids={1,math.floor(#ordered*.25),math.floor(#ordered*.5),math.floor(#ordered*.75),#ordered}
            for n,i in ipairs(ids) do
                i=math.max(1,math.min(#ordered,i))
                local q=ordered[i]
                put(string.format("%d idx=%d Forward=%.2f Lateral=%.2f HeightFromRoot=%.2f Pos=%s",n,i,q.f,q.l,q.y,vstr(q.p)))
            end
        else
            put("Could not derive horizontal trajectory direction")
        end
    else
        put("Not enough trajectory dots")
    end

    put("-- STREAMED OPPONENT HEADS RELATIVE TO TRAJECTORY --")
    local candidates={}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=lp and plr.Character then
            local head=plr.Character:FindFirstChild("Head")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if head and head:IsA("BasePart") and axis and side then
                local rel=head.Position-root.Position
                local f=rel:Dot(axis)
                local lateral=rel:Dot(side)
                local vertical=head.Position.Y-origin.Y
                local dist=rel.Magnitude
                candidates[#candidates+1]={name=plr.Name,p=head.Position,f=f,l=lateral,y=vertical,d=dist,hp=hum and hum.Health or -1,max=hum and hum.MaxHealth or -1}
            elseif head and head:IsA("BasePart") then
                local rel=head.Position-origin
                candidates[#candidates+1]={name=plr.Name,p=head.Position,f=0,l=0,y=rel.Y,d=rel.Magnitude,hp=hum and hum.Health or -1,max=hum and hum.MaxHealth or -1}
            end
        end
    end
    table.sort(candidates,function(a,b)
        if math.abs(a.l)~=math.abs(b.l) then return math.abs(a.l)<math.abs(b.l) end
        return a.d<b.d
    end)
    put("StreamedHeads="..#candidates)
    for i=1,math.min(12,#candidates) do
        local q=candidates[i]
        put(string.format("%d) %s | Head=%s | Forward=%.2f | Lateral=%.2f | HeightFromRoot=%.2f | Dist=%.2f | HP=%.0f/%.0f",
            i,q.name,vstr(q.p),q.f,q.l,q.y,q.d,q.hp,q.max))
    end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V6.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V6 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
