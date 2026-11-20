-- RAEL'S TRICKS | BLIND BOX ROOT-CAUSE DIAGNOSIS
-- READ ONLY: no hook, no require, no remote call, no UI click, no state mutation.
-- Narrow scan for BlindBox only. Bounded and yields to avoid Android freeze.
local O,seen={},{}
local function out(s) O[#O+1]=tostring(s) end
local function val(v)
 if typeof(v)=="Instance" then
  local ok,s=pcall(function() return v:GetFullName() end)
  return ok and s or v.Name
 end
 if type(v)=="string" then return string.sub(v,1,260) end
 return tostring(v)
end
local function constants(f)
 if not debug or not debug.getconstants then return {} end
 local ok,t=pcall(debug.getconstants,f)
 return ok and type(t)=="table" and t or {}
end
local function upvalues(f)
 if not debug or not debug.getupvalues then return {} end
 local ok,t=pcall(debug.getupvalues,f)
 return ok and type(t)=="table" and t or {}
end
local function dump(f,label,deep)
 if type(f)~="function" or seen[f] then return end
 seen[f]=true
 out("\n[FUNCTION] "..label)
 if debug and debug.getinfo then
  local ok,i=pcall(debug.getinfo,f)
  if ok and i then out("INFO source="..val(i.source).." name="..val(i.name).." line="..val(i.linedefined)) end
 end
 local c=constants(f)
 for i,v in pairs(c) do
  if type(v)=="string" or type(v)=="number" then out(" C"..i.." "..val(v)) end
 end
 local u=upvalues(f)
 for i,v in pairs(u) do
  if type(v)=="function" then
   out(" U"..i.." FUNCTION "..val(v))
   if deep then
    local cc=constants(v)
    for j,x in pairs(cc) do if type(x)=="string" or type(x)=="number" then out("  U"..i..".C"..j.." "..val(x)) end end
   end
  elseif type(v)=="table" then
   out(" U"..i.." TABLE")
   local n=0
   for k,x in pairs(v) do
    n=n+1
    if n>55 then out("  TABLE_LIMIT"); break end
    if type(x)=="function" then out("  ["..val(k).."] FUNCTION")
    elseif type(x)=="table" then out("  ["..val(k).."] TABLE")
    else out("  ["..val(k).."] "..type(x).." "..val(x)) end
   end
  else out(" U"..i.." "..type(v).." "..val(v)) end
 end
end
local function has(c,w)
 for _,v in pairs(c) do
  if type(v)=="string" then
   local s=v:lower()
   for _,q in ipairs(w) do if s:find(q,1,true) then return true end end
  end
 end
 return false
end
local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer
out("=== BLIND BOX ROOT-CAUSE DIAGNOSIS ===")
out("PLAYER "..val(P).." TIME "..os.date("%Y-%m-%d %H:%M:%S"))
out("READ ONLY | NO HOOKS | NO REQUIRE | NO REMOTE CALLS")
-- A. Only relevant module paths; do not require modules.
out("\n=== A. BLIND BOX MODULES ===")
local wanted={BlindBoxTampil=true,GachaController=true,GachaConfig=true,KotakController=true}
for _,x in ipairs(RS:GetDescendants()) do
 if x:IsA("ModuleScript") and wanted[x.Name] then out("[MODULE] "..val(x)) end
end
-- B. Live BlindBox GUI and relevant descendants only.
out("\n=== B. LIVE BLIND BOX UI ===")
local pg=P:FindFirstChild("PlayerGui")
local gui=pg and pg:FindFirstChild("BlindBoxLayar",true)
if gui then
 out("[GUI FOUND] "..val(gui).." Class="..gui.ClassName)
 for _,x in ipairs(gui:GetDescendants()) do
  if x:IsA("GuiButton") or x:IsA("TextLabel") or x:IsA("TextBox") or x:IsA("ViewportFrame") or x:IsA("Camera") or x:IsA("Model") or x:IsA("ValueBase") then
   local s="[UI] "..x.ClassName.." "..val(x)
   if x:IsA("TextButton") or x:IsA("TextLabel") or x:IsA("TextBox") then s=s.." Text="..val(x.Text).." Visible="..val(x.Visible) end
   if x:IsA("GuiButton") then s=s.." Active="..val(x.Active) end
   if x:IsA("ValueBase") then s=s.." Value="..val(x.Value) end
   out(s)
  end
 end
else out("BlindBoxLayar NOT FOUND (open Blind Box before running)") end
-- C. Only Blind Box-related remotes, preserving full path.
out("\n=== C. BLIND BOX-NAMED REMOTES ===")
local remoteN=0
for _,x in ipairs(RS:GetDescendants()) do
 if (x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("UnreliableRemoteEvent")) and (x.Name:lower():find("blind",1,true) or x.Name:lower():find("gacha",1,true)) then
  remoteN=remoteN+1; out("[REMOTE] "..x.ClassName.." "..val(x))
 end
end
if remoteN==0 then out("No remote with Blind/Gacha in name; this does NOT prove no indirect server route.") end
-- D. Find private orchestrator and inspect its closure graph.
out("\n=== D. PRIVATE BLINDBOX ORCHESTRATOR ===")
local gc={}
if getgc then
 local ok,g=pcall(getgc,true)
 if ok and type(g)=="table" then gc=g else out("getgc unavailable/error") end
else out("getgc unavailable") end
local candidates={}
for i=1,#gc do
 local f=gc[i]
 if type(f)=="function" then
  local c=constants(f)
  if has(c,{"bukaBlindBox"}) then
   candidates[#candidates+1]=f
  end
 end
 if i%100==0 then task.wait() end
 if i>=12000 then out("GC bound reached at 12000 objects"); break end
end
out("GC OBJECTS CHECKED "..math.min(#gc,12000).." | ORCHESTRATOR CANDIDATES "..#candidates)
local targetSet={}
for i,f in ipairs(candidates) do
 targetSet[f]=true
 dump(f,"GachaController.bukaBlindBox candidate "..i,true)
 -- Capture direct upvalue function references, especially callback U2.
 local u=upvalues(f)
 for j,v in pairs(u) do
  if type(v)=="function" then dump(v,"bukaBlindBox.U"..j,false) end
  if type(v)=="table" then
   for k,x in pairs(v) do
    if type(x)=="function" then dump(x,"bukaBlindBox.U"..j.."."..val(k),false) end
   end
  end
 end
end
if #candidates==0 then out("No loaded function constant 'bukaBlindBox' found. Keep Blind Box open and ensure it has been opened once in this session.") end
-- E. Search loaded closures for direct references to the exact orchestrator function.
out("\n=== E. CALLERS / REFERENCES TO ORCHESTRATOR ===")
local callerN,checked=0,0
if #candidates>0 then
 for i=1,#gc do
  local f=gc[i]
  if type(f)=="function" and not targetSet[f] then
   checked=checked+1
   local u=upvalues(f)
   local found=false
   for _,v in pairs(u) do
    if targetSet[v] then found=true end
    if type(v)=="table" then
     for _,x in pairs(v) do if targetSet[x] then found=true end end
    end
   end
   if found then
    callerN=callerN+1
    dump(f,"DIRECT CALLER CANDIDATE "..callerN,false)
   end
  end
  if i%100==0 then task.wait() end
  if i>=12000 then break end
 end
end
out("CLOSURES CHECKED "..checked.." | DIRECT CALLER CANDIDATES "..callerN)
-- F. Focused loaded functions with blind-box vocabulary (constants only).
out("\n=== F. BLIND / REWARD FUNCTION MATCHES ===")
local n=0
for i=1,#gc do
 local f=gc[i]
 if type(f)=="function" and not seen[f] then
  local c=constants(f)
  if has(c,{"blindbox","blind box","bukaBlindBox","claimcallback","blindboxtampil"}) then
   n=n+1; dump(f,"BLIND VOCAB MATCH "..n,false)
   if n>=45 then out("MATCH LIMIT 45"); break end
  end
 end
 if i%100==0 then task.wait() end
 if i>=12000 then break end
end
out("VOCAB MATCHES "..n)
-- G. State snapshot of only exact BlindBox-related values already present in GUI.
out("\n=== G. END ===")
out("This scan does not invoke any discovered function or remote.")
local result=table.concat(O,"\n")
if writefile then pcall(writefile,"Hasil.lua",result) end
if setclipboard then pcall(setclipboard,result) end
print("BLIND BOX DIAGNOSIS DONE | "..#result.." chars | Hasil.lua + clipboard")
