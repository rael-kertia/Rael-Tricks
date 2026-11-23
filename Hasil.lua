CONTROLLER SOURCE V6
local v1, v2 = pcall(function()
	return require(game:GetService("ReplicatedStorage"):WaitForChild("NKSystem", 10):WaitForChild("Util", 10):WaitForChild("NKDebug", 10))
end)
local _ = v1 and (v2.PRINT and print)
local v_u_3 = v1 and (v2.WARN and warn) or function() end
local v_u_4 = game:GetService("Players")
local v_u_5 = game:GetService("ReplicatedStorage")
local v_u_6 = game:GetService("RunService")
local v_u_7 = game:GetService("TweenService")
local v_u_8 = game:GetService("UserInputService")
local v_u_9 = game:GetService("Workspace")
local v_u_10 = game:GetService("StarterGui")
local v_u_11 = require(v_u_5.NKSystem.Packages.Knit)
local v_u_12 = require(v_u_5.NKSystem.Util.JamAjaibConfig)
local v_u_13 = v_u_4.LocalPlayer
local v14 = v_u_11.CreateController({
	["Name"] = "JamAjaibController"
})
local v_u_15 = nil
local v_u_16 = Color3.fromHex("#1FB3A1")
local v_u_17 = Color3.fromHex("#11806F")
local v_u_18 = Color3.fromHex("#C0392B")
local v_u_19 = Color3.fromRGB(150, 228, 255)
local v_u_20 = Color3.fromRGB(255, 214, 120)
local function v_u_24(p21, p22) -- name: suara
	if p21 and (p21.id and (p21.id ~= "" and p22)) then
		local v_u_23 = Instance.new("Sound")
		v_u_23.SoundId = p21.id
		v_u_23.Volume = p21.vol or 0.6
		v_u_23.PlaybackSpeed = p21.speed or 1
		v_u_23.RollOffMinDistance = 12
		v_u_23.RollOffMaxDistance = 220
		v_u_23.Parent = p22
		v_u_23:Play()
		v_u_23.Ended:Once(function()
			-- upvalues: (copy) v_u_23
			v_u_23:Destroy()
		end)
		task.delay(8, function()
			-- upvalues: (copy) v_u_23
			if v_u_23.Parent then
				v_u_23:Destroy()
			end
		end)
		return v_u_23
	end
end
local function v_u_33(p25, p26) -- name: kaliNS
	local v27 = {}
	for _, v28 in ipairs(p25.Keypoints) do
		local v29 = NumberSequenceKeypoint.new
		local v30 = v28.Time
		local v31 = v28.Value * p26
		local v32 = v28.Envelope * p26
		table.insert(v27, v29(v30, v31, v32))
	end
	return NumberSequence.new(v27)
end
local function v_u_36(p34) -- name: rumahDari
	-- upvalues: (copy) v_u_9
	local v35 = v_u_9:FindFirstChild("KosanSpawned")
	if v35 and p34 then
		while p34 and (p34.Parent and p34.Parent ~= v35) do
			p34 = p34.Parent
		end
		if p34 and (p34.Parent == v35 and p34:IsA("Model")) then
			return p34
		else
			return nil
		end
	else
		return nil
	end
end
local function v_u_40(p37) -- name: jumlahSewa
	local v38 = p37:GetAttribute("KosanState") == "Disewa" and 1 or 0
	for _, v39 in ipairs(p37:GetChildren()) do
		if not v39:IsA("Model") or v39:GetAttribute("KosanState") ~= "Disewa" then
			continue
		end
		v38 = v38 + 1
	end
	return v38
end
local function v_u_59(p41, p42) -- name: jarakKeRumah
	local v43, v44 = p42:GetBoundingBox()
	local v45 = v43:PointToObjectSpace(p41)
	local v46 = v44 / 2
	local v47 = v45.X
	local v48 = -v46.X
	local v49 = v46.X
	local v50 = math.clamp(v47, v48, v49)
	local v51 = v45.Y
	local v52 = -v46.Y
	local v53 = v46.Y
	local v54 = math.clamp(v51, v52, v53)
	local v55 = v45.Z
	local v56 = -v46.Z
	local v57 = v46.Z
	local v58 = math.clamp(v55, v56, v57)
	return (v45 - Vector3.new(v50, v54, v58)).Magnitude
end
local function v_u_65(p60) -- name: nilaiRumah
	-- upvalues: (copy) v_u_13, (copy) v_u_40, (copy) v_u_59, (copy) v_u_12
	if not p60 then
		return false
	end
	if p60:GetAttribute("OwnerUserId") ~= v_u_13.UserId then
		return false, "BUKAN RUMAHMU", "Jam Ajaib cuma untuk rumah sendiri"
	end
	local v61 = v_u_40(p60)
	if v61 == 0 then
		return false, "BELUM ADA PENYEWA", "Tunggu penyewa masuk dulu"
	end
	local v62 = v_u_13.Character
	if v62 then
		v62 = v62:FindFirstChild("HumanoidRootPart")
	end
	if v62 and v_u_59(v62.Position, p60) > v_u_12.JARAK_MAKS then
		return false, "TERLALU JAUH", "Dekati rumahnya dulu"
	end
	local v63 = v_u_12.POTONG * 100 + 0.5
	local v64 = math.floor(v63)
	return true, "TEMBAK JAM AJAIB", v61 > 1 and ("%d kamar, sisa sewa -%d%%"):format(v61, v64) or ("Sisa sewa dipotong %d%%"):format(v64)
end
local v_u_66 = v_u_13:GetMouse()
local v_u_67 = RaycastParams.new()
v_u_67.FilterType = Enum.RaycastFilterType.Exclude
local function v_u_76() -- name: bidik
	-- upvalues: (copy) v_u_66, (copy) v_u_9, (copy) v_u_13, (copy) v_u_67, (copy) v_u_36, (copy) v_u_40
	local v68 = v_u_66.UnitRay
	local v69 = {}
	local v70 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
	if not v70 then
		v70 = Instance.new("Folder")
		v70.Name = "JamAjaib_EfekLokal"
		v70.Parent = v_u_9
	end
	__set_list(v69, 1, {v70})
	if v_u_13.Character then
		local v71 = v_u_13.Character
		table.insert(v69, v71)
	end
	for _ = 1, 8 do
		v_u_67.FilterDescendantsInstances = v69
		local v72 = v_u_9:Raycast(v68.Origin, v68.Direction * 1500, v_u_67)
		if not v72 then
			return nil
		end
		local v73 = v_u_36(v72.Instance)
		if v73 then
			local v74
			if v73 == nil or v73:GetAttribute("OwnerUserId") ~= v_u_13.UserId then
				v74 = false
			else
				v74 = v_u_40(v73) > 0
			end
			if v74 then
				return v73
			end
			table.insert(v69, v73)
		else
			if v72.Instance.Transparency < 0.95 then
				return nil
			end
			local v75 = v72.Instance
			table.insert(v69, v75)
		end
	end
	return nil
