-- electric state dark rp esp, highlights money printers, materials, loots and crates

local genv = getgenv()
genv.highlight_color = Color3.fromRGB(255, 0, 0)

local CoreGui = game:GetService("CoreGui")

local function highlight(obj)
	if obj:IsA("Model") and obj.PrimaryPart then
        local uses = obj:FindFirstChild("Uses", true)
        if uses and uses:IsA("IntValue") and uses.Value ~= 0 then return end

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
        end
	end
end

for _, v in pairs(workspace.MoneyPrinters:GetChildren()) do
    highlight(v)
end

for _, v in pairs(workspace.Loot:GetChildren()) do
    highlight(v)
end

for _, v in pairs(workspace.Materials:GetChildren()) do
    highlight(v)
end

for _, v in pairs(workspace.Entities:GetChildren()) do
    highlight(v)
end

workspace.MoneyPrinters.ChildAdded:Connect(highlight)
workspace.Loot.ChildAdded:Connect(highlight)
workspace.Materials.ChildAdded:Connect(highlight)
workspace.Entities.ChildAdded:Connect(highlight)