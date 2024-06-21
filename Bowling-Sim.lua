-- ID: 17165763698

local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local lp = game:GetService("Players").LocalPlayer

local Packages = replicatedStorage:WaitForChild("Packages")
local Knit = Packages:WaitForChild("Knit")

local KnitServices = Knit:WaitForChild("Services")
local PlayerResourceService = KnitServices:WaitForChild("PlayerResourceService")
local ClickService = KnitServices:WaitForChild("ClickService")
local TrainService = KnitServices:WaitForChild("TrainService")
local GameService = KnitServices:WaitForChild("GameService")
local PetLuckService = KnitServices:WaitForChild("PetLuckService")
local MapService = KnitServices:WaitForChild("MapService")

local ClickRemotes = ClickService:WaitForChild("RF")
local TrainRemotes = TrainService:WaitForChild("RF")
local GameRemoteEvents = GameService:WaitForChild("RE")
local PetLuckServiceRemotes = PetLuckService:WaitForChild("RF")
local MapRemotes = MapService:WaitForChild("RF")

function sim_click()
    ClickRemotes.Click:InvokeServer()
end

function sim_train(number)
    TrainRemotes.PlayerExercise:InvokeServer(number)
end

function get_pk_money()
    GameRemoteEvents.GetPKMoney:FireServer()
end

function hatch(egg_num)
    PetLuckServiceRemotes.LuckOnce:InvokeServer(egg_num)
end

function buy_map(map_num)
    MapRemotes.BuyMap:InvokeServer(map_num)
end

function _G.bs_close()
    if _G.bs_heartbeat then
        _G.bs_heartbeat:Disconnect()
        _G.bs_heartbeat = nil
    end
end
_G.bs_close()

_G.bs_heartbeat = runService.Heartbeat:Connect(function(delta)
    sim_click()
    sim_train(7)
    get_pk_money()
end)