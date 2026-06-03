local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local _p=Players.LocalPlayer
if not _p then return end

local _g=Instance.new("ScreenGui")
_g.Name="PixelPlayer_U1MpKvbDtgA_1780445033"
_g.ResetOnSpawn=false
_g.IgnoreGuiInset=true
_g.DisplayOrder=999
_g.Parent=_p:WaitForChild("PlayerGui")

local _W,_H=256,256
local _bg=Instance.new("Frame")
_bg.Size=UDim2.new(0,_W+20,0,_H+80)
_bg.Position=UDim2.new(0.5,-(_W+20)/2,0.5,-(_H+80)/2)
_bg.BackgroundColor3=Color3.fromRGB(10,10,10)
_bg.BorderSizePixel=0
_bg.Active=true
_bg.Draggable=true
_bg.Parent=_g

local _bgCorner=Instance.new("UICorner")
_bgCorner.CornerRadius=UDim.new(0,8)
_bgCorner.Parent=_bg

local _vp=Instance.new("Frame")
_vp.Size=UDim2.new(0,_W,0,_H)
_vp.Position=UDim2.new(0,10,0,10)
_vp.BackgroundColor3=Color3.fromRGB(0,0,0)
_vp.ClipsDescendants=true
_vp.Parent=_bg

local _urls={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_2.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_14.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_19.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_30.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_35.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_65.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_82.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780445033_147.png"}
local _frames={}
local _curFrame=1
local _playing=true
local _frameDelay=250.0
local _totalFrames=148
local _videoEnded=false
local _lastFrameTime=0

for _i=1,_totalFrames do
    local _fn="px_U1MpKvbDtgA_1780445033_".._i..".png"
    if not isfile(_fn) then writefile(_fn,game:HttpGet(_urls[_i])) end
    local _lbl=Instance.new("ImageLabel")
    _lbl.Size=UDim2.new(1,0,1,0)
    _lbl.Image=getcustomasset(_fn)
    _lbl.BackgroundTransparency=1
    _lbl.Visible=(_i==1)
    _lbl.Parent=_vp
    _frames[_i]=_lbl
end


local _au="yt_U1MpKvbDtgA_1780445033.mp3"
if not isfile(_au) then writefile(_au,game:HttpGet("https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/audios/yt_U1MpKvbDtgA_1780445033.mp3")) end
local _snd=Instance.new("Sound")
_snd.SoundId=getcustomasset(_au)
_snd.Volume=0.5
_snd.Looped=false
_snd.Parent=game.Workspace
local _audioStarted=false

local function startAudio()
    if not _audioStarted then
        _audioStarted=true
        _snd:Play()
    end
end

local function stopAudio()
    if _snd then _snd:Stop() _snd:Destroy() end
end

local function pauseAudio()
    if _snd and _snd.Playing then _snd:Pause() end
end

local function resumeAudio()
    if _snd and not _snd.Playing then _snd:Resume() end
end

local function seekAudio(frameNum)
    if _snd then
        local seekTime=(frameNum-1)*(250.0/1000)
        _snd.TimePosition=math.max(0,seekTime)
    end
end

local _titleBar=Instance.new("TextLabel")
_titleBar.Size=UDim2.new(1,-100,0,24)
_titleBar.Position=UDim2.new(0,10,0,-32)
_titleBar.Text="PixelPlayer"
_titleBar.Font=Enum.Font.GothamBold
_titleBar.TextSize=12
_titleBar.TextColor3=Color3.fromRGB(200,200,200)
_titleBar.BackgroundTransparency=1
_titleBar.TextXAlignment=Enum.TextXAlignment.Left
_titleBar.Parent=_bg

local _resizeBtn=Instance.new("TextButton")
_resizeBtn.Size=UDim2.new(0,24,0,24)
_resizeBtn.Position=UDim2.new(1,-90,0,-32)
_resizeBtn.Text="⤢"
_resizeBtn.Font=Enum.Font.GothamBold
_resizeBtn.TextSize=14
_resizeBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
_resizeBtn.TextColor3=Color3.fromRGB(255,255,255)
_resizeBtn.BorderSizePixel=0
_resizeBtn.Parent=_bg
local _resizeBtnCorner=Instance.new("UICorner")
_resizeBtnCorner.CornerRadius=UDim.new(0,4)
_resizeBtnCorner.Parent=_resizeBtn

local _closeBtn=Instance.new("TextButton")
_closeBtn.Size=UDim2.new(0,24,0,24)
_closeBtn.Position=UDim2.new(1,-58,0,-32)
_closeBtn.Text="✕"
_closeBtn.Font=Enum.Font.GothamBold
_closeBtn.TextSize=14
_closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
_closeBtn.TextColor3=Color3.fromRGB(255,255,255)
_closeBtn.BorderSizePixel=0
_closeBtn.Parent=_bg
local _closeBtnCorner=Instance.new("UICorner")
_closeBtnCorner.CornerRadius=UDim.new(0,4)
_closeBtnCorner.Parent=_closeBtn

_closeBtn.MouseButton1Click:Connect(function()
    stopAudio() _g:Destroy()
end)

local _sizes={64,96,128,192,256}
local _sizeIdx=1
_resizeBtn.MouseButton1Click:Connect(function()
    _sizeIdx=_sizeIdx+1
    if _sizeIdx>#_sizes then _sizeIdx=1 end
    local _ns=_sizes[_sizeIdx]
    local _ti=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    TweenService:Create(_bg,_ti,{Size=UDim2.new(0,_ns+20,0,_ns+80)}):Play()
    TweenService:Create(_bg,_ti,{Position=UDim2.new(0.5,-(_ns+20)/2,0.5,-(_ns+80)/2)}):Play()
    TweenService:Create(_vp,_ti,{Size=UDim2.new(0,_ns,0,_ns)}):Play()
end)

local _ctrlBar=Instance.new("Frame")
_ctrlBar.Size=UDim2.new(1,0,0,36)
_ctrlBar.Position=UDim2.new(0,0,1,8)
_ctrlBar.BackgroundTransparency=1
_ctrlBar.Parent=_vp

local function _makeBtn(text,x,w)
    local _b=Instance.new("TextButton")
    _b.Size=UDim2.new(0,w,0,28)
    _b.Position=UDim2.new(0,x,0,4)
    _b.Text=text
    _b.Font=Enum.Font.GothamBold
    _b.TextSize=13
    _b.BackgroundColor3=Color3.fromRGB(40,40,40)
    _b.TextColor3=Color3.fromRGB(255,255,255)
    _b.BorderSizePixel=0
    _b.AutoButtonColor=true
    _b.Parent=_ctrlBar
    local _c=Instance.new("UICorner")
    _c.CornerRadius=UDim.new(0,5)
    _c.Parent=_b
    return _b
end

local _btnSkipBack=_makeBtn("«",4,28)
local _btnPrev=_makeBtn("◄",36,28)
local _btnPlay=_makeBtn("⏸",68,34)
_btnPlay.BackgroundColor3=Color3.fromRGB(80,160,255)
local _btnNext=_makeBtn("►",106,28)
local _btnSkipFwd=_makeBtn("»",138,28)

local _timeLabel=Instance.new("TextLabel")
_timeLabel.Size=UDim2.new(0,90,0,28)
_timeLabel.Position=UDim2.new(1,-94,0,4)
_timeLabel.Text="0:00/0:00"
_timeLabel.Font=Enum.Font.Gotham
_timeLabel.TextSize=10
_timeLabel.TextColor3=Color3.fromRGB(180,180,180)
_timeLabel.BackgroundTransparency=1
_timeLabel.Parent=_ctrlBar

local _seekTrack=Instance.new("Frame")
_seekTrack.Size=UDim2.new(1,-276,0,8)
_seekTrack.Position=UDim2.new(0,170,0,14)
_seekTrack.BackgroundColor3=Color3.fromRGB(60,60,60)
_seekTrack.BorderSizePixel=0
_seekTrack.Parent=_ctrlBar
local _seekTrackCorner=Instance.new("UICorner")
_seekTrackCorner.CornerRadius=UDim.new(0,4)
_seekTrackCorner.Parent=_seekTrack

local _seekFill=Instance.new("Frame")
_seekFill.Size=UDim2.new(0,0,1,0)
_seekFill.BackgroundColor3=Color3.fromRGB(80,160,255)
_seekFill.BorderSizePixel=0
_seekFill.Parent=_seekTrack
local _seekFillCorner=Instance.new("UICorner")
_seekFillCorner.CornerRadius=UDim.new(0,4)
_seekFillCorner.Parent=_seekFill

local _seekKnob=Instance.new("Frame")
_seekKnob.Size=UDim2.new(0,14,0,14)
_seekKnob.Position=UDim2.new(0,-7,0.5,-7)
_seekKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
_seekKnob.BorderSizePixel=0
_seekKnob.Parent=_seekFill
local _seekKnobCorner=Instance.new("UICorner")
_seekKnobCorner.CornerRadius=UDim.new(1,0)
_seekKnobCorner.Parent=_seekKnob

local _dragging=false

local function _updateTime()
    local _ts=math.floor((_curFrame-1)*(_frameDelay/1000))
    local _tot=math.floor((_totalFrames-1)*(_frameDelay/1000))
    _timeLabel.Text=string.format("%d:%02d/%d:%02d",math.floor(_ts/60),_ts%60,math.floor(_tot/60),_tot%60)
end

local function _setFrame(fn)
    local _nf=math.clamp(fn,1,_totalFrames)
    if _frames[_curFrame] then _frames[_curFrame].Visible=false end
    _curFrame=_nf
    if _frames[_curFrame] then _frames[_curFrame].Visible=true end
    local _pct=(_curFrame-1)/math.max(_totalFrames-1,1)
    _seekFill.Size=UDim2.new(_pct,0,1,0)
    _updateTime()
    seekAudio(_curFrame)
end

local function _seekTo(fn)
    _setFrame(fn)
    if _videoEnded then
        _videoEnded=false
        _playing=true
        _btnPlay.Text="⏸"
        resumeAudio()
    end
end

local function _nextFrame()
    if _curFrame<_totalFrames then
        _setFrame(_curFrame+1)
    else
        _playing=false
        _videoEnded=true
        _btnPlay.Text="▶"
        pauseAudio()
    end
end

local function _prevFrame()
    if _videoEnded then
        _videoEnded=false
        _playing=false
        _btnPlay.Text="▶"
    end
    _setFrame(math.max(_curFrame-1,1))
end

local function _skipFrames(amt)
    _seekTo(math.clamp(_curFrame+amt,1,_totalFrames))
end

_seekTrack.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        _dragging=true
        local _rel=inp.Position.X-_seekTrack.AbsolutePosition.X
        local _pct=math.clamp(_rel/_seekTrack.AbsoluteSize.X,0,1)
        _seekTo(math.floor(_pct*(_totalFrames-1))+1)
    end
end)

