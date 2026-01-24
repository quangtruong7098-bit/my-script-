local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    Visuals = {
        ESP_Box = false,
        ESP_Name = false,
        ESP_Tracer = false,
        ESP_Health = false,
        ESP_Distance = false,
        ESP_Skeletons = false,
        ESP_Color = Color3.fromRGB(180, 0, 255),
        FieldOfView = 70,
        FullBright = false
    },
    Combat = {
        HitboxEnabled = false,
        HitboxSize = 25,
        HitboxPart = "Head",
        HitboxTransparency = 0.5,
        HitboxColor = Color3.fromRGB(180, 0, 255),
        Aimbot = false,
        AimPart = "Head",
        AimSmooth = 0.2,
        AimRadius = 150,
        ShowFOV = false
    },
    Movement = {
        WalkSpeed = 16,
        SpeedEnabled = false,
        Fly = false,
        FlySpeed = 150,
        Noclip = false,
        InfiniteJump = false,
        JumpPower = 50
    },
    Misc = {
        AntiAFK = true,
        FPSBoost = false,
        AutoRejoin = false
    }
}

local Library = {}
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "QuangTruong_GodHub_Supreme"
ScreenGui.ResetOnSpawn = false

local function Corner(obj, radius)
    local uic = Instance.new("UICorner", obj)
    uic.CornerRadius = UDim.new(0, radius or 10)
    return uic
end

local function Stroke(obj, color, thickness)
    local uis = Instance.new("UIStroke", obj)
    uis.Color = color or Color3.fromRGB(180, 0, 255)
    uis.Thickness = thickness or 1.8
    uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return uis
end

