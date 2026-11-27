-- Archery Duels Diagnostic V7
-- READ-ONLY robust trajectory clustering. No firing, aim changes, camera movement, or remotes.
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
local function median(a)
    table.sort(a)
    local n=#a
    if n==0 then return 0 end
    if n%2==1 then return a[(n+1)/2] end
    return (a[n/2]+a[n/2+1])/2
end
put("=== ARCHERY DUELS DIAGNOSTIC V7 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Gravity="..Workspace.Gravity)
if not root then
    put("ERROR: HumanoidRootPart missing")
else
    local origin=root.Position
    put("Root="..vstr(origin))
    if aimBar and aimDot then
        put(string.format("AimDotYScale=%.4f | AimDotAbsY=%.2f | AimBarTop=%.2f | AimBarHeight=%.2f",
            aimDot.Position.Y.Scale,aimDot.AbsolutePosition.Y,aimBar.AbsolutePosition.Y,aimBar.AbsoluteSize.Y))
    else put("Aim UI missing") end

    local raw={}
    local total=0
    if folder then
        for _,obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name=="TrajectoryDot" then
                total=total+1
                local p=obj.Position
                if p.Magnitude>0.01 then raw[#raw+1]=p end
            end
        end
    end
    put("-- ROBUST DOT FILTER --")
    put("TotalDots="..total.." | ValidNonzero="..#raw)
    local xs,ys,zs={},{},{}
    for _,p in ipairs(raw) do xs[#xs+1]=p.X; ys[#ys+1]=p.Y; zs[#zs+1]=p.Z end
    local mx,my,mz=median(xs),median(ys),median(zs)
    local pts={}
    for _,p in ipairs(raw) do
        -- Reject isolated parts far from the dominant trajectory-dot cluster.
        if math.abs(p.X-mx)<=25 and math.abs(p.Z-mz)<=300 then pts[#pts+1]=p end
    end
    put(string.format("MedianXYZ=(%.2f,%.2f,%.2f) | ClusterDots=%d | Rejected=%d",mx,my,mz,#pts,#raw-#pts))
    if #pts>=2 then
        -- Determine horizontal direction from the nearest and farthest points
        -- after outlier rejection, then sort all dots along that axis.
        local near,far=pts[1],pts[1]
        for _,p in ipairs(pts) do
            if (p-origin).Magnitude<(near-origin).Magnitude then near=p end
            if (p-origin).Magnitude>(far-origin).Magnitude then far=p end
        end
        local flat=Vector3.new(far.X-near.X,0,far.Z-near.Z)
        if flat.Magnitude>0 then
            local axis=flat.Unit
            local side=Vector3.new(-axis.Z,0,axis.X)
            put("NearDot="..vstr(near).." | FarDot="..vstr(far))
            put("FilteredFlatDirection="..vstr(axis))
            local ordered={}
            for _,p in ipairs(pts) do
                local rel=p-near
                ordered[#ordered+1]={p=p,f=rel:Dot(axis),l=rel:Dot(side),y=p.Y-origin.Y}
            end
            table.sort(ordered,function(a,b) return a.f<b.f end)
            local minY,maxY=math.huge,-math.huge
            for _,q in ipairs(ordered) do minY=math.min(minY,q.y); maxY=math.max(maxY,q.y) end
            put(string.format("ForwardSpan=%.2f | LateralSpan=%.2f | HeightFromRootRange=%.2f..%.2f",
                ordered[#ordered].f-ordered[1].f,
                (function() local m=0 for _,q in ipairs(ordered) do m=math.max(m,math.abs(q.l)) end return m end)(),
                minY,maxY))
            put("-- FILTERED TRAJECTORY SAMPLES --")
            local ids={1,math.floor((#ordered-1)*.25)+1,math.floor((#ordered-1)*.5)+1,math.floor((#ordered-1)*.75)+1,#ordered}
            for n,i in ipairs(ids) do
                local q=ordered[i]
                put(string.format("%d idx=%d Forward=%.2f Lateral=%.2f HeightFromRoot=%.2f Pos=%s",n,i,q.f,q.l,q.y,vstr(q.p)))
            end
            put("-- STREAMED HEADS RELATIVE TO FILTERED AXIS --")
            local heads={}
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=lp and plr.Character then
                    local head=plr.Character:FindFirstChild("Head")
                    local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                    if head and head:IsA("BasePart") then
                        local rel=head.Position-origin
                        heads[#heads+1]={name=plr.Name,p=head.Position,f=rel:Dot(axis),l=rel:Dot(side),y=rel.Y,d=rel.Magnitude,hp=hum and hum.Health or -1,max=hum and hum.MaxHealth or -1}
                    end
                end
            end
            table.sort(heads,function(a,b) return math.abs(a.l)<math.abs(b.l) end)
            put("StreamedHeads="..#heads)
            for i=1,math.min(12,#heads) do
                local q=heads[i]
                put(string.format("%d) %s | Head=%s | Forward=%.2f | Lateral=%.2f | HeightFromRoot=%.2f | Dist=%.2f | HP=%.0f/%.0f",
                    i,q.name,vstr(q.p),q.f,q.l,q.y,q.d,q.hp,q.max))
            end
        else put("ERROR: filtered trajectory has no horizontal span") end
    else put("ERROR: fewer than 2 dots after filtering") end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V7.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then print("Archery Duels V7 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or "")) else warn(result) end
