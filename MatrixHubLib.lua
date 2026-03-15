-- ============================================================
--  MatrixHub UI Library  v5  |  loadstring-совместимая библиотека
--  Использование:
--    local MatrixHub = loadstring(game:HttpGet("URL_К_ЭТОМУ_ФАЙЛУ"))()
--    local W = MatrixHub.new()
-- ============================================================

local MatrixHub = {}
MatrixHub.__index = MatrixHub

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- ============================================================
--  ЦВЕТА
-- ============================================================
local C = {
    WinBG       = Color3.fromRGB(15, 21, 35),
    HeaderBG    = Color3.fromRGB(19, 27, 42),
    TabBarBG    = Color3.fromRGB(19, 27, 42),
    RowBG       = Color3.fromRGB(22, 31, 48),
    RowHover    = Color3.fromRGB(28, 40, 60),
    Border      = Color3.fromRGB(30, 45, 69),
    TextMain    = Color3.fromRGB(200, 216, 236),
    TextMuted   = Color3.fromRGB(106, 133, 168),
    Accent      = Color3.fromRGB(30, 144, 255),
    AccentHover = Color3.fromRGB(26, 125, 224),
    KbtnBG      = Color3.fromRGB(24, 34, 52),
    KbtnBorder  = Color3.fromRGB(37, 53, 80),
    TogOff      = Color3.fromRGB(37, 53, 80),
    TogOn       = Color3.fromRGB(30, 144, 255),
    Knob        = Color3.fromRGB(255, 255, 255),
    NumBG       = Color3.fromRGB(24, 34, 52),
    SliderTrack = Color3.fromRGB(30, 45, 69),
    SliderFill  = Color3.fromRGB(30, 144, 255),
    TabActive   = Color3.fromRGB(221, 230, 245),
    TabInactive = Color3.fromRGB(106, 133, 168),
    ActiveLine  = Color3.fromRGB(30, 144, 255),
    TabGlow     = Color3.fromRGB(30, 144, 255),
}

-- ============================================================
--  УТИЛИТЫ UI
-- ============================================================
local function New(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end
local function Corner(r,p) New("UICorner",{CornerRadius=UDim.new(0,r)},p) end
local function Stroke(c,t,p) New("UIStroke",{Color=c,Thickness=t},p) end
local function Tween(o,props,t,style)
    TweenService:Create(o,TweenInfo.new(t or 0.15,style or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

local function Draggable(frame, handle)
    local drag,start,spos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; start=i.Position; spos=frame.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    local last
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then last=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==last and drag then
            local d=i.Position-start
            frame.Position=UDim2.new(spos.X.Scale,spos.X.Offset+d.X,spos.Y.Scale,spos.Y.Offset+d.Y)
        end
    end)
end

-- ============================================================
--  КНОПКА КЕЙБИНДА
--  Поддерживает: Keyboard, MB1, MB2, MB3, Forward (MB4), Back (MB5)
-- ============================================================
local function MakeKeybindBtn(parent, offX)
    local wrap = New("Frame",{
        Size=UDim2.new(0,42,0,22),
        Position=UDim2.new(1,offX,0.5,-11),
        BackgroundColor3=C.KbtnBG,
        BorderSizePixel=0,
    },parent)
    Corner(5,wrap); Stroke(C.KbtnBorder,1,wrap)

    local keyTxt = New("TextLabel",{
        Text="None",
        Font=Enum.Font.GothamBold,
        TextSize=10,
        TextColor3=C.TextMuted,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Center,
    },wrap)

    local click = New("TextButton",{
        Text="",BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),ZIndex=6,
    },wrap)

    return wrap, nil, keyTxt, click
end

-- Определение имени клавиши/кнопки мыши для отображения в кейбинде
local function GetInputName(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        local n = tostring(inp.KeyCode):sub(14)
        return (#n<=3 and n or n:sub(1,3)), inp.KeyCode
    elseif inp.UserInputType == Enum.UserInputType.MouseButton1 then
        return "MB1", "MB1"
    elseif inp.UserInputType == Enum.UserInputType.MouseButton2 then
        return "MB2", "MB2"
    elseif inp.UserInputType == Enum.UserInputType.MouseButton3 then
        return "MB3", "MB3"
    elseif inp.UserInputType == Enum.UserInputType.MouseButton4 then
        -- Forward кнопка мыши
        return "FWD", "MB4"
    elseif inp.UserInputType == Enum.UserInputType.MouseButton5 then
        -- Back кнопка мыши
        return "BCK", "MB5"
    end
    return nil, nil
end

-- Проверка нажата ли клавиша/кнопка мыши по сохранённому ключу
local function IsKeyActive(key)
    if not key then return false end
    if key == "MB1" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    elseif key == "MB2" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif key == "MB3" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
    elseif key == "MB4" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton4)
    elseif key == "MB5" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton5)
    else return UserInputService:IsKeyDown(key) end
end

-- Совпадение события InputBegan с сохранённым ключом
local function InputMatchesKey(inp, key)
    if not key then return false end
    if key == "MB1" then return inp.UserInputType == Enum.UserInputType.MouseButton1
    elseif key == "MB2" then return inp.UserInputType == Enum.UserInputType.MouseButton2
    elseif key == "MB3" then return inp.UserInputType == Enum.UserInputType.MouseButton3
    elseif key == "MB4" then return inp.UserInputType == Enum.UserInputType.MouseButton4
    elseif key == "MB5" then return inp.UserInputType == Enum.UserInputType.MouseButton5
    else return inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key end
end

-- ============================================================
--  КОЛОРПИКЕР
-- ============================================================
local _cpWin    = nil
local _cpActive = nil

UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        if _cpActive and _cpActive.Parent then
            local ap = _cpActive.AbsolutePosition
            local as = _cpActive.AbsoluteSize
            local mp = UserInputService:GetMouseLocation()
            if mp.X < ap.X or mp.X > ap.X+as.X or mp.Y < ap.Y or mp.Y > ap.Y+as.Y then
                pcall(function() _cpActive:Destroy() end)
                _cpActive = nil
            end
        end
    end
end)

