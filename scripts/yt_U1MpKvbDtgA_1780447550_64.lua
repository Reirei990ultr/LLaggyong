local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local _p=Players.LocalPlayer
if not _p then return end

local _g=Instance.new("ScreenGui")
_g.Name="PixelPlayer_U1MpKvbDtgA_1780447550"
_g.ResetOnSpawn=false
_g.IgnoreGuiInset=true
_g.DisplayOrder=999
_g.Parent=_p:WaitForChild("PlayerGui")

local _W,_H=256,256
local _bg=Instance.new("Frame")
_bg.Size=UDim2.new(0,_W+20,0,_H+100)
_bg.Position=UDim2.new(0.5,-(_W+20)/2,0.5,-(_H+100)/2)
_bg.BackgroundColor3=Color3.fromRGB(10,10,10)
_bg.BorderSizePixel=0
_bg.Active=true
_bg.Draggable=true
_bg.Parent=_g
local _bgC=Instance.new("UICorner") _bgC.CornerRadius=UDim.new(0,8) _bgC.Parent=_bg

local _vp=Instance.new("Frame")
_vp.Size=UDim2.new(0,_W,0,_H)
_vp.Position=UDim2.new(0,10,0,36)
_vp.BackgroundColor3=Color3.fromRGB(0,0,0)
_vp.ClipsDescendants=true
_vp.Parent=_bg

local _titleBar=Instance.new("TextLabel")
_titleBar.Size=UDim2.new(1,-60,0,28)
_titleBar.Position=UDim2.new(0,8,0,4)
_titleBar.Text="PixelPlayer"
_titleBar.Font=Enum.Font.GothamBold
_titleBar.TextSize=12
_titleBar.TextColor3=Color3.fromRGB(220,220,220)
_titleBar.BackgroundTransparency=1
_titleBar.TextXAlignment=Enum.TextXAlignment.Left
_titleBar.Parent=_bg

local function _hdrBtn(txt,xr)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(0,26,0,26)
    b.Position=UDim2.new(1,xr,0,3)
    b.Text=txt
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.BorderSizePixel=0
    b.AutoButtonColor=true
    b.Parent=_bg
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,5) c.Parent=b
    return b
end
local _closeBtn=_hdrBtn("✕",-30)
_closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
local _resizeBtn=_hdrBtn("⤢",-60)

local _sizes={64,96,128,192,256}
local _si=1
_resizeBtn.MouseButton1Click:Connect(function()
    _si=_si%#_sizes+1
    local ns=_sizes[_si]
    local ti=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    TS:Create(_bg,ti,{Size=UDim2.new(0,ns+20,0,ns+100)}):Play()
    TS:Create(_bg,ti,{Position=UDim2.new(0.5,-(ns+20)/2,0.5,-(ns+100)/2)}):Play()
    TS:Create(_vp,ti,{Size=UDim2.new(0,ns,0,ns)}):Play()
end)
_closeBtn.MouseButton1Click:Connect(function() _stopAudio() _g:Destroy() end)

local _urls={"https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_0.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_1.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_2.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_3.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_4.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_5.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_6.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_7.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_8.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_9.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_10.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_11.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_12.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_13.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_14.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_15.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_16.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_17.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_18.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_19.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_20.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_21.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_22.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_23.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_24.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_25.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_26.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_27.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_28.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_29.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_30.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_31.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_32.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_33.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_34.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_35.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_36.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_37.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_38.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_39.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_40.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_41.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_42.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_43.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_44.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_45.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_46.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_47.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_48.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_49.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_50.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_51.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_52.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_53.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_54.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_55.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_56.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_57.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_58.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_59.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_60.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_61.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_62.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_63.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_64.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_65.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_66.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_67.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_68.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_69.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_70.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_71.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_72.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_73.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_74.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_75.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_76.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_77.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_78.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_79.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_80.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_81.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_82.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_83.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_84.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_85.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_86.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_87.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_88.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_89.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_90.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_91.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_92.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_93.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_94.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_95.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_96.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_97.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_98.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_99.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_100.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_101.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_102.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_103.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_104.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_105.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_106.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_107.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_108.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_109.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_110.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_111.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_112.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_113.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_114.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_115.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_116.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_117.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_118.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_119.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_120.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_121.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_122.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_123.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_124.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_125.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_126.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_127.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_128.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_129.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_130.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_131.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_132.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_133.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_134.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_135.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_136.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_137.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_138.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_139.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_140.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_141.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_142.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_143.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_144.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_145.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_146.png","https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/frames/frm_U1MpKvbDtgA_1780447550_147.png"}
local _frames={}
local _curFrame=1
local _playing=true
local _frameDelay=250.0
local _totalFrames=148
local _videoEnded=false
local _lastFrameTime=0
local _dragging=false
local _ctrlVisible=true
local _ctrlTimer=0
local _CTRL_HIDE=3

