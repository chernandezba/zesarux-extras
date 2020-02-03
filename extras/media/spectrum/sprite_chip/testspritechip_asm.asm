;Compile with Z88DK with the command:
;z80asm -b testspritechip_asm.asm

	org 37152

;Routine establecesprite:
;Set X , Y coordinates on sprite table for a object
;Having origin X,Y and width and height (width & height counting sprite units, not pixels)
;For every sprite:
;Offset 0: Word. Sprite number. Unused yet
;Offset 2: Word. X Coordinate. 16 bit value
;Offset 4: Word. Y Coordinate. 16 bit value
;Offset 6: Byte. Atribute1:
;Offset 7: Byte. Atribute2:


;Note: there are some auxiliar routines in this assembler code not used by the sonic demo, 
;instead they are used on the basic program (to show the bouncing sprinte for example)

;Input parameters
xinicial:	defw 0
yinicial:	defw 0

;40x48
ancho:		defw 5
alto:		defw 6
sprites:	defw spr_sonic_stopped1   ;initially points to Sonic stopped sprite
atributosprite: defb 1
;End input parameters


;Working variables
xactual:	defw 0
anchoactual:	defw 0

yactual:	defw 0
altoactual:	defw 0



establecesprite:		ld ix,(sprites)

		ld hl,(alto)
		ld (altoactual),hl

		ld hl,(yinicial)
		ld (yactual),hl

;bucle para toda altura
bucle1:		

		;Establecer xactual, ancho
		ld hl,(ancho)
		ld (anchoactual),hl

		ld hl,(xinicial)
		ld (xactual),hl

bucle2:
;bucle para todo ancho

		;Establecer x sprite
		ld hl,(xactual)
		ld (ix+2),l
		ld (ix+3),h

		;Establecer y sprite
		ld hl,(yactual)
		ld (ix+4),l
		ld (ix+5),h

		;Establecer atributo sprite
		;ld a,(atributosprite)
		;ld (ix+6),a
		call meter_atributos_sprite
		nop
		nop
		nop

		;Incrementar puntero sprites
		ld de,40
		add ix,de

		;Incrementar x
		ld hl,(xactual)
		;Incremento de x,y para cada sprite
		;ld de,8
		call retorna_de_incremento_x
		add hl,de
		ld (xactual),hl

		;Decrementar ancho
		ld hl,(anchoactual)
		dec hl
		ld (anchoactual),hl
		ld a,h
		or l
		jr nz,bucle2


		;Decrementar alto e incrementar y
		call establece_sprite_incrementar_y
		;ld hl,(yactual)

		add hl,de

		ld (yactual),hl

		ld hl,(altoactual)
		dec hl
		ld (altoactual),hl
		ld a,h
		or l
		jr nz,bucle1

		ret



;Mostrar rebote pelota
incrementox:	defw 1
incrementoy:	defw 1
rebotar_pelota:
		;Borrar ultima tecla
		xor a
		ld (23560),a

bucle:		
		;esperar a interrupcion
		;halt
		
		;cambio el halt por un nop pues para no tener que reajustar los pokes del basic y que no se desplace 1 byte hacia abajo todo
		nop

		ld a,(atributosprite)
		;xor 1
		xor 0  ;no conmutar estado activo/inactivo
		ld (atributosprite),a
		;call establecesprite
		call establecesprite_y_scroll


		;Incrementar posiciones
		ld hl,(xinicial)
		ld de,(incrementox)
		add hl,de
		ld (xinicial),hl

		;Si es 0 o 255, rebote
		ld a,h
		or l
		jr nz,noxcero

		;Es 0, incremento se establece en 1
		ld hl,1
		ld (incrementox),hl

		jr siguey

noxcero:	;Si es 255
		ld a,l
		cp 255
		jr nz,siguey
		;Es 255. incremento se establece en -1
		ld hl,-1
		ld (incrementox),hl


siguey:

                ;Incrementar posiciones
                ld hl,(yinicial)
                ld de,(incrementoy)
                add hl,de
                ld (yinicial),hl

                ;Si es 0 o 191, rebote
                ld a,h
                or l
                jr nz,noycero

                ;Es 0, incremento se establece en 1
                ld hl,1
                ld (incrementoy),hl

                jr siguebuc

noycero:        ;Si es 191
                ld a,l
                cp 191
                jr nz,siguebuc
                ;Es 191. incremento se establece en -1
                ld hl,-1
                ld (incrementoy),hl

siguebuc:	;Ver si pulsada tecla
		ld a,(23560)
		or a
		jr z,bucle

		ret


;Convertir sprite leido de disco, formato lineal a formato tabla sprites
;Hay un ejemplo de sprite en testspritechip_sprite.tap, este ha salido del juego World destruction, y esta rutina lo puede convertir a formato del ZGX Sprite chip
;Variables entrada

;Inicio sprite
sprite_orig:	defw 0

;Destino tabla sprites
sprite_dest:	defw 0


;Ancho en bytes (pixeles sera spr_ancho*8)
spr_ancho:	defw 0

;Alto en pixeles/8
spr_alto:	defw 0

;Color a establecer para bits 1. Para bits 0, se mete color 0 (transparente)
spr_color_orig:	defb 0

;si esta a 0, se mantiene el color. Si esta diferente de 0, se cambia el color, incrementando a cada color
flag_cambio:	defb 0


;Variables trabajo
spr_contador_ancho:	defw 0

spr_contador_alto:	defw 0

;Color para parte superior del byte
spr_color_rotado: defb 0

sprite_orig_trabajo: defw 0


