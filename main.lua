-- RAEL'S TRICKS - MAIN
-- Jalur produksi: core dengan patch Homework dan Gacha yang telah diuji.

local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main_obfuscated.lua"
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

-- HomeworkRun asli dipertahankan agar tidak mengubah alur inti.

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

-- Sembunyikan hanya status Auto Acc; status fitur lain tetap normal.
local raelStatusMarker = [=[local function setStatus(msg)
    if status and status.Parent then
        status.Text = "Status: " .. msg
    end
end]=]
local raelStatusReplacement = [=[local function setStatus(msg)
    if type(msg) == "string" and msg:match("^AUTO ACC") then
        return
    end
    if status and status.Parent then
        status.Text = "Status: " .. msg
    end
end]=]
local raelStatusAt = source:find(raelStatusMarker, 1, true)
assert(raelStatusAt, "Status function marker tidak ditemukan")
assert(not source:find(raelStatusMarker, raelStatusAt + #raelStatusMarker, true),
    "Status function marker ditemukan lebih dari sekali")
source = source:sub(1, raelStatusAt - 1)
    .. raelStatusReplacement
    .. source:sub(raelStatusAt + #raelStatusMarker)

]==]

wrapper = wrapper:sub(1, at - 1) .. patch .. "\n" .. wrapper:sub(at)

local chunk, compileError = loadstring(wrapper)
assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
chunk()
