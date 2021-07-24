require 'byebug'
require './packdata'
require './song_reader'
require './song_joiner'
require './song'

if ARGV.length < 1
	puts "Splits a sysex dump into separate song sysexes"
	puts "Usage: #{ARGV[0]} <input.syx>"
	exit
end

def run
	filelist = ARGV

	filelist.each do |infile|
		input = SongReader.new(File.read(infile))
		puts "File #{infile}: Read #{input.songs.length} songs"

		input.songs.each do |song|
			puts "Position #{song.position}: #{song.songString}"
			outfile = "#{song.position}-#{song.songString}.syx"
			puts "Writing to #{outfile}"

			if File.exist?(outfile)
				raise "outfile #{outfile} already exists, cowardly exiting"
			end

			File.write(outfile, song.render.pack("C*"))
		end
	end
end

run()

#testPackData()