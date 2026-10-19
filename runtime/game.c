/* game.c - the few facts about SimAnt that pcrecomp's Win16 host runtime needs.
 * See <pcrecomp>/runtime/win16/host/recomp_game.h for what each field does. */
#include "recomp_game.h"

const RecompGame recomp_game = {
    .title      = "SimAnt",
    .guest_dir  = "C:\\MAXIS\\ANTWIN",            /* APPSETUP.INF's defdir */
    /* SIMANT.CFG sits beside the EXE; the game opens its DATs by bare name. */
    .ini_fallbacks = { NULL },
    .path_anchor = NULL,
};
