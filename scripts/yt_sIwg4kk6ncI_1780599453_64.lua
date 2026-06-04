local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local p=Players.LocalPlayer
if not p then return end

local TOTAL=144
local FD=250.0
local cur=1
local playing=false
local ended=false
local dragging=false
local speed=1
local ctrlVis=true
local ctrlTimer=0
local lastFT=0
local autoReplay=false
local W,H=380,214
local autoHideEnabled=true

local lastTap=0
local lastSide=""
local tapCount=0
local holding=false
local holdStart=0
local normalSpeed=1
local isSpeedBoostActive=false

local resizing=false
local resizeDir=""
local startW,startH=0,0
local startResizeX,startResizeY=0,0
local startMousePos=nil

local g=Instance.new("ScreenGui")
g.Name="VideoPlayer_sIwg4kk6ncI_1780599453"
g.ResetOnSpawn=false
g.IgnoreGuiInset=true
g.DisplayOrder=999
g.Parent=p:WaitForChild("PlayerGui")

local I={
    skipB="rbxassetid://97609998912425",
    skipF="rbxassetid://108948582252594",
    stepB="rbxassetid://96477998975284",
    stepF="rbxassetid://133716111451411",
    play="rbxassetid://107587444636945",
    pause="rbxassetid://132239189859305",
    replay="rbxassetid://110052125369932",
    close="rbxassetid://110786993356448",
    settings="rbxassetid://80758916183665",
    fileVideo="rbxassetid://81719056173960",
}

local C={
    bg=Color3.fromRGB(10,10,10),
    bg2=Color3.fromRGB(18,18,18),
    bg3=Color3.fromRGB(25,25,25),
    border=Color3.fromRGB(35,35,35),
    text=Color3.fromRGB(240,240,240),
    text2=Color3.fromRGB(160,160,160),
    accent=Color3.fromRGB(255,70,70),
    success=Color3.fromRGB(60,220,60),
    warning=Color3.fromRGB(255,200,0),
    danger=Color3.fromRGB(200,30,30),
    orange=Color3.fromRGB(255,140,0),
}

local function stroke(inst,thick,col)
    local s=Instance.new("UIStroke")
    s.Thickness=thick
    s.Color=col or C.border
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual
    s.Parent=inst
end

