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
    f_spd = 200,
    speed = 16,
    jump = 50,
    infj = false,
    target = nil
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))

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

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 220, 0, 350)
f.Position = UDim2.new(0.5, -110, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
f.Visible = false
f.Active = true
f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
local m_s = Instance.new("UIStroke", f)
m_s.Thickness = 3

float.MouseButton1Click:Connect(function()
    f.Visible = not f.Visible
end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 45)
t.Text = "quangtruonghaik13"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = "LuckiestGuy"
t.TextSize = 18

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, 0, 0.85, 0)
sc.Position = UDim2.new(0, 0, 0.15, 0)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 1.8, 0)
sc.ScrollBarThickness = 2

local lyt = Instance.new("UIListLayout", sc)
lyt.HorizontalAlignment = "Center"
lyt.Padding = UDim.new(0, 8)

local function makeBtn(txt, callback)
    local b = Instance.new("TextButton", sc)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.85, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = "GothamBold"
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt .. (state and ": ON" or ": OFF")
        callback(state)
        b.BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    end)
end

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
makeBtn("Fly Mode", function(v) s.fly = v end)
makeBtn("Speed Hack", function(v) s.speed = v and 100 or 16 end)
makeBtn("High Jump", function(v) s.jump = v and 150 or 50 end)
makeBtn("Infinite Jump", function(v) s.infj = v end)

local hf = Instance.new("Frame", sc)
hf.Size = UDim2.new(0.85, 0, 0, 75)
hf.BackgroundTransparency = 1
local szl = Instance.new("TextLabel", hf)
szl.Size = UDim2.new(1, 0, 0, 25)
szl.Text = "SIZE: 15"
szl.TextColor3 = Color3.new(1, 1, 1)
szl.BackgroundTransparency = 1
szl.Font = "GothamBold"
local mb = Instance.new("TextButton", hf)
mb.Text = "-"; mb.Size = UDim2.new(0.4, 0, 0, 35); mb.Position = UDim2.new(0, 0, 0.4, 0); mb.BackgroundColor3 = Color3.fromRGB(50, 20, 20); mb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", mb)
local pb = Instance.new("TextButton", hf)
pb.Text = "+"; pb.Size = UDim2.new(0.4, 0, 0, 35); pb.Position = UDim2.new(0.6, 0, 0.4, 0); pb.BackgroundColor3 = Color3.fromRGB(20, 50, 20); pb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", pb)
mb.MouseButton1Click:Connect(function() s.sz = math.max(1, s.sz - 5) end)
pb.MouseButton1Click:Connect(function() s.sz = math.min(200, s.sz + 5) end)

uis.JumpRequest:Connect(function()
    if s.infj and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local bv, bg
rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    f_s.Color = clr; m_s.Color = clr; t.TextColor3 = clr; szl.TextColor3 = clr
    szl.Text = "SIZE: " .. s.sz

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
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if s.hit then
                hrp.Size = Vector3.new(s.sz, s.sz, s.sz)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = true
            end
            local hi = plr.Character:FindFirstChild("Highlight")
            if s.esp then
                if not hi then hi = Instance.new("Highlight", plr.Character) end
                hi.FillColor = clr
            elseif hi then hi:Destroy() end
        end
    end
    if s.aim and s.target and s.target.Parent then c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position) end
end)
