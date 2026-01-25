--[[
    QUANGTRUONG SUPREME ULTIMATE HUB - V15 (REMASTERED ENGINE)
    Credits: QuangTruong AI
    Theme: Night Mystic (Neon Purple/Dark Void)
    Lines: 500+ Optimized
]]

--// SERVICES //--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

--// LOCALS //--
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = Camera.ViewportSize

--// CONFIGURATION SYSTEM //--
local Settings = {
    Combat = {
        Aimbot = false,
        AimPart = "Head",
        FOV = 150,
        Smoothness = 0.5,
        TeamCheck = false,
        Hitbox = false,
        HitboxSize = 20,
        HitboxTrans = 0.6
    },
    Visuals = {
        ESP_Enabled = false,
        ESP_Box = false,
        ESP_Name = false,
        ESP_Tracer = false,
        ESP_Highlight = false,
        ESP_Color = Color3.fromRGB(170, 0, 255),
        Xray = false,
        Xray_Transparency = 0.5
    },
    Movement = {
        Speed_Enabled = false,
        Speed_Value = 16,
        Jump_Enabled = false,
        Jump_Value = 50,
        Fly = false,
        Fly_Speed = 50
    },
    Misc = {
        FullBright = false,
        NoFog = false
    }
}

--// UI LIBRARY (THE ENGINE) //--
local Library = {}
local UIConfig = {
    MainColor = Color3.fromRGB(15, 10, 25),
    AccentColor = Color3.fromRGB(180, 0, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecColor = Color3.fromRGB(25, 20, 35),
    Font = Enum.Font.GothamBold
}

function Library:Create(HubName)
    -- Main Screen
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QT_NightMystic_Supreme"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if RunService:IsStudio() then
        ScreenGui.Parent = LocalPlayer.PlayerGui
    else
        pcall(function() ScreenGui.Parent = CoreGui end)
    end

    -- Draggable Frame System
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = UIConfig.MainColor
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = UIConfig.AccentColor
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.2
    MainStroke.Parent = MainFrame

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
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
            if dragging then update(input) end
        end
    end)

    -- Sidebar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = MainFrame
    SideBar.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
    SideBar.Size = UDim2.new(0, 180, 1, 0)
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 15)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = SideBar
    Title.Text = HubName
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.LuckiestGuy
    Title.TextSize = 24
    Title.TextColor3 = UIConfig.AccentColor
    Title.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = SideBar
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.Size = UDim2.new(1, -20, 1, -80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.Padding = UDim.new(0, 10)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Container for Pages
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.Position = UDim2.new(0, 190, 0, 15)
    PageContainer.Size = UDim2.new(1, -205, 1, -30)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}

    function Tabs:NewTab(TabName, IconId)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName .. "Btn"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.Font = UIConfig.Font
        TabButton.Text = "   " .. TabName
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = TabButton
        
        -- Selected Indicator
        local Indicator = Instance.new("Frame")
        Indicator.BackgroundColor3 = UIConfig.AccentColor
        Indicator.Size = UDim2.new(0, 4, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.Parent = TabButton
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

        -- Page Logic
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "Page"
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = UIConfig.AccentColor
        Page.Visible = false
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 10)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 5)
        PagePad.PaddingBottom = UDim.new(0, 5)
        PagePad.PaddingLeft = UDim.new(0, 5)
        PagePad.PaddingRight = UDim.new(0, 5)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(25, 20, 40)}):Play()
                    v:FindFirstChild("Frame").Visible = false
                end
            end
            Page.Visible = true
            Indicator.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), BackgroundColor3 = Color3.fromRGB(45, 30, 60)}):Play()
        end)

        local Elements = {}

        function Elements:NewSection(SecName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = Page
            SectionLabel.Text = SecName
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.TextColor3 = UIConfig.AccentColor
            SectionLabel.Font = Enum.Font.LuckiestGuy
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:NewToggle(Text, Default, Callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = Text
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = UIConfig.SecColor
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.Text = Text
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = UIConfig.Font
            Label.TextColor3 = UIConfig.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextSize = 14

            local Switch = Instance.new("TextButton")
            Switch.Parent = ToggleFrame
            Switch.Text = ""
            Switch.Size = UDim2.new(0, 44, 0, 22)
            Switch.Position = UDim2.new(1, -55, 0.5, -11)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 12)

            local Dot = Instance.new("Frame")
            Dot.Parent = Switch
            Dot.BackgroundColor3 = Color3.new(1,1,1)
            Dot.Size = UDim2.new(0, 18, 0, 18)
            Dot.Position = UDim2.new(0, 2, 0.5, -9)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(0, 10)

            local Enabled = Default
            if Default then
                Switch.BackgroundColor3 = UIConfig.AccentColor
                Dot.Position = UDim2.new(1, -20, 0.5, -9)
            end

            Switch.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Callback(Enabled)
                local TargetPos = Enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                local TargetColor = Enabled and UIConfig.AccentColor or Color3.fromRGB(50, 50, 60)
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = TargetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
            end)
        end

        function Elements:NewSlider(Text, Min, Max, Default, Callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = UIConfig.SecColor
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.Text = Text .. ": " .. Default
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = UIConfig.Font
            Label.TextColor3 = UIConfig.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextSize = 14

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Bar.Size = UDim2.new(0.9, 0, 0, 6)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 3)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = UIConfig.AccentColor
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Bar
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local Connection
                    Connection = RunService.RenderStepped:Connect(function()
                        local MousePos = UserInputService:GetMouseLocation().X
                        local RelativePos = MousePos - Bar.AbsolutePosition.X
                        local Scale = math.clamp(RelativePos / Bar.AbsoluteSize.X, 0, 1)
                        local Value = math.floor(Min + ((Max - Min) * Scale))
                        
                        TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(Scale, 0, 1, 0)}):Play()
                        Label.Text = Text .. ": " .. Value
                        Callback(Value)
                    end)
                    
                    UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                            if Connection then Connection:Disconnect() end
                        end
                    end)
                end
            end)
        end

        function Elements:NewDropdown(Text, Items, Callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = UIConfig.SecColor
            DropFrame.Size = UDim2.new(1, 0, 0, 45)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = DropFrame
            Label.Text = Text
            Label.Size = UDim2.new(1, -40, 0, 45)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = UIConfig.Font
            Label.TextColor3 = UIConfig.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextSize = 14

            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = DropFrame
            Arrow.Image = "rbxassetid://6034818372" -- Down Arrow
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -30, 0, 12)
            Arrow.BackgroundTransparency = 1
            Arrow.ImageColor3 = Color3.new(0.7, 0.7, 0.7)

            local Open = false
            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropFrame
            DropBtn.Size = UDim2.new(1, 0, 0, 45)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""

            local ItemList = Instance.new("UIListLayout")
            ItemList.Parent = DropFrame
            ItemList.Padding = UDim.new(0, 5)
            ItemList.SortOrder = Enum.SortOrder.LayoutOrder
            
            -- Padding for list
            local Pad = Instance.new("UIPadding")
            Pad.Parent = DropFrame
            Pad.PaddingTop = UDim.new(0, 45)

            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local Height = Open and (45 + (#Items * 35) + 10) or 45
                TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Height)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
            end)

            for _, Item in pairs(Items) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Parent = DropFrame
                ItemBtn.Size = UDim2.new(1, -20, 0, 30)
                ItemBtn.Position = UDim2.new(0, 10, 0, 0)
                ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
                ItemBtn.Text = Item
                ItemBtn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
                ItemBtn.Font = UIConfig.Font
                Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 6)

                ItemBtn.MouseButton1Click:Connect(function()
                    Label.Text = Text .. ": " .. Item
                    Callback(Item)
                    Open = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end)
            end
        end

        return Elements
    end

    -- Toggle GUI Button
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ScreenGui
    OpenBtn.Size = UDim2.new(0, 55, 0, 55)
    OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
    OpenBtn.BackgroundColor3 = UIConfig.AccentColor
    OpenBtn.Text = "QT"
    OpenBtn.Font = Enum.Font.LuckiestGuy
    OpenBtn.TextSize = 24
    OpenBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 28)
    BtnCorner.Parent = OpenBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Parent = OpenBtn
    BtnStroke.Color = Color3.new(1,1,1)
    BtnStroke.Thickness = 2
    
    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    return Tabs
