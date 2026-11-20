-- ==========================================
-- RAEL'S TRICKS - SESSION 71 AUTO FARM COPY
-- AUTO ACC + HOMEWORK + ANTI-AFK + TP LOCATION
-- AUTO FARM / CONVERT / AUTO FEED / GACHA REMOVED
-- ==========================================

local source ="-- ==========================================\n-- RAEL'S TRICKS V18.2 + HOMEWORK\n-- AUTO CLEANER + AUTO FARM + HOMEWORK\n-- HOMEWORK TERPISAH DARI AUTO CLEAN\n-- HOMEWORK PRIORITY OVER AUTO FARM\n-- ==========================================\n\nlocal Players = game:GetService(\"Players\")\nlocal UIS = game:GetService(\"UserInputService\")\nlocal VirtualUser = game:GetService(\"VirtualUser\")\n\nlocal player = Players.LocalPlayer\nlocal playerGui = player:WaitForChild(\"PlayerGui\")\nlocal backpack = player:WaitForChild(\"Backpack\")\nlocal env = getgenv()\nlocal W = workspace\n\n-- CLEAN PREVIOUS VERSION\nif env.RaelV18Connections then\n    for _, c in ipairs(env.RaelV18Connections) do\n        pcall(function() c:Disconnect() end)\n    end\nend\nif env.RaelV18Objects then\n    for _, obj in ipairs(env.RaelV18Objects) do\n        pcall(function() obj:Destroy() end)\n    end\nend\n\nenv.RaelV18Running = false\ntask.wait(0.15)\nenv.RaelV18Running = true\n\nlocal SESSION = tick()\nenv.RaelV18Session = SESSION\nenv.RaelV18Connections = {}\nenv.RaelV18Objects = {}\n\nlocal function alive()\n    return env.RaelV18Running and env.RaelV18Session == SESSION\nend\n\nlocal function connect(signal, callback)\n    local c = signal:Connect(callback)\n    table.insert(env.RaelV18Connections, c)\n    return c\nend\n\nlocal function track(object)\n    table.insert(env.RaelV18Objects, object)\n    return object\nend\n\n-- SETTINGS\nlocal RANGE_CLEAN = 100\nlocal RANGE_TRASH = 30\nlocal SCAN_DELAY = 0.2\nlocal RETRY_DELAY = 1\nlocal DROPPING_RETRY = 2\nlocal FEED_RETRY = 8\n\nlocal enabled = false\nlocal autoFarm = false\nlocal homeworkEnabled = false\nlocal homeworkBusy = false\nlocal busy = false\n\nlocal prompts = setmetatable({}, {__mode = \"k\"})\nlocal lastAttempt = setmetatable({}, {__mode = \"k\"})\nlocal collectCooldown = {}\nlocal feedCooldown = {}\n\n-- ==========================================\n-- DYNAMIC KANDANG\n-- ==========================================\n\nlocal function getCurrentKandang()\n    local name = player:GetAttribute(\"Ternak_Kandang\")\n    if typeof(name) ~= \"string\" then return nil end\n    if not name:match(\"^Kandang_%d+$\") then return nil end\n    return name\nend\n\nlocal function getKandangNumber()\n    local name = getCurrentKandang()\n    return name and name:match(\"Kandang_(%d+)\")\nend\n\nlocal function getCurrentPen()\n    local kandang = getCurrentKandang()\n    if not kandang then return nil end\n\n    local kawasan = W:FindFirstChild(\"Kawasan_Kos\")\n    local ternak = kawasan and kawasan:FindFirstChild(\"Lahan_Ternak\")\n    return ternak and ternak:FindFirstChild(kandang)\nend\n\nlocal function getDroppingFolder()\n    local kandang = getCurrentKandang()\n    if not kandang then return nil end\n\n    local farm = W:FindFirstChild(\"TernakLokal\")\n    local owner = farm and farm:FindFirstChild(\"KotoranSaya_\" .. kandang)\n    return owner and owner:FindFirstChild(\"Kotoran\")\nend\n\n-- ==========================================\n-- PROMPT FILTER\n-- ==========================================\n\nlocal function isDroppingPrompt(prompt)\n    if not prompt or not prompt:IsA(\"ProximityPrompt\") then\n        return false\n    end\n\n    local action = (prompt.ActionText or \"\"):lower()\n    local object = (prompt.ObjectText or \"\"):lower()\n    local name = (prompt.Name or \"\"):lower()\n\n    return action:find(\"ambil\", 1, true) ~= nil\n        and (\n            object:find(\"kotoran\", 1, true) ~= nil\n            or name:find(\"ambilkotoran\", 1, true) ~= nil\n        )\nend\n\nlocal function isAllowed(prompt)\n    if not prompt or not prompt:IsA(\"ProximityPrompt\") then\n        return false\n    end\n\n    local action = (prompt.ActionText or \"\"):lower()\n    local object = (prompt.ObjectText or \"\"):lower()\n    local name = (prompt.Name or \"\"):lower()\n    local path = prompt:GetFullName():lower()\n\n    if action:find(\"keranjang\", 1, true)\n    or object:find(\"keranjang\", 1, true)\n    or name:find(\"keranjang\", 1, true)\n    or path:find(\"keranjang\", 1, true) then\n        return false\n    end\n\n    return action:find(\"bersihkan\", 1, true)\n        or action:find(\"ambil\", 1, true)\n        or action:find(\"buang\", 1, true)\nend\n\nlocal function addPrompt(obj)\n    if obj:IsA(\"ProximityPrompt\") and isAllowed(obj) then\n        prompts[obj] = true\n    end\nend\n\n-- ==========================================\n-- POSITION\n-- ==========================================\n\nlocal function getPosition(prompt)\n    if not prompt or not prompt.Parent then return nil end\n\n    local parent = prompt.Parent\n\n    if parent:IsA(\"Attachment\") then\n        return parent.WorldPosition\n    end\n\n    if parent:IsA(\"BasePart\") then\n        return parent.Position\n    end\n\n    local model = parent:IsA(\"Model\")\n        and parent\n        or parent:FindFirstAncestorWhichIsA(\"Model\")\n\n    if model then\n        local part = model.PrimaryPart\n            or model:FindFirstChildWhichIsA(\"BasePart\", true)\n        if part then return part.Position end\n    end\n\n    local part = parent:FindFirstChildWhichIsA(\"BasePart\", true)\n    return part and part.Position\nend\n\nlocal function getObjectPosition(obj)\n    if not obj then return nil end\n    if obj:IsA(\"BasePart\") then return obj.Position end\n\n    if obj:IsA(\"Model\") then\n        local ok, pivot = pcall(function()\n            return obj:GetPivot()\n        end)\n        if ok then return pivot.Position end\n    end\n\n    local part = obj:FindFirstChildWhichIsA(\"BasePart\", true)\n    return part and part.Position\nend\n\n-- ==========================================\n-- TRASHBAG - AUTO CLEAN/FARM LAMA\n-- ==========================================\n\nlocal function isCarryingTrash()\n    local character = player.Character\n    local trash = character and character:FindFirstChild(\"TrashBag\", true)\n    return trash ~= nil and trash:IsA(\"BasePart\")\nend\n\n-- ==========================================\n-- TELEPORT + PROMPT LAMA\n-- ==========================================\n\nlocal function teleportNear(position, distance)\n    if not alive() then return false end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    if not root or not position then return false end\n\n    local target = position + Vector3.new(0, 1.5, distance or 2)\n    root.CFrame = CFrame.lookAt(target, position)\n    task.wait(0.4)\n\n    return alive()\nend\n\nlocal function activatePrompt(prompt)\n    if not alive() or not prompt\n    or not prompt.Parent or not prompt.Enabled then\n        return false, \"PROMPT TIDAK AKTIF\"\n    end\n\n    if typeof(fireproximityprompt) == \"function\" then\n        local ok = pcall(function()\n            fireproximityprompt(prompt)\n        end)\n\n        if ok then\n            return true, \"FIREPROXIMITYPROMPT\"\n        end\n    end\n\n    local ok = pcall(function()\n        prompt:InputHoldBegin()\n        task.wait(math.max(prompt.HoldDuration, 0.2) + 0.15)\n        prompt:InputHoldEnd()\n    end)\n\n    if ok then\n        return true, \"INPUT HOLD\"\n    end\n\n    return false, \"INTERAKSI GAGAL\"\nend\n\n-- ==========================================\n-- GUI\n-- ==========================================\n\nlocal oldGui = playerGui:FindFirstChild(\"RaelsTricksV18\")\nif oldGui then oldGui:Destroy() end\n\nlocal gui = track(Instance.new(\"ScreenGui\"))\ngui.Name = \"RaelsTricksV18\"\ngui.ResetOnSpawn = false\ngui.DisplayOrder = 999\ngui.Parent = playerGui\n\nlocal frame = Instance.new(\"Frame\")\nframe.Size = UDim2.fromOffset(205, 115)\nframe.Position = UDim2.new(1, -220, 0, 100)\nframe.BackgroundColor3 = Color3.fromRGB(25, 25, 30)\nframe.BorderSizePixel = 0\nframe.Active = true\nframe.Parent = gui\nInstance.new(\"UICorner\", frame).CornerRadius = UDim.new(0, 8)\n\nlocal title = Instance.new(\"TextLabel\")\ntitle.Size = UDim2.new(1, -38, 0, 20)\ntitle.Position = UDim2.fromOffset(5, 0)\ntitle.BackgroundTransparency = 1\ntitle.Text = \"RAEL'S TRICKS V18.2\"\ntitle.TextColor3 = Color3.new(1, 1, 1)\ntitle.TextSize = 11\ntitle.Font = Enum.Font.GothamBold\ntitle.TextXAlignment = Enum.TextXAlignment.Left\ntitle.Parent = frame\n\nlocal minimizeButton = Instance.new(\"TextButton\")\nminimizeButton.Name = \"MinimizeButton\"\nminimizeButton.Size = UDim2.fromOffset(25, 19)\nminimizeButton.Position = UDim2.new(1, -29, 0, 1)\nminimizeButton.BackgroundColor3 = Color3.fromRGB(65, 65, 75)\nminimizeButton.Text = \"-\"\nminimizeButton.TextColor3 = Color3.new(1, 1, 1)\nminimizeButton.TextSize = 16\nminimizeButton.Font = Enum.Font.GothamBold\nminimizeButton.Parent = frame\nInstance.new(\"UICorner\", minimizeButton).CornerRadius = UDim.new(0, 5)\n\nlocal miniButton = Instance.new(\"TextButton\")\nminiButton.Name = \"RaelMiniButton\"\nminiButton.Size = UDim2.fromOffset(42, 42)\nminiButton.Position = UDim2.new(1, -55, 0, 100)\nminiButton.BackgroundColor3 = Color3.fromRGB(35, 100, 65)\nminiButton.Text = \"RT\"\nminiButton.TextColor3 = Color3.new(1, 1, 1)\nminiButton.TextSize = 15\nminiButton.Font = Enum.Font.GothamBold\nminiButton.Visible = false\nminiButton.Active = true\nminiButton.Parent = gui\nInstance.new(\"UICorner\", miniButton).CornerRadius = UDim.new(1, 0)\n\nlocal function makeButton(name, text, x, y, w, color, h)\n    local b = Instance.new(\"TextButton\")\n    b.Name = name\n    b.Size = UDim2.fromOffset(w, h or 29)\n    b.Position = UDim2.fromOffset(x, y)\n    b.BackgroundColor3 = color\n    b.TextColor3 = Color3.new(1, 1, 1)\n    b.TextSize = 10\n    b.Font = Enum.Font.GothamBold\n    b.Text = text\n    b.Parent = frame\n    Instance.new(\"UICorner\", b).CornerRadius = UDim.new(0, 6)\n    return b\nend\n\nlocal cleanButton = makeButton(\n    \"CleanButton\", \"CLEAN: OFF\", 5, 22, 95,\n    Color3.fromRGB(160, 45, 45)\n)\n\nlocal farmButton = makeButton(\n    \"FarmButton\", \"FARM: OFF\", 105, 22, 95,\n    Color3.fromRGB(35, 100, 65)\n)\n\nlocal homeworkButton = makeButton(\n    \"HomeworkButton\", \"HOMEWORK: OFF\", 5, 55, 195,\n    Color3.fromRGB(35, 75, 145), 27\n)\n\nlocal status = Instance.new(\"TextLabel\")\nstatus.Size = UDim2.new(1, -10, 0, 20)\nstatus.Position = UDim2.fromOffset(5, 88)\nstatus.BackgroundTransparency = 1\nstatus.Text = \"Status: READY\"\nstatus.TextColor3 = Color3.fromRGB(255, 220, 120)\nstatus.TextSize = 10\nstatus.Font = Enum.Font.Gotham\nstatus.TextXAlignment = Enum.TextXAlignment.Left\nstatus.Parent = frame\n\nlocal function setStatus(msg)\n    if status and status.Parent then\n        status.Text = \"Status: \" .. msg\n    end\nend\n\nlocal function updateButtons()\n    cleanButton.Text = enabled and \"CLEAN: ON\" or \"CLEAN: OFF\"\n    cleanButton.BackgroundColor3 = enabled\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(160, 45, 45)\n\n    farmButton.Text = autoFarm and \"FARM: ON\" or \"FARM: OFF\"\n    farmButton.BackgroundColor3 = autoFarm\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(35, 100, 65)\n\n    homeworkButton.Text = homeworkEnabled\n        and \"HOMEWORK: ON\" or \"HOMEWORK: OFF\"\n    homeworkButton.BackgroundColor3 = homeworkEnabled\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(35, 75, 145)\nend\n\n-- ==========================================\n-- DRAG\n-- ==========================================\n\nlocal function makeDraggable(object)\n    local dragging = false\n    local dragStart\n    local startPosition\n\n    connect(object.InputBegan, function(input)\n        if input.UserInputType == Enum.UserInputType.Touch\n        or input.UserInputType == Enum.UserInputType.MouseButton1 then\n            dragging = true\n            dragStart = input.Position\n            startPosition = object.Position\n\n            connect(input.Changed, function()\n                if input.UserInputState == Enum.UserInputState.End then\n                    dragging = false\n                end\n            end)\n        end\n    end)\n\n    connect(UIS.InputChanged, function(input)\n        if dragging and (\n            input.UserInputType == Enum.UserInputType.Touch\n            or input.UserInputType == Enum.UserInputType.MouseMovement\n        ) then\n            local delta = input.Position - dragStart\n            object.Position = UDim2.new(\n                startPosition.X.Scale,\n                startPosition.X.Offset + delta.X,\n                startPosition.Y.Scale,\n                startPosition.Y.Offset + delta.Y\n            )\n        end\n    end)\nend\n\nmakeDraggable(frame)\nmakeDraggable(miniButton)\n\nconnect(minimizeButton.Activated, function()\n    frame.Visible = false\n    miniButton.Visible = true\nend)\n\nconnect(miniButton.Activated, function()\n    miniButton.Visible = false\n    frame.Visible = true\nend)\n\n-- ==========================================\n-- HOMEWORK SYSTEM\n-- ==========================================\n\nlocal function hwRoot()\n    local c = player.Character\n    return c and c:FindFirstChild(\"HumanoidRootPart\")\nend\n\nlocal function hwProgress()\n    local pg = player:FindFirstChild(\"PlayerGui\")\n    local ui = pg and pg:FindFirstChild(\"UiGame\")\n    local cleaning = ui and ui:FindFirstChild(\"Cleaning\")\n    if not cleaning then return nil end\n\n    local label = cleaning:FindFirstChild(\"StatusPersen\")\n    local n = label and tonumber((label.Text or \"\"):match(\"(%d+)%s*%%\"))\n    if n then return n end\n\n    local bar = cleaning:FindFirstChild(\"CleaningProgres\")\n    local fill = bar and bar:FindFirstChild(\"Fill\")\n    if fill and fill:IsA(\"Frame\") then\n        return math.floor(fill.Size.X.Scale * 100 + 0.5)\n    end\n    return nil\nend\n\n-- HOMEWORK memakai deteksi recursive sendiri.\n-- Deteksi TrashBag AUTO CLEAN lama tidak diubah.\nlocal function hwCarrying()\n    local c = player.Character\n    return c and c:FindFirstChild(\"TrashBag\", true)\nend\n\nlocal function hwPart(prompt)\n    local x = prompt and prompt.Parent\n    if not x then return nil end\n\n    if x:IsA(\"BasePart\") then\n        return x\n    end\n\n    return x:FindFirstChildWhichIsA(\"BasePart\", true)\nend\n\nlocal function hwForceStand()\n    local character = player.Character\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    if not humanoid then return end\n\n    if humanoid.Sit or humanoid:GetState() == Enum.HumanoidStateType.Seated then\n        humanoid.Sit = false\n        humanoid.Jump = true\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)\n        task.wait(0.08)\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)\n        task.wait(0.08)\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)\n    end\n\n    if root then\n        root.AssemblyLinearVelocity = Vector3.zero\n        root.AssemblyAngularVelocity = Vector3.zero\n    end\nend\n\nlocal function hwMove(prompt)\n    if not alive() or not homeworkEnabled then return false end\n\n    local r = hwRoot()\n    local q = hwPart(prompt)\n    if not r or not q then return false end\n\n    -- Lepaskan kursi sebelum teleport dan mendarat lebih tinggi\n    -- agar tidak langsung menempel ke Seat/VehicleSeat di dekat target.\n    hwForceStand()\n    r = hwRoot()\n    if not r then return false end\n\n    r.CFrame = CFrame.new(q.Position + Vector3.new(0, 3.5, 0))\n    r.AssemblyLinearVelocity = Vector3.zero\n    r.AssemblyAngularVelocity = Vector3.zero\n\n    task.wait(0.15)\n    hwForceStand()\n    task.wait(0.15)\n    hwForceStand()\n\n    return alive() and homeworkEnabled\nend\n\nlocal function hwUse(prompt)\n    if not prompt or not prompt.Parent or not prompt.Enabled then\n        return false\n    end\n\n    if not hwMove(prompt) then return false end\n\n    -- Gunakan interaksi prompt yang sama dengan Auto Clean,\n    -- termasuk fallback InputHoldBegin/End.\n    local ok = activatePrompt(prompt)\n    if not ok then return false end\n\n    task.wait(0.4)\n    return alive() and homeworkEnabled\nend\n\nlocal function hwWaitCarry(value)\n    for i = 1, 40 do\n        if not alive() or not homeworkEnabled then return false end\n\n        if (hwCarrying() ~= nil) == value then\n            return true\n        end\n\n        task.wait(0.25)\n    end\n\n    return false\nend\n\nlocal function hwOwnsHouse(house)\n    if not house then return false end\n    return tonumber(house:GetAttribute(\"OwnerUserId\")) == player.UserId\nend\n\nlocal function hwDispose(house)\n    if not hwCarrying() then return true end\n\n    local r = hwRoot()\n    if not r or not house or not hwOwnsHouse(house) then return false end\n\n    -- Cari zona gedung yang paling dekat dengan rumah milik player.\n    local housePos = house:GetPivot().Position\n    local ownZone, zoneDistance\n\n    for _, zone in ipairs(W:GetChildren()) do\n        if zone.Name:match(\"^ZonaSpawanGedung\") then\n            local nearest\n            for _, part in ipairs(zone:GetDescendants()) do\n                if part:IsA(\"BasePart\") then\n                    local d = (housePos - part.Position).Magnitude\n                    if not nearest or d < nearest then nearest = d end\n                end\n            end\n            if nearest and (not zoneDistance or nearest < zoneDistance) then\n                ownZone, zoneDistance = zone, nearest\n            end\n        end\n    end\n\n    if not ownZone then\n        setStatus(\"ZONA PEMBUANGAN TIDAK DITEMUKAN\")\n        task.wait(1)\n        return false\n    end\n\n    local best, bd\n\n    -- Hanya cari tempat sampah di zona gedung rumah sendiri.\n    for _, v in ipairs(ownZone:GetDescendants()) do\n        if not alive() or not homeworkEnabled then return false end\n\n        if v:IsA(\"ProximityPrompt\")\n        and v.Name == \"BuangPrompt\"\n        and v.ActionText == \"Buang\"\n        and v.Enabled then\n            local q = hwPart(v)\n            if q then\n                local d = (r.Position - q.Position).Magnitude\n                if not bd or d < bd then\n                    best, bd = v, d\n                end\n            end\n        end\n    end\n\n    if not best then\n        setStatus(\"TEMPAT SAMPAH ZONA SENDIRI TIDAK DITEMUKAN\")\n        task.wait(1)\n        return false\n    end\n\n    if not hwUse(best) then return false end\n    return hwWaitCarry(false)\nend\n\nlocal function hwGet(house, mode)\n    local result = {}\n\n    if not house then return result end\n\n    for _, v in ipairs(house:GetDescendants()) do\n        if mode == 1\n        and v:IsA(\"ProximityPrompt\")\n        and v.ActionText == \"Bersihkan\"\n        and v.Enabled then\n            table.insert(result, v)\n\n        elseif mode == 3\n        and v:IsA(\"ProximityPrompt\")\n        and v.ActionText == \"Bersihkan\" then\n            table.insert(result, v)\n\n        elseif mode == 2\n        and v:IsA(\"BasePart\")\n        and v.Name == \"TrashBag\" then\n            local p = v:FindFirstChild(\"AmbilPrompt\")\n\n            if p and p:IsA(\"ProximityPrompt\") and p.Enabled then\n                table.insert(result, p)\n            end\n        end\n    end\n\n    return result\nend\n\nlocal function hwFindHouse()\n    local folder = W:FindFirstChild(\"KosanSpawned\")\n    local r = hwRoot()\n\n    if not folder or not r then return nil end\n\n    local best, bd\n\n    for _, house in ipairs(folder:GetChildren()) do\n        -- HOMEWORK hanya boleh memilih rumah milik player sendiri.\n        if hwOwnsHouse(house) then\n            for _, p in ipairs(hwGet(house, 1)) do\n                local q = hwPart(p)\n\n                if q then\n                    local d = (r.Position - q.Position).Magnitude\n\n                    if not bd or d < bd then\n                        best, bd = house, d\n                    end\n                end\n            end\n        end\n    end\n\n    return best\nend\n\nlocal function hwNearestOwnedHouse()\n    local folder = W:FindFirstChild(\"KosanSpawned\")\n    local r = hwRoot()\n    if not folder or not r then return nil end\n\n    local best, bd\n    for _, house in ipairs(folder:GetChildren()) do\n        if hwOwnsHouse(house) then\n            local ok, pos = pcall(function()\n                return house:GetPivot().Position\n            end)\n            if ok and pos then\n                local d = (r.Position - pos).Magnitude\n                if not bd or d < bd then\n                    best, bd = house, d\n                end\n            end\n        end\n    end\n    return best\nend\n\nlocal function homeworkRun()\n    if homeworkBusy then return end\n    homeworkBusy = true\n\n    -- Jaga karakter tetap berdiri selama Homework aktif.\n    task.spawn(function()\n        while alive() and homeworkEnabled do\n            pcall(hwForceStand)\n            task.wait(0.25)\n        end\n    end)\n\n    while alive() and homeworkEnabled do\n        local folder = W:FindFirstChild(\"KosanSpawned\")\n\n        if not folder then\n            setStatus(\"KOSANSPAWNED TIDAK DITEMUKAN\")\n            task.wait(2)\n            break\n        end\n\n        -- Muatan VIP bisa tetap menempel meski tidak ada rumah\n        -- yang sedang kotor/cooldown. Buang seluruh keranjang sekali.\n        if hwCarrying() then\n            local disposalHouse = hwNearestOwnedHouse()\n            if disposalHouse then\n                setStatus(\"MUATAN KERANJANG VIP - MEMBUANG\")\n                if not hwDispose(disposalHouse) then\n                    setStatus(\"PEMBUANGAN VIP DIULANGI\")\n                    task.wait(1)\n                end\n            else\n                setStatus(\"MUATAN VIP - RUMAH SENDIRI TIDAK DITEMUKAN\")\n                task.wait(1)\n            end\n            continue\n        end\n\n        local house = hwFindHouse()\n\n        -- Prompt Bersihkan disabled berarti cooldown, bukan selesai.\n        if not house then\n            local cooling = false\n            for _, h in ipairs(folder:GetChildren()) do\n                if hwOwnsHouse(h) and #hwGet(h, 3) > 0 then\n                    cooling = true\n                    break\n                end\n            end\n\n            if cooling then\n                setStatus(\"MENUNGGU COOLDOWN RUMAH\")\n            else\n                setStatus(\"ZONA BERSIH - MEMANTAU RUMAH\")\n            end\n\n            -- Jangan matikan Homework. Tetap ON dan scan ulang,\n            -- karena rumah bisa kotor lagi setelah beberapa saat.\n            task.wait(1)\n        else\n\n        setStatus(\"HOMEWORK: MEMBERSIHKAN RUMAH\")\n\n        -- Bersihkan semua prompt di rumah terpilih.\n        local done = {}\n\n        while alive() and homeworkEnabled do\n            local prompt\n\n            for _, p in ipairs(hwGet(house, 1)) do\n                if not done[p] then\n                    prompt = p\n                    break\n                end\n            end\n\n            if not prompt then break end\n\n            if not hwUse(prompt) then\n                if homeworkEnabled then\n                    setStatus(\"GAGAL MEMBERSIHKAN\")\n                end\n                break\n            end\n\n            done[prompt] = true\n            task.wait(0.2)\n        end\n\n        if not alive() or not homeworkEnabled then break end\n\n        -- Kunci rumah ini sampai sampahnya benar-benar selesai.\n        setStatus(\"HOMEWORK: MENUNGGU SAMPAH\")\n        local hadTrash = false\n        local quiet = 0\n        local batchCount = 0\n        local triedBags = {}\n\n        while alive() and homeworkEnabled do\n            if hwCarrying() then\n                hadTrash = true\n                local bags = hwGet(house, 2)\n                local nextBag\n\n                -- VIP: 5 sampah di keranjang + 1 di tangan.\n                -- Kumpulkan sampai 6 atau sampai tidak ada sampah\n                -- lain yang bisa diambil, baru buang sekali.\n                if batchCount < 6 then\n                    for _, p in ipairs(bags) do\n                        if not triedBags[p] then\n                            nextBag = p\n                            break\n                        end\n                    end\n                end\n\n                if nextBag then\n                    triedBags[nextBag] = true\n                    setStatus(\"HOMEWORK: MUAT KERANJANG \"..batchCount..\"/6\")\n\n                    if hwUse(nextBag) then\n                        -- Tunggu server menghapus/nonaktifkan prompt\n                        -- sebagai konfirmasi sampah berhasil diambil.\n                        local collected = false\n                        for _ = 1, 12 do\n                            if not nextBag.Parent or not nextBag.Enabled then\n                                collected = true\n                                break\n                            end\n                            task.wait(0.2)\n                        end\n                        if collected then\n                            batchCount += 1\n                        end\n                    end\n                    task.wait(0.15)\n                else\n                    setStatus(\"HOMEWORK: MEMBUANG \"..batchCount..\" SAMPAH\")\n                    if not hwDispose(house) then\n                        setStatus(\"ULANGI PEMBUANGAN SAMPAH\")\n                        task.wait(0.5)\n                        continue\n                    end\n                    batchCount = 0\n                    triedBags = {}\n                end\n\n            else\n                local bags = hwGet(house, 2)\n\n                if #bags > 0 then\n                    hadTrash = true\n                    quiet = 0\n                    setStatus(\"HOMEWORK: MENGAMBIL SAMPAH\")\n\n                    if not hwUse(bags[1])\n                    or not hwWaitCarry(true) then\n                        setStatus(\"GAGAL MENGAMBIL SAMPAH\")\n                        break\n                    end\n\n                    batchCount = 1\n                    triedBags = {[bags[1]] = true}\n                    task.wait(0.2)\n\n                elseif #hwGet(house, 1) > 0 then\n                    quiet = 0\n                    local cleanPrompts = hwGet(house, 1)\n                    local pendingClean\n\n                    for _, p in ipairs(cleanPrompts) do\n                        if not done[p] then\n                            pendingClean = p\n                            break\n                        end\n                    end\n\n                    -- Ulangi satu putaran jika semua prompt sudah dicoba,\n                    -- tetapi progres belum 100% dan sampah belum muncul.\n                    if not pendingClean and #cleanPrompts > 0 then\n                        done = {}\n                        pendingClean = cleanPrompts[1]\n                    end\n\n                    if pendingClean then\n                        setStatus(\"HOMEWORK: MELANJUTKAN BERSIHKAN\")\n                        if hwUse(pendingClean) then\n                            done[pendingClean] = true\n                        else\n                            setStatus(\"GAGAL MELANJUTKAN BERSIHKAN\")\n                            break\n                        end\n                        task.wait(0.2)\n                    else\n                        task.wait(0.5)\n                    end\n\n                else\n                    -- Hanya anggap selesai setelah sampah pernah muncul\n                    -- lalu rumah kosong stabil selama 5 detik.\n                    if hadTrash then\n                        local progress = hwProgress()\n                        if progress and progress >= 100 then\n                            quiet += 1\n                            if quiet >= 1 then break end\n                        else\n                            quiet = 0\n                            setStatus(\"HOMEWORK: MENUNGGU 100%\")\n                        end\n                    end\n                    task.wait(1)\n                end\n            end\n        end\n\n        if not alive() or not homeworkEnabled then break end\n\n        -- Rumah selesai, cari rumah kotor berikutnya.\n        if #hwGet(house, 1) > 0\n        or #hwGet(house, 2) > 0\n        or hwCarrying() then\n            setStatus(\"SAMPAH BELUM SELESAI\")\n            break\n        end\n\n        task.wait(0.3)\n        end\n    end\n\n    homeworkBusy = false\n\n    -- Cleanup aman: jangan biarkan error di pemeriksaan status\n    -- mematikan fitur atau memunculkan HOMEWORK ERROR palsu.\n    pcall(updateButtons)\n\n    if env.RaelV18Running and env.RaelV18Session == SESSION then\n        homeworkEnabled = false\n        pcall(updateButtons)\n\n        if autoFarm then\n            pcall(setStatus, \"HOMEWORK SELESAI - FARM LANJUT\")\n        else\n            pcall(setStatus, \"HOMEWORK SELESAI\")\n        end\n    end\nend\n\n-- ==========================================\n-- BUTTON EVENTS\n-- ==========================================\n\nconnect(cleanButton.Activated, function()\n    if not alive() then return end\n    if autoFarm or homeworkEnabled or homeworkBusy then return end\n\n    enabled = not enabled\n    updateButtons()\nend)\n\nconnect(homeworkButton.Activated, function()\n    if not alive() then return end\n\n    if homeworkEnabled then\n        homeworkEnabled = false\n        setStatus(\"HOMEWORK DIMATIKAN\")\n        updateButtons()\n        return\n    end\n\n    if homeworkBusy then return end\n\n    homeworkEnabled = true\n    updateButtons()\n    setStatus(\"HOMEWORK DIMULAI\")\n\n    task.spawn(function() local ok,err=xpcall(homeworkRun,function(e) local d=debug; if d and d.traceback then return d.traceback(tostring(e),2) end; return tostring(e) end); if not ok then homeworkEnabled=false; homeworkBusy=false; pcall(updateButtons); pcall(setStatus,\"HOMEWORK ERROR: \"..tostring(err):sub(1,120)); pcall(function() warn(\"RAEL HOMEWORK TRACEBACK:\\n\"..tostring(err)) end); pcall(function() if setclipboard then setclipboard(\"RAEL HOMEWORK TRACEBACK:\\n\"..tostring(err)) end end) end end)\nend)\n\n-- ==========================================\n-- AUTO CLEANER TARGET\n-- ==========================================\n\nlocal function getNearest(root)\n    local now = os.clock()\n    local carryingTrash = isCarryingTrash()\n    local nearest\n    local shortest = math.huge\n\n    for prompt in pairs(prompts) do\n        if prompt.Parent and prompt.Enabled and isAllowed(prompt) then\n            if autoFarm and isDroppingPrompt(prompt) then\n                continue\n            end\n\n            local action = (prompt.ActionText or \"\"):lower()\n            local isClean = action:find(\"bersihkan\", 1, true)\n            local isTake = action:find(\"ambil\", 1, true)\n            local isDrop = action:find(\"buang\", 1, true)\n\n            if isTake and carryingTrash then continue end\n            if isDrop and not carryingTrash then continue end\n\n            local ready = not lastAttempt[prompt]\n                or now - lastAttempt[prompt] >= RETRY_DELAY\n\n            if ready then\n                local pos = getPosition(prompt)\n                local range = isClean and RANGE_CLEAN or RANGE_TRASH\n\n                if pos then\n                    local distance = (root.Position - pos).Magnitude\n\n                    if distance <= range and distance < shortest then\n                        nearest = prompt\n                        shortest = distance\n                    end\n                end\n            end\n        end\n    end\n\n    return nearest\nend\n\n-- ==========================================\n-- DROPPING SCANNER\n-- ==========================================\n\nlocal function findNextDropping()\n    local folder = getDroppingFolder()\n\n    if not folder then\n        return nil, nil, false, false, false\n    end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n\n    if not root then\n        return nil, nil, true, false, false\n    end\n\n    local now = os.clock()\n    local nearestReady, nearestReadyPos\n    local nearestWaiting, nearestWaitingPos\n    local nearestReadyDistance = math.huge\n    local nearestWaitingDistance = math.huge\n    local hasDroppings = false\n\n    for _, obj in ipairs(folder:GetDescendants()) do\n        if obj:IsA(\"ProximityPrompt\")\n        and isDroppingPrompt(obj)\n        and obj.Enabled then\n\n            hasDroppings = true\n\n            local pos = getPosition(obj)\n\n            if pos then\n                local distance = (root.Position - pos).Magnitude\n                local last = collectCooldown[obj]\n                local ready = not last or now - last >= DROPPING_RETRY\n\n                if ready and distance < nearestReadyDistance then\n                    nearestReady = obj\n                    nearestReadyPos = pos\n                    nearestReadyDistance = distance\n                elseif not ready and distance < nearestWaitingDistance then\n                    nearestWaiting = obj\n                    nearestWaitingPos = pos\n                    nearestWaitingDistance = distance\n                end\n            elseif not nearestWaiting then\n                nearestWaiting = obj\n            end\n        end\n    end\n\n    if nearestReady then\n        return nearestReady, nearestReadyPos, true, true, false\n    end\n\n    if hasDroppings then\n        return nearestWaiting, nearestWaitingPos, true, true, true\n    end\n\n    return nil, nil, true, false, false\nend\n\n-- ==========================================\n-- FEED TOOL\n-- ==========================================\n\nlocal function findCabai()\n    local character = player.Character\n\n    local function search(container)\n        if not container then return nil end\n\n        for _, tool in ipairs(container:GetChildren()) do\n            local name = tool.Name:lower()\n\n            if tool:IsA(\"Tool\")\n            and name:find(\"cabai\", 1, true)\n            and not name:find(\"bibit\", 1, true) then\n                return tool\n            end\n        end\n    end\n\n    return search(character) or search(backpack)\nend\n\nlocal function equipCabai()\n    local tool = findCabai()\n    local character = player.Character\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n\n    if not tool or not humanoid then return false end\n\n    if tool.Parent ~= character then\n        humanoid:EquipTool(tool)\n        task.wait(0.7)\n    end\n\n    return tool.Parent == character\nend\n\n-- ==========================================\n-- FEED STOCK\n-- ==========================================\n\nlocal function getStock(palung)\n    if not palung then return nil end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"TextLabel\") or obj:IsA(\"TextButton\") then\n            local txt = (obj.Text or \"\"):lower()\n            local name = obj.Name:lower()\n\n            if txt:find(\"pakan\", 1, true)\n            or name:find(\"pakan\", 1, true) then\n                local amount = txt:match(\"(%d+)%s*/%s*100\")\n                if amount then return tonumber(amount) end\n            end\n        end\n    end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"TextLabel\") or obj:IsA(\"TextButton\") then\n            local amount = (obj.Text or \"\"):match(\"(%d+)%s*/%s*100\")\n            if amount then return tonumber(amount) end\n        end\n    end\n\n    return nil\nend\n\n-- ==========================================\n-- FEED PROMPT\n-- ==========================================\n\nlocal function findFeedPrompt(palung)\n    if not palung then return nil end\n\n    local direct = palung:FindFirstChild(\"IsiPakanPrompt\", true)\n\n    if direct and direct:IsA(\"ProximityPrompt\") then\n        return direct\n    end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"ProximityPrompt\") then\n            local action = (obj.ActionText or \"\"):lower()\n            local object = (obj.ObjectText or \"\"):lower()\n            local name = obj.Name:lower()\n\n            if action:find(\"isi\", 1, true)\n            or object:find(\"pakan\", 1, true)\n            or name:find(\"isi\", 1, true)\n            or name:find(\"pakan\", 1, true) then\n                return obj\n            end\n        end\n    end\n\n    return nil\nend\n\n-- ==========================================\n-- GET FEEDERS\n-- ==========================================\n\nlocal function getFeeders()\n    local result = {}\n    local kandang = getCurrentKandang()\n\n    if not kandang then return result end\n\n    local pen = getCurrentPen()\n\n    if pen then\n        for _, name in ipairs({\"Palung_1\", \"Palung_2\"}) do\n            local palung = pen:FindFirstChild(name, true)\n\n            if palung then\n                table.insert(result, {\n                    name = name,\n                    object = palung\n                })\n            end\n        end\n    end\n\n    local number = getKandangNumber()\n    local farm = W:FindFirstChild(\"TernakLokal\")\n\n    if farm and number then\n        for _, name in ipairs({\n            \"Palung_Kandang_\" .. number .. \"_1\",\n            \"Palung_Kandang_\" .. number .. \"_2\"\n        }) do\n            local palung = farm:FindFirstChild(name, true)\n\n            if palung then\n                local exists = false\n\n                for _, entry in ipairs(result) do\n                    if entry.object == palung then\n                        exists = true\n                    end\n                end\n\n                if not exists then\n                    table.insert(result, {\n                        name = name,\n                        object = palung\n                    })\n                end\n            end\n        end\n    end\n\n    return result\nend\n\n-- ==========================================\n-- AUTO FEED ONLY AT 0/100\n-- ==========================================\n\nlocal function feedOne()\n    if hwCarrying() then\n        setStatus(\"SAMPAH HOMEWORK BELUM DIBUANG\")\n        return false\n    end\n\n    local feeders = getFeeders()\n\n    if #feeders == 0 then\n        setStatus(\"PALUNG TIDAK DITEMUKAN\")\n        return false\n    end\n\n    local foundZero = false\n    local attempted = false\n\n    for _, entry in ipairs(feeders) do\n        if not alive() or not autoFarm\n        or homeworkEnabled or homeworkBusy then\n            return false\n        end\n\n        local stock = getStock(entry.object)\n\n        if stock == nil then\n            setStatus(entry.name .. \": STOK TIDAK TERBACA\")\n            continue\n        end\n\n        if stock ~= 0 then continue end\n        foundZero = true\n\n        local now = os.clock()\n        local last = feedCooldown[entry.name]\n\n        if last and now - last < FEED_RETRY then\n            continue\n        end\n\n        attempted = true\n\n        if not equipCabai() then\n            setStatus(\"CABAI TIDAK DITEMUKAN\")\n            return false\n        end\n\n        local prompt = findFeedPrompt(entry.object)\n\n        if not prompt then\n            setStatus(entry.name .. \": PROMPT ISI TIDAK ADA\")\n            feedCooldown[entry.name] = os.clock()\n            continue\n        end\n\n        if not prompt.Enabled then\n            setStatus(entry.name .. \": PROMPT ISI NONAKTIF\")\n            feedCooldown[entry.name] = os.clock()\n            continue\n        end\n\n        local position = getPosition(prompt)\n            or getObjectPosition(entry.object)\n\n        if not position then\n            setStatus(entry.name .. \": POSISI PALUNG GAGAL\")\n            continue\n        end\n\n        setStatus(entry.name .. \": MENGISI PAKAN 0/100\")\n\n        if not teleportNear(position, 2) then continue end\n\n        if not alive() or not autoFarm\n        or homeworkEnabled or homeworkBusy then\n            continue\n        end\n\n        local ok = activatePrompt(prompt)\n\n        if not ok then\n            feedCooldown[entry.name] = os.clock()\n            setStatus(entry.name .. \": INTERAKSI GAGAL\")\n            continue\n        end\n\n        local start = os.clock()\n        local newStock = getStock(entry.object)\n\n        while alive() and autoFarm\n        and not homeworkEnabled and not homeworkBusy\n        and os.clock() - start < 6 do\n            task.wait(0.25)\n\n            newStock = getStock(entry.object)\n\n            if newStock ~= nil and newStock > 0 then\n                break\n            end\n        end\n\n        if newStock ~= nil and newStock > 0 then\n            feedCooldown[entry.name] = nil\n            setStatus(entry.name .. \": PAKAN \" .. newStock .. \"/100\")\n        else\n            feedCooldown[entry.name] = os.clock()\n            setStatus(entry.name .. \": PENGISIAN BELUM BERHASIL\")\n        end\n    end\n\n    if not foundZero then\n        setStatus(\"PAKAN BELUM 0/100\")\n    elseif not attempted then\n        setStatus(\"MENUNGGU COOLDOWN PAKAN\")\n    end\n\n    return attempted\nend\n\n-- ==========================================\n-- REGISTER PROMPTS\n-- ==========================================\n\nfor _, obj in ipairs(W:GetDescendants()) do\n    addPrompt(obj)\nend\n\nconnect(W.DescendantAdded, function(obj)\n    if alive() then addPrompt(obj) end\nend)\n\n-- ==========================================\n-- AUTO CLEANER LOOP\n-- ==========================================\n\ntask.spawn(function()\n    while alive() and gui.Parent do\n        task.wait(SCAN_DELAY)\n\n        if not enabled or busy\n        or homeworkEnabled or homeworkBusy\n        or hwCarrying() then\n            continue\n        end\n\n        local character = player.Character\n        local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n\n        if not root then continue end\n\n        local prompt = getNearest(root)\n\n        if prompt and enabled\n        and not homeworkEnabled and not homeworkBusy then\n            busy = true\n            lastAttempt[prompt] = os.clock()\n\n            activatePrompt(prompt)\n            task.wait(0.1)\n\n            busy = false\n        end\n    end\nend)\n\n-- ==========================================\n-- AUTO FARM LOOP\n-- ==========================================\n\ntask.spawn(function()\n    local emptyScans = 0\n\n    while alive() and gui.Parent do\n        task.wait(0.5)\n\n        if not autoFarm then\n            emptyScans = 0\n            continue\n        end\n\n        -- HOMEWORK PRIORITY\n        if homeworkEnabled or homeworkBusy then\n            continue\n        end\n\n        -- Jangan biarkan Auto Farm membawa karakter ke kandang\n        -- ketika TrashBag Homework masih menempel di karakter.\n        if hwCarrying() then\n            setStatus(\"SAMPAH HOMEWORK BELUM DIBUANG\")\n            continue\n        end\n\n        enabled = true\n        updateButtons()\n\n        if not getCurrentKandang() then\n            setStatus(\"MEMBACA DATA KANDANG\")\n            emptyScans = 0\n            continue\n        end\n\n        local folder = getDroppingFolder()\n\n        if not folder then\n            emptyScans += 1\n\n            if emptyScans < 3 then\n                setStatus(\"FOLDER KOTORAN TIDAK ADA - CEK ULANG\")\n                continue\n            end\n\n            setStatus(\"TIDAK ADA KOTORAN - CEK PAKAN\")\n            feedOne()\n            emptyScans = 0\n            continue\n        end\n\n        local prompt, pos, scanReady, hasDroppings, waiting =\n            findNextDropping()\n\n        if not scanReady then\n            emptyScans += 1\n\n            if emptyScans < 3 then\n                setStatus(\"SCAN KOTORAN - CEK ULANG\")\n                continue\n            end\n\n            setStatus(\"KOTORAN TIDAK TERDETEKSI - CEK PAKAN\")\n            feedOne()\n            emptyScans = 0\n            continue\n        end\n\n        if hasDroppings then\n            emptyScans = 0\n\n            if waiting then\n                setStatus(\"KOTORAN MENUNGGU COOLDOWN\")\n                continue\n            end\n\n            if not prompt or not pos then\n                setStatus(\"POSISI KOTORAN TIDAK TERBACA\")\n                continue\n            end\n\n            setStatus(\"MENUJU KOTORAN\")\n\n            if not teleportNear(pos, 1.5) then\n                collectCooldown[prompt] = os.clock()\n                continue\n            end\n\n            if not alive() or not autoFarm\n            or homeworkEnabled or homeworkBusy then\n                continue\n            end\n\n            local activated, method = activatePrompt(prompt)\n\n            if not activated then\n                collectCooldown[prompt] = os.clock()\n                setStatus(\"INTERAKSI GAGAL\")\n                continue\n            end\n\n            setStatus(\"MENCOBA AMBIL: \" .. method)\n\n            local start = os.clock()\n            local collected = false\n\n            while alive() and autoFarm\n            and not homeworkEnabled and not homeworkBusy\n            and os.clock() - start < 4 do\n                task.wait(0.15)\n\n                if not prompt.Parent\n                or not prompt:IsDescendantOf(folder)\n                or not prompt.Enabled then\n                    collected = true\n                    break\n                end\n            end\n\n            if collected then\n                collectCooldown[prompt] = nil\n                setStatus(\"KOTORAN TERAMBIL\")\n            else\n                collectCooldown[prompt] = os.clock()\n                setStatus(\"BELUM TERAMBIL - COBA ULANG\")\n            end\n\n            continue\n        end\n\n        emptyScans += 1\n\n        if emptyScans < 3 then\n            setStatus(\"MEMASTIKAN KOTORAN HABIS\")\n            continue\n        end\n\n        setStatus(\"KOTORAN HABIS - CEK PAKAN\")\n        feedOne()\n        emptyScans = 0\n    end\nend)\n\n-- ==========================================\n-- TP LOCATION\n-- ==========================================\n\nlocal oldTool = backpack:FindFirstChild(\"TP LOCATION\")\n    or (player.Character and player.Character:FindFirstChild(\"TP LOCATION\"))\n\nif oldTool then oldTool:Destroy() end\n\nlocal tool = track(Instance.new(\"Tool\"))\ntool.Name = \"TP LOCATION\"\ntool.RequiresHandle = false\ntool.CanBeDropped = false\ntool.Parent = backpack\n\nlocal tpEquipped = false\nlocal equipTime = 0\n\nconnect(tool.Equipped, function()\n    tpEquipped = true\n    equipTime = os.clock()\nend)\n\nconnect(tool.Unequipped, function()\n    tpEquipped = false\nend)\n\nconnect(UIS.TouchTapInWorld, function(position, processed)\n    if not alive() or not tpEquipped or processed then return end\n    if os.clock() - equipTime < 0.25 then return end\n\n    local camera = W.CurrentCamera\n    if not camera then return end\n\n    local ray = camera:ViewportPointToRay(position.X, position.Y)\n    local params = RaycastParams.new()\n    params.FilterType = Enum.RaycastFilterType.Exclude\n    params.FilterDescendantsInstances = {player.Character}\n\n    local result = W:Raycast(ray.Origin, ray.Direction * 1500, params)\n    if not result then return end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n\n    if not root or not humanoid then return end\n\n    local height = humanoid.HipHeight + root.Size.Y / 2\n\n    root.CFrame = CFrame.new(\n        result.Position.X,\n        result.Position.Y + height + 0.15,\n        result.Position.Z\n    )\nend)\n\n-- ==========================================\n-- ANTI AFK\n-- ==========================================\n\nconnect(player.Idled, function()\n    if not alive() then return end\n\n    pcall(function()\n        VirtualUser:CaptureController()\n        VirtualUser:ClickButton2(Vector2.new(0, 0))\n    end)\nend)\n\n-- ==========================================\n-- GUI DESTROY GUARD\n-- ==========================================\n\nconnect(gui.Destroying, function()\n    if env.RaelV18Session == SESSION then\n        env.RaelV18Running = false\n    end\nend)\n\n-- ==========================================\n-- FINISH\n-- ==========================================\n\nupdateButtons()\nsetStatus(\"READY - FARM OFF\")\n\nprint(\"RAEL'S TRICKS V18.2 + HOMEWORK LOADED\")\nprint(\"AUTO CLEAN READY\")\nprint(\"AUTO FARM READY\")\nprint(\"HOMEWORK READY - SEPARATE TOGGLE\")\nprint(\"AUTO FEED WHEN FOLDER MISSING\")\nprint(\"FEED ONLY AT 0/100\")\nprint(\"MINIMIZE + REOPEN READY\")\nprint(\"TP LOCATION + ANTI AFK READY\")\nprint(\"NO STOP ALL\")\n"

