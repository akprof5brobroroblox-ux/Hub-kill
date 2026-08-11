-- ========================================================
-- HUBKILL MEGA PRO - ALL FEATURES + MM2 SHERIFF TAB
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Очистка старой версии
if CoreGui:FindFirstChild("MobileHubUI") then
    CoreGui.MobileHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local CurrentAccent = Color3.fromRGB(0, 170, 255)
local CurrentThemeBg = Color3.fromRGB(16, 16, 22)
local CurrentLang = "RU"

-- [[ ГЛОБАЛЬНЫЕ НАСТРОЙКИ ]]
_G.HubKill_Settings = {
    AimLock = false,
    InfJump = false,
    ESP_Murd = false,
    ESP_Sher = false,
    ESP_Inn = false,
    AimShot = false,
    ShootKnifeOnly = false,
    SilentAim = false
}

-- [[ СЛОВАРЬ ЯЗЫКОВ (10 СТРАН) ]]
local Translations = {
    RU = {Title="Персонаж", ESP="ESP", Settings="Настройки", Sheriff="Шериф", Aim="AimLock", Jump="InfJump", Murd="Murderer ESP", Sher="Sheriff ESP", Inn="Innocent ESP", Lang="Язык / Language", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    EN = {Title="Character", ESP="ESP", Settings="Settings", Sheriff="Sheriff", Aim="AimLock", Jump="InfJump", Murd="Murderer ESP", Sher="Sheriff ESP", Inn="Innocent ESP", Lang="Language", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    ES = {Title="Personaje", ESP="ESP", Settings="Ajustes", Sheriff="Alguacil", Aim="AimLock", Jump="InfJump", Murd="Asesino ESP", Sher="Alguacil ESP", Inn="Inocente ESP", Lang="Idioma", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    DE = {Title="Charakter", ESP="ESP", Settings="Einstellungen", Sheriff="Sheriff", Aim="AimLock", Jump="InfJump", Murd="Mörder ESP", Sher="Sheriff ESP", Inn="Unschuldig ESP", Lang="Sprache", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    FR = {Title="Personnage", ESP="ESP", Settings="Paramètres", Sheriff="Chérif", Aim="AimLock", Jump="InfJump", Murd="Meurtrier ESP", Sher="Chérif ESP", Inn="Innocent ESP", Lang="Langue", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    PT = {Title="Personagem", ESP="ESP", Settings="Configurações", Sheriff="Xerife", Aim="AimLock", Jump="InfJump", Murd="Assassino ESP", Sher="Xerife ESP", Inn="Inocente ESP", Lang="Idioma", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    TR = {Title="Karakter", ESP="ESP", Settings="Ayarlar", Sheriff="Şerif", Aim="AimLock", Jump="InfJump", Murd="Katil ESP", Sher="Şerif ESP", Inn="Masum ESP", Lang="Dil", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    VI = {Title="Nhân vật", ESP="ESP", Settings="Cài đặt", Sheriff="Cảnh sát", Aim="AimLock", Jump="InfJump", Murd="Sát thủ ESP", Sher="Cảnh sát ESP", Inn="Dân thường ESP", Lang="Ngôn ngữ", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    ID = {Title="Karakter", ESP="ESP", Settings="Pengaturan", Sheriff="Deputi", Aim="AimLock", Jump="InfJump", Murd="Pembunuh ESP", Sher="Deputi ESP", Inn="Warga ESP", Lang="Bahasa", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"},
    PL = {Title="Postać", ESP="ESP", Settings="Ustawienia", Sheriff="Szeryf", Aim="AimLock", Jump="InfJump", Murd="Morderca ESP", Sher="Szeryf ESP", Inn="Niewinny ESP", Lang="Język", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim"}
}

---------------------------------------------------------
-- 1. ИКОНКА СВОРАЧИВАНИЯ (Квадрат)
---------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Text = "HubKill"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = CurrentAccent
ToggleStroke.Thickness = 2

---------------------------------------------------------
-- 2. ГЛАВНОЕ МЕНЮ (ОГРОМНОЕ 500x320)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 0, 0, 0)
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
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "HubKill Mega Pro"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Кнопка 1: Зеленый кружок (Декор)
local GreenDot = Instance.new("Frame")
GreenDot.Size = UDim2.new(0, 12, 0, 12)
GreenDot.Position = UDim2.new(1, -65, 0.5, -6)
GreenDot.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
GreenDot.Parent = Header
Instance.new("UICorner", GreenDot).CornerRadius = UDim.new(1, 0)

-- Кнопка 2: Желтый кружок (Сворачивает в синий квадрат)
local YellowExitBtn = Instance.new("TextButton")
YellowExitBtn.Size = UDim2.new(0, 14, 0, 14)
YellowExitBtn.Position = UDim2.new(1, -45, 0.5, -7)
YellowExitBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
YellowExitBtn.Text = ""
YellowExitBtn.Parent = Header
Instance.new("UICorner", YellowExitBtn).CornerRadius = UDim.new(1, 0)

-- Кнопка 3: Красный крестик (Вызывает окно подтверждения)
local RedExitBtn = Instance.new("TextButton")
RedExitBtn.Size = UDim2.new(0, 14, 0, 14)
RedExitBtn.Position = UDim2.new(1, -25, 0.5, -7)
RedExitBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
RedExitBtn.Text = "✕"
RedExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RedExitBtn.TextSize = 9
RedExitBtn.Font = Enum.Font.GothamBold
RedExitBtn.Parent = Header
Instance.new("UICorner", RedExitBtn).CornerRadius = UDim.new(1, 0)

---------------------------------------------------------
-- 3. ОКНО ПОДТВЕРЖДЕНИЯ ВЫХОДА (ПО КРАСНОМУ КРЕСТИКУ)
---------------------------------------------------------
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 220, 0, 110)
ConfirmFrame.Position = UDim2.new(0.5, -110, 0.5, -55)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ConfirmFrame.ZIndex = 20
ConfirmFrame.Visible = false
ConfirmFrame.Parent = ScreenGui
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame)
ConfirmStroke.Color = Color3.fromRGB(230, 50, 50)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 50)
ConfirmText.Text = "Are you sure?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.BackgroundTransparency = 1
ConfirmText.ZIndex = 21
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 85, 0, 30)
YesBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
YesBtn.Text = "Yes (Exit)"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 21
YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 85, 0, 30)
NoBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
NoBtn.Text = "Keep"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 21
NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

RedExitBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local function MinimizeMenu()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3)
    task.wait(0.3)
    MainFrame.Visible = false
end

YellowExitBtn.MouseButton1Click:Connect(MinimizeMenu)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible 
    if MainFrame.Visible then MainFrame:TweenSize(UDim2.new(0, 500, 0, 320), "Out", "Quart", 0.3) 
    else MinimizeMenu() end
end)

---------------------------------------------------------
-- 4. БОКОВАЯ ПАНЕЛЬ И СТРАНИЦЫ
---------------------------------------------------------
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 115, 1, -35)
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -125, 1, -43)
ContentArea.Position = UDim2.new(0, 120, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreateTab(key, iconText, targetPageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = targetPageName
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ZIndex = 2
    Page.CanvasSize = UDim2.new(0, 0, 0, 400)
    Page.Parent = ContentArea
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[targetPageName] = Page

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Btn.Text = iconText .. " " .. (Translations[CurrentLang][key] or key)
    Btn.TextColor3 = Color3.fromRGB(160, 160, 175)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 10
    Btn.Parent = SideBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    TabButtons[targetPageName] = {Button = Btn, Key = key, Icon = iconText}
    
    Btn.MouseButton1Click:Connect(function()
        for name, p in pairs(Pages) do 
            p.Visible = false 
            if TabButtons[name] then
                TabButtons[name].Button.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            end
        end
        Page.Visible = true
        Btn.BackgroundColor3 = CurrentAccent
    end)
    return Page
end

local CharPage = CreateTab("Title", "👤", "Character")
local SheriffPage = CreateTab("Sheriff", "🤠", "Sheriff")
local EspPage = CreateTab("ESP", "👁", "ESP")
local SettingsPage = CreateTab("Settings", "⚙", "Settings")

Pages["Character"].Visible = true
TabButtons["Character"].Button.BackgroundColor3 = CurrentAccent

---------------------------------------------------------
-- КНОПКИ УПРАВЛЕНИЯ С ОПИСАНИЯМИ
---------------------------------------------------------
local TogglesList = {}

local function AddToggle(page, dictKey, settingKey, desc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, desc and 52 or 32)
    Container.BackgroundTransparency = 1
    Container.Parent = page

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(1, 0, 0, 32)
    Switch.Font = Enum.Font.GothamBold
    Switch.TextSize = 11
    Switch.Parent = Container
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 6)

    if desc then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, 0, 0, 18)
        DescLabel.Position = UDim2.new(0, 0, 0, 33)
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextSize = 9
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.BackgroundTransparency = 1
        DescLabel.Parent = Container
    end

    local function UpdateVisual()
        local labelText = Translations[CurrentLang][dictKey] or dictKey
        local state = _G.HubKill_Settings[settingKey]
        if state then
            Switch.BackgroundColor3 = Color3.fromRGB(35, 160, 75)
            Switch.Text = labelText .. " [ON]"
        else
            Switch.BackgroundColor3 = Color3.fromRGB(180, 40, 50)
            Switch.Text = labelText .. " [OFF]"
        end
    end

    UpdateVisual()
    table.insert(TogglesList, {Update = UpdateVisual})

    Switch.MouseButton1Click:Connect(function()
        _G.HubKill_Settings[settingKey] = not _G.HubKill_Settings[settingKey]
        UpdateVisual()
    end)