local function corner(inst,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=inst
end

local function tween(inst,t,props,easing)
    if not inst then return end
    easing=easing or Enum.EasingStyle.Quart
    local tw=TS:Create(inst,TweenInfo.new(t,easing,Enum.EasingDirection.Out),props)
    tw:Play()
    return tw
end

local function gradient(parent,c1,c2,rot)
    local gr=Instance.new("UIGradient")
    gr.Color=ColorSequence.new(c1,c2)
    gr.Rotation=rot or 0
    gr.Parent=parent
    return gr
end

local mainContainer=Instance.new("Frame")
mainContainer.Size=UDim2.new(0,W+24,0,H+92)
mainContainer.Position=UDim2.new(0.5,-(W+24)/2,0.5,-(H+92)/2)
mainContainer.BackgroundColor3=C.bg
mainContainer.BorderSizePixel=0
mainContainer.Active=true
mainContainer.Draggable=true
mainContainer.Parent=g
corner(mainContainer,12)
stroke(mainContainer,1.5,C.border)

local function createResizeBorder(size,pos)
    local border=Instance.new("TextButton")
    border.Size=size
    border.Position=pos
    border.BackgroundColor3=Color3.new(1,1,1)
    border.BackgroundTransparency=0.99
    border.Text=""
    border.ZIndex=100
    border.Parent=mainContainer
    return border
end

local topBorder=createResizeBorder(UDim2.new(1,0,0,6),UDim2.new(0,0,0,-3))
topBorder.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="top"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local bottomBorder=createResizeBorder(UDim2.new(1,0,0,6),UDim2.new(0,0,1,-3))
bottomBorder.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="bottom"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local leftBorder=createResizeBorder(UDim2.new(0,6,1,0),UDim2.new(0,-3,0,0))
leftBorder.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="left"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local rightBorder=createResizeBorder(UDim2.new(0,6,1,0),UDim2.new(1,-3,0,0))
rightBorder.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="right"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local function createCornerHandle(pos)
    local c=Instance.new("TextButton")
    c.Size=UDim2.new(0,10,0,10)
    c.Position=pos
    c.BackgroundColor3=Color3.new(1,1,1)
    c.BackgroundTransparency=0.95
    c.Text=""
    c.ZIndex=100
    c.Parent=mainContainer
    return c
end

local topLeft=createCornerHandle(UDim2.new(0,-5,0,-5))
topLeft.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="topleft"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local topRight=createCornerHandle(UDim2.new(1,-5,0,-5))
topRight.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="topright"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local bottomLeft=createCornerHandle(UDim2.new(0,-5,1,-5))
bottomLeft.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="bottomleft"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local bottomRight=createCornerHandle(UDim2.new(1,-5,1,-5))
bottomRight.MouseButton1Down:Connect(function()
    resizing=true
    resizeDir="bottomright"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)

local titleRow=Instance.new("Frame")
titleRow.Size=UDim2.new(1,0,0,36)
titleRow.Position=UDim2.new(0,0,0,0)
titleRow.BackgroundColor3=C.bg2
titleRow.BackgroundTransparency=0.3
titleRow.ZIndex=5
titleRow.Parent=mainContainer
corner(titleRow,12)

local titleIcon=Instance.new("ImageLabel")
titleIcon.Size=UDim2.new(0,20,0,20)
titleIcon.Position=UDim2.new(0,12,0.5,-10)
titleIcon.Image=I.fileVideo
titleIcon.BackgroundTransparency=1
titleIcon.ZIndex=6
titleIcon.Parent=titleRow

local titleLbl=Instance.new("TextLabel")
titleLbl.Size=UDim2.new(1,-170,1,0)
titleLbl.Position=UDim2.new(0,38,0,0)
titleLbl.BackgroundTransparency=1
titleLbl.Text="Video Player"
titleLbl.Font=Enum.Font.GothamBold
titleLbl.TextSize=14
titleLbl.TextColor3=C.text
titleLbl.TextXAlignment=Enum.TextXAlignment.Left
titleLbl.ZIndex=5
titleLbl.Parent=titleRow

local mediaBadge=Instance.new("ImageLabel")
mediaBadge.Size=UDim2.new(0,18,0,18)
mediaBadge.Position=UDim2.new(0,168,0.5,-9)
mediaBadge.Image=I.fileVideo
mediaBadge.BackgroundTransparency=1
mediaBadge.ZIndex=6
mediaBadge.Parent=titleRow

local contentArea=Instance.new("Frame")
contentArea.Size=UDim2.new(1,-24,1,-98)
contentArea.Position=UDim2.new(0,12,0,76)
contentArea.BackgroundColor3=C.bg2
contentArea.BorderSizePixel=0
contentArea.ClipsDescendants=true
contentArea.ZIndex=1
contentArea.Parent=mainContainer
corner(contentArea,6)
stroke(contentArea,1,C.border)

local vp=Instance.new("Frame")
vp.Size=UDim2.new(1,0,1,0)
vp.BackgroundColor3=Color3.fromRGB(12,12,35)
vp.ClipsDescendants=true
vp.ZIndex=1
vp.Parent=contentArea
corner(vp,4)
gradient(vp,Color3.fromRGB(20,20,50),Color3.fromRGB(10,10,25),45)

local mediaDisplay=Instance.new("ImageLabel")
mediaDisplay.Size=UDim2.new(1,0,1,0)
mediaDisplay.BackgroundTransparency=1
mediaDisplay.ScaleType=Enum.ScaleType.Fit
mediaDisplay.Parent=vp

local frameLbl=Instance.new("TextLabel")
frameLbl.Size=UDim2.new(1,0,1,0)
frameLbl.BackgroundTransparency=1
frameLbl.TextColor3=C.text
frameLbl.Font=Enum.Font.GothamBold
frameLbl.TextSize=22
frameLbl.Text="FRAME 1"
frameLbl.ZIndex=2
frameLbl.Parent=vp

local overlay=Instance.new("Frame")
overlay.Size=UDim2.new(1,0,1,0)
overlay.BackgroundColor3=Color3.new(0,0,0)
overlay.BackgroundTransparency=1
overlay.BorderSizePixel=0
overlay.ZIndex=10
overlay.Parent=vp

local overlayBtn=Instance.new("TextButton")
overlayBtn.Size=UDim2.new(1,0,1,0)
overlayBtn.BackgroundTransparency=1
overlayBtn.Text=""
overlayBtn.ZIndex=11
overlayBtn.Parent=vp

local playPauseBtn=Instance.new("ImageButton")
playPauseBtn.Size=UDim2.new(0,65,0,65)
playPauseBtn.Position=UDim2.new(0.5,-32,0.5,-32)
playPauseBtn.Image=I.play
playPauseBtn.BackgroundTransparency=1
playPauseBtn.ImageTransparency=1
playPauseBtn.ZIndex=12
playPauseBtn.Parent=vp

local speed2x=Instance.new("Frame")
speed2x.Size=UDim2.new(0,85,0,28)
speed2x.Position=UDim2.new(0.5,-42,0,10)
speed2x.BackgroundColor3=Color3.fromRGB(0,0,0)
speed2x.BackgroundTransparency=0.35
speed2x.BorderSizePixel=0
speed2x.ZIndex=15
speed2x.Visible=false
speed2x.Parent=vp
corner(speed2x,8)
stroke(speed2x,1,C.warning)

local speed2xT=Instance.new("TextLabel")
speed2xT.Size=UDim2.new(1,0,1,0)
speed2xT.BackgroundTransparency=1
speed2xT.Text="2x"
speed2xT.Font=Enum.Font.GothamBold
speed2xT.TextSize=13
speed2xT.TextColor3=C.warning
speed2xT.ZIndex=16
speed2xT.Parent=speed2x

local function makeHint(txt,xs,xo)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(0,90,1,0)
    f.Position=UDim2.new(xs,xo,0,0)
    f.BackgroundColor3=Color3.new(0,0,0)
    f.BackgroundTransparency=0.5
    f.BorderSizePixel=0
    f.ZIndex=13
    f.Visible=false
    f.Parent=vp
    local l=Instance.new("TextLabel")
    l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1
    l.Text=txt
    l.Font=Enum.Font.GothamBold
    l.TextSize=16
    l.TextColor3=Color3.new(1,1,1)
    l.ZIndex=14
    l.Parent=f
    return f
end

local hintB=makeHint("-5s",0,0)
local hintF=makeHint("+5s",1,-90)

local endScr=Instance.new("Frame")
endScr.Size=UDim2.new(1,0,1,0)
endScr.BackgroundColor3=Color3.new(0,0,0)
endScr.BackgroundTransparency=0.3
endScr.BorderSizePixel=0
endScr.ZIndex=20
endScr.Visible=false
endScr.Parent=vp

local replayBtn=Instance.new("ImageButton")
replayBtn.Size=UDim2.new(0,60,0,60)
replayBtn.Position=UDim2.new(0.5,-30,0.5,-44)
replayBtn.Image=I.replay
replayBtn.BackgroundTransparency=1
replayBtn.ZIndex=21
replayBtn.Parent=endScr

local endLbl=Instance.new("TextLabel")
endLbl.Size=UDim2.new(1,0,0,22)
endLbl.Position=UDim2.new(0,0,0.5,24)
endLbl.BackgroundTransparency=1
endLbl.Text="Assistir novamente"
endLbl.Font=Enum.Font.GothamBold
endLbl.TextSize=13
endLbl.TextColor3=Color3.new(1,1,1)
endLbl.ZIndex=21
endLbl.Parent=endScr

local ctrlBar=Instance.new("Frame")
ctrlBar.Size=UDim2.new(1,0,0,60)
ctrlBar.Position=UDim2.new(0,0,1,-60)
ctrlBar.BackgroundColor3=Color3.new(0,0,0)
ctrlBar.BackgroundTransparency=0.2
ctrlBar.BorderSizePixel=0
ctrlBar.ZIndex=16
ctrlBar.Visible=true
ctrlBar.Parent=vp
gradient(ctrlBar,Color3.fromRGB(0,0,0),Color3.fromRGB(25,25,25),180)

local seekHitArea=Instance.new("TextButton")
seekHitArea.Size=UDim2.new(1,-20,0,20)
seekHitArea.Position=UDim2.new(0,10,0,0)
seekHitArea.BackgroundTransparency=1
seekHitArea.Text=""
seekHitArea.ZIndex=20
seekHitArea.Parent=ctrlBar

local seekTrack=Instance.new("Frame")
seekTrack.Size=UDim2.new(1,0,0,5)
seekTrack.Position=UDim2.new(0,0,0.5,-2)
seekTrack.BackgroundColor3=Color3.fromRGB(80,80,80)
seekTrack.BorderSizePixel=0
seekTrack.ZIndex=17
seekTrack.Parent=seekHitArea
corner(seekTrack,3)

local seekFill=Instance.new("Frame")
seekFill.Size=UDim2.new(0,0,1,0)
seekFill.BackgroundColor3=C.accent
seekFill.BorderSizePixel=0
seekFill.ZIndex=18
seekFill.Parent=seekTrack
corner(seekFill,3)
gradient(seekFill,C.accent,Color3.fromRGB(255,140,140),0)

local seekKnob=Instance.new("Frame")
seekKnob.Size=UDim2.new(0,14,0,14)
seekKnob.AnchorPoint=Vector2.new(0.5,0.5)
seekKnob.Position=UDim2.new(0,0,0.5,0)
seekKnob.BackgroundColor3=C.accent
seekKnob.BorderSizePixel=0
seekKnob.ZIndex=19
seekKnob.Parent=seekTrack
corner(seekKnob,99)
stroke(seekKnob,2,Color3.fromRGB(255,120,120))

local timeLbl=Instance.new("TextLabel")
timeLbl.Size=UDim2.new(0,130,0,18)
timeLbl.Position=UDim2.new(0,10,0,22)
timeLbl.BackgroundTransparency=1
timeLbl.Text="0:00 / 0:07"
timeLbl.Font=Enum.Font.GothamBold
timeLbl.TextSize=11
timeLbl.TextColor3=C.text
timeLbl.TextXAlignment=Enum.TextXAlignment.Left
timeLbl.ZIndex=17
timeLbl.Parent=ctrlBar

local function imgBtn(img,x,sz)
    local b=Instance.new("ImageButton")
    b.Size=UDim2.new(0,sz,0,sz)
    b.Position=UDim2.new(0,x,0.5,-sz/2+12)
    b.Image=img
    b.BackgroundTransparency=1
    b.BorderSizePixel=0
    b.AutoButtonColor=true
    b.ZIndex=17
    b.Parent=ctrlBar
    return b
end

local BW=28
local GAP=8
local totalBtns=BW*5+GAP*4
local sx=math.floor((W-totalBtns)/2)

local bSkipB=imgBtn(I.skipB,sx,BW)
local bStepB=imgBtn(I.stepB,sx+(BW+GAP),BW)
local bPlay=imgBtn(I.play,sx+(BW+GAP)*2,BW+4)
local bStepF=imgBtn(I.stepF,sx+(BW+GAP)*3,BW)
local bSkipF=imgBtn(I.skipF,sx+(BW+GAP)*4,BW)

local settPanel=Instance.new("Frame")
settPanel.Size=UDim2.new(0,200,0,0)
settPanel.Position=UDim2.new(1,-212,0,38)
settPanel.BackgroundColor3=C.bg3
settPanel.BorderSizePixel=0
settPanel.ClipsDescendants=false
settPanel.ZIndex=60
settPanel.Visible=false
settPanel.Parent=mainContainer
corner(settPanel,10)
stroke(settPanel,1.5,C.border)

local stTitle=Instance.new("TextLabel")
stTitle.Size=UDim2.new(1,-16,0,28)
stTitle.Position=UDim2.new(0,8,0,6)
stTitle.BackgroundTransparency=1
stTitle.Text="Configuracoes"
stTitle.Font=Enum.Font.GothamBold
stTitle.TextSize=13
stTitle.TextColor3=C.text
stTitle.TextXAlignment=Enum.TextXAlignment.Left
stTitle.ZIndex=61
stTitle.Parent=settPanel

local sep=Instance.new("Frame")
sep.Size=UDim2.new(1,-16,0,1)
sep.Position=UDim2.new(0,8,0,36)
sep.BackgroundColor3=C.border
sep.BorderSizePixel=0
sep.ZIndex=61
sep.Parent=settPanel

local stSpeedLbl=Instance.new("TextLabel")
stSpeedLbl.Size=UDim2.new(0.5,0,0,28)
stSpeedLbl.Position=UDim2.new(0,8,0,42)
stSpeedLbl.BackgroundTransparency=1
stSpeedLbl.Text="Velocidade"
stSpeedLbl.Font=Enum.Font.Gotham
stSpeedLbl.TextSize=11
stSpeedLbl.TextColor3=C.text2
stSpeedLbl.TextXAlignment=Enum.TextXAlignment.Left
stSpeedLbl.ZIndex=61
stSpeedLbl.Parent=settPanel

local stSpeedBtn=Instance.new("TextButton")
stSpeedBtn.Size=UDim2.new(0.4,0,0,26)
stSpeedBtn.Position=UDim2.new(0.55,0,0,43)
stSpeedBtn.Text="1x"
stSpeedBtn.Font=Enum.Font.GothamBold
stSpeedBtn.TextSize=11
stSpeedBtn.BackgroundColor3=C.accent
stSpeedBtn.TextColor3=C.text
stSpeedBtn.BorderSizePixel=0
stSpeedBtn.ZIndex=61
stSpeedBtn.Parent=settPanel
corner(stSpeedBtn,6)

local speedOptions={0.25,0.5,0.75,1,1.25,1.5,2}
local OPTION_H=26
local DROPDOWN_MAX_H=#speedOptions*OPTION_H

local speedDropdown=Instance.new("ScrollingFrame")
speedDropdown.Size=UDim2.new(0.4,0,0,0)
speedDropdown.Position=UDim2.new(0.55,0,0,72)
speedDropdown.BackgroundColor3=C.bg
speedDropdown.BorderSizePixel=0
speedDropdown.ClipsDescendants=true
speedDropdown.ZIndex=62
speedDropdown.Visible=false
speedDropdown.ScrollBarThickness=4
speedDropdown.ScrollBarImageColor3=C.accent
speedDropdown.CanvasSize=UDim2.new(0,0,0,DROPDOWN_MAX_H)
speedDropdown.Parent=settPanel
corner(speedDropdown,6)
stroke(speedDropdown,1,C.border)

local function setSpeed(s,updateBtn)
    speed=s
    if s>1 then
        speed2x.Visible=true
        speed2xT.Text=s.."x"
        tween(speed2x,0.1,{BackgroundTransparency=0.25})
        if updateBtn then
            stSpeedBtn.Text=s.."x"
            stSpeedBtn.BackgroundColor3=s>=2 and C.warning or C.orange
        end
    else
        tween(speed2x,0.1,{BackgroundTransparency=1})
        task.delay(0.1,function()
            if speed<=1 then
                speed2x.Visible=false
            end
        end)
        if updateBtn then
            stSpeedBtn.Text=s.."x"
            stSpeedBtn.BackgroundColor3=C.accent
        end
    end
end

local dropdownList=Instance.new("Frame")
dropdownList.Size=UDim2.new(1,0,0,DROPDOWN_MAX_H)
dropdownList.BackgroundTransparency=1
dropdownList.Parent=speedDropdown

for i,spd in ipairs(speedOptions) do
    local opt=Instance.new("TextButton")
    opt.Size=UDim2.new(1,0,0,OPTION_H)
    opt.Position=UDim2.new(0,0,0,(i-1)*OPTION_H)
    opt.Text=spd.."x"
    opt.Font=Enum.Font.GothamBold
    opt.TextSize=11
    opt.BackgroundColor3=C.bg
    opt.TextColor3=C.text2
    opt.BorderSizePixel=0
    opt.ZIndex=63
    opt.Parent=dropdownList

    opt.MouseButton1Click:Connect(function()
        normalSpeed=spd
        setSpeed(spd,true)
        dropdownOpen=false
        tween(speedDropdown,0.15,{Size=UDim2.new(0.4,0,0,0)})
        task.delay(0.16,function() speedDropdown.Visible=false end)
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,186)})
    end)
