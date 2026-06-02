local Players=game:GetService"Players"
local RunService=game:GetService"RunService"
local UserInputService=game:GetService"UserInputService"
local p=Players.LocalPlayer
if not p then return end
local g=Instance.new"ScreenGui"
g.Name="PixelPlayer_17d5443f4d0f"
g.ResetOnSpawn=false
g.IgnoreGuiInset=true
g.Parent=p:WaitForChild"PlayerGui"
local W,H=256,256
local bg=Instance.new"Frame"
bg.Size=UDim2.new(0,W+20,0,H+80)
bg.Position=UDim2.new(0.5,-(W+20)/2,0.5,-(H+80)/2)
bg.BackgroundColor3=Color3.fromRGB(10,10,10)
bg.BorderSizePixel=0
bg.Active=true
bg.Draggable=true
bg.Parent=g
local corner=Instance.new"UICorner"
corner.CornerRadius=UDim.new(0,8)
corner.Parent=bg
local viewport=Instance.new"Frame"
viewport.Size=UDim2.new(0,W,0,H)
viewport.Position=UDim2.new(0,10,0,10)
viewport.BackgroundColor3=Color3.fromRGB(0,0,0)
viewport.ClipsDescendants=true
viewport.Parent=bg
local u={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_0_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_1_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_2_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_3_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_4_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_5_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_6_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_7_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_8_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_9_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_10_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_11_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_12_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_13_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_14_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_15_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_16_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_17_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_18_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_19_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_20_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_21_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_22_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_23_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_24_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_25_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_26_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_27_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_28_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_29_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_30_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_31_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_32_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_33_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_34_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_35_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_36_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_37_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_38_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_39_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_40_17d5443f4d0f.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/gif_frame_41_17d5443f4d0f.png"}
local a={}
local c=1
local t=true
local d=50
local tf=42
for i=1,tf do
    local n="px_17d5443f4d0f_"..i..".png"
    if not isfile(n) then writefile(n,game:HttpGet(u[i])) end
    local l=Instance.new"ImageLabel"
    l.Size=UDim2.new(1,0,1,0)
    l.Image=getcustomasset(n)
    l.BackgroundTransparency=1
    l.Visible=(i==1)
    l.Parent=viewport
    a[i]=l
end

local resizeBtn=Instance.new"TextButton"
resizeBtn.Size=UDim2.new(0,24,0,24)
resizeBtn.Position=UDim2.new(1,-90,0,-32)
resizeBtn.Text="⤢"
resizeBtn.Font=Enum.Font.GothamBold
resizeBtn.TextSize=14
resizeBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
resizeBtn.TextColor3=Color3.fromRGB(255,255,255)
resizeBtn.BorderSizePixel=0
resizeBtn.Parent=bg
local rc=Instance.new"UICorner" rc.CornerRadius=UDim.new(0,4) rc.Parent=resizeBtn
local sizes={64,96,128,192,256}
local si=1
resizeBtn.MouseButton1Click:Connect(function()
    si=si+1 if si>#sizes then si=1 end
    local ns=sizes[si]
    bg.Size=UDim2.new(0,ns+20,0,ns+80)
    bg.Position=UDim2.new(0.5,-(ns+20)/2,0.5,-(ns+80)/2)
    viewport.Size=UDim2.new(0,ns,0,ns)
end)
local closeBtn=Instance.new"TextButton"
closeBtn.Size=UDim2.new(0,24,0,24)
closeBtn.Position=UDim2.new(1,-58,0,-32)
closeBtn.Text="✕"
closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextSize=14
closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel=0
closeBtn.Parent=bg
local cc=Instance.new"UICorner" cc.CornerRadius=UDim.new(0,4) cc.Parent=closeBtn
closeBtn.MouseButton1Click:Connect(function() g:Destroy() end)
local titleBar=Instance.new"TextLabel"
titleBar.Size=UDim2.new(1,-100,0,24)
titleBar.Position=UDim2.new(0,10,0,-32)
titleBar.Text="PixelPlayer"
titleBar.Font=Enum.Font.GothamBold
titleBar.TextSize=12
titleBar.TextColor3=Color3.fromRGB(200,200,200)
titleBar.BackgroundTransparency=1
titleBar.TextXAlignment=Enum.TextXAlignment.Left
titleBar.Parent=bg
local ctrlBar=Instance.new"Frame"
ctrlBar.Size=UDim2.new(1,0,0,30)
ctrlBar.Position=UDim2.new(0,0,1,10)
ctrlBar.BackgroundTransparency=1
ctrlBar.Parent=viewport
local playBtn=Instance.new"TextButton"
playBtn.Size=UDim2.new(0,30,0,24)
playBtn.Position=UDim2.new(0,5,0,3)
playBtn.Text="⏸"
playBtn.Font=Enum.Font.GothamBold
playBtn.TextSize=12
playBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
playBtn.TextColor3=Color3.fromRGB(255,255,255)
playBtn.BorderSizePixel=0
playBtn.Parent=ctrlBar
local pc=Instance.new"UICorner" pc.CornerRadius=UDim.new(0,4) pc.Parent=playBtn
local timeLabel=Instance.new"TextLabel"
timeLabel.Size=UDim2.new(0,70,0,24)
timeLabel.Position=UDim2.new(1,-80,0,3)
timeLabel.Text="0:00/0:00"
timeLabel.Font=Enum.Font.Gotham
timeLabel.TextSize=10
timeLabel.TextColor3=Color3.fromRGB(180,180,180)
timeLabel.BackgroundTransparency=1
timeLabel.Parent=ctrlBar
local seekTrack=Instance.new"Frame"
seekTrack.Size=UDim2.new(1,-120,0,6)
seekTrack.Position=UDim2.new(0,42,0,12)
seekTrack.BackgroundColor3=Color3.fromRGB(60,60,60)
seekTrack.BorderSizePixel=0
seekTrack.Parent=ctrlBar
local stc=Instance.new"UICorner" stc.CornerRadius=UDim.new(0,3) stc.Parent=seekTrack
local seekFill=Instance.new"Frame"
seekFill.Size=UDim2.new(0,0,1,0)
seekFill.BackgroundColor3=Color3.fromRGB(80,160,255)
seekFill.BorderSizePixel=0
seekFill.Parent=seekTrack
local sfc=Instance.new"UICorner" sfc.CornerRadius=UDim.new(0,3) sfc.Parent=seekFill
local seekKnob=Instance.new"Frame"
seekKnob.Size=UDim2.new(0,12,0,12)
seekKnob.Position=UDim2.new(0,-6,0.5,-6)
seekKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
seekKnob.BorderSizePixel=0
seekKnob.Parent=seekFill
local skc=Instance.new"UICorner" skc.CornerRadius=UDim.new(1,0) skc.Parent=seekKnob
local dragging=false
local function seekTo(frame)
    local nc=math.clamp(frame,1,tf)
    if a[c] then a[c].Visible=false end
    c=nc
    if a[c] then a[c].Visible=true end
    local pct=(c-1)/(tf-1)
    seekFill.Size=UDim2.new(pct,0,1,0)
    local ts=math.floor((c-1)*(d/1000))
    local tot=math.floor((tf-1)*(d/1000))
    timeLabel.Text=string.format("%d:%02d/%d:%02d",math.floor(ts/60),ts%60,math.floor(tot/60),tot%60)
    
end
seekTrack.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        local rel=inp.Position.X-seekTrack.AbsolutePosition.X
        local pct=math.clamp(rel/seekTrack.AbsoluteSize.X,0,1)
        seekTo(math.floor(pct*(tf-1))+1)
    end
end)
seekTrack.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local rel=inp.Position.X-seekTrack.AbsolutePosition.X
        local pct=math.clamp(rel/seekTrack.AbsoluteSize.X,0,1)
        seekTo(math.floor(pct*(tf-1))+1)
    end
end)
playBtn.MouseButton1Click:Connect(function()
    t=not t
    playBtn.Text=t and"⏸"or"▶"
    
end)
local lt=tick()
RunService.RenderStepped:Connect(function()
    if t and not dragging then
        local nt=tick()
        if nt-lt>=d/1000 then
            lt=nt
            if a[c] then a[c].Visible=false end
            c=c+1
            if c>tf then c=1 end
            if a[c] then a[c].Visible=true end
            local pct=(c-1)/(tf-1)
            seekFill.Size=UDim2.new(pct,0,1,0)
            local ts=math.floor((c-1)*(d/1000))
            local tot=math.floor((tf-1)*(d/1000))
            timeLabel.Text=string.format("%d:%02d/%d:%02d",math.floor(ts/60),ts%60,math.floor(tot/60),tot%60)
        end
    end
end)