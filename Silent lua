getgenv().Settings = {
	["Silent"] = {
		["Enabled"] = true,
		["AimPart"] = "HumanoidRootPart",
		["WallCheck"] = true,
		["Visualize"] = true,
		["Prediction"] = {
		   ["Horizontal"] = 0.15,
		   ["Vertical"] = 0.05,
		},
	    ["AutoPrediction"] = {
	        ["Enabled"] = true,
	        ["Type"] = "Normal", --//Normal, Custom
           ["ping20_30"] = 0.12588,
           ["ping30_40"] = 0.11911,
           ["ping40_50"] = 0.12471,
           ["ping50_60"] = 0.13766,
           ["ping60_70"] = 0.13731,
           ["ping70_80"] = 0.13951,
           ["ping80_90"] = 0.14181,
           ["ping90_100"] = 0.148,
           ["ping100_110"] = 0.156,
           ["ping110_120"] = 0.1567,
           ["ping120_130"] = 0.1601,
           ["ping130_140"] = 0.1637,
           ["ping140_150"] = 0.173,
           ["ping150_160"] = 0.1714,
           ["ping160_170"] = 0.1863,
           ["ping170_180"] = 0.1872,
           ["ping180_190"] = 0.1848,
           ["ping190_200"] = 0.1865,
	    },
		["Mode"] = "Namecall", --index,namecal
	},
	["FOV"] = {
		["Enabled"] = true,
		["Size"] = 35,
		["Filled"] = false,
		["Thickness"] = 0.66,
		["Transparency"] = 0.9,
		["Color"] = Color3.fromRGB(255,255,255),
	},
	["Camlock"] = {
	    ["Enabled"] = false,
	    ["AimPart"] = "HumanoidRootPart",
	    ["Prediction"] = {
	       ["Horizontal"] = 0.185,
	       ["Vertical"] = 0.1,
	    },
	    ["Smoothness"] = 0.1,
	    ["AutoPrediction"] = {
	        ["Enabled"] = false,
	        ["Type"] = "Normal", --//Normal, Custom
           ["ping20_30"] = 0.12588,
           ["ping30_40"] = 0.11911,
           ["ping40_50"] = 0.12471,
           ["ping50_60"] = 0.12766,
           ["ping60_70"] = 0.12731,
           ["ping70_80"] = 0.12951,
           ["ping80_90"] = 0.13181,
           ["ping90_100"] = 0.138,
           ["ping100_110"] = 0.146,
           ["ping110_120"] = 0.1367,
           ["ping120_130"] = 0.1401,
           ["ping130_140"] = 0.1437,
           ["ping140_150"] = 0.153,
           ["ping150_160"] = 0.1514,
           ["ping160_170"] = 0.1663,
           ["ping170_180"] = 0.1672,
           ["ping180_190"] = 0.1848,
           ["ping190_200"] = 0.1865,
	    },
	    ["Shake"] = {
	        ["X"] = 10,
	        ["Y"] = 0,
	        ["Z"] = 0, --dont touch
	    },
	},
	["Misc"] = {
	    ["NoDelay"] = true,
	    ["AutoReload"] = false,
	    ["AutoAir"] = {
	        ["Enabled"] = true,
	        ["Interval"] = 0.5,
	    },
	    ["CMDS"] = { 
	        ["Enabled"] = false,
	        ["FOVPrefix"] = "B",
	        ["Prediction"] = "A",
	   },
	},
	["Resolution"] = {
	    ["Value"] = 1,
	   },
	["Resolvers"] = {  --entirely not
	    ["Enabled"] = false,
	    ["AutoDetect"] = false,
	    ["Type"] = "Recalculator",
	},
    ["Visuals"] = {
        ["Ambient"] = {
            ["Enabled"] = false,
            ["Color"] = Color3.fromRGB(4, 0, 255),
        },
        ["OutDoor Ambient"] = {
            ["Enabled"] = false,
            ["Color"] = Color3.fromRGB(4, 0, 255)
        },
        ["Fog Modifications"] = {
            ["Enabled"] = false,
            ["Color"] = Color3.fromRGB(4, 0, 255),
            ["Start"] = 15,
            ["End"] = 100 
        },
        ["ColorCorrection"] = {
            ["Enabled"] = false,
            ["Brightness"] = 0,
            ["Saturation"] = 5,
            ["Contrast"] = 2,
        },
    },
}
-- Services
local Services = {
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    Camera = game:GetService("Workspace").CurrentCamera
}
local Functions = {}

