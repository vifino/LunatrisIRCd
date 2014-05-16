hook.new("command_kill",function(cl,nick, ...)
	local args = {...}
	if cl.sk:getpeername()=="127.0.0.1" then
		for k,v in pairs(clients) do
			if v.nick:lower() == nick:lower() then
				if args then
					v:close("Client quit ("..table.concat(args," ")..")")
				else
					v:close("Client quit (Murdered by the almighty.)")
				end
			end
		end
	end
end)
hook.new("command_reload",function(cl,nick, ...)
	local args = {...}
	if cl.sk:getpeername()=="127.0.0.1" then
		dofile("settings.lua")
		dofile("hook.lua")
		dofile("system.lua")
		dofile("libUtil.lua")
		libUtil.loadDir("libs")
		libUtil.loadDir("modules")
	end
end)