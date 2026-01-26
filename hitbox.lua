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

--// UI GỌN NHẸ //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 420)
Main.Position = UDim2.new(0.5, -175, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

AddToggle("Hiện Người Chơi (ESP)", "ESP")
AddToggle("Mở Rộng Hitbox (Fix Đứng Im)", "Hitbox")
AddInput("Size Hitbox", "HitboxSize", 25)
AddToggle("Tự Đánh (Killaura)", "Killaura")
AddInput("Tầm Chém", "KillauraRange", 25)
AddToggle("Chạy Nhanh", "Speed")
AddInput("Tốc Độ", "SpeedVal", 100)
AddToggle("Xuyên Tường", "Noclip")

--// LOGIC V10 - FIX ĐỨNG IM //--

-- 1. Hitbox System (Chỉ thay đổi Head để không lỗi vật lý di chuyển)
task.spawn(function()
    while task.wait(0.5) do
        if Config.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local head = p.Character.Head
                    head.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    head.Transparency = 0.7
                    head.BrickColor = BrickColor.new("Bright blue")
                    head.CanCollide = false -- Tắt va chạm để không văng
                    head.Massless = true
                end
            end
        else
            -- Reset về mặc định khi tắt
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(2, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end
end)

-- 2. ESP & Killaura & Speed (Heartbeat mượt mà)
RunService.Heartbeat:Connect(function()
    -- ESP
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("QT_ESP") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "QT_ESP"
                hl.FillColor = Color3.fromRGB(0, 255, 150)
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("QT_ESP") then p.Character.QT_ESP:Destroy() end
        end
    end

    -- Speed
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end

    -- Killaura (Đánh dựa trên Head đã phóng to)
    if Config.Killaura and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude
                    if d <= Config.KillauraRange or d <= (Config.HitboxSize/1.5) then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- 3. Noclip (Xử lý vật lý Stepped)
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- Chống văng khi cầm Tool
    if LocalPlayer.Character then
        local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then
            for _, v in pairs(t:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)
