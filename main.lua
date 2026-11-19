-- ==========================================
-- RAEL'S TRICKS V1
-- BASE V1 + AUTO CONVERT + AUTO CLAIM
-- AUTO CLOSE CONVERT MACHINE
-- AUTO GACHA + AUTO CLAIM
-- ==========================================

local source = "-- ==========================================\n-- RAEL'S TRICKS V18.2 + HOMEWORK\n-- AUTO CLEANER + AUTO FARM + HOMEWORK\n-- HOMEWORK TERPISAH DARI AUTO CLEAN\n-- HOMEWORK PRIORITY OVER AUTO FARM\n-- ==========================================\n\nlocal Players = game:GetService(\"Players\")\nlocal UIS = game:GetService(\"UserInputService\")\nlocal VirtualUser = game:GetService(\"VirtualUser\")\n\nlocal player = Players.LocalPlayer\nlocal playerGui = player:WaitForChild(\"PlayerGui\")\nlocal backpack = player:WaitForChild(\"Backpack\")\nlocal env = getgenv()\nlocal W = workspace\n\n-- CLEAN PREVIOUS VERSION\nif env.RaelV18Connections then\n    for _, c in ipairs(env.RaelV18Connections) do\n        pcall(function() c:Disconnect() end)\n    end\nend\nif env.RaelV18Objects then\n    for _, obj in ipairs(env.RaelV18Objects) do\n        pcall(function() obj:Destroy() end)\n    end\nend\n\nenv.RaelV18Running = false\ntask.wait(0.15)\nenv.RaelV18Running = true\n\nlocal SESSION = tick()\nenv.RaelV18Session = SESSION\nenv.RaelV18Connections = {}\nenv.RaelV18Objects = {}\n\nlocal function alive()\n    return env.RaelV18Running and env.RaelV18Session == SESSION\nend\n\nlocal function connect(signal, callback)\n    local c = signal:Connect(callback)\n    table.insert(env.RaelV18Connections, c)\n    return c\nend\n\nlocal function track(object)\n    table.insert(env.RaelV18Objects, object)\n    return object\nend\n\n-- SETTINGS\nlocal RANGE_CLEAN = 100\nlocal RANGE_TRASH = 30\nlocal SCAN_DELAY = 0.2\nlocal RETRY_DELAY = 1\nlocal DROPPING_RETRY = 2\nlocal FEED_RETRY = 8\n\nlocal enabled = false\nlocal autoFarm = false\nlocal homeworkEnabled = false\nlocal homeworkBusy = false\nlocal busy = false\n\nlocal prompts = setmetatable({}, {__mode = \"k\"})\nlocal lastAttempt = setmetatable({}, {__mode = \"k\"})\nlocal collectCooldown = {}\nlocal feedCooldown = {}\n\n-- ==========================================\n-- DYNAMIC KANDANG\n-- ==========================================\n\nlocal function getCurrentKandang()\n    local name = player:GetAttribute(\"Ternak_Kandang\")\n    if typeof(name) ~= \"string\" then return nil end\n    if not name:match(\"^Kandang_%d+$\") then return nil end\n    return name\nend\n\nlocal function getKandangNumber()\n    local name = getCurrentKandang()\n    return name and name:match(\"Kandang_(%d+)\")\nend\n\nlocal function getCurrentPen()\n    local kandang = getCurrentKandang()\n    if not kandang then return nil end\n\n    local kawasan = W:FindFirstChild(\"Kawasan_Kos\")\n    local ternak = kawasan and kawasan:FindFirstChild(\"Lahan_Ternak\")\n    return ternak and ternak:FindFirstChild(kandang)\nend\n\nlocal function getDroppingFolder()\n    local kandang = getCurrentKandang()\n    if not kandang then return nil end\n\n    local farm = W:FindFirstChild(\"TernakLokal\")\n    local owner = farm and farm:FindFirstChild(\"KotoranSaya_\" .. kandang)\n    return owner and owner:FindFirstChild(\"Kotoran\")\nend\n\n-- ==========================================\n-- PROMPT FILTER\n-- ==========================================\n\nlocal function isDroppingPrompt(prompt)\n    if not prompt or not prompt:IsA(\"ProximityPrompt\") then\n        return false\n    end\n\n    local action = (prompt.ActionText or \"\"):lower()\n    local object = (prompt.ObjectText or \"\"):lower()\n    local name = (prompt.Name or \"\"):lower()\n\n    return action:find(\"ambil\", 1, true) ~= nil\n        and (\n            object:find(\"kotoran\", 1, true) ~= nil\n            or name:find(\"ambilkotoran\", 1, true) ~= nil\n        )\nend\n\nlocal function isAllowed(prompt)\n    if not prompt or not prompt:IsA(\"ProximityPrompt\") then\n        return false\n    end\n\n    local action = (prompt.ActionText or \"\"):lower()\n    local object = (prompt.ObjectText or \"\"):lower()\n    local name = (prompt.Name or \"\"):lower()\n    local path = prompt:GetFullName():lower()\n\n    if action:find(\"keranjang\", 1, true)\n    or object:find(\"keranjang\", 1, true)\n    or name:find(\"keranjang\", 1, true)\n    or path:find(\"keranjang\", 1, true) then\n        return false\n    end\n\n    return action:find(\"bersihkan\", 1, true)\n        or action:find(\"ambil\", 1, true)\n        or action:find(\"buang\", 1, true)\nend\n\nlocal function addPrompt(obj)\n    if obj:IsA(\"ProximityPrompt\") and isAllowed(obj) then\n        prompts[obj] = true\n    end\nend\n\n-- ==========================================\n-- POSITION\n-- ==========================================\n\nlocal function getPosition(prompt)\n    if not prompt or not prompt.Parent then return nil end\n\n    local parent = prompt.Parent\n\n    if parent:IsA(\"Attachment\") then\n        return parent.WorldPosition\n    end\n\n    if parent:IsA(\"BasePart\") then\n        return parent.Position\n    end\n\n    local model = parent:IsA(\"Model\")\n        and parent\n        or parent:FindFirstAncestorWhichIsA(\"Model\")\n\n    if model then\n        local part = model.PrimaryPart\n            or model:FindFirstChildWhichIsA(\"BasePart\", true)\n        if part then return part.Position end\n    end\n\n    local part = parent:FindFirstChildWhichIsA(\"BasePart\", true)\n    return part and part.Position\nend\n\nlocal function getObjectPosition(obj)\n    if not obj then return nil end\n    if obj:IsA(\"BasePart\") then return obj.Position end\n\n    if obj:IsA(\"Model\") then\n        local ok, pivot = pcall(function()\n            return obj:GetPivot()\n        end)\n        if ok then return pivot.Position end\n    end\n\n    local part = obj:FindFirstChildWhichIsA(\"BasePart\", true)\n    return part and part.Position\nend\n\n-- ==========================================\n-- TRASHBAG - AUTO CLEAN/FARM LAMA\n-- ==========================================\n\nlocal function isCarryingTrash()\n    local character = player.Character\n    local trash = character and character:FindFirstChild(\"TrashBag\", true)\n    return trash ~= nil and trash:IsA(\"BasePart\")\nend\n\n-- ==========================================\n-- TELEPORT + PROMPT LAMA\n-- ==========================================\n\nlocal function teleportNear(position, distance)\n    if not alive() then return false end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    if not root or not position then return false end\n\n    local target = position + Vector3.new(0, 1.5, distance or 2)\n    root.CFrame = CFrame.lookAt(target, position)\n    task.wait(0.4)\n\n    return alive()\nend\n\nlocal function activatePrompt(prompt)\n    if not alive() or not prompt\n    or not prompt.Parent or not prompt.Enabled then\n        return false, \"PROMPT TIDAK AKTIF\"\n    end\n\n    if typeof(fireproximityprompt) == \"function\" then\n        local ok = pcall(function()\n            fireproximityprompt(prompt)\n        end)\n\n        if ok then\n            return true, \"FIREPROXIMITYPROMPT\"\n        end\n    end\n\n    local ok = pcall(function()\n        prompt:InputHoldBegin()\n        task.wait(math.max(prompt.HoldDuration, 0.2) + 0.15)\n        prompt:InputHoldEnd()\n    end)\n\n    if ok then\n        return true, \"INPUT HOLD\"\n    end\n\n    return false, \"INTERAKSI GAGAL\"\nend\n\n-- ==========================================\n-- GUI\n-- ==========================================\n\nlocal oldGui = playerGui:FindFirstChild(\"RaelsTricksV18\")\nif oldGui then oldGui:Destroy() end\n\nlocal gui = track(Instance.new(\"ScreenGui\"))\ngui.Name = \"RaelsTricksV18\"\ngui.ResetOnSpawn = false\ngui.DisplayOrder = 999\ngui.Parent = playerGui\n\nlocal frame = Instance.new(\"Frame\")\nframe.Size = UDim2.fromOffset(205, 115)\nframe.Position = UDim2.new(1, -220, 0, 100)\nframe.BackgroundColor3 = Color3.fromRGB(25, 25, 30)\nframe.BorderSizePixel = 0\nframe.Active = true\nframe.Parent = gui\nInstance.new(\"UICorner\", frame).CornerRadius = UDim.new(0, 8)\n\nlocal title = Instance.new(\"TextLabel\")\ntitle.Size = UDim2.new(1, -38, 0, 20)\ntitle.Position = UDim2.fromOffset(5, 0)\ntitle.BackgroundTransparency = 1\ntitle.Text = \"RAEL'S TRICKS V18.2\"\ntitle.TextColor3 = Color3.new(1, 1, 1)\ntitle.TextSize = 11\ntitle.Font = Enum.Font.GothamBold\ntitle.TextXAlignment = Enum.TextXAlignment.Left\ntitle.Parent = frame\n\nlocal minimizeButton = Instance.new(\"TextButton\")\nminimizeButton.Name = \"MinimizeButton\"\nminimizeButton.Size = UDim2.fromOffset(25, 19)\nminimizeButton.Position = UDim2.new(1, -29, 0, 1)\nminimizeButton.BackgroundColor3 = Color3.fromRGB(65, 65, 75)\nminimizeButton.Text = \"-\"\nminimizeButton.TextColor3 = Color3.new(1, 1, 1)\nminimizeButton.TextSize = 16\nminimizeButton.Font = Enum.Font.GothamBold\nminimizeButton.Parent = frame\nInstance.new(\"UICorner\", minimizeButton).CornerRadius = UDim.new(0, 5)\n\nlocal miniButton = Instance.new(\"TextButton\")\nminiButton.Name = \"RaelMiniButton\"\nminiButton.Size = UDim2.fromOffset(42, 42)\nminiButton.Position = UDim2.new(1, -55, 0, 100)\nminiButton.BackgroundColor3 = Color3.fromRGB(35, 100, 65)\nminiButton.Text = \"RT\"\nminiButton.TextColor3 = Color3.new(1, 1, 1)\nminiButton.TextSize = 15\nminiButton.Font = Enum.Font.GothamBold\nminiButton.Visible = false\nminiButton.Active = true\nminiButton.Parent = gui\nInstance.new(\"UICorner\", miniButton).CornerRadius = UDim.new(1, 0)\n\nlocal function makeButton(name, text, x, y, w, color, h)\n    local b = Instance.new(\"TextButton\")\n    b.Name = name\n    b.Size = UDim2.fromOffset(w, h or 29)\n    b.Position = UDim2.fromOffset(x, y)\n    b.BackgroundColor3 = color\n    b.TextColor3 = Color3.new(1, 1, 1)\n    b.TextSize = 10\n    b.Font = Enum.Font.GothamBold\n    b.Text = text\n    b.Parent = frame\n    Instance.new(\"UICorner\", b).CornerRadius = UDim.new(0, 6)\n    return b\nend\n\nlocal cleanButton = makeButton(\n    \"CleanButton\", \"CLEAN: OFF\", 5, 22, 95,\n    Color3.fromRGB(160, 45, 45)\n)\n\nlocal farmButton = makeButton(\n    \"FarmButton\", \"FARM: OFF\", 105, 22, 95,\n    Color3.fromRGB(35, 100, 65)\n)\n\nlocal homeworkButton = makeButton(\n    \"HomeworkButton\", \"HOMEWORK: OFF\", 5, 55, 195,\n    Color3.fromRGB(35, 75, 145), 27\n)\n\nlocal status = Instance.new(\"TextLabel\")\nstatus.Size = UDim2.new(1, -10, 0, 20)\nstatus.Position = UDim2.fromOffset(5, 88)\nstatus.BackgroundTransparency = 1\nstatus.Text = \"Status: READY\"\nstatus.TextColor3 = Color3.fromRGB(255, 220, 120)\nstatus.TextSize = 10\nstatus.Font = Enum.Font.Gotham\nstatus.TextXAlignment = Enum.TextXAlignment.Left\nstatus.Parent = frame\n\nlocal function setStatus(msg)\n    if status and status.Parent then\n        status.Text = \"Status: \" .. msg\n    end\nend\n\nlocal function updateButtons()\n    cleanButton.Text = enabled and \"CLEAN: ON\" or \"CLEAN: OFF\"\n    cleanButton.BackgroundColor3 = enabled\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(160, 45, 45)\n\n    farmButton.Text = autoFarm and \"FARM: ON\" or \"FARM: OFF\"\n    farmButton.BackgroundColor3 = autoFarm\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(35, 100, 65)\n\n    homeworkButton.Text = homeworkEnabled\n        and \"HOMEWORK: ON\" or \"HOMEWORK: OFF\"\n    homeworkButton.BackgroundColor3 = homeworkEnabled\n        and Color3.fromRGB(35, 145, 70)\n        or Color3.fromRGB(35, 75, 145)\nend\n\n-- ==========================================\n-- DRAG\n-- ==========================================\n\nlocal function makeDraggable(object)\n    local dragging = false\n    local dragStart\n    local startPosition\n\n    connect(object.InputBegan, function(input)\n        if input.UserInputType == Enum.UserInputType.Touch\n        or input.UserInputType == Enum.UserInputType.MouseButton1 then\n            dragging = true\n            dragStart = input.Position\n            startPosition = object.Position\n\n            connect(input.Changed, function()\n                if input.UserInputState == Enum.UserInputState.End then\n                    dragging = false\n                end\n            end)\n        end\n    end)\n\n    connect(UIS.InputChanged, function(input)\n        if dragging and (\n            input.UserInputType == Enum.UserInputType.Touch\n            or input.UserInputType == Enum.UserInputType.MouseMovement\n        ) then\n            local delta = input.Position - dragStart\n            object.Position = UDim2.new(\n                startPosition.X.Scale,\n                startPosition.X.Offset + delta.X,\n                startPosition.Y.Scale,\n                startPosition.Y.Offset + delta.Y\n            )\n        end\n    end)\nend\n\nmakeDraggable(frame)\nmakeDraggable(miniButton)\n\nconnect(minimizeButton.Activated, function()\n    frame.Visible = false\n    miniButton.Visible = true\nend)\n\nconnect(miniButton.Activated, function()\n    miniButton.Visible = false\n    frame.Visible = true\nend)\n\n-- ==========================================\n-- HOMEWORK SYSTEM\n-- ==========================================\n\nlocal function hwRoot()\n    local c = player.Character\n    return c and c:FindFirstChild(\"HumanoidRootPart\")\nend\n\nlocal function hwProgress()\n    local pg = player:FindFirstChild(\"PlayerGui\")\n    local ui = pg and pg:FindFirstChild(\"UiGame\")\n    local cleaning = ui and ui:FindFirstChild(\"Cleaning\")\n    if not cleaning then return nil end\n\n    local label = cleaning:FindFirstChild(\"StatusPersen\")\n    local n = label and tonumber((label.Text or \"\"):match(\"(%d+)%s*%%\"))\n    if n then return n end\n\n    local bar = cleaning:FindFirstChild(\"CleaningProgres\")\n    local fill = bar and bar:FindFirstChild(\"Fill\")\n    if fill and fill:IsA(\"Frame\") then\n        return math.floor(fill.Size.X.Scale * 100 + 0.5)\n    end\n    return nil\nend\n\n-- HOMEWORK memakai deteksi recursive sendiri.\n-- Deteksi TrashBag AUTO CLEAN lama tidak diubah.\nlocal function hwCarrying()\n    local c = player.Character\n    return c and c:FindFirstChild(\"TrashBag\", true)\nend\n\nlocal function hwPart(prompt)\n    local x = prompt and prompt.Parent\n    if not x then return nil end\n\n    if x:IsA(\"BasePart\") then\n        return x\n    end\n\n    return x:FindFirstChildWhichIsA(\"BasePart\", true)\nend\n\nlocal function hwForceStand()\n    local character = player.Character\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    if not humanoid then return end\n\n    if humanoid.Sit or humanoid:GetState() == Enum.HumanoidStateType.Seated then\n        humanoid.Sit = false\n        humanoid.Jump = true\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)\n        task.wait(0.08)\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)\n        task.wait(0.08)\n        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)\n    end\n\n    if root then\n        root.AssemblyLinearVelocity = Vector3.zero\n        root.AssemblyAngularVelocity = Vector3.zero\n    end\nend\n\nlocal function hwMove(prompt)\n    if not alive() or not homeworkEnabled then return false end\n\n    local r = hwRoot()\n    local q = hwPart(prompt)\n    if not r or not q then return false end\n\n    -- Lepaskan kursi sebelum teleport dan mendarat lebih tinggi\n    -- agar tidak langsung menempel ke Seat/VehicleSeat di dekat target.\n    hwForceStand()\n    r = hwRoot()\n    if not r then return false end\n\n    r.CFrame = CFrame.new(q.Position + Vector3.new(0, 3.5, 0))\n    r.AssemblyLinearVelocity = Vector3.zero\n    r.AssemblyAngularVelocity = Vector3.zero\n\n    task.wait(0.15)\n    hwForceStand()\n    task.wait(0.15)\n    hwForceStand()\n\n    return alive() and homeworkEnabled\nend\n\nlocal function hwUse(prompt)\n    if not prompt or not prompt.Parent or not prompt.Enabled then\n        return false\n    end\n\n    if not hwMove(prompt) then return false end\n\n    -- Gunakan interaksi prompt yang sama dengan Auto Clean,\n    -- termasuk fallback InputHoldBegin/End.\n    local ok = activatePrompt(prompt)\n    if not ok then return false end\n\n    task.wait(0.4)\n    return alive() and homeworkEnabled\nend\n\nlocal function hwWaitCarry(value)\n    for i = 1, 40 do\n        if not alive() or not homeworkEnabled then return false end\n\n        if (hwCarrying() ~= nil) == value then\n            return true\n        end\n\n        task.wait(0.25)\n    end\n\n    return false\nend\n\nlocal function hwOwnsHouse(house)\n    if not house then return false end\n    return tonumber(house:GetAttribute(\"OwnerUserId\")) == player.UserId\nend\n\nlocal function hwDispose(house)\n    if not hwCarrying() then return true end\n\n    local r = hwRoot()\n    if not r or not house or not hwOwnsHouse(house) then return false end\n\n    -- Cari zona gedung yang paling dekat dengan rumah milik player.\n    local housePos = house:GetPivot().Position\n    local ownZone, zoneDistance\n\n    for _, zone in ipairs(W:GetChildren()) do\n        if zone.Name:match(\"^ZonaSpawanGedung\") then\n            local nearest\n            for _, part in ipairs(zone:GetDescendants()) do\n                if part:IsA(\"BasePart\") then\n                    local d = (housePos - part.Position).Magnitude\n                    if not nearest or d < nearest then nearest = d end\n                end\n            end\n            if nearest and (not zoneDistance or nearest < zoneDistance) then\n                ownZone, zoneDistance = zone, nearest\n            end\n        end\n    end\n\n    if not ownZone then\n        setStatus(\"ZONA PEMBUANGAN TIDAK DITEMUKAN\")\n        task.wait(1)\n        return false\n    end\n\n    local best, bd\n\n    -- Hanya cari tempat sampah di zona gedung rumah sendiri.\n    for _, v in ipairs(ownZone:GetDescendants()) do\n        if not alive() or not homeworkEnabled then return false end\n\n        if v:IsA(\"ProximityPrompt\")\n        and v.Name == \"BuangPrompt\"\n        and v.ActionText == \"Buang\"\n        and v.Enabled then\n            local q = hwPart(v)\n            if q then\n                local d = (r.Position - q.Position).Magnitude\n                if not bd or d < bd then\n                    best, bd = v, d\n                end\n            end\n        end\n    end\n\n    if not best then\n        setStatus(\"TEMPAT SAMPAH ZONA SENDIRI TIDAK DITEMUKAN\")\n        task.wait(1)\n        return false\n    end\n\n    if not hwUse(best) then return false end\n    return hwWaitCarry(false)\nend\n\nlocal function hwGet(house, mode)\n    local result = {}\n\n    if not house then return result end\n\n    for _, v in ipairs(house:GetDescendants()) do\n        if mode == 1\n        and v:IsA(\"ProximityPrompt\")\n        and v.ActionText == \"Bersihkan\"\n        and v.Enabled then\n            table.insert(result, v)\n\n        elseif mode == 3\n        and v:IsA(\"ProximityPrompt\")\n        and v.ActionText == \"Bersihkan\" then\n            table.insert(result, v)\n\n        elseif mode == 2\n        and v:IsA(\"BasePart\")\n        and v.Name == \"TrashBag\" then\n            local p = v:FindFirstChild(\"AmbilPrompt\")\n\n            if p and p:IsA(\"ProximityPrompt\") and p.Enabled then\n                table.insert(result, p)\n            end\n        end\n    end\n\n    return result\nend\n\nlocal function hwFindHouse()\n    local folder = W:FindFirstChild(\"KosanSpawned\")\n    local r = hwRoot()\n\n    if not folder or not r then return nil end\n\n    local best, bd\n\n    for _, house in ipairs(folder:GetChildren()) do\n        -- HOMEWORK hanya boleh memilih rumah milik player sendiri.\n        if hwOwnsHouse(house) then\n            for _, p in ipairs(hwGet(house, 1)) do\n                local q = hwPart(p)\n\n                if q then\n                    local d = (r.Position - q.Position).Magnitude\n\n                    if not bd or d < bd then\n                        best, bd = house, d\n                    end\n                end\n            end\n        end\n    end\n\n    return best\nend\n\nlocal function hwNearestOwnedHouse()\n    local folder = W:FindFirstChild(\"KosanSpawned\")\n    local r = hwRoot()\n    if not folder or not r then return nil end\n\n    local best, bd\n    for _, house in ipairs(folder:GetChildren()) do\n        if hwOwnsHouse(house) then\n            local ok, pos = pcall(function()\n                return house:GetPivot().Position\n            end)\n            if ok and pos then\n                local d = (r.Position - pos).Magnitude\n                if not bd or d < bd then\n                    best, bd = house, d\n                end\n            end\n        end\n    end\n    return best\nend\n\nlocal function homeworkRun()\n    if homeworkBusy then return end\n    homeworkBusy = true\n\n    -- Jaga karakter tetap berdiri selama Homework aktif.\n    task.spawn(function()\n        while alive() and homeworkEnabled do\n            pcall(hwForceStand)\n            task.wait(0.25)\n        end\n    end)\n\n    while alive() and homeworkEnabled do\n        local folder = W:FindFirstChild(\"KosanSpawned\")\n\n        if not folder then\n            setStatus(\"KOSANSPAWNED TIDAK DITEMUKAN\")\n            task.wait(2)\n            break\n        end\n\n        -- Muatan VIP bisa tetap menempel meski tidak ada rumah\n        -- yang sedang kotor/cooldown. Buang seluruh keranjang sekali.\n        if hwCarrying() then\n            local disposalHouse = hwNearestOwnedHouse()\n            if disposalHouse then\n                setStatus(\"MUATAN KERANJANG VIP - MEMBUANG\")\n                if not hwDispose(disposalHouse) then\n                    setStatus(\"PEMBUANGAN VIP DIULANGI\")\n                    task.wait(1)\n                end\n            else\n                setStatus(\"MUATAN VIP - RUMAH SENDIRI TIDAK DITEMUKAN\")\n                task.wait(1)\n            end\n            continue\n        end\n\n        local house = hwFindHouse()\n\n        -- Prompt Bersihkan disabled berarti cooldown, bukan selesai.\n        if not house then\n            local cooling = false\n            for _, h in ipairs(folder:GetChildren()) do\n                if hwOwnsHouse(h) and #hwGet(h, 3) > 0 then\n                    cooling = true\n                    break\n                end\n            end\n\n            if cooling then\n                setStatus(\"MENUNGGU COOLDOWN RUMAH\")\n            else\n                setStatus(\"ZONA BERSIH - MEMANTAU RUMAH\")\n            end\n\n            -- Jangan matikan Homework. Tetap ON dan scan ulang,\n            -- karena rumah bisa kotor lagi setelah beberapa saat.\n            task.wait(1)\n        else\n\n        setStatus(\"HOMEWORK: MEMBERSIHKAN RUMAH\")\n\n        -- Bersihkan semua prompt di rumah terpilih.\n        local done = {}\n\n        while alive() and homeworkEnabled do\n            local prompt\n\n            for _, p in ipairs(hwGet(house, 1)) do\n                if not done[p] then\n                    prompt = p\n                    break\n                end\n            end\n\n            if not prompt then break end\n\n            if not hwUse(prompt) then\n                if homeworkEnabled then\n                    setStatus(\"GAGAL MEMBERSIHKAN\")\n                end\n                break\n            end\n\n            done[prompt] = true\n            task.wait(0.2)\n        end\n\n        if not alive() or not homeworkEnabled then break end\n\n        -- Kunci rumah ini sampai sampahnya benar-benar selesai.\n        setStatus(\"HOMEWORK: MENUNGGU SAMPAH\")\n        local hadTrash = false\n        local quiet = 0\n        local batchCount = 0\n        local triedBags = {}\n\n        while alive() and homeworkEnabled do\n            if hwCarrying() then\n                hadTrash = true\n                local bags = hwGet(house, 2)\n                local nextBag\n\n                -- VIP: 5 sampah di keranjang + 1 di tangan.\n                -- Kumpulkan sampai 6 atau sampai tidak ada sampah\n                -- lain yang bisa diambil, baru buang sekali.\n                if batchCount < 6 then\n                    for _, p in ipairs(bags) do\n                        if not triedBags[p] then\n                            nextBag = p\n                            break\n                        end\n                    end\n                end\n\n                if nextBag then\n                    triedBags[nextBag] = true\n                    setStatus(\"HOMEWORK: MUAT KERANJANG \"..batchCount..\"/6\")\n\n                    if hwUse(nextBag) then\n                        -- Tunggu server menghapus/nonaktifkan prompt\n                        -- sebagai konfirmasi sampah berhasil diambil.\n                        local collected = false\n                        for _ = 1, 12 do\n                            if not nextBag.Parent or not nextBag.Enabled then\n                                collected = true\n                                break\n                            end\n                            task.wait(0.2)\n                        end\n                        if collected then\n                            batchCount += 1\n                        end\n                    end\n                    task.wait(0.15)\n                else\n                    setStatus(\"HOMEWORK: MEMBUANG \"..batchCount..\" SAMPAH\")\n                    if not hwDispose(house) then\n                        setStatus(\"ULANGI PEMBUANGAN SAMPAH\")\n                        task.wait(0.5)\n                        continue\n                    end\n                    batchCount = 0\n                    triedBags = {}\n                end\n\n            else\n                local bags = hwGet(house, 2)\n\n                if #bags > 0 then\n                    hadTrash = true\n                    quiet = 0\n                    setStatus(\"HOMEWORK: MENGAMBIL SAMPAH\")\n\n                    if not hwUse(bags[1])\n                    or not hwWaitCarry(true) then\n                        setStatus(\"GAGAL MENGAMBIL SAMPAH\")\n                        break\n                    end\n\n                    batchCount = 1\n                    triedBags = {[bags[1]] = true}\n                    task.wait(0.2)\n\n                elseif #hwGet(house, 1) > 0 then\n                    quiet = 0\n                    local cleanPrompts = hwGet(house, 1)\n                    local pendingClean\n\n                    for _, p in ipairs(cleanPrompts) do\n                        if not done[p] then\n                            pendingClean = p\n                            break\n                        end\n                    end\n\n                    -- Ulangi satu putaran jika semua prompt sudah dicoba,\n                    -- tetapi progres belum 100% dan sampah belum muncul.\n                    if not pendingClean and #cleanPrompts > 0 then\n                        done = {}\n                        pendingClean = cleanPrompts[1]\n                    end\n\n                    if pendingClean then\n                        setStatus(\"HOMEWORK: MELANJUTKAN BERSIHKAN\")\n                        if hwUse(pendingClean) then\n                            done[pendingClean] = true\n                        else\n                            setStatus(\"GAGAL MELANJUTKAN BERSIHKAN\")\n                            break\n                        end\n                        task.wait(0.2)\n                    else\n                        task.wait(0.5)\n                    end\n\n                else\n                    -- Hanya anggap selesai setelah sampah pernah muncul\n                    -- lalu rumah kosong stabil selama 5 detik.\n                    if hadTrash then\n                        local progress = hwProgress()\n                        if progress and progress >= 100 then\n                            quiet += 1\n                            if quiet >= 1 then break end\n                        else\n                            quiet = 0\n                            setStatus(\"HOMEWORK: MENUNGGU 100%\")\n                        end\n                    end\n                    task.wait(1)\n                end\n            end\n        end\n\n        if not alive() or not homeworkEnabled then break end\n\n        -- Rumah selesai, cari rumah kotor berikutnya.\n        if #hwGet(house, 1) > 0\n        or #hwGet(house, 2) > 0\n        or hwCarrying() then\n            setStatus(\"SAMPAH BELUM SELESAI\")\n            break\n        end\n\n        task.wait(0.3)\n        end\n    end\n\n    homeworkBusy = false\n\n    -- Cleanup aman: jangan biarkan error di pemeriksaan status\n    -- mematikan fitur atau memunculkan HOMEWORK ERROR palsu.\n    pcall(updateButtons)\n\n    if env.RaelV18Running and env.RaelV18Session == SESSION then\n        homeworkEnabled = false\n        pcall(updateButtons)\n\n        if autoFarm then\n            pcall(setStatus, \"HOMEWORK SELESAI - FARM LANJUT\")\n        else\n            pcall(setStatus, \"HOMEWORK SELESAI\")\n        end\n    end\nend\n\n-- ==========================================\n-- BUTTON EVENTS\n-- ==========================================\n\nconnect(cleanButton.Activated, function()\n    if not alive() then return end\n    if autoFarm or homeworkEnabled or homeworkBusy then return end\n\n    enabled = not enabled\n    updateButtons()\nend)\n\nconnect(farmButton.Activated, function()\n    if not alive() then return end\n\n    autoFarm = not autoFarm\n\n    if autoFarm then\n        enabled = true\n        setStatus(\"FARM DIMULAI\")\n    else\n        setStatus(\"FARM DIMATIKAN\")\n    end\n\n    updateButtons()\nend)\n\nconnect(homeworkButton.Activated, function()\n    if not alive() then return end\n\n    if homeworkEnabled then\n        homeworkEnabled = false\n        setStatus(\"HOMEWORK DIMATIKAN\")\n        updateButtons()\n        return\n    end\n\n    if homeworkBusy then return end\n\n    homeworkEnabled = true\n    updateButtons()\n    setStatus(\"HOMEWORK DIMULAI\")\n\n    task.spawn(function() local ok,err=xpcall(homeworkRun,function(e) local d=debug; if d and d.traceback then return d.traceback(tostring(e),2) end; return tostring(e) end); if not ok then homeworkEnabled=false; homeworkBusy=false; pcall(updateButtons); pcall(setStatus,\"HOMEWORK ERROR: \"..tostring(err):sub(1,120)); pcall(function() warn(\"RAEL HOMEWORK TRACEBACK:\\n\"..tostring(err)) end); pcall(function() if setclipboard then setclipboard(\"RAEL HOMEWORK TRACEBACK:\\n\"..tostring(err)) end end) end end)\nend)\n\n-- ==========================================\n-- AUTO CLEANER TARGET\n-- ==========================================\n\nlocal function getNearest(root)\n    local now = os.clock()\n    local carryingTrash = isCarryingTrash()\n    local nearest\n    local shortest = math.huge\n\n    for prompt in pairs(prompts) do\n        if prompt.Parent and prompt.Enabled and isAllowed(prompt) then\n            if autoFarm and isDroppingPrompt(prompt) then\n                continue\n            end\n\n            local action = (prompt.ActionText or \"\"):lower()\n            local isClean = action:find(\"bersihkan\", 1, true)\n            local isTake = action:find(\"ambil\", 1, true)\n            local isDrop = action:find(\"buang\", 1, true)\n\n            if isTake and carryingTrash then continue end\n            if isDrop and not carryingTrash then continue end\n\n            local ready = not lastAttempt[prompt]\n                or now - lastAttempt[prompt] >= RETRY_DELAY\n\n            if ready then\n                local pos = getPosition(prompt)\n                local range = isClean and RANGE_CLEAN or RANGE_TRASH\n\n                if pos then\n                    local distance = (root.Position - pos).Magnitude\n\n                    if distance <= range and distance < shortest then\n                        nearest = prompt\n                        shortest = distance\n                    end\n                end\n            end\n        end\n    end\n\n    return nearest\nend\n\n-- ==========================================\n-- DROPPING SCANNER\n-- ==========================================\n\nlocal function findNextDropping()\n    local folder = getDroppingFolder()\n\n    if not folder then\n        return nil, nil, false, false, false\n    end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n\n    if not root then\n        return nil, nil, true, false, false\n    end\n\n    local now = os.clock()\n    local nearestReady, nearestReadyPos\n    local nearestWaiting, nearestWaitingPos\n    local nearestReadyDistance = math.huge\n    local nearestWaitingDistance = math.huge\n    local hasDroppings = false\n\n    for _, obj in ipairs(folder:GetDescendants()) do\n        if obj:IsA(\"ProximityPrompt\")\n        and isDroppingPrompt(obj)\n        and obj.Enabled then\n\n            hasDroppings = true\n\n            local pos = getPosition(obj)\n\n            if pos then\n                local distance = (root.Position - pos).Magnitude\n                local last = collectCooldown[obj]\n                local ready = not last or now - last >= DROPPING_RETRY\n\n                if ready and distance < nearestReadyDistance then\n                    nearestReady = obj\n                    nearestReadyPos = pos\n                    nearestReadyDistance = distance\n                elseif not ready and distance < nearestWaitingDistance then\n                    nearestWaiting = obj\n                    nearestWaitingPos = pos\n                    nearestWaitingDistance = distance\n                end\n            elseif not nearestWaiting then\n                nearestWaiting = obj\n            end\n        end\n    end\n\n    if nearestReady then\n        return nearestReady, nearestReadyPos, true, true, false\n    end\n\n    if hasDroppings then\n        return nearestWaiting, nearestWaitingPos, true, true, true\n    end\n\n    return nil, nil, true, false, false\nend\n\n-- ==========================================\n-- FEED TOOL\n-- ==========================================\n\nlocal function findCabai()\n    local character = player.Character\n\n    local function search(container)\n        if not container then return nil end\n\n        for _, tool in ipairs(container:GetChildren()) do\n            local name = tool.Name:lower()\n\n            if tool:IsA(\"Tool\")\n            and name:find(\"cabai\", 1, true)\n            and not name:find(\"bibit\", 1, true) then\n                return tool\n            end\n        end\n    end\n\n    return search(character) or search(backpack)\nend\n\nlocal function equipCabai()\n    local tool = findCabai()\n    local character = player.Character\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n\n    if not tool or not humanoid then return false end\n\n    if tool.Parent ~= character then\n        humanoid:EquipTool(tool)\n        task.wait(0.7)\n    end\n\n    return tool.Parent == character\nend\n\n-- ==========================================\n-- FEED STOCK\n-- ==========================================\n\nlocal function getStock(palung)\n    if not palung then return nil end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"TextLabel\") or obj:IsA(\"TextButton\") then\n            local txt = (obj.Text or \"\"):lower()\n            local name = obj.Name:lower()\n\n            if txt:find(\"pakan\", 1, true)\n            or name:find(\"pakan\", 1, true) then\n                local amount = txt:match(\"(%d+)%s*/%s*100\")\n                if amount then return tonumber(amount) end\n            end\n        end\n    end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"TextLabel\") or obj:IsA(\"TextButton\") then\n            local amount = (obj.Text or \"\"):match(\"(%d+)%s*/%s*100\")\n            if amount then return tonumber(amount) end\n        end\n    end\n\n    return nil\nend\n\n-- ==========================================\n-- FEED PROMPT\n-- ==========================================\n\nlocal function findFeedPrompt(palung)\n    if not palung then return nil end\n\n    local direct = palung:FindFirstChild(\"IsiPakanPrompt\", true)\n\n    if direct and direct:IsA(\"ProximityPrompt\") then\n        return direct\n    end\n\n    for _, obj in ipairs(palung:GetDescendants()) do\n        if obj:IsA(\"ProximityPrompt\") then\n            local action = (obj.ActionText or \"\"):lower()\n            local object = (obj.ObjectText or \"\"):lower()\n            local name = obj.Name:lower()\n\n            if action:find(\"isi\", 1, true)\n            or object:find(\"pakan\", 1, true)\n            or name:find(\"isi\", 1, true)\n            or name:find(\"pakan\", 1, true) then\n                return obj\n            end\n        end\n    end\n\n    return nil\nend\n\n-- ==========================================\n-- GET FEEDERS\n-- ==========================================\n\nlocal function getFeeders()\n    local result = {}\n    local kandang = getCurrentKandang()\n\n    if not kandang then return result end\n\n    local pen = getCurrentPen()\n\n    if pen then\n        for _, name in ipairs({\"Palung_1\", \"Palung_2\"}) do\n            local palung = pen:FindFirstChild(name, true)\n\n            if palung then\n                table.insert(result, {\n                    name = name,\n                    object = palung\n                })\n            end\n        end\n    end\n\n    local number = getKandangNumber()\n    local farm = W:FindFirstChild(\"TernakLokal\")\n\n    if farm and number then\n        for _, name in ipairs({\n            \"Palung_Kandang_\" .. number .. \"_1\",\n            \"Palung_Kandang_\" .. number .. \"_2\"\n        }) do\n            local palung = farm:FindFirstChild(name, true)\n\n            if palung then\n                local exists = false\n\n                for _, entry in ipairs(result) do\n                    if entry.object == palung then\n                        exists = true\n                    end\n                end\n\n                if not exists then\n                    table.insert(result, {\n                        name = name,\n                        object = palung\n                    })\n                end\n            end\n        end\n    end\n\n    return result\nend\n\n-- ==========================================\n-- AUTO FEED ONLY AT 0/100\n-- ==========================================\n\nlocal function feedOne()\n    if hwCarrying() then\n        setStatus(\"SAMPAH HOMEWORK BELUM DIBUANG\")\n        return false\n    end\n\n    local feeders = getFeeders()\n\n    if #feeders == 0 then\n        setStatus(\"PALUNG TIDAK DITEMUKAN\")\n        return false\n    end\n\n    local foundZero = false\n    local attempted = false\n\n    for _, entry in ipairs(feeders) do\n        if not alive() or not autoFarm\n        or homeworkEnabled or homeworkBusy then\n            return false\n        end\n\n        local stock = getStock(entry.object)\n\n        if stock == nil then\n            setStatus(entry.name .. \": STOK TIDAK TERBACA\")\n            continue\n        end\n\n        if stock ~= 0 then continue end\n        foundZero = true\n\n        local now = os.clock()\n        local last = feedCooldown[entry.name]\n\n        if last and now - last < FEED_RETRY then\n            continue\n        end\n\n        attempted = true\n\n        if not equipCabai() then\n            setStatus(\"CABAI TIDAK DITEMUKAN\")\n            return false\n        end\n\n        local prompt = findFeedPrompt(entry.object)\n\n        if not prompt then\n            setStatus(entry.name .. \": PROMPT ISI TIDAK ADA\")\n            feedCooldown[entry.name] = os.clock()\n            continue\n        end\n\n        if not prompt.Enabled then\n            setStatus(entry.name .. \": PROMPT ISI NONAKTIF\")\n            feedCooldown[entry.name] = os.clock()\n            continue\n        end\n\n        local position = getPosition(prompt)\n            or getObjectPosition(entry.object)\n\n        if not position then\n            setStatus(entry.name .. \": POSISI PALUNG GAGAL\")\n            continue\n        end\n\n        setStatus(entry.name .. \": MENGISI PAKAN 0/100\")\n\n        if not teleportNear(position, 2) then continue end\n\n        if not alive() or not autoFarm\n        or homeworkEnabled or homeworkBusy then\n            continue\n        end\n\n        local ok = activatePrompt(prompt)\n\n        if not ok then\n            feedCooldown[entry.name] = os.clock()\n            setStatus(entry.name .. \": INTERAKSI GAGAL\")\n            continue\n        end\n\n        local start = os.clock()\n        local newStock = getStock(entry.object)\n\n        while alive() and autoFarm\n        and not homeworkEnabled and not homeworkBusy\n        and os.clock() - start < 6 do\n            task.wait(0.25)\n\n            newStock = getStock(entry.object)\n\n            if newStock ~= nil and newStock > 0 then\n                break\n            end\n        end\n\n        if newStock ~= nil and newStock > 0 then\n            feedCooldown[entry.name] = nil\n            setStatus(entry.name .. \": PAKAN \" .. newStock .. \"/100\")\n        else\n            feedCooldown[entry.name] = os.clock()\n            setStatus(entry.name .. \": PENGISIAN BELUM BERHASIL\")\n        end\n    end\n\n    if not foundZero then\n        setStatus(\"PAKAN BELUM 0/100\")\n    elseif not attempted then\n        setStatus(\"MENUNGGU COOLDOWN PAKAN\")\n    end\n\n    return attempted\nend\n\n-- ==========================================\n-- REGISTER PROMPTS\n-- ==========================================\n\nfor _, obj in ipairs(W:GetDescendants()) do\n    addPrompt(obj)\nend\n\nconnect(W.DescendantAdded, function(obj)\n    if alive() then addPrompt(obj) end\nend)\n\n-- ==========================================\n-- AUTO CLEANER LOOP\n-- ==========================================\n\ntask.spawn(function()\n    while alive() and gui.Parent do\n        task.wait(SCAN_DELAY)\n\n        if not enabled or busy\n        or homeworkEnabled or homeworkBusy\n        or hwCarrying() then\n            continue\n        end\n\n        local character = player.Character\n        local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n\n        if not root then continue end\n\n        local prompt = getNearest(root)\n\n        if prompt and enabled\n        and not homeworkEnabled and not homeworkBusy then\n            busy = true\n            lastAttempt[prompt] = os.clock()\n\n            activatePrompt(prompt)\n            task.wait(0.1)\n\n            busy = false\n        end\n    end\nend)\n\n-- ==========================================\n-- AUTO FARM LOOP\n-- ==========================================\n\ntask.spawn(function()\n    local emptyScans = 0\n\n    while alive() and gui.Parent do\n        task.wait(0.5)\n\n        if not autoFarm then\n            emptyScans = 0\n            continue\n        end\n\n        -- HOMEWORK PRIORITY\n        if homeworkEnabled or homeworkBusy then\n            continue\n        end\n\n        -- Jangan biarkan Auto Farm membawa karakter ke kandang\n        -- ketika TrashBag Homework masih menempel di karakter.\n        if hwCarrying() then\n            setStatus(\"SAMPAH HOMEWORK BELUM DIBUANG\")\n            continue\n        end\n\n        enabled = true\n        updateButtons()\n\n        if not getCurrentKandang() then\n            setStatus(\"MEMBACA DATA KANDANG\")\n            emptyScans = 0\n            continue\n        end\n\n        local folder = getDroppingFolder()\n\n        if not folder then\n            emptyScans += 1\n\n            if emptyScans < 3 then\n                setStatus(\"FOLDER KOTORAN TIDAK ADA - CEK ULANG\")\n                continue\n            end\n\n            setStatus(\"TIDAK ADA KOTORAN - CEK PAKAN\")\n            feedOne()\n            emptyScans = 0\n            continue\n        end\n\n        local prompt, pos, scanReady, hasDroppings, waiting =\n            findNextDropping()\n\n        if not scanReady then\n            emptyScans += 1\n\n            if emptyScans < 3 then\n                setStatus(\"SCAN KOTORAN - CEK ULANG\")\n                continue\n            end\n\n            setStatus(\"KOTORAN TIDAK TERDETEKSI - CEK PAKAN\")\n            feedOne()\n            emptyScans = 0\n            continue\n        end\n\n        if hasDroppings then\n            emptyScans = 0\n\n            if waiting then\n                setStatus(\"KOTORAN MENUNGGU COOLDOWN\")\n                continue\n            end\n\n            if not prompt or not pos then\n                setStatus(\"POSISI KOTORAN TIDAK TERBACA\")\n                continue\n            end\n\n            setStatus(\"MENUJU KOTORAN\")\n\n            if not teleportNear(pos, 1.5) then\n                collectCooldown[prompt] = os.clock()\n                continue\n            end\n\n            if not alive() or not autoFarm\n            or homeworkEnabled or homeworkBusy then\n                continue\n            end\n\n            local activated, method = activatePrompt(prompt)\n\n            if not activated then\n                collectCooldown[prompt] = os.clock()\n                setStatus(\"INTERAKSI GAGAL\")\n                continue\n            end\n\n            setStatus(\"MENCOBA AMBIL: \" .. method)\n\n            local start = os.clock()\n            local collected = false\n\n            while alive() and autoFarm\n            and not homeworkEnabled and not homeworkBusy\n            and os.clock() - start < 4 do\n                task.wait(0.15)\n\n                if not prompt.Parent\n                or not prompt:IsDescendantOf(folder)\n                or not prompt.Enabled then\n                    collected = true\n                    break\n                end\n            end\n\n            if collected then\n                collectCooldown[prompt] = nil\n                setStatus(\"KOTORAN TERAMBIL\")\n            else\n                collectCooldown[prompt] = os.clock()\n                setStatus(\"BELUM TERAMBIL - COBA ULANG\")\n            end\n\n            continue\n        end\n\n        emptyScans += 1\n\n        if emptyScans < 3 then\n            setStatus(\"MEMASTIKAN KOTORAN HABIS\")\n            continue\n        end\n\n        setStatus(\"KOTORAN HABIS - CEK PAKAN\")\n        feedOne()\n        emptyScans = 0\n    end\nend)\n\n-- ==========================================\n-- TP LOCATION\n-- ==========================================\n\nlocal oldTool = backpack:FindFirstChild(\"TP LOCATION\")\n    or (player.Character and player.Character:FindFirstChild(\"TP LOCATION\"))\n\nif oldTool then oldTool:Destroy() end\n\nlocal tool = track(Instance.new(\"Tool\"))\ntool.Name = \"TP LOCATION\"\ntool.RequiresHandle = false\ntool.CanBeDropped = false\ntool.Parent = backpack\n\nlocal tpEquipped = false\nlocal equipTime = 0\n\nconnect(tool.Equipped, function()\n    tpEquipped = true\n    equipTime = os.clock()\nend)\n\nconnect(tool.Unequipped, function()\n    tpEquipped = false\nend)\n\nconnect(UIS.TouchTapInWorld, function(position, processed)\n    if not alive() or not tpEquipped or processed then return end\n    if os.clock() - equipTime < 0.25 then return end\n\n    local camera = W.CurrentCamera\n    if not camera then return end\n\n    local ray = camera:ViewportPointToRay(position.X, position.Y)\n    local params = RaycastParams.new()\n    params.FilterType = Enum.RaycastFilterType.Exclude\n    params.FilterDescendantsInstances = {player.Character}\n\n    local result = W:Raycast(ray.Origin, ray.Direction * 1500, params)\n    if not result then return end\n\n    local character = player.Character\n    local root = character and character:FindFirstChild(\"HumanoidRootPart\")\n    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")\n\n    if not root or not humanoid then return end\n\n    local height = humanoid.HipHeight + root.Size.Y / 2\n\n    root.CFrame = CFrame.new(\n        result.Position.X,\n        result.Position.Y + height + 0.15,\n        result.Position.Z\n    )\nend)\n\n-- ==========================================\n-- ANTI AFK\n-- ==========================================\n\nconnect(player.Idled, function()\n    if not alive() then return end\n\n    pcall(function()\n        VirtualUser:CaptureController()\n        VirtualUser:ClickButton2(Vector2.new(0, 0))\n    end)\nend)\n\n-- ==========================================\n-- GUI DESTROY GUARD\n-- ==========================================\n\nconnect(gui.Destroying, function()\n    if env.RaelV18Session == SESSION then\n        env.RaelV18Running = false\n    end\nend)\n\n-- ==========================================\n-- FINISH\n-- ==========================================\n\nupdateButtons()\nsetStatus(\"READY - FARM OFF\")\n\nprint(\"RAEL'S TRICKS V18.2 + HOMEWORK LOADED\")\nprint(\"AUTO CLEAN READY\")\nprint(\"AUTO FARM READY\")\nprint(\"HOMEWORK READY - SEPARATE TOGGLE\")\nprint(\"AUTO FEED WHEN FOLDER MISSING\")\nprint(\"FEED ONLY AT 0/100\")\nprint(\"MINIMIZE + REOPEN READY\")\nprint(\"TP LOCATION + ANTI AFK READY\")\nprint(\"NO STOP ALL\")\n"

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
    "local autoFarm = false\nlocal autoConvert = true\nlocal autoFeedEnabled = true\nlocal antiAfkEnabled = true\nlocal tpEnabled = true",
    "FEATURE FLAGS"
)

