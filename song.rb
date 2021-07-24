require './packdata'

class Song
	attr_reader :rows, :position, :name

	def initialize(position, name, rows)
		@position = position
		if name.class == String
			n = name.unpack("C*")
			while (n.length < 16)
				n.append(0x00)
			end
			name = n
		end
		@name = name
		@rows = rows
	end

	def render
		if (@name.length != 16 || @name.class != Array)
			raise "@name should be array of length 16"
		end

		checksum = 0

		sysex = [0xf0, 0x00, 0x20, 0x3c, 0x02, 0x00, 0x69, 0x02, 0x02]
		sysex.append(@position)
		checksum += @position

		sysex += @name
		checksum += @name.sum

		puts "post name, checksum #{checksum}"
		puts "total of #{@rows} rows"

		@rows.each do |bytes|
			if bytes.length != 10
				raise "Row length should be 10 bytes"
			end
			row = packData(bytes)
			if row.length != 12
				raise "Packed row length should be 12 bytes"
			end

			sysex += row
			checksum += row.sum
		end

		checksum = checksum & 0x3fff

		puts "trying to write checksum #{checksum}"

		sysex += [(checksum>>7) & 0x7F, checksum&0x7F]

		len = sysex.length - 7
		sysex += [len>>7, len&0x7F]

		sysex
	end
end
