#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PSXFUNKIN_COMMIT=850e0207479d8fb658bdc7637f6bfbc28a2b4066
PSXAVENC="$ROOT/.deps/psxavenc/build/psxavenc"
MKPSXISO="$ROOT/.deps/bin/mkpsxiso"
ASSETS="$ROOT/official-v084"
UP="$ROOT/upstream"
REF="$ROOT/psx-week-reference"

rm -rf build out
mkdir -p build out build/generated-scripts

echo "Resetting the generated PSXFunkin tree..."
git -C "$UP" reset --hard "$PSXFUNKIN_COMMIT"
git -C "$UP" clean -fdx
git -C "$UP" apply "$ROOT/patches/0001-current-difficulties.patch"

# A few old build helpers patch sibling helper scripts as they assemble the
# current movie pipeline. CI could get away with doing that in a throwaway
# checkout; contributors should not get a dirty repo just for building.
cp scripts/build_v084_charselect_full.py build/generated-scripts/
cp scripts/apply_v084_charselect_full.py build/generated-scripts/
cp scripts/build_weekend1_movies.py build/generated-scripts/
cp scripts/apply_iso9660_lookup_fallback.py build/generated-scripts/
cp scripts/build_pico_mix_movies.py build/generated-scripts/
cp scripts/apply_pico_mixes_v1.py build/generated-scripts/
CS_BUILDER="$ROOT/build/generated-scripts/build_v084_charselect_full.py"
CS_APPLIER="$ROOT/build/generated-scripts/apply_v084_charselect_full.py"
W1_MOVIE_BUILDER="$ROOT/build/generated-scripts/build_weekend1_movies.py"
PICO_MOVIE_BUILDER="$ROOT/build/generated-scripts/build_pico_mix_movies.py"
PICO_APPLIER="$ROOT/build/generated-scripts/apply_pico_mixes_v1.py"
python3 scripts/fix_charselect_intro_extraction.py "$CS_BUILDER"
python3 scripts/fix_charselect_parity_v3.py "$CS_BUILDER" "$CS_APPLIER"

# Charts + Erect/Nightmare audio.
python3 scripts/build_v084_legacy_charts.py --data-root "$ASSETS" --iso-root "$UP/iso" --manifest build/v084_charts.json
python3 scripts/add_v084_chart_entries.py "$UP/funkin.xml"
python3 scripts/build_erect_audio.py --root "$ASSETS" --out "$UP/iso/music" --psxavenc "$PSXAVENC" --header "$UP/src/erect_audio_generated.h" --report build/erect_audio.json
python3 scripts/apply_erect_audio_routing.py "$UP"

# Menus + Character Select.
python3 scripts/apply_v084_menu_foundation.py "$UP"
python3 scripts/finalize_v084_menu_foundation.py "$UP"
python3 scripts/build_v084_menu_visual_assets.py --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/replace_freeplay_bf_with_official_dj.py --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/apply_v084_menu_visual_parity.py "$UP"
python3 scripts/fix_v084_menu_visual_feedback.py "$UP"
INTRO="$(find "$ASSETS/videos" -type f -iname 'introSelect*' -print -quit)"
test -n "$INTRO"
python3 "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json --intro-video "$INTRO" --psxavenc "$PSXAVENC"
python3 "$CS_APPLIER" "$UP"
python3 - "$UP/src/menu.c" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text(); bad='Menu_SetCSFrame(MENU_CS_IDLE_FIRST);'
if s.count(bad) != 1: raise SystemExit(f'expected one stale idle symbol, found {s.count(bad)}')
p.write_text(s.replace(bad, 'Menu_SetCSFrame(MENU_CS_INTRO_FIRST + 24);'))
PY
python3 scripts/fix_charselect_ram_runtime_v3.py "$UP"
python3 scripts/build_charselect_quality_v4.py --builder "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/apply_charselect_quality_v4.py "$UP"
python3 scripts/build_charselect_quality_v5.py --builder "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/apply_charselect_quality_v5.py "$UP"
python3 scripts/build_charselect_exact_ui_v6_fixed.py --builder "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/apply_charselect_exact_ui_v6.py "$UP"
python3 scripts/run_charselect_source_v7.py --builder "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json
python3 scripts/apply_charselect_source_v7.py "$UP"
python3 scripts/build_charselect_v7_1_cleanup.py --builder "$CS_BUILDER" --assets-root "$ASSETS" --upstream "$UP" --report build/menu_visual_sources.json --intro-video "$INTRO"
python3 scripts/apply_charselect_v7_1_cleanup.py "$UP"

# Freeplay, pause, missing base-week content, options/saves.
mkdir -p build/freeplay-v1-validation build/base-weeks-v1-validation build/console-options-v1-validation
python3 scripts/build_freeplay_parity_v1.py --assets-root "$ASSETS" --upstream "$UP" --report build/freeplay_parity_v1.json --validation-dir build/freeplay-v1-validation
python3 scripts/apply_freeplay_parity_v1.py "$UP"
python3 scripts/build_pause_audio.py --assets-root "$ASSETS" --out "$UP/iso/music/pause.xa" --psxavenc "$PSXAVENC" --font-template "$UP/iso/font/boldfont.tim" --font-out "$UP/iso/font/pausef.tim" --report build/pause_menu_v1.json
python3 scripts/apply_pause_menu_v1.py "$UP"
python3 scripts/build_base_weeks_v1.py --reference-root "$REF" --official-root "$ASSETS" --upstream "$UP" --report build/base_weeks_v1.json --validation-dir build/base-weeks-v1-validation
python3 scripts/apply_base_weeks_v1.py "$UP" --reference-root "$REF"
python3 scripts/build_console_options_v1.py --assets-root "$ASSETS" --header "$UP/src/settings_icon_generated.h" --report build/console_options_v1.json --validation build/console-options-v1-validation/memory-card-icon.png
python3 scripts/apply_console_options_v1.py "$UP"

