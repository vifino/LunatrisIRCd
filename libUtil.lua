-- libUtil.lua
-- Made by vifino
libUtil = {}
function libUtil.loadDir(dir)
	print("LibUtils loading "..dir)
	local libFiles = {}
	for i,file in pairs(system.ls(dir)) do
		print("-> "..file)
		if file ~= ".DS_Store" then
			dofile(dir.."/"..file)
		end
	end
	print("Done.")
end