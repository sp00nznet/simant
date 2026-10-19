# Changelog

## [Unreleased]

### Added
- First lift of `SIMANTW.EXE`: 12,612 lifted blocks, 0 unresolved calls,
  seeded from the game's own `SIMANTW.SYM`.
- The game boots to its **Select a Game** screen: ribbon bar, title, the
  dialog, and its `SHARED`/`WINGANT`/`SOUND` databases loaded.
- `tools/relift.py`, `runtime/game.c`, `scripts/grab.ps1`.
- The game's own menu bar, a 640x480 window, and **Quick Game**: the colony
  starts and the queen digs (pcrecomp #115, `real_windows`).
- `scripts/grab.ps1 -Click x,y` presses a point through `RECOMP_CURSOR`, since
  the game polls the mouse instead of trusting button messages.
