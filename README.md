# Using Fiedler Audio's Dolby Atmos Composer in Reaper

This repository contains a collection of Lua scripts for [Reaper](https://www.reaper.fm/) that automate various tasks for audio production.

When using [Fiedler Audio's Dolby Atmos Composer](https://fiedler-audio.com/dolby-atmos-composer//), there are two small issues where these scripts can come handy.

They are at a very early stage, especially the solo hack scripts, feel free to improve on them and of course, use at your own risks ;-)

## Video explanation

[![Alt text](https://img.youtube.com/vi/7jYYoLgwiKI/0.jpg)](https://www.youtube.com/watch?v=7jYYoLgwiKI)

## Issue 1: creating busses for audio tracks
File: `Add Dolby Bus.lua`

It may be tedious to create a bus for every track, that's where the Add Dolby Bus script comes in:

1. Select the track(s) you need a Dolby Atmos Bus for.
2. Run the script (from action list or via a toolbar or shorcut at your convenience).
3. For each selected track, the script will create a bus named "DA ORIGINAL_TRACK_NAME", route the track to it and insert the Dolby Atmos Beam plugin.

## Issue 2: the solo hack
File: `Mute All Unsoloed Tracks.lua`

Once bussed to the Dolby Atmos Composer, soloing an audio track is no longer effective. The Solo Hack script, will mute any unsoloed track while respecting the parent/child relationship and noty muting the tracks that are on solo defeat (which is why the bus creation script puts them on solo defeat by default)

### IMPORTANT NOTE
**In order to work properly, this script requires that you add at least one track permanently muted.**

### What the script does:

#### When a track is soloed

1. Makes a list of all already muted tracks (so that they are not unmuted when the last solo is cleared)
2. Stores this list to disk
3. Mute all tracks that are not soloed or on solo defeat

#### When there are no tracks in solo

1. Loads the list of previously muted tracks from disk
2. Unmute any track that is not on the list
3. Removes the list from disk

## Solo Hack Toggle
File: `Toggle Dolby Composer Solo.lua`

As the solo hack behavior is not recommended for normal use (i.e. when not using Fiedler Audio's Dolby Atmos Composer), the script needs to be toggled on/off. This script provides a toggle function to turn the Solo Hack script on and off. 

### To use the Solo Hack Toggle script:

1. Install the script as described below
2. Edit the script and insert the correct value for `solo_hack_script_id` with the ID of the Solo Hack script (found in the Action List)
3. Add the script to your toolbar or assign it to a keyboard shortcut
4. Run the script to turn the Solo Hack script on or off

## Installation

To install the scripts, simply download the `.lua` files and save them to your Reaper scripts folder. The default location for this folder is:

- **Windows:** `C:\Users\[username]\AppData\Roaming\REAPER\Scripts`
- **macOS:** `~/Library/Application Support/REAPER/Scripts`

Once you have saved the scripts to your scripts folder, you can add them to your Reaper toolbar or assign them to a keyboard shortcut by following the instructions [here](https://www.reaper.fm/videos.php#FxvJ4AbLmYc).

## Credits

These scripts were developed by [Patrice Lazareff](https://lnk.bio/MN4m) with remarkable help from [ChatGPT](https://github.com/chatgpt).

## License

These scripts are released under the [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.