local function MakeColorPicker(parent, offX, initColor, onChange)
    local color = initColor or Color3.fromRGB(0,255,0)
    local hue, sat, val2 = Color3.toHSV(color)

    local box = New("Frame",{
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(1,offX,0.5,-9),
        BackgroundColor3=color, BorderSizePixel=0, ZIndex=4,
    },parent)
    Corner(4,box); Stroke(C.KbtnBorder,1,box)

    local popup = nil
    local open  = false

    local function applyHSV()
        local c = Color3.fromHSV(hue,sat,val2)
        color=c; box.BackgroundColor3=c
        if onChange then onChange(c) end
        return c
    end

    local clickBtn = New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=7},box)

    clickBtn.MouseButton1Click:Connect(function()
        if open then
            if popup then popup:Destroy(); popup=nil end
            _cpActive=nil; open=false; return
        end
        if _cpActive and _cpActive ~= popup then
            pcall(function() _cpActive:Destroy() end); _cpActive=nil
        end
        if not _cpWin then return end
        open=true

        local winAbs  = _cpWin.AbsolutePosition
        local boxAbs  = box.AbsolutePosition
        local boxSize = box.AbsoluteSize
        local px = boxAbs.X - winAbs.X
        local py = boxAbs.Y - winAbs.Y + boxSize.Y + 4
        local popW, popH = 225, 205
        if px+popW > _cpWin.AbsoluteSize.X-4 then px=_cpWin.AbsoluteSize.X-popW-4 end
        if py+popH > _cpWin.AbsoluteSize.Y-4 then py=boxAbs.Y-winAbs.Y-popH-4 end

        popup = New("Frame",{
            Size=UDim2.new(0,popW,0,popH),
            Position=UDim2.new(0,px,0,py),
            BackgroundColor3=Color3.fromRGB(18,26,40),
            BorderSizePixel=0, ZIndex=100,
        },_cpWin)
        Corner(8,popup); Stroke(C.Border,1.5,popup)
        _cpActive = popup

        local outsideBtn = New("TextButton",{
            Text="",BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),
            Position=UDim2.new(0,0,0,0),ZIndex=99,
        },_cpWin)
        outsideBtn.MouseButton1Click:Connect(function()
            if popup and popup.Parent then popup:Destroy(); popup=nil end
            outsideBtn:Destroy(); _cpActive=nil; open=false
        end)
        New("TextLabel",{Text="Pick a color:",Font=Enum.Font.GothamBold,TextSize=12,
            TextColor3=C.TextMain,BackgroundTransparency=1,
            Size=UDim2.new(1,-8,0,18),Position=UDim2.new(0,8,0,4),
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101},popup)

        local svW,svH = 148,120
        local svFrame = New("Frame",{
            Size=UDim2.new(0,svW,0,svH),Position=UDim2.new(0,8,0,26),
            BackgroundColor3=Color3.fromHSV(hue,1,1),BorderSizePixel=0,ZIndex=101,
        },popup)
        Corner(4,svFrame)
        New("UIGradient",{
            Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))}),
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=0,
        },svFrame)
        local svDark=New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=102},svFrame)
        Corner(4,svDark)
        New("UIGradient",{
            Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}),
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),
            Rotation=90,
        },svDark)
        local svCursor=New("Frame",{
            Size=UDim2.new(0,10,0,10),Position=UDim2.new(sat,-5,1-val2,-5),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=105,
        },svFrame)
        Corner(5,svCursor); Stroke(Color3.new(0,0,0),1.5,svCursor)

        local hueFrame=New("Frame",{
            Size=UDim2.new(0,14,0,svH),Position=UDim2.new(0,svW+14,0,26),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=101,
        },popup)
        Corner(4,hueFrame)
        New("UIGradient",{
            Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,1,1)),
                ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
                ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),
                ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,1,1)),
                ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),
                ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
                ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
            }),Rotation=90,
        },hueFrame)
        local hueCursor=New("Frame",{
            Size=UDim2.new(1,4,0,3),Position=UDim2.new(0,-2,hue,-1),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=105,
        },hueFrame)
        Stroke(Color3.new(0,0,0),1,hueCursor)

        local preview=New("Frame",{
            Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,svW+14,0,svH+32),
            BackgroundColor3=color,BorderSizePixel=0,ZIndex=101,
        },popup)
        Corner(3,preview); Stroke(C.Border,1,preview)

        local function toHex(c) return string.format("#%02X%02X%02X",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)) end
        local function fmtRGB(c) return string.format("R:%-3d G:%-3d B:%-3d",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)) end

        local hexBg=New("Frame",{Size=UDim2.new(0,svW-2,0,18),Position=UDim2.new(0,8,0,svH+32),
            BackgroundColor3=Color3.fromRGB(24,34,52),BorderSizePixel=0,ZIndex=101},popup)
        Corner(4,hexBg); Stroke(C.KbtnBorder,1,hexBg)
        local hexLbl=New("TextLabel",{Text=toHex(color),Font=Enum.Font.GothamBold,TextSize=10,
            TextColor3=C.TextMain,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=102},hexBg)

        local rgbLbl=New("TextLabel",{Text=fmtRGB(color),Font=Enum.Font.GothamBold,TextSize=9,
            TextColor3=C.TextMuted,BackgroundTransparency=1,
            Size=UDim2.new(0,svW,0,14),Position=UDim2.new(0,8,0,svH+54),ZIndex=101},popup)

        local function updateUI()
            local c=applyHSV()
            svFrame.BackgroundColor3=Color3.fromHSV(hue,1,1)
            svCursor.Position=UDim2.new(sat,-5,1-val2,-5)
            hueCursor.Position=UDim2.new(0,-2,hue,-1)
            preview.BackgroundColor3=c
            hexLbl.Text=toHex(c); rgbLbl.Text=fmtRGB(c)
        end

        local svDrag=false
        local svBtn=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=106},svFrame)
        local function doSV(i)
            local a=svFrame.AbsolutePosition; local s=svFrame.AbsoluteSize
            sat=math.clamp((i.Position.X-a.X)/s.X,0,1)
            val2=math.clamp(1-(i.Position.Y-a.Y)/s.Y,0,1)
            updateUI()
        end
        svBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then svDrag=true;doSV(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then svDrag=false end end)
        UserInputService.InputChanged:Connect(function(i) if svDrag and i.UserInputType==Enum.UserInputType.MouseMovement then doSV(i) end end)

        local hueDrag=false
        local hueBtn=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=106},hueFrame)
        local function doHue(i)
            local a=hueFrame.AbsolutePosition; local s=hueFrame.AbsoluteSize
            hue=math.clamp((i.Position.Y-a.Y)/s.Y,0,0.9999)
            updateUI()
        end
        hueBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDrag=true;doHue(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDrag=false end end)
        UserInputService.InputChanged:Connect(function(i) if hueDrag and i.UserInputType==Enum.UserInputType.MouseMovement then doHue(i) end end)
    end)

    return box