end

-- Добавляем функции на страницы
AddToggle(CharPage, "Aim", "AimLock")
AddToggle(CharPage, "Jump", "InfJump")

AddToggle(SheriffPage, "AimShot", "AimShot", "Автоматически стреляет по убийце, когда вы держите пистолет.")
AddToggle(SheriffPage, "KnifeCheck", "ShootKnifeOnly", "Стреляет только когда убийца реально достал нож в руку.")
AddToggle(SheriffPage, "SilentAim", "SilentAim", "Тихий аим: наводит пулю сквозь стены прямо в мардера.")

AddToggle(EspPage, "Murd", "ESP_Murd")
AddToggle(EspPage, "Sher", "ESP_Sher")
AddToggle(EspPage, "Inn", "ESP_Inn")

---------------------------------------------------------
-- ⚙ НАСТРОЙКИ: ВЫБОР ЯЗЫКА (10 СТРАН)
---------------------------------------------------------
local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(1, -10, 0, 30)
LangBtn.Text = "🌐 " .. Translations[CurrentLang].Lang
LangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Parent = SettingsPage
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 6)

local Popup = Instance.new("ScrollingFrame")
Popup.Size = UDim2.new(0, 140, 0, 100)
Popup.Position = UDim2.new(0.5, -70, 0.5, -50)
Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Popup.ZIndex = 15
Popup.Visible = false
Popup.Parent = ContentArea
Instance.new("UIListLayout", Popup)

