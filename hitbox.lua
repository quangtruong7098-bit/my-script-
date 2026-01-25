local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Hitbox = false,
    HitboxSize = 25,
    Speed = false,
    SpeedVal = 100,
    Jump = false,
    JumpVal = 50,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    ESPName = false,
    Xray = false,
    XrayAlpha = 0.5,
    FullBright = false,
    InfJump = false,
    TargetPlayer = nil
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_Supreme"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function CreateMainUI()
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local Sidebar = Instance.new("Frame")
    local SideContainer = Instance.new("ScrollingFrame")
    local SideLayout = Instance.new("UIListLayout")
    local PageContainer = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(13, 10, 20)
    Main.Position = UDim2.new(0.5, -310, 0.5, -190)
    Main.Size = UDim2.new(0, 620, 0, 380)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = Main
    MainStroke.Color = Color3.fromRGB(190, 0, 255)
    MainStroke.Thickness = 3
    MainStroke.Parent = Main

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(7, 5, 12)
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 16)

    Title.Parent = Sidebar
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.Font = Enum.Font.LuckiestGuy
    Title.Text = "QUANG TRƯỜNG"
    Title.TextColor3 = Color3.fromRGB(220, 0, 255)
    Title.TextSize = 24
    Title.BackgroundTransparency = 1

    SideContainer.Parent = Sidebar
    SideContainer.Position = UDim2.new(0, 10, 0, 80)
    SideContainer.Size = UDim2.new(1, -20, 1, -90)
    SideContainer.BackgroundTransparency = 1
    SideContainer.ScrollBarThickness = 0
    SideLayout.Parent = SideContainer
    SideLayout.Padding = UDim.new(0, 12)

    PageContainer.Name = "PageContainer"
    PageContainer.Parent = Main
    PageContainer.Position = UDim2.new(0, 185, 0, 25)
    PageContainer.Size = UDim2.new(1, -200, 1, -50)
    PageContainer.BackgroundTransparency = 1

    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local Tabs = {}
    function Tabs:AddTab(name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")

        TabBtn.Parent = SideContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 18, 45)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(190, 0, 255)
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 15)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(SideContainer:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.new(0.6, 0.6, 0.6) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
        end)

        local Elements = {}
        function Elements:AddToggle(text, callback)
            local F = Instance.new("Frame", Page)
            F.Size = UDim2.new(1, -10, 0, 45)
            F.BackgroundColor3 = Color3.fromRGB(22, 18, 35)
            Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)
            
            local L = Instance.new("TextLabel", F)
            L.Size = UDim2.new(1, -70, 1, 0)
            L.Position = UDim2.new(0, 15, 0, 0)
            L.BackgroundTransparency = 1
            L.Font = Enum.Font.GothamSemibold
            L.Text = text
            L.TextColor3 = Color3.new(1, 1, 1)
            L.TextSize = 14
            L.TextXAlignment = Enum.TextXAlignment.Left

            local B = Instance.new("TextButton", F)
            B.Position = UDim2.new(1, -50, 0.5, -11)
            B.Size = UDim2.new(0, 40, 0, 22)
            B.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            B.Text = ""
            Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

            local D = Instance.new("Frame", B)
            D.Size = UDim2.new(0, 18, 0, 18)
            D.Position = UDim2.new(0, 2, 0.5, -9)
            D.BackgroundColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)

            local s = false
            B.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(D, TweenInfo.new(0.25), {Position = s and UDim2.new(0, 20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                TweenService:Create(B, TweenInfo.new(0.25), {BackgroundColor3 = s and Color3.fromRGB(190, 0, 255) or Color3.fromRGB(50, 50, 65)}):Play()
                callback(s)
            end)
        end

        function Elements:AddInput(text, callback)
            local F = Instance.new("Frame", Page)
            F.Size = UDim2.new(1, -10, 0, 50)
            F.BackgroundColor3 = Color3.fromRGB(22, 18, 35)
            Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)

            local L = Instance.new("TextLabel", F)
            L.Size = UDim2.new(0.6, 0, 1, 0)
            L.Position = UDim2.new(0, 15, 0, 0)
            L.BackgroundTransparency = 1
            L.Font = Enum.Font.GothamSemibold
            L.Text = text
            L.TextColor3 = Color3.new(1, 1, 1)
            L.TextSize = 14
            L.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", F)
            Box.Size = UDim2.new(0, 80, 0, 32)
            Box.Position = UDim2.new(1, -95, 0.5, -16)
            Box.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
            Box.Font = Enum.Font.GothamBold
            Box.Text = ""
            Box.PlaceholderText = "Nhập..."
            Box.TextColor3 = Color3.new(1, 1, 1)
            Box.TextSize = 13
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)

            Box.FocusLost:Connect(function()
                callback(Box.Text)
            end)
        end

        function Elements:AddButton(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 45)
            B.BackgroundColor3 = Color3.fromRGB(40, 20, 70)
            B.Font = Enum.Font.GothamBold
            B.Text = text
            B.TextColor3 = Color3.new(1, 1, 1)
            B.TextSize = 14
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
            B.MouseButton1Click:Connect(callback)
        end

        return Elements
    end
    return Tabs
