--[[
    Kysezz HUB - Key System
    made by Kysezz
]]

----------------------------------------------------------------
-- CONFIG (edit these)
----------------------------------------------------------------
local Config = {
    Title   = "Kysezz HUB",
    Credit  = "made by Kysezz",

    -- Paste your key link between the quotes. Change it any time.
    KeyLink = "https://www.roblox.rw/communities/178984439199/Stapian-Wrld",

    -- Option A: a single hardcoded key (leave "" to disable)
    Key = "PASTE_YOUR_KEY_HERE",

    -- Option B: a URL that returns the valid key as plain text (leave "" to disable)
    KeyCheckURL = "",

    -- Runs after a correct key. Put your main script here.
    OnSuccess = function()
        -- loadstring(game:HttpGet("PASTE_YOUR_MAIN_SCRIPT_LINK_HERE"))()
        print("Kysezz HUB loaded!")
    end,

    -- Colors
    Accent     = Color3.fromRGB(120, 90, 255),
    Accent2    = Color3.fromRGB(70, 140, 255),
    Background = Color3.fromRGB(18, 18, 24),
    Panel      = Color3.fromRGB(28, 28, 38),
    Text       = Color3.fromRGB(240, 240, 250),
    SubText    = Color3.fromRGB(150, 150, 170),
    Good       = Color3.fromRGB(80, 220, 130),
    Bad        = Color3.fromRGB(255, 90, 100),
}

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function getParent()
    local ok, ui = pcall(function()
        return (gethui and gethui()) or CoreGui
    end)
    if ok and ui then return ui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local parent = getParent()
local old = parent:FindFirstChild("KysezzHubKey")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KysezzHubKey"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.BackgroundColor3 = Config.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
corner(main, 14)
stroke(main, Config.Accent, 1.5, 0.35)

-- Top gradient bar
local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 4)
bar.BackgroundColor3 = Color3.new(1, 1, 1)
bar.BorderSizePixel = 0
bar.Parent = main
local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new(Config.Accent, Config.Accent2)
barGrad.Parent = bar

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 18)
title.Size = UDim2.new(1, 0, 0, 34)
title.Font = Enum.Font.GothamBold
title.Text = Config.Title
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = main
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new(Config.Accent, Config.Accent2)
titleGrad.Parent = title

-- Credit
local credit = Instance.new("TextLabel")
credit.BackgroundTransparency = 1
credit.Position = UDim2.new(0, 0, 0, 52)
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Font = Enum.Font.Gotham
credit.Text = Config.Credit
credit.TextSize = 13
credit.TextColor3 = Config.SubText
credit.Parent = main

-- Close button
local close = Instance.new("TextButton")
close.AnchorPoint = Vector2.new(1, 0)
close.Position = UDim2.new(1, -12, 0, 14)
close.Size = UDim2.new(0, 26, 0, 26)
close.BackgroundColor3 = Config.Panel
close.BorderSizePixel = 0
close.AutoButtonColor = false
close.Font = Enum.Font.GothamBold
close.Text = "X"
close.TextSize = 13
close.TextColor3 = Config.SubText
close.Parent = main
corner(close, 7)

-- Key input
local inputBox = Instance.new("TextBox")
inputBox.Position = UDim2.new(0, 24, 0, 92)
inputBox.Size = UDim2.new(1, -48, 0, 42)
inputBox.BackgroundColor3 = Config.Panel
inputBox.BorderSizePixel = 0
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "Enter your key here..."
inputBox.PlaceholderColor3 = Config.SubText
inputBox.Text = ""
inputBox.TextSize = 15
inputBox.TextColor3 = Config.Text
inputBox.Parent = main
corner(inputBox, 9)
local inputStroke = stroke(inputBox, Config.Accent, 1.2, 0.8)

inputBox.Focused:Connect(function()
    tween(inputStroke, {Transparency = 0.1})
end)
inputBox.FocusLost:Connect(function()
    tween(inputStroke, {Transparency = 0.8})
end)

