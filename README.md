## Labb Scripting framework
Includes cross script communication and server-client communication

# Example way on how to run Labb
```lua
local Labb = require(PATH_TO_LABB)

local HandlersFolder = PATH_TO_HANDLERS

for _, v in HandlersFolder:GetChildren() do
	Labb.AddHandler(require(v))
end

local loadStarted = tick()


-- Load --
for i, v in Loader.Storage do
	if not v.Start then continue end

	local succ, err = pcall(v.Start, v)
	if not succ then
		warn("-------------------------------------------------")
		warn("[An error accured while Starting an Handler]")
		warn(err)
		warn("-------------------------------------------------")
	end
end

Labb.State = "Loaded" --Determine if all handlers are loaded
print("Server loaded, \nTIME: ", tick() - loadStarted)
```
