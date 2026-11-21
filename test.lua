-- RAEL'S TRICKS - TEST
-- Salinan jalur eksekusi main.lua + dua patch Homework.
-- main.lua dan main_obfuscated.lua tidak diubah.

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

local function gachaCall(methodName, ...)
    local args = table.pack(...)
    local ok, requestOK, result = pcall(function()
        local svc = getGachaService()
        local method = svc[methodName]
        if type(method) ~= "function" then
            error("METHOD TIDAK DITEMUKAN: " .. methodName)
        end
        return method(svc, table.unpack(args, 1, args.n)):await()
    end)
    if not ok then return false, tostring(requestOK) end
    if not requestOK then return false, result or "PROMISE GAGAL" end
    return true, result
end

-- Callback asli BlindBox meneruskan indeks urutan 1..N.
local function gachaClaimMulti(results)
    if type(results) ~= "table" or #results == 0 then
        setStatus("GACHA: DAFTAR HASIL X10 KOSONG")
        return false
    end
    for i = 1, #results do
        setStatus("GACHA: KLAIM HADIAH " .. i .. "/" .. #results)
        local claimOK = gachaCall("ClaimOneMultiReward", i)
        if not claimOK then
            setStatus("GACHA: KLAIM GAGAL " .. i .. "/" .. #results)
            return false
        end
        task.wait(0.35)
    end
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
        if not spinOK or type(result) ~= "table" or not result.ok then
            setStatus("GACHA: FREE X10 GAGAL")
            return false
        end
        return gachaClaimMulti(result.results)
    elseif free > 0 then
        setStatus("GACHA: FREE SPIN 1X")
        local spinOK, result = gachaCall("Spin")
        if not spinOK or type(result) ~= "table" or not result.ok then
            setStatus("GACHA: FREE SPIN GAGAL")
            return false
        end
        local claimOK = gachaCall("ClaimReward")
        if not claimOK then
            setStatus("GACHA: KLAIM FREE SPIN GAGAL")
            return false
        end
        return true
    elseif gachaPaidEnabled then
        setStatus("GACHA: PAID X10")
        local spinOK, result = gachaCall("SpinX10WithMoney")
        if not spinOK or type(result) ~= "table" or not result.ok then
            setStatus("GACHA: PAID X10 GAGAL")
            return false
        end
        return gachaClaimMulti(result.results)
    else
        setStatus("GACHA: MENUNGGU FREE SPIN (PAID OFF)")
        return nil
    end
end
]=]

source = raelReplaceBetween(
    source,
    "local function getGachaService()",
    "local function gachaWorker()",
    raelGachaNative
)

]==]

wrapper = wrapper:sub(1, at - 1) .. patch .. "\n" .. wrapper:sub(at)

local chunk, compileError = loadstring(wrapper)
assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
chunk()
