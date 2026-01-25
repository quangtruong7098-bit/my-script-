local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    Aimbot = {
        Enabled = false,
        Part = "Head",
        Radius = 150,
        Smoothness = 0.1,
        ShowFOV = false
    },
    Visuals = {
        ESP = false,
        ESP_Color = Color3.fromRGB(255, 0, 255),
        Hitbox = false,
        HitboxSize = 25,
        HitboxTrans = 0.7,
        Xray = false,
        XrayVal = 0.5
    },
    Movement = {
        Speed = false,
        SpeedVal = 16,
        Fly = false,
        FlySpeed = 100,
        InfJump = false
    },
    Misc = {
        FullBright = false
    }
}

local QT_Library = {}
local UI = {
    MainColor = Color3.fromRGB(12, 12, 18),
    SecColor = Color3.fromRGB(20, 20, 28),
    Accent = Color3.fromRGB(200, 0, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(60, 60, 80)
}

function QT_Library:ValidateGui()
    local gui = CoreGui:FindFirstChild("QT_Titan_Engine")
    if gui then gui:Destroy() end
    
    local newGui = Instance.new("ScreenGui")
    newGui.Name = "QT_Titan_Engine"
    newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        newGui.Parent = CoreGui
    end)
    if not newGui.Parent then
        newGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return newGui
end

local ScreenGui = QT_Library:ValidateGui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = UI.MainColor
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
MainFrame.Size = UDim2.new(0, 650, 0, 400)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = UI.Accent
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6015667343"
Glow.ImageColor3 = UI.Accent
Glow.Position = UDim2.new(0, -25, 0, -25)
Glow.Size = UDim2.new(1, 50, 1, 50)
Glow.ZIndex = 0
Glow.Parent = MainFrame

local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = UI.SecColor
SideBar.Size = UDim2.new(0, 170, 1, 0)
SideBar.BorderSizePixel = 0
local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 16)
SideCorner.Parent = SideBar
local SideFix = Instance.new("Frame")
SideFix.Parent = SideBar
SideFix.BackgroundColor3 = UI.SecColor
SideFix.BorderSizePixel = 0
SideFix.Position = UDim2.new(1, -10, 0, 0)
SideFix.Size = UDim2.new(0, 10, 1, 0)

local AppTitle = Instance.new("TextLabel")
AppTitle.Parent = SideBar
AppTitle.BackgroundTransparency = 1
AppTitle.Position = UDim2.new(0, 15, 0, 20)
AppTitle.Size = UDim2.new(1, -30, 0, 40)
AppTitle.Font = Enum.Font.LuckiestGuy
AppTitle.Text = "TITAN HUB"
AppTitle.TextColor3 = UI.Accent
AppTitle.TextSize = 28
AppTitle.TextXAlignment = Enum.TextXAlignment.Left

local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Parent = SideBar
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.new(0, 0, 0, 80)
TabHolder.Size = UDim2.new(1, 0, 1, -90)
TabHolder.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabHolder
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 180, 0, 20)
Container.Size = UDim2.new(1, -190, 1, -40)

local Tabs = {}

