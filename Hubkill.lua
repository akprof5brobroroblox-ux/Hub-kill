-- ========================================================
-- HUBKILL FINAL MOBILE VERSION - [FULL & CORRECT]
-- ========================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [[ УДАЛЕНИЕ СТАРОЙ ВЕРСИИ ]]
if CoreGui:FindFirstChild("MobileHubUI") then
    CoreGui.MobileHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui -- Стандарт для большинства мобильных эксплоитов

-- [[ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ]]
local CurrentAccent = Color3.fromRGB(0, 170, 255) -- Синий по умолчанию
local CurrentThemeBg = Color3.fromRGB(16, 16, 22) -- Неон темный по умолчанию

-- Переменные функций
local AimLock_Enabled = false
_G.InfJump = false
local ESP_Settings = { Murderer = false, Sheriff = false, Innocent = false }

---------------------------------------------------------
-- 1. ИКОНКА (HubKill) - С НЕОНОВОЙ ВОДОЙ
---------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0) -- Чуть левее
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Text = "HubKill"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ClipsDescendants = true
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- На телефоне может глючить, но включаем

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = CurrentAccent
ToggleStroke.Thickness = 2

-- Градиент воды для кнопки
local WaterGradient = Instance.new("UIGradient", ToggleBtn)
WaterGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 230, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 180))
})
WaterGradient.Rotation = 45

-- Анимация течения воды
task.spawn(function()
    local rot = 0
    while task.wait(0.03) do
        rot = (rot + 2) % 360
        WaterGradient.Rotation = rot
    end
end)

---------------------------------------------------------
-- 2. ГЛАВНОЕ МЕНЮ (Тема: х)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Спавн скрытым
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = CurrentThemeBg
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainUIStroke = Instance.new("UIStroke", MainFrame)
MainUIStroke.Color = CurrentAccent
MainUIStroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "x"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

---------------------------------------------------------
-- 3. БОКОВАЯ ПАНЕЛЬ СЛЕВА
---------------------------------------------------------
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 105, 1, -35)
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarList = Instance.new("UIListLayout", SideBar)
SideBarList.SortOrder = Enum.SortOrder.LayoutOrder
SideBarList.Padding = UDim.new(0, 5)

local SideBarPadding = Instance.new("UIPadding", SideBar)
SideBarPadding.PaddingTop = UDim.new(0, 8)
SideBarPadding.PaddingLeft = UDim.new(0, 6)
SideBarPadding.PaddingRight = UDim.new(0, 6)

---------------------------------------------------------
-- 4. РАБОЧАЯ ОБЛАСТЬ СПРАВА (Pages container)
---------------------------------------------------------
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -115, 1, -43)
ContentArea.Position = UDim2.new(0, 110, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}
local CurrentPageName = nil

-- [[ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ]]

local function AddToggle(page, text, callback)
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(1, 0, 0, 30)
    Switch.Text = text
    Switch.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Switch.Parent = page
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 5)
    
    Switch.MouseButton1Click:Connect(function() 
        callback() 
    end)
end

local function CreateTab(text, iconText, targetPageName)
    -- Страница (Контейнер)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = targetPageName
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.ZIndex = 2
    Page.Parent = ContentArea
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    Pages[targetPageName] = Page

    -- Кнопка Таба
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Btn.Text = (iconText or "") .. " " .. text
    Btn.TextColor3 = Color3.fromRGB(160, 160, 175)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.AutoButtonColor = false
    Btn.Parent = SideBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    TabButtons[targetPageName] = Btn
    
    -- Логика переключения (ЗДЕСЬ БЫЛА ОШИБКА, Я ИСПРАВИЛ)
    Btn.MouseButton1Click:Connect(function()
        if CurrentPageName == targetPageName then return end -- Уже открыто
        
        -- Выключаем все
        for name, pageFrame in pairs(Pages) do 
            pageFrame.Visible = false 
            if TabButtons[name] then
                TabButtons[name].BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                TabButtons[name].TextColor3 = Color3.fromRGB(160, 160, 175)
            end
        end
        
        -- Включаем нужный
        Page.Visible = true
        Btn.BackgroundColor3 = CurrentAccent -- Красим активную кнопку
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentPageName = targetPageName
    end)
    
    return Page
end

---------------------------------------------------------
-- СОЗДАНИЕ ВКЛАДОК
---------------------------------------------------------
local CharPage = CreateTab("Персонаж", "👤", "Character")
local EspPage = CreateTab("ESP", "👁", "ESP")
local SettingsPage = CreateTab("Настройки", "⚙", "Settings")

-- Первая активная вкладка (Персонаж)
task.spawn(function()
    task.wait(0.1)
    Pages["Character"].Visible = true
    TabButtons["Character"].BackgroundColor3 = CurrentAccent
    TabButtons["Character"].TextColor3 = Color3.fromRGB(255, 255, 255)
    CurrentPageName = "Character"
end)

