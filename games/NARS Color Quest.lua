-- Redeem Codes
local codes = {"LOOKBOOK", "10KLIKES", "18KLIKES", "30KLIKES"}
for i, code in ipairs(codes) do
	coroutine.wrap(function()
		game:GetService("ReplicatedStorage").Common.remote.PromoCodes:InvokeServer(code)
	end)()
end


local dataModule = require(game:GetService("ReplicatedStorage").Common.gameplay.data)

local function getClientData()
	return debug.getupvalue(dataModule.resetPlayerData, 1)[game.Players.LocalPlayer]
end

--// Get NARS Flower Necklace
game:GetService("ReplicatedStorage").Common.remote.ConversationTag:FireServer("mrNars")
game:GetService("ReplicatedStorage").Common.remote.speakWith:FireServer(workspace.AlwaysScreenshot.MrNarsRig)

--// Completing all challenges
local function completeChallenge(name, amount)
	for i=0, amount do
		game:GetService("ReplicatedStorage").Common.remote.addChallengePoint:FireServer(name, "nil")
		task.wait(0.08)
	end
end

for name, tbl in pairs(getClientData().challengesData) do
	coroutine.wrap(function()
		repeat
			completeChallenge(name, tbl.PointsNeeded - tbl.CurrentPoints)
		until getClientData().challengesData[name].Completed == true
		task.wait(0.1)

		game:GetService("ReplicatedStorage").Common.remote.giveSandDollars:FireServer(name, tbl.SandDollarReward)
		warn("Completed:", name)
	end)()
end

while true do
	task.wait(0.2)
	local totalFalse = 0

	for name, tbl in pairs(getClientData().challengesData) do
		if tbl.Completed == false then
			totalFalse += 1
		end
	end

	if totalFalse == 0 then
		break
	end
end


for name, tbl in pairs(require(game:GetService("ReplicatedStorage").Common.gameplay.shopItems)) do
	if -tbl.SandDollarsPrice and tbl.Type == "UGC" then
		coroutine.wrap(function()
			game:GetService("ReplicatedStorage").Common.remote.purchaseItem:InvokeServer(name)
		end)()
	end
end
