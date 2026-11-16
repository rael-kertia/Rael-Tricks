
-- ==========================================
-- RAEL'S TRICKS V12
-- INDO KOS: BUILD & UPGRADE
-- DELTA ANDROID
-- AUTO CLEANER V10.3 + TP LOCATION V3
-- ==========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- AUTO CLEANER SETTINGS
-- ==========================================

local RANGE_CLEAN = 100
local RANGE_TRASH = 30
local SCAN_DELAY = 0.2
local RETRY_DELAY = 0.2
local INTERACTION_DELAY = 0.1

local enabled = false
local busy = false

local prompts = setmetatable({}, {__mode = "k"})
local lastAttempt = setmetatable({}, {__mode = "k"})

-- ==========================================
-- FILTER PROMPTS
-- ==========================================

local function isAllowed(prompt)
    local action = (prompt.ActionText or ""):lower()
    local object = (prompt.ObjectText or ""):lower()
    local name = (prompt.Name or ""):lower()
    local fullName = prompt:GetFullName():lower()

    if action:find("keranjang", 1, true)
        or object:find("keranjang", 1, true)
        or name:find("keranjang", 1, true)
        or fullName:find("keranjang", 1, true) then
        return false
    end

    return action:find("bersihkan", 1, true)
        or action:find("ambil", 1, true)
        or action:find("buang", 1, true)
end

-- ==========================================
-- DETECT TRASHBAG
-- ==========================================

local function isCarryingTrash()
    local character = player.Character
    if not character then return false end

    local model = character:FindFirstChild("Model")
    if not model then return false end

    local trash = model:FindFirstChild("TrashBag")

    return trash ~= nil and trash:IsA("BasePart")
end

-- ==========================================
-- REGISTER PROMPTS
-- ==========================================

local function addPrompt(obj)
    if obj:IsA("ProximityPrompt") and isAllowed(obj) then
        prompts[obj] = true

        pcall(function()
            obj.HoldDuration = 0
        end)
    end
end

-- ==========================================
-- PROMPT POSITION
-- ==========================================

local function getPosition(prompt)
    local parent = prompt.Parent
    if not parent then return nil end

    if parent:IsA("Attachment") then
        return parent.WorldPosition
    elseif parent:IsA("BasePart") then
        return parent.Position
    end

    local part = parent:FindFirstAncestorWhichIsA("BasePart")
    return part and part.Position
end

-- ==========================================
-- FIND NEAREST PROMPT
-- ==========================================

local function getNearest(root)
    local nearest
    local shortest = math.huge
    local now = os.clock()

    local carryingTrash = isCarryingTrash()

    for prompt in pairs(prompts) do
        if prompt.Parent and prompt.Enabled and isAllowed(prompt) then
            local action = (prompt.ActionText or ""):lower()

            local isClean = action:find("bersihkan", 1, true)
            local isTake = action:find("ambil", 1, true)
            local isDrop = action:find("buang", 1, true)

            if isTake and carryingTrash then
                continue
            end

            if isDrop and not carryingTrash then
                continue
            end

            local ready = not lastAttempt[prompt]
                or now - lastAttempt[prompt] >= RETRY_DELAY

            if ready then
                local pos = getPosition(prompt)
                local range = isClean
                    and RANGE_CLEAN or RANGE_TRASH

                if pos then
                    local distance = (root.Position - pos).Magnitude

                    if distance <= range and distance < shortest then
                        nearest = prompt
                        shortest = distance
                    end
                end
            end
        end
    end

    return nearest
end

-- ==========================================
-- GUI: RAEL'S TRICKS
-- ==========================================

