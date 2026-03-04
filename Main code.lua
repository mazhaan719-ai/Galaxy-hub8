repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

-- // Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- // Local Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // Configuration
local WEBHOOK_URL = "https://discord.com/api/webhooks/1472120689418043518/6b5RYM4GSKckCBz-c9fFvB9-E-CocJBJWw3Jj6LOOdCW-JVTRS_780aDa2UMiwVVX45C"

-- // Settings State
local Settings = {
    TextSize = 14,
    WindowWidth = 400,
    WindowHeight = 320,
    Opacity = 0.85,
    RGB = {15, 15, 20}
}

-- // Cleanup Old UI
for _, gui in pairs(PlayerGui:GetChildren()) do
    if gui.Name == "UniversalChatUI" then gui:Destroy() end
end

-- // Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalChatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- // Helper: Hover Tween
local function AddHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

-- // Helper: Flawless Dragging
local function MakeDraggable(dragHandle, windowToMove)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = windowToMove.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            windowToMove.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- // 1. RULES POPUP
local function ShowRules()
    local RulesFrame = Instance.new("Frame")
    RulesFrame.Name = "RulesFrame"
    RulesFrame.Size = UDim2.new(0, 420, 0, 480)
    RulesFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
    RulesFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    RulesFrame.BorderSizePixel = 0
    RulesFrame.ZIndex = 100
    RulesFrame.Parent = ScreenGui
    
    Instance.new("UICorner", RulesFrame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 170, 255)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.2
    Stroke.Parent = RulesFrame
    
    local Title = Instance.new("TextLabel")
    Title.Text = "SERVER RULES"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 80, 80)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.Parent = RulesFrame
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0.9, 0, 0, 1)
    Divider.Position = UDim2.new(0.05, 0, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = RulesFrame

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -40, 1, -120)
    Scroll.Position = UDim2.new(0, 20, 0, 60)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.Parent = RulesFrame
    
    local RulesText = Instance.new("TextLabel")
    RulesText.Text = [[
<font color="#00AAFF">💬</font> Be respectful, no hate or bullying
<font color="#00AAFF">🚫</font> No spam, floods, or ping abuse
<font color="#00AAFF">🔒</font> Keep privacy, no doxxing allowed
<font color="#00AAFF">📢</font> No advertisements
<font color="#00AAFF">⚠️</font> No NSFW, illegal, or harmful stuff
<font color="#00AAFF">🛑</font> Hate speech = warning or ban
<font color="#00AAFF">📬</font> Report issues to our main server 
<font color="#FF5050">🔴</font> 10 warnings result in instant ban
]]
    RulesText.Size = UDim2.new(1, 0, 0, 0)
    RulesText.AutomaticSize = Enum.AutomaticSize.Y
    RulesText.BackgroundTransparency = 1
    RulesText.TextColor3 = Color3.fromRGB(220, 220, 225)
    RulesText.Font = Enum.Font.Gotham
    RulesText.TextSize = 15
    RulesText.RichText = true
    RulesText.TextXAlignment = Enum.TextXAlignment.Left
    RulesText.TextYAlignment = Enum.TextYAlignment.Top
    RulesText.TextWrapped = true
    RulesText.Parent = Scroll
    
    local AgreeBtn = Instance.new("TextButton")
    AgreeBtn.Text = "I Agree & Understand"
    AgreeBtn.Size = UDim2.new(0.8, 0, 0, 45)
    AgreeBtn.AnchorPoint = Vector2.new(0.5, 1)
    AgreeBtn.Position = UDim2.new(0.5, 0, 1, -15)
    AgreeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 230)
    AgreeBtn.TextColor3 = Color3.new(1,1,1)
    AgreeBtn.Font = Enum.Font.GothamBold
    AgreeBtn.TextSize = 16
    AgreeBtn.Parent = RulesFrame
    Instance.new("UICorner", AgreeBtn).CornerRadius = UDim.new(0, 8)
    
    AddHoverEffect(AgreeBtn, Color3.fromRGB(0, 150, 230), Color3.fromRGB(0, 170, 255))
    
    AgreeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(RulesFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        RulesFrame:Destroy()
    end)
