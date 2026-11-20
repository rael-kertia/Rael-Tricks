=== RAEL BLIND BOX FULL DIAGNOSIS ===
Player Raelity911 | 2026-11-20 18:59:38

### MODULE GachaController = ReplicatedStorage.NKSystem.Controller.GachaController
REQUIRE true table

### FUNCTION GachaController.ShowKeyReward
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=ShowKeyReward
C1 0
C2 tonumber
C4 math
C5 floor
C7 Legendary
C8 Epic
C9 Rare
C10 task
C11 spawn
C13 type
C14 keys
C15 name
C16 rarity
C17 amount
C18 icon
C19 rbxassetid://103696452648775
C21 Kunci Emas
U1 function function: 0x18296380d3b14dd4

### FUNCTION GachaController.ShowKeyReward.U1
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=showReveal
C1 PlayerGui
C2 WaitForChild
C3 GachaRevealGui
C4 FindFirstChild
C5 rarityColor
C6 rarity
C7 type
C8 none
C9 icon
C10 
C11 Holder
C12 Pop
C13 Rays
C14 ItemIcon
C15 0.4
C16 Scale
C17 Rotation
C18 Color3
C19 fromRGB
C21 ImageColor3
C22 0.5
C23 0.12
C24 ImageTransparency
C25 Image
C26 Nama
C27 ?
C28 name
C29 Text
C30 Color
C31 TextMuted
C32 TextColor3
C33 Enabled
C34 money
C35 + Rp 
C36 0
C37 amount
C38 tostring
C40 keys
C41 + 
C42 formatMoney
C43 tonumber
C45 math
C46 floor
C48  Kunci Emas
C49 tool
C50 masuk ke ranselmu
C51 domba
C52 masuk ke kandang
C53 coba lagi ya
C54 Sub
C55 TweenInfo
C56 new
C58 0.45
C59 Enum
C60 EasingStyle
C61 Back
C63 EasingDirection
C64 Out
C66 1
C68 Create
C69 Play
C70 Linear
C72 InOut
C75 360
C77 pcall
C79 task
C80 delay
C82 2.8
C83 wait
C85 0.1
U1 userdata Players.Raelity911
U2 table table: 0xaf9cdbb7a47ac9af
  [TES_SAPU_PASTI] boolean false
  [rarityColor] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U2.rarityColor
INFO =ReplicatedStorage.NKSystem.Util.GachaConfig line=nil name=rarityColor
C1 Rarities
C2 Common
C3 color
U1 table table: 0xaf9cdbb7a47ac9af
  [MAX_FREE] number 10
  [resolvePath] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U2.resolvePath
INFO =ReplicatedStorage.NKSystem.Util.GachaConfig line=nil name=resolvePath
C1 type
C3 string
C4 gmatch
C6 [^%.]+
C7 pcall
C9 game
C10 Ugc
C11 FindFirstChild
  [Rarities] TABLE table: 0x0d67bbd3f20e4c60
  [SPIN_PRICE] number 200000
  [formatMoney] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U2.formatMoney
INFO =ReplicatedStorage.NKSystem.Util.GachaConfig line=nil name=formatMoney
C1 0
C2 tonumber
C4 math
C5 floor
C7 tostring
C9 ^(%d+)(%d%d%d)
C10 %1.%2
C11 gsub
  [getItem] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U2.getItem
INFO =ReplicatedStorage.NKSystem.Util.GachaConfig line=nil name=getItem
C1 ipairs
C3 Items
C4 id
U1 table table: 0xaf9cdbb7a47ac9af
  [Items] TABLE table: 0x79832810ae5dd740
