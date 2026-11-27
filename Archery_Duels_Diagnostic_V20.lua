-- ARCHERY DUELS DIAGNOSTIC V20
-- READ-ONLY: captures the actual ImpactVictim clone, its metadata, and all clone-head motion.
-- Does not fire, invoke remotes, change aim, or move the player.

local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local G=16.47
local lines={}
local function add(s) lines[#lines+1]=tostring(s) end
local function fmt(v)
 if typeof(v)=="Vector3" then return string.format("(%.3f, %.3f, %.3f)",v.X,v.Y,v.Z) end
 return tostring(v)
end
local function attrs(o)
 local out={}
 local ok,list=pcall(function() return o:GetAttributes() end)
 if ok then
  for k,v in pairs(list) do
   local val=typeof(v)=="Vector3" and fmt(v) or tostring(v)
   table.insert(out,k.."="..val)
  end
 end
 table.sort(out)
 return #out>0 and table.concat(out," | ") or "NONE"
end
local function attr(o,k)
 local ok,v=pcall(function() return o:GetAttribute(k) end)
 return ok and v or nil
end
local function unixNow()
 local ok,v=pcall(function() return DateTime.now().UnixTimestampMillis/1000 end)
 return ok and v or os.time()
end
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local localX=root and root.Position.X or 0
local slot=nil
local nearest=math.huge
for _,o in ipairs(Workspace:GetDescendants()) do
 if o.Name=="StuckArrow" then
  local p=attr(o,"LaunchOrigin")
  local a=attr(o,"ArenaSlot")
  if typeof(p)=="Vector3" and type(a)=="string" then
   local d=math.abs(p.X-localX)
   if d<nearest then nearest=d slot=a end
  end
 end
end
local seen={}
for _,o in ipairs(Workspace:GetDescendants()) do
 if o.Name=="PlayerArrow" then seen[o]=true end
end
local captured={}
local function findModel(name)
 if type(name)~="string" then return nil end
 for _,o in ipairs(Workspace:GetDescendants()) do
  if o:IsA("Model") and o.Name==name then return o end
 end
 return nil
end
local function capture(o)
 if seen[o] or o.Name~="PlayerArrow" then return end
 if attr(o,"OwnerUserId")~=player.UserId then return end
 local a=attr(o,"ArenaSlot")
 if slot and a and a~=slot then return end
 local origin,vel,t,impact=attr(o,"LaunchOrigin"),attr(o,"LaunchVel"),attr(o,"ImpactT"),attr(o,"ImpactPos")
 if typeof(origin)~="Vector3" or typeof(vel)~="Vector3" or type(t)~="number" or typeof(impact)~="Vector3" then return end
 seen[o]=true
 local victim=attr(o,"ImpactVictim")
 local rec={object=o,origin=origin,vel=vel,t=t,impact=impact,launch=attr(o,"LaunchTime"),slot=a,victim=victim,samples={},targets={}}
 table.insert(captured,rec)
 task.spawn(function()
  local began=os.clock()
  local nextScan=0
  while os.clock()-began<math.min(t+0.6,4.8) do
   local now=os.clock()
   if now>=nextScan then
    nextScan=now+0.045
    local elapsed=rec.launch and (unixNow()-rec.launch) or (now-began)
    local projectile=origin+vel*elapsed+Vector3.new(0,-0.5*G*elapsed*elapsed,0)
    local arrowPos
    pcall(function() arrowPos=o.Position end)
    local sample={elapsed=elapsed,projectile=projectile,arrow=arrowPos,heads={}}
    for _,m in ipairs(Workspace:GetDescendants()) do
     if m:IsA("Model") and m.Name:match("^PlayerClone_") then
      local h=m:FindFirstChild("Head",true)
      if h and h:IsA("BasePart") then
       local p=h.Position
       local df=(p-projectile).Magnitude
       local di=(p-impact).Magnitude
       sample.heads[m.Name]={pos=p,flight=df,impact=di}
       local s=rec.targets[m.Name]
       if not s then
        s={name=m.Name,model=m,attrs=attrs(m),count=0,bestFlight=math.huge,bestImpact=math.huge}
        rec.targets[m.Name]=s
       end
       s.count=s.count+1
       s.last=p
       if df<s.bestFlight then
        s.bestFlight=df
        s.bestFlightPos=p
        s.bestFlightProjectile=projectile
        s.bestFlightTime=elapsed
       end
       if di<s.bestImpact then
        s.bestImpact=di
        s.bestImpactPos=p
        s.bestImpactTime=elapsed
       end
      end
     end
    end
    table.insert(rec.samples,sample)
   end
   RunService.Heartbeat:Wait()
  end
 end)
end
local conn=Workspace.DescendantAdded:Connect(function(o)
 if o.Name=="PlayerArrow" then task.defer(function() capture(o) end) end
end)
add("=== ARCHERY DUELS DIAGNOSTIC V20 ===")
add("READ-ONLY IMPACT-VICTIM IDENTITY + ALL CLONE HEADS | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",localX).." | GravityModel="..G)
add("IMPORTANT: no clone is excluded by name; PlayerClone_"..player.Name.." is tracked too.")
add("READY: Fire exactly ONE normal arrow at the opponent bot.")
local deadline=os.clock()+7
while os.clock()<deadline do
 for _,o in ipairs(Workspace:GetDescendants()) do capture(o) end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
