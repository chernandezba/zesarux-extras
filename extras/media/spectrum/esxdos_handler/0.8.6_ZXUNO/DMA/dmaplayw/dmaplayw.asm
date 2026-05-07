; (C)2017 AZXUNO association.
; This file is part of dmaplayw, part of the ZX-UNO project.
; 
;     dmaplayw is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
; 
;     dmaplayw is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
; 
;     You should have received a copy of the GNU General Public License
;     along with dmaplayw.  If not, see <http://www.gnu.org/licenses/>.

                    org 2000h

include "esxdos.inc"
include "errors.inc"

ZXUNOADDR           equ 0fch
ZXUNODATA           equ 0fdh
ZXIBASEPORT         equ 3bh
DMACTRL             equ 0a0h
DMASRC              equ 0a1h
DMADST              equ 0a2h
DMAPRE              equ 0a3h
DMALEN              equ 0a4h
DMAPROB             equ 0a5h
DMASTAT             equ 0a6h

SPECDRUM            equ 0ffdfh

LBUFFER             equ 2048
PREESCALER          equ 223  ; la cuenta va de 0 a 223, es decir, 224 ciclos

Main                ld a,h
                    or l
                    jp nz,Init

                    ld hl,UsageStr
BucPrintMsg         ld a,(hl)
                    or a
                    ret z
                    rst 10h
                    inc hl
                    jr BucPrintMsg

RecogerNFile        ;HL apunta a los argumentos (nombre del fichero)
                    ld de,BufferNFich
CheckCaracter       ld a,(hl)
                    or a
                    jr z,FinRecoger
                    cp " "
                    jr z,FinRecoger
                    cp ":"
                    jr z,FinRecoger
                    cp 13
                    jr z,FinRecoger
                    ldi
                    jr CheckCaracter
FinRecoger          xor a
                    ld (de),a
                    inc de   ;DE queda apuntando al buffer este que se necesita en OPEN, no sé pa qué.
                    ret

UsageStr
                    ;   01234567890123456789012345678901
                    db " .dmaplayw audiofile.wav",13,13
                    db "Plays an audio file using the",13
                    db "SpecDrum and DMA at 15.625 kHz",13,0

Init                call RecogerNFile  ;results DE = buffer for OPEN
                    xor a
                    rst 08h
                    db M_GETSETDRV  ;A = unidad actual
                    ld b,FA_READ    ;B = modo de apertura
                    ld hl,BufferNFich   ;HL = Puntero al nombre del fichero (ASCIIZ)
                    rst 08h
                    db F_OPEN
                    ret c   ;Volver si hay error
                    ld (FHandle),a

                    ld l,0  ;SEEK_START
                    ld bc,0
                    ld de,44 ;skip 44 bytes from start (WAV header)
                    rst 08h
                    db F_SEEK
                    ret c

                    ld hl,16384
                    ld de,16385
                    ld bc,31
                    ld (hl),255
                    ldir
                    ;this line will be deleted on the first wave plot.

                    ld hl,BufferPlay
                    ld de,BufferPlay+1
                    ld bc,LBUFFER-1
                    ld (hl),0
                    ldir
                    ;Clear DMA buffer

PrepareToPlay       di
                    ld hl,BufferPlay  ;begin of circular play buffer
                    ld bc,ZXUNOADDR*256+ZXIBASEPORT
                    ld a,DMASRC
                    out (c),a
                    inc b
                    out (c),l
                    out (c),h
                    dec b

                    ld a,DMADST
                    out (c),a
                    inc b
                    ld hl,SPECDRUM
                    out (c),l
                    out (c),h
                    dec b

                    ld a,DMAPRE
                    out (c),a
                    inc b
                    ld hl,PREESCALER
                    out (c),l
                    out (c),h
                    dec b

                    ld a,DMALEN
                    out (c),a
                    inc b
                    ld hl,LBUFFER
                    out (c),l
                    out (c),h
                    dec b

                    ld a,DMAPROB
                    out (c),a
                    inc b
                    ld hl,BufferPlay
                    out (c),l
                    out (c),h
                    dec b

                    ld a,DMACTRL
                    out (c),a
                    inc b
                    ld a,00000111b  ;mem to I/O, redisparable, timed, se comprueba direccion fuente
                    out (c),a
                    dec b

