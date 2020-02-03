ZXUNOADDR           equ 0fc3bh      ; puertos E/S de acceso
ZXUNODATA           equ 0fd3bh      ; a los registros de ZXUNO
RASTERLINE          equ 0ch         ; registros encargados de la
RASTERCTRL          equ 0dh         ; interrupción ráster
RADASMODE           equ 40h         ; registro para activar el modo radastaniano

ULAPLUSADDR         equ 0bf3bh      ; puertos estándar de
ULAPLUSDATA         equ 0ff3bh      ; ULAplus
ULAPLUSMODE         equ 40h         ; registro de control de ULAplus


                    org 65000
Main                di
                    xor a           ; border 0
                    out (254),a
                    ld a,0fdh       ; vector es FDFF
                    ld i,a
                    im 2
                    jp Init

                    org 0fdffh
                    dw NuevaIM2_line192  ;gestor de interrupcion que se lanza cuando llegamos a la linea 192

Init                ld bc,ZXUNOADDR
                    ld a,RADASMODE
                    out (c),a
                    inc b
                    ld a,3
                    out (c),a        ; activamos modo radastaniano

                    dec b
                    ld a,RASTERLINE
                    out (c),a
                    inc b
                    ld a,192
                    out (c),a        ; establecemos disparo de INT cuando la ULA esté a punto de comenzar a pintar la linea 192

                    dec b
                    ld a,RASTERCTRL
                    out (c),a
                    inc b
                    ld a,110b        ; activamos INT raster y desactivamos INT normal de la ULA
                    out (c),a

                    ;estos bucles anidados pintan 16 filas de cuadraditos, cada fila contiene 16 cuadraditos de 8x6 pixeles
                    ;con los valores de pixel de 0 a 15.
                    ;los cuadraditos de más a la izquierda (el primero de cada fila) lo pondremos siempre a negro
                    ;para hacerlo coincidir con el valor del borde y así tener un color de borde uniforme aunque se
                    ;cambie la paleta
                    ld de,0
                    ld b,6
LoopFilas             push bc
                      ld a,0
                      ld b,16
LoopColumnas            push bc
                        ld b,4
LoopPixeles               ld hl,16384+64*6*0
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*1
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*2
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*3
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*4
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*5
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*6
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*7
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*8
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*9
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*10
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*11
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*12
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*13
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*14
                          add hl,de
                          ld (hl),a
                          ld hl,16384+64*6*15
                          add hl,de
                          ld (hl),a
                          inc de
                          djnz LoopPixeles
                        pop bc
                        add a,11h
                        djnz LoopColumnas
                      pop bc
                      djnz LoopFilas
                    ei                 ;que comience el espectáculo!!!

Forever             halt               ;nos rascamos la barriga
                    ld a,7fh
                    in a,(0feh)
                    bit 0,a            ;y solo echamos cuenta si se pulso SPACE, para salir
                    jp nz,Forever

                    di
                    im 1               ;restablecemos modo 1 de interrupciones
                    ld bc,ZXUNOADDR
                    ld a,RASTERCTRL
                    out (c),a
                    inc b
                    xor a
                    out (c),a          ;restablecemos INT normales de la ULA

                    dec b
                    ld a,RADASMODE
                    out (c),a
                    inc b
                    xor a
                    out (c),a          ;quitamos modo radastaniano

                    ei
                    ret

PaletaInicial       db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15   ;paleta inicial ULAplus para modo radastaniano
NextColor           db 0

;gestor de interrupción que se lanza justo al terminar de pintar el paper, para preparar el siguiente frame
;la primera linea del borde inferior es la linea 192. Hasta que se vuelve a pintar el paper pasan 312-192=120 lineas
;y como cada linea son 224 estados, tenemos 26880 estados para prepararlo todo (de sobra)
NuevaIM2_line192    ld d,0
                    ld hl,PaletaInicial     ;rellenamos la paleta ULAplus con un gradiente con los 16 colores de PaletaInicial
LoopPaleta            ld bc,ULAPLUSADDR
                      out (c),d
                      ld bc,ULAPLUSDATA
                      ld a,(hl)
                      out (c),a
                      inc hl
                      inc d
                      cp 10h
                      jr nz,LoopPaleta

                    ld bc,ZXUNOADDR
                    ld a,RASTERLINE
                    out (c),a
                    inc b
                    ld a,12                 ;la siguiente interrupción ráster la dispararé en la linea 12 (después de haber pintado las 6 primeras filas de pixeles radastanianos)
                    out (c),a
                    ld hl,NuevaIM2_line12ysig    ;y usaré otro gestor de interrupción un poco diferente
                    ld (0fdffh),hl

                    ld a,10h
                    ld (NextColor),a        ;llevo la cuenta del proximo color que tengo que meter en la paleta (hasta el color FFh)

                    ei
                    reti

NuevaIM2_line12ysig ld a,(NextColor)        ;recuperamos el siguiente color a poner
                    ld e,a
                    xor a
                    ld bc,ULAPLUSADDR
                    out (c),a
                    ld bc,ULAPLUSDATA
                    out (c),a               ;la primera de las 16 entradas es siempre el color negro
                    inc a
                    inc e
                    ld d,15                 ;las otras 15 sí serán los colores que siguen al que se guardó en NextColor
LoopQuarterPal        ld bc,ULAPLUSADDR     ;este bucle actualiza la paleta que acaba de dejar de ser usada.
                      out (c),a             ;el programa siempre va usando una paleta para pintar colores, mientras
                      ld bc,ULAPLUSDATA     ;la anterior está siendo actualizada. Como tenemos 4 paletas (lo que yo
                      out (c),e             ;he llamado "cachos de paleta ULAplus") tenemos 3 paletas listas para usarse
                      inc a                 ;mientras actualizo la cuarta.
                      inc e
                      dec d
                      jr nz,LoopQuarterPal

                    ld a,e
                    ld (NextColor),a

                    ld bc,ZXUNOADDR
                    ld a,RASTERLINE
                    out (c),a
                    inc b
                    in a,(c)
                    add a,12                ;establecemos la próxima INT para 12 lineas más adelante de la actual (esto son 6 lineas radastanianas)
                    out (c),a
                    cp 192                  ;si la linea donde va la INT es la 192...
                    jr nz,NotLine192
                    ld hl,NuevaIM2_line192  ;... entonces volver a cambiar el gestor por el gestor que inicializa todo el frame de nuevo
                    ld (0fdffh),hl

NotLine192          ei
                    reti

                    end Main
