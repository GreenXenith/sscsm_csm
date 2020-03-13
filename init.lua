local mods = {}

-- Virtual clientmod environment
local ENV = {}
for k, v in pairs(_G) do
  ENV[k] = v
end

local storage = dofile(minetest.get_current_modname() .. ":storage.lua")

-- Environment creation
local function run(modname, filename)
	local mod = loadstring(mods[modname][filename])

	ENV.minetest.get_mod_storage = function() return storage(modname) end
	ENV.minetest.get_current_modname = function() return modname end

	setfenv(mod, ENV)
	mod()
end

ENV.dofile = function(file)
	file = file:split(":")
	return run(file[1], file[2])
end

-- Connect to modchannel
local function init()
	if not minetest.localplayer then
		minetest.after(0.05, init)
	else
		local channel = minetest.mod_channel_join("sscsm_" .. minetest.localplayer:get_name())
		minetest.register_on_modchannel_signal(function(_, signal)
			if signal == 0 then
				channel:send_all("hello")
			end
		end)
	end
end

init()

-- Handle server messages
minetest.register_on_modchannel_message(function(_, sender, message)
	if sender == "" then
		local msg = message:split(":", false, 2)
		local command = msg[1]
		local modname = msg[2]
		if command == "send" then
			mods[modname] = minetest.deserialize(minetest.decompress(minetest.decode_base64(msg[3], "deflate")))
			run(modname, "init.lua")
		end
	end
end)
