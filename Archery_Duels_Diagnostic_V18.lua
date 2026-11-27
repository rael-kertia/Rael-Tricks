-- ARCHERY DUELS DIAGNOSTIC V18
-- READ-ONLY live capture of a newly fired owned arrow and its victim's moving Head.
-- Does not fire, invoke remotes, move player, or change aim.

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
local startUnix=unixNow()
local captured={}
local seen={}
local function capture(o)
 if seen[o] or o.Name~="PlayerArrow" then return end
 if attr(o,"OwnerUserId")~=player.UserId or attr(o,"ArenaSlot")~=slot then return end
 local origin,vel,t,impact=attr(o,"LaunchOrigin"),attr(o,"LaunchVel"),attr(o,"ImpactT"),attr(o,"ImpactPos")
 local launch=attr(o,"LaunchTime")
 if typeof(origin)~="Vector3" or typeof(vel)~="Vector3" or type(t)~="number" or typeof(impact)~="Vector3" then return end
 if type(launch)=="number" and launch<startUnix-0.35 then return end
 seen[o]=true
 local victim=attr(o,"ImpactVictim")
 local model
 if type(victim)=="string" then
  model=Workspace:FindFirstChild(victim,true)
 end
 local rec={object=o,origin=origin,vel=vel,t=t,impact=impact,launch=launch,victim=victim,model=model,samples={}}
 table.insert(captured,rec)
 task.spawn(function()
  local began=os.clock()
  while os.clock()-began<math.min(t+0.5,4.5) do
   local elapsed=launch and (unixNow()-launch) or (os.clock()-began)
   local head=nil
   if rec.model and rec.model.Parent then
    head=rec.model:FindFirstChild("Head",true)
    if head and not head:IsA("BasePart") then head=nil end
   end
   local headPos=head and head.Position or nil
   local arrowPos
   pcall(function() arrowPos=o.Position end)
   table.insert(rec.samples,{elapsed=elapsed,arrow=arrowPos,head=headPos})
   RunService.Heartbeat:Wait()
  end
 end)
end
for _,o in ipairs(Workspace:GetDescendants()) do capture(o) end
local conn=Workspace.DescendantAdded:Connect(function(o)
 if o.Name=="PlayerArrow" then task.defer(function() capture(o) end) end
end)
add("=== ARCHERY DUELS DIAGNOSTIC V18 ===")
add("READ-ONLY LIVE TARGET-HEAD CAPTURE | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",localX).." | GravityModel="..G)
add("READY: Fire exactly ONE normal arrow now. Capturing arrow and victim Head motion.")
local deadline=os.clock()+7
while os.clock()<deadline do
 for _,o in ipairs(Workspace:GetDescendants()) do capture(o) end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
task.wait(0.15)
add("-- NEW OWNED ARROW / MOVING HEAD VALIDATION --")
add("CapturedNewArrows="..#captured)
for i,r in ipairs(captured) do
 local pred=r.origin+r.vel*r.t+Vector3.new(0,-0.5*G*r.t*r.t,0)
 local err=(pred-r.impact).Magnitude
 local best,bestD=nil,math.huge
 local headCount=0
 for _,s in ipairs(r.samples) do
  if s.head then
   headCount=headCount+1
   local d=(s.head-r.impact).Magnitude
   if d<bestD then bestD=d best=s end
  end
 end
 add(string.format("ARROW %02d | Victim=%s | ImpactT=%.4f | Hit=%s | HeadHit=%s",i,tostring(r.victim),r.t,tostring(attr(r.object,"HitCharacter")),tostring(attr(r.object,"ImpactHead"))))
 add("Origin="..fmt(r.origin).." | LaunchVel="..fmt(r.vel).." | ImpactPos="..fmt(r.impact))
 add("PredictedImpact_G16.47="..fmt(pred).." | BallisticError="..string.format("%.4f",err))
 add("LaunchTime="..tostring(r.launch).." | MotionSamples="..#r.samples.." | SamplesWithHead="..headCount)
 if best then
  add("ClosestRecordedHead="..fmt(best.head).." | HeadToImpact="..string.format("%.4f",bestD).." | SampleElapsedSinceLaunch="..string.format("%.4f",best.elapsed))
  add("ArrowAtClosestHeadSample="..fmt(best.arrow))
 else
  add("VictimHeadMotion=UNAVAILABLE (victim model/head not streamed during capture)")
 end
 local n=#r.samples
 if n>0 then
  add("-- MOTION CHECKPOINTS (max 12) --")
  local count=math.min(12,n)
  for j=1,count do
   local idx=math.floor(1+(j-1)*(n-1)/math.max(1,count-1))
   local s=r.samples[idx]
   add(string.format("%02d) t=%.4f Arrow=%s Head=%s",j,s.elapsed,fmt(s.arrow),fmt(s.head)))
  end
 end
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V18.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V18",Text="Target-head report copied",Duration=5}) end)
print(output)
