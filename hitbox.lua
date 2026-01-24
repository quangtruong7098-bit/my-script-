local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Combat = {
        Hitbox = false,
        HitboxSize = 15,
        HitboxPart = "Head",
        HitboxTransparency = 0.7,
        HitboxColor = Color3.fromRGB(0, 100, 255),
        Aimbot = false,
        AimPart = "Head",
        AimSmooth = false,
        AimRadius = 200
    },
    Visuals = {
        ESP_Box = false,
        ESP_Name = false,
        ESP_Line = false,
        ESP_Color = Color3.fromRGB(255, 0, 0),
        FullBright = false,
        Crosshair = false
    },
    Movement = {
        Fly = false,
        FlySpeed = 200,
        WalkSpeed = 16,
        JumpPower = 50,
        InfiniteJump = false,
        Noclip = false,
        SpeedEnabled = false,
        JumpEnabled = false
    },
    Misc = {
        AntiAFK = true,
        FPSBoost = false
    }
}

local QT_Lib = {}

function QT_Lib:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QTHub_Titan"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 60, 60)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Text = name
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -140, 1, -50)
    ContentContainer.Position = UDim2.new(0, 135, 0, 45)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local MobileButton = Instance.new("TextButton")
    MobileButton.Size = UDim2.new(0, 50, 0, 50)
    MobileButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    MobileButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileButton.Text = "QT"
    MobileButton.Font = Enum.Font.LuckiestGuy
    MobileButton.TextSize = 20
    MobileButton.Parent = ScreenGui
    Instance.new("UICorner", MobileButton).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", MobileButton).Thickness = 2
    
    MobileButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Window = {}

    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "_Frame"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 2
        TabFrame.Visible = false
        TabFrame.Parent = ContentContainer

        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 5)
        ContentList.Parent = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
            end
            TabFrame.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local Tab = {}

        function Tab:CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleFrame.Parent = TabFrame
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = "  " .. text
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.Font = Enum.Font.GothamSemibold
            ToggleBtn.TextSize = 14
            ToggleBtn.Parent = ToggleFrame

            local Status = Instance.new("Frame")
            Status.Size = UDim2.new(0, 20, 0, 20)
            Status.Position = UDim2.new(1, -30, 0.5, -10)
            Status.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            Status.Parent = ToggleFrame
            Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

            local enabled = default
            ToggleBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                Status.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                callback(enabled)
            end)
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderFrame.Parent = TabFrame
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = text .. ": " .. default
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -20, 0, 10)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Bar.Parent = SliderFrame
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            Fill.Parent = Bar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = Bar

            local dragging = false
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local SizeScale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local Value = math.floor(min + ((max - min) * SizeScale))
                    Fill.Size = UDim2.new(SizeScale, 0, 1, 0)
                    Label.Text = text .. ": " .. Value
                    callback(Value)
                end
            end)
        end
        
        function Tab:CreateDropdown(text, list, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropFrame.Parent = TabFrame
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
            
            local MainBtn = Instance.new("TextButton")
            MainBtn.Size = UDim2.new(1, 0, 1, 0)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. ": " .. list[1]
            MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left
            MainBtn.TextSize = 14
            MainBtn.Parent = DropFrame
            
            local current = 1
            MainBtn.MouseButton1Click:Connect(function()
                current = current + 1
                if current > #list then current = 1 end
                MainBtn.Text = "  " .. text .. ": " .. list[current]
                callback(list[current])
            end)
        end

        return Tab
    end
    return Window
end

local Win = QT_Lib:CreateWindow("QUANGTRUONG TITAN V.MAX")

local CombatTab = Win:CreateTab("COMBAT")
CombatTab:CreateToggle("Enable Hitbox", false, function(v) Settings.Combat.Hitbox = v end)
CombatTab:CreateDropdown("Hitbox Part", {"Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, function(v) Settings.Combat.HitboxPart = v end)
CombatTab:CreateSlider("Hitbox Size", 1, 200, 15, function(v) Settings.Combat.HitboxSize = v end)
CombatTab:CreateSlider("Transparency", 0, 10, 7, function(v) Settings.Combat.HitboxTransparency = v/10 end)
CombatTab:CreateToggle("Aimbot (Simple)", false, function(v) Settings.Combat.Aimbot = v end)

local VisualTab = Win:CreateTab("VISUALS")
VisualTab:CreateToggle("ESP Box", false, function(v) Settings.Visuals.ESP_Box = v end)
VisualTab:CreateToggle("ESP Name", false, function(v) Settings.Visuals.ESP_Name = v end)
VisualTab:CreateToggle("ESP Lines (Tracers)", false, function(v) Settings.Visuals.ESP_Line = v end)
VisualTab:CreateToggle("Fullbright (Night Vision)", false, function(v) Settings.Visuals.FullBright = v end)
VisualTab:CreateToggle("Crosshair", false, function(v) Settings.Visuals.Crosshair = v end)

local MoveTab = Win:CreateTab("MOVEMENT")
MoveTab:CreateToggle("Enable Fly Mode", false, function(v) Settings.Movement.Fly = v end)
MoveTab:CreateSlider("Fly Speed", 10, 500, 200, function(v) Settings.Movement.FlySpeed = v end)
MoveTab:CreateToggle("Enable WalkSpeed", false, function(v) Settings.Movement.SpeedEnabled = v end)
MoveTab:CreateSlider("WalkSpeed Value", 16, 300, 16, function(v) Settings.Movement.WalkSpeed = v end)
MoveTab:CreateToggle("Enable JumpPower", false, function(v) Settings.Movement.JumpEnabled = v end)
MoveTab:CreateSlider("JumpPower Value", 50, 500, 50, function(v) Settings.Movement.JumpPower = v end)
MoveTab:CreateToggle("Infinite Jump", false, function(v) Settings.Movement.InfiniteJump = v end)
MoveTab:CreateToggle("Noclip (Wall Hack)", false, function(v) Settings.Movement.Noclip = v end)

local PlayerTab = Win:CreateTab("PLAYER")
PlayerTab:CreateToggle("Anti AFK", true, function(v) Settings.Misc.AntiAFK = v end)
PlayerTab:CreateToggle("FPS Boost", false, function(v) Settings.Misc.FPSBoost = v end)

UserInputService.JumpRequest:Connect(function()
    if Settings.Movement.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local function GetTargetPart(Char)
    if not Char then return nil end
    if Settings.Combat.HitboxPart == "Torso" then
        return Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
    elseif Settings.Combat.HitboxPart == "Head" then
        return Char:FindFirstChild("Head")
    else
        for _, v in pairs(Char:GetChildren()) do
            if string.find(v.Name, Settings.Combat.HitboxPart) then return v end
            if string.find(v.Name, "Arm") and string.find(Settings.Combat.HitboxPart, "Arm") then return v end
            if string.find(v.Name, "Leg") and string.find(Settings.Combat.HitboxPart, "Leg") then return v end
            if string.find(v.Name, "Hand") and string.find(Settings.Combat.HitboxPart, "Arm") then return v end
            if string.find(v.Name, "Foot") and string.find(Settings.Combat.HitboxPart, "Leg") then return v end
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    local CurrentTime = tick()
    
    if Settings.Visuals.FullBright then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
    end

    if Settings.Misc.FPSBoost then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Material ~= Enum.Material.SmoothPlastic then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if Settings.Movement.SpeedEnabled then Hum.WalkSpeed = Settings.Movement.WalkSpeed end
        if Settings.Movement.JumpEnabled then Hum.JumpPower = Settings.Movement.JumpPower end
        
        if HRP then
            if Settings.Movement.Fly then
                if not HRP:FindFirstChild("QTFlyBV") then
                    local BV = Instance.new("BodyVelocity", HRP)
                    BV.Name = "QTFlyBV"
                    BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    local BG = Instance.new("BodyGyro", HRP)
                    BG.Name = "QTFlyBG"
                    BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                end
                
                HRP.QTFlyBG.CFrame = Camera.CFrame
                local MoveDir = Hum.MoveDirection
                local Spd = Settings.Movement.FlySpeed
                HRP.QTFlyBV.Velocity = (Camera.CFrame.LookVector * (MoveDir.Z < 0 and Spd or MoveDir.Z > 0 and -Spd or 0)) + 
                                       (Camera.CFrame.RightVector * (MoveDir.X > 0 and Spd or MoveDir.X < 0 and -Spd or 0)) +
                                       (Camera.CFrame.UpVector * (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Spd or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -Spd or 0))
                
                if MoveDir.Magnitude == 0 and not UserInputService:IsKeyDown(Enum.KeyCode.Space) and not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                     HRP.QTFlyBV.Velocity = Vector3.new(0, 0, 0)
                end
            else
                if HRP:FindFirstChild("QTFlyBV") then HRP.QTFlyBV:Destroy() end
                if HRP:FindFirstChild("QTFlyBG") then HRP.QTFlyBG:Destroy() end
            end
            
            if Settings.Movement.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end

    local ClosestTarget = nil
    local MinDist = Settings.Combat.AimRadius
    
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer and Plr.Character then
            local TargetPart = GetTargetPart(Plr.Character)
            
            if Settings.Combat.Hitbox and TargetPart then
                TargetPart.Size = Vector3.new(Settings.Combat.HitboxSize, Settings.Combat.HitboxSize, Settings.Combat.HitboxSize)
                TargetPart.Transparency = Settings.Combat.HitboxTransparency
                TargetPart.Color = Settings.Combat.HitboxColor
                TargetPart.Material = Enum.Material.ForceField
                TargetPart.CanCollide = false
                TargetPart.Massless = true
            end
            
            if Settings.Visuals.ESP_Box or Settings.Visuals.ESP_Name or Settings.Visuals.ESP_Line then
                 local HL = Plr.Character:FindFirstChild("QTHighlight")
                 if not HL then
                     HL = Instance.new("Highlight", Plr.Character)
                     HL.Name = "QTHighlight"
                 end
                 HL.Enabled = Settings.Visuals.ESP_Box
                 HL.FillColor = Settings.Visuals.ESP_Color
                 HL.OutlineColor = Color3.new(1,1,1)
                 
                 local Head = Plr.Character:FindFirstChild("Head")
                 if Head then
                     local NameTag = Head:FindFirstChild("QTNameTag")
                     if Settings.Visuals.ESP_Name then
                         if not NameTag then
                             NameTag = Instance.new("BillboardGui", Head)
                             NameTag.Name = "QTNameTag"
                             NameTag.Size = UDim2.new(0, 100, 0, 50)
                             NameTag.StudsOffset = Vector3.new(0, 2, 0)
                             
