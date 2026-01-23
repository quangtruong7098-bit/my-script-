local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local lp = p.LocalPlayer
local m = lp:GetMouse()
local c = workspace.CurrentCamera

local s = {
    sz = 15,
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
f.Size = UDim2.new(0, 220, 0, 320)
f.Position = UDim2.new(0.5, -110, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
f.Visible = false
f.ClipsDescendants = true
f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
local m_stroke = Instance.new("UIStroke", f)
m_stroke.Thickness = 4

local drag, dInput, dStart, sPos
f.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dStart = i.Position
        sPos = f.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
end)
f.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        dInput = i
    end
end)
uis.InputChanged:Connect(function(i)
    if i == dInput and drag then
        local delta = i.Position - dStart
        f.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

local scanline = Instance.new("Frame", f)
scanline.Size = UDim2.new(1, 0, 0, 2)
scanline.BackgroundTransparency = 0.8
scanline.BorderSizePixel = 0

float.MouseButton1Click:Connect(function()
    f.Visible = not f.Visible
end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 50)
t.Text = "NIGHTMARE V7"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = Enum.Font.LuckiestGuy
t.TextSize = 22

local function btn(txt, pos, callback)
    local b = Instance.new("TextButton", f)
    b.Text = txt
    b.Size = UDim2.new(0.85, 0, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
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

btn("HITBOX EXPAND", UDim2.new(0.075, 0, 0.18, 0), function(v) s.hit = v end)
btn("LOCK ON TARGET", UDim2.new(0.075, 0, 0.35, 0), function(v) 
    s.aim = v 
    if v then s.target = getClose() else s.target = nil end
end)
btn("NEON ESP", UDim2.new(0.075, 0, 0.52, 0), function(v) s.esp = v end)

local hf = Instance.new("Frame", f)
hf.Size = UDim2.new(0.85, 0, 0, 50)
hf.Position = UDim2.new(0.075, 0, 0.72, 0)
hf.BackgroundTransparency = 1

local sz_l = Instance.new("TextLabel", hf)
sz_l.Size = UDim2.new(1, 0, 0, 20)
sz_l.Text = "HITBOX SIZE: 15"
sz_l.TextColor3 = Color3.new(1, 1, 1)
sz_l.BackgroundTransparency = 1
sz_l.Font = Enum.Font.GothamBold
sz_l.TextSize = 12

local m_btn = Instance.new("TextButton", hf)
m_btn.Text = "-"
m_btn.Size = UDim2.new(0.3, 0, 0, 30)
m_btn.Position = UDim2.new(0, 0, 0.45, 0)
m_btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
m_btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", m_btn)

local p_btn = Instance.new("TextButton", hf)
p_btn.Text = "+"
p_btn.Size = UDim2.new(0.3, 0, 0, 30)
p_btn.Position = UDim2.new(0.7, 0, 0.45, 0)
p_btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
p_btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", p_btn)

m_btn.MouseButton1Click:Connect(function() s.sz = math.max(1, s.sz - 1) end)
p_btn.MouseButton1Click:Connect(function() s.sz = s.sz + 1 end)

rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_stroke.Color = clr
    m_stroke.Color = clr
    t.TextColor3 = clr
    sz_l.Text = "HITBOX SIZE: " .. s.sz
    scanline.BackgroundColor3 = clr
    scanline.Position = UDim2.new(0, 0, 0, (tick()*120)%f.Size.Y.Offset / f.Size.Y.Offset)
    
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
        c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position)
    end
end)
