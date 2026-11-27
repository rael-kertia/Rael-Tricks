-- Archery Duels Diagnostic V3
-- Read-only snapshot. Does not fire, change aim, or invoke remotes.
-- Run after aiming toward a visible opponent.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local char = lp.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local function v3(v)
    if typeof(v) ~= "Vector3" then return "nil" end
    return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
end
local out = {}
local function put(s) out[#out+1] = tostring(s) end
put("=== ARCHERY DUELS DIAGNOSTIC V3 ===")
put("PlaceId: "..game.PlaceId.." | Player: "..lp.Name.." | UserId: "..lp.UserId)
put("Gravity: "..Workspace.Gravity)
if root then put("Root: "..v3(root.Position).." | Vel: "..v3(root.AssemblyLinearVelocity)) end
if camera then
    put("CameraPos: "..v3(camera.CFrame.Position))
    put("CameraLook: "..v3(camera.CFrame.LookVector).." | FOV: "..camera.FieldOfView)
end
local tool = char and char:FindFirstChildOfClass("Tool")
put("Tool: "..tostring(tool and tool.Name))
put("-- TARGET CANDIDATES (closest to camera direction) --")
local candidates = {}
if camera then
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local c = p.Character
            local h = c and c:FindFirstChild("Head")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if h then
                local delta = h.Position - camera.CFrame.Position
                local dist = delta.Magnitude
                local dot = dist > 0 and camera.CFrame.LookVector:Dot(delta.Unit) or -1
                candidates[#candidates+1] = {name=p.Name, head=h.Position, root=r and r.Position, vel=r and r.AssemblyLinearVelocity, hp=hum and hum.Health, max=hum and hum.MaxHealth, dist=dist, dot=dot}
            end
        end
    end
    table.sort(candidates,function(a,b) return a.dot>b.dot end)
end
put("StreamedHeads: "..#candidates)
for i=1,math.min(#candidates,8) do
    local t=candidates[i]
    put(string.format("%d) %s | Head=%s | Root=%s | Vel=%s | Dist=%.1f | AimDot=%.4f | HP=%s/%s",
        i,t.name,v3(t.head),v3(t.root),v3(t.vel),t.dist,t.dot,tostring(t.hp),tostring(t.max)))
end
put("-- TRAJECTORY DOTS --")
local folder = Workspace:FindFirstChild("ArcheryTrajectory")
local dots = {}
if folder then
    for _,obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name=="TrajectoryDot" then
            local pos=obj.Position
            if pos.Magnitude > 0.01 then
                dots[#dots+1]={pos=pos,dist=root and (pos-root.Position).Magnitude or 0}
            end
        end
    end
end
table.sort(dots,function(a,b) return a.dist<b.dist end)
put("ValidDotCount: "..#dots.." | InvalidZeroDotsExcluded: "..tostring(folder and #folder:GetDescendants() or 0 - #dots))
if #dots>0 then
    local picks={1, math.max(1,math.floor(#dots*.25)), math.max(1,math.floor(#dots*.5)), math.max(1,math.floor(#dots*.75)), #dots}
    local seen={}
    for _,idx in ipairs(picks) do
        if not seen[idx] then
            seen[idx]=true
            put(string.format("Path%02d (index %d/%d, dist %.2f): %s",#out,idx,#dots,dots[idx].dist,v3(dots[idx].pos)))
        end
    end
    local first,last=dots[1].pos,dots[#dots].pos
    put("PathStart: "..v3(first))
    put("PathEnd: "..v3(last))
    put("PathDelta: "..v3(last-first))
else
    put("No valid TrajectoryDot found")
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V3.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V3 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