-- ==========================================
-- HOMEWORK IDLE HANDOFF: FARM/FEED/CONVERT
-- ==========================================

replaceOnce(
    "local homeworkBusy = false",
    "local homeworkBusy = false\nlocal homeworkIdle = false",
    "HOMEWORK IDLE FLAG"
)

replaceOnce(
    "homeworkBusy = true\n\n    -- Jaga karakter tetap berdiri",
    "homeworkBusy = true\nhomeworkIdle = false\n\n    -- Jaga karakter tetap berdiri",
    "HOMEWORK START ACTIVE"
)

replaceOnce(
    "if hwCarrying() then\n            local disposalHouse = hwNearestOwnedHouse()",
    "if hwCarrying() then\n            homeworkIdle = false\n            local disposalHouse = hwNearestOwnedHouse()",
    "HOMEWORK CARRY ACTIVE"
)

replaceOnce(
    "local house = hwFindHouse()\n\n        -- Prompt Bersihkan disabled",
    "local house = hwFindHouse()\n        homeworkIdle = house == nil\n\n        -- Prompt Bersihkan disabled",
    "HOMEWORK IDLE DETECTION"
)

replaceOnce(
    "if homeworkEnabled or homeworkBusy then\n            continue\n        end\n\n        -- Jangan biarkan Auto Farm",
    "if (homeworkEnabled or homeworkBusy) and not homeworkIdle then\n            continue\n        end\n\n        -- Jangan biarkan Auto Farm",
    "AUTO FARM IDLE HANDOFF"
)

