if getgenv and getgenv()._MATRIXHUB_LOADED then
pcall(function()
local old = game:GetService("CoreGui"):FindFirstChild(_sGUI);if old then old:Destroy() end;end);pcall(function()
local old = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui");if old then
local g = old:FindFirstChild(_sGUI);if g then g:Destroy() end
end;end);if getgenv()._MATRIXHUB_CONNECTIONS then
for _,c in pairs(getgenv()._MATRIXHUB_CONNECTIONS) do
pcall(function() c:Disconnect() end)
end
end;if getgenv()._MATRIXHUB_ESP then
for _,e in pairs(getgenv()._MATRIXHUB_ESP) do
for _,o in pairs(e) do
if type(o)=="table" then for _,l in pairs(o) do pcall(function() l:Remove() end) end
else pcall(function() o:Remove() end) end
end
end;getgenv()._MATRIXHUB_ESP = {}
end;local _UDim2=UDim2.new;local _Color3=Color3.fromRGB;local _C3=Color3.new;local _V2=Vector2.new;local _V3=Vector3.new;local _UDim=UDim.new;local _Inst=Instance.new;local _EUT=Enum.UserInputType;local _EKC=Enum.KeyCode;local _EES=Enum.EasingStyle;local _EED=Enum.EasingDirection
local _EFA=Enum.Font;local _ETX=Enum.TextXAlignment;local _sHRP="HumanoidRootPart";local _sHUM="Humanoid";local _sGUI=_sGUI;local function _getHRP() local c=LocalPlayer.Character; if not c then return nil end; return c:FindFirstChild(_sHRP) end;local _NSK=NumberSequenceKeypoint.new
local _CSK=ColorSequenceKeypoint.new;local _NS=NumberSequence.new;local _CS=ColorSequence.new;local _ESO=Enum.SortOrder;local _EFD=Enum.FillDirection;local _EAS=Enum.AutomaticSize;local _EZB=Enum.ZIndexBehavior;local _EHS=Enum.HumanoidStateType;local _BT1='BackgroundTransparency'
local _BS0='BorderSizePixel';local _ABC='AutoButtonColor';local _UIS=UserInputService;local _IUT='UserInputType';local _IUT='UserInputType'
end;if getgenv then
getgenv()._MATRIXHUB_LOADED = true;getgenv()._MATRIXHUB_CONNECTIONS = {};getgenv()._MATRIXHUB_ESP = {}
end;local MatrixHub = {};MatrixHub.__index = MatrixHub;local Players = game:GetService("Players");local TweenService = game:GetService("TweenService");local UserInputService = game:GetService("UserInputService");local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting");local LocalPlayer = Players.LocalPlayer;local Camera = workspace.CurrentCamera;local C = {
WinBG = _Color3(15, 21, 35),
HeaderBG = _Color3(19, 27, 42),
TabBarBG = _Color3(19, 27, 42),
RowBG = _Color3(22, 31, 48),
RowHover = _Color3(28, 40, 60),
Border = _Color3(30, 45, 69),
TextMain = _Color3(200, 216, 236),
TextMuted = _Color3(106, 133, 168),
Accent = _Color3(30, 144, 255),
AccentHover = _Color3(26, 125, 224),
KbtnBG = _Color3(24, 34, 52),
KbtnBorder = _Color3(37, 53, 80),
TogOff = _Color3(37, 53, 80),
TogOn = _Color3(30, 144, 255),
Knob = _Color3(255, 255, 255),
NumBG = _Color3(24, 34, 52),
SliderTrack = _Color3(30, 45, 69),
SliderFill = _Color3(30, 144, 255),
TabActive = _Color3(221, 230, 245),
TabInactive = _Color3(106, 133, 168),
ActiveLine = _Color3(30, 144, 255),
TabGlow = _Color3(30, 144, 255),
};local function New(class, props, parent)
local o = _Inst(class);for k,v in pairs(props) do o[k]=v end;if parent then o.Parent=parent end;return o
end;local function Corner(r,p) New("UICorner",{CornerRadius=_UDim(0,r)},p) end;local function Stroke(c,t,p) New("UIStroke",{Color=c,Thickness=t},p) end;local function Tween(o,props,t,style)
TweenService:Create(o,TweenInfo.new(t or 0.15,style or _EES.Quad,_EED.Out),props):Play()
end;local function Draggable(frame,handle)
local drag,start,spos=false;handle.InputBegan:Connect(function(i)
if i[_IUT]==_EUT.MouseButton1 then drag=true;start=i.Position;spos=frame.Position end;end);handle.InputEnded:Connect(function(i)
if i[_IUT]==_EUT.MouseButton1 then drag=false end;end);local last;handle.InputChanged:Connect(function(i) if i[_IUT]==_EUT.MouseMovement then last=i end end)
UserInputService.InputChanged:Connect(function(i)
if i==last and drag then
local d=i.Position-start;frame.Position=_UDim2(spos.X.Scale,spos.X.Offset+d.X,spos.Y.Scale,spos.Y.Offset+d.Y)
end;end)
end;local function MakeKbIcon(parent)
local btn=New("Frame",{Size=_UDim2(0,26,0,18),BackgroundColor3=C.KbtnBG,BorderSizePixel=0},parent);Corner(4,btn);Stroke(C.KbtnBorder,1,btn);for _,k in ipairs({{x=3,y=2},{x=7,y=2},{x=11,y=2},{x=15,y=2},{x=19,y=2},
{x=3,y=7},{x=7,y=7},{x=11,y=7},{x=15,y=7},{x=19,y=7},{x=6,y=12,w=13}}) do
New("Frame",{Size=_UDim2(0,k.w or 3,0,3),Position=_UDim2(0,k.x,0,k.y),BackgroundColor3=C.TextMuted,BorderSizePixel=0},btn)
end;return btn
end;local function MakeKeybindBtn(parent, offX)
local wrap = New("Frame",{
Size=_UDim2(0,42,0,22),
Position=_UDim2(1,offX,0.5,-11),
BackgroundColor3=C.KbtnBG,
BorderSizePixel=0,
},parent);Corner(5,wrap); Stroke(C.KbtnBorder,1,wrap);local keyTxt = New("TextLabel",{
Text="None",
Font=_EFA.GothamBold,
TextSize=10,
TextColor3=C.TextMuted,
BackgroundTransparency=1,
Size=_UDim2(1,0,1,0),
TextXAlignment=_ETX.Center,
},wrap);local click = New("TextButton",{
Text="",BackgroundTransparency=1,
Size=_UDim2(1,0,1,0),ZIndex=6,
},wrap);return wrap, nil, keyTxt, click
end;local _cpWin = nil;local _cpActive = nil;UserInputService.InputBegan:Connect(function(inp)
if inp[_IUT] == _EUT.MouseButton1 then
if _cpActive and _cpActive.Parent then
local ap = _cpActive.AbsolutePosition;local as = _cpActive.AbsoluteSize;local mp = UserInputService:GetMouseLocation();if mp.X < ap.X or mp.X > ap.X+as.X or mp.Y < ap.Y or mp.Y > ap.Y+as.Y then
pcall(function() _cpActive:Destroy() end)
_cpActive = nil
end
end
end;end);local function MakeColorPicker(parent, offX, initColor, onChange)
local color = initColor or _Color3(0,255,0);local hue, sat, val2 = Color3.toHSV(color);local box = New("Frame",{
Size=_UDim2(0,18,0,18), Position=_UDim2(1,offX,0.5,-9),
BackgroundColor3=color, BorderSizePixel=0, ZIndex=4,
},parent);Corner(4,box); Stroke(C.KbtnBorder,1,box);local popup = nil;local open = false;local function applyHSV()
local c = Color3.fromHSV(hue,sat,val2);color=c; box.BackgroundColor3=c;if onChange then onChange(c) end;return c
end;local clickBtn = New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=7},box);clickBtn.MouseButton1Click:Connect(function()
if open then
if popup then popup:Destroy(); popup=nil end;_cpActive = nil;open=false; return
end;if _cpActive and _cpActive ~= popup then
pcall(function() _cpActive:Destroy() end)
_cpActive = nil
end;if not _cpWin then return end;open=true;local winAbs = _cpWin.AbsolutePosition;local boxAbs = box.AbsolutePosition;local boxSize = box.AbsoluteSize;local px = boxAbs.X - winAbs.X;local py = boxAbs.Y - winAbs.Y + boxSize.Y + 4;local popW, popH = 225, 205
if px + popW > _cpWin.AbsoluteSize.X - 4 then px = _cpWin.AbsoluteSize.X - popW - 4 end;if py + popH > _cpWin.AbsoluteSize.Y - 4 then py = boxAbs.Y - winAbs.Y - popH - 4 end;popup = New("Frame",{
Size=_UDim2(0,popW,0,popH),
Position=_UDim2(0,px,0,py),
BackgroundColor3=_Color3(18,26,40),
BorderSizePixel=0, ZIndex=100,
},_cpWin);Corner(8,popup); Stroke(C.Border,1.5,popup);_cpActive = popup;local outsideBtn = New("TextButton",{
Text="",BackgroundTransparency=1,
Size=_UDim2(1,0,1,0),
Position=_UDim2(0,0,0,0),
ZIndex=99,
},_cpWin);outsideBtn.MouseButton1Click:Connect(function()
if popup and popup.Parent then popup:Destroy(); popup=nil end;outsideBtn:Destroy();_cpActive=nil; open=false;end);New("TextLabel",{Text="Pick a color:",Font=_EFA.GothamBold,TextSize=12,
TextColor3=C.TextMain,BackgroundTransparency=1,
Size=_UDim2(1,-8,0,18),Position=_UDim2(0,8,0,4),
TextXAlignment=_ETX.Left,ZIndex=101},popup);local svW,svH = 148,120;local svFrame = New("Frame",{
Size=_UDim2(0,svW,0,svH),
Position=_UDim2(0,8,0,26),
BackgroundColor3=Color3.fromHSV(hue,1,1),
BorderSizePixel=0, ZIndex=101,
},popup);Corner(4,svFrame);New("UIGradient",{
Color=_CS({_CSK(0,_C3(1,1,1)),_CSK(1,_C3(1,1,1))}),
Transparency=_NS({_NSK(0,0),_NSK(1,1)}),
Rotation=0,
},svFrame);local svDark = New("Frame",{Size=_UDim2(1,0,1,0),BackgroundColor3=_C3(0,0,0),BorderSizePixel=0,ZIndex=102},svFrame);Corner(4,svDark);New("UIGradient",{
Color=_CS({_CSK(0,_C3(0,0,0)),_CSK(1,_C3(0,0,0))}),
Transparency=_NS({_NSK(0,1),_NSK(1,0)}),
Rotation=90,
},svDark);local svCursor = New("Frame",{
Size=_UDim2(0,10,0,10),
Position=_UDim2(sat,-5,1-val2,-5),
BackgroundColor3=_C3(1,1,1),
BorderSizePixel=0,ZIndex=105,
},svFrame);Corner(5,svCursor); Stroke(_C3(0,0,0),1.5,svCursor);local hueFrame = New("Frame",{
Size=_UDim2(0,14,0,svH),
Position=_UDim2(0,svW+14,0,26),
BackgroundColor3=_C3(1,1,1),
BorderSizePixel=0,ZIndex=101,
},popup);Corner(4,hueFrame);New("UIGradient",{
Color=_CS({
_CSK(0, Color3.fromHSV(0,1,1)),
_CSK(0.167,Color3.fromHSV(0.167,1,1)),
_CSK(0.333,Color3.fromHSV(0.333,1,1)),
_CSK(0.5, Color3.fromHSV(0.5,1,1)),
_CSK(0.667,Color3.fromHSV(0.667,1,1)),
_CSK(0.833,Color3.fromHSV(0.833,1,1)),
_CSK(1, Color3.fromHSV(1,1,1)),
}),Rotation=90,
},hueFrame);local hueCursor = New("Frame",{
Size=_UDim2(1,4,0,3),Position=_UDim2(0,-2,hue,-1),
BackgroundColor3=_C3(1,1,1),BorderSizePixel=0,ZIndex=105,
},hueFrame);Stroke(_C3(0,0,0),1,hueCursor);local preview = New("Frame",{
Size=_UDim2(0,14,0,14),Position=_UDim2(0,svW+14,0,svH+32),
BackgroundColor3=color,BorderSizePixel=0,ZIndex=101,
},popup);Corner(3,preview); Stroke(C.Border,1,preview);local function toHex(c) return string.format("#%02X%02X%02X",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)) end
local function fmtRGB(c) return string.format("R:%-3d G:%-3d B:%-3d",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)) end;local hexBg=New("Frame",{Size=_UDim2(0,svW-2,0,18),Position=_UDim2(0,8,0,svH+32),
BackgroundColor3=_Color3(24,34,52),BorderSizePixel=0,ZIndex=101},popup);Corner(4,hexBg); Stroke(C.KbtnBorder,1,hexBg);local hexLbl=New("TextLabel",{Text=toHex(color),Font=_EFA.GothamBold,TextSize=10,
TextColor3=C.TextMain,BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=102},hexBg);local rgbLbl=New("TextLabel",{Text=fmtRGB(color),Font=_EFA.GothamBold,TextSize=9,
TextColor3=C.TextMuted,BackgroundTransparency=1,
Size=_UDim2(0,svW,0,14),Position=_UDim2(0,8,0,svH+54),ZIndex=101},popup);local function updateUI()
local c=applyHSV();svFrame.BackgroundColor3=Color3.fromHSV(hue,1,1);svCursor.Position=_UDim2(sat,-5,1-val2,-5);hueCursor.Position=_UDim2(0,-2,hue,-1);preview.BackgroundColor3=c;hexLbl.Text=toHex(c); rgbLbl.Text=fmtRGB(c)
end;local svDrag=false;local svBtn=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=106},svFrame);local function doSV(i)
local a=svFrame.AbsolutePosition; local s=svFrame.AbsoluteSize;sat=math.clamp((i.Position.X-a.X)/s.X,0,1);val2=math.clamp(1-(i.Position.Y-a.Y)/s.Y,0,1);updateUI()
end;svBtn.InputBegan:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then svDrag=true;doSV(i) end end)
UserInputService.InputEnded:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then svDrag=false end end)
UserInputService.InputChanged:Connect(function(i) if svDrag and i[_IUT]==_EUT.MouseMovement then doSV(i) end end)
local hueDrag=false;local hueBtn=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=106},hueFrame);local function doHue(i)
local a=hueFrame.AbsolutePosition; local s=hueFrame.AbsoluteSize;hue=math.clamp((i.Position.Y-a.Y)/s.Y,0,0.9999);updateUI()
end;hueBtn.InputBegan:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then hueDrag=true;doHue(i) end end)
UserInputService.InputEnded:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then hueDrag=false end end)
UserInputService.InputChanged:Connect(function(i) if hueDrag and i[_IUT]==_EUT.MouseMovement then doHue(i) end end)
end);return box
end;local function MakeColorBox(parent, color)
local box = New("Frame",{Size=_UDim2(0,14,0,14),BackgroundColor3=color or C.Accent,BorderSizePixel=0},parent);Corner(3,box); Stroke(C.KbtnBorder,1,box); return box
end;function MatrixHub.new()
local self=setmetatable({},MatrixHub);self.Tabs={};self.ActiveTab=nil;self.Visible=true;local guiParent do
local ok,cg = pcall(function() return game:GetService("CoreGui") end)
guiParent = (ok and cg) or LocalPlayer:WaitForChild("PlayerGui")
end;local Gui=New("ScreenGui",{Name=_sGUI,ResetOnSpawn=false,ZIndexBehavior=_EZB.Sibling},guiParent);local Win=New("Frame",{Size=_UDim2(0,692,0,600),Position=_UDim2(0.5,-346,0.5,-300),
BackgroundColor3=C.WinBG,BorderSizePixel=0,ClipsDescendants=false},Gui);Corner(12,Win); Stroke(C.Border,1.5,Win);self.Gui=Gui; self.Win=Win;_cpWin = Win;local Header=New("Frame",{Size=_UDim2(1,0,0,62),BackgroundColor3=C.HeaderBG,BorderSizePixel=0},Win);Corner(12,Header)
local logoLbl=New("TextLabel",{Text="MatrixHub",Font=_EFA.GothamBlack,TextSize=22,
TextColor3=_C3(1,1,1),BackgroundTransparency=1,Size=_UDim2(0,200,1,0),
Position=_UDim2(0,16,0,0),TextXAlignment=_ETX.Left,TextYAlignment=Enum.TextYAlignment.Center},Header);New("UIGradient",{Color=_CS({
_CSK(0,_Color3(221,230,245)),
_CSK(1,_Color3(30,144,255)),
}),Rotation=0},logoLbl);local function HBtn(icon,offX)
local b=New("TextButton",{Text=icon,Font=_EFA.GothamBold,TextSize=14,TextColor3=C.TextMuted,
BackgroundColor3=C.KbtnBG,Size=_UDim2(0,28,0,28),Position=_UDim2(1,offX,0,17),
BorderSizePixel=0,AutoButtonColor=false},Header);Corner(6,b); Stroke(C.KbtnBorder,1,b);b.MouseEnter:Connect(function() Tween(b,{TextColor3=C.Accent,BackgroundColor3=C.KbtnBorder},0.1) end)
b.MouseLeave:Connect(function() Tween(b,{TextColor3=C.TextMuted,BackgroundColor3=C.KbtnBG},0.1) end)
return b
end;HBtn("⚙",-44); HBtn("✦",-80);Draggable(Win,Header);local TabBar=New("Frame",{Size=_UDim2(1,0,0,40),Position=_UDim2(0,0,0,50),
BackgroundColor3=C.TabBarBG,BorderSizePixel=0},Win);New("UIListLayout",{FillDirection=_EFD.Horizontal,SortOrder=_ESO.LayoutOrder,Padding=_UDim(0,0)},TabBar);local ContentWrap=New("Frame",{Size=_UDim2(1,0,1,-90),Position=_UDim2(0,0,0,90),BackgroundTransparency=1},Win)
local ContentL=New("Frame",{Size=_UDim2(0.5,-1,1,0),Position=_UDim2(0,0,0,0),BackgroundTransparency=1,ClipsDescendants=true},ContentWrap);local ContentR=New("Frame",{Size=_UDim2(0.5,-1,1,0),Position=_UDim2(0.5,1,0,0),BackgroundTransparency=1,ClipsDescendants=true},ContentWrap)
self.TabBar=TabBar; self.ContentL=ContentL; self.ContentR=ContentR;return self
end;function MatrixHub:AddTab(name)
local idx=#self.Tabs+1;local TabBtn=New("TextButton",{Text=name,Font=_EFA.GothamBlack,TextSize=13,
TextColor3=C.TabInactive,BackgroundColor3=C.TabBarBG,Size=_UDim2(0.2,0,1,0),
BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=idx,ClipsDescendants=true},self.TabBar);local GlowFrame=New("Frame",{Size=_UDim2(1,0,0,0),Position=_UDim2(0.5,0,1,0),
AnchorPoint=_V2(0.5,1),BackgroundColor3=C.TabGlow,BackgroundTransparency=1,
BorderSizePixel=0,ZIndex=1},TabBtn);New("UIGradient",{
Color=_CS({_CSK(0,_C3(1,1,1)),_CSK(1,_C3(1,1,1))}),
Transparency=_NS({_NSK(0,0.2),_NSK(0.5,0.7),_NSK(1,1)}),
Rotation=270,
},GlowFrame);local Line=New("Frame",{Size=_UDim2(0,0,0,2),Position=_UDim2(0.5,0,1,-2),
AnchorPoint=_V2(0.5,0),BackgroundColor3=C.ActiveLine,BorderSizePixel=0,ZIndex=3},TabBtn);Corner(1,Line);local function MakeScroll(parent)
local s=New("ScrollingFrame",{Name="Tab_"..name,Size=_UDim2(1,0,1,0),BackgroundTransparency=1,
BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.4,
CanvasSize=_UDim2(0,0,0,0),AutomaticCanvasSize=_EAS.Y,Visible=false},parent);New("UIListLayout",{SortOrder=_ESO.LayoutOrder,Padding=_UDim(0,4)},s);New("UIPadding",{PaddingTop=_UDim(0,8),PaddingBottom=_UDim(0,8),PaddingLeft=_UDim(0,8),PaddingRight=_UDim(0,8)},s);return s
end;local ScrollL=MakeScroll(self.ContentL); local ScrollR=MakeScroll(self.ContentR);local Tab={Name=name,Btn=TabBtn,Line=Line,GlowFrame=GlowFrame,Scroll=ScrollL,ScrollL=ScrollL,ScrollR=ScrollR,_n=0,_nL=0,_nR=0,fullWidth=false};table.insert(self.Tabs,Tab)
TabBtn.MouseButton1Click:Connect(function() self:_Activate(Tab) end)
TabBtn.MouseEnter:Connect(function() if self.ActiveTab~=Tab then Tween(TabBtn,{TextColor3=C.TextMain},0.1) end end)
TabBtn.MouseLeave:Connect(function() if self.ActiveTab~=Tab then Tween(TabBtn,{TextColor3=C.TabInactive},0.1) end end)
if idx==1 then self:_Activate(Tab) end;return Tab
end;function MatrixHub:_Activate(tab)
for _,t in ipairs(self.Tabs) do
t.ScrollL.Visible=false; t.ScrollR.Visible=false;Tween(t.Btn,{TextColor3=C.TabInactive},0.12);Tween(t.Line,{Size=_UDim2(0,0,0,2)},0.12);Tween(t.GlowFrame,{BackgroundTransparency=1,Size=_UDim2(1,0,0,0)},0.18)
end;tab.ScrollL.Visible=true;if tab.fullWidth then
self.ContentL.Size=_UDim2(1,0,1,0);self.ContentR.Visible=false;tab.ScrollR.Visible=false
else
self.ContentL.Size=_UDim2(0.5,-1,1,0);self.ContentR.Visible=true;tab.ScrollR.Visible=true
end;Tween(tab.Btn,{TextColor3=C.TabActive},0.12);Tween(tab.Line,{Size=_UDim2(1,0,0,2)},0.18,_EES.Back);Tween(tab.GlowFrame,{BackgroundTransparency=0.72,Size=_UDim2(1,0,0,28)},0.22);self.ActiveTab=tab
end;local function MakeRow(tab,h,col)
local isR=(col=="R"); local scroll=isR and tab.ScrollR or tab.ScrollL;local nk=isR and "_nR" or "_nL"; tab[nk]=tab[nk]+1;local wrap=New("Frame",{Size=_UDim2(1,0,0,h or 40),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=tab[nk]},scroll)
local card=New("Frame",{Size=_UDim2(1,0,1,0),BackgroundColor3=C.RowBG,BorderSizePixel=0},wrap);Corner(7,card);card.MouseEnter:Connect(function() Tween(card,{BackgroundColor3=C.RowHover},0.08) end)
card.MouseLeave:Connect(function() Tween(card,{BackgroundColor3=C.RowBG},0.08) end)
return card
end;local function Label(r,text,w)
New("TextLabel",{Text=text,Font=_EFA.GothamBlack,TextSize=13,TextColor3=C.TextMain,
BackgroundTransparency=1,Size=_UDim2(0,w or 145,1,0),
Position=_UDim2(0,12,0,0),TextXAlignment=_ETX.Left},r)
end;local function MakeToggle(parent,state,offX)
local bg=New("Frame",{Size=_UDim2(0,40,0,20),Position=_UDim2(1,offX,0.5,-10),
BackgroundColor3=state and C.TogOn or C.TogOff,BorderSizePixel=0},parent);Corner(10,bg); Stroke(C.Border,1,bg);local knob=New("Frame",{Size=_UDim2(0,14,0,14),
Position=state and _UDim2(1,-17,0.5,-7) or _UDim2(0,3,0.5,-7),
BackgroundColor3=C.Knob,BorderSizePixel=0,ZIndex=2},bg);Corner(7,knob); return bg,knob
end;function MatrixHub:AddToggle(tab,label,default,cb,col)
local r=MakeRow(tab,nil,col); local state=default or false;Label(r,label);local bg,knob=MakeToggle(r,state,-48);local click=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=3},r);click.MouseButton1Click:Connect(function()
state=not state;Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18);Tween(knob,{Position=state and _UDim2(1,-17,0.5,-7) or _UDim2(0,3,0.5,-7)},0.18,_EES.Back);if cb then cb(state) end;end);return {Get=function() return state end}
end;function MatrixHub:AddKeybindToggle(tab,label,default,cb,col,initColor,onColorChange)
local r=MakeRow(tab,nil,col); local state=default or false;local binding=false; local boundKey=nil;Label(r,label);if initColor then
MakeColorPicker(r,-118,initColor,onColorChange)
end;local kbWrap,kbIcon,kbTxt,kbClick=MakeKeybindBtn(r,-90);local bg,knob=MakeToggle(r,state,-48);local function DoToggle()
state=not state;Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18);Tween(knob,{Position=state and _UDim2(1,-17,0.5,-7) or _UDim2(0,3,0.5,-7)},0.18,_EES.Back);if cb then cb(state) end
end;kbClick.MouseButton1Click:Connect(function()
if binding then return end;binding=true;kbTxt.Text="..."; kbTxt.TextColor3=C.TextMuted;Stroke(C.Accent,1,kbWrap);local conn; conn=UserInputService.InputBegan:Connect(function(inp)
local name;if inp[_IUT]==_EUT.Keyboard then
if inp.KeyCode==_EKC.Escape then
boundKey=nil; kbTxt.Text="None"; kbTxt.TextColor3=C.TextMuted;binding=false; conn:Disconnect();for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;return
end;local n=tostring(inp.KeyCode):sub(14); name=#n<=3 and n or n:sub(1,3); boundKey=inp.KeyCode
elseif inp[_IUT]==_EUT.MouseButton1 then name="MB1"; boundKey="MB1"
elseif inp[_IUT]==_EUT.MouseButton2 then name="MB2"; boundKey="MB2"
elseif inp[_IUT]==_EUT.MouseButton3 then name="MB3"; boundKey="MB3"
elseif inp[_IUT]==_EUT.MouseButton4 then name="MB4"; boundKey="MB4"
elseif inp[_IUT]==_EUT.MouseButton5 then name="MB5"; boundKey="MB5"
else return end;kbTxt.Text=name; kbTxt.TextColor3=C.Accent;binding=false; conn:Disconnect();for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;end);end);local togClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=4},bg)
togClick.MouseButton1Click:Connect(function() if not binding then DoToggle() end end)
UserInputService.InputBegan:Connect(function(inp)
if binding then return end;local isKey = inp[_IUT]==_EUT.Keyboard and inp.KeyCode==boundKey;local isMB2 = inp[_IUT]==_EUT.MouseButton2 and boundKey=="MB2";local isMB3 = inp[_IUT]==_EUT.MouseButton3 and boundKey=="MB3";local isMB4 = inp[_IUT]==_EUT.MouseButton4 and boundKey=="MB4"
local isMB5 = inp[_IUT]==_EUT.MouseButton5 and boundKey=="MB5";if isKey or isMB2 or isMB3 or isMB4 or isMB5 then DoToggle() end;end);return {Get=function() return state end}
end;function MatrixHub:AddKeybind(tab,label,default,cb,col)
local r=MakeRow(tab,nil,col); local state=default or false;local binding=false; local boundKey=nil;local modes={"Toggle","Hold","Always"}; local modeIdx=1;Label(r,label);local modeBg=New("Frame",{Size=_UDim2(0,52,0,20),Position=_UDim2(1,-150,0.5,-10),
BackgroundColor3=C.KbtnBG,BorderSizePixel=0},r);Corner(5,modeBg); Stroke(C.KbtnBorder,1,modeBg);local modeLbl=New("TextLabel",{Text=modes[modeIdx],Font=_EFA.GothamBold,TextSize=10,
TextColor3=C.Accent,BackgroundTransparency=1,Size=_UDim2(1,0,1,0)},modeBg);local modeClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=5},modeBg);local kbWrap,kbIcon,kbTxt,kbClick=MakeKeybindBtn(r,-90);local bg,knob=MakeToggle(r,state,-48)
local function SetState(v)
state=v;Tween(bg,{BackgroundColor3=state and C.TogOn or C.TogOff},0.18);Tween(knob,{Position=state and _UDim2(1,-17,0.5,-7) or _UDim2(0,3,0.5,-7)},0.18,_EES.Back);if cb then cb(state) end
end;modeClick.MouseButton1Click:Connect(function()
modeIdx=modeIdx%#modes+1; modeLbl.Text=modes[modeIdx];if modes[modeIdx]=="Always" then SetState(true) else SetState(false) end;end);local togClick=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=4},bg);togClick.MouseButton1Click:Connect(function()
if modes[modeIdx]=="Always" then return end;if modes[modeIdx]=="Toggle" then SetState(not state) end;end);kbClick.MouseButton1Click:Connect(function()
if binding then return end;binding=true;kbTxt.Text="..."; kbTxt.TextColor3=C.TextMuted;Stroke(C.Accent,1,kbWrap);local conn; conn=UserInputService.InputBegan:Connect(function(inp)
local name;if inp[_IUT]==_EUT.Keyboard then
if inp.KeyCode==_EKC.Escape then
boundKey=nil; kbTxt.Text="None"; kbTxt.TextColor3=C.TextMuted;binding=false; conn:Disconnect();for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;return
end;local n=tostring(inp.KeyCode):sub(14); name=#n<=3 and n or n:sub(1,3); boundKey=inp.KeyCode
elseif inp[_IUT]==_EUT.MouseButton1 then name="MB1"; boundKey="MB1"
elseif inp[_IUT]==_EUT.MouseButton2 then name="MB2"; boundKey="MB2"
elseif inp[_IUT]==_EUT.MouseButton3 then name="MB3"; boundKey="MB3"
elseif inp[_IUT]==_EUT.MouseButton4 then name="MB4"; boundKey="MB4"
elseif inp[_IUT]==_EUT.MouseButton5 then name="MB5"; boundKey="MB5"
else return end;kbTxt.Text=name; kbTxt.TextColor3=C.Accent;binding=false; conn:Disconnect();for _,s in ipairs(kbWrap:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;end);end);local function keyActive(k)
if not k then return false end;if k=="MB1" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton1)
elseif k=="MB2" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton2)
elseif k=="MB3" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton3)
elseif k=="MB4" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton4)
elseif k=="MB5" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton5)
else return UserInputService:IsKeyDown(k) end
end;UserInputService.InputBegan:Connect(function(inp)
if binding then return end;local isKey = inp[_IUT]==_EUT.Keyboard and inp.KeyCode==boundKey;local isMB1 = inp[_IUT]==_EUT.MouseButton1 and boundKey=="MB1";local isMB2 = inp[_IUT]==_EUT.MouseButton2 and boundKey=="MB2";local isMB4 = inp[_IUT]==_EUT.MouseButton4 and boundKey=="MB4"
local isMB5 = inp[_IUT]==_EUT.MouseButton5 and boundKey=="MB5";if not (isKey or isMB1 or isMB2 or isMB4 or isMB5) then return end;if modes[modeIdx]=="Toggle" then SetState(not state) elseif modes[modeIdx]=="Hold" then SetState(true) end;end);UserInputService.InputEnded:Connect(function(inp)
if binding then return end;local isKey = inp[_IUT]==_EUT.Keyboard and inp.KeyCode==boundKey;local isMB1 = inp[_IUT]==_EUT.MouseButton1 and boundKey=="MB1";local isMB2 = inp[_IUT]==_EUT.MouseButton2 and boundKey=="MB2";local isMB4 = inp[_IUT]==_EUT.MouseButton4 and boundKey=="MB4"
local isMB5 = inp[_IUT]==_EUT.MouseButton5 and boundKey=="MB5";if not (isKey or isMB1 or isMB2 or isMB4 or isMB5) then return end;if modes[modeIdx]=="Hold" then SetState(false) end;end);return {Get=function() return state end, GetMode=function() return modes[modeIdx] end}
end;function MatrixHub:AddDropdown(tab,label,options,default,cb,col)
local r=MakeRow(tab,nil,col); local idx=1;for i,v in ipairs(options) do if v==default then idx=i; break end end;Label(r,label);local valLbl=New("TextLabel",{Text=tostring(options[idx]),Font=_EFA.GothamBold,TextSize=12,
TextColor3=C.TextMuted,BackgroundTransparency=1,Size=_UDim2(0,70,1,0),
Position=_UDim2(1,-78,0,0),TextXAlignment=_ETX.Right},r);New("TextLabel",{Text="▾",Font=_EFA.GothamBold,TextSize=14,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(0,16,1,0),Position=_UDim2(1,-18,0,0)},r);local click=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0)},r);click.MouseButton1Click:Connect(function()
idx=idx%#options+1; valLbl.Text=tostring(options[idx]);if cb then cb(options[idx]) end;end);return {Get=function() return options[idx] end}
end;function MatrixHub:AddSlider(tab,label,min,max,default,cb,col)
local r=MakeRow(tab,40,col); local val=default or min; local dragging=false;Label(r,label);local numBG=New("Frame",{Size=_UDim2(0,34,0,24),Position=_UDim2(1,-126,0.5,-12),BackgroundColor3=C.NumBG,BorderSizePixel=0},r);Corner(5,numBG); Stroke(C.KbtnBorder,1,numBG)
local numLbl=New("TextLabel",{Text=tostring(val),Font=_EFA.GothamBold,TextSize=12,TextColor3=C.TextMain,BackgroundTransparency=1,Size=_UDim2(1,0,1,0)},numBG);local function MakeBtn(sym,offX)
local b=New("TextButton",{Text=sym,Font=_EFA.GothamBold,TextSize=16,TextColor3=_C3(1,1,1),
BackgroundColor3=C.Accent,Size=_UDim2(0,26,0,24),Position=_UDim2(1,offX,0.5,-12),
BorderSizePixel=0,AutoButtonColor=false},r);Corner(5,b);b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=C.AccentHover},0.1) end)
b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=C.Accent},0.1) end)
return b
end;local minusBtn=MakeBtn("−",-68); local plusBtn=MakeBtn("+",-34);local sr=MakeRow(tab,26,col);local track=New("Frame",{Size=_UDim2(1,-20,0,6),Position=_UDim2(0,10,0.5,-3),BackgroundColor3=C.SliderTrack,BorderSizePixel=0},sr);Corner(3,track);local pct=(val-min)/(max-min)
local fill=New("Frame",{Size=_UDim2(pct,0,1,0),BackgroundColor3=C.SliderFill,BorderSizePixel=0},track); Corner(3,fill);local thumb=New("Frame",{Size=_UDim2(0,12,0,12),Position=_UDim2(pct,-6,0.5,-6),BackgroundColor3=C.SliderFill,BorderSizePixel=0,ZIndex=2},track); Corner(6,thumb)
local function Set(v)
v=math.clamp(math.round(v),min,max); val=v; numLbl.Text=tostring(v);local p=(v-min)/(max-min);Tween(fill,{Size=_UDim2(p,0,1,0)},0.08); Tween(thumb,{Position=_UDim2(p,-6,0.5,-6)},0.08);if cb then cb(v) end
end;minusBtn.MouseButton1Click:Connect(function() Set(val-1) end)
plusBtn.MouseButton1Click:Connect(function() Set(val+1) end)
track.InputBegan:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then dragging=true end end)
UserInputService.InputEnded:Connect(function(i) if i[_IUT]==_EUT.MouseButton1 then dragging=false end end)
UserInputService.InputChanged:Connect(function(i)
if dragging and i[_IUT]==_EUT.MouseMovement then
Set(min+math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(max-min))
end;end);return {Get=function() return val end, Set=Set}
end;function MatrixHub:AddLabel(tab,text,col)
local r=MakeRow(tab,34,col);New("TextLabel",{Text=text,Font=_EFA.GothamMedium,TextSize=12,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(1,-24,1,0),Position=_UDim2(0,12,0,0),
TextXAlignment=_ETX.Left},r)
end;function MatrixHub:AddSeparator(tab,title,col)
local isR=(col=="R"); local scroll=isR and tab.ScrollR or tab.ScrollL;local nk=isR and "_nR" or "_nL"; tab[nk]=tab[nk]+1;local sep=New("Frame",{Size=_UDim2(1,0,0,20),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=tab[nk]},scroll)
New("Frame",{Size=_UDim2(1,-16,0,1),Position=_UDim2(0,8,0.5,0),BackgroundColor3=C.Border,BorderSizePixel=0},sep);if title and title~="" then
local bg=New("Frame",{Size=_UDim2(0,#title*7+12,0,16),Position=_UDim2(0,14,0.5,-8),BackgroundColor3=C.WinBG,BorderSizePixel=0},sep);New("TextLabel",{Text=title,Font=_EFA.GothamBold,TextSize=11,TextColor3=C.Accent,BackgroundTransparency=1,Size=_UDim2(1,0,1,0)},bg)
end
end;function MatrixHub:EnableToggleKey(key)
key=key or _EKC.Insert;UserInputService.InputBegan:Connect(function(i)
if i.KeyCode==key then self.Visible=not self.Visible; self.Win.Visible=self.Visible end;end)
end;task.wait(1);local W=MatrixHub.new();local Visual = W:AddTab("Visual");local Aimbot = W:AddTab("Aimbot");local Misc = W:AddTab("Misc");local Whitelist = W:AddTab("Whitelist");local Teleport = W:AddTab("Teleport");Whitelist.fullWidth = true;Teleport.fullWidth = true
if getgenv then getgenv()._MATRIXHUB_WHITELIST = {} end;local ESP = {
Enabled = false,
ESPType = "2D",
ShowName = false,
ShowHealth = false,
ShowDistance = false,
ShowTracer = false,
Teamcheck = false,
LimitDist = false,
LimitVal = 0,
HealthCheck = false,
BoxColor = _Color3(0,255,0),
NameColor = _Color3(255,255,255),
HealthHighColor = _Color3(0,255,0),
HealthLowColor = _Color3(255,0,0),
TracerColor = _Color3(255,255,255),
};local espCache = {};local function mkD(class,props)
local d=Drawing.new(class); for k,v in pairs(props) do d[k]=v end; return d
end;local function createEspForPlayer(p)
if p==LocalPlayer then return end;local lines2D={}; for i=1,4 do lines2D[i]=mkD("Line",{Thickness=1,Color=ESP.BoxColor,Visible=false}) end;local linesC={}; for i=1,8 do linesC[i]=mkD("Line",{Thickness=1,Color=ESP.BoxColor,Visible=false}) end;local e = {
lines2D=lines2D, linesC=linesC,
name = mkD("Text",{Color=ESP.NameColor,Outline=true,Center=true,Size=13,Visible=false}),
hpOutline = mkD("Line",{Thickness=4,Color=_Color3(0,0,0),Visible=false}),
hpFill = mkD("Line",{Thickness=2,Color=ESP.HealthHighColor,Visible=false}),
distance = mkD("Text",{Color=_Color3(200,200,200),Size=12,Outline=true,Center=true,Visible=false}),
tracer = mkD("Line",{Thickness=1,Color=ESP.TracerColor,Visible=false}),
};espCache[p]=e;if getgenv then getgenv()._MATRIXHUB_ESP[p]=e end
end;local function hideAllEsp(esp)
for _,l in pairs(esp.lines2D) do l.Visible=false end;for _,l in pairs(esp.linesC) do l.Visible=false end;esp.name.Visible=false; esp.hpOutline.Visible=false; esp.hpFill.Visible=false;esp.distance.Visible=false; esp.tracer.Visible=false
end;local function removeEspForPlayer(p)
local esp=espCache[p]; if not esp then return end;for _,l in pairs(esp.lines2D) do pcall(function() l:Remove() end) end;for _,l in pairs(esp.linesC) do pcall(function() l:Remove() end) end;for _,obj in pairs({esp.name,esp.hpOutline,esp.hpFill,esp.distance,esp.tracer}) do
pcall(function() obj:Remove() end)
end;espCache[p]=nil
end;local function setLine(l,p1,p2,col,thick)
l.From=p1; l.To=p2; l.Color=col or _Color3(0,255,0);l.Thickness=thick or 1; l.Visible=true
end;local function w2s(pos)
local sp,on=Camera:WorldToViewportPoint(pos);return _V2(sp.X,sp.Y), on, sp.Z
end;for _,p in ipairs(Players:GetPlayers()) do createEspForPlayer(p) end;Players.PlayerAdded:Connect(createEspForPlayer);Players.PlayerRemoving:Connect(removeEspForPlayer);RunService.RenderStepped:Connect(function()
local ok,err = pcall(function()
if not ESP.Enabled then
for _,e in pairs(espCache) do hideAllEsp(e) end; return
end;local localChar=LocalPlayer.Character;local localHRP=localChar and localChar:FindFirstChild(_sHRP);local col=ESP.BoxColor;for player,esp in pairs(espCache) do
local char=player.Character;if not char then hideAllEsp(esp); continue end;local hum=char:FindFirstChild("Humanoid");local hrp=char:FindFirstChild(_sHRP);local head=char:FindFirstChild("Head");if not hum or not hrp or not head or hum.Health<=0 then hideAllEsp(esp); continue end
if ESP.Teamcheck and player.Team and player.Team==LocalPlayer.Team then hideAllEsp(esp); continue end;if ESP.HealthCheck and hum.Health>=hum.MaxHealth then hideAllEsp(esp); continue end;local dist=localHRP and math.floor((hrp.Position-localHRP.Position).Magnitude) or 0
if ESP.LimitDist and ESP.LimitVal>0 and dist>ESP.LimitVal then hideAllEsp(esp); continue end;local rootSP,onScreen=w2s(hrp.Position);if not onScreen then hideAllEsp(esp); continue end;local headSP=w2s(head.Position+_V3(0,head.Size.Y/2,0));local footSP=w2s(hrp.Position-_V3(0,3,0))
local bh=math.abs(headSP.Y-footSP.Y);local bw=bh*0.55;local bx=rootSP.X-bw/2;local by=headSP.Y;for _,l in pairs(esp.lines2D) do l.Visible=false end;for _,l in pairs(esp.linesC) do l.Visible=false end;if ESP.ESPType=="2D" then
setLine(esp.lines2D[1],_V2(bx,by), _V2(bx+bw,by), col);setLine(esp.lines2D[2],_V2(bx,by+bh), _V2(bx+bw,by+bh), col);setLine(esp.lines2D[3],_V2(bx,by), _V2(bx,by+bh), col);setLine(esp.lines2D[4],_V2(bx+bw,by), _V2(bx+bw,by+bh), col)
elseif ESP.ESPType=="Corner" then
local cw=bw*0.28; local ch=bh*0.28;setLine(esp.linesC[1],_V2(bx,by), _V2(bx+cw,by), col);setLine(esp.linesC[2],_V2(bx,by), _V2(bx,by+ch), col);setLine(esp.linesC[3],_V2(bx+bw,by), _V2(bx+bw-cw,by), col);setLine(esp.linesC[4],_V2(bx+bw,by), _V2(bx+bw,by+ch), col)
setLine(esp.linesC[5],_V2(bx,by+bh), _V2(bx+cw,by+bh), col);setLine(esp.linesC[6],_V2(bx,by+bh), _V2(bx,by+bh-ch), col);setLine(esp.linesC[7],_V2(bx+bw,by+bh), _V2(bx+bw-cw,by+bh), col);setLine(esp.linesC[8],_V2(bx+bw,by+bh), _V2(bx+bw,by+bh-ch), col)
end;esp.name.Visible=ESP.ShowName;if ESP.ShowName then
esp.name.Text = dist>75 and (player.Name.." ["..dist.."m]") or player.Name;esp.name.Position=_V2(bx+bw/2, by-16);esp.name.Color=ESP.NameColor
end;if ESP.ShowHealth then
local hp=math.clamp(hum.Health/hum.MaxHealth,0,1);local hpColor=ESP.HealthLowColor:Lerp(ESP.HealthHighColor,hp);local hx=bx-5;esp.hpOutline.From=_V2(hx,by+bh);esp.hpOutline.To=_V2(hx,by);esp.hpOutline.Thickness=4;esp.hpOutline.Visible=true;esp.hpFill.From=_V2(hx,by+bh)
esp.hpFill.To=_V2(hx,by+bh - bh*hp);esp.hpFill.Color=hpColor;esp.hpFill.Thickness=2;esp.hpFill.Visible=true
else
esp.hpOutline.Visible=false; esp.hpFill.Visible=false
end;esp.distance.Visible=ESP.ShowDistance;if ESP.ShowDistance then
esp.distance.Text="["..dist.."m]";esp.distance.Position=_V2(bx+bw/2,by+bh+5)
end;esp.tracer.Visible=ESP.ShowTracer;if ESP.ShowTracer then
esp.tracer.From=_V2(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);esp.tracer.To=_V2(rootSP.X,rootSP.Y);esp.tracer.Color=ESP.TracerColor
end
end
end;end);end);W:AddKeybindToggle(Visual,"ESP Box",false,function(v) ESP.Enabled=v end,"L",
_Color3(0,255,0), function(v)
ESP.BoxColor=v;for _,e in pairs(espCache) do for _,l in pairs(e.lines2D) do l.Color=v end for _,l in pairs(e.linesC) do l.Color=v end end;end);W:AddDropdown(Visual,"ESP Type",{"2D","Corner"},"2D",function(v) ESP.ESPType=v end,"L")
W:AddKeybindToggle(Visual,"ESP Distance",false,function(v) ESP.ShowDistance=v end,"L")
W:AddKeybindToggle(Visual,"ESP Name",false,function(v) ESP.ShowName=v end,"L",
_Color3(255,255,255), function(v) ESP.NameColor=v end)
W:AddToggle(Visual,"ESP Health",false,function(v) ESP.ShowHealth=v end,"L")
do
local r=MakeRow(Visual,36,"L");New("TextLabel",{Text=" └ HP High / Low",Font=_EFA.GothamBold,TextSize=12,TextColor3=C.TextMuted,BackgroundTransparency=1,Size=_UDim2(0,145,1,0),Position=_UDim2(0,12,0,0),TextXAlignment=_ETX.Left},r)
MakeColorPicker(r,-28,_Color3(255,0,0),function(v) ESP.HealthLowColor=v end)
MakeColorPicker(r,-52,_Color3(0,255,0),function(v) ESP.HealthHighColor=v end)
end;W:AddKeybindToggle(Visual,"ESP SnapLine",false,function(v) ESP.ShowTracer=v end,"L",
_Color3(255,255,255), function(v) ESP.TracerColor=v end)
W:AddKeybindToggle(Visual,"Limit Distance",false,function(v) ESP.LimitDist=v end,"L")
W:AddSlider(Visual,"Limit Distance Value",0,500,0,function(v) ESP.LimitVal=v end,"L")
W:AddToggle(Visual,"CheckTeam",false,function(v) ESP.Teamcheck=v end,"R")
W:AddToggle(Visual,"Health Check",false,function(v) ESP.HealthCheck=v end,"R")
local Mouse = LocalPlayer:GetMouse();local AB = {
Enabled=false, Key=nil, KeyActive=false, Toggle=false,
Method="CamLock", Part="Head", Smooth=1.0,
Predict=false, PredictX=0.2, Sticky=false, StickyTarget=nil,
SilentEnabled=false, SilentKey=nil, SilentKeyActive=false,
SilentTarget=nil, SilentPart="HumanoidRootPart", SilentPredict=0,
TriggerEnabled=false, TriggerKey=nil, TriggerKeyActive=false,
StrafeEnabled=false, StrafeSpeed=5, StrafeRadius=5, StrafeHeight=0, StrafeAngle=0,
};local function knockCheck(player)
if player.Character then
local be=player.Character:FindFirstChild("BodyEffects");if be then local ko=be:FindFirstChild("K.O"); if ko and ko.Value then return false end end
end;return true
end;local function getClosest()
local best,bestDist=nil,math.huge;local mx,my=Mouse.X,Mouse.Y;for _,player in pairs(Players:GetPlayers()) do
if player==LocalPlayer then continue end;if getgenv and getgenv()._MATRIXHUB_WHITELIST and getgenv()._MATRIXHUB_WHITELIST[player.Name] then continue end;local char=player.Character; if not char then continue end;local hum=char:FindFirstChildOfClass(_sHUM); local hrp=char:FindFirstChild(_sHRP)
if not hum or not hrp or hum.Health<=0 then continue end;if AB.KnockCheck and not knockCheck(player) then continue end;local sp,on=Camera:WorldToViewportPoint(hrp.Position); if not on then continue end;local d=_V2(sp.X-mx,sp.Y-my).Magnitude;if d<bestDist then bestDist=d; best=player end
end;return best
end;local function isKeyActive(key)
if not key then return true end;if key=="MB1" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton1)
elseif key=="MB2" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton2)
elseif key=="MB3" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton3)
elseif key=="MB4" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton4)
elseif key=="MB5" then return UserInputService:IsMouseButtonPressed(_EUT.MouseButton5)
else return UserInputService:IsKeyDown(key) end
end;RunService.RenderStepped:Connect(function()
pcall(function()
if AB.Enabled and (AB.Toggle or isKeyActive(AB.Key)) then
local target=(AB.Sticky and AB.StickyTarget) or getClosest();if AB.Sticky then AB.StickyTarget=target end;if target and target.Character then
local part=target.Character:FindFirstChild(AB.Part) or target.Character:FindFirstChild("Head");local hrp=target.Character:FindFirstChild(_sHRP);if part and hrp then
local pos=part.Position+(AB.Predict and hrp.AssemblyLinearVelocity*AB.PredictX or Vector3.zero);Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,pos),1/math.max(AB.Smooth,1))
end
end
elseif AB.Sticky and not isKeyActive(AB.Key) then AB.StickyTarget=nil end;if AB.TriggerEnabled and isKeyActive(AB.TriggerKey) then
local ray=Camera:ScreenPointToRay(Mouse.X,Mouse.Y);local res=workspace:Raycast(ray.Origin,ray.Direction*500);if res and res.Instance then
local char=res.Instance:FindFirstAncestorWhichIsA("Model");if char then
local plr=Players:GetPlayerFromCharacter(char);if plr and plr~=LocalPlayer then
local hum=char:FindFirstChildOfClass(_sHUM);if hum and hum.Health>0 then
pcall(function() game:GetService("VirtualUser"):Button1Down(_V2(),Camera.CFrame) end)
task.wait();pcall(function() game:GetService("VirtualUser"):Button1Up(_V2(),Camera.CFrame) end)
end
end
end
end
end;end);end);local function MakeKeyBind(parent, offX, w, onSet)
local kf=New("Frame",{Size=_UDim2(0,w or 72,0,24),Position=_UDim2(1,offX,0.5,-12),
BackgroundColor3=C.KbtnBG,BorderSizePixel=0,ZIndex=3},parent);Corner(5,kf); Stroke(C.KbtnBorder,1,kf);local kt=New("TextLabel",{Text="None",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=4},kf);local kb=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=5},kf);local binding=false;kb.MouseButton1Click:Connect(function()
if binding then return end; binding=true; kt.Text="..."; kt.TextColor3=C.TextMuted;Stroke(C.Accent,1,kf);local conn; conn=UserInputService.InputBegan:Connect(function(inp)
local key,txt;if inp[_IUT]==_EUT.Keyboard then
if inp.KeyCode==_EKC.Escape then
key=nil; txt=nil;kt.Text="None"; kt.TextColor3=C.TextMuted; binding=false; conn:Disconnect();for _,s in ipairs(kf:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;if onSet then onSet(nil) end;return
end;key=inp.KeyCode; local n=tostring(inp.KeyCode):sub(14); txt=#n<=4 and n or n:sub(1,4)
elseif inp[_IUT]==_EUT.MouseButton1 then key="MB1"; txt="MB1"
elseif inp[_IUT]==_EUT.MouseButton2 then key="MB2"; txt="MB2"
elseif inp[_IUT]==_EUT.MouseButton4 then key="MB4"; txt="MB4"
elseif inp[_IUT]==_EUT.MouseButton5 then key="MB5"; txt="MB5"
else return end;kt.Text=txt; kt.TextColor3=C.Accent; binding=false; conn:Disconnect();for _,s in ipairs(kf:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;if onSet then onSet(key) end;end);end);return kf
end;W:AddKeybindToggle(Aimbot,"Aimbot",false,function(v) AB.Enabled=v end,"L")
do local r=MakeRow(Aimbot,36,"L"); New("TextLabel",{Text="Aimbot Key",Font=_EFA.GothamBlack,TextSize=13,TextColor3=C.TextMain,BackgroundTransparency=1,Size=_UDim2(0,120,1,0),Position=_UDim2(0,12,0,0),TextXAlignment=_ETX.Left},r); MakeKeyBind(r,-84,76,function(k) AB.Key=k end) end
W:AddDropdown(Aimbot,"Method",{"CamLock","Mouse"},"CamLock",function(v) AB.Method=v end,"L")
W:AddDropdown(Aimbot,"Select Part",{"Head","UpperTorso","HumanoidRootPart"},"Head",function(v) AB.Part=v end,"L")
W:AddSlider(Aimbot,"Smooth",1,20,1,function(v) AB.Smooth=v end,"L")
W:AddKeybindToggle(Aimbot,"Predict",false,function(v) AB.Predict=v end,"L")
W:AddSlider(Aimbot,"Predict Amount",0,10,2,function(v) AB.PredictX=v/10 end,"L")
W:AddToggle(Aimbot,"Sticky",false,function(v) AB.Sticky=v; if not v then AB.StickyTarget=nil end end,"L")
W:AddToggle(Aimbot,"Knock Check",false,function(v) AB.KnockCheck=v end,"L")
W:AddKeybindToggle(Aimbot,"TriggerBot",false,function(v) AB.TriggerEnabled=v end,"R")
do local r=MakeRow(Aimbot,36,"R"); New("TextLabel",{Text="Trigger Key",Font=_EFA.GothamBlack,TextSize=13,TextColor3=C.TextMain,BackgroundTransparency=1,Size=_UDim2(0,100,1,0),Position=_UDim2(0,12,0,0),TextXAlignment=_ETX.Left},r); MakeKeyBind(r,-80,72,function(k) AB.TriggerKey=k end) end
local walkEnabled=false; local walkSpeed=16;W:AddKeybind(Misc,"WalkSpeed",false,function(on)
walkEnabled=on;local char=LocalPlayer.Character; if not char then return end;local hum=char:FindFirstChildOfClass(_sHUM);if hum then hum.WalkSpeed=on and walkSpeed or 16 end;end,"L");W:AddDropdown(Misc,"WalkSpeed Method",{"WalkSpeed","CFrame","BodyVelocity"},"WalkSpeed",nil,"L")
W:AddSlider(Misc,"Walk Speed",16,300,16,function(v)
walkSpeed=v;if walkEnabled then
local char=LocalPlayer.Character;if char then local hum=char:FindFirstChildOfClass(_sHUM); if hum then hum.WalkSpeed=v end end
end;end,"L");local flyEnabled=false; local flySpeed=50; local flyMethod="CFrame";local flyConn=nil; local bodyVel,bodyGyro;local function StopFly()
flyEnabled=false;if flyConn then flyConn:Disconnect(); flyConn=nil end;if bodyVel then bodyVel:Destroy(); bodyVel=nil end;if bodyGyro then bodyGyro:Destroy(); bodyGyro=nil end;local char=LocalPlayer.Character; if not char then return end
local hum=char:FindFirstChildOfClass(_sHUM); if hum then hum.PlatformStand=false end
end;local function StartFly()
flyEnabled=true;local char=LocalPlayer.Character; if not char then return end;local hrp=char:FindFirstChild(_sHRP);local hum=char:FindFirstChildOfClass(_sHUM);if not hrp or not hum then return end;hum.PlatformStand=true;if flyMethod=="BodyVelocity" or flyMethod=="Position" then
bodyVel=_Inst("BodyVelocity"); bodyVel.MaxForce=_V3(1e5,1e5,1e5); bodyVel.Velocity=Vector3.zero; bodyVel.Parent=hrp;bodyGyro=_Inst("BodyGyro"); bodyGyro.MaxTorque=_V3(1e5,1e5,1e5); bodyGyro.D=100; bodyGyro.Parent=hrp;flyConn=RunService.RenderStepped:Connect(function()
if not flyEnabled then return end;local cam=workspace.CurrentCamera; local dir=Vector3.zero;if UserInputService:IsKeyDown(_EKC.W) then dir=dir+cam.CFrame.LookVector end;if UserInputService:IsKeyDown(_EKC.S) then dir=dir-cam.CFrame.LookVector end
if UserInputService:IsKeyDown(_EKC.A) then dir=dir-cam.CFrame.RightVector end;if UserInputService:IsKeyDown(_EKC.D) then dir=dir+cam.CFrame.RightVector end;if UserInputService:IsKeyDown(_EKC.Space) then dir=dir+_V3(0,1,0) end;if UserInputService:IsKeyDown(_EKC.LeftShift) then dir=dir-_V3(0,1,0) end
bodyVel.Velocity=dir.Magnitude>0 and dir.Unit*flySpeed or Vector3.zero;bodyGyro.CFrame=cam.CFrame;end)
else
flyConn=RunService.RenderStepped:Connect(function()
if not flyEnabled then return end;local cam=workspace.CurrentCamera; local dir=Vector3.zero;if UserInputService:IsKeyDown(_EKC.W) then dir=dir+cam.CFrame.LookVector end;if UserInputService:IsKeyDown(_EKC.S) then dir=dir-cam.CFrame.LookVector end
if UserInputService:IsKeyDown(_EKC.A) then dir=dir-cam.CFrame.RightVector end;if UserInputService:IsKeyDown(_EKC.D) then dir=dir+cam.CFrame.RightVector end;if UserInputService:IsKeyDown(_EKC.Space) then dir=dir+_V3(0,1,0) end;if UserInputService:IsKeyDown(_EKC.LeftShift) then dir=dir-_V3(0,1,0) end
if dir.Magnitude>0 then hrp.CFrame=hrp.CFrame+dir.Unit*(flySpeed*0.016) end;end)
end
end;W:AddKeybind(Misc,"Fly",false,function(on) if on then StartFly() else StopFly() end end,"L")
W:AddDropdown(Misc,"Fly Method",{"CFrame","BodyVelocity","Position"},"CFrame",function(v) flyMethod=v; if flyEnabled then StopFly();StartFly() end end,"L")
W:AddSlider(Misc,"Fly Speed",10,300,50,function(v) flySpeed=v end,"L")
local jumpEnabled=false;W:AddToggle(Misc,"Infinite Jump",false,function(on) jumpEnabled=on end,"L")
UserInputService.JumpRequest:Connect(function()
if not jumpEnabled then return end;local char=LocalPlayer.Character; if not char then return end;local hum=char:FindFirstChildOfClass(_sHUM); if not hum then return end;hum:ChangeState(_EHS.Jumping);end);local noclipEnabled=false
W:AddToggle(Misc,"No Clip",false,function(on) noclipEnabled=on end,"L")
RunService.Stepped:Connect(function()
if not noclipEnabled then return end;local char=LocalPlayer.Character; if not char then return end;for _,part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide=false end
end;end);do;local searchRow = MakeRow(Whitelist, 32, "L");local searchBox = New("TextBox",{
Text="",PlaceholderText="Search...",
Font=_EFA.GothamBold,TextSize=12,
TextColor3=C.TextMain,PlaceholderColor3=C.TextMuted,
BackgroundColor3=C.KbtnBG,BorderSizePixel=0,
Size=_UDim2(1,-70,0,24),Position=_UDim2(0,8,0.5,-12),
ClearTextOnFocus=false,ZIndex=3,
},searchRow);Corner(5,searchBox);local searchBtn = New("TextButton",{
Text="Search",Font=_EFA.GothamBold,TextSize=11,
TextColor3=_C3(1,1,1),BackgroundColor3=C.Accent,
Size=_UDim2(0,54,0,24),Position=_UDim2(1,-62,0.5,-12),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3,
},searchRow);Corner(5,searchBtn);local headRow = MakeRow(Whitelist,28,"L");New("TextLabel",{Text="Player Name",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundTransparency=1,
Size=_UDim2(0.6,0,1,0),Position=_UDim2(0,12,0,0),
TextXAlignment=_ETX.Left},headRow);New("TextLabel",{Text="Action",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundTransparency=1,
Size=_UDim2(0.4,-8,1,0),Position=_UDim2(0.6,0,0,0),
TextXAlignment=_ETX.Center},headRow);local whitelistSet = {};local playerRows = {};local function addPlayerRow(player)
if playerRows[player] then return end;local r = MakeRow(Whitelist,34,"L");New("TextLabel",{Text=player.Name,Font=_EFA.GothamBold,TextSize=12,
TextColor3=C.TextMain,BackgroundTransparency=1,
Size=_UDim2(0.55,0,1,0),Position=_UDim2(0,12,0,0),
TextXAlignment=_ETX.Left},r);local wlBtn = New("TextButton",{
Text=whitelistSet[player.Name] and "Listed" or "Whitelist",
Font=_EFA.GothamBold,TextSize=10,
TextColor3=_C3(0,0,0),
BackgroundColor3=whitelistSet[player.Name] and _Color3(0,200,80) or _Color3(80,255,120),
Size=_UDim2(0,68,0,22),Position=_UDim2(1,-76,0.5,-11),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3,
},r);Corner(5,wlBtn);wlBtn.MouseButton1Click:Connect(function()
whitelistSet[player.Name] = not whitelistSet[player.Name];if whitelistSet[player.Name] then
wlBtn.Text="Listed"; wlBtn.BackgroundColor3=_Color3(0,200,80);if getgenv then getgenv()._MATRIXHUB_WHITELIST[player.Name]=true end
else
wlBtn.Text="Whitelist"; wlBtn.BackgroundColor3=_Color3(80,255,120);if getgenv then getgenv()._MATRIXHUB_WHITELIST[player.Name]=nil end
end;end);playerRows[player] = r
end;local function removePlayerRow(player)
if playerRows[player] then
playerRows[player].Parent.Parent.Visible = false;playerRows[player] = nil;whitelistSet[player.Name] = nil
end
end;local function filterRows(query)
query = query:lower();for plr,row in pairs(playerRows) do
local wrap = row.Parent;if query=="" then
wrap.Visible=true
else
wrap.Visible = plr.Name:lower():find(query,1,true) ~= nil
end
end
end;searchBox:GetPropertyChangedSignal("Text"):Connect(function() filterRows(searchBox.Text) end)
searchBtn.MouseButton1Click:Connect(function() filterRows(searchBox.Text) end)
for _,p in ipairs(Players:GetPlayers()) do
if p~=LocalPlayer then addPlayerRow(p) end
end;Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then addPlayerRow(p) end end)
Players.PlayerRemoving:Connect(removePlayerRow)
end;do;local teleportPoints = {};local nameRow = MakeRow(Teleport,32,"L");local namebox = New("TextBox",{
Text="",PlaceholderText="Save Name",
Font=_EFA.GothamBold,TextSize=12,
TextColor3=C.TextMain,PlaceholderColor3=C.TextMuted,
BackgroundColor3=C.KbtnBG,BorderSizePixel=0,
Size=_UDim2(1,-16,0,24),Position=_UDim2(0,8,0.5,-12),
ClearTextOnFocus=false,ZIndex=3,
},nameRow);Corner(5,namebox);local coordRow = MakeRow(Teleport,32,"L");local xLbl = New("TextLabel",{Text="0.000",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundColor3=C.KbtnBG,BorderSizePixel=0,
Size=_UDim2(0,70,0,24),Position=_UDim2(0,8,0.5,-12),ZIndex=3},coordRow);Corner(4,xLbl);local yLbl = New("TextLabel",{Text="0.000",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundColor3=C.KbtnBG,BorderSizePixel=0,
Size=_UDim2(0,70,0,24),Position=_UDim2(0,84,0.5,-12),ZIndex=3},coordRow);Corner(4,yLbl);local zLbl = New("TextLabel",{Text="0.000",Font=_EFA.GothamBold,TextSize=11,
TextColor3=C.TextMuted,BackgroundColor3=C.KbtnBG,BorderSizePixel=0,
Size=_UDim2(0,70,0,24),Position=_UDim2(0,160,0.5,-12),ZIndex=3},coordRow);Corner(4,zLbl);New("TextLabel",{Text="Position X Y Z",Font=_EFA.GothamBold,TextSize=10,
TextColor3=C.TextMuted,BackgroundTransparency=1,
Size=_UDim2(0,90,0,24),Position=_UDim2(1,-98,0.5,-12),ZIndex=3},coordRow);task.spawn(function()
while true do
task.wait(0.1);local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if hrp then
local p=hrp.Position;xLbl.Text=string.format("%.3f",p.X);yLbl.Text=string.format("%.3f",p.Y);zLbl.Text=string.format("%.3f",p.Z)
end
end;end);local btnRow = MakeRow(Teleport,32,"L");local function MakeTpBtn(txt,bgCol,offX,w)
local b=New("TextButton",{
Text=txt,Font=_EFA.GothamBold,TextSize=11,
TextColor3=_C3(1,1,1),BackgroundColor3=bgCol,
Size=_UDim2(0,w or 80,0,24),Position=_UDim2(0,offX,0.5,-12),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3,
},btnRow);Corner(5,b);b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=bgCol:Lerp(_C3(1,1,1),0.15)},0.1) end)
b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=bgCol},0.1) end)
return b
end;local setKbBtn = MakeTpBtn("Set Keybind", _Color3(30,144,255), 8, 88);local saveBtn = MakeTpBtn("Save Data", _Color3(30,144,255), 102, 80);local curLocBtn = MakeTpBtn("Current Location",_Color3(30,144,255),188,110);local tpHead = MakeRow(Teleport,24,"L")
tpHead.BackgroundColor3 = _Color3(18,26,40);local function TpHCol(txt,xOff,w)
New("TextLabel",{Text=txt,Font=_EFA.GothamBold,TextSize=10,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(0,w,1,0),
Position=_UDim2(0,xOff,0,0),TextXAlignment=_ETX.Left},tpHead)
end;TpHCol("Save Name",8,90); TpHCol("X",102,70); TpHCol("Y",176,70);TpHCol("Z",250,70); TpHCol("Key",324,44); TpHCol("Go",372,34); TpHCol("↑",410,24); TpHCol("✕",438,24);local tpRows = {};local boundTpKeys = {};local function addTpRow(name, pos)
if tpRows[name] then
teleportPoints[name] = pos;local r = tpRows[name];local lbls = {};for _,c in ipairs(r:GetChildren()) do
if c:IsA("TextLabel") then table.insert(lbls,c) end
end;for _,lbl in ipairs(lbls) do
if lbl.Position.X.Offset == 90 then lbl.Text=string.format("%.1f",pos.X) end;if lbl.Position.X.Offset == 158 then lbl.Text=string.format("%.1f",pos.Y) end;if lbl.Position.X.Offset == 226 then lbl.Text=string.format("%.1f",pos.Z) end
end;return
end;local r = MakeRow(Teleport,30,"L");r.BackgroundColor3 = C.RowBG;New("TextLabel",{Text=name,Font=_EFA.GothamBold,TextSize=11,TextColor3=C.TextMain,
BackgroundTransparency=1,Size=_UDim2(0,90,1,0),Position=_UDim2(0,8,0,0),
TextXAlignment=_ETX.Left},r);local xL=New("TextLabel",{Text=string.format("%.1f",pos.X),Font=_EFA.GothamBold,TextSize=10,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(0,70,1,0),Position=_UDim2(0,102,0,0),TextXAlignment=_ETX.Left},r);local yL=New("TextLabel",{Text=string.format("%.1f",pos.Y),Font=_EFA.GothamBold,TextSize=10,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(0,70,1,0),Position=_UDim2(0,176,0,0),TextXAlignment=_ETX.Left},r);local zL=New("TextLabel",{Text=string.format("%.1f",pos.Z),Font=_EFA.GothamBold,TextSize=10,TextColor3=C.TextMuted,
BackgroundTransparency=1,Size=_UDim2(0,70,1,0),Position=_UDim2(0,250,0,0),TextXAlignment=_ETX.Left},r);local kbF=New("Frame",{Size=_UDim2(0,40,0,20),Position=_UDim2(0,324,0.5,-10),
BackgroundColor3=C.KbtnBG,BorderSizePixel=0,ZIndex=3},r);Corner(4,kbF); Stroke(C.KbtnBorder,1,kbF);local kbLbl=New("TextLabel",{Text="—",Font=_EFA.GothamBold,TextSize=9,
TextColor3=C.TextMuted,BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=4},kbF);local kbClick2=New("TextButton",{Text="",BackgroundTransparency=1,Size=_UDim2(1,0,1,0),ZIndex=5},kbF);local tpKey=nil; local tpBinding=false;kbClick2.MouseButton1Click:Connect(function()
if tpBinding then return end; tpBinding=true; kbLbl.Text="...";Stroke(C.Accent,1,kbF);local conn; conn=UserInputService.InputBegan:Connect(function(inp)
if inp[_IUT]==_EUT.Keyboard then
if inp.KeyCode==_EKC.Escape then
tpKey=nil; kbLbl.Text="—"; kbLbl.TextColor3=C.TextMuted;tpBinding=false; conn:Disconnect();for _,s in ipairs(kbF:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end;return
end;tpKey=inp.KeyCode;local n=tostring(inp.KeyCode):sub(14); kbLbl.Text=#n<=3 and n or n:sub(1,3);kbLbl.TextColor3=C.Accent; tpBinding=false; conn:Disconnect();for _,s in ipairs(kbF:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
elseif inp[_IUT]==_EUT.MouseButton4 then
tpKey="MB4"; kbLbl.Text="MB4"; kbLbl.TextColor3=C.Accent;tpBinding=false; conn:Disconnect();for _,s in ipairs(kbF:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
elseif inp[_IUT]==_EUT.MouseButton5 then
tpKey="MB5"; kbLbl.Text="MB5"; kbLbl.TextColor3=C.Accent;tpBinding=false; conn:Disconnect();for _,s in ipairs(kbF:GetChildren()) do if s:IsA("UIStroke") then s.Color=C.KbtnBorder end end
end;end);end);UserInputService.InputBegan:Connect(function(inp)
if tpBinding then return end;local triggered = false;if type(tpKey)=="string" then
if tpKey=="MB4" and inp[_IUT]==_EUT.MouseButton4 then triggered=true end;if tpKey=="MB5" and inp[_IUT]==_EUT.MouseButton5 then triggered=true end
elseif inp[_IUT]==_EUT.Keyboard and inp.KeyCode==tpKey then
triggered=true
end;if triggered then
local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if hrp then hrp.CFrame=CFrame.new(teleportPoints[name] or pos) end
end;end);local goBtn=New("TextButton",{Text="Go",Font=_EFA.GothamBold,TextSize=10,
TextColor3=_C3(1,1,1),BackgroundColor3=C.Accent,
Size=_UDim2(0,32,0,20),Position=_UDim2(0,370,0.5,-10),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3},r);Corner(4,goBtn);goBtn.MouseButton1Click:Connect(function()
local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if hrp then hrp.CFrame=CFrame.new(teleportPoints[name] or pos) end;end);local updBtn=New("TextButton",{Text="↑",Font=_EFA.GothamBold,TextSize=12,
TextColor3=_C3(1,1,1),BackgroundColor3=_Color3(30,100,180),
Size=_UDim2(0,24,0,20),Position=_UDim2(0,408,0.5,-10),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3},r);Corner(4,updBtn);updBtn.MouseButton1Click:Connect(function()
local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if not hrp then return end;local p=hrp.Position;teleportPoints[name]=p;xL.Text=string.format("%.1f",p.X);yL.Text=string.format("%.1f",p.Y);zL.Text=string.format("%.1f",p.Z);end)
local delBtn=New("TextButton",{Text="✕",Font=_EFA.GothamBold,TextSize=11,
TextColor3=_Color3(255,80,80),BackgroundColor3=_Color3(50,20,20),
Size=_UDim2(0,24,0,20),Position=_UDim2(0,438,0.5,-10),
BorderSizePixel=0,AutoButtonColor=false,ZIndex=3},r);Corner(4,delBtn);delBtn.MouseButton1Click:Connect(function()
teleportPoints[name]=nil;tpRows[name]=nil;r.Parent.Visible=false;end);tpRows[name]=r;teleportPoints[name]=pos
end;local saveKey=nil; local saveBinding=false;setKbBtn.MouseButton1Click:Connect(function()
if saveBinding then return end; saveBinding=true;setKbBtn.Text="Press key...";local conn; conn=UserInputService.InputBegan:Connect(function(inp)
if inp[_IUT]==_EUT.Keyboard then
if inp.KeyCode==_EKC.Escape then
saveKey=nil; setKbBtn.Text="Set Keybind";saveBinding=false; conn:Disconnect();return
end;saveKey=inp.KeyCode;local n=tostring(inp.KeyCode):sub(14);setKbBtn.Text="KB: "..(#n<=3 and n or n:sub(1,3));saveBinding=false; conn:Disconnect()
elseif inp[_IUT]==_EUT.MouseButton4 then
saveKey="MB4"; setKbBtn.Text="KB: MB4";saveBinding=false; conn:Disconnect()
elseif inp[_IUT]==_EUT.MouseButton5 then
saveKey="MB5"; setKbBtn.Text="KB: MB5";saveBinding=false; conn:Disconnect()
end;end);end);local function doSave()
local name=namebox.Text;if name=="" then name="Point "..tostring(#teleportPoints+1) end;local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if not hrp then return end;if not tpRows[name] then
addTpRow(name, hrp.Position)
end
end;saveBtn.MouseButton1Click:Connect(doSave);curLocBtn.MouseButton1Click:Connect(function()
local char=LocalPlayer.Character;local hrp=char and char:FindFirstChild(_sHRP);if hrp then
local p=hrp.Position;xLbl.Text=string.format("%.3f",p.X);yLbl.Text=string.format("%.3f",p.Y);zLbl.Text=string.format("%.3f",p.Z)
end;end);UserInputService.InputBegan:Connect(function(inp)
if saveBinding then return end;local triggered = false;if type(saveKey)=="string" then
if saveKey=="MB4" and inp[_IUT]==_EUT.MouseButton4 then triggered=true end;if saveKey=="MB5" and inp[_IUT]==_EUT.MouseButton5 then triggered=true end
elseif inp[_IUT]==_EUT.Keyboard and inp.KeyCode==saveKey then
triggered=true
end;if triggered then doSave() end;end)
end;W:EnableToggleKey(_EKC.Insert);return MatrixHub