-- RAEL DIAGNOSTIC SEWA V13 - TRACE ARGUMEN ACC
-- PASIF: tidak klik, tidak memanggil Respond/VerifyReject.
local O,seen={},{}
local function a(x) O[#O+1]=tostring(x) end
local function up(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil end
 local ok,t=pcall(g,f); if ok and type(t)=="table" then return t end
end
local function info(f,tag,depth)
 if type(f)~="function" then return end
 local id=tostring(f); if seen[id] then return end; seen[id]=true
 a("\n### "..tag.." "..id.." depth="..depth)
 local gi=(debug and debug.getinfo) or getinfo
 if type(gi)=="function" then local ok,x=pcall(gi,f); if ok and type(x)=="table" then a("INFO name="..tostring(x.name).." src="..tostring(x.source).." line="..tostring(x.linedefined).." nparams="..tostring(x.nparams)) end end
 local gc=(debug and debug.getconstants) or getconstants
 if type(gc)=="function" then
  local ok,t=pcall(gc,f); if ok and type(t)=="table" then
   for i,v in ipairs(t) do if i>100 then break end
    if type(v)=="string" or type(v)=="number" or type(v)=="boolean" then a("C"..i.."="..tostring(v):sub(1,90)) end
   end
  end
 end
 local u=up(f)
 if u then for i=1,12 do local v=u[i]; if v~=nil then
  local ty=typeof(v); local st=tostring(v)
  a("UV"..i.." "..ty.." "..st:sub(1,130))
  if type(v)=="table" then
   local n=0
   for k,x in pairs(v) do
    n=n+1; if n>12 then a("UV"..i.." TABLE_MORE"); break end
    if type(x)~="table" then a("UV"..i.."["..tostring(k):sub(1,35).."]="..typeof(x)..":"..tostring(x):sub(1,90)) end
   end
  end
  if typeof(v)=="Instance" then a("INSTANCE "..v.ClassName.." "..v:GetFullName()) end
  if type(v)=="function" and depth<2 then info(v,tag.."_UV"..i,depth+1) end
 end end end
 local gp=(debug and debug.getprotos) or getprotos
 if type(gp)=="function" and depth<2 then
  local ok,ps=pcall(gp,f)
  if ok and type(ps)=="table" then
   a("PROTOS="..#ps)
   for i,p in ipairs(ps) do if i>8 then break end; info(p,tag.."_PROTO"..i,depth+1) end
  else a("PROTOS_UNAVAILABLE") end
 end
end
local function save()
 local s="=== RAEL SEWA V13 ===\n"..table.concat(O,"\n")
 local cp,wf=false,false
 if setclipboard then cp=pcall(setclipboard,s) elseif toclipboard then cp=pcall(toclipboard,s) end
 if writefile then wf=pcall(writefile,"Rael_Sewa_V13.txt",s) end
 local tail="\n\nV13 END | chars="..#s.." | clipboard="..tostring(cp).." | file="..tostring(wf)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V13.txt",s..tail) end
end
local ok,err=xpcall(function()
 local p=game:GetService("Players").LocalPlayer
 local root=p:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 if not root then a("UI_NOT_FOUND"); return end
 local count=0
 for _,b in ipairs(root:GetDescendants()) do
  local vis=true; local q=b
  while q do if q:IsA("GuiObject") and not q.Visible then vis=false end; q=q.Parent end
  if b:IsA("TextButton") and b.Name=="AccBtn" and vis then
   count=count+1; a("\nBUTTON "..b:GetFullName())
   local cs=getconnections and getconnections(b.Activated)
   if cs then for _,c in ipairs(cs) do if type(c.Function)=="function" then
    local h=up(c.Function); local cb=h and h[3]
    if type(cb)=="function" then
     a("CARD_ID_UPVALUE4="..tostring(h[4]))
     info(cb,"ACC_CALLBACK",0)
     local cu=up(cb); local f5=cu and cu[5]
     if type(f5)=="function" then info(f5,"CALLBACK_UV5",0) end
    end
   end end end
  end
 end
 a("\nVISIBLE_BUTTONS="..count)
end,function(e) return tostring(e) end)
if not ok then a("SCAN_FAILURE="..tostring(err)) end
save()
