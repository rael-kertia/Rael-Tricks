-- RAEL'S TRICKS | BLIND BOX CALLBACK TRACE
-- READ ONLY: does not call functions, remotes, hooks, or click UI.
local out, seenF, seenT = {}, {}, {}
local function add(x) out[#out+1]=tostring(x) end
local function safe(fn,...)
 local ok,a=pcall(fn,...); if ok then return a end
 return nil
end
local function constants(f)
 local t=safe(debug.getconstants,f); return type(t)=="table" and t or {}
end
local function upvalues(f)
 local t=safe(debug.getupvalues,f); return type(t)=="table" and t or {}
end
local function hasBlind(f)
 for _,v in pairs(constants(f)) do
  if type(v)=="string" and v:lower():find("bukablindbox",1,true) then return true end
 end
 return false
end
local function info(f)
 local i=safe(debug.getinfo,f)
 if type(i)=="table" then return " src="..tostring(i.source).." name="..tostring(i.name).." line="..tostring(i.linedefined) end
 return ""
end
local function dump(f,label,depth,maxDepth)
 if type(f)~="function" or seenF[f] or depth>maxDepth then return end
 seenF[f]=true
 add("\n[FUNC] "..label.." @"..tostring(f)..info(f))
 local c=constants(f)
 for i,v in pairs(c) do
  if type(v)=="string" or type(v)=="number" or type(v)=="boolean" then add(" C"..i.." "..type(v).." "..tostring(v):sub(1,180)) end
 end
 local u=upvalues(f)
 for i,v in pairs(u) do
  if type(v)=="function" then
   add(" U"..i.." FUNC @"..tostring(v))
   if depth<maxDepth then dump(v,label..".U"..i,depth+1,maxDepth) end
  elseif type(v)=="table" then
   add(" U"..i.." TABLE")
   if not seenT[v] and depth<maxDepth then
    seenT[v]=true; local n=0
    for k,x in pairs(v) do
     n=n+1; if n>80 then add("  TABLE LIMIT"); break end
     if type(x)=="function" then
      add("  ["..tostring(k).."] FUNC @"..tostring(x))
      if depth<maxDepth then dump(x,label..".U"..i.."["..tostring(k).."]",depth+1,maxDepth) end
     elseif type(x)=="string" or type(x)=="number" or type(x)=="boolean" then
      add("  ["..tostring(k).."] "..type(x).." "..tostring(x):sub(1,120))
     elseif type(x)=="table" then add("  ["..tostring(k).."] TABLE") end
    end
   end
  else add(" U"..i.." "..type(v).." "..tostring(v):sub(1,160)) end
 end
 if depth<maxDepth and debug.getprotos then
  local p=safe(debug.getprotos,f)
  if type(p)=="table" then
   for i,x in pairs(p) do if type(x)=="function" then add(" PROTO"..i.." @"..tostring(x)); dump(x,label..".PROTO"..i,depth+1,maxDepth) end end
  end
 end
end
add("=== BLIND BOX CALLBACK TRACE ===")
add("READ ONLY | "..os.date("%Y-%m-%d %H:%M:%S"))
local ok,g=pcall(getgc,true)
if not ok or type(g)~="table" then
 add("ERROR: getgc unavailable: "..tostring(g))
else
 local targets={}
 for i=1,#g do
  local f=g[i]
  if type(f)=="function" and hasBlind(f) then
   targets[#targets+1]=f
   dump(f,"bukaBlindBox["..#targets.."]",0,3)
  end
  if i%150==0 then task.wait() end
 end
 add("\nORCHESTRATORS FOUND "..#targets)
 -- Find functions which hold the orchestrator or its callback as direct upvalues.
 local refs, seen={},{}
 for i=1,#g do
  local f=g[i]
  if type(f)=="function" and not seen[f] then
   local u=upvalues(f); local hits={}
   for j,v in pairs(u) do
    for k,target in ipairs(targets) do
     if v==target then hits[#hits+1]="U"..j.." -> bukaBlindBox["..k.."]" end
     if type(v)=="table" then
      for key,z in pairs(v) do if z==target then hits[#hits+1]="U"..j.."["..tostring(key).."] -> bukaBlindBox["..k.."]" end end
     end
    end
   end
   if #hits>0 then
    seen[f]=true; refs[#refs+1]=f
    add("\n[REFERENCE "..#refs.."] "..table.concat(hits,", ")..info(f))
    dump(f,"REF"..#refs,0,2)
   end
  end
  if i%150==0 then task.wait() end
 end
 add("\nFUNCTION REFERENCES FOUND "..#refs)
end
local result=table.concat(out,"\n")
if writefile then pcall(writefile,"BlindBoxCallback.lua",result) end
if setclipboard then pcall(setclipboard,result) end
print("TRACE SELESAI | "..#result.." karakter | tersalin ke clipboard dan BlindBoxCallback.lua")
