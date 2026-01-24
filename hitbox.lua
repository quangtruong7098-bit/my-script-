V9", "Ultimate Hub Loaded! (No Comments)")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    Combat = {
        HitboxEnabled = false,
        HitboxSize = 25,
        HitboxPart = "Head",
        HitboxTransparency = 0.5,
        HitboxColor = Color3.fromRGB(180, 0, 255),
        SilentAim = false,
        AimPart = "Head",
        AimRadius = 150,
        AimSmooth = 0.05,
        Predict = 0.165
    },
    Visuals = {
        Skeleton = false,
        Box = false,
        Tracer = false,
        Name = false,
        Distance = false,
        Health = false,
        Color = Color3.fromRGB(180, 0, 255),
        FOV_Circle = false,
        Rainbow = false
    },
    Movement = {
        SpeedEnabled = false,
        WalkSpeed = 16,
        Fly = false,
        FlySpeed = 150,
        Noclip = false,
        InfJump = false,
        ShiftLock = false
    }
}

local Library = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_GodHub_V10"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function Corner(obj, radius)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, radius or 12)
    uic.Parent = obj
    return uic
end

local function Stroke(obj, color, thickness)
    local uis = Instance.new("UIStroke")
    uis.Color = color or Color3.fromRGB(180, 0, 255)
    uis.Thickness = thickness or 2.5
    uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uis.Parent = obj
    return uis
end

local function Shadow(obj)
    local g = Instance.new("ImageLabel")
    g.Name = "GlowEffect"
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://6015667343"
    g.ImageColor3 = Color3.fromRGB(180, 0, 255)
    g.Position = UDim2.new(0, -15, 0, -15)
    g.Size = UDim2.new(1, 30, 1, 30)
    g.ZIndex = obj.ZIndex - 1
    g.Parent = obj
    return g
end

