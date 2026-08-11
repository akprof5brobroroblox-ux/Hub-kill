local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

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
else
    ScreenGui.Parent = CoreGui
end

---------------------------------------------------------
-- ИКОНКА
---------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenIcon"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Text = "HubKill"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = false -- На телефонах лучше false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 210, 255)
ToggleStroke.Thickness = 2

---------------------------------------------------------
-- ГЛАВНОЕ МЕНЮ (Твое)
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

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 105, 1, -35)
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -115, 1, -43)
ContentArea.Position = UDim2.new(0, 110, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreateTab(text, iconText, targetPageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = targetPageName
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentArea
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    Pages[targetPageName] = Page

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Btn.Text = (iconText or "") .. " " .. text
    Btn.TextColor3 = Color3.fromRGB(160, 160, 175)
    Btn.Parent = SideBar
    TabButtons[targetPageName] = Btn
    
    Btn.MouseButton1Click:Connect(function()
        for name, pageFrame in pairs(Pages) do pageFrame.Visible = (name == targetPageName) end
    end)
    return Page
end

local CharPage = CreateTab("Персонаж", "👤", "Character")
local EspPage = CreateTab("ESP", "👁", "ESP")

---------------------------------------------------------
-- ФУНКЦИИ (ESP + AIMLOCK)
---------------------------------------------------------
local AimLock_Enabled = false
_G.InfJump = false

local function AddToggle(page, text, callback)
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(1, 0, 0, 30)
    Switch.Text = text
    Switch.Parent = page
    Switch.MouseButton1Click:Connect(function() 
        callback() 
    end)
end

AddToggle(CharPage, "AimLock (Вкл/Выкл)", function() AimLock_Enabled = not AimLock_Enabled end)
AddToggle(CharPage, "InfJump (Вкл/Выкл)", function() _G.InfJump = not _G.InfJump end)

-- AimLock логика
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
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

-- InfJump логика
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

---------------------------------------------------------
-- ОТКРЫТИЕ МЕНЮ
---------------------------------------------------------
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible MainFrame:TweenSize(UDim2.new(0, 370, 0, 225), "Out", "Quart", 0.3) end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3) task.wait(0.3) MainFrame.Visible = false end)

print("HubKill успешно загружен!")
