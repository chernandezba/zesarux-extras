Files in this folder are examples of ZXMMC+ and Residos:

- card1_residos_plus3dos.mmc: SD/MMC card image for residos, with some examples. Set it as the first SD/MMC card
- card2_bootrom_snaps.mmc: SD/MMC card image for ZXMMC+ boot rom, with some snapshots already saved. Set it as the second SD/MMC card
- residos-example.tap: Simple basic file that loads an example from the card1_residos_plus3dos.mmc image
- taskman.pkg: NMI task switcher for residos
- taskman.txt: Information about taskman

Quickstart with the bootrom:

- Do a Reset to open the bootrom menu
- Press Z to execute a 48k rom patched (NMI patched routines)
- Trigger a NMI then press R to generate a snapshot on flashrom
- Press T on bootrom menu to restore a snapshot from flashrom
- Having a MMC card formated for snapshots, you will see on the bootrom menu the saved snapshots
- Press Q,W or E on NMI patched rom to generate a snapshot on the MMC card formated for snapshots

See zesarux-extras/extras/docs/zxmmcplus for more info
