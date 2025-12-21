-- TPWalk con toggle G

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local SPEED = 0.4

local tpwalking = true -- ACTIVADO POR DEFECTO
local runningThread = nil

--------------------------------------------------
-- FUNCIÓN TPWALK
--------------------------------------------------
local function tpwalk()
	if runningThread then return end

	runningThread = task.spawn(function()
		while tpwalking do
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

			if humanoid and humanoid.MoveDirection.Magnitude > 0 then
				local delta = RunService.Heartbeat:Wait()
				character:TranslateBy(humanoid.MoveDirection * SPEED * delta * 10)
			else
				RunService.Heartbeat:Wait()
			end
		end
		runningThread = nil
	end)
end

--------------------------------------------------
-- NOTIFICACIÓN
--------------------------------------------------
local function notify(text)
	StarterGui:SetCore("SendNotification", {
		Title = "TPWalk",
		Text = text,
		Duration = 1.5
	})
end

--------------------------------------------------
-- TOGGLE CON G
--------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		tpwalking = not tpwalking

		if tpwalking then
			notify("¡Hora de correr!⚡")
			tpwalk()
		else
			notify("Hora de caminar💤")
		end
	end
end)

--------------------------------------------------
-- RESPAWN SAFE
--------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function()
	if tpwalking then
		task.wait(0.2)
		tpwalk()
	end
end)

--------------------------------------------------
-- INICIO AUTOMÁTICO
--------------------------------------------------
notify("¡Hora de correr!⚡")
tpwalk()
