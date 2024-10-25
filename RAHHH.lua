getgenv().Settings = {
    AimLock = {
        Enabled = false, -- Start disabled
        Prediction = 0.130340,
        Aimpart = 'HumanoidRootPart',
        Notifications = true
    },
    Settings = {
        Thickness = 3.5,
        Transparency = 1,
        Color = Color3.fromRGB(106, 13, 173),
        FOV = true
    }
}

local CurrentCamera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local Line = Drawing.new("Line")
local Circle = Drawing.new("Circle")
local Plr

local function CreateESP(Player)
    if Player.Character and Player.Character:FindFirstChild(getgenv().Settings.AimLock.Aimpart) then
        local ESPPart = Instance.new("BoxHandleAdornment")
        ESPPart.Name = "ESP"
        ESPPart.Size = Vector3.new(2, 5, 2) -- Adjust size as needed
        ESPPart.Color3 = getgenv().Settings.Settings.Color
        ESPPart.Transparency = getgenv().Settings.Settings.Transparency
        ESPPart.AlwaysOnTop = true
        ESPPart.Adornee = Player.Character[getgenv().Settings.AimLock.Aimpart]

        ESPPart.Parent = game.Workspace
        return ESPPart
    end
end

-- Same GUI
local Lnr = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

Lnr.Name = "Lnr"
Lnr.Parent = game.CoreGui
Lnr.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Lnr
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -75, 0.5, -25)
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0.5, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.1, 0, 0.2, 0)
TextButton.Size = UDim2.new(0.8, 0, 0.6, 0)
TextButton.Font = Enum.Font.GothamSemibold
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14
TextButton.Text = "Lock Off"

UICorner_2.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
    getgenv().Settings.AimLock.Enabled = not getgenv().Settings.AimLock.Enabled
    if getgenv().Settings.AimLock.Enabled then
        Plr = FindPlayerInFront()
        TextButton.Text = "Lock On"
        if getgenv().Settings.AimLock.Notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "AimLock",
                Text = "Locked On : " .. (Plr and tostring(Plr.Character.Humanoid.DisplayName) or "None")
            })
        end
        if Plr then
            CreateESP(Plr)
        end
    else
        TextButton.Text = "Lock Off"
        if Plr then
            local ESPPart = game.Workspace:FindFirstChild(Plr.Name .. "_ESP")
            if ESPPart then
                ESPPart:Destroy()
            end
        end
        if getgenv().Settings.AimLock.Notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "AimLock",
                Text = "Unlocked"
            })
        end
        Plr = nil
    end
end)

function FindPlayerInFront()
    local ClosestPlayer, ClosestAngle = nil, math.huge
    for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild(getgenv().Settings.AimLock.Aimpart) then
            local Character = Player.Character
            local HumanoidRootPart = Character[getgenv().Settings.AimLock.Aimpart]
            local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
            
            if OnScreen then
                local Direction = (HumanoidRootPart.Position - CurrentCamera.CFrame.Position).Unit
                local CameraDirection = CurrentCamera.CFrame.LookVector
                local Angle = math.acos(CameraDirection:Dot(Direction))
                
                if Angle < ClosestAngle then
                    ClosestAngle = Angle
                    ClosestPlayer = Player
                end
            end
        end
    end
    return ClosestPlayer
end

RunService.Heartbeat:Connect(function()
    if getgenv().Settings.AimLock.Enabled and Plr and Plr.Character then
        local Vector = CurrentCamera:WorldToViewportPoint(Plr.Character[getgenv().Settings.AimLock.Aimpart].Position + 
            (Plr.Character[getgenv().Settings.AimLock.Aimpart].Velocity * getgenv().Settings.AimLock.Prediction))
        
        Line.Color = getgenv().Settings.Settings.Color
        Line.Transparency = getgenv().Settings.Settings.Transparency
        Line.Thickness = getgenv().Settings.Settings.Thickness
        Line.From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y) -- Bottom center of screen
        Line.To = Vector2.new(Vector.X, Vector.Y)
        Line.Visible = true

        Circle.Position = Vector2.new(Vector.X, Vector.Y)
        Circle.Visible = getgenv().Settings.Settings.FOV
        Circle.Thickness = 1.5
        Circle.Radius = 60
        Circle.Color = getgenv().Settings.Settings.Color
    else
        Circle.Visible = false
        Line.Visible = false
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    local method = getnamecallmethod()
    if getgenv().Settings.AimLock.Enabled and Plr and Plr.Character and method == "FireServer" then
        args[2] = Plr.Character[getgenv().Settings.AimLock.Aimpart].Position + 
            (Plr.Character[getgenv().Settings.AimLock.Aimpart].Velocity * getgenv().Settings.AimLock.Prediction)
        return old(unpack(args))
    end
    return old(...)
end)

UserInputService.TouchTapInWorld:Connect(function(touchPositions, gameProcessed)
    if getgenv().Settings.AimLock.Enabled and Plr then
        local predictedPosition = Plr.Character[getgenv().Settings.AimLock.Aimpart].Position + 
                                  (Plr.Character[getgenv().Settings.AimLock.Aimpart].Velocity * getgenv().Settings.AimLock.Prediction)
        CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, predictedPosition)
    end
end)
