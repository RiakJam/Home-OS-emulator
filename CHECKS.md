# Emulator build checks

| Check | Status | Evidence |
| --- | --- | --- |
| QEMU ARM64 launch configuration | Ready | `launch.sh` uses the `virt` board, ARM64 CPU, serial logging, and a qcow2 disk. |
| Boot to guest serial console | Passed 2026-11-11 | `logs/boot-20261111T122632Z.log`: startup message, shell prompt, and `aarch64` from BusyBox `uname -m`. |
| App private-file isolation | Pending Home OS guest services | Record denied access from a second app. |
| Signed app install and update | Pending Home OS package manager | Record accepted versions and rejected tampered package. |
| Signed OS update rejection | Pending Home OS updater | Record rejection of invalid signature. |
