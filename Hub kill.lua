local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Удаление предыдущей версии UI
if CoreGui:FindFirstChild("MobileHubUI") then
    CoreGui.MobileHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHubUI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

---------------------------------------------------------
-- 1. ИКОНКА (Неон с эффектом воды + Надпись HubKill)
---------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
ToggleBtn.Text = "HubKill"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ClipsDescendants = true
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 210, 255)
ToggleStroke.Thickness = 2

-- Градиент воды для кнопки
local WaterGradient = Instance.new("UIGradient", ToggleBtn)
WaterGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 230, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 180))
})
WaterGradient.Rotation = 45

-- Анимация течения воды на кнопке
task.spawn(function()
    local rot = 0
    while task.wait(0.03) do
        rot = (rot + 2) % 360
        WaterGradient.Rotation = rot
    end
end)

-- Спавн иконки
TweenService:Create(ToggleBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 52, 0, 52)
}):Play()

---------------------------------------------------------
-- 2. ГЛАВНОЕ МЕНЮ (Заголовок "x")
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainUIStroke = Instance.new("UIStroke", MainFrame)
MainUIStroke.Color = Color3.fromRGB(0, 170, 255)
MainUIStroke.Thickness = 1.5

local MainUIScale = Instance.new("UIScale", MainFrame)
MainUIScale.Scale = 1

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
Title.TextSize = 14
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
-- 4. РАБОЧАЯ ОБЛАСТЬ СПРАВА
---------------------------------------------------------
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -115, 1, -43)
ContentArea.Position = UDim2.new(0, 110, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    Page.Visible = false
    Page.Parent = ContentArea

    local UIList = Instance.new("UIListLayout", Page)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 6)

    local UIPadding = Instance.new("UIPadding", Page)
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 4)

    Pages[pageName] = Page
    return Page
end

local function CreateTab(text, iconText, targetPageName)
    local Page = CreatePage(targetPageName)

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

    Btn.MouseButton1Click:Connect(function()
        for pageName, button in pairs(TabButtons) do
            if pageName == targetPageName then
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(0, 170, 255),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            else
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38),
                    TextColor3 = Color3.fromRGB(160, 160, 175)
                }):Play()
            end
        end

        for name, pageFrame in pairs(Pages) do
            if name == targetPageName then
                pageFrame.Visible = true
                pageFrame.Position = UDim2.new(0.05, 0, 0, 0)
                TweenService:Create(pageFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
            else
                pageFrame.Visible = false
            end
        end
    end)

    return Page
end

---------------------------------------------------------
-- 5. КОМПОНЕНТЫ ФУНКЦИЙ И ВСПОМОГАТЕЛЬНЫЕ ОКНА
---------------------------------------------------------
local function AddToggle(page, text, defaultState, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 36)
    Container.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    Container.Parent = page

    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -55, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Text = text
    TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 11
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Container

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 38, 0, 20)
    Switch.Position = UDim2.new(1, -44, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = Container

    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Switch

    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local toggled = defaultState or false
    local function UpdateVisuals()
        if toggled then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
    end
    UpdateVisuals()

    Switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateVisuals()
        pcall(callback, toggled)
    end)

    return Container
end

---------------------------------------------------------
-- СОЗДАНИЕ ВЫБОРКИ ВКЛАДОК
---------------------------------------------------------
local CharPage     = CreateTab("Персонаж", "👤", "Character")
local EspPage      = CreateTab("ESP", "👁", "ESP")
local SettingsPage = CreateTab("Настройки", "⚙", "Settings")

-- Первая активная вкладка по умолчанию
TabButtons["Character"].BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabButtons["Character"].TextColor3 = Color3.fromRGB(255, 255, 255)
Pages["Character"].Visible = true

---------------------------------------------------------
-- ВКЛАДКА 1: ПЕРСОНАЖ
---------------------------------------------------------
local AimLock_Enabled = false

AddToggle(CharPage, "AimLock (Убийца)", false, function(state)
    AimLock_Enabled = state
end)

AddToggle(CharPage, "Бесконечный прыжок", false, function(state)
    _G.InfJump = state
end)

---------------------------------------------------------
-- ВКЛАДКА 2: ESP
---------------------------------------------------------
local ESP_Settings = {
    Murderer = false,
    Sheriff = false,
    Innocent = false
}

