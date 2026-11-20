-- RAEL SEWA V17 - PROTOTYPE TABLE INSPECTION (PASSIVE)
local O,seen={},{}
local function a(x) O[#O+1]=tostring(x) end
local function safe(fn,...) if type(fn)~="function" then return nil end local ok,v=pcall(fn,...); if ok then return v end end
local function uv(f) local g=(debug and debug.getupvalues) or getupvalues; local t=safe(g,f); return type(t)=="table" and t end
local function dump(t,tag,depth)
 if type(t)~="table" or depth>3 or seen[t] then return end
 seen[t]=true; a("\nTABLE "..tag.." "..tostring(t))
 local n=0
 for k,v in pairs(t) do
  n=n+1; if n>80 then a("LIMIT"); break end
  a(tag.."["..tostring(k).."] "..typeof(v).." "..tostring(v):sub(1,180))
  if type(v)=="function" then
   local inf=safe((debug and debug.getinfo) or getinfo,v)
   if type(inf)=="table" then a("  INFO "..tostring(inf.name).." "..tostring(inf.source).." line="..tostring(inf.linedefined)) end
   local c=safe((debug and debug.getconstants) or getconstants,v)
   if type(c)=="table" then for i,x in ipairs(c) do if i>80 then break end; a("  C"..i.." "..typeof(x).." "..tostring(x):sub(1,120)) end end
   local vu=uv(v); if vu then for i=1,10 do if vu[i]~=nil then
    a("  UV"..i.." "..typeof(vu[i]).." "..tostring(vu[i]):sub(1,140))
    if type(vu[i])=="table" then dump(vu[i],tag..".UV"..i,depth+1) end
    if typeof(vu[i])=="Instance" then a("  PATH "..vu[i]:GetFullName()) end
   end end end
  elseif type(v)=="table" then dump(v,tag.."."..tostring(k),depth+1)
  elseif typeof(v)=="Instance" then a("  PATH "..v:GetFullName()) end
 end
end
local function fn(f,tag)
 if type(f)~="function" then a(tag.." NOT_FUNCTION"); return end
 a("\nFUNCTION "..tag.." "..tostring(f))
 local inf=safe((debug and debug.getinfo) or getinfo,f)
 if type(inf)=="table" then a("INFO "..tostring(inf.name).." src="..tostring(inf.source).." line="..tostring(inf.linedefined)) end
 local c=safe((debug and debug.getconstants) or getconstants,f)
 if type(c)=="table" then for i,v in ipairs(c) do if i>100 then break end; a("C"..i.." "..typeof(v).." "..tostring(v):sub(1,150)) end end
 local u=uv(f)
 if u then for i=1,12 do if u[i]~=nil then
  a("UV"..i.." "..typeof(u[i]).." "..tostring(u[i]):sub(1,160))
  if type(u[i])=="table" then dump(u[i],tag..".UV"..i,0) end
  if typeof(u[i])=="Instance" then a("INSTANCE "..u[i].ClassName.." "..u[i]:GetFullName()) end
 end end end
 local gp=(debug and debug.getprotos) or getprotos
 local ps=safe(gp,f); if type(ps)=="table" then
  a("PROTOS_COUNT "..#ps)
  local gpr=(debug and debug.getproto) or getproto
  for i=1,math.min(#ps,8) do
   local p=ps[i]
   if type(p)~="function" and type(gpr)=="function" then p=safe(gpr,f,i,true) or safe(gpr,f,i) or p end
   if type(p)=="table" then dump(p,tag..".PROTO"..i,0)
   elseif type(p)=="function" then a("PROTO"..i.." FUNCTION "..tostring(p))
   else a("PROTO"..i.." "..typeof(p).." "..tostring(p)) end
  end
 end
end
local ok,e=xpcall(function()
 local pl=game:GetService("Players").LocalPlayer
 local ui=pl:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 local stack=ui and ui:FindFirstChild("Tumpukan",true)
 local btn
 if stack then for _,x in ipairs(stack:GetDescendants()) do if x:IsA("TextButton") and x.Name=="AccBtn" then
  local vis=true; local q=x; while q do if q:IsA("GuiObject") and not q.Visible then vis=false end; q=q.Parent end
  if vis then btn=x; break end
 end end end
 if not btn then a("VISIBLE_ACC_NOT_FOUND"); return end
 a("BUTTON "..btn:GetFullName())
 local cons=getconnections and safe(getconnections,btn.Activated)
 local callback
 if type(cons)=="table" then for _,c in ipairs(cons) do if type(c.Function)=="function" then
  local u=uv(c.Function); if u and type(u[3])=="function" then callback=u[3]; break end
 end end end
 if not callback then a("CALLBACK_NOT_FOUND"); return end
 fn(callback,"ACC_CALLBACK")
 local u=uv(callback)
 if u and type(u[3])=="table" then
  for _,name in ipairs({"Respond","RespondWithVerify","VerifyReject"}) do
   local w=u[3][name]
   if type(w)=="function" then
    fn(w,"WRAPPER_"..name)
    local wu=uv(w)
    if wu and type(wu[1])=="function" then fn(wu[1],"INNER_"..name) end
   end
  end
 end
 -- Check whether controller ModuleScript exposes readable Source; never execute it.
 local nk=game:GetService("ReplicatedStorage"):FindFirstChild("NKSystem")
 local ctrl=nk and nk:FindFirstChild("Controller")
 local mod=ctrl and ctrl:FindFirstChild("PenyewaController")
 if mod then
  a("\nCONTROLLER_MODULE "..mod.ClassName.." "..mod:GetFullName())
  local okS,src=pcall(function() return mod.Source end)
  a("SOURCE_READABLE="..tostring(okS).." TYPE="..typeof(src).." LENGTH="..(okS and type(src)=="string" and #src or 0))
  if okS and type(src)=="string" then
   local lines=string.split(src,"\n")
   for i,line in ipairs(lines) do
    if line:find("Respond",1,true) or line:find("isTarget",1,true) or line:find("tid",1,true) then
     a("SOURCE_LINE "..i.." "..line:sub(1,300))
    end
   end
  end
 else a("CONTROLLER_MODULE_NOT_FOUND") end
end,function(x) return tostring(x) end)
if not ok then a("SCAN_STOPPED "..tostring(e)) end
local out="=== RAEL SEWA V17 ===\n"..table.concat(O,"\n")
local tail="\nV17 END | chars="..#out
if setclipboard then pcall(setclipboard,out..tail) elseif toclipboard then pcall(toclipboard,out..tail) end
if writefile then pcall(writefile,"Rael_Sewa_V17.txt",out..tail) end
