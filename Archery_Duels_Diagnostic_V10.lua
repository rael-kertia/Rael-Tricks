-- Archery Duels Diagnostic V10
-- READ-ONLY inspection of PlayerClone models and their hitboxes.
-- No firing, aim changes, camera movement, or remote calls.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local lp=Players.LocalPlayer
local out={}
local function put(s) out[#out+1]=tostring(s) end
local function vstr(v) return string.format("(%.2f, %.2f, %.2f)",v.X,v.Y,v.Z) end
local function safePath(o)
    local ok,res=pcall(function() return o:GetFullName() end)
    return ok and res or "?"
end
local function attrs(o)
    local a={}
    local ok,t=pcall(function() return o:GetAttributes() end)
    if ok then
        for k,v in pairs(t) do
            local s=tostring(v)
            if #s>80 then s=s:sub(1,80) end
            a[#a+1]=k.."="..s
        end
    end
    table.sort(a)
    return #a>0 and table.concat(a,", ") or "(none)"
end
put("=== ARCHERY DUELS DIAGNOSTIC V10 ===")
put("READ-ONLY | PlaceId="..game.PlaceId.." | Player="..lp.Name.." | UserId="..lp.UserId)
local matches={}
for _,o in ipairs(Workspace:GetDescendants()) do
    if o:IsA("Model") and (o.Name:find("PlayerClone") or o.Name=="PlayerClone_"..lp.Name) then
        local hum=o:FindFirstChildOfClass("Humanoid")
        local head=o:FindFirstChild("Head",true)
        if hum or head then matches[#matches+1]={model=o,hum=hum,head=head} end
    end
end
put("-- CLONE MODEL SCAN --")
put("CloneModelsFound="..#matches)
for i,item in ipairs(matches) do
    local m,h,hum=item.model,item.head,item.hum
    put("MODEL "..i..": "..m.Name)
    put("Path="..safePath(m))
    put("Class="..m.ClassName.." | Parent="..(m.Parent and m.Parent.Name or "nil"))
    put("Attributes="..attrs(m))
    put("Humanoid="..(hum and ("Health="..hum.Health.."/"..hum.MaxHealth.." | DisplayName="..hum.DisplayName.." | RigType="..tostring(hum.RigType).." | State="..tostring(hum:GetState())) or "none"))
    if h and h:IsA("BasePart") then
        put("HeadPos="..vstr(h.Position).." | Size="..vstr(h.Size).." | CanCollide="..tostring(h.CanCollide).." | CanTouch="..tostring(h.CanTouch).." | CanQuery="..tostring(h.CanQuery))
    else
        put("Head=missing")
    end
    local parts={}
    for _,d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") then parts[#parts+1]=d end
    end
    put("BaseParts="..#parts)
    for j=1,math.min(#parts,35) do
        local p=parts[j]
        put(string.format("  %d) %s | Pos=%s | Size=%s | Transparency=%.2f | Collision=%s | Touch=%s | Query=%s",
            j,p.Name,vstr(p.Position),vstr(p.Size),p.Transparency,tostring(p.CanCollide),tostring(p.CanTouch),tostring(p.CanQuery)))
    end
    local scripts={}
    for _,d in ipairs(m:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
            scripts[#scripts+1]=d.Name.." ("..d.ClassName..")"
        end
    end
    put("ScriptsInsideModel="..(#scripts>0 and table.concat(scripts,", ") or "(none visible)"))
end
put("-- PLAYER CHARACTER CLONES --")
for _,plr in ipairs(Players:GetPlayers()) do
    local found=0
    for _,item in ipairs(matches) do
        if item.model.Name=="PlayerClone_"..plr.Name then found=found+1 end
    end
    if found>0 then put(plr.Name.." | UserId="..plr.UserId.." | MatchingClones="..found) end
end
put("-- END --")
local result=table.concat(out,"\n")
local saved=pcall(function() if writefile then writefile("Archery_Duels_Diagnostic_V10.txt",result) end end)
local copied=pcall(function() if setclipboard then setclipboard(result) end end)
if saved or copied then
    print("Archery Duels V10 complete. "..(saved and "File saved. " or "")..(copied and "Copied. " or ""))
else
    warn(result)
end
