-- RAEL DIAGNOSTIC SEWA V9 - INSPEKSI HANDLER
-- PASIF: tidak klik ACC/Tolak dan tidak memanggil remote.
local out={}
local function add(v) out[#out+1]=tostring(v) end
local function path(x)
 local ok,s=pcall(function() return x:GetFullName() end)
 return ok and s or "?"
end
local function safeUp(f)
 local g=(debug and debug.getupvalues) or getupvalues
 if type(g)~="function" then return nil,"API_UPVALUES_TIDAK_ADA" end
 local ok,v=pcall(g,f)
 if ok and type(v)=="table" then return v end
 return nil,tostring(v)
end
local function constants(f,tag)
 local g=(debug and debug.getconstants) or getconstants
 if type(g)~="function" then add(tag.." CONSTANTS_API=NONE") return end
 local ok,v=pcall(g,f)
 if not ok or type(v)~="table" then add(tag.." CONSTANTS_READ_FAIL="..tostring(v)) return end
 for i,z in ipairs(v) do
  if i>45 then break end
  if type(z)=="string" or type(z)=="number" or type(z)=="boolean" then add(tag.." CONST "..i.."="..tostring(z):sub(1,100)) end
 end
end
local function tableDump(t,tag)
 if type(t)~="table" then return end
 local n=0
 for k,v in pairs(t) do
  n=n+1
  if n>24 then add(tag.." TABLE_TRUNCATED"); break end
  add(tag.." KEY="..tostring(k):sub(1,70).." TYPE="..type(v).." VAL="..tostring(v):sub(1,100))
  if type(v)=="table" then
   local m=0
   for k2,v2 in pairs(v) do
    m=m+1
    if m>8 then add(tag.."  SUB_TRUNCATED"); break end
    add(tag.."  SUB "..tostring(k2):sub(1,50).." ["..type(v2).."]="..tostring(v2):sub(1,90))
   end
  end
 end
 add(tag.." TABLE_ITEMS_SCANNED="..math.min(n,24))
end
local function finish(status)
 local s="=== RAEL SEWA V9 ===\n"..status.."\n"..table.concat(out,"\n")
 local copied=false
 if setclipboard then copied=pcall(setclipboard,s) elseif toclipboard then copied=pcall(toclipboard,s) end
 local saved=false
 if writefile then saved=pcall(writefile,"Rael_Sewa_V9.txt",s) end
 local tail="\n\nV9 END | chars="..#s.." | clipboard="..tostring(copied).." | file="..tostring(saved)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V9.txt",s..tail) end
end
local ok,err=xpcall(function()
 local P=game:GetService("Players").LocalPlayer
 local gui=P:WaitForChild("PlayerGui")
 add("PLAYER="..P.Name)
 local root=gui:FindFirstChild("PermintaanSewaUI")
 if not root then add("UI_NOT_FOUND") return end
 local cards={}
 for _,x in ipairs(root:GetDescendants()) do
  if x:IsA("TextButton") and x.Name=="AccBtn" then
   local visible=true local q=x
   while q do if q:IsA("GuiObject") and not q.Visible then visible=false end q=q.Parent end
   if visible then cards[#cards+1]=x end
  end
 end
 add("VISIBLE ACC BUTTONS="..#cards)
 for i,b in ipairs(cards) do
  add("")
  add("BUTTON #"..i.." "..path(b))
  local id
  local cns=getconnections and getconnections(b.Activated)
  add("CONNECTIONS="..tostring(cns and #cns or 0))
  if cns then
   for ci,c in ipairs(cns) do
    if type(c.Function)=="function" then
     add("HANDLER #"..ci.." "..tostring(c.Function))
     local u,e=safeUp(c.Function)
     if not u then add("HANDLER_UPVALUES_FAIL="..e) else
      for j=1,6 do
       local v=u[j]
       if v~=nil then
        add("HANDLER UPVALUE "..j.." TYPE="..type(v).." VALUE="..tostring(v):sub(1,100))
        if j==1 and type(v)=="table" then tableDump(v,"STATE") end
        if j==4 then id=v end
        if j==3 and type(v)=="function" then
         add("CALLBACK UPVALUE3="..tostring(v))
         local nu,ne=safeUp(v)
         if not nu then add("CALLBACK_UPVALUES_FAIL="..ne) else
          for ni=1,8 do
           local nf=nu[ni]
           if type(nf)=="function" then
            add("CALLBACK NESTED FN "..ni.." "..tostring(nf))
            constants(nf,"NESTED"..ni)
            local fu,fe=safeUp(nf)
            if not fu then add("NESTED"..ni.."_UPVALUES_FAIL="..fe) else
             for fi=1,10 do
              local fv=fu[fi]
              if fv~=nil then
               add("NESTED"..ni.." UPVALUE "..fi.." TYPE="..type(fv).." VALUE="..tostring(fv):sub(1,110))
               if type(fv)=="table" then tableDump(fv,"NESTED"..ni.." UV"..fi) end
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
  add("CARD_ID_UPVALUE4="..tostring(id))
 end
end,function(e) return tostring(e) end)
if ok then finish("STATUS=SELESAI") else add("RUNTIME_FAILURE="..tostring(err)); finish("STATUS=GAGAL") end
