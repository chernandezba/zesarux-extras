This testspr2 followed an old spec of sprite bits:

					OLD
					[0] 1st: X position (bits 7-0).
					[1] 2nd: Y position (0-255).
					[2] 3rd: bits 7-4 is palette offset, bit 3 is X mirror, bit 2 is Y mirror, bit 1 is visible flag and bit 0 is X MSB.
					[3] 4th: bits 7-6 is reserved, bits 5-0 is Name (pattern index, 0-63).

					NEW
					[0] 1st: X position (bits 7-0).
					[1] 2nd: Y position (0-255).
					[2] 3rd: bits 7-4 is palette offset, bit 3 is X mirror, bit 2 is Y mirror, bit 1 is rotate flag and bit 0 is X MSB.
					[3] 4th: bit 7 is visible flag, bit 6 is reserved, bits 5-0 is Name (pattern index, 0-63).


So patched the binary, changing two bytes according new specs



command@cpu-step> d 20a0h 10
20A0 INC A
20A1 LD (IX+05),A
20A4 LD A,(IX+00)
20A7 ADD A,A
20A8 OUT (C),A
20AA LD A,(IX+01)
20AD OUT (C),A
20AF LD A,02
20B1 ADC A,00
20B3 OUT (C),A


20B5 LD A,40h  -> 192  (visible flag)
20B7 SUB H
20B8 OUT (C),A


Para enviar bien el bit de visible
command@cpu-step> write-mapped-memory 20b6h 192


20B5H 3E 40 94 ED 79 DD 19 25 20 B3 3E 7F DB FE 1F DA  |>@..y..% .>....|
20C5H 5F 20 AF C9 81 18 01 01 FE 03 1C 70 01 F1        |_ .........p..|




Para que no haga rotate:
20AF LD A,02
command@cpu-step> write-mapped-memory 20b0h 0 (do not rotate)

20AFH 3E 02 CE 00 ED 79 3E C0 94 ED 79 DD 19 25 20 B3  |>....y>...y..% .|
20BFH 3E 7F DB FE 1F DA 5F 20 AF C9 25 6C 01 01        |>...._ ..%l..|



b0 (176)-> 0
b6 (182) -> 192