replaceOnce(
    "or homeworkEnabled or homeworkBusy then\n            return false",
    "or ((homeworkEnabled or homeworkBusy) and not homeworkIdle) then\n            return false",
    "AUTO FEED IDLE HANDOFF 1"
)

replaceOnce(
    "or homeworkEnabled or homeworkBusy then\n            continue",
    "or ((homeworkEnabled or homeworkBusy) and not homeworkIdle) then\n            continue",
    "AUTO FEED IDLE HANDOFF 2"
)

replaceOnce(
    "and not homeworkEnabled and not homeworkBusy\n        and os.clock() - start < 6 do",
    "and (not homeworkEnabled or homeworkIdle)\n        and (not homeworkBusy or homeworkIdle)\n        and os.clock() - start < 6 do",
    "AUTO FEED WAIT IDLE HANDOFF"
)


-- ==========================================
-- AUTO CONVERT SYSTEM
-- ==========================================

local convertCode = [==[
-- ==========================================
-- AUTO CONVERT KOTORAN
-- ==========================================

local converting = false
local CONVERT_LIMIT = 100
local MIN_CONVERT_RATE = 0.0140
local lastConvertAttempt = 0

local function findManureTool()
    local containers = {backpack, player.Character}

    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool")
                and obj.Name:lower():find("kotoran", 1, true) then
                    return obj
                end
            end
        end
    end

    return nil
end

local function getManureCount()
    local tool = findManureTool()
    if not tool then return nil end

    local attributeNames = {
        "Amount", "Jumlah", "Count",
        "Stack", "Quantity", "JumlahKotoran"
    }

    for _, name in ipairs(attributeNames) do
        local value = tool:GetAttribute(name)
        if typeof(value) == "number" then
            return value
        end
    end

    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = obj.Name:lower()
            if name:find("jumlah") or name:find("count")
            or name:find("amount") or name:find("stack") then
                return obj.Value
            end
        end
    end

    local roots = {}
    local coreGui = game:GetService("CoreGui")

    pcall(function()
        table.insert(roots, coreGui)
    end)

    table.insert(roots, playerGui)

    for _, root in ipairs(roots) do
        local okScan, descendants = pcall(function()
            return root:GetDescendants()
        end)

        if okScan then
            for _, obj in ipairs(descendants) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local txt = (obj.Text or ""):lower()
                    local number = txt:match("x%s*([%d,%.]+)")

                    if number then
                        number = number:gsub(",", ""):gsub("%.", "")
                        local amount = tonumber(number)

                        if amount and amount >= CONVERT_LIMIT then
                            return amount
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function hasManureReady()
    local count = getManureCount()
    return count ~= nil and count >= CONVERT_LIMIT
end

local function getKursRate()
    local candidates = {}
    local market = playerGui:FindFirstChild("BursaGoldUI")
    local panel = market and market:FindFirstChild("PanelPasar")
    local marketContent = panel and panel:FindFirstChild("Konten")
    local kursBox = marketContent and marketContent:FindFirstChild("KursBox")
    if kursBox and kursBox:FindFirstChild("Nilai") then
        table.insert(candidates, kursBox.Nilai)
    end
    local ui = playerGui:FindFirstChild("ConvertUI")
    local convertPanel = ui and ui:FindFirstChild("PanelConvert")
    local content = convertPanel and convertPanel:FindFirstChild("Content")
    local strip = content and content:FindFirstChild("KursStrip")
    if strip and strip:FindFirstChild("Nilai") then
        table.insert(candidates, strip.Nilai)
    end
    for _, obj in ipairs(candidates) do
        local raw = tostring(obj.Text or "")
        local value = raw:match("=%s*([%d]+[,.]?[%d]*)")
            or raw:match("([%d]+[,.][%d]+)")
        if value then
            local rate = tonumber(value:gsub(",", "."))
            if rate then return rate end
        end
    end
    return nil
end

local function resolveConvertButton(obj)
    if not obj then return nil end
    if obj:IsA("GuiButton") then return obj end
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("GuiButton") then
            return child
        end
    end
    return nil
end

local function getConvertUI()
    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")
    local content = panel and panel:FindFirstChild("Content")

    if not content then return nil end

    return {
        panel = panel,
        content = content,
        masuk = resolveConvertButton(content:FindFirstChild("MasukBtn")),
        klaim = resolveConvertButton(content:FindFirstChild("KlaimBtn")),
        status = content:FindFirstChild("StatusLbl"),
        gold = content:FindFirstChild("Proses")
            and content.Proses:FindFirstChild("SlotGold")
            and content.Proses.SlotGold:FindFirstChild("Jumlah"),
        manure = content:FindFirstChild("Proses")
            and content.Proses:FindFirstChild("SlotKotoran")
            and content.Proses.SlotKotoran:FindFirstChild("Jumlah")
    }
end

local function isRateRising()
    local badges = {}

    local market = playerGui:FindFirstChild("BursaGoldUI")
    local marketPanel = market
        and market:FindFirstChild("PanelPasar")
    local marketContent = marketPanel
        and marketPanel:FindFirstChild("Konten")
    local kursBox = marketContent
        and marketContent:FindFirstChild("KursBox")

    if kursBox and kursBox:FindFirstChild("Badge") then
        table.insert(badges, kursBox.Badge)
    end

    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")
    local content = panel and panel:FindFirstChild("Content")
    local strip = content and content:FindFirstChild("KursStrip")

    if strip and strip:FindFirstChild("Badge") then
        table.insert(badges, strip.Badge)
    end

    for _, badge in ipairs(badges) do
        local text = (badge.Text or ""):upper()
        local green = false

        pcall(function()
            local color = badge.BackgroundColor3
            green = color.G > color.R and color.G > color.B
        end)

        if (text:find("▲", 1, true)
        or text:find("NAIK", 1, true))
        and green then
            return true
        end
    end

    return false
end

local function clickConvertButton(button)
    if not button or not button.Parent
    or not button:IsA("GuiButton")
    or not button.Visible or not button.Active then
        return false
    end

    if typeof(firesignal) ~= "function" then
        return false
    end

    local ok = pcall(function()
        firesignal(button.Activated)
    end)

    if not ok then
        ok = pcall(function()
            firesignal(button.MouseButton1Click)
        end)
    end

    return ok
end

local function closeConvertMachine()
    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")

    if not panel then
        return true
    end

    local closeNames = {
        "x", "close", "closebtn",
        "exit", "exitbtn", "tutup", "tutupbtn"
    }

    for _, obj in ipairs(panel:GetDescendants()) do
        if obj:IsA("GuiButton") then
            local name = obj.Name:lower()
            local label = ""

            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") then
                    label = (child.Text or ""):lower()
                    break
                end
            end

            local matched = false

            for _, closeName in ipairs(closeNames) do
                if name == closeName then
                    matched = true
                    break
                end
            end

            if matched
            or name:find("close", 1, true)
            or name:find("exit", 1, true)
            or name:find("tutup", 1, true)
            or label == "x" then

                clickConvertButton(obj)
                task.wait(0.5)

                if not panel.Visible then
                    return true
                end
            end
        end
    end

    return not panel.Visible
end

local function getNearestConvertPrompt()
    local folder = workspace:FindFirstChild("MsinConvert")
    if not folder then return nil end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local nearest
    local shortest = math.huge

    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("ProximityPrompt")
        and obj.Name == "ConvertPrompt"
        and obj.Enabled then
            local pos = getPosition(obj)

            if pos then
                local distance = (root.Position - pos).Magnitude

                if distance < shortest then
                    shortest = distance
                    nearest = obj
                end
            end
        end
    end

    return nearest
end

local function readGoldValue(ui)
    if not ui or not ui.gold then return 0 end

    local text = tostring(ui.gold.Text or "")
    text = text:gsub(",", ".")
    return tonumber(text:match("[%d%.]+")) or 0
end

local function runAutoConvert()
    if converting or not alive() or not autoFarm then
        return false
    end

    if os.clock() - lastConvertAttempt < 10 then
        return false
    end

    lastConvertAttempt = os.clock()
    converting = true
    busy = true

    local function finish(message)
        converting = false
        busy = false
        setStatus(message)
    end

    setStatus("KOTORAN PENUH - MENUJU MESIN")

    local prompt = getNearestConvertPrompt()

    if not prompt then
        finish("MESIN CONVERT TIDAK DITEMUKAN")
        return false
    end

    local position = getPosition(prompt)

    if not position or not teleportNear(position, 2) then
        finish("GAGAL MENUJU MESIN CONVERT")
        return false
    end

    local activated = activatePrompt(prompt)

    if not activated then
        finish("GAGAL MEMBUKA MESIN")
        return false
    end

    local start = os.clock()
    local ui

    repeat
        task.wait(0.25)
        ui = getConvertUI()
    until not alive()
        or not autoFarm
        or (ui and ui.masuk and ui.klaim)
        or os.clock() - start > 12

    if not alive() or not autoFarm then
        finish("CONVERT DIBATALKAN")
        return false
    end

    if not ui or not ui.masuk or not ui.klaim then
        finish("UI CONVERT TIDAK TERDETEKSI")
        return false
    end

    setStatus("MEMERIKSA KURS MINIMAL 0,0140")
    local rate = getKursRate()
    if not rate or rate < MIN_CONVERT_RATE then
        finish("KURS DI BAWAH 0,0140")
        return false
    end
    local beforeGold = readGoldValue(ui)
    local beforeManure = getManureCount() or 0
    setStatus("MEMASUKKAN "..tostring(beforeManure).." KOTORAN")

    if not clickConvertButton(ui.masuk) then
        finish("TOMBOL MASUK GAGAL")
        return false
    end

    start = os.clock()
    local completed = false

    while alive() and autoFarm
    and os.clock() - start < 60 do
        task.wait(0.5)

        ui = getConvertUI()

        if ui then
            local goldNow = readGoldValue(ui)
            local statusText = ui.status
                and (ui.status.Text or ""):lower() or ""

            if goldNow > beforeGold
            or statusText:find("selesai", 1, true)
            or statusText:find("berhasil", 1, true)
            or statusText:find("klaim", 1, true) then
                completed = true
                break
            end
        end
    end

    if not alive() or not autoFarm then
        finish("CONVERT DIBATALKAN")
        return false
    end

    if not completed then
        finish("PROSES CONVERT BELUM TERKONFIRMASI")
        return false
    end

    ui = getConvertUI()

    if not ui or not ui.klaim then
        finish("TOMBOL KLAIM TIDAK DITEMUKAN")
        return false
    end

    setStatus("MENGKLAIM GOLD")

    local claimGold = readGoldValue(ui)
    if claimGold <= 0 then
        finish("NILAI GOLD KLAIM TIDAK TERBACA")
        return false
    end

    local claimConfirmed = false
    for attempt = 1, 2 do
        ui = getConvertUI()
        if not ui or not ui.klaim then
            claimConfirmed = true
            break
        end

        if not clickConvertButton(ui.klaim) then
            finish("TOMBOL KLAIM TIDAK BISA DIKLIK")
            return false
        end

        start = os.clock()
        while alive() and autoFarm
        and os.clock() - start < 6 do
            task.wait(0.5)

            local current = getConvertUI()
            if not current then
                claimConfirmed = true
                break
            end

            local goldNow = readGoldValue(current)
            local claimButton = current.klaim
            local statusText = current.status
                and (current.status.Text or ""):lower() or ""

            if goldNow < claimGold
            or (claimButton and (not claimButton.Visible
                or not claimButton.Active))
            or statusText:find("diklaim", 1, true) then
                claimConfirmed = true
                break
            end
        end

        if claimConfirmed then break end

        ui = getConvertUI()
        if attempt == 1 and ui and ui.klaim
        and ui.klaim.Visible and ui.klaim.Active
        and readGoldValue(ui) >= claimGold then
            setStatus("KLAIM BELUM BERUBAH - COBA SEKALI LAGI")
            task.wait(0.5)
        else
            break
        end
    end

    if not claimConfirmed then
        finish("KLAIM BELUM TERKONFIRMASI - PANEL TETAP TERBUKA")
        return false
    end

    setStatus("GOLD DIKLAIM - KELUAR MESIN")
    closeConvertMachine()
    task.wait(1)
    finish("CONVERT BERHASIL - FARM LANJUT")
    return true
end
]==]

