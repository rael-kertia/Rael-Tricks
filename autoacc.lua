-- RAEL AUTO ACC | Berdasarkan diagnosis PermintaanSewaUI
-- Hanya mengaktifkan AccBtn pada kartu dengan judul PERMINTAAN SEWA.
local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local pg=plr:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("PermintaanSewaUI",15)
if not gui then
 local m="AUTO ACC: PermintaanSewaUI tidak ditemukan"
 if setclipboard then pcall(setclipboard,m) end
 if writefile then pcall(writefile,"Rael_AutoACC_Status.txt",m) end
 return
end
local done=setmetatable({}, {__mode="k"})
local function norm(s)
 return tostring(s or ""):upper():gsub("%s+","")
end
local function isVisible(o)
 local p=o
 while p and p~=gui.Parent do
  if p:IsA("GuiObject") and not p.Visible then return false end
  if p:IsA("ScreenGui") and not p.Enabled then return false end
  p=p.Parent
 end
 return true
end
local function status(s)
 local msg="RAEL AUTO ACC | "..s.." | "..os.date("%H:%M:%S")
 if writefile then pcall(writefile,"Rael_AutoACC_Status.txt",msg) end
end
local stack=gui:WaitForChild("Tumpukan",10)
if not stack then
 status("GAGAL: Tumpukan tidak ditemukan")
 return
end
status("AKTIF - menunggu permintaan sewa")
while task.wait(0.2) do
 if not gui.Parent or not gui.Enabled then continue end
 for _,card in ipairs(stack:GetChildren()) do
  if card:IsA("Frame") and card.Name:match("^Kartu_") and card.Name~="KartuTemplate" then
   local isi=card:FindFirstChild("Isi")
   local tag=isi and isi:FindFirstChild("Tag")
   local label=tag and tag:FindFirstChild("Label")
   local acc=isi and isi:FindFirstChild("AccBtn")
   if label and label:IsA("TextLabel") and norm(label.Text)=="PERMINTAANSEWA"
      and acc and acc:IsA("TextButton") and acc.Visible and acc.Active
      and isVisible(card) and not done[acc] then
    done[acc]=true
    local ok=pcall(function() acc:Activate() end)
    if ok then
     status("ACC diaktifkan pada "..card.Name)
    else
     done[acc]=nil
     status("GAGAL mengaktifkan "..card.Name)
    end
   end
  end
 end
end
