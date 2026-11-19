-- ==========================================
-- RAEL'S TRICKS V18.2 FULL
-- INDO KOS: BUILD & UPGRADE
-- AUTO CLEANER + AUTO FARM
-- DROPPINGS PRIORITY
-- AUTO FEED WHEN DROPPING FOLDER MISSING
-- FEED ONLY AT 0/100
-- MINIMIZE + REOPEN GUI
-- NO STOP ALL
-- ==========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")
local env = getgenv()

-- ==========================================
-- CLEAN PREVIOUS VERSION
-- ==========================================

if env.RaelV18Connections then
    for _, c in ipairs(env.RaelV18Connections) do
        pcall(function() c:Disconnect() end)
    end
end

if env.RaelV18Objects then
    for _, obj in ipairs(env.RaelV18Objects) do
        pcall(function() obj:Destroy() end)
    end
end

env.RaelV18Running = false
task.wait(0.15)

env.RaelV18Running = true
local SESSION = tick()
env.RaelV18Session = SESSION
env.RaelV18Connections = {}
env.RaelV18Objects = {}

local function alive()
    return env.RaelV18Running
        and env.RaelV18Session == SESSION
end

local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(env.RaelV18Connections, c)
    return c
end

local function track(object)
    table.insert(env.RaelV18Objects, object)
    return object
end

-- ==========================================
-- SETTINGS
-- ==========================================

local RANGE_CLEAN = 100
local RANGE_TRASH = 30
local SCAN_DELAY = 0.2
local RETRY_DELAY = 1
local DROPPING_RETRY = 2
local FEED_RETRY = 8

local enabled = false
local autoFarm = false
local busy = false

local prompts = setmetatable({}, {__mode = "k"})
local lastAttempt = setmetatable({}, {__mode = "k"})
local collectCooldown = {}
local feedCooldown = {}

-- ==========================================
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

    local kawasan = workspace:FindFirstChild("Kawasan_Kos")
    local ternak = kawasan and kawasan:FindFirstChild("Lahan_Ternak")
    return ternak and ternak:FindFirstChild(kandang)
end

local function getDroppingFolder()
    local kandang = getCurrentKandang()
    if not kandang then return nil end

    local farm = workspace:FindFirstChild("TernakLokal")
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
-- TRASHBAG
-- ==========================================

local function isCarryingTrash()
    local character = player.Character
    local model = character and character:FindFirstChild("Model")
    local trash = model and model:FindFirstChild("TrashBag")
    return trash ~= nil and trash:IsA("BasePart")
end

-- ==========================================
-- TELEPORT
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

-- ==========================================
-- PROMPT INTERACTION
-- ==========================================

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
-- GUI
-- ==========================================

local oldGui = playerGui:FindFirstChild("RaelsTricksV18")
if oldGui then oldGui:Destroy() end

local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelsTricksV18"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(205, 115)
frame.Position = UDim2.new(1, -220, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -38, 0, 20)
title.Position = UDim2.fromOffset(5, 0)
title.BackgroundTransparency = 1
title.Text = "RAEL'S TRICKS V18.2"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- MINIMIZE
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.fromOffset(25, 19)
minimizeButton.Position = UDim2.new(1, -29, 0, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = frame
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 5)

-- REOPEN RT
local miniButton = Instance.new("TextButton")
miniButton.Name = "RaelMiniButton"
miniButton.Size = UDim2.fromOffset(42, 42)
miniButton.Position = UDim2.new(1, -55, 0, 100)
miniButton.BackgroundColor3 = Color3.fromRGB(35, 100, 65)
miniButton.Text = "RT"
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.TextSize = 15
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Active = true
miniButton.Parent = gui
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)