PlayLoop            ld bc,7ffeh   ;SPACE halfrow
                    in a,(c)
                    and 1
                    jp z,ExitPlay

                    ld bc,ZXUNOADDR*256+ZXIBASEPORT
                    ld a,DMASTAT
                    out (c),a
                    inc b
StillInSecondHalf   in a,(c)
                    bit 7,a
                    jr z,StillInSecondHalf

                    dec b
                    ld a,DMAPROB
                    out (c),a
                    inc b
                    ld hl,BufferPlay+LBUFFER/2
                    out (c),l
                    out (c),h
                    dec b
                    ld a,DMASTAT
                    out (c),a
                    inc b
                    in a,(c)

                    ;fill second half of buffer with audio data
                    ld hl,BufferPlay+LBUFFER/2
                    ld bc,LBUFFER/2
                    ld a,(FHandle)
                    rst 08h
                    db F_READ
                    jp c,ExitPlay  ;si error, fin de lectura
                    ld a,b
                    or c
                    jp z,ExitPlay  ;si no hay más que leer, fin de lectura

                    ld hl,BufferPlay+LBUFFER/2
                    call PlotWave

                    ld bc,ZXUNOADDR*256+ZXIBASEPORT
                    ld a,DMASTAT
                    out (c),a
                    inc b
StillInFirstHalf    in a,(c)
                    bit 7,a
                    jr z,StillInFirstHalf

                    dec b
                    ld a,DMAPROB
                    out (c),a
                    inc b
                    ld hl,BufferPlay
                    out (c),l
                    out (c),h
                    dec b
                    ld a,DMASTAT
                    out (c),a
                    inc b
                    in a,(c)

                    ;fill first half of buffer with audio data
                    ld hl,BufferPlay
                    ld bc,LBUFFER/2
                    ld a,(FHandle)
                    rst 08h
                    db F_READ
                    jp c,ExitPlay  ;si error, fin de lectura
                    ld a,b
                    or c
                    jp z,ExitPlay  ;si no hay más que leer, fin de lectura

                    ld hl,BufferPlay
                    call PlotWave

                    jp PlayLoop

ExitPlay            ld bc,ZXUNOADDR*256+ZXIBASEPORT
                    ld a,DMACTRL
                    out (c),a
                    inc b
                    xor a
                    out (c),a
                    dec b

                    ld a,(FHandle)
                    rst 08h
                    db F_CLOSE

                    or a   ;clear carry
                    ei
                    ret

FHandle             db 0

PlotWave            ld de,BufferBorrado
                    ld c,0
LoopWave            ld a,(de)
                    ld b,a
                    call Plot
                    ld a,(hl)
                    srl a
                    add a,24
                    ld b,a
                    call Plot
                    ld a,b
                    ld (de),a
                    inc hl
                    inc de
                    inc c
                    jp nz,LoopWave
                    ret

Plot            ;B=y, C=x
                push bc
                push de
                push hl
                ld e,b
                ld d,0  ;DE=y
                sla e
                rl d    ;DE=DE*2
                ld hl,DirScan
                add hl,de  ;HL=puntero a la direccion del primer pixel de Y.
                ld e,(hl)
                inc hl
                ld d,(hl)
                ex de,hl  ;HL=dir primer pixel fila Y
                ld d,c    ;Guardo coordenada X en D
                ld a,c
                srl a
                srl a
                srl a
                ld c,a
                ld b,0
                add hl,bc  ;HL contiene la direccion a pintar del pixel
                ld a,d   ;Recupero coordenada X
                and 7
                ld de,DirBits
                add a,e
                ld e,a
                ld a,d
                adc a,0
                ld d,a
                ld a,(de)
                xor (hl)
                ld (hl),a
                pop hl
                pop de
                pop bc
                ret

DirBits         db 10000000b
                db 01000000b
                db 00100000b
                db 00010000b
                db 00001000b
                db 00000100b
                db 00000010b
                db 00000001b

include "dir_scans.inc"

BufferBorrado       ds 256

BufferNFich         equ $   ;resto de la RAM para el nombre del fichero

BufferPlay          equ 8000h

