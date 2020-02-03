ESXDOS v0.8.5
(c) 2005-2013 Papaya Dezign
---------------------------

This version has the following (notable) new features (for detailed info checkout the changelog):

* Betadisk/TR-DOS Emulation: Supports (trimmed) .TRD files on all 4 drives. Uses new configuration file /SYS/CONFIG/TRDOS.CFG, which should be self-explanatory.
* DivMMC Support: Supports the DivMMC standard, available on the Zx-One FPGA core and Mario Prato's interface. This version directly supports MMC, SD and SDHC cards.
* Tape Emulator: Compatibility should be much higher now.
* NMI Browser: Online help is available at any time by pressing the "H" key. Can attach and auto-LOAD .TRD files (check help screen).
* New/Updated Commands: .divideo, .vdisk, .playwav, .dskprobe, .snapload, .gramon, .speakcz

How to (safely) install/upgrade:
--------------------------------

1. Copy esxide.tap/esxmmc.tap (depending on if you have a DivIDE or DivMMC, obviously) to your CF/SD/HDD, load it and follow the instructions. Power Off and remove media.
2. Copy the SYS, BIN (and create /TMP if using DivIDE) directories to your CF/SD/HDD.
3. Insert media. Power On. Reset while keeping space pressed to reinit if needed.

How to use the TR-DOS emulator:
-------------------------------

Either use the NMI browser to attach/auto-LOAD .TRDs, or use the .vdisk command:

.vdisk unit <filename>

Unit 0 = Drive A, Unit 1 = Drive B, etc. If you specify just the unit, it will eject the virtual drive. You can use .dskprobe to check the contents of the vdisk. Instructions on how to use TR-DOS are out of the scope of this document.

Notes:
------

a) TR-DOS emulation is not available in MapRAM mode (BETADISK.SYS will not be loaded).
b) If you replace the SYS directory *before* flashing the new ROM, your previous ROM of esxDOS will not boot correctly.
c) Questions? Bugreports? Complaints about lack of LFN/instructions? Ask on the usual places or send an e-mail to: bugs at esxdos dot org

Thanks/Greets
-------------

Alessandro Dorigatti: For developing the ZX-One core, realising the DivMMC concept, testing, etc, etc.
Bracket: For adapting the esxDOS logo for the boot screen.
Britelite: Testing, idling on IRC, saying "arsé" a lot.
Faster/TNL: For sending me his TR-DOS docs (back in 2005) that were the basis for starting the TR-DOS emulator.
Gasman: For testing, creating .commands, hdfmonkey, etc.
H7: For the Papaya Dezign nfo file.
LaesQ: For being the very first TR-DOS emulator beta-tester, .dskprobe source, moral support, etc, etc.
Mario Prato: For developing a real DivMMC interface and testing.
Mat: Extensive TR-DOS emulator testing.
Mr.Spiv: Testing, chatting on IRC, etc.
Phil Ruston: For extensive testing and for creating the wonderful V6Z80P board.
Tygrys: Extensive TR-DOS emulator, DivIDE+ testing.
UB880D: For NMI.SYS, creating .commands, re-writing FAT seek routine, TR-DOS config file parser, brainstorming, etc, etc.
Velesoft: For TR-DOS patches and testing, creating .commands + .snapload maintenance, (too) many bugreports ;), etc.

Changelog
---------

