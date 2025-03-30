local Kry = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Utility = {}
local Objects = {}

function Kry:DraggingEnabled(frame, parent)
    parent = parent or frame
    
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local themes = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background = Color3.fromRGB(36, 37, 43),
    Header = Color3.fromRGB(28, 29, 34),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}

local themeStyles = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    GrapeTheme = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background = Color3.fromRGB(64, 50, 71),
        Header = Color3.fromRGB(36, 28, 41),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background = Color3.fromRGB(44, 62, 82),
        Header = Color3.fromRGB(57, 81, 105),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95)
    },
    Sentinel = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(32, 32, 32),
        Header = Color3.fromRGB(24, 24, 24),
        TextColor = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Synapse = {
        SchemeColor = Color3.fromRGB(46, 48, 43),
        Background = Color3.fromRGB(13, 15, 12),
        Header = Color3.fromRGB(36, 38, 35),
        TextColor = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Serpent = {
        SchemeColor = Color3.fromRGB(0, 166, 58),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    }
}

local SettingsT = {}
local Name = "KryConfig.JSON"

-- Settings System Initialization
pcall(function()
    if not pcall(function() return readfile(Name) end) then
        writefile(Name, HttpService:JSONEncode(SettingsT))
    end
    SettingsT = HttpService:JSONDecode(readfile(Name) or "{}")
end)

local function SaveSettings()
    pcall(function()
        writefile(Name, HttpService:JSONEncode(SettingsT))
    end)
end

local LibName = tostring(math.random(1, 100)) .. tostring(math.random(1, 50)) .. tostring(math.random(1, 100))

function Kry:ToggleUI()
    if game.CoreGui[LibName].Enabled then
        game.CoreGui[LibName].Enabled = false
    else
        game.CoreGui[LibName].Enabled = true
    end
end

