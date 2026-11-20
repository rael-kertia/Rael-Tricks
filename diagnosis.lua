-- RAEL'S TRICKS | FULL GAME DIAGNOSIS (CLIENT VISIBLE)
-- READ ONLY. NO HOOKS, NO REMOTE INVOKE/FIRE, NO BUTTON CLICKS,
-- NO MODULE REQUIRE, NO STATE CHANGES.
local O,seenFn,seenObj={},{},{}
local function add(s) O[#O+1]=tostring(s) end
local function safe(v)
 local t=typeof(v)
 if t=="Instance" then
  local ok,s=pcall(function() return v:GetFullName() end)
  return ok and s or v.Name
 end
 if type(v)=="string" then return string.sub(v,1,350) end
 return tostring(v)
end
local function prop(x,p)
 local ok,v=pcall(function() return x[p] end)
 return ok and v or nil
end
local function getConsts(f)
 if not debug or not debug.getconstants then return {} end
 local ok,v=pcall(debug.getconstants,f)
 return ok and type(v)=="table" and v or {}
end
local function getUps(f)
 if not debug or not debug.getupvalues then return {} end
 local ok,v=pcall(debug.getupvalues,f)
 return ok and type(v)=="table" and v or {}
end
local function dumpFn(label,f,depth)
 if type(f)~="function" or seenFn[f] or depth>1 then return end
 seenFn[f]=true
 add("\n[F] "..label)
 if debug and debug.getinfo then
  local ok,i=pcall(debug.getinfo,f)
  if ok and i then add("SRC="..safe(i.source).." NAME="..safe(i.name).." LINE="..safe(i.linedefined)) end
 end
 local c=getConsts(f)
 for i,v in pairs(c) do
  local t=type(v)
  if t=="string" or t=="number" or t=="boolean" or typeof(v)=="Instance" then
   add(" C"..i.." "..t.." "..safe(v))
  end
 end
 local u=getUps(f)
 for i,v in pairs(u) do
  local t=type(v)
  if t=="function" then
   add(" U"..i.." FUNCTION")
   if depth<1 then dumpFn(label..".U"..i,v,depth+1) end
  elseif t=="table" then
   add(" U"..i.." TABLE")
   local n=0
   for k,x in pairs(v) do
    n=n+1
    if n>70 then add("  ...TABLE LIMIT"); break end
    local xt=type(x)
    if xt=="function" then add("  ["..safe(k).."] FUNCTION")
    elseif xt=="table" then add("  ["..safe(k).."] TABLE")
    else add("  ["..safe(k).."] "..xt.." "..safe(x)) end
   end
  else add(" U"..i.." "..t.." "..safe(v)) end
 end
 if debug and debug.getprotos and depth==0 then
  local ok,ps=pcall(debug.getprotos,f)
  if ok and type(ps)=="table" then
   for i,p in pairs(ps) do if type(p)=="function" then add(" PROTO"..i.." FUNCTION") end end
  end
 end
end
local function matches(s)
 s=tostring(s):lower()
 for _,w in ipairs({"gacha","blind","kotak","pet","ternak","sewa","penyewa","tenant","kos","market","shop","inventory","hadiah","reward","claim","spin","upgrade","build","uang","money","sapu","sampah","pajak","aset","rumah","kamar","furnitur","furniture","kendaraan","vehicle","job","pekerja","gaji","bank","deposit","withdraw","jual","beli","jualbeli","trade","quest","misi","level","exp","experience","rebirth","prestige","plot","tycoon","interaksi","interact"}) do
  if s:find(w,1,true) then return true end
 end
 return false
end
local services={}
for _,n in ipairs({"ReplicatedStorage","Workspace","Players","Lighting","SoundService","StarterGui","StarterPlayer","Teams","CollectionService","TextChatService"}) do
 local ok,v=pcall(function() return game:GetService(n) end)
 if ok and v then services[#services+1]=v end
end
local P=game:GetService("Players").LocalPlayer
add("=== RAEL TRICKS | FULL GAME DIAGNOSIS ===")
add("PLAYER "..safe(P).." USERID "..safe(P.UserId).." TIME "..os.date("%Y-%m-%d %H:%M:%S"))
add("MODE READ-ONLY | NO HOOKS | NO REMOTE CALLS | NO MODULE REQUIRE")
-- 1: all relevant instances across client-visible game trees
add("\n=== 1. GAME INSTANCE TREE / OBJECT INVENTORY ===")
local total,scriptCount,remoteCount,promptCount,toolCount=0,0,0,0,0
for _,root in ipairs(services) do
 add("\n[SERVICE] "..safe(root))
 local descendants={}
 pcall(function() descendants=root:GetDescendants() end)
 for _,x in ipairs(descendants) do
  total=total+1
  local cl=x.ClassName
  local nm=x.Name
  local full=safe(x)
  if x:IsA("LuaSourceContainer") then
   scriptCount=scriptCount+1
   if matches(full) or x:IsA("LocalScript") then add("[SCRIPT] "..cl.." "..full.." Disabled="..safe(prop(x,"Disabled"))) end
  end
  if x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("UnreliableRemoteEvent") or x:IsA("BindableEvent") or x:IsA("BindableFunction") then
   remoteCount=remoteCount+1
   add("[REMOTE] "..cl.." "..full)
  end
  if x:IsA("ProximityPrompt") then
   promptCount=promptCount+1
   add("[PROMPT] "..full.." Action="..safe(x.ActionText).." Object="..safe(x.ObjectText).." Enabled="..safe(x.Enabled).." Hold="..safe(x.HoldDuration))
  elseif x:IsA("ClickDetector") then add("[CLICK] "..full.." Distance="..safe(x.MaxActivationDistance))
  elseif x:IsA("Tool") then
   toolCount=toolCount+1
   add("[TOOL] "..full.." Enabled="..safe(x.Enabled).." RequiresHandle="..safe(x.RequiresHandle))
  elseif x:IsA("ModuleScript") and matches(full) then
   add("[MODULE] "..full)
  elseif x:IsA("ValueBase") and matches(full) then
   add("[VALUE] "..cl.." "..full.." Value="..safe(prop(x,"Value")))
  elseif (x:IsA("TextButton") or x:IsA("TextLabel") or x:IsA("TextBox")) and (matches(full) or matches(prop(x,"Text"))) then
   add("[GUI] "..cl.." "..full.." Text="..safe(prop(x,"Text")).." Visible="..safe(prop(x,"Visible")).." Active="..safe(prop(x,"Active")))
  elseif x:IsA("Attribute") then
   -- Attributes are read from their owning instances below when relevant.
  end
  if matches(full) then
   local attrs={}
   pcall(function() attrs=x:GetAttributes() end)
   for k,v in pairs(attrs) do add("[ATTR] "..full.." "..k.."="..safe(v)) end
  end
 end
end
add("COUNTS instances="..total.." scripts="..scriptCount.." remotes="..remoteCount.." prompts="..promptCount.." tools="..toolCount)
-- 2: player runtime and GUI tree
add("\n=== 2. PLAYER RUNTIME / GUI / BACKPACK ===")
for _,root in ipairs({P:FindFirstChild("PlayerGui"),P:FindFirstChild("PlayerScripts"),P:FindFirstChild("Backpack"),P.Character}) do
 if root then
  add("[PLAYER ROOT] "..safe(root))
  for _,x in ipairs(root:GetDescendants()) do
   if x:IsA("LuaSourceContainer") or x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("Tool") or x:IsA("ProximityPrompt") then
    add("[PLAYER OBJECT] "..x.ClassName.." "..safe(x))
   elseif x:IsA("TextButton") or x:IsA("TextLabel") or x:IsA("TextBox") then
    add("[PLAYER UI] "..safe(x).." Text="..safe(x.Text).." Visible="..safe(x.Visible).." Active="..safe(x.Active))
   elseif x:IsA("ValueBase") and matches(safe(x)) then add("[PLAYER VALUE] "..safe(x).."="..safe(x.Value)) end
  end
 end
end
-- 3: module inventory; intentionally do not require modules
add("\n=== 3. MODULE INVENTORY (NOT REQUIRED) ===")
local RS=game:GetService("ReplicatedStorage")
for _,x in ipairs(RS:GetDescendants()) do
 if x:IsA("ModuleScript") then
  add("[MODULE] "..safe(x))
 end
end
-- 4: live functions already loaded in client; inspect source/constants/upvalues
add("\n=== 4. LOADED GAME FUNCTIONS / CONSTANTS / UPVALUES ===")
local gcCount,hitCount=0,0
if getgc and debug and debug.getconstants then
 local ok,g=pcall(getgc,true)
 add("GETGC "..safe(ok).." COUNT "..(ok and type(g)=="table" and #g or 0))
 if ok and type(g)=="table" then
  for _,f in ipairs(g) do
   if type(f)=="function" and not seenFn[f] then
    gcCount=gcCount+1
    local c=getConsts(f)
    local info=""
    if debug.getinfo then
     local a,b=pcall(debug.getinfo,f)
     if a and b then info=tostring(b.source).." "..tostring(b.name) end
    end
    local hay=info
    local matched={}
    for _,v in pairs(c) do if type(v)=="string" then hay=hay.." "..v end end
    if matches(hay) then
     hitCount=hitCount+1
     dumpFn("GC_MATCH_"..hitCount.." "..info,f,0)
     if hitCount>=250 then add("GC MATCH LIMIT 250"); break end
    end
   end
  end
 end
else add("GETGC OR DEBUG CONSTANTS UNAVAILABLE") end
add("GC FUNCTIONS CHECKED "..gcCount.." MATCHES "..hitCount)
-- 5: known game controllers/services by names in replicated storage
add("\n=== 5. GAME MODULES BY PATH / CONTROLLER MAP ===")
for _,x in ipairs(RS:GetDescendants()) do
 if x:IsA("ModuleScript") and (matches(x.Name) or x.Parent and matches(x.Parent.Name)) then
  add("[GAME MODULE] "..safe(x).." Parent="..safe(x.Parent))
 end
end
-- 6: world interactables and tagged objects
add("\n=== 6. WORLD INTERACTABLES ===")
local W=game:GetService("Workspace")
for _,x in ipairs(W:GetDescendants()) do
 if x:IsA("ProximityPrompt") or x:IsA("ClickDetector") or x:IsA("TouchTransmitter") then
  add("[INTERACTABLE] "..x.ClassName.." "..safe(x).." Parent="..safe(x.Parent))
 end
end
if CollectionService then
 local ok,t=pcall(function() return game:GetService("CollectionService"):GetAllTags() end)
 if ok then for _,tag in ipairs(t) do add("[TAG] "..tag) end end
end
-- 7: key runtime state values
add("\n=== 7. PLAYER / CHARACTER STATE ===")
local char=P.Character
if char then
 local h=char:FindFirstChildOfClass("Humanoid")
 local root=char:FindFirstChild("HumanoidRootPart")
 add("CHAR "..safe(char).." HUMANOID "..safe(h).." HEALTH "..(h and safe(h.Health) or "-").." WALKSPEED "..(h and safe(h.WalkSpeed) or "-"))
 add("ROOT "..safe(root).." POSITION "..(root and safe(root.Position) or "-"))
end
local pg=P:FindFirstChild("PlayerGui")
if pg then
 for _,x in ipairs(pg:GetChildren()) do
  if x:IsA("ScreenGui") then add("[SCREEN] "..safe(x).." Enabled="..safe(x.Enabled).." DisplayOrder="..safe(x.DisplayOrder)) end
 end
end
-- 8: finish / save
local result=table.concat(O,"\n")
if writefile then pcall(writefile,"Hasil.lua",result) end
if setclipboard then pcall(setclipboard,result) end
print("FULL GAME DIAGNOSIS SELESAI | "..#result.." karakter | Hasil.lua + clipboard")