spr_color:	defb 0

		;inicio

		ld a,(spr_color_orig)
		ld (spr_color),a

		;inicio
		call establece_color

		ld hl,(spr_alto)
		ld (spr_contador_alto),hl


		ld ix,(sprite_orig)
		ld (sprite_orig_trabajo),ix

		;??? ld de,8
		;??? add ix,de


		;destino
		ld hl,(sprite_dest)
		;saltar los 8 bytes de cabecera
		ld de,8
		add hl,de
		ex de,hl

convert000:

		ld hl,(spr_ancho)
		ld (spr_contador_ancho),hl

		;Destino se guarda en de
		;Origen se guarda en ix

convert00:
		ld b,8
convert0:	push bc

		;Hacer este bucle 4 veces
		ld b,4
		ld a,(ix)

		;En a guardamos el byte que leemos

convert1:	;Leer primer byte y generar los 8 pixeles


		;byte final
		ld c,0
	

		;Byte parte superior	
		rlca
		jr nc,convert_nocol1

		;Meter color
		ex af,af'
		ld a,(spr_color_rotado)
		or c
		ld c,a
		ex af,af'

convert_nocol1:
		call cambio_color
		;Byte parte inferior
		rlca
		jr nc,convert_nocol2
		ex af,af'
		ld a,(spr_color)
		or c
		ld c,a
		ex af,af'



convert_nocol2:
		call cambio_color
		;Meter color destino
		ex af,af'
		ld a,c
		ld (de),a
		inc de
		ex af,af'

		djnz convert1


		;Siguiente linea de sprite
		;Incremento en origen es tanto como ancho
		ld bc,(spr_ancho)
		add ix,bc




		;Asi 8 veces
		pop bc

		djnz convert0

		;Incrementar contadores
		;Siguiente sprite de la derecha
		ld ix,(sprite_orig_trabajo)
		inc ix
		ld (sprite_orig_trabajo),ix


		;Siguiente sprite en destino, aumentar en 8 (salta la cabecera)
		ex de,hl
		ld de,8
		add hl,de
		ex de,hl

		;Tantas veces como ancho
		ld hl,(spr_contador_ancho)
		dec hl
		ld (spr_contador_ancho),hl
		ld a,h
		or l
		jr nz,convert00


		;Siguiente sprite de debajo
		ld ix,(sprite_orig)
		;Incrementar tanto ancho * 8
		ld hl,(spr_ancho)
		add hl,hl   ;*2
		add hl,hl   ;*4
		add hl,hl   ;*8

		push hl
		pop bc
		add ix,bc

		ld (sprite_orig),ix
		ld (sprite_orig_trabajo),ix


		;Tantas veces como alto
		ld hl,(spr_contador_alto)
		dec hl
		ld (spr_contador_alto),hl
		ld a,h
		or l
		jr nz,convert000


		ret

establece_color:
		ld a,(spr_color)
		rlca
		rlca
		rlca
		rlca
		ld (spr_color_rotado),a
		ret


cambio_color:

		push af

		ld a,(flag_cambio)
		or a 
		jr nz,cambio_color2

		ld a,(spr_color_orig)
		ld (spr_color),a
		jr cambio_color3


cambio_color2:

		;cambio color
		ld a,(spr_color)
		inc a
		cp 16
		jr nz,incremento_color
		ld a,1
incremento_color:
		ld (spr_color),a

cambio_color3:
		call establece_color

		pop af
		ret


incremento_x_sprite: defw 8
incremento_y_sprite: defw 8


;Para poder mantener la misma sentencia randomize usr del basic
moversprites_inicio:
		jp moversprites_inicio2


;Escribe caracteres ascii incrementandose, en total de BC veces

llenar_pantalla_caracteres_inc:
		ld d,33
llenar_pantalla_caracteres_inc2:
                ld a,d
                rst 16
                inc d
                ld a,d
                cp 128
                jr nz,llenar_pantalla_caracteres_inc3
		ld d,33

llenar_pantalla_caracteres_inc3:

                dec bc
                ld a,b  
                or c

                jr nz,llenar_pantalla_caracteres_inc2
		ret


moversprites_texto_inicio:
		;cls
		call 3503
		ld a,2
		call 5633

		;Llenar las 768 posiciones de pantalla con caracteres ascii
		ld bc,32*22
		call llenar_pantalla_caracteres_inc

		;Y luego 2 lineas del canal 0
		xor a
		call 5633

		call print_text
		defb 22,0,0,255

                ld bc,32*2
		call llenar_pantalla_caracteres_inc


		;Volver a abrir canal 2
		ld a,2
		call 5633

		call print_text
		defb 22,0,0
		;     01234567890123456789012345678901
		defm "Demo program of ZEsarUX sprite  "
		defb 13
		defm "video chip                      "
		defb 13
		defm "(c) Man Software (29/10/2015)   "
		defb 13
		defm "                                "
		defb 13
		defm "QAOP: Move sprite               "
		defb 13
		defm "WSKL: Scroll screen             "
		defb 13
		defm "D: Scroll parameters            "
		defb 13
		defm "B: Bounce & Last Scroll         "
		defb 13
		defm "F: Flash  C: Colour             " 
		defb 13
		defm "X: Zoom X  Y: Zoom Y            " 
		defb 13
		defm "N: Mirror X  M: Mirror Y        "
		defb 13
		defm "R: Redraw screen                "
		defb 13
		defm "E: Sonic Demo                   "
		defb 13
		defm "Space: Return to Basic          "
		defb 13
		defm "The following is an ASCII       "
		defm "pattern only to fill the screen "
		defm "                                "
		defb 255
		ret


;Rutina de movimiento de sprites
moversprites_inicio2:
		call sonicdemo_init_sprite_table
		call moversprites_texto_inicio



moversprites:	;call reset_last_key
		call establecesprite
