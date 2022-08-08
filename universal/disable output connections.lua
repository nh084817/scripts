repeat task.wait() until game:IsLoaded()

local logserivce = game:GetService("LogService")

for _, v in pairs(getconnections(logserivce.MessageOut)) do
    rconsoleprint(i)
	v:Disable()
end