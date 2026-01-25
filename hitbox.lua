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
    ESPColor = Color3.fromRGB(255, 0, 255),
    Hitbox = false,
    HitboxSize = 25,
    Speed = false,
    SpeedVal = 100
}

local QT_UI = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_NightMystic_Engine"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

function QT_UI:CreateWindow()
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local Sidebar = Instance.new("Frame")
    local SideCorner = Instance.new("UICorner")
    local SideContainer = Instance.new("ScrollingFrame")
    local SideLayout = Instance.new("UIListLayout")
    local PageContainer = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    Main.Position = UDim2.new(0.5, -300, 0.5, -185)
    Main.Size = UDim2.new(0, 600, 0, 370)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    MainStroke.Color = Color3.fromRGB(255, 0, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = Main

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
    Sidebar.Size = UDim2.new(0, 160, 1, 0)

    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = Sidebar

    Title.Parent = Sidebar
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Font = Enum.Font.LuckiestGuy
    Title.Text = "QT HUB"
    Title.TextColor3 = Color3.fromRGB(255, 0, 255)
    Title.TextSize = 25
    Title.BackgroundTransparency = 1

    SideContainer.Parent = Sidebar
    SideContainer.Position = UDim2.new(0, 10, 0, 70)
    SideContainer.Size = UDim2.new(1, -20, 1, -80)
    SideContainer.BackgroundTransparency = 1
    SideContainer.ScrollBarThickness = 0

    SideLayout.Parent = SideContainer
    SideLayout.Padding = UDim.new(0, 8)

    PageContainer.Name = "PageContainer"
    PageContainer.Parent = Main
    PageContainer.Position = UDim2.new(0, 170, 0, 20)
    PageContainer.Size = UDim2.new(1, -185, 1, -40)
    PageContainer.BackgroundTransparency = 1

    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Tabs = {}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")

        TabBtn.Parent = SideContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        TabBtn.TextSize = 14

        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 255)

        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(SideContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 15, 45)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 0, 255)}):Play()
        end)

        local Elements = {}
        function Elements:CreateToggle(text, callback)
            local ToggleFrame = Instance.new("Frame")
            local TCorner = Instance.new("UICorner")
            local TText = Instance.new("TextLabel")
            local TBtn = Instance.new("TextButton")
            local TBtnCorner = Instance.new("UICorner")
            local TDot = Instance.new("Frame")
            local TDotCorner = Instance.new("UICorner")

            ToggleFrame.Parent = Page
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
            TCorner.Parent = ToggleFrame

            TText.Parent = ToggleFrame
            TText.Position = UDim2.new(0, 15, 0, 0)
            TText.Size = UDim2.new(1, -70, 1, 0)
            TText.BackgroundTransparency = 1
            TText.Font = Enum.Font.GothamSemibold
            TText.Text = text
            TText.TextColor3 = Color3.new(1, 1, 1)
            TText.TextSize = 14
            TText.TextXAlignment = Enum.TextXAlignment.Left

            TBtn.Parent = ToggleFrame
            TBtn.Position = UDim2.new(1, -50, 0.5, -10)
            TBtn.Size = UDim2.new(0, 40, 0, 20)
            TBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
            TBtn.Text = ""
            TBtnCorner.CornerRadius = UDim.new(1, 0)
            TBtnCorner.Parent = TBtn

            TDot.Parent = TBtn
            TDot.Position = UDim2.new(0, 2, 0.5, -8)
            TDot.Size = UDim2.new(0, 16, 0, 16)
            TDot.BackgroundColor3 = Color3.new(1, 1, 1)
            TDotCorner.CornerRadius = UDim.new(1, 0)
            TDotCorner.Parent = TDot

            local state = false
            TBtn.MouseButton1Click:Connect(function()
                state = not state
                local targetX = state and 22 or 2
                local targetCol = state and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(50, 40, 60)
                TweenService:Create(TDot, TweenInfo.new(0.2), {Position = UDim2.new(0, targetX, 0.5, -8)}):Play()
                TweenService:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
                callback(state)
            end)
        end

        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            local SCorner = Instance.new("UICorner")
            local SText = Instance.new("TextLabel")
            local SBar = Instance.new("Frame")
            local SBarCorner = Instance.new("UICorner")
            local SFill = Instance.new("Frame")
            local SFillCorner = Instance.new("UICorner")
            local STrigger = Instance.new("TextButton")

            SliderFrame.Parent = Page
            SliderFrame.Size = UDim2.new(1, -10, 0, 55)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
            SCorner.Parent = SliderFrame

            SText.Parent = SliderFrame
            SText.Position = UDim2.new(0, 15, 0, 5)
            SText.Size = UDim2.new(1, -30, 0, 20)
            SText.BackgroundTransparency = 1
            SText.Font = Enum.Font.GothamSemibold
            SText.Text = text .. ": " .. default
            SText.TextColor3 = Color3.new(1, 1, 1)
            SText.TextSize = 14
            SText.TextXAlignment = Enum.TextXAlignment.Left

            SBar.Parent = SliderFrame
            SBar.Position = UDim2.new(0, 15, 0, 35)
            SBar.Size = UDim2.new(1, -30, 0, 6)
            SBar.BackgroundColor3 = Color3.fromRGB(40, 35, 50)
            SBarCorner.Parent = SBar

            SFill.Parent = SBar
            SFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            SFill.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
            SFillCorner.Parent = SFill

            STrigger.Parent = SBar
            STrigger.Size = UDim2.new(1, 0, 1, 0)
            STrigger.BackgroundTransparency = 1
            STrigger.Text = ""

            STrigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local con
                    con = RunService.RenderStepped:Connect(function()
                        local scale = math.clamp((UserInputService:GetMouseLocation().X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (scale * (max - min)))
                        SFill.Size = UDim2.new(scale, 0, 1, 0)
                        SText.Text = text .. ": " .. val
                        callback(val)
                    end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            if con then con:Disconnect() end
                        end
                    end)
                end
            end)
        end
        return Elements
    end
    return Tabs
end

local MainWin = QT_UI:CreateWindow()
local Combat = MainWin:CreateTab("Combat")
local Visuals = MainWin:CreateTab("Visuals")
local Misc = MainWin:CreateTab("Movement")

Combat:CreateToggle("Hitbox Expander", function(v) Config.Hitbox = v end)
Combat:CreateSlider("Hitbox Size", 5, 100, 25, function(v) Config.HitboxSize = v end)

Visuals:CreateToggle("Xray Map", function(v) 
    Config.Xray = v 
    if not v then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
        end
    end
end)
Visuals:CreateSlider("Xray Alpha", 1, 10, 5, function(v) Config.XrayAlpha = v/10 end)
Visuals:CreateToggle("Player ESP", function(v) 
    Config.ESP = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("QT_ESP") then p.Character.QT_ESP:Destroy() end
        end
    end
end)

Misc:CreateToggle("WalkSpeed", function(v) Config.Speed = v end)
Misc:CreateSlider("Speed Value", 16, 500, 100, function(v) Config.SpeedVal = v end)

RunService.RenderStepped:Connect(function()
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
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
            if Config.ESP then
                if not p.Character:FindFirstChild("QT_ESP") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "QT_ESP"
                    hl.FillColor = Config.ESPColor
                end
            end
        end
    end
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end
end)

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0.5, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Toggle.Text = "QT"
Toggle.Font = Enum.Font.LuckiestGuy
Toggle.TextSize = 20
Toggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.MouseButton1Click:Connect(function() ScreenGui.Main.Visible = not ScreenGui.Main.Visible end)

ScreenGui.PageContainer:GetChildren()[1].Visible = true
