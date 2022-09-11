-- tps you to spawned items in game, collecting must be done manually. cba to make auto collect function

repeat task.wait() until game:IsLoaded()

task.wait(10)

local genv = getgenv()
genv.autoServerHop = true
genv.instantPrompt = true
genv.waitTime = 0.5
genv.manualCollection = true

local https = game:GetService("HttpService")
local TS = game:GetService("TeleportService")
local PPS = game:GetService("ProximityPromptService")
local Players = game:GetService("Players")

local httprequest = syn and syn.request or http and http.request or fluxus and fluxus.request or request or http_request
local player = Players.LocalPlayer

local function collect(item)
		if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			if item and item:IsDescendantOf(workspace.Map.Items.SpawnedItems) then
				local cf = item:IsA("Model") and item:GetPivot() or item.CFrame
				local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
				if cf and prompt then
					player.Character:PivotTo(CFrame.new(cf.Position + Vector3.new(0, player.Character.Humanoid.HipHeight, 0)))
					task.wait(0.2)
					fireproximityprompt(prompt)
				end
				--repeat task.wait() until not item or not item:IsDescendantOf(workspace) 
			end
		end
end

PPS.PromptButtonHoldBegan:Connect(function(prompt)
	if genv.instantPrompt then
		fireproximityprompt(prompt)
	end
end)

for _, item in pairs(workspace.Map.Items.SpawnedItems:GetChildren()) do
	collect(item)
	task.wait(genv.waitTime)
end

workspace.Map.Items.SpawnedItems.ChildAdded:Connect(collect)

-- courtesy of EdgeIY Infinite Yield
if genv.autoServerHop then
	if httprequest then
		local servers = {}
		local req = httprequest({ Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId) })
		local body = https:JSONDecode(req.Body)

		if body and body.data then
			for _, v in next, body.data do
				if typeof(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, v.id)
				end 
			end
		end

		if #servers > 0 then
			local success = pcall(function()
				TS:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
			end)
			
            while not success do
                success = pcall(function()
                    TS:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
                end)
                task.wait(2)
            end
		end
	end
end