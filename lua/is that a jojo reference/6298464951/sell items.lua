local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local char = Players.LocalPlayer.Character

local itemsToSell = { "Steel Ball", "Stone Mask" }

for _ = 0, 10 do
    for _, v in next, itemsToSell do
        ReplicatedStorage.Events.ItemSellEvent:FireServer(char, v, v:gsub("%s", ""), "Cash", 500, 1)
    end
end