end
local v_u_77 = nil
local v_u_78 = nil
local v_u_79 = nil
local v_u_80 = nil
local v_u_81 = nil
local v_u_82 = false
local function v_u_87() -- name: perbaruiStok
	-- upvalues: (copy) v_u_13, (ref) v_u_77
	local v83 = v_u_13:FindFirstChildOfClass("PlayerGui")
	if v83 then
		v83 = v83:FindFirstChild("JamAjaibUI")
	end
	local v84 = v83 and v83:FindFirstChild("Petunjuk")
	if v84 then
		v84 = v83.Petunjuk:FindFirstChild("Stok")
	end
	if v84 and v84:FindFirstChild("Teks") then
		local v85 = v84.Teks
		local v86 = v_u_77 and v_u_77:GetAttribute("Count") or 1
		v85.Text = "x" .. tostring(v86)
	end
end
local function v_u_101(p88, p89, p90, p91) -- name: setLabelBidik
	-- upvalues: (copy) v_u_13, (ref) v_u_80, (copy) v_u_9, (copy) v_u_16, (copy) v_u_18, (copy) v_u_17
	local v92 = v_u_13:FindFirstChildOfClass("PlayerGui")
	if v92 then
		v92 = v92:FindFirstChild("JamAjaibBidik")
	end
	if v92 then
		if p88 then
			local v93, v94 = p88:GetBoundingBox()
			if not (v_u_80 and v_u_80.Parent) then
				local v95 = v93.Position
				local v96 = Instance.new("Part")
				v96.Name = "JamAjaib_JangkarBidik"
				v96.Size = Vector3.new(0.2, 0.2, 0.2)
				v96.Transparency = 1
				v96.Anchored = true
				v96.CanCollide = false
				v96.CanQuery = false
				v96.CanTouch = false
				v96.CastShadow = false
				v96.CFrame = CFrame.new(v95)
				local v97 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
				if not v97 then
					v97 = Instance.new("Folder")
					v97.Name = "JamAjaib_EfekLokal"
					v97.Parent = v_u_9
				end
				v96.Parent = v97
				v_u_80 = v96
			end
			v_u_80.CFrame = CFrame.new((v93 * CFrame.new(0, v94.Y / 2, 0)).Position)
			v92.Adornee = v_u_80
			v92.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
			local v98 = p89 and v_u_16 or v_u_18
			local v99 = v92:FindFirstChild("Kartu")
			if v99 then
				if v99:FindFirstChild("Garis") then
					v99.Garis.Color = v98
				end
				if v99:FindFirstChild("Judul") then
					v99.Judul.Text = p90 or ""
					v99.Judul.TextColor3 = p89 and v_u_17 or v_u_18
				end
				if v99:FindFirstChild("Sub") then
					v99.Sub.Text = p91 or ""
				end
			end
			local v100 = v92:FindFirstChild("Ekor")
			if v100 and v100:FindFirstChild("Garis") then
				v100.Garis.Color = v98
			end
			v92.Enabled = true
		else
			v92.Enabled = false
		end
	else
		return
	end
end
local function v_u_106(p102, p103) -- name: setSorot
	-- upvalues: (ref) v_u_79, (copy) v_u_9, (copy) v_u_19
	if p102 then
		if not (v_u_79 and v_u_79.Parent) then
			v_u_79 = Instance.new("Highlight")
			v_u_79.Name = "JamAjaib_Sorot"
			v_u_79.DepthMode = Enum.HighlightDepthMode.Occluded
			local v104 = v_u_79
			local v105 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
			if not v105 then
				v105 = Instance.new("Folder")
				v105.Name = "JamAjaib_EfekLokal"
				v105.Parent = v_u_9
			end
			v104.Parent = v105
		end
		v_u_79.Adornee = p102
		v_u_79.FillColor = p103 and v_u_19 or Color3.fromRGB(255, 120, 110)
		v_u_79.OutlineColor = p103 and Color3.fromRGB(200, 245, 255) or Color3.fromRGB(255, 150, 140)
		v_u_79.FillTransparency = p103 and 0.8 or 0.9
		v_u_79.OutlineTransparency = 0
		v_u_79.Enabled = true
	elseif v_u_79 then
		v_u_79.Adornee = nil
		v_u_79.Enabled = false
	end
end
local v_u_107 = 0
local function v_u_128(p108) -- name: langkahBidik
	-- upvalues: (ref) v_u_107, (ref) v_u_77, (copy) v_u_13, (copy) v_u_76, (ref) v_u_81, (ref) v_u_79, (ref) v_u_82, (copy) v_u_8, (copy) v_u_65, (copy) v_u_106, (copy) v_u_101, (copy) v_u_12, (copy) v_u_17, (copy) v_u_18
	v_u_107 = v_u_107 - p108
	if v_u_107 > 0 then
		return
	else
		v_u_107 = 0.08
		if v_u_77 and v_u_77.Parent == v_u_13.Character then
			local v109 = v_u_76()
			if v109 then
				v_u_81 = v109
				local v110, v111, v112 = v_u_65(v109)
				v_u_106(v109, v110)
				v_u_101(v109, v110, v111, v112)
				if not v_u_82 then
					if v110 then
						local v113 = v_u_8.TouchEnabled
						if v113 then
							v113 = not v_u_8.MouseEnabled
						end
						local v114 = v_u_12.POTONG * 100 + 0.5
						local v115 = (v113 and "Ketuk" or "Klik") .. " untuk menembak: sisa sewa dipotong " .. math.floor(v114) .. "%"
						local v116 = v_u_17
						local v117 = v_u_13:FindFirstChildOfClass("PlayerGui")
						if v117 then
							v117 = v117:FindFirstChild("JamAjaibUI")
						end
						local v118 = v117 and v117:FindFirstChild("Petunjuk")
						if v118 then
							v118 = v117.Petunjuk:FindFirstChild("Teks")
						end
						if v118 then
							v118.Text = v115
							v118.TextColor3 = v116 or Color3.fromHex("#4A2511")
							return
						end
					else
						if not v112 then
							local v119 = v_u_8.TouchEnabled
							if v119 then
								v119 = not v_u_8.MouseEnabled
							end
							v112 = v119 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
						end
						local v120 = v_u_18
						local v121 = v_u_13:FindFirstChildOfClass("PlayerGui")
						if v121 then
							v121 = v121:FindFirstChild("JamAjaibUI")
						end
						local v122 = v121 and v121:FindFirstChild("Petunjuk")
						if v122 then
							v122 = v121.Petunjuk:FindFirstChild("Teks")
						end
						if v122 then
							v122.Text = v112
							v122.TextColor3 = v120 or Color3.fromHex("#4A2511")
						end
					end
				end
			else
				if v_u_81 then
					v_u_81 = nil
					if v_u_79 then
						v_u_79.Adornee = nil
						v_u_79.Enabled = false
					end
					local v123 = v_u_13:FindFirstChildOfClass("PlayerGui")
					if v123 then
						v123 = v123:FindFirstChild("JamAjaibBidik")
					end
					if v123 then
						v123.Enabled = false
					end
				end
				if not v_u_82 then
					local v124 = v_u_8.TouchEnabled
					if v124 then
						v124 = not v_u_8.MouseEnabled
					end
					local v125 = v124 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
					local v126 = v_u_13:FindFirstChildOfClass("PlayerGui")
					if v126 then
						v126 = v126:FindFirstChild("JamAjaibUI")
					end
					local v127 = v126 and v126:FindFirstChild("Petunjuk")
					if v127 then
						v127 = v126.Petunjuk:FindFirstChild("Teks")
					end
					if v127 then
						v127.Text = v125
						v127.TextColor3 = Color3.fromHex("#4A2511")
					end
				end
			end
		else
			return
		end
	end
