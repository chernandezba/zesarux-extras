;Compilar con pasmo --tapbas readline_bin.asm readline_bin.tap

reg_port equ 243BH
value_port equ 253BH
lineas equ 23298

;Puedes leer la linea raster que retorna tbblue desde 23296 y 23297
;se puede poner una pausa modificando 23298 y generando de esa manera que el raster se desplaza hacia abajo
;ver programa basic readline_bas.tap como ejemplo de uso

	org 32768
	di

	ld a,1
	ld (lineas),a

	ld hl,inicio_int
	ld (0feffH),hl
	ld a,0feh
	ld i,a
	im 2
	ei
	ret

pausa
	ld b,30
pausa2
	djnz pausa2
	ret

lee_raster
	ld bc,reg_port
	ld a,30
	out (c),a

	inc b
	in a,(c)
	ld (23296),a

	dec b

        ld a,31
        out (c),a

        inc b
        in a,(c)
        ld (23297),a

	ret

inicio_int 	
		rst 56
		push af
		push bc


		ld a,(lineas)
retardolineas
		call pausa
		dec a
		jr nz,retardolineas

		xor a
		out (254),a

		ld a,7
		out (254),a

		call lee_raster

		pop bc
		pop af
		reti


