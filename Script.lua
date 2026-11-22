
--==================================================
-- WHITE PLASTIC GUN 2.2
-- ROBLOX STUDIO
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIGURATION
local CONFIG = {
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.65,
    Material = Enum.Material.Plastic,
    UpdateInterval = 0.25
}

local Enabled = false
local LastUpdate = 0

--==================================================
-- INTERFACE
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "WhitePlasticGun"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

local Panel = Instance.new("Frame")
Panel.Size = UDim2.fromOffset(190, 85)
Panel.Position = UDim2.new(0.5, -95, 0.5, -42)
Panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Panel.BorderSizePixel = 0
Panel.Active = true
Panel.Draggable = true
Panel.Parent = GUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Panel

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "WHITE PLASTIC GUN"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Parent = Panel

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.8, 0, 0, 32)
Toggle.Position = UDim2.new(0.1, 0, 0, 40)
Toggle.BackgroundColor3 = Color3.fromRGB(170, 45, 45)
Toggle.Text = "OFF"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.TextSize = 14
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = Panel

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 7)
ToggleCorner.Parent = Toggle

Toggle.Activated:Connect(function()
    Enabled = not Enabled

    Toggle.Text = Enabled and "ON" or "OFF"

    Toggle.BackgroundColor3 = Enabled
        and Color3.fromRGB(40, 160, 85)
        or Color3.fromRGB(170, 45, 45)
end)

--==================================================
-- REMOVE ORIGINAL APPEARANCE
--==================================================

local function removeAppearance(object)

    for _, item in ipairs(object:GetDescendants()) do

        if item:IsA("SurfaceAppearance") then
            item:Destroy()

        elseif item:IsA("Decal") or item:IsA("Texture") then
            item:Destroy()
        end

    end

    if object:IsA("MeshPart") then
        object.TextureID = ""
    end

end

--==================================================
-- CUSTOM BEAM
--==================================================

local function applyCustomBeam(handle)

    local customBeam = handle:FindFirstChild("CustomBeam", true)

    if not customBeam or not customBeam:IsA("Beam") then
        return
    end

    -- Change only its color
    customBeam.Color = ColorSequence.new(
        CONFIG.Color
    )

end

--==================================================
-- MODIFY HANDLE
--==================================================

local function applyHandle(handle)

    if not handle:IsA("MeshPart") then
        return
    end

    removeAppearance(handle)

    handle.Color = CONFIG.Color
    handle.Material = CONFIG.Material
    handle.MaterialVariant = ""
    handle.Transparency = CONFIG.Transparency

    -- Apply white CustomBeam
    applyCustomBeam(handle)

end

--==================================================
-- MODIFY GUN DISPLAY
--==================================================

local function applyDisplay(display)

    if not display:IsA("BasePart") then
        return
    end

    removeAppearance(display)

    display.Color = CONFIG.Color
    display.Material = CONFIG.Material
    display.Transparency = CONFIG.Transparency

end

--==================================================
-- FIND NEAREST GUN DISPLAY
--==================================================

local function findNearestDisplay(character)

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return nil
    end

    local folder = workspace:FindFirstChild("WeaponDisplays")

    if not folder then
        return nil
    end

    local nearest = nil
    local shortestDistance = math.huge

    for _, object in ipairs(folder:GetDescendants()) do

        if object.Name == "GunDisplay"
            and object:IsA("BasePart") then

            local distance =
                (object.Position - root.Position).Magnitude

            if distance < shortestDistance then
                shortestDistance = distance
                nearest = object
            end

        end

    end

    return nearest

end

--==================================================
-- UPDATE APPEARANCE
--==================================================

local function update()

    local character = Player.Character

    if not character then
        return
    end

    -- Only modify equipped Gun
    local gun = character:FindFirstChild("Gun")

    if gun then

        local handle = gun:FindFirstChild("Handle")

        if handle then
            applyHandle(handle)
        end

    end

    -- Find nearest GunDisplay
    local display = findNearestDisplay(character)

    if display then
        applyDisplay(display)
    end

end

--==================================================
-- MAIN LOOP
--==================================================

RunService.Heartbeat:Connect(function()

    if not Enabled then
        return
    end

    if os.clock() - LastUpdate < CONFIG.UpdateInterval then
        return
    end

    LastUpdate = os.clock()

    update()

end)

print("[White Plastic Gun 2.2] Loaded!")