end

local dropdownOpen=false

stSpeedBtn.MouseButton1Click:Connect(function()
    dropdownOpen=not dropdownOpen
    if dropdownOpen then
        speedDropdown.Visible=true
        speedDropdown.CanvasSize=UDim2.new(0,0,0,DROPDOWN_MAX_H)
        tween(speedDropdown,0.15,{Size=UDim2.new(0.4,0,0,DROPDOWN_MAX_H)})
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,78+DROPDOWN_MAX_H+8)})
    else
        tween(speedDropdown,0.15,{Size=UDim2.new(0.4,0,0,0)})
        task.delay(0.16,function()
            if not dropdownOpen then speedDropdown.Visible=false end
        end)
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,186)})
    end
end)

local function makeSettBtn(txt,y,col)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-16,0,30)
    b.Position=UDim2.new(0,8,0,y)
    b.Text=txt
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.BackgroundColor3=col or C.bg3
    b.TextColor3=C.text
    b.BorderSizePixel=0
    b.ZIndex=61
    b.Parent=settPanel
    corner(b,6)
    stroke(b,1,C.border)
    return b
end

local autoReplayBtn=makeSettBtn("Auto-Reproduzir: OFF",78)
local autoHideBtn=makeSettBtn("Auto-esconder: ON",114)
local settCloseBtn=makeSettBtn("Fechar",150,C.danger)
settCloseBtn.TextColor3=C.text

