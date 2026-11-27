-- ARCHERY DUELS DIAGNOSTIC V21
-- READ-ONLY: synchronizes observed arrow and clone Head samples using os.clock().
-- Reports closest actual arrow-to-head approach and world-space miss vector.
-- No firing, remotes, aim changes, or movement.

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
local function attr(o,k)
 local ok,v=pcall(function() return o:GetAttribute(k) end)
 return ok and v or nil
end
local function attrs(o)
 local ok,a=pcall(function() return o:GetAttributes() end)
 if not ok then return "UNAVAILABLE" end
 local t={}
 for k,v in pairs(a) do table.insert(t,k.."="..tostring(v)) end
 table.sort(t)
 return #t>0 and table.concat(t," | ") or "NONE"
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
local function capture(o)
 if seen[o] or o.Name~="PlayerArrow" then return end
 if attr(o,"OwnerUserId")~=player.UserId then return end
 local a=attr(o,"ArenaSlot")
 if slot and a and a~=slot then return end
 local origin,vel,t,impact=attr(o,"LaunchOrigin"),attr(o,"LaunchVel"),attr(o,"ImpactT"),attr(o,"ImpactPos")
 if typeof(origin)~="Vector3" or typeof(vel)~="Vector3" or type(t)~="number" then return end
 seen[o]=true
 local rec={object=o,origin=origin,vel=vel,t=t,impact=impact,slot=a,observedAt=os.clock(),samples={},targets={}}
 table.insert(captured,rec)
 task.spawn(function()
  local stopAt=rec.observedAt+math.min(t+0.35,4.5)
  local nextScan=0
  while os.clock()<stopAt do
   local now=os.clock()
   if now>=nextScan then
    nextScan=now+0.025
    local elapsed=now-rec.observedAt
    local arrowPos
    pcall(function() arrowPos=o.Position end)
    if typeof(arrowPos)=="Vector3" then
     local sample={elapsed=elapsed,arrow=arrowPos,heads={}}
     for _,m in ipairs(Workspace:GetDescendants()) do
      if m:IsA("Model") and m.Name:match("^PlayerClone_") then
       local h=m:FindFirstChild("Head",true)
       if h and h:IsA("BasePart") then
        local hp=h.Position
        local d=(hp-arrowPos).Magnitude
        sample.heads[m.Name]={pos=hp,distance=d}
        local s=rec.targets[m.Name]
        if not s then
         s={name=m.Name,model=m,attributes=attrs(m),count=0,bestDistance=math.huge}
         rec.targets[m.Name]=s
        end
        s.count=s.count+1
        s.last=hp
        if d<s.bestDistance then
         s.bestDistance=d
         s.bestElapsed=elapsed
         s.bestArrow=arrowPos
         s.bestHead=hp
         s.miss=hp-arrowPos
        end
       end
      end
     end
     table.insert(rec.samples,sample)
    end
   end
   RunService.Heartbeat:Wait()
  end
 end)
end
local conn=Workspace.DescendantAdded:Connect(function(o)
 if o.Name=="PlayerArrow" then task.defer(function() capture(o) end) end
end)
add("=== ARCHERY DUELS DIAGNOSTIC V21 ===")
add("READ-ONLY SYNCHRONIZED ARROW/HEAD DISTANCE | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | GravityModel="..G)
add("Timebase=os.clock() relative to first observed arrow object; no LaunchTime clock conversion.")
add("READY: Fire exactly ONE normal arrow at the opponent bot.")
local deadline=os.clock()+7
while os.clock()<deadline do
 for _,o in ipairs(Workspace:GetDescendants()) do capture(o) end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
task.wait(0.2)
add("-- ACTUAL ARROW / CLONE HEAD CLOSEST APPROACH --")
add("CapturedNewArrows="..#captured)
for i,r in ipairs(captured) do
 add(string.format("ARROW %02d | Slot=%s | ImpactT=%.4f | Samples=%d | ImpactPos=%s",i,tostring(r.slot),r.t,#r.samples,fmt(r.impact)))
 add("Origin="..fmt(r.origin).." | LaunchVel="..fmt(r.vel).." | ArrowAttributes="..attrs(r.object))
 local ranked={}
 for _,s in pairs(r.targets) do table.insert(ranked,s) end
 table.sort(ranked,function(a,b) return a.bestDistance<b.bestDistance end)
 add("TrackedCloneHeads="..#ranked)
 for j=1,math.min(12,#ranked) do
  local s=ranked[j]
  local m=s.miss or Vector3.zero
  local horizontal=Vector3.new(m.X,0,m.Z).Magnitude
  local vertical=m.Y
  local angle=math.deg(math.atan2(horizontal,math.max(0.001,(r.origin-r.bestHead or r.origin).Magnitude)))
  add(string.format("%02d) %s | Samples=%d | MinActualDistance=%.3f studs at t=%.4f | Arrow=%s | Head=%s",j,s.name,s.count,s.bestDistance,s.bestElapsed,fmt(s.bestArrow),fmt(s.bestHead)))
  add("   MISS_VECTOR Head-Arrow="..fmt(m).." | HorizontalMissXZ="..string.format("%.3f",horizontal).." | VerticalMissY="..string.format("%+.3f",vertical).." | CloneAttributes="..s.attributes)
 end
 local victim=attr(r.object,"ImpactVictim")
 add("ImpactVictim="..tostring(victim).." | HitCharacter="..tostring(attr(r.object,"HitCharacter")).." | ImpactHead="..tostring(attr(r.object,"ImpactHead")))
 if #ranked>0 then
  local best=ranked[1]
  add("BEST_CANDIDATE="..best.name.." | ClosestActualArrowHeadDistance="..string.format("%.3f",best.bestDistance).." | HeadMinusArrow="..fmt(best.miss))
 end
 add("-- SYNCHRONIZED CHECKPOINTS FOR CLOSEST CANDIDATE --")
 if #ranked>0 and #r.samples>0 then
  local target=ranked[1].name
  local n=#r.samples
  local count=math.min(10,n)
  for j=1,count do
   local idx=math.floor(1+(j-1)*(n-1)/math.max(1,count-1))
   local sm=r.samples[idx]
   local h=sm.heads[target]
   add(string.format("%02d) t=%.4f Arrow=%s | %s",j,sm.elapsed,fmt(sm.arrow),h and ("Head="..fmt(h.pos).." | Distance="..string.format("%.3f",h.distance)) or "Head unavailable"))
  end
 end
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V21.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V21",Text="Synchronized arrow/head report copied",Duration=5}) end)
print(output)
