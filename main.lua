
-- ==========================================
-- RAEL'S TRICKS V1
-- BASE V1 + AUTO CONVERT + AUTO CLAIM
-- AUTO CLOSE CONVERT MACHINE
-- ==========================================

local URL = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(source) ~= "string" or #source < 1000 then
    warn("RAEL V1: GAGAL MENGAMBIL MAIN.LUA")
    return
end

local function replaceOnce(old, new, label)
    local first, last = source:find(old, 1, true)
    if not first then
        error("V1 GAGAL: BAGIAN TIDAK DITEMUKAN - " .. label)
    end
    source = source:sub(1, first - 1) .. new .. source:sub(last + 1)
end

local function replaceBetween(startMarker, endMarker, newText, label)
    local first = source:find(startMarker, 1, true)
    if not first then
        error("V1 GAGAL: AWAL BAGIAN TIDAK DITEMUKAN - " .. label)
    end
    local last = source:find(endMarker, first, true)
    if not last then
        error("V1 GAGAL: AKHIR BAGIAN TIDAK DITEMUKAN - " .. label)
    end
    source = source:sub(1, first - 1) .. newText .. "\n\n" .. source:sub(last)
end

replaceOnce(
    "local autoFarm = false",
    "local autoFarm = false\nlocal autoConvert = true\nlocal autoFeedEnabled = true\nlocal antiAfkEnabled = true\nlocal tpEnabled = true",
    "FEATURE FLAGS"
)

-- ==========================================
-- AUTO CONVERT SYSTEM
-- ==========================================