function QT_Library:AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabHolder
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(100, 100, 100)
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left

    local Indicator = Instance.new("Frame")
    Indicator.Parent = TabButton
    Indicator.BackgroundColor3 = UI.Accent
    Indicator.Position = UDim2.new(0, 0, 0.15, 0)
    Indicator.Size = UDim2.new(0, 4, 0.7, 0)
    Indicator.Visible = false
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(0, 4)
    IndCorner.Parent = Indicator

    local Page = Instance.new("ScrollingFrame")
    Page.Parent = Container
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = UI.Accent
    Page.Visible = false
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 10)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(TabHolder:GetChildren()) do
            if t:IsA("TextButton") then
                TweenService:Create(t, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                t.Frame.Visible = false
            end
        end
        for _, p in pairs(Container:GetChildren()) do
            p.Visible = false
        end
        TweenService:Create(TabButton, TweenInfo.new(0.3), {TextColor3 = UI.Text}):Play()
        Indicator.Visible = true
        Page.Visible = true
    end)
    
    local Elements = {}
    
    function Elements:AddSection(text)
        local SecLabel = Instance.new("TextLabel")
        SecLabel.Parent = Page
        SecLabel.BackgroundTransparency = 1
        SecLabel.Size = UDim2.new(1, 0, 0, 30)
        SecLabel.Font = Enum.Font.GothamBlack
        SecLabel.Text = text
        SecLabel.TextColor3 = UI.Accent
        SecLabel.TextSize = 16
        SecLabel.TextXAlignment = Enum.TextXAlignment.Left
    end

    function Elements:AddToggle(text, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = Page
        ToggleFrame.BackgroundColor3 = UI.SecColor
        ToggleFrame.Size = UDim2.new(1, -5, 0, 45)
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 8)
        TCorner.Parent = ToggleFrame
        local TStroke = Instance.new("UIStroke")
        TStroke.Color = UI.Stroke
        TStroke.Thickness = 1
        TStroke.Parent = ToggleFrame
        
        local TText = Instance.new("TextLabel")
        TText.Parent = ToggleFrame
        TText.BackgroundTransparency = 1
        TText.Position = UDim2.new(0, 15, 0, 0)
        TText.Size = UDim2.new(0.7, 0, 1, 0)
        TText.Font = Enum.Font.GothamSemibold
        TText.Text = text
        TText.TextColor3 = UI.Text
        TText.TextSize = 14
        TText.TextXAlignment = Enum.TextXAlignment.Left
        
        local Switch = Instance.new("TextButton")
        Switch.Parent = ToggleFrame
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Switch.Position = UDim2.new(1, -55, 0.5, -12)
        Switch.Size = UDim2.new(0, 44, 0, 24)
        Switch.Text = ""
        local SCorner = Instance.new("UICorner")
        SCorner.CornerRadius = UDim.new(0, 12)
        SCorner.Parent = Switch
        
        local Dot = Instance.new("Frame")
        Dot.Parent = Switch
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.Position = UDim2.new(0, 2, 0.5, -10)
        Dot.Size = UDim2.new(0, 20, 0, 20)
        local DCorner = Instance.new("UICorner")
        DCorner.CornerRadius = UDim.new(0, 10)
        DCorner.Parent = Dot
        
        local Enabled = false
        Switch.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            local TargetPos = Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local TargetCol = Enabled and UI.Accent or Color3.fromRGB(40, 40, 50)
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = TargetPos}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = TargetCol}):Play()
            callback(Enabled)
        end)
    end
    
    function Elements:AddSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = Page
        SliderFrame.BackgroundColor3 = UI.SecColor
        SliderFrame.Size = UDim2.new(1, -5, 0, 60)
        local SCorner = Instance.new("UICorner")
        SCorner.CornerRadius = UDim.new(0, 8)
        SCorner.Parent = SliderFrame
        local SStroke = Instance.new("UIStroke")
        SStroke.Color = UI.Stroke
        SStroke.Thickness = 1
        SStroke.Parent = SliderFrame
        
        local SText = Instance.new("TextLabel")
        SText.Parent = SliderFrame
        SText.BackgroundTransparency = 1
        SText.Position = UDim2.new(0, 15, 0, 5)
        SText.Size = UDim2.new(1, -30, 0, 25)
        SText.Font = Enum.Font.GothamSemibold
        SText.Text = text .. ": " .. default
        SText.TextColor3 = UI.Text
        SText.TextSize = 14
        SText.TextXAlignment = Enum.TextXAlignment.Left
        
        local Bar = Instance.new("Frame")
        Bar.Parent = SliderFrame
        Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Bar.Position = UDim2.new(0, 15, 0, 40)
        Bar.Size = UDim2.new(1, -30, 0, 6)
        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 3)
        BCorner.Parent = Bar
        
        local Fill = Instance.new("Frame")
        Fill.Parent = Bar
        Fill.BackgroundColor3 = UI.Accent
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        local FCorner = Instance.new("UICorner")
        FCorner.CornerRadius = UDim.new(0, 3)
        FCorner.Parent = Fill
        
        local Trigger = Instance.new("TextButton")
        Trigger.Parent = Bar
        Trigger.BackgroundTransparency = 1
        Trigger.Size = UDim2.new(1, 0, 1, 0)
        Trigger.Text = ""
        
        Trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    local mouseX = UserInputService:GetMouseLocation().X
                    local relative = mouseX - Bar.AbsolutePosition.X
                    local scale = math.clamp(relative / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (scale * (max - min)))
                    Fill.Size = UDim2.new(scale, 0, 1, 0)
                    SText.Text = text .. ": " .. value
                    callback(value)
                end)
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end)
    end

    return Elements