local function reportLoaderError(message)
    local report = "RAEL LOADER DIAGNOSTIC: " .. tostring(message)
    pcall(function() if setclipboard then setclipboard(report) end end)
    pcall(function() warn(report) end)
    return report
end

local function replaceOnce(old, new, label)
    local first, last = source:find(old, 1, true)
    if not first then
        error(reportLoaderError("BAGIAN TIDAK DITEMUKAN - " .. label))
    end
    source = source:sub(1, first - 1) .. new .. source:sub(last + 1)
end

local function replaceBetween(startMarker, endMarker, newText, label)
    local first = source:find(startMarker, 1, true)
    if not first then
        error(reportLoaderError("AWAL BAGIAN TIDAK DITEMUKAN - " .. label))
    end

    local last = source:find(endMarker, first, true)
    if not last then
        error(reportLoaderError("AKHIR BAGIAN TIDAK DITEMUKAN - " .. label))
    end

    source = source:sub(1, first - 1) .. newText .. "\n\n" .. source:sub(last)
end

replaceOnce(
    "local autoFarm = false",
    "local autoFarm = false\nlocal farmPauseHomework = false\nlocal autoConvert = true\nlocal autoFeedEnabled = true\nlocal antiAfkEnabled = true\nlocal tpEnabled = true",
    "FEATURE FLAGS + FARM MOVEMENT LOCK"
)