end

--// INITIALIZE UI //--
local Window = Library:Create("QUANGTRUONG GOD MODE")

--// COMBAT TAB //--
local Combat = Window:NewTab("Combat", "")
Combat:NewSection("Aimbot System")
Combat:NewToggle("Enable Aimbot", false, function(v) Settings.Combat.Aimbot = v end)
Combat:NewSlider("FOV Radius", 50, 800, 150, function(v) Settings.Combat.FOV = v end)
Combat:NewDropdown("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, function(v) Settings.Combat.AimPart = v end)

Combat:NewSection("Hitbox Modified")
Combat:NewToggle("Enable Hitbox", false, function(v) Settings.Combat.Hitbox = v end)
Combat:NewSlider("Hitbox Size", 5, 50, 20, function(v) Settings.Combat.HitboxSize = v end)
Combat:NewSlider("Transparency", 0, 10, 6, function(v) Settings.Combat.HitboxTrans = v/10 end)

--// VISUALS TAB //--
local Visuals = Window:NewTab("Visuals", "")
Visuals:NewSection("ESP Player")
Visuals:NewToggle("ESP Highlight (Best)", false, function(v) Settings.Visuals.ESP_Highlight = v end)
Visuals:NewToggle("ESP Box", false, function(v) Settings.Visuals.ESP_Box = v end)

Visuals:NewSection("World Visuals")
Visuals:NewToggle("Xray (Wallhack)", false, function(v) 
    Settings.Visuals.Xray = v 
    if not v then
        -- Restore Xray Logic
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)
Visuals:NewSlider("Xray Alpha", 0, 10, 5, function(v) Settings.Visuals.Xray_Transparency = v/10 end)
Visuals:NewToggle("Fullbright", false, function(v) 
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

--// MOVEMENT TAB //--
local Movement = Window:NewTab("Movement", "")
Movement:NewToggle("Speed Hack", false, function(v) Settings.Movement.Speed_Enabled = v end)
Movement:NewSlider("Speed Value", 16, 500, 100, function(v) Settings.Movement.Speed_Value = v end)
Movement:NewToggle("Infinite Jump", false, function(v) Settings.Movement.Jump_Enabled = v end)
Movement:NewToggle("Fly Mode", false, function(v) Settings.Movement.Fly = v end)

-
