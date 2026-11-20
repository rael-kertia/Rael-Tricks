-- RAEL AUTO ACC | Indo Kos: Build & Upgrade
-- Auto tekan ACC hanya jika popup "Permintaan Sewa" terdeteksi.
local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local pg=plr:WaitForChild("PlayerGui")
local roots={pg}
pcall(function() table.insert(roots,game:GetService("CoreGui")) end)

local clicked=setmetatable({}, {__mode="k"})
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
local function hasTitle(root)
 for _,v in ipairs(root:GetDescendants()) do
  if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) and norm(v.Text):find("permintaansewa",1,true) then
   if visible(v) then return v end
  end
 end
end
local function findAcc(container)
 for _,v in ipairs(container:GetDescendants()) do
  if v:IsA("TextButton") and norm(v.Text)=="acc" and visible(v) then return v end
 end
end
local function activate(b)
 local ok=pcall(function() b:Activate() end)
 if ok then return true end
 if typeof(firesignal)=="function" then
  local a=pcall(function() firesignal(b.Activated) end)
  if a then return true end
  local m=pcall(function() firesignal(b.MouseButton1Click) end)
  if m then return true end
 end
 return false
end

while task.wait(0.25) do
 local found=false
 for _,root in ipairs(roots) do
  for _,v in ipairs(root:GetDescendants()) do
   if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) and norm(v.Text):find("permintaansewa",1,true) and visible(v) then
    local container=v
    local button
    for depth=1,7 do
     container=container.Parent
     if not container then break end
     button=findAcc(container)
     if button then break end
     if container:IsA("ScreenGui") then break end
    end
    if button then
     found=true
     if not clicked[button] then
      if activate(button) then
       clicked[button]=true
       local msg="AUTO ACC: tombol ACC ditekan | "..os.date("%H:%M:%S")
       if writefile then pcall(writefile,"Rael_AutoACC_Status.txt",msg) end
      end
     end
    end
   end
  end
 end
 if not found then
  clicked=setmetatable({}, {__mode="k"})
 end
end
