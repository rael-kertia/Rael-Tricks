-- PHONE EMPIRE RESEARCH DIAGNOSTIC
-- Read-only scan. Does not invoke remotes or change game state.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local function safe(v) return tostring(v or "") end
local function add(out, s) out[#out+1] = s end
local function getText(obj)
    local ok, value = pcall(function() return obj.Text end)
    return ok and type(value) == "string" and value or ""
end
local function scan()
    local out = {}
    add(out, "BUILD A PHONE EMPIRE - RESEARCH DIAGNOSTIC")
    add(out, "PlaceId: " .. safe(game.PlaceId))
    add(out, "Player: " .. safe(player and player.Name) .. " (" .. safe(player and player.UserId) .. ")")
    add(out, "")
    add(out, "[PLAYER GUI: RESEARCH MATCHES]")
    local pg = player and player:FindFirstChildOfClass("PlayerGui")
    local guiCount = 0
    if pg then
        for _, obj in ipairs(pg:GetDescendants()) do
            local n = obj.Name:lower()
            local t = getText(obj)
            local tl = t:lower()
            if n:find("research", 1, true) or tl:find("research", 1, true) then
                guiCount = guiCount + 1
                if guiCount <= 120 then
                    add(out, obj.ClassName .. " | " .. obj:GetFullName() .. (t ~= "" and (" | Text=" .. t:sub(1,180)) or ""))
                end
            end
        end
    end
    add(out, "Research GUI matches: " .. guiCount)
    add(out, "")
    add(out, "[VISIBLE GUI TEXT: RESEARCH / UPGRADE / PHONE]")
    local textCount = 0
    if pg then
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local t = getText(obj)
                local tl = t:lower()
                if tl:find("research",1,true) or tl:find("upgrade",1,true) or tl:find("phone",1,true) then
                    textCount = textCount + 1
                    if textCount <= 100 then add(out, obj:GetFullName() .. " | " .. t:sub(1,180)) end
                end
            end
        end
    end
    add(out, "Text matches: " .. textCount)
    add(out, "")
    add(out, "[REPLICATEDSTORAGE REMOTES: NAMES/PATHS ONLY]")
    local remoteCount = 0
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
            remoteCount = remoteCount + 1
            if remoteCount <= 180 then add(out, obj.ClassName .. " | " .. obj:GetFullName()) end
        end
    end
    add(out, "Remote-like instances: " .. remoteCount)
    add(out, "")
    add(out, "[RESEARCH-NAMED OBJECTS IN REPLICATEDSTORAGE]")
    local matchCount = 0
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("research",1,true) or n:find("tech",1,true) or n:find("upgrade",1,true) then
            matchCount = matchCount + 1
            if matchCount <= 120 then add(out, obj.ClassName .. " | " .. obj:GetFullName()) end
        end
    end
    add(out, "Named matches: " .. matchCount)
    return table.concat(out, "\n")
end
local gui = Instance.new("ScreenGui")
gui.Name = "PhoneEmpireResearchDiagnostic"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = gethui() end)
if not gui.Parent then gui.Parent = game:GetService("CoreGui") end
local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.new(0, 390, 0, 250)
frame.Position = UDim2.new(0.5, -195, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(24,24,29)
frame.BorderSizePixel = 0
frame.Parent = gui
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,10)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-16,0,34)
title.Position = UDim2.new(0,8,0,4)
title.BackgroundTransparency = 1
title.Text = "PHONE EMPIRE • RESEARCH DIAGNOSTIC"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1,-20,0,38)
scanBtn.Position = UDim2.new(0,10,0,45)
scanBtn.Text = "SCAN RESEARCH"
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 14
scanBtn.TextColor3 = Color3.new(1,1,1)
scanBtn.BackgroundColor3 = Color3.fromRGB(50,105,180)
scanBtn.Parent = frame
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0,7)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1,-20,0,34)
copyBtn.Position = UDim2.new(0,10,0,89)
copyBtn.Text = "COPY REPORT"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 13
copyBtn.TextColor3 = Color3.new(1,1,1)
copyBtn.BackgroundColor3 = Color3.fromRGB(55,130,85)
copyBtn.Parent = frame
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,7)
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,54)
status.Position = UDim2.new(0,10,0,132)
status.BackgroundTransparency = 1
status.Text = "Tekan SCAN RESEARCH, lalu COPY REPORT."
status.TextWrapped = true
status.TextColor3 = Color3.fromRGB(220,220,220)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(150,55,55)
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)
local report = ""
scanBtn.MouseButton1Click:Connect(function()
    status.Text = "Memindai UI dan nama remote..."
    local ok, result = pcall(scan)
    if ok then
        report = result
        status.Text = "Scan selesai. Tekan COPY REPORT."
    else
        status.Text = "Scan gagal: " .. tostring(result)
    end
end)
copyBtn.MouseButton1Click:Connect(function()
    if report == "" then status.Text = "Scan dulu."; return end
    local ok = pcall(function() setclipboard(report) end)
    if ok then status.Text = "Report disalin ke clipboard."
    else
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,-20,0,1)
        box.Text = report
        box.TextTransparency = 1
        box.Parent = frame
        box:CaptureFocus()
        box.TextTransparency = 0
        box.Size = UDim2.new(1,-20,0,70)
        box.Position = UDim2.new(0,10,0,175)
        box.TextWrapped = true
        box.ClearTextOnFocus = false
        status.Text = "Clipboard tidak tersedia. Salin teks dari kotak."
    end
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
