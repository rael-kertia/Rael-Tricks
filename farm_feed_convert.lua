-- RAEL FARM / FEED / CONVERT - STANDALONE
-- Does not read, patch, download, or modify main.lua.
-- Features: Auto Farm, Auto Feed, Auto Convert only.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")
local W = workspace
local env = getgenv()

-- Isolated session namespace; does not reuse RaelV18 globals.
if env.RFC_Connections then
    for _, c in ipairs(env.RFC_Connections) do pcall(function() c:Disconnect() end) end
end
if env.RFC_Objects then
    for _, o in ipairs(env.RFC_Objects) do pcall(function() o:Destroy() end) end
end
env.RFC_Running = false
task.wait(0.1)
env.RFC_Running = true
local SESSION = tick()
env.RFC_Session = SESSION
env.RFC_Connections = {}
env.RFC_Objects = {}

local function alive()
    return env.RFC_Running and env.RFC_Session == SESSION
end
local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(env.RFC_Connections, c)
    return c
end
local function track(o)
    table.insert(env.RFC_Objects, o)
    return o
end

local autoFarm, autoFeed, autoConvert = false, false, false
local farmBusy, convertBusy = false, false
local emptyScans = 0
local collectCooldown = setmetatable({}, {__mode="k"})
local feedCooldown = {}
local CONVERT_THRESHOLD = 2000
local MANURE_FARM_LIMIT = 2000 -- Batas maksimum kotoran di backpack.
local SCAN_DELAY = 0.5

-- DYNAMIC KANDANG
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

    local kawasan = W:FindFirstChild("Kawasan_Kos")
    local ternak = kawasan and kawasan:FindFirstChild("Lahan_Ternak")
    return ternak and ternak:FindFirstChild(kandang)
end

local function getDroppingFolder()
    local kandang = getCurrentKandang()
    if not kandang then return nil end

    local farm = W:FindFirstChild("TernakLokal")
    local owner = farm and farm:FindFirstChild("KotoranSaya_" .. kandang)
    return owner and owner:FindFirstChild("Kotoran")
end

-- ==========================================

-- PROMPT FILTER
-- ==========================================

local function isDroppingPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local action = (prompt.ActionText or ""):lower()
    local object = (prompt.ObjectText or ""):lower()
    local name = (prompt.Name or ""):lower()

    return action:find("ambil", 1, true) ~= nil
        and (
            object:find("kotoran", 1, true) ~= nil
            or name:find("ambilkotoran", 1, true) ~= nil
        )
end