[24/04/2012] BIOS: Packed boot logo and optimized display routines, gained ~100 bytes (lordcoxis)
[24/04/2012] Kernel: Optimized rst $30 routine, gained 8 bytes (lordcoxis)
[24/04/2012] Kernel: Optimized Call48ROM routine, gained 5 bytes (ub880d)
[25/04/2012] Kernel: Optimized devices.asm, gained ~25 bytes (lordcoxis + ub880d)
[25/04/2012] Kernel: Started to change device/filesystem layer to allow vdisks, dynamic mount/umount and reinitting devices (lordcoxis)
[25/04/2012] Kernel: Optimized DISK_INFO syscall, gained 18 bytes (ub880d)
[26/04/2012] Kernel: Optimized partition offset routine, gained 19 bytes (ub880d)
[26/04/2012] Kernel: Optimized rst $08, gained ~40 bytes (lordcoxis)
[27/04/2012] Tape Emulator: Fixed bug when closing .tap files (lordcoxis)
[27/04/2012] FAT Driver: Added statvfs() syscall (lordcoxis)
[27/04/2012] Kernel: Improved mount() syscall to allow dynamic mount and setting of drive name and flags (lordcoxis)
[28/04/2012] Kernel: Added umount() syscall (lordcoxis)
[30/04/2012] BASIC: Added drive name to CAT listing heading (lordcoxis)
[30/04/2012] Commands: Added .mount and .umount commands (lordcoxis + device translation routine by ub880d)
[30/04/2012] FAT Driver: Moved ~300 bytes of write routines to ESXDOS.SYS to make room for vdisks device driver (lordcoxis)
[01/05/2012] Kernel: Added vdisk device driver, only init and BlockRead routines for now (lordcoxis)
[01/05/2012] Commands: Added (unfinished) .vdisk command (lordcoxis)
[01/05/2012] FAT Driver: Improved read() and write() (lordcoxis + optimization by ub880d)
[02/05/2012] Commands: Added .divideo command to play DivIDEo video files (gasman)
[03/05/2012] FAT Driver: Fixed minor bug in new read/write routines (lordcoxis)
[08/05/2012] FAT Driver: Added new/faster/corrected seek routine (ub880d)
[08/05/2012] Commands: Added .playwav command to play .wav audio files (gasman)
[09/05/2012] Kernel: Added TRD image detection to vdisk device driver (lordcoxis)
[10/05/2012] Commands: Adapted LaesQ's .dskprobe to show new device definitions and handle 256 bytes block size (lordcoxis)
[11/05/2012] Kernel: Changed device bitmap and defined simple device names (ub880d + lordcoxis)
[12/05/2012] Kernel: Added TOS image detection to vdisk device driver (lordcoxis + thanks to johnny_red)
[12/05/2012] Kernel: Added device bitmap to string conversion routine (ub880d)
[13/05/2012] BIOS: Changed boot messages to be device independent (lordcoxis)
[14/05/2012] FAT Driver: Changed some routines so that now mounting a FAT volume on a vdisk works (lordcoxis)
[15/05/2012] FAT Driver: Optimized seek routine for size and changed it to work correctly on vdisks (lordcoxis)
[xx/07/2012] BETADISK Driver: Started work on driver, directory listing, some lowlevel ROM calls, etc (lordcoxis) 
[08/08/2012] DivMMC: Adapted esxDOS to the hybrid "DivMMC" (DivIDE memory mapping + ZXMMC I/O) supported by Alessandro Dorigatti's ZX FPGA core (lordcoxis)
[12/08/2012] SD/MMC Driver: Added support for SDHC cards (lordcoxis)
[12/08/2012] DivMMC: Enabled 7 Mhz mode during SD I/O and NMI screen backup to the extra RAM (lordcoxis)
[13/08/2012] Commands: Fixed bugs in .snapload - DI/EI detection in 48k SNAs, and loading uncompressed 48k Z80 snapshots (Velesoft + reported by Phil Ruston and Alessandro Dorigatti)
[14/08/2012] FAT Driver: Sped up the free cluster scanning process (lordcoxis)
[15/08/2012] NMI: Added ROM detection for port $7ffd state and enabled correct NMI entry on software that has the 128 ROM paged in (lordcoxis + reported by Velesoft and Phil Ruston)
[16/08/2012] NMI: Fixed a regression related to NMI re-triggering (lordcoxis + reported by Phil Ruston)
[16/08/2012] NMI: R register was correct when exiting NMI, but wrong when saving snapshots (lordcoxis)
[16/08/2012] NMI: R register was off by 1 if interrupts were disabled (lordcoxis)
[17/08/2012] NMI: Actually fixed NMI re-trigger bugs due to ROM detection! (lordcoxis + thanks to Velesoft and ub880d)
[16/09/2012] NMI: Fixed bug in NMI handler when 128k page 7 was paged in (lordcoxis + reported by Velesoft)
[03/10/2012] auto-LOAD: Interrupts were disabled when returning to BASIC (lordcoxis + reported by Velesoft)
[03/10/2012] Commands: Bumped .snapload to v0.3.11 (Velesoft)
[03/10/2012] DivMMC: Freezed v0.8.2 for DivMMC target (lordcoxis)
[24/10/2012] auto-LOAD: Some demos/games (Binary Love, etc) use depackers that expect zeroed RAM in depack area, auto-LOAD buffer was getting in the way (lordcoxis + reported by Joe Clifford)
[27/10/2012] Tape Emulator: Fixed a regression when opening a .tap file without closing it first (lordcoxis + reported by John Barker)
[10/01/2013] SD/MMC Driver: On init, if the card has been interrupted from a previous data transfer, it needs multiple reset commands to bring it back to normal state (lordcoxis + reported by TC64 board users)
[27/01/2013] FAT Driver: Proper error code wasn't being returned when path size was > 128 (lordcoxis + reported by ub880d)
[02/02/2013] FAT Driver: File length was being truncated when a write happened before EOF (lordcoxis)
[24/02/2013] Tape Emulator: Fixed a bug first reported long ago about excessive stack usage, which made some programs fail to load (reported by Mikezt, UB880D, Archie Robbins)
[14/03/2013] Privately released v0.8.4 to beta-testers, this version already includes TR-DOS emulation, for which there's no changelog coz I couldn't be bothered (lordcoxis)
[15/04/2013] DivMMC: Changed the I/O ports from the ZXMMC standard to the final DivMMC specification (as advised by Velesoft): control port is $E7, SPI port is $EB (lordcoxis + requested by Mario Prato)
[24/04/2013] TR-DOS: Fixed bug in BASIC commands when there was no disk inserted (lordcoxis + reported by Velesoft)
[25/04/2013] TR-DOS: Fixed long standing bug in handling BASIC errors (lordcoxis + reported by Velesoft)
[26/04/2013] BIOS: We now show DivIDE/DivMMC along with the version number (lordcoxis)
[27/04/2013] BIOS: We don't attempt to load BETADISK.SYS when in MapRAM mode anymore (lordcoxis + reported by ub880d)
[27/04/2013] TR-DOS: Added OPEN# and CLOSE# commands (lordcoxis)
[27/04/2013] FAT Driver: Fixed a bug in readdir() that caused an extra 32 bytes to be copied in each call (lordcoxis + ub880d)
[28/04/2013] TR-DOS: RUN "file" CODE was returning with DivIDE RAM still mapped (lordcoxis + reported by Velesoft and Mat)
[04/05/2013] auto-LOAD: If MapRAM mode is set, we don't try to do TR-DOS auto-LOAD (lordcoxis + reported by ub880d)
[05/05/2013] TR-DOS: Fixed R register when loading snapshots (Velesoft)
[22/05/2013] NMI: Added latest version of NMI.SYS, which has a new help screen, new keys/functions, and is incompatible with all other esxDOS versions due to memory map changes (ub880d)
[08/06/2013] Commands: Bumped .snapload to v0.3.13, added .gramon and .speakcz commands (Velesoft)

Known Bugs
----------

BASIC/Tape Emulator: You can overwrite ESXDOS system using LOAD CODE that crosses $2000
Commands: Proper argument/syntax checking is not done yet on most commands
Commands/BASIC: No wildcards yet
FAT Driver: +3DOS header is set on file creation and never updated when file size changes
FAT Driver: rename() isn't even remotely posix compliant
FAT Driver: Directories read-only attribute isn't always respected
BIOS: Version of system file isn't checked against the ROM version (bad things will happen if there's a mismatch)
TR-DOS: FORMAT and MOVE commands don't work yet + too many to list ;)

08.06.2013 / Papaya Dezign - All rights perversed