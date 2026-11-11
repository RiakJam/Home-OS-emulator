# Home OS Emulator

A QEMU based ARM64 test environment for future Home OS builds. **This repository is the emulator, not the operating system.** Until a Home OS guest is available, it can boot a small Alpine Linux prototype into a serial shell to check that the virtual machine works.

The prototype is text only. It does not provide a phone interface, app store, or Home OS services.

## Requirements

- Kali Linux with an X11 desktop for the optional console window
- Internet access to download the prototype guest assets
- About 1 GB of RAM for QEMU and space for a 2 GB virtual disk (the disk uses space as data is written)

## Install on Kali Linux

1. Install the host tools:

   ```sh
   sudo apt update
   sudo apt install qemu-system-arm qemu-utils qterminal curl cpio gzip
   qemu-system-aarch64 --version
   ```

2. Download or clone this repository and open its directory:

   ```sh
   git clone <repository-url> home-os-emulator
   cd home-os-emulator
   ```

   If you downloaded a ZIP instead, extract it and run the remaining commands from the extracted directory. Replace `<repository-url>` with the public repository URL once it is published.

3. Prepare the temporary ARM64 guest:

   ```sh
   ./prepare-prototype.sh
   ```

   This downloads Alpine Linux's ARM64 `virt` kernel and initramfs and adds the startup script in `prototype-init`. The resulting `guest/Image` and `guest/initramfs.cpio.gz` are local build assets. This step is required only once unless you want to rebuild or refresh them.

4. Launch the emulator:

   ```sh
   ./launch-desktop.sh
   ```

   A QTerminal window should show the boot log, followed by `Home OS emulator prototype guest` and a `~ #` shell prompt. For a terminal only session, run `./launch.sh` instead. On a Kali installation without a desktop, use `./launch.sh` from a terminal or SSH session.

5. Stop QEMU by pressing **Ctrl+A**, then **X** in its console window. Close the current emulator before launching another instance with the same disk.

## What the launcher creates

| Path | Purpose |
| --- | --- |
| `guest/Image` | Downloaded ARM64 Linux kernel |
| `guest/initramfs.cpio.gz` | Temporary prototype guest filesystem |
| `guest/home-os.qcow2` | Disposable 2 GB virtual test disk, created on first launch |
| `logs/boot-*.log` | Timestamped serial console logs |

The `guest/` and `logs/` directories are ignored by Git. To reset the test disk, stop QEMU and delete `guest/home-os.qcow2`; the launcher creates a new one on the next run. Logs are preserved until you delete them.

## Boot a future Home OS build

When Home OS produces an ARM64 kernel and initramfs with an executable `/init`, point the emulator at them:

```sh
HOME_OS_KERNEL=/absolute/path/to/Image \
HOME_OS_INITRD=/absolute/path/to/initramfs.cpio.gz \
./launch.sh
```

Set `HOME_OS_DISK=/absolute/path/to/test.qcow2` to keep that build's test disk separate. The launcher uses QEMU's generic ARM64 `virt` machine and the `ttyAMA0` serial console. A graphical Home OS guest and display configuration are future work; supplying a graphical guest alone does not yet change this serial console launcher into a phone screen.

## Troubleshooting

- **`Missing guest asset`**: run `./prepare-prototype.sh` again, or set `HOME_OS_KERNEL` and `HOME_OS_INITRD` to valid files.
- **No desktop window**: check that you are logged into an X11 desktop, then use `./launch-desktop.sh`. Use `./launch.sh` for a terminal session.
- **Virtual disk is locked**: another emulator instance is using the same disk. Stop it or set `HOME_OS_DISK` to a different path.
- **QEMU opens but does not reach the shell**: inspect the newest file in `logs/` and confirm that the kernel and initramfs are both ARM64 and match each other.

See [CHECKS.md](CHECKS.md) for the prototype boot result and the remaining emulator test milestones.
# Home-OS-emulator
