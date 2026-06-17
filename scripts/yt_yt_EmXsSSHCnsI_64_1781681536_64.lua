local VERSION = 2.0
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local p=Players.LocalPlayer
if not p then return end

local TOTAL=1480
local FD=100.0
local cur=1
local playing=false
local ended=false
local dragging=false
local speed=1
local normalSpeed=1
local ctrlVis=true
local ctrlTimer=0
local lastFT=0
local autoReplay=false
local W,H=380,214
local autoHideEnabled=true
local settOpen=false
local infoOpen=false
local loadedCount=0
local loadingDone=false

local lastTap=0
local lastSide=""
local tapCount=0
local holding=false
local holdStart=0
local isSpeedBoostActive=false

local resizing=false
local resizeDir=""
local startW,startH=0,0
local startResizeX,startResizeY=0,0
local startMousePos=nil
local dropdownOpen=false

local _au="yt_aud_yt_EmXsSSHCnsI_64_1781681536.mp3"
if not isfile(_au) then writefile(_au,game:HttpGet("https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/audio/yt_aud_yt_EmXsSSHCnsI_64_1781681536.mp3")) end
local _snd=nil
local function _stopOtherAudios()
    for _,s in pairs(workspace:GetDescendants()) do
        if s:IsA("Sound") and s.SoundId and string.find(s.SoundId, "aud_") then
            pcall(function() s:Stop() s:Destroy() end)
        end
    end
end
local function _ensureSound()
    if not _snd then
        _stopOtherAudios()
        _snd=Instance.new("Sound")
        _snd.SoundId=getcustomasset(_au)
        _snd.Volume=0.5
        _snd.Looped=false
        _snd.Parent=game.Workspace
    end
end
local function _stopAudio()
    if _snd then pcall(function() _snd:Stop() _snd.TimePosition=0 end) end
end
local function _pauseAudio()
    if _snd then pcall(function() if _snd.Playing then _snd:Pause() end end) end
end
local function _resumeAudio()
    if _snd then pcall(function() if not _snd.Playing then _snd:Resume() end end) end
end
local function _seekAudio(fn)
    if _snd then
        pcall(function()
            local t=math.max(0,(fn-1)*(100.0/1000))
            _snd.TimePosition=t
        end)
    end
end
local function _startAudio()
    _ensureSound()
    pcall(function() _snd.TimePosition=0 _snd:Play() end)
end
local function _setAudioSpeed(s)
    if _snd then pcall(function() _snd.PlaybackSpeed=s end) end
end
local _syncCounter=0
local function _syncAudioIfNeeded(fn, spd)
    if not _snd then return end
    _syncCounter=_syncCounter+1
    if _syncCounter<30 then return end
    _syncCounter=0
    pcall(function()
        if not _snd.Playing then return end
        local expected=(fn-1)*(100.0/1000)/spd
        local actual=_snd.TimePosition/spd
        local drift=math.abs(actual-expected)
        if drift>0.15 then
            _snd.TimePosition=math.max(0,(fn-1)*(100.0/1000))
        end
    end)
end

local g=Instance.new("ScreenGui")
g.Name="PixelPlayer_yt_EmXsSSHCnsI_64_1781681536"
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
    info="rbxassetid://128990089079703",
    video="rbxassetid://107587444636945",
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
    resizing=true resizeDir="top"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)
local bottomBorder=createResizeBorder(UDim2.new(1,0,0,6),UDim2.new(0,0,1,-3))
bottomBorder.MouseButton1Down:Connect(function()
    resizing=true resizeDir="bottom"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)
