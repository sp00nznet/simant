"""
relift.py - Regenerate SimAnt's lifted tree from your own copy of the game.

Everything below work/ is derived from SIMANTW.EXE and is never committed.
One command, so a re-lift cannot silently skip a step:

    python tools/relift.py            # the IDA map must already be in work/ida/
    python tools/relift.py --ida      # export it first (needs IDA 9 idalib)

What it runs, all from pcrecomp (PCRECOMP_DIR, default ../tools):
  ida/ida_export.py   the code map              -> work/ida/SIMANTW.json
  ne/mapsym.py        Maxis shipped SIMANTW.SYM, MAPSYM's symbol table for the
                      debugger: every function's real name and entry. Those
                      entries become seeds, so IDA's guesses never split or
                      merge a function the linker map says is one.
                                                -> work/seeds.json, work/names.txt
  ne/ne_link.py       lift, build the image, regenerate the glue
"""
import json
import os
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
PC = os.path.abspath(os.environ.get('PCRECOMP_DIR', os.path.join(ROOT, '..', 'tools')))
EXE = 'game/SIMANTW.EXE'
SYM = 'game/SIMANTW.SYM'


def run(*cmd):
    print('>', ' '.join(cmd), flush=True)
    subprocess.run(cmd, cwd=ROOT, check=True)


def sym_seeds():
    """SYM code symbols -> ne_link seeds, plus a seg:off name list for humans."""
    sys.path.insert(0, os.path.join(PC, 'tools', 'ne'))
    import mapsym
    from ne_parse import parse_ne
    ne = parse_ne(os.path.join(ROOT, EXE))
    code = {s.index for s in ne.code_segments}
    _, syms = mapsym.read(os.path.join(ROOT, SYM))
    seeds, names = {}, []
    for seg, off, name in syms:
        if seg in code:
            seeds.setdefault(str(seg), []).append(f'0x{off:04X}')
            names.append(f'{seg}:{off:04X} {name}')
    # ne_link keys seeds by module name (SIMANT), not the file stem (SIMANTW)
    json.dump({ne.module_name: seeds}, open(os.path.join(ROOT, 'work', 'seeds.json'), 'w'), indent=1)
    open(os.path.join(ROOT, 'work', 'names.txt'), 'w').write('\n'.join(names) + '\n')
    print(f'  {len(names)} function entries from {SYM}')


def main():
    for f in (EXE, SYM):
        if not os.path.isfile(os.path.join(ROOT, f)):
            sys.exit(f'missing {f}: copy your SimAnt for Windows install into game/ (README)')
    os.makedirs(os.path.join(ROOT, 'work', 'ida'), exist_ok=True)
    if '--ida' in sys.argv:
        run('py', '-3.11', os.path.join(PC, 'tools', 'ida', 'ida_export.py'), EXE, 'work/ida/SIMANTW.json')
    sym_seeds()
    run(sys.executable, os.path.join(PC, 'tools', 'ne', 'ne_link.py'),
        '--work', 'work', '--ida-dir', 'work/ida', '--seeds', 'work/seeds.json',
        '--prefix', 'recomp',
        '--shims', os.path.join(PC, 'runtime', 'win16', 'host'), '--shims', 'runtime',
        EXE)


if __name__ == '__main__':
    main()
