-- RAEL'S TRICKS - MAIN
-- Bootstrap diagnostik: tampilkan status di layar, bukan console Delta.

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local oldDiagnostic = playerGui:FindFirstChild("RaelLoaderDiagnostic")
if oldDiagnostic then oldDiagnostic:Destroy() end

local diagnosticGui = Instance.new("ScreenGui")
diagnosticGui.Name = "RaelLoaderDiagnostic"
diagnosticGui.ResetOnSpawn = false
diagnosticGui.DisplayOrder = 10000
diagnosticGui.Parent = playerGui

local diagnosticLabel = Instance.new("TextLabel")
diagnosticLabel.Size = UDim2.fromOffset(310, 42)
diagnosticLabel.Position = UDim2.new(0.5, -155, 0, 18)
diagnosticLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
diagnosticLabel.TextColor3 = Color3.new(1, 1, 1)
diagnosticLabel.TextSize = 12
diagnosticLabel.Font = Enum.Font.GothamBold
diagnosticLabel.TextWrapped = true
diagnosticLabel.Text = "RAEL LOADER: MEMULAI"
diagnosticLabel.Parent = diagnosticGui
Instance.new("UICorner", diagnosticLabel).CornerRadius = UDim.new(0, 8)

local function diagnosticStatus(message, failed)
    diagnosticLabel.Text = "RAEL LOADER: " .. tostring(message)
    diagnosticLabel.BackgroundColor3 = failed
        and Color3.fromRGB(150, 35, 35)
        or Color3.fromRGB(30, 90, 65)
end

local function bootRaelTricks()
diagnosticStatus("MENGAMBIL CORE...", false)