local convertCode = [==[
-- ==========================================
-- AUTO CONVERT KOTORAN
-- ==========================================

local converting = false
local CONVERT_LIMIT = 2000
local lastConvertAttempt = 0

local function findManureTool()
    local containers = {backpack, player.Character}

    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool")
                and obj.Name:lower():find("kotoran", 1, true) then
                    return obj
                end
            end
        end
    end

    return nil
end

local function getManureCount()
    local tool = findManureTool()
    if not tool then return nil end

    local attributeNames = {
        "Amount", "Jumlah", "Count",
        "Stack", "Quantity", "JumlahKotoran"
    }

    for _, name in ipairs(attributeNames) do
        local value = tool:GetAttribute(name)
        if typeof(value) == "number" then
            return value
        end
    end

    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = obj.Name:lower()
            if name:find("jumlah") or name:find("count")
            or name:find("amount") or name:find("stack") then
                return obj.Value
            end
        end
    end

    local roots = {}
    local coreGui = game:GetService("CoreGui")

    pcall(function()
        table.insert(roots, coreGui)
    end)

    table.insert(roots, playerGui)

    for _, root in ipairs(roots) do
        local okScan, descendants = pcall(function()
            return root:GetDescendants()
        end)

        if okScan then
            for _, obj in ipairs(descendants) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local txt = (obj.Text or ""):lower()
                    local number = txt:match("x%s*([%d,%.]+)")

                    if number then
                        number = number:gsub(",", ""):gsub("%.", "")
                        local amount = tonumber(number)

                        if amount and amount >= CONVERT_LIMIT then
                            return amount
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function isManureFull()
    local count = getManureCount()
    return count ~= nil and count >= CONVERT_LIMIT
end

local function getConvertUI()
    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")
    local content = panel and panel:FindFirstChild("Content")

    if not content then return nil end

    return {
        panel = panel,
        content = content,
        masuk = content:FindFirstChild("MasukBtn"),
        klaim = content:FindFirstChild("KlaimBtn"),
        status = content:FindFirstChild("StatusLbl"),
        gold = content:FindFirstChild("Proses")
            and content.Proses:FindFirstChild("SlotGold")
            and content.Proses.SlotGold:FindFirstChild("Jumlah"),
        manure = content:FindFirstChild("Proses")
            and content.Proses:FindFirstChild("SlotKotoran")
            and content.Proses.SlotKotoran:FindFirstChild("Jumlah")
    }
end

local function isRateRising()
    local badges = {}

    local market = playerGui:FindFirstChild("BursaGoldUI")
    local marketPanel = market
        and market:FindFirstChild("PanelPasar")
    local marketContent = marketPanel
        and marketPanel:FindFirstChild("Konten")
    local kursBox = marketContent
        and marketContent:FindFirstChild("KursBox")

    if kursBox and kursBox:FindFirstChild("Badge") then
        table.insert(badges, kursBox.Badge)
    end

    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")
    local content = panel and panel:FindFirstChild("Content")
    local strip = content and content:FindFirstChild("KursStrip")

    if strip and strip:FindFirstChild("Badge") then
        table.insert(badges, strip.Badge)
    end

    for _, badge in ipairs(badges) do
        local text = (badge.Text or ""):upper()
        local green = false

        pcall(function()
            local color = badge.BackgroundColor3
            green = color.G > color.R and color.G > color.B
        end)

        if (text:find("▲", 1, true)
        or text:find("NAIK", 1, true))
        and green then
            return true
        end
    end

    return false
end

-- KLIK TOMBOL MASUK DAN KLAIM
local function clickConvertButton(button)
    if not button or not button.Parent then
        return false
    end

    local fired = false

    if typeof(firesignal) == "function" then
        pcall(function()
            firesignal(button.MouseButton1Click)
            fired = true
        end)

        task.wait(0.2)

        pcall(function()
            firesignal(button.Activated)
            fired = true
        end)
    end

    return fired
end

-- TUTUP MESIN CONVERT / TEKAN X
local function closeConvertMachine()
    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")

    if not panel then
        return true
    end

    local closeNames = {
        "x", "close", "closebtn",
        "exit", "exitbtn", "tutup", "tutupbtn"
    }

    for _, obj in ipairs(panel:GetDescendants()) do
        if obj:IsA("GuiButton") then
            local name = obj.Name:lower()
            local label = ""

            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") then
                    label = (child.Text or ""):lower()
                    break
                end
            end

            local matched = false

            for _, closeName in ipairs(closeNames) do
                if name == closeName then
                    matched = true
                    break
                end
            end

            if matched
            or name:find("close", 1, true)
            or name:find("exit", 1, true)
            or name:find("tutup", 1, true)
            or label == "x" then

                clickConvertButton(obj)
                task.wait(0.5)

                if not panel.Visible then
                    return true
                end
            end
        end
    end

    return not panel.Visible
end

local function getNearestConvertPrompt()
    local folder = workspace:FindFirstChild("MsinConvert")
    if not folder then return nil end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local nearest
    local shortest = math.huge

    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("ProximityPrompt")
        and obj.Name == "ConvertPrompt"
        and obj.Enabled then
            local pos = getPosition(obj)

            if pos then
                local distance = (root.Position - pos).Magnitude

                if distance < shortest then
                    shortest = distance
                    nearest = obj
                end
            end
        end
    end

    return nearest
end

local function readGoldValue(ui)
    if not ui or not ui.gold then return 0 end

    local text = tostring(ui.gold.Text or "")
    text = text:gsub(",", ".")
    return tonumber(text:match("[%d%.]+")) or 0
end

local function runAutoConvert()
    if converting or not alive() or not autoFarm then
        return false
    end

    if os.clock() - lastConvertAttempt < 10 then
        return false
    end

    lastConvertAttempt = os.clock()
    converting = true
    busy = true

    local function finish(message)
        converting = false
        busy = false
        setStatus(message)
    end

    setStatus("KOTORAN PENUH - MENUJU MESIN")

    local prompt = getNearestConvertPrompt()

    if not prompt then
        finish("MESIN CONVERT TIDAK DITEMUKAN")
        return false
    end

    local position = getPosition(prompt)

    if not position or not teleportNear(position, 2) then
        finish("GAGAL MENUJU MESIN CONVERT")
        return false
    end

    local activated = activatePrompt(prompt)

    if not activated then
        finish("GAGAL MEMBUKA MESIN")
        return false
    end

    local start = os.clock()
    local ui

    repeat
        task.wait(0.25)
        ui = getConvertUI()
    until not alive()
        or not autoFarm
        or (ui and ui.masuk and ui.klaim)
        or os.clock() - start > 12

    if not alive() or not autoFarm then
        finish("CONVERT DIBATALKAN")
        return false
    end

    if not ui or not ui.masuk or not ui.klaim then
        finish("UI CONVERT TIDAK TERDETEKSI")
        return false
    end

    -- TUNGGU KURS HIJAU / NAIK
    setStatus("MENUNGGU KURS HIJAU / NAIK")

    start = os.clock()

    while alive() and autoFarm
    and os.clock() - start < 300 do
        task.wait(1)

        if isRateRising() then
            break
        end
    end

    if not alive() or not autoFarm then
        finish("CONVERT DIBATALKAN")
        return false
    end

    if not isRateRising() then
        finish("KURS BELUM NAIK - MENUNGGU")
        return false
    end

    -- MASUKKAN 2000 KOTORAN
    setStatus("MEMASUKKAN 2000 KOTORAN")

    local beforeGold = readGoldValue(ui)

    if not clickConvertButton(ui.masuk) then
        finish("TOMBOL MASUK GAGAL")
        return false
    end

    -- TUNGGU PROSES KONVERSI
    start = os.clock()
    local completed = false

    while alive() and autoFarm
    and os.clock() - start < 60 do
        task.wait(0.5)

        ui = getConvertUI()

        if ui then
            local goldNow = readGoldValue(ui)
            local statusText = ui.status
                and (ui.status.Text or ""):lower() or ""

            if goldNow > beforeGold
            or statusText:find("selesai", 1, true)
            or statusText:find("berhasil", 1, true)
            or statusText:find("klaim", 1, true) then
                completed = true
                break
            end
        end
    end

    if not alive() or not autoFarm then
        finish("CONVERT DIBATALKAN")
        return false
    end

    if not completed then
        finish("PROSES CONVERT BELUM TERKONFIRMASI")
        return false
    end

    -- KLAIM GOLD
    ui = getConvertUI()

    if not ui or not ui.klaim then
        finish("TOMBOL KLAIM TIDAK DITEMUKAN")
        return false
    end

    setStatus("MENGKLAIM GOLD")

    if not clickConvertButton(ui.klaim) then
        finish("KLAIM GOLD GAGAL")
        return false
    end

    -- VERIFIKASI KOTORAN SUDAH KELUAR DARI SLOT
    start = os.clock()

    while alive() and autoFarm
    and os.clock() - start < 12 do
        task.wait(0.5)

        local count = getManureCount()

        if count == nil or count < CONVERT_LIMIT then
            setStatus("GOLD DIKLAIM - KELUAR MESIN")

            closeConvertMachine()

            task.wait(1)

            finish("CONVERT BERHASIL - FARM LANJUT")
            return true
        end
    end

    finish("KLAIM BELUM TERKONFIRMASI")
    return false
end
]==]