local function makeButton(name, text, x, y, w, color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.fromOffset(w, 29)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local cleanButton = makeButton(
    "CleanButton", "CLEAN: OFF", 5, 22, 95,
    Color3.fromRGB(160, 45, 45)
)

local farmButton = makeButton(
    "FarmButton", "FARM: OFF", 105, 22, 95,
    Color3.fromRGB(35, 100, 65)
)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.fromOffset(5, 88)
status.BackgroundTransparency = 1
status.Text = "Status: READY"
status.TextColor3 = Color3.fromRGB(255, 220, 120)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local function setStatus(msg)
    if status and status.Parent then
        status.Text = "Status: " .. msg
    end
end

local function updateButtons()
    cleanButton.Text = enabled and "CLEAN: ON" or "CLEAN: OFF"
    cleanButton.BackgroundColor3 = enabled
        and Color3.fromRGB(35, 145, 70)
        or Color3.fromRGB(160, 45, 45)

    farmButton.Text = autoFarm and "FARM: ON" or "FARM: OFF"
    farmButton.BackgroundColor3 = autoFarm
        and Color3.fromRGB(35, 145, 70)
        or Color3.fromRGB(35, 100, 65)
end

-- ==========================================
-- DRAG
-- ==========================================

local function makeDraggable(object)
    local dragging = false
    local dragStart
    local startPosition

    connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    connect(UIS.InputChanged, function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(frame)
makeDraggable(miniButton)

connect(minimizeButton.MouseButton1Click, function()
    frame.Visible = false
    miniButton.Visible = true
end)

connect(miniButton.MouseButton1Click, function()
    miniButton.Visible = false
    frame.Visible = true
end)

-- ==========================================
-- BUTTON EVENTS
-- ==========================================

connect(cleanButton.MouseButton1Click, function()
    if not alive() then return end
    if autoFarm then return end

    enabled = not enabled
    updateButtons()
end)

connect(farmButton.MouseButton1Click, function()
    if not alive() then return end

    autoFarm = not autoFarm

    if autoFarm then
        enabled = true
        setStatus("FARM DIMULAI")
    else
        setStatus("FARM DIMATIKAN")
    end

    updateButtons()
end)

-- ==========================================
-- AUTO CLEANER TARGET
-- ==========================================

local function getNearest(root)
    local now = os.clock()
    local carryingTrash = isCarryingTrash()
    local nearest
    local shortest = math.huge

    for prompt in pairs(prompts) do
        if prompt.Parent and prompt.Enabled and isAllowed(prompt) then
            if autoFarm and isDroppingPrompt(prompt) then
                continue
            end

            local action = (prompt.ActionText or ""):lower()
            local isClean = action:find("bersihkan", 1, true)
            local isTake = action:find("ambil", 1, true)
            local isDrop = action:find("buang", 1, true)

            if isTake and carryingTrash then continue end
            if isDrop and not carryingTrash then continue end

            local ready = not lastAttempt[prompt]
                or now - lastAttempt[prompt] >= RETRY_DELAY

            if ready then
                local pos = getPosition(prompt)
                local range = isClean and RANGE_CLEAN or RANGE_TRASH

                if pos then
                    local distance = (root.Position - pos).Magnitude
                    if distance <= range and distance < shortest then
                        nearest = prompt
                        shortest = distance
                    end
                end
            end
        end
    end

    return nearest
end

-- ==========================================
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
                if amount then
                    return tonumber(amount)
                end
            end
        end
    end

    for _, obj in ipairs(palung:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local amount = (obj.Text or ""):match("(%d+)%s*/%s*100")
            if amount then
                return tonumber(amount)
            end
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
    local farm = workspace:FindFirstChild("TernakLokal")

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
        if not alive() or not autoFarm then
            return false
        end

        local stock = getStock(entry.object)

        if stock == nil then
            setStatus(entry.name .. ": STOK TIDAK TERBACA")
            continue
        end

        if stock ~= 0 then
            continue
        end

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

        if not teleportNear(position, 2) then
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
-- REGISTER PROMPTS
-- ==========================================

for _, obj in ipairs(workspace:GetDescendants()) do
    addPrompt(obj)
end

connect(workspace.DescendantAdded, function(obj)
    if alive() then
        addPrompt(obj)
    end
end)

-- ==========================================
-- AUTO CLEANER LOOP
-- ==========================================

task.spawn(function()
    while alive() and gui.Parent do
        task.wait(SCAN_DELAY)

        if not enabled or busy then
            continue
        end

        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not root then
            continue
        end

        local prompt = getNearest(root)

        if prompt and enabled then
            busy = true
            lastAttempt[prompt] = os.clock()

            activatePrompt(prompt)
            task.wait(0.1)

            busy = false
        end
    end
end)

-- ==========================================
-- AUTO FARM LOOP V18.2 FIX
-- ==========================================

task.spawn(function()
    local emptyScans = 0

    while alive() and gui.Parent do
        task.wait(0.5)

        if not autoFarm then
            emptyScans = 0
            continue
        end

        enabled = true
        updateButtons()

        if not getCurrentKandang() then
            setStatus("MEMBACA DATA KANDANG")
            emptyScans = 0
            continue
        end

        -- CEK FOLDER SECARA LANGSUNG
        local folder = getDroppingFolder()

        -- FOLDER TIDAK ADA = ANGGAP TIDAK ADA KOTORAN
        if not folder then
            emptyScans += 1

            if emptyScans < 3 then
                setStatus("FOLDER KOTORAN TIDAK ADA - CEK ULANG")
                continue
            end

            setStatus("TIDAK ADA KOTORAN - CEK PAKAN")
            feedOne()
            emptyScans = 0
            continue
        end

        local prompt, pos, scanReady, hasDroppings, waiting =
            findNextDropping()

        if not scanReady then
            -- FOLDER ADA TAPI SCAN BELUM SIAP
            emptyScans += 1

            if emptyScans < 3 then
                setStatus("SCAN KOTORAN - CEK ULANG")
                continue
            end

            setStatus("KOTORAN TIDAK TERDETEKSI - CEK PAKAN")
            feedOne()
            emptyScans = 0
            continue
        end

        if hasDroppings then
            emptyScans = 0

            if waiting then
                setStatus("KOTORAN MENUNGGU COOLDOWN")
                continue
            end

            if not prompt or not pos then
                setStatus("POSISI KOTORAN TIDAK TERBACA")
                continue
            end

            setStatus("MENUJU KOTORAN")

            if not teleportNear(pos, 1.5) then
                collectCooldown[prompt] = os.clock()
                continue
            end

            if not alive() or not autoFarm then
                continue
            end

            local activated, method = activatePrompt(prompt)

            if not activated then
                collectCooldown[prompt] = os.clock()
                setStatus("INTERAKSI GAGAL")
                continue
            end

            setStatus("MENCOBA AMBIL: " .. method)

            local start = os.clock()
            local collected = false

            while alive() and autoFarm
            and os.clock() - start < 4 do
                task.wait(0.15)

                if not prompt.Parent
                or not prompt:IsDescendantOf(folder)
                or not prompt.Enabled then
                    collected = true
                    break
                end
            end

            if collected then
                collectCooldown[prompt] = nil
                setStatus("KOTORAN TERAMBIL")
            else
                collectCooldown[prompt] = os.clock()
                setStatus("BELUM TERAMBIL - COBA ULANG")
            end

            continue
        end

        -- FOLDER ADA TAPI TIDAK ADA PROMPT KOTORAN
        emptyScans += 1

        if emptyScans < 3 then
            setStatus("MEMASTIKAN KOTORAN HABIS")
            continue
        end

        setStatus("KOTORAN HABIS - CEK PAKAN")
        feedOne()
        emptyScans = 0
    end
end)

-- ==========================================
-- TP LOCATION
-- ==========================================

local oldTool = backpack:FindFirstChild("TP LOCATION")
    or (player.Character and player.Character:FindFirstChild("TP LOCATION"))

if oldTool then
    oldTool:Destroy()
end

local tool = track(Instance.new("Tool"))
tool.Name = "TP LOCATION"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = backpack

local tpEquipped = false
local equipTime = 0

connect(tool.Equipped, function()
    tpEquipped = true
    equipTime = os.clock()
end)

connect(tool.Unequipped, function()
    tpEquipped = false
end)

connect(UIS.TouchTapInWorld, function(position, processed)
    if not alive() or not tpEquipped or processed then
        return
    end

    if os.clock() - equipTime < 0.25 then
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local ray = camera:ViewportPointToRay(position.X, position.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character}

    local result = workspace:Raycast(
        ray.Origin,
        ray.Direction * 1500,
        params
    )

    if not result then return end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not root or not humanoid then return end

    local height = humanoid.HipHeight + root.Size.Y / 2

    root.CFrame = CFrame.new(
        result.Position.X,
        result.Position.Y + height + 0.15,
        result.Position.Z
    )
end)

-- ==========================================
-- ANTI AFK
-- ==========================================

connect(player.Idled, function()
    if not alive() then return end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ==========================================
-- GUI DESTROY GUARD
-- ==========================================

connect(gui.Destroying, function()
    if env.RaelV18Session == SESSION then
        env.RaelV18Running = false
    end
end)

-- ==========================================
-- FINISH
-- ==========================================

updateButtons()
setStatus("READY - FARM OFF")

print("RAEL'S TRICKS V18.2 LOADED")
print("AUTO FARM READY")
print("AUTO FEED WHEN FOLDER MISSING")
print("FEED ONLY AT 0/100")
print("MINIMIZE + REOPEN READY")
print("TP LOCATION + ANTI AFK READY")
print("NO STOP ALL")