-- ==========================================
-- TP LOCATION INPUT + RAYCAST FIX
-- ==========================================

local tpLocationCode = [==[
-- ==========================================
-- TP LOCATION
-- ==========================================

local oldTool = backpack:FindFirstChild("TP LOCATION")
    or (player.Character and player.Character:FindFirstChild("TP LOCATION"))

if oldTool then oldTool:Destroy() end

local tool = track(Instance.new("Tool"))
tool.Name = "TP LOCATION"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = backpack

local tpEquipped = false
local equipTime = 0
local tpBusy = false

connect(tool.Equipped, function()
    tpEquipped = true
    equipTime = os.clock()
    setStatus("TP LOCATION SIAP - PILIH AREA")
end)

connect(tool.Unequipped, function()
    tpEquipped = false
    tpBusy = false
end)

local function tpAtScreenPoint(point, source)
    if not alive() or not tpEnabled or not tpEquipped then return false end
    if tpBusy then return false end
    if typeof(point) ~= "Vector2" then return false end

    local camera = W.CurrentCamera
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not camera or not root or not humanoid then
        setStatus("TP GAGAL - KARAKTER/KAMERA TIDAK SIAP")
        return false
    end

    tpBusy = true
    local ok, result = pcall(function()
        local ray = camera:ScreenPointToRay(point.X, point.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {character}
        params.IgnoreWater = false

        return W:Raycast(ray.Origin, ray.Direction * 2000, params)
    end)

    if not ok then
        tpBusy = false
        setStatus("TP RAYCAST ERROR - " .. tostring(result):sub(1, 55))
        return false
    end

    if not result then
        tpBusy = false
        setStatus("TP GAGAL - AREA TIDAK TERDETEKSI")
        return false
    end

    local height = humanoid.HipHeight + root.Size.Y / 2 + 0.2
    local target = result.Position + Vector3.new(0, height, 0)

    local moved = pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = CFrame.new(target)
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)

    tpBusy = false

    if moved then
        setStatus("TP BERHASIL - " .. tostring(source))
        return true
    end

    setStatus("TP GAGAL - TELEPORT ERROR")
    return false
end

-- TouchTapInWorld mengirim ARRAY Vector2, bukan satu Vector2.
connect(UIS.TouchTapInWorld, function(touchPositions, processedByUI)
    if processedByUI or not alive() or not tpEnabled or not tpEquipped then
        return
    end

    local point
    if typeof(touchPositions) == "Vector2" then
        point = touchPositions
    elseif type(touchPositions) == "table" then
        point = touchPositions[1]
    end

    tpAtScreenPoint(point, "TOUCH")
end)

-- Dukungan klik mouse untuk PC.
connect(UIS.InputBegan, function(input, processedByUI)
    if processedByUI or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end
    if not alive() or not tpEnabled or not tpEquipped then return end

    local point = UIS:GetMouseLocation()
    tpAtScreenPoint(point, "MOUSE")
end)

]==]

