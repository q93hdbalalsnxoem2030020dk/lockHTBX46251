local CC = game:GetService("Workspace").CurrentCamera
local Plr
local enabled = false
local accomidationfactor = 0.12
local mouse = game.Players.LocalPlayer:GetMouse()
local placemarker = Instance.new("Part", game.Workspace)

function makemarker(Parent, Adornee, Color, Size, Size2)
    local e = Instance.new("BillboardGui", Parent)
    e.Name = "PP"
    e.Adornee = Adornee
    e.Size = UDim2.new(Size, Size2, Size, Size2)
    e.AlwaysOnTop = true
    local a = Instance.new("Frame", e)
    a.Size = UDim2.new(1, 0, 1, 0)
    a.BackgroundTransparency = 0
    a.BackgroundColor3 = Color
    local g = Instance.new("UICorner", a)
    g.CornerRadius = UDim.new(50, 50)
    return e
end

local data = game.Players:GetPlayers()

function noob(player)
    local character
    repeat wait() until player.Character
    local handler = makemarker(placemarker, player.Character:WaitForChild("HumanoidRootPart"), Color3.fromRGB(176, 196, 222), 0.3, 3)
    handler.Name = player.Name

    player.CharacterAdded:connect(function(Char)
        handler.Adornee = Char:WaitForChild("HumanoidRootPart")
    end)

    spawn(function()
        while wait() do
            if player.Character then
                local leaderstats = player:FindFirstChild("leaderstats")
                local gunspork = player:FindFirstChild("gunspork") -- Check for gunspork
                
                if leaderstats and leaderstats:FindFirstChild("Wanted") and gunspork then
                    TextLabel.Text = player.Name .. " | " .. tostring(leaderstats.Wanted.Value) .. " | " .. tostring(math.floor(player.Character:WaitForChild("Humanoid").Health)) .. " | Gunspork: " .. tostring(gunspork.Value)
                elseif leaderstats and leaderstats:FindFirstChild("Wanted") then
                    TextLabel.Text = player.Name .. " | " .. tostring(leaderstats.Wanted.Value) .. " | " .. tostring(math.floor(player.Character:WaitForChild("Humanoid").Health)) .. " | Gunspork: N/A"
                end
            end
        end
    end)
end

for i = 1, #data do
    if data[i] ~= game.Players.LocalPlayer then
        noob(data[i])
    end
end

game.Players.PlayerAdded:connect(function(Player)
    noob(Player)
end)

spawn(function()
    placemarker.Anchored = true
    placemarker.CanCollide = false
    placemarker.Size = Vector3.new(8, 8, 8)
    placemarker.Transparency = 0.75
    makemarker(placemarker, placemarker, Color3.fromRGB(74, 65, 42), 0.40, 0)
end)

function isInCameraView(player)
    local playerPos = player.Character.HumanoidRootPart.Position
    local viewportPoint = CC:WorldToViewportPoint(playerPos)
    return viewportPoint.Z > 0 and viewportPoint.X > 0 and viewportPoint.X < CC.ViewportSize.X and viewportPoint.Y > 0 and viewportPoint.Y < CC.ViewportSize.Y
end

function isPlayerVisible(player)
    local startPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local endPosition = player.Character.HumanoidRootPart.Position

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, player.Character}

    local rayResult = game.Workspace:Raycast(startPosition, endPosition - startPosition, raycastParams)

    -- Return true if no part is hit, meaning the player is visible
    return rayResult == nil
end

function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            if isInCameraView(v) and isPlayerVisible(v) then
                local pos = CC:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

game:GetService("RunService").Stepped:connect(function()
    if enabled and Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        placemarker.CFrame = CFrame.new(Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * accomidationfactor))
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * accomidationfactor)
        return old(unpack(args))
    end
    return old(...)
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
TextButton.Text = "{off}"

UICorner_2.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
    if enabled then
        enabled = false
        TextButton.Text = "{off}"
        if Plr and guimain and guimain[Plr.Name] then
            guimain[Plr.Name].Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        enabled = true
        Plr = getClosestPlayerToCursor()
        TextButton.Text = "{on}"
        if Plr and guimain and guimain[Plr.Name] then
            guimain[Plr.Name].Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

TextButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    TextButton.Position = UDim2.new(0.1, 0, 0.2, 0)
end)