function Kry.CreateLib(kryName, themeList)
    if not themeList then
        themeList = themes
    end
    if type(themeList) == "string" then
        themeList = themeStyles[themeList] or themes
    end

    kryName = kryName or "Kry Library"
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainHeader = Instance.new("Frame")
    local headerCover = Instance.new("UICorner")
    local coverup = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local close = Instance.new("ImageButton")
    local MinButton = Instance.new("ImageButton")
    local MainSide = Instance.new("Frame")
    local sideCorner = Instance.new("UICorner")
    local coverup_2 = Instance.new("Frame")
    local tabFrames = Instance.new("Frame")
    local tabListing = Instance.new("UIListLayout")
    local pages = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")
    local blurFrame = Instance.new("Frame")

    Kry:DraggingEnabled(MainHeader, Main)

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.336503863, 0, 0.275485456, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)

    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    Objects[MainHeader] = "BackgroundColor3"
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Name = "headerCover"
    headerCover.Parent = MainHeader

    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.758620679, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)

    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.0171428565, 0, 0.344827592, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.Gotham
    title.Text = kryName
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 16.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.949999988, 0, 0.137999997, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.ZIndex = 2
    close.Image = "rbxassetid://113762177851436"
    close.MouseButton1Click:Connect(function()
        game.TweenService:Create(close, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
        wait()
        game.TweenService:Create(Main, TweenInfo.new(0.1), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(1)
        ScreenGui:Destroy()
    end)

    MinButton.Parent = ScreenGui
    MinButton.Size = UDim2.new(0, 40, 0, 40)
    MinButton.Position = UDim2.new(0.15, 0, 0.15, 0)
    MinButton.Image = "rbxassetid://113762177851436"
    MinButton.Active = true
    MinButton.Draggable = true
    MinButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(-7.4505806e-09, 0, 0.0911949649, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)

    sideCorner.CornerRadius = UDim.new(0, 4)
    sideCorner.Name = "sideCorner"
    sideCorner.Parent = MainSide

    coverup_2.Name = "coverup"
    coverup_2.Parent = MainSide
    coverup_2.BackgroundColor3 = themeList.Header
    coverup_2.BorderSizePixel = 0
    coverup_2.Position = UDim2.new(0.949939311, 0, 0, 0)
    coverup_2.Size = UDim2.new(0, 7, 0, 289)

    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.0438990258, 0, -0.00066378375, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder

    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0.299047589, 0, 0.122641519, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    Pages.Name = "Pages"
    Pages.Parent = pages

    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.Position = UDim2.new(0.299047619, 0, 0.874213815, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.Position = UDim2.new(-0.0222222228, 0, -0.0371747203, 0)
    blurFrame.Size = UDim2.new(0, 376, 0, 289)
    blurFrame.ZIndex = 999

    coroutine.wrap(function()
        while wait() do
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            MainSide.BackgroundColor3 = themeList.Header
            coverup_2.BackgroundColor3 = themeList.Header
            coverup.BackgroundColor3 = themeList.Header
        end
    end)()

    function Kry:ChangeColor(prope, color)
        if prope == "Background" then
            themeList.Background = color
        elseif prope == "SchemeColor" then
            themeList.SchemeColor = color
        elseif prope == "Header" then
            themeList.Header = color
        elseif prope == "TextColor" then
            themeList.TextColor = color
        elseif prope == "ElementColor" then
            themeList.ElementColor = color
        end
    end

    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize
            game.TweenService:Create(page, TweenInfo.new(0.15), {CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)}):Play()
        end

        page.Name = "Page"
        page.Parent = Pages
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, -0.00371747208, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 16, themeList.SchemeColor.g * 255 - 15, themeList.SchemeColor.b * 255 - 28)

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Name = tabName .. "TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 14.000
        tabButton.BackgroundTransparency = 1

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        end

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton

        tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for i, v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true
            for i, v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
        end)

        local Sections = {}
        local focusing = false
        local viewDe = false

        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")

            hidden = hidden or false
            sectionHead.Visible = not hidden

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0

            sectionlistoknvm.Name = "sectionlistoknvm"
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(0, 352, 0, 33)

            sHeadCorner.CornerRadius = UDim.new(0, 4)
            sHeadCorner.Parent = sectionHead

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.0198863633, 0, 0, 0)
            sectionName.Size = UDim2.new(0.980113626, 0, 1, 0)
            sectionName.Font = Enum.Font.Gotham
            sectionName.Text = secName
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 14.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1
            sectionInners.Position = UDim2.new(0, 0, 0.190751448, 0)

            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)

            local function updateSectionFrame()
                local innerSc = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionlistoknvm.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(0, 352, 0, frameSc.Y)
            end
            updateSectionFrame()
            UpdateSize()

            local Elements = {}

            function Elements:NewButton(bname, tip, callback)
                bname = bname or "Button"
                tip = tip or "Clicks the button"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local Sample = Instance.new("ImageLabel")

                buttonElement.Name = "buttonElement"
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(0, 352, 0, 33)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.SourceSans
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                buttonElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = buttonElement

                btnName.Name = "btnName"
                btnName.Parent = buttonElement
                btnName.BackgroundTransparency = 1
                btnName.Position = UDim2.new(0.0198863633, 0, 0.272727281, 0)
                btnName.Size = UDim2.new(0, 288, 0, 14)
                btnName.Font = Enum.Font.GothamSemibold
                btnName.Text = bname
                btnName.TextColor3 = themeList.TextColor
                btnName.TextSize = 14.000
                btnName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                Sample.Name = "Sample"
                Sample.Parent = buttonElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://113762177851436"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.600

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. tip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local ms = game.Players.LocalPlayer:GetMouse()

                buttonElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        callback()
                        local c = Sample:Clone()
                        c.Parent = buttonElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if buttonElement.AbsoluteSize.X >= buttonElement.AbsoluteSize.Y then
                            size = (buttonElement.AbsoluteSize.X * 1.5)
                        else
                            size = (buttonElement.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        buttonElement.BackgroundColor3 = themeList.ElementColor
                        btnName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
            end

            function Elements:NewTextBox(tname, tip, callback)
                tname = tname or "TextBox"
                tip = tip or "Enter text here"
                callback = callback or function() end

                local textBoxElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local tbName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local textBox = Instance.new("TextBox")
                local UICornerTextBox = Instance.new("UICorner")

                textBoxElement.Name = "textBoxElement"
                textBoxElement.Parent = sectionInners
                textBoxElement.BackgroundColor3 = themeList.ElementColor
                textBoxElement.ClipsDescendants = true
                textBoxElement.Size = UDim2.new(0, 352, 0, 33)
                textBoxElement.AutoButtonColor = false
                textBoxElement.Font = Enum.Font.SourceSans
                textBoxElement.Text = ""
                textBoxElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                textBoxElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = textBoxElement

                tbName.Name = "tbName"
                tbName.Parent = textBoxElement
                tbName.BackgroundTransparency = 1
                tbName.Position = UDim2.new(0.0198863633, 0, 0.272727281, 0)
                tbName.Size = UDim2.new(0, 150, 0, 14)
                tbName.Font = Enum.Font.GothamSemibold
                tbName.Text = tname
                tbName.TextColor3 = themeList.TextColor
                tbName.TextSize = 14.000
                tbName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = textBoxElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                textBox.Name = "textBox"
                textBox.Parent = textBoxElement
                textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                textBox.Position = UDim2.new(0.5, 0, 0.272727281, 0)
                textBox.Size = UDim2.new(0, 150, 0, 14)
                textBox.Font = Enum.Font.Gotham
                textBox.Text = SettingsT[tname] or tip
                textBox.TextColor3 = themeList.TextColor
                textBox.TextSize = 12.000
                textBox.TextTransparency = 0.5

                UICornerTextBox.CornerRadius = UDim.new(0, 4)
                UICornerTextBox.Parent = textBox

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. tip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                textBox.Focused:Connect(function()
                    textBox.TextTransparency = 0
                    if textBox.Text == tip then
                        textBox.Text = ""
                    end
                end)

                textBox.FocusLost:Connect(function(enter)
                    if enter then
                        SettingsT[tname] = textBox.Text
                        SaveSettings()
                        callback(textBox.Text)
                    end
                    if textBox.Text == "" then
                        textBox.Text = tip
                        textBox.TextTransparency = 0.5
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        textBoxElement.BackgroundColor3 = themeList.ElementColor
                        tbName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        textBox.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
            end

            function Elements:NewToggle(tname, nTip, callback)
                local TogFunction = {}
                tname = tname or "Toggle"
                nTip = nTip or "Prints Current Toggle State"
                callback = callback or function() end
                local toggled = SettingsT[tname] or false

                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local Sample = Instance.new("ImageLabel")

                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(0, 352, 0, 33)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.SourceSans
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = toggleElement

                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = toggleElement
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://113762177851436"
                toggleDisabled.ImageColor3 = themeList.SchemeColor

                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = toggleElement
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://113762177851436"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageTransparency = toggled and 0 or 1

                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = toggleElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                Sample.Name = "Sample"
                Sample.Parent = toggleElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://113762177851436"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.600

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. nTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local ms = game.Players.LocalPlayer:GetMouse()

                toggleElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        toggled = not toggled
                        SettingsT[tname] = toggled
                        SaveSettings()
                        game.TweenService:Create(toggleEnabled, TweenInfo.new(0.11), {ImageTransparency = toggled and 0 or 1}):Play()
                        callback(toggled)
                        local c = Sample:Clone()
                        c.Parent = toggleElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if toggleElement.AbsoluteSize.X >= toggleElement.AbsoluteSize.Y then
                            size = (toggleElement.AbsoluteSize.X * 1.5)
                        else
                            size = (toggleElement.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        toggleElement.BackgroundColor3 = themeList.ElementColor
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()

                function TogFunction:UpdateToggle(newState)
                    toggled = newState
                    SettingsT[tname] = toggled
                    SaveSettings()
                    game.TweenService:Create(toggleEnabled, TweenInfo.new(0.11), {ImageTransparency = toggled and 0 or 1}):Play()
                end
                return TogFunction
            end

            function Elements:NewDropdown(dname, tip, options, callback)
                dname = dname or "Dropdown"
                tip = tip or "Select an option"
                options = options or {}
                callback = callback or function() end
                local selectedOption = SettingsT[dname] or options[1]

                local dropdownElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local dropName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local dropFrame = Instance.new("Frame")
                local dropList = Instance.new("UIListLayout")
                local dropCorner = Instance.new("UICorner")
                local currentOption = Instance.new("TextLabel")

                dropdownElement.Name = "dropdownElement"
                dropdownElement.Parent = sectionInners
                dropdownElement.BackgroundColor3 = themeList.ElementColor
                dropdownElement.ClipsDescendants = true
                dropdownElement.Size = UDim2.new(0, 352, 0, 33)
                dropdownElement.AutoButtonColor = false
                dropdownElement.Font = Enum.Font.SourceSans
                dropdownElement.Text = ""
                dropdownElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                dropdownElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = dropdownElement

                dropName.Name = "dropName"
                dropName.Parent = dropdownElement
                dropName.BackgroundTransparency = 1
                dropName.Position = UDim2.new(0.0198863633, 0, 0.272727281, 0)
                dropName.Size = UDim2.new(0, 150, 0, 14)
                dropName.Font = Enum.Font.GothamSemibold
                dropName.Text = dname
                dropName.TextColor3 = themeList.TextColor
                dropName.TextSize = 14.000
                dropName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = dropdownElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                currentOption.Name = "currentOption"
                currentOption.Parent = dropdownElement
                currentOption.BackgroundTransparency = 1
                currentOption.Position = UDim2.new(0.5, 0, 0.272727281, 0)
                currentOption.Size = UDim2.new(0, 150, 0, 14)
                currentOption.Font = Enum.Font.Gotham
                currentOption.Text = selectedOption or "Select..."
                currentOption.TextColor3 = themeList.TextColor
                currentOption.TextSize = 12.000
                currentOption.TextXAlignment = Enum.TextXAlignment.Right

                dropFrame.Name = "dropFrame"
                dropFrame.Parent = dropdownElement
                dropFrame.BackgroundColor3 = themeList.ElementColor
                dropFrame.Position = UDim2.new(0, 0, 1, 0)
                dropFrame.Size = UDim2.new(0, 352, 0, 0)
                dropFrame.ClipsDescendants = true
                dropFrame.Visible = false

                dropCorner.CornerRadius = UDim.new(0, 4)
                dropCorner.Parent = dropFrame

                dropList.Name = "dropList"
                dropList.Parent = dropFrame
                dropList.SortOrder = Enum.SortOrder.LayoutOrder
                dropList.Padding = UDim.new(0, 2)

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. tip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local isOpen = false

                local function populateDropdown()
                    for _, option in pairs(options) do
                        local optionButton = Instance.new("TextButton")
                        local optCorner = Instance.new("UICorner")
                        optionButton.Name = option .. "Option"
                        optionButton.Parent = dropFrame
                        optionButton.BackgroundColor3 = themeList.ElementColor
                        optionButton.Size = UDim2.new(0, 352, 0, 25)
                        optionButton.AutoButtonColor = false
                        optionButton.Font = Enum.Font.Gotham
                        optionButton.Text = option
                        optionButton.TextColor3 = themeList.TextColor
                        optionButton.TextSize = 12.000
                        optCorner.CornerRadius = UDim.new(0, 4)
                        optCorner.Parent = optionButton

                        optionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            SettingsT[dname] = selectedOption
                            SaveSettings()
                            currentOption.Text = selectedOption
                            callback(selectedOption)
                            Utility:TweenObject(dropFrame, {Size = UDim2.new(0, 352, 0, 0)}, 0.2)
                            isOpen = false
                            dropFrame.Visible = false
                        end)

                        coroutine.wrap(function()
                            while wait() do
                                optionButton.BackgroundColor3 = themeList.ElementColor
                                optionButton.TextColor3 = themeList.TextColor
                            end
                        end)()
                    end
                end
                populateDropdown()

                dropdownElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        isOpen = not isOpen
                        local size = isOpen and UDim2.new(0, 352, 0, math.min(#options * 27, 100)) or UDim2.new(0, 352, 0, 0)
                        dropFrame.Visible = isOpen
                        Utility:TweenObject(dropFrame, {Size = size}, 0.2)
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        dropdownElement.BackgroundColor3 = themeList.ElementColor
                        dropName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        currentOption.TextColor3 = themeList.TextColor
                        dropFrame.BackgroundColor3 = themeList.ElementColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
            end

            function Elements:NewKeybind(kname, tip, key, callback)
                kname = kname or "Keybind"
                tip = tip or "Binds a key"
                key = key or Enum.KeyCode.Q
                callback = callback or function() end
                local currentKey = SettingsT[kname] or key

                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local keyName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local keyLabel = Instance.new("TextLabel")

                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(0, 352, 0, 33)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.SourceSans
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybindElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = keybindElement

                keyName.Name = "keyName"
                keyName.Parent = keybindElement
                keyName.BackgroundTransparency = 1
                keyName.Position = UDim2.new(0.0198863633, 0, 0.272727281, 0)
                keyName.Size = UDim2.new(0, 150, 0, 14)
                keyName.Font = Enum.Font.GothamSemibold
                keyName.Text = kname
                keyName.TextColor3 = themeList.TextColor
                keyName.TextSize = 14.000
                keyName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = keybindElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                keyLabel.Name = "keyLabel"
                keyLabel.Parent = keybindElement
                keyLabel.BackgroundTransparency = 1
                keyLabel.Position = UDim2.new(0.5, 0, 0.272727281, 0)
                keyLabel.Size = UDim2.new(0, 150, 0, 14)
                keyLabel.Font = Enum.Font.Gotham
                keyLabel.Text = currentKey.Name
                keyLabel.TextColor3 = themeList.TextColor
                keyLabel.TextSize = 12.000
                keyLabel.TextXAlignment = Enum.TextXAlignment.Right

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. tip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local waiting = false
                keybindElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        waiting = true
                        keyLabel.Text = "..."
                    end
                end)

                input.InputBegan:Connect(function(inp)
                    if waiting and inp.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = inp.KeyCode
                        SettingsT[kname] = currentKey.Name
                        SaveSettings()
                        keyLabel.Text = currentKey.Name
                        waiting = false
                    elseif inp.KeyCode == currentKey and not waiting then
                        callback()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        keybindElement.BackgroundColor3 = themeList.ElementColor
                        keyName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        keyLabel.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
            end

            function Elements:NewColorPicker(cname, tip, default, callback)
                cname = cname or "ColorPicker"
                tip = tip or "Pick a color"
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                local selectedColor = SettingsT[cname] and Color3.fromRGB(unpack(SettingsT[cname])) or default

                local colorPickerElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local cpName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local colorFrame = Instance.new("Frame")
                local colorCorner = Instance.new("UICorner")
                local colorDisplay = Instance.new("Frame")
                local colorUICorner = Instance.new("UICorner")
                local colorGradient = Instance.new("ImageLabel")
                local colorSelector = Instance.new("Frame")
                local darknessBar = Instance.new("ImageLabel")
                local darknessSelector = Instance.new("Frame")
                local rainbowToggle = Instance.new("TextButton")
                local rainbowCorner = Instance.new("UICorner")

                colorPickerElement.Name = "colorPickerElement"
                colorPickerElement.Parent = sectionInners
                colorPickerElement.BackgroundColor3 = themeList.ElementColor
                colorPickerElement.ClipsDescendants = true
                colorPickerElement.Size = UDim2.new(0, 352, 0, 33)
                colorPickerElement.AutoButtonColor = false
                colorPickerElement.Font = Enum.Font.SourceSans
                colorPickerElement.Text = ""
                colorPickerElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                colorPickerElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = colorPickerElement

                cpName.Name = "cpName"
                cpName.Parent = colorPickerElement
                cpName.BackgroundTransparency = 1
                cpName.Position = UDim2.new(0.0198863633, 0, 0.272727281, 0)
                cpName.Size = UDim2.new(0, 150, 0, 14)
                cpName.Font = Enum.Font.GothamSemibold
                cpName.Text = cname
                cpName.TextColor3 = themeList.TextColor
                cpName.TextSize = 14.000
                cpName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = colorPickerElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://113762177851436"
                viewInfo.ImageColor3 = themeList.SchemeColor

                colorDisplay.Name = "colorDisplay"
                colorDisplay.Parent = colorPickerElement
                colorDisplay.BackgroundColor3 = selectedColor
                colorDisplay.Position = UDim2.new(0.85, 0, 0.151999995, 0)
                colorDisplay.Size = UDim2.new(0, 23, 0, 23)
                colorUICorner.CornerRadius = UDim.new(0, 4)
                colorUICorner.Parent = colorDisplay

                colorFrame.Name = "colorFrame"
                colorFrame.Parent = colorPickerElement
                colorFrame.BackgroundColor3 = themeList.ElementColor
                colorFrame.Position = UDim2.new(0, 0, 1, 0)
                colorFrame.Size = UDim2.new(0, 352, 0, 0)
                colorFrame.ClipsDescendants = true
                colorFrame.Visible = false

                colorCorner.CornerRadius = UDim.new(0, 4)
                colorCorner.Parent = colorFrame

                colorGradient.Name = "colorGradient"
                colorGradient.Parent = colorFrame
                colorGradient.BackgroundTransparency = 1
                colorGradient.Position = UDim2.new(0.05, 0, 0.1, 0)
                colorGradient.Size = UDim2.new(0, 200, 0, 100)
                colorGradient.Image = "rbxassetid://6523286724"

                colorSelector.Name = "colorSelector"
                colorSelector.Parent = colorGradient
                colorSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
                colorSelector.Size = UDim2.new(0, 5, 0, 5)

                darknessBar.Name = "darknessBar"
                darknessBar.Parent = colorFrame
                darknessBar.BackgroundTransparency = 1
                darknessBar.Position = UDim2.new(0.65, 0, 0.1, 0)
                darknessBar.Size = UDim2.new(0, 20, 0, 100)
                darknessBar.Image = "rbxassetid://6523291212"

                darknessSelector.Name = "darknessSelector"
                darknessSelector.Parent = darknessBar
                darknessSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                darknessSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
                darknessSelector.Size = UDim2.new(0, 20, 0, 5)

                rainbowToggle.Name = "rainbowToggle"
                rainbowToggle.Parent = colorFrame
                rainbowToggle.BackgroundColor3 = themeList.SchemeColor
                rainbowToggle.Position = UDim2.new(0.05, 0, 0.7, 0)
                rainbowToggle.Size = UDim2.new(0, 100, 0, 25)
                rainbowToggle.AutoButtonColor = false
                rainbowToggle.Font = Enum.Font.Gotham
                rainbowToggle.Text = "Rainbow: Off"
                rainbowToggle.TextColor3 = themeList.TextColor
                rainbowToggle.TextSize = 12.000
                rainbowCorner.CornerRadius = UDim.new(0, 4)
                rainbowCorner.Parent = rainbowToggle

                local moreInfo = Instance.new("TextLabel")
                local UICornerMore = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  " .. tip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                UICornerMore.CornerRadius = UDim.new(0, 4)
                UICornerMore.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local isOpen = false
                local rainbow = false

                local function updateColor()
                    local hue, sat, val = selectedColor:ToHSV()
                    colorSelector.Position = UDim2.new(sat, 0, 1 - hue, 0)
                    darknessSelector.Position = UDim2.new(0, 0, 1 - val, 0)
                    colorDisplay.BackgroundColor3 = selectedColor
                    SettingsT[cname] = {selectedColor.R * 255, selectedColor.G * 255, selectedColor.B * 255}
                    SaveSettings()
                    callback(selectedColor)
                end
                updateColor()

                colorPickerElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        isOpen = not isOpen
                        colorFrame.Visible = isOpen
                        Utility:TweenObject(colorFrame, {Size = isOpen and UDim2.new(0, 352, 0, 150) or UDim2.new(0, 352, 0, 0)}, 0.2)
                    end
                end)

                local draggingColor = false
                colorGradient.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingColor = true
                    end
                end)

                colorGradient.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingColor = false
                    end
                end)

                input.InputChanged:Connect(function(inp)
                    if draggingColor and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local mx, my = inp.Position.X, inp.Position.Y
                        local gx, gy = colorGradient.AbsolutePosition.X, colorGradient.AbsolutePosition.Y
                        local gw, gh = colorGradient.AbsoluteSize.X, colorGradient.AbsoluteSize.Y
                        local sat = math.clamp((mx - gx) / gw, 0, 1)
                        local hue = 1 - math.clamp((my - gy) / gh, 0, 1)
                        selectedColor = Color3.fromHSV(hue, sat, selectedColor:ToHSV())
                        updateColor()
                    end
                end)

                local draggingDarkness = false
                darknessBar.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingDarkness = true
                    end
                end)

                darknessBar.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingDarkness = false
                    end
                end)

                input.InputChanged:Connect(function(inp)
                    if draggingDarkness and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local my = inp.Position.Y
                        local dy = darknessBar.AbsolutePosition.Y
                        local dh = darknessBar.AbsoluteSize.Y
                        local val = 1 - math.clamp((my - dy) / dh, 0, 1)
                        local h, s = selectedColor:ToHSV()
                        selectedColor = Color3.fromHSV(h, s, val)
                        updateColor()
                    end
                end)

                rainbowToggle.MouseButton1Click:Connect(function()
                    rainbow = not rainbow
                    rainbowToggle.Text = "Rainbow: " .. (rainbow and "On" or "Off")
                    if rainbow then
                        spawn(function()
                            while rainbow and wait() do
                                selectedColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)
                                updateColor()
                            end
                        end)
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        colorPickerElement.BackgroundColor3 = themeList.ElementColor
                        cpName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        colorFrame.BackgroundColor3 = themeList.ElementColor
                        rainbowToggle.BackgroundColor3 = themeList.SchemeColor
                        rainbowToggle.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
            end

            function Elements:NewLabel(lname)
                lname = lname or "Label"

                local labelElement = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")

                labelElement.Name = "labelElement"
                labelElement.Parent = sectionInners
                labelElement.BackgroundColor3 = themeList.ElementColor
                labelElement.Size = UDim2.new(0, 352, 0, 33)
                labelElement.Font = Enum.Font.GothamSemibold
                labelElement.Text = lname
                labelElement.TextColor3 = themeList.TextColor
                labelElement.TextSize = 14.000
                labelElement.TextXAlignment = Enum.TextXAlignment.Left
                labelElement.TextTransparency = 0

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = labelElement

                updateSectionFrame()
                UpdateSize()

                coroutine.wrap(function()
                    while wait() do
                        labelElement.BackgroundColor3 = themeList.ElementColor
                        labelElement.TextColor3 = themeList.TextColor
                    end
                end)()

                local LabelFunction = {}
                function LabelFunction:UpdateLabel(newText)
                    labelElement.Text = newText
                end
                return LabelFunction
            end

            return Elements
        end
        return Sections
    end
    return Tabs
end

return Kry
