local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Config = {
    Combat = {
        HitboxEnabled = false,
        HitboxSize = 25,
        HitboxPart = "Head",
        HitboxTransparency = 0.5,
        Aimbot = false,
        AimRadius = 150,
        AimSmooth = 0.1,
        Predict = 0.165,
        ShowFOV = true
    },
    Visuals = {
        Skeleton = false,
        Box = false,
        Tracer = false,
        Names = false,
        Xray = false,
        XrayTransparency = 0.5,
        Color = Color3.fromRGB(180, 0, 255)
    },
    Movement = {
        SpeedEnabled = false,
        WalkSpeed = 16,
        Fly = false,
        FlySpeed = 150,
        ShiftLock = false,
        InfJump = false,
        Noclip = false
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_Eternal"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function Corner(obj, r)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, r or 12)
    uic.Parent = obj
end

local function Stroke(obj, col, th)
    local uis = Instance.new("UIStroke")
    uis.Color = col or Color3.fromRGB(180, 0, 255)
    uis.Thickness = th or 2
    uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uis.Parent = obj
end

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.Size = UDim2.new(0, 700, 0, 450)
Main.BorderSizePixel = 0
Corner(Main, 18)
Stroke(Main, Color3.fromRGB(180, 0, 255), 2.5)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 60)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG GOD HUB"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextSize = 28
Title.TextXAlignment = Enum.TextXAlignment.Left

local SideBar = Instance.new("ScrollingFrame")
SideBar.Name = "SideBar"
SideBar.Parent = Main
SideBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
SideBar.Position = UDim2.new(0, 15, 0, 75)
SideBar.Size = UDim2.new(0, 160, 1, -90)
SideBar.ScrollBarThickness = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
Corner(SideBar, 12)

local TabList = Instance.new("UIListLayout")
TabList.Parent = SideBar
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 185, 0, 75)
Container.Size = UDim2.new(1, -200, 1, -90)

local function NewPage()
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
    Page.Parent = Container
    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Page
    UIList.Padding = UDim.new(0, 12)
    return Page
end

local Tabs = {}
function Tabs:AddTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
    TabBtn.TextSize = 14
    TabBtn.Parent = SideBar
    Corner(TabBtn, 8)
    
    local Page = NewPage()
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(SideBar:GetChildren()) do 
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 28), TextColor3 = Color3.fromRGB(140, 140, 140)}):Play() 
            end 
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(180, 0, 255), TextColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    local Funcs = {}
    function Funcs:AddToggle(text, callback)
        local TFrame = Instance.new("Frame")
        TFrame.Size = UDim2.new(0.97, 0, 0, 50)
        TFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        TFrame.Parent = Page
        Corner(TFrame, 8)
        Stroke(TFrame, Color3.fromRGB(40, 40, 50), 1)
        
        local TText = Instance.new("TextLabel")
        TText.Size = UDim2.new(1, -70, 1, 0)
        TText.Position = UDim2.new(0, 15, 0, 0)
        TText.BackgroundTransparency = 1
        TText.Font = Enum.Font.GothamBold
        TText.Text = text
        TText.TextColor3 = Color3.new(1, 1, 1)
        TText.TextSize = 13
        TText.TextXAlignment = Enum.TextXAlignment.Left
        TText.Parent = TFrame
        
        local TBtn = Instance.new("TextButton")
        TBtn.Size = UDim2.new(0, 44, 0, 22)
        TBtn.Position = UDim2.new(1, -55, 0.5, -11)
        TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        TBtn.Text = ""
        TBtn.Parent = TFrame
        Corner(TBtn, 11)
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 3, 0.5, -8)
        Circle.BackgroundColor3 = Color3.new(1, 1, 1)
        Circle.Parent = TBtn
        Corner(Circle, 8)
        
        local state = false
        TBtn.MouseButton1Click:Connect(function()
            state = not state
            local pos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local col = state and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(45, 45, 55)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = pos}):Play()
            TweenService:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
            callback(state)
        end)
    end
    
    function Funcs:AddSlider(text, min, max, default, callback)
        local SFrame = Instance.new("Frame")
        SFrame.Size = UDim2.new(0.97, 0, 0, 70)
        SFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        SFrame.Parent = Page
        Corner(SFrame, 8)
        
        local SText = Instance.new("TextLabel")
        SText.Size = UDim2.new(1, 0, 0, 30)
        SText.Position = UDim2.new(0, 15, 0, 5)
        SText.BackgroundTransparency = 1
        SText.Font = Enum.Font.GothamBold
        SText.Text = text .. ": " .. default
        SText.TextColor3 = Color3.new(1, 1, 1)
        SText.TextSize = 13
        SText.TextXAlignment = Enum.TextXAlignment.Left
        SText.Parent = SFrame

        local SBar = Instance.new("Frame")
        SBar.Size = UDim2.new(0.9, 0, 0, 6)
        SBar.Position = UDim2.new(0.05, 0, 0.75, 0)
        SBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SBar.Parent = SFrame
        Corner(SBar, 4)

        local SFill = Instance.new("Frame")
        SFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        SFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        SFill.Parent = SBar
        Corner(SFill, 4)

        local Trigger = Instance.new("TextButton")
        Trigger.Size = UDim2.new(1, 0, 1, 0)
        Trigger.BackgroundTransparency = 1
        Trigger.Text = ""
        Trigger.Parent = SBar

        Trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local Connection
                Connection = RunService.RenderStepped:Connect(function()
                    local CP = UserInputService:GetMouseLocation()
                    local RelPos = CP.X - SBar.AbsolutePosition.X
                    local Scale = math.clamp(RelPos / SBar.AbsoluteSize.X, 0, 1)
                    SFill.Size = UDim2.new(Scale, 0, 1, 0)
                    local Val = math.floor(min + (Scale * (max - min)))
                    SText.Text = text .. ": " .. Val
                    callback(Val)
                end)
                UserInputService.InputEnded:Connect(function(Ending)
                    if Ending.UserInputType == Enum.UserInputType.MouseButton1 or Ending.UserInputType == Enum.UserInputType.Touch then
                        if Connection then Connection:Disconnect() end
                    end
                end)
            end
        end)
    end
    return Funcs
