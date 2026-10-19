# Roadmap

## Done

- Lifts with no unresolved calls, seeded from `SIMANTW.SYM`.
- Boots to **Select a Game** in a 640x480 window, with the game's menu bar.
- **Quick Game** starts, and the colony simulates.

## Now: the Quick Game interface

- **Tool icons.** The second ribbon row shows the same placeholder bitmap
  eight times, so the game's tool bitmaps aren't being found or drawn.
- **Window frames.** The game's floating panels get Windows 11 frames
  (title bar, minimize/maximize buttons). Its own style bits should be
  honoured instead.
- **Speed.** Over 40 s the tunnel only grows a little. Check the game's
  timer (`MYTIMERFUNC`, `SetTimer`) against what the Speed menu expects.
- **Fonts.** `AddFontResource` is a stub. `FONTRES.FON` and `FONT1`–`FONT4`
  ship with the game; it also asks for `font5` and `font6`, which aren't in
  this install.
- **Still unimplemented:** `CreateRectRgn`, `GetUpdateRgn`, `SetMapperFlags`,
  `GlobalFlags`, `GlobalLRUNewest`, `lstrcat`, `GetSystemDirectory`,
  `GetProfileInt`, `GetTopWindow`, `EnumChildWindows`, `Escape`.

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
