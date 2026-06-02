local Players=game:GetService"Players"
local RunService=game:GetService"RunService"
local UserInputService=game:GetService"UserInputService"
local p=Players.LocalPlayer
if not p then return end
local g=Instance.new"ScreenGui"
g.Name="PixelPlayer_U1MpKvbDtgA_1780438037"
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
local u={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_2.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_14.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_19.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_30.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_35.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_65.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_82.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780438037_147.png"}
local a={}
local c=1
local t=true
local d=250.0
local tf=148
for i=1,tf do
    local n="px_U1MpKvbDtgA_1780438037_"..i..".png"
    if not isfile(n) then writefile(n,game:HttpGet(u[i])) end
    local l=Instance.new"ImageLabel"
    l.Size=UDim2.new(1,0,1,0)
    l.Image=getcustomasset(n)
    l.BackgroundTransparency=1
    l.Visible=(i==1)
    l.Parent=viewport
    a[i]=l
end
local au="yt_U1MpKvbDtgA_1780438037.mp3"
if not isfile(au) then writefile(au,game:HttpGet("https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/audios/yt_U1MpKvbDtgA_1780438037.mp3")) end
local s=Instance.new"Sound"
s.SoundId=getcustomasset(au)
s.Volume=0.5
s.Looped=false
s.Parent=game.Workspace
s:Play()
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
closeBtn.MouseButton1Click:Connect(function() g:Destroy() s:Stop() s:Destroy() end)
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
    s.TimePosition=(nc-1)*(250.0/1000)
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
    if t then s:Resume() else s:Pause() end
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