function Library:Notify(title, text)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(0, 300, 0, 90)
    F.Position = UDim2.new(1, 20, 0.8, 0)
    F.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    F.Parent = ScreenGui
    
    Corner(F, 10)
    Stroke(F)
    Shadow(F)
    
    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -30, 0, 30)
    t1.Position = UDim2.new(0, 15, 0, 10)
    t1.Text = title
    t1.TextColor3 = Color3.fromRGB(180, 0, 255)
    t1.Font = Enum.Font.GothamBold
    t1.TextSize = 18
    t1.BackgroundTransparency = 1
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = F
    
    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -30, 0, 40)
    t2.Position = UDim2.new(0, 15, 0, 40)
    t2.Text = text
    t2.TextColor3 = Color3.new(1, 1, 1)
    t2.Font = Enum.Font.Gotham
    t2.TextSize = 14
    t2.BackgroundTransparency = 1
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.TextWrapped = true
    t2.Parent = F
    
    F:TweenPosition(UDim2.new(1, -320, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5)
    
    task.delay(4, function()
        F:TweenPosition(UDim2.new(1, 20, 0.8, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.5)
        task.wait(0.5)
        F:Destroy()
    end)
end

function Library:CreateWindow(title)
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 680, 0, 520)
    Main.Position = UDim2.new(0.5, -340, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    Corner(Main, 20)
    Stroke(Main, Color3.fromRGB(180, 0, 255), 3)
    Shadow(Main)
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 70)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = Main
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 25, 0, 0)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(180, 0, 255)
    TitleLabel.Font = Enum.Font.LuckiestGuy
    TitleLabel.TextSize = 32
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 200, 1, -100)
    SideBar.Position = UDim2.new(0, 15, 0, 85)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    SideBar.Parent = Main
    Corner(SideBar, 15)
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, -10, 1, -10)
    TabScroll.Position = UDim2.new(0, 5, 0, 5)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.Parent = SideBar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 12)
    TabList.Parent = TabScroll
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -245, 1, -100)
    Container.Position = UDim2.new(0, 230, 0, 85)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local ToggleMain = Instance.new("TextButton")
    ToggleMain.Size = UDim2.new(0, 65, 0, 65)
    ToggleMain.Position = UDim2.new(0.02, 0, 0.1, 0)
    ToggleMain.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    ToggleMain.Text = "QT"
    ToggleMain.TextColor3 = Color3.fromRGB(180, 0, 255)
    ToggleMain.Font = Enum.Font.LuckiestGuy
    ToggleMain.TextSize = 28
    ToggleMain.Parent = ScreenGui
    Corner(ToggleMain, 50)
    Stroke(ToggleMain)

    ToggleMain.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    local dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Tabs = {}
    function Tabs:AddTab(name)
        local Tb = Instance.new("TextButton")
        Tb.Size = UDim2.new(1, 0, 0, 50)
        Tb.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Tb.Text = name
        Tb.TextColor3 = Color3.fromRGB(160, 160, 160)
        Tb.Font = Enum.Font.GothamBold
        Tb.TextSize = 16
        Tb.Parent = TabScroll
        Corner(Tb, 12)
        
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
        Page.Parent = Container
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 15)
        PageList.Parent = Page
        
        Tb.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do
                v.Visible = false
            end
            for _, v in pairs(TabScroll:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 35), TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(Tb, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(180, 0, 255), TextColor3 = Color3.new(1, 1, 1)}):Play()
        end)
        
        local Ele = {}
        
        function Ele:AddToggle(text, callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0.96, 0, 0, 60)
            f.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            f.Parent = Page
            Corner(f, 10)
            Stroke(f, Color3.fromRGB(45, 45, 60), 1.5)
            
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -80, 1, 0)
            l.Position = UDim2.new(0, 20, 0, 0)
            l.Text = text
            l.TextColor3 = Color3.new(1, 1, 1)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 15
            l.BackgroundTransparency = 1
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f
            
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 55, 0, 28)
            b.Position = UDim2.new(1, -75, 0.5, -14)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.Text = ""
            b.Parent = f
            Corner(b, 15)
            
            local c = Instance.new("Frame")
            c.Size = UDim2.new(0, 22, 0, 22)
            c.Position = UDim2.new(0, 3, 0.5, -11)
            c.BackgroundColor3 = Color3.new(1, 1, 1)
            c.Parent = b
            Corner(c, 12)
            
            local state = false
            b.MouseButton1Click:Connect(function()
                state = not state
                local pos = state and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
                local col = state and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(40, 40, 50)
                TweenService:Create(c, TweenInfo.new(0.3), {Position = pos}):Play()
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = col}):Play()
                callback(state)
            end)
        end
        
        function Ele:AddSlider(text, min, max, def, callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0.96, 0, 0, 95)
            f.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            f.Parent = Page
            Corner(f, 10)
            Stroke(f, Color3.fromRGB(45, 45, 60), 1.5)
            
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -20, 0, 45)
            l.Position = UDim2.new(0, 20, 0, 5)
            l.Text = text .. ": " .. def
            l.TextColor3 = Color3.new(1, 1, 1)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 15
            l.BackgroundTransparency = 1
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0.9, 0, 0, 12)
            bar.Position = UDim2.new(0.05, 0, 0.75, 0)
            bar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            bar.Parent = f
            Corner(bar, 6)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
            fill.Parent = bar
            Corner(fill, 6)
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = bar
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local dragging = true
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(move)
                        if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                            local scale = math.clamp((move.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                            fill.Size = UDim2.new(scale, 0, 1, 0)
                            local value = math.floor(min + (max - min) * scale)
                            l.Text = text .. ": " .. value
                            callback(value)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(ended)
                        if ended.UserInputType == Enum.UserInputType.MouseButton1 or ended.UserInputType == Enum.UserInputType.Touch then
                            connection:Disconnect()
                        end
                    end)
                end
            end)
        end
        
        function Ele:AddDropdown(text, list, callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0.96, 0, 0, 60)
            f.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            f.Parent = Page
            Corner(f, 10)
            Stroke(f, Color3.fromRGB(45, 45, 60), 1.5)
            
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -20, 1, 0)
            l.Position = UDim2.new(0, 20, 0, 0)
            l.Text = text .. ": " .. list[1]
            l.TextColor3 = Color3.new(1, 1, 1)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 15
            l.BackgroundTransparency = 1
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = f
            
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.Parent = f
            
            local current = 1
            b.MouseButton1Click:Connect(function()
                current = current + 1
                if current > #list then current = 1 end
                l.Text = text .. ": " .. list[current]
                callback(list[current])
            end)
        end
        
        return Ele
    end
    return Tabs
end

local Win = Library:CreateWindow("QT GOD ULTIMATE V10")
local Combat = Win:AddTab("COMBAT")
local Visuals = Win:AddTab("VISUALS")
local Movement = Win:AddTab("MOVEMENT")