local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/3390f91726acc5f4069a7bc8f0b15a89ef09937c/main_obfuscated.lua"
local response = game:HttpGet(url)
assert(type(response) == "string" and #response > 1000, "Gagal mengambil core Rael's Tricks")

local encoded = response:match("local encoded = %[%[(.-)%]%]")
assert(encoded, "Data core tidak ditemukan")
encoded = encoded:gsub("%s", "")

local decoded = {}
for i = 1, #encoded, 2 do
    local byte = tonumber(encoded:sub(i, i + 1), 16)
    assert(byte, "Data core rusak")
    decoded[#decoded + 1] = string.char((byte - 97) % 256)
end
local wrapper = table.concat(decoded)
diagnosticStatus("CORE TERUNDUH - MENYIAPKAN PATCH...", false)

-- Patch dilakukan setelah seluruh patch asli CORE RESTORE,
-- tepat sebelum core asli di-compile dan dijalankan.
local marker = "local compiled, compileError = loadstring(source)"
local at = wrapper:find(marker, 1, true)
assert(at, "Titik patch core tidak ditemukan")

local patch = [==[
local function raelReplaceBetween(text, firstMarker, nextMarker, replacement)
    local a = text:find(firstMarker, 1, true)
    if not a then error("Rael patch: marker awal tidak ditemukan: " .. firstMarker) end
    local b = text:find(nextMarker, a + #firstMarker, true)
    if not b then error("Rael patch: marker akhir tidak ditemukan: " .. nextMarker) end
    return text:sub(1, a - 1) .. replacement .. "\n\n" .. text:sub(b)
end

-- PERBAIKAN 1:
-- Satu rumah bisa memiliki banyak TrashBag. Scan seluruh descendants,
-- bukan hanya prompt yang menjadi child langsung dari part TrashBag.
local raelHwGet = [=[
local function hwGet(house, mode)
    local result = {}
    local seen = {}
    if not house then return result end

    for _, object in ipairs(house:GetDescendants()) do
        if (mode == 1 or mode == 3)
        and object:IsA("ProximityPrompt")
        and object.ActionText == "Bersihkan"
        and (mode == 3 or object.Enabled)
        and not seen[object] then
            seen[object] = true
            table.insert(result, object)

        elseif (mode == 2 or mode == 4)
        and object.Name == "TrashBag" then
            if object:IsA("ProximityPrompt") then
                if (mode == 4 or object.Enabled) and not seen[object] then
                    seen[object] = true
                    table.insert(result, object)
                end
            end

            for _, prompt in ipairs(object:GetDescendants()) do
                if prompt:IsA("ProximityPrompt")
                and prompt.Name == "AmbilPrompt"
                and (mode == 4 or prompt.Enabled)
                and not seen[prompt] then
                    seen[prompt] = true
                    table.insert(result, prompt)
                end
            end
        end
    end
    return result
end
]=]

source = raelReplaceBetween(
    source,
    "local function hwGet(house, mode)",
    "local function hwFindHouse()",
    raelHwGet
)

-- Rumah yang masih memiliki TrashBag aktif juga harus bisa dipilih,
-- termasuk ketika prompt Bersihkan rumah tersebut sedang cooldown.
local raelHwFindHouse = [=[
local function hwFindHouse()
    local folder = W:FindFirstChild("KosanSpawned")
    local r = hwRoot()
    if not folder or not r then return nil end

    local best, bd
    for _, house in ipairs(folder:GetChildren()) do
        if hwOwnsHouse(house) then
            local prompts = hwGet(house, 1)
            for _, p in ipairs(hwGet(house, 2)) do
                table.insert(prompts, p)
            end

            for _, p in ipairs(prompts) do
                local q = hwPart(p)
                if q then
                    local d = (r.Position - q.Position).Magnitude
                    if not bd or d < bd then
                        best, bd = house, d
                    end
                end
            end
        end
    end
    return best
end
]=]

source = raelReplaceBetween(
    source,
    "local function hwFindHouse()",
    "local function homeworkRun()",
    raelHwFindHouse
)

-- HOMEWORK: lepaskan rumah yang menunggu cooldown agar scan bisa memilih rumah lain.
-- Rumah baru dinyatakan selesai setelah tidak ada prompt Bersihkan, prompt TrashBag,
-- atau muatan selama tiga pemeriksaan berurutan. Progress GUI global tidak menjadi kunci.
local raelHomeworkWait = [=[
                    local remainingClean = #hwGet(house, 3)
                    local remainingBags = #hwGet(house, 4)

                    -- Prompt disabled menandakan rumah masih cooldown/update.
                    -- Keluar dari rumah ini agar loop luar dapat scan rumah lain.
                    if remainingClean > 0 or remainingBags > 0 then
                        quiet = 0
                        if remainingClean > 0 then
                            setStatus("HOMEWORK: RUMAH COOLDOWN - SCAN ULANG")
                        else
                            setStatus("HOMEWORK: MENUNGGU UPDATE SAMPAH")
                        end
                        break
                    end

                    if hadTrash then
                        quiet += 1
                        if quiet >= 3 then
                            break
                        end
                        setStatus("HOMEWORK: VERIFIKASI RUMAH KOSONG")
                    else
                        quiet += 1
                        if quiet >= 5 then
                            setStatus("RUMAH BELUM MEMUNCULKAN SAMPAH - SCAN ULANG")
                            break
                        end
                        setStatus("HOMEWORK: MENUNGGU SAMPAH MUNCUL")
                    end
                    task.wait(1)
]=]

source = raelReplaceBetween(
    source,
    "                    -- Hanya anggap selesai setelah sampah pernah muncul",
    "                end\n            end\n        end\n\n        if not alive() or not homeworkEnabled then break end",
    raelHomeworkWait
)


-- GACHA: gunakan tombol native game agar GachaController sendiri yang
-- menjalankan Spin, reveal BlindBox, dan seluruh proses klaim hadiah.
local raelGachaNative = [=[
local gachaService
local function getGachaService()
    if gachaService then return gachaService end
    local rs = game:GetService("ReplicatedStorage")
    local nk = rs:WaitForChild("NKSystem", 15)
    if not nk then error("NKSystem tidak ditemukan") end
    local packages = nk:WaitForChild("Packages", 15)
    if not packages then error("Packages tidak ditemukan") end
    local knitModule = packages:WaitForChild("Knit", 15)
    if not knitModule then error("Knit tidak ditemukan") end
    local Knit = require(knitModule)
    gachaService = Knit.GetService("GachaService")
    if not gachaService then error("GachaService tidak ditemukan") end
    return gachaService
end

-- Semua pemanggilan menunggu Promise selesai. Tidak ada retry otomatis.
local function gachaCall(methodName, ...)
    local args = table.pack(...)
    local ok, requestOK, result = pcall(function()
        local svc = getGachaService()
        local method = svc[methodName]
        if type(method) ~= "function" then
            error("METHOD TIDAK DITEMUKAN: " .. methodName)
        end
        local promise = method(svc, table.unpack(args, 1, args.n))
        if not promise or type(promise.await) ~= "function" then
            error("RESPONS PROMISE TIDAK VALID: " .. methodName)
        end
        return promise:await()
    end)

    if not ok then return false, tostring(requestOK) end
    if requestOK ~= true then
        return false, result or ("SERVER MENOLAK: " .. methodName)
    end
    return true, result
end

-- X10 = satu spin server, lalu klaim tiap indeks secara berurutan.
-- Jika satu klaim gagal, hentikan; jangan ulangi indeks yang sama.
local function gachaClaimMulti(results)
    if type(results) ~= "table" then
        setStatus("GACHA: HASIL X10 TIDAK VALID")
        return false
    end

    local count = #results
    if count ~= 10 then
        setStatus("GACHA: JUMLAH HASIL TIDAK 10 (" .. count .. ")")
        return false
    end

    for i = 1, count do
        if results[i] == nil then
            setStatus("GACHA: HASIL KE-" .. i .. " KOSONG")
            return false
        end

        setStatus("GACHA: KLAIM HADIAH " .. i .. "/10")
        local claimOK, claimResult = gachaCall("ClaimOneMultiReward", i)
        if not claimOK then
            setStatus("GACHA: KLAIM GAGAL " .. i .. "/10 - " .. tostring(claimResult))
            return false
        end

        -- Jeda presentasi tanpa animasi: mengikuti fase buka X10 di BlindBoxTampil.
        -- Durasi reveal terukur: 0.75 + 0.55 + 0.50 + 0.45 + 1.60 + 0.30 = 4.15 detik.
        -- Ini hanya pacing lokal; bukan perlindungan atau jaminan anti-detection.
        if i < count then
            task.wait(4.15)
        end
    end

    setStatus("GACHA: 10 KLAIM SELESAI")
    return true
end

local function gachaCycle()
    setStatus("GACHA: MEMBACA STATE")
    local stateOK, state = gachaCall("GetState")
    if not stateOK or type(state) ~= "table" then
        setStatus("GACHA: GAGAL MEMBACA STATE")
        return false
    end

    local free = tonumber(state.free) or 0
    if free >= 10 then
        setStatus("GACHA: FREE X10")
        local spinOK, result = gachaCall("SpinX10WithFree")
        if not spinOK or type(result) ~= "table" or result.ok ~= true then
            setStatus("GACHA: FREE X10 GAGAL")
            return false
        end
        return gachaClaimMulti(result.results)

    elseif free > 0 then
        setStatus("GACHA: FREE SPIN 1X")
        local spinOK, result = gachaCall("Spin")
        if not spinOK or type(result) ~= "table" or result.ok ~= true then
            setStatus("GACHA: FREE SPIN GAGAL")
            return false
        end

        local claimOK, claimResult = gachaCall("ClaimReward")
        if not claimOK then
            setStatus("GACHA: KLAIM FREE SPIN GAGAL - " .. tostring(claimResult))
            return false
        end
        setStatus("GACHA: FREE SPIN SELESAI")
        return true

    elseif gachaPaidEnabled then
        setStatus("GACHA: PAID X10")
        local spinOK, result = gachaCall("SpinX10WithMoney")
        if not spinOK or type(result) ~= "table" or result.ok ~= true then
            setStatus("GACHA: PAID X10 GAGAL")
            return false
        end
        return gachaClaimMulti(result.results)

    else
        setStatus("GACHA: MENUNGGU FREE SPIN (PAID OFF)")
        return nil
    end
end]=]

source = raelReplaceBetween(
    source,
    "local function getGachaService()",
    "local function gachaWorker()",
    raelGachaNative
)

-- HILANGKAN HANYA STATUS AUTO ACC.
-- Ganti empat pemanggilan spesifik; jangan scan seluruh source karena
-- wrapper menambahkan patch fitur lain setelah blok Auto Acc.
local autoAccStart = source:find("-- AUTO ACC - TERINTEGRASI KE RAEL'S TRICKS", 1, true)
assert(autoAccStart, "Blok Auto Acc tidak ditemukan")

local function raelReplaceOnce(text, oldText, newText, label)
    local a, b = text:find(oldText, 1, true)
    assert(a, "Status Auto Acc tidak ditemukan: " .. label)
    assert(not text:find(oldText, b + 1, true), "Status Auto Acc ganda: " .. label)
    return text:sub(1, a - 1) .. newText .. text:sub(b + 1)
end

local autoAccMarker = "local autoAccLast = {}"
local markerAt = source:find(autoAccMarker, autoAccStart, true)
assert(markerAt, "Titik patch Auto Acc tidak ditemukan")
source = source:sub(1, markerAt + #autoAccMarker - 1)
    .. "\nlocal function setAutoAccStatus(_) end"
    .. source:sub(markerAt + #autoAccMarker)

source = raelReplaceOnce(source,
    'setStatus(enabled and "AUTO ACC AKTIF - MENUNGGU PERMINTAAN"\n        or "AUTO ACC NONAKTIF")',
    'setAutoAccStatus(enabled and "AUTO ACC AKTIF - MENUNGGU PERMINTAAN"\n        or "AUTO ACC NONAKTIF")',
    "toggle")
source = raelReplaceOnce(source,
    'setStatus("AUTO ACC: " .. item.card.Name\n                        .. " | " .. #cards .. " popup")',
    'setAutoAccStatus("AUTO ACC: " .. item.card.Name\n                        .. " | " .. #cards .. " popup")',
    "popup ditemukan")
source = raelReplaceOnce(source,
    'setStatus(gone and "AUTO ACC: popup diproses; scan ulang"\n                        or "AUTO ACC: popup belum hilang; coba ulang")',
    'setAutoAccStatus(gone and "AUTO ACC: popup diproses; scan ulang"\n                        or "AUTO ACC: popup belum hilang; coba ulang")',
    "hasil klik")
source = raelReplaceOnce(source,
    'setStatus("AUTO ACC: menunggu permintaan")',
    'setAutoAccStatus("AUTO ACC: menunggu permintaan")',
    "menunggu")

-- ==========================================
-- ==========================================
-- LAYOUT PATCH - STRICT MATCH (WAJIB BERHASIL)
-- ==========================================

local function raelReplaceLineStrict(text, prefix, newLine, label)
    local a = text:find(prefix, 1, true)
    assert(a, "LAYOUT PATCH GAGAL: baris tidak ditemukan: " .. label)
    local e = text:find("\n", a, true) or (#text + 1)
    assert(not text:find(prefix, e + 1, true),
        "LAYOUT PATCH GAGAL: baris duplikat: " .. label)
    return text:sub(1, a - 1) .. newLine .. text:sub(e)
end

-- Perbaiki glyph minimize yang sebelumnya berupa karakter kontrol (kotak).
source = raelReplaceLineStrict(
    source, "minimizeButton.Text = ",
    'minimizeButton.Text = "-"',
    "MINIMIZE TEXT"
)

-- Semua posisi diatur eksplisit dan setiap perubahan wajib terkonfirmasi.
source = raelReplaceLineStrict(
    source, "statusPanel.Position = ",
    "statusPanel.Position = UDim2.fromOffset(12, 178)",
    "STATUS PANEL"
)
source = raelReplaceLineStrict(
    source, "autoAccButton.Position = ",
    "autoAccButton.Position = UDim2.fromOffset(12, 226)",
    "AUTO ACC"
)
source = raelReplaceLineStrict(
    source, "gachaButton.Position = ",
    "gachaButton.Position = UDim2.fromOffset(12, 263)",
    "AUTO GACHA"
)
source = raelReplaceLineStrict(
    source, "gachaPaidButton.Position = ",
    "gachaPaidButton.Position = UDim2.fromOffset(12, 298)",
    "PAID GACHA"
)
source = raelReplaceLineStrict(
    source, "frame.Size = UDim2.fromOffset(252, 340)",
    "frame.Size = UDim2.fromOffset(252, 340)",
    "FRAME HEIGHT"
)

-- Urutan ZIndex eksplisit agar tombol minimize selalu berada di atas header.
source = raelReplaceLineStrict(
    source, "header.Name = \"Header\"",
    'header.Name = "Header"\nheader.ZIndex = 5',
    "HEADER ZINDEX"
)
source = raelReplaceLineStrict(
    source, 'title.Text = "RAEL\'S TRICKS"',
    'title.Text = "RAEL\'S TRICKS"\ntitle.ZIndex = 6',
    "TITLE ZINDEX"
)
source = raelReplaceLineStrict(
    source, "minimizeButton.Name = \"MinimizeButton\"",
    'minimizeButton.Name = "MinimizeButton"\nminimizeButton.ZIndex = 20\nminimizeButton.Active = true\nminimizeButton.AutoButtonColor = true',
    "MINIMIZE ZINDEX"
)
source = raelReplaceLineStrict(
    source, "miniButton.Name = \"RaelMiniButton\"",
    'miniButton.Name = "RaelMiniButton"\nminiButton.ZIndex = 30\nminiButton.Active = true\nminiButton.AutoButtonColor = true',
    "REOPEN ZINDEX"
)

-- Pastikan event minimize dan reopen terpasang tepat satu kali.
local minimizeEvent = 'connect(minimizeButton.Activated, function() frame.Visible = false miniButton.Visible = true end)'
local reopenEvent = 'connect(miniButton.Activated, function() miniButton.Visible = false frame.Visible = true end)'
assert(source:find(minimizeEvent, 1, true), "MINIMIZE EVENT TIDAK DITEMUKAN")
assert(source:find(reopenEvent, 1, true), "REOPEN EVENT TIDAK DITEMUKAN")

-- AUTO JAM AJAIB: ditambahkan ke source core, bukan loader terpisah.
source = source .. [====[

-- ==========================================
-- AUTO JAM AJAIB - RAEL'S TRICKS
-- Loop scan | sekali per rumah per sesi
-- >20 menit | <=220 stud | posisi pemain tetap
-- ==========================================

local jamAutoEnabled = false
local jamBusy = false
local jamProcessed = setmetatable({}, {__mode = "k"})
local jamService

local jamButton = Instance.new("TextButton")
jamButton.Name = "AutoJamAjaibButton"
jamButton.Size = UDim2.fromOffset(180, 29)
jamButton.Position = UDim2.fromOffset(12, 138)
jamButton.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
jamButton.BorderSizePixel = 0
jamButton.Text = "AUTO JAM AJAIB: OFF"
jamButton.TextColor3 = Color3.new(1, 1, 1)
jamButton.TextSize = 10
jamButton.Font = Enum.Font.GothamBold
jamButton.Parent = frame
Instance.new("UICorner", jamButton).CornerRadius = UDim.new(0, 6)

local function paintJamButton()
    jamButton.Text = jamAutoEnabled and "AUTO JAM AJAIB: ON" or "AUTO JAM AJAIB: OFF"
    jamButton.BackgroundColor3 = jamAutoEnabled
        and Color3.fromRGB(5, 150, 105)
        or Color3.fromRGB(127, 29, 29)
end

local function getJamTool()
    local char = player.Character
    local bag = player:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({char, bag}) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") and obj:GetAttribute("JamAjaib") then
                    return obj
                end
            end
        end
    end
end

local function jamRentedCount(house)
    local count = 0
    if house:GetAttribute("KosanState") == "Disewa" then
        count += 1
    end
    for _, child in ipairs(house:GetChildren()) do
        if child:IsA("Model")
        and child:GetAttribute("KosanState") == "Disewa" then
            count += 1
        end
    end
    return count
end

local function jamRemaining(house)
    local endsAt = house:GetAttribute("RentEndsAt")
    if typeof(endsAt) ~= "number" then return -1 end
    return endsAt - time()
end

local function jamDistance(house)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return math.huge end
    local ok, cf = pcall(function()
        return house:GetBoundingBox()
    end)
    if not ok then return math.huge end
    return (root.Position - cf.Position).Magnitude
end

local function getJamService()
    if jamService then return jamService end
    local rs = game:GetService("ReplicatedStorage")
    local nk = rs:WaitForChild("NKSystem", 15)
    if not nk then error("NKSystem tidak ditemukan") end
    local packages = nk:WaitForChild("Packages", 15)
    if not packages then error("Packages tidak ditemukan") end
    local knitFolder = packages:WaitForChild("Knit", 15)
    if not knitFolder then error("Knit tidak ditemukan") end
    local knitModule = knitFolder:WaitForChild("KnitClient", 15)
    if not knitModule then error("KnitClient tidak ditemukan") end
    local Knit = require(knitModule)
    jamService = Knit.GetService("JamAjaibService")
    if not jamService then error("JamAjaibService tidak ditemukan") end
    return jamService
end

local function jamFire(house)
    local completed, response, failure = false, nil, nil
    local ok, promise = pcall(function()
        return getJamService():Tembak(house)
    end)
    if not ok or not promise then
        return false, "PEMANGGILAN SERVICE GAGAL: " .. tostring(promise)
    end

    local chainOK, chainError = pcall(function()
        promise:andThen(function(result)
            response = result
            completed = true
        end):catch(function(reason)
            failure = reason
            completed = true
        end)
    end)
    if not chainOK then
        return false, "PEMANTAUAN PROMISE GAGAL: " .. tostring(chainError)
    end

    local deadline = os.clock() + 12
    repeat
        task.wait(0.1)
    until completed or os.clock() >= deadline

    if not completed then return false, "RESPONS SERVER TIMEOUT" end
    if failure then return false, tostring(failure) end
    if not response or response.ok ~= true then
        return false, "DITOLAK SERVER"
    end
    return true, response
end

local function jamWorker()
    if jamBusy then return end
    jamBusy = true

    while alive() and jamAutoEnabled do
        local folder = W:FindFirstChild("KosanSpawned")
        local tool = getJamTool()

        if not folder then
            setStatus("JAM AJAIB: KOSANSPAWNED TIDAK DITEMUKAN")
            task.wait(4)
            continue
        end

        if not tool then
            setStatus("JAM AJAIB: TOOL TIDAK DITEMUKAN")
            task.wait(4)
            continue
        end

        if tool.Parent ~= player.Character then
            setStatus("JAM AJAIB: EQUIP TOOL TERLEBIH DAHULU")
            task.wait(3)
            continue
        end

        local stock = tool:GetAttribute("Count")
        if typeof(stock) ~= "number" or stock <= 0 then
            setStatus("JAM AJAIB: STOK HABIS / TIDAK TERBACA")
            jamAutoEnabled = false
            paintJamButton()
            break
        end

        local targets = {}
        for _, house in ipairs(folder:GetChildren()) do
            if house:IsA("Model")
            and not jamProcessed[house]
            and house:GetAttribute("OwnerUserId") == player.UserId
            and jamRentedCount(house) > 0
            and jamRemaining(house) > 1200 then
                targets[#targets + 1] = house
            end
        end

        table.sort(targets, function(a, b)
            return jamRemaining(a) > jamRemaining(b)
        end)

        local firedThisPass = 0

        for _, house in ipairs(targets) do
            if not alive() or not jamAutoEnabled then break end

            tool = getJamTool()
            if not tool or tool.Parent ~= player.Character then
                setStatus("JAM AJAIB: TOOL TIDAK DIPEGANG")
                break
            end

            stock = tool:GetAttribute("Count")
            if typeof(stock) ~= "number" or stock <= 0 then
                setStatus("JAM AJAIB: STOK HABIS")
                jamAutoEnabled = false
                paintJamButton()
                break
            end

            -- Validasi ulang tepat sebelum setiap tembakan.
            if house.Parent ~= folder
            or house:GetAttribute("OwnerUserId") ~= player.UserId
            or jamRentedCount(house) <= 0 then
                setStatus("JAM AJAIB: TARGET BERUBAH - DILEWATI")
                continue
            end

            local seconds = jamRemaining(house)
            if seconds <= 1200 then
                setStatus("JAM AJAIB: SISA WAKTU <= 20 MENIT")
                continue
            end

            local distance = jamDistance(house)
            if distance > 220 then
                setStatus("JAM AJAIB: " .. house.Name .. " TERLALU JAUH")
                continue
            end

            setStatus(string.format(
                "JAM AJAIB: TEMBAK %s | %.1f MENIT",
                house.Name, seconds / 60
            ))

            local shotOK, result = jamFire(house)
            if not shotOK then
                setStatus("JAM AJAIB BERHENTI: " .. tostring(result))
                jamAutoEnabled = false
                paintJamButton()
                break
            end

            jamProcessed[house] = true
            firedThisPass += 1
            task.wait(0.15)

            local afterTool = getJamTool()
            local afterStock = afterTool and afterTool:GetAttribute("Count")
            setStatus(string.format(
                "JAM AJAIB: BERHASIL %s | STOK %s -> %s",
                house.Name, tostring(stock), tostring(afterStock)
            ))

            task.wait(2.7)
        end

        if jamAutoEnabled and alive() then
            if firedThisPass == 0 then
                setStatus("JAM AJAIB: SCAN ULANG | TUNGGU TARGET")
            else
                setStatus("JAM AJAIB: PASS SELESAI | " .. firedThisPass .. " RUMAH")
            end
            task.wait(5)
        end
    end

    jamBusy = false
    if alive() and not jamAutoEnabled then
        setStatus("AUTO JAM AJAIB NONAKTIF")
    end
end

connect(jamButton.Activated, function()
    if not alive() then return end
    jamAutoEnabled = not jamAutoEnabled
    paintJamButton()

    if jamAutoEnabled then
        setStatus("AUTO JAM AJAIB DIMULAI")
        task.spawn(jamWorker)
    else
        setStatus("AUTO JAM AJAIB DIMATIKAN")
    end
end)

paintJamButton()

]====]

]==]

wrapper = wrapper:sub(1, at - 1) .. patch .. "\n" .. wrapper:sub(at)

diagnosticStatus("MENG-COMPILE WRAPPER...", false)
local chunk, compileError = loadstring(wrapper)
assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
diagnosticStatus("MENJALANKAN CORE...", false)
chunk()
end

local bootOK, bootError = pcall(bootRaelTricks)
if bootOK then
    diagnosticStatus("CORE BERHASIL DIEKSEKUSI", false)
else
    diagnosticStatus("GAGAL: " .. tostring(bootError):sub(1, 180), true)
end
