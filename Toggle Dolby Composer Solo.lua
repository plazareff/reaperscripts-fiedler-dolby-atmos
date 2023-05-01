-- SET THE SOLO HACK SCRIPT ID
-- You will find it in the Action List
local solo_hack_script_id = ''

if solo_hack_script_id == '' then
  reaper.ShowMessageBox("Please set the ID of the Solo Hack script.", "Solo Hack", 0)
else
  function main()
      local state = reaper.GetExtState("dac_solo_hack", "runstate")
      if state == "stopped" then
          reaper.Main_OnCommand(reaper.NamedCommandLookup(solo_hack_script_id), 0)
          reaper.ShowMessageBox("Solo Mutes All Other Tracks", "Solo Hack", 0)
      else
        reaper.SetExtState("dac_solo_hack", "runstate", "stopped", false)
        reaper.ShowMessageBox("Solo Mode Back To Normal", "Solo Hack", 0)
      end
    end
    
    main()
end
