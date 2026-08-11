-- ========================================================
-- HUBKILL MEGA PRO v13.0 - ULTIMATE MERGED EDITION
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

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

_G.HubKill_Settings = {
    AimLock = false, InfJump = false,
    ESP_Murd = false, ESP_Sher = false, ESP_Inn = false,
    AimShot = false, ShootKnifeOnly = false, SilentAim = false,
    WalkSpeed = 16, JumpPower = 50, SpeedGlitch = false,
    ActiveVisual = "None", ActiveFootTrail = "None",
    FPS_Counter = false, FPS_Boost = false
}

local Translations = {
    RU = {Title="Персонаж", ESP="ESP", Settings="Настройки", Sheriff="Шериф", Visuals="Визуалы", Aim="AimLock", Jump="InfJump", Murd="Murderer ESP", Sher="Sheriff ESP", Inn="Innocent ESP", Lang="Язык / Language", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Счетчик FPS", Boost="Убрать лаги (Boost)"},
    EN = {Title="Character", ESP="ESP", Settings="Settings", Sheriff="Sheriff", Visuals="Visuals", Aim="AimLock", Jump="InfJump", Murd="Murderer ESP", Sher="Sheriff ESP", Inn="Innocent ESP", Lang="Language", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="FPS Counter", Boost="FPS Boost"},
    ES = {Title="Personaje", ESP="ESP", Settings="Ajustes", Sheriff="Alguacil", Visuals="Visuales", Aim="AimLock", Jump="InfJump", Murd="Asesino ESP", Sher="Alguacil ESP", Inn="Inocente ESP", Lang="Idioma", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Contador FPS", Boost="FPS Boost"},
    DE = {Title="Charakter", ESP="ESP", Settings="Einstellungen", Sheriff="Sheriff", Visuals="Visuelles", Aim="AimLock", Jump="InfJump", Murd="Mörder ESP", Sher="Sheriff ESP", Inn="Unschuldig ESP", Lang="Sprache", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="FPS Zähler", Boost="FPS Boost"},
    FR = {Title="Personnage", ESP="ESP", Settings="Paramètres", Sheriff="Chérif", Visuals="Visuels", Aim="AimLock", Jump="InfJump", Murd="Meurtrier ESP", Sher="Chérif ESP", Inn="Innocent ESP", Lang="Langue", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Compteur FPS", Boost="FPS Boost"},
    PT = {Title="Personagem", ESP="ESP", Settings="Configurações", Sheriff="Xerife", Visuals="Visuais", Aim="AimLock", Jump="InfJump", Murd="Assassino ESP", Sher="Xerife ESP", Inn="Inocente ESP", Lang="Idioma", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Contador FPS", Boost="FPS Boost"},
    TR = {Title="Karakter", ESP="ESP", Settings="Ayarlar", Sheriff="Şerif", Visuals="Görseller", Aim="AimLock", Jump="InfJump", Murd="Katil ESP", Sher="Şerif ESP", Inn="Masum ESP", Lang="Dil", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="FPS Sayacı", Boost="FPS Boost"},
    VI = {Title="Nhân vật", ESP="ESP", Settings="Cài đặt", Sheriff="Cảnh sát", Visuals="Hình ảnh", Aim="AimLock", Jump="InfJump", Murd="Sát thủ ESP", Sher="Cảnh sát ESP", Inn="Dân thường ESP", Lang="Ngôn ngữ", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Bộ đếm FPS", Boost="FPS Boost"},
    ID = {Title="Karakter", ESP="ESP", Settings="Pengaturan", Sheriff="Deputi", Visuals="Visual", Aim="AimLock", Jump="InfJump", Murd="Pembunuh ESP", Sher="Deputi ESP", Inn="Warga ESP", Lang="Bahasa", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Penghitung FPS", Boost="FPS Boost"},
    PL = {Title="Postać", ESP="ESP", Settings="Ustawienia", Sheriff="Szeryf", Visuals="Wizualia", Aim="AimLock", Jump="InfJump", Murd="Morderca ESP", Sher="Szeryf ESP", Inn="Niewinny ESP", Lang="Język", AimShot="Aim Shot", KnifeCheck="Knife Check", SilentAim="Silent Aim", SpeedGlitch="Speed Glitch", FPS="Licznik FPS", Boost="FPS Boost"}
}

local function CreateStarEffect(btn)
    local star = Instance.new("TextLabel")
    star.Size = UDim2.new(0, 20, 0, 20); star.Position = UDim2.new(0.8, 0, 0.2, 0); star.BackgroundTransparency = 1; star.Text = "✨"; star.TextSize = 14; star.Parent = btn
    local tween = TweenService:Create(star, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.8, 0, -0.5, 0), TextTransparency = 1})
    tween:Play(); tween.Completed:Connect(function() star:Destroy() end)
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"; ToggleBtn.Parent = ScreenGui; ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 45); ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0); ToggleBtn.Size = UDim2.new(0, 52, 0, 52); ToggleBtn.Text = "HubKill"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleBtn.TextSize = 12; ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.Active = true; ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn); ToggleStroke.Color = CurrentAccent; ToggleStroke.Thickness = 2

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.Size = UDim2.new(0, 0, 0, 0); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.BackgroundColor3 = CurrentThemeBg; MainFrame.ClipsDescendants = true; MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainUIStroke = Instance.new("UIStroke", MainFrame); MainUIStroke.Color = CurrentAccent; MainUIStroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35); Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30); Header.BorderSizePixel = 0; Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0); Title.Position = UDim2.new(0, 12, 0, 0); Title.Text = "HubKill Mega Pro v13.0"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 15; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; Title.Parent = Header

local GreenDot = Instance.new("Frame"); GreenDot.Size = UDim2.new(0, 12, 0, 12); GreenDot.Position = UDim2.new(1, -65, 0.5, -6); GreenDot.BackgroundColor3 = Color3.fromRGB(50, 205, 50); GreenDot.Parent = Header
Instance.new("UICorner", GreenDot).CornerRadius = UDim.new(1, 0)

local YellowExitBtn = Instance.new("TextButton"); YellowExitBtn.Size = UDim2.new(0, 14, 0, 14); YellowExitBtn.Position = UDim2.new(1, -45, 0.5, -7); YellowExitBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 0); YellowExitBtn.Text = ""; YellowExitBtn.Parent = Header
Instance.new("UICorner", YellowExitBtn).CornerRadius = UDim.new(1, 0)

