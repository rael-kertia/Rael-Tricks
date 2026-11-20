-- RAEL DIAGNOSTIC: PERMINTAAN SEWA
-- PASIF: hanya membaca GUI. TIDAK klik tombol / tidak fire remote.
local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local roots={plr:WaitForChild("PlayerGui")}
pcall(function() table.insert(roots,game:GetService("CoreGui")) end)

local function safe(fn)
 local ok,v=pcall(fn)
 return ok and tostring(v) or "?"
end
local function path(o)
 return safe(function() return o:GetFullName() end)
end
local function norm(s)
 return tostring(s or ""):lower():gsub("%s+",""):gsub("[^%w]","")
end
local function visible(o)
 local p=o
 while p do
  if p:IsA("GuiObject") and not p.Visible then return false end
  if p:IsA("ScreenGui") and not p.Enabled then return false end
  p=p.Parent
 end
 return true
end
local out,used={},0
local LIMIT=4800
local function add(s)
 s=tostring(s or "")
 if used>=LIMIT then return end
 local room=LIMIT-used
 if #s>room then s=s:sub(1,room) end
 out[#out+1]=s
 used=used+#s+1
end
add("=== RAEL DIAGNOSTIC PERMINTAAN SEWA V2 ===")
add("PLAYER: "..plr.Name.." | "..os.date("%Y-%m-%d %H:%M:%S"))
local found,seen={},{}
for _,root in ipairs(roots) do
 for _,obj in ipairs(root:GetDescendants()) do
  if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
   local t=norm(obj.Text)
   if t:find("permintaansewa",1,true) then
    found[#found+1]=obj
   end
  end
 end
end
add("JUMLAH TEKS JUDUL DITEMUKAN: "..#found)
for n,title in ipairs(found) do
 add("")
 add("=== POPUP TARGET #"..n.." ===")
 add("JUDUL: "..title.ClassName.." | Name="..title.Name.." | Text="..tostring(title.Text))
 add("VISIBLE: "..tostring(visible(title)))
 add("FULL PATH: "..path(title))
 local parent=title
 for level=1,7 do
  parent=parent.Parent
  if not parent then break end
  add("ANCESTOR "..level..": "..parent.ClassName.." "..parent.Name.." | "..path(parent))
  local buttons={}
  for _,v in ipairs(parent:GetDescendants()) do
   if (v:IsA("TextButton") or v:IsA("ImageButton")) and not seen[v] then
    local tx=v:IsA("TextButton") and tostring(v.Text) or "(ImageButton)"
    local nt=norm(tx)
    if nt=="acc" or nt=="tolak" or level<=2 then
     buttons[#buttons+1]=v
    end
   end
  end
  for _,b in ipairs(buttons) do
   seen[b]=true
   add("  BUTTON: "..b.ClassName.." | Name="..b.Name.." | Text="..safe(function() return b.Text end))
   add("  PATH: "..path(b))
   add("  Visible="..safe(function() return b.Visible end).." | Active="..safe(function() return b.Active end).." | AutoButtonColor="..safe(function() return b.AutoButtonColor end))
  end
  if parent:IsA("ScreenGui") then break end
 end
end
if #found==0 then
 add("JUDUL TIDAK TERLIHAT DI PlayerGui/CoreGui SAAT SCRIPT DIJALANKAN.")
 add("Jalankan diagnosis ketika popup PERMINTAAN SEWA sedang terbuka.")
end
add("")
add("=== REMOTE DENGAN NAMA TERKAIT ===")
local RS=game:GetService("ReplicatedStorage")
local rc=0
for _,v in ipairs(RS:GetDescendants()) do
 if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
  local n=norm(v.Name)
  if n:find("sewa",1,true) or n:find("penyewa",1,true) or n:find("rent",1,true) or n:find("acc",1,true) then
   rc=rc+1
   if rc<=15 then add(v.ClassName.." | "..path(v)) end
  end
 end
end
if rc==0 then add("Tidak ada Remote bernama terkait yang terlihat di ReplicatedStorage.") end
add("TOTAL REMOTE TERKAIT: "..rc)
local result=table.concat(out,"\n")
local copied=false
if setclipboard then copied=pcall(setclipboard,result)
elseif toclipboard then copied=pcall(toclipboard,result) end
local saved=false
if writefile then saved=pcall(writefile,"Rael_Tenant_Diagnostic.txt",result) end
local status="DIAG V2 | chars="..#result.." | clipboard="..tostring(copied).." | file="..tostring(saved)
if setclipboard then pcall(setclipboard,result.."\n\n"..status)
elseif toclipboard then pcall(toclipboard,result.."\n\n"..status) end
if writefile then pcall(writefile,"Rael_Tenant_Diagnostic.txt",result.."\n\n"..status) end
