-- LocalScript, taruh di StarterGui

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ====== KORDINASI PLAYER (KANAN ATAS) ======
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0, 250, 0, 30)
coordLabel.Position = UDim2.new(1, -260, 0, 10)
coordLabel.BackgroundTransparency = 0.3
coordLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coordLabel.Font = Enum.Font.SourceSansBold
coordLabel.TextSize = 16
coordLabel.Text = "Koordinasi: X=0 Y=0 Z=0"
coordLabel.Parent = screenGui

-- Update koordinat
task.spawn(function()
	while true do
		local pos = hrp.Position
		coordLabel.Text = string.format("Koordinasi: X=%.1f Y=%.1f Z=%.1f", pos.X, pos.Y, pos.Z)
		task.wait(0.2)
	end
end)

-- ====== TOMBOL BULAT KIRI ATAS ======
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Text = "A"
toggleButton.Parent = screenGui
toggleButton.AutoButtonColor = true
toggleButton.ZIndex = 10

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = toggleButton

-- Fitur drag tombol bulat
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	toggleButton.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- ====== PANEL TENGAH ======
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 270) -- diperbesar karena ada tombol tambahan
panel.Position = UDim2.new(0.5, -150, 0.5, -135)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.Visible = false
panel.ZIndex = 5
panel.Parent = screenGui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 10)
corner2.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Teleportasi"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.ZIndex = 6
title.Parent = panel

-- Fungsi teleport cepat (smooth)
local function smoothTeleport(targetPos)
	task.spawn(function()
		for i=1,10 do
			hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.3))
			task.wait(0.05)
		end
		hrp.CFrame = CFrame.new(targetPos)
	end)
end

-- Buat tombol teleport
local function createTeleportButton(text, posY, targetVector)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.Position = UDim2.new(0.1, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = text
	btn.ZIndex = 6
	btn.Parent = panel
	
	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0, 8)
	uic.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		smoothTeleport(targetVector)
	end)
end

createTeleportButton("Penjual Pancing", 60, Vector3.new(122.6,17.5,2844.7))
createTeleportButton("Penjual Pelet", 110, Vector3.new(111.9,17.3,2866.2))
createTeleportButton("Jual Ikan", 160, Vector3.new(48.6,17.3,2865.4))
createTeleportButton("Spot Gacor", 210, Vector3.new(-3567.0, -135.0, -1278.4)) -- tombol baru

-- ====== Toggle Panel ======
local panelVisible = false
toggleButton.MouseButton1Click:Connect(function()
	panelVisible = not panelVisible
	panel.Visible = panelVisible
end)
