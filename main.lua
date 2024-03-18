-- player (1, 1, 1)
-- target (5, 5, 5)

-- tooloffset = target-player
-- (4, 4, 4)


-- playerlocation + offset = target location



-- Globals
local hitmanEnabled = false
local lockEnabled = false

local PredictionValue = 0.146

local hitmanTarget = ""
local lockTarget = ""

local lockBind = "x"

local wkPlayer = game.Workspace.Players[game.Players.LocalPlayer.Name]


-- ui 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "Hood Hitman",
   LoadingTitle = "Loading..",
   LoadingSubtitle = "by bznel",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "hitman"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = false 
   }
})

local TargetTab = Window:CreateTab("Target", 4483362458)

local Selection = TargetTab:CreateSection("Selection")

local targetDisplay = TargetTab:CreateLabel("N/A")


local targetInput = TargetTab:CreateInput({
   Name = "Target Name",
   PlaceholderText = "display or username..",
   RemoveTextAfterFocusLost = false,
   Callback = function(input)
   		for _, player in game.Players:GetChildren() do
					local name = player.Name
					local display = player.DisplayName

					local check = ""
					local iteration = 1
					
					for char in input:gmatch"." do
    					check = string.lower(check .. char)

							local userCheck = string.lower(string.sub(name, 1, iteration))
							local displayCheck = string.lower(string.sub(display, 1, iteration))

							if userCheck == check or displayCheck == check then
								hitmanTarget = name
								targetDisplay:Set(hitmanTarget)
								break
							end
							
							iteration = iteration + 1
					end
			end
   end,
})

local HitmanToggle = TargetTab:CreateToggle({
   Name = "Hitman",
   CurrentValue = false,
   Callback = function(Value)
  		hitmanEnabled = Value
   end,
})

local LockTab = Window:CreateTab("Lock", 4483362458)

local SilentAim = LockTab:CreateSection("Silent Aim")
local SilentToggle = LockTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Callback = function(Value)
  		lockEnabled = Value
   end,
})

function setPred() 
			local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local split = string.split(pingvalue,'(')
            local ping = tonumber(split[1])
						
            if ping < 130 then
                PredictionValue = 0.151
            elseif ping < 125 then
                PredictionValue = 0.149
            elseif ping < 110 then
                PredictionValue = 0.146
            elseif ping < 105 then
                PredictionValue = 0.138
            elseif ping < 90 then
                PredictionValue = 0.136
            elseif ping < 80 then
                PredictionValue = 0.134
            elseif ping < 70 then
                PredictionValue = 0.131
            elseif ping < 60 then
                PredictionValue = 0.1229
            elseif ping < 50 then
                PredictionValue = 0.1225
            elseif ping < 40 then
                PredictionValue = 0.1256
            end
end

function getClosestPlayerToCursor()
        local closestPlayer
        local shortestDistance = Settings.FOV

        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
        return closestPlayer.Name
end

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
        if key == LockBind and lockEnabled then
						if lockTarget == "" then
							lockTarget = getClosestPlayerToCursor()

							game.StarterGui:SetCore("SendNotification", {
                        Title = "Hitman";
                        Text = "Target: "..tostring(lockTarget),
                        Duration = 3
              })

							local high = Instance.new("Highlight", game.Workspace.Players[lockTarget].HumanoidRootPart)
							high.Name = "lockHighlight"
							
				
						else 
							game.Workspace.Players[lockTarget].HumanoidRootPart:WaitForChild("lockHighlight"):Destroy()
							
							lockTarget = ""

							game.StarterGui:SetCore("SendNotification", {
                        Title = "Hitman";
                        Text = "Unlocked",
                        Duration = 3
              })
	
							
							
						end
						
           
        end
end)

game:GetService("RunService").Stepped:Connect(function()
  
	if hitmanEnabled == false then
        print("Hitman off!") 
        return 
    else 
        local success, response = pcall(function()
            setPred() 
        
            local targetPosition = game.Workspace.Players[hitmanTarget].HumanoidRootPart.CFrame

            local playerPosition = wkPlayer.HumanoidRootPart.CFrame
            
            for _, item in wkPlayer:GetChildren() do
                if item:IsA("Tool") then
                
                    local offset = CFrame.new(
                        targetPosition.X - playerPosition.X,
                        targetPosition.Y - playerPosition.Y,
                        targetPosition.Z - playerPosition.Z
                    ) -- maybe add orbiting, but prob better with gun right next to target
                    
                    item.Grip = offset


                    -- change orientation if needed:
                    -- item.Handle.Part.Rotation = Vector3

                    
                end
            end
        end)
        
    end


end)

-- silent aim 

-- local mt = getrawmetatable(game)
-- local old = mt.__namecall
-- setreadonly(mt, false)
-- mt.__namecall = newcclosure(function(...)
--         local args = {...}

-- 				if not getnamecallmethod() == "FireServer" or not args[2] == "UpdateMousePos" or Plr.Character == nil then return end

				
				
--         if hitmanEnabled then

-- 						local targetSpot = game.Workspace.Players[hitmanTarget].Character["HumanoidRootPart"]
--             args[3] = targetSpot.Position+(targetSpot.Velocity*PredictionValue)


--             return old(unpack(args))
--         end

-- 				if lockEnabled then
-- 						local targetSpot = game.Workspace.Players[lockTarget].Character["HumanoidRootPart"]
-- 						args[3] = targetSpot.Position+(targetSpot.Velocity*PredictionValue)
-- 				end
				
--         return old(...)
-- end)
