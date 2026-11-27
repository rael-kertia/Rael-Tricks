-- Archery Duels Diagnostic V11
-- READ-ONLY: samples PlayerClone models over 8 seconds to catch streamed-in body parts,
-- then measures available clone head hitboxes against the current preview trajectory.
-- No firing, aim changes, camera movement, or remote calls.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local lp=Players.LocalPlayer
local out={}
local function put(s) out[#out+1]=tostring(s) end
local function vstr(v) return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end
local function nearestSegment(p,a,b)
    local ab=b-a
    local den=ab:Dot(ab)
    local t=den>1e-8 and math.clamp((p-a):Dot(ab)/den,0,1) or 0
    local q=a+ab*t
    return (p-q).Magnitude,q
end
local function getCloneModels()
    local list={}
    for _,o in ipairs(Workspace:GetChildren()) do
        if o:IsA("Model") and o.Name:sub(1,12)=="PlayerClone_" then
            list[#list+1]=o
        end
    end
    return list
end
put("=== ARCHERY DUELS DIAGNOSTIC V11 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Sampling clone streaming for 8 seconds...")
local seen={}
local started=os.clock()
while os.clock()-started<8 do
    for _,m in ipairs(getCloneModels()) do
        local rec=seen[m]
        if not rec then
            rec={first=os.clock(),maxParts=0,hadHead=false}
            seen[m]=rec
        end
        local count=0
        for _,d in ipairs(m:GetDescendants()) do
            if d:IsA("BasePart") then count=count+1 end
            if d:IsA("BasePart") and d.Name=="Head" then rec.hadHead=true end
        end
        if count>rec.maxParts then rec.maxParts=count end
    end
    task.wait(0.25)
end
local clones=getCloneModels()
local folder=Workspace:FindFirstChild("ArcheryTrajectory")
local root=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local trajectory={}
if folder then
    local raw={}
    for _,o in ipairs(folder:GetDescendants()) do
        if o:IsA("BasePart") and o.Name=="TrajectoryDot" and o.Position.Magnitude>0.01 then raw[#raw+1]=o.Position end
    end
    local xs,zs={},{}
    for _,p in ipairs(raw) do xs[#xs+1]=p.X; zs[#zs+1]=p.Z end
    table.sort(xs); table.sort(zs)
    local mx=xs[math.floor((#xs+1)/2)] or 0
    local mz=zs[math.floor((#zs+1)/2)] or 0
    for _,p in ipairs(raw) do
        if math.abs(p.X-mx)<=25 and math.abs(p.Z-mz)<=300 then trajectory[#trajectory+1]=p end
    end
    if #trajectory>1 then
        local near=trajectory[1]
        for _,p in ipairs(trajectory) do
            if root and (p-root.Position).Magnitude<(near-root.Position).Magnitude then near=p end
        end
        table.sort(trajectory,function(a,b) return (a-near).Magnitude<(b-near).Magnitude end)
        -- Sort along the dominant horizontal direction.
        local far=trajectory[#trajectory]
        local dir=Vector3.new(far.X-near.X,0,far.Z-near.Z)
        if dir.Magnitude>0 then
            dir=dir.Unit
            table.sort(trajectory,function(a,b) return (a-near):Dot(dir)<(b-near):Dot(dir) end)
        end
    end
end
put("-- CLONE STREAMING SUMMARY --")
put("CloneModels="..#clones.." | SampledModels="..(function() local n=0 for _ in pairs(seen) do n=n+1 end return n end)().." | PreviewPoints="..#trajectory)
local candidates={}
for i,m in ipairs(clones) do
    local hum=m:FindFirstChildOfClass("Humanoid")
    local head=m:FindFirstChild("Head",true)
    local hrp=m:FindFirstChild("HumanoidRootPart",true)
    local count=0
    for _,d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then count=count+1 end end
    local ownerName=m.Name:sub(13)
    local owner=Players:FindFirstChild(ownerName)
    local rec=seen[m] or {maxParts=count,hadHead=head~=nil}
    put(string.format("%d) %s | Display=%s | OwnerPlayer=%s | PartsNow=%d | PartsMaxDuringSample=%d | HeadSeen=%s | HP=%s | BotFriendUserId=%s",
        i,m.Name,hum and hum.DisplayName or "?",owner and (owner.Name.."/"..owner.UserId) or "not in Players",
        count,rec.maxParts,tostring(rec.hadHead),hum and string.format("%.0f/%.0f",hum.Health,hum.MaxHealth) or "?",
        tostring(m:GetAttribute("BotFriendUserId"))))
    local anchor=head and head:IsA("BasePart") and head or (hrp and hrp:IsA("BasePart") and hrp or nil)
    if anchor and #trajectory>1 then
        local best=math.huge
        local bestPoint=nil
        for j=1,#trajectory-1 do
            local d,q=nearestSegment(anchor.Position,trajectory[j],trajectory[j+1])
            if d<best then best=d; bestPoint=q end
        end
        candidates[#candidates+1]={name=m.Name,display=hum and hum.DisplayName or "?",kind=head and "HEAD" or "ROOT_ONLY",
            pos=anchor.Position,dist=best,closest=bestPoint,hp=hum and hum.Health or -1}
    elseif anchor then
        candidates[#candidates+1]={name=m.Name,display=hum and hum.DisplayName or "?",kind=head and "HEAD" or "ROOT_ONLY",
            pos=anchor.Position,dist=-1,closest=nil,hp=hum and hum.Health or -1}
    end
end
put("-- CLONE DISTANCE TO PREVIEW --")
table.sort(candidates,function(a,b)
    if a.dist<0 then return false end
    if b.dist<0 then return true end
    return a.dist<b.dist
end)
put("ClonesWithAnchor="..#candidates)
for i,q in ipairs(candidates) do
    put(string.format("%d) %s | %s | %s | Pos=%s | PreviewDistance=%s | ClosestPreview=%s | HP=%.0f",
        i,q.name,q.display,q.kind,vstr(q.pos),q.dist>=0 and string.format("%.2f",q.dist) or "unavailable",
        q.closest and vstr(q.closest) or "unavailable",q.hp))
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V11.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V11 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
