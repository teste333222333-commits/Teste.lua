-- Rayfield ESP Avançado by teste333222333-commits
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "ESP Avançado (Rayfield)",
    LoadingTitle = "ESP Avançado",
    LoadingSubtitle = "by teste333222333-commits",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldESPConfigs",
        FileName = "ESP_Avancado"
    }
})

local MainTab = Window:CreateTab("ESP", 4483362458)

-- Settings table (editável via Rayfield UI)
local Settings = {
    Enabled = false,
    TeamCheck = false,
    ShowTeam = false,
    VisibilityCheck = true,
    BoxESP = false,
    BoxStyle = "Corner",
    BoxOutline = true,
    BoxFilled = false,
    BoxFillTransparency = 0.5,
    BoxThickness = 1,
    TracerESP = false,
    TracerOrigin = "Bottom",
    TracerStyle = "Line",
    TracerThickness = 1,
    HealthESP = false,
    HealthStyle = "Bar",
    HealthBarSide = "Left",
    HealthTextSuffix = "HP",
    NameESP = false,
    NameMode = "DisplayName",
    ShowDistance = true,
    DistanceUnit = "studs",
    TextSize = 14,
    TextFont = 2,
    RainbowSpeed = 1,
    MaxDistance = 1000,
    RefreshRate = 1/144,
    Snaplines = false,
    SnaplineStyle = "Straight",
    RainbowEnabled = false,
    RainbowBoxes = false,
    RainbowTracers = false,
    RainbowText = false,
    ChamsEnabled = false,
    ChamsOutlineColor = Color3.fromRGB(255,255,255),
    ChamsFillColor = Color3.fromRGB(255,0,0),
    ChamsOccludedColor = Color3.fromRGB(150,0,0),
    ChamsTransparency = 0.5,
    ChamsOutlineTransparency = 0,
    ChamsOutlineThickness = 0.1,
    SkeletonESP = false,
    SkeletonColor = Color3.fromRGB(255,255,255),
    SkeletonThickness = 1.5,
    SkeletonTransparency = 1
}

local Colors = {
    Enemy = Color3.fromRGB(255, 25, 25),
    Ally = Color3.fromRGB(25, 255, 25),
    Neutral = Color3.fromRGB(255, 255, 255),
    Selected = Color3.fromRGB(255, 210, 0),
    Health = Color3.fromRGB(0, 255, 0),
    Distance = Color3.fromRGB(200, 200, 200),
    Rainbow = nil
}

----------------------------------------------------------------------
-- UI - Elementos Rayfield (exemplos, adicione quantos quiser)
----------------------------------------------------------------------

MainTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = Settings.Enabled,
    Flag = "EnabledESP",
    Callback = function(Value) Settings.Enabled = Value end
})

MainTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = Settings.BoxESP,
    Flag = "BoxESP",
    Callback = function(Value) Settings.BoxESP = Value end
})

MainTab:CreateDropdown({
    Name = "Box Style",
    Options = {"Full", "Corner", "ThreeD"},
    CurrentOption = Settings.BoxStyle,
    Flag = "BoxStyle",
    Callback = function(Value) Settings.BoxStyle = Value end
})

MainTab:CreateSlider({
    Name = "Box Thickness",
    Range = {1,5},
    Increment = 1,
    CurrentValue = Settings.BoxThickness,
    Flag = "BoxThickness",
    Callback = function(Value) Settings.BoxThickness = Value end
})

MainTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 10000},
    Increment = 50,
    CurrentValue = Settings.MaxDistance,
    Flag = "MaxDistance",
    Callback = function(Value) Settings.MaxDistance = Value end
})

MainTab:CreateColorPicker({
    Name = "Cor do Inimigo",
    Color = Colors.Enemy,
    Flag = "EnemyColor",
    Callback = function(Value) Colors.Enemy = Value end
})

MainTab:CreateColorPicker({
    Name = "Cor do Aliado",
    Color = Colors.Ally,
    Flag = "AllyColor",
    Callback = function(Value) Colors.Ally = Value end
})

MainTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = Settings.TeamCheck,
    Flag = "TeamCheck",
    Callback = function(Value) Settings.TeamCheck = Value end
})

MainTab:CreateToggle({
    Name = "Mostrar Team",
    CurrentValue = Settings.ShowTeam,
    Flag = "ShowTeam",
    Callback = function(Value) Settings.ShowTeam = Value end
})

MainTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = Settings.TracerESP,
    Flag = "TracerESP",
    Callback = function(Value) Settings.TracerESP = Value end
})

MainTab:CreateDropdown({
    Name = "Tracer Origin",
    Options = {"Bottom", "Top", "Mouse", "Center"},
    CurrentOption = Settings.TracerOrigin,
    Flag = "TracerOrigin",
    Callback = function(Value) Settings.TracerOrigin = Value end
})

MainTab:CreateToggle({
    Name = "Snaplines",
    CurrentValue = Settings.Snaplines,
    Flag = "Snaplines",
    Callback = function(Value) Settings.Snaplines = Value end
})

MainTab:CreateToggle({
    Name = "Chams",
    CurrentValue = Settings.ChamsEnabled,
    Flag = "ChamsEnabled",
    Callback = function(Value) Settings.ChamsEnabled = Value end
})

MainTab:CreateColorPicker({
    Name = "Chams Fill",
    Color = Settings.ChamsFillColor,
    Flag = "ChamsFillColor",
    Callback = function(Value) Settings.ChamsFillColor = Value end
})

MainTab:CreateColorPicker({
    Name = "Chams Outline",
    Color = Settings.ChamsOutlineColor,
    Flag = "ChamsOutlineColor",
    Callback = function(Value) Settings.ChamsOutlineColor = Value end
})

MainTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = Settings.SkeletonESP,
    Flag = "SkeletonESP",
    Callback = function(Value) Settings.SkeletonESP = Value end
})

MainTab:CreateColorPicker({
    Name = "Cor do Skeleton",
    Color = Settings.SkeletonColor,
    Flag = "SkeletonColor",
    Callback = function(Value) Settings.SkeletonColor = Value end
})

--------------------------------------------------
-- Variáveis internas e serviços Roblox
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Drawings = {
    ESP = {},
    Tracers = {},
    Boxes = {},
    Healthbars = {},
    Names = {},
    Distances = {},
    Snaplines = {},
    Skeleton = {}
}

local Highlights = {}

--------------------------------------------------
-- Funções principais ESP (criação, remoção, update)
--------------------------------------------------

