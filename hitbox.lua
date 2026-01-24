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
    f_spd = 250, -- Tốc độ bay siêu nhanh
    speed = 16,
    jump = 50,
    infj = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- NÚT QT TRÒN (FLOATING)
local float = Instance.new("TextButton", g)
float.Size = UDim2.new(0, 60, 0, 60)
float.Position = UDim2.new(0.1, 0, 0.15, 0)
float.Text = "QT"
float.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
float.TextColor3 = Color3.new(1, 1, 1)
float.TextSize = 24
float.ZIndex = 10
Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
local f_s = Instance.new("UIStroke", float)
f_s.Thickness = 3

-- KHUNG MENU CHÍNH
local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 230, 0, 360)
f.Position = UDim2.new(0.5, -115, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.Visible = false
f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
local m_s = Instance.new("UIStroke", f)
m_s.Thickness = 4

-- HỆ THỐNG KÉO MENU (DRAG)
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
t.Size = UDim2.new(1, 0, 0, 50)
t.Text = "quangtruonghaik13"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = "LuckiestGuy"
t.TextSize = 19

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, 0, 0.82, 0)
sc.Position = UDim2.new(0, 0, 0.15, 0)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 1.8, 0)
sc.ScrollBarTransparency = 1
local lyt = Instance.new("UIListLayout", sc)
lyt.HorizontalAlignment = "Center"
lyt.Padding = UDim.new(0, 10)

local function makeBtn(txt, callback)
    local b = Instance.new("TextButton", sc)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.85, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = "GothamBold"
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt .. (state and ": ON" or ": OFF")
        callback(state)
        ts:Create(b, TweenInfo.new(0.3), {
            BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30),
            TextColor3 = state and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
        }):Play()
    end)
end

-- DANH SÁCH TÍNH NĂNG
makeBtn("Hitbox Expand", function(v) s.hit = v end)
makeBtn("Lock Target", function(v) 
    s.aim = v 
    if v then
        local tar, d = nil, 500
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local pos, vis = c:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(c.ViewportSize.X/2, c.ViewportSize.Y/2)).Magnitude
                    if m < d then tar = pl.Character.HumanoidRootPart d = m end
                end
            end
        end
        s.target = tar
    else s.target = nil end
end)
makeBtn("Neon ESP", function(v) s.esp = v end)
makeBtn("Fly Mode (Fast)", function(v) s.fly = v end)
makeBtn("Speed Hack (100)", function(v) s.speed = v and 100 or 16 end)
makeBtn("Infinite Jump", function(v) s.infj = v end)

-- KHU VỰC CHỈNH SIZE
local hf = Instance.new("Frame", sc)
hf.Size = UDim2.new(0.85, 0, 0, 80)
hf.BackgroundTransparency = 1
local szl = Instance.new("TextLabel", hf)
szl.Size = UDim2.new(1, 0, 0, 30)
szl.Text = "HITBOX SIZE: 15"
szl.TextColor3 = Color3.new(1, 1, 1)
szl.BackgroundTransparency = 1
szl.Font = "GothamBold"
local mb = Instance.new("TextButton", hf)
mb.Text = "-"; mb.Size = UDim2.new(0.4, 0, 0, 35); mb.Position = UDim2.new(0, 0, 0.5, 0); mb.BackgroundColor3 = Color3.fromRGB(50, 20, 20); mb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", mb)
local pb = Instance.new("TextButton", hf)
pb.Text = "+"; pb.Size = UDim2.new(0.4, 0, 0, 35); pb.Position = UDim2.new(0.6, 0, 0.5, 0); pb.BackgroundColor3 = Color3.fromRGB(20, 50, 20); pb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", pb)
mb.MouseButton1Click:Connect(function() s.sz = math.max(2, s.sz - 5) end)
pb.MouseButton1Click:Connect(function() s.sz = math.min(200, s.sz + 5) end)

-- XỬ LÝ NHẢY VÔ HẠN
uis.JumpRequest:Connect(function()
    if s.infj and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- VÒNG LẶP CHÍNH (UPDATE MỖI KHUNG HÌNH)
local bv, bg
rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_s.Color = clr; m_s.Color = clr; t.TextColor3 = clr; szl.TextColor3 = clr
    szl.Text = "HITBOX SIZE: " .. s.sz

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
                    hrp.Transparency = 0.7
                    hrp.Material = "Neon"
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
