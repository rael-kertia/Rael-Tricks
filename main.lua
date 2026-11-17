                end
            end
        end
    end

    return nil
end

local function isManureFull()
    local count = getManureCount()
    return count ~= nil and count >= CONVERT_LIMIT
end

local function getConvertUI()
    local ui = playerGui:FindFirstChild("ConvertUI")
    local panel = ui and ui:FindFirstChild("PanelConvert")
    local content = panel and panel:FindFirstChild("Content")

    if not content then return nil end

    return {
        panel = panel,
        content = content,
        masuk = content:FindFirstChild("MasukBtn"),
        klaim = content:FindFirstChild("KlaimBtn"),
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

-- KLIK TOMBOL MASUK DAN KLAIM
local function clickConvertButton(button)
    if not button or not button.Parent then
        return false
    end

    local fired = false

    if typeof(firesignal) == "function" then
        pcall(function()
            firesignal(button.MouseButton1Click)
            fired = true
        end)

        task.wait(0.2)

        pcall(function()
            firesignal(button.Activated)
            fired = true
        end)
    end

    return fired
end

-- TUTUP MESIN CONVERT / TEKAN X
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
