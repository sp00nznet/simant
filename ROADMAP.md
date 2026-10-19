# Roadmap

## Now: past the Select a Game screen

What the runtime log still reports as unimplemented, roughly in the order the
game reaches it:

- **The window.** The frame stretches to the whole screen on a white
  background; the game draws a 640x480 area in its top-left corner.
- **The menu bar.** `SetMenu` and `ModifyMenu` are stubs, so `ANTMENU` never
  appears.
- **Fonts.** `AddFontResource` is a stub. `FONTRES.FON` and `FONT1`–`FONT4`
  ship with the game; the game also asks for `font5` and `font6`, which aren't
  in this install.
- **Regions and painting.** `CreateRectRgn`, `GetUpdateRgn`, `SetMapperFlags`.
- **Odds and ends.** `GlobalFlags`, `GlobalLRUNewest`, `lstrcat`,
  `GetSystemDirectory`, `GetProfileInt`, `GetTopWindow`, `WindowFromPoint`,
  `EnumChildWindows`, `Escape`.

Then: click through **Quick Game** and keep going until a colony runs.

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
- A resizable, scaled window; the game is fixed at 640x480.
- Checks against the original under emulation, the way the SimCity 2000
  project compares funds to the dollar.
