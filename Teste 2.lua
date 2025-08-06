-- Rayfield ESP Avançado by teste333222333-commits
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

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

--------------------------------------------------
-- (continua na próxima parte!)
--------------------------------------------------
