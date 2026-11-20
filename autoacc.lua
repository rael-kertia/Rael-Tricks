-- RAEL AUTO ACC ENGINE
-- File terpisah: autoacc.lua | Tidak menyentuh main.lua.
-- Jalankan bersama autoacc_gui.lua.
local env=(getgenv and getgenv()) or _G
local state=env.RAEL_AUTOACC or {}
env.RAEL_AUTOACC=state
state.Enabled=state.Enabled==true
state.EngineToken=(state.EngineToken or 0)+1
local token=state.EngineToken

local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local pg=plr:WaitForChild("PlayerGui")
local ui=pg:WaitForChild("PermintaanSewaUI",20)
if not ui then state.Status="PermintaanSewaUI tidak ditemukan"; return end
local stack=ui:WaitForChild("Tumpukan",10)
if not stack then state.Status="Tumpukan tidak ditemukan"; return end

local slots={
 {name="ATAS",x=708,y=154},
 {name="BAWAH",x=708,y=281}
}
local vim=game:GetService("VirtualInputManager")
local seen=setmetatable({}, {__mode="k"})
local last=setmetatable({}, {__mode="k"})
local function visible(o)
 while o and o~=ui do
  if o:IsA("GuiObject") and not o.Visible then return false end
  o=o.Parent
 end
 return ui.Enabled
end
local function findAt(slot)
 for _,card in ipairs(stack:GetChildren()) do
  if card.Name:match("^Kartu_%d+$") then
   local isi=card:FindFirstChild("Isi")
   local b=isi and isi:FindFirstChild("AccBtn")
   if b and b:IsA("GuiButton") and b.Visible and b.Active and visible(card) then
    local p=b.AbsolutePosition
    local s=b.AbsoluteSize
    local x=p.X+s.X/2
    local y=p.Y+s.Y/2
    if math.abs(x-slot.x)<=12 and math.abs(y-slot.y)<=12 then
     return b,card
    end
   end
  end
 end
end
local function tap(x,y)
 return pcall(function()
  vim:SendMouseButtonEvent(x,y,0,true,game,0)
  task.wait(0.05)
  vim:SendMouseButtonEvent(x,y,0,false,game,0)
 end)
end

state.Status="Mesin siap - OFF"
while state.EngineToken==token do
 if state.Enabled and ui.Parent and ui.Enabled then
  for _,slot in ipairs(slots) do
   local b,card=findAt(slot)
   if b and not seen[b] then
    local now=os.clock()
    if not last[b] or now-last[b]>=0.8 then
     last[b]=now
     local ok,err=tap(slot.x,slot.y)
     if ok then
      seen[b]=true
      state.Status="Klik dikirim: slot "..slot.name.." ("..card.Name..")"
     else
      state.Status="Input gagal: "..tostring(err)
     end
    end
   end
  end
 elseif not state.Enabled then
  state.Status="OFF - menunggu diaktifkan"
 end
 task.wait(0.12)
end
state.Status="Mesin dihentikan"