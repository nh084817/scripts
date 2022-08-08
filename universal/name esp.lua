-- over engineered "simple" esp, too lazy to document its features n shit

local espConfiguration = {
	highlight = true,
	highlight_color = Color3.fromRGB(255, 255, 255),
	highlight_distance = 30,
	ignore_self = true,
	refresh_key = Enum.KeyCode.F1,
	show_display_names = false,
	team_color = true
}

local connections, drawlist = {}, {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local debugger = true
if not debugger then
	print = function()

	end

	warn = function()

	end
end

local proxy = {}
local genv = setmetatable(getgenv(), {
	__index = function(_, index)
		--print("__index", index)
		return proxy[index]
	end,

	__newindex = function(_, index, value)
		if not proxy[index] or proxy[index] ~= value then
			print("__newindex", index, value)
			proxy[index] = value
			if index == "ignore_self" then
				warn(value and "CASE_0A" or "CASE_0B")
				if value then
					unbindPlayer(LocalPlayer)
				else
					bindPlayer(LocalPlayer)
				end
			elseif index == "team_color" then
				warn(value and "CASE_1A" or "CASE_1B")
				modifyAllWithFunction(function(playerName, drawUi)
					local Player = Players:FindFirstChild(playerName)
					drawUi.Color = (value and Player.Team) and Player.TeamColor.Color or Color3.fromRGB(127, 127, 127)
				end)
			end
		end
	end
})

local errorHandle do 
	errorHandle = function(err)
		modifyAllWithFunction(function(playerName, drawUi)
			if drawlist[playerName] then
				drawUi:Remove()
				drawlist[playerName] = nil
			end
		end)
		rconsolewarn("An error occurred!\nError:")
		rconsolewarn(err .. "\nTraceback")
		rconsolewarn(debug.traceback())
	end
end

modifyAllWithFunction = function(func)
	for playerName, drawUi in pairs(drawlist) do
		func(playerName, drawUi)
	end
end

bindPlayer = function(player)
	if (player.Name == LocalPlayer.Name and genv.ignore_self) then return end

	local function addEsp(player)
		if not drawlist[player.Name] then
			local drawUi = Drawing.new("Text")
			drawUi.Font = 2
			drawUi.Size = 12
			drawUi.Color = (genv.team_color and player.Team) and player.TeamColor.Color or Color3.fromRGB(127, 127, 127)
			drawUi.Outline = true
			drawUi.Center = true

			drawlist[player.Name] = drawUi
		end
	end

	if player.Character and player.Character.PrimaryPart then
		addEsp(player)
	end

	connections[player.Name] = {}

	table.insert(connections[player.Name], player.CharacterAdded:Connect(function()
		addEsp(player)
	end))

	table.insert(connections[player.Name], player:GetPropertyChangedSignal("Team"):Connect(function()
		if drawlist[player.Name] then
			drawlist[player.Name].Color = (genv.team_color and player.Team) and player.TeamColor.Color or Color3.fromRGB(127, 127, 127)
		end
	end))
end

unbindPlayer = function(player)
	local t = tick()

	if drawlist[player.Name] then
		drawlist[player.Name]:Remove()
		drawlist[player.Name] = nil
	end

	if connections[player.Name] then
		for _, conn in pairs(connections[player.Name]) do
			conn:Disconnect()
		end
		connections[player.Name] = nil
	end

	warn("unbounded", player.Name, tick() - t)
end

for _, player in pairs(Players:GetPlayers()) do
	bindPlayer(player)
end

Players.PlayerAdded:Connect(bindPlayer)
Players.PlayerRemoving:Connect(unbindPlayer)

local function renderDrawlist()
	return RunService.RenderStepped:Connect(function()
		modifyAllWithFunction(function(playerName, drawUi)
			local Player = Players:FindFirstChild(playerName)
			if Player and Player.Character and Player.Character.PrimaryPart then
				local root = Player.Character.PrimaryPart
				local humanoid = Player.Character:FindFirstChild("Humanoid")

				local vector, visible = Camera:WorldToViewportPoint(root.CFrame.Position)
				drawUi.Visible = visible and humanoid and humanoid.Health > 0

				if drawUi.Visible then
					drawUi.Position = Vector2.new(vector.X, vector.Y)

					local dist = LocalPlayer:DistanceFromCharacter(root.CFrame.Position) * 0.28
					local hovering = (UIS:GetMouseLocation() - drawUi.Position).Magnitude <= genv.highlight_distance

					drawUi.Text = string.format(
						"%s %d%% %sm",
						Player.Name,
						math.round(humanoid.Health),
						math.round(dist)
					)

					if genv.highlight then
						drawUi.Color = hovering and genv.highlight_color or (genv.team_color and Player.Team) and Player.TeamColor.Color or Color3.fromRGB(127, 127, 127)
						if hovering then		
						else
							drawUi.Text = string.format("%sm", math.round(dist))
						end
					elseif genv.show_display_names then
						drawUi.Text = string.format(
							"%s %d%% %sm",
							hovering and Player.Name or Player.DisplayName,
							math.round(humanoid.Health),
							math.round(dist)
						)
					end
				end
			end
		end)
	end)
	--return conn
end

renderDrawlist()
--xpcall(renderDrawlist, errorHandle)

UIS.InputBegan:Connect(function(inputobj, gp)
	if not gp then
		if inputobj.KeyCode == genv.refresh_key then
			print(genv.refresh_key)
			for _, player in pairs(Players:GetPlayers()) do
				unbindPlayer(player)
			end

			task.wait()

			for _, player in pairs(Players:GetPlayers()) do
				bindPlayer(player)
			end
		end
	end
end)

for k, v in pairs(espConfiguration) do
	genv[k] = v
end