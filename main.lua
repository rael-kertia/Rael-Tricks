-- ONYX HUB | MAIN LOADER
-- Satu entry point. Status ditampilkan di layar agar tidak bergantung pada console Delta.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("ONYXBootstrap")
if previous then previous:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "ONYXBootstrap"
screen.ResetOnSpawn = false
screen.DisplayOrder = 100000
screen.Parent = playerGui

local label = Instance.new("TextLabel")
label.Name = "Status"
label.AnchorPoint = Vector2.new(0.5, 0)
label.Position = UDim2.new(0.5, 0, 0, 16)
label.Size = UDim2.new(1, -28, 0, 42)
label.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
label.TextColor3 = Color3.fromRGB(235, 240, 248)
label.TextSize = 12
label.Font = Enum.Font.GothamSemibold
label.TextWrapped = true
label.Text = "ONYX HUB: MEMULAI..."
label.Parent = screen
Instance.new("UICorner", label).CornerRadius = UDim.new(0, 9)

local function setStatus(message, failed)
    label.Text = "ONYX HUB: " .. tostring(message)
    label.BackgroundColor3 = failed
        and Color3.fromRGB(135, 38, 45)
        or Color3.fromRGB(24, 94, 70)
end

local function boot()
    setStatus("MENGAMBIL CORE...", false)

    local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/onyx_hub.lua"
    local response = game:HttpGet(url)
    assert(type(response) == "string" and #response > 10000,
        "CORE KOSONG / GAGAL DIUNDUH")

    setStatus("CORE DITERIMA - MEMERIKSA...", false)

    local chunk, compileError = loadstring(response)
    assert(type(chunk) == "function",
        "KOMPILASI GAGAL: " .. tostring(compileError))

    setStatus("MENJALANKAN ONYX HUB...", false)
    chunk()

    setStatus("CORE TERPANGGIL", false)
    task.delay(3, function()
        if screen and screen.Parent then
            screen:Destroy()
        end
    end)
end

local ok, err = pcall(boot)
if not ok then
    setStatus("GAGAL: " .. tostring(err):sub(1, 190), true)
end