replaceBetween(
    "-- TP LOCATION\n-- ==========================================",
    "-- ==========================================\n-- ANTI AFK",
    tpLocationCode,
    "TP LOCATION INPUT + RAYCAST FIX"
)

-- ==========================================
-- AUTO CONVERT SYSTEM
-- ==========================================

-- ==========================================
-- CORE GUI - CLEANER / HOMEWORK / ANTI-AFK / TP
-- ==========================================

local guiCode = [==[
local oldGui = playerGui:FindFirstChild("RaelsTricksV1")
if oldGui then oldGui:Destroy() end
local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelsTricksV1"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui
local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(252, 280)
frame.Position = UDim2.new(1, -266, 0, 95)
frame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 43)
header.BackgroundColor3 = Color3.fromRGB(17, 94, 89)
header.BorderSizePixel = 0
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 21)
title.Position = UDim2.fromOffset(12, 5)
title.BackgroundTransparency = 1
title.Text = "RAEL'S TRICKS"
title.TextColor3 = Color3.fromRGB(240, 253, 250)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.fromOffset(27, 25)
minimizeButton.Position = UDim2.new(1, -35, 0, 9)
minimizeButton.BackgroundColor3 = Color3.fromRGB(15, 118, 110)
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 15
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = header
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 7)
local miniButton = Instance.new("TextButton")
miniButton.Name = "RaelMiniButton"
miniButton.Size = UDim2.fromOffset(46, 46)
miniButton.Position = UDim2.new(1, -60, 0, 95)
miniButton.BackgroundColor3 = Color3.fromRGB(13, 148, 136)
miniButton.Text = "RT"
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.TextSize = 16
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Active = true
miniButton.Parent = gui
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)
local function makeToggle(name, label, x, y, width)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.fromOffset(width or 110, 32)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
    b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(248, 250, 252)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Text = label .. ": OFF"
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end
local cleanButton = makeToggle("CleanButton", "CLEANER", 12, 58)
local homeworkButton = makeToggle("HomeworkButton", "HOMEWORK", 130, 58)
local afkButton = makeToggle("AfkButton", "ANTI-AFK", 12, 98)
local tpButton = makeToggle("TpButton", "TP LOCATION", 130, 98)
local farmButton = makeToggle("FarmButton", "AUTO FARM", 12, 195, 228)
local statusPanel = Instance.new("Frame")
statusPanel.Size = UDim2.new(1, -24, 0, 42)
statusPanel.Position = UDim2.fromOffset(12, 145)
statusPanel.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
statusPanel.BorderSizePixel = 0
statusPanel.Parent = frame
Instance.new("UICorner", statusPanel).CornerRadius = UDim.new(0, 7)
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -14, 1, -8)
status.Position = UDim2.fromOffset(7, 4)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(253, 230, 138)
status.TextSize = 9
status.Font = Enum.Font.GothamMedium
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = statusPanel
local function setStatus(msg)
    if status and status.Parent then status.Text = "STATUS: " .. tostring(msg) end
