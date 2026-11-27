-- ARCHERY DUELS DIAGNOSTIC V16
-- READ-ONLY. Captures newly added Workspace objects during one manual shot.
-- Does not fire, invoke remotes, move player, or change aim.

local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local lines={}
local function add(s) lines[#lines+1]=tostring(s) end
local function fmt(v)
 if typeof(v)=="Vector3" then return string.format("(%.3f, %.3f, %.3f)",v.X,v.Y,v.Z) end
 return tostring(v)
end
local function safeAttr(o)
 local out={}
 local ok,a=pcall(function() return o:GetAttributes() end)
 if ok then for k,v in pairs(a) do out[#out+1]=k.."="..fmt(v) end end
 table.sort(out)
 return table.concat(out,";")
end
local function pos(o)
 if o:IsA("BasePart") then return o.Position end
 if o:IsA("Model") then
  local p=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
  return p and p.Position
 end
end
local function velocity(o)
 if o:IsA("BasePart") then
  local ok,v=pcall(function() return o.AssemblyLinearVelocity end)
  if ok then return v end
 end
end
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local x=root and root.Position.X or 0
local slot=nil
local best=math.huge
for _,o in ipairs(Workspace:GetDescendants()) do
 if o.Name=="StuckArrow" then
  local ok,origin,arena=pcall(function() return o:GetAttribute("LaunchOrigin"),o:GetAttribute("ArenaSlot") end)
  if ok and typeof(origin)=="Vector3" and type(arena)=="string" then
   local d=math.abs(origin.X-x)
   if d<best then best=d slot=arena end
  end
 end
end
local known={}
for _,o in ipairs(Workspace:GetDescendants()) do known[o]=true end
local captured={}
local function relevant(o)
 local p=pos(o)
 if not p or math.abs(p.X-x)>100 then return false end
 local a=safeAttr(o)
 local n=string.lower(o.Name)
 return string.find(n,"arrow",1,true) or string.find(n,"projectile",1,true)
  or string.find(n,"bolt",1,true) or string.find(a,"LaunchOrigin",1,true)
  or string.find(a,"LaunchVel",1,true) or string.find(a,"ImpactPos",1,true)
end
local conn=Workspace.DescendantAdded:Connect(function(o)
 if relevant(o) then captured[o]=true end
end)
add("=== ARCHERY DUELS DIAGNOSTIC V16 ===")
add("READ-ONLY EVENT CAPTURE | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",x))
add("READY: Fire exactly ONE normal arrow now. Capturing new Workspace objects for 7 seconds.")
local start=os.clock()
local seen={}
local records={}
while os.clock()-start<7 do
 for o in pairs(captured) do
  if not seen[o] then
   seen[o]=true
   local rec={obj=o,path=o:GetFullName(),class=o.ClassName,attrs=safeAttr(o),samples={}}
   records[#records+1]=rec
  end
 end
 for _,r in ipairs(records) do
  local o=r.obj
  if o and o.Parent then
   local p=pos(o)
   if p and (not r.lastT or os.clock()-r.lastT>=0.035) then
    table.insert(r.samples,{t=os.clock()-start,p=p,v=velocity(o)})
    r.lastT=os.clock()
   end
  end
 end
 RunService.Heartbeat:Wait()
end
conn:Disconnect()
add("-- CAPTURED OBJECTS --")
add("CapturedCount="..#records)
for i,r in ipairs(records) do
 add(string.format("OBJECT %02d | %s | Class=%s",i,r.path,r.class))
 add("InitialAttributes="..r.attrs)
 add("Samples="..#r.samples)
 for j,s in ipairs(r.samples) do
  add(string.format("%03d) t=%.4f | Pos=%s | AssemblyVelocity=%s",j,s.t,fmt(s.p),fmt(s.v)))
 end
 if r.obj and r.obj.Parent then
  add("FinalAttributes="..safeAttr(r.obj))
  add("FinalPosition="..fmt(pos(r.obj)))
 end
end
add("-- NEW STUCK ARROW FULL SCAN --")
local n=0
for _,o in ipairs(Workspace:GetDescendants()) do
 if o.Name=="StuckArrow" then
  local p=pos(o)
  local a=safeAttr(o)
  if p and math.abs(p.X-x)<100 then
   n+=1
   add(n..") "..o:GetFullName().." | Pos="..fmt(p).." | "..a)
  end
 end
end
add("LocalLaneStuckArrowCount="..n)
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V16.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V16",Text="Capture finished; report copied",Duration=5}) end)
print(output)
