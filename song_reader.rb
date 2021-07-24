require './packdata'
require './song'

class SongReader
	attr_reader :songs

	def initialize(str)
		@songs = []
		bytes = str.unpack("C*")

		index = 0
		while index < bytes.length
			index = findSong(bytes, index)

			if (index < bytes.length)
				song = readSong(bytes, index)
				if song.rows.length > 1
					@songs.append(song)
				end
				index += 1
			end
		end
	end

	def findSong(bytes, index)
		found = false

		while (!found && index < bytes.length)
			found = (bytes[index] == 0xF0 && bytes[index+1] == 0x00 && bytes[index+2] == 0x20 && bytes[index+3] == 0x3C && bytes[index+4] == 0x02 && bytes[index+5] == 0x00) && (bytes[index+6] == 0x69 && bytes[index+7] == 0x02 && bytes[index+8] == 0x02) 

			if (!found)
				index += 1
			end
		end
		return index
	end

	def readSong(bytes, start)
		i = start
		# assume sysex header confirmed
		i += 6
		i += 3

		originalPosition = bytes[i]
		i += 1

		songName = bytes.slice(i, 16)
		i += 16

		rows = []
		done = false
		checksum = originalPosition + songName.sum
		puts "reading, post name checksum #{checksum}"

		while (!done)
			raw = bytes.slice(i, 12)
			checksum += raw.sum

			row = unpackSysex(raw)

			done = (row[0] == 255)
			rows.append(row)
	
			i += 12
		end

		puts "read a total of #{rows.length} rows"

		# TODO: read checksum
		fileChecksum = (bytes[i] << 7) + bytes[i+1]
		puts "Calculated checksum #{checksum & 0x3fff}, read file checksum #{fileChecksum}"
		i += 2

		if (checksum & 0x3fff) != fileChecksum
			raise "Incorrect checksum calculated vs file"
		end

		length = (bytes[i] << 7) + bytes[i+1]
		puts "Calculated length #{i-start-7}, read length #{length}"
		if (i-start-7 != length) 
			raise "Incorrect song length calculated"
		end
		
		i += 2

		Song.new(originalPosition, songName, rows)
	end	

end