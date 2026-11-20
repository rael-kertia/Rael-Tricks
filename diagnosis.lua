-- RAEL DIAGNOSTIC SEWA V15 - INSPEKSI DATA KARTU
-- PASIF: tidak klik tombol dan tidak memanggil remote.
local O,seen={},{}
local function a(x) O[#O+1]=tostring(x) end
local function typ(v) local ok,t=pcall(typeof,v); return ok and t or type(v) end
local function val(v)
 local t=typ(v)
 if t=="Instance" then return v.ClassName.." "..v:GetFullName() end
 if type(v)=="table" then return "table "..tostring(v) end
 return t.." "..tostring(v):sub(1,160)
end
local function dumpTable(t,tag,depth)
 if type(t)~="table" or depth>3 or seen[t] then return end
 seen[t]=true
 a("\n["..tag.."] TABLE "..tostring(t))
 local n=0
 for k,v in pairs(t) do
  n=n+1; if n>45 then a("... TABLE_LIMIT"); break end
  local key=tostring(k):sub(1,80)
  a(tag.."."..key.." = "..val(v))
  if type(v)=="table" then dumpTable(v,tag.."."..key,depth+1) end
 end
end
local function getuv(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil end
 local ok,t=pcall(g,f); return ok and type(t)=="table" and t or nil
end
local function dumpFn(f,tag)
 if type(f)~="function" then return end
 a("\n### "..tag.." "..tostring(f))
 local gi=(debug and debug.getinfo) or getinfo
 if type(gi)=="function" then local ok,x=pcall(gi,f); if ok and type(x)=="table" then a("INFO "..tostring(x.name).." | "..tostring(x.source)) end end
 local gc=(debug and debug.getconstants) or getconstants
 if type(gc)=="function" then local ok,c=pcall(gc,f); if ok and type(c)=="table" then for i,v in ipairs(c) do if i>90 then break end; a("C"..i.." "..typ(v).." "..tostring(v):sub(1,130)) end end end
 local u=getuv(f)
 if u then for i=1,12 do local v=u[i]; if v~=nil then
  a("UV"..i.." "..val(v))
  if type(v)=="table" then dumpTable(v,tag..".UV"..i,0) end
  if type(v)=="function" and i<=6 then
   local fu=getuv(v)
   if fu then for j=1,8 do if fu[j]~=nil then a(tag..".UV"..i..".UV"..j.." "..val(fu[j])); if type(fu[j])=="table" then dumpTable(fu[j],tag..".UV"..i..".UV"..j,0) end end end end
  end
 end end end
end
local function save()
 local s="=== RAEL SEWA V15 ===\n"..table.concat(O,"\n")
 local cp,wf=false,false
 if setclipboard then cp=pcall(setclipboard,s) elseif toclipboard then cp=pcall(toclipboard,s) end
 if writefile then wf=pcall(writefile,"Rael_Sewa_V15.txt",s) end
 local tail="\n\nV15 END | chars="..#s.." | clipboard="..tostring(cp).." | file="..tostring(wf)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V15.txt",s..tail) end
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
   local cons=getconnections and getconnections(b.Activated)
   if type(cons)=="table" then for _,c in ipairs(cons) do
    if type(c.Function)=="function" then
     local h=getuv(c.Function); local cb=h and h[3]
     if type(cb)=="function" then
      a("CARD_ID="..tostring(h[4]))
      dumpFn(cb,"ACC_CALLBACK")
      local cu=getuv(cb)
      if cu then
       if type(cu[1])=="table" then dumpTable(cu[1],"CALLBACK_SHARED_TABLE",0) end
       for i=1,12 do if type(cu[i])=="function" then dumpFn(cu[i],"CALLBACK_UV"..i) end end
      end
     end
    end
   end end
  end
 end
 a("\nVISIBLE_BUTTONS="..n)
 local svc=game:GetService("ReplicatedStorage"):FindFirstChild("NKSystem")
 if svc then
  local knit=svc:FindFirstChild("Packages") and svc.Packages:FindFirstChild("Knit")
  local services=knit and knit:FindFirstChild("Services")
  local penyewa=services and services:FindFirstChild("PenyewaService")
  local rf=penyewa and penyewa:FindFirstChild("RF")
  if rf then for _,name in ipairs({"Respond","VerifyReject"}) do local r=rf:FindFirstChild(name); if r then a("REMOTE "..r.ClassName.." "..r:GetFullName()) end end end
 end
end,function(e) return tostring(e) end)
if not ok then a("SCAN_FAILURE="..tostring(err)) end
save()
