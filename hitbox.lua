local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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
    InfJump = false,
    TargetPlayer = ""
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QT_Supreme_Final"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Position = UDim2.new(0.5, -280, 0.5, -175)
Main.Size = UDim2.new(0, 560, 0, 350)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Thickness = 2
MStroke.Color = Color3.fromRGB(0, 255, 150)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "QUANG TRƯỜNG"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Position = UDim2.new(0, 5, 0, 60)
TabContainer.Size = UDim2.new(1, -10, 1, -70)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 150, 0, 10)
Container.Size = UDim2.new(1, -160, 1, -20)
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
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    B.Font = Enum.Font.GothamBold
    B.Text = name
    B.TextColor3 = Color3.fromRGB(150, 150, 150)
    B.TextSize = 12
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150); v.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
        end
        P.Visible = true; B.TextColor3 = Color3.new(1, 1, 1); B.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    end)
    local El = {}
    function El:AddToggle(text, callback)
        local F = Instance.new("Frame", P); F.Size = UDim2.new(1, -5, 0, 38); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -60, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.BackgroundTransparency = 1; L.Font = Enum.Font.GothamSemibold; L.Text = text; L.TextColor3 = Color3.new(1, 1, 1); L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left
        local T = Instance.new("TextButton", F); T.Size = UDim2.new(0, 30, 0, 16); T.Position = UDim2.new(1, -40, 0.5, -8); T.BackgroundColor3 = Color3.fromRGB(40, 40, 40); T.Text = ""
        Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
        local D = Instance.new("Frame", T); D.Size = UDim2.new(0, 12, 0, 12); D.Position = UDim2.new(0, 2, 0.5, -6); D.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
        local s = false
        T.MouseButton1Click:Connect(function()
            s = not s
            TweenService:Create(D, TweenInfo.new(0.1), {Position = s and UDim2.new(0, 16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
            TweenService:Create(T, TweenInfo.new(0.1), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 40)}):Play()
            callback(s)
        end)
    end
    function El:AddInput(text, callback)
        local F = Instance.new("Frame", P); F.Size = UDim2.new(1, -5, 0, 40); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(0.6, 0, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.BackgroundTransparency = 1; L.Font = Enum.Font.GothamSemibold; L.Text = text; L.TextColor3 = Color3.new(1, 1, 1); L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left
        local Box = Instance.new("TextBox", F); Box.Size = UDim2.new(0, 70, 0, 24); Box.Position = UDim2.new(1, -80, 0.5, -12); Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Box.Font = Enum.Font.GothamBold; Box.TextColor3 = Color3.new(1, 1, 1); Box.TextSize = 12; Box.Text = ""; Box.PlaceholderText = "..."
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4); Box.FocusLost:Connect(function() callback(Box.Text) end)
    end
    function El:AddButton(text, callback)
        local B = Instance.new("TextButton", P); B.Size = UDim2.new(1, -5, 0, 32); B.BackgroundColor3 = Color3.fromRGB(30, 30, 30); B.Font = Enum.Font.GothamBold; B.Text = text; B.TextColor3 = Color3.new(1, 1, 1); B.TextSize = 12; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4); B.MouseButton1Click:Connect(callback)
    end
    return El
end

local P1 = Tabs:Create("Combat"); local P2 = Tabs:Create("Visual"); local P3 = Tabs:Create("Movement")

P1:AddToggle("Hitbox (No Push)", function(v) Config.Hitbox = v end)
P1:AddInput("Hitbox Size", function(v) Config.HitboxSize = tonumber(v) or 25 end)
P1:AddToggle("Killaura (High Speed)", function(v) Config.Killaura = v end)
P1:AddInput("Aura Range", function(v) Config.KillauraRange = tonumber(v) or 25 end)

P2:AddToggle("ESP Highlight", function(v) Config.ESP = v end)
P2:AddToggle("ESP Names", function(v) Config.ESPName = v end)

P3:AddToggle("Speed", function(v) Config.Speed = v end)
P3:AddInput("Speed Val", function(v) Config.SpeedVal = tonumber(v) or 100 end)
P3:AddToggle("Fly Mobile", function(v) Config.Fly = v end)
P3:AddInput("Fly Speed", function(v) Config.FlySpeed = tonumber(v) or 50 end)

task.spawn(function()
    while true do
        task.wait()
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude <= Config.KillauraRange then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.CanCollide = false
                hrp.CanTouch = true
                hrp.Massless = true
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.Velocity = Vector3.zero
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hrp.Velocity = Vector3.zero
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 15))
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.ESP and not p.Character:FindFirstChild("QT_H") then
                local h = Instance.new("Highlight", p.Character); h.Name = "QT_H"; h.FillColor = Color3.fromRGB(0, 255, 150)
            elseif not Config.ESP and p.Character:FindFirstChild("QT_H") then
                p.Character.QT_H:Destroy()
            end
        end
    end

    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end
end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45); OpenBtn.Position = UDim2.new(0, 10, 0.4, 0); OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10); OpenBtn.Text = "QT"; OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150); OpenBtn.TextSize = 16
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OStroke = Instance.new("UIStroke", OpenBtn); OStroke.Thickness = 2; OStroke.Color = Color3.fromRGB(0, 255, 150)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Container:GetChildren()[1].Visible = true