local guiCode = [==[
-- MODERN GUI V1
local oldGui = playerGui:FindFirstChild("RaelsTricksV1")
if oldGui then oldGui:Destroy() end

local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelsTricksV1"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(252, 258)
frame.Position = UDim2.new(1, -266, 0, 95)
frame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(45, 212, 191)
frameStroke.Thickness = 1.3
frameStroke.Transparency = 0.15
frameStroke.Parent = frame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 43)
header.BackgroundColor3 = Color3.fromRGB(17, 94, 89)
header.BorderSizePixel = 0
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 12)
headerCover.Position = UDim2.new(0, 0, 1, -12)
headerCover.BackgroundColor3 = header.BackgroundColor3
headerCover.BorderSizePixel = 0
headerCover.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 21)
title.Position = UDim2.fromOffset(12, 5)
title.BackgroundTransparency = 1
title.Text = "RAEL'S TRICKS"
title.TextColor3 = Color3.fromRGB(240, 253, 250)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -48, 0, 13)
subtitle.Position = UDim2.fromOffset(12, 25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "INDO KOS  •  AUTOMATION V1"
subtitle.TextColor3 = Color3.fromRGB(153, 246, 228)
subtitle.TextSize = 8
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.fromOffset(27, 25)
minimizeButton.Position = UDim2.new(1, -35, 0, 9)
minimizeButton.BackgroundColor3 = Color3.fromRGB(15, 118, 110)
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 15
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = header
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 7)

