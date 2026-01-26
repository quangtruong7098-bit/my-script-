local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Hitbox = false,
    HitboxSize = 25,
    Killaura = false,
    KillauraRange = 25,
    Speed = false,
    SpeedVal = 100
}

--// UI GỌN NHẸ //--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "QT_HyperHitbox"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "QUANG TRƯỜNG - MAX 1000"
Title.TextColor3 = Color3.new(0, 1, 0.6)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

--// LOGIC CHỐNG VĂNG (ANTI-FLING 100%) //--
-- Hàm này cực kỳ quan trọng để bạn không bị đẩy đi khi chỉnh size 1000
local function DisableCollision(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanTouch = false -- Tắt va chạm chạm (Touch) để không kích hoạt vật lý phản lực
        end
    end
end

-- Vòng lặp cưỡng bức vật lý
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        -- Vô hiệu hóa va chạm của chính mình và vũ khí
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end

    if Config.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                
                -- Ép thông số hitbox
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false -- Tắt va chạm tuyệt đối
                hrp.Massless = true    -- Không có trọng lượng
                hrp.Velocity = Vector3.zero -- Triệt tiêu lực quán tính
                hrp.RotVelocity = Vector3.zero
            end
        end
    end
end)

--// KILLAURA (TỐI ƯU TỐC ĐỘ) //--
task.spawn(function()
    while task.wait() do
        if Config.Killaura and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= Config.KillauraRange then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

--// UI COMPONENTS //--
local function AddToggle(name, cfg_key)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 50 + (40 * (#Main:GetChildren() - 2)))
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Config[cfg_key] = not Config[cfg_key]
        btn.Text = name .. ": " .. (Config[cfg_key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[cfg_key] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 40)
    end)
end

local function AddInput(name, cfg_key)
    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, 0, 50 + (40 * (#Main:GetChildren() - 2)))
    box.PlaceholderText = name
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        Config[cfg_key] = tonumber(box.Text) or Config[cfg_key]
    end)
end

AddToggle("Hitbox Expander", "Hitbox")
AddInput("Hitbox Size (Max 1000)", "HitboxSize")
AddToggle("Killaura", "Killaura")
AddInput("Killaura Range", "KillauraRange")
AddToggle("Speed Hack", "Speed")

-- Speed Loop
RunService.Heartbeat:Connect(function()
    if Config.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.SpeedVal
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