local RedExitBtn = Instance.new("TextButton"); RedExitBtn.Size = UDim2.new(0, 14, 0, 14); RedExitBtn.Position = UDim2.new(1, -25, 0.5, -7); RedExitBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50); RedExitBtn.Text = "✕"; RedExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255); RedExitBtn.TextSize = 9; RedExitBtn.Font = Enum.Font.GothamBold; RedExitBtn.Parent = Header
Instance.new("UICorner", RedExitBtn).CornerRadius = UDim.new(1, 0)

local ConfirmFrame = Instance.new("Frame"); ConfirmFrame.Size = UDim2.new(0, 220, 0, 110); ConfirmFrame.Position = UDim2.new(0.5, -110, 0.5, -55); ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35); ConfirmFrame.ZIndex = 20; ConfirmFrame.Visible = false; ConfirmFrame.Parent = ScreenGui
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame); ConfirmStroke.Color = Color3.fromRGB(230, 50, 50)

local ConfirmText = Instance.new("TextLabel"); ConfirmText.Size = UDim2.new(1, 0, 0, 50); ConfirmText.Text = "Are you sure?"; ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255); ConfirmText.Font = Enum.Font.GothamBold; ConfirmText.TextSize = 14; ConfirmText.BackgroundTransparency = 1; ConfirmText.ZIndex = 21; ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton"); YesBtn.Size = UDim2.new(0, 85, 0, 30); YesBtn.Position = UDim2.new(0.1, 0, 0.6, 0); YesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); YesBtn.Text = "Yes (Exit)"; YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255); YesBtn.Font = Enum.Font.GothamBold; YesBtn.ZIndex = 21; YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton"); NoBtn.Size = UDim2.new(0, 85, 0, 30); NoBtn.Position = UDim2.new(0.55, 0, 0.6, 0); NoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50); NoBtn.Text = "Keep"; NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255); NoBtn.Font = Enum.Font.GothamBold; NoBtn.ZIndex = 21; NoBtn.Parent = ConfirmFrame
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
    if MainFrame.Visible then MainFrame:TweenSize(UDim2.new(0, 500, 0, 320), "Out", "Quart", 0.3) else MinimizeMenu() end
