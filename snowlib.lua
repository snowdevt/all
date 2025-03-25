local SnowLib = {}
SnowLib.__index = SnowLib

-- Window creation
function SnowLib:Window(title)
    local Window = setmetatable({}, SnowLib)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "SnowLibGui"
    
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = UDim2.new(0, 300, 0, 400)
    Window.MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    Window.MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = ScreenGui
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    TitleBar.Parent = Window.MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "SnowLib"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.Text = "-"
    MinimizeButton.Parent = TitleBar
    
    Window.Content = Instance.new("Frame")
    Window.Content.Size = UDim2.new(1, 0, 1, -30)
    Window.Content.Position = UDim2.new(0, 0, 0, 30)
    Window.Content.BackgroundTransparency = 1
    Window.Content.Parent = Window.MainFrame
    
    -- Dragging functionality
    local dragging, dragInput, startPos, startDrag
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startDrag = input.Position
            startPos = Window.MainFrame.Position
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startDrag
            Window.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Minimize functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        Window.Content.Visible = not minimized
        Window.MainFrame.Size = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 400)
    end)
    
    -- Close functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    Window.Tabs = {}
    return Window
end

-- Tab creation
function SnowLib:AddTab(tabName)
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(0.9, 0, 1, -10)
    TabFrame.Position = UDim2.new(0.05, 0, 0, 5)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Parent = self.Content
    TabFrame.Visible = false
    
    self.Tabs[tabName] = TabFrame
    return TabFrame
end

-- Button creation
function SnowLib:AddButton(tabName, text, callback)
    if not self.Tabs[tabName] then
        self:AddTab(tabName)
    end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.Position = UDim2.new(0.05, 0, 0, #self.Tabs[tabName]:GetChildren() * 35)
    Button.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    Button.Text = text
    Button.Parent = self.Tabs[tabName]
    
    Button.MouseButton1Click:Connect(callback or function() end)
    return Button
end

-- Slider creation
function SnowLib:AddSlider(tabName, text, min, max, callback)
    if not self.Tabs[tabName] then
        self:AddTab(tabName)
    end
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    SliderFrame.Position = UDim2.new(0.05, 0, 0, #self.Tabs[tabName]:GetChildren() * 55)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = self.Tabs[tabName]
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame
    
    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(1, 0, 0, 10)
    Slider.Position = UDim2.new(0, 0, 0, 25)
    Slider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Slider.Text = ""
    Slider.Parent = SliderFrame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0.5, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Fill.Parent = Slider
    
    local value = min + (max - min) / 2
    local dragging = false
    
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(relativeX, 0, 1, 0)
            value = min + (max - min) * relativeX
            if callback then callback(value) end
        end
    end)
    
    return SliderFrame
end

return SnowLib
