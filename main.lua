-- TPWalk estable con Toggle G

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local SPEED = 16 -- velocidad real (ajusta si quieres)

local tpwalking = true
local connection = nil

--------------------------------------------------
-- NOTIFICACIÓN
--------------------------------------------------
local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 1.5
		})
	end)
end

--------------------------------------------------
-- START TPWALK
--------------------------------------------------
local function startTPWalk()
	if connection then return end

	connection = RunService.Heartbeat:Connect(function(dt)
		if not tpwalking then return end

		local char = LocalPlayer.Character
		if not char then return end

		local hum = char:FindFirstChildWhichIsA("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end

		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0 then
			hrp.CFrame = hrp.CFrame + (moveDir * SPEED * dt)
		end
	end)
end

--------------------------------------------------
-- STOP TPWALK
--------------------------------------------------
local function stopTPWalk()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

--------------------------------------------------
-- TOGGLE G
--------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		tpwalking = not tpwalking

		if tpwalking then
			startTPWalk()
			notify("TPWALK ⚡", "Activado")
		else
			stopTPWalk()
			notify("TPWALK 💤", "Desactivado")
		end
	end
end)

--------------------------------------------------
-- RESPAWN SAFE
--------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.2)
	if tpwalking then
		startTPWalk()
	end
end)

--------------------------------------------------
-- AUTO START
--------------------------------------------------
startTPWalk()
