-- RAEL DIAGNOSTIC SEWA V12 - RESPOND REMOTE
-- PASIF: hanya membaca objek, tidak klik dan tidak memanggil remote.
local O,seen={},{}
local function a(x) O[#O+1]=tostring(x) end
local function ups(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil end
 local ok,t=pcall(g,f); if ok and type(t)=="table" then return t end
end
local function constants(f,tag)
 local g=(debug and debug.getconstants) or getconstants
 if type(g)~="function" then a(tag.." CONST_API=NONE"); return end
 local ok,t=pcall(g,f); if not ok or type(t)~="table" then a(tag.." CONST_FAIL"); return end
 for i,v in ipairs(t) do
  if i>90 then break end
  if type(v)=="string" or type(v)=="number" or type(v)=="boolean" then
   a(tag.." C"..i.."="..tostring(v):sub(1,100))
  end
 end
end
local function inspectRemote(v,tag)
 a(tag.." TYPE="..typeof(v).." VALUE="..tostring(v))
 if typeof(v)=="Instance" then
  a(tag.." CLASS="..v.ClassName.." NAME="..v.Name.." PATH="..v:GetFullName())
 elseif type(v)=="userdata" then
  local mt
  pcall(function() mt=getmetatable(v) end)
  a(tag.." METATABLE="..tostring(mt))
  if type(mt)=="table" then
   for k,x in pairs(mt) do
    if type(x)~="table" then a(tag.." MT["..tostring(k).."]="..type(x)..":"..tostring(x):sub(1,100)) end
   end
  end
 end
end
local function inspectFn(f,tag)
 if type(f)~="function" or seen[f] then return end
 seen[f]=true
 a("")
 a("### "..tag.." "..tostring(f))
 local gi=(debug and debug.getinfo) or getinfo
 if type(gi)=="function" then
  local ok,i=pcall(gi,f)
  if ok and type(i)=="table" then a(tag.." INFO name="..tostring(i.name).." source="..tostring(i.source).." line="..tostring(i.linedefined)) end
 end
 constants(f,tag)
 local u=ups(f)
 if not u then a(tag.." UPVALUES_UNAVAILABLE"); return end
 for i=1,12 do
  local v=u[i]
  if v~=nil then
   a(tag.." UV"..i.." TYPE="..type(v).." VALUE="..tostring(v):sub(1,140))
   if typeof(v)=="Instance" or type(v)=="userdata" then inspectRemote(v,tag..".UV"..i) end
  end
 end
end
local function finish()
 local s="=== RAEL SEWA V12 ===\n"..table.concat(O,"\n")
 local cp=false
 if setclipboard then cp=pcall(setclipboard,s) elseif toclipboard then cp=pcall(toclipboard,s) end
 local wf=false
 if writefile then wf=pcall(writefile,"Rael_Sewa_V12.txt",s) end
 local tail="\n\nV12 END | chars="..#s.." | clipboard="..tostring(cp).." | file="..tostring(wf)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V12.txt",s..tail) end
end
local ok,err=xpcall(function()
 local p=game:GetService("Players").LocalPlayer
 local root=p:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 if not root then a("UI_NOT_FOUND"); return end
 local count=0
 for _,b in ipairs(root:GetDescendants()) do
  local vis=true local q=b
  while q do if q:IsA("GuiObject") and not q.Visible then vis=false end q=q.Parent end
  if b:IsA("TextButton") and b.Name=="AccBtn" and vis then
   count=count+1; a("BUTTON "..b:GetFullName())
   local cs=getconnections and getconnections(b.Activated)
   if cs then for _,c in ipairs(cs) do
    if type(c.Function)=="function" then
     local h=ups(c.Function)
     local cb=h and h[3]
     local cu=type(cb)=="function" and ups(cb)
     local f5=cu and cu[5]
     local f5u=type(f5)=="function" and ups(f5)
     local svc=f5u and f5u[4]
     if type(svc)=="table" then
      for _,key in ipairs({"Respond","VerifyReject"}) do
       local wrapper=svc[key]
       if type(wrapper)=="function" then
        a("SERVICE_METHOD="..key)
        inspectFn(wrapper,"WRAPPER_"..key)
        local wu=ups(wrapper)
        local inner=wu and wu[1]
        if type(inner)=="function" then
         inspectFn(inner,"INNER_"..key)
         local iu=ups(inner)
         if iu then
          for z=1,12 do
           local v=iu[z]
           if typeof(v)=="Instance" or type(v)=="userdata" then inspectRemote(v,"INNER_"..key.."_OBJECT"..z) end
           if type(v)=="function" then inspectFn(v,"INNER_"..key.."_FUNCTION"..z) end
          end
         end
        end
       end
      end
     else a("SERVICE_TABLE_NOT_FOUND") end
    end
   end end
  end
 end
 a("VISIBLE_BUTTONS="..count)
end,function(e) return tostring(e) end)
if not ok then a("SCAN_FAILURE="..tostring(err)) end
finish()
