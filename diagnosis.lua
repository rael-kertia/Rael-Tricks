-- RAEL DIAGNOSTIC SEWA V8 - SEARCH LANGSUNG
-- PASIF: tidak klik ACC/Tolak dan tidak memanggil remote.
local out={}
local function add(v) out[#out+1]=tostring(v) end
local function path(x)
 local ok,s=pcall(function() return x:GetFullName() end)
 return ok and s or "?"
end
local function finish(status)
 local s="=== RAEL SEWA V8 ===\n"..status.."\n"..table.concat(out,"\n")
 local copied=false
 if setclipboard then copied=pcall(setclipboard,s) elseif toclipboard then copied=pcall(toclipboard,s) end
 local saved=false
 if writefile then saved=pcall(writefile,"Rael_Sewa_V8.txt",s) end
 local tail="\n\nV8 END | chars="..#s.." | clipboard="..tostring(copied).." | file="..tostring(saved)
 if setclipboard then pcall(setclipboard,s..tail) elseif toclipboard then pcall(toclipboard,s..tail) end
 if writefile then pcall(writefile,"Rael_Sewa_V8.txt",s..tail) end
end
local ok,err=xpcall(function()
 local P=game:GetService("Players").LocalPlayer
 local gui=P:WaitForChild("PlayerGui")
 add("PLAYER="..P.Name)
 add("PLAYERGUI="..path(gui))
 local all=gui:GetDescendants()
 local titles={}
 local buttons={}
 for _,x in ipairs(all) do
  if x:IsA("TextLabel") and x.Text=="PERMINTAAN SEWA" then titles[#titles+1]=x end
  if x:IsA("TextButton") and x.Name=="AccBtn" then buttons[#buttons+1]=x end
 end
 add("TITLE COUNT="..#titles)
 for i,t in ipairs(titles) do
  add("TITLE #"..i.." "..path(t).." visible="..tostring(t.Visible))
  local p=t
  for level=1,5 do
   p=p and p.Parent
   if not p then break end
   local found={}
   for _,d in ipairs(p:GetDescendants()) do
    if d:IsA("TextButton") and d.Name=="AccBtn" then found[#found+1]=d end
   end
   if #found>0 then
    add("  ANCESTOR "..level.." "..p.Name.." class="..p.ClassName.." ACC_FOUND="..#found)
    for _,b in ipairs(found) do
     local vis=true local q=b
     while q do if q:IsA("GuiObject") and not q.Visible then vis=false end q=q.Parent end
     add("   BTN "..path(b).." Visible="..tostring(b.Visible).." Active="..tostring(b.Active).." TREE_VISIBLE="..tostring(vis))
    end
   end
  end
 end
 add("ALL ACCBTN COUNT="..#buttons)
 for i,b in ipairs(buttons) do
  local vis=true local q=b
  while q do if q:IsA("GuiObject") and not q.Visible then vis=false end q=q.Parent end
  add("")
  add("ACC BUTTON #"..i.." "..path(b))
  add(" Visible="..tostring(b.Visible).." Active="..tostring(b.Active).." TREE_VISIBLE="..tostring(vis))
  local p=b.Parent
  for level=1,4 do
   if not p then break end
   local labs={}
   for _,d in ipairs(p:GetDescendants()) do
    if d:IsA("TextLabel") and d.Text=="PERMINTAAN SEWA" then labs[#labs+1]=d end
   end
   if #labs>0 then add(" TARGET TITLE IN ANCESTOR "..level.." "..p.Name.." count="..#labs) end
   p=p.Parent
  end
  if type(getconnections)=="function" then
   local a,cs=pcall(getconnections,b.Activated)
   if a and type(cs)=="table" then
    add(" ACTIVATED CONNECTIONS="..#cs)
    for ci,c in ipairs(cs) do
     add("  CONN "..ci.." enabled="..tostring(c.Enabled).." source="..tostring(c.Source).." line="..tostring(c.Line))
     local gu=(debug and debug.getupvalues) or getupvalues
     if type(gu)=="function" and type(c.Function)=="function" then
      local ua,u=pcall(gu,c.Function)
      if ua and type(u)=="table" then
       for ui=1,6 do
        local v=u[ui]
        if v~=nil then
         add("   UPVALUE "..ui.." TYPE="..type(v).." VALUE="..tostring(v):sub(1,100))
         if ui==3 and type(v)=="function" then
          local na,nu=pcall(gu,v)
          if na and type(nu)=="table" then
           for ni=1,5 do
            if type(nu[ni])=="function" then
             add("   NESTED FUNCTION "..ni.." FOUND")
             local gc=(debug and debug.getconstants) or getconstants
             if type(gc)=="function" then
              local ca,cc=pcall(gc,nu[ni])
              if ca and type(cc)=="table" then
               for k,z in ipairs(cc) do
                if k<=50 and (type(z)=="string" or type(z)=="number" or type(z)=="boolean") then add("    NESTED"..ni.." CONST "..k.."="..tostring(z):sub(1,100)) end
               end
              else add("    CONSTANT READ FAILED") end
             end
            end
           end
          else add("   NESTED UPVALUE READ FAILED="..tostring(nu)) end
         end
        end
       end
      else add("   HANDLER UPVALUE READ FAILED="..tostring(u)) end
     end
    end
   else add(" ACTIVATED CONNECTION READ FAILED="..tostring(cs)) end
  else add(" GETCONNECTIONS NOT AVAILABLE") end
 end
end,function(e) return tostring(e) end)
if ok then finish("STATUS=SELESAI") else add("RUNTIME FAILURE="..tostring(err)); finish("STATUS=GAGAL / FAILSAFE") end