for _i=1,_totalFrames do
    local _fn="px_U1MpKvbDtgA_1780447550_".._i..".png"
    if not isfile(_fn) then
        local ok,err=pcall(function() writefile(_fn,game:HttpGet(_urls[_i])) end)
        if not ok then print("frame err ".._i..": "..tostring(err)) end
    end
    local _lbl=Instance.new("ImageLabel")
    _lbl.Size=UDim2.new(1,0,1,0)
    _lbl.Image=getcustomasset(_fn)
    _lbl.BackgroundTransparency=1
    _lbl.Visible=(_i==1)
    _lbl.Parent=_vp
    _frames[_i]=_lbl
end


local _au="yt_U1MpKvbDtgA_1780447550.mp3"
if not isfile(_au) then writefile(_au,game:HttpGet("https://raw.githubusercontent.com/Reirei990ultr/LLaggyong/main/audios/yt_U1MpKvbDtgA_1780447550.mp3")) end
local _snd=Instance.new("Sound")
_snd.SoundId=getcustomasset(_au)
_snd.Volume=0.5
_snd.Looped=false
_snd.Parent=game.Workspace

local function _stopAudio()
    if _snd then pcall(function() _snd:Stop() _snd:Destroy() end) end
end
local function _pauseAudio()
    pcall(function() if _snd and _snd.Playing then _snd:Pause() end end)
end
local function _resumeAudio()
    pcall(function() if _snd and not _snd.Playing then _snd:Resume() end end)
end
local function _seekAudio(fn)
    pcall(function()
        if _snd then
            _snd.TimePosition=math.max(0,(fn-1)*(250.0/1000))
        end
    end)
end
local function _startAudio()
    pcall(function() _snd:Play() end)
end

local _overlay=Instance.new("Frame")
_overlay.Size=UDim2.new(1,0,1,0)
_overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
_overlay.BackgroundTransparency=0.5
_overlay.BorderSizePixel=0
_overlay.Visible=false
_overlay.ZIndex=10
_overlay.Parent=_vp

local _overlayBtn=Instance.new("TextButton")
_overlayBtn.Size=UDim2.new(1,0,1,0)
_overlayBtn.BackgroundTransparency=1
_overlayBtn.Text=""
_overlayBtn.ZIndex=11
_overlayBtn.Parent=_vp

local _bigPlayBtn=Instance.new("TextLabel")
_bigPlayBtn.Size=UDim2.new(0,56,0,56)
_bigPlayBtn.Position=UDim2.new(0.5,-28,0.5,-28)
_bigPlayBtn.Text="▶"
_bigPlayBtn.Font=Enum.Font.GothamBold
_bigPlayBtn.TextSize=32
_bigPlayBtn.TextColor3=Color3.fromRGB(255,255,255)
_bigPlayBtn.BackgroundTransparency=1
_bigPlayBtn.ZIndex=12
_bigPlayBtn.Visible=false
_bigPlayBtn.Parent=_vp

local _skipFwdHint=Instance.new("TextLabel")
_skipFwdHint.Size=UDim2.new(0,80,0,30)
_skipFwdHint.Position=UDim2.new(1,-85,0.5,-15)
_skipFwdHint.Text="+10s"
_skipFwdHint.Font=Enum.Font.GothamBold
_skipFwdHint.TextSize=14
_skipFwdHint.TextColor3=Color3.fromRGB(255,255,255)
_skipFwdHint.BackgroundTransparency=1
_skipFwdHint.ZIndex=12
_skipFwdHint.Visible=false
_skipFwdHint.Parent=_vp

