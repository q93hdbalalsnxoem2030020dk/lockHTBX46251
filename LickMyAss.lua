getgenv().OldAimPart = "UpperTorso"

getgenv().AimPart = "UpperTorso"

getgenv().AimlockKey = "c" -- Ignored

getgenv().AimRadius = 30

getgenv().ThirdPerson = true 

getgenv().FirstPerson = true

getgenv().TeamCheck = false

getgenv().PredictMovement = true

getgenv().PredictionVelocity = 4.5

getgenv().CheckIfJumped = false

getgenv().Smoothness = false

getgenv().SmoothnessAmount = 0.015



local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";

local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;

local Aimlock, MousePressed, CanNotify = false, false, false;  -- Changed Aimlock to start as false

local AimlockTarget;

local OldPre;



local ScreenGui = Instance.new("ScreenGui")

local Frame = Instance.new("Frame")

local ToggleButton = Instance.new("TextButton")



ScreenGui.Name = "NIGGGGAA"

ScreenGui.Parent = game.CoreGui



Frame.Parent = ScreenGui

Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)

Frame.Position = UDim2.new(0.8, 0, 0.5, 0)

Frame.Size = UDim2.new(0, 100, 0, 40)

Frame.Active = true

Frame.Draggable = true



ToggleButton.Parent = Frame

ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

ToggleButton.BorderSizePixel = 0

ToggleButton.Size = UDim2.new(1, 0, 1, 0)

ToggleButton.Font = Enum.Font.GothamSemibold

ToggleButton.Text = "Nigga: OFF"

ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.TextSize = 14



ToggleButton.MouseButton1Click:Connect(function()

    Aimlock = not Aimlock

    ToggleButton.Text = Aimlock and "Nigga: ON" or "Nigga: OFF"

    ToggleButton.BackgroundColor3 = Aimlock

        and Color3.fromRGB(40, 120, 40)

        or Color3.fromRGB(25, 25, 25)

end)



getgenv().WorldToViewportPoint = function(P)

    return Camera:WorldToViewportPoint(P)

end



getgenv().WorldToScreenPoint = function(P)

    return Camera.WorldToScreenPoint(Camera, P)

end



getgenv().GetObscuringObjects = function(T)

    if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 

        local RayPos = workspace:FindPartOnRay(RNew(

            T[getgenv().AimPart].Position, Client.Character.Head.Position)

        )

        if RayPos then return RayPos:IsDescendantOf(T) end

    end

end



getgenv().GetNearestTarget = function()

    local players = {}

    local PLAYER_HOLD  = {}

    local DISTANCES = {}

    for i, v in pairs(Players:GetPlayers()) do

        if v ~= Client then

            table.insert(players, v)

        end

    end

    for i, v in pairs(players) do

        if v.Character ~= nil then

            local AIM = v.Character:FindFirstChild("Head")

            if getgenv().TeamCheck == true and v.Team ~= Client.Team then

                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude

                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)

                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)

                local DIFF = math.floor((POS - AIM.Position).magnitude)

                PLAYER_HOLD[v.Name .. i] = {}

                PLAYER_HOLD[v.Name .. i].dist= DISTANCE

                PLAYER_HOLD[v.Name .. i].plr = v

                PLAYER_HOLD[v.Name .. i].diff = DIFF

                table.insert(DISTANCES, DIFF)

            elseif getgenv().TeamCheck == false and v.Team == Client.Team then 

                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude

                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)

                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)

                local DIFF = math.floor((POS - AIM.Position).magnitude)

                PLAYER_HOLD[v.Name .. i] = {}

                PLAYER_HOLD[v.Name .. i].dist= DISTANCE

                PLAYER_HOLD[v.Name .. i].plr = v

                PLAYER_HOLD[v.Name .. i].diff = DIFF

                table.insert(DISTANCES, DIFF)

            end

        end

    end

    

    if unpack(DISTANCES) == nil then

        return nil

    end

    

    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))

    if L_DISTANCE > getgenv().AimRadius then

        return nil

    end

    

    for i, v in pairs(PLAYER_HOLD) do

        if v.diff == L_DISTANCE then

            return v.plr

        end

    end

    return nil

end



Mouse.KeyDown:Connect(function(a)

    if not (Uis:GetFocusedTextBox()) then 

        if a == AimlockKey and AimlockTarget == nil then

            pcall(function()

                if MousePressed ~= true then MousePressed = true end 

                local Target;Target = GetNearestTarget()

                if Target ~= nil then 

                    AimlockTarget = Target

                end

            end)

        elseif a == AimlockKey and AimlockTarget ~= nil then

            if AimlockTarget ~= nil then AimlockTarget = nil end

            if MousePressed ~= false then 

                MousePressed = false 

            end

        end

    end

end)



RService.RenderStepped:Connect(function()

    if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 

        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 

            CanNotify = true 

        else 

            CanNotify = false 

        end

    elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 

        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 

            CanNotify = true 

        else 

            CanNotify = false 

        end

    elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 

        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 

            CanNotify = true 

        else 

            CanNotify = false 

        end

    end

    if Aimlock == true and MousePressed == true then 

        if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 

            if getgenv().FirstPerson == true then

                if CanNotify == true then

                    if getgenv().PredictMovement == true then

                        if getgenv().Smoothness == true then

                            local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)

                            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)

                        else

                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)

                        end

                    elseif getgenv().PredictMovement == false then 

                        if getgenv().Smoothness == true then

                            local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)

                            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)

                        else

                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)

                        end

                    end

                end

            end

        end

    end

    if CheckIfJumped == true then

        if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild("Humanoid") then

            if AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then

                getgenv().AimPart = "UpperTorso"

            else

                getgenv().AimPart = getgenv().OldAimPart

            end

        end

    end

end)
