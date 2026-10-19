# Roadmap

## Done

- Lifts with no unresolved calls, seeded from `SIMANTW.SYM`.
- Boots to **Select a Game** in a 640x480 window, with the game's menu bar.
- **Quick Game** starts, and the colony simulates at speed: the timer
  callback (`MYTIMERFUNC`) runs.
- The ribbon's user buttons show their own tools (WIN.INI `GetProfileInt`).
- Most of the calls that were stubs now work (pcrecomp #116).

## Now: the Quick Game interface

- **Window frames.** The game's floating panels get Windows 11 frames, which
  are thicker than Windows 3.1's, so the panels overlap more than they did.
- **Speed menu.** Windows timers tick at 55 ms at best, as they did in
  1992. Check that each Speed setting changes the pace.
- **Fonts.** The game asks for `font5` and `font6`, which aren't in this
  install.
- **Still unimplemented:** `ScrollWindow`, `LoadAccelerators` and
  `TranslateAccelerator` (no keyboard shortcuts yet), `EnumChildWindows`,
  `Escape`.

## Sound and music

- **Sound effects** go through `SOUND.DAT` and the Windows 1–3 `SOUND.DRV`
  voice-queue API (`OpenSound`, `SetVoiceNote`, `StartSound`), which Win32
  doesn't have. That needs a small synthesiser, or a mapping onto
  `waveOut`/SDL.
- **Music** is MIDI (`SOUND\*.MID`). The game loads `MMSYSTEM.DLL` at run
  time with `LoadLibrary` and `GetProcAddress` (`mciSendCommand`,
  `midiOutGetNumDevs`, `waveOut*`). That's what `RecompGame.proc_address` and
  host thunks are for.

## Afterwards

- Saving and loading `.ANT` games through the game's own dialogs.
- Tutorial, Full Game and Experimental modes.
- A scaled window; the game is fixed at 640x480.
- Checks against the original under emulation, the way the SimCity 2000
  project compares funds to the dollar.