end

-- ============================================================
--  ОКНО
-- ============================================================
function MatrixHub.new()
    local self = setmetatable({},MatrixHub)
    self.Tabs={}; self.ActiveTab=nil; self.Visible=true

    local Gui = New("ScreenGui",{Name="MatrixHubUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},
        game:GetService("CoreGui") or LocalPlayer:FindFirstChildOfClass("PlayerGui"))

    local Win = New("Frame",{Size=UDim2.new(0,692,0,600),Position=UDim2.new(0.5,-346,0.5,-300),
        BackgroundColor3=C.WinBG,BorderSizePixel=0,ClipsDescendants=false},Gui)
    Corner(12,Win); Stroke(C.Border,1.5,Win)
    self.Gui=Gui; self.Win=Win
    _cpWin=Win

    local Header=New("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=C.HeaderBG,BorderSizePixel=0},Win)
    Corner(12,Header)

    local logoLbl=New("TextLabel",{Text="MatrixHub",Font=Enum.Font.GothamBlack,TextSize=22,
        TextColor3=Color3.new(1,1,1),BackgroundTransparency=1,Size=UDim2.new(0,200,1,0),
        Position=UDim2.new(0,16,0,0),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},Header)
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(221,230,245)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(30,144,255)),
    }),Rotation=0},logoLbl)

    local function HBtn(icon,offX)
        local b=New("TextButton",{Text=icon,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.TextMuted,
            BackgroundColor3=C.KbtnBG,Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,offX,0,17),
            BorderSizePixel=0,AutoButtonColor=false},Header)
        Corner(6,b); Stroke(C.KbtnBorder,1,b)
        b.MouseEnter:Connect(function() Tween(b,{TextColor3=C.Accent,BackgroundColor3=C.KbtnBorder},0.1) end)
        b.MouseLeave:Connect(function() Tween(b,{TextColor3=C.TextMuted,BackgroundColor3=C.KbtnBG},0.1) end)
        return b
    end
    HBtn("⚙",-44); HBtn("✦",-80)
    Draggable(Win,Header)

    local TabBar=New("Frame",{Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,0,50),
        BackgroundColor3=C.TabBarBG,BorderSizePixel=0},Win)
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,0)},TabBar)

    local ContentWrap=New("Frame",{Size=UDim2.new(1,0,1,-90),Position=UDim2.new(0,0,0,90),BackgroundTransparency=1},Win)
    local ContentL=New("Frame",{Size=UDim2.new(0.5,-1,1,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,ClipsDescendants=true},ContentWrap)
    local ContentR=New("Frame",{Size=UDim2.new(0.5,-1,1,0),Position=UDim2.new(0.5,1,0,0),BackgroundTransparency=1,ClipsDescendants=true},ContentWrap)

    self.TabBar=TabBar; self.ContentL=ContentL; self.ContentR=ContentR
    return self
end

-- ============================================================
--  ВКЛАДКА
-- ============================================================
function MatrixHub:AddTab(name)
    local idx=#self.Tabs+1
    local TabBtn=New("TextButton",{Text=name,Font=Enum.Font.GothamBlack,TextSize=13,
        TextColor3=C.TabInactive,BackgroundColor3=C.TabBarBG,Size=UDim2.new(0.2,0,1,0),
        BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=idx,ClipsDescendants=true},self.TabBar)

    local GlowFrame=New("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0.5,0,1,0),
        AnchorPoint=Vector2.new(0.5,1),BackgroundColor3=C.TabGlow,BackgroundTransparency=1,
        BorderSizePixel=0,ZIndex=1},TabBtn)
    New("UIGradient",{
        Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))}),
        Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(0.5,0.7),NumberSequenceKeypoint.new(1,1)}),
        Rotation=270,
    },GlowFrame)

    local Line=New("Frame",{Size=UDim2.new(0,0,0,2),Position=UDim2.new(0.5,0,1,-2),
        AnchorPoint=Vector2.new(0.5,0),BackgroundColor3=C.ActiveLine,BorderSizePixel=0,ZIndex=3},TabBtn)
    Corner(1,Line)

    local function MakeScroll(parent)
        local s=New("ScrollingFrame",{Name="Tab_"..name,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.4,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},parent)
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)},s)
        New("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},s)
        return s
    end
    local ScrollL=MakeScroll(self.ContentL); local ScrollR=MakeScroll(self.ContentR)
    local Tab={Name=name,Btn=TabBtn,Line=Line,GlowFrame=GlowFrame,Scroll=ScrollL,ScrollL=ScrollL,ScrollR=ScrollR,_n=0,_nL=0,_nR=0,fullWidth=false}
    table.insert(self.Tabs,Tab)
    TabBtn.MouseButton1Click:Connect(function() self:_Activate(Tab) end)
    TabBtn.MouseEnter:Connect(function() if self.ActiveTab~=Tab then Tween(TabBtn,{TextColor3=C.TextMain},0.1) end end)
    TabBtn.MouseLeave:Connect(function() if self.ActiveTab~=Tab then Tween(TabBtn,{TextColor3=C.TabInactive},0.1) end end)
    if idx==1 then self:_Activate(Tab) end
    return Tab
end

function MatrixHub:_Activate(tab)
    for _,t in ipairs(self.Tabs) do
        t.ScrollL.Visible=false; t.ScrollR.Visible=false
        Tween(t.Btn,{TextColor3=C.TabInactive},0.12)
        Tween(t.Line,{Size=UDim2.new(0,0,0,2)},0.12)
        Tween(t.GlowFrame,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0)},0.18)
    end
    tab.ScrollL.Visible=true
    if tab.fullWidth then
        self.ContentL.Size=UDim2.new(1,0,1,0); self.ContentR.Visible=false; tab.ScrollR.Visible=false
    else
        self.ContentL.Size=UDim2.new(0.5,-1,1,0); self.ContentR.Visible=true; tab.ScrollR.Visible=true
    end
    Tween(tab.Btn,{TextColor3=C.TabActive},0.12)
    Tween(tab.Line,{Size=UDim2.new(1,0,0,2)},0.18,Enum.EasingStyle.Back)
    Tween(tab.GlowFrame,{BackgroundTransparency=0.72,Size=UDim2.new(1,0,0,28)},0.22)
    self.ActiveTab=tab
