-- ARCHERY DUELS DIAGNOSTIC V14
-- READ-ONLY: filters arrows to the local ArenaSlot and reconstructs ballistic paths.
-- Does not fire, invoke remotes, change aim, or move the character.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local lines = {}
local function add(s) lines[#lines+1] = tostring(s) end
local function fmt(v)
    if typeof(v) == "Vector3" then
        return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
    end
    return tostring(v)
end
local function attr(o, name)
    local ok, v = pcall(function() return o:GetAttribute(name) end)
    return ok and v or nil
end
local function getArenaSlot()
    local slot
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local x = root and root.Position.X or 0
    local best, bestDist = nil, math.huge
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o.Name == "StuckArrow" then
            local origin = attr(o, "LaunchOrigin")
            local arena = attr(o, "ArenaSlot")
            if typeof(origin) == "Vector3" and typeof(arena) == "string" then
                local d = math.abs(origin.X - x)
                if d < bestDist then bestDist, best = d, arena end
            end
        end
    end
    return best, bestDist
end
local function ballistic(origin, velocity, t)
    return origin + velocity*t + Vector3.new(0, -Workspace.Gravity*0.5*t*t, 0)
end
local function isLocalLane(o, slot, localX)
    if attr(o, "ArenaSlot") ~= slot then return false end
    local origin = attr(o, "LaunchOrigin")
    if typeof(origin) ~= "Vector3" then return false end
    if math.abs(origin.X-localX) > 20 then return false end
    local owner = attr(o, "OwnerUserId")
    if owner ~= nil and tonumber(owner) ~= player.UserId then return false end
    return true
end
add("=== ARCHERY DUELS DIAGNOSTIC V14 ===")
add("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..player.Name.."/"..player.UserId)
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local localX = root and root.Position.X or 0
local slot, slotDist = getArenaSlot()
add("LocalRoot="..(root and fmt(root.Position) or "nil"))
add("DetectedLocalArenaSlot="..tostring(slot).." | NearestKnownArrowLaneDeltaX="..string.format("%.2f",slotDist))
if not slot then
    add("ERROR: Could not infer local ArenaSlot from existing arrows.")
else
    add("-- MATCHING ARROWS --")
    local matches = {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o.Name == "StuckArrow" and isLocalLane(o,slot,localX) then
            table.insert(matches,o)
        end
    end
    add("MatchingStuckArrows="..#matches)
    for i,o in ipairs(matches) do
        local origin = attr(o,"LaunchOrigin")
        local velocity = attr(o,"LaunchVel")
        local impact = attr(o,"ImpactPos")
        local impactT = attr(o,"ImpactT")
        local launchTime = attr(o,"LaunchTime")
        local owner = attr(o,"OwnerUserId")
        local victim = attr(o,"ImpactVictim")
        local hit = attr(o,"HitCharacter")
        local head = attr(o,"ImpactHead")
        local spin = attr(o,"SpinSlot")
        local damage = attr(o,"BaseDamage")
        add(string.format("%02d) %s | Owner=%s | Victim=%s | Hit=%s | Head=%s | Damage=%s | Spin=%s",
            i,o:GetFullName(),tostring(owner),tostring(victim),tostring(hit),tostring(head),tostring(damage),tostring(spin)))
        add("    LaunchOrigin="..fmt(origin).." | LaunchVel="..fmt(velocity))
        add("    ImpactPos="..fmt(impact).." | ImpactT="..tostring(impactT).." | LaunchTime="..tostring(launchTime))
        if typeof(origin)=="Vector3" and typeof(velocity)=="Vector3" and type(impactT)=="number" and typeof(impact)=="Vector3" then
            local predicted = ballistic(origin,velocity,impactT)
            local errorDist = (predicted-impact).Magnitude
            add("    BallisticPredictedImpact="..fmt(predicted).." | ErrorVsImpactPos="..string.format("%.3f",errorDist))
            local times = {0, impactT*0.25, impactT*0.5, impactT*0.75, impactT}
            local chunks = {}
            for _,t in ipairs(times) do
                table.insert(chunks,string.format("t=%.3f:%s",t,fmt(ballistic(origin,velocity,t))))
            end
            add("    PathSamples "..table.concat(chunks," | "))
        else
            add("    PathSamples unavailable: missing origin/velocity/impact data")
        end
    end
    add("-- LIVE MATCHING ARROW OBJECTS --")
    local liveCount=0
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") or o:IsA("Model") then
            local n=string.lower(o.Name)
            if (string.find(n,"arrow",1,true) or string.find(n,"projectile",1,true) or string.find(n,"bolt",1,true))
                and attr(o,"ArenaSlot")==slot then
                local p
                if o:IsA("BasePart") then p=o.Position
                else
                    local r=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart
                    p=r and r.Position
                end
                liveCount+=1
                if liveCount<=30 then
                    add(string.format("%02d) %s | Pos=%s | LaunchOrigin=%s | LaunchVel=%s | Owner=%s",
                        liveCount,o:GetFullName(),fmt(p),fmt(attr(o,"LaunchOrigin")),fmt(attr(o,"LaunchVel")),tostring(attr(o,"OwnerUserId"))))
                end
            end
        end
    end
    add("LiveMatchingNamedObjects="..liveCount)
end
add("-- END --")
local output=table.concat(lines,"\n")
if writefile then pcall(writefile,"Archery_Duels_Diagnostic_V14.txt",output) end
if setclipboard then pcall(setclipboard,output) end
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="Archery Duels V14",Text="Local arena report copied",Duration=5})
end)
print(output)