AddToggle(EspPage, "Murderer ESP", false, function(state)
    ESP_Settings.Murderer = state
end)

AddToggle(EspPage, "Sheriff ESP", false, function(state)
    ESP_Settings.Sheriff = state
end)

AddToggle(EspPage, "Innocent ESP", false, function(state)
    ESP_Settings.Innocent = state
end)

---------------------------------------------------------
-- ВКЛАДКА 3: НАСТРОЙКИ С ОКОШКАМИ ВЫБОРА (ЦВЕТ / СТИЛЬ)
---------------------------------------------------------
local SettingsThemeContainer = Instance.new("Frame")
SettingsThemeContainer.Size = UDim2.new(1, 0, 0, 40)
SettingsThemeContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
SettingsThemeContainer.Parent = SettingsPage
Instance.new("UICorner", SettingsThemeContainer).CornerRadius = UDim.new(0, 6)

local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Size = UDim2.new(1, -110, 1, 0)
ThemeLabel.Position = UDim2.new(0, 10, 0, 0)
ThemeLabel.Text = "Изменить тему UI"
ThemeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
ThemeLabel.Font = Enum.Font.Gotham
ThemeLabel.TextSize = 11
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Parent = SettingsThemeContainer

-- Две маленькие кнопки
local ColorPickerBtn = Instance.new("TextButton")
ColorPickerBtn.Size = UDim2.new(0, 45, 0, 22)
ColorPickerBtn.Position = UDim2.new(1, -100, 0.5, -11)
ColorPickerBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ColorPickerBtn.Text = "Цвет"
ColorPickerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerBtn.Font = Enum.Font.GothamBold
ColorPickerBtn.TextSize = 10
ColorPickerBtn.Parent = SettingsThemeContainer
Instance.new("UICorner", ColorPickerBtn).CornerRadius = UDim.new(0, 5)

local StylePickerBtn = Instance.new("TextButton")
StylePickerBtn.Size = UDim2.new(0, 48, 0, 22)
StylePickerBtn.Position = UDim2.new(1, -50, 0.5, -11)
StylePickerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
StylePickerBtn.Text = "Стиль"
StylePickerBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
StylePickerBtn.Font = Enum.Font.GothamBold
StylePickerBtn.TextSize = 10
StylePickerBtn.Parent = SettingsThemeContainer
Instance.new("UICorner", StylePickerBtn).CornerRadius = UDim.new(0, 5)

-- Выплывающее Окошко Списка (Scroll Pop-up)
local ScrollPopup = Instance.new("Frame")
ScrollPopup.Size = UDim2.new(0, 120, 0, 110)
ScrollPopup.Position = UDim2.new(0.5, -60, 0.5, -55)
ScrollPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ScrollPopup.ClipsDescendants = true
ScrollPopup.Visible = false
ScrollPopup.ZIndex = 10
ScrollPopup.Parent = MainFrame

Instance.new("UICorner", ScrollPopup).CornerRadius = UDim.new(0, 8)
local PopStroke = Instance.new("UIStroke", ScrollPopup)
PopStroke.Color = Color3.fromRGB(0, 170, 255)
PopStroke.Thickness = 1.5

local PopupScroll = Instance.new("ScrollingFrame")
PopupScroll.Size = UDim2.new(1, 0, 1, 0)
PopupScroll.BackgroundTransparency = 1
PopupScroll.ScrollBarThickness = 3
PopupScroll.ZIndex = 11
PopupScroll.Parent = ScrollPopup

local PopList = Instance.new("UIListLayout", PopupScroll)
PopList.SortOrder = Enum.SortOrder.LayoutOrder
PopList.Padding = UDim.new(0, 4)

local PopPad = Instance.new("UIPadding", PopupScroll)
PopPad.PaddingTop = UDim.new(0, 5)
PopPad.PaddingLeft = UDim.new(0, 5)
PopPad.PaddingRight = UDim.new(0, 5)

