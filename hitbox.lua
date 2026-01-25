local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    Visuals = {Xray = false, XrayTrans = 0.5, Hitbox = false, HitboxSize = 25},
    Movement = {Speed = false, SpeedVal = 100, Fly = false, FlySpeed = 100, InfJump = false},
    Aimbot = {Enabled = false, Radius = 150, Smooth = 0.5}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_MobileFix"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Position = UDim2.new(0.5, -300, 0.5, -180)
Main.Size = UDim2.new(0, 600, 0, 360)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 0, 255)
MainStroke.Thickness = 2.5
MainStroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(1, -40, 0, 50)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG GOD MODE HUB"
Title.TextColor3 = Color3.fromRGB(220, 50, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = Main
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 10, 0, 55)
ScrollContainer.Size = UDim2.new(1, -20, 1, -65)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollContainer.ScrollBarThickness = 2
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 255)

local UIGrid = Instance.new("UIGridLayout")
UIGrid.Parent = ScrollContainer
UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)
UIGrid.CellSize = UDim2.new(0, 280, 0, 160)

local function CreateCard(title)
    local Card = Instance.new("Frame")
    Card.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Card.Parent = ScrollContainer
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Card).Color = Color3.fromRGB(60, 60, 80)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 30)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamBold
    Lbl.Text = "  " .. title
    Lbl.TextColor3 = Color3.fromRGB(200, 0, 255)
    Lbl.TextSize = 14
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Card
    
    local List = Instance.new("Frame")
    List.Position = UDim2.new(0, 5, 0, 30)
    List.Size = UDim2.new(1, -10, 1, -35)
    List.BackgroundTransparency = 1
    List.Parent = Card
    Instance.new("UIListLayout", List).Padding = UDim.new(0, 5)
    
    return List
end

local function AddToggle(parent, text, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundTransparency = 1
    f.Parent = parent
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 40, 0, 20)
    b.Position = UDim2.new(1, -45, 0.5, -10)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.Text = ""
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Parent = b
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 10)
    
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        TweenService:Create(dot, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(50, 50, 60)}):Play()
        callback(s)
    end)
end

local function AddSlider(parent, text, min, max, def, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundTransparency = 1
    f.Parent = parent
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text .. ": " .. def
    l.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local s = Instance.new("Frame")
    s.Size = UDim2.new(0.9, 0, 0, 4)
    s.Position = UDim2.new(0.05, 0, 0.7, 0)
    s.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    s.Parent = f
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
    fill.Parent = s
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = s
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local con
            con = RunService.RenderStepped:Connect(function()
                local sc = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(sc, 0, 1, 0)
                local v = math.floor(min + (sc * (max - min)))
                l.Text = text .. ": " .. v
                callback(v)
            end)
            UserInputService.InputEnded:Connect(function(e)
                if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then
                    if con then con:Disconnect() end
                end
            end)
        end
    end)
end

local VisCard = CreateCard("Visuals & Hitbox")
AddToggle(VisCard, "Enable Hitbox", function(v) Config.Visuals.Hitbox = v end)
AddSlider(VisCard, "Hitbox Size", 5, 100, 25, function(v) Config.Visuals.HitboxSize = v end)
AddToggle(VisCard, "Enable Xray", function(v) Config.Visuals.Xray = v end)

local MoveCard = CreateCard("Movement")
AddToggle(MoveCard, "Speed Hack", function(v) Config.Movement.Speed = v end)
AddSlider(MoveCard, "Value", 16, 500, 150, function(v) Config.Movement.SpeedVal = v end)
AddToggle(MoveCard, "Fly Mode", function(v) Config.Movement.Fly = v end)

local CombatCard = CreateCard("Combat")
AddToggle(CombatCard, "Aimbot", function(v) Config.Aimbot.Enabled = v end)
AddSlider(CombatCard, "FOV Radius", 50, 800, 150, function(v) Config.Aimbot.Radius = v end)

RunService.RenderStepped:Connect(function()
    if Config.Visuals.Xray then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p:IsDescendantOf(LocalPlayer.Character) and not p.Parent:FindFirstChild("Humanoid") then
                p.LocalTransparencyModifier = Config.Visuals.XrayTrans
            end
        end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            if Config.Visuals.Hitbox then
                hrp.Size = Vector3.new(Config.Visuals.HitboxSize, Config.Visuals.HitboxSize, Config.Visuals.HitboxSize)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
    if Config.Movement.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.SpeedVal
    end
end)

local BTN = Instance.new("TextButton", ScreenGui)
BTN.Size = UDim2.new(0, 50, 0, 50)
BTN.Position = UDim2.new(0, 15, 0.45, 0)
BTN.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
BTN.Text = "QT"
BTN.TextColor3 = Color3.new(1, 1, 1)
BTN.Font = Enum.Font.LuckiestGuy
BTN.TextSize = 22
Instance.new("UICorner", BTN).CornerRadius = UDim.new(0, 25)
BTN.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
