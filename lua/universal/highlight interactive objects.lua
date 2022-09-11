-- highlights interactive objects in the game ( ProximityPrompt, Click Detectors and Touch Interests )

local genv = getgenv()
genv.instant_proximityprompt = true
genv.highlight_color = Color3.fromRGB(255, 0, 0)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local PPS = game:GetService("ProximityPromptService")

local localplayer = Players.LocalPlayer

localplayer.CharacterAppearanceLoaded:Wait()

local function highlight(obj)
	if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("TouchTransmitter") then
		if genv.highlight then
			if not CoreGui:FindFirstChild(obj:GetFullName()) then
				local Highlight = Instance.new("Highlight")
				Highlight.Adornee = obj.Parent
				Highlight.Archivable = true
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Enabled = true
				Highlight.Name = obj:GetFullName()
				Highlight.FillColor = genv.highlight_color; Highlight.FillTransparency = 0.5
				Highlight.OutlineColor = genv.highlight_color; Highlight.OutlineTransparency = 0
				Highlight.Parent = CoreGui
			end
		end
	end
end

for _, descendant in pairs(workspace:GetDescendants()) do
	highlight(descendant)
end

workspace.DescendantAdded:Connect(highlight)

localplayer.CharacterAdded:Connect(function()
	for _, descendant in pairs(workspace:GetDescendants()) do
		highlight(descendant)
	end
end)

PPS.PromptButtonHoldBegan:Connect(function(prompt)
	if genv.instant_proximityprompt then
		fireproximityprompt(prompt)
	end
end)