-- ==========================================
-- GUI V1 + AUTO GACHA
-- ==========================================

local guiCode = [==[
-- MODERN GUI V1
local oldGui = playerGui:FindFirstChild("RaelsTricksV1")
if oldGui then oldGui:Destroy() end

local gui = track(Instance.new("ScreenGui"))
gui.Name = "RaelsTricksV1"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(252, 331)
frame.Position = UDim2.new(1, -266, 0, 95)
frame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(45, 212, 191)
frameStroke.Thickness = 1.3
frameStroke.Transparency = 0.15
frameStroke.Parent = frame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 43)
header.BackgroundColor3 = Color3.fromRGB(17, 94, 89)
header.BorderSizePixel = 0
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 12)
headerCover.Position = UDim2.new(0, 0, 1, -12)
headerCover.BackgroundColor3 = header.BackgroundColor3
headerCover.BorderSizePixel = 0
headerCover.Parent = header

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

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -48, 0, 13)
subtitle.Position = UDim2.fromOffset(12, 25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "INDO KOS  •  AUTOMATION V1"
subtitle.TextColor3 = Color3.fromRGB(153, 246, 228)
subtitle.TextSize = 8
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

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

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(153, 246, 228)
miniStroke.Thickness = 1.5
miniStroke.Parent = miniButton

local section = Instance.new("TextLabel")
section.Size = UDim2.new(1, -24, 0, 16)
section.Position = UDim2.fromOffset(12, 49)
section.BackgroundTransparency = 1
section.Text = "FITUR OTOMATIS"
section.TextColor3 = Color3.fromRGB(148, 163, 184)
section.TextSize = 9
section.Font = Enum.Font.GothamBold
section.TextXAlignment = Enum.TextXAlignment.Left
section.Parent = frame

local function makeToggle(name, label, x, y)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.fromOffset(110, 32)
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

local cleanButton = makeToggle("CleanButton", "CLEANER", 12, 69)
local farmButton = makeToggle("FarmButton", "AUTO FARM", 130, 69)
local convertButton = makeToggle("ConvertButton", "CONVERT", 12, 108)
local feedButton = makeToggle("FeedButton", "AUTO FEED", 130, 108)
local afkButton = makeToggle("AfkButton", "ANTI-AFK", 12, 147)
local tpButton = makeToggle("TpButton", "TP LOCATION", 130, 147)

-- TOMBOL AUTO GACHA DI GUI UTAMA
local gachaButton = makeToggle("GachaButton", "AUTO GACHA", 12, 186)
gachaButton.Size = UDim2.new(1, -24, 0, 32)

local homeworkButton = makeToggle("HomeworkButton", "HOMEWORK", 130, 225)
homeworkButton.Size = UDim2.fromOffset(110, 32)

local statusPanel = Instance.new("Frame")
statusPanel.Size = UDim2.new(1, -24, 0, 39)
statusPanel.Position = UDim2.fromOffset(12, 264)
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
status.TextYAlignment = Enum.TextYAlignment.Center
status.Parent = statusPanel

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -24, 0, 14)
footer.Position = UDim2.fromOffset(12, 309)
footer.BackgroundTransparency = 1
footer.Text = "RAEL EDITION  •  V1"
footer.TextColor3 = Color3.fromRGB(100, 116, 139)
footer.TextSize = 8
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Parent = frame

