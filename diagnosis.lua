-- RAEL DIAGNOSTIC: POPUP PENYEWA
-- Indo Kos: Build & Upgrade
-- PASIF: TIDAK MENEKAN / MENGIRIM APA PUN

local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CG = game:GetService("CoreGui")
local plr = P.LocalPlayer

local KEY = {
    "penyewa", "sewa", "terima", "tolak",
    "tenant", "rent", "accept", "reject",
    "penghuni", "kontrak", "kos"
}

local function match(s)
    s = tostring(s or ""):lower()
    for _, k in ipairs(KEY) do
        if s:find(k, 1, true) then return true end
    end
    return false
end

local function safe(fn)
    local ok, v = pcall(fn)
    return ok and tostring(v) or "?"
end

local out = {}
local function add(s)
    out[#out+1] = tostring(s)
end

local function path(o)
    return safe(function() return o:GetFullName() end)
end

add("=== RAEL TENANT POPUP DIAGNOSTIC ===")
add("PLAYER: "..plr.Name)
add("TIME: "..os.date("%Y-%m-%d %H:%M:%S"))
add("")

-- PLAYER GUI + CORE GUI
local roots = {
    plr:FindFirstChildOfClass("PlayerGui"),
    CG
}

local foundGui = {}

for _, root in ipairs(roots) do
    if root then
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("ScreenGui") then
                local texts = {}
                local buttons = {}

                for _, v in ipairs(obj:GetDescendants()) do
                    if v:IsA("TextLabel")
                    or v:IsA("TextButton")
                    or v:IsA("TextBox") then
                        local t = v.Text
                        if t and t ~= "" then
                            texts[#texts+1] = {
                                text = t,
                                object = v
                            }
                        end
                    end

                    if v:IsA("TextButton")
                    or v:IsA("ImageButton") then
                        buttons[#buttons+1] = v
                    end
                end

                local relevant = match(obj.Name)
                for _, item in ipairs(texts) do
                    if match(item.text) then
                        relevant = true
                    end
                end

                if relevant then
                    foundGui[obj] = true
                    add("")
                    add("=== SCREEN GUI ===")
                    add("NAME: "..obj.Name)
                    add("PATH: "..path(obj))
                    add("ENABLED: "..tostring(obj.Enabled))
                    add("DISPLAY ORDER: "..tostring(obj.DisplayOrder))

                    add("-- TEXT OBJECTS --")
                    for _, item in ipairs(texts) do
                        local v = item.object
                        add("TEXT: "..item.text)
                        add("CLASS: "..v.ClassName)
                        add("PATH: "..path(v))
                        add("VISIBLE: "..safe(function()
                            return v.Visible
                        end))
                    end

                    add("-- BUTTONS --")
                    for _, b in ipairs(buttons) do
                        add("BUTTON: "..b.Name)
                        add("CLASS: "..b.ClassName)
                        add("TEXT: "..safe(function()
                            return b.Text
                        end))
                        add("VISIBLE: "..safe(function()
                            return b.Visible
                        end))
                        add("ACTIVE: "..safe(function()
                            return b.Active
                        end))
                        add("PATH: "..path(b))
                    end
                end
            end
        end
    end
end

-- REMOTE EVENT / FUNCTION
add("")
add("=== REMOTE SCAN ===")

local count = 0
for _, obj in ipairs(RS:GetDescendants()) do
    if obj:IsA("RemoteEvent")
    or obj:IsA("RemoteFunction")
    or obj:IsA("UnreliableRemoteEvent") then
        if match(obj.Name) then
            count += 1
            add("REMOTE: "..obj.Name)
            add("CLASS: "..obj.ClassName)
            add("PATH: "..path(obj))
        end
    end
end

add("MATCHING REMOTES: "..count)

-- SCRIPT NAMES IN PLAYER GUI
add("")
add("=== GUI SCRIPT SCAN ===")

for _, root in ipairs(roots) do
    if root then
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("LocalScript")
            and match(path(obj)) then
                add("SCRIPT: "..path(obj))
            end
        end
    end
end

-- SUMMARY
add("")
add("=== SUMMARY ===")
local guiCount = 0
for _ in pairs(foundGui) do guiCount += 1 end
add("MATCHING SCREEN GUI: "..guiCount)
add("MATCHING REMOTE: "..count)
add("=== END DIAGNOSTIC ===")

local result = table.concat(out, "\n")

local copied = false
if setclipboard then
    copied = pcall(setclipboard, result)
end
if not copied and toclipboard then
    copied = pcall(toclipboard, result)
end

local saved = false
if writefile then
    saved = pcall(writefile, "Rael_Tenant_Diagnostic.txt", result)
end

if copied then
    print("DIAGNOSTIC COPIED")
end
if saved then
    print("FILE SAVED")
end
