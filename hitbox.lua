local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Xray = false,
    XrayAlpha = 0.5,
    ESP = false,
    ESPName = false,
    ESPColor = Color3.fromRGB(255, 0, 255),
    Hitbox = false,
    HitboxSize = 25,
    Speed = false,
    SpeedVal = 100
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QT_Supreme_V2"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function CreateUI()
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
    Main.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
    Main.Position = UDim2.new(0.5, -280, 0.5, -170)
    Main.Size = UDim2.new(0, 560, 0, 340)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main
    MainStroke.Color = Color3.fromRGB(200, 0, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = Main

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)

    Title.Parent = Sidebar
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.LuckiestGuy
    Title.Text = "TITAN V2"
    Title.TextColor3 = Color3.fromRGB(255, 0, 255)
    Title.TextSize = 24
    Title.BackgroundTransparency = 1

    SideContainer.Parent = Sidebar
    SideContainer.Position = UDim2.new(0, 10, 0, 60)
    SideContainer.Size = UDim2.new(1, -20, 1, -70)
    SideContainer.BackgroundTransparency = 1
    SideContainer.ScrollBarThickness = 0
    SideLayout.Parent = SideContainer
    SideLayout.Padding = UDim.new(0, 8)

    PageContainer.Name = "PageContainer"
    PageContainer.Parent = Main
    PageContainer.Position = UDim2.new(0, 160, 0, 15)
    PageContainer.Size = UDim2.new(1, -175, 1, -30)
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
    function Tabs:NewTab(name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")

        TabBtn.Parent = SideContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 10)

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
            local Frame = Instance.new("Frame")
            local Btn = Instance.new("TextButton")
            local Dot = Instance.new("Frame")
            Frame.Parent = Page
            Frame.Size = UDim2.new(1, -5, 0, 35)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = Frame
            Lbl.Size = UDim2.new(1, -50, 1, 0)
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.Text = text
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            Btn.Parent = Frame
            Btn.Position = UDim2.new(1, -40, 0.5, -8)
            Btn.Size = UDim2.new(0, 32, 0, 16)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
            Btn.Text = ""
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

            Dot.Parent = Btn
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Dot.Position = UDim2.new(0, 2, 0.5, -6)
            Dot.BackgroundColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local s = false
            Btn.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = s and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(45, 40, 50)}):Play()
                callback(s)
            end)
        end

        function Elements:AddInput(text, placeholder, callback)
            local Frame = Instance.new("Frame")
            Frame.Parent = Page
            Frame.Size = UDim2.new(1, -5, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = Frame
            Lbl.Size = UDim2.new(0.6, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.Text = text
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox")
            Box.Parent = Frame
            Box.Size = UDim2.new(0, 80, 0, 24)
            Box.Position = UDim2.new(1, -90, 0.5, -12)
            Box.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
            Box.Font = Enum.Font.GothamBold
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Color3.new(1, 1, 1)
            Box.TextSize = 12
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

            Box.FocusLost:Connect(function()
                callback(Box.Text)
            end)
        end
        return Elements
    end
    return Tabs
end

local Tabs = CreateUI()
local MainTabs = Tabs:NewTab("Main")
local VisTabs = Tabs:NewTab("Visuals")

MainTabs:AddToggle("Enable Hitbox", function(v) 
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
MainTabs:AddInput("Hitbox Size", "Số (Vd: 20)", function(v) Config.HitboxSize = tonumber(v) or 25 end)

MainTabs:AddToggle("Enable Speed", function(v) Config.Speed = v end)
MainTabs:AddInput("Walk Speed", "Số (Vd: 100)", function(v) Config.SpeedVal = tonumber(v) or 16 end)

VisTabs:AddToggle("Chams (Highlight)", function(v) 
    Config.ESP = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("QT_Cham") then p.Character.QT_Cham:Destroy() end
        end
    end
end)
VisTabs:AddToggle("ESP Name (Tên)", function(v) 
    Config.ESPName = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("QT_NameTag") then
                p.Character.Head.QT_NameTag:Destroy()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.Hitbox and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.6
                p.Character.HumanoidRootPart.CanCollide = false
                p.Character.HumanoidRootPart.Color = Config.ESPColor
            end
            
            if Config.ESP then
                if not p.Character:FindFirstChild("QT_Cham") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "QT_Cham"
                    h.FillColor = Config.ESPColor
                end
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
                    tl.TextStrokeTransparency = 0
                    tl.TextSize = 14
                    tl.Text = p.Name
                end
            end
        end
    end
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end
end)

local Tgl = Instance.new("TextButton", ScreenGui)
Tgl.Size = UDim2.new(0, 45, 0, 45)
Tgl.Position = UDim2.new(0, 15, 0.4, 0)
Tgl.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
Tgl.Text = "QT"
Tgl.Font = Enum.Font.LuckiestGuy
Tgl.TextColor3 = Color3.new(1, 1, 1)
Tgl.TextSize = 18
Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)
Tgl.MouseButton1Click:Connect(function() ScreenGui.Main.Visible = not ScreenGui.Main.Visible end)

ScreenGui.Main.PageContainer:GetChildren()[1].Visible = true
