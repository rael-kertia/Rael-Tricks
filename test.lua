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
-- Setelah satu muatan dibuang, loop Homework tetap mengunci rumah yang
-- sama dan scan ulang TrashBag sampai benar-benar habis. Jangan pindah
-- rumah hanya karena batch pertama (maksimal 6 item) sudah dibuang.
local raelHomeworkRun = [=[
local function homeworkRun()
    if homeworkBusy then return end
    homeworkBusy = true

    task.spawn(function()
        while alive() and homeworkEnabled do
            pcall(hwForceStand)
            task.wait(0.25)
        end
    end)

    while alive() and homeworkEnabled do
        local folder = W:FindFirstChild("KosanSpawned")
        if not folder then
            setStatus("MENUNGGU KOSANSPAWNED")
            task.wait(2)
            continue
        end

        if hwCarrying() then
            local disposalHouse = hwNearestOwnedHouse()
            if disposalHouse then
                setStatus("MUATAN VIP - MEMBUANG")
                if not hwDispose(disposalHouse) then task.wait(1) end
            else
                setStatus("MUATAN VIP - RUMAH SENDIRI TIDAK DITEMUKAN")
                task.wait(1)
            end
            continue
        end

        local house = hwFindHouse()
        if not house then
            local cooling = false
            for _, h in ipairs(folder:GetChildren()) do
                if hwOwnsHouse(h) and #hwGet(h, 3) > 0 then
                    cooling = true
                    break
                end
            end
            setStatus(cooling and "MENUNGGU COOLDOWN RUMAH" or "ZONA BERSIH - MEMANTAU RUMAH")
            task.wait(1)
            continue
        end

        setStatus("HOMEWORK: MEMBERSIHKAN RUMAH")
        local done = {}
        while alive() and homeworkEnabled do
            local pending
            for _, p in ipairs(hwGet(house, 1)) do
                if not done[p] then
                    pending = p
                    break
                end
            end
            if not pending then break end
            if not hwUse(pending) then break end
            done[pending] = true
            task.wait(0.2)
        end

        if not alive() or not homeworkEnabled then break end

        setStatus("HOMEWORK: SCAN SEMUA SAMPAH RUMAH")
        local hadTrash = false
        local quiet = 0
        local batchCount = 0
        local triedBags = {}

        -- Tetap berada di rumah ini sampai semua sampahnya habis.
        while alive() and homeworkEnabled do
            local bags = hwGet(house, 2)

            if hwCarrying() then
                hadTrash = true
                local nextBag
                if batchCount < 6 then
                    for _, p in ipairs(bags) do
                        if not triedBags[p] then
                            nextBag = p
                            break
                        end
                    end
                end

                if nextBag then
                    triedBags[nextBag] = true
                    setStatus("HOMEWORK: MENGAMBIL " .. tostring(batchCount + 1) .. "/6")
                    if hwUse(nextBag) then
                        local collected = false
                        for _ = 1, 12 do
                            if not nextBag.Parent or not nextBag.Enabled then
                                collected = true
                                break
                            end
                            task.wait(0.2)
                        end
                        if collected then batchCount = batchCount + 1 end
                    end
                    task.wait(0.15)
                else
                    setStatus("HOMEWORK: MEMBUANG " .. tostring(batchCount) .. " SAMPAH")
                    if hwDispose(house) then
                        batchCount = 0
                        triedBags = {}
                    else
                        task.wait(0.75)
                    end
                end

            elseif #bags > 0 then
                hadTrash = true
                quiet = 0
                local first = bags[1]
                triedBags = {[first] = true}
                setStatus("HOMEWORK: MENGAMBIL SAMPAH")
                if hwUse(first) and hwWaitCarry(true) then
                    batchCount = 1
                else
                    triedBags[first] = nil
                    task.wait(0.5)
                end

            elseif #hwGet(house, 1) > 0 then
                quiet = 0
                local clean = hwGet(house, 1)[1]
                if clean and hwUse(clean) then
                    task.wait(0.2)
                else
                    task.wait(0.5)
                end

            else
                if hadTrash then
                    local progress = hwProgress()
                    if progress and progress >= 100 then
                        quiet = quiet + 1
                        if quiet >= 1 then break end
                    else
                        quiet = 0
                        setStatus("HOMEWORK: MENUNGGU 100%")
                    end
                else
                    quiet = quiet + 1
                    if quiet >= 5 then break end
                    setStatus("HOMEWORK: MENUNGGU SAMPAH MUNCUL")
                end
                task.wait(1)
            end
        end

        if not alive() or not homeworkEnabled then break end

        -- Jika masih ada sampah atau muatan, jangan pindah rumah.
        if hwCarrying() or #hwGet(house, 2) > 0 or #hwGet(house, 1) > 0 then
            setStatus("RUMAH BELUM SELESAI - SCAN ULANG")
            task.wait(0.5)
        else
            setStatus("RUMAH SELESAI - CARI RUMAH BERIKUTNYA")
            task.wait(0.3)
        end
    end

    homeworkBusy = false
end
]=]

source = raelReplaceBetween(
    source,
    "local function homeworkRun()",
    "local function ",
    raelHomeworkRun
)
]==]

wrapper = wrapper:sub(1, at - 1) .. patch .. "\n" .. wrapper:sub(at)

local chunk, compileError = loadstring(wrapper)
assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
chunk()
