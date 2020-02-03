;Picture viewer for Radastan mode (256x128x16)
;To generate a screen compatible with the Radastan mode:
; - Use a graphics tool, like Irfanview, to resize the picture to 128x96 with a palette of 16 colours
; - Save it as BMP without compression
; - Include it as a binary data into this source code

; To be assembled with PASMO --tapbas

RADASOFFSET    equ 41h
RADASPADDING   equ 42h
ZXUNOADDR      equ 0fch
ZXUNODATA      equ 0fdh
ZXIBASEADDR    equ 3bh

               org 33000
Main           di

               ;Convert BMP palette to ULAplus palette entry
               ld hl,Pantalla+36h  ;BMP palette offset. Format is BGRA
               ld bc,0bf3bh
               ld e,0
BucPaleta      out (c),e
               ld b,0ffh
               ld a,(hl)   ; blue
               sra a
               sra a
               sra a
               sra a
               sra a
               sra a
               and 3
               ld d,a
               inc hl
               ld a,(hl)   ; green
               and 11100000b
               or d
               ld d,a
               inc hl
               ld a,(hl)   ; red
               sra a
               sra a
               sra a
               and 00011100b
               or d
               out (c),a
               inc hl
               inc hl      ; skip the alpha byte
               ld b,0bfh
               inc e
               ld a,e
               cp 16
               jr nz,BucPaleta

               ld b,0fch  ;NEW! now this is how to enable Radastan mode
               ld a,64
               out (c),a  ;NEW! now this is how to enable Radastan mode
               ld b,0fdh
               ld a,3
               out (c),a

               xor a
               out (254),a

               ld hl,Pantalla+76h+127*128   ;offset to the last BMP stored scanline (the first we see on screen)
               ld de,16384                ;offset to the Spectrum screen buffer
               ld b,128
BucPintaScans  push bc
               ld bc,128
               ldir
               ld bc,-256
               add hl,bc
               pop bc
               djnz BucPintaScans

               ld a,82h
               ld i,a
               im 2

               ei

               ld c,ZXIBASEADDR
               ld b,ZXUNOADDR
               ld a,RADASPADDING
               out (c),a
               inc b
               ld a,64
               out (c),a

Forever        ld a,0   ;line
               ld hl,0  ;offset

Derecha1       halt
               ld b,ZXUNOADDR
               ld d,RADASOFFSET
               out (c),d
               inc b
               out (c),l
               out (c),h
               inc hl
               inc a
               cp 64
               jr nz,Derecha1
               dec hl
               xor a

BajaIzq        halt
               ld b,ZXUNOADDR
               ld d,RADASOFFSET
               dec hl
               out (c),d
               inc b
               out (c),l
               out (c),h
               halt
               ld de,127
               add hl,de
               ld d,RADASOFFSET
               dec b
               out (c),d
               inc b
               out (c),l
               out (c),h
               inc a
               cp 32
               jr nz,BajaIzq
               xor a

Derecha2       halt
               ld b,ZXUNOADDR
               ld d,RADASOFFSET
               out (c),d
               inc b
               out (c),l
               out (c),h
               inc hl
               inc a
               cp 64
               jr nz,Derecha2
               dec hl
               xor a

SubeIzq        halt
               ld b,ZXUNOADDR
               ld d,RADASOFFSET
               dec hl
               out (c),d
               inc b
               out (c),l
               out (c),h
               halt
               ld de,-129
               add hl,de
               ld d,RADASOFFSET
               dec b
               out (c),d
               inc b
               out (c),l
               out (c),h
               inc a
               cp 32
               jr nz,SubeIzq

               jp Forever


               org 82FFh
               dw NuevaIM2

NuevaIM2       rept 8
               nop
               endm
               ei
               reti

Pantalla       equ $
               incbin "lena256x128.bmp"  ; <-- put here the BMP you want to see. It must have 6262 bytes in length

               end Main
