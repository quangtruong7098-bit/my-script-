local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local lp = p.LocalPlayer
local m = lp:GetMouse()
local c = workspace.CurrentCamera

local s = {
    sz = 16,
    spd = 1.5,
    hit = false,
    aim = false,
    esp = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

local float = Instance.new("TextButton", g)
float.Size = UDim2.new(0, 65, 0, 65)
float.Position = UDim2.new(0.05, 0, 0.2, 0)
float.Text = "✧"
float.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
float.TextColor3 = Color3.new(1, 1, 1)
float.TextSize = 35
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local f_stroke = Instance.new("UIStroke", float)
f_stroke.Thickness = 3

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 220, 0, 280)
f.Position = UDim2.new(0.5, -110, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
f.Visible = false
f.ClipsDescendants = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
local m_stroke = Instance.new("UIStroke", f)
m_stroke.Thickness = 4

local scanline = Instance.new("Frame", f)
scanline.Size = UDim2.new(1, 0, 0, 2)
scanline.BackgroundColor3 = Color3.new(1, 1, 1)
scanline.BackgroundTransparency = 0.8
scanline.BorderSizePixel = 0

float.MouseButton1Click:Connect(function()
    f.Visible = not f.Visible
    if f.Visible then
        f:TweenSize(UDim2.new(0, 220, 0, 280), "Out", "Back", 0.3, true)
    end
end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 50)
t.Text = "NIGHTMARE V6"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = Enum.Font.LuckiestGuy
t.TextSize = 22

local function btn(txt, pos, callback)
    local b = Instance.new("TextButton", f)
    b.Text = txt
    b.Size = UDim2.new(0.85, 0, 0, 45)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local st = false
    b.MouseButton1Click:Connect(function()
        st = not st
        callback(st)
        ts:Create(b, TweenInfo.new(0.3), {
            BackgroundColor3 = st and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(20, 20, 20),
            TextColor3 = st and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
        }):Play()
    end)
end

local function getClose()
    local target = nil
    local dist = 300
    for _, plr in pairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = c:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(c.ViewportSize.X/2, c.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    target = plr.Character.HumanoidRootPart
                    dist = mag
                end
            end
        end
    end
    return target
end

btn("HITBOX EXPAND", UDim2.new(0.075, 0, 0.22, 0), function(v) s.hit = v end)
btn("LOCK ON TARGET", UDim2.new(0.075, 0, 0.43, 0), function(v) 
    s.aim = v 
    if v then s.target = getClose() else s.target = nil end
end)
btn("NEON ESP", UDim2.new(0.075, 0, 0.64, 0), function(v) s.esp = v end)

rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_stroke.Color = clr
    m_stroke.Color = clr
    t.TextColor3 = clr
    scanline.BackgroundColor3 = clr
    scanline.Position = UDim2.new(0, 0, 0, (tick()*100)%f.Size.Y.Offset / f.Size.Y.Offset)
    
    local pulse = 1 + math.sin(tick()*5)*0.05
    float.Size = UDim2.new(0, 60*pulse, 0, 60*pulse)

    for _, plr in pairs(p:GetPlayers()) do
        pcall(function()
            if plr ~= lp and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if s.hit then
                        hrp.Size = Vector3.new(s.sz, s.sz, s.sz)
                        hrp.Color = clr
                        hrp.Transparency = 0.8
                        hrp.Material = Enum.Material.Neon
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
                elseif hi then hi:Destroy() end
            end
        end)
    end

    if s.aim and s.target and s.target.Parent then
        c.CFrame = ts:Create(c, TweenInfo.new(0.1), {CFrame = CFrame.new(c.CFrame.Position, s.target.Position)}):Play()
        c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position)
    end
end)