Combat:AddToggle("Hitbox God", function(v) Config.Combat.HitboxEnabled = v end)
Combat:AddDropdown("Select Part", {"Head", "HumanoidRootPart", "UpperTorso"}, function(v) Config.Combat.HitboxPart = v end)
Combat:AddSlider("Hitbox Size", 1, 1000, 25, function(v) Config.Combat.HitboxSize = v end)
Combat:AddToggle("Silent Aim", function(v) Config.Combat.SilentAim = v end)
Combat:AddSlider("FOV Size", 50, 800, 150, function(v) Config.Combat.AimRadius = v end)
Combat:AddSlider("Aim Smoothing", 1, 100, 10, function(v) Config.Combat.AimSmooth = v/1000 end)

Visuals:AddToggle("Skeleton ESP", function(v) Config.Visuals.Skeleton = v end)
Visuals:AddToggle("Box ESP", function(v) Config.Visuals.Box = v end)
Visuals:AddToggle("Tracer Lines", function(v) Config.Visuals.Tracer = v end)
Visuals:AddToggle("Names & Distance", function(v) Config.Visuals.Name = v end)
Visuals:AddToggle("Rainbow Menu", function(v) Config.Visuals.Rainbow = v end)
Visuals:AddToggle("Full Bright", function(v) Config.Visuals.FullBright = v end)

Movement:AddToggle("Shift Lock Mobile", function(v) Config.Movement.ShiftLock = v end)
Movement:AddToggle("Speed Bypass", function(v) Config.Movement.SpeedEnabled = v end)
Movement:AddSlider("Speed Value", 16, 2000, 16, function(v) Config.Movement.WalkSpeed = v end)
Movement:AddToggle("Fly God", function(v) Config.Movement.Fly = v end)
Movement:AddSlider("Fly Speed", 50, 2000, 150, function(v) Config.Movement.FlySpeed = v end)
Movement:AddToggle("Noclip Bypass", function(v) Config.Movement.Noclip = v end)
Movement:AddToggle("Infinite Jump", function(v) Config.Movement.InfJump = v end)

local FOV = Drawing.new("Circle")
FOV.Thickness = 2
FOV.Color = Color3.fromRGB(180, 0, 255)
FOV.Filled = false
FOV.Transparency = 1

local function GetTarget()
    local target = nil
    local dist = Config.Combat.AimRadius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.Combat.AimPart) then
            local pos, vis = Camera:WorldToViewportPoint(v.Character[Config.Combat.AimPart].Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

local Bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}
}

local function CreateESP(plr)
    local SkeletonLines = {}
    for i = 1, #Bones do
        local l = Drawing.new("Line")
        l.Thickness = 2
        l.Color = Config.Visuals.Color
        SkeletonLines[i] = l
    end
    
    local Tracer = Drawing.new("Line")
    Tracer.Thickness = 1.5
    Tracer.Color = Config.Visuals.Color
    
    local NameTag = Drawing.new("Text")
    NameTag.Size = 16
    NameTag.Center = true
    NameTag.Outline = true
    NameTag.Color = Color3.new(1, 1, 1)

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= LocalPlayer then
            local hrp = plr.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            
            if vis and Config.Visuals.Skeleton then
                for i, bone in pairs(Bones) do
                    local p1 = plr.Character:FindFirstChild(bone[1])
                    local p2 = plr.Character:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local v1, vs1 = Camera:WorldToViewportPoint(p1.Position)
                        local v2, vs2 = Camera:WorldToViewportPoint(p2.Position)
                        SkeletonLines[i].Visible = vs1 and vs2
                        SkeletonLines[i].From = Vector2.new(v1.X, v1.Y)
                        SkeletonLines[i].To = Vector2.new(v2.X, v2.Y)
                    else
                        SkeletonLines[i].Visible = false
                    end
                end
            else
                for _, l in pairs(SkeletonLines) do l.Visible = false end
            end
            
            if vis and Config.Visuals.Tracer then
                Tracer.Visible = true
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To = Vector2.new(pos.X, pos.Y)
            else
                Tracer.Visible = false
            end
            
            if vis and Config.Visuals.Name then
                local d = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                NameTag.Visible = true
                NameTag.Text = plr.Name .. " | " .. d .. "m"
                NameTag.Position = Vector2.new(pos.X, pos.Y - 40)
            else
                NameTag.Visible = false
            end
            
            local hl = plr.Character:FindFirstChild("QT_Highlight")
            if Config.Visuals.Box then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "QT_Highlight"
                    hl.Parent = plr.Character
                end
                hl.FillColor = Config.Visuals.Color
                hl.
