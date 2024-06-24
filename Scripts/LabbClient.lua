local Loader = {}
Loader.__index = Loader
Loader.Storage = {}
Loader.State = "Loading"

local CrossSignals = require(game.ReplicatedStorage.UnpackAtReplicatedStorage.Utils.CrossSignal)

function Loader:Await()
	if Loader.State ~= "Loaded" then
		while(wait()) do
			if Loader.State == "Loaded" then break end
		end
	end
end

function Loader.AddHandler(Handler: {})
	local meta =  setmetatable(Handler, Loader)
	table.insert(Loader.Storage, meta)
	return meta
end

function Loader.GetHandler(Name: string)
	for _, v in pairs(Loader.Storage) do
		if v and v.Name == Name then
			local succ, err = pcall(function()
				v:GatherEvent()
			end)

			if not succ then warn("Error occured while running GatherEvent\n", ("ERR -> %s"):format(err), "\n-> END REPORT <-") end

			return v
		end
	end

	error(("Handler doesnt exist NAME: %s"):format(Name))
end


--error handlers
setmetatable(Loader, {
	__index = function(t, key) warn(("This key doesnt exist, KEY: %s"):format(tostring(key)), "\n-> END REPORT <-") end;
	--__newindex = function(t, key) warn(("Key to which you are trying asign value doesnt exist(Adding keys blacklisted) KEY: %s"):format(tostring(key)), "\n-> END REPORT <-") end;
})


return Loader
