-- system.lua, provide System functions, may only work on *NIX
-- Made by vifino
system = {}
function system.ls(directory)
	local i = 0
	local t = {}
    for filename in io.popen('ls "'..directory..'"'):lines() do
        i = i + 1
        t[i] = filename
    end
    return t
end
function system.cmd(command, data)
	if data then
		local cmd = ("echo $foo | $command 2>&1"):gsub('$foo', data):gsub("$command", command)
		local f = assert(io.popen(cmd, 'r'))
		local s = assert(f:read('*a'))
	 	f:close()
		s = string.gsub(s, '^%s+', '')
		s = string.gsub(s, '%s+$', '')
		--s = string.gsub(s, '[\n\r]+', ' | ')
		return s
	else
		local f = assert(io.popen(command.." 2>&1", 'r'))
		local s = assert(f:read('*a'))
	 	f:close()
		s = string.gsub(s, '^%s+', '')
		s = string.gsub(s, '%s+$', '')
		--s = string.gsub(s, '[\n\r]+', ' | ')
		return s
	end
end