-- RAEL DIAGNOSTIC SEWA V11 - TRACE RESPOND WRAPPER
-- PASIF: tidak klik tombol dan tidak memanggil remote.
local out={}
local seen={}
local function add(v) out[#out+1]=tostring(v) end
local function getups(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil,"NO_UPVALUE_API" end
 local ok,v=pcall(g,f)
 if ok and type(v)=="table" then return v end
 return nil,tostring(v)
end
local function getconst(f,tag)
 local g=(debug and debug.getconstants) or getconstants
 if type(g)~="function" then add(tag.." CONST_API=NONE"); return end
 local ok,v=pcall(g,f)
 if not ok or type(v)~="table" then add(tag.." CONST_FAIL="..tostring(v)); return end
 for i,x in ipairs(v) do
  if i>65 then break end
  if type(x)=="string" or type(x)=="number" or type(x)=="boolean" then add(tag.." C"..i.."="..tostring(x):sub(1,120)) end
 end
end
local function trace(f,tag,depth)
 if type(f)~="function" then return end
 if seen[f] then add(tag.." ALREADY_SEEN "..tostring(f)); return end
 seen[f]=true
 add("")
 add("### "..tag.." "..tostring(f))
 local gi=(debug and debug.getinfo) or getinfo
 if type(gi)=="function" then
  local ok,inf=pcall(gi,f)
  if ok and type(inf)=="table" then
   add(tag.." INFO name="..tostring(inf.name).." source="..tostring(inf.source).." what="..tostring(inf.what).." line="..tostring(inf.linedefined))
  end
 end
 getconst(f,tag)
 local u,e=getups(f)
 if not u then add(tag.." UPVALUES_FAIL="..e); return end
 for i=1,14 do
  local v=u[i]
  if v~=nil then
   add(tag.." UV"..i.." TYPE="..type(v).." VALUE="..tostring(v):sub(1,180))
   if type(v)=="function" and depth>0 then trace(v,tag..".UV"..i,depth-1) end
   if type(v)=="table" then
    local n=0
    for k,z in pairs(v) do
     n=n+1
     if n>30 then add(tag.." TABLE_TRUNCATED"); break end
     add(tag.." T["..tostring(k):sub(1,80).."] TYPE="..type(z).." VALUE="..tostring(z):sub(1,140))
     if type(z)=="function" and depth>0 then trace(z,tag..".T_"..tostring(k),depth-1) end
     if type(z)=="table" then
      local m=0
      for k2,z2 in pairs(z) do
       m=m+1
       if m>12 then break end
       add(tag.." T["..tostring(k).."]["..tostring(k2).."] TYPE="..type(z2).." VALUE="..tostring(z2):sub(1,120))
       if type(z2)=="function" and depth>0 then trace(z2,tag..".T_"..tostring(k).."_"..tostring(k2),depth-1) end
      end
     end
    end
   end
  end
 end
end
local function finish(status)
 local s="=== RAEL SEWA V11 ===\n"..status.."\n"..table.concat(out,"\n")
 local copied=false
 if setclipboard then copied=pcall(setclipboard,s) elseif toclipboard then copied=pcall(toclipboard,s) end
 local saved=false
 if writefile then saved=pcall(writefile,"Rael_Sewa_V11.txt",s) end
 local tail="\n\nV11 END | chars="..#s.." | clipboard="..tostring(copied).." | file="..tostring(saved)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V11.txt",s..tail) end
end
local ok,err=xpcall(function()
 local p=game:GetService("Players").LocalPlayer
 local root=p:WaitForChild("PlayerGui"):FindFirstChild("PermintaanSewaUI")
 if not root then add("UI_NOT_FOUND"); return end
 local n=0
 for _,b in ipairs(root:GetDescendants()) do
  if b:IsA("TextButton") and b.Name=="AccBtn" then
   local vis=true local q=b
   while q do if q:IsA("GuiObject") and not q.Visible then vis=false end q=q.Parent end
   if vis then
    n=n+1
    add("BUTTON "..n.." "..b:GetFullName())
    local cs=getconnections and getconnections(b.Activated)
    if cs then
     for ci,c in ipairs(cs) do
      if type(c.Function)=="function" then
       local u=getups(c.Function)
       if u and type(u[3])=="function" then
        local nu=getups(u[3])
        if nu then
         for ni=1,8 do
          if type(nu[ni])=="function" then
           local fu=getups(nu[ni])
           if fu then
            for fi=1,10 do
             if type(fu[fi])=="function" then
              local f2=getups(fu[fi])
              if f2 then
               for ui=1,8 do
                local t=f2[ui]
                if type(t)=="table" then
                 for key,fn in pairs(t) do
                  if type(fn)=="function" and (key=="Respond" or key=="VerifyReject") then
                   trace(fn,"CARD"..n.."_"..key,4)
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
     end
    end
   end
  end
 end
 add("VISIBLE_BUTTONS="..n)
end,function(e) return tostring(e) end)
if ok then finish("STATUS=SELESAI") else add("RUNTIME_FAILURE="..tostring(err)); finish("STATUS=GAGAL") end
