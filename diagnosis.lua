-- RAEL'S TRICKS | FULL GAME DIAGNOSIS - SAFE / THROTTLED
-- READ ONLY. NO HOOKS, NO REQUIRE, NO REMOTE CALLS, NO UI CLICKS.
-- Limits and yields prevent Android client freeze.
local O,seenFn={},{}
local MAX_CHARS=180000
local MAX_OBJECTS=14000
local MAX_GC=18000
local MAX_MATCH=90
local function add(s)
 if #O<MAX_CHARS then O[#O+1]=tostring(s) end
end
local function safe(v)
 if typeof(v)=="Instance" then
  local ok,s=pcall(function() return v:GetFullName() end)
  return ok and s or v.Name
 end
 if type(v)=="string" then return string.sub(v,1,220) end
 return tostring(v)
end
local function match(s)
 s=tostring(s):lower()
 for _,w in ipairs({"gacha","blind","kotak","pet","ternak","sewa","penyewa","tenant","kos","market","shop","inventory","hadiah","reward","claim","spin","upgrade","build","uang","money","sapu","sampah","pajak","aset","rumah","kamar","furnitur","furniture","kendaraan","vehicle","job","pekerja","gaji","bank","deposit","withdraw","jual","beli","trade","quest","misi","level","exp","rebirth","prestige","plot","tycoon"}) do
  if s:find(w,1,true) then return true end
 end
 return false
end
local function consts(f)
 if not debug or not debug.getconstants then return {} end
 local ok,t=pcall(debug.getconstants,f)
 return ok and type(t)=="table" and t or {}
end
local function ups(f)
 if not debug or not debug.getupvalues then return {} end
 local ok,t=pcall(debug.getupvalues,f)
 return ok and type(t)=="table" and t or {}
end
local function dumpFn(label,f)
 if type(f)~="function" or seenFn[f] then return end
 seenFn[f]=true
 add("\n[FUNCTION] "..label)
 if debug and debug.getinfo then
  local ok,i=pcall(debug.getinfo,f)
  if ok and i then add("INFO "..safe(i.source).." name="..safe(i.name).." line="..safe(i.linedefined)) end
 end
 local c=consts(f)
 for i,v in pairs(c) do
  if type(v)=="string" or type(v)=="number" then add(" C"..i.." "..safe(v)) end
 end
 local u=ups(f)
 for i,v in pairs(u) do
  local t=type(v)
  if t=="function" then add(" U"..i.." FUNCTION")
  elseif t=="table" then
   add(" U"..i.." TABLE")
   local n=0
   for k,x in pairs(v) do
    n=n+1
    if n>35 then add("  TABLE TRUNCATED"); break end
    if type(x)=="function" then add("  ["..safe(k).."] FUNCTION")
    elseif type(x)=="table" then add("  ["..safe(k).."] TABLE")
    else add("  ["..safe(k).."] "..type(x).." "..safe(x)) end
   end
  else add(" U"..i.." "..t.." "..safe(v)) end
 end
end
local function yieldNow() task.wait() end
local P=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
add("=== FULL GAME DIAGNOSIS SAFE MODE ===")
add("PLAYER "..safe(P).." USERID "..safe(P.UserId).." TIME "..os.date("%Y-%m-%d %H:%M:%S"))
add("READ ONLY | NO HOOKS | NO REQUIRE | NO REMOTE CALLS")
-- 1. Key service tree inventory
add("\n=== 1. REPLICATED STORAGE / WORKSPACE / PLAYER OBJECTS ===")
local roots={RS,game:GetService("Workspace"),P:FindFirstChild("PlayerGui"),P:FindFirstChild("PlayerScripts"),P:FindFirstChild("Backpack"),P.Character}
local count=0
for _,root in ipairs(roots) do
 if root then
  add("\n[ROOT] "..safe(root))
  local ok,ds=pcall(function() return root:GetDescendants() end)
  if ok then
   for _,x in ipairs(ds) do
    count=count+1
    if count>MAX_OBJECTS then add("OBJECT LIMIT REACHED"); break end
    local cl=x.ClassName
    local full=safe(x)
    if x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("UnreliableRemoteEvent") or x:IsA("BindableEvent") or x:IsA("BindableFunction") then
     add("[REMOTE] "..cl.." "..full)
    elseif x:IsA("ModuleScript") then
     add("[MODULE] "..full)
    elseif x:IsA("LocalScript") then
     if match(full) then add("[LOCALSCRIPT] "..full.." Disabled="..safe(x.Disabled)) end
    elseif x:IsA("ProximityPrompt") then
     add("[PROMPT] "..full.." Action="..safe(x.ActionText).." Object="..safe(x.ObjectText).." Enabled="..safe(x.Enabled))
    elseif x:IsA("ClickDetector") then add("[CLICK] "..full)
    elseif x:IsA("Tool") then add("[TOOL] "..full)
    elseif x:IsA("ValueBase") and match(full) then add("[VALUE] "..full.."="..safe(x.Value))
    elseif (x:IsA("TextButton") or x:IsA("TextLabel") or x:IsA("TextBox")) and (match(full) or match(x.Text)) then
     add("[GUI] "..full.." Text="..safe(x.Text).." Visible="..safe(x.Visible).." Active="..safe(x.Active))
    end
    if count%350==0 then yieldNow() end
   end
  end
 end
