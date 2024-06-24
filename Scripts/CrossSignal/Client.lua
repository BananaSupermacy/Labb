local Client = {}
Client.__index = Client

Client.Storage = {}
Client.Event = script.Parent.Server:WaitForChild("Main")

local Connection = {}
Connection.__index = Connection

function Client.get(Name: string)
	local meta = nil
	Client.Event:FireServer(true, Name)
	
	local conn, start = nil, os.clock()
	conn = Client.Event.OnClientEvent:Connect(function(Signal)
		if Signal and type(Signal) ~= "string" and Signal.Name == Name then
			meta = true
			conn:Disconnect()
			conn = nil
		end
	end)
	
	while(wait()) do
		if os.clock() - start >= 1.5 and not meta then
			break
		elseif meta then
			meta = setmetatable({
				["Name"] = Name;
				["connectionList"] = {};
			}, Client)
			
			Client.Storage[Name] = meta
			return meta
		end
	end
	warn("No response from server")
end

function Client:Fire(...)
	Client.Event:FireServer(self.Name, ...)
end

function Client:Connect(func)
	local meta = setmetatable({
		["func"] = func;
		["Connected"] = true;
	}, Connection)
	
	table.insert(self.connectionList, meta)
	return meta
end

function Connection:Disconnect()
	self.Connected = false
	self.func = nil
end

Client.Event.OnClientEvent:Connect(function(Name, ...)
	if type(Name) ~= "string" then return end
	
	if Client.Storage[Name] then
		for _, v in Client.Storage[Name].connectionList do
			if v.Connected and v.func then
				coroutine.wrap(v.func)(...)
			end
		end
	end
end)

return Client