# Weekend 1.
mkdir -p build/weekend1-v2-validation "$UP/iso/movie"
python3 scripts/build_weekend1_assets.py --root "$ASSETS" --upstream "$UP" --report build/weekend1_assets_v2.json
python3 scripts/build_weekend1_charts.py --root "$ASSETS" --iso-root "$UP/iso" --report build/weekend1_charts_v2.json --header "$UP/src/weekend1_events_generated.h"
python3 scripts/build_weekend1_audio.py --root "$ASSETS" --out "$UP/iso/music" --psxavenc "$PSXAVENC" --report build/weekend1_audio_v2.json
python3 "$W1_MOVIE_BUILDER" --root "$ASSETS" --out "$UP/iso/movie" --psxavenc "$PSXAVENC" --report build/weekend1_movies_v2.json --header "$UP/src/weekend1_movies_generated.h"
python3 scripts/apply_weekend1_v2.py --upstream "$UP"

# LE SSERAFIM.
mkdir -p build/sserafim-v1-validation
python3 scripts/build_sserafim_assets.py --root "$ASSETS" --upstream "$UP" --report build/sserafim_assets_v1.json
python3 scripts/build_sserafim_charts.py --root "$ASSETS" --iso-root "$UP/iso" --header "$UP/src/sserafim_events_generated.h" --report build/sserafim_charts_v1.json
python3 scripts/build_sserafim_audio.py --linux-zip "$ROOT/official-assets/funkin-linux-64bit.zip" --assets-root "$ASSETS" --out "$UP/iso/music" --psxavenc "$PSXAVENC" --header "$UP/src/sserafim_audio_generated.h" --report build/sserafim_audio_v1.json
python3 scripts/build_sserafim_movies.py --root "$ASSETS" --stage-preview "$UP/build-sserafim/background/sserafim_preview.png" --out "$UP/iso/movie" --psxavenc "$PSXAVENC" --header "$UP/src/sserafim_movies_generated.h" --report build/sserafim_movies_v1.json
python3 scripts/apply_sserafim_v1.py --upstream "$UP"

# Pico + current STR/MDEC WIP.
mkdir -p build/pico-mixes-v1-validation
python3 scripts/build_pico_mix_assets.py --root "$ASSETS" --upstream "$UP" --charselect-builder "$CS_BUILDER" --charselect-report build/menu_visual_sources.json --report build/pico_mix_assets_v1.json --validation-dir build/pico-mixes-v1-validation
python3 scripts/build_pico_mix_content.py --root "$ASSETS" --iso-root "$UP/iso" --psxavenc "$PSXAVENC" --event-header "$UP/src/pico_mix_events_generated.h" --audio-header "$UP/src/pico_mix_audio_generated.h" --report build/pico_mix_content_v1.json
python3 "$PICO_MOVIE_BUILDER" --source "$ASSETS/videos/videos/stressPicoCutscene.mkv" --out "$UP/iso/movie/pstrs.str" --ending-atlas "$ASSETS/week7/images/erect/cutscene/tankmanEnding" --ending-audio "$ASSETS/week7/sounds/erect/endCutscene.ogg" --ending-out "$UP/iso/movie/pstrend.str" --psxavenc "$PSXAVENC" --header "$UP/src/pico_mix_movies_generated.h" --report build/pico_mix_movies_v1.json
python3 "$PICO_APPLIER" --upstream "$UP"

git -C "$UP" diff --check

# Toolchain files are copied last because upstream/ is intentionally disposable.
rm -rf "$UP/mips/psyq"
mkdir -p "$UP/mips/psyq"
cp -a .deps/psyq/include "$UP/mips/psyq/include"
cp -a .deps/psyq/lib "$UP/mips/psyq/lib"

make -C "$UP" clean || true
make -C "$UP" -j"${JOBS:-2}"
test -s "$UP/funkin.ps-exe"

# The original XML references a Sony license file that is not part of this repo.
sed -i '/<license file="licensea.dat"\/>/d' "$UP/funkin.xml"
(
    cd "$UP"
    "$MKPSXISO" -y funkin.xml
)
test -s "$UP/funkin.bin"
test -s "$UP/funkin.cue"
test "$(( $(stat -c%s "$UP/funkin.bin") % 2352 ))" -eq 0
sectors=$(( $(stat -c%s "$UP/funkin.bin") / 2352 ))
echo "Raw disc sectors: $sectors"
test "$sectors" -le 360000

cp "$UP/funkin.bin" out/PSXFunkin-COMPLETE-WIP.bin
cat > out/PSXFunkin-COMPLETE-WIP.cue <<'EOF'
FILE "PSXFunkin-COMPLETE-WIP.bin" BINARY
  TRACK 01 MODE2/2352
    INDEX 01 00:00:00
EOF
cp "$UP/funkin.ps-exe" out/funkin.ps-exe
sha256sum out/PSXFunkin-COMPLETE-WIP.bin out/funkin.ps-exe > out/SHA256SUMS.txt

echo
echo "Build finished: out/PSXFunkin-COMPLETE-WIP.cue"