local miniButton = Instance.new("TextButton")
miniButton.Name = "RaelMiniButton"
miniButton.Size = UDim2.fromOffset(46, 46)
miniButton.Position = UDim2.new(1, -60, 0, 95)
miniButton.BackgroundColor3 = Color3.fromRGB(13, 148, 136)
miniButton.Text = "RT"
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.TextSize = 16
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Active = true
miniButton.Parent = gui
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(153, 246, 228)
miniStroke.Thickness = 1.5
miniStroke.Parent = miniButton

local section = Instance.new("TextLabel")
section.Size = UDim2.new(1, -24, 0, 16)
section.Position = UDim2.fromOffset(12, 49)
section.BackgroundTransparency = 1
section.Text = "FITUR OTOMATIS"
section.TextColor3 = Color3.fromRGB(148, 163, 184)
section.TextSize = 9
section.Font = Enum.Font.GothamBold
section.TextXAlignment = Enum.TextXAlignment.Left
section.Parent = frame

local function makeToggle(name, label, x, y)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.fromOffset(110, 32)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
    b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(248, 250, 252)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Text = label .. ": OFF"
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local cleanButton = makeToggle("CleanButton", "CLEANER", 12, 69)
local farmButton = makeToggle("FarmButton", "AUTO FARM", 130, 69)
local convertButton = makeToggle("ConvertButton", "CONVERT", 12, 108)
local feedButton = makeToggle("FeedButton", "AUTO FEED", 130, 108)
local afkButton = makeToggle("AfkButton", "ANTI-AFK", 12, 147)
local tpButton = makeToggle("TpButton", "TP LOCATION", 130, 147)

local statusPanel = Instance.new("Frame")
statusPanel.Size = UDim2.new(1, -24, 0, 39)
statusPanel.Position = UDim2.fromOffset(12, 190)
statusPanel.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
statusPanel.BorderSizePixel = 0
statusPanel.Parent = frame
Instance.new("UICorner", statusPanel).CornerRadius = UDim.new(0, 7)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -14, 1, -8)
status.Position = UDim2.fromOffset(7, 4)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(253, 230, 138)
status.TextSize = 9
status.Font = Enum.Font.GothamMedium
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Center
status.Parent = statusPanel

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -24, 0, 14)
footer.Position = UDim2.fromOffset(12, 235)
footer.BackgroundTransparency = 1
footer.Text = "RAEL EDITION  •  V1"
footer.TextColor3 = Color3.fromRGB(100, 116, 139)
footer.TextSize = 8
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Parent = frame

local function setStatus(msg)
    if status and status.Parent then
        status.Text = "STATUS: " .. tostring(msg)
    end
end

local function paintToggle(button, label, state)
    button.Text = label .. (state and ": ON" or ": OFF")
    button.BackgroundColor3 = state
        and Color3.fromRGB(5, 150, 105)
        or Color3.fromRGB(127, 29, 29)
end

local function updateButtons()
    paintToggle(cleanButton, "CLEANER", enabled)
    paintToggle(farmButton, "AUTO FARM", autoFarm)
    paintToggle(convertButton, "CONVERT", autoConvert)
    paintToggle(feedButton, "AUTO FEED", autoFeedEnabled)
    paintToggle(afkButton, "ANTI-AFK", antiAfkEnabled)
    paintToggle(tpButton, "TP LOCATION", tpEnabled)
