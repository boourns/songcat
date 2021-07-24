# songcat
Concatenate / split song sysex files for the Elektron Machinedrum

# Description
The Machinedrum cannot load a new song file while the sequencer is playing.  This is an issue when you, like me, try to make a 1-hour machinedrum solo live set (which I'm sure you're about to do!)

So, this tool concatenates separate songs held in various sysex files into a longer song.  So you can write 10 separate songs, and then join them together into one larger set.

The Machinedrum can only play a song of total 255 rows, so you may still have to split your set up into multiple songs, but at least you'll only need a handful of "infinite reverb decay wash" passes while you reload the next section of your set. 

A second tool, `split.rb`, accepts a sysex file that contains many songs, and writes separate song sysex files.  This makes it easier to dump all songs in one sysex file with C6, then split the file into single song sysex files, then concatenate them all back together.

# Usage
```bash
ruby songcat.rb <output.syx> <song-1.syx> <song-2.syx>
```
This will merge `song-1.syx` and `song-2.syx` into a new, longer song, and write it to `output.syx`.  Relative jumps are rewritten to match the new row numbers.

```bash
ruby split.rb <input.syx>
```
This will read `input.syx`, and write each single song into a separate sysex file named `<position>-<song name>.syx`.
