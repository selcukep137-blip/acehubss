local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({Name = "Ace Hub | Ultimate Final", LoadingTitle = "Sistem Hazır", LoadingSubtitle = "by Ace Hub"})
local Tab = Window:CreateTab("Combat & Master", 4483362456)
local TrollTab = Window:CreateTab("Troll & Chaos", 4483362456)

_G.ESP_Rainbow, _G.Hitbox, _G.Silent, _G.Spin = false, false, false, false
_G.Speed, _G.SpinSpeed, _G.FOV = 16, 5, 70

-- Silent Aim
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if _G.Silent and (method == "FireServer" or method == "InvokeServer") and (self.Name == "Shoot" or self.Name == "Fire" or self.Name == "Hit") then
        local closest = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                if d < dist then closest = p.Character.HumanoidRootPart.Position dist = d end
            end
        end
        if closest then args[2] = closest return self.FireServer(self, unpack(args)) end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- GÜNCELLEME DÖNGÜSÜ
RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = _G.FOV
    local rainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    
    if LocalPlayer.Character then
        if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed end
        
        -- Kendi Karakterin Rainbow
        if _G.ESP_Rainbow then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Color = rainbowColor end
            end
        end
    end

    -- Düşman ESP & Rainbow Highlight (Takım Arkadaşı Hariç)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local isTeammate = (LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team)
            
            if _G.ESP_Rainbow and not isTeammate then
                if not player.Character:FindFirstChild("AceHighlight") then
                    local h = Instance.new("Highlight") h.Name = "AceHighlight" h.Parent = player.Character
                end
                player.Character.AceHighlight.FillColor = rainbowColor
            elseif player.Character:FindFirstChild("AceHighlight") then 
                player.Character.AceHighlight:Destroy() 
            end
        end
    end

    -- Spin
    if _G.Spin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0)
    end

    -- Hitbox
    if _G.Hitbox then
        for _, player in pairs(Players:GetPlayers()) do
            local isTeammate = (LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team)
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not isTeammate then
                player.Character.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
                player.Character.HumanoidRootPart.Transparency = 1
            elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            end
        end
    end
end)

-- UI
Tab:CreateSection("Combat")
Tab:CreateToggle({Name = "ESP + Gökkuşağı (Düşman)", Callback = function(v) _G.ESP_Rainbow = v end})
Tab:CreateToggle({Name = "Hitbox + Silent Aim", Callback = function(v) _G.Hitbox = v _G.Silent = v end})
Tab:CreateSlider({Name = "Hız (Speed)", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(v) _G.Speed = v end})
Tab:CreateSlider({Name = "FOV", Range = {70, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) _G.FOV = v end})

TrollTab:CreateSection("Troll")
TrollTab:CreateToggle({Name = "Spin", Callback = function(v) _G.Spin = v end})
TrollTab:CreateSlider({Name = "Spin Hızı", Range = {1, 50}, Increment = 1, CurrentValue = 5, Callback = function(v) _G.SpinSpeed = v end})
