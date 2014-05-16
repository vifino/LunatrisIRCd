hook.new("command_whois",function(cl,user)
	if not user then
		return 461,"WHOIS","Not enough parameters"
	end
	if nicks[user] then
		local user=nicks[user]
		cl:send(encode(cl,311,user.nick,user.username,user.ip,"*",":"..user.realname))
		local o={}
		for k,v in pairs(user.chans) do
			local chan=chans[v]
			if chan then
				table.insert(o,(contains(chan.op,user) and "@" or "")..(contains(chan.voice,user) and "+" or "")..v)
			end
		end
		cl:send(encode(cl,319,user.nick,":"..table.concat(o," ")))
	else
		cl:send(encode(cl,401,"No such nick/channel"))
	end
	return 318,user,"End of /WHOIS list."
end)