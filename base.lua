
-- RAEL'S TRICKS + HOMEWORK
local U="https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main.lua"
local ok,s=pcall(function() return game:HttpGet(U) end)
if not ok or type(s)~="string" then warn("GAGAL LOAD MAIN") return end

local function R(a,b)
 local i,j=s:find(a,1,true)
 if not i then error("PATCH GAGAL: "..a) end
 s=s:sub(1,i-1)..b..s:sub(j+1)
end

-- GUI
R("frame.Size = UDim2.fromOffset(252, 292)",
  "frame.Size = UDim2.fromOffset(252, 331)")
R('local statusPanel = Instance.new("Frame")',
  'local homeworkButton = makeToggle("HomeworkButton","HOMEWORK",12,225)\nlocal statusPanel = Instance.new("Frame")')
R("statusPanel.Position = UDim2.fromOffset(12, 225)",
  "statusPanel.Position = UDim2.fromOffset(12, 264)")
R("footer.Position = UDim2.fromOffset(12, 270)",
  "footer.Position = UDim2.fromOffset(12, 309)")
R('paintToggle(gachaButton, "AUTO GACHA", autoGachaEnabled)',
  'paintToggle(gachaButton, "AUTO GACHA", autoGachaEnabled)\n    paintToggle(homeworkButton,"HOMEWORK",homeworkEnabled)')
R("updateButtons()\n]==]",
[=[
connect(homeworkButton.MouseButton1Click,function()
 if not alive() then return end
 homeworkEnabled=not homeworkEnabled
 updateButtons()
 if homeworkEnabled then
  setStatus("HOMEWORK DIMULAI - FARM DIJEDA")
  task.spawn(homeworkRun)
 else
  setStatus("HOMEWORK DIMATIKAN")
 end
end)
updateButtons()
]==]])

-- SISIPKAN FITUR KE BASE
local marker="-- ==========================================\n-- COMPILE DAN JALANKAN"
local i=s:find(marker,1,true)
if not i then error("MARKER COMPILE TIDAK DITEMUKAN") end