end

-- ============================================================
--  СТРОКА
-- ============================================================
local function MakeRow(tab,h,col)
    local isR=(col=="R"); local scroll=isR and tab.ScrollR or tab.ScrollL
    local nk=isR and "_nR" or "_nL"; tab[nk]=tab[nk]+1
    local wrap=New("Frame",{Size=UDim2.new(1,0,0,h or 40),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=tab[nk]},scroll)
    local card=New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.RowBG,BorderSizePixel=0},wrap)
    Corner(7,card)
    card.MouseEnter:Connect(function() Tween(card,{BackgroundColor3=C.RowHover},0.08) end)
    card.MouseLeave:Connect(function() Tween(card,{BackgroundColor3=C.RowBG},0.08) end)
    return card
end

local function Label(r,text,w)
    New("TextLabel",{Text=text,Font=Enum.Font.GothamBlack,TextSize=13,TextColor3=C.TextMain,
        BackgroundTransparency=1,Size=UDim2.new(0,w or 145,1,0),
        Position=UDim2.new(0,12,0,0),TextXAlignment=Enum.TextXAlignment.Left},r)
end

local function MakeToggle(parent,state,offX)
    local bg=New("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,offX,0.5,-10),
        BackgroundColor3=state and C.TogOn or C.TogOff,BorderSizePixel=0},parent)
    Corner(10,bg); Stroke(C.Border,1,bg)
    local knob=New("Frame",{Size=UDim2.new(0,14,0,14),
        Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3=C.Knob,BorderSizePixel=0,ZIndex=2},bg)
    Corner(7,knob); return bg,knob
