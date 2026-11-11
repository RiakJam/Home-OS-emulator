#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL="${HOME_OS_KERNEL:-$ROOT/guest/Image}"
INITRD="${HOME_OS_INITRD:-$ROOT/guest/initramfs.cpio.gz}"
DISK="${HOME_OS_DISK:-$ROOT/guest/home-os.qcow2}"
LOG_DIR="$ROOT/logs"

for tool in qemu-system-aarch64 qemu-img; do
  command -v "$tool" >/dev/null || { echo "Missing $tool. See README.md." >&2; exit 1; }
done
for asset in "$KERNEL" "$INITRD"; do
  [[ -f "$asset" ]] || { echo "Missing guest asset: $asset. See README.md." >&2; exit 1; }
done

mkdir -p "$LOG_DIR" "$(dirname "$DISK")"
if [[ ! -e "$DISK" ]]; then
  qemu-img create -f qcow2 "$DISK" 2G
fi
LOG="$LOG_DIR/boot-$(date -u +%Y%m%dT%H%M%SZ).log"
echo "Serial log: $LOG"
qemu-system-aarch64 \
  -machine virt -cpu cortex-a57 -smp 2 -m 1024 \
  -kernel "$KERNEL" -initrd "$INITRD" \
  -append 'console=ttyAMA0,115200 root=/dev/ram0 rw' \
  -drive "if=none,file=$DISK,format=qcow2,id=homeosdisk" \
  -device virtio-blk-device,drive=homeosdisk \
  -netdev user,id=homeos-net \
  -device virtio-net-pci,netdev=homeos-net \
  -nographic 2>&1 | tee "$LOG"