end

local MainTab = Tabs:AddTab("Combat")
MainTab:AddToggle("Supreme Aimbot", function(v) Config.Combat.Aimbot = v end)
MainTab:AddToggle("Show FOV", function(v) Config.Combat.ShowFOV = v end)
MainTab:AddSlider("FOV Size", 50, 800, 150, function(v) Config.Combat.AimRadius = v end)
MainTab:AddToggle("Hitbox Expander", function(v) Config.Combat.HitboxEnabled = v end)
MainTab:AddSlider("Hitbox Scale", 10, 500, 25, function(v) Config.Combat.HitboxSize = v end)

local EspTab = Tabs:AddTab("Visuals")
EspTab:AddToggle("Enable Xray", function(v) Config.Visuals.Xray = v end)
EspTab:AddSlider("Xray Transparency", 0, 10, 5, function(v) Config.Visuals.XrayTransparency = v/10 end)
EspTab:AddToggle("Box Highlight", function(v) Config.Visuals.Box = v end)
EspTab:AddToggle("Tracer Lines", function(v) Config.Visuals.Tracer = v end)
EspTab:AddToggle("Name & Dist", function(v) Config.Visuals.Names = v end)

local MoveTab = Tabs:AddTab("Movement")
MoveTab:AddToggle("Speed Bypass", function(v) Config.Movement.SpeedEnabled = v end)
MoveTab:AddSlider("Speed Multi", 16, 1000, 16, function(v) Config.Movement.WalkSpeed = v end)
MoveTab:AddToggle("Fly Mode", function(v) Config.Movement.Fly = v end)
MoveTab:AddSlider("Fly Power", 50, 1000, 150, function(v) Config.Movement.FlySpeed = v end)
MoveTab:AddToggle("Mobile ShiftLock", function(v) Config.Movement.ShiftLock = v end)

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 2
FOV_Circle.Color = Color3.fromRGB(180, 0, 255)
FOV_Circle.Filled = false
FOV_Circle.Transparency = 1

local function UpdateXray()
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) and not part.Parent:FindFirstChild("Humanoid") then
            if Config.Visuals.Xray then
                if not part:FindFirstChild("OldT") then
                    local val = Instance.new("NumberValue", part)
                    val.Name = "OldT"
                    val.Value = part.Transparency
                end
                part.Transparency = Config.Visuals.XrayTransparency
            else
                if part:FindFirstChild("OldT") then
                    part.Transparency = part.OldT.Value
                    part.OldT:Destroy()
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    FOV_Circle.Visible = Config.Combat.ShowFOV and Config.Combat.Aimbot
    FOV_Circle.Radius = Config.Combat.AimRadius
    FOV_Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    if Config.Visuals.Xray then UpdateXray() end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local H = LocalPlayer.Character.Humanoid
        local HRP = LocalPlayer.Character.HumanoidRootPart
        if Config.Movement.SpeedEnabled then H.WalkSpeed = Config.Movement.WalkSpeed end
        if Config.Movement.ShiftLock then
            Camera.Offset = Vector3.new(1.8, 0.5, 0)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            Camera.Offset = Vector3.new(0, 0, 0)
        end
        if Config.Movement.Fly then
            if not HRP:FindFirstChild("FlyV") then
                local bv = Instance.new("BodyVelocity", HRP)
                bv.Name = "FlyV"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                local bg = Instance.new("BodyGyro", HRP)
                bg.Name = "FlyG"
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            end
            HRP.FlyG.CFrame = Camera.CFrame
            HRP.FlyV.Velocity = Camera.CFrame.LookVector * H.MoveDirection.Magnitude * Config.Movement.FlySpeed
        else
            if HRP:FindFirstChild("FlyV") then HRP.FlyV:Destroy(); HRP.FlyG:Destroy() end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Combat.HitboxEnabled and p.Character:FindFirstChild(Config.Combat.HitboxPart) then
                local part = p.Character[Config.Combat.HitboxPart]
                part.Size = Vector3.new(Config.Combat.HitboxSize, Config.Combat.HitboxSize, Config.Combat.HitboxSize)
                part.Transparency = Config.Combat.HitboxTransparency
                part.CanCollide = false
            end
            local hl = p.Character:FindFirstChild("QT_H")
            if Config.Visuals.Box then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "QT_H"
                    hl.FillColor = Config.Visuals.Color
                end
            elseif hl then hl:Destroy() end
        end
    end

    if Config.Combat.Aimbot then
        local t = nil; local d = Config.Combat.AimRadius
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local p, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(p.X, p.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if m < d then d = m; t = v end
                end
            end
        end
        if t then
            local targetPos = t.Character.Head.Position + (t.Character.Head.Velocity * Config.Combat.Predict)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Config.Combat.AimSmooth)
        end
    end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
ToggleBtn.Text = "QT"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.LuckiestGuy
ToggleBtn.TextSize = 25
Corner(ToggleBtn, 30)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
