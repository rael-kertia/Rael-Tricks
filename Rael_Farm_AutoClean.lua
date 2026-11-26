--[[
    RAEL FARM + AUTO CLEAN
    Sumber acuan: Rael-Tricks/base.lua
    Fitur:
      - AUTO FARM: ambil kotoran ternak + isi pakan saat stok 0/100
      - AUTO CLEAN: membersihkan prompt "Bersihkan" di area sekitar
      - Anti-AFK aktif selama sesi script berjalan.
      - Tidak membawa Homework, pengambilan TrashBag, pembuangan sampah,
        atau sistem lain dari base.lua.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
local World = workspace
local env = getgenv()

-- Isolasi sesi script ini dari script Rael lain.
if env.RaelFarmCleanSession then
    env.RaelFarmCleanSession.running = false
    for _, connection in ipairs(env.RaelFarmCleanSession.connections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    for _, object in ipairs(env.RaelFarmCleanSession.objects or {}) do
        pcall(function() object:Destroy() end)
    end
end

local SESSION = {
    running = true,
    connections = {},
    objects = {}
}
env.RaelFarmCleanSession = SESSION

local function alive()
    return SESSION.running and env.RaelFarmCleanSession == SESSION
end

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(SESSION.connections, connection)
    return connection
end

local function track(object)
    table.insert(SESSION.objects, object)
    return object
end

-- ANTI-AFK: cegah idle kick selama sesi script aktif.
connect(player.Idled, function()
    if not alive() then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- Pengaturan inti diambil dari pola base.lua.
local CLEAN_RANGE = 100
local SCAN_DELAY = 0.2
local DROPPING_RETRY = 2
local FEED_RETRY = 8

local cleanEnabled = false
local farmEnabled = false
local feedEnabled = true
local convertEnabled = true
local converting = false
local CONVERT_LIMIT = 2000
local lastConvertAttempt = 0
local cleanBusy = false
local farmBusy = false
local actionBusy = false

local cleanPrompts = setmetatable({}, {__mode = "k"})
local cleanRetry = setmetatable({}, {__mode = "k"})
local droppingCooldown = setmetatable({}, {__mode = "k"})
local feedCooldown = {}
local teleportNextDropping = false
local statusLabel

local function setStatus(message)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "STATUS: " .. tostring(message)
    end
end

local function getRoot()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- ==========================================
-- DATA KANDANG
-- ==========================================

local function getCurrentKandang()
    local name = player:GetAttribute("Ternak_Kandang")
    if typeof(name) ~= "string" then return nil end
    if not name:match("^Kandang_%d+$") then return nil end
    return name
end

local function getKandangNumber()
    local name = getCurrentKandang()
    return name and name:match("Kandang_(%d+)")
end

local function getCurrentPen()
    local kandang = getCurrentKandang()
    if not kandang then return nil end
    local kawasan = World:FindFirstChild("Kawasan_Kos")
    local ternak = kawasan and kawasan:FindFirstChild("Lahan_Ternak")
    return ternak and ternak:FindFirstChild(kandang)
end

local function getDroppingFolder()
    local kandang = getCurrentKandang()
    if not kandang then return nil end
    local farm = World:FindFirstChild("TernakLokal")
    local owner = farm and farm:FindFirstChild("KotoranSaya_" .. kandang)
    return owner and owner:FindFirstChild("Kotoran")
end

-- ==========================================
-- PROMPT / POSISI
-- ==========================================

local function isDroppingPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local action = (prompt.ActionText or ""):lower()
    local object = (prompt.ObjectText or ""):lower()
    local name = (prompt.Name or ""):lower()
    return action:find("ambil", 1, true) ~= nil
        and (object:find("kotoran", 1, true) ~= nil
        or name:find("ambilkotoran", 1, true) ~= nil)
end

local function isCleanPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local action = (prompt.ActionText or ""):lower()
    local object = (prompt.ObjectText or ""):lower()
    local name = (prompt.Name or ""):lower()
    local path = prompt:GetFullName():lower()

    -- Hindari prompt keranjang dan prompt sampah.
    if action:find("keranjang", 1, true)
        or object:find("keranjang", 1, true)
        or name:find("keranjang", 1, true)
        or path:find("keranjang", 1, true)
        or object:find("trash", 1, true)
        or name:find("trash", 1, true)
        or path:find("trashbag", 1, true) then
        return false
    end

    return action:find("bersihkan", 1, true) ~= nil
end

local function getPosition(prompt)
    if not prompt or not prompt.Parent then return nil end
    local parent = prompt.Parent

    if parent:IsA("Attachment") then
        return parent.WorldPosition
    elseif parent:IsA("BasePart") then
        return parent.Position
    end

    local model = parent:IsA("Model") and parent
        or parent:FindFirstAncestorWhichIsA("Model")
    if model then
        local part = model.PrimaryPart
            or model:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    end

    local part = parent:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

local function getObjectPosition(object)
    if not object then return nil end
    if object:IsA("BasePart") then return object.Position end
    if object:IsA("Model") then
        local ok, pivot = pcall(function() return object:GetPivot() end)
        if ok then return pivot.Position end
    end
    local part = object:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

local function activatePrompt(prompt)
    if not alive() or not prompt or not prompt.Parent or not prompt.Enabled then
        return false
    end

    if typeof(fireproximityprompt) == "function" then
        local ok = pcall(function() fireproximityprompt(prompt) end)
        if ok then return true end
    end

    local ok = pcall(function()
        prompt:InputHoldBegin()
        task.wait(math.max(prompt.HoldDuration, 0.2) + 0.15)
        prompt:InputHoldEnd()
    end)
    return ok
end

local function teleportNear(position, distance)
    if not alive() then return false end
    local root = getRoot()
    if not root or not position then return false end
    local target = position + Vector3.new(0, 1.5, distance or 2)
    root.CFrame = CFrame.lookAt(target, position)
    task.wait(0.35)
    return alive()
end

-- FARM menggunakan pathfinding adaptif: deteksi macet, lalu hitung ulang rute.
local function pathfindTo(position, prompt)
    if not alive() or not farmEnabled or not position then return false end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = getRoot()
    if not humanoid or not root then return false end

    local activationDistance = prompt and prompt.MaxActivationDistance or 10
    local arrivalDistance = math.max(2.5, math.min(activationDistance - 1, 8))
    local offsets = {
        Vector3.new(0, 0, 0),
        Vector3.new(3, 0, 0),
        Vector3.new(-3, 0, 0),
        Vector3.new(0, 0, 3),
        Vector3.new(0, 0, -3),
        Vector3.new(2.5, 0, 2.5),
        Vector3.new(-2.5, 0, 2.5),
        Vector3.new(2.5, 0, -2.5),
        Vector3.new(-2.5, 0, -2.5)
    }

    -- Maksimal 7 kali hitung ulang rute jika jalur terhalang atau karakter macet.
    for replan = 1, 7 do
        if not alive() or not farmEnabled then
            humanoid:MoveTo(root.Position)
            return false
        end

        root = getRoot()
        if not root then return false end
        if (root.Position - position).Magnitude <= arrivalDistance then
            return true
        end

        -- Cari titik pendekatan yang bisa dijangkau, bukan selalu titik prompt persis.
        local bestPath, bestDistance
        for _, offset in ipairs(offsets) do
            local goal = position + offset
            local candidate = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                AgentCanClimb = true,
                WaypointSpacing = 3
            })

            local ok = pcall(function()
                candidate:ComputeAsync(root.Position, goal)
            end)

            if ok and candidate.Status == Enum.PathStatus.Success then
                local waypoints = candidate:GetWaypoints()
                local distance = 0
                for i = 2, #waypoints do
                    distance = distance + (waypoints[i].Position - waypoints[i - 1].Position).Magnitude
                end
                if not bestDistance or distance < bestDistance then
                    bestPath = candidate
                    bestDistance = distance
                end
            end
        end

        if not bestPath then
            task.wait(0.2)
        else
            local waypoints = bestPath:GetWaypoints()
            local blocked = false
            local blockedConnection = bestPath.Blocked:Connect(function(blockedIndex)
                if blockedIndex >= 1 then blocked = true end
            end)

            for index, waypoint in ipairs(waypoints) do
                if not alive() or not farmEnabled then
                    blockedConnection:Disconnect()
                    humanoid:MoveTo(root.Position)
                    return false
                end

                root = getRoot()
                if not root then
                    blockedConnection:Disconnect()
                    return false
                end
                if (root.Position - position).Magnitude <= arrivalDistance then
                    blockedConnection:Disconnect()
                    return true
                end

                -- Lewati waypoint yang sudah terlewati agar tidak berputar di tempat.
                if (root.Position - waypoint.Position).Magnitude > 3 then
                    if waypoint.Action == Enum.PathWaypointAction.Jump then
                        humanoid.Jump = true
                    end

                    humanoid:MoveTo(waypoint.Position)
                    local lastPosition = root.Position
                    local lastProgress = os.clock()
                    local reached = false

                    while alive() and farmEnabled and os.clock() - lastProgress < 3.5 do
                        task.wait(0.15)
                        root = getRoot()
                        if not root then break end

                        if (root.Position - position).Magnitude <= arrivalDistance then
                            reached = true
                            break
                        end
                        if (root.Position - waypoint.Position).Magnitude <= 2.5 then
                            reached = true
                            break
                        end

                        -- Jika bergerak kurang dari 0.7 stud selama 1.1 detik, anggap tersangkut.
                        if (root.Position - lastPosition).Magnitude >= 0.7 then
                            lastPosition = root.Position
                            lastProgress = os.clock()
                        elseif os.clock() - lastProgress >= 1.1 then
                            break
                        end

                        if blocked then break end
                    end

                    if not alive() or not farmEnabled then
                        blockedConnection:Disconnect()
                        return false
                    end

                    root = getRoot()
                    if not root then
                        blockedConnection:Disconnect()
                        return false
                    end

                    if (root.Position - position).Magnitude <= arrivalDistance then
                        blockedConnection:Disconnect()
                        return true
                    end

                    if not reached and (root.Position - waypoint.Position).Magnitude > 3 then
                        blocked = true
                        break
                    end
                end
            end

            blockedConnection:Disconnect()
            root = getRoot()
            if root and (root.Position - position).Magnitude <= activationDistance then
                return true
            end
        end

        -- Beri jeda singkat lalu hitung ulang dari posisi karakter saat ini.
        task.wait(0.15)
    end

    return false
end

-- ==========================================
-- AUTO CONVERT KOTORAN 2000 + KLAIM GOLD
-- ==========================================
local function findManureTool()
    for _, c in ipairs({backpack, player.Character}) do
        if c then for _, o in ipairs(c:GetChildren()) do
            if o:IsA("Tool") and o.Name:lower():find("kotoran",1,true) then return o end
        end end
    end
end
local function getManureCount()
    local t=findManureTool(); if not t then return nil end
    for _, n in ipairs({"Amount","Jumlah","Count","Stack","Quantity","JumlahKotoran"}) do
        local v=t:GetAttribute(n); if typeof(v)=="number" then return v end
    end
    for _, o in ipairs(t:GetDescendants()) do
        if o:IsA("IntValue") or o:IsA("NumberValue") then
            local n=o.Name:lower()
            if n:find("jumlah") or n:find("count") or n:find("amount") or n:find("stack") then return o.Value end
        end
    end
end
local function isManureFull() local n=getManureCount(); return n~=nil and n>=CONVERT_LIMIT end
local function getConvertUI()
    local u=playerGui:FindFirstChild("ConvertUI"); local p=u and u:FindFirstChild("PanelConvert"); local c=p and p:FindFirstChild("Content")
    if not c then return nil end
    local pr=c:FindFirstChild("Proses"); local g=pr and pr:FindFirstChild("SlotGold")
    return {masuk=c:FindFirstChild("MasukBtn"),klaim=c:FindFirstChild("KlaimBtn"),status=c:FindFirstChild("StatusLbl"),gold=g and g:FindFirstChild("Jumlah"),panel=p}
end
local function isRateRising()
    local badges={}
    local m=playerGui:FindFirstChild("BursaGoldUI"); local p=m and m:FindFirstChild("PanelPasar"); local c=p and p:FindFirstChild("Konten"); local k=c and c:FindFirstChild("KursBox")
    if k and k:FindFirstChild("Badge") then table.insert(badges,k.Badge) end
    local u=playerGui:FindFirstChild("ConvertUI"); local cp=u and u:FindFirstChild("PanelConvert"); local cc=cp and cp:FindFirstChild("Content"); local st=cc and cc:FindFirstChild("KursStrip")
    if st and st:FindFirstChild("Badge") then table.insert(badges,st.Badge) end
    for _, b in ipairs(badges) do
        local tx=(b.Text or ""):upper(); local green=false
        pcall(function() local q=b.BackgroundColor3; green=q.G>q.R and q.G>q.B end)
        if (tx:find("▲",1,true) or tx:find("NAIK",1,true)) and green then return true end
    end
    return false
end
local function clickConvertButton(b)
    if not b or not b.Parent or typeof(firesignal)~="function" then return false end
    local fired=false
    pcall(function() firesignal(b.MouseButton1Click); fired=true end)
    task.wait(0.2)
    pcall(function() firesignal(b.Activated); fired=true end)
    return fired
end
local function getNearestConvertPrompt()
    local f=World:FindFirstChild("MsinConvert"); local root=getRoot()
    if not f or not root then return nil end
    local best,dist=nil,math.huge
    for _, p in ipairs(f:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Name=="ConvertPrompt" and p.Enabled then
            local pos=getPosition(p)
            if pos then local d=(root.Position-pos).Magnitude; if d<dist then best,dist=p,d end end
        end
    end
    return best
end
local function readGold(ui)
    if not ui or not ui.gold then return 0 end
    return tonumber((tostring(ui.gold.Text or ""):gsub(",", ".")):match("[%d%.]+")) or 0
end
local function closeConvertMachine(panel)
    if not panel then return end
    for _, o in ipairs(panel:GetDescendants()) do
        if o:IsA("GuiButton") then
            local n=o.Name:lower()
            if n=="x" or n:find("close",1,true) or n:find("exit",1,true) or n:find("tutup",1,true) then clickConvertButton(o); return end
        end
    end
end
local function runAutoConvert()
    if converting or not alive() or not farmEnabled or not convertEnabled or os.clock()-lastConvertAttempt<10 then return false end
    lastConvertAttempt=os.clock(); converting=true; actionBusy=true
    local function finish(msg) converting=false; actionBusy=false; if alive() then setStatus(msg) end end
    setStatus("KOTORAN 2000 - MENUJU MESIN")
    local prompt=getNearestConvertPrompt()
    if not prompt then finish("MESIN CONVERT TIDAK DITEMUKAN"); return false end
    local pos=getPosition(prompt)
    if not pos or not teleportNear(pos,2) then finish("GAGAL MENUJU MESIN"); return false end
    if not alive() or not farmEnabled or not convertEnabled then finish("CONVERT DIBATALKAN"); return false end
    if not activatePrompt(prompt) then finish("GAGAL MEMBUKA MESIN"); return false end
    local start=os.clock(); local ui
    repeat
        task.wait(0.25)
        if not alive() or not farmEnabled or not convertEnabled then finish("CONVERT DIBATALKAN"); return false end
        ui=getConvertUI()
    until (ui and ui.masuk and ui.klaim) or os.clock()-start>12
    if not ui or not ui.masuk or not ui.klaim then finish("UI CONVERT TIDAK TERDETEKSI"); return false end
    setStatus("MENUNGGU KURS HIJAU / NAIK"); start=os.clock()
    while alive() and farmEnabled and convertEnabled and os.clock()-start<300 do task.wait(1); if isRateRising() then break end end
    if not alive() or not farmEnabled or not convertEnabled then finish("CONVERT DIBATALKAN"); return false end
    if not isRateRising() then finish("KURS BELUM NAIK - COBA LAGI"); return false end
    local before=readGold(ui)
    setStatus("MEMASUKKAN 2000 KOTORAN")
    if not clickConvertButton(ui.masuk) then finish("TOMBOL MASUK GAGAL"); return false end
    start=os.clock(); local done=false
    while alive() and farmEnabled and convertEnabled and os.clock()-start<60 do
        task.wait(0.5); ui=getConvertUI()
        if ui then
            local st=ui.status and (ui.status.Text or ""):lower() or ""
            if readGold(ui)>before or st:find("selesai",1,true) or st:find("berhasil",1,true) or st:find("klaim",1,true) then done=true; break end
        end
    end
    if not alive() or not farmEnabled or not convertEnabled then finish("CONVERT DIBATALKAN"); return false end
    if not done then finish("PROSES CONVERT BELUM TERKONFIRMASI"); return false end
    ui=getConvertUI()
    if not ui or not ui.klaim then finish("TOMBOL KLAIM TIDAK DITEMUKAN"); return false end
    setStatus("MENGKLAIM GOLD")
    if not clickConvertButton(ui.klaim) then finish("KLAIM GOLD GAGAL"); return false end
    start=os.clock()
    while alive() and farmEnabled and convertEnabled and os.clock()-start<12 do
        task.wait(0.5); local count=getManureCount()
        if count==nil or count<CONVERT_LIMIT then
            closeConvertMachine(ui.panel); task.wait(0.4)
            finish("CONVERT BERHASIL - FARM LANJUT"); return true
        end
    end
    finish("KLAIM BELUM TERKONFIRMASI"); return false
end

-- ==========================================
-- AUTO CLEAN: HANYA PROMPT BERSIHKAN
-- Tidak mengambil TrashBag dan tidak membuang sampah.
-- ==========================================

local function registerPrompt(object)
    if object:IsA("ProximityPrompt") and isCleanPrompt(object) then
        cleanPrompts[object] = true
    end
end

for _, object in ipairs(World:GetDescendants()) do
    registerPrompt(object)
end

connect(World.DescendantAdded, function(object)
    if alive() then registerPrompt(object) end
end)

local function getNearestClean(root)
    local nearest, nearestDistance
    local now = os.clock()

    local function consider(prompt, isManure)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        if isManure then
            if not isDroppingPrompt(prompt) then return end
        elseif not isCleanPrompt(prompt) then
            return
        end

        local last = cleanRetry[prompt]
        if last and now - last < (isManure and DROPPING_RETRY or 1) then
            return
        end

        local position = getPosition(prompt)
        if not position then return end

        local distance = (root.Position - position).Magnitude
        local activationDistance = prompt.MaxActivationDistance or 10
        -- Sama seperti dirt rumah: prompt hanya diaktifkan ketika karakter
        -- sudah berada dalam jarak interaksi, bukan sekadar radius scan.
        if distance <= math.min(CLEAN_RANGE, activationDistance)
            and (not nearestDistance or distance < nearestDistance) then
            nearest = prompt
            nearestDistance = distance
        end
    end

    -- Prompt bersihkan dirt rumah.
    for prompt in pairs(cleanPrompts) do
        consider(prompt, false)
    end

    -- Prompt ambil kotoran ternak dari kandang milik pemain saat ini.
    local droppingFolder = getDroppingFolder()
    if droppingFolder then
        for _, object in ipairs(droppingFolder:GetDescendants()) do
            if object:IsA("ProximityPrompt") then
                consider(object, true)
            end
        end
    end

    return nearest
end

task.spawn(function()
    while alive() do
        task.wait(SCAN_DELAY)

        if not cleanEnabled or cleanBusy or actionBusy then
            continue
        end

        local root = getRoot()
        if not root then continue end

        local prompt = getNearestClean(root)
        if prompt and cleanEnabled and not actionBusy then
            cleanBusy = true
            actionBusy = true
            cleanRetry[prompt] = os.clock()

            local manurePrompt = isDroppingPrompt(prompt)
            setStatus(manurePrompt and "AUTO CLEAN: MENGAMBIL KOTORAN TERNAK"
                or "AUTO CLEAN: MEMBERSIHKAN DIRT RUMAH")

            local activated = activatePrompt(prompt)
            local started = os.clock()
            local completed = false

            if activated then
                repeat
                    task.wait(0.15)
                    if not prompt.Parent or not prompt.Enabled then
                        completed = true
                        break
                    end
                until not alive() or not cleanEnabled or os.clock() - started >= 3
            end

            if completed then
                cleanRetry[prompt] = nil
                setStatus(manurePrompt and "AUTO CLEAN: KOTORAN TERAMBIL"
                    or "AUTO CLEAN: DIRT BERSIH")
            else
                cleanRetry[prompt] = os.clock()
                setStatus(manurePrompt and "AUTO CLEAN: KOTORAN BELUM TERAMBIL"
                    or "AUTO CLEAN: PROMPT BELUM SELESAI")
            end

            actionBusy = false
            cleanBusy = false
        end
    end
end)

-- ==========================================
-- AUTO FARM: KOTORAN TERNAK
-- ==========================================

local function findNextDropping()
    local folder = getDroppingFolder()
    if not folder then return nil, nil, false, false end

    local root = getRoot()
    if not root then return nil, nil, true, false end

    local now = os.clock()
    local nearest, nearestPosition
    local nearestDistance = math.huge
    local hasDroppings = false
    local hasReady = false

    for _, object in ipairs(folder:GetDescendants()) do
        if object:IsA("ProximityPrompt")
            and isDroppingPrompt(object)
            and object.Enabled then

            hasDroppings = true
            local position = getPosition(object)
            if position then
                local distance = (root.Position - position).Magnitude
                local last = droppingCooldown[object]
                local ready = not last or now - last >= DROPPING_RETRY
                if ready then
                    hasReady = true
                    if distance < nearestDistance then
                        nearest = object
                        nearestPosition = position
                        nearestDistance = distance
                    end
                end
            end
        end
    end

    return nearest, nearestPosition, true, hasDroppings, hasReady
end

-- ==========================================
-- AUTO FEED: HANYA SAAT STOK 0/100
-- ==========================================

local function findCabai()
    local character = player.Character

    local function search(container)
        if not container then return nil end
        for _, tool in ipairs(container:GetChildren()) do
            local name = tool.Name:lower()
            if tool:IsA("Tool")
                and name:find("cabai", 1, true)
                and not name:find("bibit", 1, true) then
                return tool
            end
        end
    end

    return search(character) or search(backpack)
end

local function equipCabai()
    local tool = findCabai()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not tool or not humanoid then return false end

    if tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.6)
    end

    return tool.Parent == character
end

local function getStock(feeder)
    if not feeder then return nil end

    for _, object in ipairs(feeder:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local text = (object.Text or ""):lower()
            local name = object.Name:lower()
            if text:find("pakan", 1, true) or name:find("pakan", 1, true) then
                local amount = text:match("(%d+)%s*/%s*100")
                if amount then return tonumber(amount) end
            end
        end
    end

    for _, object in ipairs(feeder:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local amount = (object.Text or ""):match("(%d+)%s*/%s*100")
            if amount then return tonumber(amount) end
        end
    end

    return nil
end

local function findFeedPrompt(feeder)
    if not feeder then return nil end
    local direct = feeder:FindFirstChild("IsiPakanPrompt", true)
    if direct and direct:IsA("ProximityPrompt") then return direct end

    for _, object in ipairs(feeder:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            local action = (object.ActionText or ""):lower()
            local target = (object.ObjectText or ""):lower()
            local name = object.Name:lower()
            if action:find("isi", 1, true)
                or target:find("pakan", 1, true)
                or name:find("isi", 1, true)
                or name:find("pakan", 1, true) then
                return object
            end
        end
    end
end

local function getFeeders()
    local result = {}
    local kandang = getCurrentKandang()
    if not kandang then return result end

    local pen = getCurrentPen()
    if pen then
        for _, name in ipairs({"Palung_1", "Palung_2"}) do
            local feeder = pen:FindFirstChild(name, true)
            if feeder then
                table.insert(result, {name = name, object = feeder})
            end
        end
    end

    local number = getKandangNumber()
    local farm = World:FindFirstChild("TernakLokal")
    if farm and number then
        for _, name in ipairs({
            "Palung_Kandang_" .. number .. "_1",
            "Palung_Kandang_" .. number .. "_2"
        }) do
            local feeder = farm:FindFirstChild(name, true)
            if feeder then
                local exists = false
                for _, entry in ipairs(result) do
                    if entry.object == feeder then exists = true break end
                end
                if not exists then
                    table.insert(result, {name = name, object = feeder})
                end
            end
        end
    end

    return result
end

local function feedOne()
    if not feedEnabled then return end
    local feeders = getFeeders()
    if #feeders == 0 then
        setStatus("PALUNG TIDAK DITEMUKAN")
        return
    end

    local foundZero = false
    for _, entry in ipairs(feeders) do
        if not alive() or not farmEnabled then return end

        local stock = getStock(entry.object)
        if stock == 0 then
            foundZero = true
            local last = feedCooldown[entry.name]
            if last and os.clock() - last < FEED_RETRY then
                continue
            end

            if not equipCabai() then
                setStatus("CABAI TIDAK DITEMUKAN")
                return
            end

            local prompt = findFeedPrompt(entry.object)
            if not prompt or not prompt.Enabled then
                feedCooldown[entry.name] = os.clock()
                setStatus(entry.name .. ": PROMPT ISI TIDAK SIAP")
                continue
            end

            local position = getPosition(prompt) or getObjectPosition(entry.object)
            if not position then
                setStatus(entry.name .. ": POSISI PALUNG GAGAL")
                continue
            end

            setStatus(entry.name .. ": PATHFINDING KE PALUNG")
            if not pathfindTo(position, prompt) then
                feedCooldown[entry.name] = os.clock()
                setStatus(entry.name .. ": JALUR KE PALUNG TERHALANG")
                continue
            end
            if not alive() or not farmEnabled then return end
            setStatus(entry.name .. ": MENGISI PAKAN")

            if activatePrompt(prompt) then
                local started = os.clock()
                local newStock = getStock(entry.object)
                while alive() and farmEnabled and os.clock() - started < 6 do
                    task.wait(0.25)
                    newStock = getStock(entry.object)
                    if newStock ~= nil and newStock > 0 then break end
                end

                if newStock ~= nil and newStock > 0 then
                    feedCooldown[entry.name] = nil
                    teleportNextDropping = true
                    setStatus(entry.name .. ": PAKAN " .. newStock .. "/100")
                else
                    feedCooldown[entry.name] = os.clock()
                    setStatus(entry.name .. ": PENGISIAN BELUM BERHASIL")
                end
            else
                feedCooldown[entry.name] = os.clock()
                setStatus(entry.name .. ": INTERAKSI GAGAL")
            end
        end
    end

    if not foundZero then
        setStatus("PAKAN BELUM 0/100")
    end
end

task.spawn(function()
    local emptyScans = 0

    while alive() do
        task.wait(0.35)

        if not farmEnabled or farmBusy or actionBusy then
            continue
        end

        if convertEnabled and isManureFull() then
            runAutoConvert()
            continue
        end

        if not getCurrentKandang() then
            setStatus("FARM: MEMBACA DATA KANDANG")
            continue
        end

        local folder = getDroppingFolder()
        if not folder then
            emptyScans += 1
            if emptyScans >= 3 then
                actionBusy = true
                farmBusy = true
                setStatus("FOLDER KOTORAN TIDAK ADA - CEK PAKAN")
                feedOne()
                farmBusy = false
                actionBusy = false
                emptyScans = 0
            end
            continue
        end

        local prompt, position, scanReady, hasDroppings, hasReady =
            findNextDropping()

        if not scanReady then
            emptyScans += 1
            if emptyScans >= 3 then
                actionBusy = true
                farmBusy = true
                setStatus("SCAN KOTORAN GAGAL - CEK PAKAN")
                feedOne()
                farmBusy = false
                actionBusy = false
                emptyScans = 0
            end
            continue
        end

        if hasDroppings and hasReady and prompt and position then
            emptyScans = 0
            farmBusy = true
            actionBusy = true
            local reachedDropping = false
            if teleportNextDropping then
                setStatus("FARM: TP PERTAMA SETELAH ISI PAKAN")
                reachedDropping = teleportNear(position, 2)
                if reachedDropping then
                    teleportNextDropping = false
                end
            else
                setStatus("FARM: PATHFINDING KE KOTORAN")
                reachedDropping = pathfindTo(position, prompt)
            end

            if reachedDropping and alive() and farmEnabled then
                local activated = activatePrompt(prompt)
                if activated then
                    setStatus("FARM: MENGAMBIL KOTORAN")
                    local started = os.clock()
                    local collected = false

                    while alive() and farmEnabled and os.clock() - started < 4 do
                        task.wait(0.15)
                        if not prompt.Parent
                            or not prompt:IsDescendantOf(folder)
                            or not prompt.Enabled then
                            collected = true
                            break
                        end
                    end

                    if collected then
                        droppingCooldown[prompt] = nil
                        setStatus("FARM: KOTORAN TERAMBIL")
                    else
                        droppingCooldown[prompt] = os.clock()
                        setStatus("FARM: KOTORAN BELUM TERAMBIL")
                    end
                else
                    droppingCooldown[prompt] = os.clock()
                    setStatus("FARM: INTERAKSI KOTORAN GAGAL")
                end
            else
                droppingCooldown[prompt] = os.clock()
            end

            actionBusy = false
            farmBusy = false
            continue
        end

        if hasDroppings and not hasReady then
            setStatus("FARM: KOTORAN MENUNGGU COOLDOWN")
            continue
        end

        emptyScans += 1
        if emptyScans >= 3 then
            farmBusy = true
            actionBusy = true
            setStatus("FARM: KOTORAN HABIS - CEK PAKAN")
            feedOne()
            actionBusy = false
            farmBusy = false
            emptyScans = 0
        end
    end
end)

-- ==========================================
-- GUI
-- ==========================================

local oldGui = playerGui:FindFirstChild("RaelFarmClean")
if oldGui then oldGui:Destroy() end

local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelFarmClean"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(210, 151)
frame.Position = UDim2.new(1, -225, 0, 110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -64, 0, 22)
title.Position = UDim2.fromOffset(7, 0)
title.BackgroundTransparency = 1
title.Text = "RAEL FARM + CLEAN | AFK ON"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(25, 19)
minimize.Position = UDim2.new(1, -29, 0, 2)
minimize.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 15
minimize.Parent = frame
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 5)

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopAllButton"
stopButton.Size = UDim2.fromOffset(25, 19)
stopButton.Position = UDim2.new(1, -58, 0, 2)
stopButton.BackgroundColor3 = Color3.fromRGB(155, 40, 48)
stopButton.Text = "X"
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 12
stopButton.Parent = frame
Instance.new("UICorner", stopButton).CornerRadius = UDim.new(0, 5)

local mini = Instance.new("TextButton")
mini.Name = "RaelFarmMini"
mini.Size = UDim2.fromOffset(42, 42)
mini.Position = UDim2.new(1, -55, 0, 110)
mini.BackgroundColor3 = Color3.fromRGB(35, 100, 65)
mini.Text = "RF"
mini.TextColor3 = Color3.new(1, 1, 1)
mini.TextSize = 15
mini.Font = Enum.Font.GothamBold
mini.Visible = false
mini.Active = true
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)

local function makeButton(name, text, x, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(96, 29)
    button.Position = UDim2.fromOffset(x, 28)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 10
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    return button
end

local cleanButton = makeButton("CleanButton", "CLEAN: OFF", 6, Color3.fromRGB(150, 45, 45))
local farmButton = makeButton("FarmButton", "FARM: OFF", 108, Color3.fromRGB(35, 100, 65))
local feedButton = makeButton("FeedButton", "FEED: ON", 6, Color3.fromRGB(35, 145, 70))
local convertButton = makeButton("ConvertButton", "CONVERT: ON", 108, Color3.fromRGB(35, 145, 70))
feedButton.Position = UDim2.fromOffset(6, 62)
convertButton.Position = UDim2.fromOffset(108, 62)

statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -12, 0, 37)
statusLabel.Position = UDim2.fromOffset(6, 101)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS: READY"
statusLabel.TextColor3 = Color3.fromRGB(255, 220, 120)
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.TextWrapped = true
statusLabel.Parent = frame

local function updateButtons()
    cleanButton.Text = cleanEnabled and "CLEAN: ON" or "CLEAN: OFF"
    cleanButton.BackgroundColor3 = cleanEnabled
        and Color3.fromRGB(35, 145, 70) or Color3.fromRGB(150, 45, 45)

    farmButton.Text = farmEnabled and "FARM: ON" or "FARM: OFF"
    farmButton.BackgroundColor3 = farmEnabled
        and Color3.fromRGB(35, 145, 70) or Color3.fromRGB(35, 100, 65)
    feedButton.Text = feedEnabled and "FEED: ON" or "FEED: OFF"
    feedButton.BackgroundColor3 = feedEnabled and Color3.fromRGB(35, 145, 70) or Color3.fromRGB(150, 45, 45)
    convertButton.Text = convertEnabled and "CONVERT: ON" or "CONVERT: OFF"
    convertButton.BackgroundColor3 = convertEnabled and Color3.fromRGB(35, 145, 70) or Color3.fromRGB(150, 45, 45)
end

connect(cleanButton.MouseButton1Click, function()
    if not alive() then return end
    cleanEnabled = not cleanEnabled
    updateButtons()
    setStatus(cleanEnabled and "AUTO CLEAN AKTIF" or "AUTO CLEAN NONAKTIF")
end)

connect(farmButton.MouseButton1Click, function()
    if not alive() then return end
    farmEnabled = not farmEnabled
    updateButtons()
    setStatus(farmEnabled and "AUTO FARM AKTIF" or "AUTO FARM NONAKTIF")
end)

connect(feedButton.MouseButton1Click, function()
    if not alive() then return end
    feedEnabled = not feedEnabled
    updateButtons()
    setStatus(feedEnabled and "AUTO FEED AKTIF" or "AUTO FEED NONAKTIF")
end)

connect(convertButton.MouseButton1Click, function()
    if not alive() then return end
    convertEnabled = not convertEnabled
    updateButtons()
    setStatus(convertEnabled and "AUTO CONVERT AKTIF" or "AUTO CONVERT NONAKTIF")
end)

connect(stopButton.MouseButton1Click, function()
    if not alive() then return end
    SESSION.running = false
    cleanEnabled, farmEnabled, feedEnabled, convertEnabled = false, false, false, false
    converting, actionBusy = false, false
    for _, connection in ipairs(SESSION.connections) do pcall(function() connection:Disconnect() end) end
    table.clear(SESSION.connections)
    for _, object in ipairs(SESSION.objects) do pcall(function() object:Destroy() end) end
    table.clear(SESSION.objects)
end)

connect(minimize.MouseButton1Click, function()
    frame.Visible = false
    mini.Visible = true
end)

connect(mini.MouseButton1Click, function()
    mini.Visible = false
    frame.Visible = true
end)

-- Drag support untuk layar sentuh dan mouse.
local function makeDraggable(object)
    local dragging = false
    local dragInput, dragStart, startPosition

    connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position
            dragInput = input

            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    connect(UserInputService.InputChanged, function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(frame)
makeDraggable(mini)

connect(gui.Destroying, function()
    if env.RaelFarmCleanSession == SESSION then
        SESSION.running = false
    end
end)

updateButtons()
setStatus("READY - FARM & CLEAN OFF")