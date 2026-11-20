-- RAEL AUTO ACC GUI
-- File terpisah: autoacc_gui.lua | Tidak menyentuh main.lua.
local env=(getgenv and getgenv()) or _G
local state=env.RAEL_AUTOACC or {}
env.RAEL_AUTOACC=state
if state.Enabled==nil then state.Enabled=false end

local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local old=pg:FindFirstChild("RaelAutoAccGUI")
if old then old:Destroy() end

local gui=Instance.new("ScreenGui")
gui.Name="RaelAutoAccGUI"
gui.ResetOnSpawn=false
gui.DisplayOrder=10000
gui.Parent=pg

local frame=Instance.new("Frame")
frame.Size=UDim2.fromOffset(245,166)
frame.Position=UDim2.new(0,18,0.42,0)
frame.BackgroundColor3=Color3.fromRGB(24,27,34)
frame.BorderSizePixel=0
frame.Active=true
frame.Draggable=true
frame.Parent=gui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10)

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-16,0,30)
title.Position=UDim2.fromOffset(8,5)
title.BackgroundTransparency=1
title.Text="RAEL AUTO ACC"
title.TextColor3=Color3.fromRGB(255,255,255)
title.Font=Enum.Font.GothamBold
title.TextSize=16
title.Parent=frame

local function makeButton(text,x,color)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0.5,-12,0,34)
 b.Position=UDim2.new(x, x==0 and 8 or 4, 0, 43)
 b.BackgroundColor3=color
 b.BorderSizePixel=0
 b.Text=text
 b.TextColor3=Color3.new(1,1,1)
 b.Font=Enum.Font.GothamBold
 b.TextSize=14
 b.Parent=frame
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
 return b
end

local on=makeButton("ON",0,Color3.fromRGB(35,145,85))
local off=makeButton("OFF",0.5,Color3.fromRGB(170,60,60))
local status=Instance.new("TextLabel")
status.Size=UDim2.new(1,-16,0,48)
status.Position=UDim2.fromOffset(8,84)
status.BackgroundTransparency=1
status.TextColor3=Color3.fromRGB(225,230,240)
status.Font=Enum.Font.Gotham
status.TextSize=11
status.TextWrapped=true
status.TextYAlignment=Enum.TextYAlignment.Top
status.Text="Mesin: menunggu\nAtas: 708,154 | Bawah: 708,281"
status.Parent=frame

local close=Instance.new("TextButton")
close.Size=UDim2.fromOffset(22,22)
close.Position=UDim2.new(1,-27,0,7)
close.BackgroundColor3=Color3.fromRGB(75,78,88)
close.Text="×"
close.TextColor3=Color3.new(1,1,1)
close.Font=Enum.Font.GothamBold
close.TextSize=16
close.Parent=frame
Instance.new("UICorner",close).CornerRadius=UDim.new(1,0)

on.MouseButton1Click:Connect(function()
 state.Enabled=true
 state.Status="ON - memantau slot popup"
end)
off.MouseButton1Click:Connect(function()
 state.Enabled=false
 state.Status="OFF - klik otomatis dihentikan"
end)
close.MouseButton1Click:Connect(function()
 state.Enabled=false
 gui:Destroy()
end)

task.spawn(function()
 while gui.Parent do
  status.Text="Status: "..tostring(state.Status or "Mesin belum dijalankan")
   .."\nAtas: 708,154 | Bawah: 708,281"
  task.wait(0.25)
 end
end)