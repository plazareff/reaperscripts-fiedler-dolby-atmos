local prev_solo_count = 0
local muted_tracks = {}
local stored_muted_tracks = false

if reaper.GetExtState("dac_solo_hack", "runstate")=="running" then return end

reaper.SetExtState("dac_solo_hack", "runstate", "running", false)

function store_muted_tracks()
  muted_tracks = {}
  for i = 0, reaper.CountTracks(0)-1 do
    local track = reaper.GetTrack(0, i)
    local muted = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
    if muted == 1 then
      table.insert(muted_tracks, track)
    end
  end
  if #muted_tracks > 0 then
    -- reaper.ShowConsoleMsg("Try to store Muted Tracks File\n")
    local file_exists = os.rename("muted_tracks.txt", "muted_tracks.txt")
    if file_exists == nil then
      -- reaper.ShowConsoleMsg("File already exists, not creating new file.\n")
      return
    end
    local file = io.open("muted_tracks.txt", "w")
    if file then
      for i = 1, #muted_tracks do
        local _, track_name = reaper.GetTrackName(muted_tracks[i])
        file:write(track_name .. "\n")
      end
      file:close()
      -- reaper.ShowConsoleMsg("File written to disk.\n")
    end
  end
end


function load_muted_tracks()
  local file = io.open("muted_tracks.txt", "r")
  if file then
    for line in file:lines() do
      for i = 0, reaper.CountTracks(0)-1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track)
        if track_name == line then
          table.insert(muted_tracks, track)
          break
        end
      end
      
    end
    file:close()
  end
end

function unmute_all_tracks_except_muted()
  local unmute_all = false
  if #muted_tracks == 0 then
    unmute_all = true
    -- reaper.ShowConsoleMsg("UNMUTE ALL\n")
  end
  for i = 0, reaper.CountTracks(0)-1 do
    local track = reaper.GetTrack(0, i)
    local is_on_list = false
    for j = 1, #muted_tracks do
      if muted_tracks[j] == track then
        is_on_list = true
        break
      end
    end
    if not is_on_list or unmute_all then
      reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
    end
  end

  -- check if muted_tracks file exists before loading it
  if os.rename("muted_tracks.txt", "muted_tracks.txt") then
    load_muted_tracks()
  end
end


function mute_all_tracks_except_soloed()
    -- reaper.ShowConsoleMsg("Muting all tracks except those that are soloed or on solo defeat mode\n")
    for i = 0, reaper.CountTracks(0)-1 do
      local track = reaper.GetTrack(0, i)
      local parent_track = reaper.GetParentTrack(track)
      local soloed = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
      -- reaper.ShowConsoleMsg(soloed .. " SOLO STATUS\n")
      if parent_track == nil then -- check if track is not a child track
        if soloed & 1 ~= 1 and soloed & 2 ~= 2 then
          reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 1)
        end
      else -- if track is a child track
       local parent_muted = reaper.GetMediaTrackInfo_Value(parent_track, "B_MUTE")
         if soloed == 2 and parent_muted == 1 then
          reaper.SetMediaTrackInfo_Value(parent_track, "B_MUTE", 0)
        end
      end
    end
  end

function check_solo_state()
  local solo_count = 0
  local selected_count = reaper.CountSelectedTracks(0)
  for i = 0, reaper.CountTracks(0)-1 do
    local track = reaper.GetTrack(0, i)
    local soloed = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
    if soloed & 1 == 1 or soloed & 2 == 2 then
      solo_count = solo_count + 1
    end
  end
  if solo_count > 0 then
    if(solo_count ~= prev_solo_count) then
        prev_solo_count = solo_count
        stored_muted_tracks = false
    end
    if  solo_count >= selected_count then
      if #muted_tracks == 0 and not stored_muted_tracks then
        -- reaper.ShowConsoleMsg("Call to store_muted_tracks\n")
        store_muted_tracks()
        stored_muted_tracks = true
      end
    end
    mute_all_tracks_except_soloed()
    -- reaper.ShowConsoleMsg("Muting all tracks except those that are soloed or on solo defeat mode\n")
  elseif solo_count == 0 then
    if #muted_tracks > 0 then
      -- reaper.ShowConsoleMsg("Unmuting all tracks\n")
      unmute_all_tracks_except_muted()
      os.remove("muted_tracks.txt")
      -- reaper.ShowConsoleMsg("Deleted muted tracks file\n")
      muted_tracks = {}
      stored_muted_tracks = false
    end
  end
end

function main()
  if reaper.GetExtState("dac_solo_hack", "runstate")=="running" then 
    check_solo_state()
    reaper.defer(main)
  end
end

main()