end)

local SideBar = Instance.new("Frame"); SideBar.Size = UDim2.new(0, 115, 1, -35); SideBar.Position = UDim2.new(0, 0, 0, 35); SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28); SideBar.BorderSizePixel = 0; SideBar.Parent = MainFrame
Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame"); ContentArea.Size = UDim2.new(1, -125, 1, -43); ContentArea.Position = UDim2.new(0, 120, 0, 38); ContentArea.BackgroundTransparency = 1; ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreateTab(key, iconText, targetPageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = targetPageName; Page.Size = UDim2.new(1, -5, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ZIndex = 2; Page.CanvasSize = UDim2.new(0, 0, 0, 1200); Page.Parent = ContentArea
    local grid = Instance.new("UIGridLayout", Page); grid.CellSize = UDim2.new(0.48, 0, 0, 32); grid.CellPadding = UDim2.new(0.03, 0, 0, 8)
    Pages[targetPageName] = Page

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38); Btn.Text = iconText .. " " .. (Translations[CurrentLang][key] or key); Btn.TextColor3 = Color3.fromRGB(160, 160, 175); Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 10; Btn.Parent = SideBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    TabButtons[targetPageName] = {Button = Btn, Key = key, Icon = iconText}
    
    Btn.MouseButton1Click:Connect(function()
        CreateStarEffect(Btn)
        for name, p in pairs(Pages) do p.Visible = false; if TabButtons[name] then TabButtons[name].Button.BackgroundColor3 = Color3.fromRGB(28, 28, 38) end end
        Page.Visible = true; Btn.BackgroundColor3 = CurrentAccent
    end)
    return Page
end

local CharPage = CreateTab("Title", "👤", "Character")
local SheriffPage = CreateTab("Sheriff", "🤠", "Sheriff")
local EspPage = CreateTab("ESP", "👁", "ESP")
local VisualPage = CreateTab("Visuals", "🎨", "Visuals")
local SettingsPage = CreateTab("Settings", "⚙", "Settings")

Pages["Character"].Visible = true
TabButtons["Character"].Button.BackgroundColor3 = CurrentAccent

local TogglesList = {}
local function AddToggle(page, dictKey, settingKey)
    local Switch = Instance.new("TextButton"); Switch.Size = UDim2.new(1, 0, 0, 32); Switch.Font = Enum.Font.GothamBold; Switch.TextSize = 10; Switch.Parent = page
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 6)

    local function UpdateVisual()
        local labelText = Translations[CurrentLang][dictKey] or dictKey
        if _G.HubKill_Settings[settingKey] then
            Switch.BackgroundColor3 = Color3.fromRGB(35, 160, 75); Switch.Text = labelText .. " [ON]"
        else
            Switch.BackgroundColor3 = Color3.fromRGB(180, 40, 50); Switch.Text = labelText .. " [OFF]"
        end
    end
    UpdateVisual()
    table.insert(TogglesList, {Update = UpdateVisual})

    Switch.MouseButton1Click:Connect(function()
        CreateStarEffect(Switch)
        _G.HubKill_Settings[settingKey] = not _G.HubKill_Settings[settingKey]
        UpdateVisual()
    end)
end

AddToggle(CharPage, "Aim", "AimLock")
AddToggle(CharPage, "Jump", "InfJump")
AddToggle(CharPage, "SpeedGlitch", "SpeedGlitch")

