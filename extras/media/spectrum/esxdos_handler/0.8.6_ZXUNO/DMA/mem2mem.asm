ZXUNOADDR       equ 0FC3Bh
ZXUNODATA       equ 0FD3Bh
DMACTRL         equ 0A0h
DMASRC          equ 0A1h
DMADST          equ 0A2h
DMALEN          equ 0A4h
SCANDBLR        equ 0Bh

                org 32768

Main            ld hl,22528
                ld de,0110000001010000b
                ld b,12
LoopLines       push bc
                ld b,32
LoopYellow      ld (hl),d
                inc hl
                djnz LoopYellow
                ld b,32
LoopWhite       ld (hl),e
                inc hl
                djnz LoopWhite
                pop bc
                djnz LoopLines

                ld hl,0  ; initial source address.

Loop            xor a
                ld (23560),a  ;clear LAST-K

                halt    ;sync with interrupt
                ld bc,ZXUNOADDR
                ld a,(23560)
                cp "1"
                jr nz,Not7MHz
                ld a,0
                ld (DMAOption),a
                ld a,SCANDBLR
                out (c),a
                inc b
                in a,(c)
                and 3Fh
                or 40h
                out (c),a
                jr ExitOption
Not7MHz         cp "2"
                jr nz,Not14MHz
                ld a,0
                ld (DMAOption),a
                ld a,SCANDBLR
                out (c),a
                inc b
                in a,(c)
                and 3Fh
                or 80h
                out (c),a
                jr ExitOption
Not14MHz        cp "3"
                jr nz,Not28MHz
                ld a,0
                ld (DMAOption),a
                ld a,SCANDBLR
                out (c),a
                inc b
                in a,(c)
                and 3Fh
                or 0C0h
                out (c),a
                jr ExitOption
Not28MHz        cp "4"
                jr nz,ExitOption
                ld a,1
                ld (DMAOption),a
                ld a,SCANDBLR
                out (c),a
                inc b
                in a,(c)
                and 3Fh
                out (c),a
                jr ExitOption
ExitOption

                ld a,(DMAOption)
                or a
                jr nz,DoDMA

                ld a,2
                out (254),a

                ;-----------------------------------
                push hl
                ld de,16384
                ld bc,6144
                ldir
                pop hl
                ;-----------------------------------

                ld a,7
                out (254),a
                jr NextSource


DoDMA           ld de,899  ;a small delay so the DMA transfer begins somewhere
WaitScan        dec de      ;within the visible screen range
                ld a,d
                or e
                jr nz,WaitScan

                ld a,2
                out (254),a

                ;-----------------------------------
                ld bc,ZXUNOADDR
                ld de,16384

                ld a,DMADST
                out (c),a
                inc b
                out (c),e
                out (c),d    ;DMADST = 16384
                dec b
                ld a,DMALEN
                out (c),a
                inc b
                xor a
                out (c),a    ;0 (LSB DMA transfer length)
                ld a,24
                out (c),a    ;24 (MSB DMA transfer length) : LEN = 24*256+0=6144 bytes
                dec b
                ld a,DMASRC
                out (c),a
                inc b
                out (c),l
                out (c),h   ;DMASRC = address in HL (ROM)
                dec b

                ld a,DMACTRL
                out (c),a
                inc b

                ld a,1   ; MEM to MEM, BURST
                out (c),a
                ;-----------------------------------

                ld a,7
                out (254),a
                dec b

NextSource      inc hl
                ld a,h
                cp 40h
                jp nz,Loop

                ld bc,ZXUNOADDR
                ld a,SCANDBLR
                out (c),a
                inc b
                in a,(c)
                and 3Fh
                out (c),a
                dec b

                ret

DMAOption       db 1

                end Main

