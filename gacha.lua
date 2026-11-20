-- RAEL'S TRICKS - STANDALONE AUTO GACHA
-- Indo Kos: Build & Upgrade
-- Terpisah dari main.lua | Knit GachaService
-- Paid spin default OFF untuk mencegah pengeluaran tidak sengaja.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local env = getgenv()

-- Cleanup versi sebelumnya
if env.RaelGachaConnections then
    for _, c in ipairs(env.RaelGachaConnections) do
        pcall(function() c:Disconnect() end)
    end
end
if env.RaelGachaGui then
    pcall(function() env.RaelGachaGui:Destroy() end)
end

env.RaelGachaRunning = false
task.wait(0.1)
env.RaelGachaRunning = true
local SESSION = tick()
env.RaelGachaSession = SESSION
env.RaelGachaConnections = {}

local function alive()
    return env.RaelGachaRunning and env.RaelGachaSession == SESSION
end

local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(env.RaelGachaConnections, c)
    return c
end

local autoEnabled = false
local paidEnabled = false
local busy = false
local service

-- GUI
local old = playerGui:FindFirstChild("RaelGachaUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "RaelGachaUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 1001
gui.Parent = playerGui
env.RaelGachaGui = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(235, 190)
frame.Position = UDim2.new(1, -250, 0, 130)
frame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 11)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(45, 212, 191)
stroke.Thickness = 1.2
stroke.Parent = frame

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -42, 0, 32)
header.Position = UDim2.fromOffset(11, 3)
header.BackgroundTransparency = 1
header.Text = "RAEL'S TRICKS • GACHA"
header.TextColor3 = Color3.fromRGB(240, 253, 250)
header.TextSize = 12
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = frame

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(27, 25)
mini.Position = UDim2.new(1, -34, 0, 6)
mini.BackgroundColor3 = Color3.fromRGB(15, 118, 110)
mini.Text = "—"
mini.TextColor3 = Color3.new(1, 1, 1)
mini.TextSize = 15
mini.Font = Enum.Font.GothamBold
mini.Parent = frame
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(45, 45)
reopen.Position = UDim2.new(1, -58, 0, 130)
reopen.BackgroundColor3 = Color3.fromRGB(13, 148, 136)
reopen.Text = "G"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.TextSize = 17
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Active = true
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(1, 0)

local function makeButton(name, text, y)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, -22, 0, 34)
    b.Position = UDim2.fromOffset(11, y)
    b.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local autoButton = makeButton("AutoGacha", "AUTO GACHA: OFF", 43)
local paidButton = makeButton("PaidSpin", "PAID SPIN: OFF", 83)
paidButton.BackgroundColor3 = Color3.fromRGB(71, 85, 105)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -22, 0, 38)
status.Position = UDim2.fromOffset(11, 126)
status.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(253, 230, 138)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.TextWrapped = true
status.Parent = frame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 7)

local function setStatus(message)
    if status and status.Parent then
        status.Text = "STATUS: " .. tostring(message)
    end
end

local function paint()
    autoButton.Text = autoEnabled and "AUTO GACHA: ON" or "AUTO GACHA: OFF"
    autoButton.BackgroundColor3 = autoEnabled
        and Color3.fromRGB(5, 150, 105) or Color3.fromRGB(127, 29, 29)
    paidButton.Text = paidEnabled and "PAID SPIN: ON" or "PAID SPIN: OFF"
    paidButton.BackgroundColor3 = paidEnabled
        and Color3.fromRGB(180, 110, 20) or Color3.fromRGB(71, 85, 105)
end

