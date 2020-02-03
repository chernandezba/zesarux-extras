;Visor de pantallas simples modo 128x192
;Para generar una pantalla compatible con este modo:
; - Convertir una imagen RGB a 128x192, 16 colores paletizados
; - Grabarla como BMP sin compresión
; - Integrarla como archivo binario a este programa
;Compilar con pasmo --tapbas visorxxx.asm outputfile.tap

               org 32768
Main           di

               ;Convertir la paleta del BMP a paleta de ULAplus
               ld hl,Pantalla+36h  ;offset de la paleta en los BMP. El formato de la paleta es BGRA
               ld bc,0bf3bh
               ld e,0
BucPaleta      out (c),e
               ld b,0ffh
               ld a,(hl)   ; azul
               sra a
               sra a
               sra a
               sra a
               sra a
               sra a
               and 3
               ld d,a
               inc hl
               ld a,(hl)   ; verde
               and 11100000b
               or d
               ld d,a
               inc hl
               ld a,(hl)   ; rojo
               sra a
               sra a
               sra a
               and 00011100b
               or d
               out (c),a
               inc hl
               inc hl      ; nos saltamos el byte de "alpha"
               ld b,0bfh
               inc e
               ld a,e
               cp 16
               jr nz,BucPaleta

               ld bc,0fc3bh
               ld a,64
               out (c),a
               ld b,0fdh
               ld a,5  ;128x192 (valor del registro: 5)
               out (c),a

               ld hl,Pantalla+76h+191*64   ;offset a la última línea del BMP (la primera en pantalla)
               ld de,16384                ;offset al comienzo de pantalla
               ld b,192
BucPintaScans  push bc
               ld bc,64
               ldir
               ld bc,-128
               add hl,bc
               pop bc
               djnz BucPintaScans

buclesinsalida jr buclesinsalida

               ei

               ld bc,0
               call 7997 ;PAUSE 0

               ld bc,0fc3bh
               ld a,64
               out (c),a
               ld b,0fdh
               xor a
               out (c),a

               ret


Pantalla       equ $
               incbin "dog_silueta_128x192.bmp"  ; <-- pon aqui el fichero BMP que quieras ver. Debe tener 12406 bytes de longitud

               end Main
