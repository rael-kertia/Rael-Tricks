-- RAEL DIAGNOSTIC SEWA V7 - FAILSAFE
-- PASIF: tidak klik ACC, tidak memanggil remote.
local output={}
local function add(x) output[#output+1]=tostring(x) end
local function finish(tag)
 local result="=== RAEL SEWA V7 ===\n"..tag.."\n"..table.concat(output,"\n")
 local copied=false
 if setclipboard then copied=pcall(setclipboard,result) elseif toclipboard then copied=pcall(toclipboard,result) end
 local saved=false
 if writefile then saved=pcall(writefile,"Rael_Tenant_V7.txt",result) end
 local status="\n\nV7 END | chars="..#result.." | clipboard="..tostring(copied).." | file="..tostring(saved)
 if setclipboard then pcall(setclipboard,result..status) elseif toclipboard then pcall(toclipboard,result..status) end
 if writefile then pcall(writefile,"Rael_Tenant_V7.txt",result..status) end
end
local ok,err=xpcall(function()
 local P=game:GetService("Players").LocalPlayer
 local gui=P:WaitForChild("PlayerGui")
 add("PLAYER="..P.Name)
 local function path(x) local a,b=pcall(function() return x:GetFullName() end) return a and b or "?" end
 local function dumpTable(t,label)
  add(label.." [TABLE]")
  local n=0
  for k,v in pairs(t) do
   n=n+1
   if n>30 then add("  (table dipotong)"); break end
   local typ=typeof and typeof(v) or type(v)
   local val
   if typ=="Instance" then val=v.ClassName.." "..path(v)
   elseif typ=="table" then val="{table}"
   elseif typ=="function" then val="{function}"
   else val=tostring(v):sub(1,120) end
   add("  ["..tostring(k).."] "..typ.." = "..val)
  end
  if n==0 then add("  (kosong)") end
 end
 local function inspect(fn,label)
  add("")
  add("--- "..label.." ---")
  if type(fn)~="function" then add("BUKAN FUNCTION: "..type(fn)); return end
  local d=decompile or decompilefunction
  if type(d)=="function" then
   local a,s=pcall(d,fn)
   if a and type(s)=="string" then
    local n=0
    for line in (s.."\n"):gmatch("(.-)\n") do n=n+1 if n<=35 then add("SRC "..n..": "..line) end end
   else add("DECOMPILE GAGAL: "..tostring(s)) end
  else add("DECOMPILE TIDAK ADA") end
  local gu=(debug and debug.getupvalues) or getupvalues
  if type(gu)=="function" then
   local a,u=pcall(gu,fn)
   if a and type(u)=="table" then
    for k,v in pairs(u) do
     if type(k)=="number" and k<=12 then
      local typ=typeof and typeof(v) or type(v)
      if typ=="table" then dumpTable(v,"UPVALUE "..k)
      elseif typ=="Instance" then add("UPVALUE "..k.." = "..v.ClassName.." "..path(v))
      else add("UPVALUE "..k.." = "..typ..":"..tostring(v):sub(1,140)) end
     end
    end
   else add("GETUPVALUES GAGAL: "..tostring(u)) end
  else add("GETUPVALUES TIDAK TERSEDIA") end
  local gc=(debug and debug.getconstants) or getconstants
  if type(gc)=="function" then
   local a,c=pcall(gc,fn)
   if a and type(c)=="table" then
    for i,v in ipairs(c) do if i<=70 and (type(v)=="string" or type(v)=="number" or type(v)=="boolean") then add("CONST "..i.." = "..tostring(v):sub(1,120)) end end
   else add("GETCONSTANTS GAGAL: "..tostring(c)) end
  end
 end
 add("PLAYERGUI DITEMUKAN")
 local n=0
 for _,b in ipairs(gui:GetDescendants()) do
  if b:IsA("TextButton") and b.Name=="AccBtn" then
   local card=b.Parent and b.Parent.Parent
   local label=card and card:FindFirstChild("Label",true)
   if card and card.Name~="KartuTemplate" and label and label:IsA("TextLabel") and label.Text=="PERMINTAAN SEWA" and b.Visible then
    local visible=true
    local p=b
    while p do if p:IsA("GuiObject") and not p.Visible then visible=false end p=p.Parent end
    if visible then
     n=n+1
     add("")
     add("ACC #"..n.." "..path(b))
     if type(getconnections)=="function" then
      local a,cs=pcall(getconnections,b.Activated)
      if a and type(cs)=="table" then
       add("CONNECTIONS="..#cs)
       for ci,c in ipairs(cs) do
        add("CONNECTION "..ci.." enabled="..tostring(c.Enabled))
        local gu=(debug and debug.getupvalues) or getupvalues
        if type(gu)=="function" and type(c.Function)=="function" then
         local ua,u=pcall(gu,c.Function)
         if ua and type(u)=="table" then
          for ui,uv in pairs(u) do
           if ui<=6 then
            local typ=typeof and typeof(uv) or type(uv)
            if ui==3 and type(uv)=="function" then
             inspect(uv,"UPVALUE 3 CALLBACK")
             local na,nu=pcall(gu,uv)
             if na and type(nu)=="table" then
              inspect(nu[2],"NESTED FUNCTION 2")
              inspect(nu[5],"NESTED FUNCTION 5")
             else add("NESTED GETUPVALUES GAGAL: "..tostring(nu)) end
            elseif typ=="table" then dumpTable(uv,"HANDLER UPVALUE "..ui)
            else add("HANDLER UPVALUE "..ui.." = "..typ..":"..tostring(uv):sub(1,120)) end
           end
          end
         else add("CALLBACK GETUPVALUES GAGAL: "..tostring(u)) end
        end
       end
      else add("GETCONNECTIONS GAGAL: "..tostring(cs)) end
     else add("GETCONNECTIONS TIDAK TERSEDIA") end
    end
   end
  end
 end
 add("")
 add("ACTIVE ACC COUNT="..n)
end,function(e) return tostring(e) end)
if ok then finish("STATUS=SELESAI") else add("RUNTIME FAILURE="..tostring(err)); finish("STATUS=GAGAL / FAILSAFE") end