end

-- // 2. NOTIFICATION SYSTEM
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "NotificationContainer"
NotifyContainer.Size = UDim2.new(0, 250, 1, 0)
NotifyContainer.Position = UDim2.new(1, -260, 0, 0)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.Parent = NotifyContainer

local function SpawnPopup(sender, message)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.1
    Frame.ClipsDescendants = true
    Frame.Parent = NotifyContainer
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 170, 255)
    Stroke.Transparency = 0.5
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Text = sender
    Title.Size = UDim2.new(1, -16, 0, 20)
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 170, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Msg = Instance.new("TextLabel")
    Msg.Text = message
    Msg.Size = UDim2.new(1, -16, 0, 20)
    Msg.Position = UDim2.new(0, 8, 0, 22)
    Msg.BackgroundTransparency = 1
    Msg.TextColor3 = Color3.fromRGB(230, 230, 230)
    Msg.Font = Enum.Font.Gotham
    Msg.TextSize = 13
    Msg.TextXAlignment = Enum.TextXAlignment.Left
    Msg.TextWrapped = true
    Msg.Parent = Frame

    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 55)}):Play()

    task.delay(4, function()
        if not Frame or not Frame.Parent then return end
        TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        Frame:Destroy()
    end)
end

-- // 3. MAIN WINDOW & TOP BAR
local MainFrame = Instance.new("Frame")
MainFrame.Name = "ChatWindow"
MainFrame.Size = UDim2.new(0, Settings.WindowWidth, 0, Settings.WindowHeight)
MainFrame.Position = UDim2.new(0.5, -Settings.WindowWidth/2, 0.5, -Settings.WindowHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(Settings.RGB[1], Settings.RGB[2], Settings.RGB[3])
MainFrame.BackgroundTransparency = Settings.Opacity
MainFrame.ClipsDescendants = true -- Perfectly clips content when shrinking
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 120)
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar (Handles Dragging)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame
MakeDraggable(TopBar, MainFrame)

-- Window Controls (Minimize & Settings)
local ControlLayout = Instance.new("UIListLayout")
ControlLayout.FillDirection = Enum.FillDirection.Horizontal
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
ControlLayout.Padding = UDim.new(0, 5)
ControlLayout.Parent = TopBar

local ControlPadding = Instance.new("UIPadding")
ControlPadding.PaddingRight = UDim.new(0, 5)
ControlPadding.PaddingTop = UDim.new(0, 5)
ControlPadding.Parent = TopBar

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Text = "⚙️"
SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsBtn.BackgroundTransparency = 0.5
SettingsBtn.TextSize = 16
SettingsBtn.TextColor3 = Color3.new(1,1,1)
SettingsBtn.LayoutOrder = 1
SettingsBtn.Parent = TopBar
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6)
AddHoverEffect(SettingsBtn, Color3.fromRGB(40, 40, 50), Color3.fromRGB(70, 70, 85))

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "−"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.LayoutOrder = 2
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)
AddHoverEffect(MinimizeBtn, Color3.fromRGB(40, 40, 50), Color3.fromRGB(70, 70, 85))

-- Content Container (PREVENTS SQUASHING WHEN MINIMIZING)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "Content"
ContentContainer.Size = UDim2.new(1, 0, 0, Settings.WindowHeight - 40)
ContentContainer.Position = UDim2.new(0, 0, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tab System
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 160, 0, 30)
TabFrame.Position = UDim2.new(0, 5, 0, 5)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = TopBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabFrame

