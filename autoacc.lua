-- RAEL AUTO ACC ENGINE v7
-- Deteksi semua kartu aktif berdasarkan posisi aktual; kartu bawah diikuti saat reflow.
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
local attempts=setmetatable({}, {__mode="k"})
local busy=setmetatable({}, {__mode="k"})

local function visible(o)
 while o and o~=ui do
  if o:IsA("GuiObject") and not o.Visible then return false end
  o=o.Parent
 end
 return ui.Parent~=nil and ui.Enabled
end

local function getActiveButtons()
 local found={}
 for _,card in ipairs(stack:GetChildren()) do
  if card.Name:match("^Kartu_%d+$") and visible(card) then
   local isi=card:FindFirstChild("Isi")
   local b=isi and isi:FindFirstChild("AccBtn")
   if b and b:IsA("GuiButton") and b.Visible and b.Active then
    local p,s=b.AbsolutePosition,b.AbsoluteSize
    found[#found+1]={button=b,card=card,x=p.X+s.X/2,y=p.Y+s.Y/2}
   end
  end
 end
 table.sort(found,function(a,b) return a.y<b.y end)
 return found
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
 local sx,sy=x+44,y+58
 return pcall(function()
  vim:SendMouseMoveEvent(sx,sy,game)
  task.wait(0.05)
  vim:SendMouseButtonEvent(sx,sy,0,true,game,1)
  task.wait(0.08)
  vim:SendMouseButtonEvent(sx,sy,0,false,game,1)
 end)
end

state.Status="Mesin siap - OFF"
while state.EngineToken==token do
 if state.Enabled and ui.Parent and ui.Enabled then
  local buttons=getActiveButtons()
  for _,item in ipairs(buttons) do
   local b,card,x,y=item.button,item.card,item.x,item.y
   if b.Parent and b.Visible and not busy[b] and (attempts[b] or 0)<2 then
    busy[b]=true
    attempts[b]=(attempts[b] or 0)+1
    local n=attempts[b]
    state.Status=string.format("Memproses ACC #%d pada Y %.0f (%d/2)",_,y,n)
    local ok,err=sendTouch(x,y)
    task.wait(0.55)
    if b.Parent and b.Visible and card.Parent then
     state.Status="Touch belum menghilangkan popup; mencoba mouse"
     local mok,merr=sendMouse(x,y)
     task.wait(0.7)
    end
    if not (b.Parent and b.Visible and card.Parent) then
     state.Status="ACC terkonfirmasi; memindai ulang posisi kartu"
    elseif n>=2 then
     state.Status="GAGAL INPUT pada Y "..math.floor(y).." | touch="..tostring(err)
    else
     state.Status="Popup masih ada; menunggu percobaan ulang"
    end
    busy[b]=nil
    break
   end
  end
 elseif not state.Enabled then
  state.Status="OFF - menunggu diaktifkan"
 end
 task.wait(0.12)
end
state.Status="Mesin dihentikan"
