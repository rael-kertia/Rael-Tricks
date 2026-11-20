-- RAEL AUTO ACC ENGINE v8
-- Prioritas kartu paling atas, lalu scan ulang kartu tersisa setelah reflow.
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
local busy=false
local lastTried={}

local function isVisible(o)
 while o and o~=ui do
  if o:IsA("GuiObject") and not o.Visible then return false end
  o=o.Parent
 end
 return ui.Parent~=nil and ui.Enabled
end

local function scan()
 local found={}
 for _,card in ipairs(stack:GetChildren()) do
  if card.Name:match("^Kartu_%d+$") and isVisible(card) then
   local isi=card:FindFirstChild("Isi")
   local b=isi and isi:FindFirstChild("AccBtn")
   if b and b:IsA("GuiButton") and b.Visible and b.Active then
    local p,s=b.AbsolutePosition,b.AbsoluteSize
    found[#found+1]={card=card,button=b,x=p.X+s.X/2,y=p.Y+s.Y/2}
   end
  end
 end
 table.sort(found,function(a,b) return a.y<b.y end)
 return found
end

local function click(item)
 local b,x,y=item.button,item.x,item.y
 local pos=Vector2.new(x,y)
 local okTouch,errTouch=pcall(function()
  vim:SendTouchEvent(0,Enum.UserInputState.Begin,pos)
  task.wait(0.10)
  vim:SendTouchEvent(0,Enum.UserInputState.End,pos)
 end)
 task.wait(0.45)
 if b.Parent and b.Visible then
  local mx,my=x+44,y+58
  local okMouse,errMouse=pcall(function()
   vim:SendMouseMoveEvent(mx,my,game)
   task.wait(0.05)
   vim:SendMouseButtonEvent(mx,my,0,true,game,1)
   task.wait(0.08)
   vim:SendMouseButtonEvent(mx,my,0,false,game,1)
  end)
  task.wait(0.65)
 end
 return not (b.Parent and b.Visible),errTouch
end

state.Status="Mesin siap - OFF"
while state.EngineToken==token do
 if state.Enabled and ui.Parent and ui.Enabled and not busy then
  local cards=scan()
  if #cards>0 then
   local item=cards[1]
   local key=item.card
   local now=os.clock()
   if not lastTried[key] or now-lastTried[key]>2.5 then
    busy=true
    lastTried[key]=now
    state.Status=string.format("ACC kartu teratas: %s | Y %.1f | total %d",key.Name,item.y,#cards)
    local gone,err=click(item)
    if gone then
     state.Status="Kartu teratas hilang; scan ulang posisi kartu tersisa"
     task.wait(0.35)
    else
     state.Status="Popup belum hilang; input belum terkonfirmasi"
    end
    busy=false
   end
  else
   state.Status="Menunggu popup permintaan"
  end
 end
 task.wait(0.15)
end
state.Status="Mesin dihentikan"