end
local function v_u_134(p129) -- name: hadapkan
	-- upvalues: (copy) v_u_13
	local v130 = v_u_13.Character
	if v130 then
		v130 = v130:FindFirstChild("HumanoidRootPart")
	end
	if v130 then
		local v131 = p129.X - v130.Position.X
		local v132 = p129.Z - v130.Position.Z
		local v133 = Vector3.new(v131, 0, v132)
		if v133.Magnitude >= 0.5 then
			v130.CFrame = CFrame.lookAt(v130.Position, v130.Position + v133)
		end
	else
		return
	end
end
local function v_u_155() -- name: tembak
	-- upvalues: (ref) v_u_82, (ref) v_u_77, (copy) v_u_76, (ref) v_u_81, (copy) v_u_8, (copy) v_u_18, (copy) v_u_13, (copy) v_u_65, (copy) v_u_134, (copy) v_u_17, (ref) v_u_15, (copy) v_u_12
	if v_u_82 or not v_u_77 then
		return
	else
		local v135 = v_u_76() or v_u_81
		if v135 then
			local v136, _, v137 = v_u_65(v135)
			if v136 then
				v_u_82 = true
				v_u_134(v135:GetBoundingBox().Position)
				local v138 = v_u_17
				local v139 = v_u_13:FindFirstChildOfClass("PlayerGui")
				if v139 then
					v139 = v139:FindFirstChild("JamAjaibUI")
				end
				local v140 = v139 and v139:FindFirstChild("Petunjuk")
				if v140 then
					v140 = v139.Petunjuk:FindFirstChild("Teks")
				end
				if v140 then
					v140.Text = "Jam Ajaib bekerja..."
					v140.TextColor3 = v138 or Color3.fromHex("#4A2511")
				end
				v_u_15:Tembak(v135):andThen(function(p141)
					-- upvalues: (ref) v_u_82, (ref) v_u_8, (ref) v_u_13, (ref) v_u_12
					if p141 and p141.ok then
						task.delay(v_u_12.WAKTU_MUATAN + v_u_12.WAKTU_TERBANG + v_u_12.JEDA_HABIS + 0.1, function()
							-- upvalues: (ref) v_u_82
							v_u_82 = false
						end)
					else
						v_u_82 = false
						local v142 = v_u_8.TouchEnabled
						if v142 then
							v142 = not v_u_8.MouseEnabled
						end
						local v143 = v142 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
						local v144 = v_u_13:FindFirstChildOfClass("PlayerGui")
						if v144 then
							v144 = v144:FindFirstChild("JamAjaibUI")
						end
						local v145 = v144 and v144:FindFirstChild("Petunjuk")
						if v145 then
							v145 = v144.Petunjuk:FindFirstChild("Teks")
						end
						if v145 then
							v145.Text = v143
							v145.TextColor3 = Color3.fromHex("#4A2511")
						end
					end
				end):catch(function()
					-- upvalues: (ref) v_u_82
					v_u_82 = false
				end)
			else
				if not v137 then
					local v146 = v_u_8.TouchEnabled
					if v146 then
						v146 = not v_u_8.MouseEnabled
					end
					v137 = v146 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
				end
				local v147 = v_u_18
				local v148 = v_u_13:FindFirstChildOfClass("PlayerGui")
				if v148 then
					v148 = v148:FindFirstChild("JamAjaibUI")
				end
				local v149 = v148 and v148:FindFirstChild("Petunjuk")
				if v149 then
					v149 = v148.Petunjuk:FindFirstChild("Teks")
				end
				if v149 then
					v149.Text = v137
					v149.TextColor3 = v147 or Color3.fromHex("#4A2511")
				end
			end
		else
			local v150 = v_u_8.TouchEnabled
			if v150 then
				v150 = not v_u_8.MouseEnabled
			end
			local v151 = v150 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
			local v152 = v_u_18
			local v153 = v_u_13:FindFirstChildOfClass("PlayerGui")
			if v153 then
				v153 = v153:FindFirstChild("JamAjaibUI")
			end
			local v154 = v153 and v153:FindFirstChild("Petunjuk")
			if v154 then
				v154 = v153.Petunjuk:FindFirstChild("Teks")
			end
			if v154 then
				v154.Text = v151
				v154.TextColor3 = v152 or Color3.fromHex("#4A2511")
			end
			return
		end
	end
end
local v_u_156 = {}
local function v_u_160() -- name: lepasJam
	-- upvalues: (copy) v_u_156, (ref) v_u_78, (ref) v_u_77, (ref) v_u_81, (ref) v_u_79, (copy) v_u_13
	for _, v157 in ipairs(v_u_156) do
		v157:Disconnect()
	end
	table.clear(v_u_156)
	if v_u_78 then
		v_u_78:Disconnect()
		v_u_78 = nil
	end
	v_u_77 = nil
	v_u_81 = nil
	if v_u_79 then
		v_u_79.Adornee = nil
		v_u_79.Enabled = false
	end
	local v158 = v_u_13:FindFirstChildOfClass("PlayerGui")
	if v158 then
		v158 = v158:FindFirstChild("JamAjaibBidik")
	end
	if v158 then
		v158.Enabled = false
	end
	local v159 = v_u_13:FindFirstChildOfClass("PlayerGui")
	if v159 then
		v159 = v159:FindFirstChild("JamAjaibUI")
	end
	if v159 then
		v159.Enabled = false
	end
