local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Hitbox = false,
    HitboxSize = 15,
    Killaura = false,
    AutoBlock = false,
    AntiRagdoll = false,
    Speed = false,
    SpeedVal = 85,
    RefreshRate = 0 -- 0 nghĩa là nhanh nhất có thể (Hyper Loop)
}

--// UI SYSTEM (V17 HYPER) //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 200) -- Màu Neon Cyan cho bản Hyper
Stroke.Thickness = 2

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.Text = "V17"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 40)
ToggleBtn.TextColor3 = Color3.new(0, 1, 1)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function AddToggle(text, cfg_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = text .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(20, 25, 30)
    end)
end

AddToggle("Quét Hitbox 300Hz (Fix đứng im)", "Hitbox")
AddToggle("Auto Block (Siêu nhạy)", "AutoBlock")
AddToggle("Killaura (Tự đấm)", "Killaura")
AddToggle("Chống Té (Anti-Ragdoll)", "AntiRagdoll")
AddToggle("Tăng tốc chạy", "Speed")

--// CORE HYPER LOGIC //--

-- 1. Vòng lặp siêu cao tần (300Hz Loop) cho Hitbox
task.spawn(function()
    while true do
        if Config.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    -- Quét mọi bộ phận để đảm bảo không bị sót khi character load lại
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local head = p.Character:FindFirstChild("Head")
                    
                    if hrp then
                        hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        hrp.Transparency = 0.8
                        hrp.CanCollide = false
                    end
                    
                    if head then
                        head.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        head.Transparency = 0.9
                        head.CanCollide = false
                    end
                end
            end
        end
        -- Không dùng task.wait() để đạt tốc độ tối đa, hoặc dùng wait cực nhỏ
        RunService.Heartbeat:Wait() 
    end
end)

-- 2. Anti-Ragdoll (Ép trạng thái liên tục)
RunService.Stepped:Connect(function()
    if Config.AntiRagdoll and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            -- Nếu bị văng hoặc ngã, ép đứng dậy ngay trong 1/60 giây
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum.PlatformStand then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- 3. Auto Block (Quét khoảng cách gần)
local isB = false
task.spawn(function()
    while task.wait(0.05) do -- Quét block mỗi 0.05s
        if Config.AutoBlock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local enemyNear = false
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 18 then
                        enemyNear = true
                        break
                    end
                end
            end
            
            if enemyNear and not isB then
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                isB = true
            elseif not enemyNear and isB then
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                isB = false
            end
        end
    end
end)

-- 4. Speed & Killaura
RunService.RenderStepped:Connect(function()
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
    end

    if Config.Killaura and LocalPlayer.Character then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < 18 then
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.01)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end
end)
