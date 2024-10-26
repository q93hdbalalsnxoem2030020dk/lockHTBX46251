local new = { 
    main = { 
        Mario = false, -- Start as false, controlled by button toggle
        Prediction = 0.13,
        Part = "HumanoidRootPart", 
        Key = "q",
        Notifications = true,
        AirshotFunc = true
    },
    Tracer = { 
        TracerThickness = 3.5,
        TracerTransparency = 1,
        TracerColor = Color3.fromRGB(153, 50, 204)
    }
}

local CurrentCamera = game:GetService "Workspace".CurrentCamera
local Mouse = game.Players.LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Plr = game.Players.LocalPlayer
local Line = Drawing.new("Line")
local Inset = game:GetService("GuiService"):GetGuiInset().Y

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
TextButton.Text = "Off" -- Default text

UICorner_2.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
    new.main.Mario = not new.main.Mario
    if new.main.Mario then
        Plr = FindClosestUser()
        if new.main.Notifications == true then
            game.StarterGui:SetCore("SendNotification", {
                Title = "<3",
                Text = "Locked on to:" .. tostring(Plr.Character.Humanoid.DisplayName)
            })
        end
        TextButton.Text = "On"
    else
        if new.main.Notifications == true then
            game.StarterGui:SetCore("SendNotification", {
                Title = "<3",
                Text = "No longer locked on"
            })
        end
        TextButton.Text = "Off"
    end
end)

function FindClosestUser()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
            v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

RunService.Stepped:connect(function()
    if new.main.Mario == true then
        local Vector = CurrentCamera:WorldToViewportPoint(Plr.Character[new.main.Part].Position +
                                                              (Plr.Character.HumanoidRootPart.Velocity *
                                                                  new.main.Prediction))
        Line.Color = new.Tracer.TracerColor
        Line.Thickness = new.Tracer.TracerThickness
        Line.Transparency = new.Tracer.TracerTransparency

        Line.From = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Line.To = Vector2.new(Vector.X, Vector.Y)
        Line.Visible = true
    else
        Line.Visible = false
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if new.main.Mario and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character[new.main.Part].Position +
                      (Plr.Character[new.main.Part].Velocity * new.main.Prediction)
        return old(unpack(args))
    end
    return old(...)
end)

if new.main.AirshotFunc == true then
    if Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        settings.main.Part = "RightFoot"
    else
        Plr.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Freefall then
                settings.main.Part = "RightFoot"
            else
                settings.main.Part = "LowerTorso"
            end
        end)
    end
end
