-- ==================================================
-- ROBLOX ALL-IN-ONE
-- PRIVATE SERVER AUTO REJOIN + EXTREME LITE MODE
-- GAME : Fish It
-- ==================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserSettings = UserSettings()
local player = Players.LocalPlayer

-- =============================
-- PRIVATE SERVER DATA
-- =============================
local PLACE_ID = 121864768012064
local ACCESS_CODE = "87598261007287524710305984218115"

local REJOINING = false
local REJOIN_COUNT = 0

-- =============================
-- GRAPHIC SUPER MINIMUM
-- =============================
pcall(function()
    UserSettings.GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    UserSettings.GameSettings.GraphicsQualityLevel = 1
end)

-- =============================
-- EXTREME NO RENDER
-- =============================
pcall(function()
    RunService:Set3dRenderingEnabled(false)
end)

pcall(function()
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = CFrame.new(0, 1e9, 0)
end)

-- =============================
-- MATIKAN SEMUA EFFECT
-- =============================
Lighting.GlobalShadows = false
Lighting.Brightness = 0
Lighting.FogEnd = 1e9

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

-- =============================
-- RINGANKAN WORKSPACE
-- =============================
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.CastShadow = false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("Sound") then
        v.Volume = 0
        v.Playing = false
    end
end

-- =============================
-- FPS LOCK (CPU STABIL)
-- =============================
RunService.Heartbeat:Connect(function()
    task.wait(0.08) -- ~12 FPS
end)

-- =============================
-- ANTI AFK
-- =============================
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- =============================
-- AUTO REJOIN PRIVATE SERVER
-- =============================
local function rejoinPrivate()
    if REJOINING then return end
    REJOINING = true
    REJOIN_COUNT += 1

    warn("🔁 Rejoining Private Server | Count:", REJOIN_COUNT)
    task.wait(5)

    pcall(function()
        TeleportService:TeleportToPrivateServer(
            PLACE_ID,
            nil,
            {player},
            ACCESS_CODE
        )
    end)
end

player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        rejoinPrivate()
    end
end)

player.AncestryChanged:Connect(function()
    rejoinPrivate()
end)

print("🔥 ALL-IN-ONE AKTIF | PRIVATE SERVER + EXTREME MODE")
