# Changelog

## [Unreleased]

### Added
- Keyboard shortcuts, from the game's own accelerator table (pcrecomp #119).
- Music and sound effects, through the runtime's MMSYSTEM (pcrecomp #118).
- The colony runs at speed: the simulation's timer callback is called
  (pcrecomp #116). The ribbon's user buttons show their own tools.
- `scripts/grab.ps1` activates the game window, so effects aren't muted, and
  takes several clicks (`-Click "345,237","338,104"`, run with `&`).
- First lift of `SIMANTW.EXE`: 12,612 lifted blocks, 0 unresolved calls,
  seeded from the game's own `SIMANTW.SYM`.
- The game boots to its **Select a Game** screen: ribbon bar, title, the
  dialog, and its `SHARED`/`WINGANT`/`SOUND` databases loaded.
- `tools/relift.py`, `runtime/game.c`, `scripts/grab.ps1`.
- The game's own menu bar, a 640x480 window, and **Quick Game**: the colony
  starts and the queen digs (pcrecomp #115, `real_windows`).
- `scripts/grab.ps1 -Click x,y` presses a point through `RECOMP_CURSOR`, since
  the game polls the mouse instead of trusting button messages.
