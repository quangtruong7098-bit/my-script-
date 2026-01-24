local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

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
        AimRadius = 150,
        AimSmooth = 0.1,
        Predict = 0.165
    },
    Visuals = {
        Box = false,
        Skeleton = false,
        Names = false,
        Tracer = false,
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
ScreenGui.Name = "QuangTruong_Stable_V11"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function Corner(obj, r)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, r or 12)
    uic.Parent = obj
end

local function Stroke(obj, col)
    local uis = Instance.new("UIStroke")
    uis.Color = col or Color3.fromRGB(180, 0, 255)
    uis.Thickness = 2.5
    uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uis.Parent = obj
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Visible = true
Corner(Main, 15)
Stroke(Main)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopBar.Size = UDim2.new(1, 0, 0, 50)
Corner(TopBar, 15)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG SUPREME V11"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 160, 0, 60)
Container.Size = UDim2.new(1, -170, 1, -70)

local SideBar = Instance.new("Frame")
SideBar.Parent = Main
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SideBar.Position = UDim2.new(0, 10, 0, 60)
SideBar.Size = UDim2.new(0, 140, 1, -70)
Corner(SideBar, 10)

local TabList = Instance.new("UIListLayout")
TabList.Parent = SideBar
TabList.Padding = UDim.new(0, 5)

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = SideBar
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.TextSize = 14
    Corner(TabBtn, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Parent = Container
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        Page.Visible = true
    end)

    return Page
end

local CombatPage = CreateTab("COMBAT")
local VisualPage = CreateTab("VISUALS")
local MovePage = CreateTab("MOVEMENT")

local function AddToggle(parent, text, callback)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    f.Size = UDim2.new(1, 0, 0, 45)
    Corner(f, 8)

    local l = Instance.new("TextLabel")
    l.Parent = f
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 15, 0, 0)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Font = Enum.Font.GothamSemibold
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left

    local b = Instance.new("TextButton")
    b.Parent = f
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Position = UDim2.new(1, -50, 0.5, -12)
    b.Size = UDim2.new(0, 40, 0, 24)
    b.Text = ""
    Corner(b, 12)

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(40, 40, 50)
        callback(state)
    end)
end

AddToggle(CombatPage, "Hitbox God Mode", function(v) Config.Combat.HitboxEnabled = v end)
AddToggle(CombatPage, "Silent Aim", function(v) Config.Combat.SilentAim = v end)
AddToggle(VisualPage, "Box ESP", function(v) Config.Visuals.Box = v end)
AddToggle(VisualPage, "Name Tags", function(v) Config.Visuals.Names = v end)
AddToggle(MovePage, "Speed Bypass", function(v) Config.Movement.SpeedEnabled = v end)
AddToggle(MovePage, "Fly Mode", function(v) Config.Movement.Fly = v end)
AddToggle(MovePage, "Shift Lock", function(v) Config.Movement.ShiftLock = v end)

RunService.RenderStepped:Connect(function()
    if Config.Movement.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.WalkSpeed
    end
    
    if Config.Movement.ShiftLock then
        Camera.Offset = Vector3.new(1.7, 0.5, 0)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        Camera.Offset = Vector3.new(0, 0, 0)
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Combat.HitboxEnabled and p.Character:FindFirstChild(Config.Combat.HitboxPart) then
                local part = p.Character[Config.Combat.HitboxPart]
                part.Size = Vector3.new(Config.Combat.HitboxSize, Config.Combat.HitboxSize, Config.Combat.HitboxSize)
                part.Transparency = Config.Combat.HitboxTransparency
                part.CanCollide = false
            end
            
            local hl = p.Character:FindFirstChild("QT_Highlight")
            if Config.Visuals.Box then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "QT_Highlight"
                end
                hl.FillColor = Config.Visuals.Color
            elseif hl then
                hl:Destroy()
            end
        end
    end
    
    if Config.Combat.SilentAim then
        local t = nil; local d = Config.Combat.AimRadius
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mag < d then d = mag; t = v end
                end
            end
        end
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), Config.Combat.AimSmooth)
        end
    end
end)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.Text = "QT"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Corner(ToggleBtn, 25)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("QuangTruong V11 Loaded!")
