-- RAEL'S TRICKS - HOMEWORK TEST LOADER
-- Separate test entrypoint. Does not modify main.lua or main_obfuscated.lua.

local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main_obfuscated.lua"
local response = game:HttpGet(url)
if type(response) ~= "string" or response == "" then
    error("RAEL TEST: core tidak bisa diunduh")
end

local encoded = response:match("local encoded = %[%[(.-)%]%]")
if not encoded then
    error("RAEL TEST: encoded core tidak ditemukan")
end

local decoded = {}
for i = 1, #encoded, 2 do
    local byte = tonumber(encoded:sub(i, i + 1), 16)
    if not byte then error("RAEL TEST: data hex rusak pada posisi " .. i) end
    decoded[#decoded + 1] = string.char((byte - 97) % 256)
end
local wrapper = table.concat(decoded)

-- Extract the original Lua source string from the decoded wrapper.
local sourceStart = wrapper:find("local source =", 1, true)
if not sourceStart then error("RAEL TEST: source marker tidak ditemukan") end

local quoteStart = wrapper:find('"', sourceStart, true)
if not quoteStart then error("RAEL TEST: pembuka source tidak ditemukan") end

local i = quoteStart + 1
local escaped = false
local quoteEnd
while i <= #wrapper do
    local ch = wrapper:sub(i, i)
    if escaped then
        escaped = false
    elseif ch == "\\" then
        escaped = true
    elseif ch == '"' then
        quoteEnd = i
        break
    end
    i = i + 1
end
if not quoteEnd then error("RAEL TEST: penutup source tidak ditemukan") end

local literal = wrapper:sub(quoteStart, quoteEnd)
local literalChunk, literalError = loadstring("return " .. literal)
if not literalChunk then
    error("RAEL TEST: source literal gagal dibaca: " .. tostring(literalError))
end
local source = literalChunk()

local function replaceSection(text, firstMarker, nextMarker, replacement)
    local a = text:find(firstMarker, 1, true)
    if not a then error("RAEL TEST: marker awal tidak ditemukan: " .. firstMarker) end
    local b = text:find(nextMarker, a + #firstMarker, true)
    if not b then error("RAEL TEST: marker akhir tidak ditemukan: " .. nextMarker) end
    return text:sub(1, a) .. replacement .. "\n\n" .. text:sub(b)
end

-- Scan every nested TrashBag and every nested AmbilPrompt in the selected house.
local newHwGet = [=[
local function hwGet(house, mode)
    local result = {}
    local seen = {}
    if not house then return result end

    for _, object in ipairs(house:GetDescendants()) do
        if mode == 1 or mode == 3 then
            if object:IsA("ProximityPrompt")
            and object.ActionText == "Bersihkan"
            and (mode == 3 or object.Enabled)
            and not seen[object] then
                seen[object] = true
                table.insert(result, object)
            end

        elseif mode == 2 and object.Name == "TrashBag" then
            for _, prompt in ipairs(object:GetDescendants()) do
                if prompt:IsA("ProximityPrompt")
                and prompt.Name == "AmbilPrompt"
                and prompt.Enabled
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

source = replaceSection(
    source,
    "local function hwGet(house, mode)",
    "local function hwFindHouse()",
    newHwGet
)

-- Try every eligible disposal prompt in range order, not only the first one.
local newHwDispose = [=[
local function hwDispose(house)
    if not hwCarrying() then return true end
    if not alive() or not homeworkEnabled then return false end

    local root = hwRoot()
    if not root then return false end

    local folder = W:FindFirstChild("KosanSpawned")
    local candidates = {}
    local seen = {}

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

    if #candidates == 0 then
        setStatus("TEMPAT SAMPAH TIDAK DITEMUKAN - SCAN ULANG")
        task.wait(0.75)
        return false
    end

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

    setStatus("SEMUA TEMPAT BUANG GAGAL - COBA ULANG")
    return false
end
]=]

source = replaceSection(
    source,
    "local function hwDispose(house)",
    "local function hwGet(house, mode)",
    newHwDispose
)

local compiled, compileError = loadstring(source)
if not compiled then
    error("RAEL TEST COMPILE ERROR: " .. tostring(compileError))
end

local ok, runError = pcall(compiled)
if not ok then
    error("RAEL TEST RUNTIME ERROR: " .. tostring(runError))
end
