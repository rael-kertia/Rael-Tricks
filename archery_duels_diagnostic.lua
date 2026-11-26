-- ARCHERY DUELS DIAGNOSTIC - V5 QUICK GUI
-- BUILD: 2026-11-27-V5-QUICK-GUI
-- Read-only snapshots only. No remotes, firing, or gameplay value changes.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local function getParent()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    local ok = pcall(function() return CoreGui.Name end)
    if ok then return CoreGui end
    return PlayerGui
end

local parent = getParent()
local old = parent:FindFirstChild("ArcheryDiagV5")
if old then old:Destroy() end

-- Create the panel immediately, before any world inspection.
local gui = Instance.new("ScreenGui")
gui.Name = "ArcheryDiagV5"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(290, 164)
frame.Position = UDim2.new(0.5, -145, 0.18, 0)
frame.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local function label(text, pos, size, fontSize, bold)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Position = pos
    x.Size = size
    x.Text = text
    x.TextColor3 = Color3.fromRGB(240, 242, 248)
    x.TextSize = fontSize
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextWrapped = true
    x.Parent = frame
    return x
end

label("ARCHERY DIAG V5", UDim2.fromOffset(8, 5), UDim2.new(1, -16, 0, 25), 14, true)
local status = label("GUI aktif. Capture A, gerakkan bidikan, lalu Capture B.", UDim2.fromOffset(8, 31), UDim2.new(1, -16, 0, 34), 11, false)

local function button(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.44, 0, 0, 32)
    b.Position = UDim2.new(x, 0, 0, 72)
    b.BackgroundColor3 = Color3.fromRGB(55, 65, 85)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = text
    b.Parent = frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = b
    return b
end

local btnA = button("CAPTURE A", 0.04)
local btnB = button("CAPTURE B", 0.52)
local close = Instance.new("TextButton")
close.Size = UDim2.new(1, -16, 0, 24)
close.Position = UDim2.fromOffset(8, 116)
close.BackgroundTransparency = 1
close.Text = "TUTUP"
close.TextColor3 = Color3.fromRGB(180, 190, 205)
close.Font = Enum.Font.Gotham
close.TextSize = 11
close.Parent = frame

local function getAimDot()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local fireGui = pg and pg:FindFirstChild("FireButtonGui")
    local canvas = fireGui and fireGui:FindFirstChild("Canvas")
    local aimBar = canvas and canvas:FindFirstChild("AimBar")
    return aimBar and aimBar:FindFirstChild("AimDot", true)
end

local function snapshot()
    local s = {dots = {}, lastDots = {}}
    local camera = Workspace.CurrentCamera
    s.cameraPos = camera and camera.CFrame.Position or Vector3.zero
    s.cameraLook = camera and camera.CFrame.LookVector or Vector3.zero
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    s.playerPos = root and root.Position or Vector3.zero

    local aim = getAimDot()
    if aim and aim:IsA("GuiObject") then
        s.aimPos = aim.AbsolutePosition
        s.aimVisible = aim.Visible
        s.aimPath = aim:GetFullName()
    end

    local folder = Workspace:FindFirstChild("ArcheryTrajectory")
    if folder then
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("BasePart") then
                if obj.Name == "TrajectoryDot" then
                    s.dots[#s.dots + 1] = obj.Position
                elseif obj.Name == "LastShotDot" then
                    s.lastDots[#s.lastDots + 1] = obj.Position
                end
            end
        end
    end
    return s
end

local function v3(v)
    return string.format("%.2f, %.2f, %.2f", v.X, v.Y, v.Z)
end

local function report(a, b)
    local t = {
        "ARCHERY DUELS AIM COMPARISON - V5",
        "PlaceId=" .. tostring(game.PlaceId) .. " | Player=" .. LP.Name,
        "",
        "[A - BEFORE AIM MOVEMENT]",
        "Player=" .. v3(a.playerPos),
        "CameraPosition=" .. v3(a.cameraPos),
        "CameraLook=" .. v3(a.cameraLook),
        "AimDot=" .. tostring(a.aimPath or "NOT FOUND"),
        "AimDotPosition=" .. (a.aimPos and tostring(a.aimPos) or "N/A"),
        "AimDotVisible=" .. tostring(a.aimVisible),
        "TrajectoryDotCount=" .. tostring(#a.dots),
        "LastShotDotCount=" .. tostring(#a.lastDots),
        "",
        "[B - AFTER AIM MOVEMENT]",
        "Player=" .. v3(b.playerPos),
        "CameraPosition=" .. v3(b.cameraPos),
        "CameraLook=" .. v3(b.cameraLook),
        "AimDot=" .. tostring(b.aimPath or "NOT FOUND"),
        "AimDotPosition=" .. (b.aimPos and tostring(b.aimPos) or "N/A"),
        "AimDotVisible=" .. tostring(b.aimVisible),
        "TrajectoryDotCount=" .. tostring(#b.dots),
        "LastShotDotCount=" .. tostring(#b.lastDots),
        "",
        "[DELTA A TO B]",
        "PlayerPositionDelta=" .. v3(b.playerPos - a.playerPos),
        "CameraLookDelta=" .. v3(b.cameraLook - a.cameraLook),
        "TrajectorySampleCount A/B=" .. tostring(#a.dots) .. "/" .. tostring(#b.dots)
    }
    if a.aimPos and b.aimPos then
        t[#t + 1] = string.format("AimDotPixelDelta=%.1f, %.1f", b.aimPos.X-a.aimPos.X, b.aimPos.Y-a.aimPos.Y)
    end
    for i = 1, math.min(#a.dots, #b.dots, 16) do
        t[#t + 1] = "TrajectoryDelta[" .. i .. "]=" .. v3(b.dots[i] - a.dots[i])
    end
    t[#t + 1] = "Read-only diagnostic; no remotes invoked and no shots fired."
    return table.concat(t, "\n")
end

local captureA
btnA.MouseButton1Click:Connect(function()
    local ok, result = pcall(snapshot)
    if not ok then
        status.Text = "Capture A gagal: " .. tostring(result)
        return
    end
    captureA = result
    status.Text = "Capture A tersimpan. Gerakkan bidikan, lalu tekan B."
end)

btnB.MouseButton1Click:Connect(function()
    if not captureA then
        status.Text = "Tekan Capture A dulu."
        return
    end
    local ok, result = pcall(function()
        local output = report(captureA, snapshot())
        if typeof(setclipboard) == "function" then
            local copied = pcall(setclipboard, output)
            if copied then return "Hasil disalin ke clipboard." end
        end
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -12, 1, -12)
        box.Position = UDim2.fromOffset(6, 6)
        box.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.TextSize = 11
        box.Font = Enum.Font.Code
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.TextWrapped = false
        box.MultiLine = true
        box.ClearTextOnFocus = false
        box.Text = output
        box.Parent = frame
        return "Hasil tampil di kotak teks. Pilih semua lalu salin."
    end)
    status.Text = ok and result or ("Capture B gagal: " .. tostring(result))
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
warn("ARCHERY DIAG V5 READY")
