local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local HitboxToggle = Instance.new("TextButton", Main)
local AimbotToggle = Instance.new("TextButton", Main)
local SizeInput = Instance.new("TextBox", Main)

Main.Size = UDim2.new(0, 200, 0, 180)
Main.Position = UDim2.new(0.5, -100, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "MULTI-HACK VIP"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

HitboxToggle.Size = UDim2.new(0.9, 0, 0, 30)
HitboxToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
HitboxToggle.Text = "Hitbox: OFF"
HitboxToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
HitboxToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", HitboxToggle)

AimbotToggle.Size = UDim2.new(0.9, 0, 0, 30)
AimbotToggle.Position = UDim2.new(0.05, 0, 0.45, 0)
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
AimbotToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AimbotToggle)

SizeInput.Size = UDim2.new(0.9, 0, 0, 30)
SizeInput.Position = UDim2.new(0.05, 0, 0.65, 0)
SizeInput.PlaceholderText = "Hitbox Size"
SizeInput.Text = "15"
SizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SizeInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SizeInput)

local HitboxEnabled = false
local AimbotEnabled = false
local HitboxSize = 15

HitboxToggle.MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    HitboxToggle.Text = HitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
    HitboxToggle.BackgroundColor3 = HitboxEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    AimbotToggle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

SizeInput.FocusLost:Connect(function()
    HitboxSize = tonumber(SizeInput.Text) or 15
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local lp = game:GetService("Players").LocalPlayer
    local mouse = lp:GetMouse()
    local closestPlr = nil
    local shortestDist = math.huge

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            
            -- Logic Hitbox
            if HitboxEnabled then
                hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end

            -- Logic Aimbot (Tìm mục tiêu gần tâm chuột nhất)
            if AimbotEnabled then
                local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if dist < shortestDist then
                        closestPlr = hrp
                        shortestDist = dist
                    end
                end
            end
        end
    end

    if AimbotEnabled and closestPlr then
        game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closestPlr.Position)
    end
end)
