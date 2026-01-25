local Core = {}
Core.__index = Core
--services basic
local Services = {
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	TweenService = game:GetService("TweenService"),
	Lighting = game:GetService("Lighting"),
	UserInputService = game:GetService("UserInputService"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	Debris = game:GetService("Debris")
}
--variable
local LocalPlayer = Services.Players.LocalPlayer
--utile
function Core:Log(...)
	if self.Debug then
		print("[CORE]", ...)
	end
end
--wait
function Core:Wait(seconds)
	seconds = seconds or 0
	local start = tick()
	while tick() - start < seconds do
		Services.RunService.Heartbeat:Wait()
	end
end
--prt
function Core:SafeCall(func, ...)
	local args = {...}
	local success, result = pcall(function()
		return func(unpack(args))
	end)

	if not success then
		warn("[CORE ERROR]:", result)
	end

	return success, result
end
--player parts
function Core:GetCharacter(player)
	player = player or LocalPlayer
	return player.Character or player.CharacterAdded:Wait()
end

function Core:GetHumanoid(player)
	local char = self:GetCharacter(player)
	return char:WaitForChild("Humanoid")
end

function Core:GetHRP(player)
	local char = self:GetCharacter(player)
	return char:WaitForChild("HumanoidRootPart")
end
--tween
function Core:Tween(instance, properties, time, easingStyle, easingDirection)
	local tweenInfo = TweenInfo.new(
		time or 0.3,
		easingStyle or Enum.EasingStyle.Quad,
		easingDirection or Enum.EasingDirection.Out
	)

	local tween = Services.TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end
--conects
Core.Connections = {}

function Core:Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(self.Connections, connection)
	return connection
end

function Core:DisconnectAll()
	for _, conn in ipairs(self.Connections) do
		if conn and conn.Disconnect then
			conn:Disconnect()
		end
	end
	table.clear(self.Connections)
end
--perfps
function Core:OptimizeFPS()
	Services.Lighting.GlobalShadows = false
	Services.Lighting.FogEnd = 1e9
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end
--ini
function Core.new(config)
	local self = setmetatable({}, Core)

	self.Debug = config and config.Debug or false

	self:Log("Core iniciado")
	return self
end

return Core