end
local function v_u_174(p161) -- name: pegangJam
	-- upvalues: (ref) v_u_77, (copy) v_u_160, (copy) v_u_13, (copy) v_u_12, (copy) v_u_8, (copy) v_u_87, (copy) v_u_156, (copy) v_u_155, (ref) v_u_78, (copy) v_u_6, (copy) v_u_128
	if v_u_77 ~= p161 then
		v_u_160()
		v_u_77 = p161
		local v162 = v_u_13:FindFirstChildOfClass("PlayerGui")
		if v162 then
			v162 = v162:FindFirstChild("JamAjaibUI")
		end
		if v162 then
			local v163 = v162:FindFirstChild("Petunjuk")
			if v163 then
				v163 = v162.Petunjuk:FindFirstChild("Ikon")
			end
			if v163 then
				v163.Image = p161.TextureId ~= "" and p161.TextureId or v_u_12.IKON
				v163.Visible = v163.Image ~= ""
			end
			v162.Enabled = true
		end
		local v164 = v_u_8.TouchEnabled
		if v164 then
			v164 = not v_u_8.MouseEnabled
		end
		local v165 = v164 and "Ketuk rumahmu yang ada penyewanya" or "Arahkan ke rumahmu yang ada penyewanya, lalu klik"
		local v166 = v_u_13:FindFirstChildOfClass("PlayerGui")
		if v166 then
			v166 = v166:FindFirstChild("JamAjaibUI")
		end
		local v167 = v166 and v166:FindFirstChild("Petunjuk")
		if v167 then
			v167 = v166.Petunjuk:FindFirstChild("Teks")
		end
		if v167 then
			v167.Text = v165
			v167.TextColor3 = Color3.fromHex("#4A2511")
		end
		v_u_87()
		local v168 = v_u_156
		local v169 = p161.Activated
		local v170 = v_u_155
		table.insert(v168, v169:Connect(v170))
		local v171 = v_u_156
		local v172 = p161:GetAttributeChangedSignal("Count")
		local v173 = v_u_87
		table.insert(v171, v172:Connect(v173))
		v_u_78 = v_u_6.RenderStepped:Connect(v_u_128)
	end
end
local function v_u_180(p175) -- name: pantauKarakter
	-- upvalues: (copy) v_u_160, (copy) v_u_174, (ref) v_u_77
	v_u_160()
	local function v177(p176) -- name: cek
		-- upvalues: (ref) v_u_174
		if p176:IsA("Tool") and p176:GetAttribute("JamAjaib") then
			v_u_174(p176)
		end
	end
	for _, v178 in ipairs(p175:GetChildren()) do
		if not (v178:IsA("Tool") and v178:GetAttribute("JamAjaib")) then
			continue
		end
		v_u_174(v178)
	end
	p175.ChildAdded:Connect(v177)
	p175.ChildRemoved:Connect(function(p179)
		-- upvalues: (ref) v_u_77, (ref) v_u_160
		if p179 == v_u_77 then
			v_u_160()
		end
	end)
end
local v_u_181 = setmetatable({}, {
	["__mode"] = "k"
})
local v_u_182 = CFrame.new()
local v_u_183 = CFrame.new(0, 0.2, 0.35) * CFrame.Angles(0.4886921905584123, 0, 0)
local v_u_184 = CFrame.new(0, 0.15, -0.8) * CFrame.Angles(-0.7330382858376184, 0, 0)
local function v_u_195(p185, p186, p187, p188, p189) -- name: geserPose
	-- upvalues: (copy) v_u_7, (copy) v_u_181, (copy) v_u_6
	local v190 = os.clock()
	while p185.Parent do
		local v191 = (os.clock() - v190) / p188
		local v192 = math.clamp(v191, 0, 1)
		local v193 = p186:Lerp(p187, (v_u_7:GetValue(v192, p189 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)))
		local v194 = v_u_181[p185]
		if v194 and p185.Parent then
			p185.Grip = v194 * v193:Inverse()
		end
		if v192 >= 1 then
			break
		end
		v_u_6.RenderStepped:Wait()
	end
end
local function v_u_197(p_u_196) -- name: animasiJam
	-- upvalues: (copy) v_u_181, (copy) v_u_195, (copy) v_u_182, (copy) v_u_183, (copy) v_u_12, (copy) v_u_184
	if not v_u_181[p_u_196] then
		v_u_181[p_u_196] = p_u_196.Grip
		p_u_196.Unequipped:Connect(function()
			-- upvalues: (ref) v_u_181, (copy) p_u_196
			if v_u_181[p_u_196] then
				p_u_196.Grip = v_u_181[p_u_196]
			end
		end)
	end
	v_u_195(p_u_196, v_u_182, v_u_183, v_u_12.WAKTU_MUATAN, Enum.EasingStyle.Sine)
	v_u_195(p_u_196, v_u_183, v_u_184, 0.12, Enum.EasingStyle.Back)
	task.wait(v_u_12.WAKTU_TERBANG * 0.55)
	v_u_195(p_u_196, v_u_184, v_u_182, 0.45, Enum.EasingStyle.Sine)
	if p_u_196.Parent then
		p_u_196.Grip = v_u_181[p_u_196]
	end
end
local function v_u_217(p198, p199) -- name: titikPermukaan
	local v200 = p198.kotak
	if typeof(v200) == "CFrame" then
		local v201 = p198.ukuran
		if typeof(v201) == "Vector3" and typeof(p199) == "Vector3" then
			local v202 = p198.kotak:PointToObjectSpace(p198.titik)
			local v203 = p198.kotak:PointToObjectSpace(p199)
			local v204 = v203.X - v202.X
			local v205 = v203.Z - v202.Z
			local v206 = Vector3.new(v204, 0, v205)
			if v206.Magnitude < 0.1 then
				return p198.titik
			end
			local v207 = v206.Unit
			local v208 = p198.ukuran / 2
			local v209 = v207.X
			local v210
			if math.abs(v209) > 0.001 then
				local v211 = v208.X
				local v212 = v207.X
				v210 = v211 / math.abs(v212) or (1 / 0)
			else
				v210 = (1 / 0)
			end
			local v213 = v207.Z
			local v214
			if math.abs(v213) > 0.001 then
				local v215 = v208.Z
				local v216 = v207.Z
				v214 = v215 / math.abs(v216) or (1 / 0)
			else
				v214 = (1 / 0)
			end
			return p198.kotak:PointToWorldSpace(v202 + v207 * (math.min(v210, v214) + 1.5))
		end
	end
	return p198.titik
end
local function v_u_221(p_u_218, p219) -- name: padamkan
	for _, v220 in ipairs(p_u_218:GetDescendants()) do
		if v220:IsA("ParticleEmitter") then
			v220.Enabled = false
		else
			if not v220:IsA("PointLight") then
				continue
			end
			v220.Enabled = false
		end
	end
	if p_u_218:IsA("BasePart") then
		p_u_218.Transparency = 1
	end
	task.delay(p219 or 1.5, function()
		-- upvalues: (copy) p_u_218
		if p_u_218.Parent then
			p_u_218:Destroy()
		end
	end)
