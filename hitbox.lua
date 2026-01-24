local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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
        Box = false,
        Xray = false,
        XrayTransparency = 0.5,
        Color = Color3.fromRGB(180, 0, 255)
    },
    Movement = {
        SpeedEnabled = false,
        WalkSpeed = 16,
        Fly = false,
        FlySpeed = 150,
        ShiftLock = false
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_GodMode"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Position = UDim2.new(0.5, -340, 0.5, -230)
Main.Size = UDim2.new(0, 680, 0, 460)
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(180, 0, 255)
MainStroke.Thickness = 3
MainStroke.Parent = Main

local Glow = Instance.new("ImageLabel")
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6015667343"
Glow.ImageColor3 = Color3.fromRGB(180, 0, 255)
Glow.Position = UDim2.new(0, -15, 0, -15)
Glow.Size = UDim2.new(1, 30, 1, 30)
Glow.ZIndex = 0
Glow.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0, 400, 0, 60)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG GOD MODE HUB"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextSize = 30
Title.TextXAlignment = Enum.TextXAlignment.Left

local SideBar = Instance.new("ScrollingFrame")
SideBar.Parent = Main
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SideBar.Position = UDim2.new(0, 15, 0, 70)
SideBar.Size = UDim2.new(0, 160, 1, -85)
SideBar.ScrollBarThickness = 0
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame")
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 185, 0, 70)
Container.Size = UDim2.new(1, -200, 1, -85)

local function NewPage()
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = Container
    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Page
    UIList.Padding = UDim.new(0, 10)
    return Page
end

local Tabs = {}
function Tabs:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = SideBar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)

    local Page = NewPage()
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    
    local Funcs = {}
    function Funcs:Toggle(text, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.95, 0, 0, 45)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        f.Parent = Page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -60, 1, 0)
        l.Position = UDim2.new(0, 15, 0, 0)
        l.Text = text
        l.TextColor3 = Color3.new(1,1,1)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 40, 0, 20)
        b.Position = UDim2.new(1, -50, 0.5, -10)
        b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        b.Text = ""
        b.Parent = f
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        local state = false
        b.MouseButton1Click:Connect(function()
            state = not state
            b.BackgroundColor3 = state and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(50, 50, 60)
            callback(state)
        end)
    end
    
    function Funcs:Slider(text, min, max, def, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.95, 0, 0, 60)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        f.Parent = Page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 30)
        l.Position = UDim2.new(0, 15, 0, 5)
        l.Text = text .. ": " .. def
        l.TextColor3 = Color3.new(1,1,1)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        
        local s = Instance.new("Frame")
        s.Size = UDim2.new(0.85, 0, 0, 6)
        s.Position = UDim2.new(0.07, 0, 0.75, 0)
        s.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        s.Parent = f
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        fill.Parent = s
        
        local trigger = Instance.new("TextButton")
        trigger.Size = UDim2.new(1, 0, 1, 0)
        trigger.BackgroundTransparency = 1
        trigger.Text = ""
        trigger.Parent = s
        
        trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    local scale = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(scale, 0, 1, 0)
                    local val = math.floor(min + (scale * (max - min)))
                    l.Text = text .. ": " .. val
                    callback(val)
                end)
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end)
    end
    return Funcs
end

local CombatT = Tabs:CreateTab("Combat")
CombatT:Toggle("Aimbot", function(v) Config.Combat.Aimbot = v end)
CombatT:Slider("FOV Size", 50, 800, 150, function(v) Config.Combat.AimRadius = v end)
CombatT:Toggle("Hitbox Expander", function(v) Config.Combat.HitboxEnabled = v end)
CombatT:Slider("Hitbox Size", 10, 500, 25, function(v) Config.Combat.HitboxSize = v end)

local VisualT = Tabs:CreateTab("Visuals")
VisualT:Toggle("Xray (Wallhack)", function(v) Config.Visuals.Xray = v end)
VisualT:Toggle("Box ESP", function(v) Config.Visuals.Box = v end)

local MoveT = Tabs:CreateTab("Movement")
MoveT:Toggle("Speed Bypass", function(v) Config.Movement.SpeedEnabled = v end)
MoveT:Slider("WalkSpeed", 16, 500, 16, function(v) Config.Movement.WalkSpeed = v end)

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 2
FOV_Circle.Color = Color3.fromRGB(180, 0, 255)
FOV_Circle.Filled = false

RunService.RenderStepped:Connect(function()
    FOV_Circle.Visible = Config.Combat.Aimbot
    FOV_Circle.Radius = Config.Combat.AimRadius
    FOV_Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    if Config.Visuals.Xray then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p:IsDescendantOf(LocalPlayer.Character) and not p.Parent:FindFirstChild("Humanoid") then
                p.LocalTransparencyModifier = Config.Visuals.XrayTransparency
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Combat.HitboxEnabled and p.Character:FindFirstChild(Config.Combat.HitboxPart) then
                local hb = p.Character[Config.Combat.HitboxPart]
                hb.Size = Vector3.new(Config.Combat.HitboxSize, Config.Combat.HitboxSize, Config.Combat.HitboxSize)
                hb.Transparency = Config.Combat.HitboxTransparency
                hb.CanCollide = false
            end
        end
    end

    if Config.Combat.Aimbot then
        local target = nil
        local dist = Config.Combat.AimRadius
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mag < dist then dist = mag; target = v end
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), Config.Combat.AimSmooth)
        end
    end
end)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
ToggleBtn.Text = "QT"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.LuckiestGuy
ToggleBtn.TextSize = 25
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 30)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