local function CreateESP(player)
    if player == LocalPlayer then return end
    local box = {
        TopLeft = Drawing.new("Line"),
        TopRight = Drawing.new("Line"),
        BottomLeft = Drawing.new("Line"),
        BottomRight = Drawing.new("Line"),
        Left = Drawing.new("Line"),
        Right = Drawing.new("Line"),
        Top = Drawing.new("Line"),
        Bottom = Drawing.new("Line")
    }
    for _, line in pairs(box) do
        line.Visible = false
        line.Color = Colors.Enemy
        line.Thickness = Settings.BoxThickness
    end

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Colors.Enemy
    tracer.Thickness = Settings.TracerThickness

    local healthBar = {
        Outline = Drawing.new("Square"),
        Fill = Drawing.new("Square"),
        Text = Drawing.new("Text")
    }
    for _, obj in pairs(healthBar) do
        obj.Visible = false
        if obj == healthBar.Fill then
            obj.Color = Colors.Health
            obj.Filled = true
        elseif obj == healthBar.Text then
            obj.Center = true
            obj.Size = Settings.TextSize
            obj.Color = Colors.Health
            obj.Font = Settings.TextFont
        end
    end

    local info = {
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }
    for _, text in pairs(info) do
        text.Visible = false
        text.Center = true
        text.Size = Settings.TextSize
        text.Color = Colors.Enemy
        text.Font = Settings.TextFont
        text.Outline = true
    end

    local snapline = Drawing.new("Line")
    snapline.Visible = false
    snapline.Color = Colors.Enemy
    snapline.Thickness = 1

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Settings.ChamsFillColor
    highlight.OutlineColor = Settings.ChamsOutlineColor
    highlight.FillTransparency = Settings.ChamsTransparency
    highlight.OutlineTransparency = Settings.ChamsOutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = Settings.ChamsEnabled
    Highlights[player] = highlight

    local skeleton = {
        Head = Drawing.new("Line"),
        Neck = Drawing.new("Line"),
        UpperSpine = Drawing.new("Line"),
        LowerSpine = Drawing.new("Line"),
        LeftShoulder = Drawing.new("Line"),
        LeftUpperArm = Drawing.new("Line"),
        LeftLowerArm = Drawing.new("Line"),
        LeftHand = Drawing.new("Line"),
        RightShoulder = Drawing.new("Line"),
        RightUpperArm = Drawing.new("Line"),
        RightLowerArm = Drawing.new("Line"),
        RightHand = Drawing.new("Line"),
        LeftHip = Drawing.new("Line"),
        LeftUpperLeg = Drawing.new("Line"),
        LeftLowerLeg = Drawing.new("Line"),
        LeftFoot = Drawing.new("Line"),
        RightHip = Drawing.new("Line"),
        RightUpperLeg = Drawing.new("Line"),
        RightLowerLeg = Drawing.new("Line"),
        RightFoot = Drawing.new("Line")
    }
    for _, line in pairs(skeleton) do
        line.Visible = false
        line.Color = Settings.SkeletonColor
        line.Thickness = Settings.SkeletonThickness
        line.Transparency = Settings.SkeletonTransparency
    end

    Drawings.Skeleton[player] = skeleton
    Drawings.ESP[player] = {
        Box = box,
        Tracer = tracer,
        HealthBar = healthBar,
        Info = info,
        Snapline = snapline
    }
end

local function RemoveESP(player)
    local esp = Drawings.ESP[player]
    if esp then
        for _, obj in pairs(esp.Box) do obj:Remove() end
        esp.Tracer:Remove()
        for _, obj in pairs(esp.HealthBar) do obj:Remove() end
        for _, obj in pairs(esp.Info) do obj:Remove() end
        esp.Snapline:Remove()
        Drawings.ESP[player] = nil
    end
    local highlight = Highlights[player]
    if highlight then
        highlight:Destroy()
        Highlights[player] = nil
    end
    local skeleton = Drawings.Skeleton[player]
    if skeleton then
        for _, line in pairs(skeleton) do
            line:Remove()
        end
        Drawings.Skeleton[player] = nil
    end
end

local function GetPlayerColor(player)
    if Settings.RainbowEnabled then
        if Settings.RainbowBoxes and Settings.BoxESP then return Colors.Rainbow end
        if Settings.RainbowTracers and Settings.TracerESP then return Colors.Rainbow end
        if Settings.RainbowText and (Settings.NameESP or Settings.HealthESP) then return Colors.Rainbow end
    end
    return player.Team == LocalPlayer.Team and Colors.Ally or Colors.Enemy
end
------------------------
-- PARTE 2 - Funções auxiliares e lógica de update
------------------------

local function GetBoxCorners(cf, size)
    local corners = {
        Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
        Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
        Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
        Vector3.new(-size.X/2, size.Y/2, size.Z/2),
        Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
        Vector3.new(size.X/2, -size.Y/2, size.Z/2),
        Vector3.new(size.X/2, size.Y/2, -size.Z/2),
        Vector3.new(size.X/2, size.Y/2, size.Z/2)
    }
    for i, corner in ipairs(corners) do
        corners[i] = cf:PointToWorldSpace(corner)
    end
    return corners
end

local function GetTracerOrigin()
    local origin = Settings.TracerOrigin
    if origin == "Bottom" then
        return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    elseif origin == "Top" then
        return Vector2.new(Camera.ViewportSize.X/2, 0)
    elseif origin == "Mouse" then
        return UserInputService:GetMouseLocation()
    else
        return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
end

