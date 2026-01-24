local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local lp = p.LocalPlayer
local c = workspace.CurrentCamera

local s = {
    sz = 15,
    hit = false,
    part = "Head",
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
f.Size = UDim2.new(0, 230, 0, 380)
f.Position = UDim2.new(0.5, -115, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
f.Visible = false
f.Active = true
f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)
local m_s = Instance.new("UIStroke", f)
m_s.Thickness = 3

float.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 45)
t.Text = "quangtruonghaik13 V14"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Font = "LuckiestGuy"
t.TextSize = 17

local sc = Instance.new("ScrollingFrame", f)
sc.Size = UDim2.new(1, 0, 0.85, 0)
sc.Position = UDim2.new(0, 0, 0.12, 0)
sc.BackgroundTransparency = 1
sc.CanvasSize = UDim2.new(0, 0, 2, 0)
sc.ScrollBarThickness = 2

local lyt = Instance.new("UIListLayout", sc)
lyt.HorizontalAlignment = "Center"
lyt.Padding = UDim.new(0, 8)

local function makeBtn(txt, callback)
    local b = Instance.new("TextButton", sc)
    b.Text = txt .. ": OFF"
    b.Size = UDim2.new(0.9, 0, 0, 35)
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

local pb_btn = Instance.new("TextButton", sc)
pb_btn.Size = UDim2.new(0.9, 0, 0, 35)
pb_btn.Text = "PART: HEAD"
pb_btn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
pb_btn.TextColor3 = Color3.new(1, 1, 1)
pb_btn.Font = "GothamBold"
Instance.new("UICorner", pb_btn)

local parts = {"Head", "HumanoidRootPart", "LeftLeg", "RightLeg"}
local curr_p = 1
pb_btn.MouseButton1Click:Connect(function()
    curr_p = curr_p + 1
    if curr_p > #parts then curr_p = 1 end
    s.part = parts[curr_p]
    pb_btn.Text = "PART: " .. s.part:upper()
end)

makeBtn("Hitbox Active", function(v) s.hit = v end)
makeBtn("Lock Target", function(v) s.aim = v end)
makeBtn("Neon ESP", function(v) s.esp = v end)
makeBtn("Fly Mode", function(v) s.fly = v end)
makeBtn("Speed 100", function(v) s.speed = v and 100 or 16 end)
makeBtn("Inf Jump", function(v) s.infj = v end)

local hf = Instance.new("Frame", sc)
hf.Size = UDim2.new(0.85, 0, 0, 70)
hf.BackgroundTransparency = 1
local szl = Instance.new("TextLabel", hf)
szl.Size = UDim2.new(1, 0, 0, 25)
szl.Text = "SIZE: 15"
szl.TextColor3 = Color3.new(1, 1, 1)
szl.BackgroundTransparency = 1
szl.Font = "GothamBold"
local mb = Instance.new("TextButton", hf)
mb.Text = "-"; mb.Size = UDim2.new(0.4, 0, 0, 30); mb.Position = UDim2.new(0, 0, 0.4, 0); mb.BackgroundColor3 = Color3.fromRGB(80, 20, 20); mb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", mb)
local pb = Instance.new("TextButton", hf)
pb.Text = "+"; pb.Size = UDim2.new(0.4, 0, 0, 30); pb.Position = UDim2.new(0.6, 0, 0.4, 0); pb.BackgroundColor3 = Color3.fromRGB(20, 80, 20); pb.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", pb)
mb.MouseButton1Click:Connect(function() s.sz = math.max(1, s.sz - 5) end)
pb.MouseButton1Click:Connect(function() s.sz = math.min(100, s.sz + 5) end)

uis.JumpRequest:Connect(function()
    if s.infj and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/1.2%1, 1, 1)
    f_s.Color = clr; m_s.Color = clr; t.TextColor3 = clr; szl.Text = "SIZE: " .. s.sz
    
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = s.speed
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if s.fly then
                if not hrp:FindFirstChild("FlyBV") then
                    local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                end
                hrp.FlyBG.CFrame = c.CFrame
                local move = lp.Character.Humanoid.MoveDirection
                hrp.FlyBV.Velocity = (c.CFrame.LookVector * move.Magnitude * s.f_spd)
                if move.Magnitude == 0 then hrp.FlyBV.Velocity = Vector3.new(0, 0.1, 0) end
            else
                if hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
                if hrp:FindFirstChild("FlyBG") then hrp.FlyBG:Destroy() end
            end
        end
    end

    for _, plr in pairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local targetPart = plr.Character:FindFirstChild(s.part)
            if targetPart then
                if s.hit then
                    targetPart.Size = Vector3.new(s.sz, s.sz, s.sz)
                    targetPart.Color = Color3.fromRGB(0, 100, 255)
                    targetPart.Transparency = 0.8
                    targetPart.CanCollide = false
                else
                    targetPart.Size = (s.part == "Head" and Vector3.new(1.2, 1.2, 1.2) or Vector3.new(2, 2, 1))
                    targetPart.Transparency = 0
                    targetPart.CanCollide = true
                end
            end
            local hi = plr.Character:FindFirstChild("Highlight")
            if s.esp then
                if not hi then hi = Instance.new("Highlight", plr.Character) end
                hi.FillColor = clr
            elseif hi then hi:Destroy() end
        end
    end
    
    if s.aim and s.target and s.target.Parent then 
        c.CFrame = CFrame.new(c.CFrame.Position, s.target.Position) 
    end
end)
