=== BLIND BOX DEEP DIAGNOSIS ===
PLAYER Players.Raelity911 TIME 2026-11-20 19:46:19
READ ONLY | NO HOOKS | NO REMOTE CALLS | NO UI CLICKS

=== 1. KNOWN MODULES ===
[MODULE] ReplicatedStorage.NKSystem.Controller.GachaController
[MODULE] ReplicatedStorage.NKSystem.Controller.KotakController
[MODULE] ReplicatedStorage.NKSystem.Util.GachaConfig
[MODULE] ReplicatedStorage.NKSystem.Util.BlindBoxTampil

=== 2. LIVE BLIND BOX UI ===
[GUI] Players.Raelity911.PlayerGui.BlindBoxLayar
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tutup Visible=false Active=true Text=ImageButton
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Tutup.TextLabel Text=X Visible=false
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Tutup.X Text=X Visible=true
[OBJECT] ViewportFrame Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia
[OBJECT] Camera Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Camera
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Rak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[OBJECT] Model Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Kotak
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak1 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak2 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak3 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak4 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak5 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak6 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak7 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak8 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak9 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak10 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak11 Visible=true Active=true Text=
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Tombol.Kotak12 Visible=true Active=true Text=
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Judul Text=BLIND BOX Visible=true
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Hitung Text=Kotak 1 / 10 Visible=true
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Hint Text=Ketuk kotak, ketuk lagi untuk membuka Visible=true
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Nama Text= Visible=true
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Sub Text= Visible=true
[BUTTON] Players.Raelity911.PlayerGui.BlindBoxLayar.Auto Visible=true Active=true Text=
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Auto.Ikon Text=▶▶ Visible=true
[LABEL] Players.Raelity911.PlayerGui.BlindBoxLayar.Auto.Label Text=AUTO BUKA: MATI Visible=true

=== 3. FULL GC ENUMERATION ===
GC TOTAL 184019
PASS1 objects=184019 functions=17560 tables=8917 targetFunctions=0
ORCHESTRATOR NOT FOUND IN FULL GC. It may not be loaded in this client session, or constants API is limited.

=== 4. DIRECT CALLER / CLOSURE REFERENCES ===
DIRECT CALLER COUNT 0

=== 5. BLIND / REWARD / CLAIM FUNCTION CANDIDATES ===

[FUNCTION] TARGET VOCAB CANDIDATE 1 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string key
 C2 string KotakJumlah
 C3 string Jumlah
 C4 string 
 C5 string Text
 C6 string play
 C7 string tabKlik
 C8 number 0.4
 U1 string uang
 U2 TABLE table: 0x87562a03e0fa674b
  [target] number 5000
  [ikon] string rbxassetid://82796392606041
  [key] string gold
  [nama] string Gold
 U3 boolean false
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U5 TABLE table: 0x922def0a5865bdc8
  [Volume] TABLE
  [play] FUNCTION
  [Ids] TABLE
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U7 FUNCTION function: 0xde5ac185e0315c2c

[FUNCTION] TARGET VOCAB CANDIDATE 1.U7 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=renderAset line=nil
 C1 string ipairs
 C3 string Aset
 C4 string Aset_
 C5 string key
 C6 string FindFirstChild
 C7 string tersimpan
 C8 string target
 C9 string math
 C10 string clamp
 C12 string Angka
 C13 string Tersimpan %s / %s
 C14 string format
 C15 string Text
 C16 string Persen
 C17 number 100
 C18 number 10
 C19 string floor
 C21 string %.
 C22 string f
 C23 string %.?0+$
 C24 string 
 C25 string gsub
 C26 string ,
 C27 string %
 C28 string TextColor3
 C29 string Bar
 C30 string Isi
 C31 string UDim2
 C32 string fromScale
 C34 number 0.001
 C35 string max
 C37 string Size
 C38 string Visible
 C39 string Garis
 C40 string Color
 C41 number 3.5
 C42 string Thickness
 C43 string Grad
 C44 string ColorSequence
 C45 string new
 U1 TABLE table: 0x59dabc891f89831a
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U3 TABLE table: 0x04027be883d7d448
 U4 FUNCTION function: 0x0079ae9ce4e1b480
 U5 userdata 0.180392, 0.619608, 0.356863
 U6 userdata 0.290196, 0.145098, 0.0666667
 U7 string uang
 U8 userdata 0.121569, 0.701961, 0.631373
 U9 userdata 1, 0.952941, 0.768627
 U10 userdata 1, 0.854902, 0.478431
 U11 userdata 1, 0.984314, 0.941176
 U12 userdata 0.968627, 0.894118, 0.741176
 U8 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 1.U8 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=renderSetor line=nil
 C1 string cariAset
 C2 string setor
 C3 string TabSetor
 C4 string Primary
 C5 string Disabled
 C6 string setButton
 C7 string Teks
 C8 string SETOR
 C9 string Text
 C10 string TabTarik
 C11 string TARIK
 C12 string Saldo
 C13 string Saldo %s kamu: <b>%s</b>
 C14 string nama
 C15 string key
 C16 string saldo
 C17 string rupiah
 C18 string Rp 
 C19 string  
 C20 string kunci
 C21 string Kunci
 C22 string format
 C23 string Tersimpan di brankas: <b>%s</b>
 C24 string tersimpan
 C25 string KotakJumlah
 C26 string Prefiks
 C27 string Visible
 C28 string Jumlah
 C29 string UDim2
 C30 string fromScale
 C32 number 0.15
 C33 number 0.04
 C34 number 0.12
 C35 string Position
 C36 number 0.82
 C37 number 0.93
 C38 number 0.76
 C39 string Size
 C40 string Jumlah %s yang disetor
 C41 string Jumlah %s yang ditarik
 C42 string PlaceholderText
 C43 string target
 C44 string math
 C45 string min
 C47 string max
 C49 string 
 C50 string %D
 C51 string gsub
 C52 number 0
 C53 string tonumber
 C55 string Pratinjau
 C56 string TextColor3
 C57 string  sudah mencapai target
 C58 string  kamu kosong
 C59 string Belum ada 
 C60 string  di brankas
 C61 string Maksimal %s
 C62 string persen
 C63 string abs
 C65 string Progres total %s%s  →  %s%s
 C66 string +
 C67 string -
 C68 number 10
 C69 string floor
 C71 string %.
 C72 string f
 C73 string %.?0+$
 C74 string ,
 C75 string %
 C76 string   (maks 
 C77 number 1000000000
 C78 string  M
 C79 number 1000000
 C80 string  jt
 C81 string )
 C82 string Setor
 C83 string Secondary
 C84 string ...
 C85 string SETOR KE BRANKAS
 C86 string TARIK KE DOMPET
 C87 string Cepat
 U1 TABLE table: 0x59dabc891f89831a
 U2 string uang
 U3 string setor
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U5 TABLE table: 0xceb1377140a7e40c
 U6 TABLE table: 0x04027be883d7d448
 U7 FUNCTION function: 0x22b58e8f699498a6
 U8 userdata 0.54902, 0.478431, 0.4
 U9 FUNCTION function: 0x369aabeb24817386
 U10 userdata 0.180392, 0.619608, 0.356863
 U11 userdata 0.752941, 0.223529, 0.168627
 U12 boolean false
 U9 FUNCTION function: 0xd853cd43ac375f3a

[FUNCTION] TARGET VOCAB CANDIDATE 1.U9 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=renderProgres line=nil
 C1 string persen
 C2 string tahap
 C3 string Persen
 C4 number 10
 C5 string math
 C6 string floor
 C8 string %.
 C9 string f
 C10 string format
 C11 string %.?0+$
 C12 string 
 C13 string gsub
 C14 string ,
 C15 string %
 C16 string Text
 C17 string Bar
 C18 string Isi
 C19 string UDim2
 C20 string fromScale
 C22 number 100
 C23 number 0.001
 C24 string max
 C26 string Size
 C27 string Visible
 C28 string Tahap
 C29 string Teks
 C30 string TAHAP %d  •  %s
 C31 string nama
 C32 string upper
 C33 string warna
 C34 string Grad
 C35 string FindFirstChild
 C36 string ColorSequence
 C37 string new
 C39 string Color3
 C41 number 0.25
 C42 string Lerp
 C43 string Color
 C44 string BELUM ADA TAHAP
 C45 string ipairs
 C47 string Node
 C48 string BackgroundColor3
 C49 string Garis
 C50 number 2.5
 C51 string Thickness
 C52 string ✓
 C53 string tostring
 C55 string Label
 C56 number 0.35
 C57 string TextColor3
 U1 TABLE table: 0x04027be883d7d448
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuProgres
 U3 TABLE table: 0x59dabc891f89831a
 U4 userdata 0.709804, 0.639216, 0.521569
 U5 number 1
 U6 userdata 0.121569, 0.701961, 0.631373
 U7 userdata 0.290196, 0.145098, 0.0666667
 U8 userdata 0.54902, 0.478431, 0.4
 U10 FUNCTION function: 0x73d566cadc2eee54

[FUNCTION] TARGET VOCAB CANDIDATE 1.U10 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=renderHadiah line=nil
 C1 string Tahap
 C2 string tahap
 C3 string persen
 C4 string Lencana
 C5 string Teks
 C6 string TAHAP 
 C7 string Text
 C8 string warna
 C9 string Grad
 C10 string FindFirstChild
 C11 string ColorSequence
 C12 string new
 C14 string Color3
 C16 number 0.25
 C17 string Lerp
 C18 string Color
 C19 string Nama
 C20 string nama
 C21 string upper
 C22 number 0.45
 C23 string TextColor3
 C24 string Status
 C25 string BackgroundColor3
 C26 string TAHAP KAMU
 C27 string TERBUKA
 C28 string Syarat
 C29 string Sudah terbuka  •  syarat progres %d%%
 C30 string format
 C31 string TERKUNCI
 C32 string math
 C33 string max
 C35 string Semua target penuh (100%%)  •  kurang %s
 C36 number 10
 C37 string floor
 C39 string %.
 C40 string f
 C41 string %.?0+$
 C42 string 
 C43 string gsub
 C44 string ,
 C45 string %
 C46 string Butuh progres %d%%  •  kurang %s
 C47 string Daftar
 C48 string Hadiah
 C49 string hadiah
 C50 string Visible
 C51 string fromHex
 C53 string #6B5A45
 C54 string Ikon
 U1 TABLE table: 0x59dabc891f89831a
 U2 number 1
 U3 TABLE table: 0x04027be883d7d448
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuHadiah
 U5 userdata 0.290196, 0.145098, 0.0666667
 U6 userdata 0.180392, 0.619608, 0.356863
 U7 userdata 0.709804, 0.639216, 0.521569

[FUNCTION] TARGET VOCAB CANDIDATE 2 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string key
 C2 string KotakJumlah
 C3 string Jumlah
 C4 string 
 C5 string Text
 C6 string play
 C7 string tabKlik
 C8 number 0.4
 U1 string uang
 U2 TABLE table: 0x884896541474f606
  [target] number 100000
  [ikon] string rbxassetid://103696452648775
  [key] string kunci
  [nama] string Kunci Emas
 U3 boolean false
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U5 TABLE table: 0x922def0a5865bdc8
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U7 FUNCTION function: 0xde5ac185e0315c2c
 U8 FUNCTION function: 0x3254f0c70dc4d97b
 U9 FUNCTION function: 0xd853cd43ac375f3a
 U10 FUNCTION function: 0x73d566cadc2eee54

[FUNCTION] TARGET VOCAB CANDIDATE 3 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string key
 C2 string KotakJumlah
 C3 string Jumlah
 C4 string 
 C5 string Text
 C6 string play
 C7 string tabKlik
 C8 number 0.4
 U1 string uang
 U2 TABLE table: 0x358b3959722f4ac8
  [ikon] string rbxassetid://79619577477373
  [key] string uang
  [target] number 5000000000
  [rupiah] boolean true
  [nama] string Uang
 U3 boolean false
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U5 TABLE table: 0x922def0a5865bdc8
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U7 FUNCTION function: 0xde5ac185e0315c2c
 U8 FUNCTION function: 0x3254f0c70dc4d97b
 U9 FUNCTION function: 0xd853cd43ac375f3a
 U10 FUNCTION function: 0x73d566cadc2eee54

[FUNCTION] TARGET VOCAB CANDIDATE 4 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string nilai
 C2 string besar
 C3 string mode
 C4 string jumlah
 C5 string jual
 C6 string q
 C7 string HARGA_MIN
 C8 string HARGA_MAKS
 C9 string math
 C10 string floor
 C12 string clamp
 C14 string PopupAngka
 C15 string Kartu
 C16 string sibuk
 C17 string Kotak
 C18 string Angka
 C19 string 
 C20 string Text
 U1 TABLE table: 0xb22bcf6cf89a19c2
  [nilai] number 0
  [kecil] number 1
  [besar] number 10
 U2 TABLE table: 0x7a52fdbf20ff8ac4
  [tab] string Beli
  [urut] number 1
  [kat] string semua
  [proses] boolean false
  [daftar] TABLE
  [stok] TABLE
  [terbuka] boolean false
  [token] number 0
 U3 TABLE table: 0xdbe0587e2dff8d22
  [HARGA_MIN] number 100
  [DURASI] number 172800
  [SLOT] number 5
  [Kategori] FUNCTION
  [SLOT_VIP] number 10
  [Angka] FUNCTION
  [Rupiah] FUNCTION
  [Bersih] FUNCTION
  [JUMLAH_MAKS] number 1000000
  [KATEGORI] TABLE
  [Pajak] FUNCTION
  [HARGA_MAKS] number 5000000000
  [PAJAK] number 0
  [MIN_LEVEL_JUAL] number 10
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 4.U5 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=infoPopup line=nil
 C1 string PopupAngka
 C2 string Kartu
 C3 string jual
 C4 string mode
 C5 string jumlah
 C6 string Info
 C7 string Kamu punya 
 C8 string q
 C9 string Angka
 C10 string  
 C11 string 
 C12 string kat
 C13 string gold
 C14 string kunci
 C15 string pet
 C16 string buah
 C17 string Text
 C18 number 1
 C19 string math
 C20 string max
 C22 string nilai
 C23 string ≈ 
 C24 string floor
 C26 string Rupiah
 C27 string  / satuan
 C28 string table
 C29 string insert
 C31 string termurah
 C32 string termurah 
 C33 string concat
 C35 string   ·  
 C36 string Harga untuk 
 C37 string nama
 C39 string -
 C40 string  ×
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xb22bcf6cf89a19c2
 U4 TABLE table: 0xdbe0587e2dff8d22

[FUNCTION] TARGET VOCAB CANDIDATE 5 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string nilai
 C2 string kecil
 C3 string mode
 C4 string jumlah
 C5 string jual
 C6 string q
 C7 string HARGA_MIN
 C8 string HARGA_MAKS
 C9 string math
 C10 string floor
 C12 string clamp
 C14 string PopupAngka
 C15 string Kartu
 C16 string sibuk
 C17 string Kotak
 C18 string Angka
 C19 string 
 C20 string Text
 U1 TABLE table: 0xb22bcf6cf89a19c2
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 6 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string nilai
 C2 string kecil
 C3 string mode
 C4 string jumlah
 C5 string jual
 C6 string q
 C7 string HARGA_MIN
 C8 string HARGA_MAKS
 C9 string math
 C10 string floor
 C12 string clamp
 C14 string PopupAngka
 C15 string Kartu
 C16 string sibuk
 C17 string Kotak
 C18 string Angka
 C19 string 
 C20 string Text
 U1 TABLE table: 0xb22bcf6cf89a19c2
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 7 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string nilai
 C2 string besar
 C3 string mode
 C4 string jumlah
 C5 string jual
 C6 string q
 C7 string HARGA_MIN
 C8 string HARGA_MAKS
 C9 string math
 C10 string floor
 C12 string clamp
 C14 string PopupAngka
 C15 string Kartu
 C16 string sibuk
 C17 string Kotak
 C18 string Angka
 C19 string 
 C20 string Text
 U1 TABLE table: 0xb22bcf6cf89a19c2
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 8 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string sibuk
 C2 string mode
 C3 string jumlah
 C4 string jual
 C5 string q
 C6 string HARGA_MIN
 C7 string HARGA_MAKS
 C8 string Kotak
 C9 number 0
 C10 string Text
 C11 string %D
 C12 string 
 C13 string gsub
 C14 string tonumber
 C16 string math
 C17 string min
 C19 string nilai
 U1 TABLE table: 0xb22bcf6cf89a19c2
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket.PopupAngka.Kartu
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 9 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string 
 C2 string KotakJumlah
 C3 string Jumlah
 C4 string Text
 C5 string %D
 C6 string gsub
 C7 number 0
 C8 string tonumber
 C10 number 1000000000000
 C11 string math
 C12 string min
 C14 number 1
 C15 string CursorPosition
 U1 boolean false
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U3 FUNCTION function: 0x22b58e8f699498a6

