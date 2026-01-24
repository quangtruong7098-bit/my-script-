local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Config = {
    HitboxSize = 25,
    HitboxEnabled = false,
    HitboxPart = "Head",
    HitboxTransparency = 0.5,
    SpeedEnabled = false,
    WalkSpeed = 16,
    FlyEnabled = false,
    FlySpeed = 100,
    EspEnabled = false,
    ShiftLock = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuangTruong_V12"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 15)
UICorner_Main.Parent = Main

local UIStroke_Main = Instance.new("UIStroke")
UIStroke_Main.Color = Color3.fromRGB(180, 0, 255)
UIStroke_Main.Thickness = 3
UIStroke_Main.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "QUANGTRUONG SUPREME V12"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextSize = 22
Title.BorderSizePixel = 0

local UICorner_Title = Instance.new("UICorner")
UICorner_Title.CornerRadius = UDim.new(0, 15)
UICorner_Title.Parent = Title

local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Parent = Main
TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabFrame.Position = UDim2.new(0, 10, 0, 50)
TabFrame.Size = UDim2.new(0, 120, 1, -60)
TabFrame.BorderSizePixel = 0

local UICorner_Tab = Instance.new("UICorner")
UICorner_Tab.CornerRadius = UDim.new(0, 10)
UICorner_Tab.Parent = TabFrame

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 140, 0, 50)
Container.Size = UDim2.new(1, -150, 1, -60)

local UIListLayout_Tab = Instance.new("UIListLayout")
UIListLayout_Tab.Parent = TabFrame
UIListLayout_Tab.Padding = UDim.new(0, 5)
UIListLayout_Tab.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = ""
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(50, 50, 60)
        callback(state)
    end)
end

local function CreateSlider(text, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.9, 0, 0, 5)
    sliderBar.Position = UDim2.new(0.05, 0, 0.7, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBar.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    sliderFill.Parent = sliderBar
    
    local inputBtn = Instance.new("TextButton")
    inputBtn.Size = UDim2.new(1, 0, 1, 0)
    inputBtn.BackgroundTransparency = 1
    inputBtn.Text = ""
    inputBtn.Parent = sliderBar
    
    inputBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                    local scale = math.clamp((move.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                    local value = math.floor(min + (max - min) * scale)
                    label.Text = text .. ": " .. tostring(value)
                    callback(value)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moveConnection:Disconnect()
                end
            end)
        end
    end)
end

local UIListLayout_Cont = Instance.new("UIListLayout")
UIListLayout_Cont.Parent = Container
UIListLayout_Cont.Padding = UDim.new(0, 10)

CreateToggle("Enable Hitbox", function(v) Config.HitboxEnabled = v end)
CreateSlider("Hitbox Size", 1, 500, function(v) Config.HitboxSize = v end)
CreateToggle("Enable ESP", function(v) Config.EspEnabled = v end)
CreateToggle("Speed Bypass", function(v) Config.SpeedEnabled = v end)
CreateSlider("WalkSpeed", 16, 1000, function(v) Config.WalkSpeed = v end)
CreateToggle("Fly Mode", function(v) Config.FlyEnabled = v end)
CreateToggle("Shift Lock", function(v) Config.ShiftLock = v end)

RunService.RenderStepped:Connect(function()
    if Config.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end

    if Config.ShiftLock then
        Camera.Offset = Vector3.new(1.7, 0.5, 0)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        Camera.Offset = Vector3.new(0, 0, 0)
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Config.HitboxEnabled and plr.Character:FindFirstChild(Config.HitboxPart) then
                local p = plr.Character[Config.Combat.HitboxPart or "Head"]
                p.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Transparency = Config.HitboxTransparency
                p.CanCollide = false
            end
            
            local hl = plr.Character:FindFirstChild("QT_HL")
            if Config.EspEnabled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "QT_HL"
                    hl.Parent = plr.Character
                    hl.FillColor = Color3.fromRGB(180, 0, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
            elseif hl then
                hl:Destroy()
            end
        end
    end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
ToggleBtn.Text = "QT"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.LuckiestGuy
ToggleBtn.TextSize = 20

local UICorner_TBtn = Instance.new("UICorner")
UICorner_TBtn.CornerRadius = UDim.new(0, 25)
UICorner_TBtn.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("QUANGTRUONG V12 REBORN LOADED")