local inject=[==[
-- HOMEWORK FLAGS
replaceOnce("local autoFarm = false",
 "local autoFarm = false\nlocal homeworkEnabled=false\nlocal homeworkBusy=false\nlocal homeworkRun\n",
 "HOMEWORK FLAGS")

-- HOMEWORK ENGINE
local hw=[==[
local function hwRoot()
 local c=player.Character
 return c and c:FindFirstChild("HumanoidRootPart")
end
local function hwCarry()
 local c=player.Character
 return c and c:FindFirstChild("TrashBag",true)
end
local function hwPart(p)
 local x=p and p.Parent
 if not x then return nil end
 if x:IsA("BasePart") then return x end
 return x:FindFirstChildWhichIsA("BasePart",true)
end
local function hwGet(h,mode)
 local a={}
 for _,v in ipairs(h:GetDescendants()) do
  if mode==1 and v:IsA("ProximityPrompt")
  and v.ActionText=="Bersihkan" and v.Enabled then
   table.insert(a,v)
  elseif mode==2 and v:IsA("BasePart")
  and v.Name=="TrashBag" then
   local p=v:FindFirstChild("AmbilPrompt")
   if p and p.Enabled then table.insert(a,p) end
  end
 end
 return a
end
local function hwUse(p)
 if not p or not p.Parent or not p.Enabled then return false end
 local r,q=hwRoot(),hwPart(p)
 if not r or not q then return false end
 r.CFrame=CFrame.new(q.Position+Vector3.new(0,1.5,0))
 task.wait(.3)
 if not homeworkEnabled then return false end
 pcall(function() fireproximityprompt(p,p.HoldDuration) end)
 task.wait(.4)
 return homeworkEnabled
end
local function hwWait(v)
 for n=1,40 do
  if not homeworkEnabled or not alive() then return false end
  if (hwCarry()~=nil)==v then return true end
  task.wait(.25)
 end
 return false
end
local function hwDispose()
 if not hwCarry() then return true end
 local r=hwRoot()
 if not r then return false end
 local best,dist
 for _,p in ipairs(workspace:GetDescendants()) do
  if p:IsA("ProximityPrompt") and p.Name=="BuangPrompt"
  and p.ActionText=="Buang" and p.Enabled then
   local q=hwPart(p)
   if q then
    local d=(r.Position-q.Position).Magnitude
    if not dist or d<dist then best,dist=p,d end
   end
  end
 end
 return best~=nil and hwUse(best) and hwWait(false)
end

homeworkRun=function()
 if homeworkBusy then return end
 homeworkBusy=true
 local function finish(msg)
  homeworkEnabled=false
  homeworkBusy=false
  updateButtons()
  setStatus(msg)
 end
 while homeworkEnabled and alive() do
  local r=hwRoot()
  local folder=workspace:FindFirstChild("KosanSpawned")
  if not r or not folder then break end
  local house,short
  for _,h in ipairs(folder:GetChildren()) do
   for _,p in ipairs(hwGet(h,1)) do
    local q=hwPart(p)
    if q then
     local d=(r.Position-q.Position).Magnitude
     if not short or d<short then house,short=h,d end
    end
   end
  end
  if not house then
   finish("HOMEWORK SELESAI - SEMUA BERSIH")
   return
  end

  setStatus("HOMEWORK: MEMBERSIHKAN")
  local done={}
  while homeworkEnabled and alive() do
   local target
   for _,p in ipairs(hwGet(house,1)) do
    if not done[p] then target=p break end
   end
   if not target then break end
   if not hwUse(target) then break end
   done[target]=true
   task.wait(.2)
  end
  if not homeworkEnabled then break end

  setStatus("HOMEWORK: MENCARI SAMPAH")
  local idle=0
  while homeworkEnabled and alive() and idle<30 do
   if hwCarry() then
    setStatus("HOMEWORK: MEMBUANG")
    if not hwDispose() then break end
    idle=0
   else
    local bags=hwGet(house,2)
    if #bags>0 then
     if not hwUse(bags[1]) or not hwWait(true) then break end
     if not hwDispose() then break end
     idle=0
    elseif #hwGet(house,1)>0 then
     idle=0
     task.wait(1)
    else
     idle+=1
     task.wait(1)
    end
   end
  end
  if not homeworkEnabled then break end
  if hwCarry() then hwDispose() end
  if #hwGet(house,1)>0 or #hwGet(house,2)>0 then break end
 end
 finish("HOMEWORK DIHENTIKAN")
end
]==]

replaceOnce("-- ==========================================\n-- AUTO CLEANER LOOP",
 hw.."\n\n-- ==========================================\n-- AUTO CLEANER LOOP",
 "HOMEWORK ENGINE")

-- PAUSE CLEANER LAMA
replaceOnce("if not enabled or busy then",
 "if not enabled or busy or homeworkEnabled or homeworkBusy then",
 "HOMEWORK CLEANER PAUSE")

-- PRIORITAS DI ATAS AUTO FARM
replaceOnce("        enabled = true\n        updateButtons()",
 "        if homeworkEnabled or homeworkBusy then continue end\n        enabled = true\n        updateButtons()",
 "HOMEWORK FARM PRIORITY")

-- FEED BERHENTI JIKA HOMEWORK AKTIF
replaceOnce("if not alive() or not autoFarm then\n            return false",
 "if not alive() or not autoFarm or homeworkEnabled then\n            return false",
 "HOMEWORK FEED PAUSE")

]==]

s=s:sub(1,i-1)..inject.."\n"..s:sub(i)
local f,e=loadstring(s)
if not f then warn("COMPILE ERROR: "..tostring(e)) return end
local ran,err=pcall(f)
if not ran then warn("RAEL ERROR: "..tostring(err)) end
