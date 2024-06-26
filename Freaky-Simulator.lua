-- ID: 

if _G.FS_LOADED then
    _G.FS_LOADED = false

    if _G.FS_HEARTBEAT then
        _G.FS_HEARTBEAT:Disconnect()
    end
else
    _G.FS_LOADED = true
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")

    local lp = game:GetService("Players").LocalPlayer

    local remotes = replicatedStorage:WaitForChild("Remotes")

    local EGGS = {
        BASIC = "Basic Egg"
    }

    _G.click = function()
        remotes:WaitForChild("Clicker"):FireServer()
    end

    _G.hatch = function(egg_name, amount)
        remotes:WaitForChild("Egg"):InvokeServer(egg_name, amount)
    end

    _G.FS_HEARTBEAT = runService.Heartbeat:Connect(function(delta)
        _G.click()
    end)
end