moversprites_espera: 
		;halt
		;ld a,(23560)
		;or a
		;jr z,moversprites_espera
		ld a,251
		in a,(254)
		and 1
		jr nz,notecla_q
		ld hl,(yinicial)
		ld a,h
		or l
		jr z,notecla_q

		dec hl
		ld (yinicial),hl
		;jr moversprites


notecla_q: 	ld a,253
		in a,(254)
		and 1
		jr nz,notecla_a
		ld hl,(yinicial)
		ld a,l
		cp 191
		jr z,notecla_a
		inc hl
		ld (yinicial),hl
		;jr moversprites

notecla_a:	
		ld a,127
		in a,(254)
		and 1
		jr nz,notecla_espacio
		ret


notecla_espacio: 
		ld a,223
		in a,(254)
		and 2
		jr nz,notecla_o
		ld hl,(xinicial)
		ld a,h
		or l
		jr z,notecla_o
		dec hl
		ld (xinicial),hl
		;jr moversprites

notecla_o:
		ld a,223
		in a,(254)
		and 1
		jr nz,notecla_p
		ld hl,(xinicial)
		ld a,l
		cp 255
		jr z,notecla_p
		inc hl
		ld (xinicial),hl
		;jr moversprites
		


notecla_p:
		;1 flash 1
		ld a,253
		in a,(254)
		and 8
		jr nz,notecla_f
		ld a,(atributosprite)
		xor 32
		ld (atributosprite),a
		call espera_no_tecla

notecla_f:

		;b bounce
		ld a,127
		in a,(254)
		and 16
		call z,rebotar_pelota

		;c cambiar color
		ld a,254
		in a,(254)
		and 8
		jr nz,notecla_c

		call cambiocolor_sprite


notecla_c:
		ld a,254
		in a,(254)
		and 4
		jr nz,notecla_x

		;Conmutar Zoom X.
		;Si incremento es 8, pasa a 16
		;Si incremento es 16, pasa a 8
		;Si incremento es -8, pasa a -16
		;Si incremento es -16, pasa a -8

		ld hl,(incremento_x_sprite)
		call conmutar_incremento_zoom
		ld (incremento_x_sprite),hl

		;Conmutar bit de zoom x 
		ld a,(atributosprite)
		xor 8
		ld (atributosprite),a
		call espera_no_tecla

notecla_x:

                ld a,223
                in a,(254)
                and 16
                jr nz,notecla_y

                ;Conmutar Zoom Y.
                ld hl,(incremento_y_sprite)
                call conmutar_incremento_zoom
                ld (incremento_y_sprite),hl

                ;Conmutar bit de zoom y
                ld a,(atributosprite)
                xor 16
                ld (atributosprite),a
                call espera_no_tecla


notecla_y:

		;Tecla N mirror X
		ld a,127
		in a,(254)
		and 8
		jr nz,notecla_n


		;Cambiar signo al incremento
		ld bc,(incremento_x_sprite)
		ld hl,0
		or a
		sbc hl,bc
		ld (incremento_x_sprite),hl

		ld a,(atributosprite)
		xor 2
		ld (atributosprite),a
		call espera_no_tecla

notecla_n:


                ;Tecla M mirror Y
                ld a,127
                in a,(254)
                and 4
                jr nz,notecla_m

		;Cambiar signo al incremento
                ld bc,(incremento_y_sprite)
                ld hl,0
                or a
                sbc hl,bc
                ld (incremento_y_sprite),hl

                ld a,(atributosprite)
                xor 4
                ld (atributosprite),a
                call espera_no_tecla

notecla_m:

		;Tecla redibujar pantalla

		ld a,251
		in a,(254)
		and 8
		jr nz,notecla_r

		call moversprites_texto_inicio


notecla_r:

		;Tecla parametros scroll D
		ld a,253
		in a,(254)
		and 4
		jr nz,notecla_d
		call pregunta_parametros_scroll


notecla_d:

                ;Tecla scroll k

                ld a,191
                in a,(254)
                and 4
                jr nz,notecla_k

                ld a,3
                ld (scroll_tipo),a
                call send_parameters_scroll


notecla_k:

		;Tecla scroll l


		ld a,191
		in a,(254)
		and 2
		jr nz,notecla_l

		ld a,4
		ld (scroll_tipo),a
		call send_parameters_scroll

notecla_l:


                ;Tecla scroll w


                ld a,251
                in a,(254)
                and 2
                jr nz,notecla_w

                ld a,1
                ld (scroll_tipo),a
                call send_parameters_scroll


notecla_w:

                ;Tecla scroll s


                ld a,253
                in a,(254)
                and 2
                jr nz,notecla_s
                
                ld a,2
                ld (scroll_tipo),a
                call send_parameters_scroll


notecla_s:

		;Tecla sonic demo E

                ld a,251
                in a,(254)
                and 4
                jr nz,notecla_e

		call sonicdemo

		;Al volver, el ultimo sprite es el boss. Si la coordenada X del boss no es en pantalla, no se vera
		;ajustarla
		ld hl,128
		ld (xinicial),hl


		call moversprites_texto_inicio

notecla_e:
		jp moversprites

reset_last_key: 
		;Borrar ultima tecla
		xor a
		ld (23560),a
		ret

conmutar_incremento_zoom:

                ;Conmutar incremento de HL
                ;Si incremento es 8, pasa a 16
                ;Si incremento es 16, pasa a 8
                ;Si incremento es -8, pasa a -16
                ;Si incremento es -16, pasa a -8

		;Ver si negativo o positivo
		bit 7,h
		jr nz,conmutar_incremento_zoom_negativo

		;Es positivo
		ld a,l
		cp 8
		jr z,conmutar_incremento_zoom_8
		ld hl,8
		ret
conmutar_incremento_zoom_8:
		ld hl,16
		ret

