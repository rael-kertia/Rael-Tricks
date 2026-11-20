-- RAEL AUTO ACC ENGINE v2
-- Terpisah dari main.lua. Jalankan bersama autoacc_gui.lua.
local env=(getgenv and getgenv()) or _G
local state=env.RAEL_AUTOACC or {}
env.RAEL_AUTOACC=state
state.Enabled=state.Enabled==true
state.EngineToken=(state.EngineToken or 0)+1
local token=state.EngineToken

local plr=game:GetService("Players").LocalPlayer
local pg=plr:WaitForChild("PlayerGui")
local ui=pg:WaitForChild("PermintaanSewaUI",20)
if not ui then state.Status="UI permintaan tidak ditemukan"; return end
local stack=ui:WaitForChild("Tumpukan",10)
if not stack then state.Status="Tumpukan tidak ditemukan"; return end

local vim=game:GetService("VirtualInputManager")
local slots={{name="ATAS",x=708,y=154},{name="BAWAH",x=708,y=281}}
local attempts=setmetatable({}, {__mode="k"})
local busy=setmetatable({}, {__mode="k"})

local function isVisible(o)
 while o and o~=ui do
  if o:IsA("GuiObject") and not o.Visible then return false end
  o=o.Parent
 end
 return ui.Parent~=nil and ui.Enabled
end

local function findSlot(slot)
 for _,card in ipairs(stack:GetChildren()) do
  if card.Name:match("^Kartu_%d+$") and isVisible(card) then
   local isi=card:FindFirstChild("Isi")
   local b=isi and isi:FindFirstChild("AccBtn")
   if b and b:IsA("GuiButton") and b.Visible and b.Active then
    local p,s=b.AbsolutePosition,b.AbsoluteSize
    local x,y=p.X+s.X/2,p.Y+s.Y/2
    if math.abs(x-slot.x)<=12 and math.abs(y-slot.y)<=12 then
     return b,card,x,y
    end
   end
  end
 end
end

local function touch(x,y)
 if not vim then return false,"VirtualInputManager tidak ada" end
 local ok,err=pcall(function()
  vim:SendTouchEvent(0,Enum.UserInputState.Begin,x,y)
  task.wait(0.08)
  vim:SendTouchEvent(0,Enum.UserInputState.End,x,y)
 end)
 if ok then return true,"touch" end
 local ok2,err2=pcall(function()
  vim:SendTouchEvent(0,0,x,y)
  task.wait(0.08)
  vim:SendTouchEvent(0,1,x,y)
 end)
 if ok2 then return true,"touch-numeric" end
 return false,tostring(err).." | "..tostring(err2)
end

local function mouse(x,y)
 if not vim then return false,"VirtualInputManager tidak ada" end
 return pcall(function()
  vim:SendMouseButtonEvent(x,y,0,true,game,0)
  task.wait(0.08)
  vim:SendMouseButtonEvent(x,y,0,false,game,0)
 end)
end

state.Status="Mesin siap - OFF"
while state.EngineToken==token do
 if state.Enabled and ui.Parent and ui.Enabled then
  for _,slot in ipairs(slots) do
   local b,card,x,y=findSlot(slot)
   if b and not busy[b] and (attempts[b] or 0)<2 then
    busy[b]=true
    attempts[b]=(attempts[b] or 0)+1
    local n=attempts[b]
    state.Status="Mencoba "..slot.name.." ("..n.."/2)"
    local ok,method=touch(x,y)
    task.wait(0.45)
    if b.Parent and b.Visible and card.Parent then
     -- Fallback mouse hanya jika sentuhan belum mengubah popup.
     local mok,merr=mouse(x,y)
     task.wait(0.65)
     if not (b.Parent and b.Visible and card.Parent) then
      state.Status="ACC terkirim: slot "..slot.name
     elseif n>=2 then
      state.Status="GAGAL: input tidak mengubah popup "..slot.name
     else
      state.Status="Belum terkonfirmasi: "..slot.name..", coba sekali lagi"
     end
    else
     state.Status="ACC terkirim: slot "..slot.name
    end
    busy[b]=nil
   end
  end
 elseif not state.Enabled then
  state.Status="OFF - menunggu diaktifkan"
 end
 task.wait(0.12)
end
state.Status="Mesin dihentikan"