[FUNCTION] TARGET VOCAB CANDIDATE 9.U3 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=rapi line=nil
 C1 number 0.5
 C2 string math
 C3 string floor
 C5 string tostring
 C7 string reverse
 C8 string (%d%d%d)
 C9 string %1.
 C10 string gsub
 C11 string sub
 C12 string .
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor.KotakJumlah.Jumlah
 U5 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 10 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string TabTarik
 C3 string tarik
 C4 string KotakJumlah
 C5 string Jumlah
 C6 string 
 C7 string Text
 U1 TABLE table: 0xceb1377140a7e40c
  [Tween] TABLE
  [FontTitle] userdata Font { Family = rbxassetid://16658221428, Weight = ExtraBold, Style = Normal }
  [CloseIcon] string rbxassetid://134557119979432
  [Color] TABLE
  [Stroke] TABLE
  [bounce] FUNCTION
  [applyGradient] FUNCTION
  [Corner] TABLE
  [Button] TABLE
  [Krem] TABLE
  [applyStroke] FUNCTION
  [pop] FUNCTION
  [setButton] FUNCTION
  [Stagger] number 0.07
  [Transparency] TABLE
  [PopFrom] number 0.55
  [Gradient] TABLE
  [Font] userdata Font { Family = rbxassetid://16658221428, Weight = Bold, Style = Normal }
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U3 string setor
 U4 boolean false
 U5 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 11 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string TabSetor
 C3 string setor
 C4 string KotakJumlah
 C5 string Jumlah
 C6 string 
 C7 string Text
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U3 string setor
 U4 boolean false
 U5 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 12 source==ReplicatedStorage.NKSystem.Controller.HarianController name= line=nil
 C1 string bounce
 C2 string Isi
 C3 string Like
 C4 string Kotak
 C5 string like
 C6 string likeKlik
 C7 string KlikLike
 C8 string andThen
 C9 string warn
 C11 string catch
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.HarianUI.Entri
 U3 TABLE table: 0x4c37f77b696ad5c9
  [bisaKlaim] boolean false
  [selesai] number 4
  [like] boolean true
  [likeKlik] boolean true
  [detikReset] number 18855
  [komunitas] boolean true
  [terbuka] boolean true
  [favorit] boolean true
  [berikut] number 5
 U4 TABLE table: 0x02790fc29a6ad8aa
  [LaporFavorit] FUNCTION
  [CekKomunitas] FUNCTION
  [StatusBerubah] TABLE
  [Klaim] FUNCTION
  [GetStatus] FUNCTION
  [KlikLike] FUNCTION
 U5 FUNCTION function: 0x1444567fcf6ae9f6

[FUNCTION] TARGET VOCAB CANDIDATE 12.U5 source==ReplicatedStorage.NKSystem.Controller.HarianController name=terapkan line=nil
 C1 string type
 C3 string table
 C4 string os
 C5 string clock
 C7 number 86400
 C8 string detikReset
 C9 string tonumber
 C11 string bisaKlaim
 C12 string Visible
 U1 TABLE table: 0x4c37f77b696ad5c9
 U2 number 19622.223921947
 U3 userdata Players.Raelity911.PlayerGui.Button.TopbarButtons.HadiahButton.Titik
 U4 FUNCTION function: 0x6a06b355d8f4c35d
 U5 FUNCTION function: 0xe6b9075b9e0f6c1a

[FUNCTION] TARGET VOCAB CANDIDATE 13 source=WCWjWcgUqFxXEmJxAxiY name= line=nil
 C8 string game
 C10 string Players
 C11 string GetService
 C12 string LocalPlayer
 C13 string ReplicatedStorage
 C14 string === BLIND BOX DEEP DIAGNOSIS ===
 C15 string PLAYER 
 C16 string  TIME 
 C17 string os
 C18 string date
 C20 string %Y-%m-%d %H:%M:%S
 C21 string READ ONLY | NO HOOKS | NO REMOTE CALLS | NO UI CLICKS
 C22 string 
=== 1. KNOWN MODULES ===
 C23 string ipairs
 C25 string GetDescendants
 C26 string ModuleScript
 C27 string IsA
 C28 string Name
 C29 string GachaController
 C30 string BlindBoxTampil
 C31 string GachaConfig
 C32 string KotakController
 C33 string [MODULE] 
 C34 string 
=== 2. LIVE BLIND BOX UI ===
 C35 string PlayerGui
 C36 string FindFirstChild
 C37 string BlindBoxLayar
 C38 string [GUI] 
 C39 string GuiButton
 C40 string [BUTTON] 
 C41 string  Visible=
 C42 string Visible
 C43 string  Active=
 C44 string Active
 C45 string  Text=
 C46 string TextButton
 C47 string Text
 C48 string ImageButton
 C49 string TextLabel
 C50 string [LABEL] 
 C51 string ViewportFrame
 C52 string Camera
 C53 string Model
 C54 string ValueBase
 C55 string [OBJECT] 
 C56 string ClassName
 C57 string  
 C58 string  Value=
 C59 string Value
 C60 string GUI NOT OPEN
 C61 string 
=== 3. FULL GC ENUMERATION ===
 C62 string getgc
 C64 string pcall
 C66 string type
 C68 string table
 C69 string GETGC FAILED: 
 C70 string GC TOTAL 
 C71 string function
 C72 number 1
 C73 string bukaBlindBox
 C74 string GachaController.bukaBlindBox #
 C75 number 100
 C76 number 0
 C77 string task
 C78 string wait
 C80 string PASS1 objects=
 C81 string  functions=
 C82 string  tables=
 C83 string  targetFunctions=
 C84 string ORCHESTRATOR NOT FOUND IN FULL GC. It may not be loaded in this client session, or constants API is limited.
 C85 string 
=== 4. DIRECT CALLER / CLOSURE REFERENCES ===
 C86 string pairs
 C88 string U
 C89 string .
 C90 string [CALLER REF 
 C91 string ] 
 C92 string concat
 C94 string , 
 C95 string DIRECT CALLER 
 C96 string DIRECT CALLER COUNT 
 C97 string 
=== 5. BLIND / REWARD / CLAIM FUNCTION CANDIDATES ===
 C98 string blind
 C99 string blindbox
 C100 string blind box
 C101 string claimcallback
 C102 string reward
 C103 string hasilhadiah
 C104 string kotak
 C105 string TARGET VOCAB CANDIDATE 
 C106 string VOCAB CANDIDATES 
 C107 string 
=== 6. RELEVANT REMOTE INVENTORY ===
 C108 string NKSystem
 C109 string RemoteEvent
 C110 string RemoteFunction
 C111 string UnreliableRemoteEvent
 C112 string [REMOTE] 
 C113 string NKSystem remotes listed 
 C114 string 
=== 7. END / LIMITATIONS ===
 C115 string No function was executed. No remote was invoked. No hook was installed.
 C116 string A caller may not retain the target as an upvalue; absence of direct refs is not proof of no caller.
 C117 string 

 C118 string writefile
 C120 string Hasil.lua
 C121 string setclipboard
 C123 string print
 C125 string BLIND BOX DEEP DIAGNOSIS DONE | 
 C126 string  chars | Hasil.lua + clipboard

[FUNCTION] TARGET VOCAB CANDIDATE 14 source=JbwPHHiHTJCykVUYbcXC name= line=nil
 C8 string game
 C10 string Players
 C11 string GetService
 C12 string LocalPlayer
 C13 string ReplicatedStorage
 C14 string === BLIND BOX DEEP DIAGNOSIS ===
 C15 string PLAYER 
 C16 string  TIME 
 C17 string os
 C18 string date
 C20 string %Y-%m-%d %H:%M:%S
 C21 string READ ONLY | NO HOOKS | NO REMOTE CALLS | NO UI CLICKS
 C22 string 
=== 1. KNOWN MODULES ===
 C23 string ipairs
 C25 string GetDescendants
 C26 string ModuleScript
 C27 string IsA
 C28 string Name
 C29 string GachaController
 C30 string BlindBoxTampil
 C31 string GachaConfig
 C32 string KotakController
 C33 string [MODULE] 
 C34 string 
=== 2. LIVE BLIND BOX UI ===
 C35 string PlayerGui
 C36 string FindFirstChild
 C37 string BlindBoxLayar
 C38 string [GUI] 
 C39 string GuiButton
 C40 string [BUTTON] 
 C41 string  Visible=
 C42 string Visible
 C43 string  Active=
 C44 string Active
 C45 string  Text=
 C46 string TextButton
 C47 string Text
 C48 string ImageButton
 C49 string TextLabel
 C50 string [LABEL] 
 C51 string ViewportFrame
 C52 string Camera
 C53 string Model
 C54 string ValueBase
 C55 string [OBJECT] 
 C56 string ClassName
 C57 string  
 C58 string  Value=
 C59 string Value
 C60 string GUI NOT OPEN
 C61 string 
=== 3. FULL GC ENUMERATION ===
 C62 string getgc
 C64 string pcall
 C66 string type
 C68 string table
 C69 string GETGC FAILED: 
 C70 string GC TOTAL 
 C71 string function
 C72 number 1
 C73 string bukaBlindBox
 C74 string GachaController.bukaBlindBox #
 C75 number 100
 C76 number 0
 C77 string task
 C78 string wait
 C80 string PASS1 objects=
 C81 string  functions=
 C82 string  tables=
 C83 string  targetFunctions=
 C84 string ORCHESTRATOR NOT FOUND IN FULL GC. It may not be loaded in this client session, or constants API is limited.
 C85 string 
=== 4. DIRECT CALLER / CLOSURE REFERENCES ===
 C86 string pairs
 C88 string U
 C89 string .
 C90 string [CALLER REF 
 C91 string ] 
 C92 string concat
 C94 string , 
 C95 string DIRECT CALLER 
 C96 string DIRECT CALLER COUNT 
 C97 string 
=== 5. BLIND / REWARD / CLAIM FUNCTION CANDIDATES ===
 C98 string blind
 C99 string blindbox
 C100 string blind box
 C101 string claimcallback
 C102 string reward
 C103 string hasilhadiah
 C104 string kotak
 C105 string TARGET VOCAB CANDIDATE 
 C106 string VOCAB CANDIDATES 
 C107 string 
=== 6. RELEVANT REMOTE INVENTORY ===
 C108 string NKSystem
 C109 string RemoteEvent
 C110 string RemoteFunction
 C111 string UnreliableRemoteEvent
 C112 string [REMOTE] 
 C113 string NKSystem remotes listed 
 C114 string 
=== 7. END / LIMITATIONS ===
 C115 string No function was executed. No remote was invoked. No hook was installed.
 C116 string A caller may not retain the target as an upvalue; absence of direct refs is not proof of no caller.
 C117 string 

 C118 string writefile
 C120 string Hasil.lua
 C121 string setclipboard
 C123 string print
 C125 string BLIND BOX DEEP DIAGNOSIS DONE | 
 C126 string  chars | Hasil.lua + clipboard

[FUNCTION] TARGET VOCAB CANDIDATE 15 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string Kotak
 C3 string Batal
 C4 string Visible
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi

[FUNCTION] TARGET VOCAB CANDIDATE 16 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string Kotak
 C3 string Ya
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U3 FUNCTION function: 0xdcbb366ce96bcce0

[FUNCTION] TARGET VOCAB CANDIDATE 16.U3 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=jalankan line=nil
 C1 number 0
 C2 string Jumlah
 C3 string GetAttribute
 C4 string Visible
 C5 string setor
 C6 string Setor
 C7 string Tarik
 C8 string andThen
 C9 string catch
 U1 boolean false
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U3 FUNCTION function: 0x3254f0c70dc4d97b
 U4 string setor
 U5 TABLE table: 0x48c2b128346f2acb
 U6 string uang
 U7 TABLE table: 0x04027be883d7d448
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U9 FUNCTION function: 0xde5ac185e0315c2c
 U10 FUNCTION function: 0xd853cd43ac375f3a
 U11 FUNCTION function: 0x73d566cadc2eee54
 U12 boolean false
 U13 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U14 FUNCTION function: 0xf8f3cb8cecdba7f6
 U15 userdata 0.752941, 0.223529, 0.168627
 U16 FUNCTION function: 0x5032c419ec99de9c

[FUNCTION] TARGET VOCAB CANDIDATE 17 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=cepatPopup line=nil
 C1 string Aksi
 C2 string GetAttribute
 C3 string jual
 C4 string persen
 C5 string q
 C6 number 1
 C7 string Nilai
 C8 string math
 C9 string floor
 C11 string max
 C13 string mode
 C14 string jumlah
 C15 string HARGA_MIN
 C16 string HARGA_MAKS
 C17 string clamp
 C19 string nilai
 C20 string PopupAngka
 C21 string Kartu
 C22 string sibuk
 C23 string Kotak
 C24 string Angka
 C25 string 
 C26 string Text
 C27 string termurah
 C28 string turun
 C29 number 0.9
 C30 string naik
 C31 number 1.1
 C32 number 100
 C33 string hapus
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 TABLE table: 0xb22bcf6cf89a19c2
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U5 FUNCTION function: 0x595d29e1e8325b9d

[FUNCTION] TARGET VOCAB CANDIDATE 18 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=mintaKonfirmasi line=nil
 C1 string cariAset
 C2 string setor
 C3 string key
 C4 string saldo
 C5 string target
 C6 string tersimpan
 C7 string math
 C8 string min
 C10 string max
 C12 string 
 C13 string KotakJumlah
 C14 string Jumlah
 C15 string Text
 C16 string %D
 C17 string gsub
 C18 number 0
 C19 string tonumber
 C21 string Kotak
 C22 string Kepala
 C23 string Teks
 C24 string KONFIRMASI SETOR
 C25 string KONFIRMASI TARIK
 C26 string Pesan
 C27 string Setor <b>%s</b> ke Brankas IDK?
 C28 string rupiah
 C29 string Rp 
 C30 string  
 C31 string kunci
 C32 string Kunci
 C33 string nama
 C34 string format
 C35 string Tarik <b>%s</b> ke dompetmu?
 C36 string Detail
 C37 string Progres total jadi %s  •  %s
 C38 number 10
 C39 string floor
 C41 string %.
 C42 string f
 C43 string %.?0+$
 C44 string ,
 C45 string %
 C46 string Tahap
 C47 string belum ada tahap
 C48 string TextColor3
 C49 string Peringatan
 C50 string Pastikan jumlahnya sudah benar sebelum setor.
 C51 string Menarik aset bisa menurunkan tahap IDK kamu.
 C52 string Ya
 C53 string Primary
 C54 string Secondary
 C55 string YA, SETOR
 C56 string YA, TARIK
 C57 string setButton
 C58 string SetAttribute
 C59 string Visible
 U1 boolean false
 U2 TABLE table: 0x59dabc891f89831a
  [LoungeMinTahap] number 1
  [cariAset] FUNCTION
  [Tahap] TABLE
  [MaksRiwayat] number 30
  [Aset] TABLE
  [persenTotal] FUNCTION
  [ZonaJam] number 7
  [tahapDari] FUNCTION
  [JedaSetor] number 0.6
 U3 string uang
 U4 string setor
 U5 TABLE table: 0x04027be883d7d448
  [tersimpan] TABLE
  [tahap] number 0
  [persen] number 16.666666666666664
  [saldo] TABLE
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U7 FUNCTION function: 0x5032c419ec99de9c

[FUNCTION] TARGET VOCAB CANDIDATE 18.U7 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=goyang line=nil
 C1 string Position
 C2 string TweenInfo
 C3 string new
 C5 number 0.05
 C6 string Enum
 C7 string EasingStyle
 C8 string Quad
 C10 string EasingDirection
 C11 string InOut
 C14 string UDim2
 C15 string fromScale
 C17 number 0.006
 C18 string Create
 C19 string Play
 U1 userdata TweenService
 U8 FUNCTION function: 0x369aabeb24817386

[FUNCTION] TARGET VOCAB CANDIDATE 18.U8 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=setelah line=nil
 C1 string ipairs
 C3 string Aset
 C4 string key
 C5 string tersimpan
 C6 string setor
 C7 string persenTotal
 C8 string tahapDari
 U1 TABLE table: 0x59dabc891f89831a
 U2 TABLE table: 0x04027be883d7d448
 U3 string uang
 U4 string setor
 U9 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U10 FUNCTION function: 0x22b58e8f699498a6
 U11 userdata 0.180392, 0.619608, 0.356863
 U12 userdata 0.752941, 0.223529, 0.168627
 U13 TABLE table: 0xceb1377140a7e40c

[FUNCTION] TARGET VOCAB CANDIDATE 19 source==ReplicatedStorage.NKSystem.Controller.AdminAbusePanelController name=KnitStart line=nil
 C1 string GetService
 C2 string AdminAbuseService
 C3 string AdminService
 C4 string PlayerGui
 C5 string WaitForChild
 C6 string AdminTitleUI
 C7 string AdminPanel
 C8 string Panel
 C9 string Body
 C10 string Actions
 C11 string EventSection
 C12 string [AdminAbusePanel] EventSection tidak ada
 C13 string AmIAdmin
 C14 string andThen
 C15 string catch
 C16 string InfoEvent
 C17 string SisaEvent
 C18 string StatusEvent
 C19 string AdminAbuseKontrol
 C20 string Jendela
 C21 string Isi
 C22 string StatusMini
 C23 string FindFirstChild
 C24 string AksiMini
 C25 string ipairs
 C27 string LogEvent
 C28 string LogBox
 C29 string Log
 C30 string table
 C31 string insert
 C33 string info
 C34 string C9D1D9
 C35 string ok
 C36 string 7EE787
 C37 string klaim
 C38 string F2CC60
 C39 string fase
 C40 string 79C0FF
 C41 string warn
 C42 string FFA657
 C43 string error
 C44 string FF7B72
 C47 string Catat
 C48 string game
 C50 string UserInputService
 C51 string Topbar
 C52 string InputBegan
 C53 string Connect
 C54 string InputChanged
 C55 string Skala
 C56 string workspace
 C58 string CurrentCamera
 C59 number 760
 C60 string ViewportSize
 C61 string Y
 C62 number 0.55
 C63 string math
 C64 string clamp
 C66 string Scale
 C67 string GetPropertyChangedSignal
 C68 string CloseBtn
 C69 string Activated
 C70 string GetDescendants
 C71 string ImageButton
 C72 string IsA
 C73 string TemaTombol
 C74 string GetAttribute
 C75 string setButton
 C76 string danger
 C77 string Danger
 C78 string secondary
 C79 string Secondary
 C80 string Primary
 C81 string kotak
 C83 string KuotaRow1
 C84 string KunciBox
 C85 string MusikRow
 C86 string MusikBox
 C87 string ScopeRow
 C88 string ScopeServerBtn
 C89 string ScopeGlobalBtn
 C90 string pairs
 C92 string Kuota %s (%s)
 C93 string NAMA
 C94 string KUOTA_DEFAULT
 C95 string tostring
 C97 string format
 C98 string PlaceholderText
 C99 string MUSIK_DANCE
 C100 string 
 C101 string ID musik (bawaan 
 C102 string )
 C104 string Text
 C105 string SebarRow
 C106 string SebarBox
 C107 string SebarBtn
 C108 string EmoteList
 C109 string _TemplateEmote
 C110 string CariRow
 C111 string CariBox
 C112 string EmoteDipilih
 C113 string daftarAnim
 C114 string Clone
 C115 string E_
 C116 string Name
 C117 string LayoutOrder
 C118 string Visible
 C119 string Label
 C120 string emote
 C121 string  ·E
 C122 string Cari
 C123 string lower
 C124 string SetAttribute
 C125 string Parent
 C126 string aksi
 C128 string sampai
 C129 number 0
 C132 string OtoRow
 C133 string OtomatisBtn
 C134 string FaseRow1
 C135 string PembukaanBtn
 C136 string LemparBtn
 C137 string FaseRow2
 C138 string BurstBtn
 C139 string DanceBtn
 C140 string FaseRow3
 C141 string PenutupBtn
 C142 string BatalBtn
 C143 string EmoteRow
 C144 string MainkanBtn
 C145 string DiamBtn
 C146 string MiniRow
 C147 string MinimizeBtn
 C148 string Grid
 C149 string EmoteBtn
 C150 string Baris3
 C151 string Baris2
 C152 string PanelBtn
 C153 string BersihBtn
 C154 string task
 C155 string delay
 C157 string spawn
 U1 TABLE table: 0xda0f166d4ec11a3a
  [AddControllers] FUNCTION
  [GetService] FUNCTION
  [GetController] FUNCTION
  [Player] userdata Players.Raelity911
  [OnStart] FUNCTION
  [AddControllersDeep] FUNCTION
  [Start] FUNCTION
  [GetControllers] FUNCTION
  [Util] userdata ReplicatedStorage.NKSystem.Packages
  [CreateController] FUNCTION
 U2 userdata Players.Raelity911
 U3 FUNCTION function: 0xc641e62bf5e97979

[FUNCTION] TARGET VOCAB CANDIDATE 19.U3 source==ReplicatedStorage.NKSystem.Controller.AdminAbusePanelController name= line=nil
 U4 TABLE table: 0x14a5e9155032fc08
  [KnitStart] FUNCTION
  [Name] string AdminAbusePanelController
  [Catat] FUNCTION
 U5 TABLE table: 0xceb1377140a7e40c
 U6 TABLE table: 0x2b5af13d063ba45f
  [MUSIK_DANCE] string 78852932059882
  [AVATAR_USER_ID] number 8131035694
  [TOLAK_PRIVATE_SERVER] boolean false
  [PENGUMUMAN] string ADMIN ABUSE dimulai! Owner datang melempar Kotak Misteri. Pungut sebanyak-banyaknya lalu buka dari hotbar!
  [LEMPAR_JEDA] TABLE
  [TITIK_CADANGAN] vector -735, 16, -275
  [PELUANG_KE_PEMAIN] number 0.3
  [SEBAR_MAKS] number 500
  [KUOTA_MAKS] TABLE
  [MAKS_DROP_AKTIF] number 60
  [UMUR_DROP] number 40
  [TENGGELAM] number 0.38
  [BULAT_UANG] number 1000
  [SEBAR_TITIK] TABLE
  [ANIM_JOGET] TABLE
  [IKON] TABLE
  [JENIS_DANCE] TABLE
  [JEDA_ANTAR_DROP] number 0.12
  [LANGIT] TABLE
  [KOTAK] TABLE
  [SEBAR_PEMAIN] TABLE
  [SUDUT_SEBAR_TITIK] number 65
  [EMOTE_ACAK] TABLE
  [ABAIKAN_SYARAT_DI_STUDIO] boolean true
  [JARAK_AMBIL] number 7
  [KUOTA_DEFAULT] TABLE
  [VOLUME_MUSIK] number 0.6
  [BURST] number 14
  [OTOMATIS] TABLE
  [PER_GELOMBANG] TABLE
  [PITCH_TING] TABLE
  [SEBAR_PER_TICK] number 20
  [SPEED_MUSIK] number 0.4
  [EFEK_MUSIK] TABLE
  [MIN_PEMAIN] number 4
  [WARNA_KABUT] userdata 0.92549, 0.909804, 0.972549
  [SFX] TABLE
  [MAKS_FASE_LEMPAR] number 1800
  [JENIS] TABLE
  [NAMA] TABLE
  [MAJU_TITIK] number 45
  [DURASI] TABLE
  [KLAIM_PER_DETIK] number 12
  [JARAK_KLAIM_SERVER] number 18
  [ANIM] TABLE
  [TITIK_NAMA] string AdminAbuseTitik
  [TINGGI_AVATAR] number 509
  [CUTSCENE] boolean true
  [SEBAR_AREA] TABLE
  [WARNA] TABLE
  [daftarAnim] FUNCTION
  [LAMA_TERBANG] number 2.6
  [cariAnim] FUNCTION
  [PER_DROP] TABLE
  [LANGIT_MALAM] TABLE
  [TOPIC] string NK_AdminAbuseEvent_v1
 U7 TABLE table: 0x1f7935bf8b25c74f
  [lempar] string LEMPAR HADIAH
  [dance] string DANCE BARENG
  [mati] string TIDAK AKTIF
  [penutup] string PENUTUP
  [pembukaan] string PEMBUKAAN

[FUNCTION] TARGET VOCAB CANDIDATE 20 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=bukaRiwayat line=nil
 C1 string Visible
 C2 string Kotak
 C3 string Daftar
 C4 string Kosong
 C5 string Memuat riwayat...
 C6 string Text
 C7 string GetRiwayat
 C8 string andThen
 C9 string catch
 U1 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Riwayat
 U2 FUNCTION function: 0x988d0e9fa402fd49

[FUNCTION] TARGET VOCAB CANDIDATE 20.U2 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=isiRiwayat line=nil
 C1 string Kotak
 C2 string Daftar
 C3 string ipairs
 C5 string GetChildren
 C6 string Name
 C7 string Baris
 C8 string Destroy
 C9 string Kosong
 C10 number 0
 C11 string Visible
 C12 string cariAset
 C13 string k
 C14 string BarisTpl
 C15 string Clone
 C16 string LayoutOrder
 C17 string j
 C18 string tarik
 C19 string Jenis
 C20 string BackgroundColor3
 C21 string Teks
 C22 string SETOR
 C23 string TARIK
 C24 string Text
 C25 string Ikon
 C26 string ikon
 C27 string Image
 C28 string Jumlah
 C29 string n
 C30 string rupiah
 C31 string Rp 
 C32 string  
 C33 string key
 C34 string kunci
 C35 string Kunci
 C36 string nama
 C37 string t
 C38 string os
 C39 string date
 C41 string !*t
 C42 string time
 C44 number 3600
 C45 string ZonaJam
 C46 string Waktu
 C47 string %d %s %d  •  %02d:%02d WIB  •  %s
 C48 string day
 C49 string month
 C50 string sub
 C51 string year
 C52 string hour
 C53 string min
 C54 string 
 C55 string no
 C56 string format
 C57 string Struk
 C58 string Activated
 C59 string Connect
 C60 string Parent
 U1 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Riwayat
 U2 TABLE table: 0x59dabc891f89831a
 U3 userdata 0.180392, 0.619608, 0.356863
 U4 userdata 0.780392, 0.478431, 0.0705882
 U5 FUNCTION function: 0x22b58e8f699498a6
 U6 TABLE table: 0xaf69739db9242ad6
 U7 TABLE table: 0xceb1377140a7e40c
 U8 FUNCTION function: 0xf8f3cb8cecdba7f6
 U3 TABLE table: 0x48c2b128346f2acb
  [StatusBerubah] TABLE
  [NaikTahap] TABLE
  [Setor] FUNCTION
  [GetStatus] FUNCTION
  [GetRiwayat] FUNCTION
  [Tarik] FUNCTION

[FUNCTION] TARGET VOCAB CANDIDATE 21 source==ReplicatedStorage.NKSystem.Controller.KotakController name=pasangTool line=nil
 C1 string Tool
 C2 string IsA
 C3 string KotakMisteri
 C4 string GetAttribute
 C5 string Activated
 C6 string Connect
 C7 string Unequipped
 U1 TABLE table: 0x214413fc1a70a8b3
 U2 FUNCTION function: 0x90661f09f9ee63dc

[FUNCTION] TARGET VOCAB CANDIDATE 21.U2 source==ReplicatedStorage.NKSystem.Controller.KotakController name=buka line=nil
 C1 string task
 C2 string wait
 C4 number 0.14
 C5 number 1
 C6 string Visible
 C7 string BackgroundTransparency
 C8 number 0.35
 C10 string TweenInfo
 C11 string new
 C13 number 0.25
 C14 string Enum
 C15 string EasingStyle
 C16 string Quad
 C18 string EasingDirection
 C19 string Out
 C21 string Create
 C22 string Play
 C23 string UDim2
 C24 string fromScale
 C26 number 0.5
 C27 number 0.42
 C28 string Position
 C29 string Rotation
 C30 string ImageTransparency
 C31 number 0.99
 C32 string Scale
 C34 string Back
 C36 number 0.6
 C38 number 1.2
 C39 number 0.7
 C41 number 0.3
 C42 string Size
 C43 number 0.45
 C45 number 0.46
 C46 string TextTransparency
 C47 string Transparency
 C48 string MEMBUKA KOTAK...
 C49 string Text
 C50 string Color3
 C51 string fromRGB
 C53 string Color
 C54 string Disconnect
 C55 string RenderStepped
 C56 string Connect
 C57 string Buka
 C58 string andThen
 C59 string catch
 C60 string os
 C61 string clock
 C63 number 1.15
 C64 string math
 C65 string clamp
 C67 number 3
 C68 number 16
 C69 number 46
 C70 string sin
 C73 string random
 C75 number 0.16
 C76 number 0.05
 C77 number 24
 C78 string abs
 C80 number 0.17
 C81 number 0.11
 C82 number 0.2
 C83 number 1.1
 C84 string Instance
 C86 string Sound
 C87 string rbxassetid://1169806635
 C88 string SoundId
 C89 string Volume
 C90 string PlaybackSpeed
 C91 string Parent
 C92 string AddItem
 C93 string Wait
 C94 string type
 C96 string table
 C97 string BELUM BISA DIBUKA
 C98 string string
 C99 string Coba lagi sebentar.
 C100 number 0
 C103 string delay
 C105 number 2.2
 C106 string IsLoaded
 C107 number 1.25
 C108 string Elastic
 C110 string ipairs
 C112 string Skala
 C114 number 0.9
 C116 number 0.08
 C117 number 0.34
 C120 number 0.4
 C122 string kunci
 C123 string Vector2
 C125 string AbsoluteSize
 C126 string X
 C127 string Y
 C128 string SFX
 C129 string muncul
 C130 string 
 C131 number 1.5
 C132 string kembangApi
 C133 string JACKPOT! KAMU DAPAT:
 C134 string KAMU DAPAT:
 C135 string jenis
 C136 string uang
 C137 string nilai
 C138 string format
 C141 string insert
 C143 string xp
 C148 string kotoran
 C151 number 0.32
 U1 boolean false
 U2 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar
 U3 boolean false
 U4 FUNCTION function: 0x5b2b1eb8bb6cc39e
 U5 number 0
 U6 FUNCTION function: 0xb102db109a3b08f7
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
 U22 TABLE table: 0x20e164fe7c1e7b73
 U23 userdata SoundService
 U24 userdata Debris
 U25 userdata Players.Raelity911.PlayerGui.KotakMisteriUI.Layar.Kilat
 U26 FUNCTION function: 0x8a56def41551fb35
 U27 TABLE table: 0x2b5af13d063ba45f
 U28 FUNCTION function: 0x5d355b9c8f611287
 U29 FUNCTION function: 0x13b853845d21877d
 U3 boolean false
 U4 FUNCTION function: 0x5b2b1eb8bb6cc39e

[FUNCTION] TARGET VOCAB CANDIDATE 21.U4 source==ReplicatedStorage.NKSystem.Controller.KotakController name=tutup line=nil
 C1 number 1
 C2 number 0.12
 C3 number 0.3
 C4 string BackgroundTransparency
 C6 string TweenInfo
 C7 string new
 C9 string Enum
 C10 string EasingStyle
 C11 string Quad
 C13 string EasingDirection
 C14 string Out
 C16 string Create
 C17 string Play
 C18 string ImageTransparency
 C20 string TextTransparency
 C22 string Transparency
 C24 string ipairs
 C26 string GetChildren
 C27 string Name
 C28 string Kartu
 C29 string Pop
 C30 string Scale
 C31 number 0
 C33 string Back
 C35 string In
 C37 string task
 C38 string delay
 C40 number 0.05
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
 U16 FUNCTION function: 0xb102db109a3b08f7

[FUNCTION] TARGET VOCAB CANDIDATE 22 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=letakkanRak line=nil
 C1 string rakPose
 C2 string rak
 C3 string PivotTo
 C4 string pairs
 C6 string kotak
 C7 string angkat
 C8 string Value
 C9 string relSlot
 C10 string CFrame
 C11 string new
 C13 number 0.6
 C14 string cahaya
 C15 string GetPivot
 C16 number -0.09
 U1 TABLE table: 0x2c5d2d8e6c52a35c
  [blur] userdata Lighting.BlindBoxBlur
  [poseDunia] userdata -672.662537, 16.1800003, -211.899994, 0, 0, 1, 0, 1, 0, -1, 0, 0
  [sambungAuto] userdata Connection
  [relSlot] TABLE
  [kotak] TABLE
  [angkat] TABLE
  [auto] boolean true
  [cam] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Camera
  [camLama] TABLE
  [kosong] TABLE
  [vpf] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia
  [cahaya] TABLE
  [kontrol] TABLE
  [display] userdata Workspace.Kawasan_Kos.Area_Gacha_Pajak.BlindBox_Display
  [rak] userdata Players.Raelity911.PlayerGui.BlindBoxLayar.Dunia.Rak
  [rakPose] userdata -678.743164, 17.6267738, -211.606384, -0.146941662, 0.0658650771, 0.986949921, 0.00105779618, 0.997790456, -0.0664310455, -0.989144683, -0.00871749036, -0.146686673
  [gui] userdata Players.Raelity911.PlayerGui.BlindBoxLayar

[FUNCTION] TARGET VOCAB CANDIDATE 23 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=teksSub line=nil
 C1 string type
 C2 string money
 C3 string + Rp 
 C4 string formatMoney
 C5 number 0
 C6 string amount
 C7 string keys
 C8 string + 
 C9 string  Kunci Emas
 C10 string tool
 C11 string masuk ke ranselmu
 C12 string domba
 C13 string masuk ke kandang
 C14 string pet
 C15 string Pet baru! Pakai di menu PET
 C16 string none
 C17 string kotak kosong, coba lagi ya
 C18 string 
 U1 TABLE table: 0x44b3be69b1065740
  [TES_SAPU_PASTI] boolean false
  [rarityColor] FUNCTION
  [MAX_FREE] number 10
  [resolvePath] FUNCTION
  [Rarities] TABLE
  [SPIN_PRICE] number 200000
  [formatMoney] FUNCTION
  [getItem] FUNCTION
  [Items] TABLE

[FUNCTION] TARGET VOCAB CANDIDATE 24 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=modelHadiah line=nil
 C1 string type
 C2 string pet
 C3 string domba
 C4 string tool
 C5 string PlayerGui
 C6 string WaitForChild
 C7 string BlindBoxModel
 C8 string id
 C9 string tostring
 C11 number 1.5
 C12 string Model
 C13 string IsA
 C14 string Clone
 C15 string ipairs
 C17 string GetDescendants
 C18 string BaseScript
 C19 string Sound
 C20 string BillboardGui
 C21 string Destroy
 C22 string GetBoundingBox
 C23 string X
 C24 string Y
 C25 string Z
 C26 string math
 C27 string max
 C29 string pcall
 C31 string CFrame
 C32 string new
 C34 string PivotTo
 C35 string Position
 C36 number 2
 C37 string Vector3
 U1 userdata Players.Raelity911

[FUNCTION] TARGET VOCAB CANDIDATE 25 source==ReplicatedStorage.NKSystem.Controller.HarianController name=KnitStart line=nil
 C1 string GetService
 C2 string HarianService
 C3 string LocalPlayer
 C4 string PlayerGui
 C5 string WaitForChild
 C6 string HarianUI
 C7 string Button
 C8 string TopbarButtons
 C9 string HadiahButton
 C10 string warn
 C12 string [HarianController] HarianUI / HadiahButton tidak ditemukan
 C13 string Entri
 C14 string Daftar
 C15 string Titik
 C16 string FindFirstChild
 C17 string Visible
 C18 string Activated
 C19 string Connect
 C20 string Top
 C21 string Close
 C22 string Isi
 C23 string Komunitas
 C24 string Aksi
 C25 string Favorit
 C26 string Like
 C27 string Kotak
 C28 string Open
 C29 string Klaim
 C30 string PromptSetFavoriteCompleted
 C31 string StatusBerubah
 C32 string GetStatus
 C33 string andThen
 C35 string catch
 C36 string favorit
 C37 string task
 C38 string spawn
 U1 TABLE table: 0x02790fc29a6ad8aa
 U2 TABLE table: 0xda0f166d4ec11a3a
 U3 userdata Players
 U4 userdata Players.Raelity911.PlayerGui.HarianUI
 U5 userdata Players.Raelity911.PlayerGui.Button.TopbarButtons.HadiahButton
 U6 userdata Players.Raelity911.PlayerGui.HarianUI.Entri
 U7 userdata Players.Raelity911.PlayerGui.HarianUI.Daftar
 U8 userdata Players.Raelity911.PlayerGui.Button.TopbarButtons.HadiahButton.Titik
 U9 TABLE table: 0xceb1377140a7e40c
 U10 FUNCTION function: 0x1444567fcf6ae9f6
 U11 boolean false
 U12 TABLE table: 0x4c37f77b696ad5c9
 U13 userdata AvatarEditorService
 U14 number 113574409274355
 U15 FUNCTION function: 0x5c73592e844c5de6

[FUNCTION] TARGET VOCAB CANDIDATE 25.U15 source==ReplicatedStorage.NKSystem.Controller.HarianController name=buka line=nil
 C1 string daftar
 C2 string Visible
 C3 string pop
 C4 string play
 C5 string uiOpen
 U1 userdata Players.Raelity911.PlayerGui.HarianUI.Daftar
 U2 userdata Players.Raelity911.PlayerGui.HarianUI.Entri
 U3 TABLE table: 0xceb1377140a7e40c
 U4 FUNCTION function: 0x6a06b355d8f4c35d
 U5 FUNCTION function: 0xe6b9075b9e0f6c1a
 U6 TABLE table: 0x922def0a5865bdc8
 U16 FUNCTION function: 0x86700297c29245f2

[FUNCTION] TARGET VOCAB CANDIDATE 25.U16 source==ReplicatedStorage.NKSystem.Controller.HarianController name=tutup line=nil
 C1 string Visible
 C2 string pop
 U1 userdata Players.Raelity911.PlayerGui.HarianUI.Entri
 U2 TABLE table: 0xceb1377140a7e40c
 U3 userdata Players.Raelity911.PlayerGui.HarianUI.Daftar
 U17 boolean false
 U18 userdata GroupService
 U19 TABLE table: 0x16421a3fcb790d5d
  [Ikon] TABLE
  [GroupId] number 216674790
  [FavoritPlaceId] number 113574409274355
  [Hadiah] TABLE
  [ZonaJam] number 7
 U20 FUNCTION function: 0xb79d0eaaaefd93bf

[FUNCTION] TARGET VOCAB CANDIDATE 25.U20 source==ReplicatedStorage.NKSystem.Controller.HarianController name=favoritkan line=nil
 C1 string favorit
 C3 string pcall
 C5 string warn
 C7 string [HarianController] popup favorit gagal:
 C8 string LaporFavorit
 C9 string andThen
 C10 string catch
 U1 TABLE table: 0x4c37f77b696ad5c9
 U2 userdata AvatarEditorService
 U3 number 113574409274355
 U4 TABLE table: 0x02790fc29a6ad8aa
 U5 FUNCTION function: 0x1444567fcf6ae9f6
 U21 FUNCTION function: 0x5397270addf209bc

[FUNCTION] TARGET VOCAB CANDIDATE 25.U21 source==ReplicatedStorage.NKSystem.Controller.HarianController name=goyang line=nil
 C1 string Position
 C2 string TweenInfo
 C3 string new
 C5 number 0.05
 C6 string Enum
 C7 string EasingStyle
 C8 string Quad
 C10 string EasingDirection
 C11 string InOut
 C14 string UDim2
 C15 string fromScale
 C17 number 0.006
 C18 string Create
 C19 string Play
 U1 userdata TweenService
 U22 FUNCTION function: 0xc6bd2c0acc5466a1

[FUNCTION] TARGET VOCAB CANDIDATE 25.U22 source==ReplicatedStorage.NKSystem.Controller.HarianController name=klaim line=nil
 C1 string bisaKlaim
 C2 string terbuka
 C3 string Klaim
 C4 string andThen
 C5 string catch
 U1 boolean false
 U2 TABLE table: 0x4c37f77b696ad5c9
 U3 FUNCTION function: 0xe6b9075b9e0f6c1a
 U4 TABLE table: 0x02790fc29a6ad8aa
 U5 number 19622.223921947
 U6 userdata Players.Raelity911.PlayerGui.Button.TopbarButtons.HadiahButton.Titik
 U7 FUNCTION function: 0x6a06b355d8f4c35d
 U8 TABLE table: 0x922def0a5865bdc8
 U9 userdata Players.Raelity911.PlayerGui.HarianUI.Daftar
 U10 userdata TweenService
 U11 TABLE table: 0xceb1377140a7e40c
 U23 number 19622.223921947

[FUNCTION] TARGET VOCAB CANDIDATE 26 source==ReplicatedStorage.NKSystem.Controller.MisiController name=KnitStart line=nil
 C1 string GetService
 C2 string MisiService
 C3 string task
 C4 string spawn
 C6 string PlayerGui
 C7 string WaitForChild
 C8 string MisiUI
 C9 string Panel
 C10 string Backdrop
 C11 string Header
 C12 string CloseBtn
 C13 string Left
 C14 string RewardName
 C15 string FindFirstChild
 C16 string RewardPreview
 C17 string ProgTrack
 C18 string Fill
 C19 string Count
 C20 string ClaimBtn
 C21 string Label
 C22 string Right
 C23 string List
 C24 string RowTemplate
 C25 string Visible
 C26 string Activated
 C27 string Connect
 C28 string PromptTriggered
 C29 string Updated
 C30 string GetMisi
 C32 string andThen
 C33 string warn
 C35 string catch
 U1 TABLE table: 0x8bac66e1f7699d8c
  [Updated] TABLE
  [Claim] FUNCTION
  [IsUnlocked] FUNCTION
  [GetMisi] FUNCTION
 U2 TABLE table: 0xda0f166d4ec11a3a
 U3 boolean true
 U4 userdata Players.Raelity911
 U5 userdata Players.Raelity911.PlayerGui.MisiUI
 U6 userdata Players.Raelity911.PlayerGui.MisiUI.Panel
 U7 userdata Players.Raelity911.PlayerGui.MisiUI.Backdrop
 U8 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.RewardName
 U9 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.RewardPreview
 U10 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ProgTrack.Fill
 U11 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ProgTrack.Count
 U12 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ClaimBtn
 U13 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ClaimBtn.Label
 U14 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Right.List
 U15 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Right.RowTemplate
 U16 boolean false
 U17 TABLE table: 0xceb1377140a7e40c
 U18 boolean false
 U19 TABLE table: 0x42f521e9c9737bb7
  [total] number 10
  [progress] number 10
  [targets] TABLE
  [desc] string Tolak 10 pelanggan bermasalah berikut saat mereka datang ke kosanmu.
  [title] string TOLAK PELANGGAN BERMASALAH
  [claimed] boolean true
  [canClaim] boolean false
  [rewardIcon] string rbxassetid://80697010016049
  [rewardLabel] string Crystal Monument
  [ready] boolean true
 U20 FUNCTION function: 0x00e3d20a991d9f60

[FUNCTION] TARGET VOCAB CANDIDATE 26.U20 source==ReplicatedStorage.NKSystem.Controller.MisiController name=showRewardReveal line=nil
 C1 string PlayerGui
 C2 string FindFirstChild
 C3 string MisiRewardGui
 C4 string Dim
 C5 string Holder
 C6 string Pop
 C7 string Rays
 C8 string Icon
 C9 string BackgroundTransparency
 C10 number 0.4
 C11 string Scale
 C12 string Rotation
 C13 string 
 C14 string Image
 C15 string ImageTransparency
 C16 string Nama
 C17 string Reward
 C18 string tostring
 C20 string Text
 C21 string Sub
 C22 string masuk ke Gudang
 C23 string Enabled
 C24 string TweenInfo
 C25 string new
 C27 number 0.3
 C29 string Transparency
 C30 string Create
 C31 string Play
 C32 number 0.45
 C33 string Enum
 C34 string EasingStyle
 C35 string Back
 C37 string EasingDirection
 C38 string Out
 C40 number 1
 C42 string Linear
 C44 string InOut
 C47 number 360
 C48 string play
 C49 string levelup
 C50 string pcall
 C52 string Activated
 C53 string Connect
 C54 string task
 C55 string delay
 U1 userdata Players.Raelity911
 U2 userdata TweenService
 U3 TABLE table: 0xceb1377140a7e40c
 U4 TABLE table: 0x922def0a5865bdc8
 U21 FUNCTION function: 0x1afa0164846572f8

[FUNCTION] TARGET VOCAB CANDIDATE 26.U21 source==ReplicatedStorage.NKSystem.Controller.MisiController name=render line=nil
 C1 string Reward: 
 C2 string -
 C3 string rewardLabel
 C4 string tostring
 C6 string Text
 C7 string rewardIcon
 C8 string 
 C9 string Image
 C10 string progress
 C11 string  / 
 C12 string total
 C13 string math
 C14 string clamp
 C16 string UDim2
 C17 string fromScale
 C19 string Size
 C20 string ipairs
 C22 string targets
 C23 string claimed
 C24 string SUDAH DIKLAIM
 C25 string setButton
 C26 string Disabled
 C27 string canClaim
 C28 string CLAIM
 C29 string Primary
 C30 string KURANG %d LAGI
 C31 number 0
 C32 string max
 C34 string format
 U1 TABLE table: 0x42f521e9c9737bb7
 U2 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.RewardName
 U3 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.RewardPreview
 U4 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ProgTrack.Count
 U5 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ProgTrack.Fill
 U6 FUNCTION function: 0x7a50cffb8b85a00e
 U7 FUNCTION function: 0x1611b8c07c3d7afb
 U8 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ClaimBtn
 U9 userdata Players.Raelity911.PlayerGui.MisiUI.Panel.Left.ClaimBtn.Label
 U10 TABLE table: 0xceb1377140a7e40c
 U22 FUNCTION function: 0xb7af5dda12276670

[FUNCTION] TARGET VOCAB CANDIDATE 26.U22 source==ReplicatedStorage.NKSystem.Controller.MisiController name=setOpen line=nil
 C1 string Enabled
 C2 string play
 C3 string uiOpen
 C4 string pcall
 C6 string GetMisi
 C8 string andThen
 C9 string warn
 C11 string catch
 C12 string pop
 C13 string task
 C14 string delay
 C16 number 0.3
 U1 userdata Players.Raelity911.PlayerGui.MisiUI
 U2 boolean true
 U3 boolean false
 U4 TABLE table: 0x922def0a5865bdc8
 U5 TABLE table: 0x8bac66e1f7699d8c
 U6 FUNCTION function: 0x1afa0164846572f8
 U7 TABLE table: 0xceb1377140a7e40c
 U8 userdata Players.Raelity911.PlayerGui.MisiUI.Panel
 U9 userdata Players.Raelity911.PlayerGui.MisiUI.Backdrop
 U23 userdata ProximityPromptService
 U24 TABLE table: 0x922def0a5865bdc8

[FUNCTION] TARGET VOCAB CANDIDATE 27 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=KnitStart line=nil
 C1 string GetService
 C2 string TabunganIDKService
 C3 string LocalPlayer
 C4 string PlayerGui
 C5 string WaitForChild
 C6 string SetorAsetUI
 C7 string warn
 C9 string [SetorAsetController] SetorAsetUI tidak ditemukan
 C10 string Panel
 C11 string Struk
 C12 string KartuSetor
 C13 string KartuProgres
 C14 string KartuHadiah
 C15 string Konfirmasi
 C16 string Riwayat
 C17 string Visible
 C18 string Top
 C19 string Close
 C20 string Activated
 C21 string Connect
 C22 string ipairs
 C24 string Aset
 C25 string Aset_
 C26 string key
 C27 string FindFirstChild
 C28 string TabSetor
 C29 string TabTarik
 C30 string Cepat
 C31 string KotakJumlah
 C32 string Jumlah
 C33 string Text
 C34 string GetPropertyChangedSignal
 C35 string Setor
 C36 string Kotak
 C37 string Batal
 C38 string Ya
 C39 string Kepala
 C40 string Tutup
 C41 string Tahap
 C42 string Node
 C43 string PromptTriggered
 C45 string StatusBerubah
 C46 string NaikTahap
 C47 string pcall
 C49 string LB_Emas
 C50 string GetAttributeChangedSignal
 C51 string GetStatus
 C52 string andThen
 C54 string catch
 U1 TABLE table: 0x48c2b128346f2acb
 U2 TABLE table: 0xda0f166d4ec11a3a
 U3 userdata Players
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI
 U5 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Struk
 U7 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuProgres
 U9 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuHadiah
 U10 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U11 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Riwayat
 U12 FUNCTION function: 0xe43406ff7fcb5c2e

[FUNCTION] TARGET VOCAB CANDIDATE 27.U12 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=tutup line=nil
 C1 string Visible
 C2 string pop
 U1 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Struk
 U2 TABLE table: 0xceb1377140a7e40c
 U3 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U13 TABLE table: 0x59dabc891f89831a
 U14 string uang
 U15 boolean false
 U16 TABLE table: 0x922def0a5865bdc8
 U17 FUNCTION function: 0xde5ac185e0315c2c
 U18 FUNCTION function: 0x3254f0c70dc4d97b
 U19 FUNCTION function: 0xd853cd43ac375f3a
 U20 FUNCTION function: 0x73d566cadc2eee54
 U21 TABLE table: 0xceb1377140a7e40c
 U22 string setor
 U23 TABLE table: 0x04027be883d7d448
 U24 FUNCTION function: 0x5032c419ec99de9c
 U25 FUNCTION function: 0x22b58e8f699498a6
 U26 FUNCTION function: 0x365a6d6b7b48d203
 U27 FUNCTION function: 0xdcbb366ce96bcce0
 U28 FUNCTION function: 0x0e118881936919bf
 U29 number 1
 U30 userdata ProximityPromptService
 U31 FUNCTION function: 0x949125abacf1d95e

[FUNCTION] TARGET VOCAB CANDIDATE 27.U31 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=buka line=nil
 C1 string Visible
 C2 string KotakJumlah
 C3 string Jumlah
 C4 string 
 C5 string Text
 C6 number 1
 C7 string tahap
 C8 string Tahap
 C9 string math
 C10 string min
 C12 string pop
 C13 string play
 C14 string uiOpen
 C15 string GetStatus
 C16 string andThen
 C18 string catch
 U1 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U3 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Riwayat
 U4 boolean false
 U5 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U6 TABLE table: 0x04027be883d7d448
 U7 number 1
 U8 TABLE table: 0x59dabc891f89831a
 U9 FUNCTION function: 0xde5ac185e0315c2c
 U10 FUNCTION function: 0x3254f0c70dc4d97b
 U11 FUNCTION function: 0xd853cd43ac375f3a
 U12 FUNCTION function: 0x73d566cadc2eee54
 U13 TABLE table: 0xceb1377140a7e40c
 U14 TABLE table: 0x922def0a5865bdc8
 U15 TABLE table: 0x48c2b128346f2acb
 U16 FUNCTION function: 0xb5c3ef979b9bc0bd
 U32 FUNCTION function: 0xb5c3ef979b9bc0bd

[FUNCTION] TARGET VOCAB CANDIDATE 27.U32 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=terapkan line=nil
 C1 string type
 C3 string table
 U1 TABLE table: 0x04027be883d7d448
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U3 FUNCTION function: 0xde5ac185e0315c2c
 U4 FUNCTION function: 0x3254f0c70dc4d97b
 U5 FUNCTION function: 0xd853cd43ac375f3a
 U6 FUNCTION function: 0x73d566cadc2eee54

[FUNCTION] TARGET VOCAB CANDIDATE 28 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=init line=nil
 C1 string HalBeli
 C2 string Kiri
 C3 string Kategori
 C4 string ipairs
 C6 string KATEGORI
 C7 string Templates
 C8 string Chip
 C9 string Clone
 C10 string Visible
 C11 string K_
 C12 string id
 C13 string Name
 C14 string nama
 C15 string Text
 C16 string LayoutOrder
 C17 string UDim2
 C18 string fromScale
 C20 string tani
 C21 number 0.26
 C22 string kunci
 C23 number 0.21
 C24 number 0.15
 C25 string Size
 C26 string Kat
 C27 string SetAttribute
 C28 string Activated
 C29 string Connect
 C30 string Parent
 C31 string Cari
 C32 string GetPropertyChangedSignal
 C33 string Urut
 C34 string Daftar
 C35 string UIGridLayout
 C36 string FindFirstChildOfClass
 C37 string AbsoluteWindowSize
 C38 string Detail
 C39 string Isi
 C40 string TombolBeli
 C41 string HalJual
 C42 string Form
 C43 string Tas
 C44 string TombolJumlah
 C45 string TombolHarga
 C46 string PopupAngka
 C47 string Kartu
 C48 string Kotak
 C49 string Langkah
 C50 string KurangBesar
 C51 string KurangKecil
 C52 string TambahKecil
 C53 string TambahBesar
 C54 string Cepat
 C55 string C
 C56 string Batal
 C57 string Simpan
 C58 string TombolPasang
 C59 string aktifTab
 C60 string PASANG DI MARKET
 C61 string BackgroundColor3
 C62 string AutoButtonColor
 C63 string Aktif
 C64 string Lapak
 C65 string Muat
 C66 string Beli
 C67 string Jual
 C68 string Riwayat
 C69 string Tab
 C70 string Info
 C71 string Pajak 
 C72 string % · 
 C73 string Tanpa pajak · 
 C74 string jualan tampil 
 C75 number 3600
 C76 string DURASI
 C77 string math
 C78 string floor
 C80 string  jam
 C81 string Ringkasan
 C82 string LPajak
 C83 string Pajak
 C84 string Pajak pasar 
 C85 string %
 C86 string HargaJual
 C87 number 0
 C88 number 0.3333333333333333
 C89 string Terima
 C90 number 0.6666666666666666
 C92 number 0.08
 C93 number 0.54
 C95 string pairs
 C97 string L
 C98 string Position
 C99 number 0.55
 C100 number 0.6
 C101 number 0.38
 C102 number 0.45
 C103 string Catatan
 C104 string Barang keluar dari tasmu & ditahan sistem sampai laku atau kamu tarik. Tanpa potongan.
 C105 string Konfirmasi
 C106 string Ya
 C107 string task
 C108 string spawn
 U1 boolean true
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U3 TABLE table: 0x72fc978fc23d6679
  [toast] FUNCTION
  [sfx] FUNCTION
 U4 TABLE table: 0xdbe0587e2dff8d22
 U5 TABLE table: 0x7a52fdbf20ff8ac4
 U6 FUNCTION function: 0xb619ed97f05390eb

[FUNCTION] TARGET VOCAB CANDIDATE 28.U6 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=warnaChip line=nil
 C1 string ipairs
 C3 string HalBeli
 C4 string Kiri
 C5 string Kategori
 C6 string GetChildren
 C7 string TextButton
 C8 string IsA
 C9 string Kat
 C10 string GetAttribute
 C11 string kat
 C12 string aktifTab
 C13 string putih
 C14 string BackgroundColor3
 C15 number 0.86
 C16 string BackgroundTransparency
 C17 string Color3
 C18 string fromRGB
 C20 string TextColor3
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0x9a75f1069bf0543a
 U7 FUNCTION function: 0xe299b7308fe61058

[FUNCTION] TARGET VOCAB CANDIDATE 28.U7 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=muatDaftar line=nil
 C1 string token
 C2 string kat
 C3 string HalBeli
 C4 string Kiri
 C5 string Kosong
 C6 string Visible
 C7 string Memuat…
 C8 string Text
 C9 string Jelajah
 C10 string type
 C12 string table
 C13 string daftar
 C14 string Gagal memuat. Coba lagi.
 C15 string pilih
 C16 string ipairs
 C18 string id
 C19 string Detail
 C20 string Isi
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U3 FUNCTION function: 0xf92969312829e830
 U4 FUNCTION function: 0x58e3afa52113aa95
 U8 FUNCTION function: 0x58e3afa52113aa95

[FUNCTION] TARGET VOCAB CANDIDATE 28.U8 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string HalBeli
 C2 string Kiri
 C3 string Daftar
 C4 string string
 C5 string lower
 C7 string 
 C8 string Cari
 C9 string Text
 C10 string ipairs
 C12 string daftar
 C13 string find
 C15 string nama
 C16 string table
 C17 string insert
 C19 string urut
 C20 string id
 C21 string sort
 C23 string Templates
 C24 string KartuBarang
 C25 string Clone
 C26 string Visible
 C27 string B_
 C28 string Name
 C29 string LayoutOrder
 C30 string Ikon
 C31 string ikon
 C32 string Image
 C33 string Nama
 C34 number 1
 C35 string q
 C36 string kat
 C37 string gold
 C38 string kunci
 C39 string -
 C40 string  ×
 C41 string Angka
 C42 string Satuan
 C43 string h
 C44 string math
 C45 string floor
 C47 string Rupiah
 C48 string  / satuan
 C49 string oleh 
 C50 string sn
 C51 string tostring
 C53 string Harga
 C54 string Rarity
 C55 string pet
 C56 string upper
 C58 string rarity
 C59 string pilih
 C60 string UIStroke
 C61 string aktifTab
 C62 string Color
 C63 string Transparency
 C64 number 2.5
 C65 string Thickness
 C66 string Activated
 C67 string Connect
 C68 string Parent
 C69 string Kosong
 C70 number 0
 C71 string Belum ada barang di kategori ini.
 C72 string Tidak ada barang yang cocok.
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 FUNCTION function: 0xd69e89f4b8150caf
 U3 TABLE table: 0x7a52fdbf20ff8ac4
 U4 TABLE table: 0x8f9f7a97a52c9e7d
 U5 TABLE table: 0xdbe0587e2dff8d22
 U6 TABLE table: 0x9a75f1069bf0543a
 U7 TABLE table: 0x72fc978fc23d6679
 U8 FUNCTION function: 0xab55b034eb6a8647
 U9 TABLE table: 0x8f9f7a97a52c9e7d
  [1] TABLE
  [2] TABLE
  [3] TABLE
 U10 FUNCTION function: 0xe78ec0aa69ef0cb4

[FUNCTION] TARGET VOCAB CANDIDATE 28.U10 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=beli line=nil
 C1 string pilih
 C2 string proses
 C3 string HalBeli
 C4 string Detail
 C5 string Isi
 C6 string TombolBeli
 C7 string Aktif
 C8 string GetAttribute
 C9 string judul
 C10 string Konfirmasi beli
 C11 string l1
 C12 string Kamu bayar
 C13 string n1
 C14 string w1
 C15 string l2
 C16 string Kamu dapat
 C17 string n2
 C18 string w2
 C19 string l3
 C20 string Penjual
 C21 string n3
 C22 string catatan
 C23 string Cek lagi barang & harganya. Pembelian tidak bisa dibatalkan.
 C24 string ya
 C25 string BELI
 C27 string h
 C28 string Rupiah
 C29 string teksKuning
 C30 string +
 C31 number 1
 C32 string q
 C33 string kat
 C34 string gold
 C35 string kunci
 C36 string -
 C37 string nama
 C38 string  ×
 C39 string Angka
 C40 string teksHijau
 C41 string sn
 C42 string tostring
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U3 FUNCTION function: 0xe40aa92f95c7a275
 U4 TABLE table: 0xdbe0587e2dff8d22
 U5 TABLE table: 0x9a75f1069bf0543a
 U6 FUNCTION function: 0xf92969312829e830
 U7 TABLE table: 0x72fc978fc23d6679
 U8 FUNCTION function: 0xe299b7308fe61058
 U11 FUNCTION function: 0x40ad77a3f52fd6ac

[FUNCTION] TARGET VOCAB CANDIDATE 28.U11 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=bukaPopup line=nil
 C1 string jual
 C2 string toast
 C3 string Pilih barang yang mau dijual dulu.
 C4 string jumlah
 C5 string kat
 C6 string pet
 C7 string Pet dijual 1 ekor.
 C8 string PopupAngka
 C9 string Kartu
 C10 string mode
 C11 number 0
 C12 number 1
 C13 string math
 C14 string max
 C16 string Judul
 C17 string Jumlah 
 C18 string barang
 C19 string nama
 C20 string Text
 C21 string nilai
 C22 string q
 C23 string floor
 C25 string tostring
 C27 number 2
 C28 string kecil
 C29 string 25%
 C30 number 0.25
 C31 string 50%
 C32 number 0.5
 C33 string 75%
 C34 number 0.75
 C35 string SEMUA
 C36 string ipairs
 C38 string Cepat
 C39 string C
 C40 string Visible
 C41 string Aksi
 C42 string persen
 C43 string SetAttribute
 C44 string Nilai
 C45 string Harga total 
 C47 string gold
 C48 string kunci
 C49 string -
 C50 string  ×
 C51 string Angka
 C52 string harga
 C53 string termurah
 C54 string TERMURAH
 C55 string −10%
 C56 string turun
 C57 string +10%
 C58 string naik
 C59 string HAPUS
 C60 string hapus
 C61 number 10
 C62 string besar
 C63 string Langkah
 C64 string KurangBesar
 C65 string −
 C66 string KurangKecil
 C67 string TambahKecil
 C68 string +
 C69 string TambahBesar
 C70 string sibuk
 C71 string Kotak
 C72 string 
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 TABLE table: 0x72fc978fc23d6679
 U3 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U4 TABLE table: 0xb22bcf6cf89a19c2
 U5 TABLE table: 0xdbe0587e2dff8d22
 U6 FUNCTION function: 0x595d29e1e8325b9d
 U12 TABLE table: 0xb22bcf6cf89a19c2
 U13 FUNCTION function: 0x595d29e1e8325b9d
 U14 FUNCTION function: 0x45b71c92a114bf65
 U15 FUNCTION function: 0x795bbc1518b556e1

[FUNCTION] TARGET VOCAB CANDIDATE 28.U15 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=simpanPopup line=nil
 C1 string mode
 C2 string jumlah
 C3 string jual
 C4 string q
 C5 string HARGA_MIN
 C6 string HARGA_MAKS
 C7 string nilai
 C8 string Jumlah harus 1 – 
 C9 string Angka
 C10 string .
 C11 string toast
 C12 string Harga harus 
 C13 string Rupiah
 C14 string  – 
 C15 string harga
 C16 string PopupAngka
 C17 string Visible
 U1 TABLE table: 0xb22bcf6cf89a19c2
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U4 TABLE table: 0x72fc978fc23d6679
 U5 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U6 FUNCTION function: 0xc9ba645cce4bdfc9
 U16 FUNCTION function: 0xc9ba645cce4bdfc9

[FUNCTION] TARGET VOCAB CANDIDATE 28.U16 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=hitungJual line=nil
 C1 string HalJual
 C2 string Form
 C3 string jual
 C4 number 0
 C5 string harga
 C6 string jumlah
 C7 string Ringkasan
 C8 string HargaJual
 C9 string Rupiah
 C10 string Text
 C11 string Pajak
 C12 string − 
 C13 string Terima
 C14 string Bersih
 C15 string TombolJumlah
 C16 string Nilai
 C17 string Angka
 C18 string  
 C19 string 
 C20 string kat
 C21 string gold
 C22 string kunci
 C23 string pet
 C24 string buah
 C25 string Atur jumlah
 C26 string TombolHarga
 C27 string Atur harga
 C28 string Pilihan
 C29 string -
 C30 string nama
 C31 string  · kamu punya 
 C32 string q
 C33 string ≈ 
 C34 string math
 C35 string floor
 C37 string  / satuan
 C38 string table
 C39 string insert
 C41 string termurah
 C42 string termurah di Market 
 C43 string InfoHarga
 C44 string concat
 C46 string    ·   
 C47 string Pilih barang di atas
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 TABLE table: 0xdbe0587e2dff8d22
 U17 FUNCTION function: 0x7cbc5ba4908af6f7

[FUNCTION] TARGET VOCAB CANDIDATE 28.U17 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=pasang line=nil
 C1 string proses
 C2 string HalJual
 C3 string Form
 C4 string jual
 C5 string toast
 C6 string Pilih barang yang mau dijual dulu.
 C7 number 0
 C8 string jumlah
 C9 string harga
 C10 string Atur jumlah barang dulu (tombol UBAH).
 C11 string Atur harga dulu (tombol UBAH).
 C12 string q
 C13 string Jumlah melebihi barang yang kamu punya.
 C14 string HARGA_MIN
 C15 string HARGA_MAKS
 C16 string Harga harus 
 C17 string Rupiah
 C18 string  – 
 C19 string .
 C20 string judul
 C21 string Pasang jualan
 C22 string l1
 C23 string Kamu jual
 C24 string n1
 C25 string l2
 C26 string Harga total
 C27 string n2
 C28 string w2
 C29 string l3
 C30 string n3
 C31 string w3
 C32 string catatan
 C33 string Barang langsung keluar dari tasmu. Harga tidak bisa diubah, tapi lapak bisa ditarik sebelum laku.
 C34 string ya
 C35 string PASANG
 C36 string warnaYa
 C38 string nama
 C39 string kat
 C41 number 1
 C42 string gold
 C43 string kunci
 C44 string -
 C45 string  ×
 C46 string Angka
 C47 string teksKuning
 C48 string Kamu terima saat laku (setelah pajak 
 C49 string %)
 C50 string Kamu terima saat laku
 C51 string Bersih
 C52 string teksHijau
 C53 string aktifTab
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U3 TABLE table: 0x72fc978fc23d6679
 U4 TABLE table: 0xdbe0587e2dff8d22
 U5 FUNCTION function: 0xe40aa92f95c7a275
 U6 TABLE table: 0x9a75f1069bf0543a
 U7 boolean false
 U8 number 0
 U9 FUNCTION function: 0xf92969312829e830
 U10 FUNCTION function: 0xc9ba645cce4bdfc9
 U11 FUNCTION function: 0xca3b8e006f04d6d9
 U12 FUNCTION function: 0x7b03b3e4edafaf99
 U18 TABLE table: 0x9a75f1069bf0543a
  [abu] userdata 0.352941, 0.376471, 0.470588
  [biru] userdata 0.215686, 0.541176, 0.866667
  [teksHijau] userdata 0.509804, 0.882353, 0.54902
  [aktifTab] userdata 0.960784, 0.588235, 0.156863
  [teksPudar] userdata 0.745098, 0.803922, 1
  [putih] userdata 1, 1, 1
  [teksMerah] userdata 0.941176, 0.588235, 0.588235
  [teksKuning] userdata 1, 0.886275, 0.470588
  [hijau] userdata 0.113725, 0.619608, 0.458824
 U19 FUNCTION function: 0x7b03b3e4edafaf99

[FUNCTION] TARGET VOCAB CANDIDATE 28.U19 source==ReplicatedStorage.NKSystem.Util.TabletMarket name= line=nil
 C1 string HalJual
 C2 string Lapak
 C3 string token
 C4 string Lapakku
 C5 string Daftar
 C6 string type
 C8 string table
 C9 string Kosong
 C10 string Visible
 C11 string string
 C12 string Gagal memuat Lapakku.
 C13 string Text
 C14 string daftar
 C15 string Judul
 C16 string Lapakku · 
 C17 string /
 C18 string slotMaks
 C19 string SLOT
 C20 string tostring
 C22 string  slot
 C23 string terjual
 C24 number 1
 C25 string habis
 C26 number 2
 C27 string batal
 C28 string aktif
 C29 number 3
 C30 string dipesan
 C31 number 4
 C32 string proses
 C33 number 5
 C35 string sort
 C37 string Templates
 C38 string BarisLapak
 C39 number 0.24
 C40 string AbsoluteWindowSize
 C41 string Y
 C42 string math
 C43 string floor
 C45 string max
 C47 string ipairs
 C49 string Clone
 C50 string L_
 C51 string id
 C52 string Name
 C53 string LayoutOrder
 C54 string UDim2
 C55 string new
 C57 string Size
 C58 string Ikon
 C59 string 
 C60 string ikon
 C61 string Image
 C62 string Nama
 C63 string q
 C64 string kat
 C65 string gold
 C66 string kunci
 C67 string -
 C68 string nama
 C69 string  ×
 C70 string Angka
 C71 string Aksi
 C72 string Sub
 C73 string Harga 
 C74 string h
 C75 string Rupiah
 C76 string st
 C77 string Status
 C78 string Terjual ke 
 C79 string bn
 C80 string teksHijau
 C81 string TextColor3
 C82 string Kamu terima 
 C83 string bersih
 C84 string teksKuning
 C85 string UIStroke
 C86 string Color
 C87 number 0.2
 C88 string Transparency
 C89 string hijau
 C90 string AMBIL UANG
 C91 string BackgroundColor3
 C92 string AutoButtonColor
 C93 string Aktif
 C94 string SetAttribute
 C95 string lewat
 C96 string Kedaluwarsa · tidak laku
 C97 string teksMerah
 C98 number 0.3
 C99 string biru
 C100 string AMBIL BARANG
 C101 string Ditarik · barang belum diambil
 C102 string Aktif · sisa 
 C103 string sisa
 C104 string abu
 C105 string TARIK
 C106 string Sedang dibeli…
 C107 string Sedang disimpan…
 C108 string Activated
 C109 string Connect
 C110 string Parent
 C111 number 0
 C112 string Belum ada jualan. Pasang barang pertamamu di kiri!
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 TABLE table: 0x7a52fdbf20ff8ac4
 U3 FUNCTION function: 0xf92969312829e830
 U4 FUNCTION function: 0xd69e89f4b8150caf
 U5 TABLE table: 0xdbe0587e2dff8d22
 U6 TABLE table: 0x9a75f1069bf0543a
 U7 FUNCTION function: 0xc49587557e68eabb
 U8 TABLE table: 0x72fc978fc23d6679
 U9 FUNCTION function: 0x146adb92ff78d3c5
 U20 FUNCTION function: 0xca3b8e006f04d6d9

[FUNCTION] TARGET VOCAB CANDIDATE 28.U20 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=muatStok line=nil
 C1 string HalJual
 C2 string Form
 C3 string StokJual
 C4 string Tas
 C5 string type
 C7 string table
 C8 string stok
 C9 string Templates
 C10 string TasItem
 C11 string ipairs
 C13 string Clone
 C14 string Visible
 C15 string T_
 C16 string Name
 C17 string LayoutOrder
 C18 string Kunci
 C19 string k
 C20 string SetAttribute
 C21 string Ikon
 C22 string 
 C23 string ikon
 C24 string Image
 C25 string Jumlah
 C26 string kat
 C27 string pet
 C28 string Pet
 C29 string nama
 C30 string tostring
 C32 string q
 C33 string Angka
 C34 string Text
 C35 string Activated
 C36 string Connect
 C37 string Parent
 C38 string TasKosong
 C39 number 0
 C40 string jual
 C41 string jumlah
 C42 string harga
 C43 string termurah
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 FUNCTION function: 0xf92969312829e830
 U3 FUNCTION function: 0xd69e89f4b8150caf
 U4 TABLE table: 0x7a52fdbf20ff8ac4
 U5 TABLE table: 0xdbe0587e2dff8d22
 U6 TABLE table: 0x72fc978fc23d6679
 U7 FUNCTION function: 0xffd33ed4665866a4
 U8 FUNCTION function: 0xc9ba645cce4bdfc9
 U21 FUNCTION function: 0x978c3b7a1cb6fdbd

[FUNCTION] TARGET VOCAB CANDIDATE 28.U21 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=bukaTab line=nil
 C1 string tab
 C2 string token
 C3 number 1
 C4 string HalBeli
 C5 string Beli
 C6 string Visible
 C7 string HalJual
 C8 string Jual
 C9 string HalRiwayat
 C10 string Riwayat
 C11 string ipairs
 C13 string Tab
 C14 string aktifTab
 C15 string putih
 C16 string BackgroundColor3
 C17 number 0.86
 C18 string BackgroundTransparency
 C19 string Color3
 C20 string fromRGB
 C22 string TextColor3
 C23 string task
 C24 string spawn
 C26 string Form
 C27 string info
 C28 number 0
 C29 string level
 C30 string minLevel
 C31 string MIN_LEVEL_JUAL
 C32 string Terkunci
 C33 string T
 C34 string 🔒 Berjualan butuh minimal Level 
 C35 string tostring
 C37 string 
(level kamu sekarang 
 C38 string )
 C39 string Text
 U1 TABLE table: 0x7a52fdbf20ff8ac4
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U3 TABLE table: 0x9a75f1069bf0543a
 U4 FUNCTION function: 0xe299b7308fe61058
 U5 TABLE table: 0xdbe0587e2dff8d22
 U6 FUNCTION function: 0xca3b8e006f04d6d9
 U7 FUNCTION function: 0x7b03b3e4edafaf99
 U8 FUNCTION function: 0xde8bef4f35e0745c
 U22 boolean false
 U23 number 0
 U25 TABLE table: 0xda0f166d4ec11a3a
 U26 TABLE table: 0xb5b47bfed36bf161
  [GetPlayerData] FUNCTION
  [UnlockLevel] FUNCTION
  [MoneyChanged] TABLE
  [Notify] TABLE
  [ShopUpdated] TABLE
 U27 FUNCTION function: 0x9c1baf8b6a0e2bfa

[FUNCTION] TARGET VOCAB CANDIDATE 28.U27 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=setSaldo line=nil
 C1 string tonumber
 C3 string AppBar
 C4 string Saldo
 C5 string T
 C6 string Rupiah
 C7 string Text
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMarket
 U2 TABLE table: 0xdbe0587e2dff8d22
 U28 TABLE table: 0x41615eefb2e9ccc3
  [Ambil] FUNCTION
  [StokJual] FUNCTION
  [Beli] FUNCTION
  [Lapakku] FUNCTION
  [Kabar] TABLE
  [Info] FUNCTION
  [Jelajah] FUNCTION
  [Riwayat] FUNCTION
  [Pasang] FUNCTION
  [Detail] FUNCTION
  [Tarik] FUNCTION
 U29 FUNCTION function: 0xc49587557e68eabb

[FUNCTION] TARGET VOCAB CANDIDATE 28.U29 source==ReplicatedStorage.NKSystem.Util.TabletMarket name=sisaTeks line=nil
 C1 number 0
 C2 string math
 C3 string floor
 C5 string max
 C7 number 3600
 C8 number 60
 C9 string string
 C10 string format
 C12 string %dh %dj
 C13 number 24
 C14 string %dj %dm
 C15 string %dm
 C16 number 1

[FUNCTION] TARGET VOCAB CANDIDATE 29 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=isiBaris line=nil
 C1 string HalDaftar
 C2 string Baris
 C3 string table
 C4 string clear
 C6 string kunci
 C7 string CARI
 C8 string Aksi
 C9 string Saring
 C10 string Isi
 C11 string Text
 C12 string daftar
 C13 string ipairs
 C15 string Clone
 C16 string Visible
 C17 string LayoutOrder
 C18 string No
 C19 string SetAttribute
 C20 string tostring
 C22 string Judul
 C23 string judul
 C24 string Artis
 C25 string artis
 C26 string PL
 C27 string tag
 C28 string Playlist
 C29 string nama
 C30 string gambar
 C31 string 
 C32 string warna
 C34 string Color3
 C35 string fromRGB
 C37 string Durasi
 C38 string 0:00
 C39 string math
 C40 string floor
 C42 string string
 C43 string format
 C45 string %d:%02d
 C46 number 60
 C47 string -:--
 C48 string Sampul
 C49 string id
 C50 string SampulLagu
 C51 string Image
 C52 string BackgroundColor3
 C53 string Glyph
 C54 string FindFirstChild
 C55 string Kilau
 C56 string Enabled
 C57 string Parent
 C58 string Activated
 C59 string Connect
 C60 string Suka
 C61 string MouseEnter
 C62 string MouseLeave
 C63 string Kosong
 C64 number 0
 C65 string DISUKAI
 C66 string Tekan ♡ pada lagu untuk menyukainya
 C67 string ID
 C68 string Masukkan kode ID musik di kotak atas lalu tekan PUTAR
 C69 string RIWAYAT
 C70 string Belum ada lagu yang diputar
 C71 string Lagu tidak ditemukan
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Utama
 U2 FUNCTION function: 0x0f27c1953ef3fc9e

[FUNCTION] TARGET VOCAB CANDIDATE 29.U2 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=bersihkan line=nil
 C1 string ipairs
 C3 string GetChildren
 C4 string Name
 C5 string Destroy
 U3 TABLE table: 0x5731b12b946ad8c9
 U4 FUNCTION function: 0x59746ec8d4bb9f50

[FUNCTION] TARGET VOCAB CANDIDATE 29.U4 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=daftarDari line=nil
 C1 string SEMUA
 C2 string CARI
 C3 string DISUKAI
 C4 string ID
 C5 string RIWAYAT
 C6 string lower
 C7 string 
 C8 string ipairs
 C10 string judul
 C11 string  
 C12 string artis
 C13 string find
 C14 string table
 C15 string insert
 U1 TABLE table: 0xab080fd783bab462
 U2 TABLE table: 0x280675fdbfceabce
 U3 TABLE table: 0x63190c57c6bc8ac0
 U4 TABLE table: 0x8556358de2eda93f
 U5 TABLE table: 0x3f17d03b3dc48bf3
 U5 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Templat
 U6 TABLE table: 0x8918abf47d42fe63
  [Ikon] TABLE
  [Playlist] TABLE
  [VolumeAwal] number 0.5
  [SampulLagu] TABLE
  [SpeedID] number 0.43
 U7 TABLE table: 0x678f1dc04d896fbd
 U8 FUNCTION function: 0xc0920fd37487025c

[FUNCTION] TARGET VOCAB CANDIDATE 29.U8 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=pas line=nil
 C1 string Pas
 C2 string GetAttribute
 C3 string SetAttribute
 C4 string TextScaled
 C5 string AbsoluteSize
 C6 string GetPropertyChangedSignal
 C7 string Connect
 C8 string Y
 C9 number 0.95
 C10 string math
 C11 string floor
 C13 string max
 C15 string TextSize
 U9 FUNCTION function: 0x4d721e605f409fad

[FUNCTION] TARGET VOCAB CANDIDATE 29.U9 source==ReplicatedStorage.NKSystem.Util.TabletMusik name= line=nil
 C1 number 1
 C2 string Stop
 C3 string aset
 C4 string SoundId
 C5 string speed
 C6 string PlaybackSpeed
 C7 string TimePosition
 C8 string Play
 C9 string AmbientBacksound
 C10 string FindFirstChild
 C11 string VolAsliMusik
 C12 string GetAttribute
 C13 string Volume
 C14 string SetAttribute
 C15 string kunci
 C16 string table
 C17 string remove
 C19 string insert
 C21 string task
 C22 string spawn
 U1 TABLE table: 0xf008c49b0d49ea9e
 U2 number 0
 U4 number 0
 U5 FUNCTION function: 0xb34e5fc4d0a97634
 U6 userdata SoundService
 U7 FUNCTION function: 0xe68508808c91dd79
 U8 TABLE table: 0x8556358de2eda93f
 U9 FUNCTION function: 0xefad4ea596f0b545
 U10 userdata ContentProvider
 U11 TABLE table: 0x678f1dc04d896fbd
 U12 FUNCTION function: 0xd327083eb088261d
 U13 TABLE table: 0x0a23a939e3960381
 U10 FUNCTION function: 0x798f2d95cd811bdc

[FUNCTION] TARGET VOCAB CANDIDATE 29.U10 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=sukai line=nil
 C1 string kunci
 C2 string table
 C3 string remove
 C5 string toast
 C6 string Dihapus dari Lagu Disukai
 C7 string insert
 C9 string Ditambahkan ke Lagu Disukai
 C10 string sfx
 C11 string tabKlik
 C12 string DISUKAI
 U1 TABLE table: 0x260ad7794afe5d48
 U2 TABLE table: 0x280675fdbfceabce
 U3 TABLE table: 0x0a23a939e3960381
 U4 TABLE table: 0x5774634fe8fbeb7b
 U5 FUNCTION function: 0x98bef918fbf4dcff
 U6 FUNCTION function: 0xefad4ea596f0b545
 U11 TABLE table: 0x260ad7794afe5d48
 U12 FUNCTION function: 0xefad4ea596f0b545

[FUNCTION] TARGET VOCAB CANDIDATE 29.U12 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=segarkanPemutar line=nil
 C1 string Playing
 C2 string Kontrol
 C3 string Putar
 C4 string Jeda
 C5 string II
 C6 string ▶
 C7 string 
 C8 string Ikon
 C9 string Gambar
 C10 string FindFirstChild
 C11 string Image
 C12 string Text
 C13 string TextTransparency
 C14 string HalDaftar
 C15 string Aksi
 C16 string PutarBesar
 C17 string jenis
 C18 string daftar
 C19 string Judul
 C20 string judul
 C21 string Artis
 C22 string artis
 C23 string Sampul
 C24 string tag
 C25 string Playlist
 C26 string nama
 C27 string gambar
 C28 string warna
 C30 string Color3
 C31 string fromRGB
 C33 string id
 C34 string SampulLagu
 C35 string BackgroundColor3
 C36 string Glyph
 C37 string Visible
 C38 string Kilau
 C39 string Enabled
 C40 string kunci
 C41 string Suka
 C42 string SukaPenuh
 C43 string ♥
 C44 string ♡
 C45 string TextColor3
 C46 string ImageColor3
 C47 string Acak
 C48 string Titik
 C49 string Ulang
 C50 string Satu
 C51 number 2
 C52 string AcakBesar
 U2 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Pemutar
 U3 TABLE table: 0x8918abf47d42fe63
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Utama
 U5 TABLE table: 0x5774634fe8fbeb7b
 U7 TABLE table: 0xf008c49b0d49ea9e
 U8 TABLE table: 0x260ad7794afe5d48
 U9 userdata 0.117647, 0.843137, 0.376471
 U10 userdata 0.701961, 0.701961, 0.701961
 U11 boolean false
 U12 number 0
 U13 FUNCTION function: 0xd327083eb088261d

[FUNCTION] TARGET VOCAB CANDIDATE 30 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=buka line=nil
 C1 string dipilih
 C2 string gui
 C3 string kotak
 C4 string kosong
 C5 string cahaya
 C6 string Destroy
 C7 string Tutup
 C8 string Visible
 C9 number 1
 C10 string rarityColor
 C11 string rarity
 C12 string type
 C13 string none
 C14 string cam
 C15 number 2
 C16 string FieldOfView
 C17 string math
 C18 string rad
 C20 string tan
 C22 number 4.8
 C23 string CFrame
 C24 string new
 C26 number -2.6
 C27 string Angles
 C29 number 2.7576202181510405
 C30 string GetPivot
 C31 string rakPose
 C32 string terbang
 C33 number 0.75
 C34 string PivotTo
 C35 string ipairs
 C37 string GetDescendants
 C38 string BasePart
 C39 string IsA
 C40 string Name
 C41 string string
 C42 string sub
 C44 string ToObjectSpace
 C45 string X
 C46 string Z
 C47 string Vector3
 C49 string Magnitude
 C50 number 0.01
 C51 string Kiri
 C52 string find
 C53 string Kanan
 C54 string p
 C55 string rel
 C56 string tinggi
 C57 string engsel
 C58 string sumbu
 C59 string maks
 C61 string Y
 C63 string Unit
 C64 string Cross
 C65 string table
 C66 string sort
 C69 string lakban
 C70 number 0.55
 C71 number 0.9
 C72 string kardus
 C73 number 0.5
 C74 number 0.7
 C75 number 3.141592653589793
 C77 string Rays
 C78 string UDim2
 C79 string fromScale
 C81 string Position
 C82 string Color3
 C83 string fromRGB
 C85 string ImageColor3
 C86 string ImageTransparency
 C88 number 0.6
 C89 number 0.12
 C90 string TweenInfo
 C92 number 0.4
 C93 string Enum
 C94 string EasingStyle
 C95 string Quad
 C97 string EasingDirection
 C98 string Out
 C100 string Create
 C101 string Play
 C102 string Linear
 C104 string InOut
 C106 string Rotation
 C108 number 360
 C109 string task
 C110 string spawn
 C112 string muncul
 C113 string Ikon
 C115 string vpf
 C116 string Parent
 C117 string icon
 C118 string 
 C120 string Image
 C121 number 0.05
 C122 string Size
 C123 number 0
 C125 number 0.22
 C126 string Back
 C128 number 0.45
 C129 number 0.65
 C130 string Nama
 C131 string TextColor3
 C132 string ?
 C133 string name
 C134 string Sub
 C135 number 1.6
 C136 number 2.4
 C137 string os
 C138 string clock
 C140 number 2.2
 C141 number 3
 C142 string sin
 C144 string RenderStepped
 C145 string Wait
 C146 number 0.2
 C148 number 0.25
 C149 number 0.3
 C150 string Cancel
 U1 TABLE table: 0x2c5d2d8e6c52a35c
 U2 TABLE table: 0x44b3be69b1065740
 U3 FUNCTION function: 0x3ac30e390561d133

[FUNCTION] TARGET VOCAB CANDIDATE 30.U3 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=bunyi line=nil
 C1 string Instance
 C2 string new
 C4 string Sound
 C5 string SoundId
 C6 string Volume
 C7 string Parent
 C8 string Play
 C9 string Ended
 C10 string Once
 C11 string task
 C12 string delay
 U1 TABLE table: 0x50b7ce8d8f4ffd81
 U2 userdata SoundService
 U4 FUNCTION function: 0xc4393ce1671aba2c

[FUNCTION] TARGET VOCAB CANDIDATE 30.U4 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=animasi line=nil
 C1 string os
 C2 string clock
 C4 string math
 C5 string clamp
 C7 string RenderStepped
 C8 string Wait
 U1 userdata Run Service
 U5 FUNCTION function: 0x5662f5c6e173a0fe
 U6 FUNCTION function: 0x9e154f8f059cc9a4
 U7 FUNCTION function: 0x81703489983a03f2

[FUNCTION] TARGET VOCAB CANDIDATE 30.U7 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=proyeksi line=nil
 C1 string cam
 C2 string vpf
 C3 string CFrame
 C4 string PointToObjectSpace
 C5 number 2
 C6 string FieldOfView
 C7 string math
 C8 string rad
 C10 string tan
 C12 string AbsoluteSize
 C13 string X
 C14 string Y
 C15 number 1
 C16 string max
 C18 string Z
 C19 number 0.01
 C20 number 0.5
 U1 TABLE table: 0x2c5d2d8e6c52a35c
 U8 userdata TweenService
 U9 FUNCTION function: 0x9f239beb757a1f48

[FUNCTION] TARGET VOCAB CANDIDATE 30.U9 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=teksTampil line=nil
 C1 string Text
 C2 number 0.25
 C3 string TextTransparency
 C5 string TweenInfo
 C6 string new
 C8 string Enum
 C9 string EasingStyle
 C10 string Quad
 C12 string EasingDirection
 C13 string Out
 C15 string Create
 C16 string Play
 C17 string UIStroke
 C18 string FindFirstChildOfClass
 C19 string Transparency
 U1 userdata TweenService
 U10 FUNCTION function: 0x46b9e9482b21c282
 U11 userdata Run Service
 U12 FUNCTION function: 0x860246c9e697022f

[FUNCTION] TARGET VOCAB CANDIDATE 30.U12 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=aturTransparansi line=nil
 C1 string ipairs
 C3 string GetDescendants
 C4 string BasePart
 C5 string IsA
 C6 string _TrAsli
 C7 string GetAttribute
 C8 string Transparency
 C9 string SetAttribute
 C10 string math
 C11 string max

[FUNCTION] TARGET VOCAB CANDIDATE 31 source==ReplicatedStorage.NKSystem.Controller.KotakController name=KnitStart line=nil
 C1 string GetService
 C2 string KotakService
 C3 string PlayerGui
 C4 string WaitForChild
 C5 string KotakMisteriUI
 C6 string [KotakController] StarterGui.KotakMisteriUI tidak ada
 C7 string Layar
 C8 string Kotak
 C9 string Skala
 C10 string Badan
 C11 string Tutup
 C12 string Sinar
 C13 string Sinar2
 C14 string Cahaya
 C15 string Judul
 C16 string UIStroke
 C17 string FindFirstChildOfClass
 C18 string Hadiah
 C19 string _Kartu
 C20 string Info
 C21 string Kilat
 C22 string Konfeti
 C23 string Visible
 C24 string task
 C25 string spawn
 C27 string Backpack
 C28 string ChildAdded
 C30 string Connect
 C31 string Character
 C32 string CharacterAdded
 U1 TABLE table: 0x20e164fe7c1e7b73
  [Buka] FUNCTION
  [Jumlah] FUNCTION
  [JumlahBerubah] TABLE
 U2 TABLE table: 0xda0f166d4ec11a3a
 U3 userdata Players.Raelity911
 U4 FUNCTION function: 0xdcd6d24fca064ce7

[FUNCTION] TARGET VOCAB CANDIDATE 31.U4 source==ReplicatedStorage.NKSystem.Controller.KotakController name= line=nil
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
 U22 FUNCTION function: 0xc54c91cd267a2c6b

[FUNCTION] TARGET VOCAB CANDIDATE 31.U22 source==ReplicatedStorage.NKSystem.Controller.KotakController name=pantau line=nil
 C1 string ipairs
 C3 string GetChildren
 C4 string ChildAdded
 C5 string Connect
 U1 FUNCTION function: 0xaf6e167560c7482a

[FUNCTION] TARGET VOCAB CANDIDATE 32 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=init line=nil
 C1 string pasang
 C2 string LocalPlayer
 C3 string Atas
 C4 string Profil
 C5 string Avatar
 C6 string rbxthumb://type=AvatarHeadShot&id=
 C7 string UserId
 C8 string &w=150&h=150
 C9 string Image
 C10 string Nama
 C11 string DisplayName
 C12 string Text
 C13 string kartu
 C14 string Ikon
 C15 string Aplikasi
 C16 string 
 C17 string FindFirstChild
 C18 string Gambar
 C19 string Glyph
 C20 string Visible
 C21 string BackgroundTransparency
 C22 string Kembali
 C23 string Activated
 C24 string Connect
 C25 string Beranda
 C26 string Cari
 C27 string Koleksi
 C28 string Disukai
 C29 string BuatPlaylist
 C30 string Speaker
 C31 string PanelSpeaker
 C32 string Kartu
 C33 string Tutup
 C34 string Perangkat
 C35 string Mundur
 C36 string Maju
 C37 string KotakID
 C38 string Putar
 C39 string Isi
 C40 string FocusLost
 C42 string HalDaftar
 C43 string Aksi
 C44 string Saring
 C45 string GetPropertyChangedSignal
 C46 string PutarBesar
 C47 string AcakBesar
 C48 string Kontrol
 C49 string Sebelum
 C52 string Acak
 C53 string Ulang
 C54 string Suka
 C55 string VolIkon
 C56 string Progres
 C57 string Bar
 C58 string Volume
 C60 string Heartbeat
 U1 TABLE table: 0x0a23a939e3960381
  [toast] FUNCTION
  [kartu] userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.Beranda.Aplikasi.Musik
  [kembali] FUNCTION
  [sfx] FUNCTION
 U2 TABLE table: 0x181256d89461e725
  [buka] FUNCTION
  [bukaPlaylist] FUNCTION
  [init] FUNCTION
  [pasang] FUNCTION
  [tutup] FUNCTION
 U3 userdata Players
 U4 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Utama
 U5 TABLE table: 0x8918abf47d42fe63
 U6 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Samping
 U7 FUNCTION function: 0xf38db5c056c6f5c9

[FUNCTION] TARGET VOCAB CANDIDATE 32.U7 source==ReplicatedStorage.NKSystem.Util.TabletMusik name= line=nil
 C1 number 1
 C2 string table
 C3 string remove
 C5 string insert
 U1 TABLE table: 0xe15905db79f26ff4
 U2 number 1
 U3 FUNCTION function: 0x98bef918fbf4dcff
 U8 FUNCTION function: 0xfc887d8d41bb2650

[FUNCTION] TARGET VOCAB CANDIDATE 32.U8 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=bukaPanel line=nil
 C1 string PanelSpeaker
 C2 number 1
 C3 string Visible
 C4 string Kartu
 C5 string Radar
 C6 string Pusat
 C7 string Denyut
 C8 string UDim2
 C9 string fromScale
 C11 string Size
 C12 number 0.3
 C13 string BackgroundTransparency
 C14 string Cancel
 C15 string game
 C17 string TweenService
 C18 string GetService
 C19 string TweenInfo
 C20 string new
 C22 number 1.3
 C23 string Enum
 C24 string EasingStyle
 C25 string Quad
 C27 string EasingDirection
 C28 string Out
 C31 number 2.4
 C32 string Create
 C33 string Play
 C34 string task
 C35 string spawn
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik
 U2 boolean false
 U3 number 0
 U5 FUNCTION function: 0x6b589ffd519c3f76
 U6 FUNCTION function: 0x15e3b32158bae190
 U9 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik
 U10 boolean false
 U11 number 0
 U13 boolean false
 U14 FUNCTION function: 0x0519941ba61832cc

[FUNCTION] TARGET VOCAB CANDIDATE 32.U14 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=minta line=nil
 C1 string pcall
 C3 string type
 C5 string table
 C6 string andThen
 U1 FUNCTION function: 0xecfc53c118c862e5
 U15 FUNCTION function: 0x9c2d4a89e17b4bfa

[FUNCTION] TARGET VOCAB CANDIDATE 32.U15 source==ReplicatedStorage.NKSystem.Util.TabletMusik name= line=nil
 C1 number 0.8
 C2 string jauh
 C3 string toast
 C4 string Kamu menjauh dari speaker, musik pindah ke tablet
 C5 string tolak
 C6 string Speaker tidak bisa memutar lagu ini
 C7 string  Musik pindah ke tablet.
 C8 string hilang
 C9 string ganti
 C10 string Speaker dipindah/dihapus, musik kembali ke tablet
 C11 string Speaker diputus, musik kembali ke tablet
 U1 boolean false
 U2 FUNCTION function: 0xfaf5f987db1da48f
 U3 boolean false
 U4 number 0.5
 U5 TABLE table: 0x0a23a939e3960381
 U6 FUNCTION function: 0x6b589ffd519c3f76
 U7 boolean false
 U8 FUNCTION function: 0x15e3b32158bae190
 U16 number 1
 U17 FUNCTION function: 0x98bef918fbf4dcff

[FUNCTION] TARGET VOCAB CANDIDATE 32.U17 source==ReplicatedStorage.NKSystem.Util.TabletMusik name= line=nil
 C1 string jenis
 C2 string beranda
 U1 TABLE table: 0x5774634fe8fbeb7b
 U2 FUNCTION function: 0xc631248c89101a0d
 U3 FUNCTION function: 0x355f6d49d7f8d630
 U4 FUNCTION function: 0xefb26c0e7ba31ba8
 U5 FUNCTION function: 0xefad4ea596f0b545
 U18 TABLE table: 0xe15905db79f26ff4
  [1] TABLE
 U19 FUNCTION function: 0x4902e5529a11f9df

[FUNCTION] TARGET VOCAB CANDIDATE 32.U19 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=putarKode line=nil
 C1 string Atas
 C2 string KotakID
 C3 string Isi
 C4 string Text
 C5 string %d+
 C6 string match
 C7 string toast
 C8 string Masukkan kode ID musik (angka)
 C9 string sfx
 C10 string error
 C11 string 
 C12 string ReleaseFocus
 C13 string id
 C14 string ipairs
 C16 string kunci
 C17 string judul
 C18 string artis
 C19 string aset
 C20 string speed
 C21 string tag
 C22 string ID
 C24 string Musik #
 C25 string Kode ID 
 C26 string rbxassetid://
 C27 string SpeedID
 C28 string DefaultSpeed
 C29 string table
 C30 string insert
 C32 string task
 C33 string spawn
 C35 string Memutar kode ID 
 C36 string jenis
 C37 string beranda
 U1 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Utama
 U2 TABLE table: 0x0a23a939e3960381
 U3 TABLE table: 0x63190c57c6bc8ac0
 U4 TABLE table: 0x8918abf47d42fe63
 U5 TABLE table: 0xdc8c8dc023b374e5
 U6 userdata MarketplaceService
 U8 number 0
 U10 boolean false
 U11 FUNCTION function: 0x0519941ba61832cc
 U12 userdata SoundService
 U13 TABLE table: 0x5774634fe8fbeb7b
 U14 FUNCTION function: 0x98bef918fbf4dcff
 U15 FUNCTION function: 0x4d721e605f409fad
 U20 TABLE table: 0x5774634fe8fbeb7b
  [jenis] string beranda
 U21 FUNCTION function: 0x433237c5a3f54adc
 U23 TABLE table: 0xf008c49b0d49ea9e
 U24 FUNCTION function: 0xe2b7c9b7cb863796

[FUNCTION] TARGET VOCAB CANDIDATE 32.U24 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=putarJeda line=nil
 C1 string daftar
 C2 string Playing
 C3 string Pause
 C4 string AmbientBacksound
 C5 string FindFirstChild
 C6 string VolAsliMusik
 C7 string GetAttribute
 C8 string Volume
 C9 string SetAttribute
 C10 string KontrolTablet
 C11 string jeda
 C13 string catch
 C14 string TimePosition
 C15 string Resume
 C16 string Play
 C17 string lanjut
 U2 TABLE table: 0x5774634fe8fbeb7b
 U3 TABLE table: 0xab080fd783bab462
 U4 FUNCTION function: 0x4d721e605f409fad
 U5 FUNCTION function: 0xb34e5fc4d0a97634
 U6 userdata SoundService
 U7 boolean false
 U8 FUNCTION function: 0x0519941ba61832cc
 U9 FUNCTION function: 0xefad4ea596f0b545
 U25 FUNCTION function: 0x4d721e605f409fad
 U26 boolean false
 U27 FUNCTION function: 0xefad4ea596f0b545
 U28 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Pemutar
 U29 FUNCTION function: 0x63fdede1035d1491

[FUNCTION] TARGET VOCAB CANDIDATE 32.U29 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=lompat line=nil
 C1 string TimePosition
 C2 string PlaybackSpeed
 C3 number 0.01
 C4 string math
 C5 string max
 C7 string KontrolTablet
 C8 string seek
 C10 string catch
 C11 number 0
 C12 string random
 C14 number 1
 U2 FUNCTION function: 0xe2b7c9b7cb863796
 U3 FUNCTION function: 0xb34e5fc4d0a97634
 U4 boolean false
 U5 FUNCTION function: 0x0519941ba61832cc
 U6 TABLE table: 0xf008c49b0d49ea9e
 U7 boolean false
 U8 number 0
 U9 FUNCTION function: 0x4d721e605f409fad
 U30 number 0
 U31 FUNCTION function: 0x798f2d95cd811bdc
 U32 boolean false
 U33 FUNCTION function: 0x594fbea8ac87a7b6

[FUNCTION] TARGET VOCAB CANDIDATE 32.U33 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=setVolume line=nil
 C1 string Cancel
 C2 string Volume
 C3 string task
 C4 string delay
 C6 number 0.15
 C7 string Isi
 C8 string UDim2
 C9 string fromScale
 C11 string Size
 C12 string Kenop
 C13 number 0.5
 C14 string Position
 C15 number 0
 C16 string VolIkon
 C17 string Bisu
 C18 string 🔇
 C19 string 🔈
 C20 string 
 C21 string Ikon
 C22 string Gambar
 C23 string FindFirstChild
 C24 string Image
 C25 string Text
 C26 string TextTransparency
 U1 number 0.5
 U2 boolean false
 U5 boolean false
 U6 boolean false
 U7 FUNCTION function: 0x0519941ba61832cc
 U8 userdata Players.Raelity911.PlayerGui.TabletUI.Bingkai.Layar.AppMusik.Pemutar
 U9 TABLE table: 0x8918abf47d42fe63
 U34 number 0.5
 U35 FUNCTION function: 0x6f64d3880a6801eb

[FUNCTION] TARGET VOCAB CANDIDATE 32.U35 source==ReplicatedStorage.NKSystem.Util.TabletMusik name=slider line=nil
 C1 string Area
 C2 string InputBegan
 C3 string Connect
 C4 string InputChanged
 C5 string InputEnded
 C6 string MouseEnter
 C7 string MouseLeave
 U1 userdata 0.117647, 0.843137, 0.376471
 U2 userdata 1, 1, 1
 U3 userdata UserInputService
 U36 boolean false
 U37 number 0
 U39 userdata Run Service

[FUNCTION] TARGET VOCAB CANDIDATE 33 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=targetHud line=nil
 C1 string workspace
 C3 string CurrentCamera
 C4 string ViewportSize
 C5 string PlayerGui
 C6 string FindFirstChild
 C7 string PlayerHUD
 C8 string GuiObject
 C9 string IsA
 C10 string Visible
 C11 string AbsoluteSize
 C12 string X
 C13 string AbsolutePosition
 C14 number 2
 C15 string ScreenGui
 C16 string IgnoreGuiInset
 C17 string GetGuiInset
 C18 string kotoran
 C19 string kotak
 C20 string Vector2
 C21 string new
 C23 number 70
 C24 string Y
 U1 userdata Players.Raelity911
 U2 TABLE table: 0x58d86e07a61ea5fc
  [uang] string CashFrame
  [gold] string EmasFrame
  [kunci] string KunciFrame
 U3 userdata GuiService

[FUNCTION] TARGET VOCAB CANDIDATE 34 source==ReplicatedStorage.NKSystem.Controller.GachaController name=bukaBlindBox line=nil
 C1 string mulai
 C2 string pcall
 C4 string [GachaController] BlindBox.mulai gagal:
 C5 string ipairs
 C7 string pilih
 C8 string [GachaController] BlindBox.pilih gagal:
 C9 string buka
 C10 string [GachaController] BlindBox.buka gagal:
 C11 string selesai
 U1 TABLE table: 0xdd930693d76de099
  [mulai] FUNCTION
  [aktif] FUNCTION
  [selesai] FUNCTION
  [buka] FUNCTION
  [pilih] FUNCTION
 U2 FUNCTION function: 0xec33f8b51c2368b8

[FUNCTION] TARGET VOCAB CANDIDATE 34.U2 source==ReplicatedStorage.NKSystem.Controller.GachaController name= line=nil
 U3 FUNCTION function: 0x4b4107dbfd19704a

[FUNCTION] TARGET VOCAB CANDIDATE 34.U3 source==ReplicatedStorage.NKSystem.Controller.GachaController name=showReveal line=nil
 C1 string PlayerGui
 C2 string WaitForChild
 C3 string GachaRevealGui
 C4 string FindFirstChild
 C5 string rarityColor
 C6 string rarity
 C7 string type
 C8 string none
 C9 string icon
 C10 string 
 C11 string Holder
 C12 string Pop
 C13 string Rays
 C14 string ItemIcon
 C15 number 0.4
 C16 string Scale
 C17 string Rotation
 C18 string Color3
 C19 string fromRGB
 C21 string ImageColor3
 C22 number 0.5
 C23 number 0.12
 C24 string ImageTransparency
 C25 string Image
 C26 string Nama
 C27 string ?
 C28 string name
 C29 string Text
 C30 string Color
 C31 string TextMuted
 C32 string TextColor3
 C33 string Enabled
 C34 string money
 C35 string + Rp 
 C36 number 0
 C37 string amount
 C38 string tostring
 C40 string keys
 C41 string + 
 C42 string formatMoney
 C43 string tonumber
 C45 string math
 C46 string floor
 C48 string  Kunci Emas
 C49 string tool
 C50 string masuk ke ranselmu
 C51 string domba
 C52 string masuk ke kandang
 C53 string coba lagi ya
 C54 string Sub
 C55 string TweenInfo
 C56 string new
 C58 number 0.45
 C59 string Enum
 C60 string EasingStyle
 C61 string Back
 C63 string EasingDirection
 C64 string Out
 C66 number 1
 C68 string Create
 C69 string Play
 C70 string Linear
 C72 string InOut
 C75 number 360
 C77 string pcall
 C79 string task
 C80 string delay
 C82 number 2.8
 C83 string wait
 C85 number 0.1
 U1 userdata Players.Raelity911
 U2 TABLE table: 0x44b3be69b1065740
 U3 TABLE table: 0xceb1377140a7e40c
 U4 userdata TweenService
 U5 userdata ReplicatedStorage

[FUNCTION] TARGET VOCAB CANDIDATE 35 source==ReplicatedStorage.NKSystem.Controller.GachaController name=mulaiEtalase line=nil
 C1 string Panel
 C2 string FindFirstChild
 C3 string Etalase
 C4 string Kotak3D
 C5 string Kotak
 C6 string Rays
 C7 string Spesial
 C8 string Foto
 C9 string Sapu3D
 C10 string Sapu
 C11 string ipairs
 C13 string CurrentCamera
 C14 string Camera
 C15 string FindFirstChildOfClass
 C16 number 1
 C17 string task
 C18 string spawn
 U1 number 4
 U2 userdata Run Service

[FUNCTION] TARGET VOCAB CANDIDATE 36 source==ReplicatedStorage.NKSystem.Controller.RedeemController name=KnitStart line=nil
 C1 string GetService
 C2 string RedeemService
 C3 string PlayerGui
 C4 string WaitForChild
 C5 string RedeemUI
 C6 string [Redeem] RedeemUI tidak ada di PlayerGui
 C7 string Panel
 C8 string Isi
 C9 string KotakKode
 C10 string Input
 C11 string Info
 C12 string Hasil
 C13 string _Chip
 C14 string Visible
 C15 string Tukar
 C16 string Top
 C17 string Close
 C18 string Text
 C19 string GetPropertyChangedSignal
 C20 string Connect
 C21 string FocusLost
 C23 string Activated
 C24 string PromptTriggered
 U1 TABLE table: 0x20b0c880b1dbdbf0
  [Tukar] FUNCTION
  [KodeBerubah] TABLE
  [AturKode] FUNCTION
  [BuatKode] FUNCTION
  [DaftarKode] FUNCTION
 U2 TABLE table: 0xda0f166d4ec11a3a
 U3 userdata Players.Raelity911
 U4 FUNCTION function: 0x9774ced7232d3d00

[FUNCTION] TARGET VOCAB CANDIDATE 36.U4 source==ReplicatedStorage.NKSystem.Controller.RedeemController name= line=nil
 U5 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel
 U6 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.KotakKode.Input
 U7 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.Info
 U8 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.Hasil
 U9 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.Hasil._Chip
 U10 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Tukar
 U11 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Top.Close
 U12 TABLE table: 0x0111f1fa624bdf74
  [KODE_MAKS] number 20
  [MAKS_KODE] number 150
  [FormatWaktu] FUNCTION
  [HADIAH] TABLE
  [TOPIK] string NK_RedeemKode_v1
  [Rp] FUNCTION
  [STORE_PEMAIN] string NKRedeemPemain_v1
  [SisaWaktu] FUNCTION
  [REFRESH] number 90
  [KODE_MIN] number 3
  [MAKS_PEMAKAI] number 1000000
  [RingkasHadiah] FUNCTION
  [TeksHadiah] FUNCTION
  [STORE_KODE] string NKRedeemKode_v1
  [PETA_HITUNG] string NKRedeemHitung_v1
  [Normalisasi] FUNCTION
  [ZONA_JAM] number 7
  [IKON_KADO] string rbxassetid://91160706455744
  [SATUAN] TABLE
  [HadiahById] TABLE
  [PROMPT] TABLE
  [Angka] FUNCTION
  [MAKS_DURASI_HARI] number 365
 U13 FUNCTION function: 0x5afc8c8486d84d91

[FUNCTION] TARGET VOCAB CANDIDATE 36.U13 source==ReplicatedStorage.NKSystem.Controller.RedeemController name=tukar line=nil
 C1 string Normalisasi
 C2 string Text
 C3 string 
 C4 string Kode tidak valid.
 C5 string TextColor3
 C6 string setButton
 C7 string Disabled
 C8 string Memeriksa kode...
 C9 string Tukar
 C10 string andThen
 C11 string catch
 C12 string finally
 U1 boolean false
 U2 TABLE table: 0x20b0c880b1dbdbf0
 U3 TABLE table: 0x0111f1fa624bdf74
 U4 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.KotakKode.Input
 U5 userdata 0.658824, 0.219608, 0.164706
 U6 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Isi.Info
 U7 userdata 0.478431, 0.290196, 0.133333
 U8 TABLE table: 0xceb1377140a7e40c
 U9 userdata Players.Raelity911.PlayerGui.RedeemUI.Panel.Tukar
 U10 FUNCTION function: 0xcdca3b59373e86f9
 U11 userdata 0.0666667, 0.501961, 0.435294
 U12 FUNCTION function: 0x5aef2f423d4cf9a6
 U13 TABLE table: 0x922def0a5865bdc8
 U14 FUNCTION function: 0x9774ced7232d3d00
 U14 TABLE table: 0xceb1377140a7e40c
 U15 userdata ProximityPromptService

[FUNCTION] TARGET VOCAB CANDIDATE 37 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string Panel
 C2 string Struk
 C3 string KartuSetor
 C4 string KartuProgres
 C5 string KartuHadiah
 C6 string Konfirmasi
 C7 string Riwayat
 C8 string uang
 C9 string pilih
 C10 string setor
 C11 string mode
 C12 number 1
 C13 string lihat
 C14 string type
 C16 string table
 C17 string jumlah
 C18 string KotakJumlah
 C19 string Jumlah
 C20 string 
 C21 string Text
 C22 string struk
 C23 string riwayat
 U1 userdata Players.Raelity911.PlayerGui.SetorAsetUI
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel
 U3 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Struk
 U4 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U5 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuProgres
 U6 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuHadiah
 U7 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Konfirmasi
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.Riwayat
 U9 string uang
 U10 string setor
 U11 number 1
 U12 TABLE table: 0x04027be883d7d448
 U13 FUNCTION function: 0xde5ac185e0315c2c
 U14 FUNCTION function: 0x3254f0c70dc4d97b
 U15 FUNCTION function: 0xd853cd43ac375f3a
 U16 FUNCTION function: 0x73d566cadc2eee54
 U17 boolean false
 U18 FUNCTION function: 0x22b58e8f699498a6
 U19 FUNCTION function: 0x83fccf58b2a7a08d

[FUNCTION] TARGET VOCAB CANDIDATE 37.U19 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name=isiStruk line=nil
 C1 string LocalPlayer
 C2 string cariAset
 C3 string k
 C4 string Aset
 C5 string Kertas
 C6 string j
 C7 string tarik
 C8 string Foto
 C9 string rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150
 C10 string UserId
 C11 string format
 C12 string Image
 C13 string Nama
 C14 string DisplayName
 C15 string Text
 C16 string Username
 C17 string @
 C18 string Name
 C19 string IdNasabah
 C20 string ID Nasabah 
 C21 string JenisPill
 C22 string BackgroundColor3
 C23 string Teks
 C24 string BUKTI SETOR TABUNGAN
 C25 string BUKTI TARIK TABUNGAN
 C26 string t
 C27 string os
 C28 string date
 C30 string !*t
 C31 string time
 C33 number 3600
 C34 string ZonaJam
 C35 string Rincian
 C36 string No
 C37 string Nilai
 C38 string -
 C39 string no
 C40 string Tanggal
 C41 string %d %s %d
 C42 string day
 C43 string month
 C44 string year
 C45 string Jam
 C46 string %02d:%02d:%02d WIB
 C47 string hour
 C48 string min
 C49 string sec
 C50 string Jenis
 C51 string Setor Tabungan
 C52 string Tarik Tabungan
 C53 string nama
 C54 string Jumlah
 C55 string + 
 C56 string - 
 C57 number 0
 C58 string n
 C59 string rupiah
 C60 string Rp 
 C61 string  
 C62 string key
 C63 string kunci
 C64 string Kunci
 C65 string TextColor3
 C66 string Sisa
 C67 string %s / %s
 C68 string sesudah
 C69 number 1000000000
 C70 string %.
 C71 string f
 C72 string %.?0+$
 C73 string 
 C74 string gsub
 C75 string ,
 C76 string  M
 C77 number 1000000
 C78 string  jt
 C79 string target
 C80 string Progres
 C81 string persen
 C82 number 10
 C83 string math
 C84 string floor
 C86 string %
 C87 string Tahap
 C88 string tahap
 C89 string Belum ada
 C90 string Stempel
 C91 string %02d.%02d.%d
 C92 string Status
 C93 string SETORAN SAH
 C94 string PENARIKAN SAH
 U1 userdata Players
 U2 TABLE table: 0x59dabc891f89831a
 U3 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Struk
 U4 userdata 0.180392, 0.619608, 0.356863
 U5 userdata 0.780392, 0.478431, 0.0705882
 U6 TABLE table: 0xaf69739db9242ad6
 U7 FUNCTION function: 0x22b58e8f699498a6
 U8 userdata 0.752941, 0.223529, 0.168627
 U20 FUNCTION function: 0x988d0e9fa402fd49

[FUNCTION] TARGET VOCAB CANDIDATE 38 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=efekCollect line=nil
 C1 string workspace
 C3 string CurrentCamera
 C4 string WARNA
 C5 string Color3
 C6 string new
 C8 number 2
 C9 string ViewportSize
 C10 string typeof
 C12 string Vector3
 C13 string WorldToViewportPoint
 C14 string Vector2
 C16 string X
 C17 string Y
 C18 number 0.5
 C19 number 0.35
 C20 string math
 C21 string floor
 C23 string max
 C25 string Instance
 C27 string Frame
 C28 string AnchorPoint
 C29 string UDim2
 C30 string fromOffset
 C32 string Size
 C33 string Rotation
 C34 number 0
 C35 string BackgroundColor3
 C36 string BorderSizePixel
 C37 string Position
 C38 string ZIndex
 C39 string Parent
 C40 number 3.141592653589793
 C41 number 10
 C42 number -0.3
 C43 number 0.6
 C44 string random
 C46 number 50
 C47 string TweenInfo
 C49 string Enum
 C50 string EasingStyle
 C51 string Quad
 C53 string BackgroundTransparency
 C54 number 1
 C55 number 225
 C57 string cos
 C59 string sin
 C61 string Create
 C62 string Play
 C63 number 0.55
 C64 string AddItem
 C65 string TextLabel
 C66 number 30
 C67 string Font
 C69 string rbxassetid://16658221428
 C70 string FontWeight
 C71 string Heavy
 C73 string FontFace
 C74 string TextSize
 C75 string TextColor3
 C76 string uang
 C77 string +Rp 
 C78 string tostring
 C80 string reverse
 C81 string (%d%d%d)
 C82 string %1.
 C83 string gsub
 C84 string ^%.
 C85 string 
 C86 string +
 C87 string  
 C88 string NAMA
 C89 string Text
 C90 string UIStroke
 C91 string fromRGB
 C93 string Color
 C94 number 2.5
 C95 string Thickness
 C96 string UIScale
 C97 number 0.4
 C98 string Scale
 C99 number 0.3
 C100 string Back
 C103 number 1.1
 C105 number 110
 C106 string task
 C107 string delay
 C109 number 0.7
 C110 number 1.2
 C111 string ImageLabel
 C112 string IKON
 C113 string Image
 C114 string ScaleType
 C115 string Fit
 C117 string kunci
 C118 string kotoran
 C119 string kotak
 C120 string gold
 C122 string tunda
 C123 number 0.25
 C124 string dur
 C125 number 0.65
 C126 string ease
 C127 string rot
 C129 number 0.05
 C130 number 0.45
 C132 number 0.15
 C134 string Bounce
 C136 number 0.2
 C137 number -25
 C139 number 360
 C141 number 0.1
 C144 string SFX
 C145 string ting_
 C146 string PITCH_TING
 U1 userdata Players.Raelity911.PlayerGui.AdminAbuseUI.FX
 U2 TABLE table: 0x2b5af13d063ba45f
 U3 FUNCTION function: 0x124dd5839753a03d
 U4 FUNCTION function: 0x1786efe0aa2b9525

[FUNCTION] TARGET VOCAB CANDIDATE 38.U4 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=ringLayar line=nil
 C1 string Instance
 C2 string new
 C4 string Frame
 C5 string Vector2
 C7 number 0.5
 C8 string AnchorPoint
 C9 string UDim2
 C10 string fromOffset
 C12 string X
 C13 string Y
 C14 string Position
 C15 string Size
 C16 string BackgroundTransparency
 C17 string ZIndex
 C18 string Parent
 C19 string UICorner
 C20 string UDim
 C22 string CornerRadius
 C23 string UIStroke
 C24 string Color
 C25 string Thickness
 C26 string TweenInfo
 C28 number 0.45
 C29 string Enum
 C30 string EasingStyle
 C31 string Quad
 C34 string Create
 C35 string Play
 C36 string Transparency
 C37 number 1
 C39 string AddItem
 U1 userdata Players.Raelity911.PlayerGui.AdminAbuseUI.FX
 U2 userdata TweenService
 U3 userdata Debris
 U5 boolean false
 U6 number 0.6
 U7 userdata TweenService
 U8 userdata Debris
 U9 FUNCTION function: 0x3359a24cde522329

[FUNCTION] TARGET VOCAB CANDIDATE 38.U9 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=suara line=nil
 C1 string type
 C3 string string
 C4 string 
 C5 string Instance
 C6 string new
 C8 string Sound
 C9 string SoundId
 C10 number 0.6
 C11 string Volume
 C12 number 1
 C13 string PlaybackSpeed
 C14 string Looped
 C15 string Parent
 C16 string Play
 C17 string Ended
 C18 string Once
 C19 string AddItem
 U1 userdata SoundService
 U2 userdata Debris

[FUNCTION] TARGET VOCAB CANDIDATE 39 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string cariAset
 C3 string setor
 C4 string key
 C5 string saldo
 C6 string target
 C7 string tersimpan
 C8 string math
 C9 string min
 C11 string max
 C13 number 1
 C14 string Bagian
 C15 string GetAttribute
 C16 string floor
 C18 string KotakJumlah
 C19 string Jumlah
 C20 string 
 C21 string Text
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor.Cepat4
 U3 TABLE table: 0x59dabc891f89831a
 U4 string uang
 U5 string setor
 U6 TABLE table: 0x04027be883d7d448
 U7 FUNCTION function: 0x5032c419ec99de9c
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U9 boolean false
 U10 FUNCTION function: 0x22b58e8f699498a6
 U11 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 40 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string cariAset
 C3 string setor
 C4 string key
 C5 string saldo
 C6 string target
 C7 string tersimpan
 C8 string math
 C9 string min
 C11 string max
 C13 number 1
 C14 string Bagian
 C15 string GetAttribute
 C16 string floor
 C18 string KotakJumlah
 C19 string Jumlah
 C20 string 
 C21 string Text
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor.Cepat3
 U3 TABLE table: 0x59dabc891f89831a
 U4 string uang
 U5 string setor
 U6 TABLE table: 0x04027be883d7d448
 U7 FUNCTION function: 0x5032c419ec99de9c
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U9 boolean false
 U10 FUNCTION function: 0x22b58e8f699498a6
 U11 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 41 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string cariAset
 C3 string setor
 C4 string key
 C5 string saldo
 C6 string target
 C7 string tersimpan
 C8 string math
 C9 string min
 C11 string max
 C13 number 1
 C14 string Bagian
 C15 string GetAttribute
 C16 string floor
 C18 string KotakJumlah
 C19 string Jumlah
 C20 string 
 C21 string Text
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor.Cepat2
 U3 TABLE table: 0x59dabc891f89831a
 U4 string uang
 U5 string setor
 U6 TABLE table: 0x04027be883d7d448
 U7 FUNCTION function: 0x5032c419ec99de9c
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U9 boolean false
 U10 FUNCTION function: 0x22b58e8f699498a6
 U11 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 42 source==ReplicatedStorage.NKSystem.Controller.SetorAsetController name= line=nil
 C1 string bounce
 C2 string cariAset
 C3 string setor
 C4 string key
 C5 string saldo
 C6 string target
 C7 string tersimpan
 C8 string math
 C9 string min
 C11 string max
 C13 number 1
 C14 string Bagian
 C15 string GetAttribute
 C16 string floor
 C18 string KotakJumlah
 C19 string Jumlah
 C20 string 
 C21 string Text
 U1 TABLE table: 0xceb1377140a7e40c
 U2 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor.Cepat1
 U3 TABLE table: 0x59dabc891f89831a
 U4 string uang
 U5 string setor
 U6 TABLE table: 0x04027be883d7d448
 U7 FUNCTION function: 0x5032c419ec99de9c
 U8 userdata Players.Raelity911.PlayerGui.SetorAsetUI.Panel.KartuSetor
 U9 boolean false
 U10 FUNCTION function: 0x22b58e8f699498a6
 U11 FUNCTION function: 0x3254f0c70dc4d97b

[FUNCTION] TARGET VOCAB CANDIDATE 43 source==ReplicatedStorage.NKSystem.Controller.GachaController name=doSpin line=nil
 C1 string GetState
 C2 string await
 C3 string type
 C5 string table
 C6 number 0
 C7 string free
 C8 string max
 C9 string MAX_FREE
 C10 string Spin
 C11 string ok
 C12 string granted
 C13 string [GachaController] Reward gagal dikasih server, coba spin lagi
 C14 string PlayerGui
 C15 string FindFirstChild
 C17 string pcall
 C19 string play
 C20 number 1
 C21 string math
 U1 boolean true
 U2 TABLE table: 0x376d7778956d36aa
  [ClaimReward] FUNCTION
  [Spin] FUNCTION
  [SpinX10WithFree] FUNCTION
  [SpinX10WithMoney] FUNCTION
  [GetState] FUNCTION
  [ClaimOneMultiReward] FUNCTION
  [GetInventory] FUNCTION
  [SpinWithMoney] FUNCTION
  [StateChanged] TABLE
  [ClaimMultiReward] FUNCTION
 U3 number 9
 U4 number 10
 U5 TABLE table: 0x44b3be69b1065740
 U6 FUNCTION function: 0xf5975fd744499ce2

[FUNCTION] TARGET VOCAB CANDIDATE 43.U6 source==ReplicatedStorage.NKSystem.Controller.GachaController name=updateFree line=nil
 C1 string PlayerGui
 C2 string WaitForChild
 C3 string GachaEntryGui
 C4 string FindFirstChild
 C5 string Panel
 C6 string FreeLabel
 C7 string StatusPelanggan
 C8 string string
 C9 string format
 C11 string Kotak gratis  %d/%d
 C12 number 0
 C13 string MAX_FREE
 C14 string Text
 C15 string Row1
 C16 string SpinButton
 C17 string Active
 C18 string AutoButtonColor
 C19 string Label
 C20 string SubLabel
 C21 string BUKA GRATIS
 C22 string GRATIS HABIS
 C23 string Pakai kotak gratis
 C24 string Kotak gratis habis
 C25 string setButton
 C26 string Primary
 C27 string Disabled
 C28 string PaidSpinButton
 C29 string Rp 
 C30 string formatMoney
 C31 string Row2
 C32 string X10FreeButton
 C33 string BUKA 10
 C34 string 10 kotak gratis
 C35 string Kotak gratis kurang
 C36 string X10PaidButton
 U1 userdata Players.Raelity911
 U2 TABLE table: 0x44b3be69b1065740
 U3 TABLE table: 0xceb1377140a7e40c
 U4 number 200000
 U5 number 2000000
 U7 FUNCTION function: 0xec33f8b51c2368b8
 U8 userdata Players.Raelity911
 U9 userdata ReplicatedStorage
 U10 FUNCTION function: 0x687534ef308f6a88

[FUNCTION] TARGET VOCAB CANDIDATE 43.U10 source==ReplicatedStorage.NKSystem.Controller.GachaController name=closeEntry line=nil
 C1 string PlayerGui
 C2 string WaitForChild
 C3 string GachaEntryGui
 C4 string FindFirstChild
 C5 number 1
 C6 string Panel
 C7 string Backdrop
 C8 string pop
 C9 string Enabled
 U1 userdata Players.Raelity911
 U2 number 4
 U3 TABLE table: 0xceb1377140a7e40c
 U11 FUNCTION function: 0xbe957f3d6aaf0723

[FUNCTION] TARGET VOCAB CANDIDATE 44 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=pilih line=nil
 C1 string gui
 C2 string Tombol
 C3 string WaitForChild
 C4 string ipairs
 C6 string GetChildren
 C7 string Destroy
 C8 string Judul
 C9 string BLIND BOX
 C10 string Hitung
 C11 number 1
 C12 string string
 C13 string format
 C15 string Kotak %d / %d
 C16 string 
 C17 string TouchEnabled
 C18 string Ketuk kotak, ketuk lagi untuk membuka
 C19 string Pilih kotak, klik untuk membuka
 C20 string Hint
 C21 string auto
 C22 string Auto buka aktif - tekan AUTO BUKA untuk berhenti
 C23 string Auto
 C24 string FindFirstChild
 C25 string Visible
 C26 string terbang
 C27 string rakPose
 C28 string poseDunia
 C29 number 0.9
 C30 string pairs
 C32 string kotak
 C33 string Instance
 C34 string new
 C36 string TextButton
 C37 string Kotak
 C38 string Name
 C39 string Text
 C40 string BackgroundTransparency
 C41 string Vector2
 C43 number 0.5
 C44 string AnchorPoint
 C45 string ZIndex
 C46 string Parent
 C47 string MouseEnter
 C48 string Connect
 C49 string Activated
 C50 string os
 C51 string clock
 C53 string CFrame
 C55 number 0.12
 C56 number 1.7
 C57 string math
 C58 string sin
 C60 string Angles
 C62 number 0.025
 C63 number 0.012
 C64 number 1.25
 C65 number 0.35
 C66 string table
 C67 string insert
 C69 string random
 C71 number 0.55
 C72 string cahaya
 C73 number 0.78
 C74 number 0.08
 C75 number 6
 C76 string GetDescendants
 C77 string BasePart
 C78 string IsA
 C79 string Transparency
 C80 string GetPivot
 C83 string Position
 C84 string abs
 C86 string vpf
 C87 string AbsoluteSize
 C88 string UDim2
 C89 string fromScale
 C91 number 0.75
 C92 string Y
 C93 string X
 C94 string max
 C96 number 1.05
 C97 string Size
 C98 string RenderStepped
 C99 string Wait
 C100 string dipilih
 U1 TABLE table: 0x2c5d2d8e6c52a35c
 U2 FUNCTION function: 0x9f239beb757a1f48
 U3 userdata UserInputService
 U4 FUNCTION function: 0x3ac30e390561d133
 U5 FUNCTION function: 0xb6f3986e76f1d044

[FUNCTION] TARGET VOCAB CANDIDATE 44.U5 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=poseTengah line=nil
 C1 string cam
 C2 number 2
 C3 string FieldOfView
 C4 string math
 C5 string rad
 C7 string tan
 C9 string vpf
 C10 string AbsoluteSize
 C11 string X
 C12 string Y
 C13 number 1
 C14 string max
 C16 string rak
 C17 string GetBoundingBox
 C18 number 0.45
 C19 number 0.7
 C20 string CFrame
 C21 string new
 C23 number 0.36
 C24 string Angles
 C26 number 3.141592653589793
 C27 number -0.4886921905584123
 U1 TABLE table: 0x2c5d2d8e6c52a35c
 U6 FUNCTION function: 0x9d93c548fb7fd12b

[FUNCTION] TARGET VOCAB CANDIDATE 44.U6 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=easeInOut line=nil
 C1 number 0.5
 C2 number 3
 C3 number 1
 C4 number 2
 U7 FUNCTION function: 0xc4393ce1671aba2c
 U8 FUNCTION function: 0x5662f5c6e173a0fe
 U9 userdata TweenService
 U10 FUNCTION function: 0x81703489983a03f2
 U11 userdata Run Service

[FUNCTION] TARGET VOCAB CANDIDATE 45 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=mulai line=nil
 C1 string PlayerGui
 C2 string WaitForChild
 C3 string BlindBoxLayar
 C4 string FindFirstChild
 C5 string BlindBox
 C6 string Rak
 C7 string Kotak
 C8 string Dunia
 C9 string ipairs
 C11 string GetChildren
 C12 string Model
 C13 string IsA
 C14 string Camera
 C15 string BasePart
 C16 string Destroy
 C17 string workspace
 C19 string CurrentCamera
 C20 string gui
 C21 string vpf
 C22 string kotak
 C23 string relSlot
 C24 string angkat
 C25 string cahaya
 C26 string kosong
 C28 string tipe
 C29 string cf
 C31 string CameraType
 C32 string CFrame
 C33 string camLama
 C34 string Enum
 C35 string Scriptable
 C37 string pcall
 C39 string Instance
 C40 string new
 C42 string FieldOfView
 C43 string Parent
 C44 string cam
 C45 string Clone
 C46 string rak
 C47 string GetDescendants
 C48 string Attachment
 C49 string string
 C50 string match
 C52 string Name
 C53 string ^Slot(%d+)$
 C54 string tonumber
 C57 string PivotTo
 C58 string pairs
 C60 string WorldCFrame
 C61 string NumberValue
 C62 string BlindBox_Display
 C63 string display
 C64 string GetPivot
 C65 string poseDunia
 C66 string BlindBoxBlur
 C67 string BlurEffect
 C68 string Size
 C69 string blur
 C70 number 14
 C72 string TweenInfo
 C74 number 0.5
 C75 string EasingStyle
 C76 string Quad
 C78 string EasingDirection
 C79 string Out
 C81 string Create
 C82 string Play
 C83 string Gelap
 C84 string BackgroundTransparency
 C86 string Judul
 C87 string Hitung
 C88 string Hint
 C89 string Nama
 C90 string Sub
 C91 string TextTransparency
 C92 string UIStroke
 C93 string FindFirstChildOfClass
 C94 string Transparency
 C95 string Rays
 C96 string ImageTransparency
 C97 string Ikon
 C98 string Tutup
 C99 string Visible
 C100 string auto
 C101 string Auto
 C102 string Label
 C103 string AUTO BUKA: MATI
 C104 string Text
 C105 string Color3
 C106 string fromRGB
 C108 string BackgroundColor3
 C109 string Activated
 C110 string Connect
 C111 string sambungAuto
 C112 string Enabled
 U1 TABLE table: 0x2c5d2d8e6c52a35c
 U2 userdata Players.Raelity911
 U3 userdata ReplicatedStorage
 U4 FUNCTION function: 0xb6f3986e76f1d044
 U5 FUNCTION function: 0x5662f5c6e173a0fe
 U6 FUNCTION function: 0xbf58698842e8d42a

[FUNCTION] TARGET VOCAB CANDIDATE 45.U6 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=setSembunyi line=nil
 C1 string ipairs
 C3 string GetDescendants
 C4 string BasePart
 C5 string IsA
 C6 string LocalTransparencyModifier
 U7 userdata Lighting
 U8 userdata TweenService
 U9 FUNCTION function: 0x6a3e6cc06ef88601

[FUNCTION] TARGET VOCAB CANDIDATE 45.U9 source==ReplicatedStorage.NKSystem.Util.BlindBoxTampil name=setAuto line=nil
 C1 string Auto
 C2 string FindFirstChild
 C3 string Label
 C4 string AUTO BUKA: NYALA
 C5 string AUTO BUKA: MATI
 C6 string Text
 C7 string Color3
 C8 string fromRGB
 C10 string BackgroundColor3
 U10 FUNCTION function: 0x3ac30e390561d133

[FUNCTION] TARGET VOCAB CANDIDATE 46 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=buatDrop line=nil
 C1 number 0
 C2 string typeof
 C4 string Vector3
 C5 string workspace
 C7 string GetServerTimeNow
 C8 string LAMA_TERBANG
 C9 string Shape
 C10 string Size
 C12 string Color
 C13 string Transparency
 C14 number 1
 C15 string CFrame
 C17 string Enum
 C18 string PartType
 C19 string Ball
 C21 string WARNA
 C22 string Color3
 C23 string new
 C26 string Instance
 C28 string BillboardGui
 C29 string UDim2
 C31 number 4.5
 C32 string LightInfluence
 C33 string MaxDistance
 C34 string Enabled
 C35 string Parent
 C36 string Frame
 C37 string fromScale
 C39 number 0.9
 C40 number 0.5
 C41 string Position
 C42 string Vector2
 C44 string AnchorPoint
 C45 string BackgroundColor3
 C46 number 0.55
 C47 string BackgroundTransparency
 C48 string UICorner
 C49 string UDim
 C51 string CornerRadius
 C52 string ImageLabel
 C53 number 0.8
 C54 string 
 C55 string IKON
 C56 string Image
 C57 string ScaleType
 C58 string Fit
 C60 string Attachment
 C63 string Trail
 C64 string Attachment0
 C65 string Attachment1
 C66 string ColorSequence
 C68 string NumberSequence
 C70 number 0.2
 C71 number 0.35
 C72 string Lifetime
 C73 string LightEmission
 C74 number 2
 C75 number 0.25
 C76 string Magnitude
 C78 string j
 C79 string n
 C80 string p
 C81 string t1
 C82 string t2
 C83 string a
 C84 string c
 C85 string part
 C86 string bb
 C87 string landed
 C88 boolean false
 C89 string pending
 C91 string kotak
 C92 string NKSystem
 C93 string Assets
 C94 string KotakMisteri
 C95 string FindFirstChild
 C96 string Clone
 C97 string pcall
 C99 string ipairs
 C101 string GetDescendants
 C102 string BasePart
 C103 string IsA
 C104 string Anchored
 C105 string CanCollide
 C106 string CanQuery
 C107 string CanTouch
 C108 string PivotTo
 C109 string PrimaryPart
 C110 string PointLight
 C111 string Range
 C112 number 1.2
 C113 string Brightness
 C114 string m
 C115 number 3.141592653589793
 C116 string math
 C117 string random
 C119 string rot
 U1 TABLE table: 0x3951c58e0a8fd8a1
 U2 TABLE table: 0x2b5af13d063ba45f
 U3 FUNCTION function: 0xf5fc8d8da8d26329

[FUNCTION] TARGET VOCAB CANDIDATE 46.U3 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=part line=nil
 C1 string Instance
 C2 string new
 C4 string Part
 C5 string Anchored
 C6 string CanCollide
 C7 string CanQuery
 C8 string CanTouch
 C9 string CastShadow
 C10 string Enum
 C11 string Material
 C12 string Neon
 C14 string SurfaceType
 C15 string Smooth
 C17 string TopSurface
 C18 string BottomSurface
 C19 string pairs
 C21 string Parent
 U1 userdata Workspace.AdminAbuseFX_Lokal
 U4 FUNCTION function: 0x536751ebf4148ec4

[FUNCTION] TARGET VOCAB CANDIDATE 46.U4 source==ReplicatedStorage.NKSystem.Controller.AdminAbuseController name=posisiTangan line=nil
 C1 string RightHand
 C2 string FindFirstChild
 C3 string Right Arm
 C4 string Position
 C5 string cf
 C6 string typeof
 C8 string CFrame
 C9 string new
 C11 string TITIK_CADANGAN
 C12 number 0.7
 C13 string TINGGI_AVATAR
 C14 string Vector3
 U3 TABLE table: 0x2b5af13d063ba45f
 U2 TABLE table: 0xb62345c4bc20a6b2
 U5 boolean false
 U6 userdata ReplicatedStorage

[FUNCTION] TARGET VOCAB CANDIDATE 47 source==ReplicatedStorage.NKSystem.Controller.HarianController name=renderEntri line=nil
 C1 string Isi
 C2 string Komunitas
 C3 string Aksi
 C4 string komunitas
 C5 string Owned
 C6 string Primary
 C7 string SELESAI
 C8 string JOIN
 C9 string setButton
 C10 string Teks
 C11 string FindFirstChild
 C12 string Text
 C13 string Favorit
 C14 string favorit
 C15 string FAVORIT
 C16 string Like
 C17 string Kotak
 C18 string like
 C19 string BackgroundColor3
 C20 string Centang
 C21 string Visible
 C22 string Ket
 C23 string Terima kasih sudah like map ini!
 C24 string likeKlik
 C25 string Sip! Centang aktif saat kamu masuk map lagi
 C26 string Keluar map, tekan 👍 di halaman game, lalu centang
 C27 string Open
 C28 string terbuka
 C29 string Disabled
 C30 string OPEN
 C31 string Top
 C32 string Subjudul
 C33 string Semua langkah selesai, buka hadiahmu!
 C34 string Selesaikan 3 langkah untuk membuka hadiah (%d/3)
 C35 string format
 U1 userdata Players.Raelity911.PlayerGui.HarianUI.Entri
 U2 TABLE table: 0x4c37f77b696ad5c9
 U3 TABLE table: 0xceb1377140a7e40c
 U4 userdata 0.180392, 0.619608, 0.356863
 U5 userdata 1, 0.968627, 0.905882

[FUNCTION] TARGET VOCAB CANDIDATE 48 source==ReplicatedStorage.NKSystem.Controller.ShopController name=isiSyarat line=nil
 C1 string Parent
 C2 string ipairs
 C4 string KeyPriceInline
 C5 string TenantFillBarContainer
 C6 string FindFirstChild
 C7 string Destroy
 C8 string SyaratKotak
 C9 string SyaratBaris
 C10 number 0
 C11 string RightPanel
 C12 string Position
 C13 string Y
 C14 string Scale
 C15 string Size
 C16 number 1
 C17 number 0.19
 C18 number 0.06
 C19 string Clone
 C20 string Visible
 C21 string UDim2
 C22 string fromScale
 C24 number 2
 C25 string math
 C26 string max
 C28 string ZIndex
 C29 string Syarat
 C30 string Name
 C31 string LayoutOrder
 C32 string emoji
 C33 string Ikon
 C34 string IkonTeks
 C35 string Text
 C36 string warna
 C37 string TextColor3
 C38 string ikon
 C39 string Image
 C40 string Teks
 C41 string teks
 C42 string AbsoluteSize
 C43 string GetPropertyChangedSignal
 C44 string Connect
 U1 userdata Players.Raelity911.PlayerGui.UiGame.Frame.Templates
 U2 FUNCTION function: 0xd263de3eecd33b4b

[FUNCTION] TARGET VOCAB CANDIDATE 48.U2 source==ReplicatedStorage.NKSystem.Controller.ShopController name=samakanTeksSyarat line=nil
 C1 string ipairs
 C3 string GetChildren
 C4 string Teks
 C5 string FindFirstChild
 C6 string UITextSizeConstraint
 C7 string FindFirstChildOfClass
 C8 string MaksAsli
 C9 string GetAttribute
 C10 string MaxTextSize
 C11 string SetAttribute
 C12 string table
 C13 string insert
 C15 string TextBounds
 C16 string Y
 C17 string math
 C18 string floor
 C20 string min
VOCAB CANDIDATES 48

=== 6. RELEVANT REMOTE INVENTORY ===
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.AddFromGudang
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetOwnedItems
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetTenantCount
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetServerTimeOfDay
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.SellFromGudang
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.UpgradeBuilding
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.MarkTutorialSeen
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.CabutItem
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetSellPrice
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.HammerHit
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetGudangData
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.PlaceItem
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.SellBuilding
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.MoveBuilding
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GiftFromGudang
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetTutorialSeen
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.MarkNewShopItemsSeen
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.PlaceBuilding
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BangunKosanService.RF.GetSeenNewShopItems
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyService.RF.GetPlayerData
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyService.RF.UnlockLevel
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyService.RE.MoneyChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyService.RE.ShopUpdated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LevelService.RE.LevelChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LevelService.RE.LeveledUp
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LevelService.RF.GetLevelData
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.PenyewaService.RE.TenantLeft
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.PenyewaService.RE.TenantArrived
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.PenyewaService.RF.VerifyReject
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.PenyewaService.RF.RespondWithVerify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.PenyewaService.RF.Respond
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KosanStateService.RE.PlayPickupAnim
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KosanStateService.RE.CleanProgress
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KosanStateService.RF.GetPetaZona
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ZoneService.RF.GetMyZoneIndex
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.ZoneService.RE.ZoneAssigned
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.FireWorker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.RequestJob
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetWorkers
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetMyStatus
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.SetAccess
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.QuitJob
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.SetGaji
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetHistory
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetWorkerHistory
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.JawabTawaran
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetGaji
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.AcceptWorker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.IsWorker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetMyBoss
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetBosses
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.RejectWorker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RF.GetRequests
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RE.Updated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RE.Tawaran
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KaryawanService.RE.Gaji
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.SetOwnTitle
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.SetStreamerTitle
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.RemoveStreamerTitle
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.ReportDevice
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.AmIAdmin
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.GiftTitle
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RF.GetPlayerList
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.OverheadService.RE.Updated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RE.Updated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RE.Notify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RF.GetCatalog
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RF.PromptGift
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RF.PromptBuy
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GamepassService.RF.GetPlayerList
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.PlayerStatService.RF.GetPlayTime
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ReportService.RF.GetReasons
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ReportService.RF.Submit
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GiftItem
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.SetPass
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GiftMoney
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.TeleportBuildingsToZone
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.SetWaktu
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.CekPass
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetTenantData
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetKnownPlayers
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.SetWaktuGlobal
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetPlayers
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetPlayerGold
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.BanByUsername
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GiftGold
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetPlayerMoney
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.SetItemLimit
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.Ban
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.Teleport
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.Unban
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetPlayerMoneyOffline
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.AddTenantData
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetAnnouncementLog
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetMyZoneIndex
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GetCatalogItems
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GiftKeys
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.Kick
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.AmIAdmin
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.SetItemPrice
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.GiftMoneyAll
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminService.RF.CleanAllHouses
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RobuxTransferService.RF.GetLimits
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RobuxTransferService.RF.Send
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyTransferService.RF.GetLimits
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyTransferService.RF.Send
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MoneyTransferService.RE.Notify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.SwitchRoleService.RF.SwitchRole
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.SwitchRoleService.RF.GetRole
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.SwitchRoleService.RE.RoleChanged
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TransferService.RF.Transfer
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.ReturnHomeService.RE.Mulai
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ReturnHomeService.RF.Pergi
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ReturnHomeService.RF.Minta
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.TogglePause
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.SambungSpeaker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.HasSpeaker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.Play
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.CariSpeaker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.PlayCustom
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.Next
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.GetState
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.PutusSpeaker
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.Stop
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.KontrolTablet
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.PutarTablet
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RF.SetVolume
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RE.VolumeChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RE.StateChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.BoomboxService.RE.TabletPutus
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LayanganService.RE.LayanganEquipped
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LayanganService.RE.UlurStart
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LayanganService.RE.UlurStop
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LayanganService.RE.LayanganUnequipped
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ServerHopService.RF.NewServer
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ServerHopService.RF.QuickZone
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ServerHopService.RF.GetList
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ServerHopService.RF.Join
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.ServerHopService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.WatersprayService.RE.Notify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ConvertService.RF.Klaim
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ConvertService.RF.Masukkan
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RongsokanService.RF.Ambil
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.FollowPetShopService.RF.Buy
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RF.InputKode
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RF.BeliToken
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RF.GetAllStates
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RF.GetMyData
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RF.ToggleSwitch
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RE.OpenTokenInputUI
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RE.ListrikStateChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TokenListrikService.RE.OpenListrikSwitchUI
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RE.Badge
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RE.Updated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RE.Notify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.Broadcast
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.GetInfoSebar
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.GetLokers
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.GetBadge
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.MarkRead
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LokerService.RF.TeleportToOwner
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GlobalRankService.RF.GetTopRanks
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.GlobalRankService.RE.RanksUpdated
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.CatTembokService.RF.CatRumah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.CatTembokService.RF.GetCatPrice
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimReward
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.Spin
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithFree
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinX10WithMoney
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetState
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimOneMultiReward
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.GetInventory
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.SpinWithMoney
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RF.ClaimMultiReward
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.GachaService.RE.StateChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaRideService.RE.RideStopped
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaRideService.RE.RideStarted
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaGiftService.RE.Notify
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaGiftService.RF.GetPlayerList
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaGiftService.RF.GiftDomba
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.DombaGiftService.RF.GetMyDomba
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MutasiService.RF.GetHistory
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TaxService.RF.HitungPajak
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TaxService.RF.BayarPajak
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TaxService.RF.GetRiwayat
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TaxService.RF.GetSaldo
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RE.Updated
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RE.OpenMachine
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RF.StartWash
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RF.GetMachineState
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RF.GetDebugLog
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LaundryService.RF.DepositClothes
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RefreshService.RF.DoRefresh
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.PriceOverrideService.RE.Updated
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.PriceOverrideService.RF.GetAll
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.LimitOverrideService.RE.Updated
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.LimitOverrideService.RF.GetAll
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MisiService.RE.Updated
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MisiService.RF.Claim
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MisiService.RF.GetMisi
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MisiService.RF.IsUnlocked
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.HargaRobux
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.BeliGold
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.DaftarPemain
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.Spawn
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.Hadiahkan
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.Info
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.BeliRobux
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RF.UpgradeTangki
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RE.Notify
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RE.Berubah
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RE.Tersedot
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RE.MulaiMengemudi
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TraktorService.RE.SelesaiMengemudi
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RE.Updated
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.ClaimReward
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.GetDeadline
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.OwnerCompleteMission
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.ClaimBroomService.RF.GetState
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KeyService.RE.KeysChanged
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KeyService.RF.GetKeys
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AnnouncementService.RE.Show
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AnnouncementService.RF.Send
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AnnouncementService.RF.CanSend
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.UpgradeGundukan
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.Panen
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.SetAuto
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.Siram
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.Tanam
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RF.BeliBibit
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TanamService.RE.Dipanen
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.IsiPakan
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.BeliDomba
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.Saldo
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.AmbilKotoran
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.GendongDomba
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RF.TaruhDomba
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TernakService.RE.KotoranDiambil
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Cancel
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Accept
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Unconfirm
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.SetOffer
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Confirm
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Decline
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.GetInventory
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.Request
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RF.CancelRequest
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TradeService.RE.Event
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RF.LaporFavorit
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RF.Klaim
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RF.CekKomunitas
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RF.KlikLike
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RF.GetStatus
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.HarianService.RE.StatusBerubah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RF.AmbilLog
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RF.GetState
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RF.AdminAksi
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RF.AdminInfo
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RF.Klaim
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RE.Log
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RE.Fase
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RE.Dapat
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RE.Hilang
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminAbuseService.RE.Lempar
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.BursaGoldService.RE.KursBerubah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.BursaGoldService.RF.GetPasar
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminLacakService.RF.KickJarakJauh
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminLacakService.RF.Cari
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminLacakService.RF.TeleportKe
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AdminLacakService.RF.AmbilLog
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Buka
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RF.Jumlah
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.KotakService.RE.JumlahBerubah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RF.GetRiwayat
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RF.Tarik
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RF.Setor
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RF.GetStatus
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RE.NaikTahap
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.TabunganIDKService.RE.StatusBerubah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RedeemService.RF.Tukar
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RedeemService.RF.DaftarKode
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RedeemService.RF.AturKode
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.RedeemService.RF.BuatKode
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.RedeemService.RE.KodeBerubah
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.AlatService.RF.Beli
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Ambil
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.StokJual
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Beli
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Riwayat
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Tarik
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Info
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Lapakku
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Detail
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Pasang
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RF.Jelajah
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Packages.Knit.Services.MarketService.RE.Kabar
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.BeliTokenListrik
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.InputTokenListrik
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.GetTokenListrikData
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.SetListrikSwitch
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.ListrikStateChanged
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.OpenTokenInputUI
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.OpenListrikSwitchUI
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.PetEquip
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.BeliKendaraan
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.VehicleEquip
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.VehicleUnequip
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.OpenVehicleShop
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.BuyVehicle
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.GetOwnedVehicles
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.BroomEquip
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.BroomUnequip
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.SetLikedMap
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.GetLikedMap
[REMOTE] RemoteFunction ReplicatedStorage.NKSystem.Remotes.GetSaleState
[REMOTE] RemoteEvent ReplicatedStorage.NKSystem.Remotes.SaleUpdate
NKSystem remotes listed 320

=== 7. END / LIMITATIONS ===
No function was executed. No remote was invoked. No hook was installed.
A caller may not retain the target as an upvalue; absence of direct refs is not proof of no caller.
