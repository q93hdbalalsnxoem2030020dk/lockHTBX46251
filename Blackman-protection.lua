-- modified by sxc --


--[[

███████ ██   ██  ██████     
██        ██ ██   ██          
███████   ███    ██         NIGGA PROTECTION, CERTIFIED 
     ██   ██ ██   ██          
███████ ██   ██  ██████     
                            
                                                     
]]

getgenv().Enabled = true
getgenv().Aimlockkey = "q"
getgenv().Prediction = 0.977
getgenv().Aimpart = "HumanoidRootPart"
getgenv().Notifications = true
getgenv().Color = Color3.fromRGB(153, 50, 204)
getgenv().FOV = false
getgenv().Notifications = true
getgenv().Colorr = Color3.fromRGB(153, 50, 204)
getgenv().Transparency = 1
getgenv().Thickness = 3.5

local CurrentCamera = game:GetService("Workspace").CurrentCamera
local Inset = game:GetService("GuiService"):GetGuiInset().Y
local RunService = game:GetService("RunService")

local Mouse = game.Players.LocalPlayer:GetMouse()
local LocalPlayer = game.Players.LocalPlayer

local Line = Drawing.new("Line")
local Circle = Drawing.new("Circle")
local Plr

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
TextButton.Text = "CLICK TO LOCK"

TextButton.MouseButton1Click:Connect(function()
    local keyEvent = {
        KeyCode = Enum.KeyCode.Q,
        UserInputType = Enum.UserInputType.Keyboard
    }
    
    if getgenv().Aimlockkey == "q" then
        if getgenv().Enabled == true then
            getgenv().Enabled = false
            if getgenv().Notifications == true then
                Plr = FindClosestPlayer()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Private",
                    Text = "Unlocked"
                })
            end
        else
            Plr = FindClosestPlayer()
            getgenv().Enabled = true
            if getgenv().Notifications == true then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Private",
                    Text = "Locked On: " .. tostring(Plr.Character.Humanoid.DisplayName)
                })
            end
        end
    end
    
    TextButton.Text = getgenv().Enabled and "Nigga: ON" or "Nigga: OFF"
    TextButton.BackgroundColor3 = getgenv().Enabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(25, 25, 25)
end)

function FindClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge, nil;
    for _, Player in next, game:GetService("Players"):GetPlayers() do
        local ISNTKNOCKED = Player.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local ISNTGRABBED = Player.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character.Humanoid.Health > 1 and ISNTKNOCKED and ISNTGRABBED then
                local Position, IsVisibleOnViewPort = CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart
                                                                                             .Position)
                if IsVisibleOnViewPort then
                    local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestDistance
end

RunService.Heartbeat:connect(function()
    if getgenv().Enabled == true then
        local Vector = CurrentCamera:WorldToViewportPoint(Plr.Character[getgenv().Aimpart].Position +
                                                              (Plr.Character[getgenv().Aimpart].Velocity*Prediction))
        Line.Color = getgenv().Colorr
        Line.Transparency = getgenv().Transparency
        Line.Thickness = getgenv().Thickness
        Line.From = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Line.To = Vector2.new(Vector.X, Vector.Y)
        Line.Visible = true
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Circle.Visible = getgenv().FOV
        Circle.Thickness = 1.5
        Circle.Thickness = 2
        Circle.Radius = 60
        Circle.Color = getgenv().Color

    else
        Line.Visible = false
        Circle.Visible = false
    end
end)


local rawmetatable = getrawmetatable(game)
local old = rawmetatable.__namecall
setreadonly(rawmetatable, false)
rawmetatable.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().Enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character[getgenv().Aimpart].Position+(Plr.Character[getgenv().Aimpart].Velocity*Prediction)
        return old(unpack(args))
    end
    return old(...)
end)


local Settings = {
    AimLock = {
        Enabled = true,
        Aimlockkey = "q",
        Prediction = 0.11567724521,
        Aimpart = 'HumanoidRootPart',
        Notifications = false
    },
    Settings = {
        Thickness = 3.5,
        Transparency = 1,
        Color = Color3.fromRGB(153, 50, 204),
        FOV = false
    }
}

local CurrentCamera = game:GetService("Workspace").CurrentCamera
local Inset = game:GetService("GuiService"):GetGuiInset().Y
local RunService = game:GetService("RunService")

local Mouse = game.Players.LocalPlayer:GetMouse()
local LocalPlayer = game.Players.LocalPlayer

local Line = Drawing.new("Line")
local Circle = Drawing.new("Circle")

local Plr

Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (Settings.AimLock.Aimlockkey) then
        if Settings.AimLock.Enabled == true then
            Settings.AimLock.Enabled = false
            if Settings.AimLock.Notifications == true then
                Plr = FindClosestPlayer()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Private",
                    Text = "Unlocked"
                })
            end
        else
            Plr = FindClosestPlayer()
            Settings.AimLock.Enabled = true
            if Settings.AimLock.Notifications == true then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Private",
                    Text = "Locked On :  " .. tostring(Plr.Character.Humanoid.DisplayName)
                })
            end
        end
    end
end)

function FindClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge, nil;
    for _, Player in next, game:GetService("Players"):GetPlayers() do
        local ISNTKNOCKED = Player.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local ISNTGRABBED = Player.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character.Humanoid.Health > 1 and ISNTKNOCKED and ISNTGRABBED then
                local Position, IsVisibleOnViewPort = CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart
                                                                                             .Position)
                if IsVisibleOnViewPort then
                    local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestDistance
end

RunService.Heartbeat:connect(function()
    if Settings.AimLock.Enabled == true then
        local Vector = CurrentCamera:WorldToViewportPoint(Plr.Character[Settings.AimLock.Aimpart].Position +
                                                              (Plr.Character[Settings.AimLock.Aimpart].Velocity *
                                                              Settings.AimLock.Prediction))
        Line.Color = Settings.Settings.Color
        Line.Transparency = Settings.Settings .Transparency
        Line.Thickness = Settings.Settings .Thickness
        Line.From = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Line.To = Vector2.new(Vector.X, Vector.Y)
        Line.Visible = true
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Circle.Visible = Settings.Settings.FOV
        Circle.Thickness = 1.5
        Circle.Thickness = 2
        Circle.Radius = 60
        Circle.Color = Settings.Settings.Color
    elseif Settings.AimLock.FOV == true then
        Circle.Visible = true
    else
        Circle.Visible = false
        Line.Visible = false
    end
end)

local rawmetatable = getrawmetatable(game)
local old = rawmetatable.__namecall
setreadonly(rawmetatable, false)
rawmetatable.__namecall = newcclosure(function(...)
    local args = {...}
    if Settings.AimLock.Enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character[Settings.AimLock.Aimpart].Position+(Plr.Character[Settings.AimLock.Aimpart].Velocity*Settings.AimLock.Prediction)
        return old(unpack(args))
    end
    return old(...)
end)
