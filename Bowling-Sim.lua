local replicatedStorage = game:GetService("ReplicatedStorage")

local lp = game:GetService("Players").LocalPlayer

local Packages = replicatedStorage:WaitForChild("Packages")
local Knit = Packages:WaitForChild("Knit")

local KnitServices = Knit:WaitForChild("Services")
local PlayerResourceService = KnitServices:WaitForChild("PlayerResourceService")
local ClickService = KnitServices:WaitForChild("PlayerResourceService")
local TrainService = KnitServices:WaitForChild("TrainService")

local ClickRemotes = ClickService:WaitForChild("RF")
local TrainRemotes = TrainService:WaitForChild("RF")

RF.GetPlayerRankData:InvokeServer(lp)

function sim_click()
    ClickRemotes.Click:InvokeServer()
end

function sim_train(number)
    TrainRemotes.PlayerExercise:InvokeServer(number)
end