local ActiveTracers = {}
local ActiveHighlights = {}
local ActiveBillboards = {}

local Settings = {
    ["Tracer"] = {
        ["Color"] = Color3.fromRGB(255, 255, 255),
        ["Thickness"] = 1
    },
    ["Highlight"] = {
        ["Color"] = Color3.fromRGB(255, 255, 255),
        ["FillTransparency"] = 0.7,
        ["OutlineTransparency"] = 0.2
    },
    ["Billboard"] = {
        ["TextColor"] = Color3.fromRGB(255, 255, 255),
        ["StudsOffset"] = Vector3.new(0, 3, 0),
        ["Size"] = UDim2.new(0, 200, 0, 50)
    },
    ["FacingThreshold"] = 0.9
}

Functions["CreateTracer"] = function(player)
    local tracer = Drawing.new("Line")
    tracer.Color = Settings["Tracer"]["Color"]
    tracer.Thickness = Settings["Tracer"]["Thickness"]
    tracer.Transparency = 1
    tracer.Visible = false
    return tracer
end

Functions["CreateHighlight"] = function(character)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Settings["Highlight"]["Color"]
    highlight.FillTransparency = Settings["Highlight"]["FillTransparency"]
    highlight.OutlineTransparency = Settings["Highlight"]["OutlineTransparency"]
    highlight.Parent = game:GetService("CoreGui")
    highlight.Enabled = false
    return highlight
end

Functions["CreateBillboard"] = function(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character:FindFirstChild("Head")
    billboard.Size = Settings["Billboard"]["Size"]
    billboard.StudsOffset = Settings["Billboard"]["StudsOffset"]
    billboard.AlwaysOnTop = true
    billboard.Enabled = false

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Text = player.Name
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Settings["Billboard"]["TextColor"]
    textLabel.TextStrokeTransparency = 0

    billboard.Parent = game:GetService("CoreGui")
    return billboard
end

Functions["UpdateTracer"] = function(tracer, character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local screenPosition, onScreen = Services.Camera:WorldToViewportPoint(rootPart.Position)
        if onScreen then
            tracer.From = Vector2.new(Services.Camera.ViewportSize.X / 2, Services.Camera.ViewportSize.Y / 2)
            tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
            tracer.Visible = true
        else
            tracer.Visible = false
        end
    else
        tracer.Visible = false
    end
end

Functions["IsPlayerFacing"] = function(localPlayer, targetPlayer)
    if not localPlayer.Character or not targetPlayer.Character then return false end
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not localRoot or not targetRoot then return false end

    local direction = (targetRoot.Position - localRoot.Position).Unit
    local facing = localRoot.CFrame.LookVector
    return facing:Dot(direction) > Settings["FacingThreshold"]
end

Services.RunService.Heartbeat:Connect(function()
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= Services.Players.LocalPlayer then
            if Functions["IsPlayerFacing"](Services.Players.LocalPlayer, player) then
                if not ActiveTracers[player] then
                    ActiveTracers[player] = Functions["CreateTracer"](player)
                end
                if not ActiveHighlights[player] then
                    ActiveHighlights[player] = Functions["CreateHighlight"](player.Character)
                end
                if not ActiveBillboards[player] then
                    ActiveBillboards[player] = Functions["CreateBillboard"](player)
                end

                Functions["UpdateTracer"](ActiveTracers[player], player.Character)
                ActiveHighlights[player].Enabled = true
                ActiveBillboards[player].Enabled = true
            else
                if ActiveTracers[player] then
                    ActiveTracers[player].Visible = false
                end
                if ActiveHighlights[player] then
                    ActiveHighlights[player].Enabled = false
                end
                if ActiveBillboards[player] then
                    ActiveBillboards[player].Enabled = false
                end
            end
        end
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/bobbbb-b/B/main/77_SJQ0ZC.lua"))()
