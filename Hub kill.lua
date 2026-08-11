local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Удаление старого UI
if CoreGui:FindFirstChild("MM2_Mobile_PulseHub") then
    CoreGui.MM2_Mobile_PulseHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_PulseHub"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- 1. Плавающий плавно появляющийся квадрат (Иконка)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
ToggleBtn.Text = "HUB"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.ClipsDescendants = true
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 150, 255)
ToggleStroke.Thickness = 2

TweenService:Create(ToggleBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 48, 0, 48)
}):Play()

-- 2. Главный фрейм меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 1.5
UIStroke.Enabled = false

local UIScale = Instance.new("UIScale", MainFrame)
UIScale.Scale = 1

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Pulse Hub <font color='#0096FF'>•</font> MM2 Mobile"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
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
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = Header

-- Sidebar (Слева маленькие кнопки)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 110, 1, -40)
SideBar.Position = UDim2.new(0, 5, 0, 35)
SideBar.BackgroundTransparency = 1
SideBar.Parent = MainFrame

local SideBarList = Instance.new("UIListLayout", SideBar)
SideBarList.SortOrder = Enum.SortOrder.LayoutOrder
SideBarList.Padding = UDim.new(0, 4)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -125, 1, -40)
ContentArea.Position = UDim2.new(0, 120, 0, 35)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.Parent = ContentArea

    local UIList = Instance.new("UIListLayout", Page)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)

    Pages[pageName] = Page
    return Page
end

local MainPage = CreatePage("Main")
local ESPPage = CreatePage("ESP")
MainPage.Visible = true

local function ShowPage(targetPageName)
    for name, page in pairs(Pages) do
        page.Visible = (name == targetPageName)
    end
end

local function CreateTabButton(text, targetPage)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BackgroundTransparency = 1
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = SideBar

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local UIPadding = Instance.new("UIPadding", Btn)
    UIPadding.PaddingLeft = UDim.new(0, 10)

    TabButtons[targetPage] = Btn

    Btn.MouseButton1Click:Connect(function()
        for pageName, button in pairs(TabButtons) do
            if pageName == targetPage then
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                button.Font = Enum.Font.SourceSansBold
            else
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }):Play()
                button.Font = Enum.Font.SourceSans
            end
        end
        ShowPage(targetPage)
    end)
    return Btn
end

local MainTab = CreateTabButton("Главная", "Main")
local ESPTab = CreateTabButton("ESP", "ESP")

MainTab.BackgroundTransparency = 0
MainTab.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab.Font = Enum.Font.SourceSansBold

-- ESP Пресеты
local ColorPresets = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(0, 255, 100),
    Color3.fromRGB(180, 0, 255),
    Color3.fromRGB(255, 255, 255)
}

local ESP_Data = {
    Murderer = { Enabled = false, Color = Color3.fromRGB(255, 0, 0), ColorIndex = 1 },
    Sheriff  = { Enabled = false, Color = Color3.fromRGB(0, 150, 255), ColorIndex = 2 },
    Hero     = { Enabled = false, Color = Color3.fromRGB(255, 215, 0), ColorIndex = 3 },
    Innocent = { Enabled = false, Color = Color3.fromRGB(0, 255, 100), ColorIndex = 4 },
    GunDrop  = { Enabled = false, Color = Color3.fromRGB(255, 255, 0), ColorIndex = 3 }
}

local function CreateFunctionButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = parent

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local UIPadding = Instance.new("UIPadding", Btn)
    UIPadding.PaddingLeft = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateFunctionToggle(parent, text, defaultState, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -5, 0, 30)
    Container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.Text = text
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSans
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Container

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 36, 0, 18)
    ToggleBtn.Position = UDim2.new(1, -42, 0.5, -9)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Container
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = UDim2.new(0, 2, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Indicator.Parent = ToggleBtn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    local function UpdateVisuals()
        if state then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
        end
    end
    UpdateVisuals()

    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        UpdateVisuals()
        callback(state)
    end)
    return Container
end

