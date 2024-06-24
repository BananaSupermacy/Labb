local Signal = {}
Signal.__index = Signal
Signal.Storage = {}

local Connections = {}
Connections.__index = Connections

function Signal.new(Name: string)
	local meta = setmetatable({
		["Name"] = Name;
		["connectionList"] = {};
	}, Signal)
	
	Signal.Storage[Name] = meta
	return meta
end

function Signal.get(Name: string)
	return Signal.Storage[Name] or setmetatable({
		Name = Name;
	}, Signal)
end

function Signal:Await()
	if self.Name and self.connectionList then return self end
	
	while(wait()) do
		if Signal.Storage[self.Name] then
			self = Signal.Storage[self.Name]
			return self
		end
	end
end

function Signal:Connect(func)
	local connSelf = setmetatable({
		["func"] = func;
		["Connected"] = true
	}, Connections)
	
	
	table.insert(self.connectionList, connSelf)
	return connSelf
end

function Signal:Fire(...)
	local args = {...}
	
	for _, v in self.connectionList do
		if v.func and v.Connected then
			print("Fired coro")
			coroutine.wrap(v.func)(...)
		end
	end
end

function Connections:Disconnect()
	self.Connected = false
	return nil
end

return Signal