end
add("OBJECTS SCANNED "..count)
-- 2. Loaded game functions. Constants fetched once per function, throttled.
add("\n=== 2. LOADED FUNCTIONS / CONSTANTS / UPVALUES ===")
local checked,hits=0,0
if getgc and debug and debug.getconstants then
 local ok,g=pcall(getgc,true)
 add("GETGC "..safe(ok).." COUNT "..(ok and type(g)=="table" and #g or 0))
 if ok and type(g)=="table" then
  for _,f in ipairs(g) do
   if type(f)=="function" and not seenFn[f] then
    checked=checked+1
    local info=""
    if debug.getinfo then
     local a,b=pcall(debug.getinfo,f)
     if a and b then info=tostring(b.source).." "..tostring(b.name) end
    end
    local c=consts(f)
    local found=match(info)
    for _,v in pairs(c) do
     if type(v)=="string" then
      if match(v) then found=true end
     end
    end
    if found then
     hits=hits+1
     -- dump the constants already collected, avoiding another constants pass
     add("\n[GC MATCH "..hits.."] "..info)
     for i,v in pairs(c) do if type(v)=="string" or type(v)=="number" then add(" C"..i.." "..safe(v)) end end
     local u=ups(f)
     for i,v in pairs(u) do
      local t=type(v)
      if t=="function" then add(" U"..i.." FUNCTION")
      elseif t=="table" then
       add(" U"..i.." TABLE")
       local n=0
       for k,x in pairs(v) do
        n=n+1
        if n>30 then add("  TABLE TRUNCATED"); break end
        if type(x)=="function" then add("  ["..safe(k).."] FUNCTION")
        elseif type(x)=="table" then add("  ["..safe(k).."] TABLE")
        else add("  ["..safe(k).."] "..type(x).." "..safe(x)) end
       end
      else add(" U"..i.." "..t.." "..safe(v)) end
     end
     seenFn[f]=true
    end
    if hits>=MAX_MATCH then add("MATCH LIMIT REACHED"); break end
    if checked%120==0 then yieldNow() end
   end
   if checked>=MAX_GC then add("GC SCAN LIMIT REACHED"); break end
  end
 end
else add("GETGC / DEBUG CONSTANTS UNAVAILABLE") end
add("FUNCTIONS CHECKED "..checked.." MATCHES "..hits)
-- 3. ScreenGui state and character
add("\n=== 3. ACTIVE PLAYER UI / CHARACTER ===")
local pg=P:FindFirstChild("PlayerGui")
if pg then
 for _,x in ipairs(pg:GetChildren()) do
  if x:IsA("ScreenGui") then add("[SCREEN] "..safe(x).." Enabled="..safe(x.Enabled).." Order="..safe(x.DisplayOrder)) end
 end
end
local ch=P.Character
if ch then
 local h=ch:FindFirstChildOfClass("Humanoid")
 local rp=ch:FindFirstChild("HumanoidRootPart")
 add("CHARACTER "..safe(ch).." HEALTH="..(h and safe(h.Health) or "-").." WALKSPEED="..(h and safe(h.WalkSpeed) or "-").." ROOT="..(rp and safe(rp.Position) or "-"))
end
-- 4. Tagged objects, safe bounded list
add("\n=== 4. COLLECTION TAGS ===")
local ok,t=pcall(function() return game:GetService("CollectionService"):GetAllTags() end)
if ok then for _,v in ipairs(t) do add("[TAG] "..safe(v)) end else add("TAG API UNAVAILABLE") end
local result=table.concat(O,"\n")
if writefile then pcall(writefile,"Hasil.lua",result) end
if setclipboard then pcall(setclipboard,result) end
print("DIAGNOSIS SELESAI: "..#result.." chars. Hasil.lua dan clipboard.")