local function CreateESPFunctionWithColor(parent, text, espKey)
    local Container = CreateFunctionToggle(parent, text, ESP_Data[espKey].Enabled, function(state)
        ESP_Data[espKey].Enabled = state
    end)

    local ColorSquare = Instance.new("TextButton")
    ColorSquare.Size = UDim2.new(0, 18, 0, 18)
    ColorSquare.Position = UDim2.new(1, -68, 0.5, -9)
    ColorSquare.BackgroundColor3 = ESP_Data[espKey].Color
    ColorSquare.Text = ""
    ColorSquare.Parent = Container

    Instance.new("UICorner", ColorSquare).CornerRadius = UDim.new(0, 4)
    local SquareStroke = Instance.new("UIStroke", ColorSquare)
    SquareStroke.Color = Color3.fromRGB(255, 255, 255)
    SquareStroke.Thickness = 1

    ColorSquare.MouseButton1Click:Connect(function()
        local data = ESP_Data[espKey]
        data.ColorIndex = (data.ColorIndex % #ColorPresets) + 1
        data.Color = ColorPresets[data.ColorIndex]
        ColorSquare.BackgroundColor3 = data.Color
    end)
end

-- Наполнение Главной
local AimLock_Enabled = false
local AimSmoothness = 0.15

CreateFunctionToggle(MainPage, "Плавный AimLock (Убийца)", false, function(state)
    AimLock_Enabled = state
end)

CreateFunctionButton(MainPage, "Сменить тему UI", function()
    if MainFrame.BackgroundColor3 == Color3.fromRGB(15, 15, 15) then
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    elseif MainFrame.BackgroundColor3 == Color3.fromRGB(30, 10, 10) then
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end)

CreateFunctionToggle(MainPage, "Неоновая обводка", false, function(state)
    UIStroke.Enabled = state
end)

local currentScale = 1
CreateFunctionButton(MainPage, "Размер: 100% -> 80% -> 120%", function()
    if currentScale == 1 then
        currentScale = 0.8
    elseif currentScale == 0.8 then
        currentScale = 1.2
    else
        currentScale = 1
    end
    TweenService:Create(UIScale, TweenInfo.new(0.25), {Scale = currentScale}):Play()
end)

-- Наполнение ESP
CreateESPFunctionWithColor(ESPPage, "Убийца (Murderer)", "Murderer")
CreateESPFunctionWithColor(ESPPage, "Шериф (Sheriff)", "Sheriff")
CreateESPFunctionWithColor(ESPPage, "Герой (Hero)", "Hero")
CreateESPFunctionWithColor(ESPPage, "Мирные (Innocent)", "Innocent")
CreateESPFunctionWithColor(ESPPage, "Пистолет (GunDrop)", "GunDrop")

-- Анимация Открытия/Закрытия
local isOpen = false

local function OpenMenu()
    isOpen = true
    MainFrame.Visible = true
    
    TweenService:Create(ToggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 250)
    }):Play()
end

local function CloseMenu()
    isOpen = false
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
        Size = UDim2.new(0, 48, 0, 48)
    }):Play()
end

ToggleBtn.MouseButton1Click:Connect(OpenMenu)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Логика ESP и AimLock
local function GetRole(player)
    if not player or not player.Character then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        if player:FindFirstChild("IsHero") then return "Hero" end
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

task.spawn(function()
    while task.wait(0.3) do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local role = GetRole(player)
                local char = player.Character
                local config = ESP_Data[role]
                if config and config.Enabled then
                    ApplyHighlight(char, config.Color)
                else
                    RemoveHighlight(char)
                end
            end
        end
        local gunDrop = Workspace:FindFirstChild("GunDrop")
        if gunDrop then
            if ESP_Data.GunDrop.Enabled then
                ApplyHighlight(gunDrop, ESP_Data.GunDrop.Color)
            else
                RemoveHighlight(gunDrop)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if AimLock_Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and GetRole(player) == "Murderer" and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSmoothness)
                end
            end
        end
    end
end)