end

local Tabs = CreateMainUI()
local Combat = Tabs:AddTab("Combat")
local Visuals = Tabs:AddTab("Visuals")
local Movement = Tabs:AddTab("Movement")
local Teleport = Tabs:AddTab("Teleport")

Combat:AddToggle("Hitbox Expander", function(v) 
    Config.Hitbox = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)
Combat:AddInput("Hitbox Size", function(v) Config.HitboxSize = tonumber(v) or 25 end)

Visuals:AddToggle("ESP Chams", function(v) 
    Config.ESP = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("QT_Cham") then p.Character.QT_Cham:Destroy() end
        end
    end
end)
Visuals:AddToggle("ESP Tên Người Chơi", function(v) 
    Config.ESPName = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("QT_NameTag") then
                p.Character.Head.QT_NameTag:Destroy()
            end
        end
    end
end)
Visuals:AddToggle("Xray Nhìn Xuyên Bản Đồ", function(v) 
    Config.Xray = v 
    if not v then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
        end
    end
end)
Visuals:AddToggle("FullBright Siêu Sáng", function(v) 
    Config.FullBright = v 
    if not v then Lighting.Brightness = 1 Lighting.ClockTime = 14 end
end)

Movement:AddToggle("WalkSpeed (Tốc Độ)", function(v) Config.Speed = v end)
Movement:AddInput("Tốc Độ Chạy", function(v) Config.SpeedVal = tonumber(v) or 16 end)
Movement:AddToggle("Nhảy Vô Hạn", function(v) Config.InfJump = v end)
Movement:AddToggle("Chế Độ Bay", function(v) Config.Fly = v end)
Movement:AddInput("Tốc Độ Bay", function(v) Config.FlySpeed = tonumber(v) or 50 end)

Teleport:AddInput("Tên Người Chơi (Cần bay đến)", function(v) Config.TargetPlayer = v end)
Teleport:AddButton("Dịch Chuyển Ngay", function()
    if Config.TargetPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), string.lower(Config.TargetPlayer)) or string.find(string.lower(p.DisplayName), string.lower(Config.TargetPlayer)) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.FullBright then Lighting.Brightness = 2 Lighting.ClockTime = 14 end
    
    if Config.Xray then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p:IsDescendantOf(LocalPlayer.Character) and not p.Parent:FindFirstChild("Humanoid") then
                p.LocalTransparencyModifier = Config.XrayAlpha
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Hitbox and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = 0.6
                hrp.CanCollide = false
            end
            
            if Config.ESP and not p.Character:FindFirstChild("QT_Cham") then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "QT_Cham"
                h.FillColor = Color3.fromRGB(190, 0, 255)
            end

            if Config.ESPName and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("QT_NameTag") then
                    local bg = Instance.new("BillboardGui", p.Character.Head)
                    bg.Name = "QT_NameTag"
                    bg.Size = UDim2.new(0, 100, 0, 50)
                    bg.StudsOffset = Vector3.new(0, 3, 0)
                    bg.AlwaysOnTop = true
                    local tl = Instance.new("TextLabel", bg)
                    tl.BackgroundTransparency = 1
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.Font = Enum.Font.GothamBold
                    tl.TextColor3 = Color3.new(1, 1, 1)
                    tl.TextSize = 14
                    tl.Text = p.DisplayName
                end
            end
        end
    end

    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end
    
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -Config.FlySpeed/10) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, Config.FlySpeed/10) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then hrp.CFrame = hrp.CFrame * CFrame.new(0, Config.FlySpeed/10, 0) end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local ToggleMain = Instance.new("TextButton", ScreenGui)
ToggleMain.Size = UDim2.new(0, 55, 0, 55)
ToggleMain.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMain.BackgroundColor3 = Color3.fromRGB(190, 0, 255)
ToggleMain.Text = "QT"
ToggleMain.Font = Enum.Font.LuckiestGuy
ToggleMain.TextColor3 = Color3.new(1, 1, 1)
ToggleMain.TextSize = 22
Instance.new("UICorner", ToggleMain).CornerRadius = UDim.new(1, 0)
ToggleMain.MouseButton1Click:Connect(function() ScreenGui.Main.Visible = not ScreenGui.Main.Visible end)

ScreenGui.Main.PageContainer:GetChildren()[1].Visible = true
