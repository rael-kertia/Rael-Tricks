-- RAEL DIAGNOSTIC: PERMINTAAN SEWA
-- PASIF: hanya membaca GUI. TIDAK klik tombol / tidak fire remote.
local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local roots={plr:WaitForChild("PlayerGui")}
pcall(function() table.insert(roots,game:GetService("CoreGui")) end)

local function safe(fn)
 local ok,v=pcall(fn)
 return ok and tostring(v) or "?"
end
local function path(o)
 return safe(function() return o:GetFullName() end)
end
local function norm(s)
 return tostring(s or ""):lower():gsub("%s+",""):gsub("[^%w]","")
end
local function visible(o)
 local p=o
 while p do
  if p:IsA("GuiObject") and not p.Visible then return false end
  if p:IsA("ScreenGui") and not p.Enabled then return false end
  p=p.Parent
 end
 return true
end
local out,used={},0
local LIMIT=9500
local function add(s)
 s=tostring(s or "")
 if used>=LIMIT then return end
 local room=LIMIT-used
 if #s>room then s=s:sub(1,room) end
 out[#out+1]=s
 used=used+#s+1
end
add("=== RAEL DIAGNOSTIC PERMINTAAN SEWA V5 UPVALUE3 ===")
add("PLAYER: "..plr.Name.." | "..os.date("%Y-%m-%d %H:%M:%S"))
local found,seen={},{}
for _,root in ipairs(roots) do
 for _,obj in ipairs(root:GetDescendants()) do
  if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
   local t=norm(obj.Text)
   if t:find("permintaansewa",1,true) then
    found[#found+1]=obj
   end
  end
 end
end
add("JUMLAH TEKS JUDUL DITEMUKAN: "..#found)
for n,title in ipairs(found) do
 add("")
 add("=== POPUP TARGET #"..n.." ===")
 add("JUDUL: "..title.ClassName.." | Name="..title.Name.." | Text="..tostring(title.Text))
 add("VISIBLE: "..tostring(visible(title)))
 add("FULL PATH: "..path(title))
 local parent=title
 for level=1,7 do
  parent=parent.Parent
  if not parent then break end
  add("ANCESTOR "..level..": "..parent.ClassName.." "..parent.Name.." | "..path(parent))
  local buttons={}
  for _,v in ipairs(parent:GetDescendants()) do
   if (v:IsA("TextButton") or v:IsA("ImageButton")) and not seen[v] then
    local tx=v:IsA("TextButton") and tostring(v.Text) or "(ImageButton)"
    local nt=norm(tx)
    if nt=="acc" or nt=="tolak" or level<=2 then
     buttons[#buttons+1]=v
    end
   end
  end
  for _,b in ipairs(buttons) do
   seen[b]=true
   add("  BUTTON: "..b.ClassName.." | Name="..b.Name.." | Text="..safe(function() return b.Text end))
   add("  PATH: "..path(b))
   add("  Visible="..safe(function() return b.Visible end).." | Active="..safe(function() return b.Active end).." | AutoButtonColor="..safe(function() return b.AutoButtonColor end))
  end
  if parent:IsA("ScreenGui") then break end
 end
end
if #found==0 then
 add("JUDUL TIDAK TERLIHAT DI PlayerGui/CoreGui SAAT SCRIPT DIJALANKAN.")
 add("Jalankan diagnosis ketika popup PERMINTAAN SEWA sedang terbuka.")
end
add("")
add("=== REMOTE DENGAN NAMA TERKAIT ===")
local RS=game:GetService("ReplicatedStorage")
local rc=0
for _,v in ipairs(RS:GetDescendants()) do
 if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
  local n=norm(v.Name)
  if n:find("sewa",1,true) or n:find("penyewa",1,true) or n:find("rent",1,true) or n:find("acc",1,true) then
   rc=rc+1
   if rc<=15 then add(v.ClassName.." | "..path(v)) end
  end
 end
end
if rc==0 then add("Tidak ada Remote bernama terkait yang terlihat di ReplicatedStorage.") end
add("TOTAL REMOTE TERKAIT: "..rc)

add("")
add("=== KONEKSI EVENT AccBtn (INSPEKSI PASIF) ===")
local getcon= getconnections
local dbg=debug
local inspected=0
for _,root in ipairs(roots) do
 for _,b in ipairs(root:GetDescendants()) do
  if (b:IsA("TextButton") or b:IsA("ImageButton")) and b.Name=="AccBtn" then
   inspected=inspected+1
   add("BUTTON #"..inspected.." | "..path(b).." | visible="..safe(function() return b.Visible end))
   if type(getcon)=="function" then
    local events={"Activated","MouseButton1Click","MouseButton1Down"}
    for _,ev in ipairs(events) do
     local ok,sig=pcall(function() return b[ev] end)
     if ok and sig then
      local cok,cons=pcall(getcon,sig)
      if cok and type(cons)=="table" then
       add(" EVENT "..ev.." CONNECTIONS="..#cons)
       for ci,co in ipairs(cons) do
        if ci<=5 then
         local fn=co.Function
         local info=nil
         if type(fn)=="function" and dbg and type(dbg.getinfo)=="function" then
          local iok,iv=pcall(dbg.getinfo,fn)
          if iok then info=iv end
         end
         if info then
          add("  CONN "..ci.." enabled="..safe(function() return co.Enabled end).." name="..tostring(info.name).." source="..tostring(info.short_src or info.source).." line="..tostring(info.currentline))
         else
          add("  CONN "..ci.." enabled="..safe(function() return co.Enabled end).." function="..tostring(fn))
         end
         local gu=(dbg and dbg.getupvalues) or getupvalues
         if type(gu)=="function" and type(fn)=="function" then
          local uok,ups=pcall(gu,fn)
          if uok and type(ups)=="table" then
           for ui,uv in pairs(ups) do
            local desc=typeof and typeof(uv) or type(uv)
            if desc=="Instance" then desc=uv.ClassName.." "..path(uv)
            elseif type(uv)=="string" then desc="string:"..uv:sub(1,100)
            else desc=desc..":"..tostring(uv):sub(1,100) end
            if ui<=12 then add("   UPVALUE "..tostring(ui).." = "..desc) end
            if ui==3 and type(uv)=="function" then
             add("   === UPVALUE 3 FUNCTION DETAIL ===")
             local dfn=decompile or decompilefunction
             if type(dfn)=="function" then
              local fok,fs=pcall(dfn,uv)
              if fok and type(fs)=="string" then
               local ln=0
               for line in (fs.."\\n"):gmatch("(.-)\\n") do
                ln=ln+1
                if ln<=90 then add("    SRC "..ln..": "..line) end
               end
              else add("    DECOMPILE: "..tostring(fs)) end
             else add("    DECOMPILE TIDAK TERSEDIA") end
             local fgu=(dbg and dbg.getupvalues) or getupvalues
             if type(fgu)=="function" then
              local fok2,fups=pcall(fgu,uv)
              if fok2 and type(fups)=="table" then
               for fi,fv in pairs(fups) do
                if fi<=12 then
                 local fd=typeof and typeof(fv) or type(fv)
                 if fd=="Instance" then fd=fv.ClassName.." "..path(fv) else fd=fd..":"..tostring(fv):sub(1,120) end
                 add("    NESTED UPVALUE "..fi.." = "..fd)
                end
               end
              else add("    NESTED UPVALUES: "..tostring(fups)) end
             end
             local fgc=(dbg and dbg.getconstants) or getconstants
             if type(fgc)=="function" then
              local fok3,fcs=pcall(fgc,uv)
              if fok3 and type(fcs)=="table" then
               for fi,fc in ipairs(fcs) do
                if fi<=100 then
                 if type(fc)=="string" or type(fc)=="number" or type(fc)=="boolean" then
                  add("    NESTED CONST "..fi.." = "..tostring(fc):sub(1,120))
                 end
                end
               end
              else add("    NESTED CONSTANTS: "..tostring(fcs)) end
             end
            end
           end
          end
         end
         local df=decompile or decompilefunction
         if type(df)=="function" and type(fn)=="function" then
          local dok,ds=pcall(df,fn)
          if dok and type(ds)=="string" then
           add("   HANDLER SOURCE:")
           local n=0
           for line in (ds.."\\n"):gmatch("(.-)\\n") do
            n=n+1
            if n<=100 then add("   "..n..": "..line) end
           end
          else add("   HANDLER DECOMPILE GAGAL: "..tostring(ds)) end
         end
         local gc=(dbg and dbg.getconstants) or getconstants
         if type(gc)=="function" and type(fn)=="function" then
          local gok,vals=pcall(gc,fn)
          if gok and type(vals)=="table" then
           local hits={}
           for _,cv in ipairs(vals) do
            if type(cv)=="string" and (#cv<100) then
             local z=norm(cv)
             if z:find("accept",1,true) or z:find("worker",1,true) or z:find("sewa",1,true) or z:find("karyawan",1,true) or z:find("acc",1,true) then
              hits[#hits+1]=cv
             end
            end
           end
           if #hits>0 then add("   CONSTANTS: "..table.concat(hits,", "):sub(1,250)) end
          end
         end
        end
       end
      else
       add(" EVENT "..ev.." getconnections gagal/tidak tersedia")
      end
     end
    end
   else
    add(" getconnections TIDAK TERSEDIA DI EXECUTOR")
   end
  end
 end
end
if inspected==0 then add("Tidak menemukan AccBtn saat pemeriksaan.") end

local result=table.concat(out,"\n")
local copied=false
if setclipboard then copied=pcall(setclipboard,result)
elseif toclipboard then copied=pcall(toclipboard,result) end
local saved=false
if writefile then saved=pcall(writefile,"Rael_Tenant_Diagnostic.txt",result) end
local status="DIAG V5 UPVALUE3 | chars="..#result.." | clipboard="..tostring(copied).." | file="..tostring(saved)
if setclipboard then pcall(setclipboard,result.."\n\n"..status)
elseif toclipboard then pcall(toclipboard,result.."\n\n"..status) end
if writefile then pcall(writefile,"Rael_Tenant_Diagnostic.txt",result.."\n\n"..status) end
