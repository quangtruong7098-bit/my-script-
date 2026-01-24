local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    Visuals = {Xray = false, XrayTrans = 0.5, Hitbox = false, HitboxSize = 25},
    Movement = {Speed = false, SpeedVal = 150, Fly = false, FlySpeed = 150, InfJump = false},
    Misc = {AntiAFK = false}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_Supreme_V12"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
Main.BackgroundTransparency = 0.2
Main.Position = UDim2.new(0.5, -340, 0.5, -230)
Main.Size = UDim2.new(0, 680, 0, 460)
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 0, 255)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 25, 0, 10)
Title.Size = UDim2.new(0, 400, 0, 50)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG GOD MODE HUB"
Title.TextColor3 = Color3.fromRGB(255, 100, 255)
Title.TextSize = 28
Title.TextXAlignment = Enum.TextXAlignment.Left

local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = Main
SideBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideBar.BackgroundTransparency = 0.5
SideBar.Position = UDim2.new(0, 15, 0, 70)
SideBar.Size = UDim2.new(0, 160, 1, -85)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 15)

local Container = Instance.new("ScrollingFrame")
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 185, 0, 70)
Container.Size = UDim2.new(1, -200, 1, -85)
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 0

local Grid = Instance.new("UIGridLayout")
Grid.Parent = Container
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.CellSize = UDim2.new(0, 235, 0, 180)

local function CreateSection(name)
    local Sect = Instance.new("Frame")
    Sect.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    Sect.BackgroundTransparency = 0.4
    Sect.Parent = Container
    Instance.new("UICorner", Sect).CornerRadius = UDim.new(0, 12)
    local stk = Instance.new("UIStroke", Sect)
    stk.Color = Color3.fromRGB(255, 0, 255)
    stk.Thickness = 1
    stk.Transparency = 0.5

    local head = Instance.new("TextLabel")
    head.Size = UDim2.new(1, 0, 0, 30)
    head.BackgroundTransparency = 1
    head.Font = Enum.Font.GothamBold
    head.Text = "  " .. name
    head.TextColor3 = Color3.new(1, 1, 1)
    head.TextSize = 14
    head.TextXAlignment = Enum.TextXAlignment.Left
    head.Parent = Sect

    local itemHolder = Instance.new("Frame")
    itemHolder.Position = UDim2.new(0, 0, 0, 30)
    itemHolder.Size = UDim2.new(1, 0, 1, -35)
    itemHolder.BackgroundTransparency = 1
    itemHolder.Parent = Sect
    Instance.new("UIListLayout", itemHolder).Padding = UDim.new(0, 5)

    return itemHolder
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
    l.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 35, 0, 18)
    b.Position = UDim2.new(1, -45, 0.5, -9)
    b.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
    b.Text = ""
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local d = Instance.new("Frame")
    d.Size = UDim2.new(0, 14, 0, 14)
    d.Position = UDim2.new(0, 2, 0.5, -7)
    d.BackgroundColor3 = Color3.new(1, 1, 1)
    d.Parent = b
    Instance.new("UICorner", d).CornerRadius = UDim.new(0, 10)
    
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        TweenService:Create(d, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(60, 30, 80)}):Play()
        callback(s)
    end)
end

local function AddSlider(parent, text, min, max, def, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 35)
    f.BackgroundTransparency = 1
    f.Parent = parent
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 15)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text .. ": " .. def
    l.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local s = Instance.new("Frame")
    s.Size = UDim2.new(0.85, 0, 0, 4)
    s.Position = UDim2.new(0.07, 0, 0.7, 0)
    s.BackgroundColor3 = Color3.fromRGB(80, 40, 100)
    s.Parent = f
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    fill.Parent = s
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = s
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local c
            c = RunService.RenderStepped:Connect(function()
                local sc = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(sc, 0, 1, 0)
                local v = math.floor(min + (sc * (max - min)))
                l.Text = text .. ": " .. v
                callback(v)
            end)
            UserInputService.InputEnded:Connect(function(e)
                if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then
                    if c then c:Disconnect() end
                end
            end)
        end
    end)
end

local VisSect = CreateSection("Visuals")
AddToggle(VisSect, "Xray Enabled", function(v) Config.Visuals.Xray = v end)
AddSlider(VisSect, "Xray Trans", 0, 10, 5, function(v) Config.Visuals.XrayTrans = v/10 end)
AddToggle(VisSect, "Hitbox Expander", function(v) Config.Visuals.Hitbox = v end)
AddSlider(VisSect, "Size", 5, 100, 25, function(v) Config.Visuals.HitboxSize = v end)

local MoveSect = CreateSection("Movement")
AddToggle(MoveSect, "Speed Hack", function(v) Config.Movement.Speed = v end)
AddSlider(MoveSect, "Value", 16, 500, 150, function(v) Config.Movement.SpeedVal = v end)
AddToggle(MoveSect, "Infinite Jump", function(v) Config.Movement.InfJump = v end)

local MiscSect = CreateSection("Misc")
AddToggle(MiscSect, "Anti AFK", function(v) Config.Misc.AntiAFK = v end)

RunService.RenderStepped:Connect(function()
    if Config.Movement.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.SpeedVal
    end
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
                hrp.Transparency = 0.8
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

local ToggleBTN = Instance.new("TextButton", ScreenGui)
ToggleBTN.Size = UDim2.new(0, 50, 0, 50)
ToggleBTN.Position = UDim2.new(0, 10, 0.45, 0)
ToggleBTN.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
ToggleBTN.Text = "QT"
ToggleBTN.Font = Enum.Font.LuckiestGuy
ToggleBTN.TextSize = 20
ToggleBTN.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ToggleBTN).CornerRadius = UDim.new(0, 25)
ToggleBTN.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