local leftBorder=createResizeBorder(UDim2.new(0,6,1,0),UDim2.new(0,-3,0,0))
leftBorder.MouseButton1Down:Connect(function()
    resizing=true resizeDir="left"
    startW,startH=W,H
    startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset
    startMousePos=UIS:GetMouseLocation()
end)
local rightBorder=createResizeBorder(UDim2.new(0,6,1,0),UDim2.new(1,-3,0,0))
rightBorder.MouseButton1Down:Connect(function()
    resizing=true resizeDir="right"
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
topLeft.MouseButton1Down:Connect(function() resizing=true resizeDir="topleft" startW,startH=W,H startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset startMousePos=UIS:GetMouseLocation() end)
local topRight=createCornerHandle(UDim2.new(1,-5,0,-5))
topRight.MouseButton1Down:Connect(function() resizing=true resizeDir="topright" startW,startH=W,H startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset startMousePos=UIS:GetMouseLocation() end)
local bottomLeft=createCornerHandle(UDim2.new(0,-5,1,-5))
bottomLeft.MouseButton1Down:Connect(function() resizing=true resizeDir="bottomleft" startW,startH=W,H startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset startMousePos=UIS:GetMouseLocation() end)
local bottomRight=createCornerHandle(UDim2.new(1,-5,1,-5))
bottomRight.MouseButton1Down:Connect(function() resizing=true resizeDir="bottomright" startW,startH=W,H startResizeX,startResizeY=mainContainer.Position.X.Offset,mainContainer.Position.Y.Offset startMousePos=UIS:GetMouseLocation() end)

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
titleIcon.Image=I.video
titleIcon.BackgroundTransparency=1
titleIcon.ZIndex=6
titleIcon.Parent=titleRow

local titleLbl=Instance.new("TextLabel")
titleLbl.Size=UDim2.new(1,-200,1,0)
titleLbl.Position=UDim2.new(0,38,0,0)
titleLbl.BackgroundTransparency=1
titleLbl.Text="Morse Code Tracing" ~= "" and "Morse Code Tracing" or "Video Player"
titleLbl.Font=Enum.Font.GothamBold
titleLbl.TextSize=13
titleLbl.TextColor3=C.text
titleLbl.TextXAlignment=Enum.TextXAlignment.Left
titleLbl.TextTruncate=Enum.TextTruncate.AtEnd
titleLbl.ZIndex=5
titleLbl.Parent=titleRow

local contentArea=Instance.new("Frame")
contentArea.Size=UDim2.new(1,-24,1,-98)
contentArea.Position=UDim2.new(0,12,0,44)
contentArea.BackgroundColor3=C.bg2
contentArea.BorderSizePixel=0
contentArea.ClipsDescendants=true
contentArea.ZIndex=1
contentArea.Parent=mainContainer
corner(contentArea,6)
stroke(contentArea,1,C.border)

local vp=Instance.new("Frame")
vp.Size=UDim2.new(1,0,1,0)
vp.BackgroundColor3=Color3.fromRGB(0,0,0)
vp.ClipsDescendants=true
vp.ZIndex=1
vp.Parent=contentArea
corner(vp,4)

local _frameUrls={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_147.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_148.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_149.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_150.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_151.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_152.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_153.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_154.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_155.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_156.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_157.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_158.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_159.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_160.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_161.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_162.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_163.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_164.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_165.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_166.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_167.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_168.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_170.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_171.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_172.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_173.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_174.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_175.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_176.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_177.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_178.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_179.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_181.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_182.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_183.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_184.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_185.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_186.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_187.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_188.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_189.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_190.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_191.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_192.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_193.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_194.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_195.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_196.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_197.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_198.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_199.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_200.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_201.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_202.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_203.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_204.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_205.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_206.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_207.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_208.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_209.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_211.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_212.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_213.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_214.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_215.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_216.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_217.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_218.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_219.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_221.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_222.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_223.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_224.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_225.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_226.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_227.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_228.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_230.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_231.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_232.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_233.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_234.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_235.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_236.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_237.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_239.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_240.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_241.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_242.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_243.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_244.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_245.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_246.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_247.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_248.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_249.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_250.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_251.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_252.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_253.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_255.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_256.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_257.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_258.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_259.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_260.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_261.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_262.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_263.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_264.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_265.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_266.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_267.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_268.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_269.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_270.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_271.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_272.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_273.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_274.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_275.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_276.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_277.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_278.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_279.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_280.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_281.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_282.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_283.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_284.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_285.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_287.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_288.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_289.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_290.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_291.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_292.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_293.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_294.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_295.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_296.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_297.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_298.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_299.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_300.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_301.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_302.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_303.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_304.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_305.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_306.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_307.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_308.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_309.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_310.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_311.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_312.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_313.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_314.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_315.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_316.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_317.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_318.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_319.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_320.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_321.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_322.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_323.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_324.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_325.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_326.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_327.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_328.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_329.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_330.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_331.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_332.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_333.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_334.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_335.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_337.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_338.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_339.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_340.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_341.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_342.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_343.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_344.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_345.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_346.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_348.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_349.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_350.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_351.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_352.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_353.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_354.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_355.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_356.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_357.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_358.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_360.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_361.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_362.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_363.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_364.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_365.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_366.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_367.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_368.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_369.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_370.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_371.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_372.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_373.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_374.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_375.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_376.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_377.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_378.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_379.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_381.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_382.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_383.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_384.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_386.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_387.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_388.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_389.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_390.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_391.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_392.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_393.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_394.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_395.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_396.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_397.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_398.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_399.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_401.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_402.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_403.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_404.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_405.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_406.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_407.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_408.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_409.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_410.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_411.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_412.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_413.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_415.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_416.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_417.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_418.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_419.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_420.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_421.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_422.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_423.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_424.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_425.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_426.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_427.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_428.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_429.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_430.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_431.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_432.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_433.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_434.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_435.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_436.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_437.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_439.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_440.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_441.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_442.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_443.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_444.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_445.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_446.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_447.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_448.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_449.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_450.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_451.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_452.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_453.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_454.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_455.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_456.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_457.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_458.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_460.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_461.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_462.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_463.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_464.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_465.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_466.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_467.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_468.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_469.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_470.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_471.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_472.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_473.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_475.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_476.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_477.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_478.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_479.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_481.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_482.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_483.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_484.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_485.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_486.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_487.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_488.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_489.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_490.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_491.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_493.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_494.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_495.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_496.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_497.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_498.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_499.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_500.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_501.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_502.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_503.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_504.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_505.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_506.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_507.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_508.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_509.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_510.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_511.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_512.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_513.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_515.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_516.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_517.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_518.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_519.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_520.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_521.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_522.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_523.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_524.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_525.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_527.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_528.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_529.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_530.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_531.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_532.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_533.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_534.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_535.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_536.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_537.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_538.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_539.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_540.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_541.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_542.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_543.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_545.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_546.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_547.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_548.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_549.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_550.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_551.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_552.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_554.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_555.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_556.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_557.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_558.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_559.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_560.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_561.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_563.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_564.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_565.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_566.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_567.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_568.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_569.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_571.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_572.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_573.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_575.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_576.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_577.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_578.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_579.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_580.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_581.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_582.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_583.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_584.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_585.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_586.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_587.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_588.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_589.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_590.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_591.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_592.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_593.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_594.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_595.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_596.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_598.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_599.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_600.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_601.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_602.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_603.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_604.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_605.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_606.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_607.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_608.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_609.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_610.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_611.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_613.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_614.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_615.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_616.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_617.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_618.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_619.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_620.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_621.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_622.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_623.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_624.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_625.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_626.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_627.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_628.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_629.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_630.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_631.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_632.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_633.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_634.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_635.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_636.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_637.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_638.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_639.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_640.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_641.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_642.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_643.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_644.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_645.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_646.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_647.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_648.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_649.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_650.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_651.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_652.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_653.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_655.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_656.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_657.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_658.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_659.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_660.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_661.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_662.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_663.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_664.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_665.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_666.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_667.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_668.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_669.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_670.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_671.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_672.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_674.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_675.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_676.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_677.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_678.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_679.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_680.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_681.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_682.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_683.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_684.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_686.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_687.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_688.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_689.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_690.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_691.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_692.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_693.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_694.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_695.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_696.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_697.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_698.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_699.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_700.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_701.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_702.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_703.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_704.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_705.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_706.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_707.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_708.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_709.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_710.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_711.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_712.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_713.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_714.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_715.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_716.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_717.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_719.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_720.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_721.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_722.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_723.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_724.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_725.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_726.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_727.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_728.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_729.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_730.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_731.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_732.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_734.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_735.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_736.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_737.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_738.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_739.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_740.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_741.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_742.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_743.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_744.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_745.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_746.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_747.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_749.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_750.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_751.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_752.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_753.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_754.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_755.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_756.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_757.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_758.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_759.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_760.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_761.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_762.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_763.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_764.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_765.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_766.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_767.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_768.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_769.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_770.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_771.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_772.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_773.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_774.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_775.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_776.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_777.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_778.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_779.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_780.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_781.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_782.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_783.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_784.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_785.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_786.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_787.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_788.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_789.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_790.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_791.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_792.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_793.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_794.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_797.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_798.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_799.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_800.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_801.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_802.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_803.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_804.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_805.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_806.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_807.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_808.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_809.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_810.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_811.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_812.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_813.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_814.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_816.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_817.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_818.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_819.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_820.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_821.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_822.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_823.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_824.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_825.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_826.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_827.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_828.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_829.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_830.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_831.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_832.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_834.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_835.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_836.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_837.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_839.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_840.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_841.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_842.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_843.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_844.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_845.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_846.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_847.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_848.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_849.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_850.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_851.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_852.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_853.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_854.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_855.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_856.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_857.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_858.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_859.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_860.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_861.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_862.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_863.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_864.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_865.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_866.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_867.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_868.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_869.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_870.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_871.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_872.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_873.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_875.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_876.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_877.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_878.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_879.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_880.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_881.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_882.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_883.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_884.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_885.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_886.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_887.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_888.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_889.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_890.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_891.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_892.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_894.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_895.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_896.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_897.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_898.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_899.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_900.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_901.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_902.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_903.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_904.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_905.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_906.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_908.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_909.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_910.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_912.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_913.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_914.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_915.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_916.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_917.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_918.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_919.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_921.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_922.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_923.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_924.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_925.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_926.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_927.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_928.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_929.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_930.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_931.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_932.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_933.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_934.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_935.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_936.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_937.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_938.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_939.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_940.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_941.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_942.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_943.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_944.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_945.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_946.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_947.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_948.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_949.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_950.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_951.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_952.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_953.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_954.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_955.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_956.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_957.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_958.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_959.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_961.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_962.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_963.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_964.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_966.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_967.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_968.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_969.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_970.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_971.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_972.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_973.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_974.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_975.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_976.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_977.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_978.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_979.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_980.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_981.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_982.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_983.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_984.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_985.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_986.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_987.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_988.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_989.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_990.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_992.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_993.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_994.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_995.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_996.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_997.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_998.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_999.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1000.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1001.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1002.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1003.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1004.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1005.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1006.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1007.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1009.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1010.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1011.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1012.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1013.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1014.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1015.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1016.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1017.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1018.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1019.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1020.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1021.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1022.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1023.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1024.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1025.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1026.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1027.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1028.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1029.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1030.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1031.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1032.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1033.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1034.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1035.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1036.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1037.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1038.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1040.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1041.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1042.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1043.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1044.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1045.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1046.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1047.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1048.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1049.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1050.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1051.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1052.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1053.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1054.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1055.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1056.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1057.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1058.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1059.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1060.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1061.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1062.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1063.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1064.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1065.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1066.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1067.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1068.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1069.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1070.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1071.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1072.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1073.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1074.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1075.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1076.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1077.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1078.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1079.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1080.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1081.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1082.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1083.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1084.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1085.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1086.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1087.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1088.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1089.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1091.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1092.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1093.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1094.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1095.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1096.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1097.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1098.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1099.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1147.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1148.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1149.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1150.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1151.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1152.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1153.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1154.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1155.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1156.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1157.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1158.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1159.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1160.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1161.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1162.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1163.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1164.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1166.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1167.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1168.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1169.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1170.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1171.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1172.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1173.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1174.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1175.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1176.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1177.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1178.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1179.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1180.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1181.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1182.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1183.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1184.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1185.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1187.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1188.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1189.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1190.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1191.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1192.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1193.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1194.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1195.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1196.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1197.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1198.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1199.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1200.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1201.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1202.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1203.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1204.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1205.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1206.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1207.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1208.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1209.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1210.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1211.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1212.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1213.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1214.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1215.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1216.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1217.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1218.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1219.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1220.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1221.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1222.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1223.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1224.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1225.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1226.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1227.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1228.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1229.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1230.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1231.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1232.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1233.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1234.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1235.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1236.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1237.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1238.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1239.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1240.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1241.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1242.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1243.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1244.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1245.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1246.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1247.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1248.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1249.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1250.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1251.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1252.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1253.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1255.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1256.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1257.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1258.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1259.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1260.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1261.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1262.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1263.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1264.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1265.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1266.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1267.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1268.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1269.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1270.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1271.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1272.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1273.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1274.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1275.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1276.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1277.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1278.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1279.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1280.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1281.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1283.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1284.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1285.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1286.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1287.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1288.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1289.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1290.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1291.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1292.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1293.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1295.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1296.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1297.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1298.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1299.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1300.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1301.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1302.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1303.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1304.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1305.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1306.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1307.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1308.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1309.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1310.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1311.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1312.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1313.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1314.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1315.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1316.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1317.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1318.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1319.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1320.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1321.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1322.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1323.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1325.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1326.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1327.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1328.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1329.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1330.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1331.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1332.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1333.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1334.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1335.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1336.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1337.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1338.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1339.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1340.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1341.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1342.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1343.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1344.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1345.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1346.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1347.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1348.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1349.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1350.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1351.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1352.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1353.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1354.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1355.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1356.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1357.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1358.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1359.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1360.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1361.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1362.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1363.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1364.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1365.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1367.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1368.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1369.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1370.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1371.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1372.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1373.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1374.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1375.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1376.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1377.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1378.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1379.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1380.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1381.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1382.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1383.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1384.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1385.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1386.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1387.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1388.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1389.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1390.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1392.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1393.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1394.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1395.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1396.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1397.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1398.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1399.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1400.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1401.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1402.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1403.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1404.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1405.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1406.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1407.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1408.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1409.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1410.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1411.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1412.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1413.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1414.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1415.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1416.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1417.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1418.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1419.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1420.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1421.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1422.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1423.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1424.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1425.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1426.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1427.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1428.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1429.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1430.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1431.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1432.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1434.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1435.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1436.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1438.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1439.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1440.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1441.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1442.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1443.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1444.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1445.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1446.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1447.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1449.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1450.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1451.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1452.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1453.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1454.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1456.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1457.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1458.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1459.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1460.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1461.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1462.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1463.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1464.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1465.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1466.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1467.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1468.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1469.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1470.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1471.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1472.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1473.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1474.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1475.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1476.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1477.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1478.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1479.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1480.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1481.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1482.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1483.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1484.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1485.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1486.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1488.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1489.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1490.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1491.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1492.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1493.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1494.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1495.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1497.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1498.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1499.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1500.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1501.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1502.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1503.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1504.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1505.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1506.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1507.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1508.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1509.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1510.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1511.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1512.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1513.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1514.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1515.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1516.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1517.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1518.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1519.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1520.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1521.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1522.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1523.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1524.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1525.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1526.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1527.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1528.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1529.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1530.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1531.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1532.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1533.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1535.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1536.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1537.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1538.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1539.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1540.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1541.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1542.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1543.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1544.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1545.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1546.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1547.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1548.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1549.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1550.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1551.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1552.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1553.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1554.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1555.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1556.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1557.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_yt_EmXsSSHCnsI_64_1781681536_1558.png"}
local _images={}
local _loadedFlags={}

local loadingBg=Instance.new("Frame")
loadingBg.Size=UDim2.new(1,0,1,0)
loadingBg.BackgroundColor3=Color3.fromRGB(10,10,10)
loadingBg.BackgroundTransparency=0
loadingBg.BorderSizePixel=0
loadingBg.ZIndex=49
loadingBg.Parent=vp

local loadingLbl=Instance.new("TextLabel")
loadingLbl.Size=UDim2.new(1,0,0,28)
loadingLbl.Position=UDim2.new(0,0,0.5,-30)
loadingLbl.BackgroundTransparency=1
loadingLbl.Text="Carregando... 0/1480"
loadingLbl.Font=Enum.Font.GothamBold
loadingLbl.TextSize=16
loadingLbl.TextColor3=Color3.fromRGB(200,200,200)
loadingLbl.ZIndex=50
loadingLbl.Parent=vp

local loadingBarBg=Instance.new("Frame")
loadingBarBg.Size=UDim2.new(0.8,0,0,6)
loadingBarBg.Position=UDim2.new(0.1,0,0.5,10)
loadingBarBg.BackgroundColor3=Color3.fromRGB(40,40,40)
loadingBarBg.BorderSizePixel=0
loadingBarBg.ZIndex=50
loadingBarBg.Parent=vp
corner(loadingBarBg,3)

local loadingBarFill=Instance.new("Frame")
loadingBarFill.Size=UDim2.new(0,0,1,0)
loadingBarFill.BackgroundColor3=Color3.fromRGB(255,70,70)
loadingBarFill.BorderSizePixel=0
loadingBarFill.ZIndex=51
loadingBarFill.Parent=loadingBarBg
corner(loadingBarFill,3)

task.spawn(function()
    for i=1,TOTAL do
        local ok,err=pcall(function()
            local fn="px_yt_EmXsSSHCnsI_64_1781681536_"..i..".png"
            if not isfile(fn) then
                local data=game:HttpGet(_frameUrls[i])
                writefile(fn,data)
            end
            local img=Instance.new("ImageLabel")
            img.Size=UDim2.new(1,0,1,0)
            img.Image=getcustomasset(fn)
            img.ScaleType=Enum.ScaleType.Fit
            img.BackgroundTransparency=1
            img.Visible=false
            img.ZIndex=2
            img.Parent=vp
            _images[i]=img
            _loadedFlags[i]=true
            loadedCount=loadedCount+1
        end)
        if not ok then
            warn("Erro no frame "..i..": "..tostring(err))
            loadedCount=loadedCount+1
        end
        loadingLbl.Text="Carregando... "..loadedCount.."/1480"
        loadingBarFill.Size=UDim2.new(loadedCount/TOTAL,0,1,0)
        task.wait()
    end
    loadingDone=true
    loadingBg.Visible=false
    loadingLbl.Visible=false
    loadingBarBg.Visible=false
    if _images[1] then _images[1].Visible=true end
    playing=true
    lastFT=tick()
    _startAudio()
end)

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
playPauseBtn.Image=I.pause
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

local seekLoaded=Instance.new("Frame")
seekLoaded.Size=UDim2.new(0,0,1,0)
seekLoaded.BackgroundColor3=Color3.fromRGB(100,100,100)
seekLoaded.BackgroundTransparency=0.5
seekLoaded.BorderSizePixel=0
seekLoaded.ZIndex=17
seekLoaded.Parent=seekTrack
corner(seekLoaded,3)

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
timeLbl.Text="0:00 / 0:00"
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
local bPlay=imgBtn(I.pause,sx+(BW+GAP)*2,BW+4)
local bStepF=imgBtn(I.stepF,sx+(BW+GAP)*3,BW)
local bSkipF=imgBtn(I.skipF,sx+(BW+GAP)*4,BW)

local infoPanel=Instance.new("Frame")
infoPanel.Size=UDim2.new(0,320,0,0)
infoPanel.Position=UDim2.new(0,12,0,38)
infoPanel.BackgroundColor3=C.bg3
infoPanel.BorderSizePixel=0
infoPanel.ClipsDescendants=true
infoPanel.ZIndex=70
infoPanel.Visible=false
infoPanel.Parent=mainContainer
corner(infoPanel,10)
stroke(infoPanel,1.5,C.border)

local infoScroll=Instance.new("ScrollingFrame")
infoScroll.Size=UDim2.new(1,-4,1,-4)
infoScroll.Position=UDim2.new(0,2,0,2)
infoScroll.BackgroundTransparency=1
infoScroll.BorderSizePixel=0
infoScroll.ScrollBarThickness=4
infoScroll.ScrollBarImageColor3=C.accent
infoScroll.CanvasSize=UDim2.new(0,0,0,0)
infoScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
infoScroll.ZIndex=71
infoScroll.Parent=infoPanel

local infoLayout=Instance.new("UIListLayout")
infoLayout.SortOrder=Enum.SortOrder.LayoutOrder
infoLayout.Padding=UDim.new(0,6)
infoLayout.Parent=infoScroll

local infoPad=Instance.new("UIPadding")
infoPad.PaddingLeft=UDim.new(0,10)
infoPad.PaddingRight=UDim.new(0,10)
infoPad.PaddingTop=UDim.new(0,8)
infoPad.PaddingBottom=UDim.new(0,8)
infoPad.Parent=infoScroll

local function addInfoSection(labelTxt, bodyTxt, order)
    if bodyTxt=="" then return end
    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,0,0,18)
    lbl.BackgroundTransparency=1
    lbl.Text=labelTxt
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=11
    lbl.TextColor3=C.accent
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.ZIndex=72
    lbl.LayoutOrder=order
    lbl.Parent=infoScroll
    local body=Instance.new("TextLabel")
    body.Size=UDim2.new(1,0,0,0)
    body.AutomaticSize=Enum.AutomaticSize.Y
    body.BackgroundTransparency=1
    body.Text=bodyTxt
    body.Font=Enum.Font.Gotham
    body.TextSize=11
    body.TextColor3=C.text
    body.TextXAlignment=Enum.TextXAlignment.Left
    body.TextWrapped=true
    body.ZIndex=72
    body.LayoutOrder=order+1
    body.Parent=infoScroll
end

local _vTitle="Morse Code Tracing"
local _vDesc="This is one of two methods I have found to be very helpful for learning morse code.  Please check out both video lessons.\n\nHere is a link to the second video in this series:  https://youtu.be/SNaHv3byzw0"
local _comments={
    {author="@rocksalt636",text="“I bet E is going to be 3 dashes” is a single dot “o-oh okay...”",likes=54000},
    {author="@fahoudey",text="It was a smart decision to allocate it a single dot  Morse code was crafted like this based on the frequency of letters ",likes=4600},
    {author="@caula1815",text="@fahoudey  EEEE",likes=67},
    {author="@Edgybubbles1270",text="@caula1815 😂",likes=2},
    {author="@archelcalinawan4330",text="@Edgybubbles1270….",likes=0},
    {author="@g_u_m_m_y_s_h_a_r_k",text="@fahoudey  Same with T, thats why its just a dash",likes=32},
    {author="@Avii.aator.loll.editss",text="@f @fahoudey nd michael made it be one - because he did a vid “the kid who always starts with the letter a starts yappin",likes=2},
    {author="@ATERAH",text="@fahoudey  Oh makes sense",likes=17},
    {author="@zoolkhan",text="@fahoudey  true this",likes=0},
    {author="@jarthejar9816",text="@fahoudey  like  for example fucked up?",likes=0},
    {author="@spicyyakisoba_",text="@fahoudey  is E the most used word in this comment?",likes=0},
    {author="@guilhermeplays5270",text="@fahoudey  In portuguese, A is the most used",likes=0},
    {author="@NalanzFCroadsaviationetc",text="​ @guilhermeplays5270  Yes.",likes=1},
    {author="@wheatleythe_bigmoron_1179",text="@fahoudey  English pls",likes=0},
    {author="@garf5484",text="@fahoudey  I bet a can make up a sentence without the letter E",likes=0},
    {author="@notareallin620",text="@fahoudey  That... makes a lot of sense!",likes=0},
    {author="@shiroitaka5948",text="@fahoudey  Das sum big brain shiz right there",likes=0},
    {author="@scaredy-cat4404",text="@fahoudey  i think i saw that one on the \"zodiac\" movie",likes=0},
    {author="@tunedoesstuff",text="@fahoudey  I thought the most used letter was a",likes=0},
    {author="@nekolir1499",text="@fahoudey  actually t is the most used letter",likes=0}
}

if _vTitle~="" then addInfoSection("TITULO",_vTitle,1) end
if _vDesc~="" then addInfoSection("DESCRICAO",_vDesc,3) end

if #_comments>0 then
    local sepLbl=Instance.new("TextLabel")
    sepLbl.Size=UDim2.new(1,0,0,18)
    sepLbl.BackgroundTransparency=1
    sepLbl.Text="COMENTARIOS ("..#_comments..")"
    sepLbl.Font=Enum.Font.GothamBold
    sepLbl.TextSize=11
    sepLbl.TextColor3=C.accent
    sepLbl.TextXAlignment=Enum.TextXAlignment.Left
    sepLbl.ZIndex=72
    sepLbl.LayoutOrder=5
    sepLbl.Parent=infoScroll
    for ci,cm in ipairs(_comments) do
        local cFrame=Instance.new("Frame")
        cFrame.Size=UDim2.new(1,0,0,0)
        cFrame.AutomaticSize=Enum.AutomaticSize.Y
        cFrame.BackgroundColor3=C.bg2
        cFrame.BorderSizePixel=0
        cFrame.ZIndex=72
        cFrame.LayoutOrder=5+ci
        cFrame.Parent=infoScroll
        corner(cFrame,6)
        local cPad=Instance.new("UIPadding")
        cPad.PaddingLeft=UDim.new(0,8) cPad.PaddingRight=UDim.new(0,8)
        cPad.PaddingTop=UDim.new(0,5) cPad.PaddingBottom=UDim.new(0,5)
        cPad.Parent=cFrame
        local cLayout=Instance.new("UIListLayout")
        cLayout.SortOrder=Enum.SortOrder.LayoutOrder
        cLayout.Padding=UDim.new(0,2)
        cLayout.Parent=cFrame
        local cAuthor=Instance.new("TextLabel")
        cAuthor.Size=UDim2.new(1,0,0,14)
        cAuthor.BackgroundTransparency=1
        cAuthor.Text=cm.author..(cm.likes>0 and " · "..cm.likes.." likes" or "")
        cAuthor.Font=Enum.Font.GothamBold
        cAuthor.TextSize=10
        cAuthor.TextColor3=C.text2
        cAuthor.TextXAlignment=Enum.TextXAlignment.Left
        cAuthor.ZIndex=73
        cAuthor.LayoutOrder=1
        cAuthor.Parent=cFrame
        local cText=Instance.new("TextLabel")
        cText.Size=UDim2.new(1,0,0,0)
        cText.AutomaticSize=Enum.AutomaticSize.Y
        cText.BackgroundTransparency=1
        cText.Text=cm.text
        cText.Font=Enum.Font.Gotham
        cText.TextSize=11
        cText.TextColor3=C.text
        cText.TextXAlignment=Enum.TextXAlignment.Left
        cText.TextWrapped=true
        cText.ZIndex=73
        cText.LayoutOrder=2
        cText.Parent=cFrame
    end
end

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
    _setAudioSpeed(s)
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
            if speed<=1 then speed2x.Visible=false end
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
local infoBtn=hdrBtn(I.info,-100)
infoBtn.Visible=true

local function setFrame(n)
    if not _loadedFlags[n] then return end
    local prev=cur
    cur=math.clamp(n,1,TOTAL)
    if _images[prev] then _images[prev].Visible=false end
    if _images[cur] then _images[cur].Visible=true end
    local pct=(cur-1)/math.max(TOTAL-1,1)
    seekFill.Size=UDim2.new(pct,0,1,0)
    seekKnob.Position=UDim2.new(pct,0,0.5,0)
    local ts=math.floor((cur-1)*(FD/1000))
    local tot=math.floor((TOTAL-1)*(FD/1000))
    timeLbl.Text=string.format("%d:%02d / %d:%02d",math.floor(ts/60),ts%60,math.floor(tot/60),tot%60)
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
    local target=math.clamp(n,1,TOTAL)
    if not _loadedFlags[target] then
        local best=target
        for k=target,1,-1 do
            if _loadedFlags[k] then best=k break end
        end
        target=best
    end
    setFrame(target)
    _seekAudio(target)
    if ended then
        ended=false
        endScr.Visible=false
        playing=true
        bPlay.Image=I.pause
        playPauseBtn.Image=I.pause
    end
end

local function nextFrame()
    local next=cur+1
    if next>TOTAL then
        playing=false
        ended=true
        bPlay.Image=I.play
        playPauseBtn.Image=I.play
        endScr.Visible=true
        ctrlBar.Visible=true
        tween(overlay,0.15,{BackgroundTransparency=0.3})
        tween(playPauseBtn,0.1,{ImageTransparency=1})
        _stopAudio()
        if isSpeedBoostActive then
            setSpeed(normalSpeed,false)
            isSpeedBoostActive=false
        end
        return
    end
    if not _loadedFlags[next] then return end
    setFrame(next)
    _syncAudioIfNeeded(next, speed)
end

local function skipFrames(amt,hint)
    local n=math.max(1,math.floor(math.abs(amt)/(FD/1000)))
    if amt<0 then n=-n end
    local target=math.clamp(cur+n,1,TOTAL)
    if not _loadedFlags[target] then
        local best=target
        for k=target,1,-1 do
            if _loadedFlags[k] then best=k break end
        end
        target=best
    end
    seekTo(target)
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
    _startAudio()
    showCtrl()
    task.delay(2.5,function()
        if playing and not ended and autoHideEnabled then hideCtrl() end
    end)
end

local function togglePlayPause()
    if not loadingDone then return end
    if ended then doReplay() return end
    playing=not playing
    bPlay.Image=playing and I.pause or I.play
    playPauseBtn.Image=playing and I.pause or I.play
    tween(playPauseBtn,0.08,{ImageTransparency=0})
    if playing then
        lastFT=tick()
        ctrlTimer=0
        _resumeAudio()
        if autoHideEnabled then
            task.delay(2.5,function()
                if playing and not ended and autoHideEnabled then hideCtrl() end
            end)
        end
    else
        ctrlTimer=0
        _pauseAudio()
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
    if infoOpen then
        infoOpen=false
        tween(infoPanel,0.15,{Size=UDim2.new(0,320,0,0)})
        task.delay(0.16,function() infoPanel.Visible=false end)
    end
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

local function toggleInfo()
    infoOpen=not infoOpen
    if settOpen then
        settOpen=false
        dropdownOpen=false
        speedDropdown.Visible=false
        speedDropdown.Size=UDim2.new(0.4,0,0,0)
        tween(settPanel,0.15,{Size=UDim2.new(0,200,0,0)})
        task.delay(0.17,function() settPanel.Visible=false end)
    end
    infoPanel.Visible=true
    if infoOpen then
        tween(infoPanel,0.15,{Size=UDim2.new(0,320,0,280)})
    else
        tween(infoPanel,0.15,{Size=UDim2.new(0,320,0,0)})
        task.delay(0.16,function()
            if not infoOpen then infoPanel.Visible=false end
        end)
    end
end

overlayBtn.InputBegan:Connect(function(inp)
    if not loadingDone then return end
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
            if ctrlVis then hideCtrl() else showCtrl() ctrlTimer=0 end
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
    _stopAudio()
    tween(mainContainer,0.12,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)})
    task.delay(0.14,function() g:Destroy() end)