local function hdrBtn(img,xr,bgCol)
    local b=Instance.new("ImageButton")
    b.Size=UDim2.new(0,28,0,28)
    b.Position=UDim2.new(1,xr,0.5,-14)
    b.Image=img
    b.BackgroundColor3=bgCol or C.bg3
    b.BorderSizePixel=0
    b.AutoButtonColor=true
    b.ZIndex=6
    b.Parent=titleRow
    corner(b,6)
    stroke(b,1,C.border)
    return b
end

local closeBtn=hdrBtn(I.close,-34,C.danger)
local settBtn=hdrBtn(I.settings,-66)

local function updateKnob()
    local pct=(cur-1)/math.max(TOTAL-1,1)
    seekFill.Size=UDim2.new(pct,0,1,0)
    seekKnob.Position=UDim2.new(pct,0,0.5,0)
end

local function updateTime()
    local ts=math.floor((cur-1)*(FD/1000))
    local tot=math.floor((TOTAL-1)*(FD/1000))
    timeLbl.Text=string.format("%d:%02d / %d:%02d",math.floor(ts/60),ts%60,math.floor(tot/60),tot%60)
end

local function setFrame(n)
    cur=math.clamp(n,1,TOTAL)
    frameLbl.Text="FRAME "..cur
    updateKnob()
    updateTime()
