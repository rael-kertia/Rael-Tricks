-- Archery Duels Diagnostic V9
-- READ-ONLY: scans player/NPC humanoid heads and measures distance to preview trajectory.
-- Does not fire, change aim, move camera, or invoke remotes.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local lp=Players.LocalPlayer
local char=lp.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
local folder=Workspace:FindFirstChild("ArcheryTrajectory")
local out={}
local function put(s) out[#out+1]=tostring(s) end
local function vstr(v) return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end
local function nearestOnSegment(p,a,b)
    local ab=b-a
    local den=ab:Dot(ab)
    local t=den>1e-8 and math.clamp((p-a):Dot(ab)/den,0,1) or 0
    local q=a+ab*t
    return (p-q).Magnitude,t,q
end
local function getHumanoid(model)
    if not model then return nil end
    return model:FindFirstChildOfClass("Humanoid")
end
put("=== ARCHERY DUELS DIAGNOSTIC V9 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Gravity="..Workspace.Gravity)
if not root then
    put("ERROR: HumanoidRootPart missing")
elseif not folder then
    put("ERROR: Workspace.ArcheryTrajectory missing")
else
    put("Root="..vstr(root.Position))
    local raw={}
    local total=0
    for _,o in ipairs(folder:GetDescendants()) do
        if o:IsA("BasePart") and o.Name=="TrajectoryDot" then
            total=total+1
            if o.Position.Magnitude>0.01 then raw[#raw+1]=o.Position end
        end
    end
    local xs,zs={},{}
    for _,p in ipairs(raw) do xs[#xs+1]=p.X; zs[#zs+1]=p.Z end
    table.sort(xs); table.sort(zs)
    local mx=xs[math.floor((#xs+1)/2)] or root.Position.X
    local mz=zs[math.floor((#zs+1)/2)] or root.Position.Z
    local pts={}
    for _,p in ipairs(raw) do
        if math.abs(p.X-mx)<=25 and math.abs(p.Z-mz)<=300 then pts[#pts+1]=p end
    end
    put("-- PREVIEW AXIS --")
    put("TotalDots="..total.." | Valid="..#raw.." | Cluster="..#pts.." | Rejected="..(#raw-#pts))
    if #pts<2 then
        put("ERROR: insufficient trajectory points")
    else
        local near=pts[1]
        for _,p in ipairs(pts) do
            if (p-root.Position).Magnitude<(near-root.Position).Magnitude then near=p end
        end
        local far=pts[1]
        for _,p in ipairs(pts) do
            if (p-root.Position).Magnitude>(far-root.Position).Magnitude then far=p end
        end
        local flat=Vector3.new(far.X-near.X,0,far.Z-near.Z)
        local axis=flat.Magnitude>1e-5 and flat.Unit or Vector3.new(0,0,-1)
        local side=Vector3.new(-axis.Z,0,axis.X)
        local data={}
        for _,p in ipairs(pts) do
            local rel=p-near
            data[#data+1]={p=p,f=rel:Dot(axis)}
        end
        table.sort(data,function(a,b) return a.f<b.f end)
        put("NearDot="..vstr(near).." | FarDot="..vstr(far))
        put("FlatAxis="..vstr(axis).." | ForwardSpan="..string.format("%.2f",data[#data].f))
        -- Scan unique Head parts belonging to humanoid models, including NPCs.
        local candidates={}
        local seen={}
        local scanned=0
        for _,o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and o.Name=="Head" then
                local model=o:FindFirstAncestorOfClass("Model")
                local hum=getHumanoid(model)
                if hum and model~=char and not seen[o] then
                    seen[o]=true
                    scanned=scanned+1
                    local best=math.huge
                    local bestF,bestT,bestPoint=0,0,nil
                    for i=1,#data-1 do
                        local dist,t,q=nearestOnSegment(o.Position,data[i].p,data[i+1].p)
                        if dist<best then
                            best=dist
                            bestT=t
                            bestPoint=q
                            bestF=data[i].f+(data[i+1].f-data[i].f)*t
                        end
                    end
                    local rel=o.Position-near
                    local lateral=rel:Dot(side)
                    local forward=rel:Dot(axis)
                    local owner=Players:GetPlayerFromCharacter(model)
                    local kind=owner and "PLAYER" or "NPC"
                    candidates[#candidates+1]={
                        name=owner and owner.Name or model.Name,
                        kind=kind,
                        pos=o.Position,
                        dist=best,
                        forward=forward,
                        lateral=lateral,
                        hitForward=bestF,
                        closest=bestPoint,
                        height=o.Position.Y-root.Position.Y,
                        humanoid=hum,
                        model=model
                    }
                end
            end
        end
        table.sort(candidates,function(a,b) return a.dist<b.dist end)
        put("-- HEAD SCAN --")
        put("HumanoidHeadsScanned="..scanned.." | Candidates="..#candidates)
        put("Distance = shortest 3D distance from head center to any preview line segment.")
        local shown=math.min(30,#candidates)
        for i=1,shown do
            local q=candidates[i]
            local hp=q.humanoid.Health
            local maxhp=q.humanoid.MaxHealth
            put(string.format("%d) [%s] %s | Head=%s | CurveDistance=%.2f | Forward=%.2f | Lateral=%.2f | Height=%.2f | HP=%.0f/%.0f | ClosestPreview=%s",
                i,q.kind,q.name,vstr(q.pos),q.dist,q.forward,q.lateral,q.height,hp,maxhp,q.closest and vstr(q.closest) or "nil"))
        end
        put("-- CLOSEST HEADS BY RANGE --")
        local thresholds={5,10,20,50,100}
        for _,limit in ipairs(thresholds) do
            local count=0
            for _,q in ipairs(candidates) do if q.dist<=limit then count=count+1 end end
            put("Within "..limit.." studs: "..count)
        end
    end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V9.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V9 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
