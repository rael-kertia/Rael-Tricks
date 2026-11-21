-- RAEL'S TRICKS - HOMEWORK TEST LOADER
-- Runs the decoded CORE RESTORE wrapper intact, then patches Homework
-- immediately before the wrapper compiles/runs its final source.
-- main.lua and main_obfuscated.lua are never modified.

local function showTestError(message)
    local text = "RAEL TEST LOADER\n" .. tostring(message)
    pcall(function() warn(text) end)
    pcall(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local guiParent = player and player:FindFirstChildOfClass("PlayerGui")
        if not guiParent then return end
        local old = guiParent:FindFirstChild("RaelTestDiagnostic")
        if old then old:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "RaelTestDiagnostic"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000000
        gui.Parent = guiParent
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -24, 0, 100)
        label.Position = UDim2.fromOffset(12, 40)
        label.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextWrapped = true
        label.TextSize = 14
        label.Text = text
        label.Parent = gui
    end)
end

local ok, result = pcall(function()
    local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main_obfuscated.lua"
    local response = game:HttpGet(url)
    assert(type(response) == "string" and #response > 1000, "Gagal mengambil main_obfuscated.lua")

    local encoded = response:match("local encoded = %[%[(.-)%]%]")
    assert(encoded, "Data encoded tidak ditemukan")
    encoded = encoded:gsub("%s", "")
    assert(#encoded > 1000 and #encoded % 2 == 0, "Panjang data encoded tidak valid")

    local decoded = {}
    for i = 1, #encoded, 2 do
        local byte = tonumber(encoded:sub(i, i + 1), 16)
        assert(byte, "Data hex rusak pada posisi " .. i)
        decoded[#decoded + 1] = string.char((byte - 97) % 256)
    end
    local wrapper = table.concat(decoded)

    -- Patch source AFTER all original CORE RESTORE modifications,
    -- but BEFORE its final loadstring(source).
    local compileMarker = "local compiled, compileError = loadstring(source)"
    local compileAt = wrapper:find(compileMarker, 1, true)
    assert(compileAt, "Titik injeksi core tidak ditemukan")

    local homeworkPatch = [==[
-- ===== RAEL TEST: HOMEWORK MULTI-TARGET PATCH =====
local function testReplaceBetween(text, firstMarker, nextMarker, replacement)
    local a = text:find(firstMarker, 1, true)
    if not a then error("TEST PATCH: marker awal tidak ditemukan: " .. firstMarker) end
    local b = text:find(nextMarker, a + #firstMarker, true)
    if not b then error("TEST PATCH: marker akhir tidak ditemukan: " .. nextMarker) end
    return text:sub(1, a) .. replacement .. "\n\n" .. text:sub(b)
end

local testHwGet = [=[
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

source = testReplaceBetween(
    source,
    "local function hwGet(house, mode)",
    "local function hwFindHouse()",
    testHwGet
)

local testHwDispose = [=[
local function hwDispose(house)
    if not hwCarrying() then return true end
    if not alive() or not homeworkEnabled then return false end

    local root = hwRoot()
    if not root then return false end

    local candidates = {}
    local seen = {}
    local folder = W:FindFirstChild("KosanSpawned")

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
                if folder and node.Parent == folder then
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

    for _, candidate in ipairs(candidates) do
        if not alive() or not homeworkEnabled then return false end
        local prompt = candidate.prompt
        if prompt and prompt.Parent and prompt.Enabled then
            if hwUse(prompt) and hwWaitCarry(false) then
                return true
            end
            task.wait(0.2)
        end
    end

    setStatus(#candidates == 0
        and "TEMPAT BUANG TIDAK DITEMUKAN - SCAN ULANG"
        or "INTERAKSI BUANG GAGAL - COBA ULANG")
    return false
end
]=]

source = testReplaceBetween(
    source,
    "local function hwDispose(house)",
    "local function hwGet(house, mode)",
    testHwDispose
)
-- ===== END RAEL TEST PATCH =====

]=]

    wrapper = wrapper:sub(1, compileAt - 1)
        .. homeworkPatch
        .. "\n"
        .. wrapper:sub(compileAt)

    local chunk, compileError = loadstring(wrapper)
    assert(chunk, "Wrapper compile gagal: " .. tostring(compileError))
    local ran, runError = pcall(chunk)
    assert(ran, "Wrapper runtime gagal: " .. tostring(runError))
end)

if not ok then
    showTestError(result)
end
