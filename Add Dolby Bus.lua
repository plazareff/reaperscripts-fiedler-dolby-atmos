-- function to add a bus and route the track to it
function add_bus(track)
    local bus_count = reaper.CountTracks()
    local bus
    local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    local bus_name = "DA " .. track_name
    for i = 0, bus_count-1 do
      local track = reaper.GetTrack(0, i)
      local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
      if name == bus_name then
        bus = track
        break
      end
    end
    if not bus then
      reaper.InsertTrackAtIndex(reaper.GetNumTracks(), true)
      bus = reaper.GetTrack(0, reaper.GetNumTracks()-1)
      reaper.GetSetMediaTrackInfo_String(bus, "P_NAME", bus_name, true)
      reaper.SetMediaTrackInfo_Value(bus, "B_SOLO_DEFEAT", 1)
      reaper.CreateTrackSend(track, bus)
    end
    return bus
  end
  
  -- function to add the plugin to the bus
  function add_plugin(bus)
    local fx_idx = reaper.TrackFX_AddByName(bus, "Dolby Atmos Beam (Fiedler Audio)", false, -1)
    return fx_idx
  end
  
  -- main function that loops through selected tracks and creates buses with plugins
  function main()
    local sel_tracks = reaper.CountSelectedTracks(0)
    if sel_tracks > 0 then
      for i = 0, sel_tracks-1 do
        local track = reaper.GetSelectedTrack(0, i)
        local bus = add_bus(track)
        local fx_idx = add_plugin(bus)
      end
    end
  end
  
  reaper.Undo_BeginBlock()
  
  main()
  
  reaper.Undo_EndBlock("Add Buses and Plugins to Selected Tracks", -1)
  
