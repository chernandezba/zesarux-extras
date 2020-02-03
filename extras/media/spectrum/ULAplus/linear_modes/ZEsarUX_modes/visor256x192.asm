;Visor de pantallas simples modo 256x192
;Para generar una pantalla compatible con este modo:
; - Convertir una imagen RGB a 256x192, 16 colores paletizados
; - Grabarla como BMP sin compresión
; - Integrarla como archivo binario a este programa
;compilar con pasmo --tapbas visor256x192.asm salida.tap



;Mitad de pantalla empieza en 16384 y acaba en 28672
;La otra mitad de pantalla esta en RAM 7
;Como el bmp se lee del final hacia el principio, cuando vamos a conmutar a ram7, la lectura en el bmp ya esta por debajo de la 49152
;y no hay peligro de perder los datos que estamos leyendo
               org 28672


Main
		;saltamos a rutina del bmp para que no nos "pille" sobreescribiendo esta zona
		di
		ld sp,mipila
		jr Main2

;mas que suficiente para stack
                defs 10
mipila          equ $


               ;Convertir la paleta del BMP a paleta de ULAplus
Main2          ld hl,BMPFile+36h  ;offset de la paleta en los BMP. El formato de la paleta es BGRA
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
               ld a,9  ;256x192 (valor del registro: 9)
               out (c),a

               ld hl,BMPFile+76h+191*128   ;offset a la última línea del BMP (la primera en pantalla)
               ld de,16384                ;offset al comienzo de pantalla
               ld b,192
BucPintaScans  push bc
               ld bc,128
               ldir
               ld bc,-256
               add hl,bc
               pop bc
;si b=97, cambio pagina ram
		ld a,b
		cp 97
		jr nz,buc2
		push bc
		ld bc,32765
		ld a,16+7
		out (c),a
		pop bc
		;Incrementar destino
		push hl	
		ex de,hl
		ld de,32768-12288
		add hl,de
		ex de,hl
		pop hl
buc2

               djnz BucPintaScans

buclesinsalida jr buclesinsalida


BMPFile         equ $
               incbin "dragonballz.bmp"  ; <-- pon aqui el fichero BMP que quieras ver. Debe tener 24694 bytes de longitud


               end Main

