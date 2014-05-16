function findCL(nick)
	if nick then
		for k,v in pairs(clients) do
			if v.nick:lower() == nick:lower() then
				return v
			end
		end
	end
end
function sendtoChannel(nick,channel,text)
	sendchan(channel,":"..nick.." PRIVMSG "..channel.." :"..text)
end