local function UpdateESP(player)
    if not Settings.Enabled then return end
    local esp = Drawings.ESP[player]
    if not esp then return end
    local character = player.Character
    if not character then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        local skeleton = Drawings.Skeleton[player]
        if skeleton then for _, line in pairs(skeleton) do line.Visible = false end end
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        local skeleton = Drawings.Skeleton[player]
        if skeleton then for _, line in pairs(skeleton) do line.Visible = false end end
        return
    end

    local _, isOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
    if not isOnScreen then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        local skeleton = Drawings.Skeleton[player]
        if skeleton then for _, line in pairs(skeleton) do line.Visible = false end end
        return
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        local skeleton = Drawings.Skeleton[player]
        if skeleton then for _, line in pairs(skeleton) do line.Visible = false end end
        return
    end

    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    if not onScreen or distance > Settings.MaxDistance then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    if Settings.TeamCheck and player.Team == LocalPlayer.Team and not Settings.ShowTeam then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        esp.Tracer.Visible = false
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
        for _, obj in pairs(esp.Info) do obj.Visible = false end
        esp.Snapline.Visible = false
        return
    end

    local color = GetPlayerColor(player)
    local size = character:GetExtentsSize()
    local cf = rootPart.CFrame

    local top, top_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, size.Y/2, 0).Position)
    local bottom, bottom_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, -size.Y/2, 0).Position)
    if not top_onscreen or not bottom_onscreen then
        for _, obj in pairs(esp.Box) do obj.Visible = false end
        return
    end

    local screenSize = bottom.Y - top.Y
    local boxWidth = screenSize * 0.65
    local boxPosition = Vector2.new(top.X - boxWidth/2, top.Y)
    local boxSize = Vector2.new(boxWidth, screenSize)

    -- Box ESP
    for _, obj in pairs(esp.Box) do obj.Visible = false end
    if Settings.BoxESP then
        if Settings.BoxStyle == "ThreeD" then
            local front = {
                TL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position),
                TR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position),
                BL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position),
                BR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position)
            }
            local back = {
                TL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position),
                TR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position),
                BL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position),
                BR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position)
            }
            if not (front.TL.Z > 0 and front.TR.Z > 0 and front.BL.Z > 0 and front.BR.Z > 0 and
                    back.TL.Z > 0 and back.TR.Z > 0 and back.BL.Z > 0 and back.BR.Z > 0) then
                for _, obj in pairs(esp.Box) do obj.Visible = false end
                return
            end
            local function toVector2(v3) return Vector2.new(v3.X, v3.Y) end
            front.TL, front.TR = toVector2(front.TL), toVector2(front.TR)
            front.BL, front.BR = toVector2(front.BL), toVector2(front.BR)
            back.TL, back.TR = toVector2(back.TL), toVector2(back.TR)
            back.BL, back.BR = toVector2(back.BL), toVector2(back.BR)
            esp.Box.TopLeft.From = front.TL
            esp.Box.TopLeft.To = front.TR
            esp.Box.TopLeft.Visible = true
            esp.Box.TopRight.From = front.TR
            esp.Box.TopRight.To = front.BR
            esp.Box.TopRight.Visible = true
            esp.Box.BottomLeft.From = front.BL
            esp.Box.BottomLeft.To = front.BR
            esp.Box.BottomLeft.Visible = true
            esp.Box.BottomRight.From = front.TL
            esp.Box.BottomRight.To = front.BL
            esp.Box.BottomRight.Visible = true
            esp.Box.Left.From = back.TL
            esp.Box.Left.To = back.TR
            esp.Box.Left.Visible = true
            esp.Box.Right.From = back.TR
            esp.Box.Right.To = back.BR
            esp.Box.Right.Visible = true
            esp.Box.Top.From = back.BL
            esp.Box.Top.To = back.BR
            esp.Box.Top.Visible = true
            esp.Box.Bottom.From = back.TL
            esp.Box.Bottom.To = back.BL
            esp.Box.Bottom.Visible = true
            local function drawConnectingLine(from, to, visible)
                local line = Drawing.new("Line")
                line.Visible = visible
                line.Color = color
                line.Thickness = Settings.BoxThickness
                line.From = from
                line.To = to
                return line
            end
            local connectors = {
                drawConnectingLine(front.TL, back.TL, true),
                drawConnectingLine(front.TR, back.TR, true),
                drawConnectingLine(front.BL, back.BL, true),
                drawConnectingLine(front.BR, back.BR, true)
            }
            task.spawn(function()
                task.wait()
                for _, line in ipairs(connectors) do
                    line:Remove()
                end
            end)
        elseif Settings.BoxStyle == "Corner" then
            local cornerSize = boxWidth * 0.2
            esp.Box.TopLeft.From = boxPosition
            esp.Box.TopLeft.To = boxPosition + Vector2.new(cornerSize, 0)
            esp.Box.TopLeft.Visible = true
            esp.Box.TopRight.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.TopRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, 0)
            esp.Box.TopRight.Visible = true
            esp.Box.BottomLeft.From = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.BottomLeft.To = boxPosition + Vector2.new(cornerSize, boxSize.Y)
            esp.Box.BottomLeft.Visible = true
            esp.Box.BottomRight.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.BottomRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
            esp.Box.BottomRight.Visible = true
            esp.Box.Left.From = boxPosition
            esp.Box.Left.To = boxPosition + Vector2.new(0, cornerSize)
            esp.Box.Left.Visible = true
            esp.Box.Right.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.Right.To = boxPosition + Vector2.new(boxSize.X, cornerSize)
            esp.Box.Right.Visible = true
            esp.Box.Top.From = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.Top.To = boxPosition + Vector2.new(0, boxSize.Y - cornerSize)
            esp.Box.Top.Visible = true
            esp.Box.Bottom.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.Bottom.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y - cornerSize)
            esp.Box.Bottom.Visible = true
        else -- Full box
            esp.Box.Left.From = boxPosition
            esp.Box.Left.To = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.Left.Visible = true
            esp.Box.Right.From = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.Right.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.Right.Visible = true
            esp.Box.Top.From = boxPosition
            esp.Box.Top.To = boxPosition + Vector2.new(boxSize.X, 0)
            esp.Box.Top.Visible = true
            esp.Box.Bottom.From = boxPosition + Vector2.new(0, boxSize.Y)
            esp.Box.Bottom.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
            esp.Box.Bottom.Visible = true
            esp.Box.TopLeft.Visible = false
            esp.Box.TopRight.Visible = false
            esp.Box.BottomLeft.Visible = false
            esp.Box.BottomRight.Visible = false
        end
        for _, obj in pairs(esp.Box) do
            if obj.Visible then
                obj.Color = color
                obj.Thickness = Settings.BoxThickness
            end
        end
    end

    -- Tracer ESP
    if Settings.TracerESP then
        esp.Tracer.From = GetTracerOrigin()
        esp.Tracer.To = Vector2.new(pos.X, pos.Y)
        esp.Tracer.Color = color
        esp.Tracer.Visible = true
    else
        esp.Tracer.Visible = false
    end

    -- Health ESP
    if Settings.HealthESP then
        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = health/maxHealth
        local barHeight = screenSize * 0.8
        local barWidth = 4
        local barPos = Vector2.new(
            boxPosition.X - barWidth - 2,
            boxPosition.Y + (screenSize - barHeight)/2
        )
        esp.HealthBar.Outline.Size = Vector2.new(barWidth, barHeight)
        esp.HealthBar.Outline.Position = barPos
        esp.HealthBar.Outline.Visible = true
        esp.HealthBar.Fill.Size = Vector2.new(barWidth - 2, barHeight * healthPercent)
        esp.HealthBar.Fill.Position = Vector2.new(barPos.X + 1, barPos.Y + barHeight * (1-healthPercent))
        esp.HealthBar.Fill.Visible = true
        esp.HealthBar.Fill.Color = Colors.Health
        esp.HealthBar.Text.Text = string.format("%d%s", math.floor(health), Settings.HealthTextSuffix)
        esp.HealthBar.Text.Position = Vector2.new(barPos.X + barWidth/2, barPos.Y + barHeight/2)
        esp.HealthBar.Text.Visible = true
    else
        for _, obj in pairs(esp.HealthBar) do obj.Visible = false end
    end

    -- Name ESP
    if Settings.NameESP then
        esp.Info.Name.Text = Settings.NameMode == "DisplayName" and player.DisplayName or player.Name
        esp.Info.Name.Position = Vector2.new(boxPosition.X + boxSize.X/2, boxPosition.Y - 16)
        esp.Info.Name.Visible = true
        esp.Info.Name.Color = color
    else
        esp.Info.Name.Visible = false
    end

    -- Distance ESP
    if Settings.ShowDistance then
        esp.Info.Distance.Text = string.format("%.0f %s", distance, Settings.DistanceUnit)
        esp.Info.Distance.Position = Vector2.new(boxPosition.X + boxSize.X/2, boxPosition.Y + boxSize.Y + 2)
        esp.Info.Distance.Visible = true
        esp.Info.Distance.Color = Colors.Distance
    else
        esp.Info.Distance.Visible = false
    end

    -- Snapline ESP
    if Settings.Snaplines then
        esp.Snapline.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        esp.Snapline.To = Vector2.new(pos.X, pos.Y)
        esp.Snapline.Color = color
        esp.Snapline.Visible = true
    else
        esp.Snapline.Visible = false
    end

    -- Chams (Highlight)
    local highlight = Highlights[player]
    if highlight then
        highlight.Parent = character
        highlight.Enabled = Settings.ChamsEnabled
        highlight.FillColor = Settings.ChamsFillColor
        highlight.OutlineColor = Settings.ChamsOutlineColor
        highlight.FillTransparency = Settings.ChamsTransparency
        highlight.OutlineTransparency = Settings.ChamsOutlineTransparency
    end

    -- Skeleton ESP