local SpeedBtn = Instance.new("TextButton", CharPage)
SpeedBtn.Size = UDim2.new(1, 0, 0, 32); SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60); SpeedBtn.Text = "⚡ Speed: 30"; SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SpeedBtn.Font = Enum.Font.GothamBold; SpeedBtn.TextSize = 10
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0, 6)
SpeedBtn.MouseButton1Click:Connect(function()
    CreateStarEffect(SpeedBtn)
    if _G.HubKill_Settings.WalkSpeed == 16 then _G.HubKill_Settings.WalkSpeed = 32
    elseif _G.HubKill_Settings.WalkSpeed == 32 then _G.HubKill_Settings.WalkSpeed = 50
    else _G.HubKill_Settings.WalkSpeed = 16 end
    SpeedBtn.Text = "⚡ Speed: " .. tostring(_G.HubKill_Settings.WalkSpeed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.HubKill_Settings.WalkSpeed
    end
end)

AddToggle(SheriffPage, "AimShot", "AimShot")
AddToggle(SheriffPage, "KnifeCheck", "ShootKnifeOnly")
AddToggle(SheriffPage, "SilentAim", "SilentAim")

AddToggle(EspPage, "Murd", "ESP_Murd")
AddToggle(EspPage, "Sher", "ESP_Sher")
AddToggle(EspPage, "Inn", "ESP_Inn")

---------------------------------------------------------
-- ВСЕ ВИЗУАЛЫ, КРЫЛЬЯ, СЛЕДЫ, ОРУЖИЕ И ЭМОЦИИ
---------------------------------------------------------
local function RemoveCurrentVisual()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hrp:FindFirstChild("HubEffect") then hrp.HubEffect:Destroy() end
    end
end

local function AddVisualBtn(text, effType)
    local btn = Instance.new("TextButton", VisualPage)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.Gotham; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        CreateStarEffect(btn)
        RemoveCurrentVisual()
        _G.HubKill_Settings.ActiveVisual = effType
        if effType == "None" then return end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local folder = Instance.new("Folder", hrp); folder.Name = "HubEffect"

        if effType == "AngelWings" then
            local p = Instance.new("ParticleEmitter", folder)
            p.Texture = "rbxassetid://258129202"; p.Rate = 15; p.Lifetime = NumberRange.new(1, 1.5); p.Size = NumberSequence.new(3, 4); p.Transparency = NumberSequence.new(0, 1); p.Speed = NumberRange.new(1); p.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        elseif effType == "DemonWings" then
            local p = Instance.new("ParticleEmitter", folder)
            p.Texture = "rbxassetid://258129202"; p.Rate = 20; p.Lifetime = NumberRange.new(0.8, 1.2); p.Size = NumberSequence.new(3.5, 4.5); p.Transparency = NumberSequence.new(0, 0.8); p.Speed = NumberRange.new(2); p.Color = ColorSequence.new(Color3.fromRGB(200, 0, 0))
        elseif effType == "Planets" then
            local a = Instance.new("Attachment", hrp); a.Name = "PlanetsAttach"; a.Parent = folder
            local p = Instance.new("ParticleEmitter", a)
            p.Rate = 30; p.Lifetime = NumberRange.new(1.5); p.Size = NumberSequence.new(0.8); p.Speed = NumberRange.new(4); p.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
        elseif effType == "GhostAura" then
            local p = Instance.new("ParticleEmitter", folder)
            p.Rate = 40; p.Lifetime = NumberRange.new(1, 2); p.Size = NumberSequence.new(2, 5); p.Transparency = NumberSequence.new(0.3, 1); p.Speed = NumberRange.new(1); p.Color = ColorSequence.new(Color3.fromRGB(150, 0, 255))
        elseif effType == "Lightning" then
            local p = Instance.new("ParticleEmitter", folder)
            p.Rate = 50; p.Lifetime = NumberRange.new(0.2, 0.5); p.Size = NumberSequence.new(1, 3); p.Speed = NumberRange.new(5); p.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        elseif effType == "Crown" then
            local a = Instance.new("Attachment", char:FindFirstChild("Head") or hrp); a.Position = Vector3.new(0, 2.5, 0); a.Parent = folder
            local p = Instance.new("ParticleEmitter", a)
            p.Rate = 20; p.Lifetime = NumberRange.new(1); p.Size = NumberSequence.new(1.2); p.Speed = NumberRange.new(0); p.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
        end
    end)
end

AddVisualBtn("👼 Ангел", "AngelWings")
AddVisualBtn("😈 Демон", "DemonWings")
AddVisualBtn("🪐 Планеты", "Planets")
AddVisualBtn("👻 Призрак", "GhostAura")
AddVisualBtn("⚡ Шторм", "Lightning")
AddVisualBtn("👑 Корона", "Crown")