end

-- ============================================================
--  TOGGLE
-- ============================================================
function MatrixHub:AddToggle(tab,label,default,cb,col)
    local r=MakeRow(tab,nil,col); local state=default or false
    Label(r,label)
    local bg,knob=MakeToggle(r,state,-48)
    local click=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=3},r)
    click.MouseButton1Click:Connect(function()
        state=not state
        Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18)
        Tween(knob,{Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.18,Enum.EasingStyle.Back)
        if cb then cb(state) end
    end)
    return {Get=function() return state end}
end

-- ============================================================
--  KEYBIND TOGGLE
--  Поддержка: Keyboard, MB1-MB5 (Forward/Back мышь)
-- ============================================================
function MatrixHub:AddKeybindToggle(tab,label,default,cb,col,initColor,onColorChange)
    local r=MakeRow(tab,nil,col); local state=default or false
    local binding=false; local boundKey=nil
    Label(r,label)

    if initColor then
        MakeColorPicker(r,-118,initColor,onColorChange)
    end

    local kbWrap,kbIcon,kbTxt,kbClick=MakeKeybindBtn(r,-90)
    local bg,knob=MakeToggle(r,state,-48)

    local function DoToggle()
        state=not state
        Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18)
        Tween(knob,{Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.18,Enum.EasingStyle.Back)
        if cb then cb(state) end
    end

    kbClick.MouseButton1Click:Connect(function()
        if binding then return end
        binding=true; kbTxt.Text="..."; kbTxt.TextColor3=C.TextMuted
        Stroke(C.Accent,1,kbWrap)
        local conn; conn=UserInputService.InputBegan:Connect(function(inp)
            local name,key = GetInputName(inp)
            if not name then return end
            kbTxt.Text=name; kbTxt.TextColor3=C.Accent
            boundKey=key; binding=false; conn:Disconnect()
            for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
        end)
    end)

    local togClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=4},bg)
    togClick.MouseButton1Click:Connect(function() if not binding then DoToggle() end end)

    UserInputService.InputBegan:Connect(function(inp)
        if binding then return end
        if InputMatchesKey(inp,boundKey) then DoToggle() end
    end)

    return {Get=function() return state end}
