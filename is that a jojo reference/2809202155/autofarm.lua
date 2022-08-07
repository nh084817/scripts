-- https://v3rmillion.net/showthread.php?tid=1179492

if game.PlaceId ~= 2809202155 then
	return
end

task.wait(10)

-- // old code
if not game:IsLoaded() then
	game.Loaded:Wait()
end

pcall(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	local runService = game:GetService("RunService")
	local httpService = game:GetService("HttpService")

	local repStorage = game:GetService("ReplicatedStorage")
	local repFirst = game:GetService("ReplicatedFirst")

	local itemFolder = workspace.Item_Spawns.Items
	local itemSpawn = repFirst.ItemSpawn

	local blacklistedItems = {
		"Stand Arrow",
		"Umbrella",
		"Requiem Arrow",
		"Bat",
		"Pizza",
		"Tea",
		"Boxing Gloves",
		"Pluck",
		"Voicelines",
		"Item-Spawn Notifier",
		"Select Pose",
	}
	local valueItems = {
		"Gold Coin",
		"Rokakaka",
		"Lucky Arrow",
		"DEO's Diary",
		"Rib Cage of The Saint's Corpse",
		"Left Arm of The Saint's Corpse",
		"Pelvis of the Saint's Corpse",
		"Heart of the Saint's Corpse",
	}

	local remoteKey = nil
	do
		for _, v in next, getloadedmodules() do
			if v.Name == "Client" then
				remoteKey = getsenv(v).A[2]
			end
		end

		if not remoteKey then
			return error("Failed to get remote key")
		end
	end

	local oldNameCall, oldVector3
	do
		oldNameCall = hookmetamethod(
			game,
			"__namecall",
			newcclosure(function(self, ...)
				local arguments = { ... }
				local namecall_method = getnamecallmethod()

				if tostring(self) == "Returner" and arguments[1] == "idklolbrah2de" then
					return remoteKey
				end
				return oldNameCall(self, ...)
			end)
		)

		oldVector3 = hookmetamethod(
			Vector3.new(),
			"__index",
			newcclosure(function(self, index)
				if (index):lower() == "magnitude" and getcallingscript() == itemSpawn then
					return math.random(0, 1)
				end

				return oldVector3(self, index)
			end),
			false
		)
	end

	do
		for _, v in next, getconnections(LocalPlayer.Idled) do
			v:Disable()
		end
	end

	local function getCharacter()
		return LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
	end

	local teleportCallback = true
	do
		task.wait(2)

		runService.Stepped:Connect(function()
			if LocalPlayer.Backpack:FindFirstChild("Gold Coin") then
				getCharacter().RemoteEvent:FireServer(
					"EndDialogue",
					{ NPC = "Item Machine", Option = "Option1", Dialogue = "Dialogue1" }
				)
				task.wait(1)
			end
            --[[
			if LocalPlayer.PlayerGui:FindFirstChild("RollingItem") then
                LocalPlayer.PlayerGui:FindFirstChild("RollingItem"):Destroy();
			end
            ]]
            for _, v in next, LocalPlayer.PlayerGui:GetChildren() do
                if v.Name == "RollingItem" then
                    v.Enabled = false;
                end
            end

			for _, v in next, itemFolder:GetChildren() do
				for _, v2 in next, v:GetChildren() do
					if v2 and v2:IsA("BasePart") then
						if teleportCallback and v2.Transparency ~= 1 then
							getCharacter().PrimaryPart.CFrame = v2.CFrame
							teleportCallback = false
							task.wait(0.6)

							if (v2.Position - getCharacter().PrimaryPart.Position).magnitude <= 5 then
								if v2.Transparency ~= 1 then
									if v:FindFirstChildWhichIsA("ClickDetector") then
										if v.ClickDetector:IsDescendantOf(game) then
											task.defer(fireclickdetector, v.ClickDetector)
											task.wait(2)
											teleportCallback = true
										end
									end
								end
							end

							teleportCallback = true
							task.wait(0.6)
						end
					end
				end
			end

			pcall(function()
				for _, v in next, LocalPlayer.Backpack:GetChildren() do
					if
						v:IsA("Tool") --[[and v ~= nil and v.Parent and v.Parent ~= nil]]
						and not table.find(blacklistedItems, v.Name)
						and not table.find(valueItems, v.Name)
						--and v.Name ~= "Gold Coin"
						and not string.find(v.Name, "Redeemed")
					then
						task.wait()

						repeat
							task.wait()

							v.Parent = getCharacter()
							getCharacter().RemoteEvent:FireServer(
								"EndDialogue",
								{ NPC = "Merchant", Option = "Option1", Dialogue = "Dialogue5" }
							)

							task.wait()
						until LocalPlayer.PlayerStats.Money.Value == 30000
					end
				end
			end)
		end)
	end
end)

print("helol")