end
local function paintToggle(button, label, state)
    button.Text = label .. (state and ": ON" or ": OFF")
    button.BackgroundColor3 = state and Color3.fromRGB(5, 150, 105) or Color3.fromRGB(127, 29, 29)
end
local function updateButtons()
    paintToggle(cleanButton, "CLEANER", enabled)
    paintToggle(homeworkButton, "HOMEWORK", homeworkEnabled)
    paintToggle(afkButton, "ANTI-AFK", antiAfkEnabled)
    paintToggle(tpButton, "TP LOCATION", tpEnabled)
    paintToggle(farmButton, "AUTO FARM", autoFarm)
end
local function makeDraggable(object)
    local dragging, dragStart, startPosition
    connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position
            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    connect(UIS.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(frame)
makeDraggable(miniButton)
connect(minimizeButton.Activated, function() frame.Visible = false miniButton.Visible = true end)
connect(miniButton.Activated, function() miniButton.Visible = false frame.Visible = true end)
connect(cleanButton.Activated, function()
    if not alive() or homeworkEnabled or homeworkBusy then return end
    enabled = not enabled
    updateButtons()
end)
connect(afkButton.Activated, function()
    if not alive() then return end
    antiAfkEnabled = not antiAfkEnabled
    updateButtons()
    setStatus(antiAfkEnabled and "ANTI-AFK AKTIF" or "ANTI-AFK NONAKTIF")
end)
connect(tpButton.Activated, function()
    if not alive() then return end
    tpEnabled = not tpEnabled
    updateButtons()
    setStatus(tpEnabled and "TP LOCATION AKTIF" or "TP LOCATION NONAKTIF")
end)
connect(farmButton.Activated, function()
    if not alive() then return end
    autoFarm = not autoFarm
    if autoFarm then
        setStatus("AUTO FARM AKTIF - MELANJUTKAN SIKLUS")
    else
        setStatus("AUTO FARM NONAKTIF")
    end
    updateButtons()
end)
]==]

