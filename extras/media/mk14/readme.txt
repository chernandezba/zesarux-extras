clock.bin: load at 0f16h. run at 0f16h  (on mk14 keyboard: 0f16g)
duckshoot.bin: load at 0f20h. run at 0f23h
mastermind.bin. load at 0f1ch. run at 0f1ch . ;       Term: new game .  Mem: clear .  Go: process
moonlanding.bin. load at 0F14h. run at 0f52h.
;       Moon landing (MK14 Manual)
;
;       Keys 1-7 control the thrust
;
;	0f08	Alt,
;	0f0B	Vel,
;	0f0E	Acceleration,
;	0f10	Thrust,
;	0f12	Fuel

----

These examples got from the page http://www.dougrice.plus.com/dev/seg_mk14.htm

Many are written in hexadecimal format, like this: (clock):

:080F16001200000076404002C9
:180F2000C40137C40B33C40D36C40D32C40F35C41A3103C405C8DAC567
:180F3800FFEC00C900E904980498029002C900C100D40F01C380CE01B8
:180F5000C4408F00C1001C1C1C1C01C380CE02B8B09CD4C403C8AAC4DC
:180F68000001C5FFE1045801B89F9CF6019803409003C4070807C40276
:040F80008F1190A29B
:00000001FF

The format of every line is (looking at first line):
: no meaning
08 : length of the data
0F16 : address to load the data
00 : no meaning
1200000076404002 : efective data to write at 0F16
C9: some kind of checksum. just ignore it

So, you can write the first line on mk14, using ZEsarUX remote command protocol (ZRCP) with the command:

write-mapped-memory-raw 0F16H 120000007640400

The rest of the program is written with:

write-mapped-memory-raw 8F20H C40137C40B33C40D36C40D32C40F35C41A3103C405C8DAC5FFEC00C900E904980498029002C900C100D40F01C380CE01C4408F00C1001C1C1C1C01C380CE02B8B09CD4C403C8AAC40001C5FFE1045801B89F9CF6019803409003C4070807C4028F1190A2

Last line (:00000001FF) seems not to have meaning
