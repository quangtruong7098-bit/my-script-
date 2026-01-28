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
    ESP = false,
    InfJump = false -- Chức năng mới thêm lại
}

--// UI SETUP //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "QT_V12_InfJump"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 480) -- Tăng chiều dài để chứa đủ nút
Main.Position = UDim2.new(0.5, -175, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 80)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "QUANG TRƯỜNG V12 (INF JUMP)"
Title.TextColor3 = Color3.fromRGB(255, 0, 80)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

-- Nút QT Ẩn/Hiện
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.Text = "QT"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 80)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local TStroke = Instance.new("UIStroke", ToggleBtn)
TStroke.Color = Color3.fromRGB(255, 0, 80)
TStroke.Thickness = 2
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// UI FUNCTION //--
local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(30, 30, 30)
    end)
end

local function AddInput(text, cfg_key, def)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, 0, 0, 38)
    box.PlaceholderText = text .. " (Mặc định: " .. def .. ")"
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function() Config[cfg_key] = tonumber(box.Text) or def end)
end

--// LIST CHỨC NĂNG //--
AddToggle("Nhảy Vô Hạn (Inf Jump)", "InfJump") -- Mới thêm
AddToggle("Bay (Fly)", "Fly")
AddToggle("Xuyên Tường (Noclip)", "Noclip")
AddToggle("Hitbox (Đầu To)", "Hitbox")
AddInput("Size Hitbox", "HitboxSize", 20)
AddToggle("Killaura (Tự Đánh)", "Killaura")
AddInput("Tầm Đánh", "KillauraRange", 25)
AddToggle("Chạy Nhanh (Speed)", "Speed")
AddInput("Tốc Độ", "SpeedVal", 100)
AddToggle("ESP (Hiện Người)", "ESP")

--// LOGIC XỬ LÝ (CORE) //--

-- 1. Infinite Jump (Xử lý nhảy vô hạn)
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            -- Ép trạng thái nhảy liên tục dù đang ở trên không
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 2. Vòng lặp chính (RenderStepped)
RunService.RenderStepped:Connect(function()
    -- Xử lý ESP (Tắt là xóa ngay)
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("QT_ESP") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "QT_ESP"
                hl.FillColor = Color3.fromRGB(255, 0, 80)
                hl.OutlineColor = Color3.new(1, 1, 1)
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("QT_ESP") then
                p.Character.QT_ESP:Destroy()
            end
        end
    end

    -- Xử lý Hitbox (Head Expand)
    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Character.Head.Transparency = 0.7
                p.Character.Head.CanCollide = false
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if p.Character.Head.Size.X > 5 then
                    p.Character.Head.Size = Vector3.new(1.2, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end

    -- Xử lý Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if Config.Speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
        else
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end

    -- Xử lý Noclip
    if LocalPlayer.Character then
        if Config.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        else
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CanCollide = true
            end
        end
        -- Luôn tắt va chạm Tool
        local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then
            for _, v in pairs(t:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
    
    -- Xử lý Fly
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (Config.FlySpeed / 20))
        end
    end
end)

-- 3. Killaura Loop
task.spawn(function()
    while task.wait(0.05) do
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude
                        if d <= Config.KillauraRange or d <= Config.HitboxSize then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)
