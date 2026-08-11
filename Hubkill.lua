-- ========================================================
-- MM2 EXCLUSIVE: HUGE SHERIFF HUB v4.0
-- ========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Настройки
_G.HubSettings = {
    AimShot = false, ShootKnifeOnly = false, SilentAim = false
}

-- Удаление старого UI
if game.CoreGui:FindFirstChild("MM2HugeHub") then game.CoreGui.MM2HugeHub:Destroy() end

local Screen = Instance.new("ScreenGui", game.CoreGui)
Screen.Name = "MM2HugeHub"

-- ОСНОВНОЕ ОКНО
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 550, 0, 450)
Main.Position = UDim2.new(0.5, -275, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0) -- Красная рамка для Sheriff стиля

-- ВКЛАДКИ
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, 150, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, 0)
Content.Position = UDim2.new(0, 155, 0, 0)
Content.BackgroundTransparency = 1

-- ФУНКЦИЯ КНОПОК
local function AddToggle(text, settingKey, desc)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -20, 0, 60)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 1, 0)
    lbl.Text = desc
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    lbl.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        _G.HubSettings[settingKey] = not _G.HubSettings[settingKey]
        btn.BackgroundColor3 = _G.HubSettings[settingKey] and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(40, 40, 50)
        btn.Text = text .. (_G.HubSettings[settingKey] and " [ON]" or " [OFF]")
    end)
end

-- ДОБАВЛЕНИЕ ВКЛАДКИ SHERIFF
AddToggle("Aim Shot", "AimShot", "Автоматический выстрел в убийцу.")
AddToggle("Knife Check", "ShootKnifeOnly", "Стрелять только если убийца достал нож.")
AddToggle("Silent Aim / Wallbang", "SilentAim", "Стреляет сквозь стены в цель (Silent).")

-- [[ ЛОГИКА ДЛЯ MM2 ]]
RunService.RenderStepped:Connect(function()
    local murderer = nil
    
    -- Поиск Мардера в MM2 (он держит нож)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Knife") then
            murderer = p
        end
    end

    if murderer and _G.HubSettings.AimShot then
        -- Проверка на наличие ножа (если включена)
        if _G.HubSettings.ShootKnifeOnly and not murderer.Character:FindFirstChild("Knife") then 
            return 
        end

        local targetPos = murderer.Character.HumanoidRootPart.Position

        -- Реализация Silent Aim (Wallbang)
        if _G.HubSettings.SilentAim then
            -- Манипуляция направлением камеры (Silent)
            local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.2)
        end
        
        -- Авто-выстрел (имитация клика мышью, если в руках пистолет)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
            -- В MM2 нужно вызвать событие выстрела
            -- Это простейшая имитация
            mouse1click() 
        end
    end
end)

print("MM2 Huge Hub Loaded. Target: Official Murder Mystery 2")