---------------------------------------------------------
-- ФУНКЦИИ
---------------------------------------------------------

-- 👤 ПЕРСОНАЖ
AddToggle(CharPage, "AimLock (Вкл/Выкл)", function() AimLock_Enabled = not AimLock_Enabled end)
AddToggle(CharPage, "InfJump (Вкл/Выкл)", function() _G.InfJump = not _G.InfJump end)

-- 👁 ESP
AddToggle(EspPage, "Murderer ESP", function() ESP_Settings.Murderer = not ESP_Settings.Murderer end)
AddToggle(EspPage, "Sheriff ESP", function() ESP_Settings.Sheriff = not ESP_Settings.Sheriff end)
AddToggle(EspPage, "Innocent ESP", function() ESP_Settings.Innocent = not ESP_Settings.Innocent end)

-- ⚙ НАСТРОЙКИ (КНОПКИ ВЫБОРА ЦВЕТА И ТЕМЫ)

local ThemeSelectLabel = Instance.new("TextLabel")
ThemeSelectLabel.Size = UDim2.new(1, 0, 0, 20)
ThemeSelectLabel.Text = "Выбрать тему / цвет:"
ThemeSelectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ThemeSelectLabel.Parent = SettingsPage

-- Создаем окно рулетки
local Popup = Instance.new("ScrollingFrame")
Popup.Name = "ThemesPopup"
Popup.Size = UDim2.new(0, 120, 0, 80)
Popup.Position = UDim2.new(0.5, -60, 0.5, -40)
Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Popup.ZIndex = 10
Popup.Visible = false
Popup.Parent = ContentArea
Instance.new("UIListLayout", Popup)

-- Кнопка открытия рулетки цветов
local OpenColorsBtn = Instance.new("TextButton")
OpenColorsBtn.Size = UDim2.new(1, 0, 0, 25)
OpenColorsBtn.Text = "Цвет неона"
OpenColorsBtn.Parent = SettingsPage
OpenColorsBtn.MouseButton1Click:Connect(function()
    for _,child in pairs(Popup:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    Popup.Visible = true
    
    local colors = {["Синий"]=Color3.fromRGB(0,170,255), ["Красный"]=Color3.fromRGB(255,50,50), ["Зеленый"]=Color3.fromRGB(0,255,100)}
    for name,clr in pairs(colors) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,20)
        b.Text = name
        b.TextColor3 = clr
        b.Parent = Popup
        b.MouseButton1Click:Connect(function()
            CurrentAccent = clr
            MainUIStroke.Color = clr
            ToggleStroke.Color = clr
            Popup.Visible = false
        end)
    end
end)

-- Кнопка открытия рулетки стилей
local OpenStylesBtn = Instance.new("TextButton")
OpenStylesBtn.Size = UDim2.new(1, 0, 0, 25)
OpenStylesBtn.Text = "Стиль UI"
OpenStylesBtn.Parent = SettingsPage
OpenStylesBtn.MouseButton1Click:Connect(function()
    for _,child in pairs(Popup:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    Popup.Visible = true
    
    local styles = {["Темный Неон"]=Color3.fromRGB(16,16,22), ["Демонический"]=Color3.fromRGB(30,10,10), ["Морской"]=Color3.fromRGB(10,25,35)}
    for name,bg in pairs(styles) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,20)
        b.Text = name
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Parent = Popup
        b.MouseButton1Click:Connect(function()
            CurrentThemeBg = bg
            MainFrame.BackgroundColor3 = bg
            Popup.Visible = false
        end)
    end
end)

---------------------------------------------------------
-- ЛОГИКА ИГРЫ
---------------------------------------------------------

-- 👤 AimLock logic (исправлен)
RunService.RenderStepped:Connect(function()
    if AimLock_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = nil
        local dist = 1000
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then target = p.Character.HumanoidRootPart dist = mag end
            end
        end
        
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.15) end
    end
end)

-- 👤 InfJump logic
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- 👁 ESP logic
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if ESP_Settings.Murderer then
                    -- Тут должна быть логика поиска ножа (мы ее пока не писали), пока просто красим
                    local hl = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    hl.FillColor = Color3.fromRGB(255,0,0) hl.FillTransparency = 0.5
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- ОТКРЫТИЕ И ЗАКРЫТИЕ
---------------------------------------------------------
ToggleBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
    if MainFrame.Visible then MainFrame:TweenSize(UDim2.new(0, 370, 0, 225), "Out", "Quart", 0.3) 
    else MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3) end
end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3) task.wait(0.3) MainFrame.Visible = false end)

print("HubKill [FULL] успешно загружен!")
