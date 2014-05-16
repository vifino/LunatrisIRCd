--test, probably doesn't work.
godreplies = { "Yes, mortal?", "Hello", "Wut?", "Ohia down there!" }
hook.new("command_privmsg",function(cl,chan,txt)
	if not chan or not txt then
	  --Do nothing
	else
  	if txt:lower() == "god" then
  	  sendtoChannel("god",chan,godreplies[ math.random( #myTable ) ])
  	end
	end
end)
