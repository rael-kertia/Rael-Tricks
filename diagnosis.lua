-- RAEL'S TRICKS | BLIND BOX DEEP DIAGNOSIS
-- READ ONLY: no hooks, no remote calls, no UI clicks, no game-state mutation.
-- Exhaustive GC traversal (yields), targeted to known Blind Box functions.
local O,seenFn,seenTab={}, {}, {}
local function add(s) O[#O+1]=tostring(s) end
local function val(v)
 if typeof(v)=="Instance" then
  local ok,s=pcall(function() return v:GetFullName() end)
  return ok and s or v.Name
 end
 if type(v)=="string" then return string.sub(v,1,300) end
 return tostring(v)
end
local function const(f)
 if not debug or not debug.getconstants then return {} end
 local ok,t=pcall(debug.getconstants,f)
 return ok and type(t)=="table" and t or {}
end
local function ups(f)
 if not debug or not debug.getupvalues then return {} end
 local ok,t=pcall(debug.getupvalues,f)
 return ok and type(t)=="table" and t or {}
end
local function info(f)
 if not debug or not debug.getinfo then return "" end
 local ok,i=pcall(debug.getinfo,f)
 if ok and i then return " source="..val(i.source).." name="..val(i.name).." line="..val(i.linedefined) end
 return ""
end
local function dump(f,label,depth)
 if type(f)~="function" or seenFn[f] or depth>2 then return end
 seenFn[f]=true
 add("\n[FUNCTION] "..label..info(f))
 local c=const(f)
 for i,v in pairs(c) do
  if type(v)=="string" or type(v)=="number" or type(v)=="boolean" then add(" C"..i.." "..type(v).." "..val(v)) end
 end
 local u=ups(f)
 for i,v in pairs(u) do
  local t=type(v)
  if t=="function" then
   add(" U"..i.." FUNCTION "..val(v))
   if depth<2 then dump(v,label..".U"..i,depth+1) end
  elseif t=="table" then
   add(" U"..i.." TABLE "..val(v))
   if depth<2 and not seenTab[v] then
    seenTab[v]=true
    local n=0
    for k,x in pairs(v) do
     n=n+1
     if n>120 then add("  TABLE LIMIT"); break end
     if type(x)=="function" then
      add("  ["..val(k).."] FUNCTION")
      if depth<1 then dump(x,label..".U"..i.."."..val(k),depth+1) end
     elseif type(x)=="table" then add("  ["..val(k).."] TABLE")
     else add("  ["..val(k).."] "..type(x).." "..val(x)) end
    end
   end
  else add(" U"..i.." "..t.." "..val(v)) end
 end
 if depth<2 and debug and debug.getprotos then
  local ok,p=pcall(debug.getprotos,f)
  if ok and type(p)=="table" then
   for i,x in pairs(p) do if type(x)=="function" then add(" PROTO"..i.." FUNCTION"); dump(x,label..".PROTO"..i,depth+1) end end
  end
 end
end
local function contains(c,words)
 for _,v in pairs(c) do
  if type(v)=="string" then
   local s=v:lower()
   for _,w in ipairs(words) do if s:find(w,1,true) then return true end end
  end
 end
 return false
end
local P=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
add("=== BLIND BOX DEEP DIAGNOSIS ===")
add("PLAYER "..val(P).." TIME "..os.date("%Y-%m-%d %H:%M:%S"))
add("READ ONLY | NO HOOKS | NO REMOTE CALLS | NO UI CLICKS")
-- 1. Known modules and live GUI (inventory only; do not require).
add("\n=== 1. KNOWN MODULES ===")
for _,x in ipairs(RS:GetDescendants()) do
 if x:IsA("ModuleScript") and (x.Name=="GachaController" or x.Name=="BlindBoxTampil" or x.Name=="GachaConfig" or x.Name=="KotakController") then
  add("[MODULE] "..val(x))
 end
end
add("\n=== 2. LIVE BLIND BOX UI ===")
local pg=P:FindFirstChild("PlayerGui")
local gui=pg and pg:FindFirstChild("BlindBoxLayar",true)
if gui then
 add("[GUI] "..val(gui))
 for _,x in ipairs(gui:GetDescendants()) do
  if x:IsA("GuiButton") then add("[BUTTON] "..val(x).." Visible="..val(x.Visible).." Active="..val(x.Active).." Text="..val(x:IsA("TextButton") and x.Text or "ImageButton"))
  elseif x:IsA("TextLabel") then add("[LABEL] "..val(x).." Text="..val(x.Text).." Visible="..val(x.Visible))
  elseif x:IsA("ViewportFrame") or x:IsA("Camera") or x:IsA("Model") or x:IsA("ValueBase") then
   local s="[OBJECT] "..x.ClassName.." "..val(x)
   if x:IsA("ValueBase") then s=s.." Value="..val(x.Value) end
   add(s)
  end
 end
else add("GUI NOT OPEN") end
-- 3. Full GC list. No arbitrary first-N cutoff. Yield every 100 objects.
add("\n=== 3. FULL GC ENUMERATION ===")
local ok,g=pcall(getgc,true)
if not ok or type(g)~="table" then
 add("GETGC FAILED: "..val(g))
else
 local total=#g
 add("GC TOTAL "..total)
 local target={}
 local targetCount,fnCount,tableCount=0,0,0
 -- pass 1: find exact orchestrator by constants, across entire GC list.
 for i=1,total do
  local x=g[i]
  if type(x)=="function" then
   fnCount=fnCount+1
   local c=const(x)
   if contains(c,{"bukaBlindBox"}) then
    target[x]=true; targetCount=targetCount+1
    dump(x,"GachaController.bukaBlindBox #"..targetCount,0)
   end
  elseif type(x)=="table" then tableCount=tableCount+1 end
  if i%100==0 then task.wait() end
 end
 add("PASS1 objects="..total.." functions="..fnCount.." tables="..tableCount.." targetFunctions="..targetCount)
 if targetCount==0 then add("ORCHESTRATOR NOT FOUND IN FULL GC. It may not be loaded in this client session, or constants API is limited.") end
 -- pass 2: find direct upvalue references and nested table references to exact function.
 add("\n=== 4. DIRECT CALLER / CLOSURE REFERENCES ===")
 local callers,callerSeen=0,{}
 for i=1,total do
  local f=g[i]
  if type(f)=="function" and not target[f] then
   local u=ups(f)
   local matched={}
   for j,v in pairs(u) do
    if target[v] then matched[#matched+1]="U"..j end
    if type(v)=="table" then
     for k,z in pairs(v) do if target[z] then matched[#matched+1]="U"..j.."."..val(k) end end
    end
   end
   if #matched>0 and not callerSeen[f] then
    callerSeen[f]=true; callers=callers+1
    add("[CALLER REF "..callers.."] "..table.concat(matched,", ")..info(f))
    dump(f,"DIRECT CALLER "..callers,1)
   end
  end
  if i%100==0 then task.wait() end
 end
 add("DIRECT CALLER COUNT "..callers)
 -- pass 3: targeted vocabulary candidates, not every unrelated function.
 add("\n=== 5. BLIND / REWARD / CLAIM FUNCTION CANDIDATES ===")
 local n=0
 for i=1,total do
  local f=g[i]
  if type(f)=="function" and not seenFn[f] then
   local c=const(f)
   if contains(c,{"blind","blindbox","blind box","claimcallback","bukaBlindBox","reward","hasilhadiah","kotak"}) then
    n=n+1; dump(f,"TARGET VOCAB CANDIDATE "..n,1)
   end
  end
  if i%100==0 then task.wait() end
 end
 add("VOCAB CANDIDATES "..n)
end
-- 4. Remote inventory only under NKSystem and names likely tied to reward systems.
add("\n=== 6. RELEVANT REMOTE INVENTORY ===")
local rem=0
local nk=RS:FindFirstChild("NKSystem")
if nk then
 for _,x in ipairs(nk:GetDescendants()) do
  if x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("UnreliableRemoteEvent") then
   rem=rem+1; add("[REMOTE] "..x.ClassName.." "..val(x))
  end
 end
end
add("NKSystem remotes listed "..rem)
-- 5. Snapshot exact known state table candidates if any are still referenced by loaded functions.
add("\n=== 7. END / LIMITATIONS ===")
add("No function was executed. No remote was invoked. No hook was installed.")
add("A caller may not retain the target as an upvalue; absence of direct refs is not proof of no caller.")
local result=table.concat(O,"\n")
if writefile then pcall(writefile,"Hasil.lua",result) end
if setclipboard then pcall(setclipboard,result) end
print("BLIND BOX DEEP DIAGNOSIS DONE | "..#result.." chars | Hasil.lua + clipboard")