local function setStatus(msg)
    if status and status.Parent then
        status.Text = "STATUS: " .. tostring(msg)
    end
end

local function paintToggle(button, label, state)
    button.Text = label .. (state and ": ON" or ": OFF")
    button.BackgroundColor3 = state
        and Color3.fromRGB(5, 150, 105)
        or Color3.fromRGB(127, 29, 29)
end

-- ==========================================
-- AUTO GACHA SYSTEM
-- ==========================================

local autoGachaEnabled = false
local gachaWorkerRunning = false
local gachaBusy = false

local Gacha

local function getGachaService()
    if Gacha then
        return Gacha
    end

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local knitModule = replicatedStorage
        :WaitForChild("NKSystem")
        :WaitForChild("Packages")
        :WaitForChild("Knit")

    local Knit = require(knitModule)
    Gacha = Knit.GetService("GachaService")

    return Gacha
end

-- PCALL MENANGKAP HASIL AWAIT DENGAN BENAR
local function callGacha(methodName)
    local service = getGachaService()
    local method = service[methodName]

    if type(method) ~= "function" then
        return false, "METHOD TIDAK DITEMUKAN: " .. methodName
    end

    local callOK, awaitOK, result = pcall(function()
        return method(service):await()
    end)

    if not callOK then
        return false, tostring(awaitOK)
    end

    if not awaitOK then
        return false, result or "PROMISE GAGAL"
    end

    return true, result
