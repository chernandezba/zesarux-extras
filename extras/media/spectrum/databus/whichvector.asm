;whichvector: a small utility to peek at the data bus to find out
;which hardware vector triggered an IM 2 interrupt.
;    Copyright (C) 2025 Miguel Angel Rodriguez Jodar
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

UDG                     equ 23675

                        org 60B0h

Main                    proc

                        ;Toda la pantalla a negro
                        xor a
                        out (254),a
                        ld hl,4000h
                        ld de,4001h
                        ld bc,6911
                        ld (hl),a
                        ldir

                        ;Definir un cuadrado en UDG "A"
                        ld hl,(UDG)
                        ld (hl),255
                        ld b,6
BucleUDG                inc hl
                        ld (hl),129
                        djnz BucleUDG
                        inc hl
                        ld (hl),255

                        ;Pintar 256 cuadrados. Serán nuestros
                        ;visores para ver qué vector se usa

                        ;AT 0,0;PAPER 1;BRIGHT 1
                        ld a,22
                        rst 10h
                        xor a
                        rst 10h
                        rst 10h
                        ld a,17
                        rst 10h
                        ld a,1
                        rst 10h
                        ld a,19
                        rst 10h
                        ld a,1
                        rst 10h

                        ld b,0
BuclePintaCuadros       ld a,144  ;UDG "A"
                        rst 10h
                        djnz BuclePintaCuadros

                        di
                        call FillInterruptTable
                        call CreateHandlers

BucleTestIRQ            ld a,0feh
                        ld i,a
                        im 2
                        xor a
                        ld (23670),a
                        ei

                        org 60FFh  ;la instrucción tras HALT estará en 6100h
                        halt  ;espera interrupción

                        di    ;cuando ocurre la interrupción, PC apunta aquí.
                        ld a,(23670)
                        ld e,a
                        ld d,0
                        ld hl,22528
                        add hl,de
                        ld (hl),01110000b   ;paper 6;bright 1
                        jr BucleTestIRQ
                        endp

EndIntr                 proc          ;todos los vectores mueren aquí
                        ld (23670),a  ;guardo el vector en memoria, y adios interrupciones
                        ld a,3fh
                        ld i,a
                        im 1
                        ei
                        reti
                        endp

FillInterruptTable      proc
                        ld de,258
                        ld bc,7078h    ;dirección de comienzo de la IRQ
                        ld hl,0fe00h
LoopFillTable           ld (hl),b
                        inc hl
                        dec de
                        ld (hl),c
                        inc hl
                        dec de
                        inc b          ;Esto va metiendo: 70 78 71 79 72 80, etc... en los vectores de interrupción
                        inc c
                        ld a,d
                        or e
                        jr nz,LoopFillTable
                        ret
                        endp

CreateHandlers          proc
                        ld bc,EndIntr
                        ld hl,0fe00h  ;ahora me vuelvo a pasar por la tabla de vectores
LoopCreateHandlers      ld e,(hl)
                        inc hl
                        ld d,(hl)     ;tengo en DE el comienzo de la rutina de interrupción para ese vector
                        ld a,3eh    ;LD A,n
                        ld (de),a
                        inc de
                        ld a,l      ;n
                        dec a
                        ld (de),a
                        inc de
                        ld a,195    ;JP addr    En cada rutina pongo un LD A,vector ; JP EndIntr
                        ld (de),a
                        inc de
                        ld a,c      ;low byte addr
                        ld (de),a
                        inc de
                        ld a,b      ;high byte addr
                        ld (de),a
                        inc de
                        ld a,l
                        or a
                        jr nz,LoopCreateHandlers
                        ret
                        endp

                        end Main
