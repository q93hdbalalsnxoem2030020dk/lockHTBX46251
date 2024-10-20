-- Main aimlock settings
local configs = {
    main = {
        enabled = false, -- status
        prediction = 0.116,
        aimpart = 'HumanoidRootPart', -- Options: Head, UpperTorso, HumanoidRootPart, LowerTorso
        notifications = true
    }
}

-- Box / marker settings
local boxsettings = {
    box = {
        Showbox = true,
        boxsize = Vector3.new(3.3, 3, 2.8), -- Box Size
        markercolor = Color3.fromRGB(1, 120, 145), -- Marker Color
        markersize = UDim2.new(1, 0, 3, 0) -- Marker Size
    }
}
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
TextButton.Text = "Lock: Off"

-- Box for aimlock marker
local box = Instance.new("Part", game.Workspace)
local Mouse = game.Players.LocalPlayer:GetMouse()

function makemarker(Parent, Adornee, Color, Size, Size2)
    local box = Instance.new("BillboardGui", Parent)
    box.Name = "PRIVATE-REWRITE!"
    box.Adornee = Adornee
    box.Size = UDim2.new(Size, Size2, Size, Size2)
    box.AlwaysOnTop = true

    local a = Instance.new("Frame", box)
    a.Size = boxsettings.box.markersize
    a.BackgroundColor3 = Color

    local g = Instance.new("UICorner", a)
    g.CornerRadius = UDim.new(50, 25)
    return (box)
end

local Plr

TextButton.MouseButton1Click:Connect(function()
    if configs.main.enabled then
        configs.main.enabled = false
        TextButton.Text = "Lock: Off"
        if configs.main.notifications then
            Plr = FindClosestUser()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Private",
                Text = "Unlocked;"
            })
        end
    else
        Plr = FindClosestUser()
        configs.main.enabled = true
        TextButton.Text = "Lock: On"
        if configs.main.notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Private",
                Text = "Locked On; " .. tostring(Plr.Character.Humanoid.DisplayName)
            })
        end
    end
end)

local data = game.Players:GetPlayers()
function noob(player)
    local character
    repeat
        wait()
    until player.Character
    local handler = makemarker(Lnr, player.Character:WaitForChild(configs.main.aimpart),
        Color3.fromRGB(107, 184, 255), 0.10, 8)
    handler.Name = player.Name
    player.CharacterAdded:connect(function(Char)
        handler.Adornee = Char:WaitForChild("HumanoidRootPart")
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
    box.Anchored = true
    box.CanCollide = false
    box.Size = boxsettings.box.boxsize
    if boxsettings.box.Showbox then
        box.Transparency = 0.70
    else
        box.Transparency = 1
    end
    makemarker(box, box, boxsettings.box.markercolor, 0.40, 1)
end)

function FindClosestUser()
    local closestPlayer
    local ShortestDistance = 300

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
            v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) -
                                  Vector2.new(game.Players.LocalPlayer:GetMouse().X,
                    game.Players.LocalPlayer:GetMouse().Y)).magnitude
            if magnitude < ShortestDistance then
                closestPlayer = v
                ShortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

game:GetService("RunService").Stepped:connect(function()
    if configs.main.enabled and Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        box.CFrame = CFrame.new(Plr.Character[configs.main.aimpart].Position +
                                    (Plr.Character[configs.main.aimpart].Velocity * configs.main.prediction))
    else
        box.CFrame = CFrame.new(0, 9999, 0) -- Hide box if aimlock is off
    end
end)

repeat
    wait()
until game:IsLoaded()
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if configs.main.enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character[configs.main.aimpart].Position +
                      (Plr.Character[configs.main.aimpart].Velocity * configs.main.prediction)
        return old(unpack(args))
    end
    return old(...)
end)