function Library:Notify(title, text, time)
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.Size = UDim2.new(0, 280, 0, 70)
    NotifFrame.Position = UDim2.new(1, 10, 0.85, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Corner(NotifFrame, 8)
    Stroke(NotifFrame)
    local T = Instance.new("TextLabel", NotifFrame)
    T.Size = UDim2.new(1, -10, 0.4, 0); T.Position = UDim2.new(0, 10, 0, 5)
    T.Text = title; T.TextColor3 = Color3.fromRGB(180, 0, 255); T.Font = "GothamBold"
    T.BackgroundTransparency = 1; T.TextSize = 14; T.TextXAlignment = "Left"
    local D = Instance.new("TextLabel", NotifFrame)
    D.Size = UDim2.new(1, -10, 0.5, 0); D.Position = UDim2.new(0, 10, 0.4, 0)
    D.Text = text; D.TextColor3 = Color3.new(1, 1, 1); D.Font = "Gotham"
    D.BackgroundTransparency = 1; D.TextSize = 12; D.TextXAlignment = "Left"; D.TextWrapped = true
    NotifFrame:TweenPosition(UDim2.new(1, -290, 0.85, 0), "Out", "Quart", 0.4)
    task.delay(time or 3, function()
        NotifFrame:TweenPosition(UDim2.new(1, 10, 0.85, 0), "In", "Quart", 0.4)
        task.wait(0.5); NotifFrame:Destroy()
    end)
end

function Library:CreateWindow(title)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 620, 0, 450)
    Main.Position = UDim2.new(0.5, -310, 0.5, -225)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Corner(Main, 15)
    Stroke(Main)
    local dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position; startPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStart = nil end
    end)
    local SideBar = Instance.new("Frame", Main)
    SideBar.Size = UDim2.new(0, 170, 1, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Corner(SideBar, 15)
    local Logo = Instance.new("TextLabel", SideBar)
    Logo.Size = UDim2.new(1, 0, 0, 70)
    Logo.Text = title; Logo.TextColor3 = Color3.fromRGB(180, 0, 255); Logo.Font = "GothamBold"; Logo.TextSize = 22; Logo.BackgroundTransparency = 1
    local TabContainer = Instance.new("ScrollingFrame", SideBar)
    TabContainer.Size = UDim2.new(1, 0, 1, -80); TabContainer.Position = UDim2.new(0, 0, 0, 75); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -185, 1, -20); Container.Position = UDim2.new(0, 180, 0, 10); Container.BackgroundTransparency = 1
    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60); ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255); ToggleBtn.Text = "QT"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = "LuckiestGuy"; ToggleBtn.TextSize = 28; Corner(ToggleBtn, 50); Stroke(ToggleBtn, Color3.new(1,1,1), 2)
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
    local Tabs = {}
    function Tabs:AddTab(name)
        local TBtn = Instance.new("TextButton", TabContainer)
        TBtn.Size = UDim2.new(0.9, 0, 0, 42); TBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28); TBtn.Text = name; TBtn.TextColor3 = Color3.new(0.7,0.7,0.7); TBtn.Font = "GothamBold"; Corner(TBtn, 8)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12)
        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(22, 22, 28) end end
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        end)
        local Elements = {}
        function Elements:AddToggle(text, callback)
            local Box = Instance.new("Frame", Page); Box.Size = UDim2.new(0.96, 0, 0, 50); Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Corner(Box, 8)
            local Lbl = Instance.new("TextLabel", Box); Lbl.Size = UDim2.new(1, -60, 1, 0); Lbl.Position = UDim2.new(0, 15, 0, 0); Lbl.Text = text; Lbl.TextColor3 = Color3.new(1,1,1); Lbl.Font = "GothamSemibold"; Lbl.TextSize = 14; Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1
            local Btn = Instance.new("TextButton", Box); Btn.Size = UDim2.new(0, 45, 0, 24); Btn.Position = UDim2.new(1, -60, 0.5, -12); Btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15); Btn.Text = ""; Corner(Btn, 12)
            local Circle = Instance.new("Frame", Btn); Circle.Size = UDim2.new(0, 18, 0, 18); Circle.Position = UDim2.new(0, 3, 0.5, -9); Circle.BackgroundColor3 = Color3.new(1,1,1); Corner(Circle, 10)
            local state = false
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Circle:TweenPosition(state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), "Out", "Quart", 0.3)
                Btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 255) or Color3.new(0.15, 0.15, 0.15)
                callback(state)
            end)
        end
        function Elements:AddSlider(text, min, max, def, callback)
            local SBox = Instance.new("Frame", Page); SBox.Size = UDim2.new(0.96, 0, 0, 75); SBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Corner(SBox, 8)
            local SLbl = Instance.new("TextLabel", SBox); SLbl.Size = UDim2.new(1, -20, 0, 35); SLbl.Position = UDim2.new(0, 15, 0, 5); SLbl.Text = text .. ": " .. def; SLbl.TextColor3 = Color3.new(1,1,1); SLbl.Font = "GothamSemibold"; SLbl.BackgroundTransparency = 1; SLbl.TextXAlignment = "Left"
            local Bar = Instance.new("Frame", SBox); Bar.Size = UDim2.new(0.9, 0, 0, 8); Bar.Position = UDim2.new(0.05, 0, 0.75, 0); Bar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1); Corner(Bar, 5)
            local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255); Corner(Fill, 5)
            local InputBtn = Instance.new("TextButton", Bar); InputBtn.Size = UDim2.new(1, 0, 1, 0); InputBtn.BackgroundTransparency = 1; InputBtn.Text = ""
            InputBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            local scale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(scale, 0, 1, 0)
                            local val = math.floor(min + (max-min)*scale)
                            SLbl.Text = text .. ": " .. val
                            callback(val)
                        end
                    end)
                    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
                end
            end)
        end
        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page); Btn.Size = UDim2.new(0.96, 0, 0, 45); Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45); Btn.Text = text; Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = "GothamBold"; Btn.TextSize = 14; Corner(Btn, 8); Btn.MouseButton1Click:Connect(callback)
        end
        return Elements
    end
    return Tabs
end

local Win = Library:CreateWindow("QT ULTRA V5")
local Combat = Win:AddTab("COMBAT")
local Visuals = Win:AddTab("VISUALS")
local Movement = Win:AddTab("MOVEMENT")
local Misc = Win:AddTab("MISC")

Combat:AddToggle("God Hitbox", function(v) Config.Combat.HitboxEnabled = v end)
Combat:AddSlider("Size", 1, 800, 25, function(v) Config.Combat.HitboxSize = v end)
Combat:AddSlider("Transparency", 0, 10, 5, function(v) Config.Combat.HitboxTransparency = v/10 end)
Combat:AddToggle("Aimbot Lock", function(v) Config.Combat.Aimbot = v end)
Combat:AddSlider("Aim Radius", 10, 1000, 150, function(v) Config.Combat.AimRadius = v end)

Visuals:AddToggle("ESP Box VIP", function(v) Config.Visuals.ESP_Box = v end)
Visuals:AddToggle("ESP Names", function(v) Config.Visuals.ESP_Name = v end)
Visuals:AddToggle("ESP Tracers", function(v) Config.Visuals.ESP_Tracer = v end)
Visuals:AddToggle("ESP Health", function(v) Config.Visuals.ESP_Health = v end)
Visuals:AddToggle("Full Bright", function(v) Config.Visuals.FullBright = v end)

