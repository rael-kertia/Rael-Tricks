-- RAEL DIAGNOSTIC: POPUP PENYEWA (FOKUS)
-- Indo Kos: Build & Upgrade | PASIF: TIDAK MENEKAN / MENGIRIM APA PUN
local P=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local CG=game:GetService("CoreGui")
local plr=P.LocalPlayer
-- Kata khusus penyewa. Accept/Reject sengaja tidak dipakai sebagai pemicu.
local KEY={"penyewa","sewa","tenant","rent","penghuni","kontrak","kos"}
local function match(s)
 s=tostring(s or ""):lower()
 for _,k in ipairs(KEY) do if s:find(k,1,true) then return true end end
 return false
end
local function safe(fn) local ok,v=pcall(fn) return ok and tostring(v) or "?" end
local function path(o) return safe(function() return o:GetFullName() end) end
local function short(s,n) s=tostring(s or "") return #s>n and s:sub(1,n).."..." or s end
local out,used,limit,cut={},0,2850,false
local function add(s)
 s=tostring(s or "")
 if used>=limit then cut=true return end
 local room=limit-used
 if #s>room then s=s:sub(1,math.max(0,room-14)).." [DIPOTONG]" cut=true end
 out[#out+1]=s used=used+#s+1
end
add("=== RAEL TENANT DIAGNOSTIC FOKUS ===")
add("PLAYER: "..plr.Name.." | "..os.date("%Y-%m-%d %H:%M:%S"))
local roots={plr:FindFirstChildOfClass("PlayerGui"),CG}
local guiCount,remoteCount,scriptCount=0,0,0
for _,root in ipairs(roots) do
 if root then
  for _,gui in ipairs(root:GetDescendants()) do
   if gui:IsA("ScreenGui") then
    local texts,buttons,relevant={}, {},match(gui.Name)
    for _,v in ipairs(gui:GetDescendants()) do
     if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
      if v.Text and v.Text~="" then
       if match(v.Text) then relevant=true texts[#texts+1]=v end
      end
     end
     if v:IsA("TextButton") or v:IsA("ImageButton") then buttons[#buttons+1]=v end
    end
    if relevant then
     guiCount=guiCount+1
     add("")
     add("CANDIDATE GUI: "..gui.Name.." | Enabled="..tostring(gui.Enabled).." | Order="..tostring(gui.DisplayOrder))
     add("PATH: "..short(path(gui),170))
     add("MATCH TEXT:")
     if #texts==0 then add("- (nama GUI cocok)") end
     for _,v in ipairs(texts) do
      add("- "..v.ClassName.." ["..short(v.Name,35).."] = "..short(v.Text,100))
     end
     add("BUTTONS DALAM GUI:")
     for i,b in ipairs(buttons) do
      if i<=12 then
       add("- "..b.ClassName.." ["..short(b.Name,35).."] Text="..short(safe(function() return b.Text end),45).." Visible="..safe(function() return b.Visible end))
      end
     end
     if #buttons>12 then add("... +"..(#buttons-12).." tombol") end
    end
   end
  end
 end
end
add("")
add("REMOTE KHUSUS:")
for _,obj in ipairs(RS:GetDescendants()) do
 if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent")) and match(obj.Name) then
  remoteCount=remoteCount+1
  if remoteCount<=12 then add("- "..obj.ClassName.." "..short(path(obj),180)) end
 end
end
if remoteCount==0 then add("- Tidak ada nama Remote yang cocok") end
if remoteCount>12 then add("... +"..(remoteCount-12).." remote lainnya") end
add("GUI SCRIPT KHUSUS:")
for _,root in ipairs(roots) do
 if root then
  for _,obj in ipairs(root:GetDescendants()) do
   if obj:IsA("LocalScript") and match(path(obj)) then
    scriptCount=scriptCount+1
    if scriptCount<=6 then add("- "..short(path(obj),180)) end
   end
  end
 end
end
if guiCount==0 then add("TIDAK ADA GUI DENGAN KATA KHUSUS PENYEWA") end
add("SUMMARY: GUI="..guiCount.." REMOTE="..remoteCount.." SCRIPT="..scriptCount)
if cut then out[#out+1]="[OUTPUT DIPOTONG: batas 2850 karakter]" end
local result=table.concat(out,"\n")
if setclipboard then pcall(setclipboard,result)
elseif toclipboard then pcall(toclipboard,result) end
if writefile then pcall(writefile,"Rael_Tenant_Diagnostic.txt",result) end
print("DIAGNOSTIC FOKUS SELESAI | "..#result.." karakter")