end

local function showCtrl()
    ctrlTimer=0
    ctrlVis=true
    tween(overlay,0.1,{BackgroundTransparency=0.45})
    ctrlBar.Visible=true
    playPauseBtn.Image=(ended or not playing) and I.play or I.pause
    tween(playPauseBtn,0.1,{ImageTransparency=0})
end

local function hideCtrl()
    if ended or not autoHideEnabled then return end
    ctrlVis=false
    tween(overlay,0.15,{BackgroundTransparency=1})
    tween(playPauseBtn,0.12,{ImageTransparency=1})
    task.delay(0.15,function()
        if not ctrlVis then ctrlBar.Visible=false end
    end)
end

local function seekTo(n)
    setFrame(n)
    if ended then
        ended=false
        endScr.Visible=false
        playing=true
        bPlay.Image=I.pause
        playPauseBtn.Image=I.pause
    end
end

local function nextFrame()
    if cur<TOTAL then
        setFrame(cur+1)
    else
        playing=false
        ended=true
        bPlay.Image=I.play
        playPauseBtn.Image=I.play
        endScr.Visible=true
        ctrlBar.Visible=true
        tween(overlay,0.15,{BackgroundTransparency=0.3})
        tween(playPauseBtn,0.1,{ImageTransparency=1})
        if isSpeedBoostActive then
            setSpeed(normalSpeed,false)
            isSpeedBoostActive=false
        end
    end