conmutar_incremento_zoom_negativo:
		ld a,l
		cp -8
		jr z,conmutar_incremento_zoom_negativo_8
		ld hl,-8
		ret

conmutar_incremento_zoom_negativo_8:
		ld hl,-16
		ret

		ret


print_text_hl:	defw 0

print_text:
		;Guardamos hl
		ld (print_text_hl),hl
		pop hl

		;Guardamos AF
		push af

print_text1:
		ld a,(hl)
		inc hl
		cp 255
		jr z,print_textfin
		rst 16
		jr print_text1
print_textfin:	

		;Recuperamos AF
		pop af

		;Metemos direccion de retorno
		push hl

		;Recuperamos hl
		ld hl,(print_text_hl)
		ret

;Leer texto y guardar en posicion hl, maximo C bytes. Bytes leidos en B
input_text:
		ld b,0
input_text00:
		;Mostrar cursor
		call print_text
		defb 18,1,'K',18,0,8,255
input_text0:	
		call reset_last_key
input_text1:	ld a,(23560)
		or a
		jr z,input_text1
		;Si enter, volver
		cp 13
		jr nz,input_text_no13
		ld (hl),255
		ld a,' '
		rst 16
		ret	

input_text_no13:
		;si 12, borrar, si b>0
	 	cp 12
		jr nz,input_text_no12
		ld a,b
		or a
		jr z,input_text0
		call print_text
		defb ' ',8,8,255

		dec hl
		dec b
		jr input_text00

input_text_no12:
		;Si entre 32 y 127, meter letra
		cp 32
		jr c,input_text0
		cp 128
		jr nc,input_text0
		;Si llega al maximo de letras
		ex af,af'
		ld a,b
		cp c
		jr z,input_text0
		ex af,af'

		ld (hl),a
		inc hl
		inc b
		rst 16
		jr input_text00

buf_parametro_scroll: defm "1234"


pregunta_parametros_scroll:
		call print_text
		defb 22,14,0
		defm "X? (between 0 and 31)"
		defb 255
		ld hl,buf_parametro_scroll
		ld c,2

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
		ld (scroll_x),a

                call print_text
                defb 22,14,0
                defm "Y? (between 0 and 191)"
                defb 255
                ld hl,buf_parametro_scroll
                ld c,3

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
                ld (scroll_y),a

                call print_text
                defb 22,14,0
                defm "Width? (between 1 and 32)"
                defb 255
                ld hl,buf_parametro_scroll
                ld c,2

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
                ld (scroll_ancho),a

                call print_text
                defb 22,14,0
                defm "Height? (between 1 and 192)"
                defb 255
                ld hl,buf_parametro_scroll
                ld c,3

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
                ld (scroll_alto),a


                call print_text
                defb 22,14,0
                defm "How many pixels? (between 1 and 8)"
                defb 255
                ld hl,buf_parametro_scroll
                ld c,1

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
                ld (scroll_pixeles),a


                call print_text
                defb 22,14,0
                defm "Fill type? (0=0, 1=1, 2=circular)"
                defb 255
                ld hl,buf_parametro_scroll
                ld c,1

                push hl
                call input_text
                pop hl

                call rutina_atoi
                ld a,e
                ld (scroll_relleno),a


		ret


buf_color:      defm "123"

buf_colour_type: defm "12"

buf_palette:	defm "12"

cambiocolor_sprite_err:
		call print_text
		defm " Invalid colour"
		defb 255
		ret


cambiocolor_sprite:

		call print_text
		defb 22,14,0
		defm "Colour type? (0=normal,1=spectra,2=ulaplus)"
		defb 255
		ld hl,buf_colour_type
		ld c,1

                push hl
                call input_text
                pop hl

		call rutina_atoi
		ld a,e
		and 3

		;Si tipo 1 o 2, pedir numero paleta
		cp 1
		jr z,cambiocolor_sprite_pide_paleta
		cp 2
		jr z,cambiocolor_sprite_pide_paleta
		jr cambiocolor_sprite_pide_paleta_sigue

cambiocolor_sprite_pide_paleta:
		push af

		call print_text
		defb 13
		defm "Palette number? (0=colours 0-15, 1=16-31, 2=32-47, 3=48-63)"
		defb 255

		ld hl,buf_palette
		ld c,1
                push hl
                call input_text
                pop hl
		call rutina_atoi
		ld a,e
		and 3
		rlca
		rlca
		ld e,a
		pop af
		or e

cambiocolor_sprite_pide_paleta_sigue:
		
		ld (atributosprite2),a


		call print_text
		defb 13
		defm "Colour? (1-15). Write i for"
		defb 13
		defm "incremental colour"
		defb 13,255

		ld hl,buf_color
		ld c,2

		push hl
		call input_text
		pop hl

		ld a,(hl)
		cp 'i'
		jr nz,cambiocolor_sprite_no_i
		ld a,0
		jr cambiocolor_sprite_i

cambiocolor_sprite_no_i:
	
		;Parsear numero
		call rutina_atoi


		;Color en DE. Realmente usamos solo E

		;Color 0 significa cambio de color a cada pixel

		;Color en E
		ld a,e
		cp 0
		jp z,cambiocolor_sprite_err
		cp 16
		jp nc,cambiocolor_sprite_err

cambiocolor_sprite_i:
		ld (spr_color),a
		ld (spr_color_orig),a

		;Calculamos color para parte alta y baja del byte
		call establece_color
		;Cambiamos colores que no sean 0 por el valor


		ld hl,(sprites)
		;Inicio tabla

		;Incrementar HL en 8 (saltar cabecera)
		;call incremento_hl_y_mete_atr2

		;Bucle para alto
		ld bc,(alto)

