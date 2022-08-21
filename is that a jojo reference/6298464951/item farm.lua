-- tps you to spawned items in game, collecting must be done manually

repeat task.wait() until game:IsLoaded()

local genv = getgenv()
genv.InstantPrompt = true
genv.farming_enabled = true
genv.auto_server_hop = true

local TS = game:GetService("TeleportService")
local PPS = game:GetService("ProximityPromptService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function collect(obj)
    if genv.farming_enabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if obj and obj:IsDescendantOf(workspace.Map.Items.SpawnedItems) then
                local prompt = obj:FindFirstChild("ProximityPrompt", true)
                if prompt then
                    local cf = obj:IsA("Model") and obj:GetPivot() or obj.CFrame
                    if cf then
                        player.Character:PivotTo(cf + Vector3.new(0, 3, 0))
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end

workspace.Map.Items.SpawnedItems.ChildAdded:Connect(collect)

PPS.PromptButtonHoldBegan:Connect(function(prompt)
	if genv.InstantPrompt then
		fireproximityprompt(prompt)
	end
end)

for _, children in pairs(workspace.Map.Items.SpawnedItems:GetChildren()) do
	collect(children)
    task.wait(1)
end

if genv.auto_server_hop then
    TS:Teleport(6298464951) 
end