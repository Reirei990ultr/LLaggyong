local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local p=Players.LocalPlayer
if not p then return end

local g=Instance.new("ScreenGui")
g.Name="PixelPlayer_U1MpKvbDtgA_1780443868"
g.ResetOnSpawn=false
g.IgnoreGuiInset=true
g.Parent=p:WaitForChild("PlayerGui")

local W,H=256,256
local bg=Instance.new("Frame")
bg.Size=UDim2.new(0,W+20,0,H+80)
bg.Position=UDim2.new(0.5,-(W+20)/2,0.5,-(H+80)/2)
bg.BackgroundColor3=Color3.fromRGB(10,10,10)
bg.BorderSizePixel=0
bg.Active=true
bg.Draggable=true
bg.Parent=g

local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,8)
corner.Parent=bg

local viewport=Instance.new("Frame")
viewport.Size=UDim2.new(0,W,0,H)
viewport.Position=UDim2.new(0,10,0,10)
viewport.BackgroundColor3=Color3.fromRGB(0,0,0)
viewport.ClipsDescendants=true
viewport.Parent=bg

local u={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_2.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_14.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_19.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_30.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_35.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_65.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_82.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780443868_147.png"}
local a={}
local c=1
local t=true
local d=250.0
local tf=148
local videoDuration = 37
local videoEnded = false

for i=1,tf do
    local n="px_U1MpKvbDtgA_1780443868_"..i..".png"
    if not isfile(n) then writefile(n,game:HttpGet(u[i])) end
    local l=Instance.new("ImageLabel")
    l.Size=UDim2.new(1,0,1,0)
    l.Image=getcustomasset(n)
    l.BackgroundTransparency=1
    l.Visible=(i==1)
    l.Parent=viewport
    a[i]=l
end


local au="yt_U1MpKvbDtgA_1780443868.mp3"
if not isfile(au) then writefile(au,game:HttpGet("https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/audios/yt_U1MpKvbDtgA_1780443868.mp3")) end
local s=Instance.new("Sound")
s.SoundId=getcustomasset(au)
s.Volume=0.5
s.Looped=false
s.Parent=game.Workspace
local audioStarted=false
local audioStartTime=0

local function startAudio()
    if not audioStarted then
        audioStarted=true
        audioStartTime=tick()
        s:Play()
    end
end

local function stopAudio()
    if s then
        s:Stop()
        s:Destroy()
    end
end

local function pauseAudio()
    if s and s.Playing then
        s:Pause()
    end
end

local function resumeAudio()
    if s and not s.Playing then
        s:Resume()
    end
end

local function seekAudio(frameNum)
    if s then
        local seekTime = (frameNum-1)*(250.0/1000)
        s.TimePosition = seekTime
        audioStartTime = tick() - seekTime
    end
end

local resizeBtn=Instance.new("TextButton")
resizeBtn.Size=UDim2.new(0,24,0,24)
resizeBtn.Position=UDim2.new(1,-90,0,-32)
resizeBtn.Text="⤢"
resizeBtn.Font=Enum.Font.GothamBold
resizeBtn.TextSize=14
resizeBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
resizeBtn.TextColor3=Color3.fromRGB(255,255,255)
resizeBtn.BorderSizePixel=0
resizeBtn.Parent=bg

local rc=Instance.new("UICorner")
rc.CornerRadius=UDim.new(0,4)
rc.Parent=resizeBtn

local sizes={64,96,128,192,256}
local si=1
resizeBtn.MouseButton1Click:Connect(function()
    si=si+1 if si>#sizes then si=1 end
    local ns=sizes[si]
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenBg = TweenService:Create(bg, tweenInfo, {Size=UDim2.new(0,ns+20,0,ns+80)})
    local tweenPos = TweenService:Create(bg, tweenInfo, {Position=UDim2.new(0.5,-(ns+20)/2,0.5,-(ns+80)/2)})
    local tweenVp = TweenService:Create(viewport, tweenInfo, {Size=UDim2.new(0,ns,0,ns)})
    tweenBg:Play()
    tweenPos:Play()
    tweenVp:Play()
end)

local closeBtn=Instance.new("TextButton")
closeBtn.Size=UDim2.new(0,24,0,24)
closeBtn.Position=UDim2.new(1,-58,0,-32)
closeBtn.Text="✕"
closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextSize=14
closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel=0
closeBtn.Parent=bg

local cc=Instance.new("UICorner")
cc.CornerRadius=UDim.new(0,4)
cc.Parent=closeBtn

closeBtn.MouseButton1Click:Connect(function()
    stopAudio() g:Destroy()
end)

local titleBar=Instance.new("TextLabel")
titleBar.Size=UDim2.new(1,-100,0,24)
titleBar.Position=UDim2.new(0,10,0,-32)
titleBar.Text="PixelPlayer"
titleBar.Font=Enum.Font.GothamBold
titleBar.TextSize=12
titleBar.TextColor3=Color3.fromRGB(200,200,200)
titleBar.BackgroundTransparency=1
titleBar.TextXAlignment=Enum.TextXAlignment.Left
titleBar.Parent=bg

local ctrlBar=Instance.new("Frame")
ctrlBar.Size=UDim2.new(1,0,0,30)
ctrlBar.Position=UDim2.new(0,0,1,10)
ctrlBar.BackgroundTransparency=1
ctrlBar.Parent=viewport

local btnPrev2=Instance.new("TextButton")
btnPrev2.Size=UDim2.new(0,24,0,24)
btnPrev2.Position=UDim2.new(0,5,0,3)
btnPrev2.Text="«"
btnPrev2.Font=Enum.Font.GothamBold
btnPrev2.TextSize=12
btnPrev2.BackgroundColor3=Color3.fromRGB(40,40,40)
btnPrev2.TextColor3=Color3.fromRGB(255,255,255)
btnPrev2.BorderSizePixel=0
btnPrev2.Parent=ctrlBar
local p2c=Instance.new("UICorner")
p2c.CornerRadius=UDim.new(0,4)
p2c.Parent=btnPrev2

local btnPrev=Instance.new("TextButton")
btnPrev.Size=UDim2.new(0,24,0,24)
btnPrev.Position=UDim2.new(0,33,0,3)
btnPrev.Text="◄"
btnPrev.Font=Enum.Font.GothamBold
btnPrev.TextSize=12
btnPrev.BackgroundColor3=Color3.fromRGB(40,40,40)
btnPrev.TextColor3=Color3.fromRGB(255,255,255)
btnPrev.BorderSizePixel=0
btnPrev.Parent=ctrlBar
local pc=Instance.new("UICorner")
pc.CornerRadius=UDim.new(0,4)
pc.Parent=btnPrev

local playBtn=Instance.new("TextButton")
playBtn.Size=UDim2.new(0,30,0,24)
playBtn.Position=UDim2.new(0,61,0,3)
playBtn.Text="⏸"
playBtn.Font=Enum.Font.GothamBold
playBtn.TextSize=12
playBtn.BackgroundColor3=Color3.fromRGB(80,160,255)
playBtn.TextColor3=Color3.fromRGB(255,255,255)
playBtn.BorderSizePixel=0
playBtn.Parent=ctrlBar
local plc=Instance.new("UICorner")
plc.CornerRadius=UDim.new(0,4)
plc.Parent=playBtn

local btnNext=Instance.new("TextButton")
btnNext.Size=UDim2.new(0,24,0,24)
btnNext.Position=UDim2.new(0,95,0,3)
btnNext.Text="►"
btnNext.Font=Enum.Font.GothamBold
btnNext.TextSize=12
btnNext.BackgroundColor3=Color3.fromRGB(40,40,40)
btnNext.TextColor3=Color3.fromRGB(255,255,255)
btnNext.BorderSizePixel=0
btnNext.Parent=ctrlBar
local nc=Instance.new("UICorner")
nc.CornerRadius=UDim.new(0,4)
nc.Parent=btnNext

local btnNext2=Instance.new("TextButton")
btnNext2.Size=UDim2.new(0,24,0,24)
btnNext2.Position=UDim2.new(0,123,0,3)
btnNext2.Text="»"
btnNext2.Font=Enum.Font.GothamBold
btnNext2.TextSize=12
btnNext2.BackgroundColor3=Color3.fromRGB(40,40,40)
btnNext2.TextColor3=Color3.fromRGB(255,255,255)
btnNext2.BorderSizePixel=0
btnNext2.Parent=ctrlBar
local n2c=Instance.new("UICorner")
n2c.CornerRadius=UDim.new(0,4)
n2c.Parent=btnNext2

local timeLabel=Instance.new("TextLabel")
timeLabel.Size=UDim2.new(0,130,0,24)
timeLabel.Position=UDim2.new(1,-135,0,3)
timeLabel.Text="0:00/0:00"
timeLabel.Font=Enum.Font.Gotham
timeLabel.TextSize=10
timeLabel.TextColor3=Color3.fromRGB(180,180,180)
timeLabel.BackgroundTransparency=1
timeLabel.Parent=ctrlBar

local seekTrack=Instance.new("Frame")
seekTrack.Size=UDim2.new(1,-280,0,6)
seekTrack.Position=UDim2.new(0,155,0,12)
seekTrack.BackgroundColor3=Color3.fromRGB(60,60,60)
seekTrack.BorderSizePixel=0
seekTrack.Parent=ctrlBar

local stc=Instance.new("UICorner")
stc.CornerRadius=UDim.new(0,3)
stc.Parent=seekTrack

local seekFill=Instance.new("Frame")
seekFill.Size=UDim2.new(0,0,1,0)
seekFill.BackgroundColor3=Color3.fromRGB(80,160,255)
seekFill.BorderSizePixel=0
seekFill.Parent=seekTrack

local sfc=Instance.new("UICorner")
sfc.CornerRadius=UDim.new(0,3)
sfc.Parent=seekFill

local seekKnob=Instance.new("Frame")
seekKnob.Size=UDim2.new(0,12,0,12)
seekKnob.Position=UDim2.new(0,-6,0.5,-6)
seekKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
seekKnob.BorderSizePixel=0
seekKnob.Parent=seekFill

local skc=Instance.new("UICorner")
skc.CornerRadius=UDim.new(1,0)
skc.Parent=seekKnob

local dragging=false
local lastFrameTime=0

local function updateTimeDisplay()
    local ts=math.floor((c-1)*(d/1000))
    local tot=math.floor((tf-1)*(d/1000))
    timeLabel.Text=string.format("%d:%02d/%d:%02d",math.floor(ts/60),ts%60,math.floor(tot/60),tot%60)
end

local function seekTo(frame)
    local nc=math.clamp(frame,1,tf)
    if a[c] then a[c].Visible=false end
    c=nc
    if a[c] then a[c].Visible=true end
    local pct=(c-1)/(tf-1)
    seekFill.Size=UDim2.new(pct,0,1,0)
    updateTimeDisplay()
    if type(nc) == "number" and nc >= 1 and nc <= tf then
        seekAudio(nc)
    end
    if videoEnded then
        videoEnded = false
        t = true
        playBtn.Text="⏸"
        resumeAudio()
    end
end

local function nextFrame()
    if c < tf then
        if a[c] then a[c].Visible=false end
        c=c+1
        if a[c] then a[c].Visible=true end
        local pct=(c-1)/(tf-1)
        seekFill.Size=UDim2.new(pct,0,1,0)
        updateTimeDisplay()
        if type(c) == "number" and c >= 1 and c <= tf then
            seekAudio(nc)
        end
    else
        if a[c] then a[c].Visible=false end
        c = tf
        if a[c] then a[c].Visible=true end
        t = false
        playBtn.Text="▶"
        videoEnded = true
        pauseAudio()
        return
    end
end

local function prevFrame()
    if c > 1 then
        if a[c] then a[c].Visible=false end
        c=c-1
        if a[c] then a[c].Visible=true end
        local pct=(c-1)/(tf-1)
        seekFill.Size=UDim2.new(pct,0,1,0)
        updateTimeDisplay()
        if type(c) == "number" and c >= 1 and c <= tf then
            seekAudio(nc)
        end
        if videoEnded then
            videoEnded = false
            t = true
            playBtn.Text="⏸"
            resumeAudio()
        end
    end
end

local function skipFrames(amount)
    local newPos = c + amount
    if newPos < 1 then newPos = 1 end
    if newPos > tf then newPos = tf end
    seekTo(newPos)
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
    if videoEnded then
        videoEnded = false
        seekTo(1)
        t = true
        playBtn.Text="⏸"
        resumeAudio()
        return
    end
    t=not t
    playBtn.Text=t and "⏸" or "▶"
    if t then
        resumeAudio()
        lastFrameTime=tick()
    else
        pauseAudio()
    end
end)

btnPrev.MouseButton1Click:Connect(function()
    prevFrame()
end)

btnNext.MouseButton1Click:Connect(function()
    nextFrame()
end)

btnPrev2.MouseButton1Click:Connect(function()
    skipFrames(-10)
end)

btnNext2.MouseButton1Click:Connect(function()
    skipFrames(10)
end)

local animationRunning = true
local frameInterval = d/1000

RunService.RenderStepped:Connect(function()
    if t and not dragging and animationRunning and not videoEnded then
        local now=tick()
        if now - lastFrameTime >= frameInterval then
            lastFrameTime = now
            nextFrame()
        end
    end
end)

local function startAnimation()
    animationRunning = true
    lastFrameTime = tick()
end

local function stopAnimation()
    animationRunning = false
end

startAnimation()
startAudio()
updateTimeDisplay()