cambiocolor_sprite1:
		push bc
		;Bucle para ancho
		ld bc,(ancho)

cambiocolor_sprite2:


		call incremento_hl_y_mete_atr2
		

		push bc
		;Bucle para 8 bytes de alto dentro del sprite

		ld b,8

cambiocolor_sprite3:
		push bc

		;Bucle para 4 bytes de ancho del sprite
		ld b,4

cambiocolor_sprite4:
		push bc

		;Color final
		ld e,0

		call cambiocolor_si_incrementa

		;Leer byte de color
		ld a,(hl)
		
		push af
		;Parte alta del byte. Si es 0 dejamos tal cual, sino, metemos color
		and 240
		jr z,cambiocolor_sprite_sicero


		ld a,(spr_color_rotado)
		ld e,a

cambiocolor_sprite_sicero:

		;Parte baja del byte
		call cambiocolor_si_incrementa

		pop af
		and 15
		jr z,cambiocolor_sprite_sicero2

		ld a,(spr_color)
		or e
		jr cambiocolor_sprite_sicero3

cambiocolor_sprite_sicero2:
		ld a,e
cambiocolor_sprite_sicero3:
		ld (hl),a
		inc hl

		;Para 4 bytes
		pop bc
		djnz cambiocolor_sprite4

		;Para 8 de alto sprite
		pop bc
		djnz cambiocolor_sprite3

		;Siguiente sprite. Incrementar HL en 8
		;call incremento_hl_y_mete_atr2

		;Para ancho todos sprites
		pop bc
		dec bc
		ld a,b
		or c
		jr nz,cambiocolor_sprite2

		;Para alto todos sprites
		pop bc
		dec bc
		ld a,b
		or c
		jr nz,cambiocolor_sprite1

		ret


		;Si color se incrementa
cambiocolor_si_incrementa:
		ld a,(spr_color_orig)
		or a
		ret nz 
		ld a,(spr_color)
		inc a
		cp 16
		jr nz,cambiocolor_si_incrementa2
		ld a,1
cambiocolor_si_incrementa2:
		ld (spr_color),a
		call establece_color
		ret


;Parsear ascii a numero
;Entrada: HL direccion
;Salida: DE valor


rutina_atoi:	ld de,0

rutina_atoi_buc:	
		ld a,(hl)
		inc hl
		cp 255
		jr nz,rutina_atoi2
		;Volver
		ret

rutina_atoi2:	
		;Multiplicar DE*10. DE*10=DE*(8+2)=DE*8+DE*2
		push hl
		ld h,d
		ld l,e
		add hl,hl ;*2
		push hl
		add hl,hl ;*4
		add hl,hl ;*8
		pop de
		add hl,de ;*10

		;Ascii '0'=48
		sub 48

		;Sumar valor a HL
		ld e,a
		ld d,0
		add hl,de
		ex de,hl ;Resultado en DE

		pop hl ;recuperar puntero
		
		jr rutina_atoi_buc


espera_no_tecla:
		call lee_todas_teclas
		cp 31 
		jr nz,espera_no_tecla
		ret

espera_tecla:
		call lee_todas_teclas
                cp 31
                jr z,espera_tecla
                ret

lee_todas_teclas:
                xor a
                in a,(254)
                and 31
		ret


retorna_de_incremento_x:
		ld de,(incremento_x_sprite)
		ret

retorna_de_incremento_y:
		ld de,(incremento_y_sprite)
		ret


establece_sprite_incrementar_y:
		call retorna_de_incremento_y
                ld hl,(yactual)
		ret



atributosprite2: defb 0

meter_atributos_sprite:
                ;Establecer atributo sprite
                ld a,(atributosprite)
                ld (ix+6),a
                ;ld a,(atributosprite2)
                ;ld (ix+7),a
		ret



                ;Incrementar HL en 8 (saltar cabecera)
incremento_hl_y_mete_atr2:
                inc hl
                inc hl
                inc hl
                inc hl
                inc hl
                inc hl
                inc hl
                ;Meter atributo sprite2
                ld a,(atributosprite2)
                ld (hl),a
                inc hl
		ret


;Envia comando D con valor A a sprite chip
send_command_spritechip:
		ld bc,03F1H
		out (c),d
		;data port es 04F1
		inc b
		out (c),a
		ret


;Esperar a que finalice scroll en curso
scroll_wait_finish:
		ld d,9
		ld bc,03F1H
		out (c),d
		inc b

scroll_wait_finish_buc:
		in a,(c)
		jr nz,scroll_wait_finish_buc
		ret

scroll_x:	defb 0
scroll_y:	defb 0
scroll_ancho:	defb 255
scroll_alto:	defb 255
scroll_pixeles:	defb 1
scroll_relleno: defb 2
scroll_tipo:	defb 4



;Enviar parametros scroll
send_parameters_scroll:
;Esperar a que finalice scroll en curso

		call scroll_wait_finish

		ld d,3
		ld a,(scroll_x)
		call send_command_spritechip

		inc d
		ld a,(scroll_y)
		call send_command_spritechip

		inc d
		ld a,(scroll_ancho)
		call send_command_spritechip

		inc d
		ld a,(scroll_alto)
		call send_command_spritechip

		inc d
		ld a,(scroll_pixeles)
		call send_command_spritechip

		inc d
		ld a,(scroll_relleno)
		call send_command_spritechip

		inc d
		ld a,(scroll_tipo)
		call send_command_spritechip

		ret



establecesprite_y_scroll:
                call establecesprite

		;Repetir ultimo scroll
		call send_parameters_scroll
		ret


