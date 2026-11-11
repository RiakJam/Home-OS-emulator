#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE='https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/aarch64/netboot'
for tool in curl cpio gzip; do command -v "$tool" >/dev/null || { echo "Missing $tool" >&2; exit 1; }; done
mkdir -p "$ROOT/guest"
curl -fL --retry 2 -o "$ROOT/guest/Image" "$BASE/vmlinuz-virt"
TEMP="$(mktemp -d)"
trap 'rm -rf "$TEMP"' EXIT
curl -fL --retry 2 -o "$TEMP/alpine-initramfs.gz" "$BASE/initramfs-virt"
(
  cd "$TEMP"
  gzip -dc alpine-initramfs.gz | cpio -idmu --quiet
  rm alpine-initramfs.gz
  cp "$ROOT/prototype-init" init
  chmod +x init
  find . -print0 | cpio --null -o -H newc --quiet | gzip -9 > "$ROOT/guest/initramfs.cpio.gz"
)
echo 'Prototype guest assets are ready. Run ./launch.sh.'