end)
settBtn.MouseButton1Click:Connect(toggleSett)
infoBtn.MouseButton1Click:Connect(toggleInfo)
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
    if not loadingDone then return end
    if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
    dragging=true
    local pct=math.clamp((inp.Position.X-seekHitArea.AbsolutePosition.X)/seekHitArea.AbsoluteSize.X,0,1)
    local target=math.floor(pct*(TOTAL-1))+1
    seekTo(target)
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
    local target=math.floor(pct*(TOTAL-1))+1
    seekTo(target)
end)

UIS.InputChanged:Connect(function(inp)
    if not resizing then return end
    if inp.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local currentMouse=UIS:GetMouseLocation()
    local deltaX=currentMouse.X-startMousePos.X
    local deltaY=currentMouse.Y-startMousePos.Y
    local newW,newH=startW,startH
    local newXOff,newYOff=startResizeX,startResizeY
    if resizeDir=="right" then newW=math.clamp(startW+deltaX,160,800)
    elseif resizeDir=="left" then newW=math.clamp(startW-deltaX,160,800) newXOff=startResizeX+(startW-newW)
    elseif resizeDir=="bottom" then newH=math.clamp(startH+deltaY,90,600)
    elseif resizeDir=="top" then newH=math.clamp(startH-deltaY,90,600) newYOff=startResizeY+(startH-newH)
    elseif resizeDir=="bottomright" then newW=math.clamp(startW+deltaX,160,800) newH=math.clamp(startH+deltaY,90,600)
    elseif resizeDir=="bottomleft" then newW=math.clamp(startW-deltaX,160,800) newH=math.clamp(startH+deltaY,90,600) newXOff=startResizeX+(startW-newW)
    elseif resizeDir=="topright" then newW=math.clamp(startW+deltaX,160,800) newH=math.clamp(startH-deltaY,90,600) newYOff=startResizeY+(startH-newH)
    elseif resizeDir=="topleft" then newW=math.clamp(startW-deltaX,160,800) newH=math.clamp(startH-deltaY,90,600) newXOff=startResizeX+(startW-newW) newYOff=startResizeY+(startH-newH)
    end
    if newW~=W or newH~=H then
        resizeWindow(newW,newH)
        mainContainer.Position=UDim2.new(0.5,newXOff,0.5,newYOff)
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then resizing=false end
end)

