-- ARCHERY DUELS DIAGNOSTIC V19
-- READ-ONLY: captures the user's new arrow and tracks streamed opponent-clone/player Heads.
-- No firing, remote calls, aim changes, movement, or character interaction.

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
local ownCloneName="PlayerClone_"..player.Name
local seen={}
-- Ignore arrows that already existed before the test starts.
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
 if typeof(origin)~="Vector3" or typeof(vel)~="Vector3" or type(t)~="number" or typeof(impact)~="Vector3" then return end
 seen[o]=true
 local rec={object=o,origin=origin,vel=vel,t=t,impact=impact,launch=attr(o,"LaunchTime"),slot=a,samples={},targets={}}
 table.insert(captured,rec)
 task.spawn(function()
  local began=os.clock()
  local nextScan=0
  while os.clock()-began<math.min(t+0.6,4.8) do
   local now=os.clock()
   if now>=nextScan then
    nextScan=now+0.08
    local elapsed=rec.launch and (unixNow()-rec.launch) or (now-began)
    local arrowPos
    pcall(function() arrowPos=o.Position end)
    local projectile=origin+vel*elapsed+Vector3.new(0,-0.5*G*elapsed*elapsed,0)
    local sample={elapsed=elapsed,arrow=arrowPos,projectile=projectile,heads={}}
    local function addHead(model,head)
     if not model or not head or not head:IsA("BasePart") then return end
     local name=model.Name
     if name==ownCloneName or model==player.Character then return end
     local p=head.Position
     local dImpact=(p-impact).Magnitude
     local dFlight=(p-projectile).Magnitude
     sample.heads[name]={pos=p,dImpact=dImpact,dFlight=dFlight}
     local stat=rec.targets[name]
     if not stat then
      stat={modelName=name,count=0,bestFlight=math.huge,bestImpact=math.huge,bestFlightPos=nil,bestImpactPos=nil,bestElapsed=0,first=p,last=p}
      rec.targets[name]=stat
     end
     stat.count=stat.count+1
     stat.last=p
     if dFlight<stat.bestFlight then
      stat.bestFlight=dFlight
      stat.bestFlightPos=p
      stat.bestElapsed=elapsed
      stat.bestProjectile=projectile
     end
     if dImpact<stat.bestImpact then
      stat.bestImpact=dImpact
      stat.bestImpactPos=p
      stat.bestImpactElapsed=elapsed
     end
    end
    -- Track all streamed opponent clone heads, not just ImpactVictim.
    for _,m in ipairs(Workspace:GetDescendants()) do
     if m:IsA("Model") and m.Name:match("^PlayerClone_") and m.Name~=ownCloneName then
      local h=m:FindFirstChild("Head",true)
      if h then addHead(m,h) end
     end
    end
    -- Also track actual streamed player characters other than the local player.
    for _,plr in ipairs(Players:GetPlayers()) do
     if plr~=player and plr.Character then
      local h=plr.Character:FindFirstChild("Head",true)
      if h then addHead(plr.Character,h) end
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
add("=== ARCHERY DUELS DIAGNOSTIC V19 ===")
add("READ-ONLY OPPONENT-HEAD TRACKING | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",localX).." | GravityModel="..G)
add("Own clone excluded: "..ownCloneName)
add("READY: Fire exactly ONE normal arrow. Tracking all streamed opponent clone/player Heads.")
local deadline=os.clock()+7
while os.clock()<deadline do
 for _,o in ipairs(Workspace:GetDescendants()) do capture(o) end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
task.wait(0.2)
add("-- OWNED ARROW / OPPONENT HEAD VALIDATION --")
add("CapturedNewArrows="..#captured)
for i,r in ipairs(captured) do
 local pred=r.origin+r.vel*r.t+Vector3.new(0,-0.5*G*r.t*r.t,0)
 add(string.format("ARROW %02d | ArenaSlot=%s | ImpactT=%.4f | Hit=%s | HeadHit=%s | Victim=%s",i,tostring(r.slot),r.t,tostring(attr(r.object,"HitCharacter")),tostring(attr(r.object,"ImpactHead")),tostring(attr(r.object,"ImpactVictim"))))
 add("Origin="..fmt(r.origin).." | LaunchVel="..fmt(r.vel).." | ImpactPos="..fmt(r.impact))
 add("PredictedImpact_G16.47="..fmt(pred).." | BallisticError="..string.format("%.4f",(pred-r.impact).Magnitude))
 add("LaunchTime="..tostring(r.launch).." | MotionSamples="..#r.samples.." | OpponentHeadCandidates="..(function() local n=0 for _ in pairs(r.targets) do n=n+1 end return n end)())
 local ranked={}
 for _,s in pairs(r.targets) do table.insert(ranked,s) end
 table.sort(ranked,function(a,b) return a.bestFlight<b.bestFlight end)
 if #ranked==0 then
  add("NO OPPONENT HEAD FOUND: no streamed PlayerClone_ (other than own clone) or other player Head during capture.")
 else
  add("-- CANDIDATE HEADS (sorted by closest approach to predicted arrow path) --")
  for j=1,math.min(10,#ranked) do
   local s=ranked[j]
   add(string.format("%02d) %s | Samples=%d | ClosestArrowHead=%.3f studs at t=%.4f | Head=%s | PredictedArrow=%s | ClosestImpactHead=%.3f at t=%.4f | LastHead=%s",j,s.modelName,s.count,s.bestFlight,s.bestElapsed,fmt(s.bestFlightPos),fmt(s.bestProjectile),s.bestImpact,s.bestImpactElapsed,fmt(s.last)))
  end
 end
 add("-- HEAD MOTION CHECKPOINTS --")
 local total=#r.samples
 if total>0 then
  local count=math.min(8,total)
  for j=1,count do
   local idx=math.floor(1+(j-1)*(total-1)/math.max(1,count-1))
   local s=r.samples[idx]
   local names={}
   for name,h in pairs(s.heads) do table.insert(names,name.."="..fmt(h.pos)) end
   table.sort(names)
   add(string.format("%02d) t=%.4f PredictedArrow=%s | %s",j,s.elapsed,fmt(s.projectile),#names>0 and table.concat(names," ; ") or "No opponent Heads streamed"))
  end
 end
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V19.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V19",Text="Opponent-head report copied",Duration=5}) end)
print(output)