end

local function skipFrames(amt,hint)
    local n=math.max(1,math.floor(math.abs(amt)/(FD/1000)))
    if amt<0 then n=-n end
    seekTo(math.clamp(cur+n,1,TOTAL))
    if hint then
        hint.Visible=true
        hint.BackgroundTransparency=0.5
        tween(hint,0.1,{BackgroundTransparency=0.3})
        task.delay(0.5,function()
            tween(hint,0.15,{BackgroundTransparency=1})
            task.delay(0.15,function() hint.Visible=false end)
        end)
    end
    ctrlTimer=0
end

local function doReplay()
    if isSpeedBoostActive then
        setSpeed(normalSpeed,false)
        isSpeedBoostActive=false
    end
    ended=false
    endScr.Visible=false
    seekTo(1)
    playing=true
    bPlay.Image=I.pause
    playPauseBtn.Image=I.pause
    lastFT=tick()
    showCtrl()
    task.delay(2.5,function()
        if playing and not ended and autoHideEnabled then hideCtrl() end
    end)
end

local function togglePlayPause()
    if ended then doReplay() return end
    playing=not playing
    bPlay.Image=playing and I.pause or I.play
    playPauseBtn.Image=playing and I.pause or I.play
    tween(playPauseBtn,0.08,{ImageTransparency=0})
    if playing then
        lastFT=tick()
        ctrlTimer=0
        if autoHideEnabled then
            task.delay(2.5,function()
                if playing and not ended and autoHideEnabled then hideCtrl() end
            end)
        end
    else
        ctrlTimer=0
        showCtrl()
    end
