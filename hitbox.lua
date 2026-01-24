local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local lp = p.LocalPlayer
local c = workspace.CurrentCamera

local s = {
    sz = 15,
    spd = 1.2,
    hit = false,
    aim = false,
    esp = false,
    fly = false,
    f_spd = 200, -- Tốc độ bay cực nhanh
    speed = 16,
    jump = 50,
    infj = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- NÚT TRÒN QT (FLOATING BUTTON)
local float = Instance.new("TextButton", g)
float.Size = UDim2.new(0, 60, 0, 60)
float.Position = UDim2.new(0.1, 0, 0.2, 0)
float.Text = "QT"
float.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
float.TextColor3 = Color3.new(1, 1, 1)
float.TextSize = 25
float.ZIndex = 10
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local f_s = Instance.new("UIStroke", float)
f_s.Thickness = 3

-- KHUNG MENU CHÍNH
local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 230, 0, 350)
f.Position = UDim2.new(0.5, -115, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.Visible = false
f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
local m_s = Instance.new("UIStroke", f)
m_s.Thickness = 4

-- HỆ THỐNG DI CHUYỂN (DRAG) CHO MOBILE
local dragging, dragInput, dragStart, startPos
f.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = f.Position
    end
end)
uis.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
uis.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

float.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 45)
t.Text = "quangtruonghaik13"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = Enum.Font.LuckiestGuy
t.TextSize = 18

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, 0, 0.85, -10)
sc.Position = UDim2.new(0, 0, 0.15, 0)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 1.6, 0)
sc.ScrollBarTransparency = 1
local lyt = Instance.new("UIListLayout", sc)
lyt.HorizontalAlignment = "Center"
lyt.Padding = UDim.new(0, 8)

local function createBtn(txt, callback)
    local b = Instance.new("TextButton", sc)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    b.Font = "GothamBold"
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = false
    b.MouseButton1Click:Connect(function()
        st = not st
        b.Text = txt .. (st and ": ON" or ": OFF")
        callback(st)
        ts:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = st and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(25, 25, 25), TextColor3 = st and Color3.new(1,1,1) or Color3.new(0.7,0.7,0.7)}):Play()
    end)
end

-- CÁC CHỨC NĂNG
createBtn("Hitbox Expand", function(v) s.hit = v end)
createBtn("Lock Target", function(v) 
    s.aim = v 
    if v then
        local target, dist = nil, 400
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
createBtn("Neon ESP", function(v) s.esp = v end)
createBtn("Fly Mode (High Speed)", function(v) s.fly = v end)
createBtn("Speed Hack (100)", function(v) s.speed = v and 100 or 16 end)
createBtn("Infinite Jump", function(v) s.infj = v end)

-- CHỈNH HITBOX SIZE
local hf = Instance.new("Frame", sc)
hf.Size = UDim2.new(0.9, 0, 0, 70)
hf.BackgroundTransparency = 1
local sz_l = Instance.new("TextLabel", hf)
sz_l.Size = UDim2.new(1, 0, 0, 25)
sz_l.Text = "HITBOX SIZE: 15"
sz_l.TextColor3 = Color3.new(1, 1, 1)
sz_l.BackgroundTransparency = 1
sz_l.Font = "GothamBold"
local mb = Instance.new("TextButton", hf)
mb.Text = "-5"; mb.Size = UDim2.new(0.4, 0, 0, 35); mb.Position = UDim2.new(0, 0, 0.45, 0); mb.BackgroundColor3 = Color3.fromRGB(40,20,20); mb.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mb)
local pb = Instance.new("TextButton", hf)
pb.Text = "+5"; pb.Size = UDim2.new(0.4, 0, 0, 35); pb.Position = UDim2.new(0.6, 0, 0.45, 0); pb.BackgroundColor3 = Color3.fromRGB(20,40,20); pb.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", pb)
mb.MouseButton1Click:Connect(function() s.sz = math.max(2, s.sz - 5) end)
pb.MouseButton1Click:Connect(function() s.sz = math.min(100, s.sz + 5) end)

-- VÒNG LẶP CHÍNH (RENDER STEPPED)
local bv, bg
uis.JumpRequest:Connect(function()
    if s.infj and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_s.Color = clr; m_s.Color = clr; t.TextColor3 = clr; sz_l.TextColor3 = clr
    sz_l.Text = "HITBOX SIZE: " .. s.sz

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = s.speed
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
