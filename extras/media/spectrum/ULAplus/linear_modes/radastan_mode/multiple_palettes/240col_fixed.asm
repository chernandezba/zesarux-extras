ZXUNOADDR           equ 0fc3bh      ; puertos E/S de acceso
ZXUNODATA           equ 0fd3bh      ; a los registros de ZXUNO
RASTERLINE          equ 0ch         ; registros encargados de la
RASTERCTRL          equ 0dh         ; interrupción ráster
RADASMODE           equ 40h         ; registro para activar el modo radastaniano
RADASPALBANK        equ 43h         ; registro para cambiar qué cuarto de paleta ULAplus usamos

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
                    ld a,RADASPALBANK
                    out (c),a
                    inc b
                    ld a,0             ;restituimos el banco 0 de paleta para modo radastaniano
                    out (c),a

                    dec b
                    ld a,RADASMODE
                    out (c),a
                    inc b
                    xor a
                    out (c),a          ;quitamos modo radastaniano

                    ei
                    ret


                    ;la primera entrada de cada grupo de 16 entradas es el color negro. Como el borde es 0 (entrada 0 de la paleta), pues
                    ;siempre se pinta de color negro y no se ve "feo" por los cambios de paleta.
                    ;debido a esto, este programa no muestra los 256 colores posible de ULAplus, sino 240, y además se notará que el borde
                    ;izquierdo es ligeramente más grueso que el derecho (porque la primera columna de cuadrados también será negra)
PaletaInicial       db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15   ;cacho 0  |  Mientras la ULA va pintando pixeles con el cacho N, el
                    db 0,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31   ;cacho 1  |  gestor de interrupción va actualizando el cacho N-1
                    db 0,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47   ;cacho 2  |  Después del cacho 3, viene el cacho 0 de nuevo
                    db 0,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63   ;cacho 3  |
NextPalEntry        db 0
NextColor           db 0

;gestor de interrupción que se lanza justo al terminar de pintar el paper, para preparar el siguiente frame
;la primera linea del borde inferior es la linea 192. Hasta que se vuelve a pintar el paper pasan 312-192=120 lineas
;y como cada linea son 224 estados, tenemos 26880 estados para prepararlo todo (de sobra)
NuevaIM2_line192    ld bc,ZXUNOADDR
                    ld a,RADASPALBANK
                    out (c),a
                    inc b
                    ld a,0             ;usamos el cacho de paleta 0 (entradas 0 a 15)
                    out (c),a

                    ld d,0
                    ld hl,PaletaInicial     ;rellenamos la paleta ULAplus con un gradiente con los 64 primeros colores
LoopPaleta            ld bc,ULAPLUSADDR     ;pero cuidando de que las entradas de la paleta 0,16,24,32,48 sean el negro, para que el
                      out (c),d             ;borde no cambie cuando cambiemos de paleta (mirar PaletaInicial para entender cómo funciona esto)
                      ld bc,ULAPLUSDATA
                      ld a,(hl)
                      out (c),a
                      inc hl
                      inc d
                      ld a,d
                      cp 40h
                      jr nz,LoopPaleta

                    ld bc,ZXUNOADDR
                    ld a,RASTERLINE
                    out (c),a
                    inc b
                    ld a,12                 ;la siguiente interrupción ráster la dispararé en la linea 12 (después de haber pintado las 6 primeras filas de pixeles radastanianos)
                    out (c),a
                    ld hl,NuevaIM2_line12ysig    ;y usaré otro gestor de interrupción un poco diferente
                    ld (0fdffh),hl

                    ld a,40h
                    ld (NextColor),a        ;llevo la cuenta del proximo color que tengo que meter en la paleta (hasta el color FFh)
                    ld a,0
                    ld (NextPalEntry),a     ;y la cuenta de en qué entrada de paleta tengo que ponerlo

                    ei
                    reti

NuevaIM2_line12ysig ld bc,ZXUNOADDR
                    ld a,RADASPALBANK
                    out (c),a
                    inc b
                    in a,(c)                ;paso del cacho actual de paleta ULAplus
                    inc a                   ;al siguiente cacho
                    and 3                   ;modulo 4, para que la secuencia sea 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2.......
                    out (c),a

                    ld a,(NextColor)        ;recuperamos el siguiente color a poner
                    ld e,a
                    ld a,(NextPalEntry)     ;y la siguiente entrada de paleta donde lo pondremos
                    ld bc,ULAPLUSADDR
                    out (c),a
                    ld bc,ULAPLUSDATA
                    ld d,0                  ;pero la primera entrada (de las 16) de este cacho de paleta será el color negro siempre
                    out (c),d
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

                    and 3fh                 ;si me paso de entrada de paleta, volver a 0 (modulo 64)
                    ld (NextPalEntry),a
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
