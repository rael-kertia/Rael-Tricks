-- RAEL'S TRICKS - HOMEWORK TEST LOADER
-- Keeps main.lua and main_obfuscated.lua untouched.
-- Loads the current core, then applies isolated Homework scan/disposal patches.

local sourceUrl = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main_obfuscated.lua"
local response = game:HttpGet(sourceUrl)
if type(response) ~= "string" or response == "" then
    error("Rael Homework Test: gagal mengambil core")
end

local encodedMatch = response:match("local encoded = %[%[(.-)%]%]")
if not encodedMatch then
    error("Rael Homework Test: payload core tidak ditemukan")
end

local decoded = table.create(#encodedMatch / 2)
for i = 1, #encodedMatch, 2 do
    local byte = tonumber(encodedMatch:sub(i, i + 1), 16)
    if not byte then
        error("Rael Homework Test: payload hex tidak valid")
    end
    decoded[#decoded + 1] = string.char((byte - 97) % 256)
end
local wrapper = table.concat(decoded)

local marker = "local chunk, compileError = loadstring(source)"
local at = wrapper:find(marker, 1, true)
if not at then
    error("Rael Homework Test: titik injeksi core tidak ditemukan")
end

local homeworkPatch = [==[
-- ==========================================
-- RAEL HOMEWORK TEST PATCH
-- Full scan + multi-destination disposal.
-- ==========================================

replaceBetween(
    "local function hwDispose(house)",
    "local function hwGet(house, mode)",
    [=[
local function hwDispose(house)
    if not hwCarrying() then return true end
    if not alive() or not homeworkEnabled then return false end

    local root = hwRoot()
    if not root then return false end

    local kosanFolder = W:FindFirstChild("KosanSpawned")
    local candidates = {}
    local seen = {}

    -- Kumpulkan SEMUA prompt Buang yang valid, bukan hanya satu target terdekat.
    for _, prompt in ipairs(W:GetDescendants()) do
        if not alive() or not homeworkEnabled then return false end

        if prompt:IsA("ProximityPrompt")
        and prompt.Name == "BuangPrompt"
        and prompt.ActionText == "Buang"
        and prompt.Enabled
        and not seen[prompt] then

            local node = prompt
            local allowed = false

            while node and node.Parent do
                if kosanFolder and node.Parent == kosanFolder then
                    allowed = hwOwnsHouse(node)
                    break
                end

                if node.Parent == W then
                    allowed = node.Name:match("^ZonaSpawanGedung") ~= nil
                    break
                end

                node = node.Parent
            end

            if allowed then
                local part = hwPart(prompt)
                if part then
                    seen[prompt] = true
                    table.insert(candidates, {
                        prompt = prompt,
                        distance = (root.Position - part.Position).Magnitude
                    })
                end
            end
        end
    end

    table.sort(candidates, function(a, b)
        return a.distance < b.distance
    end)

    if #candidates == 0 then
        setStatus("TEMPAT SAMPAH TIDAK DITEMUKAN - SCAN ULANG")
        task.wait(0.75)
        return false
    end

    -- Jika target pertama gagal, coba target berikutnya.
    for _, entry in ipairs(candidates) do
        if not alive() or not homeworkEnabled then return false end

        local prompt = entry.prompt
        if prompt and prompt.Parent and prompt.Enabled then
            setStatus("HOMEWORK: MENCOBA TEMPAT BUANG")

            if hwUse(prompt) and hwWaitCarry(false) then
                setStatus("HOMEWORK: SAMPAH BERHASIL DIBUANG")
                return true
            end

            task.wait(0.15)
        end
    end

    setStatus("SEMUA TEMPAT BUANG GAGAL - COBA ULANG")
    return false
end
]=],
    "HOMEWORK TEST - TRY ALL DISPOSAL PROMPTS"
)

replaceBetween(
    "local function hwGet(house, mode)",
    "local function hwFindHouse()",
    [=[
local function hwGet(house, mode)
    local result = {}
    local seen = {}

    if not house then return result end

    -- Mode 1: Bersihkan aktif.
    -- Mode 3: seluruh Bersihkan, termasuk yang sedang cooldown.
    -- Mode 2: Ambil sampah aktif.
    -- Mode 4: seluruh prompt Ambil, termasuk yang sedang cooldown.
    for _, object in ipairs(house:GetDescendants()) do
        if (mode == 1 or mode == 3)
        and object:IsA("ProximityPrompt")
        and object.ActionText == "Bersihkan"
        and (mode == 3 or object.Enabled) then
            if not seen[object] then
                seen[object] = true
                table.insert(result, object)
            end

        elseif (mode == 2 or mode == 4)
        and object.Name == "TrashBag"
        and (object:IsA("BasePart") or object:IsA("Model") or object:IsA("Folder")) then
            for _, prompt in ipairs(object:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local action = (prompt.ActionText or ""):lower()
                    local name = (prompt.Name or ""):lower()
                    local isTake = name == "ambilprompt"
                        or name:find("ambil", 1, true) ~= nil
                        or action:find("ambil", 1, true) ~= nil

                    if isTake and (mode == 4 or prompt.Enabled)
                    and not seen[prompt] then
                        seen[prompt] = true
                        table.insert(result, prompt)
                    end
                end
            end
        end
    end

    return result
end
]=],
    "HOMEWORK TEST - FULL RECURSIVE HOUSE SCAN"
)
]==]

wrapper = wrapper:sub(1, at - 1) .. homeworkPatch .. "\n" .. wrapper:sub(at)

local chunk, compileError = loadstring(wrapper)
if not chunk then
    error("Rael Homework Test: core compile gagal: " .. tostring(compileError))
end

local ok, runError = pcall(chunk)
if not ok then
    error("Rael Homework Test: core gagal dijalankan: " .. tostring(runError))
end