end

-- ============================================================
--  KEYBIND с режимами Toggle / Hold / Always
--  Поддержка: Keyboard, MB1-MB5 (Forward/Back мышь)
-- ============================================================
function MatrixHub:AddKeybind(tab,label,default,cb,col)
    local r=MakeRow(tab,nil,col); local state=default or false
    local binding=false; local boundKey=nil
    local modes={"Toggle","Hold","Always"}; local modeIdx=1
    Label(r,label)

    local modeBg=New("Frame",{Size=UDim2.new(0,52,0,20),Position=UDim2.new(1,-150,0.5,-10),
        BackgroundColor3=C.KbtnBG,BorderSizePixel=0},r)
    Corner(5,modeBg); Stroke(C.KbtnBorder,1,modeBg)
    local modeLbl=New("TextLabel",{Text=modes[modeIdx],Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=C.Accent,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},modeBg)
    local modeClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=5},modeBg)

    local kbWrap,kbIcon,kbTxt,kbClick=MakeKeybindBtn(r,-90)
    local bg,knob=MakeToggle(r,state,-48)

    local function SetState(v)
        state=v
        Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18)
        Tween(knob,{Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.18,Enum.EasingStyle.Back)
        if cb then cb(state) end
    end

    modeClick.MouseButton1Click:Connect(function()
        modeIdx=modeIdx%#modes+1; modeLbl.Text=modes[modeIdx]
        if modes[modeIdx]=="Always" then SetState(true) else SetState(false) end
    end)

    local togClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=4},bg)
    togClick.MouseButton1Click:Connect(function()
        if modes[modeIdx]=="Always" then return end
        if modes[modeIdx]=="Toggle" then SetState(not state) end
    end)

    kbClick.MouseButton1Click:Connect(function()
        if binding then return end
        binding=true; kbTxt.Text="..."; kbTxt.TextColor3=C.TextMuted
        Stroke(C.Accent,1,kbWrap)
        local conn; conn=UserInputService.InputBegan:Connect(function(inp)
            local name,key = GetInputName(inp)
            if not name then return end
            kbTxt.Text=name; kbTxt.TextColor3=C.Accent
            boundKey=key; binding=false; conn:Disconnect()
            for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
        end)
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if binding then return end
        if not InputMatchesKey(inp,boundKey) then return end
        if modes[modeIdx]=="Toggle" then SetState(not state)
        elseif modes[modeIdx]=="Hold" then SetState(true) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if binding then return end
        if not InputMatchesKey(inp,boundKey) then return end
        if modes[modeIdx]=="Hold" then SetState(false) end
    end)

    return {Get=function() return state end, GetMode=function() return modes[modeIdx] end}
