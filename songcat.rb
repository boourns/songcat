require 'byebug'
require './packdata'
require './song_reader'
require './song_joiner'
require './song'

if ARGV.length < 2
	puts "Usage: #{ARGV[0]} <output.syx> <song-1.syx> <song-2.syx>"
	exit
end

def run
	filelist = ARGV
	outfile = filelist.shift

	if File.exist?(outfile)
		raise "outfile #{outfile} already exists, cowardly exiting"
	end

	songs = []

	filelist.each do |infile|
		input = SongReader.new(File.read(infile))
		puts "File #{infile}: Read #{input.songs.length} songs"
		songs += input.songs

		input.songs.each do |song|
			puts "Position #{song.position}: #{song.name}"
		end
	end

	puts "Joining #{songs}"

	joiner = SongJoiner.new(songs)

	puts "Computed joined song of length #{joiner.output.rows.length}"

	rendered = joiner.output.render

	# check it
	check = SongReader.new(rendered.pack("C*"))

	if check.songs.length != 1 || joiner.output.rows.length != check.songs[0].rows.length
		raise "Didn't reload right length"
	end

	File.write(outfile, rendered.pack("C*"))
end

run()

#testPackData()