U3 table table: 0x4cb6247ff86fb3da
  [Tween] TABLE table: 0xfe803200859911db
  [FontTitle] userdata Font { Family = rbxassetid://16658221428, Weight = ExtraBold, Style = Normal }
  [CloseIcon] string rbxassetid://134557119979432
  [Color] TABLE table: 0xeb7eaf03992aea23
  [Stroke] TABLE table: 0xa92968751648df76
  [bounce] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U3.bounce
INFO =ReplicatedStorage.NKSystem.Util.UITheme line=nil name=bounce
C1 Bounce
C2 FindFirstChild
C3 Instance
C4 new
C6 UIScale
C7 Name
C8 Parent
C9 0.85
C10 Scale
C11 Tween
C12 1
C14 Create
C15 Play
U1 userdata TweenService
U2 table table: 0x4cb6247ff86fb3da
  [applyGradient] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U3.applyGradient
INFO =ReplicatedStorage.NKSystem.Util.UITheme line=nil name=applyGradient
C1 Lapis
C2 FindFirstChild
C3 setButton
C4 Grad
C5 Instance
C6 new
C8 UIGradient
C9 Name
C10 Enabled
C11 Gradient
C12 Confirm
C13 Color
C14 Rotation
C15 Parent
U1 table table: 0x0115c3be3f3d0056
U2 table table: 0x4cb6247ff86fb3da
  [Corner] TABLE table: 0xe75fe6a7d7ec6ce1
  [Button] TABLE table: 0xd58be41bb037c82e
  [Krem] TABLE table: 0xad4400ec664e1b48
  [applyStroke] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U3.applyStroke
INFO =ReplicatedStorage.NKSystem.Util.UITheme line=nil name=applyStroke
C1 Stroke
C2 Text
C3 UIStroke
C4 FindFirstChildOfClass
C5 Instance
C6 new
C8 Thickness
C9 Color
C10 Transparency
C11 Enum
C12 ApplyStrokeMode
C13 Contextual
C15 Parent
U1 table table: 0x4cb6247ff86fb3da
  [pop] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U3.pop
INFO =ReplicatedStorage.NKSystem.Util.UITheme line=nil name=pop
C1 Pop
C2 FindFirstChild
C3 Instance
C4 new
C6 UIScale
C7 Name
C8 Parent
C9 Vector2
C11 0.5
C12 AnchorPoint
C13 UDim2
C14 fromScale
C16 Position
C17 1
C18 0
C19 PopToken
C20 GetAttribute
C21 SetAttribute
C22 Visible
C23 BackgroundTransparency
C24 Tween
C25 Fade
C27 Transparency
C28 Dim
C29 Create
C30 Play
C31 PopFrom
C32 Scale
C33 Open
C35 Close
C37 0.65
C39 Completed
C40 Once
U1 userdata TweenService
U2 table table: 0x4cb6247ff86fb3da
  [setButton] FUNCTION

### FUNCTION GachaController.ShowKeyReward.U1.U3.setButton
INFO =ReplicatedStorage.NKSystem.Util.UITheme line=nil name=setButton
C1 Button
C2 Primary
C3 Base
C4 BackgroundColor3
C5 Lapis
C6 FindFirstChild
C7 Grad
C8 UIGradient
C9 FindFirstChildOfClass
C10 Enabled
C11 ColorSequence
C12 new
C14 Top
C15 Bot
C16 Color
C17 ipairs
C19 GetDescendants
C20 TextLabel
C21 IsA
C22 Text
C23 TextColor3
C24 TeksStroke
C25 Secondary
U1 table table: 0x4cb6247ff86fb3da
  [Stagger] number 0.07
  [Transparency] TABLE table: 0xe6f1051deb8a60ed
  [PopFrom] number 0.55
  [Gradient] TABLE table: 0x8e3af24769f834be
  [Font] userdata Font { Family = rbxassetid://16658221428, Weight = Bold, Style = Normal }
U4 userdata TweenService
U5 userdata ReplicatedStorage

### FUNCTION GachaController.KnitStart
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=KnitStart
C1 GetService
C2 GachaService
C3 pcall
C5 task
C6 spawn
C8 PlayerGui
C9 WaitForChild
C10 GachaGui
C11 FindFirstChild
C12 Enabled
C13 GachaEntryGui
C14 StateChanged
C15 Connect
C16 GetState
C17 await
C18 type
C20 table
C21 0
C22 free
C23 max
C24 MAX_FREE
U1 table table: 0x65a2702051027d98
  [ClaimReward] FUNCTION

### FUNCTION GachaController.KnitStart.U1.ClaimReward
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x63e94cbe4858a6a6

### FUNCTION GachaController.KnitStart.U1.ClaimReward.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimReward
U4 function function: 0x3b587166b4b5e7af
  [Spin] FUNCTION

### FUNCTION GachaController.KnitStart.U1.Spin
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x07e4fc3f5d4ce72a

### FUNCTION GachaController.KnitStart.U1.Spin.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.Spin
U4 function function: 0x4f6beb0a0af161ac
  [SpinX10WithFree] FUNCTION

### FUNCTION GachaController.KnitStart.U1.SpinX10WithFree
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0xcd48626f530a1664

### FUNCTION GachaController.KnitStart.U1.SpinX10WithFree.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithFree
U4 function function: 0xd5e0763411120f25
  [SpinX10WithMoney] FUNCTION

### FUNCTION GachaController.KnitStart.U1.SpinX10WithMoney
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x0f4c944330d541d5

### FUNCTION GachaController.KnitStart.U1.SpinX10WithMoney.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithMoney
U4 function function: 0xdaa1b64365d4469a
  [GetState] FUNCTION

### FUNCTION GachaController.KnitStart.U1.GetState
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x1a3ee17faf1a6d89

### FUNCTION GachaController.KnitStart.U1.GetState.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetState
U4 function function: 0xbcafb94ecc6660a2
  [ClaimOneMultiReward] FUNCTION

### FUNCTION GachaController.KnitStart.U1.ClaimOneMultiReward
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x2fe03b5c7daa6a6f

### FUNCTION GachaController.KnitStart.U1.ClaimOneMultiReward.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimOneMultiReward
U4 function function: 0x3f1fe03e8d41f234
  [GetInventory] FUNCTION

### FUNCTION GachaController.KnitStart.U1.GetInventory
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x1a8b3099a589af6f

### FUNCTION GachaController.KnitStart.U1.GetInventory.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetInventory
U4 function function: 0x3fecf2ffb4c8da9c
  [SpinWithMoney] FUNCTION

### FUNCTION GachaController.KnitStart.U1.SpinWithMoney
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x2f0e1653de7c64e5

### FUNCTION GachaController.KnitStart.U1.SpinWithMoney.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinWithMoney
U4 function function: 0xe698dca2d64abed5
  [StateChanged] TABLE table: 0x444b53463ac05df2
  [ClaimMultiReward] FUNCTION

### FUNCTION GachaController.KnitStart.U1.ClaimMultiReward
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0xe0910d56304bb63c

### FUNCTION GachaController.KnitStart.U1.ClaimMultiReward.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimMultiReward
U4 function function: 0x92f49fab5b81e1bb
U2 table table: 0x1268e2a2975741b5
  [AddControllers] FUNCTION

### FUNCTION GachaController.KnitStart.U2.AddControllers
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=AddControllers
C1 Controllers cannot be added after calling "Knit.Start()"
C2 assert
C4 GetChildren
C5 ModuleScript
C6 IsA
C7 require
C9 table
C10 insert
U1 boolean true
  [GetService] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=GetService
C1 Cannot call GetService until Knit has been started
C2 assert
C4 type
C6 string
C7 ServiceName must be a string; got %*
C8 format
C9 script
C11 Parent
C12 Services
C13 WaitForChild
C14 Middleware
C15 PerServiceMiddleware
C16 new
C17 ServicePromises
C18 Inbound
C19 Outbound
C20 BuildObject
U1 table table: 0xdaf5404208afbc54
  [TraktorService] TABLE table: 0xdb2f122ec2503cbd
  [KaryawanService] TABLE table: 0xe95594dde6939ba8
  [AdminService] TABLE table: 0x748ad3f68c8ee5f8
  [TernakService] TABLE table: 0xf6c064d5233b3e5e
  [LimitOverrideService] TABLE table: 0x8e67c207f93a405a
  [ZoneService] TABLE table: 0x7b24da8f311ff251
  [PenyewaService] TABLE table: 0x87c3623dd7c7ed48
  [TradeService] TABLE table: 0xdb023b9b00640a24
  [OverheadService] TABLE table: 0xe914edc377155b35
  [RongsokanService] TABLE table: 0xa6578ff3f99c3a2f
  [SwitchRoleService] TABLE table: 0xb1babfe95b676637
  [ConvertService] TABLE table: 0x432fb02b62611df6
  [LokerService] TABLE table: 0x8bb6b0ff81d0ef2d
  [KotakService] TABLE table: 0x978ac45f0836dcee
  [BoomboxService] TABLE table: 0xe66da10d93bce362
  [ReturnHomeService] TABLE table: 0xb4c68c3baeb883cb
  [LaundryService] TABLE table: 0x29a3c18dd9621708
  [TokenListrikService] TABLE table: 0x64b5547abec7af9a
  [MarketService] TABLE table: 0x19243b29ff359eeb
  [RedeemService] TABLE table: 0xecc09b3fdbd5b9bd
  [KeyService] TABLE table: 0x53a57b5a2a7d757f
  [TaxService] TABLE table: 0x93f7c770b29880c1
  [MoneyService] TABLE table: 0xd684d6d7f2f699b4
  [DombaGiftService] TABLE table: 0xb6ab8e084d315ff7
  [HarianService] TABLE table: 0x3fd8f427f81cc015
  [FollowPetShopService] TABLE table: 0xc4160c0e749cbf31
  [KosanStateService] TABLE table: 0xe66256f0edf88c2d
  [BursaGoldService] TABLE table: 0x7bfc90480a250a76
  [GachaService] TABLE table: 0x65a2702051027d98
  [BangunKosanService] TABLE table: 0x60cb29cedc885445
  [CatTembokService] TABLE table: 0x5c740cfa53d3722c
  [PriceOverrideService] TABLE table: 0xa00533fa09ffd0ab
  [ServerHopService] TABLE table: 0xe9bc2d7072309820
  [ReportService] TABLE table: 0xb55b7a08349a5cb3
  [RefreshService] TABLE table: 0x58d8fd599626884d
  [LevelService] TABLE table: 0x4d3f5f7f8929677f
  [AdminLacakService] TABLE table: 0x2f0591624f23c340
  [GamepassService] TABLE table: 0x241d97623175ef80
  [RobuxTransferService] TABLE table: 0xe0dec60ee66841df
  [TabunganIDKService] TABLE table: 0x6c5b9632826cc02c
  [AnnouncementService] TABLE table: 0xe863e0fb1e7d4be3
  [MisiService] TABLE table: 0xec11f172f38e13e7
  [TanamService] TABLE table: 0xf94ff532dfe0ed87
  [AdminAbuseService] TABLE table: 0x76921a77c4b7d66b
U2 boolean true
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services
U4 table table: 0x64fb3f21e56b154c
  [PerServiceMiddleware] TABLE table: 0x7156ee62921bf468
  [ServicePromises] boolean true
U5 table table: 0x78818f3dd9fa9ba9
  [GetSignal] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.GetSignal
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=GetSignal
C1 GetSignal
C2 _instancesFolder
U1 table table: 0x3c44051b731bae37
  [Destroy] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.Destroy
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=Destroy
  [BuildObject] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.BuildObject
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=BuildObject
C1 _instancesFolder
C2 RF
C3 FindFirstChild
C4 RE
C5 RP
C6 GetChildren
C7 RemoteFunction
C8 IsA
C9 Name
C10 GetFunction
C11 RemoteEvent
C12 UnreliableRemoteEvent
C13 GetSignal
C14 GetProperty
  [GetProperty] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.GetProperty
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=GetProperty
C1 GetProperty
C2 _instancesFolder
U1 table table: 0x3c44051b731bae37
  [GetFunction] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.GetFunction
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=GetFunction
C1 GetFunction
C2 _instancesFolder
C3 _usePromise
U1 table table: 0x3c44051b731bae37
  [__index] TABLE table: 0x78818f3dd9fa9ba9
  [new] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetService.U5.new
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=new
C1 IsServer
C2 ClientComm must be constructed from the client
C3 assert
C5 typeof
C7 Instance
C8 Parent must be of type Instance
C9 DefaultCommFolderName
C10 WaitForChildTimeout
C11 WaitForChild
C12 Could not find namespace for ClientComm in parent: 
C13 setmetatable
C15 _instancesFolder
C16 _usePromise
U1 table table: 0xc908cae164aded77
U2 table table: 0x78818f3dd9fa9ba9
  [GetController] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetController
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=GetController
C1 Cannot call GetController until Knit has been started
C2 assert
C4 type
C6 string
C7 ControllerName must be a string; got %*
C8 format
C9 error
C11 Could not find controller "%*". Check to verify a controller with this name exists.
U1 table table: 0xc4fa22ede443b10e
  [MisiController] TABLE table: 0x7f41105b0106bb2a
  [BoomboxController] TABLE table: 0xaa9aed77c9c481e7
  [OverheadController] TABLE table: 0xfca835085bc15bca
  [AnnouncementController] TABLE table: 0x977ab95e56427de9
  [KaryawanController] TABLE table: 0x883f4cf15bb57840
  [GudangController] TABLE table: 0xcc11dbcda2dcd61d
  [RedeemAdminController] TABLE table: 0xa94ccec2fd40646f
  [ProximityAksesController] TABLE table: 0x9d97671020e5d1ba
  [PlacementController] TABLE table: 0xdbbf0a9364229637
  [AdminPanelController] TABLE table: 0xd8403877f0327fd3
  [UpgradeController] TABLE table: 0xb31feaaddedf1c02
  [PlayerListController] TABLE table: 0xe0dc983c65ea4d99
  [NotifController] TABLE table: 0xecf6dadf617c3085
  [CleaningController] TABLE table: 0x98b35c948738488d
  [RedeemController] TABLE table: 0x2500bdfa3248494e
  [GajiNotifController] TABLE table: 0x23df6f28fdf46476
  [GerbangController] TABLE table: 0x25d5b669e1cae985
  [LoungePrioritasController] TABLE table: 0x3ac8726fcb252fdc
  [GoldLeaderboardController] TABLE table: 0x7762db6a6b241daf
  [SetorAsetController] TABLE table: 0x72da4d312a069ef7
  [KotakController] TABLE table: 0x8b365d0624f9e54b
  [BursaGoldController] TABLE table: 0x9d3777668f3c8839
  [AdminLacakPanelController] TABLE table: 0x68d66bdd2644ae16
  [TransferController] TABLE table: 0x56fe1cd005d724fd
  [PenyewaController] TABLE table: 0x20e126a853e80c3d
  [MoveController] TABLE table: 0x522b634f976f874f
  [AmbientMusicController] TABLE table: 0xfe4bbb65a97af826
  [TutorialTernakController] TABLE table: 0x34336978cec84c39
  [TraktorController] TABLE table: 0xd6dd03b171eada92
  [DataReadyController] TABLE table: 0xb7676d7e6cfca3da
  [HarianController] TABLE table: 0x4a27d69300907b1a
  [AdminAbusePanelController] TABLE table: 0x441149fbce8b4bb0
  [ConvertController] TABLE table: 0x03488750c921357c
  [WaypointController] TABLE table: 0x35bfa55fcc94aa90
  [GamepassShopController] TABLE table: 0xf45501a79c83fdac
  [TanamController] TABLE table: 0x0566e677afca6272
  [RefreshController] TABLE table: 0xa8e2d24a0976cf0f
  [AcmController] TABLE table: 0xc03215bfcf27bb1c
  [DayNightController] TABLE table: 0x907fa575c207643a
  [AdminAbuseController] TABLE table: 0xf30e2986cd57f242
  [SwitchRoleController] TABLE table: 0x00d259c0e7166080
  [GridController] TABLE table: 0xdea12ed5a870d36a
  [MutasiController] TABLE table: 0x5fd629871153c49e
  [TaxController] TABLE table: 0xe1570494d710112c
  [DombaGiftController] TABLE table: 0x601e63721b556748
  [TernakController] TABLE table: 0xe1c9fe1670855de6
  [ReturnHomeController] TABLE table: 0x21bd544a68ff1adb
  [TutorialController] TABLE table: 0x1ab32c7470043f39
  [LokerController] TABLE table: 0x30c121c863e1b375
  [BuildCameraController] TABLE table: 0x8edcb6489ecefb13
  [PetsController] TABLE table: 0x07c99fd16873150a
  [TradeController] TABLE table: 0x73376a68a06ff16a
  [NightAmbienceController] TABLE table: 0x1cf30c3b68ecc8b4
  [TokenListrikController] TABLE table: 0x6e361d0231e4f898
  [PemilikLahanController] TABLE table: 0x0a5186a35fb4ae7f
  [ShopController] TABLE table: 0x5ba829439b0cf8c1
  [GachaController] TABLE table: 0xc3ec9a6d854f7fc4
  [LevelUpController] TABLE table: 0x0ee966f017956a42
  [PlayerHudController] TABLE table: 0x3b3db0f6ac5bd722
  [SettingController] TABLE table: 0xf3e0f028f59d3b25
U2 boolean true
  [Player] userdata Players.Raelity911
  [OnStart] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=OnStart
C1 resolve
C2 fromEvent
C3 Event
U1 boolean true
U2 table table: 0x8729f6b64b33e49a
  [onUnhandledRejection] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.onUnhandledRejection
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=onUnhandledRejection
C1 _unhandledRejectionCallbacks
C2 table
C3 insert
U1 table table: 0x8729f6b64b33e49a
  [_new] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2._new
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=_new
C1 is
C2 error
C4 Argument #2 to Promise.new must be a promise or nil
C5 _thread
C7 _source
C8 _status
C9 _values
C10 _valuesLength
C11 -1
C12 _unhandledRejection
C14 _queuedResolve
C15 _queuedReject
C16 _queuedFinally
C17 _cancellationHook
C18 _parent
C19 _consumers
C21 Status
C22 Started
C23 setmetatable
C25 coroutine
C26 create
C28 task
C29 spawn
U1 table table: 0x8729f6b64b33e49a
U2 table table: 0x585ac6cd7ef3b69c
U3 function function: 0x3cd9bba5fa251676
  [fromEvent] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.fromEvent
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=fromEvent
C2 _new
C3 debug
C4 traceback
U1 table table: 0x8729f6b64b33e49a
  [_all] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2._all
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=_all
C1 type
C3 table
C4 error
C6 string
C7 format
C9 Please pass a list of promises to %s
C10 Promise.all
C11 pairs
C13 is
C14 Non-promise value passed into %s at index %s
C15 tostring
C17 0
C18 resolve
C19 _new
U1 table table: 0x8729f6b64b33e49a
  [_try] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2._try
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=_try
C1 _new
U1 function function: 0x0878e75279348919
U2 table table: 0x8729f6b64b33e49a
  [__tostring] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.__tostring
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=__tostring
C1 string
C2 format
C4 Promise(%s)
C5 _status
  [retryWithDelay] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.retryWithDelay
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=retryWithDelay
C1 type
C3 function
C4 table
C5 getmetatable
C7 __call
C8 rawget
C10 Parameter #1 to Promise.retry must be a function
C11 assert
C13 number
C14 Parameter #2 (times) to Promise.retry must be a number
C15 Parameter #3 (seconds) to Promise.retry must be a number
C16 #
C17 select
C19 resolve
C20 catch
U1 table table: 0x8729f6b64b33e49a
  [defer] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.defer
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=defer
C1 debug
C2 traceback
C4 _new
U1 table table: 0x8729f6b64b33e49a
U2 function function: 0x3cd9bba5fa251676
  [race] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.race
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=race
C1 type
C3 table
C4 string
C5 format
C7 Please pass a list of promises to %s
C8 Promise.race
C9 assert
C11 pairs
C13 is
C14 Non-promise value passed into %s at index %s
C15 tostring
C17 _new
C18 debug
C19 traceback
U1 table table: 0x8729f6b64b33e49a
  [retry] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.retry
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=retry
C1 type
C3 function
C4 table
C5 getmetatable
C7 __call
C8 rawget
C10 Parameter #1 to Promise.retry must be a function
C11 assert
C13 number
C14 Parameter #2 to Promise.retry must be a number
C15 #
C16 select
C18 resolve
C19 catch
U1 table table: 0x8729f6b64b33e49a
  [delay] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.delay
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=delay
C1 type
C3 number
C4 Bad argument #1 to Promise.delay, must be a number.
C5 assert
C7 0.016666666666666666
C8 inf
C9 _new
C10 debug
C11 traceback
U1 table table: 0x8729f6b64b33e49a
  [_getTime] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2._getTime
INFO =[C] line=nil name=clock
  [promisify] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.promisify
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=promisify
U1 table table: 0x8729f6b64b33e49a
  [__index] TABLE table: 0xf52609ba51752546
  [_unhandledRejectionCallbacks] TABLE table: 0x38c475bc21499c5e
  [is] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.is
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=is
C1 type
C3 table
C4 getmetatable
C6 andThen
C7 function
C8 __call
C9 rawget
C11 __index
U1 table table: 0x8729f6b64b33e49a
  [each] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.each
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=each
C1 type
C3 table
C4 string
C5 format
C7 Please pass a list of promises to %s
C8 Promise.each
C9 assert
C11 function
C12 getmetatable
C14 __call
C15 rawget
C17 Please pass a handler function to %s!
C18 _new
C19 debug
C20 traceback
U1 table table: 0x8729f6b64b33e49a
U2 table table: 0x79a9eeb3ceb14c04
  [try] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.try
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=try
C1 _try
C2 debug
C3 traceback
U1 table table: 0x8729f6b64b33e49a
  [_timeEvent] userdata Signal Heartbeat
  [prototype] TABLE table: 0xf52609ba51752546
  [async] FUNCTION
  [allSettled] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.allSettled
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=allSettled
C1 type
C3 table
C4 error
C6 string
C7 format
C9 Please pass a list of promises to %s
C10 Promise.allSettled
C11 pairs
C13 is
C14 Non-promise value passed into %s at index %s
C15 tostring
C17 0
C18 resolve
C19 _new
C20 debug
C21 traceback
U1 table table: 0x8729f6b64b33e49a
  [any] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.any
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=any
C1 _all
C2 debug
C3 traceback
C6 andThen
U1 table table: 0x8729f6b64b33e49a
  [new] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.new
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=new
C1 _new
C2 debug
C3 traceback
U1 table table: 0x8729f6b64b33e49a
  [reject] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.reject
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=reject
C1 _new
C2 debug
C3 traceback
U1 function function: 0x0878e75279348919
U2 table table: 0x8729f6b64b33e49a
  [fold] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.fold
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=fold
C1 type
C3 table
C4 Bad argument #1 to Promise.fold: must be a table
C5 assert
C7 function
C8 getmetatable
C10 __call
C11 rawget
C13 Bad argument #2 to Promise.fold: must be a function
C14 resolve
C15 each
C16 andThen
U1 table table: 0x8729f6b64b33e49a
  [all] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.all
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=all
C1 _all
C2 debug
C3 traceback
U1 table table: 0x8729f6b64b33e49a
  [Status] TABLE table: 0x872d8e0b4745cd44
  [resolve] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.resolve
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=resolve
C1 _new
C2 debug
C3 traceback
U1 function function: 0x0878e75279348919
U2 table table: 0x8729f6b64b33e49a
  [Error] TABLE table: 0x79a9eeb3ceb14c04
  [some] FUNCTION

### FUNCTION GachaController.KnitStart.U2.OnStart.U2.some
INFO =ReplicatedStorage.NKSystem.Packages._Index.evaera_promise@4.0.0.promise line=nil name=some
C1 type
C3 number
C4 Bad argument #2 to Promise.some: must be a number
C5 assert
C7 _all
C8 debug
C9 traceback
U1 table table: 0x8729f6b64b33e49a
U3 userdata Event
  [AddControllersDeep] FUNCTION

### FUNCTION GachaController.KnitStart.U2.AddControllersDeep
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=AddControllersDeep
C1 Controllers cannot be added after calling "Knit.Start()"
C2 assert
C4 GetDescendants
C5 ModuleScript
C6 IsA
C7 require
C9 table
C10 insert
U1 boolean true
  [Start] FUNCTION

### FUNCTION GachaController.KnitStart.U2.Start
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=Start
C1 reject
C2 Knit already started
C3 table
C4 freeze
C6 typeof
C8 KnitOptions should be a table or nil; got %*
C9 format
C10 assert
C12 PerServiceMiddleware
C13 type
C15 new
C17 andThen
U1 boolean true
U2 table table: 0x8729f6b64b33e49a
U3 table table: 0xc4fa22ede443b10e
U4 table table: 0x64fb3f21e56b154c
U5 table table: 0x64fb3f21e56b154c
U6 boolean true
U7 userdata Event
  [GetControllers] FUNCTION

### FUNCTION GachaController.KnitStart.U2.GetControllers
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=GetControllers
C1 Cannot call GetControllers until Knit has been started
C2 assert
U1 boolean true
U2 table table: 0xc4fa22ede443b10e
  [Util] userdata ReplicatedStorage.NKSystem.Packages
  [CreateController] FUNCTION

### FUNCTION GachaController.KnitStart.U2.CreateController
INFO =ReplicatedStorage.NKSystem.Packages.Knit.KnitClient line=nil name=CreateController
C1 type
C3 table
C4 Controller must be a table; got %*
C5 format
C6 assert
C8 Name
C9 string
C10 Controller.Name must be a string; got %*
C11 Controller.Name must be a non-empty string
C12 Controller %* already exists
C13 Controllers cannot be created after calling "Knit.Start()"
U1 table table: 0xc4fa22ede443b10e
U2 boolean true
U3 table table: 0x53a57b5a2a7d757f
  [KeysChanged] TABLE table: 0x3bc738c40ae7e2a0
  [GetKeys] FUNCTION

### FUNCTION GachaController.KnitStart.U3.GetKeys
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0x3c81995eddf1d117

### FUNCTION GachaController.KnitStart.U3.GetKeys.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.KeyService.RF.GetKeys
U4 function function: 0xb4a8bc1d91c31ff1
U4 function function: 0x2c8e92f41017b629

### FUNCTION GachaController.KnitStart.U4
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=bindKeyHud
C1 KeysChanged
C3 Connect
C4 task
C5 spawn
U1 table table: 0x53a57b5a2a7d757f
U2 function function: 0xd815a0857708e464

### FUNCTION GachaController.KnitStart.U4.U2
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=updateKeyHud
C1 PlayerGui
C2 FindFirstChild
C3 PlayerHUD
C4 MainFrame
C5 Container
C6 KunciFrame
C7 Plakat
C8 Vlue
C9 TextLabel
C10 IsA
C11 formatMoney
C12 0
C13 tonumber
C15 math
C16 floor
C18 Text
U1 userdata Players.Raelity911
U2 table table: 0xaf9cdbb7a47ac9af
U3 userdata Players.Raelity911
U5 userdata Players.Raelity911
U6 number 9
U7 number 10
U8 table table: 0xaf9cdbb7a47ac9af
U9 function function: 0x09da031e6aa6d036

### FUNCTION GachaController.KnitStart.U9
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=updateFree
C1 PlayerGui
C2 WaitForChild
C3 GachaEntryGui
C4 FindFirstChild
C5 Panel
C6 FreeLabel
C7 StatusPelanggan
C8 string
C9 format
C11 Kotak gratis  %d/%d
C12 0
C13 MAX_FREE
C14 Text
C15 Row1
C16 SpinButton
C17 Active
C18 AutoButtonColor
C19 Label
C20 SubLabel
C21 BUKA GRATIS
C22 GRATIS HABIS
C23 Pakai kotak gratis
C24 Kotak gratis habis
C25 setButton
C26 Primary
C27 Disabled
C28 PaidSpinButton
C29 Rp 
C30 formatMoney
C31 Row2
C32 X10FreeButton
C33 BUKA 10
C34 10 kotak gratis
C35 Kotak gratis kurang
C36 X10PaidButton
U1 userdata Players.Raelity911
U2 table table: 0xaf9cdbb7a47ac9af
U3 table table: 0x4cb6247ff86fb3da
U4 number 200000
U5 number 2000000
U10 function function: 0x9349a9742514488c

### FUNCTION GachaController.KnitStart.U10
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=
C1 PlayerGui
C2 WaitForChild
C3 GachaEntryGui
C4 FindFirstChild
C5 Panel
C6 Row1
C7 Row2
C8 CloseButton
C10 SpinButton
C11 PaidSpinButton
C12 X10FreeButton
C13 X10PaidButton
U1 userdata Players.Raelity911
U2 table table: 0x4cb6247ff86fb3da
U3 number 9
U4 boolean true
U5 function function: 0x7d2b92ad54ce8c97

### FUNCTION GachaController.KnitStart.U10.U5
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=doSpin
C1 GetState
C2 await
C3 type
C5 table
C6 0
C7 free
C8 max
C9 MAX_FREE
C10 Spin
C11 ok
C12 granted
C13 [GachaController] Reward gagal dikasih server, coba spin lagi
C14 PlayerGui
C15 FindFirstChild
C17 pcall
C19 play
C20 1
C21 math
U1 boolean true
U2 table table: 0x65a2702051027d98
U3 number 9
U4 number 10
U5 table table: 0xaf9cdbb7a47ac9af
U6 function function: 0x09da031e6aa6d036
U7 function function: 0xa3e060376941be0a
U8 userdata Players.Raelity911
U9 userdata ReplicatedStorage
U10 function function: 0x48c9c0ff74bcf7ef
U11 function function: 0x7da078948b3f1123
U6 function function: 0x82816dab187adcba

### FUNCTION GachaController.KnitStart.U10.U6
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=doSpinPaid
C1 SpinWithMoney
C2 await
C3 type
C5 table
C6 ok
C7 GetState
C8 0
C9 free
C10 max
C11 MAX_FREE
C13 pcall
U1 boolean true
U2 table table: 0x65a2702051027d98
U3 number 9
U4 number 10
U5 table table: 0xaf9cdbb7a47ac9af
U6 function function: 0x09da031e6aa6d036
U7 userdata ReplicatedStorage
U8 function function: 0x48c9c0ff74bcf7ef
U9 function function: 0x7da078948b3f1123
U7 function function: 0xa2b8d86d2c6119f4

### FUNCTION GachaController.KnitStart.U10.U7
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=doSpin10Free
C1 SpinX10WithFree
C2 await
C3 type
C5 table
C6 ok
C7 GetState
C8 0
C9 free
C10 max
C11 MAX_FREE
C13 pcall
C15 10
C16 math
C18 results
U1 boolean true
U2 table table: 0x65a2702051027d98
U3 number 9
U4 number 10
U5 table table: 0xaf9cdbb7a47ac9af
U6 function function: 0x09da031e6aa6d036
U7 userdata ReplicatedStorage
U8 function function: 0x48c9c0ff74bcf7ef
U9 function function: 0x7da078948b3f1123
U8 function function: 0xf8d5463d5cb49c02

### FUNCTION GachaController.KnitStart.U10.U8
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=doSpin10Paid
C1 SpinX10WithMoney
C2 await
C3 type
C5 table
C6 ok
C7 GetState
C8 0
C9 free
C10 max
C11 MAX_FREE
C13 pcall
C15 results
U1 boolean true
U2 table table: 0x65a2702051027d98
U3 number 9
U4 number 10
U5 table table: 0xaf9cdbb7a47ac9af
U6 function function: 0x09da031e6aa6d036
U7 userdata ReplicatedStorage
U8 function function: 0x48c9c0ff74bcf7ef
U9 function function: 0x7da078948b3f1123
U9 function function: 0x48c9c0ff74bcf7ef

### FUNCTION GachaController.KnitStart.U10.U9
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=closeEntry
C1 PlayerGui
C2 WaitForChild
C3 GachaEntryGui
C4 FindFirstChild
C5 1
C6 Panel
C7 Backdrop
C8 pop
C9 Enabled
U1 userdata Players.Raelity911
U2 number 2
U3 table table: 0x4cb6247ff86fb3da
U11 function function: 0x414bacab53cb85d9

### FUNCTION GachaController.KnitStart.U11
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=wirePrompt
C1 GachaTriger
C2 WaitForChild
C4 ipairs
C6 GetChildren
C7 ChildAdded
C9 Connect
U1 userdata Workspace
U2 userdata Players.Raelity911
U3 function function: 0x2b2f8da39bb97060

### FUNCTION GachaController.KnitStart.U11.U3
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=openEntry
C1 PlayerGui
C2 WaitForChild
C3 GachaEntryGui
C4 FindFirstChild
C5 GetState
C6 await
C7 type
C9 table
C10 0
C11 free
C12 max
C13 MAX_FREE
C14 Enabled
C15 Panel
C16 Backdrop
C17 pop
U1 boolean true
U2 userdata Players.Raelity911
U3 function function: 0x9349a9742514488c
U4 function function: 0x09da031e6aa6d036
U5 number 9
U6 number 10
U7 table table: 0x65a2702051027d98
U8 table table: 0xaf9cdbb7a47ac9af
U9 table table: 0x4cb6247ff86fb3da
U10 function function: 0x7e4f492d6cb8b961
EXPORT Name string GachaController

### MODULE BlindBoxTampil = ReplicatedStorage.NKSystem.Util.BlindBoxTampil
REQUIRE true table

### FUNCTION BlindBoxTampil.mulai
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=mulai
C1 PlayerGui
C2 WaitForChild
C3 BlindBoxLayar
C4 FindFirstChild
C5 BlindBox
C6 Rak
C7 Kotak
C8 Dunia
C9 ipairs
C11 GetChildren
C12 Model
C13 IsA
C14 Camera
C15 BasePart
C16 Destroy
C17 workspace
C18 Workspace
C19 CurrentCamera
C20 gui
C21 vpf
C22 kotak
C23 relSlot
C24 angkat
C25 cahaya
C26 kosong
C28 tipe
C29 cf
C31 CameraType
C32 CFrame
C33 camLama
C34 Enum
C35 Scriptable
C37 pcall
C39 Instance
C40 new
C42 FieldOfView
C43 Parent
C44 cam
C45 Clone
C46 rak
C47 GetDescendants
C48 Attachment
C49 string
C50 match
C52 Name
C53 ^Slot(%d+)$
C54 tonumber
C57 PivotTo
C58 pairs
C60 WorldCFrame
C61 NumberValue
C62 BlindBox_Display
C63 display
C64 GetPivot
C65 poseDunia
C66 BlindBoxBlur
C67 BlurEffect
C68 Size
C69 blur
C70 14
C72 TweenInfo
C74 0.5
C75 EasingStyle
C76 Quad
C78 EasingDirection
C79 Out
C81 Create
C82 Play
C83 Gelap
C84 BackgroundTransparency
C86 Judul
C87 Hitung
C88 Hint
C89 Nama
C90 Sub
C91 TextTransparency
C92 UIStroke
C93 FindFirstChildOfClass
C94 Transparency
C95 Rays
C96 ImageTransparency
C97 Ikon
C98 Tutup
C99 Visible
C100 auto
C101 Auto
C102 Label
C103 AUTO BUKA: MATI
C104 Text
C105 Color3
C106 fromRGB
C108 BackgroundColor3
C109 Activated
C110 Connect
C111 sambungAuto
C112 Enabled
U1 table table: 0xe1154fcf192754b7
  [blur] userdata Lighting.BlindBoxBlur
  [poseDunia] userdata -672.662537, 16.1800003, -211.899994, 0, 0, 1, 0, 1, 0, -1, 0, 0
  [sambungAuto] userdata Connection
  [relSlot] TABLE table: 0xe1fd0600e7ad3f41
  [kotak] TABLE table: 0x01abea45069559fa
  [angkat] TABLE table: 0xe6704a8e7245aa81
  [auto] boolean false
  [cam] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Camera
  [camLama] TABLE table: 0x025999c110fc1147
  [kosong] TABLE table: 0xeffe6a21cc88ea87
  [vpf] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia
  [cahaya] TABLE table: 0x19cb23f263d94735
  [kontrol] TABLE table: 0xcb3e2b4e3aba102f
  [display] userdata Workspace.Kawasan_Kos.Area_Gacha_Pajak.BlindBox_Display
  [rak] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Rak
  [rakPose] userdata -681.513, 18.2529793, -211.663437, -0.463632017, -0.136564493, 0.875440121, -0.0136645148, 0.989034951, 0.147048116, -0.885922492, 0.0562137477, -0.46041441
  [gui] userdata Players.Raelity911.PlayerGui.BlindBoxLayar
U2 userdata Players.Raelity911
U3 userdata ReplicatedStorage
U4 function function: 0x83e20a3647b92251

### FUNCTION BlindBoxTampil.mulai.U4
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=poseTengah
C1 cam
C2 2
C3 FieldOfView
C4 math
C5 rad
C7 tan
C9 vpf
C10 AbsoluteSize
C11 X
C12 Y
C13 1
C14 max
C16 rak
C17 GetBoundingBox
C18 0.45
C19 0.7
C20 CFrame
C21 new
C23 0.36
C24 Angles
C26 3.141592653589793
C27 -0.4886921905584123
U1 table table: 0xe1154fcf192754b7
U5 function function: 0x97485a3258004184

### FUNCTION BlindBoxTampil.mulai.U5
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=letakkanRak
C1 rakPose
C2 rak
C3 PivotTo
C4 pairs
C6 kotak
C7 angkat
C8 Value
C9 relSlot
C10 CFrame
C11 new
C13 0.6
C14 cahaya
C15 GetPivot
C16 -0.09
U1 table table: 0xe1154fcf192754b7
U6 function function: 0x6cfec7e59ee252d6

### FUNCTION BlindBoxTampil.mulai.U6
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=setSembunyi
C1 ipairs
C3 GetDescendants
C4 BasePart
C5 IsA
C6 LocalTransparencyModifier
U7 userdata Lighting
U8 userdata TweenService
U9 function function: 0x6c9591142bdf3a4c

### FUNCTION BlindBoxTampil.mulai.U9
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=setAuto
C1 Auto
C2 FindFirstChild
C3 Label
C4 AUTO BUKA: NYALA
C5 AUTO BUKA: MATI
C6 Text
C7 Color3
C8 fromRGB
C10 BackgroundColor3
U10 function function: 0xaea5c6811f8e378a

### FUNCTION BlindBoxTampil.mulai.U10
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=bunyi
C1 Instance
C2 new
C4 Sound
C5 SoundId
C6 Volume
C7 Parent
C8 Play
C9 Ended
C10 Once
C11 task
C12 delay
U1 table table: 0x8dffb731f9e22955
  [terbang] TABLE table: 0x83f0076d81a5edf0
  [lakban] TABLE table: 0x3d3cb2e7042334f8
  [pilih] TABLE table: 0x43adebceeb31ba0a
  [muncul] TABLE table: 0x2362c10552b79b7b
  [kardus] TABLE table: 0x59a50357225db935
U2 userdata SoundService

### FUNCTION BlindBoxTampil.aktif
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=aktif
U1 table table: 0xe1154fcf192754b7

### FUNCTION BlindBoxTampil.selesai
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=selesai
C1 gui
C2 Tutup
C3 Visible
C4 sambungAuto
C5 Disconnect
C6 Auto
C7 FindFirstChild
C8 ipairs
C10 Judul
C11 Hitung
C12 Hint
C13 Nama
C14 Sub
C15 0.2
C16 Rays
C17 ImageTransparency
C18 1
C20 TweenInfo
C21 new
C23 Enum
C24 EasingStyle
C25 Quad
C27 EasingDirection
C28 Out
C30 Create
C31 Play
C32 rakPose
C33 poseDunia
C34 Position
C35 Magnitude
C36 0.05
C37 0.6
C38 blur
C39 Size
C40 0
C42 0.35
C43 Gelap
C44 BackgroundTransparency
C46 task
C47 wait
C49 0.36
C50 display
C51 Destroy
C52 Enabled
C53 vpf
C54 GetChildren
C55 Model
C56 IsA
C57 Camera
C58 BasePart
C59 pairs
C61 angkat
C62 workspace
C63 Workspace
C64 CurrentCamera
C65 camLama
C66 tipe
C67 CameraType
C68 kontrol
C69 pcall
U1 table table: 0xe1154fcf192754b7
U2 function function: 0xc97a50afa4864caa

### FUNCTION BlindBoxTampil.selesai.U2
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=teksTampil
C1 Text
C2 0.25
C3 TextTransparency
C5 TweenInfo
C6 new
C8 Enum
C9 EasingStyle
C10 Quad
C12 EasingDirection
C13 Out
C15 Create
C16 Play
C17 UIStroke
C18 FindFirstChildOfClass
C19 Transparency
U1 userdata TweenService
U3 userdata TweenService
U4 function function: 0xcd7c80abc1758604

### FUNCTION BlindBoxTampil.selesai.U4
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=easeIn
C1 3
U5 function function: 0xdf0cbc5682f61ca5

### FUNCTION BlindBoxTampil.selesai.U5
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=animasi
C1 os
C2 clock
C4 math
C5 clamp
C7 RenderStepped
C8 Wait
U1 userdata Run Service
U6 function function: 0xef397590aa4f2f96

### FUNCTION BlindBoxTampil.selesai.U6
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=easeInOut
C1 0.5
C2 3
C3 1
C4 2
U7 function function: 0x97485a3258004184
U8 function function: 0x6cfec7e59ee252d6

### FUNCTION BlindBoxTampil.buka
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=buka
C1 dipilih
C2 gui
C3 kotak
C4 kosong
C5 cahaya
C6 Destroy
C7 Tutup
C8 Visible
C9 1
C10 rarityColor
C11 rarity
C12 type
C13 none
C14 cam
C15 2
C16 FieldOfView
C17 math
C18 rad
C20 tan
C22 4.8
C23 CFrame
C24 new
C26 -2.6
C27 Angles
C29 2.7576202181510405
C30 GetPivot
C31 rakPose
C32 terbang
C33 0.75
C34 PivotTo
C35 ipairs
C37 GetDescendants
C38 BasePart
C39 IsA
C40 Name
C41 string
C42 sub
C44 ToObjectSpace
C45 X
C46 Z
C47 Vector3
C49 Magnitude
C50 0.01
C51 Kiri
C52 find
C53 Kanan
C54 p
C55 rel
C56 tinggi
C57 engsel
C58 sumbu
C59 maks
C61 Y
C63 Unit
C64 Cross
C65 table
C66 sort
C69 lakban
C70 0.55
C71 0.9
C72 kardus
C73 0.5
C74 0.7
C75 3.141592653589793
C77 Rays
C78 UDim2
C79 fromScale
C81 Position
C82 Color3
C83 fromRGB
C85 ImageColor3
C86 ImageTransparency
C88 0.6
C89 0.12
C90 TweenInfo
C92 0.4
C93 Enum
C94 EasingStyle
C95 Quad
C97 EasingDirection
C98 Out
C100 Create
C101 Play
C102 Linear
C104 InOut
C106 Rotation
C108 360
C109 task
C110 spawn
C112 muncul
C113 Ikon
C115 vpf
C116 Parent
C117 icon
C118 
C120 Image
C121 0.05
C122 Size
C123 0
C125 0.22
C126 Back
C128 0.45
C129 0.65
C130 Nama
C131 TextColor3
C132 ?
C133 name
C134 Sub
C135 1.6
C136 2.4
C137 os
C138 clock
C140 2.2
C141 3
C142 sin
C144 RenderStepped
C145 Wait
C146 0.2
C148 0.25
C149 0.3
C150 Cancel
U1 table table: 0xe1154fcf192754b7
U2 table table: 0xaf9cdbb7a47ac9af
U3 function function: 0xaea5c6811f8e378a
U4 function function: 0xdf0cbc5682f61ca5
U5 function function: 0x97485a3258004184
U6 function function: 0xc15b94544e618a63

### FUNCTION BlindBoxTampil.buka.U6
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=modelHadiah
C1 type
C2 pet
C3 domba
C4 tool
C5 PlayerGui
C6 WaitForChild
C7 BlindBoxModel
C8 id
C9 tostring
C11 1.5
C12 Model
C13 IsA
C14 Clone
C15 ipairs
C17 GetDescendants
C18 BaseScript
C19 Sound
C20 BillboardGui
C21 Destroy
C22 GetBoundingBox
C23 X
C24 Y
C25 Z
C26 math
C27 max
C29 pcall
C31 CFrame
C32 new
C34 PivotTo
C35 Position
C36 2
C37 Vector3
U1 userdata Players.Raelity911
U7 function function: 0xc6590ff9eaf718cd

### FUNCTION BlindBoxTampil.buka.U7
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=proyeksi
C1 cam
C2 vpf
C3 CFrame
C4 PointToObjectSpace
C5 2
C6 FieldOfView
C7 math
C8 rad
C10 tan
C12 AbsoluteSize
C13 X
C14 Y
C15 1
C16 max
C18 Z
C19 0.01
C20 0.5
U1 table table: 0xe1154fcf192754b7
U8 userdata TweenService
U9 function function: 0xc97a50afa4864caa
U10 function function: 0x24756341401c1366

### FUNCTION BlindBoxTampil.buka.U10
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=teksSub
C1 type
C2 money
C3 + Rp 
C4 formatMoney
C5 0
C6 amount
C7 keys
C8 + 
C9  Kunci Emas
C10 tool
C11 masuk ke ranselmu
C12 domba
C13 masuk ke kandang
C14 pet
C15 Pet baru! Pakai di menu PET
C16 none
C17 kotak kosong, coba lagi ya
C18 
U1 table table: 0xaf9cdbb7a47ac9af
U11 userdata Run Service
U12 function function: 0x98102ca283f5691c

### FUNCTION BlindBoxTampil.buka.U12
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=aturTransparansi
C1 ipairs
C3 GetDescendants
C4 BasePart
C5 IsA
C6 _TrAsli
C7 GetAttribute
C8 Transparency
C9 SetAttribute
C10 math
C11 max

### FUNCTION BlindBoxTampil.pilih
INFO =ReplicatedStorage.NKSystem.Util.BlindBoxTampil line=nil name=pilih
C1 gui
C2 Tombol
C3 WaitForChild
C4 ipairs
C6 GetChildren
C7 Destroy
C8 Judul
C9 BLIND BOX
C10 Hitung
C11 1
C12 string
C13 format
C15 Kotak %d / %d
C16 
C17 TouchEnabled
C18 Ketuk kotak, ketuk lagi untuk membuka
C19 Pilih kotak, klik untuk membuka
C20 Hint
C21 auto
C22 Auto buka aktif - tekan AUTO BUKA untuk berhenti
C23 Auto
C24 FindFirstChild
C25 Visible
C26 terbang
C27 rakPose
C28 poseDunia
C29 0.9
C30 pairs
C32 kotak
C33 Instance
C34 new
C36 TextButton
C37 Kotak
C38 Name
C39 Text
C40 BackgroundTransparency
C41 Vector2
C43 0.5
C44 AnchorPoint
C45 ZIndex
C46 Parent
C47 MouseEnter
C48 Connect
C49 Activated
C50 os
C51 clock
C53 CFrame
C55 0.12
C56 1.7
C57 math
C58 sin
C60 Angles
C62 0.025
C63 0.012
C64 1.25
C65 0.35
C66 table
C67 insert
C69 random
C71 0.55
C72 cahaya
C73 0.78
C74 0.08
C75 6
C76 GetDescendants
C77 BasePart
C78 IsA
C79 Transparency
C80 GetPivot
C83 Position
C84 abs
C86 vpf
C87 AbsoluteSize
C88 UDim2
C89 fromScale
C91 0.75
C92 Y
C93 X
C94 max
C96 1.05
C97 Size
C98 RenderStepped
C99 Wait
C100 dipilih
U1 table table: 0xe1154fcf192754b7
U2 function function: 0xc97a50afa4864caa
U3 userdata UserInputService
U4 function function: 0xaea5c6811f8e378a
U5 function function: 0x83e20a3647b92251
U6 function function: 0xef397590aa4f2f96
U7 function function: 0xdf0cbc5682f61ca5
U8 function function: 0x97485a3258004184
U9 userdata TweenService
U10 function function: 0xc6590ff9eaf718cd
U11 userdata Run Service

### MODULE GachaConfig = ReplicatedStorage.NKSystem.Util.GachaConfig
REQUIRE true table
EXPORT TES_SAPU_PASTI boolean false
EXPORT MAX_FREE number 10
EXPORT Rarities TABLE
EXPORT SPIN_PRICE number 200000
EXPORT Items TABLE

### MODULE KotakController = ReplicatedStorage.NKSystem.Controller.KotakController
REQUIRE true table

### FUNCTION KotakController.KnitStart
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=KnitStart
C1 GetService
C2 KotakService
C3 PlayerGui
C4 WaitForChild
C5 KotakMisteriUI
C6 [KotakController] StarterGui.KotakMisteriUI tidak ada
C7 Layar
C8 Kotak
C9 Skala
C10 Badan
C11 Tutup
C12 Sinar
C13 Sinar2
C14 Cahaya
C15 Judul
C16 UIStroke
C17 FindFirstChildOfClass
C18 Hadiah
C19 _Kartu
C20 Info
C21 Kilat
C22 Konfeti
C23 Visible
C24 task
C25 spawn
C27 Backpack
C28 ChildAdded
C30 Connect
C31 Character
C32 CharacterAdded
U1 table table: 0x978ac45f0836dcee
  [Buka] FUNCTION

### FUNCTION KotakController.KnitStart.U1.Buka
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0xd645164a95ec7146

### FUNCTION KotakController.KnitStart.U1.Buka.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Buka
U4 function function: 0x47d94365ca8726da
  [Jumlah] FUNCTION

### FUNCTION KotakController.KnitStart.U1.Jumlah
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client.ClientComm line=nil name=
U1 function function: 0xa0158c857f33215e

### FUNCTION KotakController.KnitStart.U1.Jumlah.U1
INFO =ReplicatedStorage.NKSystem.Packages._Index.sleitnick_comm@1.0.1.comm.Client line=nil name=
C1 table
C2 pack
C4 new
U1 table table: 0x8729f6b64b33e49a
U2 boolean false
U3 userdata ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Jumlah
U4 function function: 0x8f8a288dcf5027a3
  [JumlahBerubah] TABLE table: 0xe9e9c4357464e8ec
U2 table table: 0x1268e2a2975741b5
U3 userdata Players.Raelity911
U4 function function: 0xa3f535e7a679ae1f

### FUNCTION KotakController.KnitStart.U4
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=
U5 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
U6 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kotak
U7 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kotak.Skala
U8 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Badan
U9 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Tutup
U10 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar
U11 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar2
U12 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Cahaya
U13 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul
U14 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.Skala
U15 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.UIStroke
U16 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah
U17 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah._Kartu
U18 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info
U19 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info.UIStroke
U20 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kilat
U21 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Konfeti
U22 function function: 0x53eb7b28b7e31c36

### FUNCTION KotakController.KnitStart.U22
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=pantau
C1 ipairs
C3 GetChildren
C4 ChildAdded
C5 Connect
U1 function function: 0x50efa237f24258a9

### FUNCTION KotakController.KnitStart.U22.U1
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=pasangTool
C1 Tool
C2 IsA
C3 KotakMisteri
C4 GetAttribute
C5 Activated
C6 Connect
C7 Unequipped
U1 table table: 0xfda9eafd1f39bdeb
U2 function function: 0xc53b28b35ed2d429
U3 boolean false
U4 function function: 0x90ad1147bbc0a559
EXPORT Name string KotakController
EXPORT _uji TABLE

### FUNCTION KotakController._uji.buka
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=buka
C1 task
C2 wait
C4 0.14
C5 1
C6 Visible
C7 BackgroundTransparency
C8 0.35
C10 TweenInfo
C11 new
C13 0.25
C14 Enum
C15 EasingStyle
C16 Quad
C18 EasingDirection
C19 Out
C21 Create
C22 Play
C23 UDim2
C24 fromScale
C26 0.5
C27 0.42
C28 Position
C29 Rotation
C30 ImageTransparency
C31 0.99
C32 Scale
C34 Back
C36 0.6
C38 1.2
C39 0.7
C41 0.3
C42 Size
C43 0.45
C45 0.46
C46 TextTransparency
C47 Transparency
C48 MEMBUKA KOTAK...
C49 Text
C50 Color3
C51 fromRGB
C53 Color
C54 Disconnect
C55 RenderStepped
C56 Connect
C57 Buka
C58 andThen
C59 catch
C60 os
C61 clock
C63 1.15
C64 math
C65 clamp
C67 3
C68 16
C69 46
C70 sin
C73 random
C75 0.16
C76 0.05
C77 24
C78 abs
C80 0.17
C81 0.11
C82 0.2
C83 1.1
C84 Instance
C86 Sound
C87 rbxassetid://1169806635
C88 SoundId
C89 Volume
C90 PlaybackSpeed
C91 Parent
C92 AddItem
C93 Wait
C94 type
C96 table
C97 BELUM BISA DIBUKA
C98 string
C99 Coba lagi sebentar.
C100 0
C103 delay
C105 2.2
C106 IsLoaded
C107 1.25
C108 Elastic
C110 ipairs
C112 Skala
C114 0.9
C116 0.08
C117 0.34
C120 0.4
C122 kunci
C123 Vector2
C125 AbsoluteSize
C126 X
C127 Y
C128 SFX
C129 muncul
C130 
C131 1.5
C132 kembangApi
C133 JACKPOT! KAMU DAPAT:
C134 KAMU DAPAT:
C135 jenis
C136 uang
C137 nilai
C138 format
C141 insert
C143 xp
C148 kotoran
C151 0.32
U1 boolean false
U2 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
U3 boolean false
U4 function function: 0x90ad1147bbc0a559

### FUNCTION KotakController._uji.buka.U4
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=tutup
C1 1
C2 0.12
C3 0.3
C4 BackgroundTransparency
C6 TweenInfo
C7 new
C9 Enum
C10 EasingStyle
C11 Quad
C13 EasingDirection
C14 Out
C16 Create
C17 Play
C18 ImageTransparency
C20 TextTransparency
C22 Transparency
C24 ipairs
C26 GetChildren
C27 Name
C28 Kartu
C29 Pop
C30 Scale
C31 0
C33 Back
C35 In
C37 task
C38 delay
C40 0.05
U1 number 0
U2 boolean false
U3 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
U4 userdata TweenService
U5 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar
U6 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar2
U7 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Cahaya
U8 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kotak
U9 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Badan
U10 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Tutup
U11 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul
U12 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.UIStroke
U13 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info
U14 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info.UIStroke
U15 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah
U16 function function: 0x8276454e15396f79

### FUNCTION KotakController._uji.buka.U4.U16
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=bersihKartu
C1 ipairs
C3 GetChildren
C4 Name
C5 Kartu
C6 Destroy
U1 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah
U5 number 0
U6 function function: 0x8276454e15396f79
U7 userdata TweenService
U8 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kotak
U9 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Badan
U10 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Tutup
U11 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Cahaya
U12 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kotak.Skala
U13 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar
U14 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Sinar2
U15 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info
U16 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Info.UIStroke
U17 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul
U18 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.UIStroke
U19 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.Skala
U21 userdata Run Service
U22 table table: 0x978ac45f0836dcee
U23 userdata SoundService
U24 userdata Debris
U25 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kilat
U26 function function: 0x6f905b8333c46aa1

### FUNCTION KotakController._uji.buka.U26
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=konfeti
C1 AbsoluteSize
C2 Vector2
C3 new
C5 0.5
C6 X
C7 0.42
C8 Y
C9 Instance
C11 Frame
C12 math
C13 random
C15 UDim2
C16 fromOffset
C18 0
C19 Size
C20 AnchorPoint
C21 Position
C22 Rotation
C23 BackgroundColor3
C24 BorderSizePixel
C25 ZIndex
C26 Parent
C27 0.4
C28 UICorner
C29 UDim
C31 CornerRadius
C32 2
C33 3.141592653589793
C34 100
C35 cos
C37 0.8
C38 sin
C41 Enum
C42 EasingStyle
C43 Quad
C45 TweenInfo
C47 EasingDirection
C48 Out
C50 Create
C51 Play
C52 task
C53 delay
C55 1.2
C56 AddItem
U1 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
U2 table table: 0x0c5ab9f748e36839
  [1] userdata 1, 0.803922, 0.235294
  [2] userdata 0.745098, 0.470588, 1
  [3] userdata 1, 0.470588, 0.745098
  [4] userdata 0.352941, 0.862745, 1
  [5] userdata 1, 1, 1
  [6] userdata 0.470588, 0.921569, 0.54902
U3 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Konfeti
U4 userdata TweenService
U5 userdata Debris
U27 table table: 0xc830b57d40ec4fb4
  [MUSIK_DANCE] string 78852932059882
  [AVATAR_USER_ID] number 8131035694
  [TOLAK_PRIVATE_SERVER] boolean false
  [PENGUMUMAN] string ADMIN ABUSE dimulai! Owner datang melempar Kotak Misteri. Pungut sebanyak-banyaknya lalu buka dari hotbar!
  [LEMPAR_JEDA] TABLE table: 0x623757db8d07fada
  [TITIK_CADANGAN] vector -735, 16, -275
  [PELUANG_KE_PEMAIN] number 0.3
  [SEBAR_MAKS] number 500
  [KUOTA_MAKS] TABLE table: 0x6de96da29d6d087f
  [MAKS_DROP_AKTIF] number 60
  [UMUR_DROP] number 40
  [TENGGELAM] number 0.38
  [BULAT_UANG] number 1000
  [SEBAR_TITIK] TABLE table: 0x3e0a1b1bac9484cf
  [ANIM_JOGET] TABLE table: 0xdae4f5cdf80e58bf
  [IKON] TABLE table: 0x06ec74636a5fa23b
  [JENIS_DANCE] TABLE table: 0x484f90e4b8b6c907
  [JEDA_ANTAR_DROP] number 0.12
  [LANGIT] TABLE table: 0x9b03b90598009152
  [KOTAK] TABLE table: 0x2cc0f8d535836cca
  [SEBAR_PEMAIN] TABLE table: 0x7efa0f71edc959d3
  [SUDUT_SEBAR_TITIK] number 65
  [EMOTE_ACAK] TABLE table: 0x160652eea75ba614
  [ABAIKAN_SYARAT_DI_STUDIO] boolean true
  [JARAK_AMBIL] number 7
  [KUOTA_DEFAULT] TABLE table: 0xd0b7593e78719645
  [VOLUME_MUSIK] number 0.6
  [BURST] number 14
  [OTOMATIS] TABLE table: 0x748fcce3eabfafc8
  [PER_GELOMBANG] TABLE table: 0xd0f66bbccbac3419
  [PITCH_TING] TABLE table: 0xd46952c40308951d
  [SEBAR_PER_TICK] number 20
  [SPEED_MUSIK] number 0.4
  [EFEK_MUSIK] TABLE table: 0x2fd6623f47a748b2
  [MIN_PEMAIN] number 4
  [WARNA_KABUT] userdata 0.92549, 0.909804, 0.972549
  [SFX] TABLE table: 0x9dc304df20f56ad4
  [MAKS_FASE_LEMPAR] number 1800
  [JENIS] TABLE table: 0xa335672ee9f7845d
  [NAMA] TABLE table: 0xb62604e500e8adbc
  [MAJU_TITIK] number 45
  [DURASI] TABLE table: 0x155a7f91fbba0b2d
  [KLAIM_PER_DETIK] number 12
  [JARAK_KLAIM_SERVER] number 18
  [ANIM] TABLE table: 0x78ac9570b45e30b1
  [TITIK_NAMA] string AdminAbuseTitik
  [TINGGI_AVATAR] number 509
  [CUTSCENE] boolean true
  [SEBAR_AREA] TABLE table: 0x23ad9c84c3108c14
  [WARNA] TABLE table: 0x8b14e9220e12729f
  [daftarAnim] FUNCTION

### FUNCTION KotakController._uji.buka.U27.daftarAnim
INFO =ReplicatedStorage.NKSystem.Config.AdminAbuseConfig line=nil name=daftarAnim
C1 game
C2 Ugc
C3 ReplicatedStorage
C4 GetService
C5 NKSystem
C6 FindFirstChild
C7 Assets
C8 Dance
C9 ipairs
C11 GetChildren
C12 Animation
C13 IsA
C14 Name
C15 dance
C16 table
C17 insert
C19 Emote
C20 Emote/
C21 emote
C22 sort
  [LAMA_TERBANG] number 2.6
  [cariAnim] FUNCTION

### FUNCTION KotakController._uji.buka.U27.cariAnim
INFO =ReplicatedStorage.NKSystem.Config.AdminAbuseConfig line=nil name=cariAnim
C1 type
C3 string
C4 
C5 game
C6 Ugc
C7 ReplicatedStorage
C8 GetService
C9 NKSystem
C10 FindFirstChild
C11 Assets
C12 Dance
C13 ^Emote/(.+)$
C14 match
C15 Emote
C16 Animation
C17 IsA
  [PER_DROP] TABLE table: 0xd2baa2b1a563322c
  [LANGIT_MALAM] TABLE table: 0x65a0b0dd98c366e2
  [TOPIC] string NK_AdminAbuseEvent_v1
U28 function function: 0x909667640ddea25e

### FUNCTION KotakController._uji.buka.U28
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=aturJudul
C1 Text
C2 TextTransparency
C3 Transparency
C4 Color3
C5 fromRGB
C7 Color
C8 0.5
C9 Scale
C10 1
C12 Enum
C13 EasingStyle
C14 Back
C16 TweenInfo
C17 new
C19 0.35
C20 Quad
C22 EasingDirection
C23 Out
C25 Create
C26 Play
U1 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul
U2 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.UIStroke
U3 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Judul.Skala
U4 userdata TweenService
U29 function function: 0xad0397e34622275f

### FUNCTION KotakController._uji.buka.U29
INFO =ReplicatedStorage.NKSystem.Controller.KotakController line=nil name=kartu
C1 jenis
C2 Clone
C3 Kartu
C4 Name
C5 LayoutOrder
C6 Visible
C7 Garis
C8 warna
C9 Color
C10 ikon
C11 Ikon
C12 Image
C13 IkonTeks
C14 teks
C15 Text
C16 BackgroundColor3
C17 Pop
C18 Scale
C19 Parent
C20 Jumlah
C21 FindFirstChild
C22 format
C23 Heartbeat
C24 Wait
C25 AbsoluteSize
C26 Vector2
C27 new
C29 0.5
C30 X
C31 0.37
C32 Y
C33 AbsolutePosition
C34 2
C35 0.15
C36 math
C37 min
C39 0.22
C40 Terbang
C41 UIAspectRatioConstraint
C42 FindFirstChildOfClass
C43 Destroy
C44 AnchorPoint
C45 UDim2
C46 fromOffset
C48 Size
C49 Position
C50 random
C52 Rotation
C53 Instance
C55 NumberValue
C56 Changed
C57 Connect
C58 Value
C59 1
C61 Enum
C62 EasingStyle
C63 Sine
C65 EasingDirection
C66 InOut
C68 TweenInfo
C70 0.55
C71 Quad
C73 Out
C75 Create
C76 Play
C78 0
C80 Back
C82 0.8
C83 pitch
C84 Sound
C85 rbxassetid://1169806635
C86 SoundId
C87 0.45
C88 Volume
C89 PlaybackSpeed
C90 AddItem
C91 task
C92 wait
C94 1.2
C95 0.3
C97 nilai
C98 Quart
C100 0.75
C101 Completed
C102 Once
C103 0.6
C104 kunci
C105 Thickness
C106 spawn
C108 delay
C110 0.05
U1 table table: 0xe81820febc5e3b5e
  [kotoran] TABLE table: 0x3767d77a2eb18561
  [uang] TABLE table: 0xa8d0c08bc644d684
  [xp] TABLE table: 0x7846152a39a8d1bb
  [kunci] TABLE table: 0x64fe2d3a516f77fb
U2 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah._Kartu
U3 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Hadiah
U4 userdata Run Service
U5 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
U6 userdata TweenService
U7 userdata SoundService
U8 userdata Debris
U9 function function: 0x6f905b8333c46aa1

### REMOTE INVENTORY
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimReward
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.Spin
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithFree
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithMoney
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetState
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimOneMultiReward
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetInventory
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinWithMoney
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimMultiReward
RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RE.StateChanged
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MisiService.RF.Claim
RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RE.Updated
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.ClaimReward
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.GetDeadline
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.OwnerCompleteMission
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.GetState
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Buka
RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Jumlah
RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RE.JumlahBerubah
REMOTE MATCHES 19

### LOADED FUNCTION SEARCH

GC HIT 1 constants==== RAEL BLIND BOX FULL DIAGNOSIS ===, BlindBoxTampil, blindbox, blind box, bukablindbox, claimcallback, BlindBoxLayar, BLIND BOX DIAGNOSIS SELESAI | hasil disalin dan disimpan sebagai Hasil.lua

### FUNCTION GC_HIT_1
INFO ijpgWeQUWsRMisjdLNSo line=nil name=
C1 game
C3 ReplicatedStorage
C4 GetService
C5 Players
C6 LocalPlayer
C13 === RAEL BLIND BOX FULL DIAGNOSIS ===
C14 Player 
C15 Name
C16  | 
C17 os
C18 date
C20 %Y-%m-%d %H:%M:%S
C21 GachaController
C22 BlindBoxTampil
C23 GachaConfig
C24 KotakController
C25 ipairs
C27 
### MODULE 
C28  = 
C29 require
C31 pcall
C33 REQUIRE 
C34 tostring
C36  
C37 type
C39 table
C40 pairs
C42 function
C43 .
C44 EXPORT 
C45  TABLE
C46 typeof
C48 Instance
C49   
C50 
### REMOTE INVENTORY
C51 GetDescendants
C52 RemoteEvent
C53 IsA
C54 RemoteFunction
C55 BindableEvent
C56 BindableFunction
C57 GetFullName
C58 lower
C59 gacha
C60 find
C61 blind
C62 kotak
C63 reward
C64 claim
C65 1
C66 ClassName
C67 REMOTE MATCHES 
C68 
### LOADED FUNCTION SEARCH
C69 getgc
C71 debug
C73 getconstants
C75 string
C76 blindbox
C77 blind box
C78 bukablindbox
C79 claimcallback
C80 
GC HIT 
C81  constants=
C82 concat
C84 , 
C85 GC_HIT_
C86 GC SEARCH LIMIT 80
C87 GC HITS 
C88  getgc=
C89 getgc/debug.getconstants unavailable
C90 
### LIVE GUI
C91 PlayerGui
C92 FindFirstChild
C93 BlindBoxLayar
C94 GUI 
C95 TextButton
C96 TextLabel
C97  Text=
C98 Text
C99  Visible=
C100 Visible
C101 

C102 setclipboard
C104 writefile
C106 Hasil.lua
C107 print
C109 BLIND BOX DIAGNOSIS SELESAI | hasil disalin dan disimpan sebagai Hasil.lua

GC HIT 2 constants==== RAEL BLIND BOX FULL DIAGNOSIS ===, BlindBoxTampil, blindbox, blind box, bukablindbox, claimcallback, BlindBoxLayar, BLIND BOX DIAGNOSIS SELESAI | hasil disalin dan disimpan sebagai Hasil.lua

### FUNCTION GC_HIT_2
INFO ROiPNveylEYiSfBwEtPU line=nil name=
C1 game
C3 ReplicatedStorage
C4 GetService
C5 Players
C6 LocalPlayer
C13 === RAEL BLIND BOX FULL DIAGNOSIS ===
C14 Player 
C15 Name
C16  | 
C17 os
C18 date
C20 %Y-%m-%d %H:%M:%S
C21 GachaController
C22 BlindBoxTampil
C23 GachaConfig
C24 KotakController
C25 ipairs
C27 
### MODULE 
C28  = 
C29 require
C31 pcall
C33 REQUIRE 
C34 tostring
C36  
C37 type
C39 table
C40 pairs
C42 function
C43 .
C44 EXPORT 
C45  TABLE
C46 typeof
C48 Instance
C49   
C50 
### REMOTE INVENTORY
C51 GetDescendants
C52 RemoteEvent
C53 IsA
C54 RemoteFunction
C55 BindableEvent
C56 BindableFunction
C57 GetFullName
C58 lower
C59 gacha
C60 find
C61 blind
C62 kotak
C63 reward
C64 claim
C65 1
C66 ClassName
C67 REMOTE MATCHES 
C68 
### LOADED FUNCTION SEARCH
C69 getgc
C71 debug
C73 getconstants
C75 string
C76 blindbox
C77 blind box
C78 bukablindbox
C79 claimcallback
C80 
GC HIT 
C81  constants=
C82 concat
C84 , 
C85 GC_HIT_
C86 GC SEARCH LIMIT 80
C87 GC HITS 
C88  getgc=
C89 getgc/debug.getconstants unavailable
C90 
### LIVE GUI
C91 PlayerGui
C92 FindFirstChild
C93 BlindBoxLayar
C94 GUI 
C95 TextButton
C96 TextLabel
C97  Text=
C98 Text
C99  Visible=
C100 Visible
C101 

C102 setclipboard
C104 writefile
C106 Hasil.lua
C107 print
C109 BLIND BOX DIAGNOSIS SELESAI | hasil disalin dan disimpan sebagai Hasil.lua

GC HIT 3 constants=[GachaController] BlindBox.mulai gagal:, [GachaController] BlindBox.pilih gagal:, [GachaController] BlindBox.buka gagal:

### FUNCTION GC_HIT_3
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=bukaBlindBox
C1 mulai
C2 pcall
C4 [GachaController] BlindBox.mulai gagal:
C5 ipairs
C7 pilih
C8 [GachaController] BlindBox.pilih gagal:
C9 buka
C10 [GachaController] BlindBox.buka gagal:
C11 selesai
U1 table table: 0x275158e6aaacd7b0
  [mulai] FUNCTION
  [aktif] FUNCTION
  [selesai] FUNCTION
  [buka] FUNCTION
  [pilih] FUNCTION
U2 function function: 0xa3e060376941be0a

### FUNCTION GC_HIT_3.U2
INFO =ReplicatedStorage.NKSystem.Controller.GachaController line=nil name=
U3 function function: 0x18296380d3b14dd4
GC HITS 3 getgc=true

### LIVE GUI
GUI Players.Raelity911.PlayerGui.BlindBoxLayar
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Tutup.TextLabel Text=X Visible=false
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Tutup.X Text=X Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak1 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak2 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak3 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak4 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak5 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak6 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak7 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak8 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak9 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak10 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak11 Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak12 Text= Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Judul Text=BLIND BOX Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Hitung Text=Kotak 1 / 10 Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Hint Text=Ketuk kotak, ketuk lagi untuk membuka Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Nama Text= Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Sub Text= Visible=true
TextButton Players.Raelity911.PlayerGui.BlindBoxLayar.Auto Text= Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Auto.Ikon Text=▶▶ Visible=true
TextLabel Players.Raelity911.PlayerGui.BlindBoxLayar.Auto.Label Text=AUTO BUKA: MATI Visible=true
