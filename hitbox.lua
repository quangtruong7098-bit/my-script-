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
    InfJump = false
}

--// UI SYSTEM //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 420)
Main.Position = UDim2.new(0.5, -175, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 150)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
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
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function() Config[cfg_key] = tonumber(box.Text) or def end)
end

--// ADD CONTROLS //--
AddToggle("Noclip (Xuyên Tường)", "Noclip")
AddToggle("Hitbox (Ghost Mode)", "Hitbox")
AddInput("Size Hitbox", "HitboxSize", 25)
AddToggle("Killaura (Chém Liên Tục)", "Killaura")
AddInput("Tầm Chém", "KillauraRange", 25)
AddToggle("Speed (Tốc Độ)", "Speed")
AddInput("Số Tốc Độ", "SpeedVal", 100)
AddToggle("Bay (Fly)", "Fly")
AddToggle("Hiện ESP", "ESP")

--// LOGIC FIX TRIỆT ĐỂ //--

-- 1. Noclip & Local Physics (Chỉ tác động lên bản thân để không văng)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if Config.Noclip then
                    v.CanCollide = false
                else
                    -- Luôn tắt va chạm vũ khí để tránh bị đẩy khi hitbox to chạm vào tool
                    if v.Parent:IsA("Tool") or v.Name == "Handle" then
                        v.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- 2. Hitbox Expansion (Phương pháp tối ưu - Không đóng băng người chơi)
task.spawn(function()
    while task.wait(0.5) do -- Giảm tần suất cập nhật để tránh Freeze vật lý
        if Config.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    -- Chỉ thay đổi thuộc tính tối thiểu
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.8
                    hrp.CanCollide = false
                    hrp.Massless = true
                    -- TUYỆT ĐỐI không can thiệp vào Velocity hay CFrame của đối thủ ở đây
                end
            end
        end
    end
end)

-- 3. Killaura (Đánh liên tục và hiệu quả)
task.spawn(function()
    while task.wait(0.05) do -- Tốc độ đánh mượt
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local root = p.Character.HumanoidRootPart
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        
                        -- Chém dựa trên vùng ảo (Range)
                        if dist <= Config.KillauraRange or dist <= (Config.HitboxSize/2) then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

-- 4. Các tính năng khác
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
    -- ESP
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("QT_ESP") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "QT_ESP"; hl.FillColor = Color3.fromRGB(0, 255, 150)
            end
        end
    end
end)