Movement:AddToggle("Fly Mode", function(v) Config.Movement.Fly = v end)
Movement:AddSlider("Fly Speed", 50, 1000, 150, function(v) Config.Movement.FlySpeed = v end)
Movement:AddToggle("WalkSpeed Hack", function(v) Config.Movement.SpeedEnabled = v end)
Movement:AddSlider("Speed", 16, 500, 16, function(v) Config.Movement.WalkSpeed = v end)
Movement:AddToggle("Noclip", function(v) Config.Movement.Noclip = v end)
Movement:AddToggle("Infinite Jump", function(v) Config.Movement.InfiniteJump = v end)

Misc:AddToggle("Anti AFK", function(v) Config.Misc.AntiAFK = v end)
Misc:AddButton("FPS Boost", function()
    for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end
    Library:Notify("FPS Boost", "Graphics optimized!")
end)

local function DrawESP(p)
    local Box = Drawing.new("Square"); Box.Thickness = 1.5; Box.Filled = false; Box.Transparency = 1
    local TLine = Drawing.new("Line"); TLine.Thickness = 1; TLine.Transparency = 1
    local Name = Drawing.new("Text"); Name.Size = 14; Name.Center = true; Name.Outline = true
    local Health = Drawing.new("Line"); Health.Thickness = 2
    
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer and p.Character:FindFirstChild("Humanoid") then
            local pos, screen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if screen and Config.Visuals.ESP_Box then
                local size = 1500 / pos.Z
                Box.Visible = true; Box.Size = Vector2.new(size, size * 1.5); Box.Position = Vector2.new(pos.X - size/2, pos.Y - size/1.5); Box.Color = Config.Visuals.ESP_Color
                if Config.Visuals.ESP_Tracer then TLine.Visible = true; TLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); TLine.To = Vector2.new(pos.X, pos.Y); TLine.Color = Config.Visuals.ESP_Color else TLine.Visible = false end
                if Config.Visuals.ESP_Name then Name.Visible = true; Name.Text = p.Name; Name.Position = Vector2.new(pos.X, pos.Y - size/1.5 - 15); Name.Color = Color3.new(1,1,1) else Name.Visible = false end
                if Config.Visuals.ESP_Health then
                    Health.Visible = true; Health.From = Vector2.new(pos.X - size/2 - 5, pos.Y + size/1.5); Health.To = Vector2.new(pos.X - size/2 - 5, pos.Y + size/1.5 - (size*1.5 * p.Character.Humanoid.Health/p.Character.Humanoid.MaxHealth)); Health.Color = Color3.new(0,1,0)
                else Health.Visible = false end
            else Box.Visible = false; TLine.Visible = false; Name.Visible = false; Health.Visible = false end
        else Box.Visible = false; TLine.Visible = false; Name.Visible = false; Health.Visible = false end
    end)
end

for _, p in pairs(Players:GetPlayers()) do DrawESP(p) end
Players.PlayerAdded:Connect(DrawESP)

RunService.RenderStepped:Connect(function()
    if Config.Visuals.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        if Config.Movement.SpeedEnabled then LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.WalkSpeed end
        if Config.Movement.Fly then
            if not HRP:FindFirstChild("QT_V5_Fly") then
                local bv = Instance.new("BodyVelocity", HRP); bv.Name = "QT_V5_Fly"; bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                local bg = Instance.new("BodyGyro", HRP); bg.Name = "QT_V5_Gyro"; bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
            end
            HRP.QT_V5_Gyro.CFrame = Camera.CFrame
            HRP.QT_V5_Fly.Velocity = (Camera.CFrame.LookVector * LocalPlayer.Character.Humanoid.MoveDirection.Magnitude * Config.Movement.FlySpeed)
        else
            if HRP:FindFirstChild("QT_V5_Fly") then HRP.QT_V5_Fly:Destroy() end
            if HRP:FindFirstChild("QT_V5_Gyro") then HRP.QT_V5_Gyro:Destroy() end
        end
        if Config.Movement.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hit = plr.Character:FindFirstChild(Config.Combat.HitboxPart)
            if Config.Combat.HitboxEnabled and hit then
                hit.Size = Vector3.new(Config.Combat.HitboxSize, Config.Combat.HitboxSize, Config.Combat.HitboxSize)
                hit.Transparency = Config.Combat.HitboxTransparency; hit.Color = Config.Combat.HitboxColor; hit.Material = "ForceField"; hit.CanCollide = false
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfiniteJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

LocalPlayer.Idled:Connect(function() if Config.Misc.AntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

Library:Notify("QuangTruong V5", "Supreme Hub Loaded Successfully!", 5)