replaceBetween(
    "-- ==========================================\n-- GUI\n-- ==========================================",
    "-- ==========================================\n-- HOMEWORK SYSTEM",
    guiCode,
    "MODERN GUI + AUTO GACHA"
)

-- ==========================================
-- TOGGLE ANTI-AFK
-- ==========================================

replaceOnce(
    "connect(player.Idled, function()\n    if not alive() then return end",
    "connect(player.Idled, function()\n    if not alive() or not antiAfkEnabled then return end",
    "ANTI-AFK TOGGLE"
)

-- ==========================================
-- TOGGLE TP LOCATION
-- ==========================================
-- tpEnabled sudah diperiksa langsung oleh TP LOCATION INPUT + RAYCAST FIX.

-- ==========================================
-- UBAH LABEL VERSI
-- ==========================================

source = source:gsub("V18%.2", "V1")
source = source:gsub("V18%.3", "V1")

-- ==========================================
-- INTEGRASI AUTO ACC
-- ==========================================

source = source:gsub("frame.Size = UDim2.fromOffset%(205, 115%)",
    "frame.Size = UDim2.fromOffset(205, 180)")
source = source:gsub("status.Position = UDim2.fromOffset%(5, 88%)",
    "status.Position = UDim2.fromOffset(5, 155)")

