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
    Noclip = false, -- Chức năng mới
    ESP = false,
    InfJump = false
}

--// UI SYSTEM //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "QT_Supreme_V6_Final"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 380)
Main.Position = UDim2.new(0.5, -200, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Thickness = 2
MStroke.Color = Color3.fromRGB(0, 255, 150)

-- Nút QT Ẩn/Hiện Menu
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
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 5)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "QUANG TRƯỜNG HUB V6"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

--// UI HELPER FUNCTIONS //--
local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = "  " .. text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(30, 30, 30)
    end)
end

local function AddInput(text, cfg_key, default_val)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(1, -5, 0, 35); frame.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", frame)
    L.Size = UDim2.new(0.6, 0, 1, 0); L.Text = "  " .. text; L.TextColor3 = Color3.new(0.8, 0.8, 0.8); L.Font = Enum.Font.Gotham; L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left; L.BackgroundTransparency = 1
    local txt = Instance.new("TextBox", frame)
    txt.Size = UDim2.new(0.3, 0, 0.8, 0); txt.Position = UDim2.new(0.7, -5, 0.1, 0); txt.BackgroundColor3 = Color3.fromRGB(25, 25, 25); txt.Text = tostring(default_val); txt.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", txt)
    txt.FocusLost:Connect(function() Config[cfg_key] = tonumber(txt.Text) or Config[cfg_key] end)
end

--// ADDING CONTROLS //--
AddToggle("Đi Xuyên Tường (Noclip)", "Noclip")
AddToggle("Mở Rộng Hitbox (1000 Max)", "Hitbox")
AddInput("Size Hitbox", "HitboxSize", 25)
AddToggle("Tự Đánh Liên Tục (Killaura)", "Killaura")
AddInput("Tầm Đánh", "KillauraRange", 25)
AddToggle("Chạy Nhanh", "Speed")
AddInput("Tốc độ", "SpeedVal", 100)
AddToggle("Bay (Fly)", "Fly")
AddToggle("Hiện Người (ESP)", "ESP")
AddToggle("Nhảy Vô Hạn", "InfJump")

--// CORE LOGIC //--

-- Noclip & Hitbox Physics (Stepped xử lý vật lý)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        -- Xử lý Noclip
        if Config.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
        
        -- Chống văng vật lý (Luôn chạy cho nhân vật & vũ khí)
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and not Config.Noclip then -- Chỉ can thiệp CanCollide nếu không bật Noclip
                v.CanCollide = false 
            end
        end
    end

    -- Hitbox Expand
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

-- Speed, Fly, ESP (Heartbeat xử lý frame)
RunService.Heartbeat:Connect(function()
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end

    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        if LocalPlayer.Character:FindFirstChild("Humanoid").MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 20))
        end
    end

    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("QT_HL") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "QT_HL"; hl.FillColor = Color3.fromRGB(0, 255, 150)
            end
        end
    end
end)

-- Killaura Fix (Đánh liên tục)
task.spawn(function()
    while task.wait() do -- Tốc độ lặp cực nhanh
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= Config.KillauraRange then
                            -- Giải pháp đánh liên tục: Activate nhiều lần
                            tool:Activate()
                            -- Một số game cần lệnh này để chém nhanh hơn
                            pcall(function() tool:Hit(p.Character.HumanoidRootPart) end)
                        end
                    end
                end
            end
        end
    end
end)

-- Jump Request
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end)

-- Drag System
local dragging, dragStart, startPos
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