task.wait(0.2)
add("-- ARROW / VICTIM REPORT --")
add("CapturedNewArrows="..#captured)
for i,r in ipairs(captured) do
 local pred=r.origin+r.vel*r.t+Vector3.new(0,-0.5*G*r.t*r.t,0)
 local victimModel=findModel(r.victim)
 local victimHead=victimModel and victimModel:FindFirstChild("Head",true)
 add(string.format("ARROW %02d | Slot=%s | Victim=%s | Hit=%s | HeadHit=%s | ImpactT=%.4f",i,tostring(r.slot),tostring(r.victim),tostring(attr(r.object,"HitCharacter")),tostring(attr(r.object,"ImpactHead")),r.t))
 add("OwnerUserId="..tostring(attr(r.object,"OwnerUserId")).." | ArrowAttributes="..attrs(r.object))
 add("Origin="..fmt(r.origin).." | LaunchVel="..fmt(r.vel).." | ImpactPos="..fmt(r.impact))
 add("PredictedImpact_G16.47="..fmt(pred).." | BallisticError="..string.format("%.4f",(pred-r.impact).Magnitude))
 if victimModel then
  add("VICTIM MODEL FOUND: "..victimModel:GetFullName().." | Class="..victimModel.ClassName)
  add("VictimModelAttributes="..attrs(victimModel))
  add("VictimHead="..fmt(victimHead and victimHead.Position or nil))
  add("VictimHeadClass="..tostring(victimHead and victimHead.ClassName))
 else
  add("VICTIM MODEL NOT FOUND by exact ImpactVictim name at report time.")
 end
 local ranked={}
 for _,s in pairs(r.targets) do table.insert(ranked,s) end
 table.sort(ranked,function(a,b) return a.bestFlight<b.bestFlight end)
 add("TrackedCloneModels="..#ranked.." | MotionSamples="..#r.samples)
 local victimStats=r.targets[r.victim]
 if victimStats then
  add("IMPACT VICTIM TRACKED: "..victimStats.name.." | Samples="..victimStats.count.." | ClosestPathDistance="..string.format("%.3f",victimStats.bestFlight).." at t="..string.format("%.4f",victimStats.bestFlightTime).." | Head="..fmt(victimStats.bestFlightPos).." | PredictedArrow="..fmt(victimStats.bestFlightProjectile))
  add("VictimCloneAttributes="..victimStats.attrs)
 else
  add("IMPACT VICTIM HAD NO TRACKED HEAD: "..tostring(r.victim))
 end
 add("-- CLOSEST CLONE HEADS TO PREDICTED ARROW PATH --")
 for j=1,math.min(12,#ranked) do
  local s=ranked[j]
  add(string.format("%02d) %s | Samples=%d | ClosestPath=%.3f at t=%.4f | Head=%s | ImpactDistance=%.3f | Attributes=%s",j,s.name,s.count,s.bestFlight,s.bestFlightTime,fmt(s.bestFlightPos),s.bestImpact,s.attrs))
 end
 add("-- HEAD CHECKPOINTS (VICTIM + NEAREST CLONES) --")
 local wanted={}
 if r.victim then wanted[r.victim]=true end
 for j=1,math.min(3,#ranked) do wanted[ranked[j].name]=true end
 local n=#r.samples
 if n>0 then
  local count=math.min(8,n)
  for j=1,count do
   local idx=math.floor(1+(j-1)*(n-1)/math.max(1,count-1))
   local s=r.samples[idx]
   local bits={}
   for name,h in pairs(s.heads) do
    if wanted[name] then table.insert(bits,name.."="..fmt(h.pos).." (path "..string.format("%.1f",h.flight).." st)") end
   end
   table.sort(bits)
   add(string.format("%02d) t=%.4f Arrow=%s | %s",j,s.elapsed,fmt(s.projectile),#bits>0 and table.concat(bits," ; ") or "No selected clone Head streamed"))
  end
 end
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V20.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V20",Text="Victim identity report copied",Duration=5}) end)
print(output)
