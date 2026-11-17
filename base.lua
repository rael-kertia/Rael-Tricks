-- ==========================================
-- RAEL'S TRICKS V18.3 FULL
-- V18.2 + AUTO CONVERT KOTORAN 2000
-- AUTO CLAIM GOLD FIX
-- ==========================================

local URL = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(source) ~= "string" or #source < 1000 then
    warn("RAEL V18.3: GAGAL MENGAMBIL MAIN.LUA")
    return
end

local function replaceOnce(old, new, label)
    local first, last = source:find(old, 1, true)
    if not first then
        error("V18.3 GAGAL: BAGIAN TIDAK DITEMUKAN - " .. label)
    end
    source = source:sub(1, first - 1) .. new .. source:sub(last + 1)
end

-- ==========================================
-- AUTO CONVERT SYSTEM
-- ==========================================

local convertCode = [==[
-- ==========================================
-- AUTO CONVERT KOTORAN
-- ==========================================

local autoConvert = true
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

-- FIX KLIK MASUK DAN KLAIM
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

    setStatus("MEMASUKKAN 2000 KOTORAN")

    local beforeGold = readGoldValue(ui)

    if not clickConvertButton(ui.masuk) then
        finish("TOMBOL MASUK GAGAL")
        return false
    end

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

    start = os.clock()

    while alive() and autoFarm
    and os.clock() - start < 12 do
        task.wait(0.5)

        local count = getManureCount()

        if count == nil or count < CONVERT_LIMIT then
            finish("CONVERT BERHASIL - FARM LANJUT")
            return true
        end
    end

    finish("KLAIM BELUM TERKONFIRMASI")
    return false
end
]==]

replaceOnce(
    "-- ==========================================\n-- AUTO CLEANER LOOP",
    convertCode .. "\n\n-- ==========================================\n-- AUTO CLEANER LOOP",
    "AUTO CONVERT INSERT"
)

replaceOnce(
    "if not enabled or busy then",
    "if not enabled or busy or converting then",
    "CLEANER CONVERT GUARD"
)

replaceOnce(
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end",
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end\n\n        if converting then\n            continue\n        end\n\n        if autoConvert and isManureFull() then\n            runAutoConvert()\n            continue\n        end",
    "AUTO FARM CONVERT TRIGGER"
)

source = source:gsub("V18%.2", "V18.3")

local compiled, compileError = loadstring(source)

if not compiled then
    error("RAEL V18.3 COMPILE ERROR: " .. tostring(compileError))
end

compiled()