end
--------------------------------------------------
-- PARTE 3 - Skeleton, loop, eventos, finalização
--------------------------------------------------
    -- Skeleton ESP
    local skeleton = Drawings.Skeleton[player]
    if skeleton and Settings.SkeletonESP then
        local function getPos(partName)
            local part = character:FindFirstChild(partName)
            if not part then return nil end
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            return onScreen and Vector2.new(pos.X, pos.Y) or nil
        end
        local joints = {
            -- Head/Spine
            {"Head", "Neck"},
            {"Neck", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            -- Left Arm
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
            -- Right Arm
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
            -- Left Leg
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
            -- Right Leg
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
        }
        local visible = false
        for i, pair in ipairs(joints) do
            local fromPos = getPos(pair[1])
            local toPos = getPos(pair[2])
            local line = skeleton[pair[1]..pair[2]] or skeleton[i]
            if line and fromPos and toPos then
                line.From = fromPos
                line.To = toPos
                line.Color = Settings.SkeletonColor
                line.Thickness = Settings.SkeletonThickness
                line.Transparency = Settings.SkeletonTransparency
                line.Visible = true
                visible = true
            elseif line then
                line.Visible = false
            end
        end
        -- Hide unused lines
        if not visible then
            for _, line in pairs(skeleton) do line.Visible = false end
        end
    elseif skeleton then
        for _, line in pairs(skeleton) do line.Visible = false end
    end
end

--------------------------------------------------
-- Loop principal ESP
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not Drawings.ESP[player] then
                CreateESP(player)
            end
            UpdateESP(player)
        end
    end
    -- Remover ESP de jogadores que saíram
    for player, _ in pairs(Drawings.ESP) do
        if not Players:FindFirstChild(player.Name) then
            RemoveESP(player)
        end
    end
end)

--------------------------------------------------
-- Eventos de Players para criar/remover ESP
--------------------------------------------------
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

--------------------------------------------------
-- Rayfield: Salva e carrega configuração
--------------------------------------------------
Rayfield:LoadConfiguration()

--------------------------------------------------
-- FIM: Script ESP Avançado Rayfield
--------------------------------------------------

-- Otimizado para Roblox {lua cheat} ultra avançado, padrão profissional
-- Se quiser adicionar mais features ou dúvidas, só pedir!
