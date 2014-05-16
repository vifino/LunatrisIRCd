local smode={
	["v"]="voice",
	["o"]="op",
	["q"]="quiet",
}
function admin_op(chan,cl)
	if not contains(chans[chan].op,cl) then
		sendchan(chan,":Server MODE "..chan.." +o "..cl.nick)
		table.insert(chans[chan].op,cl)
	end
end
function admin_deop(chan,cl)
	if contains(chans[chan].op,cl) then
		sendchan(chan,":Server MODE "..chan.." -o "..cl.nick)
		table.vremove(chans[chan].op,cl)
	end
end
function admin_voice(chan,cl)
	if not contains(chans[chan].voice,cl) then
		sendchan(chan,":Server MODE "..chan.." +v "..cl.nick)
		table.insert(chans[chan].voice,cl)
	end
end
function admin_devoice(chan,cl)
	if contains(chans[chan].voice,cl) then
		sendchan(chan,":Server MODE "..chan.." -v "..cl.nick)
		table.vremove(chans[chan].voice,cl)
	end
end
hook.new("command_mode",function(cl,chan,mode,user)
	if not chan then
		return 461,"MODE","Not enough parameters"
	end
	if mode and user then
		if nicks[user] and mode:match("^[%+%-][voq]$") then
			if contains((chans[chan] or {}).op or {},cl) then
				sendchan(chan,":"..cl.id.." MODE "..chan.." "..mode.." "..user)
				local t=chans[chan][smode[mode:match("^.(.)")]]
				if mode:match("^%-") and contains(t,nicks[user]) then
					table.vremove(t,nicks[user])
				elseif mode:match("^%+") and not not contains(t,nicks[user]) then
					table.insert(t,nicks[user])
				end
			end
		end
	elseif mode then
		-- todo: channel modes
	else
		return 324,chan,"+nt"
	end
end)
local function maxval(tbl)
	local mx=0
	for k,v in pairs(tbl) do
		if type(k)=="number" then
			mx=math.max(k,mx)
		end
	end
	return mx
end
hook.new("msg",function(cl,chan,txt)
	if cl.sk:getpeername()=="127.0.0.1" and txt:match("^@") then
		txt=txt:match("^@(.+)")
		local func,err=loadstring("return "..txt,"=lua")
		if not func then
			func,err=loadstring(txt,"=lua")
			if not func then
				sendchan(chan,":Server PRIVMSG "..chan.." :"..err)
				return
			end
		end
		local res={xpcall(func,debug.traceback)}
		for l1=2,math.max(maxval(res),2) do
			sendchan(chan,":Server PRIVMSG "..chan.." :"..tostring(res[l1]))
		end
	end
end)
hook.new("command_cloak",function(cl,user,host)
	user=nicks[user]
	if user then
		sendchan(user.chans,":"..user.id.." QUIT :Changing hosts",user)
		user.ip=host
		user.id=user.nick.."!"..user.username.."@"..user.ip
		for k,v in pairs(user.chans) do
			sendchan(v,":"..user.id.." JOIN "..v,user)
		end
	end
end)
