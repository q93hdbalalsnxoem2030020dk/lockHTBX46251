-- Toggle key is Q
getgenv().Target = true
-- Configuration
getgenv().Key = Enum.KeyCode.Q
getgenv().Prediction = 0.130340
getgenv().ChatMode = false
getgenv().NotifMode = true
getgenv().PartMode = true
getgenv().AirshotFunccc = true
getgenv().Partz = "LowerTorso"
getgenv().AutoPrediction = false
--
_G.Types = {
    Ball = Enum.PartType.Ball,
    Block = Enum.PartType.Block,
    Cylinder = Enum.PartType.Cylinder
}

-- Variables
local Tracer = Instance.new("Part", game.Workspace)
Tracer.Name = "gay"
Tracer.Anchored = true
Tracer.CanCollide = false
Tracer.Transparency = 0.8
Tracer.Parent = game.Workspace
Tracer.Shape = _G.Types.Block
Tracer.Size = Vector3.new(14, 14, 14)
Tracer.Color = Color3.fromRGB(16, 0, 22)

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local Runserv = game:GetService("RunService")

circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 0
circle.NumSides = 732
circle.Radius = 732
circle.Transparency = 0.9
circle.Visible = false
circle.Filled = false

Runserv.RenderStepped:Connect(function()
    circle.Position = Vector2.new(mouse.X, mouse.Y + 35)
end)

local guimain = Instance.new("Folder", game.CoreGui)
local CC = game:GetService("Workspace").CurrentCamera
local LocalMouse = game.Players.LocalPlayer:GetMouse()
local Locking = false

local function ToggleLock()
    if getgenv().Target == true then
        Locking = not Locking
        if Locking then
            Plr = getClosestPlayerToCursor()
            if getgenv().ChatMode then
                local A_1 = "Target: "..tostring(Plr.Character.Humanoid.DisplayName)
                local A_2 = "All"
                local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
                Event:FireServer(A_1, A_2)
            end
            if getgenv().NotifMode then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "<3 Chloe <3#7316's Lock",
                    Text = "Target: "..tostring(Plr.Character.Humanoid.DisplayName)
                })
            end
        else
            if getgenv().ChatMode then
                local A_1 = "Unlocked!"
                local A_2 = "All"
                local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
                Event:FireServer(A_1, A_2)
            end
            if getgenv().NotifMode then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "<3 Chloe <3#7316's Lock",
                    Text = "unlocked",
                    Duration = 1
                })
            end
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "lock",
            Text = "target isn't enabled",
            Duration = 1
        })
    end
end

-- Original Key Binding (kys)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(keygo, ok)
    if not ok and keygo.KeyCode == getgenv().Key then
        ToggleLock()
    end
end)

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
TextButton.Text = "Q Toggle"

UICorner_2.Parent = TextButton
TextButton.MouseButton1Click:Connect(ToggleLock)

-- Other functions (unchanged)
function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = circle.Radius

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("LowerTorso") then
            local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalMouse.X, LocalMouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

-- Ping adjustment
while wait() do
    if getgenv().AutoPrediction == true then
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingvalue, '(')
        local ping = tonumber(split[1])
        if ping < 130 then
            getgenv().Prediction = 0.151
        elseif ping < 125 then
            getgenv().Prediction = 0.149
        elseif ping < 110 then
            getgenv().Prediction = 0.146
        elseif ping < 105 then
            getgenv().Prediction = 0.138
        elseif ping < 90 then
            getgenv().Prediction = 0.136
        elseif ping < 80 then
            getgenv().Prediction = 0.134
        elseif ping < 70 then
            getgenv().Prediction = 0.131
        elseif ping < 60 then
            getgenv().Prediction = 0.1229
        elseif ping < 50 then
            getgenv().Prediction = 0.1225
        elseif ping < 40 then
            getgenv().Prediction = 0.1256
        end
    end
end
