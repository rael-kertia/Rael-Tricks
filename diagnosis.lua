-- RAEL DIAGNOSTIC SEWA V14 - DECOMPILE CALLBACK
-- PASIF: tidak klik dan tidak memanggil remote.
local O={}
local function a(x) O[#O+1]=tostring(x) end
local function safe(fn,...)
 if type(fn)~="function" then return nil end
 local ok,v=pcall(fn,...); if ok then return v end
 return nil
end
local function dumpSource(f,tag)
 if type(f)~="function" then return end
 a("\n### "..tag.." "..tostring(f))
 local gi=(debug and debug.getinfo) or getinfo
 local inf=safe(gi,f)
 if type(inf)=="table" then a("INFO name="..tostring(inf.name).." src="..tostring(inf.source).." line="..tostring(inf.linedefined).." params="..tostring(inf.nparams)) end
 local dc=decompile or (debug and debug.decompile)
 if type(dc)=="function" then
  local src=safe(dc,f)
  if type(src)=="string" then
   a("DECOMPILE_BEGIN")
   a(src:sub(1,12000))
   a("DECOMPILE_END")
  else a("DECOMPILE_UNAVAILABLE") end
 else a("NO_DECOMPILE_API") end
 local gc=(debug and debug.getconstants) or getconstants
 local cs=safe(gc,f)
 if type(cs)=="table" then
  a("CONSTANTS:")
  for i,v in ipairs(cs) do if i>160 then break end
   a("C"..i.." ["..typeof(v).."]="..tostring(v):sub(1,180))
  end
 else a("CONSTANTS_UNAVAILABLE") end
 local gp=(debug and debug.getprotos) or getprotos
 local ps=safe(gp,f)
 if type(ps)=="table" then
  a("PROTOS="..#ps)
  local gpr=(debug and debug.getproto) or getproto
  for i=1,math.min(#ps,8) do
   local p=ps[i]
   if type(p)~="function" and type(gpr)=="function" then p=safe(gpr,f,i,true) or safe(gpr,f,i) end
   if type(p)=="function" then
    a("\nPROTO_"..i.." "..tostring(p))
    local pi=safe(gi,p)
    if type(pi)=="table" then a("PROTO_INFO name="..tostring(pi.name).." src="..tostring(pi.source).." line="..tostring(pi.linedefined)) end
    local pc=safe(gc,p)
    if type(pc)=="table" then for j,v in ipairs(pc) do if j>100 then break end; a("P"..i.."C"..j.." ["..typeof(v).."]="..tostring(v):sub(1,160)) end end
    local pd=type(dc)=="function" and safe(dc,p) or nil
    if type(pd)=="string" then a("PROTO_DECOMPILE_BEGIN"); a(pd:sub(1,7000)); a("PROTO_DECOMPILE_END") end
   else a("PROTO_"..i.."_NOT_FUNCTION "..typeof(p).." "..tostring(p)) end
  end
 else a("PROTOS_UNAVAILABLE") end
end
local function save()
 local s="=== RAEL SEWA V14 ===\n"..table.concat(O,"\n")
 local cp,wf=false,false
 if setclipboard then cp=pcall(setclipboard,s) elseif toclipboard then cp=pcall(toclipboard,s) end
 if writefile then wf=pcall(writefile,"Rael_Sewa_V14.txt",s) end
 local tail="\n\nV14 END | chars="..#s.." | clipboard="..tostring(cp).." | file="..tostring(wf)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V14.txt",s..tail) end
end
local ok,err=xpcall(function()
 local pl=game:GetService("Players").LocalPlayer
 local ui=pl:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 if not ui then a("UI_NOT_FOUND"); return end
 local n=0
 for _,b in ipairs(ui:GetDescendants()) do
  local visible=true; local q=b
  while q do if q:IsA("GuiObject") and not q.Visible then visible=false end; q=q.Parent end
  if b:IsA("TextButton") and b.Name=="AccBtn" and visible then
   n=n+1; a("\nBUTTON "..b:GetFullName())
   local con=getconnections and safe(getconnections,b.Activated)
   if type(con)=="table" then
    for _,c in ipairs(con) do
     local fn=c.Function
     if type(fn)=="function" then
      local gu=(debug and debug.getupvalues) or getupvalues
      local uv=safe(gu,fn)
      local cb=type(uv)=="table" and uv[3]
      if type(cb)=="function" then
       a("CARD_ID_UPVALUE4="..tostring(uv[4]))
       dumpSource(cb,"ACC_CALLBACK")
       local cu=safe(gu,cb)
       if type(cu)=="table" then
        for i,v in ipairs(cu) do
         if type(v)=="function" then dumpSource(v,"CALLBACK_UPVALUE_"..i) end
        end
       end
      end
     end
    end
   else a("GETCONNECTIONS_UNAVAILABLE") end
  end
 end
 a("\nVISIBLE_BUTTONS="..n)
end,function(e) return tostring(e) end)
if not ok then a("SCAN_FAILURE="..tostring(err)) end
save()