end
local v_u_222 = {
	["Cincin"] = 1.45,
	["Simbol"] = 1.55,
	["Gelombang"] = 1.4
}
local function v_u_298(p223, p224) -- name: ledakan
	-- upvalues: (copy) v_u_5, (copy) v_u_33, (copy) v_u_9, (copy) v_u_7, (copy) v_u_24, (copy) v_u_12, (copy) v_u_222, (copy) v_u_6, (copy) v_u_19
	local v225 = p223.lebar
	local v226 = tonumber(v225) or 30
	local v227 = math.clamp(v226, 10, 90)
	local v228 = v227 / 30
	local v229 = math.clamp(v228, 0.7, 2.2)
	local v230 = v_u_5:FindFirstChild("JamAjaibVFX")
	if v230 then
		v230 = v230:FindFirstChild("Ledakan")
	end
	if v230 then
		local v_u_231 = v230:Clone()
		v_u_231.CFrame = CFrame.new(p224 or p223.titik)
		for _, v232 in ipairs(v_u_231:GetDescendants()) do
			if not v232:IsA("ParticleEmitter") then
				continue
			end
			v232.Size = v_u_33(v232.Size, v229)
			if v232.Speed.Max <= 1 then
				continue
			end
			v232.Speed = NumberRange.new(v232.Speed.Min * math.sqrt(v229), v232.Speed.Max * math.sqrt(v229))
		end
		local v233 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
		if not v233 then
			v233 = Instance.new("Folder")
			v233.Name = "JamAjaib_EfekLokal"
			v233.Parent = v_u_9
		end
		v_u_231.Parent = v233
		local v234
		if v_u_231 then
			v234 = v_u_231:FindFirstChild("Kilat", true)
		else
			v234 = v_u_231
		end
		if v234 and v234:IsA("ParticleEmitter") then
			v234:Emit(2)
		end
		local v235
		if v_u_231 then
			v235 = v_u_231:FindFirstChild("Cincin", true)
		else
			v235 = v_u_231
		end
		if v235 and v235:IsA("ParticleEmitter") then
			v235:Emit(1)
		end
		local v236
		if v_u_231 then
			v236 = v_u_231:FindFirstChild("Gelombang", true)
		else
			v236 = v_u_231
		end
		if v236 and v236:IsA("ParticleEmitter") then
			v236:Emit(1)
		end
		local v237
		if v_u_231 then
			v237 = v_u_231:FindFirstChild("Sinar", true)
		else
			v237 = v_u_231
		end
		if v237 and v237:IsA("ParticleEmitter") then
			v237:Emit(1)
		end
		local v238
		if v_u_231 then
			v238 = v_u_231:FindFirstChild("Cahaya", true)
		else
			v238 = v_u_231
		end
		if v238 and v238:IsA("ParticleEmitter") then
			v238:Emit(1)
		end
		local v239
		if v_u_231 then
			v239 = v_u_231:FindFirstChild("Petir", true)
		else
			v239 = v_u_231
		end
		if v239 and v239:IsA("ParticleEmitter") then
			v239:Emit(3)
		end
		local v240
		if v_u_231 then
			v240 = v_u_231:FindFirstChild("Kelip", true)
		else
			v240 = v_u_231
		end
		if v240 and v240:IsA("ParticleEmitter") then
			v240:Emit(70)
		end
		local v241
		if v_u_231 then
			v241 = v_u_231:FindFirstChild("Debu", true)
		else
			v241 = v_u_231
		end
		if v241 and v241:IsA("ParticleEmitter") then
			v241:Emit(45)
		end
		local v242
		if v_u_231 then
			v242 = v_u_231:FindFirstChild("Gelembung", true)
		else
			v242 = v_u_231
		end
		if v242 and v242:IsA("ParticleEmitter") then
			v242:Emit(25)
		end
		local v243 = v_u_231:FindFirstChild("Lampu")
		if v243 then
			local v244 = v227 * 1.3
			v243.Range = math.clamp(v244, 24, 60)
			v243.Brightness = 6
			v_u_7:Create(v243, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				["Brightness"] = 0
			}):Play()
		end
		v_u_24(v_u_12.SUARA.KENA, v_u_231)
		v_u_24(v_u_12.SUARA.KENA2, v_u_231)
		task.delay(4, function()
			-- upvalues: (copy) v_u_231
			if v_u_231.Parent then
				v_u_231:Destroy()
			end
		end)
	end
	local v245 = v_u_5:FindFirstChild("JamAjaibVFX")
	if v245 then
		v245 = v245:FindFirstChild("Lingkaran")
	end
	if v245 and p223.alas then
		local v_u_246 = v245:Clone()
		local v247 = v227 * 1.12
		local v248 = v227 * 1.12
		v_u_246.Size = Vector3.new(v247, 0.2, v248)
		v_u_246.CFrame = CFrame.new(p223.alas + Vector3.new(0, 0.35, 0))
		local v249 = v227 / 10
		for _, v250 in ipairs(v_u_246.Alas:GetChildren()) do
			if not v250:IsA("ParticleEmitter") then
				continue
			end
			v250.Size = v_u_33(v250.Size, v249 * (v_u_222[v250.Name] or 1.1))
		end
		local v251 = p223.atas and (p223.atas.Y - p223.alas.Y or 20) or 20
		local v252 = math.max(6, v251)
		local v253 = v_u_246.PilarBawah
		local v254 = v252 * 0.8
		v253.Position = Vector3.new(0, v254, 0)
		local v255 = v_u_246.PilarAtas
		local v256 = v252 + 26
		v255.Position = Vector3.new(0, v256, 0)
		local v_u_257 = v_u_246.PilarBawah:FindFirstChild("Riak")
		if v_u_257 then
			local v258 = v_u_33
			local v259 = v_u_257.Size
			local v260 = v227 / 14
			v_u_257.Size = v258(v259, (math.clamp(v260, 0.8, 4)))
		end
		local v_u_261 = v_u_246:FindFirstChild("Pilar")
		local v_u_262 = v_u_246:FindFirstChild("PilarInti")
		if v_u_261 then
			local v263 = v227 * 0.45
			v_u_261.Width0 = math.clamp(v263, 7, 28)
			v_u_261.Width1 = v_u_261.Width0 * 0.25
		end
		if v_u_262 then
			local v264 = v227 * 0.12
			v_u_262.Width0 = math.clamp(v264, 2.5, 8)
			v_u_262.Width1 = v_u_262.Width0 * 0.2
		end
		local v265 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
		if not v265 then
			v265 = Instance.new("Folder")
			v265.Name = "JamAjaib_EfekLokal"
			v265.Parent = v_u_9
		end
		v_u_246.Parent = v265
		local v266
		if v_u_246 then
			v266 = v_u_246:FindFirstChild("Cincin", true)
		else
			v266 = v_u_246
		end
		if v266 and v266:IsA("ParticleEmitter") then
			v266:Emit(1)
		end
		local v267
		if v_u_246 then
			v267 = v_u_246:FindFirstChild("Simbol", true)
		else
			v267 = v_u_246
		end
		if v267 and v267:IsA("ParticleEmitter") then
			v267:Emit(1)
		end
		local v268
		if v_u_246 then
			v268 = v_u_246:FindFirstChild("Gelombang", true)
		else
			v268 = v_u_246
		end
		if v268 and v268:IsA("ParticleEmitter") then
			v268:Emit(1)
		end
		local v269 = v227 * 0.6 + 25
		local v270 = math.floor(v269)
		local v271
		if v_u_246 then
			v271 = v_u_246:FindFirstChild("Kabut", true)
		else
			v271 = v_u_246
		end
		if v271 and v271:IsA("ParticleEmitter") then
			v271:Emit(v270)
		end
		local v272 = v227 * 1.2 + 50
		local v273 = math.floor(v272)
		local v274
		if v_u_246 then
			v274 = v_u_246:FindFirstChild("KelipNaik", true)
		else
			v274 = v_u_246
		end
		if v274 and v274:IsA("ParticleEmitter") then
			v274:Emit(v273)
		end
		local v275 = v227 * 0.7 + 30
		local v276 = math.floor(v275)
		local v277
		if v_u_246 then
			v277 = v_u_246:FindFirstChild("DebuNaik", true)
		else
			v277 = v_u_246
		end
		if v277 and v277:IsA("ParticleEmitter") then
			v277:Emit(v276)
		end
		if v_u_257 then
			task.spawn(function()
				-- upvalues: (copy) v_u_257
				for _ = 1, 4 do
					if not v_u_257.Parent then
						break
					end
					v_u_257:Emit(1)
					task.wait(0.16)
				end
			end)
		end
		task.spawn(function()
			-- upvalues: (copy) v_u_246, (copy) v_u_261, (copy) v_u_262, (ref) v_u_6
			local v278 = os.clock()
			while v_u_246.Parent do
				local v279 = os.clock() - v278
				if v279 > 1.7 then
					break
				end
				local v280 = v279 < 0.15 and v279 / 0.15
				if not v280 then
					local v281 = 1 - (v279 - 0.15) / 1.5
					v280 = math.clamp(v281, 0, 1)
				end
				local v282 = 1 - v280 * 0.85
				if v_u_261 then
					local v283 = v_u_261
					local v284 = {}
					local v285 = NumberSequenceKeypoint.new(0, v282)
					local v286 = NumberSequenceKeypoint.new
					local v287 = v282 + 0.15
					__set_list(v284, 1, {v285, v286(0.7, (math.min(1, v287))), NumberSequenceKeypoint.new(1, 1)})
					v283.Transparency = NumberSequence.new(v284)
				end
				if v_u_262 then
					local v288 = v_u_262
					local v289 = {}
					local v290 = NumberSequenceKeypoint.new
					local v291 = v282 + 0.05
					local v292 = v290(0, (math.min(1, v291)))
					local v293 = NumberSequenceKeypoint.new
					local v294 = v282 + 0.3
					__set_list(v289, 1, {v292, v293(0.8, (math.min(1, v294))), NumberSequenceKeypoint.new(1, 1)})
					v288.Transparency = NumberSequence.new(v289)
				end
				v_u_6.RenderStepped:Wait()
			end
			if v_u_261 then
				v_u_261.Enabled = false
			end
			if v_u_262 then
				v_u_262.Enabled = false
			end
		end)
		task.delay(4, function()
			-- upvalues: (copy) v_u_246
			if v_u_246.Parent then
				v_u_246:Destroy()
			end
		end)
	end
	local v295 = p223.rumah
	if typeof(v295) == "Instance" and p223.rumah.Parent then
		local v_u_296 = Instance.new("Highlight")
		v_u_296.Name = "JamAjaib_Kilat"
		v_u_296.Adornee = p223.rumah
		v_u_296.DepthMode = Enum.HighlightDepthMode.Occluded
		v_u_296.FillColor = v_u_19
		v_u_296.OutlineColor = Color3.new(1, 1, 1)
		v_u_296.FillTransparency = 0.35
		v_u_296.OutlineTransparency = 0
		local v297 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
		if not v297 then
			v297 = Instance.new("Folder")
			v297.Name = "JamAjaib_EfekLokal"
			v297.Parent = v_u_9
		end
		v_u_296.Parent = v297
		v_u_7:Create(v_u_296, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["FillTransparency"] = 1,
			["OutlineTransparency"] = 1
		}):Play()
		task.delay(1.5, function()
			-- upvalues: (copy) v_u_296
			v_u_296:Destroy()
		end)
	end
