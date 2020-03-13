local storage = minetest.get_mod_storage()

local clientstorage = {}
clientstorage.__index = clientstorage

setmetatable(clientstorage, {
    __call = function(o, modname)
		local self = setmetatable(o or {}, clientstorage)
		self.modname = modname
		return self
    end,
})

function clientstorage:key(key)
	return self.modname .. ":" .. key
end

-- StorageRef methods
function clientstorage:contains(key)
	return storage:contains(self:key(key))
end

function clientstorage:get(key)
	return storage:get(self:key(key))
end

function clientstorage:set_string(key, value)
	storage:set_string(self:key(key), value)
end

function clientstorage:get_string(key)
	return storage:get_string(self:key(key))
end

function clientstorage:set_int(key, value)
	storage:set_int(self:key(key), value)
end

function clientstorage:get_int(key)
	return storage:get_int(self:key(key))
end

function clientstorage:set_float(key, value)
	storage:set_float(self:key(key), value)
end

function clientstorage:get_float(key)
	return storage:get_float(self:key(key))
end

function clientstorage:to_table()
	local t = {fields = {}}
	for k, v in pairs(storage:to_table().fields) do
		if k:match("^" .. self.modname .. ":") then
			t.fields[k:sub(self.modname:len() + 2)] = v
		end
	end
	return t
end

function clientstorage:from_table(new)
	local t = storage:to_table().fields
	for k in pairs(t) do
		if k:match("^" .. self.modname .. ":") then
			if type(new) ~= "table" then
				t[k] = nil
			elseif not new[k:sub(self.modname:len() + 2)] then
				t[k] = nil
			end
		end
	end
	if type(new) == "table" then
		for k, v in pairs(new) do
			t[self:key(k)] = v
		end
	end
	storage:from_table({fields=t})
end

function clientstorage:equals(other)
	local this = self:to_table().fields
	local that = other:to_table().fields
	for k, v in pairs(this) do
		if not that[k] or that[k] ~= v then
			return
		end
	end
	for k, v in pairs(that) do
		if not this[k] or this[k] ~= v then
			return
		end
	end
	return true
end

return clientstorage
