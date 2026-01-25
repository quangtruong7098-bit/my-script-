local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Hitbox = false,
    HitboxSize = 25,
    Killaura = false,
    KillauraRange = 25,
    Speed = false,
    SpeedVal = 100,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    ESPName = false,
    Xray = false,
    InfJump = false,
    TargetPlayer = ""
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QT_Supreme"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Position = UDim2.new(0.5, -280, 0.5, -175)
Main.Size = UDim2.new(0, 560, 0, 350)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Thickness = 3
MStroke.Color = Color3.fromRGB(0, 255, 150)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Sidebar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANG TRƯỜNG"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Position = UDim2.new(0, 5, 0, 70)
TabContainer.Size = UDim2.new(1, -10, 1, -80)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 160, 0, 10)
Container.Size = UDim2.new(1, -170, 1, -20)
Container.BackgroundTransparency = 1

local function Drag(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
Drag(Main)

local Tabs = {}
function Tabs:Create(name)
    local B = Instance.new("TextButton", TabContainer)
    B.Size = UDim2.new(1, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    B.Font = Enum.Font.GothamBold
    B.Text = name
    B.TextColor3 = Color3.fromRGB(150, 150, 150)
    B.TextSize = 13
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150); v.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end
        end
        P.Visible = true; B.TextColor3 = Color3.fromRGB(255, 255, 255); B.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    end)

    local El = {}
    function El:AddToggle(text, callback)
        local F = Instance.new("Frame", P)
        F.Size = UDim2.new(1, -5, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
        local L = Instance.new("TextLabel", F)
        L.Size = UDim2.new(1, -60, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.BackgroundTransparency = 1
        L.Font = Enum.Font.GothamSemibold; L.Text = text; L.TextColor3 = Color3.new(1, 1, 1); L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left
        local T = Instance.new("TextButton", F)
        T.Size = UDim2.new(0, 35, 0, 18); T.Position = UDim2.new(1, -45, 0.5, -9); T.BackgroundColor3 = Color3.fromRGB(45, 45, 50); T.Text = ""
        Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
        local D = Instance.new("Frame", T)
        D.Size = UDim2.new(0, 14, 0, 14); D.Position = UDim2.new(0, 2, 0.5, -7); D.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
        local s = false
        T.MouseButton1Click:Connect(function()
            s = not s
            TweenService:Create(D, TweenInfo.new(0.2), {Position = s and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
            TweenService:Create(T, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 50)}):Play()
            callback(s)
        end)
    end
    function El:AddInput(text, callback)
        local F = Instance.new("Frame", P)
        F.Size = UDim2.new(1, -5, 0, 45); F.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
        local L = Instance.new("TextLabel", F)
        L.Size = UDim2.new(0.6, 0, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.BackgroundTransparency = 1
        L.Font = Enum.Font.GothamSemibold; L.Text = text; L.TextColor3 = Color3.new(1, 1, 1); L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left
        local Box = Instance.new("TextBox", F)
        Box.Size = UDim2.new(0, 80, 0, 28); Box.Position = UDim2.new(1, -90, 0.5, -14); Box.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Box.Font = Enum.Font.GothamBold
        Box.TextColor3 = Color3.fromRGB(0, 255, 150); Box.TextSize = 13; Box.Text = ""; Box.PlaceholderText = "..."
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
        Box.FocusLost:Connect(function() callback(Box.Text) end)
    end
    function El:AddButton(text, callback)
        local B = Instance.new("TextButton", P)
        B.Size = UDim2.new(1, -5, 0, 35); B.BackgroundColor3 = Color3.fromRGB(0, 80, 50); B.Font = Enum.Font.GothamBold; B.Text = text; B.TextColor3 = Color3.new(1, 1, 1); B.TextSize = 13
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6); B.MouseButton1Click:Connect(callback)
    end
    return El
end

local P1 = Tabs:Create("Combat"); local P2 = Tabs:Create("Visual"); local P3 = Tabs:Create("Movement"); local P4 = Tabs:Create("Teleport")

P1:AddToggle("Hitbox Expander", function(v) 
    Config.Hitbox = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1); p.Character.HumanoidRootPart.Transparency = 1; p.Character.HumanoidRootPart.Massless = false
            end
        end
    end
end)
P1:AddInput("Hitbox Size", function(v) Config.HitboxSize = tonumber(v) or 25 end)
P1:AddToggle("Killaura", function(v) Config.Killaura = v end)

P2:AddToggle("Highlight", function(v) Config.ESP = v end)
P2:AddToggle("Names", function(v) Config.ESPName = v end)

P3:AddToggle("Speed Hack", function(v) Config.Speed = v end)
P3:AddInput("Speed Value", function(v) Config.SpeedVal = tonumber(v) or 100 end)
P3:AddToggle("Fly Mobile", function(v) Config.Fly = v end)
P3:AddToggle("Inf Jump", function(v) Config.InfJump = v end)

P4:AddInput("Player Name", function(v) Config.TargetPlayer = v end)
P4:AddButton("Teleport", function()
    if Config.TargetPlayer ~= "" then
        for _, p in pairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), string.lower(Config.TargetPlayer)) or string.find(string.lower(p.DisplayName), string.lower(Config.TargetPlayer)) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character.Humanoid
        hrp.Velocity = Vector3.new(0, 0, 0)
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 25))
        end
    end

    if Config.Killaura and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Config.KillauraRange then
                        tool:Activate()
                    end
                end
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Hitbox then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.8; hrp.CanCollide = false; hrp.Massless = true; hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
            if Config.ESP and not p.Character:FindFirstChild("QT_H") then
                local h = Instance.new("Highlight", p.Character); h.Name = "QT_H"; h.FillColor = Color3.fromRGB(0, 255, 150)
            end
            if Config.ESPName and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("QT_N") then
                local b = Instance.new("BillboardGui", p.Character.Head); b.Name = "QT_N"; b.Size = UDim2.new(0, 100, 0, 30); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 3, 0)
                local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamBold; t.TextColor3 = Color3.new(1, 1, 1); t.TextSize = 12; t.Text = p.DisplayName
            end
        end
    end
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(3) end
end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 10, 0.4, 0); OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18); OpenBtn.Text = "QT"; OpenBtn.Font = Enum.Font.LuckiestGuy; OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150); OpenBtn.TextSize = 22
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OStroke = Instance.new("UIStroke", OpenBtn); OStroke.Thickness = 2; OStroke.Color = Color3.fromRGB(0, 255, 150)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Container:GetChildren()[1].Visible = true
