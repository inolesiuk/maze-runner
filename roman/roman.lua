function file_exists(file)
	local f  = io.open (file,"r");
	if f then f:close() end
	return f ~= nil
end

function lines_from(file, numbers, lengths)
	if not file_exists(file) then return {} end
	profit = 0
	for line in io.lines(file) do 
		line_ = line
		real = convert(line_, numbers)
		roman_l = make_roman(real, lengths)
		profit = profit + (string.len(line_) - roman_l)
	end
	return profit
end

function make_roman (number,lengths)
	len = 0
	if (number >= 4000) then 
		len =len + 2 
	end
	while (number > 0) do
		len = len + lengths[number % 10]
		i,j = math.modf(number/10)
		number = i
	end
	return len
end

function find_a_part(rn, number)
	p = rn:sub(1, -1)
	i, j = string.find(p, number)
	if (p ~= nil and  i == 1) then 
		if (j < string.len(p)) then
			p = p:sub(j+1, -1)
			return p, true
		else return "", true
		end
	end
	return p, false
end 

function convert (rn, numbers)
	real_number = 0
	while (rn ~= "") do
		for i = 1, 13  do
			rn, cut = find_a_part(rn, numbers[i][1])
			if (cut) then
				real_number = real_number + numbers[i][2]
				break
			end
		end
	end
	return real_number
end

numbers = {}
numbers [1] = {"M",1000}
numbers [2] = {"CM", 900}
numbers [3] = {"D", 500}
numbers [4] = {"CD", 400}
numbers [5] = {"C", 100}
numbers [6] = {"XC", 90}
numbers [7] = {"L", 50}
numbers [8] = {"XL", 40}
numbers [9] = {"X", 10}
numbers [10] = {"IX", 9}
numbers [11] = {"V", 5}
numbers [12] = {"IV", 4}
numbers [13] = {"I", 1}

lengths = {}
lengths[0] = 0 
lengths[1] = 1
lengths[2] = 2
lengths[3] = 3
lengths[4] = 2
lengths[5] = 1
lengths[6] = 2
lengths[7] = 3
lengths[8] = 4
lengths[9] = 2     

profit = lines_from("roman.txt", numbers, lengths)
print(profit)
