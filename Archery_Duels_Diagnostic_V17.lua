-- ARCHERY DUELS DIAGNOSTIC V17
-- READ-ONLY: manually fire ONE normal arrow after READY.
-- Checks the empirically estimated arrow gravity against this player's own arrow metadata.
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
local function getAttr(o,k)
 local ok,v=pcall(function() return o:GetAttribute(k) end)
 return ok and v or nil
end
local function getPos(o)
 if o:IsA("BasePart") then return o.Position end
 if o:IsA("Model") then
  local p=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
  return p and p.Position
 end
end
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local localX=root and root.Position.X or 0
local slot=nil
local nearest=math.huge
for _,o in ipairs(Workspace:GetDescendants()) do
 if o.Name=="StuckArrow" then
  local origin=getAttr(o,"LaunchOrigin")
  local arena=getAttr(o,"ArenaSlot")
  if typeof(origin)=="Vector3" and type(arena)=="string" then
   local d=math.abs(origin.X-localX)
   if d<nearest then nearest=d slot=arena end
  end
 end
end
local candidates={}
local seen={}
local function inspect(o)
 if seen[o] then return end
 if o.Name~="PlayerArrow" and o.Name~="StuckArrow" then return end
 local arena=getAttr(o,"ArenaSlot")
 local owner=getAttr(o,"OwnerUserId")
 local origin=getAttr(o,"LaunchOrigin")
 local vel=getAttr(o,"LaunchVel")
 local t=getAttr(o,"ImpactT")
 local impact=getAttr(o,"ImpactPos")
 if arena~=slot or owner~=player.UserId then return end
 if typeof(origin)~="Vector3" or typeof(vel)~="Vector3" or type(t)~="number" or typeof(impact)~="Vector3" then return end
 seen[o]=true
 table.insert(candidates,o)
end
for _,o in ipairs(Workspace:GetDescendants()) do inspect(o) end
local conn=Workspace.DescendantAdded:Connect(function(o)
 if o.Name=="PlayerArrow" or o.Name=="StuckArrow" then
  task.defer(function() inspect(o) end)
 end
end)
add("=== ARCHERY DUELS DIAGNOSTIC V17 ===")
add("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",localX))
add("GravityTest="..G.." | ExistingOwnedArrows="..#candidates)
add("READY: Fire exactly ONE normal arrow now. Monitoring own arrows for 7 seconds.")
local start=os.clock()
local prevCount=#candidates
while os.clock()-start<7 do
 for _,o in ipairs(Workspace:GetDescendants()) do inspect(o) end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
add("-- OWN ARROW BALLISTIC VALIDATION --")
add("OwnedArrowCount="..#candidates)
local function findNamedModel(name)
 if type(name)~="string" then return nil end
 for _,o in ipairs(Workspace:GetDescendants()) do
  if o:IsA("Model") and o.Name==name then return o end
 end
 return nil
end
for i,o in ipairs(candidates) do
 local origin=getAttr(o,"LaunchOrigin")
 local vel=getAttr(o,"LaunchVel")
 local t=getAttr(o,"ImpactT")
 local impact=getAttr(o,"ImpactPos")
 local predicted=origin+vel*t+Vector3.new(0,-0.5*G*t*t,0)
 local error=(predicted-impact).Magnitude
 local gDerived
 if t>0 then gDerived=2*(origin.Y+vel.Y*t-impact.Y)/(t*t) end
 local victim=getAttr(o,"ImpactVictim")
 local headPos=nil
 local model=findNamedModel(victim)
 if model then
  local head=model:FindFirstChild("Head",true)
  if head and head:IsA("BasePart") then headPos=head.Position end
 end
 add(string.format("ARROW %02d | %s | Class=%s",i,o:GetFullName(),o.ClassName))
 add("OwnerUserId="..tostring(getAttr(o,"OwnerUserId")).." | Victim="..tostring(victim).." | HitCharacter="..tostring(getAttr(o,"HitCharacter")).." | ImpactHead="..tostring(getAttr(o,"ImpactHead")))
 add("Origin="..fmt(origin).." | LaunchVel="..fmt(vel).." | ImpactT="..string.format("%.6f",t))
 add("ImpactPos="..fmt(impact).." | PredictedImpact_G16.47="..fmt(predicted).." | Error="..string.format("%.4f",error))
 add("GravityDerivedFromImpact="..string.format("%.5f",gDerived or -1))
 add("TargetHead="..fmt(headPos).." | HeadToImpactDistance="..(headPos and string.format("%.4f",(headPos-impact).Magnitude) or "unavailable"))
 add("CurrentArrowPosition="..fmt(getPos(o)).." | Attributes="..(function()
  local a={} for k,v in pairs(o:GetAttributes()) do a[#a+1]=k.."="..fmt(v) end table.sort(a) return table.concat(a,";")
 end)())
end
add("-- INTERPRETATION --")
if #candidates==0 then
 add("No owned arrow with complete launch/impact attributes was found in this ArenaSlot during the capture window.")
else
 add("Compare Error values across arrows. Small errors support G=16.47; large errors mean gravity/model needs revision.")
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V17.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V17",Text="Validation complete; report copied",Duration=5}) end)
print(output)
