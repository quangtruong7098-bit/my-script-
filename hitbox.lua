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
    Noclip = false,
    ESP = false
}

--// UI //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 420)
Main.Position = UDim2.new(0.5, -175, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- Nút ẩn/hiện
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.Text = "QT"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// UI HELPERS //--
local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(30, 30, 30)
        
        -- Xóa ESP ngay lập tức nếu tắt
        if cfg_key == "ESP" and not Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("QT_ESP") then
                    p.Character.QT_ESP:Destroy()
                end
            end
        end
    end)
end

local function AddInput(text, cfg_key, def)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, 0, 0, 35)
    box.PlaceholderText = text .. " [" .. def .. "]"
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function() Config[cfg_key] = tonumber(box.Text) or def end)
end

--// CONTROLS //--
AddToggle("Hiện Người Chơi (ESP)", "ESP")
AddToggle("Hitbox (Ghost Mode)", "Hitbox")
AddInput("Size Hitbox", "HitboxSize", 25)
AddToggle("Tự Đánh (Killaura)", "Killaura")
AddInput("Tầm Chém", "KillauraRange", 25)
AddToggle("Chạy Nhanh", "Speed")
AddInput("Tốc Độ", "SpeedVal", 100)
AddToggle("Xuyên Tường (Noclip)", "Noclip")
AddToggle("Bay (Fly)", "Fly")

--// LOGIC CHUẨN //--

-- 1. Xử lý ESP (Chạy riêng để không lag)
task.spawn(function()
    while task.wait(0.5) do
        if Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    if not p.Character:FindFirstChild("QT_ESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "QT_ESP"
                        hl.Parent = p.Character
                        hl.FillColor = Color3.fromRGB(0, 255, 150)
                        hl.OutlineColor = Color3.new(1, 1, 1)
                    end
                end
            end
        end
    end
end)

-- 2. Xử lý Hitbox & Noclip (Stepped tối ưu)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if Config.Noclip then
                    v.CanCollide = false
                elseif v.Parent:IsA("Tool") or v.Name == "Handle" then
                    v.CanCollide = false -- Chống văng khi cầm tool
                end
            end
        end
    end

    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
            end
        end
    end
end)

-- 3. Killaura & Speed & Fly
RunService.Heartbeat:Connect(function()
    -- Speed
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end
    
    -- Fly
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 20))
        end
    end

    -- Killaura
    if Config.Killaura and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d <= Config.KillauraRange or d <= (Config.HitboxSize/2) then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)
