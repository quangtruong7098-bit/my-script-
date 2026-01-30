local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

--// CẤU HÌNH AN TOÀN (ANTI-KICK) //--
local Config = {
    Hitbox = false,
    HitboxSize = 7, -- KHÔNG CHỈNH QUÁ 10 ĐỂ TRÁNH BỊ KICK
    Killaura = false,
    AutoBlock = false,
    AntiRagdoll = false, -- Nên tắt nếu vẫn bị kick
    Speed = false,
    SpeedVal = 26 -- Tốc độ an toàn (Mặc định là 16)
}

--// GIAO DIỆN V18 BYPASS //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "QT_V18_Bypass"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 100, 0) -- Màu Cam cảnh báo
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "JJS V18 - ANTI KICK"
Title.TextColor3 = Color3.fromRGB(255, 150, 50)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

-- Nút Ẩn/Hiện
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.Text = "V18"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 0)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

AddToggle("Hitbox An Toàn (Size 7)", "Hitbox")
AddToggle("Tự Đỡ (Auto Block)", "AutoBlock")
AddToggle("Tự Đánh (Killaura)", "Killaura")
AddToggle("Speed An Toàn (26)", "Speed")
AddToggle("Chống Té (Anti-Ragdoll)", "AntiRagdoll")

--// LOGIC BYPASS (CHỐNG PHÁT HIỆN) //--

-- 1. Hitbox Logic (Sử dụng PostSimulation để ghi đè sau khi game check)
RunService.PostSimulation:Connect(function()
    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Chỉ chỉnh transparency và size ở mức thấp
                    if hrp.Size.X ~= Config.HitboxSize then
                        hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    end
                end
            end
        end
    else
        -- Reset ngay khi tắt để tránh lỗi
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character.HumanoidRootPart.Size.X > 2 then
                   p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                   p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

-- 2. Speed Logic (Chỉ set 1 lần mỗi giây để tránh spam)
task.spawn(function()
    while task.wait(0.5) do
        if Config.Speed and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum.WalkSpeed ~= Config.SpeedVal then
                hum.WalkSpeed = Config.SpeedVal
            end
        end
    end
end)

-- 3. Auto Block & Killaura (Giữ nguyên logic nhưng giảm tốc độ click)
task.spawn(function()
    while task.wait(0.1) do
        if Config.Killaura and LocalPlayer.Character then
             local found = false
             for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < 15 then found = true break end
                end
            end
            if found then
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end
        
        -- Auto Block Check
        if Config.AutoBlock and LocalPlayer.Character then
             local close = false
             for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < 15 then close = true break end
                end
            end
            if close then
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            else
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end
end)

-- 4. Anti Ragdoll (Cẩn thận, tính năng này dễ bị kick nhất)
RunService.Stepped:Connect(function()
    if Config.AntiRagdoll and LocalPlayer.Character then
         local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
         if hum and (hum:GetState() == Enum.HumanoidStateType.Ragdoll) then
             hum:ChangeState(Enum.HumanoidStateType.GettingUp)
         end
    end
end)
