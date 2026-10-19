# Roadmap

## Done

- Lifts with no unresolved calls, seeded from `SIMANTW.SYM`.
- Boots to **Select a Game** in a 640x480 window, with the game's menu bar.
- **Quick Game** starts, and the colony simulates at speed: the timer
  callback (`MYTIMERFUNC`) runs.
- The ribbon's user buttons show their own tools (WIN.INI `GetProfileInt`).
- Most of the calls that were stubs now work (pcrecomp #116).
- Music (MIDI through MCI) and sound effects (pcrecomp #118).
- Keyboard shortcuts: Shift+0 pauses, Shift+1-4 set the speed (pcrecomp #119).

## Now: the Quick Game interface

- **Window frames.** The game's floating panels get Windows 11 frames, which
  are thicker than Windows 3.1's, so the panels overlap more than they did.
- **Speed menu.** Windows timers tick at 55 ms at best, as they did in
  1992. Check that each Speed setting changes the pace.
- **Fonts.** The game asks for `font5` and `font6`, which aren't in this
  install.
- **Still unimplemented:** `ScrollWindow`, `EnumChildWindows`, `Escape`.

## Sound

- **One voice.** Effects go through `sndPlaySound`, so a new sound cuts off
  the one playing. Real `waveOut` would let them overlap the way the game's
  own queue expects.
- **Sample rate.** The game asks for 4096 Hz. Check that it sounds right
  against the original.
- **PC speaker.** Without MMSYSTEM the game falls back to the `SOUND.DRV`
  voice queue (`OpenSound`, `SetVoiceNote`), which is still a stub. Nothing
  reaches it while MMSYSTEM works.

## Afterwards

- Saving and loading `.ANT` games through the game's own dialogs.
- Tutorial, Full Game and Experimental modes.
- A scaled window; the game is fixed at 640x480.
- Checks against the original under emulation, the way the SimCity 2000
  project compares funds to the dollar.