local function ClearPopup()
    for _, child in pairs(PopupScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
end

-- Логика рулетки цвета
ColorPickerBtn.MouseButton1Click:Connect(function()
    ClearPopup()
    ScrollPopup.Visible = not ScrollPopup.Visible
    if not ScrollPopup.Visible then return end

    local colors = {
        {Name = "Синий", Color = Color3.fromRGB(0, 170, 255)},
        {Name = "Красный", Color = Color3.fromRGB(255, 50, 50)},
        {Name = "Зеленый", Color = Color3.fromRGB(0, 230, 120)},
        {Name = "Фиолетовый", Color = Color3.fromRGB(170, 0, 255)},
        {Name = "Золотой", Color = Color3.fromRGB(255, 200, 0)},
        {Name = "Белый", Color = Color3.fromRGB(255, 255, 255)}
    }

    for _, item in ipairs(colors) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 24)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        b.Text = item.Name
        b.TextColor3 = item.Color
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 10
        b.ZIndex = 12
        b.Parent = PopupScroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

        b.MouseButton1Click:Connect(function()
            MainUIStroke.Color = item.Color
            ToggleStroke.Color = item.Color
            ColorPickerBtn.BackgroundColor3 = item.Color
            ScrollPopup.Visible = false
        end)
    end
end)

-- Логика рулетки стилей
StylePickerBtn.MouseButton1Click:Connect(function()
    ClearPopup()
    ScrollPopup.Visible = not ScrollPopup.Visible
    if not ScrollPopup.Visible then return end

    local styles = {
        {Name = "Неоновый", Bg = Color3.fromRGB(16, 16, 22), Main = Color3.fromRGB(0, 170, 255)},
        {Name = "Демонический", Bg = Color3.fromRGB(25, 10, 12), Main = Color3.fromRGB(255, 30, 30)},
        {Name = "Темный", Bg = Color3.fromRGB(10, 10, 10), Main = Color3.fromRGB(100, 100, 100)},
        {Name = "Морской", Bg = Color3.fromRGB(10, 22, 30), Main = Color3.fromRGB(0, 220, 255)}
    }

    for _, item in ipairs(styles) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 24)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        b.Text = item.Name
        b.TextColor3 = Color3.fromRGB(240, 240, 240)
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 10
        b.ZIndex = 12
        b.Parent = PopupScroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

        b.MouseButton1Click:Connect(function()
            MainFrame.BackgroundColor3 = item.Bg
            MainUIStroke.Color = item.Main
            ScrollPopup.Visible = false
        end)
    end
end)

---------------------------------------------------------
-- 6. ПЛАВНОЕ ОТКРЫТИЕ И ЗАКРЫТИЕ
---------------------------------------------------------
local isOpen = false

local function OpenMenu()
    isOpen = true
    MainFrame.Visible = true

    TweenService:Create(ToggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 370, 0, 225)
    }):Play()
end

local function CloseMenu()
    isOpen = false
    ScrollPopup.Visible = false

    local mainTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    mainTween:Play()

    mainTween.Completed:Connect(function()
        if not isOpen then
            MainFrame.Visible = false
        end
    end)

    TweenService:Create(ToggleBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 52, 0, 52)
    }):Play()
end

ToggleBtn.MouseButton1Click:Connect(OpenMenu)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

---------------------------------------------------------
-- ЛОГИКА ИГРЫ (ESP, AIMLOCK, INF JUMP)
---------------------------------------------------------
local function GetRole(player)
    if not player or not player.Character then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local function ApplyHighlight(object, color)
    local hl = object:FindFirstChild("Pulse_Highlight")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "Pulse_Highlight"
        hl.Parent = object
    end
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.3
end

local function RemoveHighlight(object)
    if object and object:FindFirstChild("Pulse_Highlight") then
        object.Pulse_Highlight:Destroy()
    end
end

-- Цикл ESP
task.spawn(function()
    while task.wait(0.3) do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local role = GetRole(player)
                local char = player.Character
                if role == "Murderer" and ESP_Settings.Murderer then
                    ApplyHighlight(char, Color3.fromRGB(255, 0, 0))
                elseif role == "Sheriff" and ESP_Settings.Sheriff then
                    ApplyHighlight(char, Color3.fromRGB(0, 150, 255))
                elseif role == "Innocent" and ESP_Settings.Innocent then
                    ApplyHighlight(char, Color3.fromRGB(0, 255, 100))
                else
                    RemoveHighlight(char)
                end
            end
        end
    end
end)

-- AimLock
RunServ
