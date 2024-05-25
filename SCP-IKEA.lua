print("Loading SCIP-IKEA...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local gameObjects = game.Workspace:WaitForChild("GameObjects")
local physicalF = gameObjects:WaitForChild("Physical")
local characterFolder = physicalF:WaitForChild("Players")
local itemsFolder = physicalF:WaitForChild("Items")

local nearestItems = {}
local esps = {}
local createdInstances = {}

local ITEM_PIZZA = "Pizza"
local ITEM_BURGER = "Burger"
local ITEM_COOKIE = "Cookie"
local ITEM_LEMON = "Lemon"

function respawn()
    lp.Character.System.Event:FireServer("Respawn")
end

function pickup(itemModel)
    local args = {
        [1] = "Store",
        [2] = {
            ["Model"] = itemModel
        }
    }

    lp.Character.System.Action:InvokeServer(unpack(args))
end

function consume(itemName)
    local args = {
        [1] = "Inventory_Consume",
        [2] = {
            ["Tool"] = itemName
        }
    }

    lp.Character.System.Action:InvokeServer(unpack(args))
end

function drop(itemName)
    local args = {
        [1] = "Inventory_Drop",
        [2] = {
            ["Tool"] = itemName
        }
    }

    game:GetService("Players").LocalPlayer.Character.System.Action:InvokeServer(unpack(args))
end

function whistle()
    lp.Character.System.Action:InvokeServer("Whistle")
end

-- Create a destroyable ESP
function createEsp(basepart:BasePart)
	local highlight = create("Highlight")
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	
	local gui = create("BillboardGui")
	gui.AlwaysOnTop = true
	gui.Enabled = true
	gui.Size = UDim2.new(0, 100, 0, 25)
	
	local textlabel = create("TextLabel")
	textlabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textlabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textlabel.BackgroundTransparency = 0.25
	textlabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
	textlabel.BorderMode = Enum.BorderMode.Inset
	textlabel.BorderSizePixel = 1
	textlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textlabel.Size = UDim2.new(1, 0, 1, 0)
	textlabel.Visible = true
	textlabel.FontFace = Font.new("Inconsolota", Enum.FontWeight.Light, Enum.FontStyle.Normal)
	textlabel.Text = "[ITEM] [#DIST]"
	textlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textlabel.TextScaled = true
	textlabel.Parent = gui
	
	gui.Parent = basepart
	highlight.Parent = basepart
	
	esps[basepart.Name] = basepart
	
	local connection = RunService.Heartbeat:Connect(function(delta)
		local distance = getDistanceFromPlr(basepart)
		textlabel.Text = "["..basepart.Name.."] ["..math.round(distance).."]"
	end)
	
	textlabel.Destroying:Connect(function()
		connection:Disconnect()
	end)
end

function create(className:string)
	local inst = Instance.new(className)
	createdInstances[#createdInstances+1] = Instance.new(className)
end

function getDistanceFromPlr(p:BasePart) 
	return (p.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude
end

function updateNearestItems()
	local instances = itemsFolder:GetChildren()
	for _, inst in pairs(instances) do
		local id = tostring(inst.Name)
		local root = inst:FindFirstChildWhichIsA("BasePart")
		
		if root then
			if nearestItems[id] then
				if (getDistanceFromPlr(nearestItems[id]) > getDistanceFromPlr(root)) then
					nearestItems[id] = root
					print("New item!")
				end
			else
				nearestItems[id] = root
			end
		end
	end
end

function loadUI()

end

local loaded, errormessage = pcall(loadUI())

local frameConnection = RunService.Heartbeat:Connect(function(delta)
	updateNearestItems()
    print(nearestItems)
end)