local function CreateTab(text, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    AddHoverEffect(btn, Color3.fromRGB(50, 50, 60), Color3.fromRGB(80, 80, 95))
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Scrolling Frames (Fixed Jitter with AutomaticCanvasSize)
local function CreateScrollFrame(name, heightOffset)
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = name
    Scroll.Size = UDim2.new(1, -16, 1, heightOffset)
    Scroll.Position = UDim2.new(0, 8, 0, 5)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = Scroll
    
    return Scroll
end

local GlobalScroll = CreateScrollFrame("GlobalScroll", -50)
local PrivateScroll = CreateScrollFrame("PrivateScroll", -90)
PrivateScroll.Visible = false

-- Inputs
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -16, 0, 36)
InputBox.Position = UDim2.new(0, 8, 1, -42)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
InputBox.BackgroundTransparency = 0.3
InputBox.TextColor3 = Color3.fromRGB(240, 240, 240)
InputBox.PlaceholderText = "Type message here..."
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
InputBox.Text = ""
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 14
InputBox.Parent = ContentContainer
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

local InputPadding = Instance.new("UIPadding")
InputPadding.PaddingLeft = UDim.new(0, 10)
InputPadding.PaddingRight = UDim.new(0, 10)
InputPadding.Parent = InputBox

local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, -16, 0, 36)
TargetBox.Position = UDim2.new(0, 8, 1, -84)
TargetBox.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
TargetBox.BackgroundTransparency = 0.3
TargetBox.TextColor3 = Color3.fromRGB(220, 180, 255)
TargetBox.PlaceholderText = "Target Username..."
TargetBox.PlaceholderColor3 = Color3.fromRGB(180, 140, 220)
TargetBox.TextSize = 14
TargetBox.Font = Enum.Font.GothamMedium
TargetBox.Visible = false
TargetBox.Parent = ContentContainer
Instance.new("UICorner", TargetBox).CornerRadius = UDim.new(0, 8)

local TargetPadding = Instance.new("UIPadding")
TargetPadding.PaddingLeft = UDim.new(0, 10)
TargetPadding.PaddingRight = UDim.new(0, 10)
TargetPadding.Parent = TargetBox

local currentTab = "Global"
CreateTab("Global", function()
    currentTab = "Global"
    GlobalScroll.Visible, PrivateScroll.Visible, TargetBox.Visible = true, false, false
    InputBox.PlaceholderText = "Type to everyone..."
end)

CreateTab("Private", function()
    currentTab = "Private"
    GlobalScroll.Visible, PrivateScroll.Visible, TargetBox.Visible = false, true, true
    InputBox.PlaceholderText = "Type whisper..."
end)

-- Minimize Logic
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetHeight = isMinimized and 40 or Settings.WindowHeight
    MinimizeBtn.Text = isMinimized and "+" or "−"
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, Settings.WindowWidth, 0, targetHeight)
    }):Play()
end)

-- // 4. SETTINGS PANEL (Fixed: Moved to ScreenGui to prevent clipping)
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0, 240, 0, 360)
SettingsFrame.Position = UDim2.new(0, 0, 0, 0) -- Set dynamically on open
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SettingsFrame.BackgroundTransparency = 0.05
SettingsFrame.Visible = false
SettingsFrame.Parent = ScreenGui -- Free from MainFrame's ClipDescendants!

Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 12)
local SetStroke = Instance.new("UIStroke")
SetStroke.Color = Color3.fromRGB(100, 100, 120)
SetStroke.Thickness = 1.5
SetStroke.Transparency = 0.5
SetStroke.Parent = SettingsFrame

local SetTopBar = Instance.new("Frame")
SetTopBar.Size = UDim2.new(1, 0, 0, 40)
SetTopBar.BackgroundTransparency = 1
SetTopBar.Parent = SettingsFrame
MakeDraggable(SetTopBar, SettingsFrame)

