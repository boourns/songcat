def unpackBlock(block)
	output = []
	i = 0
	while (i+1 < block.length)
	  output[i] = block[i+1] + ((block[0] & 0x1<<(6-i) != 0) ? 0x1<<7 : 0)
	  i += 1
	end
	return output
end

def packBlock(bytes)
	carry = 0
	output = []
	i = 0
	while (i < bytes.length)
		if (bytes[i] & 0x1 << 7) != 0
			carry = carry | (0x1 << (6-i))
		end
		output.append(bytes[i] & 0x7F)
		i += 1
	end	
	output.unshift(carry)
	output
end

def unpackSysex(sysex)
	output = []
	sysex.each_slice(8) do |block|
		output += unpackBlock(block)
	end
	output
end

def packData(data)
	output = []
	data.each_slice(7) do |block|
		output += packBlock(block)
	end
	output
end

def assert(cond)
	raise "Assertion Failure" unless cond
end

def testPackData
	assert unpackSysex([]).length == 0

	test = unpackSysex([0,0])
	assert test.length == 1 && test[0] == 0

	test = unpackSysex([0, 55, 33])
	assert test.length == 2 && test[0] == 55 && test[1] == 33

	test = unpackSysex([1<<6, 0, 0])
	assert test.length == 2 && test[0] == 128 && test[1] == 0

	test = unpackSysex([1<<5, 40, 10])
	assert test.length == 2 && test[0] == 40 && test[1] == 138

	test = unpackSysex([1, 0, 1, 2, 3, 4, 5, 6])
	assert test.length == 7 && test[0] == 0 && test[6] == 6 + 128

	test = unpackSysex([1, 0, 0, 0, 0, 0, 0, 0, 1<<6, 0, 0])
	assert test.length == 9 && test[0] == 0 && test[6] == 128 && test[7] == 128 && test[8] == 0

	test = packData([0])
	assert test.length == 2 && test[0] == 0 && test[1] == 0

	test = packData([1])
	assert test.length == 2 && test[0] == 0 && test[1] == 1

	test = packData([255])
	assert test.length == 2 && test[0] == 1<<6 && test[1] == 127

	test = packData([1,1,1,1,1,1,1,1,1,1])
	assert test.length == 12 && test[0] == 0 && test[8] == 0

	puts "tests pass"
end