end
local function v_u_320(p299) -- name: kartuMenit
	-- upvalues: (copy) v_u_13, (copy) v_u_10, (copy) v_u_9, (copy) v_u_12, (copy) v_u_19, (copy) v_u_7, (copy) v_u_20, (copy) v_u_6
	local v300 = p299.lantai
	if v300 then
		v300 = p299.lantai[1]
	end
	if not (v300 and p299.atas) then
		return
	end
	local v301 = v_u_13:FindFirstChildOfClass("PlayerGui")
	local v302
	if v301 then
		v302 = v301:FindFirstChild("JamAjaibPotong")
	else
		v302 = v301
	end
	local v303 = v302 or v_u_10:FindFirstChild("JamAjaibPotong")
	if not (v303 and v301) then
		return
	end
	local v304 = p299.atas + Vector3.new(0, 6, 0)
	local v305 = Instance.new("Part")
	v305.Name = "JamAjaib_JangkarKartu"
	v305.Size = Vector3.new(0.2, 0.2, 0.2)
	v305.Transparency = 1
	v305.Anchored = true
	v305.CanCollide = false
	v305.CanQuery = false
	v305.CanTouch = false
	v305.CastShadow = false
	v305.CFrame = CFrame.new(v304)
	local v306 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
	if not v306 then
		v306 = Instance.new("Folder")
		v306.Name = "JamAjaib_EfekLokal"
		v306.Parent = v_u_9
	end
	v305.Parent = v306
	local v307 = v303:Clone()
	v307.Name = "JamAjaibPotong_Aktif"
	v307.Adornee = v305
	v307.Enabled = true
	local v308 = v307.Isi
	local v_u_309 = v308.Kartu
	local v_u_310 = v308.Potong
	local v311 = p299.persen
	if not v311 then
		local v312 = v_u_12.POTONG * 100 + 0.5
		v311 = math.floor(v312)
	end
	v_u_309.Judul.Text = ("SEWA DIPERCEPAT %d%%"):format(v311)
	v_u_309.Lama.Text = v_u_12.FormatSisa(v300.lama)
	v_u_309.Baru.Text = v_u_12.FormatSisa(v300.lama)
	v_u_309.Baru.TextColor3 = v_u_19
	v_u_309.Lama.Coret.Size = UDim2.fromScale(0, 0.1)
	v_u_310.Teks.Text = "-" .. v_u_12.FormatPotong(v300.lama - v300.baru)
	if #p299.lantai > 1 then
		v_u_309.Penyewa.Text = ("%d kamar dipercepat sekaligus"):format(#p299.lantai)
	elseif v300.nama and v300.nama ~= "" then
		v_u_309.Penyewa.Text = "Penyewa: " .. v300.nama
	else
		v_u_309.Penyewa.Text = ""
	end
	v308.Skala.Scale = 0.3
	v_u_310.Skala.Scale = 0
	v307.Parent = v301
	v_u_7:Create(v308.Skala, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		["Scale"] = 1
	}):Play()
	task.delay(0.2, function()
		-- upvalues: (ref) v_u_7, (copy) v_u_310
		v_u_7:Create(v_u_310.Skala, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			["Scale"] = 1
		}):Play()
	end)
	task.delay(0.3, function()
		-- upvalues: (ref) v_u_7, (copy) v_u_309
		v_u_7:Create(v_u_309.Lama.Coret, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["Size"] = UDim2.fromScale(1, 0.1)
		}):Play()
	end)
	local v313 = v_u_309:FindFirstChild("Garis")
	if v313 then
		v313 = v_u_309.Garis:FindFirstChild("Kilau")
	end
	local v314 = os.clock()
	local v315 = false
	while v307.Parent do
		local v316 = os.clock() - v314
		if v_u_12.LAMA_KARTU <= v316 then
			break
		end
		if v313 then
			v313.Rotation = v316 * 160 % 360
		end
		if not v315 and v316 >= 0.35 then
			local v317 = (v316 - 0.35) / 1.4
			local v318 = math.clamp(v317, 0, 1)
			local v319 = v_u_7:GetValue(v318, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			v_u_309.Baru.Text = v_u_12.FormatSisa(v300.lama + (v300.baru - v300.lama) * v319)
			if v318 >= 1 then
				v_u_309.Baru.Text = v_u_12.FormatSisa(v300.baru)
				v_u_309.Baru.TextColor3 = v_u_20
				v_u_7:Create(v_u_309.Baru, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["TextColor3"] = Color3.new(1, 1, 1)
				}):Play()
				v_u_310.Skala.Scale = 1.18
				v_u_7:Create(v_u_310.Skala, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					["Scale"] = 1
				}):Play()
				v315 = true
			end
		end
		v_u_6.RenderStepped:Wait()
	end
	if v307.Parent then
		v_u_7:Create(v_u_310, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			["Position"] = UDim2.fromScale(0.5, -0.35)
		}):Play()
		v_u_7:Create(v_u_310.Skala, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			["Scale"] = 0
		}):Play()
		v_u_7:Create(v308.Skala, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			["Scale"] = 0
		}):Play()
		task.wait(0.5)
	end
	v307:Destroy()
	v305:Destroy()