local SetTitle = Instance.new("TextLabel")
SetTitle.Text = "Settings"
SetTitle.Size = UDim2.new(1, 0, 1, 0)
SetTitle.BackgroundTransparency = 1
SetTitle.TextColor3 = Color3.new(1,1,1)
SetTitle.Font = Enum.Font.GothamBold
SetTitle.TextSize = 18
SetTitle.Parent = SetTopBar

local SetList = Instance.new("ScrollingFrame")
SetList.Size = UDim2.new(1, -16, 1, -50)
SetList.Position = UDim2.new(0, 8, 0, 40)
SetList.BackgroundTransparency = 1
SetList.ScrollBarThickness = 4
SetList.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130)
SetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SetList.CanvasSize = UDim2.new(0, 0, 0, 0)
SetList.Parent = SettingsFrame

local SetLayout = Instance.new("UIListLayout")
SetLayout.Padding = UDim.new(0, 15)
SetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SetLayout.Parent = SetList

SettingsBtn.MouseButton1Click:Connect(function() 
    SettingsFrame.Visible = not SettingsFrame.Visible 
    if SettingsFrame.Visible then
        -- Snap to the right side of the main window cleanly
        SettingsFrame.Position = UDim2.new(
            MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + MainFrame.AbsoluteSize.X + 15,
            MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset
        )
    end
end)

local function CreateSlider(name, min, max, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(0.95, 0, 0, 45)
    F.BackgroundTransparency = 1
    F.Parent = SetList
    
    local L = Instance.new("TextLabel")
    L.Text = name .. ": " .. string.format("%.2f", default)
    L.Size = UDim2.new(1, 0, 0, 18)
    L.TextColor3 = Color3.fromRGB(220, 220, 220)
    L.BackgroundTransparency = 1
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F
    
    local BG = Instance.new("Frame")
    BG.Size = UDim2.new(1, 0, 0, 10)
    BG.Position = UDim2.new(0, 0, 0, 25)
    BG.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    BG.Parent = F
    Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.Parent = BG
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = BG
    
    local function Update(input)
        local pos = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        
        if max > 10 then L.Text = name .. ": " .. math.floor(val) 
        else L.Text = name .. ": " .. string.format("%.2f", val) end
        
        callback(val)
    end
    
    local dragging = false
    Btn.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = true 
            SetList.ScrollingEnabled = false 
            Update(i) 
        end 
    end)
    
    UserInputService.InputChanged:Connect(function(i) 
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            Update(i) 
        end 
    end)
    
    local function StopDragging()
        dragging = false
        SetList.ScrollingEnabled = true 
    end

    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            StopDragging()
        end 
    end)
end

-- Populate Settings
CreateSlider("Opacity", 0, 1, Settings.Opacity, function(v) MainFrame.BackgroundTransparency = 1 - v end)
CreateSlider("Red", 0, 1, Settings.RGB[1]/255, function(v) Settings.RGB[1]=v*255; MainFrame.BackgroundColor3 = Color3.fromRGB(Settings.RGB[1],Settings.RGB[2],Settings.RGB[3]) end)
CreateSlider("Green", 0, 1, Settings.RGB[2]/255, function(v) Settings.RGB[2]=v*255; MainFrame.BackgroundColor3 = Color3.fromRGB(Settings.RGB[1],Settings.RGB[2],Settings.RGB[3]) end)
CreateSlider("Blue", 0, 1, Settings.RGB[3]/255, function(v) Settings.RGB[3]=v*255; MainFrame.BackgroundColor3 = Color3.fromRGB(Settings.RGB[1],Settings.RGB[2],Settings.RGB[3]) end)
CreateSlider("Width", 250, 600, Settings.WindowWidth, function(v) 
    Settings.WindowWidth = v
    if not isMinimized then MainFrame.Size = UDim2.new(0, v, 0, Settings.WindowHeight) end
end)
CreateSlider("Height", 200, 600, Settings.WindowHeight, function(v) 
    Settings.WindowHeight = v
    ContentContainer.Size = UDim2.new(1, 0, 0, v - 40) -- Prevents squashing when updating height
    if not isMinimized then MainFrame.Size = UDim2.new(0, Settings.WindowWidth, 0, v) end
end)
CreateSlider("Text Size", 8, 24, Settings.TextSize, function(v) 
    Settings.TextSize = v
    for _,c in pairs(GlobalScroll:GetChildren()) do if c:IsA("TextLabel") then c.TextSize = v end end
    for _,c in pairs(PrivateScroll:GetChildren()) do if c:IsA("TextLabel") then c.TextSize = v end end
end)

