# Home OS Emulator

A QEMU based ARM64 test environment and desktop launcher for Home OS. **This repository is the emulator, not the operating system.** The desktop launcher opens the adjacent `Home OS` project's phone UI, while `launch.sh` remains available for serial guest testing.

The standalone prototype guest is text only. The desktop launcher displays the Home OS phone shell and starts its ARM64 guest for supported functions.

Both launchers give the guest a virtual network adapter. QEMU shares the computer's active connection, including Wi-Fi, through user mode networking. The guest cannot scan or change the computer's physical Wi-Fi settings. In the phone UI, Quick Settings shows whether the host Wi-Fi is connected.

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

4. Place this repository beside the `Home OS` project and launch the phone UI:

   ```sh
   ./launch-desktop.sh
   ```

   The borderless, rounded phone window uses the Home OS elephant logo as its application icon. Drag its top edge to move it. Use **Alt+F4** to close it. Set `HOME_OS_ROOT=/path/to/Home OS` if the project is elsewhere. For a terminal only serial prototype session, run `./launch.sh` instead.

5. In the serial prototype console, stop QEMU by pressing **Ctrl+A**, then **X**. Close the current emulator before launching another instance with the same disk.

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
- **No desktop window**: check that you are logged into an X11 desktop and that the adjacent `Home OS` project exists, then use `./launch-desktop.sh`. Use `./launch.sh` for a terminal session.
- **Virtual disk is locked**: another emulator instance is using the same disk. Stop it or set `HOME_OS_DISK` to a different path.
- **QEMU opens but does not reach the shell**: inspect the newest file in `logs/` and confirm that the kernel and initramfs are both ARM64 and match each other.

See [CHECKS.md](CHECKS.md) for the prototype boot result and the remaining emulator test milestones.
# Home-OS-emulator