source = source .. [==[

-- ==========================================
-- AUTO ACC - TERINTEGRASI KE RAEL'S TRICKS

local autoAccEnabled = false
local autoAccBusy = false
local autoAccLast = {}
local autoAccVIM = game:GetService("VirtualInputManager")

-- Buat tombol langsung agar tidak bergantung pada helper GUI lokal.
local autoAccButton = Instance.new("TextButton")
autoAccButton.Name = "AutoAccButton"
autoAccButton.Size = UDim2.fromOffset(110, 32)
autoAccButton.Position = UDim2.fromOffset(12, 235)
autoAccButton.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
autoAccButton.BorderSizePixel = 0
autoAccButton.Text = "AUTO ACC: OFF"
autoAccButton.TextColor3 = Color3.fromRGB(248, 250, 252)
autoAccButton.TextSize = 10
autoAccButton.Font = Enum.Font.GothamBold
autoAccButton.Parent = frame
Instance.new("UICorner", autoAccButton).CornerRadius = UDim.new(0, 7)

local function setAutoAcc(enabled)
    autoAccEnabled = enabled
    autoAccButton.Text = enabled and "AUTO ACC: ON" or "AUTO ACC: OFF"
    autoAccButton.BackgroundColor3 = enabled
        and Color3.fromRGB(5, 150, 105)
        or Color3.fromRGB(127, 29, 29)
    setStatus(enabled and "AUTO ACC AKTIF - MENUNGGU PERMINTAAN"
        or "AUTO ACC NONAKTIF")
end

connect(autoAccButton.Activated, function()
    if not alive() then return end
    setAutoAcc(not autoAccEnabled)
end)

local function getAutoAccCards()
    local found = {}
    local requestUI = playerGui:FindFirstChild("PermintaanSewaUI")
    local stack = requestUI and requestUI:FindFirstChild("Tumpukan")
    if not requestUI or not requestUI.Enabled or not stack then
        return found
    end

    for _, card in ipairs(stack:GetChildren()) do
        if card.Name:match("^Kartu_%d+$") and card.Visible then
            local isi = card:FindFirstChild("Isi")
            local button = isi and isi:FindFirstChild("AccBtn")
            if button and button:IsA("GuiButton")
            and button.Visible and button.Active then
                local p, size = button.AbsolutePosition, button.AbsoluteSize
                table.insert(found, {
                    card = card,
                    button = button,
                    x = p.X + size.X / 2,
                    y = p.Y + size.Y / 2
                })
            end
        end
    end

    table.sort(found, function(a, b) return a.y < b.y end)
    return found
end

local function autoAccClick(item)
    local button, x, y = item.button, item.x, item.y
    local pos = Vector2.new(x, y)

    pcall(function()
        autoAccVIM:SendTouchEvent(0, Enum.UserInputState.Begin, pos)
        task.wait(0.10)
        autoAccVIM:SendTouchEvent(0, Enum.UserInputState.End, pos)
    end)

    task.wait(0.45)
    if button.Parent and button.Visible then
        local mx, my = x + 44, y + 58
        pcall(function()
            autoAccVIM:SendMouseMoveEvent(mx, my, game)
            task.wait(0.05)
            autoAccVIM:SendMouseButtonEvent(mx, my, 0, true, game, 1)
            task.wait(0.08)
            autoAccVIM:SendMouseButtonEvent(mx, my, 0, false, game, 1)
        end)
        task.wait(0.65)
    end

    return not (button.Parent and button.Visible)
end

task.spawn(function()
    while alive() and gui.Parent do
        if autoAccEnabled and not autoAccBusy then
            local cards = getAutoAccCards()
            if #cards > 0 then
                local item = cards[1]
                local now = os.clock()
                local last = autoAccLast[item.card] or 0

                if now - last > 2.5 then
                    autoAccBusy = true
                    autoAccLast[item.card] = now
                    setStatus("AUTO ACC: " .. item.card.Name
                        .. " | " .. #cards .. " popup")

                    local gone = autoAccClick(item)
                    setStatus(gone and "AUTO ACC: popup diproses; scan ulang"
                        or "AUTO ACC: popup belum hilang; coba ulang")
                    autoAccBusy = false
                end
            else
                setStatus("AUTO ACC: menunggu permintaan")
            end
        end
        task.wait(0.15)
    end
end)

]==]

-- ==========================================
-- FITUR DIHAPUS: AUTO FEED DAN AUTO FARM
-- ==========================================
-- Jangan hapus helper Feed atau loop Farm asli di tahap ini.
-- Controller Sesi 71 membutuhkan feedOne() dan akan mengganti loop Farm di bawah.

-- ==========================================
-- HOMEWORK + CLEANER HOTFIX
-- ==========================================

-- Cleaner toggle hanya mengubah preferensi pengguna.
replaceOnce(
    [=[if not alive() or homeworkEnabled or homeworkBusy then return end
    enabled = not enabled
    updateButtons()]=],
    [=[if not alive() then return end
    enabled = not enabled
    updateButtons()]=],
    "CLEANER TOGGLE INDEPENDENT"
)

-- Pause Homework work loops without changing its visible toggle.
source = source:gsub(
    "while alive%(%) and homeworkEnabled do",
    "while alive() and homeworkEnabled and not farmPauseHomework do"
)
source = source:gsub(
    "if not alive%(%) or not homeworkEnabled then break end",
    "if not alive() or not homeworkEnabled or farmPauseHomework then break end"
)
source = source:gsub(
    "if not alive%(%) or not homeworkEnabled then return false end",
    "if not alive() or not homeworkEnabled or farmPauseHomework then return false end"
)
source = source:gsub(
    "return alive%(%) and homeworkEnabled",
    "return alive() and homeworkEnabled and not farmPauseHomework"
)

-- ==========================================
-- COMPILE DAN JALANKAN
-- ==========================================


-- ==========================================
-- SESSION 71: INTEGRATED AUTO FARM
-- COPY OF MAIN.LUA - MAIN.LUA IS NOT MODIFIED
-- ==========================================

local integratedCode = [==[
local farmPhase = "FEED"
local cooldownEnd = 0
local convertBusy = false
local CONVERT_LIMIT = 2000

local function manureTool()
    for _, container in ipairs({backpack, player.Character}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower():find("kotoran", 1, true) then
                    return item
                end
            end
        end
    end
end

local function manureCount()
    local tool = manureTool()
    if not tool then return 0 end
    for _, key in ipairs({"Amount","Jumlah","Count","Stack","Quantity","JumlahKotoran"}) do
        local n = tool:GetAttribute(key)
        if typeof(n) == "number" then return n end
    end
    for _, v in ipairs(tool:GetDescendants()) do
        if (v:IsA("IntValue") or v:IsA("NumberValue"))
        and (v.Name:lower():find("jumlah") or v.Name:lower():find("count")
        or v.Name:lower():find("amount") or v.Name:lower():find("stack")) then
            return v.Value
        end
    end
    return 0
end

local function clickConvert(btn)
    if not btn or not btn.Parent then return false end
    if typeof(firesignal) ~= "function" then return false end
    local ok = pcall(function() firesignal(btn.MouseButton1Click) end)
    task.wait(0.15)
    pcall(function() firesignal(btn.Activated) end)
    return ok
end

local function convertAt2000()
    if convertBusy then return false end
    convertBusy = true
    local function finish(msg)
        convertBusy = false
        setStatus(msg)
    end

    setStatus("KOTORAN 2000 - MENUJU KONVERSI")
    local machine = W:FindFirstChild("MsinConvert")
    local prompt
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local best = math.huge
    if machine and root then
        for _, obj in ipairs(machine:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Name == "ConvertPrompt" and obj.Enabled then
                local pos = getPosition(obj)
                if pos then
                    local d = (root.Position - pos).Magnitude
                    if d < best then prompt, best = obj, d end
                end
            end
        end
    end
    if not prompt then finish("MESIN CONVERT TIDAK DITEMUKAN"); return false end
    local pos = getPosition(prompt)
    if not pos or not teleportNear(pos, 2) or not activatePrompt(prompt) then
        finish("GAGAL MEMBUKA MESIN CONVERT"); return false
    end

    local ui, content
    local started = os.clock()
    repeat
        task.wait(0.25)
        ui = playerGui:FindFirstChild("ConvertUI")
        local panel = ui and ui:FindFirstChild("PanelConvert")
        content = panel and panel:FindFirstChild("Content")
    until not alive() or (content and content:FindFirstChild("MasukBtn")
        and content:FindFirstChild("KlaimBtn")) or os.clock() - started > 12

    if not alive() or not content then
        finish("UI CONVERT TIDAK TERDETEKSI"); return false
    end

    local masuk = content:FindFirstChild("MasukBtn")
    local klaim = content:FindFirstChild("KlaimBtn")
    local gold = content:FindFirstChild("Proses")
        and content.Proses:FindFirstChild("SlotGold")
        and content.Proses.SlotGold:FindFirstChild("Jumlah")
    local statusLbl = content:FindFirstChild("StatusLbl")
    if not masuk or not klaim then
        finish("TOMBOL CONVERT TIDAK LENGKAP"); return false
    end

    -- Tidak ada pemeriksaan kurs. Langsung masukkan saat UI siap.
    local beforeGold = gold and tonumber((gold.Text or ""):gsub(",", ".")) or 0
    setStatus("MEMASUKKAN KOTORAN - KURS DIABAIKAN")
    if not clickConvert(masuk) then
        finish("TOMBOL MASUK GAGAL"); return false
    end

    started = os.clock()
    local completed = false
    while alive() and os.clock() - started < 75 do
        task.wait(0.4)
        ui = playerGui:FindFirstChild("ConvertUI")
        local p = ui and ui:FindFirstChild("PanelConvert")
        content = p and p:FindFirstChild("Content")
        if content then
            gold = content:FindFirstChild("Proses")
                and content.Proses:FindFirstChild("SlotGold")
                and content.Proses.SlotGold:FindFirstChild("Jumlah")
            statusLbl = content:FindFirstChild("StatusLbl")
            local nowGold = gold and tonumber((gold.Text or ""):gsub(",", ".")) or 0
            local st = statusLbl and (statusLbl.Text or ""):lower() or ""
            if nowGold > beforeGold or st:find("selesai",1,true)
            or st:find("berhasil",1,true) or st:find("klaim",1,true) then
                completed = true
                break
            end
        end
    end
    if not completed then finish("PROSES CONVERT BELUM TERKONFIRMASI"); return false end

    content = playerGui:FindFirstChild("ConvertUI")
        and playerGui.ConvertUI:FindFirstChild("PanelConvert")
        and playerGui.ConvertUI.PanelConvert:FindFirstChild("Content")
    klaim = content and content:FindFirstChild("KlaimBtn")
    setStatus("MENGKLAIM HASIL CONVERT")
    if not clickConvert(klaim) then finish("KLAIM GAGAL"); return false end

    started = os.clock()
    while alive() and os.clock() - started < 15 do
        task.wait(0.4)
        if manureCount() < CONVERT_LIMIT then
            local panel = playerGui:FindFirstChild("ConvertUI")
                and playerGui.ConvertUI:FindFirstChild("PanelConvert")
            if panel then
                for _, b in ipairs(panel:GetDescendants()) do
                    if b:IsA("GuiButton") then
                        local n = b.Name:lower()
                        if n == "x" or n:find("close") or n:find("tutup") then
                            clickConvert(b)
                            break
                        end
                    end
                end
            end
            finish("CONVERT BERHASIL - MELANJUTKAN TAHAP")
            return true
        end
    end
    finish("KLAIM BELUM TERVERIFIKASI")
    return false
end

local function homeworkSet(on)
    if on then
        homeworkEnabled = true
        updateButtons()
        if not homeworkBusy then
            task.spawn(function()
                local ok, err = xpcall(homeworkRun, function(e)
                    return tostring(e)
                end)
                if not ok then
                    homeworkEnabled = false
                    homeworkBusy = false
                    pcall(updateButtons)
                    pcall(setStatus, "HOMEWORK ERROR: " .. tostring(err):sub(1,80))
                end
            end)
        end
    else
        homeworkEnabled = false
        updateButtons()
    end
end

local function allFeedersReady()
    local feeders = getFeeders()
    if #feeders < 2 then return false end
    for _, entry in ipairs(feeders) do
        local stock = getStock(entry.object)
        if stock == nil or stock <= 0 then return false end
    end
    return true
end

local function stopHomeworkAndWait()
    farmPauseHomework = true
    local t = os.clock()
    while alive() and homeworkBusy and os.clock() - t < 8 do task.wait(0.1) end
end

-- Satu pengendali mengatur Feed -> cooldown/Homework -> pickup.
task.spawn(function()
    local emptyScans = 0
    while alive() and gui.Parent do
        task.wait(0.35)
        if not autoFarm then
            farmPauseHomework = false
            emptyScans = 0
            continue
        end
        if manureCount() >= CONVERT_LIMIT then
            local wasHomework = farmPhase == "COOLDOWN"
            if wasHomework then stopHomeworkAndWait() end
            convertAt2000()
            -- farmPhase dan cooldownEnd sengaja tidak di-reset.
            if wasHomework and farmPhase == "COOLDOWN" and os.clock() < cooldownEnd then
                homeworkSet(true)
            end
            continue
        end

        if farmPhase == "FEED" then
            farmPauseHomework = true
            if not getCurrentKandang() then
                setStatus("MEMBACA DATA KANDANG")
                continue
            end
            if allFeedersReady() then
                cooldownEnd = os.clock() + 300
                farmPhase = "COOLDOWN"
                homeworkSet(true)
                setStatus("PAKAN PENUH - COOLDOWN 5 MENIT")
            else
                setStatus("MENGISI DUA PALUNG 0/100")
                feedOne()
            end

        elseif farmPhase == "COOLDOWN" then
            farmPauseHomework = false
            if os.clock() >= cooldownEnd then
                stopHomeworkAndWait()
                farmPhase = "PICKUP"
                emptyScans = 0
                setStatus("COOLDOWN SELESAI - MENUJU KANDANG")
            else
                homeworkSet(true)
                local remain = math.max(0, math.ceil(cooldownEnd - os.clock()))
                setStatus("HOMEWORK - SISA COOLDOWN " .. remain .. " DETIK")
            end

        elseif farmPhase == "PICKUP" then
            farmPauseHomework = true
            if hwCarrying() then
                setStatus("MENUNGGU MUATAN HOMEWORK DIBUANG")
                continue
            end
            local folder = getDroppingFolder()
            local p, dropPos, ready, has, waiting = findNextDropping()
            if not ready then
                setStatus("MEMINDAI KOTORAN KANDANG")
                continue
            end
            if has then
                emptyScans = 0
                if waiting then
                    setStatus("MENUNGGU KOTORAN SIAP DIAMBIL")
                    task.wait(0.7)
                elseif p and dropPos then
                    setStatus("MEMUNGUT KOTORAN")
                    if teleportNear(dropPos, 1.5) and alive() and autoFarm then
                        local ok = activatePrompt(p)
                        if ok then
                            local t = os.clock()
                            repeat
                                task.wait(0.15)
                            until not alive() or not p.Parent
                                or not p:IsDescendantOf(folder) or not p.Enabled
                                or os.clock() - t > 4
                            if p.Parent and p.Enabled then
                                collectCooldown[p] = os.clock()
                            else
                                collectCooldown[p] = nil
                            end
                        else
                            collectCooldown[p] = os.clock()
                        end
                    end
                end
            else
                emptyScans += 1
                if emptyScans >= 4 then
                    farmPhase = "FEED"
                    emptyScans = 0
                    setStatus("KOTORAN HABIS - SIKLUS BARU")
                else
                    setStatus("MEMASTIKAN KOTORAN HABIS")
                end
            end
        end
    end
    farmPauseHomework = false
end)
]==]

-- Sisipkan konverter dan pengendali baru, lalu nonaktifkan loop farm lama.
local insertMarker = "-- ==========================================\n-- AUTO CLEANER LOOP"
local a = source:find(insertMarker, 1, true)
if not a then error("SESSION 71: AUTO CLEANER MARKER NOT FOUND") end
source = source:sub(1, a - 1) .. integratedCode .. "\n\n" .. source:sub(a)

local oldFarmAt = source:find("-- AUTO FARM LOOP", 1, true)
if oldFarmAt then
    local oldFarmEnd = source:find("-- TP LOCATION", oldFarmAt, true)
    if oldFarmEnd then
        source = source:sub(1, oldFarmAt - 1)
            .. "-- AUTO FARM LOOP V18.2 DISABLED: REPLACED BY SESSION 71 CONTROLLER\\n\\n"
            .. source:sub(oldFarmEnd)
    end
end

-- Pause Cleaner during farm-controlled movement without changing its toggle.
local cleanerGuard = "if not enabled or busy\n        or homeworkEnabled or homeworkBusy"
local cg = source:find(cleanerGuard, 1, true)
if cg then
    source = source:sub(1, cg - 1)
        .. "if farmPauseHomework or not enabled or busy\n        or homeworkEnabled or homeworkBusy"
        .. source:sub(cg + #cleanerGuard)
end


local compiled, compileError = loadstring(source)

if not compiled then
    error(reportLoaderError("COMPILE ERROR: " .. tostring(compileError)))
end

local runOK, runError = pcall(compiled)
if not runOK then
    error(reportLoaderError("RUNTIME ERROR: " .. tostring(runError)))
end