-- // 5. WEBHOOK & CHAT LOGIC
local function SendWebhook(sender, msg)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "New Message Logged",
            ["color"] = 3447003,
            ["fields"] = {
                {["name"] = "Player", ["value"] = sender, ["inline"] = true},
                {["name"] = "Message", ["value"] = msg, ["inline"] = false},
                {["name"] = "Game", ["value"] = "ID: "..tostring(game.PlaceId), ["inline"] = true}
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local jsonData = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    
    local requestFunc = request or http_request or (syn and syn.request)
    if requestFunc then
        requestFunc({Url = WEBHOOK_URL, Method = "POST", Headers = headers, Body = jsonData})
    else
        pcall(function() HttpService:PostAsync(WEBHOOK_URL, jsonData) end)
    end
end

local function GetColor(userId)
    local hue = (userId % 360) / 360
    return Color3.fromHSV(hue, 0.6, 0.9)
end

local function AddMessage(scroll, name, msg, colorOverride)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -5, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = Settings.TextSize
    lbl.Font = Enum.Font.GothamMedium
    lbl.RichText = true
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    local c = colorOverride or Color3.fromRGB(255,255,255)
    lbl.Text = string.format("<font color='rgb(%d,%d,%d)'><b>%s:</b></font> %s", c.R*255, c.G*255, c.B*255, name, msg)
    lbl.Parent = scroll
    
    -- Flawless Auto-Scroll
    RunService.RenderStepped:Wait()
    scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y)
end

local IsTextChatService = TextChatService.ChatVersion == Enum.ChatVersion.TextChatService

local function OnMessage(senderName, message, senderId)
    SpawnPopup(senderName, message)
    AddMessage(GlobalScroll, senderName, message, GetColor(senderId))
    
    if senderName ~= LocalPlayer.Name then SendWebhook(senderName, message) end

    if message:lower():match("^/w ") or (currentTab == "Private" and senderName == LocalPlayer.Name) then
        AddMessage(PrivateScroll, senderName, message, Color3.fromRGB(220, 130, 255))
    end
end

if IsTextChatService then
    TextChatService.MessageReceived:Connect(function(tab)
        if tab.TextSource then OnMessage(tab.TextSource.Name, tab.Text, tab.TextSource.UserId) end
    end)
else
    local function hookPlayer(p)
        p.Chatted:Connect(function(msg) OnMessage(p.Name, msg, p.UserId) end)
    end
    for _, p in pairs(Players:GetPlayers()) do hookPlayer(p) end
    Players.PlayerAdded:Connect(hookPlayer)
end

InputBox.FocusLost:Connect(function(enter)
    if not enter then return end
    local txt = InputBox.Text
    if txt == "" then return end
    
    if currentTab == "Global" then
        if IsTextChatService then 
            TextChatService.TextChannels.RBXGeneral:SendAsync(txt)
        else 
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All") 
        end
    else
        local target = TargetBox.Text
        if target ~= "" then
            local cmd = "/w " .. target .. " " .. txt
            if IsTextChatService then 
                TextChatService.TextChannels.RBXGeneral:SendAsync(cmd)
            else 
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cmd, "All") 
            end
            AddMessage(PrivateScroll, "To ["..target.."]", txt, Color3.fromRGB(255, 100, 255))
        end
    end
    
    InputBox.Text = ""
end)

ShowRules()