end

local function claimGachaSingle()
    local okClaim, claimResult = callGacha("ClaimReward")

    if not okClaim then
        setStatus("GACHA: KLAIM GAGAL")
        return false
    end

    return true
end

local function claimGachaMulti(results)
    local total = #results

    for index = 1, total do
        -- Tetap selesaikan klaim hadiah spin yang sudah berjalan,
        -- meskipun tombol AUTO GACHA dimatikan.
        local okClaim = callGacha("ClaimOneMultiReward")

        if not okClaim then
            setStatus("GACHA: KLAIM MULTI GAGAL")
            return false
        end

        task.wait(0.25)
    end

    return true
end

local function runAutoGacha()
    if gachaWorkerRunning then
        return
    end

    gachaWorkerRunning = true

    while autoGachaEnabled and alive() do
        if not gachaBusy then
            gachaBusy = true

            local stateOK, state = callGacha("GetState")

            if not stateOK or type(state) ~= "table" then
                setStatus("GACHA: GAGAL MEMBACA STATE")
                gachaBusy = false
                task.wait(3)
            else
                local free = tonumber(state.free) or 0
                local spinOK = false
                local result = nil

                if free >= 10 then
                    setStatus("GACHA: FREE SPIN X10")

                    spinOK, result = callGacha("SpinX10WithFree")

                    if spinOK
                    and type(result) == "table"
                    and result.ok then

                        local results = result.results or {}

                        if #results > 0 then
                            claimGachaMulti(results)
                        end
                    else
                        spinOK = false
                    end

                elseif free > 0 then
                    setStatus("GACHA: FREE SPIN")

                    spinOK, result = callGacha("Spin")

                    if spinOK
                    and type(result) == "table"
                    and result.ok then

                        if result.granted ~= false then
                            claimGachaSingle()
                        end
                    else
                        spinOK = false
                    end

                else
                    setStatus("GACHA: PAID SPIN")

                    spinOK, result = callGacha("SpinWithMoney")

                    if spinOK
                    and type(result) == "table"
                    and result.ok then

                        claimGachaSingle()
                    else
                        spinOK = false
                    end
                end

                if spinOK then
                    setStatus("GACHA: SPIN SELESAI")
                    task.wait(1.5)
                else
                    setStatus("GACHA: SPIN GAGAL / COBA LAGI")
                    task.wait(3)
                end

                gachaBusy = false
            end
        end
    end

    gachaBusy = false
    gachaWorkerRunning = false

    autoGachaEnabled = false

    if gachaButton and gachaButton.Parent then
        paintToggle(gachaButton, "AUTO GACHA", false)
    end

    if alive() then
        setStatus("AUTO GACHA NONAKTIF")
    end
