local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
    InfJump = false
}

--// UI SYSTEM //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "QT_Supreme_V4"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Thickness = 2
MStroke.Color = Color3.fromRGB(0, 255, 150)

-- Nút Ẩn/Hiện (Toggle Button)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "QT"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local TStroke = Instance.new("UIStroke", ToggleBtn)
TStroke.Thickness = 2
TStroke.Color = Color3.fromRGB(0, 255, 150)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Sidebar Tabs
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(0, 100, 1, 0)
TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", TabFrame)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -110, 1, -20)
Container.Position = UDim2.new(0, 105, 0, 10)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 5)

--// FUNCTIONS //--
local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(30, 30, 30)
    end)
end

local function AddInput(text, cfg_key)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(1, -5, 0, 35)
    frame.BackgroundTransparency = 1
    
    local txt = Instance.new("TextBox", frame)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    txt.PlaceholderText = text
    txt.Text = ""
    txt.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", txt)
    txt.FocusLost:Connect(function()
        Config[cfg_key] = tonumber(txt.Text) or Config[cfg_key]
    end)
end

--// UI CONTENT //--
AddToggle("Hitbox Expander", "Hitbox")
AddInput("Hitbox Size (Max 1000)", "HitboxSize")
AddToggle("Killaura (Auto Attack)", "Killaura")
AddInput("Aura Range", "KillauraRange")
AddToggle("ESP Highlight", "ESP")
AddToggle("Speed Hack", "Speed")
AddInput("Speed Value", "SpeedVal")
AddToggle("Fly Mobile", "Fly")
AddInput("Fly Speed", "FlySpeed")
AddToggle("Infinite Jump", "InfJump")

--// CORE LOGIC //--

-- Anti-Fling & Hitbox Logic
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        -- Vô hiệu hóa va chạm tool để không bị văng khi cầm vũ khí
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
                hrp.Massless = true
                hrp.Velocity = Vector3.zero
            end
        end
    end
end)

-- Fly & Speed & ESP Logic
RunService.Heartbeat:Connect(function()
    -- Speed
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end

    -- Fly
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        hrp.Velocity = Vector3.zero
        if hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 20))
        end
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Config.ESP and not p.Character:FindFirstChild("QT_HL") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "QT_HL"
                hl.FillColor = Color3.fromRGB(0, 255, 150)
            elseif not Config.ESP and p.Character:FindFirstChild("QT_HL") then
                p.Character.QT_HL:Destroy()
            end
        end
    end
end)

-- Killaura Loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= Config.KillauraRange then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end)

-- Drag UI
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