LangBtn.MouseButton1Click:Connect(function()
    for _,child in pairs(Popup:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    Popup.Visible = not Popup.Visible
    
    local countries = {
        {Code="RU", Name="🇷🇺 Русский"}, {Code="EN", Name="🇺🇸 English"},
        {Code="ES", Name="🇪🇸 Español"}, {Code="DE", Name="🇩🇪 Deutsch"},
        {Code="FR", Name="🇫🇷 Français"}, {Code="PT", Name="🇵🇹 Português"},
        {Code="TR", Name="🇹🇷 Türkçe"}, {Code="VI", Name="🇻🇳 Tiếng Việt"},
        {Code="ID", Name="🇮🇩 Indonesia"}, {Code="PL", Name="🇵🇱 Polski"}
    }
    
    for _, c in ipairs(countries) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,22)
        b.Text = c.Name
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.ZIndex = 16
        b.Parent = Popup
        
        b.MouseButton1Click:Connect(function()
            CurrentLang = c.Code
            LangBtn.Text = "🌐 " .. Translations[CurrentLang].Lang
            Popup.Visible = false
            
            for _, tabData in pairs(TabButtons) do
                tabData.Button.Text = tabData.Icon .. " " .. (Translations[CurrentLang][tabData.Key] or tabData.Key)
            end
            for _, tog in ipairs(TogglesList) do tog.Update() end
        end)
    end
end)

---------------------------------------------------------
-- ЛОГИКА MM2 И ИГРЫ
---------------------------------------------------------

-- 1. AimLock
RunService.RenderStepped:Connect(function()
    if _G.HubKill_Settings.AimLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

-- 2. InfJump
UserInputService.JumpRequest:Connect(function()
    if _G.HubKill_Settings.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- 3. ESP
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("HubKill_ESP")
            local isMurd = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isSher = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
            
            local show = false
            local col = Color3.fromRGB(255, 255, 255)

            if isMurd and _G.HubKill_Settings.ESP_Murd then show = true col = Color3.fromRGB(255, 0, 0)
            elseif isSher and _G.HubKill_Settings.ESP_Sher then show = true col = Color3.fromRGB(0, 150, 255)
            elseif not isMurd and not isSher and _G.HubKill_Settings.ESP_Inn then show = true col = Color3.fromRGB(0, 255, 100) end

            if show then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "HubKill_ESP"
                end
                hl.FillColor = col
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 4. Вкладка Шерифа (AimShot, KnifeCheck, SilentAim)
RunService.RenderStepped:Connect(function()
    if _G.HubKill_Settings.AimShot then
        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                murderer = p
                break
            end
        end

        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            -- Проверка на Нож в руке
            if _G.HubKill_Settings.ShootKnifeOnly and not murderer.Character:FindFirstChild("Knife") then
                return
            end

            local targetPos = murderer.Character.HumanoidRootPart.Position

            -- Silent Aim
            if _G.HubKill_Settings.SilentAim then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            end

            -- Авто-выстрел с пистолета
            local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
            if gun then
                gun:Activate()
            end
        end
    end
end)

print("HubKill MEGA PRO LOADED!")