end

-- ============================================================
--  DROPDOWN
-- ============================================================
function MatrixHub:AddDropdown(tab,label,options,default,cb,col)
    local r=MakeRow(tab,nil,col); local idx=1
    for i,v in ipairs(options) do if v==default then idx=i; break end end
    Label(r,label)
    local valLbl=New("TextLabel",{Text=tostring(options[idx]),Font=Enum.Font.GothamBold,TextSize=12,
        TextColor3=C.TextMuted,BackgroundTransparency=1,Size=UDim2.new(0,70,1,0),
        Position=UDim2.new(1,-78,0,0),TextXAlignment=Enum.TextXAlignment.Right},r)
    New("TextLabel",{Text="▾",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.TextMuted,
        BackgroundTransparency=1,Size=UDim2.new(0,16,1,0),Position=UDim2.new(1,-18,0,0)},r)
    local click=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},r)
    click.MouseButton1Click:Connect(function()
        idx=idx%#options+1; valLbl.Text=tostring(options[idx])
        if cb then cb(options[idx]) end
    end)
    return {Get=function() return options[idx] end}
end

-- ============================================================
--  SLIDER
-- ============================================================
function MatrixHub:AddSlider(tab,label,min,max,default,cb,col)
    local r=MakeRow(tab,40,col); local val=default or min; local dragging=false
    Label(r,label)
    local numBG=New("Frame",{Size=UDim2.new(0,34,0,24),Position=UDim2.new(1,-126,0.5,-12),BackgroundColor3=C.NumBG,BorderSizePixel=0},r)
    Corner(5,numBG); Stroke(C.KbtnBorder,1,numBG)
    local numLbl=New("TextLabel",{Text=tostring(val),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=C.TextMain,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},numBG)
    local function MkBtn(sym,offX)
        local b=New("TextButton",{Text=sym,Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.new(1,1,1),
            BackgroundColor3=C.Accent,Size=UDim2.new(0,26,0,24),Position=UDim2.new(1,offX,0.5,-12),
            BorderSizePixel=0,AutoButtonColor=false},r)
        Corner(5,b)
        b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=C.AccentHover},0.1) end)
        b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=C.Accent},0.1) end)
        return b
    end
    local minusBtn=MkBtn("−",-68); local plusBtn=MkBtn("+",-34)
    local sr=MakeRow(tab,26,col)
    local track=New("Frame",{Size=UDim2.new(1,-20,0,6),Position=UDim2.new(0,10,0.5,-3),BackgroundColor3=C.SliderTrack,BorderSizePixel=0},sr)
    Corner(3,track)
    local pct=(val-min)/(max-min)
    local fill=New("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=C.SliderFill,BorderSizePixel=0},track); Corner(3,fill)
    local thumb=New("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(pct,-6,0.5,-6),BackgroundColor3=C.SliderFill,BorderSizePixel=0,ZIndex=2},track); Corner(6,thumb)
    local function Set(v)
        v=math.clamp(math.round(v),min,max); val=v; numLbl.Text=tostring(v)
        local p=(v-min)/(max-min)
        Tween(fill,{Size=UDim2.new(p,0,1,0)},0.08); Tween(thumb,{Position=UDim2.new(p,-6,0.5,-6)},0.08)
        if cb then cb(v) end
    end
    minusBtn.MouseButton1Click:Connect(function() Set(val-1) end)
    plusBtn.MouseButton1Click:Connect(function() Set(val+1) end)
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            Set(min+math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min))
        end
    end)
    return {Get=function() return val end, Set=Set}
