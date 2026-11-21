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


-- PERBAIKAN 2:
-- Free tetap 1x per siklus; Paid menggunakan X10.
-- Parameter hasil wajib diteruskan ke ClaimOneMultiReward.
local raelGachaFunctions = [=[
local function gachaCall(methodName, argument)
    local ok, a, b = pcall(function()
        local svc = getGachaService()
        local method = svc[methodName]
        if type(method) ~= "function" then
            error("METHOD TIDAK DITEMUKAN: " .. methodName)
        end
        return method(svc, argument):await()
    end)
    if not ok then return false, tostring(a) end
    if not a then return false, b or "PROMISE GAGAL" end
    return true, b
end

local function gachaClaimSingle()
    local ok = gachaCall("ClaimReward")
    if not ok then setStatus("GACHA: KLAIM GAGAL") end
    return ok
end

local function gachaClaimMulti(results)
    for i = 1, #results do
        local ok = gachaCall("ClaimOneMultiReward", results[i])
        if not ok then
            setStatus("GACHA: KLAIM X10 GAGAL " .. i .. "/" .. #results)
            return false
        end
        task.wait(0.25)
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
    local spinOK, result

    if free > 0 then
        setStatus("GACHA: FREE SPIN 1X")
        spinOK, result = gachaCall("Spin")
        if spinOK and type(result) == "table" and result.ok then
            if result.granted ~= false then gachaClaimSingle() end
        else
            spinOK = false
        end
    elseif gachaPaidEnabled then
        setStatus("GACHA: PAID SPIN X10")
        spinOK, result = gachaCall("SpinX10WithMoney")
        if spinOK and type(result) == "table" and result.ok then
            local results = result.results or {}
            if #results > 0 then
                gachaClaimMulti(results)
            end
        else
            spinOK = false
        end
    else
        setStatus("GACHA: MENUNGGU FREE SPIN (PAID OFF)")
        return nil
    end

    if spinOK then
        setStatus("GACHA: SPIN SELESAI - FREE " .. free)
        return true
    end
    setStatus("GACHA: SPIN GAGAL / COBA LAGI")
    return false
end
]=]

source = raelReplaceBetween(
    source,
    "local function gachaCall(methodName)",
    "local function gachaWorker()",
    raelGachaFunctions
)

-- HomeworkRun asli dipertahankan agar tidak mengubah alur inti.

]==]

wrapper = wrapper:sub(1, at - 1) .. patch .. "\n" .. wrapper:sub(at)

local chunk, compileError = loadstring(wrapper)
assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
chunk()
