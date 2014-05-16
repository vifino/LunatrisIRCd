hook.new("command_ping",function(cl,txt)
	if not txt then
		return 461,"PING","Not enough parameters"
	end
	return "PONG",":"..txt
end)