--test, probably doesn't work.
godreplies = { "Yes, mortal?", "Hello", "Wut?", "Ohia down there!" }
hook.new("command_privmsg",function(cl,chan,txt)
	if not chan or not txt then
	  --Do nothing
	else
  	if txt:match("god") then
  	  sendtoChannel("god",chan,godreplies[ math.random( #godreplies ) ])
  	end
	end
end)
-- RANDOM DERPING SPREE!
hook.new("command_privmsg",function(cl,chan,txt) if not chan or not txt then elseif txt:match("hy") then sendtoChannel(cl.nick,chan,"Oh, sorry, its Hai...") end end)
hook.new("command_privmsg",function(cl,chan,txt) if not chan or not txt then elseif txt:match("ty") then sendtoChannel(cl.nick,chan,"Oh, sorry, its Thank you...") end end)
hook.new("command_privmsg",function(cl,chan,txt) if not chan or not txt then elseif txt:match("P:") then sendtoChannel(cl.nick,chan,"ITS :P GOD DAMMIT!") end end)
hook.new("command_privmsg",function(cl,chan,txt) if not chan or not txt then elseif txt:match("P :") then sendtoChannel(cl.nick,chan,"ITS :P GOD DAMMIT!") end end)