-- highlights spawned items in game

repeat task.wait() until game:IsLoaded()

local genv = getgenv()
genv.highlight = true
genv.highlight_color = Color3.fromRGB(255, 0, 0)

local PPS = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local path = workspace.Map.Items.SpawnedItems

local function highlight(obj)
    local prompt = obj:FindFirstChild("ProximityPrompt", true)
	if prompt then
		if genv.InstantPrompt then
			prompt.HoldDuration = 0
		end

		if genv.highlight then
			if not CoreGui:FindFirstChild(obj:GetFullName()) then
				local Highlight = Instance.new("Highlight")
				Highlight.Adornee = obj
				Highlight.Archivable = true
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Enabled = true
				Highlight.Name = obj:GetFullName()
				Highlight.FillColor = genv.highlight_color; Highlight.FillTransparency = 0.5
				Highlight.OutlineColor = genv.highlight_color; Highlight.OutlineTransparency = 0
				Highlight.Parent = CoreGui

                obj.AncestryChanged:Connect(function()
                    if not obj or not obj:IsDescendantOf(workspace) then
                        Highlight:Destroy()
                    end
                end)
			end
		end
	end
end

for _, children in pairs(path:GetChildren()) do
	highlight(children)
end

path.ChildAdded:Connect(highlight)
player.CharacterAdded:Connect(function()
    for _, children in pairs(path:GetChildren()) do
        highlight(children)
    end
end)