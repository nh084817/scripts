-- https://v3rmillion.net/showthread.php?tid=1179492

if game.PlaceId ~= 2809202155 then
	return
end

-- // old code
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local runService = game:GetService("RunService")

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local genv = getgenv()

genv.blacklistedItems = {
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

genv.valueItems = {
	--"Gold Coin",
	"Pure Rokakaka",
	"Lucky Arrow",
	"Dio's Diary",
	--"Rib Cage of The Saint's Corpse",
	"Left Arm of The Saint's Corpse",
	"Pelvis of the Saint's Corpse",
	"Heart of the Saint's Corpse",
}

local function main(item)
	if
		item ~= nil and item.Parent and item.Parent ~= nil
		and item:IsA("Tool")
		and item.Name ~= "Gold Coin"
		and not table.find(genv.blacklistedItems, item.Name)
		and not table.find(genv.valueItems, item.Name)
		and not string.find(item.Name, "Redeemed")
	then
		if LocalPlayer.PlayerStats.Money.Value ~= 30000 then
			task.wait()
			if item.Parent ~= getCharacter() then
				item.Parent = getCharacter()
				getCharacter().RemoteEvent:FireServer(
					"EndDialogue",
					{ NPC = "Merchant", Option = "Option1", Dialogue = "Dialogue5" }
				)
				task.wait()
			end
		end
	end
end

for _, v in next, LocalPlayer.Backpack:GetChildren() do
	main(v)
end

LocalPlayer.Backpack.ChildAdded:Connect(function(item)
	task.defer(main(item))
end)

LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
	task.defer(function()
		if child:IsA("ScreenGui") and child.Name == "RollingItem" then
			--child:Destroy()
			child.Enabled = false
		end
	end)
end)

--runService.Stepped:Connect(function(time, deltaTime)
while LocalPlayer.Backpack:FindFirstChild("Gold Coin") do
	if LocalPlayer.Backpack:FindFirstChild("Gold Coin") then
		getCharacter().RemoteEvent:FireServer(
			"EndDialogue",
			{ NPC = "Item Machine", Option = "Option1", Dialogue = "Dialogue1" }
		)
		--task.wait(1)
	end
	task.wait()
end--)
