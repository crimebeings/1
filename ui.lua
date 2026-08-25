local UI = {}

local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

function UI.Init(cfg, bodyPartsList)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PastelSilentAimUI"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 360, 0, 420)
    Main.Position = UDim2.new(0.5, -180, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(242, 248, 252)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui

    -- Kéo thả UI
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, math.max(0, cam.ViewportSize.X - Main.AbsoluteSize.X))
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(0, cam.ViewportSize.Y - Main.AbsoluteSize.Y))
        Main.Position = UDim2.new(0, newX, 0, newY)
    end

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 14)

    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Color = Color3.fromRGB(180, 215, 235)
    UIStroke.Thickness = 2

    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Crimebeings Silent Aim "
    Title.TextColor3 = Color3.fromRGB(90, 130, 160)
    Title.TextSize = 18
    Title.Font = Enum.Font.FredokaOne
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeBtn = Instance.new("TextButton", Header)
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -36, 0.5, -13)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(215, 235, 245)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(90, 130, 160)
    MinimizeBtn.Font = Enum.Font.FredokaOne
    MinimizeBtn.TextSize = 20
    MinimizeBtn.AutoButtonColor = false

    local MiniCorner = Instance.new("UICorner", MinimizeBtn)
    MiniCorner.CornerRadius = UDim.new(0, 8)

    local MiniBubble = Instance.new("TextButton", ScreenGui)
    MiniBubble.Name = "MiniBubble"
    MiniBubble.Size = UDim2.new(0, 48, 0, 48)
    MiniBubble.Position = UDim2.new(0.5, -24, 0.5, -24)
    MiniBubble.BackgroundColor3 = Color3.fromRGB(242, 248, 252)
    MiniBubble.Text = "🌸"
    MiniBubble.TextSize = 22
    MiniBubble.Visible = false
    MiniBubble.Active = true

    local bDragging, bDragStart, bStartPos
    MiniBubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            bDragging = true
            bDragStart = input.Position
            bStartPos = MiniBubble.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    bDragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if bDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - bDragStart
            local newX = math.clamp(bStartPos.X.Offset + delta.X, 0, cam.ViewportSize.X - 48)
            local newY = math.clamp(bStartPos.Y.Offset + delta.Y, 0, cam.ViewportSize.Y - 48)
            MiniBubble.Position = UDim2.new(0, newX, 0, newY)
        end
    end)

    local BubbleCorner = Instance.new("UICorner", MiniBubble)
    BubbleCorner.CornerRadius = UDim.new(1, 0)

    local BubbleStroke = Instance.new("UIStroke", MiniBubble)
    BubbleStroke.Color = Color3.fromRGB(180, 215, 235)
    BubbleStroke.Thickness = 2

    local Scroll = Instance.new("ScrollingFrame", Main)
    Scroll.Size = UDim2.new(1, -20, 1, -50)
    Scroll.Position = UDim2.new(0, 10, 0, 40)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(160, 200, 225)

    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
    end)

    local function minimizeUI()
        local x = math.clamp(Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2) - 24, 0, cam.ViewportSize.X - 48)
        local y = math.clamp(Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2) - 24, 0, cam.ViewportSize.Y - 48)
        MiniBubble.Position = UDim2.new(0, x, 0, y)
        Main.Visible = false
        MiniBubble.Visible = true
    end

    local function restoreUI()
        local x = math.clamp(MiniBubble.AbsolutePosition.X - (Main.AbsoluteSize.X / 2) + 24, 0, cam.ViewportSize.X - Main.AbsoluteSize.X)
        local y = math.clamp(MiniBubble.AbsolutePosition.Y - (Main.AbsoluteSize.Y / 2) + 24, 0, cam.ViewportSize.Y - Main.AbsoluteSize.Y)
        Main.Position = UDim2.new(0, x, 0, y)
        MiniBubble.Visible = false
        Main.Visible = true
    end

    MinimizeBtn.MouseButton1Click:Connect(minimizeUI)
    MiniBubble.MouseButton1Click:Connect(restoreUI)

    local function createCard(height)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, height or 40)
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.BorderSizePixel = 0
        card.Parent = Scroll
        
        local c = Instance.new("UICorner", card)
        c.CornerRadius = UDim.new(0, 8)
        
        local s = Instance.new("UIStroke", card)
        s.Color = Color3.fromRGB(215, 235, 245)
        s.Thickness = 1
        return card
    end

    local function addToggle(text, default, callback)
        local card = createCard(40)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(100, 130, 150)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", card)
        btn.Size = UDim2.new(0, 44, 0, 22)
        btn.Position = UDim2.new(1, -54, 0.5, -11)
        btn.BackgroundColor3 = default and Color3.fromRGB(150, 205, 230) or Color3.fromRGB(220, 225, 230)
        btn.Text = ""
        btn.AutoButtonColor = false

        local bc = Instance.new("UICorner", btn)
        bc.CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        
        local cc = Instance.new("UICorner", circle)
        cc.CornerRadius = UDim.new(1, 0)

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(150, 205, 230) or Color3.fromRGB(220, 225, 230)
            circle:TweenPosition(state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            callback(state)
        end)
    end

    local function addSlider(text, min, max, default, callback)
        local card = createCard(50)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0.6, 0, 0, 20)
        lbl.Position = UDim2.new(0, 10, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(100, 130, 150)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local valLbl = Instance.new("TextLabel", card)
        valLbl.Size = UDim2.new(0.3, 0, 0, 20)
        valLbl.Position = UDim2.new(0.7, -10, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(default)
        valLbl.TextColor3 = Color3.fromRGB(130, 160, 180)
        valLbl.Font = Enum.Font.SourceSans
        valLbl.TextSize = 14
        valLbl.TextXAlignment = Enum.TextXAlignment.Right

        local bg = Instance.new("Frame", card)
        bg.Size = UDim2.new(1, -20, 0, 8)
        bg.Position = UDim2.new(0, 10, 0, 30)
        bg.BackgroundColor3 = Color3.fromRGB(225, 235, 240)
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", bg)
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(150, 205, 230)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local sDragging = false
        local function update(input)
            local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valLbl.Text = tostring(val)
            callback(val)
        end

        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sDragging = true
                update(input)
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sDragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if sDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end

    local function addDropdown(text, list, default, callback)
        local card = createCard(40)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(100, 130, 150)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", card)
        btn.Size = UDim2.new(0.55, 0, 0, 26)
        btn.Position = UDim2.new(0.43, 0, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(235, 245, 250)
        btn.Text = default
        btn.TextColor3 = Color3.fromRGB(90, 130, 150)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local s = Instance.new("UIStroke", btn)
        s.Color = Color3.fromRGB(190, 220, 235)

        local dropFrame = Instance.new("ScrollingFrame", Scroll)
        dropFrame.Size = UDim2.new(1, -6, 0, 120)
        dropFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dropFrame.Visible = false
        dropFrame.BorderSizePixel = 0
        dropFrame.ScrollBarThickness = 3
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
        
        local dList = Instance.new("UIListLayout", dropFrame)
        dList.SortOrder = Enum.SortOrder.LayoutOrder

        dList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            dropFrame.CanvasSize = UDim2.new(0, 0, 0, dList.AbsoluteContentSize.Y)
        end)

        for _, v in ipairs(list) do
            local item = Instance.new("TextButton", dropFrame)
            item.Size = UDim2.new(1, 0, 0, 24)
            item.BackgroundTransparency = 1
            item.Text = v
            item.TextColor3 = Color3.fromRGB(100, 130, 150)
            item.Font = Enum.Font.SourceSans
            item.TextSize = 13
            
            item.MouseButton1Click:Connect(function()
                btn.Text = v
                dropFrame.Visible = false
                callback(v)
            end)
        end

        btn.MouseButton1Click:Connect(function()
            dropFrame.Visible = not dropFrame.Visible
        end)
    end

    local function addKeybind(text, defaultKey, callback)
        local card = createCard(40)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0.6, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(100, 130, 150)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", card)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -90, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(235, 245, 250)
        btn.Text = defaultKey.Name
        btn.TextColor3 = Color3.fromRGB(90, 130, 150)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local s = Instance.new("UIStroke", btn)
        s.Color = Color3.fromRGB(190, 220, 235)

        local listening = false
        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)

        UIS.InputBegan:Connect(function(input, gpe)
            if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                btn.Text = input.KeyCode.Name
                callback(input.KeyCode)
            end
        end)
    end


    addToggle("Silent Aim", cfg.silentAim, function(v) cfg.silentAim = v end)
    addToggle("Show FOV Circle", cfg.silentAimFOVShow, function(v) cfg.silentAimFOVShow = v end)
    addSlider("FOV Size", 10, 500, cfg.silentAimFOV, function(v) cfg.silentAimFOV = v end)
    addToggle("Bypass Revolver", cfg.bypassRevolver, function(v) cfg.bypassRevolver = v end)
    addToggle("Wall Check", cfg.silentAimWallCheck, function(v) cfg.silentAimWallCheck = v end)
    addToggle("Target Closest Part", cfg.silentAimClosestPart, function(v) cfg.silentAimClosestPart = v end)
    addDropdown("HitPart (16 Parts)", bodyPartsList, cfg.silentAimPart, function(v) cfg.silentAimPart = v end)
    addToggle("Enable Keybind", cfg.useKeybind, function(v) cfg.useKeybind = v end)
    addKeybind("Toggle Aim Key", cfg.silentAimKey, function(v) cfg.silentAimKey = v end)
    addKeybind("Hide/Show UI Key", cfg.uiToggleKey, function(v) cfg.uiToggleKey = v end)

    return ScreenGui
end

return UI
