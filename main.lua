-- RAEL'S TRICKS - MAIN LOADER
local url = "https://raw.githubusercontent.com/rael-kertia/Rael-Tricks/main/main_obfuscated.lua"
local response = game:HttpGet(url)
local chunk, loadError = loadstring(response)
if not chunk then
    error("Rael's Tricks failed to compile: " .. tostring(loadError))
end
chunk()
