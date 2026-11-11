#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_OS_ROOT="${HOME_OS_ROOT:-$ROOT/../Home OS}"
GUI="$HOME_OS_ROOT/scripts/design-emulator.py"
[[ -f "$GUI" ]] || { echo "Home OS phone UI not found: $GUI" >&2; exit 1; }
export HOME_OS_EMULATOR_ICON="$ROOT/assets/home-os-emulator.png"
exec python3 "$GUI"
