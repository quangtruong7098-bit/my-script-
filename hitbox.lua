local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local lp = p.LocalPlayer
local m = lp:GetMouse()
local c = workspace.CurrentCamera

local s = {
    sz = 15,
    spd = 2,
    hit = true,
    aim = true,
    esp = true
}

local g = Instance.new("ScreenGui", game:GetService("CoreGui"))
local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 160, 0, 160)
f.Position = UDim2.new(0.5, -80, 0.4, 0)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.Active = true
f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 35)
t.Text = "RAINBOW VIP"
t.TextColor3 = Color3.new(1, 1, 1)
t.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", t).CornerRadius = UDim.new(0, 10)

local function btn(txt, pos, callback)
    local b = Instance.new("TextButton", f)
    b.Text = txt .. ": ON"
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local state = true
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(100, 30, 30)
        callback(state)
    end)
end

btn("Hitbox", UDim2.new(0.05, 0, 0.3, 0), function(v) s.hit = v end)
btn("Aimbot", UDim2.new(0.05, 0, 0.52, 0), function(v) s.aim = v end)
btn("ESP", UDim2.new(0.05, 0, 0.75, 0), function(v) s.esp = v end)

local function getTarget()
    local target = nil
    local dist = 500
    for _, plr in pairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = c:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(m.X, m.Y)).Magnitude
                if mag < dist then
                    target = plr.Character.HumanoidRootPart
                    dist = mag
                end
            end
        end
    end
    return target
end

rs.RenderStepped:Connect(function()
    local clr = Color3.fromHSV(tick()/s.spd%1, 1, 1)
    t.TextColor3 = clr
    
    for _, plr in pairs(p:GetPlayers()) do
        pcall(function()
            if plr ~= lp and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if s.hit then
                        hrp.Size = Vector3.new(s.sz, s.sz, s.sz)
                        hrp.Color = clr
                        hrp.Transparency = 0.6
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
                elseif hi then
                    hi:Destroy()
                end
            end
        end)
    end

    if s.aim then
        local target = getTarget()
        if target then
            c.CFrame = CFrame.new(c.CFrame.Position, target.Position)
        end
    end
end)

uis.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.L then f.Visible = not f.Visible end
end)
