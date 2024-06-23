local uis = game:GetService("UserInputService")

local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place = game.PlaceId
local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
function ListServers(cursor)
   local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
   return Http:JSONDecode(Raw)
end

function tp()
   local Server, Next; repeat
      local Servers = ListServers(Next)
      Server = Servers.data[math.random(1,50)]
      Next = Servers.nextPageCursor
   until Server
   
   TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
end

if not _G.LPS_LOADED then
   _G.LPS_LOADED = true

   local teleporting = false

   local ctrlDown = false
   local hDown = false
   uis.InputBegan:Connect(function(input, gameProcessed)
      if not gameProcessed then
         if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrlDown = true
         elseif input.KeyCode == Enum.KeyCode.H then
            hDown = true
         end

         if ctrlDown and hDown then
            if not teleporting then
               teleporting = true
               print("Teleporting...")
               local success, errormessage = pcall(tp)
               if not success then
                  warn(errormessage)
                  teleporting = false
               end
            end
         end
      end
   end)

   uis.InputEnded:Connect(function(input, gameProcessed)
      if input.KeyCode == Enum.KeyCode.LeftControl then
         ctrlDown = false
      elseif input.KeyCode == Enum.KeyCode.H then
         hDown = false
      end
   end)

else
   tp()
end