_seekTrack.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        _dragging=false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if _dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local _rel=inp.Position.X-_seekTrack.AbsolutePosition.X
        local _pct=math.clamp(_rel/_seekTrack.AbsoluteSize.X,0,1)
        _seekTo(math.floor(_pct*(_totalFrames-1))+1)
    end
end)

_btnPlay.MouseButton1Click:Connect(function()
    if _videoEnded then
        _videoEnded=false
        _seekTo(1)
        _playing=true
        _btnPlay.Text="⏸"
        resumeAudio()
        _lastFrameTime=tick()
        return
    end
    _playing=not _playing
    _btnPlay.Text=_playing and "⏸" or "▶"
    if _playing then
        resumeAudio()
        _lastFrameTime=tick()
    else
        pauseAudio()
    end
end)

_btnPrev.MouseButton1Click:Connect(function() _prevFrame() end)
_btnNext.MouseButton1Click:Connect(function() _nextFrame() end)
_btnSkipBack.MouseButton1Click:Connect(function() _skipFrames(-10) end)
_btnSkipFwd.MouseButton1Click:Connect(function() _skipFrames(10) end)

local _frameInterval=_frameDelay/1000
_lastFrameTime=tick()

RunService.RenderStepped:Connect(function()
    if _playing and not _dragging and not _videoEnded then
        local _now=tick()
        if _now-_lastFrameTime>=_frameInterval then
            _lastFrameTime=_now
            _nextFrame()
        end
    end
end)

startAudio()
_updateTime()