sonicdemo:
		call espera_no_tecla

		;Volcar fondo
		ld hl,sonic_background
		ld de,16384
		ld bc,6912
		ldir



		call sonicdemo_init_sprite_table


		;Mostrar boss
		call sonic_set_sprite_boss


		;Quieto
		ld a,0
		ld (sonic_state),a
		call sonic_reset_current_sprite


		;Parpadeante hasta que se pulse tecla

		
                ld a,(atributosprite)
                or 32
                ld (atributosprite),a
		call sonic_set_current_sprite


		;Mostrar teclas
		call print_text
		defb 22,0,0,17,5,16,0
		defm "QAOP: Move",13
		defm "SPC: Return"	
		defb 255


		call espera_tecla

	
		;Borrar teclas
                call print_text
                defb 22,0,0,17,5,16,4
                defm "          ",13
                defm "           "
                defb 255

		ld a,(atributosprite)
		and 255-32
		ld (atributosprite),a

		call sonic_set_current_sprite
			


sonic_lee_tecla:


		;Cuando se entra aqui es porque no hay tecla pulsada. Mover boss
		call mover_sprite_boss
		call sonic_set_sprite_boss


		;lee tecla 
		;Si espacio, volver
		ld a,127
		in a,(254)
		and 1
		jr nz,sonic_lee_no_tecla_espacio
		;volver
		ret

sonic_lee_no_tecla_espacio:

		;Si tecla Q
		ld a,251
		in a,(254)
		and 1
		jr nz,sonic_lee_no_tecla_q

		call sonic_saltar
		jr sonic_lee_tecla


sonic_lee_no_tecla_q:
		;Si tecla A
		ld a,253
		in a,(254)
		and 1
		jr nz,sonic_lee_no_tecla_a

		call sonic_agachar
		jr sonic_lee_tecla

sonic_lee_no_tecla_a:
		;Si tecla p
		ld a,223
		in a,(254)
		and 1
		jr nz,sonic_lee_no_tecla_p
		;tecla P

		;Scroll
                ld a,3
                ld (scroll_tipo),a


		;Si ya tiene atributo de ir a la derecha, no tocar
		ld a,(atributosprite)
		bit 1,a
		jr z,sonic_andando_inicio

		;Invertir signo incremento
		ld bc,(incremento_x_sprite)
		ld hl,0
		or a
		sbc hl,bc
		ld (incremento_x_sprite),hl

		;Quitar bit mirror		
		ld a,(atributosprite)
		and 253
		ld (atributosprite),a

		jr sonic_andando_inicio

sonic_lee_no_tecla_p:
		;Si tecla o
		ld a,223
		in a,(254)
		and 2
		jr nz,sonic_lee_tecla

		;Tecla O
		;Poner scroll derecha, con mirror y caminar izquierda

		;scroll
                ld a,4
                ld (scroll_tipo),a

		;Si ya tiene atributo de ir a la izquierda, no tocar
		ld a,(atributosprite)
		bit 1,a
		jr nz,sonic_andando_inicio

		;Invertir signo incremento
		ld bc,(incremento_x_sprite)
		ld hl,0
		or a
		sbc hl,bc
		ld (incremento_x_sprite),hl

		;Poner bit mirror
		ld a,(atributosprite)
		or 2
		ld (atributosprite),a


		jr sonic_andando_inicio


sonic_andando_inicio:
		call sonic_reset_current_sprite
		;Velocidad lenta
		ld a,0
		ld (sonic_speed),a

sonic_andando_reiniciar_paso:
		;Andando
		ld a,1
		ld (sonic_state),a


		;Asi para todos los pasos
		ld a,1
		ld (sonic_walking_pass),a

sonic_andando_buc:
		
                call sonic_set_current_sprite


		call sonic_wait_and_scroll

		call sonic_reset_current_sprite

		ld a,(sonic_walking_pass)
		inc a
		ld (sonic_walking_pass),a
		cp 7 
		jr nz,sonic_andando_buc

		;Si hay tecla pulsada, aumentar velocidad y repetir
		call lee_todas_teclas
		cp 31
		jr z,sonic_andando_buc_fin

                ;Aumentar velocidad
                ld a,(sonic_speed)
		cp velocidad_maxima
		jr z,sonic_andando_buc_speed0
                inc a
                ld (sonic_speed),a
sonic_andando_buc_speed0:
		jr sonic_andando_reiniciar_paso

sonic_andando_buc_fin:
		;Finalmente lo dejamos quieto y mostramos
		ld a,0
		ld (sonic_state),a
		call sonic_set_current_sprite


		jp sonic_lee_tecla	




sonic_wait_and_scroll:
                call sonic_wait
                ;Repetir ultimo scroll, pero alterando cuantos pixeles se mueve

		ld a,(sonic_speed)
		inc a
		ld (scroll_pixeles),a

		;Aumentar o disminuir coordenada x de boss segun si izquierda o derecha

		ld c,a
		ld b,0
		ld a,(scroll_tipo)
		cp 3
		jr nz,sonic_wait_and_scroll_izquierda
		;Convertir bc en negativo, para restar X a posicion boss
		ld h,0
		ld l,0
		or a
		sbc hl,bc
		ld c,l
		ld b,h
		


sonic_wait_and_scroll_izquierda:
		;Sumar BC a posicion boss
		ld hl,(boss_x)
		add hl,bc
		ld (boss_x),hl



;Mover tambien boss como siempre. Da sensacion de multitarea
                call mover_sprite_boss


		;Y redibujar boss
		call sonic_set_sprite_boss

		;Nota: Segun donde se dibuja el boss o sonic, al ir al maximo de velocidad sonic,
		;puede ser que el sonic no se vea, o el boss se vea desplazado sus sprites al correr,
		;esto se aprecia mas con zoom x,y en los sprites

                call send_parameters_scroll

		;Y redibujar boss
		;call sonic_set_sprite_boss
		ret