end

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

connect(cleanButton.MouseButton1Click, function()
    if not alive() then return end
    if autoFarm then
        setStatus("CLEANER AKTIF SAAT AUTO FARM BERJALAN")
        return
    end
    enabled = not enabled
    updateButtons()
    setStatus(enabled and "CLEANER AKTIF" or "CLEANER NONAKTIF")
end)

connect(farmButton.MouseButton1Click, function()
    if not alive() then return end
    autoFarm = not autoFarm
    if autoFarm then
        enabled = true
        setStatus("AUTO FARM DIMULAI")
    else
        setStatus("AUTO FARM DIMATIKAN")
    end
    updateButtons()
end)

connect(convertButton.MouseButton1Click, function()
    if not alive() then return end
    autoConvert = not autoConvert
    updateButtons()
    setStatus(autoConvert and "AUTO CONVERT AKTIF" or "AUTO CONVERT NONAKTIF")
end)

connect(feedButton.MouseButton1Click, function()
    if not alive() then return end
    autoFeedEnabled = not autoFeedEnabled
    updateButtons()
    setStatus(autoFeedEnabled and "AUTO FEED AKTIF" or "AUTO FEED NONAKTIF")
end)

connect(afkButton.MouseButton1Click, function()
    if not alive() then return end
    antiAfkEnabled = not antiAfkEnabled
    updateButtons()
    setStatus(antiAfkEnabled and "ANTI-AFK AKTIF" or "ANTI-AFK NONAKTIF")
end)

connect(tpButton.MouseButton1Click, function()
    if not alive() then return end
    tpEnabled = not tpEnabled
    updateButtons()
    setStatus(tpEnabled and "TP LOCATION AKTIF" or "TP LOCATION NONAKTIF")
end)

updateButtons()

]==]

replaceBetween(
    "-- ==========================================\n-- GUI\n-- ==========================================",
    "-- ==========================================\n-- AUTO CLEANER TARGET",
    guiCode,
    "MODERN GUI"
)

-- SISIPKAN AUTO CONVERT SEBELUM AUTO CLEANER LOOP
replaceOnce(
    "-- ==========================================\n-- AUTO CLEANER LOOP",
    convertCode .. "\n\n-- ==========================================\n-- AUTO CLEANER LOOP",
    "AUTO CONVERT INSERT"
)

-- CLEANER BERHENTI SEMENTARA SAAT CONVERT
replaceOnce(
    "if not enabled or busy then",
    "if not enabled or busy or converting then",
    "CLEANER CONVERT GUARD"
)

-- AUTO FARM OTOMATIS CONVERT SAAT KOTORAN PENUH
replaceOnce(
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end",
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end\n\n        if converting then\n            continue\n        end\n\n        if autoConvert and isManureFull() then\n            runAutoConvert()\n            continue\n        end",
    "AUTO FARM CONVERT TRIGGER"
)

-- TOGGLE AUTO FEED
replaceOnce(
    "local function feedOne()\n    local feeders = getFeeders()",
    "local function feedOne()\n    if not autoFeedEnabled then return false end\n    local feeders = getFeeders()",
    "AUTO FEED TOGGLE"
)

-- TOGGLE ANTI-AFK
replaceOnce(
    "connect(player.Idled, function()\n    if not alive() then return end",
    "connect(player.Idled, function()\n    if not alive() or not antiAfkEnabled then return end",
    "ANTI-AFK TOGGLE"
)

-- TOGGLE TP LOCATION
replaceOnce(
    "if not alive() or not tpEquipped or processed then",
    "if not alive() or not tpEnabled or not tpEquipped or processed then",
    "TP LOCATION TOGGLE"
)

-- UBAH LABEL VERSI
source = source:gsub("V18%.2", "V1")
source = source:gsub("V18%.3", "V1")

local compiled, compileError = loadstring(source)

if not compiled then
    error("RAEL V1 COMPILE ERROR: " .. tostring(compileError))
end

compiled()