end

local function resizeWindow(nw,nh)
    W=math.clamp(nw,160,800)
    H=math.clamp(nh,90,600)
    local newSx=math.floor((W-totalBtns)/2)
    local btns={bSkipB,bStepB,bPlay,bStepF,bSkipF}
    mainContainer.Size=UDim2.new(0,W+24,0,H+92)
    for i,btn in ipairs(btns) do
        btn.Position=UDim2.new(0,newSx+(i-1)*(BW+GAP),0.5,-BW/2+12)
    end
end

local function toggleSett()
    settOpen=not settOpen
    settPanel.Visible=true
    if settOpen then
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,186)})
    else
        dropdownOpen=false
        speedDropdown.Visible=false
        speedDropdown.Size=UDim2.new(0.4,0,0,0)
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,0)})
        task.delay(0.17,function()
            if not settOpen then settPanel.Visible=false end
        end)
    end
end

local _frameUrls={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_2.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_14.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_19.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_30.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_35.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_65.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_82.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_sIwg4kk6ncI_1780599453_143.png"}

for i=1,TOTAL do
    local fn="px_sIwg4kk6ncI_1780599453_"..i..".png"
    if not isfile(fn) then
        writefile(fn,game:HttpGet(_frameUrls[i]))
    end
    local img=Instance.new("ImageLabel")
    img.Size=UDim2.new(1,0,1,0)
    img.Image=getcustomasset(fn)
    img.BackgroundTransparency=1
    img.Visible=(i==1)
    img.Parent=vp
end

mediaDisplay.Visible=false
frameLbl.Visible=true

overlayBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
    holding=true
    holdStart=tick()
    local relX=inp.Position.X-vp.AbsolutePosition.X
    local side=relX<vp.AbsoluteSize.X/2 and "L" or "R"
    local now=tick()
    if now-lastTap<0.3 and side==lastSide and tapCount==1 then
        tapCount=0
        lastTap=0
        if side=="R" then skipFrames(5,hintF) else skipFrames(-5,hintB) end
        showCtrl()
        return
    end
    lastTap=now
    lastSide=side
    tapCount=1
    task.delay(0.32,function()
        if tapCount==1 and now==lastTap then
            tapCount=0
            if ctrlVis then hideCtrl() else showCtrl(); ctrlTimer=0 end
        end
    end)
end)

overlayBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
    holding=false
    if isSpeedBoostActive then
        setSpeed(normalSpeed,false)
        isSpeedBoostActive=false
    end
end)

playPauseBtn.MouseButton1Click:Connect(togglePlayPause)

closeBtn.MouseButton1Click:Connect(function()
    tween(mainContainer,0.12,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)})
    task.delay(0.14,function() g:Destroy() end)
end)

settBtn.MouseButton1Click:Connect(toggleSett)
settCloseBtn.MouseButton1Click:Connect(toggleSett)

autoReplayBtn.MouseButton1Click:Connect(function()
    autoReplay=not autoReplay
    autoReplayBtn.Text=autoReplay and "Auto-Reproduzir: ON" or "Auto-Reproduzir: OFF"
    autoReplayBtn.TextColor3=autoReplay and C.success or C.text
end)

autoHideBtn.MouseButton1Click:Connect(function()
    autoHideEnabled=not autoHideEnabled
    autoHideBtn.Text=autoHideEnabled and "Auto-esconder: ON" or "Auto-esconder: OFF"
end)

seekHitArea.InputBegan:Connect(function(inp)
    if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
    dragging=true
    local pct=math.clamp((inp.Position.X-seekHitArea.AbsolutePosition.X)/seekHitArea.AbsoluteSize.X,0,1)
    seekTo(math.floor(pct*(TOTAL-1))+1)
    showCtrl()
end)