local oldGui = playerGui:FindFirstChild("RaelsTricks")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "RaelsTricks"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(142, 38)
frame.Position = UDim2.new(1, -155, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.fromOffset(102, 12)
title.Position = UDim2.fromOffset(4, -13)
title.BackgroundTransparency = 1
title.Text = "Rael's Tricks"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 10
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- CLEANER TOGGLE
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(102, 30)
toggle.Position = UDim2.fromOffset(4, 4)
toggle.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 12
toggle.Font = Enum.Font.GothamBold
toggle.Text = "CLEAN: OFF"
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- MINIMIZE
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(28, 30)
minimize.Position = UDim2.fromOffset(110, 4)
minimize.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 17
minimize.Font = Enum.Font.GothamBold
minimize.Text = "−"
minimize.Parent = frame

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(38, 38)
mini.Position = UDim2.new(1, -50, 0, 100)
mini.BackgroundColor3 = Color3.fromRGB(35, 100, 65)
mini.TextColor3 = Color3.new(1, 1, 1)
mini.TextSize = 15
mini.Font = Enum.Font.GothamBold
mini.Text = "RT"
mini.Visible = false
mini.Active = true
mini.Parent = gui

Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)

-- ==========================================
-- DRAG SUPPORT
-- ==========================================

local function makeDraggable(object)
    local dragging = false
    local dragInput
    local dragStart
    local startPosition

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    object.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(frame)
makeDraggable(mini)

-- ==========================================
-- GUI BUTTONS
-- ==========================================

local function update()
    toggle.Text = enabled and "CLEAN: ON" or "CLEAN: OFF"

    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(35, 145, 70)
        or Color3.fromRGB(160, 45, 45)
end

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    update()
end)

minimize.MouseButton1Click:Connect(function()
    mini.Position = frame.Position
    frame.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    mini.Visible = false
    frame.Visible = true
end)

-- ==========================================
-- TP LOCATION TOOL
-- TP TEST V3 - CONFIRMED WORKING
-- ==========================================

local backpack = player:WaitForChild("Backpack")

local oldTool = backpack:FindFirstChild("TP LOCATION")
    or (player.Character and player.Character:FindFirstChild("TP LOCATION"))

if oldTool then
    oldTool:Destroy()
end

local tool = Instance.new("Tool")
tool.Name = "TP LOCATION"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = backpack

local tpEquipped = false
local equipTime = 0

tool.Equipped:Connect(function()
    tpEquipped = true
    equipTime = os.clock()
    print("TP LOCATION READY")
end)

tool.Unequipped:Connect(function()
    tpEquipped = false
end)

UIS.TouchTapInWorld:Connect(function(position, processed)
    if not tpEquipped or processed then
        return
    end

    -- Abaikan sentuhan saat proses equip
    if os.clock() - equipTime < 0.25 then
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local ray = camera:ViewportPointToRay(
        position.X,
        position.Y
    )

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        player.Character
    }

    local result = workspace:Raycast(
        ray.Origin,
        ray.Direction * 1500,
        params
    )

    if not result then return end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not root or not humanoid then return end

    local height = humanoid.HipHeight + root.Size.Y / 2

    root.CFrame = CFrame.new(
        result.Position.X,
        result.Position.Y + height + 0.15,
        result.Position.Z
    )

    print("TELEPORT BERHASIL:", result.Position)
end)

-- ==========================================
-- INITIAL PROMPT SCAN
-- ==========================================

for _, obj in ipairs(workspace:GetDescendants()) do
    addPrompt(obj)
end

workspace.DescendantAdded:Connect(addPrompt)

-- ==========================================
-- MAIN AUTO CLEANER LOOP
-- ==========================================

task.spawn(function()
    while gui.Parent do
        task.wait(SCAN_DELAY)

        if not enabled or busy then
            continue
        end

        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not root then
            continue
        end

        local prompt = getNearest(root)

        if prompt and enabled then
            busy = true
            lastAttempt[prompt] = os.clock()

            pcall(function()
                if enabled and prompt.Parent then
                    prompt.HoldDuration = 0
                    prompt:InputHoldBegin()

                    task.wait(INTERACTION_DELAY)

                    prompt:InputHoldEnd()
                end
            end)

            busy = false
        end
    end
end)

-- ==========================================
-- FINISH
-- ==========================================

update()

print("================================")
print("RAEL'S TRICKS V12 LOADED")
print("AUTO CLEANER V10.3 READY")
print("TP LOCATION V3 READY")
print("================================")