-- Button factory
local function makeButton(text, position, size, filled)
    local btn = Instance.new("TextButton")
    btn.Position = position
    btn.Size = size
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextSize = 15
    btn.TextColor3 = Config.Text
    btn.Parent = main
    corner(btn, 9)

    if filled then
        btn.BackgroundColor3 = Color3.new(1, 1, 1)
        btn.Text = ""
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(Config.Accent, Config.Accent2)
        g.Rotation = 20
        g.Parent = btn

        -- separate label so the gradient doesn't tint the text
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = text
        lbl.TextSize = 15
        lbl.TextColor3 = Config.Text
        lbl.Parent = btn
    else
        btn.BackgroundColor3 = Config.Panel
        stroke(btn, Config.Accent, 1.2, 0.4)
    end

    btn.MouseEnter:Connect(function()
        tween(btn, {Size = size + UDim2.new(0, 4, 0, 2)}, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {Size = size}, 0.12)
    end)
    return btn
end

-- Left: Check Key | Right: Copy Link
local checkBtn = makeButton("Check Key", UDim2.new(0, 24, 0, 150), UDim2.new(0.5, -30, 0, 42), true)
local copyBtn  = makeButton("Copy Link", UDim2.new(0.5, 6, 0, 150), UDim2.new(0.5, -30, 0, 42), false)

-- Status label
local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 24, 0, 206)
status.Size = UDim2.new(1, -48, 0, 20)
status.Font = Enum.Font.Gotham
status.Text = "Get your key with the Copy Link button."
status.TextSize = 13
status.TextColor3 = Config.SubText
status.Parent = main

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or Config.SubText
end

----------------------------------------------------------------
-- LOGIC
----------------------------------------------------------------
local checking = false

local function fetchValidKey()
    if Config.KeyCheckURL ~= "" then
        local ok, res = pcall(function()
            return game:HttpGet(Config.KeyCheckURL)
        end)
        if ok and res then
            return (res:gsub("%s+", ""))
        end
        return nil, "Could not reach key server."
    end
    return Config.Key
end

local function closeGui()
    tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
    task.wait(0.28)
    gui:Destroy()
end

checkBtn.MouseButton1Click:Connect(function()
    if checking then return end
    local entered = inputBox.Text:gsub("%s+", "")
    if entered == "" then
        setStatus("Please enter a key first.", Config.Bad)
        return
    end

    checking = true
    setStatus("Checking key...", Config.SubText)
    task.wait(0.4)

    local valid, err = fetchValidKey()
    if not valid then
        setStatus(err or "Key check failed.", Config.Bad)
        checking = false
        return
    end

    if entered == valid then
        setStatus("Key accepted! Loading...", Config.Good)
        tween(inputStroke, {Color = Config.Good, Transparency = 0})
        task.wait(0.8)
        closeGui()
        pcall(Config.OnSuccess)
    else
        setStatus("Invalid key. Try again.", Config.Bad)
        tween(inputStroke, {Color = Config.Bad, Transparency = 0})
        -- little shake
        local origin = inputBox.Position
        for i = 1, 4 do
            inputBox.Position = origin + UDim2.new(0, (i % 2 == 0) and 6 or -6, 0, 0)
            task.wait(0.04)
        end
        inputBox.Position = origin
        task.wait(0.6)
        tween(inputStroke, {Color = Config.Accent, Transparency = 0.8})
    end
    checking = false
end)

copyBtn.MouseButton1Click:Connect(function()
    local copier = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if copier then
        pcall(copier, Config.KeyLink)
        setStatus("Link copied to clipboard!", Config.Good)
    else
        setStatus("Clipboard unsupported: " .. Config.KeyLink, Config.Bad)
    end
end)

close.MouseEnter:Connect(function()
    tween(close, {BackgroundColor3 = Config.Bad, TextColor3 = Config.Text}, 0.12)
end)
close.MouseLeave:Connect(function()
    tween(close, {BackgroundColor3 = Config.Panel, TextColor3 = Config.SubText}, 0.12)
end)
close.MouseButton1Click:Connect(closeGui)

----------------------------------------------------------------
-- DRAGGING
----------------------------------------------------------------
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

----------------------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------------------
TweenService:Create(
    main,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 380, 0, 246)}
):Play()