end
local function v_u_382(p321) -- name: mainkanEfek
	-- upvalues: (copy) v_u_9, (copy) v_u_4, (copy) v_u_12, (copy) v_u_5, (copy) v_u_197, (copy) v_u_24, (copy) v_u_6, (copy) v_u_217, (copy) v_u_7, (copy) v_u_221, (copy) v_u_298, (copy) v_u_320
	if type(p321) == "table" then
		local v322 = p321.titik
		if typeof(v322) == "Vector3" then
			local v323 = v_u_9.CurrentCamera
			if not v323 then
				return
			end
			local v324 = v_u_4:GetPlayerByUserId(p321.uid)
			if v324 then
				v324 = v324.Character
			end
			local v325
			if v324 then
				v325 = v324:FindFirstChild(v_u_12.NAMA_TOOL)
			else
				v325 = v324
			end
			local v326
			if v325 then
				v326 = v325:FindFirstChild("Handle")
			else
				v326 = v325
			end
			local v327
			if v326 then
				v327 = v326:FindFirstChild("VFX_Inti")
			else
				v327 = v326
			end
			local v328 = v323.CFrame.Position
			local v329 = (v328 - p321.titik).Magnitude < 700
			local v330
			if v326 == nil then
				v330 = false
			else
				v330 = (v328 - v326.Position).Magnitude < 700
			end
			if not (v329 or v330) then
				return
			end
			local v331 = v_u_5:FindFirstChild("JamAjaibVFX")
			if v331 then
				v331 = v331:FindFirstChild("Peluru")
			end
			if v331 then
				v331 = v331:Clone()
			end
			local v332
			if v331 then
				v332 = v331.Size
			else
				v332 = v331
			end
			local v333 = {
				["Cahaya"] = true,
				["Kabut"] = true
			}
			if v331 then
				for _, v334 in ipairs(v331:GetChildren()) do
					if not v334:IsA("Trail") then
						continue
					end
					v334.Enabled = false
				end
				for _, v335 in ipairs(v331:GetDescendants()) do
					if not (v335:IsA("ParticleEmitter") and v333[v335.Name]) then
						continue
					end
					v335.Enabled = false
				end
				v331.Size = v332 * 0.1
				local v336 = CFrame.new
				local v337
				if v327 and v327.Parent then
					v337 = v327.WorldPosition
				else
					local v338
					if v324 then
						v338 = v324:FindFirstChild("HumanoidRootPart")
					else
						v338 = v324
					end
					if v338 then
						v337 = v338.Position + Vector3.new(0, 2.5, 0)
					else
						v337 = p321.titik + Vector3.new(0, 25, 0)
					end
				end
				v331.CFrame = v336(v337)
				local v339 = v_u_9:FindFirstChild("JamAjaib_EfekLokal")
				if not v339 then
					v339 = Instance.new("Folder")
					v339.Name = "JamAjaib_EfekLokal"
					v339.Parent = v_u_9
				end
				v331.Parent = v339
			end
			if v325 and v326 then
				task.spawn(v_u_197, v325)
				local v340
				if v326 then
					v340 = v326:FindFirstChild("Halo_Detak", true)
				else
					v340 = v326
				end
				if v340 and v340:IsA("ParticleEmitter") then
					v340:Emit(2)
				end
				local v341
				if v326 then
					v341 = v326:FindFirstChild("Halo_Cincin", true)
				else
					v341 = v326
				end
				if v341 and v341:IsA("ParticleEmitter") then
					v341:Emit(1)
				end
				local v342
				if v326 then
					v342 = v326:FindFirstChild("Inti_DetakKilat", true)
				else
					v342 = v326
				end
				if v342 and v342:IsA("ParticleEmitter") then
					v342:Emit(3)
				end
				local v343
				if v325 then
					v343 = v325:FindFirstChild("Kepala_Kelip", true)
				else
					v343 = v325
				end
				if v343 and v343:IsA("ParticleEmitter") then
					v343:Emit(12)
				end
				local v344
				if v325 then
					v344 = v325:FindFirstChild("Kepala_Gelembung", true)
				else
					v344 = v325
				end
				if v344 and v344:IsA("ParticleEmitter") then
					v344:Emit(8)
				end
			end
			v_u_24(v_u_12.SUARA.MUATAN, v326 or v331)
			local v345 = os.clock()
			while os.clock() - v345 < v_u_12.WAKTU_MUATAN do
				local v346 = (os.clock() - v345) / v_u_12.WAKTU_MUATAN
				if v331 then
					v331.Size = v332 * (0.1 + 0.9 * v346)
					local v347 = CFrame.new
					local v348
					if v327 and v327.Parent then
						v348 = v327.WorldPosition
					else
						local v349
						if v324 then
							v349 = v324:FindFirstChild("HumanoidRootPart")
						else
							v349 = v324
						end
						if v349 then
							v348 = v349.Position + Vector3.new(0, 2.5, 0)
						else
							v348 = p321.titik + Vector3.new(0, 25, 0)
						end
					end
					v331.CFrame = v347(v348)
				end
				v_u_6.RenderStepped:Wait()
			end
			if v325 and v326 then
				local v350
				if v326 then
					v350 = v326:FindFirstChild("Inti_DetakKilat", true)
				else
					v350 = v326
				end
				if v350 and v350:IsA("ParticleEmitter") then
					v350:Emit(4)
				end
				if v326 then
					v326 = v326:FindFirstChild("Halo_Detak", true)
				end
				if v326 and v326:IsA("ParticleEmitter") then
					v326:Emit(1)
				end
			end
			if v331 then
				v331.Size = v332
				for _, v351 in ipairs(v331:GetChildren()) do
					if not v351:IsA("Trail") then
						continue
					end
					v351.Enabled = true
				end
				for _, v352 in ipairs(v331:GetDescendants()) do
					if not (v352:IsA("ParticleEmitter") and v333[v352.Name]) then
						continue
					end
					v352.Enabled = true
				end
				v_u_24(v_u_12.SUARA.TEMBAK, v331)
				local v353
				if v327 and v327.Parent then
					v353 = v327.WorldPosition
				else
					local v354
					if v324 then
						v354 = v324:FindFirstChild("HumanoidRootPart")
					else
						v354 = v324
					end
					if v354 then
						v353 = v354.Position + Vector3.new(0, 2.5, 0)
					else
						v353 = p321.titik + Vector3.new(0, 25, 0)
					end
				end
				local v355 = v_u_217(p321, v353)
				p321._kena = v355
				local v356 = (v355 - v353).Magnitude
				local v357 = (v353 + v355) / 2
				local v358 = v356 * 0.22
				local v359 = math.clamp(v358, 4, 35)
				local v360 = v357 + Vector3.new(0, v359, 0)
				local v361 = {
					{ v331:FindFirstChild("SpiralEmas0"), v331:FindFirstChild("SpiralEmas1"), 0 },
					{ v331:FindFirstChild("SpiralBiru0"), v331:FindFirstChild("SpiralBiru1"), 3.141592653589793 }
				}
				local v362 = os.clock()
				local v363 = v353
				while v331.Parent do
					local v364 = (os.clock() - v362) / v_u_12.WAKTU_TERBANG
					local v365 = math.clamp(v364, 0, 1)
					local v366 = v_u_7:GetValue(v365, Enum.EasingStyle.Sine, Enum.EasingDirection.In) * 0.35 + v365 * 0.65
					local v367 = 1 - v366
					local v368 = v353 * v367 * v367 + v360 * 2 * v367 * v366 + v355 * v366 * v366
					local v369 = v368 - v363
					if v369.Magnitude < 0.001 then
						v369 = v355 - v353
					end
					v331.CFrame = CFrame.lookAt(v368, v368 + v369.Unit)
					local v370 = (os.clock() - v362) * 16
					for _, v371 in ipairs(v361) do
						if not (v371[1] and v371[2]) then
							continue
						end
						local v372 = (1 - v365 * 0.4) * 0.95
						local v373 = v370 + v371[3]
						local v374 = math.cos(v373)
						local v375 = v370 + v371[3]
						local v376 = math.sin(v375)
						local v377 = Vector3.new(v374, v376, 0)
						v371[1].Position = v377 * v372
						v371[2].Position = v377 * (v372 + 0.18)
					end
					if v365 >= 1 then
						break
					end
					v_u_6.RenderStepped:Wait()
					v363 = v368
				end
				v_u_221(v331, 1.2)
			else
				task.wait(v_u_12.WAKTU_TERBANG)
			end
			if v329 then
				local v378 = v_u_298
				local v379 = p321._kena
				if not v379 then
					local v380 = v_u_217
					local v381
					if v327 and v327.Parent then
						v381 = v327.WorldPosition
					else
						if v324 then
							v324 = v324:FindFirstChild("HumanoidRootPart")
						end
						if v324 then
							v381 = v324.Position + Vector3.new(0, 2.5, 0)
						else
							v381 = p321.titik + Vector3.new(0, 25, 0)
						end
					end
					v379 = v380(p321, v381)
				end
				v378(p321, v379)
				v_u_320(p321)
			end
			return
		end
	end
end
function v14.KnitStart(_) -- name: KnitStart
	-- upvalues: (ref) v_u_15, (copy) v_u_11, (copy) v_u_382, (copy) v_u_3, (copy) v_u_13, (copy) v_u_180
	v_u_15 = v_u_11.GetService("JamAjaibService")
	v_u_15.Efek:Connect(function(p_u_383)
		-- upvalues: (ref) v_u_382, (ref) v_u_3
		task.spawn(function()
			-- upvalues: (ref) v_u_382, (copy) p_u_383, (ref) v_u_3
			local v384 = v_u_382
			local v385 = p_u_383
			local v386, v387 = pcall(v384, v385)
			if not v386 then
				v_u_3("[JamAjaib] efek gagal:", v387)
			end
		end)
	end)
	if v_u_13.Character then
		v_u_180(v_u_13.Character)
	end
	v_u_13.CharacterAdded:Connect(v_u_180)
end
return v14
