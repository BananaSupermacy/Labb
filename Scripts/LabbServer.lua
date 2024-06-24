local Labb = {}
Labb.__index = Labb
Labb.Storage = {}
Labb.State = false

--local CrossSignals = require(game.ReplicatedStorage.UnpackAtReplicatedStorage.Utils.CrossSignal)

function Labb:Await()
	if not Labb.State then
		while(wait()) do
			if Labb.State then break end
		end
	end
end

function Labb.AddHandler(Handler: {})
	local meta =  setmetatable(Handler, Labb)
	table.insert(Labb.Storage, meta)
	return meta
end

function Labb.GetHandler(Name: string)
	for _, v in pairs(Labb.Storage) do
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
setmetatable(Labb, {
	__index = function(t, key) warn(("This key doesnt exist, KEY: %s"):format(tostring(key)), "\n-> END REPORT <-") end;
	--__newindex = function(t, key) warn(("Key to which you are trying asign value doesnt exist(Adding keys blacklisted) KEY: %s"):format(tostring(key)), "\n-> END REPORT <-") end;
})


return Labb
