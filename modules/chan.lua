chans={}
function sendchan(chan,txt,cl)
	if type(chan)~="table" then
		chan={chan}
	end
	local u={}
	for k,v in pairs(chan) do
		for k,v in pairs(chans[v] or {}) do
			if tonumber(k) and (not cl or v~=cl) and not u[v] then
				v:send(txt)
				u[v]=true
			end
		end
	end
end

function chan_join(cl,chan)
	if type(chan)~="table" then
		chan={chan}
	end
	for k,v in pairs(chan) do
		chans[v]=chans[v] or {
			voice={},
			op={},
		}
		table.insert(chans[v],cl)
		table.insert(cl.chans,v)
		sendchan(v,":"..cl.id.." JOIN "..v)
		local cchan=chans[v]
		for l1=1,#cchan,50 do
			local o={}
			for l2=l1,l1+49 do
				if cchan[l2] then
					table.insert(o,(contains(cchan.voice,cchan[l2]) and "+" or "")..(contains(cchan.op,cchan[l2]) and "@" or "")..cchan[l2].nick)
				end
			end
			cl:send(encode(cl,353,"=",v,":"..table.concat(o," ")))
		end
		cl:send(encode(cl,366,v,"End of /NAMES list."))
		if #cchan==1 then
			admin_op(v,cl)
		end
	end
end

function chan_part(cl,chan,txt)
	if type(chan)~="table" then
		chan={chan}
	end
	for k,v in pairs(chan) do
		sendchan(v,":"..cl.id.." PART "..v.." :"..(txt or "Leaving"))
		table.vremove(cl.chans,v)
		table.vremove(chans[v],cl)
		if #chans[v]==0 then
			chans[v]=nil
		end
	end
end

hook.new("command_join",function(cl,chan)
	if not chan then
		return 461,"JOIN","Not enough parameters"
	end
	if chan:match("^#[%w%d]*$") then
		if not contains(cl.chans,chan) then
			chan_join(cl,chan)
		end
	else
		return 403,chan,"No such channel"
	end
end)

hook.new("command_part",function(cl,chan,txt)
	if not chan then
		return 461,"JOIN","Not enough parameters"
	end
	if contains(cl.chans,chan) then
		chan_part(cl,chan,txt)
	end
end)

hook.new("command_privmsg",function(cl,chan,txt)
	if not chan or not txt then
		return 461,"PRIVMSG","Not enough parameters"
	end
	if contains(cl.chans,chan) then
		sendchan(chan,":"..cl.id.." PRIVMSG "..chan.." :"..txt,cl)
		hook.queue("msg",cl,chan,txt)
	elseif nicks[chan] then
		nicks[chan]:send(":"..cl.id.." PRIVMSG "..chan.." :"..txt)
		hook.queue("msg",cl,chan,txt)
	end
end)

hook.new("command_notice",function(cl,chan,txt)
	if not chan or not txt then
		return 461,"NOTICE","Not enough parameters"
	end
	if contains(cl.chans,chan) then
		sendchan(chan,":"..cl.id.." NOTICE "..chan.." :"..txt,cl)
	elseif nicks[chan] then
		nicks[chan]:send(":"..cl.id.." NOTICE "..chan.." :"..txt)
	end
end)

hook.new("command_quit",function(cl,reason)
	if reason then
		cl:close("Client quit ("..reason..")")
	else
		cl:close("Client quit")
	end
end)