local function isAllowed(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local action = (prompt.ActionText or ""):lower()
    local object = (prompt.ObjectText or ""):lower()
    local name = (prompt.Name or ""):lower()
    local path = prompt:GetFullName():lower()

    if action:find("keranjang", 1, true)
    or object:find("keranjang", 1, true)
    or name:find("keranjang", 1, true)
    or path:find("keranjang", 1, true) then
        return false
    end

    return action:find("bersihkan", 1, true)
        or action:find("ambil", 1, true)
        or action:find("buang", 1, true)
end

local function addPrompt(obj)
    if obj:IsA("ProximityPrompt") and isAllowed(obj) then
        prompts[obj] = true
    end
end

-- ==========================================

-- POSITION
-- ==========================================

local function getPosition(prompt)
    if not prompt or not prompt.Parent then return nil end

    local parent = prompt.Parent

    if parent:IsA("Attachment") then
        return parent.WorldPosition
    end

    if parent:IsA("BasePart") then
        return parent.Position
    end

    local model = parent:IsA("Model")
        and parent
        or parent:FindFirstAncestorWhichIsA("Model")

    if model then
        local part = model.PrimaryPart
            or model:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    end

    local part = parent:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

local function getObjectPosition(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position end

    if obj:IsA("Model") then
        local ok, pivot = pcall(function()
            return obj:GetPivot()
        end)
        if ok then return pivot.Position end
    end

    local part = obj:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

-- ==========================================

-- TELEPORT + PROMPT LAMA
-- ==========================================

local function teleportNear(position, distance)
    if not alive() then return false end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or not position then return false end

    local target = position + Vector3.new(0, 1.5, distance or 2)
    root.CFrame = CFrame.lookAt(target, position)
    task.wait(0.4)

    return alive()
end

local function activatePrompt(prompt)
    if not alive() or not prompt
    or not prompt.Parent or not prompt.Enabled then
        return false, "PROMPT TIDAK AKTIF"
    end

    if typeof(fireproximityprompt) == "function" then
        local ok = pcall(function()
            fireproximityprompt(prompt)
        end)

        if ok then
            return true, "FIREPROXIMITYPROMPT"
        end
    end

    local ok = pcall(function()
        prompt:InputHoldBegin()
        task.wait(math.max(prompt.HoldDuration, 0.2) + 0.15)
        prompt:InputHoldEnd()
    end)

    if ok then
        return true, "INPUT HOLD"
    end

    return false, "INTERAKSI GAGAL"
end

-- ==========================================

-- NEW GUI: three feature toggles only
local old = playerGui:FindFirstChild("RaelFarmFeedConvert")
if old then old:Destroy() end
local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelFarmFeedConvert"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10000
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(228, 174)
panel.Position = UDim2.new(1, -244, 0, 110)
panel.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(65, 93, 125)
stroke.Thickness = 1

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -42, 0, 30)
header.Position = UDim2.fromOffset(12, 4)
header.BackgroundTransparency = 1
header.Text = "RAEL // FARM SYSTEM"
header.TextColor3 = Color3.fromRGB(235, 242, 255)
header.TextSize = 12
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = panel

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(26, 24)
minimize.Position = UDim2.new(1, -33, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(42, 53, 70)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
minimize.Parent = panel
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

local function makeToggle(name, label, y, color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = label .. "  [OFF]"
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = panel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end
local farmButton = makeToggle("AutoFarm", "AUTO FARM", 39, Color3.fromRGB(34, 94, 75))
local feedButton = makeToggle("AutoFeed", "AUTO FEED", 77, Color3.fromRGB(44, 83, 128))
local convertButton = makeToggle("AutoConvert", "AUTO CONVERT", 115, Color3.fromRGB(113, 77, 39))

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 17)
status.Position = UDim2.fromOffset(10, 151)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(255, 213, 128)
status.TextSize = 9
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local function setStatus(s)
    if status and status.Parent then status.Text = "STATUS: " .. tostring(s) end
end
local function paint(button, label, enabled, onColor, offColor)
    button.Text = label .. (enabled and "  [ON]" or "  [OFF]")
    button.BackgroundColor3 = enabled and onColor or offColor
end
local function updateUI()
    paint(farmButton, "AUTO FARM", autoFarm, Color3.fromRGB(32,145,94), Color3.fromRGB(34,94,75))
    paint(feedButton, "AUTO FEED", autoFeed, Color3.fromRGB(43,126,190), Color3.fromRGB(44,83,128))
    paint(convertButton, "AUTO CONVERT", autoConvert, Color3.fromRGB(184,123,48), Color3.fromRGB(113,77,39))
end

local mini = Instance.new("TextButton")
mini.Name = "RaelFarmMini"
mini.Size = UDim2.fromOffset(44,44)
mini.Position = UDim2.new(1,-58,0,110)
mini.BackgroundColor3 = Color3.fromRGB(29,105,91)
mini.Text = "RF"
mini.TextColor3 = Color3.new(1,1,1)
mini.TextSize = 14
mini.Font = Enum.Font.GothamBold
mini.Visible = false
mini.Active = true
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local function draggable(obj)
    local moving, start, origin = false, nil, nil
    connect(obj.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            moving, start, origin = true, input.Position, obj.Position
            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then moving = false end
            end)
        end
    end)
    connect(UIS.InputChanged, function(input)
        if moving and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - start
            obj.Position = UDim2.new(origin.X.Scale, origin.X.Offset+d.X, origin.Y.Scale, origin.Y.Offset+d.Y)
        end
    end)
end
draggable(panel)
draggable(mini)
connect(minimize.MouseButton1Click, function() panel.Visible=false; mini.Visible=true end)
connect(mini.MouseButton1Click, function() mini.Visible=false; panel.Visible=true end)

-- DROPPING SCANNER
-- ==========================================

local function findNextDropping()
    local folder = getDroppingFolder()

    if not folder then
        return nil, nil, false, false, false
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return nil, nil, true, false, false
    end

    local now = os.clock()
    local nearestReady, nearestReadyPos
    local nearestWaiting, nearestWaitingPos
    local nearestReadyDistance = math.huge
    local nearestWaitingDistance = math.huge
    local hasDroppings = false

    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("ProximityPrompt")
        and isDroppingPrompt(obj)
        and obj.Enabled then

            hasDroppings = true

            local pos = getPosition(obj)

            if pos then
                local distance = (root.Position - pos).Magnitude
                local last = collectCooldown[obj]
                local ready = not last or now - last >= DROPPING_RETRY

                if ready and distance < nearestReadyDistance then
                    nearestReady = obj
                    nearestReadyPos = pos
                    nearestReadyDistance = distance
                elseif not ready and distance < nearestWaitingDistance then
                    nearestWaiting = obj
                    nearestWaitingPos = pos
                    nearestWaitingDistance = distance
                end
            elseif not nearestWaiting then
                nearestWaiting = obj
            end
        end
    end

    if nearestReady then
        return nearestReady, nearestReadyPos, true, true, false
    end

    if hasDroppings then
        return nearestWaiting, nearestWaitingPos, true, true, true
    end

    return nil, nil, true, false, false
end

-- ==========================================

-- FEED TOOL
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
        task.wait(0.7)
    end

    return tool.Parent == character
end

-- ==========================================
-- FEED STOCK
-- ==========================================

local function getStock(palung)
    if not palung then return nil end

    for _, obj in ipairs(palung:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local txt = (obj.Text or ""):lower()
            local name = obj.Name:lower()

            if txt:find("pakan", 1, true)
            or name:find("pakan", 1, true) then
                local amount = txt:match("(%d+)%s*/%s*100")
                if amount then return tonumber(amount) end
            end
        end
    end

    for _, obj in ipairs(palung:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local amount = (obj.Text or ""):match("(%d+)%s*/%s*100")
            if amount then return tonumber(amount) end
        end
    end

    return nil
end

-- ==========================================
-- FEED PROMPT
-- ==========================================

local function findFeedPrompt(palung)
    if not palung then return nil end

    local direct = palung:FindFirstChild("IsiPakanPrompt", true)

    if direct and direct:IsA("ProximityPrompt") then
        return direct
    end

    for _, obj in ipairs(palung:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local action = (obj.ActionText or ""):lower()
            local object = (obj.ObjectText or ""):lower()
            local name = obj.Name:lower()

            if action:find("isi", 1, true)
            or object:find("pakan", 1, true)
            or name:find("isi", 1, true)
            or name:find("pakan", 1, true) then
                return obj
            end
        end
    end

    return nil
end

-- ==========================================
-- GET FEEDERS
-- ==========================================

local function getFeeders()
    local result = {}
    local kandang = getCurrentKandang()

    if not kandang then return result end

    local pen = getCurrentPen()

    if pen then
        for _, name in ipairs({"Palung_1", "Palung_2"}) do
            local palung = pen:FindFirstChild(name, true)

            if palung then
                table.insert(result, {
                    name = name,
                    object = palung
                })
            end
        end
    end

    local number = getKandangNumber()
    local farm = W:FindFirstChild("TernakLokal")

    if farm and number then
        for _, name in ipairs({
            "Palung_Kandang_" .. number .. "_1",
            "Palung_Kandang_" .. number .. "_2"
        }) do
            local palung = farm:FindFirstChild(name, true)

            if palung then
                local exists = false

                for _, entry in ipairs(result) do
                    if entry.object == palung then
                        exists = true
                    end
                end

                if not exists then
                    table.insert(result, {
                        name = name,
                        object = palung
                    })
                end
            end
        end
    end

    return result
end

-- ==========================================
-- AUTO FEED ONLY AT 0/100
-- ==========================================

local function feedOne()
    local feeders = getFeeders()

    if #feeders == 0 then
        setStatus("PALUNG TIDAK DITEMUKAN")
        return false
    end

    local foundZero = false
    local attempted = false

    for _, entry in ipairs(feeders) do
        if not alive() or not autoFarm
        or homeworkEnabled or homeworkBusy then
            return false
        end

        local stock = getStock(entry.object)

        if stock == nil then
            setStatus(entry.name .. ": STOK TIDAK TERBACA")
            continue
        end

        if stock ~= 0 then continue end
        foundZero = true

        local now = os.clock()
        local last = feedCooldown[entry.name]

        if last and now - last < FEED_RETRY then
            continue
        end

        attempted = true

        if not equipCabai() then
            setStatus("CABAI TIDAK DITEMUKAN")
            return false
        end

        local prompt = findFeedPrompt(entry.object)

        if not prompt then
            setStatus(entry.name .. ": PROMPT ISI TIDAK ADA")
            feedCooldown[entry.name] = os.clock()
            continue
        end

        if not prompt.Enabled then
            setStatus(entry.name .. ": PROMPT ISI NONAKTIF")
            feedCooldown[entry.name] = os.clock()
            continue
        end

        local position = getPosition(prompt)
            or getObjectPosition(entry.object)

        if not position then
            setStatus(entry.name .. ": POSISI PALUNG GAGAL")
            continue
        end

        setStatus(entry.name .. ": MENGISI PAKAN 0/100")

        if not teleportNear(position, 2) then continue end

        if not alive() or not autoFarm
        or homeworkEnabled or homeworkBusy then
            continue
        end

        local ok = activatePrompt(prompt)

        if not ok then
            feedCooldown[entry.name] = os.clock()
            setStatus(entry.name .. ": INTERAKSI GAGAL")
            continue
        end

        local start = os.clock()
        local newStock = getStock(entry.object)

        while alive() and autoFarm
        and not homeworkEnabled and not homeworkBusy
        and os.clock() - start < 6 do
            task.wait(0.25)

            newStock = getStock(entry.object)

            if newStock ~= nil and newStock > 0 then
                break
            end
        end

        if newStock ~= nil and newStock > 0 then
            feedCooldown[entry.name] = nil
            setStatus(entry.name .. ": PAKAN " .. newStock .. "/100")
        else
            feedCooldown[entry.name] = os.clock()
            setStatus(entry.name .. ": PENGISIAN BELUM BERHASIL")
        end
    end

    if not foundZero then
        setStatus("PAKAN BELUM 0/100")
    elseif not attempted then
        setStatus("MENUNGGU COOLDOWN PAKAN")
    end

    return attempted
end

-- ==========================================

-- Convert helpers: find manure count from tool metadata, values, or visible counter text.
local function readNumber(value)
    if typeof(value) == "number" then return value end
    if typeof(value) == "string" then
        -- Read only the first numeric token (e.g. "2000/2000" -> 2000).
        local token = value:match("%d[%d%. ,]*")
        if token then
            local digits = token:gsub("[^%d]", "")
            if digits ~= "" then return tonumber(digits) end
        end
    end
    return nil
end

local function getManureTool()
    local character = player.Character
    local containers = {backpack, character}
    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") then
                    local n = obj.Name:lower()
                    if n:find("kotoran",1,true) or n:find("manure",1,true) then return obj end
                end
            end
        end
    end
    return nil
end

local function getManureCount()
    local tool = getManureTool()
    if tool then
        for _, key in ipairs({"Count","Jumlah","Amount","数量","Stack"}) do
            local a = readNumber(tool:GetAttribute(key))
            if a ~= nil then return a end
        end
        for _, v in ipairs(tool:GetDescendants()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("count",1,true) or n:find("jumlah",1,true) or n:find("amount",1,true) then
                    return v.Value
                end
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                local n = v.Name:lower()
                if n:find("count",1,true) or n:find("jumlah",1,true) or n:find("kotoran",1,true) then
                    local a = readNumber(v.Text)
                    if a ~= nil then return a end
                end
            end
        end
    end
    for _, container in ipairs({backpack, playerGui}) do
        for _, v in ipairs(container:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                local text = (v.Text or ""):lower()
                if text:find("kotoran",1,true) or text:find("manure",1,true) then
                    local a = readNumber(text)
                    if a ~= nil then return a end
                end
            end
        end
    end
    return nil
end

local function findConvertPrompt()
    local machine = W:FindFirstChild("MsinConvert")
    if not machine then return nil end
    local p = machine:FindFirstChild("ConvertPrompt", true)
    if p and p:IsA("ProximityPrompt") then return p end
    for _, v in ipairs(machine:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (v.Name:lower():find("convert",1,true) or v.ActionText:lower():find("convert",1,true)) then
            return v
        end
    end
    return nil
end

local function findButton(root, name)
    if not root then return nil end
    local obj = root:FindFirstChild(name, true)
    if obj and (obj:IsA("TextButton") or obj:IsA("ImageButton")) then return obj end
    return nil
end

local function clickButton(button)
    if not button or not button.Parent then return false end
    local fired = false
    if typeof(firesignal) == "function" then
        fired = pcall(function() firesignal(button.MouseButton1Click) end)
        pcall(function() firesignal(button.Activated) end)
    end
    if not fired then
        pcall(function() button:Activate() end)
    end
    return true
end

local function findConvertUI()
    local root = playerGui:FindFirstChild("ConvertUI", true)
    if not root then return nil end
    local panelUI = root:FindFirstChild("PanelConvert", true)
    local content = panelUI and panelUI:FindFirstChild("Content", true)
    if not content then return nil end
    return content, findButton(content,"MasukBtn"), findButton(content,"KlaimBtn")
end

-- Kurs dibaca langsung dari KursStrip.Nilai; koma desimal dinormalisasi.
-- Warna indikator tidak dipakai sebagai syarat transaksi.
local MIN_CONVERT_RATE = 0.00150
local function getConvertRate(content)
    if not content then return nil end
    local strip = content:FindFirstChild("KursStrip", true)
    local label = strip and strip:FindFirstChild("Nilai", true)
    if not label or not (label:IsA("TextLabel") or label:IsA("TextButton")) then
        return nil
    end
    local text = label.Text or ""
    -- Explicitly parse the decimal comma used by the game UI.
    local whole, fraction = text:match("=%s*(%d+),(%d+)")
    if whole and fraction then
        return tonumber(whole .. "." .. fraction)
    end
    local decimal = text:match("=%s*(%d+%.%d+)")
    if decimal then return tonumber(decimal) end
    local integer = text:match("=%s*(%d+)")
    return integer and tonumber(integer) or nil
end

local function waitUntil(fn, seconds)
    local started = os.clock()
    while alive() and os.clock()-started < seconds do
        local ok, result = pcall(fn)
        if ok and result then return result end
        task.wait(0.25)
    end
    return nil
end

local function waitConvertUntil(fn, seconds)
    local started = os.clock()
    while alive() and autoConvert and os.clock()-started < seconds do
        local ok, result = pcall(fn)
        if ok and result then return result end
        task.wait(0.25)
    end
    return nil
end

local function runConvert()
    if convertBusy or farmBusy or not autoConvert or not alive() then return end
    convertBusy = true
    local ok, err = pcall(function()
        local count = getManureCount()
        if not count or count < CONVERT_THRESHOLD then
            setStatus(count and ("KOTORAN "..count.."/"..CONVERT_THRESHOLD) or "JUMLAH KOTORAN TIDAK TERBACA")
            return
        end

        setStatus("MENUJU MESIN CONVERT")
        local prompt = findConvertPrompt()
        if not prompt or not prompt.Enabled then
            setStatus("CONVERT PROMPT TIDAK DITEMUKAN")
            return
        end
        local pos = getPosition(prompt)
        if not pos or not teleportNear(pos, 2) then
            setStatus("POSISI MESIN TIDAK TERBACA")
            return
        end
        if not alive() or not autoConvert then return end
        local activated = activatePrompt(prompt)
        if not activated then
            setStatus("GAGAL MEMBUKA MESIN")
            return
        end

        local content, masuk, klaim = waitConvertUntil(function()
            local a,b,c = findConvertUI()
            if a and b and c then return {a,b,c} end
        end, 15)
        if not content then
            setStatus("CONVERT UI TIDAK MUNCUL")
            return
        end
        masuk, klaim = content[2], content[3]
        setStatus("MENUNGGU KURS MINIMAL 0,00150")

        -- Tunggu sampai nilai numerik kurs memenuhi ambang, tanpa memedulikan warna merah/hijau.
        local rateReady = waitConvertUntil(function()
            local rate = getConvertRate(content[1])
            if rate and rate >= MIN_CONVERT_RATE then
                return rate
            end
        end, 310)
        if not rateReady then
            setStatus("KURS BELUM MEMENUHI 0,00150")
            return
        end
        if not autoConvert or not alive() then return end

        local before = getManureCount()
        local leaderstats = player:FindFirstChild("leaderstats")
        local gold = leaderstats and (leaderstats:FindFirstChild("Gold") or leaderstats:FindFirstChild("Uang"))
        local goldBefore
        if gold and (gold:IsA("IntValue") or gold:IsA("NumberValue")) then goldBefore = gold.Value end

        setStatus(string.format("KURS %.5f - MASUK", rateReady))
        clickButton(masuk)
        task.wait(0.6)

        setStatus("MENUNGGU HASIL CONVERT")
        local completed = waitConvertUntil(function()
            local current = getManureCount()
            local statusText = ""
            for _, v in ipairs(content[1]:GetDescendants()) do
                if v:IsA("TextLabel") then statusText = statusText .. " " .. (v.Text or ""):lower() end
            end
            local goldNow = gold and gold.Value
            if (before and current and current < before) or (goldBefore and goldNow and goldNow > goldBefore)
                or statusText:find("selesai",1,true) or statusText:find("berhasil",1,true) then
                return true
            end
        end, 300)
        if not completed then
            setStatus("HASIL CONVERT BELUM TERKONFIRMASI")
            return
        end
        if not autoConvert or not alive() then return end
        setStatus("KLAIM HASIL")
        clickButton(klaim)
        waitConvertUntil(function()
            local current = getManureCount()
            return before and current and current < before
        end, 20)

        -- Close the conversion panel if the game exposes a conventional close control.
        local rootUI = playerGui:FindFirstChild("ConvertUI", true)
        if rootUI then
            for _, name in ipairs({"CloseBtn","CloseButton","TutupBtn","ExitBtn"}) do
                local close = findButton(rootUI, name)
                if close then clickButton(close); break end
            end
        end
        setStatus("CONVERT SELESAI")
    end)
    if not ok then setStatus("CONVERT ERROR: "..tostring(err)) end
    convertBusy = false
end

-- Feature button wiring
connect(farmButton.MouseButton1Click, function()
    autoFarm = not autoFarm
    updateUI()
    setStatus(autoFarm and "AUTO FARM AKTIF" or "AUTO FARM NONAKTIF")
end)
connect(feedButton.MouseButton1Click, function()
    autoFeed = not autoFeed
    updateUI()
    setStatus(autoFeed and "AUTO FEED AKTIF" or "AUTO FEED NONAKTIF")
end)
connect(convertButton.MouseButton1Click, function()
    autoConvert = not autoConvert
    updateUI()
    setStatus(autoConvert and "AUTO CONVERT AKTIF" or "AUTO CONVERT NONAKTIF")
end)

-- Farm worker. Auto Feed is called only after three confirmed empty scans.
task.spawn(function()
    while alive() and gui.Parent do
        task.wait(SCAN_DELAY)
        if not autoFarm or farmBusy or convertBusy then continue end
        farmBusy = true
        local ok, err = pcall(function()
            if not getCurrentKandang() then
                setStatus("MEMBACA DATA KANDANG")
                emptyScans = 0
                return
            end

            -- Hard cap: fail closed if count cannot be read; never collect blindly.
            local manureCount = getManureCount()
            if manureCount == nil then
                emptyScans = 0
                setStatus("JUMLAH KOTORAN TIDAK TERBACA - FARM DITAHAN")
                return
            end
            if manureCount >= MANURE_FARM_LIMIT then
                emptyScans = 0
                setStatus("BATAS KOTORAN TERCAPAI: " .. manureCount .. "/" .. MANURE_FARM_LIMIT)
                return
            end

            local folder = getDroppingFolder()
            if not folder then
                emptyScans = emptyScans + 1
                setStatus("FOLDER KOTORAN TIDAK ADA")
                if emptyScans >= 3 then
                    emptyScans = 0
                    if autoFeed then feedOne() else setStatus("KOTORAN KOSONG - AUTO FEED OFF") end
                end
                return
            end
            local p, pos, ready, hasDroppings, waiting = findNextDropping()
            if not ready then
                emptyScans = emptyScans + 1
                setStatus("SCAN KOTORAN")
                if emptyScans >= 3 then
                    emptyScans = 0
                    if autoFeed then feedOne() else setStatus("KOTORAN TIDAK TERDETEKSI") end
                end
                return
            end
            if hasDroppings then
                emptyScans = 0
                if waiting then setStatus("KOTORAN MENUNGGU COOLDOWN"); return end
                if not p or not pos then setStatus("POSISI KOTORAN TIDAK TERBACA"); return end
                setStatus("MENUJU KOTORAN")
                if not teleportNear(pos,1.5) then collectCooldown[p]=os.clock(); return end
                if not autoFarm or not alive() then return end

                -- Recheck immediately before interacting, in case the count changed during teleport.
                manureCount = getManureCount()
                if manureCount == nil then
                    setStatus("JUMLAH KOTORAN TIDAK TERBACA - PENGAMBILAN DIBATALKAN")
                    return
                end
                if manureCount >= MANURE_FARM_LIMIT then
                    setStatus("BATAS KOTORAN TERCAPAI: " .. manureCount .. "/" .. MANURE_FARM_LIMIT)
                    return
                end

                local success = activatePrompt(p)
                if not success then collectCooldown[p]=os.clock(); setStatus("GAGAL AMBIL KOTORAN"); return end
                local start = os.clock()
                local got = waitUntil(function()
                    return not p.Parent or not p:IsDescendantOf(folder) or not p.Enabled
                end, 4)
                if got then collectCooldown[p]=nil; setStatus("KOTORAN TERAMBIL")
                else collectCooldown[p]=os.clock(); setStatus("KOTORAN BELUM TERAMBIL") end
                return
            end
            emptyScans = emptyScans + 1
            setStatus("MEMASTIKAN KOTORAN HABIS")
            if emptyScans >= 3 then
                emptyScans = 0
                if autoFeed then feedOne() else setStatus("KOTORAN HABIS - AUTO FEED OFF") end
            end
        end)
        if not ok then setStatus("FARM ERROR: "..tostring(err)) end
        farmBusy = false
    end
end)

-- Convert monitor runs independently and never blocks the farm while idle.
task.spawn(function()
    while alive() and gui.Parent do
        task.wait(2)
        if autoConvert and not convertBusy then
            local count = getManureCount()
            if count and count >= CONVERT_THRESHOLD then
                runConvert()
            end
        end
    end
end)

connect(gui.Destroying, function()
    if env.RFC_Session == SESSION then env.RFC_Running = false end
end)

updateUI()
setStatus("READY // ALL FEATURES OFF")
print("RAEL FARM / FEED / CONVERT LOADED")
print("AUTO FARM / AUTO FEED / AUTO CONVERT READY")
