local Server = {}
Server.__index = Server

Server.Storage = {}
Server.Event = Instance.new("RemoteEvent"); Server.Event.Parent = script; Server.Event.Name = "Main"

local Connection = {}
Connection.__index = Connection

function Server.new(Name: string)
	local meta = setmetatable({
		["Name"] = Name;
		["connectionList"] = {};
	}, Server)
	
	Server.Storage[Name] = meta
	return meta
end

function Server.get(Name: string)
	return Server.Storage[Name]
end

function Server:Fire(Player: Player, ...)
	self.Event:FireClient(Player, self.Name, ...)
end

function Server:FireAll(...)
	self.Event:FireAllClients(self.Name, ...)
end

function Server:Connect(func)
	local meta = setmetatable({
		["func"] = func;
		["Connected"] = true;
	}, Connection)
	
	table.insert(self.connectionList, meta)
	return meta
end

function Connection:Disconnect()
	self.func = nil
	self.Connected = false
end

Server.Event.OnServerEvent:Connect(function(Player, Name, ...)
	if type(Name) == "string" and Name then
		local Signal = Server.get(Name)
		if Signal then
			for i, v in Signal.connectionList do
				if v.Connected and v.func then
					coroutine.wrap(v.func)(...)
				else
					table.remove(Signal.connectionList, i)
				end
			end
		end
	elseif Name then
		local args = {...}
		Name = args[1]
		
		if Name and Server.get(Name) then
			Server.Event:FireClient(Player, Server.get(Name))
		end
	end
end)


return Server