;Desactiva (pone a 0) sprite actual
;Realmente hace mas cosas en la rutina (pone x,y), pero lo hacemos para reaprovechar la rutina de establecesprite
sonic_reset_current_sprite:
		ld a,(atributosprite)
		and 254
		ld (atributosprite),a
		jr sonic_set_current_sprite2

;Activa (pone a 1) sprite actual
sonic_set_current_sprite:
                ld a,(atributosprite)
		or 1
                ld (atributosprite),a

sonic_set_current_sprite2:
		call sonic_return_current_sprite
                ld (sprites),hl

                ld hl,(sonic_x)
                ld (xinicial),hl

                ld hl,(sonic_y)
                ld (yinicial),hl

                ld hl,5
                ld (ancho),hl

                ld hl,6
                ld (alto),hl


                call establecesprite

		ret


sonicdemo_init_sprite_table:

                ;desactivar sprite chip
;Envia comando D con valor A a sprite chip
                ;comando 0
                ld d,0
                ;valor 0
                xor a
                call send_command_spritechip



                ;Establecer tabla sprites
                ld hl,tabla_sprites

                ;Byte bajo
                ld d,1
                ld a,l
                call send_command_spritechip

                ;Byte alto
                ld d,2
                ld a,h
                call send_command_spritechip


                ;activar sprite chip

                ;comando 0
                ld d,0
                ;valor 1
                ld a,1
                call send_command_spritechip

		ret

;Retorna sprite actual a sonic segun si esta quieto, andando, etc

sonic_return_current_sprite:
		ld a,(sonic_state)
		cp 0
		jr nz,sonic_return_current_sprite_no_stopped
		ld hl,spr_sonic_stopped1
		ret

sonic_return_current_sprite_no_stopped:
		;Esta corriendo?
		cp 1
		jr nz,sonic_return_current_sprite_no_running


		;En que paso esta andando?
		ld a,(sonic_walking_pass)
		cp 1
		jr nz,sonic_return_current_sprite_walking_no1
		ld hl,spr_sonic_walking1
		ret

sonic_return_current_sprite_walking_no1:
		cp 2
                jr nz,sonic_return_current_sprite_walking_no2
                ld hl,spr_sonic_walking2
                ret

sonic_return_current_sprite_walking_no2:
                cp 3
                jr nz,sonic_return_current_sprite_walking_no3
                ld hl,spr_sonic_walking3
                ret

sonic_return_current_sprite_walking_no3:
                cp 4
                jr nz,sonic_return_current_sprite_walking_no4
                ld hl,spr_sonic_walking4
                ret

sonic_return_current_sprite_walking_no4:
                cp 5
                jr nz,sonic_return_current_sprite_walking_no5
                ld hl,spr_sonic_walking5
                ret

sonic_return_current_sprite_walking_no5:
		;Suponemos que cualquier otro es 6
		ld hl,spr_sonic_walking6
		ret


sonic_return_current_sprite_no_running:
		;Esta saltando?
                cp 2
                jr nz,sonic_return_current_sprite_no_jumping

                ;En que paso esta saltando?
                ld a,(sonic_jumping_pass)
                cp 1
                jr nz,sonic_return_current_sprite_jumping_no1
                ld hl,spr_sonic_rolling1
                ret

sonic_return_current_sprite_jumping_no1:
                cp 2
                jr nz,sonic_return_current_sprite_jumping_no2
                ld hl,spr_sonic_rolling2
                ret

sonic_return_current_sprite_jumping_no2:
                cp 3
                jr nz,sonic_return_current_sprite_jumping_no3
                ld hl,spr_sonic_rolling3
                ret

sonic_return_current_sprite_jumping_no3:
		;Estara en paso 3
                ld hl,spr_sonic_rolling4
                ret


sonic_return_current_sprite_no_jumping:
		;Suponemos que esta agachado
		ld hl,spr_sonic_agachado1
		ret

;8= rapido. no halt
;0=lento. = 8 halt
sonic_wait:	;Run halt
		ld a,(sonic_speed)
		cp velocidad_maxima
		ret z

		;Restamos 8-valor speed
		ld b,a
		ld a,velocidad_maxima
		sub b

sonic_wait2:	halt
		dec a
		jr nz,sonic_wait2
		ret



;Activa (pone a 1) sprite boss 
sonic_set_sprite_boss:
                ld a,(atributosprite)
                or 1
                ld (atributosprite),a

                ld hl,sonic_boss
                ld (sprites),hl

                ld hl,(boss_x)
                ld (xinicial),hl

                ld hl,(boss_y)
                ld (yinicial),hl

                ld hl,10
                ld (ancho),hl

                ld hl,8
                ld (alto),hl


                call establecesprite

                ret


sonic_saltar:
;Y inicial 56
;Subir 20 pixeles
;Y volver a bajar

		call sonic_reset_current_sprite

		;scroll 1 pixel
		ld a,1
		ld (scroll_pixeles),a

		;Subiendo

		;scroll abajo
		ld a,2
		ld (scroll_tipo),a

		;Y llenar con 0
		ld a,0
		ld (scroll_relleno),a	

		;Y sonic saltando
		ld a,2
		ld (sonic_state),a



		ld hl,-1
		ld (incremento_sonic_saltar_aux),hl
		call sonic_saltar_aux



		;Bajando
	        ;scroll arriba
                ld a,1
                ld (scroll_tipo),a

                ;Y llenar con 1
                ld a,1
                ld (scroll_relleno),a

		ld hl,1
		ld (incremento_sonic_saltar_aux),hl
		call sonic_saltar_aux

		call sonic_reset_current_sprite

		;Dejar scroll relleno circular
		ld a,2
		ld (scroll_relleno),a	

		;Y sonic quieto
		ld a,0
		ld (sonic_state),a

		call sonic_set_current_sprite

		ret