local _skipBackHint=Instance.new("TextLabel")
_skipBackHint.Size=UDim2.new(0,80,0,30)
_skipBackHint.Position=UDim2.new(0,5,0.5,-15)
_skipBackHint.Text="-10s"
_skipBackHint.Font=Enum.Font.GothamBold
_skipBackHint.TextSize=14
_skipBackHint.TextColor3=Color3.fromRGB(255,255,255)
_skipBackHint.BackgroundTransparency=1
_skipBackHint.ZIndex=12
_skipBackHint.Visible=false
_skipBackHint.Parent=_vp

local _bottomBar=Instance.new("Frame")
_bottomBar.Size=UDim2.new(1,0,0,54)
_bottomBar.Position=UDim2.new(0,0,1,0)
_bottomBar.BackgroundColor3=Color3.fromRGB(10,10,10)
_bottomBar.BorderSizePixel=0
_bottomBar.ZIndex=10
_bottomBar.Parent=_vp

local _seekTrack=Instance.new("Frame")
_seekTrack.Size=UDim2.new(1,-16,0,4)
_seekTrack.Position=UDim2.new(0,8,0,6)
_seekTrack.BackgroundColor3=Color3.fromRGB(80,80,80)
_seekTrack.BorderSizePixel=0
_seekTrack.ZIndex=11
_seekTrack.Parent=_bottomBar
local _stC=Instance.new("UICorner") _stC.CornerRadius=UDim.new(0,2) _stC.Parent=_seekTrack

local _seekFill=Instance.new("Frame")
_seekFill.Size=UDim2.new(0,0,1,0)
_seekFill.BackgroundColor3=Color3.fromRGB(255,0,0)
_seekFill.BorderSizePixel=0
_seekFill.ZIndex=12
_seekFill.Parent=_seekTrack
local _sfC=Instance.new("UICorner") _sfC.CornerRadius=UDim.new(0,2) _sfC.Parent=_seekFill

local _seekKnob=Instance.new("Frame")
_seekKnob.Size=UDim2.new(0,14,0,14)
_seekKnob.Position=UDim2.new(0,-7,0.5,-7)
_seekKnob.BackgroundColor3=Color3.fromRGB(255,0,0)
_seekKnob.BorderSizePixel=0
_seekKnob.ZIndex=13
_seekKnob.Parent=_seekFill
local _skC=Instance.new("UICorner") _skC.CornerRadius=UDim.new(1,0) _skC.Parent=_seekKnob

local function _ctrlBtn(txt,x,w)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(0,w,0,32)
    b.Position=UDim2.new(0,x,0,16)
    b.Text=txt
    b.Font=Enum.Font.GothamBold
    b.TextSize=15
    b.BackgroundColor3=Color3.fromRGB(30,30,30)
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.BorderSizePixel=0
    b.AutoButtonColor=true
    b.ZIndex=11
    b.Parent=_bottomBar
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
    return b
end

local _btnSkipB=_ctrlBtn("«",4,36)
local _btnPrev=_ctrlBtn("◄",44,36)
local _btnPlay=_ctrlBtn("⏸",84,42)
_btnPlay.BackgroundColor3=Color3.fromRGB(200,0,0)
local _btnNext=_ctrlBtn("►",130,36)
local _btnSkipF=_ctrlBtn("»",170,36)

local _timeLabel=Instance.new("TextLabel")
_timeLabel.Size=UDim2.new(0,110,0,20)
_timeLabel.Position=UDim2.new(1,-114,0,17)
_timeLabel.Text="0:00 / 0:00"
_timeLabel.Font=Enum.Font.Gotham
_timeLabel.TextSize=11
_timeLabel.TextColor3=Color3.fromRGB(210,210,210)
_timeLabel.BackgroundTransparency=1
_timeLabel.ZIndex=11
_timeLabel.Parent=_bottomBar

local function _updateTime()
    local _ts=math.floor((_curFrame-1)*(_frameDelay/1000))
    local _tot=math.floor((_totalFrames-1)*(_frameDelay/1000))
    _timeLabel.Text=string.format("%d:%02d / %d:%02d",math.floor(_ts/60),_ts%60,math.floor(_tot/60),_tot%60)
end

local function _setFrame(fn)
    local nf=math.clamp(fn,1,_totalFrames)
    if _frames[_curFrame] then _frames[_curFrame].Visible=false end
    _curFrame=nf
    if _frames[_curFrame] then _frames[_curFrame].Visible=true end
    local pct=(_curFrame-1)/math.max(_totalFrames-1,1)
    _seekFill.Size=UDim2.new(pct,0,1,0)
    _updateTime()
    _seekAudio(_curFrame)
