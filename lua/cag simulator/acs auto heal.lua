local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
    character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")

for i = 1, 12 do
    game:GetService("ReplicatedStorage").ACS_Engine.Events.MedSys.MedHandler:FireServer(nil, i)
end

humanoid.HealthChanged:Connect(function()
    for i = 1, 12 do
        game:GetService("ReplicatedStorage").ACS_Engine.Events.MedSys.MedHandler:FireServer(nil, i)
    end
end)