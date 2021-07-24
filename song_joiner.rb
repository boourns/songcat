require './song'

MAX_SONG_LENGTH = 240

class SongJoiner	
	attr_reader :output

	def initialize(songs)
		@output = Song.new(0, "output", [])
		songs.each_with_index { |s, i| append_song(s, i == songs.length-1) }
	end

	def append_song(song, final)
		offset = @output.rows.length
		if offset + song.rows.length > MAX_SONG_LENGTH
			raise "Cannot add song #{song.name}, combined song is too long (#{offset+song.rows.length})"
		end
		song.rows.each do |orig|
			row = Array.new(orig)

			puts "Row: #{row}"
			if row[0] == 254
				puts "Looks like a jump to row #{row[3]}"
				puts "Adjusting to row #{row[3] + offset}"
				row[3] += offset
				if row[3] > MAX_SONG_LENGTH
					raise "Jump past end of song!"
				end
			end
			if row[0] == 255 && !final
				puts "skipping 'halt', not last song"
			else
				@output.rows.append(row)
			end
		end
	end

end