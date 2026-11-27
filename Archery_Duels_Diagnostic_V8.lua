-- Archery Duels Diagnostic V8
-- READ-ONLY quadratic fit of the filtered trajectory and head alignment.
-- Does not fire, alter aim, move camera, or invoke remotes.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local lp=Players.LocalPlayer
local char=lp.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
local folder=Workspace:FindFirstChild("ArcheryTrajectory")
local gui=lp:FindFirstChildOfClass("PlayerGui")
local fireGui=gui and gui:FindFirstChild("FireButtonGui",true)
local aimBar=fireGui and fireGui:FindFirstChild("AimBar",true)
local aimDot=aimBar and aimBar:FindFirstChild("AimDot",true)
local out={}
local function put(s) out[#out+1]=tostring(s) end
local function vstr(v) return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end
local function solve3(m,b)
    local a={{m[1][1],m[1][2],m[1][3],b[1]},
             {m[2][1],m[2][2],m[2][3],b[2]},
             {m[3][1],m[3][2],m[3][3],b[3]}}
    for i=1,3 do
        local pivot=i
        for r=i+1,3 do if math.abs(a[r][i])>math.abs(a[pivot][i]) then pivot=r end end
        if math.abs(a[pivot][i])<1e-10 then return nil end
        a[i],a[pivot]=a[pivot],a[i]
        local d=a[i][i]
        for c=i,4 do a[i][c]=a[i][c]/d end
        for r=1,3 do
            if r~=i then
                local f=a[r][i]
                for c=i,4 do a[r][c]=a[r][c]-f*a[i][c] end
            end
        end
    end
    return a[1][4],a[2][4],a[3][4]
end
local function predict(a,b,c,x) return a*x*x+b*x+c end

put("=== ARCHERY DUELS DIAGNOSTIC V8 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
put("Gravity="..Workspace.Gravity)
if not root then
    put("ERROR: HumanoidRootPart missing")
else
    local origin=root.Position
    put("Root="..vstr(origin))
    if aimDot then put(string.format("AimDotYScale=%.4f",aimDot.Position.Y.Scale)) end
    local raw={}
    local total=0
    if folder then
        for _,o in ipairs(folder:GetDescendants()) do
            if o:IsA("BasePart") and o.Name=="TrajectoryDot" then
                total=total+1
                if o.Position.Magnitude>0.01 then raw[#raw+1]=o.Position end
            end
        end
    end
    local xs,zs={},{}
    for _,p in ipairs(raw) do xs[#xs+1]=p.X; zs[#zs+1]=p.Z end
    table.sort(xs); table.sort(zs)
    local mx=xs[math.floor((#xs+1)/2)] or origin.X
    local mz=zs[math.floor((#zs+1)/2)] or origin.Z
    local pts={}
    for _,p in ipairs(raw) do
        if math.abs(p.X-mx)<=25 and math.abs(p.Z-mz)<=300 then pts[#pts+1]=p end
    end
    put("-- FILTERED TRAJECTORY --")
    put("TotalDots="..total.." | Valid="..#raw.." | Cluster="..#pts.." | Rejected="..(#raw-#pts))
    if #pts<5 then
        put("ERROR: not enough filtered dots for curve fit")
    else
        local near,far=pts[1],pts[1]
        for _,p in ipairs(pts) do
            if (p-origin).Magnitude<(near-origin).Magnitude then near=p end
            if (p-origin).Magnitude>(far-origin).Magnitude then far=p end
        end
        local flat=Vector3.new(far.X-near.X,0,far.Z-near.Z)
        local axis=flat.Unit
        local side=Vector3.new(-axis.Z,0,axis.X)
        local data={}
        for _,p in ipairs(pts) do
            local rel=p-near
            data[#data+1]={x=rel:Dot(axis),y=p.Y-origin.Y,l=rel:Dot(side),p=p}
        end
        table.sort(data,function(a,b) return a.x<b.x end)
        -- Fit y = A*x^2 + B*x + C using normal equations.
        local s0,s1,s2,s3,s4,t0,t1,t2=0,0,0,0,0,0,0,0
        for _,q in ipairs(data) do
            local x,y=q.x,q.y
            local x2=x*x
            s0=s0+1; s1=s1+x; s2=s2+x2; s3=s3+x2*x; s4=s4+x2*x2
            t0=t0+y; t1=t1+x*y; t2=t2+x2*y
        end
        local A,B,C=solve3({{s4,s3,s2},{s3,s2,s1},{s2,s1,s0}},{t2,t1,t0})
        put("NearDot="..vstr(near).." | FarDot="..vstr(far))
        put("FlatAxis="..vstr(axis).." | LateralAxis="..vstr(side))
        if A then
            local ss=0
            for _,q in ipairs(data) do local e=q.y-predict(A,B,C,q.x); ss=ss+e*e end
            local rmse=math.sqrt(ss/#data)
            put(string.format("FIT y=A*x^2+B*x+C | A=%.8f | B=%.6f | C=%.4f | RMSE=%.4f",A,B,C,rmse))
            if A<0 then
                local apexX=-B/(2*A)
                local apexY=predict(A,B,C,apexX)
                put(string.format("PredictedApex Forward=%.2f | HeightFromRoot=%.2f",apexX,apexY))
            end
            put(string.format("PreviewForward=%.2f | FitHeightAtEnd=%.2f",data[#data].x,predict(A,B,C,data[#data].x)))
            put("-- STREAMED HEADS / CURVE MISS --")
            local heads={}
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=lp and plr.Character then
                    local h=plr.Character:FindFirstChild("Head")
                    local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h:IsA("BasePart") then
                        local rel=h.Position-near
                        local f=rel:Dot(axis)
                        local lateral=rel:Dot(side)
                        local predicted=predict(A,B,C,f)
                        heads[#heads+1]={name=plr.Name,p=h.Position,f=f,l=lateral,y=h.Position.Y-origin.Y,miss=(h.Position.Y-origin.Y)-predicted,pred=predicted,hp=hum and hum.Health or -1,max=hum and hum.MaxHealth or -1}
                    end
                end
            end
            table.sort(heads,function(a,b) return math.abs(a.l)<math.abs(b.l) end)
            put("StreamedHeads="..#heads)
            for i=1,math.min(12,#heads) do
                local q=heads[i]
                put(string.format("%d) %s | Head=%s | Forward=%.2f | Lateral=%.2f | HeadHeight=%.2f | CurveHeight=%.2f | VerticalMiss=%.2f | HP=%.0f/%.0f",
                    i,q.name,vstr(q.p),q.f,q.l,q.y,q.pred,q.miss,q.hp,q.max))
            end
        else
            put("ERROR: quadratic fit failed")
        end
        put("-- ORDERED CURVE SAMPLES --")
        local ids={1,math.floor((#data-1)*.25)+1,math.floor((#data-1)*.5)+1,math.floor((#data-1)*.75)+1,#data}
        for i,idx in ipairs(ids) do
            local q=data[idx]
            put(string.format("%d) Forward=%.2f HeightFromRoot=%.2f Lateral=%.2f Pos=%s",i,q.x,q.y,q.l,vstr(q.p)))
        end
    end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V8.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then print("Archery Duels V8 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or "")) else warn(result) end
