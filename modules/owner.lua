hooks.new("command_kill",function(cl,nick)
	if cl.sk:getpeername()=="127.0.0.1" then
		for k,v in pairs(clients) do
			if v.nick == nick then
				v:close("Client quit (Murdered by the almighty.)")
			end
		end
	end
end)