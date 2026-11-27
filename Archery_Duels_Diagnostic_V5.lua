-- Archery Duels Diagnostic V5
-- READ-ONLY geometry inspection. Does not fire, change aim, or invoke remotes.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer
local char = lp.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local gui = lp:FindFirstChildOfClass("PlayerGui")
local fireGui = gui and gui:FindFirstChild("FireButtonGui", true)
local aimBar = fireGui and fireGui:FindFirstChild("AimBar", true)
local aimDot = aimBar and aimBar:FindFirstChild("AimDot", true)
local camera = Workspace.CurrentCamera
local out = {}
local function put(s) out[#out+1] = tostring(s) end
local function vstr(v)
    return string.format("(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
end
local function clamp(x,a,b) return math.max(a,math.min(b,x)) end

put("=== ARCHERY DUELS DIAGNOSTIC V5 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Gravity="..Workspace.Gravity)
if not root or not camera then
    put("ERROR: character root or camera missing")
else
    local origin = root.Position
    local look = camera.CFrame.LookVector
    local flat = Vector3.new(look.X,0,look.Z)
    if flat.Magnitude > 0 then flat = flat.Unit end
    local right = Vector3.new(-flat.Z,0,flat.X)
    put("Root="..vstr(origin))
    put("CameraLook="..vstr(look).." | FlatForward="..vstr(flat).." | CameraPos="..vstr(camera.CFrame.Position))
    if aimBar and aimDot then
        put("AimBarAbsPos="..vstr(Vector3.new(aimBar.AbsolutePosition.X,aimBar.AbsolutePosition.Y,0))..
            " | AimBarAbsSize="..vstr(Vector3.new(aimBar.AbsoluteSize.X,aimBar.AbsoluteSize.Y,0)))
        put("AimDotAbsPos="..vstr(Vector3.new(aimDot.AbsolutePosition.X,aimDot.AbsolutePosition.Y,0))..
            " | AimDotYScale="..string.format("%.4f",aimDot.Position.Y.Scale)..
            " | AimDotYOffset="..tostring(aimDot.Position.Y.Offset))
    else
        put("Aim UI missing")
    end

    local folder = Workspace:FindFirstChild("ArcheryTrajectory")
    local pts, total = {}, 0
    if folder then
        for _,obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "TrajectoryDot" then
                total = total + 1
                local p = obj.Position
                if p.Magnitude > 0.01 then
                    local rel = p-origin
                    local forward = rel:Dot(flat)
                    local lateral = rel:Dot(right)
                    local vertical = p.Y-origin.Y
                    pts[#pts+1] = {p=p, f=forward, l=lateral, y=vertical, d=rel.Magnitude}
                end
            end
        end
    end
    put("-- DOT GEOMETRY --")
    put("TotalDots="..total.." | ValidDots="..#pts)
    if #pts > 0 then
        local minF,maxF,minL,maxL,minY,maxY = math.huge,-math.huge,math.huge,-math.huge,math.huge,-math.huge
        for _,q in ipairs(pts) do
            minF=math.min(minF,q.f); maxF=math.max(maxF,q.f)
            minL=math.min(minL,q.l); maxL=math.max(maxL,q.l)
            minY=math.min(minY,q.y); maxY=math.max(maxY,q.y)
        end
        put(string.format("ForwardRange=%.2f..%.2f | LateralRange=%.2f..%.2f | VerticalRange=%.2f..%.2f",minF,maxF,minL,maxL,minY,maxY))
        table.sort(pts,function(a,b) return a.f < b.f end)
        put("-- ORDERED SAMPLES BY CAMERA-FORWARD PROJECTION --")
        local indexes = {1, math.floor((#pts-1)*0.25)+1, math.floor((#pts-1)*0.50)+1, math.floor((#pts-1)*0.75)+1, #pts}
        for n,idx in ipairs(indexes) do
            local q=pts[clamp(idx,1,#pts)]
            put(string.format("%d) idx=%d | Forward=%.2f | Lateral=%.2f | HeightFromRoot=%.2f | Pos=%s",n,idx,q.f,q.l,q.y,vstr(q.p)))
        end
        put("-- FIRST 12 DOTS (FORWARD ORDER) --")
        for i=1,math.min(12,#pts) do
            local q=pts[i]
            put(string.format("%02d F=%.2f L=%.2f Y=%.2f Pos=%s",i,q.f,q.l,q.y,vstr(q.p)))
        end
        put("-- LAST 8 DOTS (FORWARD ORDER) --")
        for i=math.max(1,#pts-7),#pts do
            local q=pts[i]
            put(string.format("%02d F=%.2f L=%.2f Y=%.2f Pos=%s",i,q.f,q.l,q.y,vstr(q.p)))
        end
    else
        put("No valid TrajectoryDot parts found")
    end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V5.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V5 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
