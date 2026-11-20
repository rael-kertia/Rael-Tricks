-- RAEL DIAGNOSTIC SEWA V6
-- PASIF: tidak klik tombol dan tidak memanggil remote.
local P=game:GetService("Players").LocalPlayer
local roots={P:WaitForChild("PlayerGui")}
local function path(x) local ok,v=pcall(function() return x:GetFullName() end) return ok and v or "?" end
local function add(s) out[#out+1]=tostring(s) end
local out={}
local function dumpTable(t,label)
 add(label.." TYPE=table")
 local n=0
 for k,v in pairs(t) do
  n=n+1
  if n>35 then add("  ... table dibatasi"); break end
  local tv=typeof and typeof(v) or type(v)
  local val
  if tv=="Instance" then val=v.ClassName.." "..path(v)
  elseif tv=="table" then val="table"
  elseif tv=="function" then val="function"
  else val=tostring(v):sub(1,140) end
  add("  KEY "..tostring(k):sub(1,100).." ["..tv.."] = "..val)
 end
 if n==0 then add("  (kosong)") end
end
local function inspectFn(fn,label)
 add("")
 add("=== "..label.." ===")
 if type(fn)~="function" then add("BUKAN FUNCTION: "..type(fn)); return end
 local dbg=debug
 local decomp=decompile or decompilefunction
 if type(decomp)=="function" then
  local ok,s=pcall(decomp,fn)
  if ok and type(s)=="string" then
   local i=0
   for line in (s.."\n"):gmatch("(.-)\n") do i=i+1 if i<=45 then add("SRC "..i..": "..line) end end
  else add("DECOMPILE: "..tostring(s)) end
 end
 local gu=(dbg and dbg.getupvalues) or getupvalues
 if type(gu)=="function" then
  local ok,u=pcall(gu,fn)
  if ok and type(u)=="table" then
   for k,v in pairs(u) do
    if type(k)=="number" and k<=15 then
     local typ=typeof and typeof(v) or type(v)
     if typ=="Instance" then add("UPVALUE "..k.." = "..v.ClassName.." "..path(v))
     elseif typ=="table" then dumpTable(v,"UPVALUE "..k)
     else add("UPVALUE "..k.." = "..typ..":"..tostring(v):sub(1,180)) end
    end
   end
  else add("GETUPVALUES: "..tostring(u)) end
 end
 local gc=(dbg and dbg.getconstants) or getconstants
 if type(gc)=="function" then
  local ok,c=pcall(gc,fn)
  if ok and type(c)=="table" then
   for i,v in ipairs(c) do if i<=100 and (type(v)=="string" or type(v)=="number" or type(v)=="boolean") then add("CONST "..i.." = "..tostring(v):sub(1,140)) end end
  else add("GETCONSTANTS: "..tostring(c)) end
 end
end
add("=== RAEL DIAGNOSTIC SEWA V6 ===")
add("PLAYER: "..P.Name)
local gui=P:FindFirstChild("PlayerGui")
local count=0
if gui then
 for _,b in ipairs(gui:GetDescendants()) do
  if b:IsA("TextButton") and b.Name=="AccBtn" then
   local card=b.Parent and b.Parent.Parent
   local title=card and card:FindFirstChild("Isi",true)
   local label=title and title:FindFirstChild("Label",true)
   if card and card.Name~="KartuTemplate" and label and label:IsA("TextLabel") and label.Text=="PERMINTAAN SEWA" then
    local vis=true local x=b
    while x do if x:IsA("GuiObject") and not x.Visible then vis=false end x=x.Parent end
    if vis then
     count=count+1
     add("")
     add("ACC BUTTON "..count.." "..path(b))
     local getcon=getconnections
     if type(getcon)=="function" then
      local ok,cons=pcall(getcon,b.Activated)
      if ok and type(cons)=="table" then
       add("ACTIVATED CONNECTIONS="..#cons)
       for ci,c in ipairs(cons) do
        local fn=c.Function
        add("CONNECTION "..ci.." enabled="..tostring(c.Enabled))
        local gu=(debug and debug.getupvalues) or getupvalues
        if type(gu)=="function" and type(fn)=="function" then
         local uok,u=pcall(gu,fn)
         if uok and type(u)=="table" then
          for ui,uv in pairs(u) do
           if ui<=8 then
            local typ=typeof and typeof(uv) or type(uv)
            if ui==3 and type(uv)=="function" then
             inspectFn(uv,"UPVALUE 3 / CALLBACK")
             local nok,nu=pcall(gu,uv)
             if nok and type(nu)=="table" then
              inspectFn(nu[2],"NESTED FUNCTION 2")
              inspectFn(nu[5],"NESTED FUNCTION 5")
             end
            elseif typ=="table" then dumpTable(uv,"HANDLER UPVALUE "..ui)
            else add("HANDLER UPVALUE "..ui.." = "..typ..":"..tostring(uv):sub(1,150)) end
           end
          end
         else add("HANDLER GETUPVALUES: "..tostring(u)) end
        end
       end
      else add("GETCONNECTIONS: "..tostring(cons)) end
     else add("getconnections tidak tersedia") end
    end
   end
  end
 end
end
add("")
add("ACTIVE TARGET COUNT="..count)
local result=table.concat(out,"\n")
local copied=false
if setclipboard then copied=pcall(setclipboard,result) elseif toclipboard then copied=pcall(toclipboard,result) end
local saved=false
if writefile then saved=pcall(writefile,"Rael_Tenant_V6.txt",result) end
local status="V6 | chars="..#result.." | clipboard="..tostring(copied).." | file="..tostring(saved)
if setclipboard then pcall(setclipboard,result.."\n\n"..status) elseif toclipboard then pcall(toclipboard,result.."\n\n"..status) end
if writefile then pcall(writefile,"Rael_Tenant_V6.txt",result.."\n\n"..status) end
