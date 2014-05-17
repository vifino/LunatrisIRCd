socket=require("socket")
root = arg[0]:gsub("main.lua","")
function tpairs(tbl)
	local s={}
	local c=1
	for k,v in pairs(tbl) do
		s[c]=k
		c=c+1
	end
	c=0
	return function()
		c=c+1
		return s[c],tbl[s[c]]
	end
end
dofile(root.."settings.lua")
dofile(root.."hook.lua")
dofile(root.."system.lua")
dofile(root.."libUtil.lua")
libUtil.loadDir(root.."libs")
libUtil.loadDir(root.."modules")
local sv=assert(socket.bind("*",port))
hook.newsocket(sv)
clients={}
commands={}
nicks=setmetatable({},{__index=function(s,n)
	for k,v in pairs(nicks) do
		if k:lower()==n:lower() then
			return v
		end
	end
end})
local function send(cl,txt)
	async.new(function()
		async.socket(cl.sk).send(txt.."\r\n")
	end)
end
local function close(cl,reason)
	if cl.nick then
		sendchan(cl.chans,":"..cl.id.." QUIT :"..(reason or "Quit"),true)
		for k,v in pairs(cl,chans) do
			chans[v]=chans[v] or {}
			table.vremove(chans[v],cl)
			if #chans[v] then
				chans[v]=nil
			end
		end
		nicks[cl.nick]=nil
	end
	cl.sk:close()
	clients[cl.sk]=nil
	hook.remsocket(cl.sk)
end
function table.vremove(tbl,val)
	for k,v in pairs(tbl) do
		if v==val then
			table.remove(tbl,k)
			break
		end
	end
end
function contains(tbl,val)
	for k,v in pairs(tbl) do
		if v==val then
			return true
		end
	end
	return false
end
while true do
	local cl=sv:accept()
	while cl do
		hook.newsocket(cl)
		clients[cl]={
			sk=cl,
			ip=cl:getpeername(),
			send=send,
			close=close,
			chans={},
			buffer={},
		}
		hook.queue("new_client",clients[cl])
		cl=sv:accept()
	end
	for k,v in tpairs(clients) do
		if v then
			local res,err=k:receive(0)
			if err and err~="timeout" then
				close(v,"Error: "..err)
			else
				local txt=k:receive()
				if txt then
					hook.queue("raw",v,txt:sub(1,256))
				end
			end
		end
	end
	hook.queue("select",socket.select(hook.sel,hook.rsel,math.min(5,hook.interval or 5)))
end