local function AddFootTrailBtn(text, trailType)
    local btn = Instance.new("TextButton", VisualPage)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.Gotham; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        CreateStarEffect(btn)
        _G.HubKill_Settings.ActiveFootTrail = trailType
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        if hrp:FindFirstChild("FootTrailFolder") then hrp.FootTrailFolder:Destroy() end

        if trailType == "None" then return end
        local folder = Instance.new("Folder", hrp); folder.Name = "FootTrailFolder"
        local p = Instance.new("ParticleEmitter", folder)
        p.Rate = 25; p.Lifetime = NumberRange.new(0.5, 1); p.Size = NumberSequence.new(1, 0); p.Speed = NumberRange.new(0)

        if trailType == "Fire" then p.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
        elseif trailType == "Ice" then p.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
        elseif trailType == "Flowers" then p.Color = ColorSequence.new(Color3.fromRGB(255, 105, 180))
        elseif trailType == "Electric" then p.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        elseif trailType == "Void" then p.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30)) end
    end)
end

AddFootTrailBtn("🔥 Огонь", "Fire")
AddFootTrailBtn("❄️ Лёд", "Ice")
AddFootTrailBtn("🌸 Цветы", "Flowers")
AddFootTrailBtn("⚡ Искры", "Electric")
AddFootTrailBtn("🕳️ Тень", "Void")
AddFootTrailBtn("❌ Без следов", "None")

local function GiveClientItem(itemName, isKnife)
    local tool = Instance.new("Tool"); tool.Name = "[Visual] " .. itemName; tool.RequiresHandle = true
    local handle = Instance.new("Part", tool); handle.Name = "Handle"; handle.Size = Vector3.new(1, 2, 1)
    if isKnife then
        handle.Color = Color3.fromRGB(255, 50, 50)
        local mesh = Instance.new("SpecialMesh", handle); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://121944778"
    else
        handle.Color = Color3.fromRGB(50, 150, 255)
        local mesh = Instance.new("SpecialMesh", handle); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://43132201"
    end
    tool.Parent = LocalPlayer.Backpack
end

local function AddItemBtn(text, itemName, isKnife)
    local btn = Instance.new("TextButton", VisualPage)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 35, 45); btn.Text = text; btn.TextColor3 = Color3.fromRGB(220, 220, 255); btn.Font = Enum.Font.Gotham; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() CreateStarEffect(btn); GiveClientItem(itemName, isKnife) end)
end

AddItemBtn("🔪 Chroma Laser", "Chroma Laser", true)
AddItemBtn("🔪 Candy Knife", "Candy", true)
AddItemBtn("🔫 Corrupt Gun", "Corrupt", false)

local currentTrack = nil
local function PlayEmote(animId)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if currentTrack then currentTrack:Stop() end
    local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://" .. animId
    currentTrack = hum:LoadAnimation(anim); currentTrack:Play()
end

local function AddEmoteBtn(text, animId)
    local btn = Instance.new("TextButton", VisualPage)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(40, 30, 50); btn.Text = text; btn.TextColor3 = Color3.fromRGB(240, 200, 255); btn.Font = Enum.Font.Gotham; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() CreateStarEffect(btn); PlayEmote(animId) end)
end

AddEmoteBtn("🧘 Zen", "333333131")
AddEmoteBtn("🪑 Sit", "250622329")
AddEmoteBtn("🕺 Dance", "182436842")

local function SetSky(skyId)
    local oldSky = Lighting:FindFirstChildOfClass("Sky")
    if oldSky then oldSky:Destroy() end
    if skyId == "Reset" then return end
    local newSky = Instance.new("Sky", Lighting)
    newSky.SkyboxBk = "rbxassetid://" .. skyId; newSky.SkyboxDn = "rbxassetid://" .. skyId
    newSky.SkyboxFt = "rbxassetid://" .. skyId; newSky.SkyboxLf = "rbxassetid://" .. skyId
    newSky.SkyboxRt = "rbxassetid://" .. skyId; newSky.SkyboxUp = "rbxassetid://" .. skyId
end

local function AddSkyBtn(text, skyId)
    local btn = Instance.new("TextButton", VisualPage)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38); btn.Text = text; btn.TextColor3 = Color3.fromRGB(200, 200, 220); btn.Font = Enum.Font.Gotham; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() CreateStarEffect(btn); SetSky(skyId) end)
end

AddSkyBtn("🌙 Ночь", "159454299")
AddSkyBtn("🌅 Закат", "125712080")
AddSkyBtn("🌌 Галактика", "159454299")
AddSkyBtn("🔄 Сброс неба", "Reset")

---------------------------------------------------------
-- НАСТРОЙКИ (FPS, BOOST И 10 ЯЗЫКОВ)
---------------------------------------------------------
AddToggle(SettingsPage, "FPS", "FPS_Counter")
AddToggle(SettingsPage, "Boost", "FPS_Boost")

