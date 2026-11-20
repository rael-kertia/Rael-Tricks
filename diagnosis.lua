-- RAEL'S TRICKS | BLIND BOX FULL DIAGNOSIS
-- READ ONLY: tidak menekan UI, tidak invoke/fire remote, tidak mengubah state.
local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer
local O,seenFn,seenTab={}, {}, {}
local function add(s) O[#O+1]=tostring(s) end
local function path(x)
 if typeof(x)=="Instance" then
  local ok,s=pcall(function() return x:GetFullName() end)
  return ok and s or x.Name
 end
 return tostring(x)
end
local function constants(fn)
 if not debug or not debug.getconstants then return {} end
 local ok,t=pcall(debug.getconstants,fn)
 return ok and type(t)=="table" and t or {}
end
local function values(fn)
 if not debug or not debug.getupvalues then return {} end
 local ok,t=pcall(debug.getupvalues,fn)
 return ok and type(t)=="table" and t or {}
end
local function dumpFn(name,fn,depth)
 if type(fn)~="function" or seenFn[fn] or depth>2 then return end
 seenFn[fn]=true
 add("\n### FUNCTION "..name)
 if debug and debug.getinfo then
  local ok,i=pcall(debug.getinfo,fn)
  if ok and i then add("INFO "..tostring(i.source).." line="..tostring(i.linedefined).." name="..tostring(i.name)) end
 end
 local c=constants(fn)
 for i,v in pairs(c) do
  if type(v)=="string" or typeof(v)=="Instance" or type(v)=="number" then
   add("C"..i.." "..path(v))
  end
 end
 local u=values(fn)
 for i,v in pairs(u) do
  local ty=type(v)
  add("U"..i.." "..ty.." "..path(v))
  if ty=="function" then dumpFn(name..".U"..i,v,depth+1)
  elseif ty=="table" and depth<2 then
   if not seenTab[v] then
    seenTab[v]=true
    local n=0
    for k,x in pairs(v) do
     n=n+1
     if n>100 then add("  TABLE TRUNCATED"); break end
     local xt=type(x)
     if xt=="function" then
      add("  ["..tostring(k).."] FUNCTION")
      dumpFn(name..".U"..i.."."..tostring(k),x,depth+1)
     elseif xt=="table" then
      add("  ["..tostring(k).."] TABLE "..tostring(x))
     else add("  ["..tostring(k).."] "..xt.." "..path(x)) end
    end
   end
  end
 end
 if debug and debug.getprotos and depth<2 then
  local ok,ps=pcall(debug.getprotos,fn)
  if ok and type(ps)=="table" then
   for i,p in pairs(ps) do if type(p)=="function" then dumpFn(name..".PROTO"..i,p,depth+1) end end
  end
 end
end
local function findModule(name)
 for _,x in ipairs(RS:GetDescendants()) do
  if x:IsA("ModuleScript") and x.Name==name then return x end
 end
end
add("=== RAEL BLIND BOX FULL DIAGNOSIS ===")
add("Player "..P.Name.." | "..os.date("%Y-%m-%d %H:%M:%S"))
-- A. module exports and function bodies
local names={"GachaController","BlindBoxTampil","GachaConfig","KotakController"}
local mods={}
for _,n in ipairs(names) do
 local m=findModule(n)
 add("\n### MODULE "..n.." = "..path(m))
 if m then
  local ok,res=pcall(require,m)
  add("REQUIRE "..tostring(ok).." "..(ok and type(res) or tostring(res)))
  if ok and type(res)=="table" then
   mods[n]=res
   for k,v in pairs(res) do
    if type(v)=="function" then dumpFn(n.."."..tostring(k),v,0)
    elseif type(v)=="table" then
     add("EXPORT "..tostring(k).." TABLE")
     for a,b in pairs(v) do
      if type(b)=="function" then dumpFn(n.."."..tostring(k).."."..tostring(a),b,0)
      elseif typeof(b)=="Instance" then add("  "..tostring(a).." "..path(b)) end
     end
    else add("EXPORT "..tostring(k).." "..type(v).." "..path(v)) end
   end
  end
 end
end
-- B. remote/event/function inventory relevant to Gacha, BlindBox, Kotak
add("\n### REMOTE INVENTORY")
local count=0
for _,x in ipairs(RS:GetDescendants()) do
 if x:IsA("RemoteEvent") or x:IsA("RemoteFunction") or x:IsA("BindableEvent") or x:IsA("BindableFunction") then
  local s=(x.Name.." "..x:GetFullName()):lower()
  if s:find("gacha") or s:find("blind") or s:find("kotak") or s:find("reward") or s:find("claim") then
   count=count+1; add(x.ClassName.." "..path(x))
  end
 end
end
add("REMOTE MATCHES "..count)
-- C. all loaded GC functions whose constants identify the Blind Box flow
add("\n### LOADED FUNCTION SEARCH")
if getgc and debug and debug.getconstants then
 local ok,g=pcall(getgc,true)
 local hits=0
 if ok and type(g)=="table" then
  for _,v in ipairs(g) do
   if type(v)=="function" and not seenFn[v] then
    local c=constants(v); local match={}
    for _,z in pairs(c) do
     if type(z)=="string" then
      local q=z:lower()
      if q:find("blindbox") or q:find("blind box") or q:find("bukablindbox") or q:find("claimcallback") then
       match[#match+1]=z
      end
     end
    end
    if #match>0 then
     hits=hits+1
     add("\nGC HIT "..hits.." constants="..table.concat(match,", "))
     dumpFn("GC_HIT_"..hits,v,0)
     if hits>=80 then add("GC SEARCH LIMIT 80"); break end
    end
   end
  end
 end
 add("GC HITS "..hits.." getgc="..tostring(ok))
else add("getgc/debug.getconstants unavailable") end
-- D. live BlindBox GUI state snapshot (read only)
add("\n### LIVE GUI")
local gui=P:FindFirstChild("PlayerGui") and P.PlayerGui:FindFirstChild("BlindBoxLayar")
add("GUI "..path(gui))
if gui then
 for _,x in ipairs(gui:GetDescendants()) do
  if x:IsA("TextButton") or x:IsA("TextLabel") then
   add(x.ClassName.." "..path(x).." Text="..tostring(x.Text).." Visible="..tostring(x.Visible))
  end
 end
end
local result=table.concat(O,"\n")
if setclipboard then pcall(setclipboard,result) end
if writefile then pcall(writefile,"Hasil.lua",result) end
print("BLIND BOX DIAGNOSIS SELESAI | hasil disalin dan disimpan sebagai Hasil.lua")
