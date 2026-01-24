local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local lp = p.LocalPlayer
local m = lp:GetMouse()
local c = workspace.CurrentCamera

local s = {
    sz = 15,
    spd = 1.2,
    hit = false,
    aim = false,
    esp = false,
    fly = false,
    f_spd = 150,
    speed = 16,
    jump = 50,
    infj = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

local float = Instance.new("TextButton", g)
float.Size = UDim2.new(0, 60, 0, 60)
float.Position = UDim2.new(0.1, 0, 0.2, 0)
float.Text = "QT"
float.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
float.TextColor3 = Color3.new(1, 1, 1)
float.TextSize = 25
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local f_s = Instance.new("UIStroke", float)
f_s.Thickness = 3

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 220, 0, 420)
f.Position = UDim2.new(0.5, -110, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
f.Visible = false
f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
local m_s = Instance.new("UIStroke", f)
m_s.Thickness = 4

local dragging, dragInput, dragStart, startPos
f.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = f.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
f.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        dragInput = i
    end
end)
uis.InputChanged:Connect(function(i)
    if i == dragInput and dragging then
        local delta = i.Position - dragStart
        f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

float.MouseButton1Click:Connect(function()
    f.Visible = not f.Visible
end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 50)
t.Text = "quangtruonghaik13"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = Enum.Font.LuckiestGuy
t.TextSize = 20

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, 0, 0.85, 0)
sc.Position = UDim2.new(0, 0, 0.12, 0)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 1.5, 0)
sc.ScrollBarTransparency = 1

local lyt = Instance.new("UIListLayout", sc)
lyt.HorizontalAlignment = Enum.HorizontalAlignment.Center
lyt.Padding = UDim.new(0, 10)

local function btn(txt, callback)
    local b = Instance.new("TextButton", sc)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.85, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = false
    b.MouseButton1Click:Connect(function()
        st = not st
        b.Text = txt .. (st and ": ON" or ": OFF")
        callback(st)
        ts:Create(b, TweenInfo.new(0.3), {
            BackgroundColor3 = st and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(20, 20, 20),
            TextColor3 = st and Color3.new(1, 1, 1) or Color3.new(0.6, 0.6, 0.6)
        }):Play()
    end)
end

btn("Hitbox Expand", function(v) s.hit = v end)
btn("Lock On Aim", function(v) 
    s.aim = v 
    if v then
        local target = nil
        local dist = 300
        for _, plr in pairs(p:GetPlayers()) do
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = c:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(c.ViewportSize.X/2, c.ViewportSize.Y/2)).Magnitude
                    if mag < dist then target = plr.Character.HumanoidRootPart dist = mag end
                end
            end
        end
        s.target = target
    else s.target = nil end
end)
btn("Neon ESP", function(v) s.esp = v end)
btn("Fly Mode", function(v) s.fly = v end)
btn("Speed Hack", function(v) s.speed = v and 100 or 16 end)
btn("Jump Hack", function(v) s.jump = v and 150 or 50 end)
btn("Inf Jump", function(v) s.infj = v end)

local h_f = Instance.new("Frame", sc)
h_f.Size = UDim2.new(0.85, 0, 0, 60)
h_f.BackgroundTransparency = 1
local sz_l = Instance.new("TextLabel", h_f)
sz_l.Size = UDim2.new(1, 0, 0, 25)
sz_l.Text = "HITBOX SIZE: 15"
sz_l.TextColor3 = Color3.new(1, 1, 1)
sz_l.BackgroundTransparency = 1
sz_l.Font = Enum.Font.GothamBold
sz_l.TextSize = 13
local m_b = Instance.new("TextButton", h_f)
m_b.Text = "-"
m_b.Size = UDim2.new(0.35, 0, 0, 35)
m_b.Position = UDim2.new(0, 0, 0.45, 0)
m_b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
m_b.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", m_b)
local p_b = Instance.new("TextButton", h_f)
p_b.Text = "+"
p_b.Size = UDim2.new(0.35, 0, 0, 35)
p_b.Position = UDim2.new(0.65, 0, 0.45, 0)
p_b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
p_b.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", p_b)
m_b.MouseButton1Click:Connect(function() s.sz = math.max(1, s.sz - 5) end)
p_b.MouseButton1Click:Connect(function() s.sz = s.sz + 5 end)

uis.JumpRequest:Connect(function()
    if s.infj and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local bv, bg
rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_s.Color = clr
    m_s.Color = clr
    t.TextColor3 = clr
    sz_l.Text = "HITBOX SIZE: " .. s.sz
    sz_l.TextColor3 = clr
    float.Size = UDim2.new(0, 60 + math.sin(tick()*5)*3, 0, 60 + math.sin(tick()*5)*3)

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = s.speed
        lp.Character.Humanoid.JumpPower = s.jump
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if s.fly then
                if not hrp:FindFirstChild("FlyBV") then
                    bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                end
                hrp.FlyBG.CFrame = c.CFrame
                local dir = lp.Character.Humanoid.MoveDirection
                hrp.FlyBV.Velocity = (c.CFrame.LookVector * (dir.Z < 0 and s.f_spd or dir.Z > 0 and -s.f_spd or 0)) + (c.CFrame.RightVector * (dir.X > 0 and s.f_spd or dir.X < 0 and -s.f_spd or 0))
                if dir.Magnitude == 0 then hrp.FlyBV.Velocity = Vector3.new(0, 0.1, 0) end
            else
                if hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
                if hrp:FindFirstChild("FlyBG") then hrp.FlyBG:Destroy() end
            end
        end
    end

    for _, plr in pairs(p:GetPlayers()) do
        pcall(function()
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if s.hit then
                    hrp.Size = Vector3.new(s.sz, s.sz, s.sz)
                    hrp.Color = clr
                    hrp.Transparency = 0.8
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
                local hi = plr.Character:FindFirstChild("Highlight")
                if s.esp then
                    if not hi then hi = Instance.new("Highlight", plr.Character) end
                    hi.FillColor = clr
                elseif hi then hi:Destroy() end
            end
        end)
    end
    if s.aim and s.target and s.target.Parent then c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position) end
end)
