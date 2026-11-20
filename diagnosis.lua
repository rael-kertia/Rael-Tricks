-- RAEL DIAGNOSTIC SEWA V10 - TELUSURI RESPOND
-- PASIF: tidak klik tombol dan tidak memanggil remote.
local out={}
local function add(v) out[#out+1]=tostring(v) end
local function ups(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil,"API_UPVALUES_TIDAK_ADA" end
 local ok,v=pcall(g,f)
 if ok and type(v)=="table" then return v end
 return nil,tostring(v)
end
local function cons(f,tag)
 local g=(debug and debug.getconstants) or getconstants
 if type(g)~="function" then add(tag.." CONSTANTS_API=NONE") return end
 local ok,v=pcall(g,f)
 if not ok or type(v)~="table" then add(tag.." CONSTANTS_FAIL="..tostring(v)) return end
 for i,x in ipairs(v) do
  if i>70 then break end
  if type(x)=="string" or type(x)=="number" or type(x)=="boolean" then add(tag.." C"..i.."="..tostring(x):sub(1,120)) end
 end
end
local function inspect(f,tag,depth)
 if type(f)~="function" then add(tag.." NOT_FUNCTION="..type(f)); return end
 add("")
 add("=== FUNCTION "..tag.." "..tostring(f).." ===")
 cons(f,tag)
 local u,e=ups(f)
 if not u then add(tag.." UPS_FAIL="..e); return end
 for i=1,12 do
  local v=u[i]
  if v~=nil then
   add(tag.." UV"..i.." TYPE="..type(v).." VALUE="..tostring(v):sub(1,150))
   if type(v)=="table" and depth>0 then
    local n=0
    for k,z in pairs(v) do
     n=n+1
     if n>35 then add(tag.." TABLE_TRUNCATED"); break end
     add(tag.." TABLE["..tostring(k):sub(1,80).."] TYPE="..type(z).." VALUE="..tostring(z):sub(1,130))
     if type(z)=="function" and (tostring(k)=="Respond" or tostring(k)=="VerifyReject" or tostring(k)=="TenantLeft" or tostring(k)=="TenantArrived") then
      inspect(z,tag.."."..tostring(k),depth-1)
     elseif type(z)=="table" then
      for k2,z2 in pairs(z) do
       if type(z2)=="function" then add(tag.." TABLE SUB "..tostring(k).."."..tostring(k2).." FN="..tostring(z2)) end
      end
     end
    end
   end
  end
 end
end
local function finish(status)
 local s="=== RAEL SEWA V10 ===\n"..status.."\n"..table.concat(out,"\n")
 local copied=false
 if setclipboard then copied=pcall(setclipboard,s) elseif toclipboard then copied=pcall(toclipboard,s) end
 local saved=false
 if writefile then saved=pcall(writefile,"Rael_Sewa_V10.txt",s) end
 local tail="\n\nV10 END | chars="..#s.." | clipboard="..tostring(copied).." | file="..tostring(saved)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V10.txt",s..tail) end
end
local ok,err=xpcall(function()
 local p=game:GetService("Players").LocalPlayer
 local root=p:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 if not root then add("UI_NOT_FOUND"); return end
 local n=0
 for _,b in ipairs(root:GetDescendants()) do
  if b:IsA("TextButton") and b.Name=="AccBtn" then
   local visible=true local q=b
   while q do if q:IsA("GuiObject") and not q.Visible then visible=false end q=q.Parent end
   if visible then
    n=n+1
    add("BUTTON "..n.." "..b:GetFullName())
    local cs=getconnections and getconnections(b.Activated)
    if cs then for _,c in ipairs(cs) do
     if type(c.Function)=="function" then
      local u=ups(c.Function)
      if u and type(u[3])=="function" then
       local nu=ups(u[3])
       if nu then
        for ni=1,8 do
         if type(nu[ni])=="function" then
          local fu=ups(nu[ni])
          if fu then
           for fi=1,10 do
            if type(fu[fi])=="function" then
             local f2u=ups(fu[fi])
             if f2u then
              for ui=1,8 do
               local t=f2u[ui]
               if type(t)=="table" then
                for key,fn in pairs(t) do
                 if type(fn)=="function" and (key=="Respond" or key=="VerifyReject") then
                  inspect(fn,"CARD"..n.."_NEST"..ni.."_UV"..fi.."_"..key,2)
                 end
                end
               end
              end
             end
            end
           end
          end
         end
        end
       end
      end
     end
    end end
   end
  end
 end
 add("VISIBLE_BUTTONS="..n)
end,function(e) return tostring(e) end)
if ok then finish("STATUS=SELESAI") else add("RUNTIME_FAILURE="..tostring(err)); finish("STATUS=GAGAL") end
