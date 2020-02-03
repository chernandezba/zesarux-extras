;
;    ZEsarUX  ZX Second-Emulator And Released for UniX
;    Copyright (C) 2013 Cesar Hernandez Bano
;
;    This file is part of ZEsarUX.
;
;    ZEsarUX is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;Compile with Z88DK with the command:
;z80asm -b tstfile5.asm
;
;Simple test to load data from the .nex file handle (12 characters at the end of the snapshot),
;and print that string on the screen
;file handler is saved at address 50000, as told in the header (offsets 140 and 141)
;After compiling it, I modified the snapshot tstfile5_load_data.nex writing this binary code starting at offset 3200h
;I used my own ZEsarUX menu tools (load filemen, load binary, hex editor) to modify the tstfile5_load_data.nex

;this tstfile5_load_data.nex is a derived snapshot from https://github.com/ped7g/ZXSpectrumNextMisc/tree/master/nexload2/tmHiRes.nex
;I modified it to reuse the esxdos/NextOS file handle and added the 12 characters at the end  (and of course, included this binary code)

		org 32768
	

		di
		ld a,(50000)
		ld bc,12
		ld ix,40000
		rst 8
		;fread
		defb 9dh  

;I use my own functions to cls and print character
;as I haven't booted regular Basic ROM and I can't use rst 16
;But I do have the character map
;The print routines are the same I used on my PrismBootRom.asm code

		call cls

		xor a
		ld (print_coord_x),a
		ld (print_coord_y),a

		ld hl,40000
buc:		ld a,(hl)
		cp 10
		jr z,endbuc
		call print_character
		inc hl
		jr buc
endbuc:		jr endbuc



cls:
		ld hl,16384
		ld de,16385
		ld bc,6143
		ld (hl),0
		ldir

		inc hl
		inc de
		ld bc,767
		ld (hl),56
		ldir

		ret



;Print character routine
;Modified registers: AF'
print_character:
		push af
		push bc
		push hl

		ex af,af'
		ld a,(print_coord_x)
		ld c,a
		ld a,(print_coord_y)
		ld l,a
		ex af,af'

		;If character 13, line feed
		cp 13
		jr nz,print_character_no13

		call print_character_line_feed
		jr print_character_continues

print_character_no13:

		push bc
		push hl
		call print_char_lowlevel
		pop hl
		pop bc

		inc c
		ld a,c
		cp 32
		call z,print_character_line_feed

print_character_continues:
		ld a,c
		ld (print_coord_x),a

		ld a,l
		ld (print_coord_y),a

		pop hl
		pop bc
		pop af

		ret

print_character_line_feed:
		ld c,0
		inc l
		ld a,l
		cp 24
		ret nz
		ld l,23
		ret


print_char_lowlevel:

                                        ;Convert line, column to spectrum display
                                        ;     high byte          low byte
                                        ;bit  7 6 5 4 3 2 1 0  7 6 5 4 3 2 1 0
                                        ;     0 1 0 L L S S S  L L L C C C C C

		ex af,af'
		;In C, column, in L, line. In A, character
		ld a,l
		and 8+16
		or 64
		ld d,a

		ld a,l
		rlca
		rlca
		rlca
		rlca
		rlca

		and 128+64+32
		or c
		ld e,a
		ex af,af'

		;DE have the target

		;Get source on HL
		ld l,a
		ld h,0
		add hl,hl
		add hl,hl
		add hl,hl
		;char table-256
		ld bc,15360 
		add hl,bc

		;Loop 8 pixels

		ld b,8
print_char_lowlevel_loop:

		ld a,(hl)
		ld (de),a

		inc hl
		inc d

		djnz print_char_lowlevel_loop

		ret

;Variables.
print_coord_x: defb 0
print_coord_y: defb 0