-- Drag + minimize
local function draggable(obj)
    local dragging, startPos, startInput
    connect(obj.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startInput = input.Position
            startPos = obj.Position
            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    connect(UIS.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - startInput
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end
draggable(frame)
draggable(reopen)

connect(mini.Activated, function()
    frame.Visible = false
    reopen.Visible = true
end)
connect(reopen.Activated, function()
    reopen.Visible = false
    frame.Visible = true
end)

-- Knit service
local function getGachaService()
    if service then return service end
    local rs = game:GetService("ReplicatedStorage")
    local knitModule = rs:WaitForChild("NKSystem", 15)
    if not knitModule then error("NKSystem tidak ditemukan") end
    knitModule = knitModule:WaitForChild("Packages", 15)
    if not knitModule then error("Packages tidak ditemukan") end
    knitModule = knitModule:WaitForChild("Knit", 15)
    if not knitModule then error("Knit tidak ditemukan") end
    local Knit = require(knitModule)
    service = Knit.GetService("GachaService")
    if not service then error("GachaService tidak ditemukan") end
    return service
end

local function callGacha(methodName)
    local ok, a, b = pcall(function()
        local svc = getGachaService()
        local method = svc[methodName]
        if type(method) ~= "function" then
            error("METHOD TIDAK DITEMUKAN: " .. methodName)
        end
        return method(svc):await()
    end)
    if not ok then return false, tostring(a) end
    if not a then return false, b or "PROMISE GAGAL" end
    return true, b
end

local function claimSingle()
    local ok = callGacha("ClaimReward")
    if not ok then setStatus("KLAIM GAGAL") end
    return ok
end

local function claimMulti(results)
    for i = 1, #results do
        -- Selesaikan seluruh klaim hasil x10 walau Auto Gacha dimatikan.
        local ok = callGacha("ClaimOneMultiReward")
        if not ok then
            setStatus("KLAIM MULTI GAGAL (" .. i .. "/" .. #results .. ")")
            return false
        end
        task.wait(0.25)
    end
    return true
end

local function oneCycle()
    setStatus("MEMBACA STATE")
    local stateOK, state = callGacha("GetState")
    if not stateOK or type(state) ~= "table" then
        setStatus("GAGAL MEMBACA STATE")
        return false
    end

    local free = tonumber(state.free) or 0
    local spinOK, result

    if free >= 10 then
        setStatus("FREE SPIN X10")
        spinOK, result = callGacha("SpinX10WithFree")
        if spinOK and type(result) == "table" and result.ok then
            local results = result.results or {}
            if #results > 0 then claimMulti(results) end
        else
            spinOK = false
        end
    elseif free > 0 then
        setStatus("FREE SPIN")
        spinOK, result = callGacha("Spin")
        if spinOK and type(result) == "table" and result.ok then
            if result.granted ~= false then claimSingle() end
        else
            spinOK = false
        end
    elseif paidEnabled then
        setStatus("PAID SPIN")
        spinOK, result = callGacha("SpinWithMoney")
        if spinOK and type(result) == "table" and result.ok then
            claimSingle()
        else
            spinOK = false
        end
    else
        setStatus("MENUNGGU FREE SPIN • PAID OFF")
        return nil
    end

    if spinOK then
        setStatus("SPIN SELESAI • FREE: " .. free)
        return true
    end
    setStatus("SPIN GAGAL / COBA LAGI")
    return false
end

local function worker()
    if busy then return end
    busy = true
    while alive() and autoEnabled do
        local ok, err = pcall(oneCycle)
        if not ok then setStatus("ERROR: " .. tostring(err):sub(1, 90)) end
        task.wait(ok and 1.5 or 3)
    end
    busy = false
    if alive() then setStatus("AUTO GACHA NONAKTIF") end
end

connect(autoButton.Activated, function()
    if not alive() then return end
    autoEnabled = not autoEnabled
    paint()
    if autoEnabled then
        setStatus("AUTO GACHA DIMULAI")
        task.spawn(worker)
    else
        setStatus("AUTO GACHA DIMATIKAN")
    end
end)

connect(paidButton.Activated, function()
    if not alive() then return end
    paidEnabled = not paidEnabled
    paint()
    setStatus(paidEnabled and "PAID SPIN DIIZINKAN" or "PAID SPIN DINONAKTIFKAN")
end)

connect(gui.Destroying, function()
    if env.RaelGachaSession == SESSION then
        env.RaelGachaRunning = false
    end
end)

paint()
setStatus("READY • FREE ONLY")
print("RAEL GACHA LOADED • SEPARATE FROM MAIN")