seekHitArea.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

UIS.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
    local pct=math.clamp((inp.Position.X-seekHitArea.AbsolutePosition.X)/seekHitArea.AbsoluteSize.X,0,1)
    seekTo(math.floor(pct*(TOTAL-1))+1)
end)

UIS.InputChanged:Connect(function(inp)
    if not resizing then return end
    if inp.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local currentMouse=UIS:GetMouseLocation()
    local deltaX=currentMouse.X-startMousePos.X
    local deltaY=currentMouse.Y-startMousePos.Y
    local newW,newH=startW,startH
    local newXOff,newYOff=startResizeX,startResizeY
    if resizeDir=="right" then
        newW=math.clamp(startW+deltaX,160,800)
    elseif resizeDir=="left" then
        newW=math.clamp(startW-deltaX,160,800)
        newXOff=startResizeX+(startW-newW)
    elseif resizeDir=="bottom" then
        newH=math.clamp(startH+deltaY,90,600)
    elseif resizeDir=="top" then
        newH=math.clamp(startH-deltaY,90,600)
        newYOff=startResizeY+(startH-newH)
    elseif resizeDir=="bottomright" then
        newW=math.clamp(startW+deltaX,160,800)
        newH=math.clamp(startH+deltaY,90,600)
    elseif resizeDir=="bottomleft" then
        newW=math.clamp(startW-deltaX,160,800)
        newH=math.clamp(startH+deltaY,90,600)
        newXOff=startResizeX+(startW-newW)
    elseif resizeDir=="topright" then
        newW=math.clamp(startW+deltaX,160,800)
        newH=math.clamp(startH-deltaY,90,600)
        newYOff=startResizeY+(startH-newH)
    elseif resizeDir=="topleft" then
        newW=math.clamp(startW-deltaX,160,800)
        newH=math.clamp(startH-deltaY,90,600)
        newXOff=startResizeX+(startW-newW)
        newYOff=startResizeY+(startH-newH)
    end
    if newW~=W or newH~=H then
        resizeWindow(newW,newH)
        mainContainer.Position=UDim2.new(0.5,newXOff,0.5,newYOff)
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then
        resizing=false
    end
end)

bPlay.MouseButton1Click:Connect(togglePlayPause)
bStepB.MouseButton1Click:Connect(function()
    if ended then ended=false endScr.Visible=false end
    setFrame(math.max(cur-1,1))
    showCtrl()
end)
bStepF.MouseButton1Click:Connect(function()
    nextFrame()
    showCtrl()
end)
bSkipB.MouseButton1Click:Connect(function()
    skipFrames(-5,hintB)
    showCtrl()
end)
bSkipF.MouseButton1Click:Connect(function()
    skipFrames(5,hintF)
    showCtrl()
end)
replayBtn.MouseButton1Click:Connect(doReplay)

UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.Space then
        togglePlayPause()
    elseif inp.KeyCode==Enum.KeyCode.Left then
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then
            skipFrames(-5,hintB)
        else
            setFrame(math.max(cur-1,1))
        end
        showCtrl()
    elseif inp.KeyCode==Enum.KeyCode.Right then
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then
            skipFrames(5,hintF)
        else
            nextFrame()
        end
        showCtrl()
    end
end)

lastFT=tick()
showCtrl()
updateKnob()
updateTime()
normalSpeed=1
local settOpen=false

RunService.RenderStepped:Connect(function(dt)
    local cam=workspace.CurrentCamera
    local char=p.Character
    if cam and char then
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist=(cam.CFrame.Position-hrp.Position).Magnitude
            mainContainer.Visible=dist<=15
        end
    end

    if holding and not isSpeedBoostActive and normalSpeed==1 and (tick()-holdStart)>=0.8 and playing and not ended then
        tapCount=0
        isSpeedBoostActive=true
        setSpeed(2,false)
    end

    if playing and not dragging and not ended then
        local interval=(FD/1000)/speed
        local now=tick()
        if now-lastFT>=interval then
            lastFT=now
            nextFrame()
            if ended and autoReplay then task.delay(0.2,doReplay) end
        end
        if ctrlVis and autoHideEnabled then
            ctrlTimer=ctrlTimer+dt
            if ctrlTimer>=2.5 then
                hideCtrl()
            end
        end
    end
end)