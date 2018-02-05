function file_exists(file)
	local f  = io.open (file,"rb");
	if f then f:close() end
	return f ~= nil
end

function lines_from(file)
	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end

function write_in(lines)
	file = io.open ("output.txt", "w")
	for i=0, tablelength (lines) - 1 do
		file:write (lines[i], "\n")
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function make_array(lines)
	mt ={}
	M = string.len(lines[1]) - 1
	N = tablelength(lines)
	for i=0,N+1 do
		if (i~=0 and i~=N+1 and string.len(lines[i])<M) then
			break
		end
        mt[i] = {}     -- create a new row

        for j=0,M+1 do
	      	if (i==0 or j==0 or i==N+1 or j==M+1) then
	      		mt[i][j] = '0'
	      	else
	        mt[i][j] = string.sub(lines[i], j, j)
    	end
      end
    end
    return mt
end

function wave(I, E, lines)
	--[[
	Performs Lee wave-algorithm in order to find the
	shortest path in the given maze.
	]]--
	d = 0
	front = {}
	front[0] = {I}

	nb = {}
	nb[1] = {1, 0}
	nb[2] = {0, 1}
	nb[3] = {-1, 0}
	nb[4] = {0, -1}

	-- Wave filling..

	while true do
		front[d + 1] = {}
		for _, a in pairs(front[d]) do
			for k, v in pairs(nb) do
				pt = {}
				pt.i = a.i + v[1]
				pt.j = a.j + v[2]
				if lines[pt.i][pt.j] == ' ' or lines[pt.i][pt.j] == 'E' then
					table.insert(front[d+1], pt)
					lines[pt.i][pt.j] = d + 1
				end
			end
		end
		front[d] = nil
		d  = d + 1
		if lines[E.i][E.j] ~= 'E' or tablelength(front[d]) == 0 then break
		end
	end

	-- Restoring path...

	if tablelength(front[d]) > 0 then
		cur = {}
		cur.i = E.i
		cur.j = E.j
		while d > 0 do
			for k, v in pairs(nb) do
				if lines[cur.i + v[1]][cur.j + v[2]] == d  then
					cur.i = cur.i + v[1]
					cur.j = cur.j + v[2]
					lines[cur.i][cur.j] = '+'
					break
				end
			end
			d = d - 1
		end
	end
	lines[E.i][E.j] = 'E'
	return lines
end

function make_strings (lines)
	t = {}
	N = tablelength(lines)
	for i = 0, N-1 do
		for j = 0, M-1 do
			a = lines[i][j]
			if a ~= '0' and a ~= ' ' and a ~= '+' and 
			 a ~= 'E' and a ~= 'I' then
				lines[i][j] = ' '
			end
		end
		t[i] = table.concat(lines[i])
	end
	return t
end

function find_position(lines, el)
	N = tablelength(lines)
	M = tablelength(lines[1])
	for i = 0,N-1 do
		for j = 0,M-1 do
			if lines[i][j] == el then
				temp = {}
				temp.i = i
				temp.j = j
				return temp
			end
		end
	end
end



local file = 'input.txt'
local lines = lines_from(file)

lines = make_array(lines)
N = tablelength(lines)
M = tablelength(lines[1])
I = find_position(lines, "I")
E = find_position(lines, "E")
lines = wave(I, E, lines)
r = make_strings(lines)
write_in(r)