end

-- ============================================================
--  LABEL / SEPARATOR
-- ============================================================
function MatrixHub:AddLabel(tab,text,col)
    local r=MakeRow(tab,34,col)
    New("TextLabel",{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.TextMuted,
        BackgroundTransparency=1,Size=UDim2.new(1,-24,1,0),Position=UDim2.new(0,12,0,0),
        TextXAlignment=Enum.TextXAlignment.Left},r)
end

function MatrixHub:AddSeparator(tab,title,col)
    local isR=(col=="R"); local scroll=isR and tab.ScrollR or tab.ScrollL
    local nk=isR and "_nR" or "_nL"; tab[nk]=tab[nk]+1
    local sep=New("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=tab[nk]},scroll)
    New("Frame",{Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,0.5,0),BackgroundColor3=C.Border,BorderSizePixel=0},sep)
    if title and title~="" then
        local bg=New("Frame",{Size=UDim2.new(0,#title*7+12,0,16),Position=UDim2.new(0,14,0.5,-8),BackgroundColor3=C.WinBG,BorderSizePixel=0},sep)
        New("TextLabel",{Text=title,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=C.Accent,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},bg)
    end
end

-- ============================================================
--  КНОПКА КЕЙБИНДА ДЛЯ AIMBOT (расширенная версия)
--  Поддерживает: Keyboard, MB1-MB5 (Forward/Back)
-- ============================================================
function MatrixHub:MakeKeyBind(parent, offX, w, onSet)
    local kf=New("Frame",{Size=UDim2.new(0,w or 72,0,24),Position=UDim2.new(1,offX,0.5,-12),
        BackgroundColor3=C.KbtnBG,BorderSizePixel=0,ZIndex=3},parent)
    Corner(5,kf); Stroke(C.KbtnBorder,1,kf)
    local kt=New("TextLabel",{Text="None",Font=Enum.Font.GothamBold,TextSize=11,
        TextColor3=C.TextMuted,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=4},kf)
    local kb=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=5},kf)
    local binding=false
    kb.MouseButton1Click:Connect(function()
        if binding then return end; binding=true; kt.Text="..."; kt.TextColor3=C.TextMuted
        Stroke(C.Accent,1,kf)
        local conn; conn=UserInputService.InputBegan:Connect(function(inp)
            local name,key = GetInputName(inp)
            if not name then return end
            kt.Text=name; kt.TextColor3=C.Accent; binding=false; conn:Disconnect()
            for _,s in ipairs(kf:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
            if onSet then onSet(key) end
        end)
    end)
    return kf
end

-- ============================================================
--  ВКЛЮЧЕНИЕ КЛАВИШИ ПЕРЕКЛЮЧЕНИЯ ОКНА
--  Поддержка: Keyboard, MB4 (Forward), MB5 (Back)
-- ============================================================
function MatrixHub:EnableToggleKey(key)
    key = key or Enum.KeyCode.Insert
    UserInputService.InputBegan:Connect(function(i)
        local match = false
        if type(key) == "string" then
            -- Forward/Back мышь
            if key=="MB4" and i.UserInputType==Enum.UserInputType.MouseButton4 then match=true
            elseif key=="MB5" and i.UserInputType==Enum.UserInputType.MouseButton5 then match=true end
        else
            if i.KeyCode == key then match=true end
        end
        if match then
            self.Visible=not self.Visible
            self.Win.Visible=self.Visible
        end
    end)
end

-- Экспортируем вспомогательные функции для использования в основном скрипте
MatrixHub._MakeRow       = MakeRow
MatrixHub._Label         = Label
MatrixHub._MakeColorPicker = MakeColorPicker
MatrixHub._IsKeyActive   = IsKeyActive
MatrixHub._InputMatchesKey = InputMatchesKey
MatrixHub._GetInputName  = GetInputName
MatrixHub._New           = New
MatrixHub._Corner        = Corner
MatrixHub._Stroke        = Stroke
MatrixHub._Tween         = Tween
MatrixHub._C             = C

return MatrixHub
