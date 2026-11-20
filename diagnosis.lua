-- RAEL DIAGNOSTIC SEWA V16 - RESPOND WRAPPER
-- PASIF: hanya inspeksi fungsi dan RemoteFunction; tidak InvokeServer/FireServer.
local O,seen={},{}
local function a(x) O[#O+1]=tostring(x) end
local function safe(fn,...)
 if type(fn)~="function" then return nil end
 local ok,v=pcall(fn,...); if ok then return v end
end
local function getuv(f)
 local g=(debug and debug.getupvalues) or getupvalues
 local t=safe(g,f); return type(t)=="table" and t or nil
end
local function dumpTable(t,tag,depth)
 if type(t)~="table" or depth>2 or seen[t] then return end
 seen[t]=true; a("\n["..tag.."] "..tostring(t))
 local n=0
 for k,v in pairs(t) do
  n=n+1; if n>30 then a("TABLE_LIMIT"); break end
  a(tag.."."..tostring(k).." = "..typeof(v).." "..tostring(v):sub(1,140))
  if type(v)=="table" then dumpTable(v,tag.."."..tostring(k),depth+1) end
  if type(v)=="function" then
   local u=getuv(v)
   if u then for i=1,8 do if u[i]~=nil then a(tag.."."..tostring(k)..".UV"..i.." = "..typeof(u[i]).." "..tostring(u[i]):sub(1,140)) end end end
  end
 end
end
local function dumpFn(f,tag,depth)
 if type(f)~="function" or depth>2 or seen[f] then return end
 seen[f]=true; a("\n### "..tag.." "..tostring(f))
 local gi=(debug and debug.getinfo) or getinfo
 local inf=safe(gi,f)
 if type(inf)=="table" then
  a("INFO name="..tostring(inf.name).." src="..tostring(inf.source).." line="..tostring(inf.linedefined).." params="..tostring(inf.nparams).." vararg="..tostring(inf.isvararg))
 end
 local gc=(debug and debug.getconstants) or getconstants
 local cs=safe(gc,f)
 if type(cs)=="table" then for i,v in ipairs(cs) do if i>120 then break end; a("C"..i.." "..typeof(v).." "..tostring(v):sub(1,160)) end else a("CONSTANTS_UNAVAILABLE") end
 local uv=getuv(f)
 if uv then for i=1,12 do local v=uv[i]; if v~=nil then
  a("UV"..i.." "..typeof(v).." "..tostring(v):sub(1,180))
  if type(v)=="table" then dumpTable(v,tag..".UV"..i,0) end
  if type(v)=="function" then dumpFn(v,tag..".UV"..i,depth+1) end
  if typeof(v)=="Instance" then a("INSTANCE_CLASS="..v.ClassName.." PATH="..v:GetFullName()) end
 end end else a("UPVALUES_UNAVAILABLE") end
 local gp=(debug and debug.getprotos) or getprotos
 local ps=safe(gp,f)
 if type(ps)=="table" then
  a("PROTOS="..#ps)
  local gpr=(debug and debug.getproto) or getproto
  for i=1,math.min(#ps,6) do
   local p=ps[i]
   if type(p)~="function" and type(gpr)=="function" then p=safe(gpr,f,i,true) or safe(gpr,f,i) end
   if type(p)=="function" then dumpFn(p,tag..".PROTO"..i,depth+1) else a("PROTO"..i.." "..typeof(p).." "..tostring(p)) end
  end
 end
end
local function save()
 local s="=== RAEL SEWA V16 ===\n"..table.concat(O,"\n")
 local cp,wf=false,false
 if setclipboard then cp=pcall(setclipboard,s) elseif toclipboard then cp=pcall(toclipboard,s) end
 if writefile then wf=pcall(writefile,"Rael_Sewa_V16.txt",s) end
 local tail="\n\nV16 END | chars="..#s.." | clipboard="..tostring(cp).." | file="..tostring(wf)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V16.txt",s..tail) end
end
local ok,err=xpcall(function()
 local rs=game:GetService("ReplicatedStorage")
 local nk=rs:FindFirstChild("NKSystem")
 local packages=nk and nk:FindFirstChild("Packages")
 local knit=packages and packages:FindFirstChild("Knit")
 local services=knit and knit:FindFirstChild("Services")
 local ps=services and services:FindFirstChild("PenyewaService")
 local rf=ps and ps:FindFirstChild("RF")
 if not rf then a("PENYEWA_RF_NOT_FOUND"); return end
 for _,name in ipairs({"Respond","VerifyReject"}) do
  local remote=rf:FindFirstChild(name)
  if remote then a("\nREMOTE "..remote.ClassName.." "..remote:GetFullName()) end
 end
 local pl=game:GetService("Players").LocalPlayer
 local ui=pl:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 local btn=ui and ui:FindFirstChild("Tumpukan",true)
 local acc
 if btn then for _,x in ipairs(btn:GetDescendants()) do if x:IsA("TextButton") and x.Name=="AccBtn" then
  local visible=true; local q=x
  while q do if q:IsA("GuiObject") and not q.Visible then visible=false end; q=q.Parent end
  if visible then acc=x; break end
 end end end
 if not acc then a("VISIBLE_ACC_NOT_FOUND"); return end
 a("BUTTON "..acc:GetFullName())
 local cons=getconnections and safe(getconnections,acc.Activated)
 local cb
 if type(cons)=="table" then for _,c in ipairs(cons) do
  if type(c.Function)=="function" then local u=getuv(c.Function); if u and type(u[3])=="function" then cb=u[3]; break end end
 end end
 if not cb then a("ACC_CALLBACK_NOT_FOUND") else
  a("CALLBACK_IDENTITY "..tostring(cb))
  local cu=getuv(cb)
  if cu and type(cu[3])=="table" then
   for _,method in ipairs({"Respond","RespondWithVerify","VerifyReject"}) do
    local fn=cu[3][method]
    if type(fn)=="function" then dumpFn(fn,"SERVICE_METHOD_"..method,0) else a("METHOD_"..method.."_NOT_FUNCTION") end
   end
  else a("CALLBACK_SERVICE_TABLE_NOT_FOUND") end
 end
end,function(e) return tostring(e) end)
if not ok then a("SCAN_FAILURE="..tostring(err)) end
save()