end

local function _showOverlay(resumePlay)
    _ctrlTimer=0
    _ctrlVisible=true
    _overlay.Visible=true
    _bottomBar.Visible=true
    if _videoEnded or not _playing then
        _bigPlayBtn.Text="▶"
        _bigPlayBtn.Visible=true
    else
        _bigPlayBtn.Visible=false
    end
    if resumePlay then
        task.delay(2,function()
            if _ctrlVisible then
                _overlay.Visible=false
                _bigPlayBtn.Visible=false
            end
        end)
    end
end

local function _hideOverlay()
    _ctrlVisible=false
    _overlay.Visible=false
    _bigPlayBtn.Visible=false
end

local function _seekTo(fn)
    _setFrame(fn)
    if _videoEnded then
        _videoEnded=false
        _playing=true
        _btnPlay.Text="⏸"
        _resumeAudio()
    end
end

local function _nextFrame()
    if _curFrame<_totalFrames then
        _setFrame(_curFrame+1)
    else
        _playing=false
        _videoEnded=true
        _btnPlay.Text="▶"
        _pauseAudio()
        _showOverlay(false)
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

local function _skipFrames(amt,hint)
    _seekTo(math.clamp(_curFrame+amt,1,_totalFrames))
    if hint then
        hint.Visible=true
        task.delay(0.7,function() hint.Visible=false end)
    end
end

_seekTrack.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        _dragging=true
        local rel=inp.Position.X-_seekTrack.AbsolutePosition.X
        local pct=math.clamp(rel/_seekTrack.AbsoluteSize.X,0,1)
        _seekTo(math.floor(pct*(_totalFrames-1))+1)
    end
end)
_seekTrack.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        _dragging=false
    end
end)
UIS.InputChanged:Connect(function(inp)
    if _dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local rel=inp.Position.X-_seekTrack.AbsolutePosition.X
        local pct=math.clamp(rel/_seekTrack.AbsoluteSize.X,0,1)
        _seekTo(math.floor(pct*(_totalFrames-1))+1)
    end
end)

_overlayBtn.MouseButton1Click:Connect(function()
    if _ctrlVisible and not _videoEnded then
        _hideOverlay()
    else
        _showOverlay(not _videoEnded)
    end
end)

_btnPlay.MouseButton1Click:Connect(function()
    if _videoEnded then
        _videoEnded=false
        _seekTo(1)
        _playing=true
        _btnPlay.Text="⏸"
        _resumeAudio()
        _lastFrameTime=tick()
        _hideOverlay()
        return
    end
    _playing=not _playing
    _btnPlay.Text=_playing and "⏸" or "▶"
    if _playing then
        _resumeAudio()
        _lastFrameTime=tick()
        task.delay(2,function() if _playing then _hideOverlay() end end)
    else
        _pauseAudio()
        _showOverlay(false)
    end
end)

_btnPrev.MouseButton1Click:Connect(function() _prevFrame() _ctrlTimer=0 end)
_btnNext.MouseButton1Click:Connect(function() _nextFrame() _ctrlTimer=0 end)
_btnSkipB.MouseButton1Click:Connect(function()
    local fps_10=math.floor(10/(_frameDelay/1000))
    _skipFrames(-fps_10,_skipBackHint)
    _ctrlTimer=0
end)
_btnSkipF.MouseButton1Click:Connect(function()
    local fps_10=math.floor(10/(_frameDelay/1000))
    _skipFrames(fps_10,_skipFwdHint)
    _ctrlTimer=0
end)

local _frameInterval=_frameDelay/1000
_lastFrameTime=tick()

RunService.RenderStepped:Connect(function(dt)
    if _playing and not _dragging and not _videoEnded then
        local now=tick()
        if now-_lastFrameTime>=_frameInterval then
            _lastFrameTime=now
            _nextFrame()
        end
        if _ctrlVisible and not _dragging then
            _ctrlTimer=_ctrlTimer+dt
            if _ctrlTimer>=_CTRL_HIDE then
                _hideOverlay()
            end
        end
    end
end)

_startAudio()
_updateTime()