local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.new(0, 100, 0, 30); FpsLabel.Position = UDim2.new(1, -110, 0, 10); FpsLabel.BackgroundTransparency = 0.5; FpsLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20); FpsLabel.TextColor3 = Color3.fromRGB(50, 255, 50); FpsLabel.Font = Enum.Font.GothamBold; FpsLabel.TextSize = 12; FpsLabel.Visible = false

RunService.RenderStepped:Connect(function(dt)
    if _G.HubKill_Settings.FPS_Counter then
        FpsLabel.Visible = true; FpsLabel.Text = "FPS: " .. tostring(math.floor(1 / dt))
    else
        FpsLabel.Visible = false
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.HubKill_Settings.FPS_Boost then
        Lighting.GlobalShadows = false; Lighting.Brightness = 1
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false end
        end
    end
end)

local LangBtn = Instance.new("TextButton", SettingsPage)
LangBtn.Size = UDim2.new(1, 0, 0, 32); LangBtn.Text = "🌐 " .. Translations[CurrentLang].Lang; LangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55); LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255); LangBtn.Font = Enum.Font.GothamBold; LangBtn.TextSize = 10
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 6)

local Popup = Instance.new("ScrollingFrame", ContentArea)
Popup.Size = UDim2.new(0, 140, 0, 140); Popup.Position = UDim2.new(0.5, -70, 0.5, -70); Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 40); Popup.ZIndex = 15; Popup.Visible = false
Instance.new("UIListLayout", Popup)

LangBtn.MouseButton1Click:Connect(function()
    CreateStarEffect(LangBtn)
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
        local b = Instance.new("TextButton", Popup)
        b.Size = UDim2.new(1,0,0,22); b.Text = c.Name; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.Gotham; b.TextSize = 10; b.ZIndex = 16
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
-- ИГРОВАЯ ЛОГИКА (AIM, ЖПР, ESP, ШЕРИФ)
---------------------------------------------------------
UserInputService.JumpRequest:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if _G.HubKill_Settings.InfJump and hum then hum:ChangeState("Jumping") end
        if _G.HubKill_Settings.SpeedGlitch and hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(Camera.CFrame.LookVector.X * 120, 60, Camera.CFrame.LookVector.Z * 120)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.HubKill_Settings.AimLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = nil; local dist = 1000
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then target = p.Character.HumanoidRootPart; dist = mag end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.15) end
    end
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local gui = root:FindFirstChild("HubKill_ESP_Gui")
            local isMurd = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isSher = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
            
            local show = false; local col = Color3.fromRGB(255, 255, 255)
            if isMurd and _G.HubKill_Settings.ESP_Murd then show = true; col = Color3.fromRGB(255, 0, 0)
            elseif isSher and _G.HubKill_Settings.ESP_Sher then show = true; col = Color3.fromRGB(0, 150, 255)
            elseif not isMurd and not isSher and _G.HubKill_Settings.ESP_Inn then show = true; col = Color3.fromRGB(0, 255, 100) end

            if show then
                if not gui then
                    gui = Instance.new("BillboardGui", root)
                    gui.Name = "HubKill_ESP_Gui"; gui.Size = UDim2.new(0, 25, 0, 25); gui.AlwaysOnTop = true
                    local frame = Instance.new("Frame", gui); frame.Size = UDim2.new(1,0,1,0); frame.BackgroundColor3 = col
                    Instance.new("UICorner", frame).CornerRadius = UDim.new(1,0)
                end
                gui.Frame.BackgroundColor3 = col
            else
                if gui then gui:Destroy() end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.HubKill_Settings.AimShot then
        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                murderer = p; break
            end
        end

        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            if _G.HubKill_Settings.ShootKnifeOnly and not murderer.Character:FindFirstChild("Knife") then return end
            local targetPos = murderer.Character.HumanoidRootPart.Position

            if _G.HubKill_Settings.SilentAim then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos) end

            local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
            if gun and not gun:FindFirstChild("CooldownTag") then
                gun:Activate()
                local tag = Instance.new("Folder", gun); tag.Name = "CooldownTag"
                task.delay(0.4, function() tag:Destroy() end)
            end
        end
    end
end)

print("HubKill v13.0 FULL ULTIMATE LOADED SUCCESSFULLY!")
