# songcat
Concatenate song sysex files for the Elektron Machinedrum

# Description
The Machinedrum cannot load a new song file while the sequencer is playing.  This is an issue when you, like me, try to make a 1-hour machinedrum solo live set (which I'm sure you're about to do!)

So, this tool concatenates separate songs held in various sysex files into a longer song.  So you can write 10 separate songs, and then join them together into one larger set.

The Machinedrum can only play a song of total 255 rows, so you may still have to split your set up into multiple songs, but at least you'll only need a handful of "infinite reverb decay wash" passes while you reload the next section of your set. 

# Usage
```ruby
ruby songcat.rb <output.syx> <song-1.syx> <song-2.syx>
```

# TODO
Often when you dump sysex it will have all the songs in 1 sysex file.  I should write a second tool that splits a sysex dump into N separate song sysexes.
