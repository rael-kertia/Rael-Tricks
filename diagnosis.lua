-- RAEL SEWA V18 - OBSERVER RESPOND INVOKESERVER
-- Pasang pengamat. Tidak menekan tombol dan tidak memanggil remote sendiri.
local O={}
local function add(s) O[#O+1]=tostring(s) end
local function val(v,depth,seen)
 depth=depth or 0; seen=seen or {}
 local ty=typeof(v)
 if ty=="Instance" then return "Instance<"..v.ClassName.."> "..v:GetFullName() end
 if type(v)=="string" then return string.format("%q",v) end
 if type(v)=="number" or type(v)=="boolean" or v==nil then return tostring(v) end
 if type(v)=="table" then
  if seen[v] then return "<cycle>" end
  if depth>=3 then return "<table>" end
  seen[v]=true; local out={}
  local n=0
  for k,x in pairs(v) do n=n+1; if n>40 then out[#out+1]="..."; break end
   out[#out+1]="["..val(k,depth+1,seen).."]="..val(x,depth+1,seen)
  end
  seen[v]=nil; return "{"..table.concat(out,", ").."}"
 end
 return ty.." "..tostring(v)
end
local function save()
 local s="=== RAEL SEWA V18 CAPTURE ===\n"..table.concat(O,"\n")
 if setclipboard then pcall(setclipboard,s) elseif toclipboard then pcall(toclipboard,s) end
 if writefile then pcall(writefile,"Rael_Sewa_V18.txt",s) end
end
local rs=game:GetService("ReplicatedStorage")
local remote=rs:WaitForChild("NKSystem"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PenyewaService"):WaitForChild("RF"):WaitForChild("Respond")
if not hookmetamethod or not getnamecallmethod or not newcclosure then
 add("HOOK_API_UNAVAILABLE")
 add("Need hookmetamethod + getnamecallmethod + newcclosure")
 save(); return
end
local old
local installed,err=pcall(function()
 old=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
  local method=getnamecallmethod()
  if self==remote and method=="InvokeServer" then
   local args=table.pack(...)
   add("\n--- RESPOND CAPTURE ---")
   add("TIME "..os.date("%Y-%m-%d %H:%M:%S"))
   add("REMOTE "..remote:GetFullName())
   add("ARG_COUNT "..tostring(args.n))
   for i=1,args.n do add("ARG"..i.." "..val(args[i])) end
   save()
  end
  return old(self,...)
 end))
end)
if not installed then add("HOOK_INSTALL_FAILED "..tostring(err)); save(); return end
add("HOOK_INSTALLED")
add("REMOTE "..remote:GetFullName())
add("INSTRUCTIONS: biarkan script aktif, lalu tekan ACC manual hanya jika siap menerima permintaan tersebut.")
add("Pengamat hanya mencatat argumen dan meneruskan panggilan asli satu kali.")
save()