end

local function updateButtons()
    paintToggle(cleanButton, "CLEANER", enabled)
    paintToggle(farmButton, "AUTO FARM", autoFarm)
    paintToggle(convertButton, "CONVERT", autoConvert)
    paintToggle(feedButton, "AUTO FEED", autoFeedEnabled)
    paintToggle(afkButton, "ANTI-AFK", antiAfkEnabled)
    paintToggle(tpButton, "TP LOCATION", tpEnabled)
    paintToggle(gachaButton, "AUTO GACHA", autoGachaEnabled)
    paintToggle(homeworkButton, "HOMEWORK", homeworkEnabled)
end

local function makeDraggable(object)
    local dragging = false
    local dragStart
    local startPosition

    connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    connect(UIS.InputChanged, function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
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
makeDraggable(miniButton)

connect(minimizeButton.Activated, function()
    frame.Visible = false
    miniButton.Visible = true
end)

connect(miniButton.Activated, function()
    miniButton.Visible = false
    frame.Visible = true
end)

connect(convertButton.Activated, function()
    if not alive() then return end

    autoConvert = not autoConvert
    updateButtons()

    setStatus(autoConvert and "AUTO CONVERT AKTIF" or "AUTO CONVERT NONAKTIF")
end)

connect(feedButton.Activated, function()
    if not alive() then return end

    autoFeedEnabled = not autoFeedEnabled
    updateButtons()

    setStatus(autoFeedEnabled and "AUTO FEED AKTIF" or "AUTO FEED NONAKTIF")
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

-- TOGGLE AUTO GACHA
connect(gachaButton.Activated, function()
    if not alive() then return end

    autoGachaEnabled = not autoGachaEnabled
    updateButtons()

    if autoGachaEnabled then
        setStatus("AUTO GACHA DIMULAI")
        task.spawn(runAutoGacha)
    else
        setStatus("AUTO GACHA DIMATIKAN")
    end
end)

updateButtons()
]==]

