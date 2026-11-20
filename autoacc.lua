-- RAEL AUTO ACC ENGINE v3
-- Input sentuh memakai signature Vector2; main.lua tidak disentuh.
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

local function visible(o)
 while o and o~=ui do
  if o:IsA("GuiObject") and not o.Visible then return false end
  o=o.Parent
 end
 return ui.Parent~=nil and ui.Enabled
end

local function findSlot(slot)
 for _,card in ipairs(stack:GetChildren()) do
  if card.Name:match("^Kartu_%d+$") and visible(card) then
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

local function sendTouch(x,y)
 if not vim then return false,"VIM tidak tersedia" end
 local pos=Vector2.new(x,y)
 local ok,err=pcall(function()
  vim:SendTouchEvent(0,Enum.UserInputState.Begin,pos)
  task.wait(0.10)
  vim:SendTouchEvent(0,Enum.UserInputState.End,pos)
 end)
 return ok,err
end

local function sendMouse(x,y)
 if not vim then return false,"VIM tidak tersedia" end
 return pcall(function()
  vim:SendMouseMoveEvent(x,y,game)
  task.wait(0.05)
  vim:SendMouseButtonEvent(x,y,0,true,game,1)
  task.wait(0.08)
  vim:SendMouseButtonEvent(x,y,0,false,game,1)
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
    state.Status="Input sentuh "..slot.name.." ("..n.."/2)"
    local ok,err=sendTouch(x,y)
    task.wait(0.55)
    if b.Parent and b.Visible and card.Parent then
     state.Status="Sentuh tidak mengubah popup; mencoba mouse "..slot.name
     local mok,merr=sendMouse(x,y)
     task.wait(0.7)
    end
    if not (b.Parent and b.Visible and card.Parent) then
     state.Status="ACC terkonfirmasi: "..slot.name
    elseif n>=2 then
     state.Status="GAGAL INPUT "..slot.name.." | touch="..tostring(err)
    else
     state.Status="Popup masih ada: "..slot.name..", menunggu percobaan ulang"
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