incremento_sonic_saltar_aux: defw 1

sonic_saltar_aux:		

		ld bc,16
		ld hl,(sonic_y)

		;En E guardamos un contador para cambiar sprite de salto 1 de cada 4 veces
		ld e,0

sonic_saltar_subiendo:

		push bc
		push hl
		push de

		call sonic_set_current_sprite
		call sonic_set_sprite_boss
		;halt
		call send_parameters_scroll


		pop de
		inc e
		ld a,e
		and 3
		cp 3
		jr nz,sonic_saltar_subiendo2
		;Siguiente estado 1 de cada 2 veces para que no haga parpadeo
		push de
		halt
		call sonic_reset_current_sprite
		call sonic_saltando_siguiente
		pop de

sonic_saltar_subiendo2:

;Modificar tambien posicion y boss pero al contrario
;Dado que al saltar el sonic desplaza todo el paisaje hacia abajo, los sprites que haya presentes en pantalla tambien deben bajar
		ld hl,(boss_y)
		ld bc,(incremento_sonic_saltar_aux)
		or a
		sbc hl,bc
		ld (boss_y),hl

;Modificar tambien posicion X del jefe. Da sensacion de "multi" tarea ;)
		push de
                call mover_sprite_boss
                ;call sonic_set_sprite_boss
		pop de


		pop hl

		ld bc,(incremento_sonic_saltar_aux)
		add hl,bc

		ld (sonic_y),hl
		pop bc

		dec bc
		ld a,b
		or c
		jr nz,sonic_saltar_subiendo

		ret






;Siguiente estado rolling
sonic_saltando_siguiente:
		ld a,(sonic_jumping_pass)
		inc a
		cp 5
		jr nz,sonic_saltando_siguiente2
		ld a,1
sonic_saltando_siguiente2:
		ld (sonic_jumping_pass),a
		ret
		

sonic_agachar:
		call sonic_reset_current_sprite

		ld a,3
		ld (sonic_state),a

		call sonic_set_current_sprite


sonic_agachar_buc:
		call lee_todas_teclas
		cp 31
		jr z,sonic_agachar_fin

		;Mientras esta agachado mover el boss. Da sensacion de "multi" tarea ;)
                call mover_sprite_boss
                call sonic_set_sprite_boss
		jr sonic_agachar_buc


sonic_agachar_fin:

		call sonic_reset_current_sprite

		ld a,0
		ld (sonic_state),a
		call sonic_set_current_sprite

		ret

;El jefe tiene un movimiento bastante absurdo. Se mueve entre las posiciones 0 y 512
;Tener en cuenta que cuando sonic se mueve altera estas posiciones tambien, sin tener en cuenta este incremento
;por tanto este movimiento del jefe no es correcto del todo. Lo hago solo para mostrar que se pueden mover otros sprites
;en background sin problemas
mover_sprite_boss:
		;Aumentar posicion
		ld hl,(boss_x)
		ld bc,(boss_incremento_x)
		add hl,bc
		ld (boss_x),hl

		;Ver en que posicion esta
		;Si es 0
		ld a,h
		or l
		jr z,mover_sprite_boss_conmutar

		;Si es 512
		ld a,h
		cp 2
		ret nz

mover_sprite_boss_conmutar:
		;Conmutar signo incremento
		ld bc,(boss_incremento_x)
		ld hl,0
		or a
		sbc hl,bc
		ld (boss_incremento_x),hl
		ret

		

spritesonic:


;Velocidad 0 significa hacer 7 halt y hacer scroll de 1 pixel
;Velocidad 1 significa hacer 6 halt y hacer scroll de 2 pixel
;...
;Velocidad 7 significa hacer 0 halt y hacer scroll de 8 pixel
DEFC velocidad_maxima = 7



;Sonic state. 
;0 stopped
;1 walking
;2 jumping
;3 agachado
sonic_state:	defb 0

;State walking: 1..6
sonic_walking_pass: defb 1

sonic_jumping_pass: defb 1


;sonic speed. Indicates how many halt do we run after every move
sonic_speed:	defb 0


sonic_x:	defw 128
sonic_y:	defw 56


;El jefe esta fuera de pantalla
boss_x:		defw 512
boss_y:		defw 0
boss_incremento_x: defw -1

;Inicio tabla sprites. Cada sonic ocupa 30 sprites. Boss ocupa 10x8. Total sprites: 30*12+10x8=440
tabla_sprites:	defw 440

spr_sonic_walking1:
include "sonic_sprite_40x48_andando_1.asm"

spr_sonic_walking2:
include "sonic_sprite_40x48_andando_2.asm"

spr_sonic_walking3:
include "sonic_sprite_40x48_andando_3.asm"

spr_sonic_walking4:
include "sonic_sprite_40x48_andando_4.asm"

spr_sonic_walking5:
include "sonic_sprite_40x48_andando_5.asm"

spr_sonic_walking6:
include "sonic_sprite_40x48_andando_6.asm"

spr_sonic_stopped1:
include "sonic_sprite_40x48_quieto_1.asm"

spr_sonic_rolling1:
include "sonic_sprite_40x48_rolling_1.asm"

spr_sonic_rolling2:
include "sonic_sprite_40x48_rolling_2.asm"

spr_sonic_rolling3:
include "sonic_sprite_40x48_rolling_3.asm"

spr_sonic_rolling4:
include "sonic_sprite_40x48_rolling_4.asm"

spr_sonic_agachado1:
include "sonic_sprite_40x48_agachado_1.asm"



sonic_boss:
include "sonicboss_80x64.asm"


		defm "SONICSCR"
sonic_background:
;incbin "avantgreenhill01_recoloreado.png.scr"

