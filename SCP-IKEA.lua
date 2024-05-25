local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local gameObjects = game.Workspace:WaitForChild("GameObjects")
local physicalF = gameObjects:WaitForChild("Physical")
local characterFolder = physicalF:WaitForChild("Players")
local itemsFolder = physicalF:WaitForChild("Items")

local ITEM_PIZZA = "Pizza"
local ITEM_BURGER = "Burger"
local ITEM_COOKIE = "Cookie"

function respawn()
    lp.Character.System.Event:FireServer("Respawn")
end

function pickup()
    local args = {
        [1] = "Store",
        [2] = {
            ["Model"] = workspace.GameObjects.Physical.Items.Cookie
        }
    }

    lp.Character.System.Action:InvokeServer(unpack(args))

end

function consume(item)
    local args = {
        [1] = "Inventory_Consume",
        [2] = {
            ["Tool"] = item
        }
    }

    lp.Character.System.Action:InvokeServer(unpack(args))
end

function drop(item)
    -- Script generated by SimpleSpy - credits to exx#9394
    local args = {
        [1] = "Inventory_Drop",
        [2] = {
            ["Tool"] = item
        }
    }

    game:GetService("Players").LocalPlayer.Character.System.Action:InvokeServer(unpack(args))
end