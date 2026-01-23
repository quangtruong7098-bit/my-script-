local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Settings = {
    HitboxSize = 12,
    RainbowSpeed = 3,
    HitboxTransparency = 0.5,
    AimbotEnabled = true,
    HitboxEnabled = true,
    ESPEnabled = true
}

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 150)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "RAINBOW HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromHSV(tick()%5/5, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Title).CornerRadius = UDim(0, 10)

RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV(tick()/Settings.RainbowSpeed % 1, 1, 1)
end)

local function createToggle(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text = name .. ": ON"
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim(0, 5)
    
    local enabled = true
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(80, 20, 20)
        callback(enabled)
    end)
end

createToggle("Hitbox", UDim2.new(0.05, 0, 0.3, 0), function(v) Settings.HitboxEnabled = v end)
createToggle("Aimbot", UDim2.new(0.05, 0, 0.55, 0), function(v) Settings.AimbotEnabled = v end)
createToggle("ESP", UDim2.new(0.05, 0, 0.8, 0), function(v) Settings.ESPEnabled = v end)

local function getClosest()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    target = p.Character.HumanoidRootPart
                    dist = mag
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local hue = tick() / Settings.RainbowSpeed % 1
    local currentRainbowColor = Color3.fromHSV(hue, 1, 1)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            if hrp and hum then
                if Settings.HitboxEnabled then
                    hrp.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    hrp.Transparency = Settings.HitboxTransparency
                    hrp.Color = currentRainbowColor
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end

                local highlight = p.Character:FindFirstChild("Highlight")
                if Settings.ESPEnabled then
                    if not highlight then
                        highlight = Instance.new("Highlight", p.Character)
                    end
                    highlight.FillColor = currentRainbowColor
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                elseif highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    if Settings.AimbotEnabled then
        local target = getClosest()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.L then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
