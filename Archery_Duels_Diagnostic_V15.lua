-- ARCHERY DUELS DIAGNOSTIC V15
-- READ-ONLY LIVE SAMPLER. User manually fires ONE normal arrow after script starts.
-- No firing, remotes, aim changes, or movement by this script.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local lines = {}
local function add(s) lines[#lines+1] = tostring(s) end
local function fmt(v)
    if typeof(v)=="Vector3" then return string.format("(%.3f, %.3f, %.3f)",v.X,v.Y,v.Z) end
    return tostring(v)
end
local function attr(o,k)
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
local function getSlot()
    local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local x=root and root.Position.X or 0
    local best,dist=nil,math.huge
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name=="StuckArrow" then
            local origin=attr(o,"LaunchOrigin")
            local slot=attr(o,"ArenaSlot")
            if typeof(origin)=="Vector3" and type(slot)=="string" then
                local d=math.abs(origin.X-x)
                if d<dist then best,dist=slot,d end
            end
        end
    end
    return best
end
local slot=getSlot()
local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local localX=root and root.Position.X or 0
local tool=player.Character and player.Character:FindFirstChildOfClass("Tool")
local handle=tool and tool:FindFirstChild("Handle")
local initial={}
for _,o in ipairs(Workspace:GetDescendants()) do
    if o.Name=="StuckArrow" and attr(o,"ArenaSlot")==slot then initial[o]=true end
end
add("=== ARCHERY DUELS DIAGNOSTIC V15 ===")
add("READ-ONLY LIVE SAMPLE | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
add("ArenaSlot="..tostring(slot).." | LocalX="..string.format("%.2f",localX))
add("Tool="..(tool and tool.Name or "nil").." | Handle="..(handle and fmt(handle.Position) or "nil"))
add("ExistingLocalLaneStuckArrows="..tostring((function() local n=0 for _ in pairs(initial) do n+=1 end return n end)()))
add("READY: Fire exactly ONE normal arrow now. Sampling for up to 6 seconds.")
local target, targetName=nil,nil
local samples={}
local start=os.clock()
local lastRecord=0
local stableSince=nil
while os.clock()-start<6 do
    local best,bestDist=nil,math.huge
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name~="StuckArrow" and (o:IsA("BasePart") or o:IsA("Model")) then
            local n=string.lower(o.Name)
            if string.find(n,"arrow",1,true) or string.find(n,"projectile",1,true) or string.find(n,"bolt",1,true) then
                local p=getPos(o)
                local arena=attr(o,"ArenaSlot")
                if p and math.abs(p.X-localX)<80 and (not slot or not arena or arena==slot) then
                    local d=(p-((handle and handle.Position) or (root and root.Position) or p)).Magnitude
                    if d<bestDist then best,bestDist=o,d end
                end
            end
        end
    end
    if best then
        if best~=target then
            target=best
            targetName=target:GetFullName()
            samples={}
            stableSince=nil
            add("ProjectileCandidate="..targetName.." | Class="..target.ClassName.." | Attrs="..(function()
                local a={} for k,v in pairs(target:GetAttributes()) do a[#a+1]=k.."="..fmt(v) end table.sort(a) return table.concat(a,";")
            end)())
        end
        local now=os.clock()-start
        if now-lastRecord>=0.04 then
            local p=getPos(target)
            if p then
                local vel
                if target:IsA("BasePart") then
                    local ok,v=pcall(function() return target.AssemblyLinearVelocity end)
                    if ok then vel=v end
                end
                table.insert(samples,{t=now,p=p,v=vel})
                lastRecord=now
                if vel and vel.Magnitude<0.15 then
                    stableSince=stableSince or now
                else
                    stableSince=nil
                end
            end
        end
    end
    if stableSince and os.clock()-start-stableSince>0.7 then break end
    RunService.Heartbeat:Wait()
end
add("-- LIVE POSITION SAMPLES --")
add("TrackedObject="..tostring(targetName).." | SampleCount="..#samples)
for i,s in ipairs(samples) do
    add(string.format("%03d) t=%.4f | Pos=%s | AssemblyVelocity=%s",i,s.t,fmt(s.p),fmt(s.v)))
end
add("-- DERIVED SEGMENT VELOCITIES --")
for i=2,#samples do
    local a,b=samples[i-1],samples[i]
    local dt=b.t-a.t
    if dt>0 then
        local v=(b.p-a.p)/dt
        add(string.format("%03d) t=%.4f..%.4f | dt=%.4f | V=%s | Speed=%.3f",i-1,a.t,b.t,dt,fmt(v),v.Magnitude))
    end
end
add("-- NEW STUCK ARROW METADATA --")
local stuckCount=0
for _,o in ipairs(Workspace:GetDescendants()) do
    if o.Name=="StuckArrow" and attr(o,"ArenaSlot")==slot and not initial[o] then
        stuckCount+=1
        local fields={}
        for k,v in pairs(o:GetAttributes()) do fields[#fields+1]=k.."="..fmt(v) end
        table.sort(fields)
        add(stuckCount..") "..o:GetFullName().." | Pos="..fmt(getPos(o)).." | "..table.concat(fields," | "))
    end
end
add("NewLocalLaneStuckArrows="..stuckCount)
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V15.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V15",Text="Sample finished; report copied",Duration=5}) end)
print(output)
