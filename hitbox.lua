local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local lp = p.LocalPlayer
local m = lp:GetMouse()
local c = workspace.CurrentCamera

local s = {
    sz = 15,
    spd = 2,
    hit = false,
    aim = false,
    esp = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

local float = Instance.new("TextButton", g)
float.Size = UDim2.new(0, 60, 0, 60)
float.Position = UDim2.new(0.1, 0, 0.1, 0)
float.Text = "VIP"
float.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
float.TextColor3 = Color3.new(1, 1, 1)
float.Font = Enum.Font.SpecialElite
float.TextSize = 22
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local f_stroke = Instance.new("UIStroke", float)
f_stroke.Thickness = 3
f_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 200, 0, 240)
f.Position = UDim2.new(0.5, -100, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.Visible = false
f.ClipsDescendants = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
local m_stroke = Instance.new("UIStroke", f)
m_stroke.Thickness = 2

local grad = Instance.new("UIGradient", f)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
})

float.MouseButton1Click:Connect(function()
    f.Visible = not f.Visible
end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 45)
t.Text = "RAINBOW HUB V5"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = Enum.Font.GothamBold
t.TextSize = 18

local function btn(txt, pos, callback)
    local b = Instance.new("TextButton", f)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.85, 0, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = false
    b.MouseButton1Click:Connect(function()
        st = not st
        b.Text = txt .. (st and ": ON" or ": OFF")
        b.BackgroundColor3 = st and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(30, 30, 30)
        callback(st)
    end)
    return b
end

local function getClose()
    local target = nil
    local dist = 250
    for _, plr in pairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = c:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if vis then
                local m_pos = Vector2.new(c.ViewportSize.X/2, c.ViewportSize.Y/2)
                local mag = (Vector2.new(pos.X, pos.Y) - m_pos).Magnitude
                if mag < dist then
                    target = plr.Character.HumanoidRootPart
                    dist = mag
                end
            end
        end
    end
    return target
end

local b1 = btn("Hitbox", UDim2.new(0.075, 0, 0.25, 0), function(v) s.hit = v end)
local b2 = btn("Aimbot Lock", UDim2.new(0.075, 0, 0.46, 0), function(v) 
    s.aim = v 
    if v then s.target = getClose() else s.target = nil end
end)
local b3 = btn("ESP Glow", UDim2.new(0.075, 0, 0.67, 0), function(v) s.esp = v end)

rs.RenderStepped:Connect(function()
    local hue = tick()/s.spd%1
    local clr = Color3.fromHSV(hue, 1, 1)
    
    f_stroke.Color = clr
    m_stroke.Color = clr
    t.TextColor3 = clr
    grad.Rotation = (grad.Rotation + 1) % 360

    for _, plr in pairs(p:GetPlayers()) do
        pcall(function()
            if plr ~= lp and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if s.hit then
                        hrp.Size = Vector3.new(s.sz, s.sz, s.sz)
                        hrp.Color = clr
                        hrp.Transparency = 0.7
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                end
                
                local hi = plr.Character:FindFirstChild("Highlight")
                if s.esp then
                    if not hi then hi = Instance.new("Highlight", plr.Character) end
                    hi.FillColor = clr
                    hi.OutlineColor = Color3.new(1, 1, 1)
                    hi.FillTransparency = 0.4
                elseif hi then
                    hi:Destroy()
                end
            end
        end)
    end

    if s.aim and s.target and s.target.Parent then
        c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position)
    end
end)