bPlay.MouseButton1Click:Connect(togglePlayPause)
bStepB.MouseButton1Click:Connect(function()
    if not loadingDone then return end
    if ended then ended=false endScr.Visible=false end
    local target=math.max(cur-1,1)
    if _loadedFlags[target] then
        setFrame(target)
        _seekAudio(target)
    end
    showCtrl()
end)
bStepF.MouseButton1Click:Connect(function()
    if not loadingDone then return end
    if _loadedFlags[cur+1] then
        nextFrame()
    end
    showCtrl()
end)
bSkipB.MouseButton1Click:Connect(function()
    if not loadingDone then return end
    skipFrames(-5,hintB) showCtrl()
end)
bSkipF.MouseButton1Click:Connect(function()
    if not loadingDone then return end
    skipFrames(5,hintF) showCtrl()
end)
replayBtn.MouseButton1Click:Connect(doReplay)

UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if not loadingDone then return end
    if inp.KeyCode==Enum.KeyCode.Space then togglePlayPause()
    elseif inp.KeyCode==Enum.KeyCode.Left then
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then skipFrames(-5,hintB) else
            local target=math.max(cur-1,1)
            if _loadedFlags[target] then setFrame(target) _seekAudio(target) end
        end
        showCtrl()
    elseif inp.KeyCode==Enum.KeyCode.Right then
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then skipFrames(5,hintF) else
            if _loadedFlags[cur+1] then nextFrame() end
        end
        showCtrl()
    end
end)

lastFT=tick()
showCtrl()

RunService.RenderStepped:Connect(function(dt)
    if not loadingDone then
        local pct=loadedCount/TOTAL
        seekLoaded.Size=UDim2.new(pct,0,1,0)
    end

    if holding and not isSpeedBoostActive and normalSpeed==1 and (tick()-holdStart)>=0.8 and playing and not ended and loadingDone then
        tapCount=0
        isSpeedBoostActive=true
        setSpeed(2,false)
    end

    if playing and not dragging and not ended and loadingDone then
        local interval=(FD/1000)/speed
        local now=tick()
        if now-lastFT>=interval then
            lastFT=now
            nextFrame()
            if ended and autoReplay then task.delay(0.2,doReplay) end
        end
        if ctrlVis and autoHideEnabled then
            ctrlTimer=ctrlTimer+dt
            if ctrlTimer>=2.5 then hideCtrl() end
        end
    end
end)