end

local CombatTab = QT_Library:AddTab("Combat")
CombatTab:AddSection("Aimbot")
CombatTab:AddToggle("Enable Aimbot", function(v) Config.Aimbot.Enabled = v end)
CombatTab:AddSlider("FOV Radius", 50, 500, 150, function(v) Config.Aimbot.Radius = v end)
CombatTab:AddSlider("Smoothing", 1, 10, 5, function(v) Config.Aimbot.Smoothness = v/10 end)

CombatTab:AddSection("Hitbox")
CombatTab:AddToggle("Hitbox Expander", function(v) Config.Visuals.Hitbox = v end)
CombatTab:AddSlider("Hitbox Size", 5, 50, 20, function(v) Config.Visuals.HitboxSize = v end)
CombatTab:AddSlider("Transparency", 0, 10, 7, function(v) Config.Visuals.HitboxTrans = v/10 end)

local VisualTab = QT_Library:AddTab("Visuals")
VisualTab:AddSection("ESP System")
VisualTab:AddToggle("Player ESP (Highlight)", function(v) Config.Visuals.ESP = v end)
VisualTab:AddToggle("Fullbright Mode", function(v) 
    Config.Misc.FullBright = v 
    if not v then
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end
end)

VisualTab:AddSection("World")
VisualTab:AddToggle("Xray (Wallhack)", function(v) 
    Config.Visuals.Xray = v 
    if not v then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)
VisualTab:AddSlider("Xray Opacity", 0, 10, 5, function(v) Config.Visuals.XrayVal = v/10 end)

local MoveTab = QT_Library:AddTab("Movement")
MoveTab:AddSection("Character")
MoveTab:AddToggle("Speed Hack", function(v) Config.Movement.Speed = v end)
MoveTab:AddSlider("Speed Value", 16, 300, 50, function(v) Config.Movement.SpeedVal = v end)
MoveTab:AddToggle("Infinite Jump", function(v) Config.Movement.InfJump = v end)
MoveTab:AddToggle("Fly Mode", function(v) Config.Movement.Fly = v end)

local function GetTarget()
    local Target = nil
    local Dist = Config.Aimbot.Radius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.Aimbot.Part) then
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character[Config.Aimbot.Part].Position)
            if OnScreen then
                local Mag = (Vector2.new(ScreenPos.X, ScreenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if Mag < Dist then
                    Dist = Mag
                    Target = v
                end
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local Target = GetTarget()
        if Target and Target.Character then
            local Current = Camera.CFrame
            local Goal = CFrame.new(Current.Position, Target.Character[Config.Aimbot.Part].Position)
            Camera.CFrame = Current:Lerp(Goal, Config.Aimbot.Smoothness)
        end
    end

    if Config.Misc.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end

    if Config.Visuals.Xray then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                if not part.Parent:FindFirstChild("Humanoid") then
                    part.LocalTransparencyModifier = Config.Visuals.XrayVal
                end
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Visuals.Hitbox and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.Visuals.HitboxSize, Config.Visuals.HitboxSize, Config.Visuals.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = Config.Visuals.HitboxTrans
                p.Character.HumanoidRootPart.CanCollide = false
            end
            
            local hl = p.Character:FindFirstChild("QT_ESP_Highlight")
            if Config.Visuals.ESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "QT_ESP_Highlight"
                    hl.Parent = p.Character
                    hl.FillColor = Config.Visuals.ESP_Color
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.5
                end
            elseif hl then
                hl:Destroy()
            end
        end
    end

    if Config.Movement.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.SpeedVal
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.BackgroundColor3 = UI.Accent
ToggleBtn.Text = "QT"
ToggleBtn.Font = Enum.Font.LuckiestGuy
ToggleBtn.TextSize = 20
ToggleBtn.TextColor3 = Color3.new(1,1,1)
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 25)
BtnCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)
