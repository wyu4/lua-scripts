function _G.ks_close()
    local oldProcessClosed, oldProcessClosingError = pcall(function()
        if (_G.ks_heartbeat ~= null) then
            _G.ks_heartbeat:Disconnect()
            _G.ks_heartbeat = null
        end
    
        if (_G.ks_heartbeat2 ~= null) then
            _G.ks_heartbeat2:Disconnect()
            _G.ks_heartbeat2 = null
        end
    
        if (_G.esps ~= null) then
            for _, v in pairs(_G.esps) do
                v[2]:Destroy()
                v[3]:Destroy()
                v[4]:Disconnect()
            end
            _G.esps = null
        end
        print("Old process closed.")
    end)
end
_G.ks_close()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

local gameObjects = game.Workspace:WaitForChild("GameObjects")
local physicalF = gameObjects:WaitForChild("Physical")
local characterFolder = physicalF:WaitForChild("Players")
local itemsFolder = physicalF:WaitForChild("Items")

local nearestItems = {}
_G.esps = {}

local ITEM_PIZZA = "Pizza"
local ITEM_BURGER = "Burger"
local ITEM_COOKIE = "Cookie"
local ITEM_LEMON = "Lemon"

function respawn()
    lp.Character.System.Event:FireServer("Respawn")
end

function pickup(itemModel)
    lp.Character.System.Action:InvokeServer("Store", itemModel)
end

function consume(itemName)
    lp.Character.System.Action:InvokeServer("Inventory_Consume", itemName)
end

function drop(itemName)
    game:GetService("Players").LocalPlayer.Character.System.Action:InvokeServer("Inventory_Drop", itemName)
end

function whistle()
    lp.Character.System.Action:InvokeServer("Whistle")
end

-- Create a destroyable ESP
function createEsp(basepart:BasePart)
	_G.esps[basepart.Parent.Name] = {}
	
	local highlight = Instance.new("Highlight")
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	
	local gui = Instance.new("BillboardGui")
	gui.AlwaysOnTop = true
	gui.Enabled = true
	gui.Size = UDim2.new(0, 100, 0, 25)
	
	local textlabel = Instance.new("TextLabel")
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
	
	local connection = RunService.Heartbeat:Connect(function(delta)
		local s, e = pcall(function()
			local distance = getDistanceFromPlr(basepart)
			textlabel.Text = "["..basepart.Parent.Name.."] ["..math.round(distance).."]"
		end)
	end)
	
	_G.esps[basepart.Parent.Name] = {basepart, highlight, gui, connection}
end

function getDistanceFromPlr(p:BasePart) 
	local dist
    local s, e = pcall(function()
        dist = (p.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude
    end)
    if s then
        return dist
    end
    return 0
end

function updateNearestItems()
	local instances = itemsFolder:GetChildren()
	for _, inst in pairs(instances) do
		if (inst.Parent ~= nil) then
			local id = tostring(inst.Name)
			local root = inst:FindFirstChildWhichIsA("BasePart")

			if root then
				if nearestItems[id] then
					if (getDistanceFromPlr(nearestItems[id]) > getDistanceFromPlr(root)) then
						nearestItems[id] = root
					end
				else
					nearestItems[id] = root
				end
			end
		end
	end
end

_G.ks_heartbeat = RunService.Heartbeat:Connect(function(delta)
    -- ESP stuff
	updateNearestItems()
	for id, item in pairs(nearestItems) do
		if (item.Parent ~= null) then
            if (_G.esps[id]) then
                if (_G.esps[id][1] ~= item) then
                    _G.esps[id][2]:Destroy()
                    _G.esps[id][3]:Destroy()
                    _G.esps[id][4]:Disconnect()
                    createEsp(item)
                end
            else
                createEsp(item)
            end
        end
	end
end)

-- _G.ks_heartbeat2 = RunService.Heartbeat:Connect(function(delta)
--     -- Auto collect items on mouse hover
--     local target = mouse.Target
--     if (target) then
--         if target:IsA("BasePart") then
--             local g = target.Parent
--             if (g.Parent == itemsFolder) then
--                 -- pickup(g)
--             end
--         elseif target:IsA("Model") then
--             if (target.Parent == itemsFolder) then
--                 -- pickup(target)
--             end
--         end
--     end
-- end)

respawn()