replaceBetween(
    "-- ==========================================\n-- GUI\n-- ==========================================",
    "-- ==========================================\n-- HOMEWORK SYSTEM",
    guiCode,
    "MODERN GUI + AUTO GACHA"
)

-- ==========================================
-- SISIPKAN AUTO CONVERT
-- ==========================================

replaceOnce(
    "-- ==========================================\n-- AUTO CLEANER LOOP",
    convertCode .. "\n\n-- ==========================================\n-- AUTO CLEANER LOOP",
    "AUTO CONVERT INSERT"
)

-- ==========================================
-- CLEANER BERHENTI SEMENTARA SAAT CONVERT
-- ==========================================

replaceOnce(
    "if not enabled or busy\n        or homeworkEnabled or homeworkBusy\n        or hwCarrying() then",
    "if not enabled or busy or converting\n        or homeworkEnabled or homeworkBusy\n        or hwCarrying() then",
    "CLEANER CONVERT GUARD"
)

-- ==========================================
-- AUTO FARM CONVERT SAAT KOTORAN PENUH
-- ==========================================

replaceOnce(
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end",
    "if not autoFarm then\n            emptyScans = 0\n            continue\n        end\n\n        if converting then\n            continue\n        end\n\n        if autoConvert and hasManureReady()\n        and (getKursRate() or 0) >= MIN_CONVERT_RATE then\n            runAutoConvert()\n            continue\n        end",
    "AUTO FARM CONVERT TRIGGER"
)

-- ==========================================
-- TOGGLE AUTO FEED
-- ==========================================

replaceOnce(
    "local function feedOne()\n    if hwCarrying() then",
    "local function feedOne()\n    if not autoFeedEnabled then return false end\n    if hwCarrying() then",
    "AUTO FEED TOGGLE"
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

replaceOnce(
    "if not alive() or not tpEquipped or processed then",
    "if not alive() or not tpEnabled or not tpEquipped or processed then",
    "TP LOCATION TOGGLE"
)

-- ==========================================
-- UBAH LABEL VERSI
-- ==========================================

source = source:gsub("V18%.2", "V1")
source = source:gsub("V18%.3", "V1")

-- ==========================================
-- COMPILE DAN JALANKAN
-- ==========================================

local compiled, compileError = loadstring(source)

if not compiled then
    error(reportLoaderError("COMPILE ERROR: " .. tostring(compileError)))
end

local runOK, runError = pcall(compiled)
if not runOK then
    error(reportLoaderError("RUNTIME ERROR: " .. tostring(runError)))
end
