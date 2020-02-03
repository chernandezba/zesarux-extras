; #########################################################################
; #                                                                       #
; #                        NOTAS ABRIL / 2019                             #
; #                                                                       #
; # Este listado es exactamente igual al que obtuve en 1988 no tiene      #
; # ninguna modificación excepto la de haberlo pasado a texto UTF8 para   #
; # Windows, por que originalmente era un TEXTO DOS puro usando la página #
; # de códigos 437. (recomiendo su lectura usando alguna fuente de        #
; # Windows monoespaciada con Notepad++ o Texpad, para ello he cambiado   #
; # cualquier caracter TAB (chr9) por espacios                            #
; #                                                                       #
; # Contiene además ligeros cambios sintácticos para que pueda ser        #
; # ensamablado con emsambladores Z80 actuales como por ejemplo SJASMPLUS #
; #                                                                       #
; # Fin de notas: Abril/2019                                              #
; #                                                                       #
; #########################################################################

; #########################################################################
; #                                                                       #
; #                Desensamble de la ROM HiLow V1.3E                      #
; #                                                                       #
; # Este listado en assembler Z80, produce un binario de 8KB exactamente  #
; # igual a la ROM del dispositivo de almacenamiento HiLow para Spectrum  #
; #                                                                       #
; # El listado está preparado para ser ensamblado con SJASMPLUS, haciendo #
; # un binario de nombre hilow.rom exactamente igual a la ROM HiLow V1.3E #
; #                                                                       #
; # NOTA:     El diseño y programación de este dispositivo para Spectrum  #
; #           pertenece a: Juan Arias, Carlos Galucci, Roberto Eimer      #
; #           Ramiro Arias y Alfredo Mussio.                              #
; #                                                                       #
; #########################################################################

; Si fuiste un usuario del ensamblador para Spectrum GENS, debes tener
; en cuenta lo siguiente para poder guiarte mejor:

;       1)      Cada etiqueta en este fuente termina con dos puntos ':'
;               no es obligatorio, pero SJASM lo acepta y hace más legible
;               el listado.

;       2)      En el GENS se usa la notación #NN para indicar un número
;               en base 16, aquí se usa la notación $NN teniendo el mismo
;               significado.

; =============================================================================

                OUTPUT  "hilow.rom"

; ORIGEN
                IFNDEF  ORIGEN
                DEFINE  ORIGEN  $0000
                ENDIF

                DEFINE  VERSION "1.3E"

; Definición del nemónico "LD A,Ix" muy usado en esta ROM

                DEFINE  LDA_Ix  DEFB $DD,$7C

                ORG     ORIGEN

                ; =============================
                ;      DIRECCIONES RESTART
                ;  (ver comentarios al margen)
                ; =============================

START:          DI                      ;RST 00H el ejecutarse el RET en
                LD      SP,L1016+3      ;en L0052 (y por lo tanto se produce
                JP      L0052           ;despaginación) saltaría a #21FF en
                DEFS    $01,$00         ;la ROM normal provocando un RESET.
                                        ;no veo que utilidad tiene esto...

                                        ;NOTA: Cualquier DEFS que se encuentre
                                        ;en este fuente deber ser ensamblado
                                        ;como espacio libre rellenados con
                                        ;ceros para que quede exactamente igual
                                        ;a la ROM original.

RST08:          DEFS    $08,$00         ;RST 08H no hace nada, en principio
                                        ;por contener 0's ejecuta un RST 10H
                                        
RST10:          RST     18H             ;RST 10H al usar el RST 18H con un
                DEFW    RST10           ;DEFW $0010, tiene la misma función
                RET                     ;que el RST 10H de la ROM normal.
                DEFS    $04,$00

RST18:          JP      L05A8           ;RST 18H sirve para llamar a una
                DEFS    $05,$00         ;rutina de la ROM normal, cuya
                                        ;dirección se indique a continuación
                                        ;con un DEFW

RST20:          LD      B,$FF           ;RST 20H imprime un mensaje cuyos
                JP      L0989           ;bytes se indican a partir de la
                DEFS    $03,$00         ;dirección DE, los códigos son impresos
                                        ;hasta que B=0 o (DE)=0

RST28:          JP      PR_ERRMSG       ;RST 28H imprime los mensajes
                DEFS    $05,$00         ;de error del HiLow, cuyo nro. viene
                                        ;indicado en A.

RST30:          INC     SP              ;RST 30H despagina el HiLow
                INC     SP              ;retornando al elemento de pila
L0032:          EI                      ;inmediatamente anterior.
                JR      L0052           ;Tiene como función el retorno con
                DEFS    $03,$00         ;las int. activadas a la ROM normal.

RST38:          PUSH    AF              ;RST 38H (rutina de servicio IM1)
                LD      A,$01           ;simplemente pone un uno en L3EED,
                LD      (L3EED),A       ;tiene la función de indicar cual es
                POP     AF              ;el modo de interrupcion activo en el
                EI                      ;momento de ejecutar la NMI
                RET                     ;(ver etiqueta NOTA2)

WINDOW1:        DEFB    $01,$01,$03,$03 ;Estos bytes definen el mapa de bits
                DEFB    $03,$03,$03,$03 ;(tipo UDG) para imprimir en pantalla
                DEFB    $03,$03,$03,$03 ;la parte IZQUIERDA del marco de las
                DEFB    $03,$00,$00,$00 ;ventanas usadas para los mensajes de
                DEFB    $00             ;error.

L0052:          RET                     ;Cuando se accede a esta dirección la
                                        ;electrónica del HiLow despagina su
                                        ;ROM, continuando la ejecución en la
                                        ;misma dirección de la ROM normal.

WINDOW2:        DEFB    $80,$80,$80,$80 ;Estos bytes definen el mapa de bits
                DEFB    $80,$80,$80,$80 ;(tipo UDG) para imprimir en pantalla
                DEFB    $80,$80,$00,$00 ;la parte DERECHA del marco de las
                DEFB    $00,$00,$00,$00 ;ventanas usadas para los mensajes de
                DEFB    $00,$00,$00     ;error.

NMI:            LD      (NMI_STACK),SP  ;RUTINA DE SERVICIO DE LA NMI
                LD      SP,START_RAM    ;--+
                PUSH    AF              ;  +- Obsérvese cómo se guardan
                DEC     SP              ;  ¦  los registros, y la ejecución
                DEC     SP              ;  ¦  de un RETN para avisar al Z80
                PUSH    BC              ;  ¦  el fin de la NMI.
                PUSH    DE              ;  ¦
                PUSH    HL              ;  ¦  Aparentemente se trata de un
                PUSH    IX              ;  ¦  error (no estoy seguro) de
                PUSH    IY              ;  ¦  concepto ya que haciendo esto,
                EX      AF,AF'          ;  ¦  en teoría es posible hacer una
                PUSH    AF              ;  ¦  petición de NMI cuando YA se
                EXX                     ;  ¦  estaba dando servicio a una.
                PUSH    BC              ;  ¦
                PUSH    DE              ;  ¦
                PUSH    HL              ;  ¦
                LD      HL,CONTINT      ;  +-+
                PUSH    HL              ;  ¦ ¦
                RETN                    ;--+ ¦
                                        ;    ¦
CONTINT:        AND     A               ;------ Notar que aquí continúa la NMI
                LD      A,I             ;       luego de la ejecución del RETN
                DI
                PUSH    AF
                XOR     A               ;I <- 0, cuando llegue al HALT se
                LD      I,A             ;ejecutará RST38 o INT_IM2 dependiendo
                EI                      ;del MODO de interrupción, entonces
NOTA2:          HALT                    ;quedará un 0 en L3EED si IM1, o un 1
                DI                      ;si fué una IM2. QUE INGENIOSO!
                POP     HL
                LD      A,(L3EED)       ;La rutina L0116 que se llama más
                LD      C,A             ;adelante comprueba las teclas [1] y
                LD      A,L             ;[SPACE]... es decir:
                OR      C
                LD      L,A             ;BOTON NMI + [SPACE] (fuerza un BREAK)
                PUSH    HL              ;BOTON NMI + [1]     (hace un RESET,
                LD      IX,(L3F2B)      ;ya que la computadora TK90X carecía
                LD      HL,START_RAM    ;de botón RESET este interface se lo
                LD      (L3F31),HL      ;proporcionaba)
TEST_1SPACE:    CALL    L0116
                IN      A,(HLWPORT)     ;Aquí cancela el SAVE del snap NMI si
                BIT     3,A             ;se abrió la tapa del grabador, además
                JP      Z,L0E31         ;también cancela si el SAVE si es que
                LD      A,(L3EEC)       ;ya fue usado.
                CP      $7B             ;La rutina L0D32 prueba SYMBOL y SPACE
                JP      NZ,L0E31        ;si se pulsa SYMBOL hace el SAVE, si
                JP      L0D32           ;se pulsa SPACE retorna.

L00B6:          LD      A,$2E
                CP      (IX+1)
                CALL    NZ,L055A
                LD      C,$40
                CALL    L1F4F
                JP      NZ,RESET
                XOR     A
                LD      (L3EEC),A
                JP      L1129

L00CD:          LD      A,(IX+0)        ;Aquí se decide si se salva el juego
                AND     A               ;por ser un header tipo BASIC o
                JR      Z,L00DF         ;bien la pantalla del juego por ser
                LD      (IX+1),$2E      ;un header tipo CODE. I.e.
                LD      HL,$1B00
                LD      BC,START_RAM    ;SAVE "*JUEGO" -> header basic
                JR      L00E7           ;SAVE "*PANT" SCREEN$ -> header CODE

L00DF:          LD      HL,$C000        ;Aquí se salva toda la RAM para el
                LD      BC,START_RAM    ;juego con ID 4 -> NMI
                LD      A,$04
L00E7:          LD      (IX+$0B),L
                LD      (IX+$0C),H
                LD      (IX+$0D),C
                LD      (IX+$0E),B
                LD      (IX+$00),A
                CALL    L06FC
                JR      L010A

                DEFS    $04,$00

; ============================================================================
; NOTA A NMI:
;
; Si IM2 estuviera activa, al dar un 0 al registro I, entonces el Z80 leera
; la dirección contenida en L00FF y saltará a INT_IM2 para dar servicio a la
; interrupción forzada por el HALT de la etiqueta NOTA2.
;
; Por el contrario, si el modo era IM1 entonces se ejecuta RST 38h.
;
; En una palabra: si después de poner un 0 en el registro 'I' y al hacer luego
; un HALT, entonces quedará en el contenido de L3EED un 0 si las interrupciones
; estaban en MODO 2, o quedará un 1 si estaban en MODO 1.

L00FF:          DEFW    INT_IM2

INT_IM2:        PUSH    AF              ;con este fragmento se averigua el modo
                LD      A,$00           ;de interrupciones que estaba activo
                LD      (L3EED),A       ;cuando se ejecute el HALT de la rutina
                POP     AF              ;NMI (ver etiqueta NOTA2) al quedar un
                EI                      ;0 en la dirección L3EED
                RET

L010A:          JP      C,L05E0
                CALL    L0910
                LD      A,$7B
                LD      (L3EEC),A
                RST     30H

L0116:          LD      A,$F7           ;RUTINA USADA POR LA NMI
                IN      A,($FE)
                RRA
                JR      NC,L0128        ;SE APRETO TECLA 1 (RESET)
                LD      A,$7F
                IN      A,($FE)
                RRA
                RET     C               ;RETORNA A MENOS QUE SE PULSE SPACE
                LD      HL,E_BREAKCONT  ;D - BREAK CONT repeats
                JR      L012B

L0128:          LD      HL,$0000        ;RESET
L012B:          CALL    READ_KBD
                JR      NZ,L012B
                LD      SP,(RUNMI_SP)
                JP      L11FC

PR_ERRMSG:      PUSH    HL              ;Esta rutina imprime uno de los
                LD      HL,MSGSYS1      ;mensajes de la tabla MSGSYS1
                LD      (DIRMSGS),HL    ;Entrando con A=número de mensaje
                POP     HL              ;siendo 1 el primero.
L013F:          CALL    SAVE_REGS       ;Observar que hay un punto opcional
                LD      HL,$FFC4        ;de entrada para poder usar otra
                LD      DE,L3D14        ;tabla de mensajes... i.e. la nuestra
                LD      BC,$003C
                LDIR                    ;Para hacer esto simplemente hay que
                LD      ($FFFE),SP      ;poner en (DIRMSGS) la dirección de
                LD      SP,$FFFE        ;nuestra tabla, entrando por L013F.
                AND     A
                JP      Z,L01F6         ;Conviene entrar a esta dirección
                LD      HL,L3D63        ;usando la entrada en el JUMP_BLOCK1
                LD      (L3D5B),HL
                CALL    L023D
                PUSH    DE
                LD      DE,WINDOW1      ;Imprime el contorno izquierdo
                CALL    L0222           ;del marco del mensaje
                INC     HL
                POP     DE
                CALL    L017C           ;Imprime el mensaje
                LD      DE,WINDOW2      ;Imprime el contorno derecho
                CALL    L0222           ;del marco del mensaje
                CALL    L026F           ;Guarda contenido previo atributos
                CALL    L0286           ;Coloca los atributos
                JP      L1016

L017C:          LD      A,(DE)          ;Este fragmento imprime todo el
                AND     A               ;mensaje, siendo (DE) la dirección
                RET     Z               ;del mensaje y HL la dirección de
                PUSH    DE              ;la pantalla en donde imprimir el
                CALL    L0187           ;carácter.
                POP     DE
                INC     DE              ;Observar -> fin del mensaje (DE)=0
                JR      L017C

L0187:          PUSH    HL
                PUSH    AF
                LD      B,$FF
                LD      C,$FF
                CALL    L01B5           ;Guarda el contenido de pantalla (HL)
                                        ;y pasa "raya"
                CALL    L0B7B           ;calcula sig. SCAN
                POP     AF
                PUSH    HL
                CALL    L01CE           ;Dirección (mapa bits) del carácter
                POP     DE
                EX      DE,HL
                LD      B,$08
                CALL    L01D9           ;Imprime el carácter
                LD      B,$FF
                LD      C,$FF
                CALL    L01B5           ;repite la "raya" parte inferior marco
                CALL    L0B7B
                LD      A,(HL)
                LD      (DE),A
                INC     DE
                LD      (L3D5B),DE
                LD      (HL),$FF
                POP     HL
                INC     HL
                RET

L01B5:          LD      DE,(L3D5B)      ;Ver comentario en L0187
                LD      A,(HL)
                LD      (DE),A
                INC     DE
                LD      (HL),B
                LD      (L3D5B),DE
                RET

                CALL    L0B7B           ;Este fragmento no es usado por nadie
                LD      A,(HL)          ;aparentemente se trata de un residuo
                LD      (DE),A          ;de programación.
                INC     DE
                LD      (L3D5B),DE
                LD      (HL),C
                RET

L01CE:          LD      H,$00           ;Recibe en A el ASCII de un carácter
                LD      L,A             ;y retorna en HL su dirección en el
                LD      DE,$3C00        ;font
                ADD     HL,HL
                ADD     HL,HL
                ADD     HL,HL
                ADD     HL,DE
                RET

L01D9:          LD      A,(HL)          ;Este fragmento imprime en pantalla
                PUSH    DE              ;el caracter cuyo mapa de bits se
                LD      DE,(L3D5B)      ;encuentra en (DE) y lo hace en la
                LD      (DE),A          ;dirección de pantalla (HL)
                INC     DE
                LD      (L3D5B),DE
                POP     DE
                EX      DE,HL
CALLRST18_1:    RST     18H             ;Observar que despagina el HiLow para
                DEFW    RET_WHL         ;poder leer de la ROM normal el mapa
                LD      C,A             ;bits del carácter a imprimir.
                RRA
                OR      C               ;Observar que pone el carácter en
                EX      DE,HL           ;"negritas"
                INC     DE
                LD      (HL),A
                CALL    L0B7B
                DJNZ    L01D9
                RET

L01F6:          LD      HL,(SCR_DIR)    ;Esta rutina restituye lo guardado
                LD      DE,L3D63        ;por PR_ERRMSG en la pantalla
                LD      BC,(L3D5F)      ;Es decir, restablece la pantalla.
                INC     C
                INC     C               ;Siendo esta rutina sólamente llamada
                LD      B,C             ;cuando A=0 al usar PR_ERRMSG
L0203:          CALL    L020E
                DJNZ    L0203
                CALL    L027D
                JP      L1016

L020E:          PUSH    HL
                CALL    L0215
                POP     HL
                INC     HL
                RET

L0215:          PUSH    BC
                LD      B,$0B
L0218:          LD      A,(DE)
                LD      (HL),A
                CALL    L0B7B
                INC     DE
                DJNZ    L0218
                POP     BC
                RET

L0222:          PUSH    HL              ;Esta rutina imprime el contorno
                LD      B,$0B           ;izquierdo o derecho del marco de los
L0225:          PUSH    BC              ;mensajes siendo (DE) mapa de bits
                LD      A,(HL)          ;a imprimir y HL dirección de la
                LD      BC,(L3D5B)      ;pantalla.
                LD      (BC),A
                INC     BC              ;Además salvaguarda en ((L3D5B)) el
                LD      (L3D5B),BC      ;contenido previo de lo que va a
                LD      A,(DE)          ;afectar.
                OR      (HL)
                LD      (HL),A          ;Esta rutina sólamente es usada por
                INC     DE              ;RST 28H
                CALL    L0B7B
                POP     BC
                DJNZ    L0225
                POP     HL
                RET

L023D:          LD      DE,(DIRMSGS)    ;Esta rutina es usada para averiguar
                LD      B,A             ;la dirección del mensaje en la tabla
L0242:          LD      C,$00           ;indicada por (DIRMSGS).
                PUSH    DE
                POP     HL              ;Retorna DE=dirección mensaje
L0246:          LD      A,(DE)          ;        HL=dirección pantalla
                INC     DE              ;        (SCR_DIR) idem anterior
                AND     A               ;        (ATR_DIR) dirección atributos
                JR      Z,L024E         ;        (L3D5F) ancho mensaje
                INC     C
                JR      L0246
L024E:          DJNZ    L0242
                EX      DE,HL
                LD      (L3D5F),BC
                INC     C
                INC     C
                LD      A,$20
                SUB     C
                RRA
                LD      C,A
                LD      HL,$4F20
                ADD     HL,BC
                LD      (SCR_DIR),HL
                LD      HL,$5940
                ADD     HL,BC
                INC     HL
                LD      (ATR_DIR),HL
                LD      HL,(SCR_DIR)
                RET

L026F:          LD      HL,(ATR_DIR)
                LD      DE,(L3D5B)
L0276:          LD      BC,(L3D5F)
                LDIR
                RET

L027D:          LD      HL,(L3D5B)
                LD      DE,(ATR_DIR)
                JR      L0276

L0286:          LD      HL,(ATR_DIR)
                LD      A,(HL)
                AND     $40
                XOR     $78
                LD      (HL),A
                LD      BC,(L3D5F)
                PUSH    HL
                POP     DE
                INC     DE
                DEC     BC
                LDIR
                RET

; ============================================================================
; Estos son los mensajes del sistema. (ver RST 28H)
; (cada mensaje va terminado con 0)

MSGSYS1:        DEFB    " CONFIRME SUSTITUCION ",0              ; 01
                DEFB    " ARCHIVO NO ENCONTRADO ",0             ; 02
                DEFB    " SIN LUGAR EN LA CINTA ",0             ; 03
                DEFB    " DIRECTORIO LLENO ",0                  ; 04
                DEFB    " INSERTE CASSETTE ",0                  ; 05
                DEFB    " ERROR EN LA CINTA ",0                 ; 06
                DEFB    " DATADRIVE  CASSETTE ",0               ; 07
                DEFB    " COLOCAR ORIGINAL ",0                  ; 08
                DEFB    " CAMBIAR CASSETTE ",0                  ; 09
                DEFB    " VERIFICA ? ",0                        ; 0A
                DEFB    " VERIFICADO ",0                        ; 0B
                DEFB    " OTRA COPIA ? ",0                      ; 0C
                DEFB    "Start tape, then press any key",0      ; 0D
                DEFB    " QUITAR CASSETTE ",0                   ; 0E
                DEFB    " COLOCAR CASSETTE A FORMATEAR ",0      ; 0F
                DEFB    " C/BORRADO  S/BORRADO ",0              ; 10
                DEFB    " SIMPLE LADO  DOBLE LADO ",0           ; 11
                DEFB    " NMI NO SE COPIA ",0                   ; 12
                DEFB    " ERROR EN EL DIRECTORIO ",0            ; 13
                DEFB    " ESTE CASSETTE NO SIRVE ",0            ; 14
                DEFB    " GRABADOR APAGADO !! ",0               ; 15
                DEFB    " CONFIRME BORRADO ",0                  ; 16
                DEFB    " LONGITUD INCORRECTA ",0               ; 17
                DEFB    "Conecte grabador, digite ENTER",0      ; 18
                DEFB    " NOMBRE YA EXISTENTE ",0               ; 19

                DEFS    $09,$00

; ********************************************************
; ESTA ES UNA DE LAS 4 DIRECCIONES EN DONDE LA ELECTRONICA
; DEL HILOW PAGINA SU ROM
; ********************************************************

SAVE:           DI                      ;Aquí se pagina la ROM... ojo porque
                JP      TEST_PAGEON     ;en TEST_PAGEON está la protección.

CONT_SAVE:      AND     A               ;SI A=0 entonces interpreta si es una
                JP      Z,L0628         ;cabecera legal y retorna al programa
                EX      AF,AF'          ;que llamó.
                LD      A,(L3EF5)
                RLA                     ;Si la cabecera fue legal la variable
                JP      NC,L0654        ;L3EF5 queda con el valor de la tabla
                RLA                     ;para los diferentes identificadores:
                JP      C,CATALOGO      ;
                RLA                     ;L3EF5 = %10000000 (80h) = .&*
                JP      C,L065C         ;L3EF5 = %10100000 (A0h) = | ERASE
                PUSH    IX              ;L3EF5 = %11000000 (C0h) = (espacio) ^
                LD      IX,L3F19        ;
                EX      AF,AF'          ;Si L3EF5 es cualquiera de los valores
                LD      B,A             ;anteriores entonces salta a CATALOGO
                CP      $FF
                JR      NZ,L050D
                LD      A,D
                CP      (IX+12)
                JR      NZ,L050D
                CP      $C1
                JR      NC,L050D
                LD      A,E
                CP      (IX+11)
                JR      NZ,L050D
                LD      HL,L3EF9
                RES     2,(HL)
                LD      A,(IX+1)
                CP      $3A
                JP      NZ,L05D9
                LD      A,$2E
                LD      (IX+1),A
                SET     2,(HL)
                JP      L05D9

L050D:          PUSH    DE
                PUSH    BC
                XOR     A
                LD      (L3EF5),A
                LD      DE,$0011
                LD      IX,(L3EFB)
                LD      HL,SALO_RET
                RST     18H
                DEFW    SAVE_TAPE
                POP     AF
                EX      AF,AF'
                POP     DE
                POP     IX
                JP      L0654

L0528:          POP     AF
                LD      IX,(L3F2B)
                LD      HL,(L3EFD)
                LD      B,(IX+12)
                LD      C,(IX+11)
                PUSH    HL
                CALL    L0964
                POP     HL
                JP      (HL)

                DEFS    $1A,$00

; ********************************************************
; ESTA ES UNA DE LAS 4 DIRECCIONES EN DONDE LA ELECTRONICA
; DEL HILOW PAGINA SU ROM
; ********************************************************

LOAD:           DI                      ; Esta es una de las direcciones en
                JP      PARSE_LOAD      ; donde se pagina el HiLow

L055A:          LD      HL,RAMHLW
                LD      DE,$4017
                LD      BC,$0018
                LDDR
                RET

TEST_OFF:       IN      A,(HLWPORT)     ;Esta rutina testea si el grabador
                BIT     0,A             ;está apagado, solo sale de aquí
                RET     Z               ;cuando se lo enciende o bien se
                BIT     6,A             ;presiona SPACE.
                RET     NZ
                LD      A,$15
                RST     28H
                CALL    W_SOUND
                LD      H,$00
                LD      DE,L3800        ;Para el caso de que el grabador
L0579:          LD      A,(DE)          ;estuviera apagado hace una chequeo XOR
                XOR     H               ;desde 3800h hasta el fin de la RAM.
                LD      H,A             ;dicha comprobación queda en H
                INC     DE
                LD      A,D
                OR      E
                JR      NZ,L0579
L0581:          IN      A,(HLWPORT)
                BIT     6,A
                JR      NZ,L0593        ;Se encendió el grabador!
                LD      A,$7F
                IN      A,($FE)
                RRA
                JR      C,L0581         ;Bucle hasta encender grabador o SPACE
                XOR     A
                RST     28H
                JP      BREAKCONT

L0593:          LD      B,$00           ;Vuelve a hacer la comprobación XOR
                LD      DE,L3800        ;de todos los bytes entre 3800h y FFFFh
L0598:          LD      A,(DE)
                XOR     B
                LD      B,A
                INC     DE
                LD      A,D
                OR      E
                JR      NZ,L0598
                LD      A,B
                CP      H               ;Si no concuerda la comprobación
                JP      NZ,RESET        ;anterior => la RAM fue corrupta al
                XOR     A               ;al encender el grabador. (por eso
                RST     28H             ;el RESET).
                RET

L05A8:          EX      (SP),HL
                PUSH    AF
                LD      A,(HL)
                INC     HL
                INC     HL
                LD      (L3F2F),HL
                DEC     HL
                LD      H,(HL)
                LD      L,A
                POP     AF
                LD      (L3F2D),HL
                LD      HL,(L3F2F)
                EX      (SP),HL
                PUSH    HL
                LD      HL,START
                EX      (SP),HL
                PUSH    HL
                LD      HL,SAVE
                EX      (SP),HL
                PUSH    HL
                LD      HL,(L3F2D)
                EX      (SP),HL
                RST     30H

                ; ------------------------------------------------
                ; Aquí está la "dichosa" forma de paginar el Hilow
                ; debemos poner un 0 como dirección de retorno en
                ; la pila y saltar a la rutina 'SAVE_BYTES' de la
                ; ROM normal. (04C2h)
                ;
                ; ¡ pero eso es un reset !... ¡para nada! y sino
                ; observar el siguiente fragmento hasta el 'RET'
                ; ------------------------------------------------

TEST_PAGEON:    EX      (SP),HL         ;Carga en HL la dirección de retorno
                PUSH    AF              ;guarda AF
                LD      A,H             ;mira si HL (dir. de retorno) es 0
                OR      L
                JR      Z,USER_RET      ;si? ==> salta a USER_RET
                POP     AF              ;no? ==> recupera AF
                EX      (SP),HL         ;restituye HL y la pila
                JP      CONT_SAVE       ;y sigue con el trabajo normal.

USER_RET:       POP     AF              ;restituye AF
                POP     HL              ;restituye HL original
                RET                     ;"retorna" a la dirección de llamada.

L05D9:          CALL    L06FC
                JR      NC,L05EE
                POP     IX
L05E0:          DEC     A
                JP      Z,L0032
                DEC     A
                JP      Z,L0622
                LD      A,$03
                CALL    L09A8
                RST     30H

L05EE:          XOR     A
                LD      (L3EF5),A
                CALL    L0910
                POP     IX
                LD      (L3EED),IX
                LD      (L3F31),IX
                LD      IX,(L3F2B)
                LD      C,$40
                CALL    L077B
                LD      HL,L3EF9
                BIT     2,(HL)
                JR      NZ,L0610
                RST     30H

L0610:          LD      IX,(L3F2B)
                LD      DE,(L3EED)
                LD      (L3F31),DE
                LD      C,$00
                CALL    L077B
                RST     30H

L0622:          LD      A,$04
                CALL    L09A8
                RST     30H

L0628:          LD      A,D             ;Aquí se hace la segunda interpretación
                XOR     E               ;del save, a esta rutina se accede
                CP      $11             ;sólamente cuando el usuario hace un
                JR      NZ,L064F        ;SAVE desde c/m de una cabecera válida
                LD      B,$10           ;y no con los comandos del BASIC
                LD      A,(IX+1)
                CP      '.'             ; . = LOAD FILE
                JR      Z,L066D
                CP      '&'             ; & = LOAD FILE
                JR      Z,L066D
                CP      ':'             ; : = VERIFY
                JR      Z,L066D
                CP      '|'             ; | = ERASE FILE
                JR      Z,L0671
                CP      $D2             ; ERASE = ERASE FILE
                JR      Z,L0671
                CP      ' '             ; <espacio> = (alias CAT)
                JR      Z,L066F
                CP      '^'             ; ^ = (alias CAT)
                JR      Z,L066F

L064F:          XOR     A               ;En cualquier otro caso se pone
                LD      (L3EF5),A       ;a 0 la var. L3EF5 para indicar
                EX      AF,AF'          ;al Hilow que no tome acción alguna
L0654:          LD      HL,SALO_RET     ;cuando haya que cargar el bloque FFh
                EX      AF,AF'
                RST     18H
                DEFW    SAVE_TAPE       ;Finalmente se ejecuta un save "normal"
                RST     30H

L065C:          LD      IX,L3F19
L0660:          CALL    L0DC7
                JP      Z,L113E
                CALL    L097A
                CALL    NZ,L09A3
                RST     30H

L066D:          SLA     B
L066F:          SLA     B
L0671:          SLA     B
                SET     7,B
                LD      A,B
                LD      (L3EF5),A
                CALL    L067D
                RST     30H

L067D:          PUSH    IX
                POP     HL
                LD      (L3EFB),HL
                LD      DE,L3F19
                LD      BC,$0011
                LDIR
                RET

L068C:          LD      A,E
                DEC     A
                CP      $FF
                LD      A,D
                ADC     A,$00
                RET     Z
                SRL     A
                ADC     A,$00
                SRL     A
                ADC     A,$00
                SRL     A
                ADC     A,$00
                RET

L06A1:          PUSH    HL
                PUSH    HL
                POP     IX
                PUSH    HL
                CALL    L06BA
                POP     HL
                LD      DE,$002D
                ADD     HL,DE
                POP     DE
L06AF:          LD      BC,$002D
                LD      A,(HL)
                LDIR
                CP      $FF
                JR      NZ,L06AF
                RET

L06BA:          LD      DE,$0011
                PUSH    HL
                ADD     HL,DE
                LD      B,(HL)
                POP     HL
                LD      DE,$0012
                ADD     HL,DE
L06C5:          LD      A,(HL)
                PUSH    HL
                PUSH    BC
                CALL    L06D1
                POP     BC
                POP     HL
                INC     HL
                DJNZ    L06C5
                RET

L06D1:          PUSH    AF
                LD      A,(L3BF3)
                LD      D,$00
                LD      E,A
                INC     A
                LD      (L3BF3),A
                POP     AF
                LD      HL,L3BF5
                ADD     HL,DE
                PUSH    HL
                POP     DE
                INC     DE
L06E4:          LDD
                CP      (HL)
                JR      C,L06E4
                LD      (DE),A
                RET

L06EB:          LD      B,$16
                LD      HL,L380B
                LD      DE,$002D
L06F3:          LD      A,(HL)
                CP      $FF
                RET     Z
                ADD     HL,DE
                DJNZ    L06F3
                SCF
                RET

L06FC:          CALL    L0947
L06FF:          CALL    L1F46           ;Esta parte aparentemente salva
                JR      NZ,L0724        ;un bloque de bytes cuyos datos
                LD      A,$01           ;son los siguientes:
                RST     28H             ;(IX+$0B) --- LONGITUD
                CALL    W_SOUND         ;(IX+$0C) -+
                CALL    L0768           ;(IX+$0D) --- COMIENZO
                LD      A,$00           ;(IX+$0E) -+
                RST     28H             ;(IX+$00) --- FLAG (*)
                LD      A,$01           ;(IX+$01) --- NOMBRE (10 bytes)
                CCF                     ;
                RET     C               ;el FLAG es igual a lo acostumbrado
                CALL    L0737           ;excepto los NMI i.e.:
                CALL    L0C9B           ;
                LD      A,$03           ; 0 = BASIC
                RET     C               ; 1 = MATRIZ NUMERICA
                PUSH    HL              ; 2 = MATRIZ ALFANUMERICA
                CALL    L06BA           ; 3 = CODE
                POP     HL              ; 4 = NMI (ver desde L00CD)
                JR      L0732

L0724:          CALL    L06EB
                LD      A,$02
                RET     C
                LD      B,$00
                CALL    L0C9B
                LD      A,$03
                RET     C
L0732:          CALL    L0742
                XOR     A
                RET

L0737:          PUSH    IX
                PUSH    HL
                POP     IX
                LD      B,(IX+17)
                POP     IX
                RET

L0742:          PUSH    HL
                LD      (L3F2B),HL
                PUSH    IX
                POP     DE
                EX      DE,HL
                LD      BC,$0011
                LDIR
                PUSH    IX
                LD      IX,(L3F2B)
                LD      E,(IX+11)
                LD      D,(IX+12)
                CALL    L068C
                LD      (IX+17),A
                POP     IX
                POP     HL
                CALL    L10C0
                RET

L0768:          LD      A,$7F           ; Esta rutina testea BREAK (NC)
                IN      A,($FE)         ; y ejecuta el sonido característico
                RRA                     ; cuando se cancela algo.
                JR      NC,L0777
                RRA
                JR      C,L0768
                CALL    L1079
                SCF
                RET

L0777:          CALL    W_SOUND_SPC
                RET

L077B:          CALL    L1F4F
                PUSH    AF
                LD      A,(L3EFB)
                CP      $C0
                JP      Z,L0528
                POP     AF
                RET     Z

ERR_IO:         CP      $FF             ;SE PRESIONO BREAK
                JR      Z,BREAKCONT
                CP      $01             ;[ERROR EN LA CINTA]
                JR      Z,L07A0
                CP      $02             ;[ERROR EN LA CINTA]
                JR      Z,L07A0
                CP      $03             ;[ERROR EN EL DIRECTORIO]
                JR      Z,L07A8
                CP      $04             ;[ESTE CASSETTE NO SIRVE]
                JR      Z,L07B2
                RST     18H             ;[INVALID DEVICE] EN CUALQUIER CASO
                DEFW    E_INVDEV

L07A0:          LD      A,$06
                CALL    L07CD
BREAKCONT:      RST     18H
                DEFW    E_BREAKCONT

L07A8:          LD      A,$13
L07AA:          CALL    L07CD
                CALL    L07B6
                JR      BREAKCONT

L07B2:          LD      A,$14
                JR      L07AA

L07B6:          PUSH    AF              ; Esta rutina espera a que se quite
L07B7:          IN      A,(HLWPORT)     ; el cassette de la unidad y no sale
                BIT     2,A             ; de ella a menos que se lo haga.
                JR      Z,L07CB
                LD      A,$0E           ; A diferencia de la rutina en L118B
                RST     28H             ; aquí se retorna al punto desde
                CALL    W_SOUND         ; donde se llamó.
L07C3:          IN      A,(HLWPORT)
                BIT     2,A
                JR      NZ,L07C3
                XOR     A
                RST     28H
L07CB:          POP     AF
                RET

L07CD:          RST     28H
                CALL    L1056
                CALL    W_SOUND_SPC
                CALL    L09AF
                XOR     A
                RST     28H
                RET

;Aquí se comprueba el primer carácter del nombre dado en el SAVE "..."
;(ver etiqueta ON_SAVE)

PARSE_SAVE:     POP     HL
                LD      A,(IX+1)
                CP      $D0             ; FORMAT
                JP      Z,FORMAT
                CP      '@'             ; @ (alias FORMAT)
                JP      Z,FORMAT
                CP      '|'             ; | (alias ERASE)
                JP      Z,L0660
                CP      $D2             ; ERASE
                JP      Z,L0660
                CP      '.'             ; . LOAD
                JP      Z,L086B
                CP      '&'             ; & LOAD
                JP      Z,L086B
                CP      ':'             ; : VERIFY
                JP      Z,L085D
                CP      ' '             ; <espacio> i.e. alias CAT
                JP      Z,CATALOGO
                CP      $CF             ; CAT
                JP      Z,CATALOGO
                CP      '^'             ; ^ (alias CAT)
                JP      Z,CATALOGO
                CP      '*'             ; * (save NMI)
                JP      Z,L00CD
                CP      '='             ; = COPIAR ARCHIVOS
                JP      Z,L0E8B
                CP      '['             ; [ RENOMBRAR ARCHIVO
                JP      Z,L11B2

                PUSH    HL              ; Emula un SAVE normal de ROM SPECTRUM
                CALL    W_SOUND
                LD      HL,$1392        ; --+
                RST     18H             ;   + Aquí decide si es ROM SPECTRUM
                DEFW    RET_WHL         ;   ¦ o TK90X
                CP      $4F             ; --+
                LD      A,$0D           ; SI (1392h)=4FH => es una ROM SPECTRUM
                JR      Z,L0831         ; y usa el mensaje "Start tape..."
                LD      A,$18           ; SI (1392h)<>4FH => es una ROM TK90X
L0831:          RST     28H             ; y usa mensaje "Conecte grabador..."
L0832:          CALL    READ_KBD        ;
                JR      Z,L0832         ; Esta es la única diferenciación que
                XOR     A               ; se hace en base a si es una ROM
                RST     28H             ; Spectrum o TK90, después no sé de
                PUSH    IX              ; ninguna otra.
                LD      DE,$0011
                XOR     A
                LD      HL,SALO_RET
                RST     18H
                DEFW    SAVE_TAPE
                POP     IX
                LD      B,$32
L0849:          NOP
                DJNZ    L0849
                LD      E,(IX+11)
                LD      D,(IX+12)
                LD      A,$FF
                POP     IX
                LD      HL,SALO_RET
                RST     18H
                DEFW    SAVE_TAPE
                RST     30H

L085D:          PUSH    HL
                LD      HL,L3EF9
                SET     2,(HL)
                LD      A,$2E
                LD      (IX+1),A
                JP      L05D9

L086B:          PUSH    HL
                LD      HL,L3EF9
                RES     2,(HL)
                JP      L05D9

; Esta rutina formatea/recupera un cassette...

FORMAT:         CALL    L11A1           ;Borra pantalla
                CALL    L1198           ;Abre canal #2
                LD      A,(IX+2)
                CP      $3F             ;Si el segundo chr del nombre del SAVE
                JR      Z,L08D6         ;es un '?' entonces 'recupera casette'
                IN      A,(HLWPORT)
                BIT     2,A             ;Si BIT 2 PORT $FF=0 ==> No hay cass.
                JR      Z,L088A         ;en la unidad
                CALL    L07B6           ;Rutina q' pide que se quite el cass.
L088A:          LD      A,$0F           ;Mensaje: "PONGA CASSETTE A FORMATEAR"
                RST     28H             ;                                    ^
                CALL    W_SOUND         ;sonido de aviso                     ¦
                CALL    L0768           ;testea BREAK (NC si es así)         ¦
                LD      A,$00           ;                                    ¦
                RST     28H             ;                                    ¦
                JP      NC,L0032        ;SI SE PRESIONO BREAK ==> CANCELA    ¦
                IN      A,(HLWPORT)     ;                                    ¦
                BIT     2,A             ;                                    ¦
                JR      Z,L088A         ;repite si ni hay cassette puesto ---+
                LD      A,$10
                CALL    L0B21           ;Pregunta: [CON BORRADO  SIN BORRADO]
                LD      A,$01           ;1=con borrado
                JR      Z,L08A9
                XOR     A               ;0=sin borrado
L08A9:          LD      (L3EF9),A
                LD      A,$11           ;Pregunta: [SIMPLE LADO  DOBLE LADO]
                CALL    L0B21           ;BIT 1 de $3EF9=1 SIMPLE
                LD      A,(L3EF9)
                JR      Z,L08BB         ;BIT 1 de $3EF9=0 DOBLE
                SET     1,A
                LD      (L3EF9),A
L08BB:          LD      DE,MSFORM       ;DE=Mensaje "FORMATEANDO CASSETTE..."
                JR      L08D9           ;La rutina de formateo en sí, comienza
                                        ;a partir de esta dirección.

GO_FORMAT:      CALL    EX_FORMAT
                AND     A
                JP      NZ,ERR_IO
                LD      A,$80
                OUT     (HLWPORT),A
                CALL    L0910
                JR      CATALOGO

L08D0:          LD      A,$28
                OUT     (HLWPORT),A
                XOR     A
                RET

L08D6:          LD      DE,MSRECP       ;DE=MENSAJE "RECUPERANDO CASSETTE..."
L08D9:          RST     20H             ;IMPRIME RESTO DE LA PRESENTACION
                PUSH    IX              ;(nombre cassette, logotipo,
                POP     DE              ;copyright, etc...) y empieza a
                INC     DE              ;formatear saltando a GO_FORMAT
                INC     DE
                LD      B,$09
                CALL    L0989
                JR      GO_FORMAT

CATALOGO:       CALL    L0947           ;Rutina que dá el catálogo del
                CALL    L1198           ;del cassette. Puede serle útil
                CALL    L0B94           ;para imprimir un catálogo directamente
L08EF:          LD      A,$BF           ;sin tener que preparar una cabecera,
                IN      A,($FE)         ;despaginar luego, etc..
                RRA
                JR      NC,L08EF
                RST     30H

L08F7:          IN      A,(HLWPORT)
                BIT     3,A
                JP      Z,BREAKCONT
L08FE:          PUSH    IX
                LD      BC,(L3800)
                INC     BC
                LD      (L3800),BC
                XOR     A
                CALL    EX_RDSECT
                POP     IX
                RET

L0910:          CALL    L08F7
                AND     A
                JP      Z,L08D0
                CALL    L07B6
                JP      ERR_IO

TEST_DOOR:      XOR     A
                LD      (L3EEC),A
                IN      A,(HLWPORT)     ;Esta rutina testea si hay cassette
                BIT     2,A             ;o la tapa esta abierta.
                SCF                     ;NZ=tapa abierta/no hay cassette
                RET

RD_SECTCAT:     PUSH    IX
                XOR     A
                INC     A
                LD      A,$00
                SCF
                CALL    EX_RDSECT
                POP     IX
                RET

INSERT_TAPE:    CALL    W_SOUND         ;Esta rutina pide que se inserte
                LD      A,$05           ;un cassette
                RST     28H
                CALL    L0768           ;retorna NC si no se hizo
                LD      A,$00
                RST     28H
                RET     NC
                IN      A,(HLWPORT)
                RRA
                RRA
                RRA
                RET

L0947:          CALL    TEST_OFF
                CALL    TEST_DOOR
                CALL    Z,INSERT_TAPE
                JP      NC,BREAKCONT
                IN      A,(HLWPORT)
                BIT     3,A
                RET     NZ
                CALL    RD_SECTCAT
                AND     A
                JP      NZ,ERR_IO
                LD      A,$A8
                OUT     (HLWPORT),A
                RET

L0964:          LD      A,$C0           ;Esta rutina no la entiendo,
                LD      R,A             ;aparentemente encripta algo, pero
L0968:          LD      D,(HL)          ;ignoro para que... y cuando.
                LD      A,R             ;Se me ocurre que esto sirve para
                XOR     D               ;protección, cuando se hace:
                LD      (HL),A          ;SAVE ".ROM" CODE <alguna_parte_rom>
                INC     HL              ;
                INC     HL              ;Tampoco entiendo la secuencia:
                DEC     HL              ;INC HL / INC HL / DEC HL
                DEC     BC              ;lo cual es equivalente a un
                LD      A,B             ;solo INC HL (no sé que ganan)...
                OR      C               ;sera un retardo?
                JR      NZ,L0968        ;Si alguien entiende algo por
                RET                     ;favor, hágamelo saber.
                                        ;
                                        ;Por lo pronto encripta desde HL
                                        ;BC bytes, con el valor de R que
                                        ;contiene al principio $C0, tambien
                                        ;des-encripta si se la llama por
                                        ;segunda vez.


; ********************************************************
; ESTA ES UNA DE LAS 4 DIRECCIONES EN DONDE LA ELECTRONICA
; DEL HILOW PAGINA SU ROM
; ********************************************************

ON_SAVE:        DI                      ;Aquí esta la tercera direccion
                JP      PARSE_SAVE      ;en donde se pagina el HiLow para
                                        ;procesar el comando SAVE "...."
                                        ;Observar que en la ROM normal, en
                                        ;esta dirección se están preparando
                                        ;las cosas para ejecutar el SAVE.

L097A:          CALL    L0947
                CALL    L1F46
                RET     NZ
                CALL    L06A1
                CALL    L0910
                XOR     A
                RET

L0989:          LD      A,(DE)          ;Esta es la rutina principal de imp.
                AND     A               ;de mensajes.
                RET     Z               ;
                CP      $20             ;DE debe apuntar al mensaje y continúa
                JR      C,L0994         ;imprimiendo hasta B=0 o (DE)=0
                CP      $7F             ;
                JR      C,L099A         ;Observar que los códigos menores a 20h
L0994:          CP      $0D             ;y mayores a 7Fh (excepto 0Dh) son
                JR      Z,L099A         ;filtrados y sustituidos por 8Fh
                LD      A,$8F
L099A:          INC     DE
                PUSH    BC
                PUSH    DE
                RST     10H
                POP     DE
                POP     BC
                DJNZ    L0989
                RET

L09A3:          LD      A,$02
                CALL    W_SOUND
L09A8:          RST     28H
                CALL    L09AF
                XOR     A
                RST     28H
                RET

L09AF:          LD      A,$7F           ;Este fragmento mira si está apretada
                IN      A,($FE)         ;[SPACE] y se queda en bucle si es así.
                RRA
                JR      C,L09AF         ;Esta rutina es muy usada en muchas
                RET                     ;partes

PARSE_LOAD:     EX      (SP),HL         ;HL=dirección de retorno
                PUSH    AF
                LD      A,H
                CP      $07             ;Si H=7 ==> entonces LOAD fue llamada
                JP      NZ,L0A90        ;desde la dirección 76Eh en la ROM
                POP     AF              ;normal para la carga de una cabecera.
                LD      HL,L07B7
                EX      (SP),HL
                PUSH    AF
                LD      BC,$0011
                PUSH    IX
                POP     HL
                AND     A
                SBC     HL,BC
                PUSH    HL
                POP     IX
                LD      A,(IX+1)
                CP      $2E             ;El usuario quiere cargar un BASIC o un
                JR      Z,L09DD         ;CODE, o una MATRIZ
                CP      $2A             ;El usuario quiere cargar un NMI
                JP      NZ,L0A78

L09DD:          CALL    L0DC7
                JR      NZ,L0A0E
                PUSH    IX
                CALL    L0947
                CALL    L0DD6
                POP     IX
                LD      A,B
                AND     A
                JR      Z,L0A0E
                CALL    L0D45
                LD      HL,L37DE
                LD      A,(L3EF3)
                LD      DE,$002D
L09FC:          ADD     HL,DE
                CP      (HL)
                JR      NZ,L09FC
                DJNZ    L09FC
                CP      $04
                JP      Z,LOAD_NMI
                XOR     A
                LD      (L3EF7),A
                POP     AF
                JR      L0A2E

L0A0E:          XOR     A
                LD      (L3EF7),A
                POP     AF
                PUSH    IX
                CALL    L0947
                CALL    L1F46
                POP     IX
                JP      NZ,L0A6E
                LD      A,(HL)
                CP      (IX+0)
                JR      Z,L0A2E
                CP      $04
                JP      NZ,L0A6E
                JP      LOAD_NMI

L0A2E:          LD      (L3F2B),HL
                LD      BC,$0011
                ADD     IX,BC
                PUSH    IX
                POP     DE
                LDIR
                POP     HL
                POP     IX
                PUSH    HL
                LD      A,(IX+0)
                CP      $03
                JR      NZ,L0A5C
                LD      L,(IX-6)
                LD      H,(IX-5)
                LD      A,H
                OR      L
                JR      Z,L0A5C
                LD      A,(IX+11)
                CP      L
                JR      NZ,L0A5D
                LD      A,(IX+12)
                CP      H
                JR      NZ,L0A5D
L0A5C:          RST     30H

L0A5D:          LD      A,$17
                RST     28H
                CALL    L1065
                CALL    L09AF
                XOR     A
                RST     28H
L0A68:          CALL    W_SOUND_SPC
                RST     18H
                DEFW    E_BREAKPRG

L0A6E:          CALL    L119E
                CALL    L09A3
                POP     HL
                POP     HL
                POP     HL
                RST     30H

L0A78:          LD      A,$FF
                LD      (L3EF7),A
                INC     A
                LD      (L3EF6),A
                POP     AF
                POP     HL
                POP     IX
                PUSH    IX
                LD      HL,LOAD_PRG
                PUSH    HL
L0A8B:          INC     D
                RST     18H
                DEFW    LOAD_TAPE
                RST     30H

L0A90:          CP      $08             ;Si H=8 ==> entonces LOAD fue llamada
                JR      NZ,L0AAD        ;desde la dirección 802h en la ROM
                PUSH    HL              ;normal para la carga de una bloque.
                LD      HL,$0007
                ADD     HL,SP
                LD      A,(HL)
                POP     HL
                CP      $5B
                JR      Z,L0AA3
                CP      $40
                JR      NC,L0AAD
L0AA3:          LD      A,(L3EF7)
                INC     A
                JR      NZ,L0ADC
                POP     AF
                EX      (SP),HL
                JR      L0A8B

L0AAD:          POP     AF
                EX      (SP),HL
                PUSH    AF
                POP     BC
                AND     A
                JP      Z,L0AE0
                LD      A,(L3EF6)
                BIT     0,A
                JR      NZ,L0AC3
                PUSH    BC
                POP     AF
L0ABE:          INC     D
                RST     18H
                DEFW    LOAD_TAPE
                RST     30H

L0AC3:          PUSH    BC
                POP     AF
L0AC5:          LD      (L3F31),IX
                LD      IX,(L3F2B)
                LD      C,$01
                JR      C,L0AD3
                LD      C,$00
L0AD3:          XOR     A
                LD      (L3EF6),A
                CALL    L077B
                SCF
                RST     30H

L0ADC:          POP     AF
                EX      (SP),HL
                JR      L0AC5

L0AE0:          LD      A,(L3EF6)
                BIT     0,A
                JR      NZ,L0AFD
                PUSH    DE
                CALL    L0B1F
                POP     DE
                JR      Z,L0AF5
                XOR     A
                SCF
                LD      (L3EF6),A
                JR      L0ABE

L0AF5:          CALL    L0947
                LD      HL,L380B
                JR      L0B04

L0AFD:          LD      HL,(L3F2B)
                LD      DE,$002D
                ADD     HL,DE
L0B04:          LD      A,(HL)
                CP      $FF
                JP      Z,L0B8A
                LD      (L3F2B),HL
                PUSH    IX
                POP     DE
                LD      BC,$0011
                LDIR
                SCF
                PUSH    DE
                POP     IX
                LD      A,$01
                LD      (L3EF6),A
                RST     30H

L0B1F:          LD      A,$07           ; PREGUNTA AL USUARIO SI LA OPCION
                                        ; VA DIRIGIDA AL CASSETTE O AL DRIVER

L0B21:          RST     28H             ; ESTA RUTINA SIRVE PARA LOS MENUES
                CALL    W_SOUND         ; P.EJ. [DATADRIVE - CASSETTE]
                LD      A,(L3D5F)       ; RETORNA [Z] SI SE SELECCIONO OPCION
                AND     A               ; DE LA IZQUIERDA O [NZ] EN CASO
                RRA                     ; CONTRARIO.
                ADC     A,$00
                CALL    L0B6F
                CALL    L0B6C
                AND     A
L0B33:          EX      AF,AF'
L0B34:          LD      A,$EF
                IN      A,($FE)
                BIT     2,A
                JR      Z,L0B52
                LD      A,$F7
                IN      A,($FE)
                BIT     4,A
                JR      NZ,L0B5A
                EX      AF,AF'
                JR      NC,L0B33
                CALL    L1056
L0B4A:          CCF
                PUSH    AF
                CALL    L0B6C
                POP     AF
                JR      L0B33

L0B52:          EX      AF,AF'
                JR      C,L0B33
                CALL    L1065
                JR      L0B4A

L0B5A:          LD      A,$7F
                IN      A,($FE)
                RRA
                RRA
                JR      C,L0B34
                CALL    L1079
                EX      AF,AF'
                LD      A,$00
                RST     28H
                ADC     A,$00
                RET

L0B6C:          LD      A,(L3D5F)
L0B6F:          LD      B,A
                LD      HL,(ATR_DIR)
L0B73:          LD      A,(HL)
                XOR     $45
                LD      (HL),A
                INC     HL
                DJNZ    L0B73
                RET

L0B7B:          INC     H               ;Esta rutina retorna en HL la dir.
                LD      A,H             ;en pantalla del siguiente SCAN, y es
                AND     $07             ;usada para la impresión de mensajes.
                RET     NZ
                LD      A,L
                ADD     A,$20
                LD      L,A
                RET     C
                LD      A,H
                SUB     $08
                LD      H,A
                RET

L0B8A:          CALL    L09A3
                XOR     A
                LD      (L3EF6),A
                JP      BREAKCONT

; Esta rutina imprime el directorio

L0B94:          LD      A,$0D
                RST     10H
                LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
                LD      DE,MSCAT1
                LD      B,$0B
                CALL    L0989
                LD      DE,L3802
                LD      B,$09
                CALL    L0989
                LD      A,$17
                RST     10H
                LD      A,$15
                RST     10H
                LD      A,$41
                RST     10H
                LD      BC,(L3800)      ; ==> NRO. DE ACTUALIZACIONES
NOTA1:          BIT     7,B
                CALL    NZ,W_SOUND_SPC
                CALL    NZ,L1009
                BIT     2,B
                CALL    NZ,L1009
                RES     7,B
                RST     18H
                DEFW    STACK_BC
                RST     18H
                DEFW    PRINT_BC
                CALL    L1010
                LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
                CALL    L0BE7
                CALL    L0C48
                CALL    L0C5E
                JP      L0C63

L0BE7:          LD      HL,L380B
                LD      B,$00
L0BEC:          LD      A,(HL)
                LD      (L3EF3),A
                CP      $FF
                RET     Z
                PUSH    BC
                PUSH    HL
                CALL    L0C01
                POP     HL
                POP     BC
                INC     B
                LD      DE,$002D
                ADD     HL,DE
                JR      L0BEC

L0C01:          LD      C,A
                ADD     A,A
                ADD     A,A
                ADD     A,C
                INC     HL
                LD      DE,L3EFB
                LD      BC,$000A
                LDIR
                LD      C,(HL)
                INC     HL
                LD      B,(HL)
                LD      (L3EF1),BC
                INC     HL
                LD      C,(HL)
                INC     HL
                LD      B,(HL)
                LD      (L3EEF),BC
                LD      HL,MSCAT2
                LD      C,A
                LD      B,$00
                ADD     HL,BC
                LD      BC,$0005
                LDIR
                LD      DE,L3EFB
                LD      B,$0F
                CALL    L0989
                LD      BC,(L3EF1)
                RST     18H
                DEFW    STACK_BC
                RST     18H
                DEFW    PRINT_BC
                LD      A,$17
                RST     10H
                LD      A,$15
                RST     10H
                CALL    L0C71
                LD      A,$06
                RST     10H
                RET

L0C48:          LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
L0C4E:          LD      H,$00
                LD      A,(L3BF3)
                LD      L,A
                ADD     HL,HL
                PUSH    HL
                POP     BC
                RST     18H
                DEFW    STACK_BC
                RST     18H
                DEFW    PRINT_BC
                RET

L0C5E:          LD      DE,$0CDA
                RST     20H
                RET

L0C63:          LD      DE,MSVER
                RST     20H
                LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
                LD      A,$06
                RST     10H
                RET

L0C71:          LD      A,(L3EF3)
                AND     A
                JR      Z,L0C85
                CP      $03
                JR      NC,L0C7F
L0C7B:          LD      A,$06
                RST     10H
                RET

L0C7F:          LD      DE,MSCAT3
                RST     20H
                JR      L0C90

L0C85:          LD      A,(L3EF0)
                AND     $C0
                JR      NZ,L0C7B
                LD      DE,MSCAT4
                RST     20H
L0C90:          LD      BC,(L3EEF)
                RST     18H
                DEFW    STACK_BC
                RST     18H
                DEFW    PRINT_BC
                RET

L0C9B:          LD      E,(IX+11)
                LD      D,(IX+12)
                LD      A,D
                OR      E
                JR      Z,L0CAC
                CALL    L068C
                CP      $1A
                JR      C,L0CAF
L0CAC:          RST     18H
                DEFW    E_OUTRANGE

L0CAF:          LD      C,A
                LD      A,(L3BF3)
                ADD     A,B
                SUB     C
                RET

MSCAT1:         DEFB    "CASSETTE :",0
MSCAT2:         DEFM    "\\BAS \\NUM \\CHR \\COD \\NMI  K LIBRES",$00
MSVER:          DEFB    "    HILOW  VER ",VERSION,0
MSRECP:         DEFB    "RECUPERANDO CASSETTE ",0
MSFORM:         DEFB    "FORMATEANDO CASSETTE ",0
MSCAT3:         DEFB    " DIR. ",0
MSCAT4:         DEFB    " LINE ",0

L0D32:          CALL    L1083
                LD      A,$7F
                IN      A,($FE)
                BIT     1,A
                JP      Z,L00B6
                BIT     0,A
                JR      NZ,L0D32
                JP      L0E31

L0D45:          CALL    L0D4C
                JP      C,L0A68
                RET

L0D4C:          LD      HL,$5800
                LD      A,(ATTRT)
                AND     $40
                XOR     $78
                CALL    L0DBC
                LD      C,$01
L0D5B:          LD      A,$EF
                IN      A,($FE)
                BIT     4,A
                JR      Z,L0D80
                BIT     3,A
                JR      Z,L0D94
                IN      A,(HLWPORT)
                BIT     2,A
                JP      Z,BREAKCONT
                LD      A,$7F
                IN      A,($FE)
                BIT     0,A
                SCF
                RET     Z
                BIT     1,A
                JR      NZ,L0D5B
                CALL    L1079
                LD      B,C
                AND     A
                RET

L0D80:          LD      A,C
                CP      B
                JR      Z,L0D5B
                CALL    L1056
                INC     A
                LD      C,A
                LD      A,(ATTRT)
                CALL    L0DBC
                LD      DE,$0020
                JR      L0DA5

L0D94:          LD      A,C
                DEC     A
                JR      Z,L0D5B
                CALL    L1065
                LD      C,A
                LD      A,(ATTRT)
                CALL    L0DBC
                LD      DE,$FFE0
L0DA5:          ADD     HL,DE
                LD      A,(ATTRT)
                AND     $40
                XOR     $78
                CALL    L0DBC
L0DB0:          LD      A,$EF
                IN      A,($FE)
                AND     $18
                CP      $18
                JR      NZ,L0DB0
                JR      L0D5B

L0DBC:          PUSH    BC
                PUSH    HL
                LD      B,$0E
L0DC0:          LD      (HL),A
                INC     HL
                DJNZ    L0DC0
                POP     HL
                POP     BC
                RET

L0DC7:          LD      B,$09
                PUSH    IX
                POP     HL
                INC     HL
                INC     HL
                LD      A,$20
L0DD0:          CP      (HL)
                RET     NZ
                INC     HL
                DJNZ    L0DD0
                RET

L0DD6:          CALL    L11A1
                CALL    L1198
                LD      HL,L380B
                LD      B,$00
                LD      A,(IX+1)
                CP      $2A
                JR      NZ,L0DEC
                LD      A,$04
                JR      L0DEF

L0DEC:          LD      A,(IX+0)
L0DEF:          LD      (L3EF3),A
                LD      C,A
L0DF3:          LD      A,(HL)
                CP      $FF
                RET     Z
                CP      C
                CALL    Z,L0E01
                LD      DE,$002D
                ADD     HL,DE
                JR      L0DF3

L0E01:          PUSH    HL
                INC     B
                PUSH    BC
                CALL    L0C01
                POP     BC
                POP     HL
                RET

;-------------------------------------------------
; Esta rutina carga el NMI que ya fué seleccionado

LOAD_NMI:       LD      SP,START_RAM
                PUSH    HL
                PUSH    DE
                PUSH    BC
                LD      HL,$5800
                LD      (HL),$00
                LD      D,H
                LD      E,L
                INC     DE
                LD      BC,$02FF
                LDIR
                POP     BC
                POP     DE
                LD      IX,START_RAM
                LD      (L3F31),IX
                POP     IX
                LD      C,$01
                CALL    L1F4F
                JP      NZ,L0E77
L0E31:          POP     AF
                IM      1
                JR      C,L0E38
                IM      2
L0E38:          LD      C,$00
                JP      PO,L0E3F
                LD      C,$04
L0E3F:          LD      I,A
                LD      A,C
                LD      (L3EEB),A
                POP     HL
                POP     DE
                POP     BC
                EXX
                POP     AF
                EX      AF,AF'
                POP     IY
                POP     IX
                POP     HL
                POP     DE
                POP     BC
                EX      (SP),HL
                LD      (RUNMI_SP),HL
                LD      A,(L3EEB)
                BIT     2,A
                LD      HL,L0E6E
                JR      Z,L0E63
                LD      HL,L0E65
L0E63:          EX      (SP),HL
                RET

L0E65:          POP     AF
                LD      SP,(RUNMI_SP)
                EI
                JP      L0052

L0E6E:          POP     AF
                LD      SP,(RUNMI_SP)
                DI
                JP      L0052

L0E77:          CALL    L1056
                CP      $FF
                JP      Z,RESET
                CALL    L1065
                LD      A,$06
                RST     28H
                CALL    L09AF
                JP      RESET

L0E8B:          CALL    W_SOUND
                LD      A,$08
                RST     28H
                CALL    L0768
                LD      A,$00
                RST     28H
                JP      NC,BREAKCONT
                CALL    L0947
                CALL    L0DC7
                JR      NZ,L0EB5
                LD      A,(L380B)
                CP      $FF
                JP      Z,L1148
                CALL    L11A1
                CALL    L115C
                JP      C,BREAKCONT
                JR      L0EC0

L0EB5:          CALL    L1F46
                JR      Z,L0EC0

L0EBA:          CALL    L09A3
                JP      BREAKCONT

;-----------------------------------
;A partir de aquí rutina para copiar
;archivos

L0EC0:          PUSH    HL
                POP     IX
                LD      A,$2A           ; A = ASCII de '*'
                CP      (IX+1)          ; ¿ Queremos copiar un NMI ?
PROTECCION:     JR      NZ,L0EE0        ; no?==>vamos a copiar

                LD      A,$12           ; si?==>mensaje "NMI NO SE COPIA"
                RST     28H             ; lo imprimimos
                CALL    W_SOUND_SPC     ; sonido de aviso

                                        
                CALL    TEST_HIW        ; pero entonces.... 
                                        ; !!!aquí comprueba algo interesante!!!
                                        ; si a la salida de esta rutina se
                                        ; pulsaron en secuencia las teclas
                                        ; [H] [I] y [W] entonces hay condición
                                        ; ZERO

                EX      AF,AF'          ; pone AF' para conservar AF normales
                                        ; ya que AF contiene el resultado de
                                        ; TEST_HIW

L0ED4:          CALL    READ_KBD        ; lee el teclado y espera hasta que
                JR      NZ,L0ED4        ; NO haya tecla(s) pulsada(s)

                EX      AF,AF'          ; recupera AF para saber que pasó con
                                        ; la rutina TEST_HIW

                LD      A,$00           ; código para restituir la pantalla
                RST     28H             ; borramos mensaje "NMI NO SE COPIA"

                JP      NZ,BREAKCONT    ; si no estaban presionadas las teclas
                                        ; HIW como se explica en TEST_HIW
                                        ; entonces hay condición NZ y salta
                                        ; BREAKCONT en donde se envia un error
                                        ; 'D - BREAK conts repeats'

L0EE0:          CALL    L0FA8           ; en caso contrario continua con la
                LD      (L3F31),DE      ; copia aunque este sea un NMI
                CALL    L067D
                LD      SP,COPY_STACK
                LD      C,$01
                CALL    L1F4F
                AND     A
                JP      NZ,RESET
L0EF6:          LD      A,$28
                OUT     (HLWPORT),A
                LD      HL,RETARDO1
L0EFD:          DEC     HL
                LD      A,H
                OR      L
                JR      NZ,L0EFD
L0F02:          IN      A,(HLWPORT)
                BIT     0,A
                JR      Z,L0F02
                CALL    W_SOUND
                LD      A,$09
                RST     28H
                CALL    L0768
                LD      A,$00
                RST     28H
                JP      NC,RESET
                CALL    TEST_DOOR
                CALL    Z,INSERT_TAPE
                JP      NC,RESET
                CALL    RD_SECTCAT
                AND     A
                JP      NZ,L0FBD
                CALL    L08D0
                LD      IX,L3F19
                CALL    L0FA8
                PUSH    DE
                CALL    L06FF
                JR      NC,L0F4A
                POP     DE
                DEC     A
                JR      Z,L0EF6
                DEC     A
                LD      A,$04
                JR      Z,L0F42
                LD      A,$03
L0F42:          RST     28H
                CALL    L0768
                XOR     A
                RST     28H
                JR      L0EF6

L0F4A:          CALL    L08FE
                AND     A
                JP      NZ,RESET
                POP     IX
                LD      (L3F31),IX
                LD      IX,(L3F2B)
                LD      C,$40
                CALL    L1F4F
                AND     A
                JP      NZ,RESET
                LD      A,$0A
                RST     28H
                CALL    L0768
                JR      NC,L0F88
                XOR     A
                RST     28H
                LD      IX,(L3F2B)
                CALL    L0FA8
                LD      (L3F31),DE
                LD      C,$00
                CALL    L1F4F
                LD      A,$0B
                JR      Z,L0F84
                LD      A,$06
L0F84:          RST     28H
                CALL    L09AF
L0F88:          XOR     A
                RST     28H
                LD      A,$0C
                RST     28H
                CALL    W_SOUND
L0F90:          LD      A,$7F
                IN      A,($FE)
                RRA
                JR      NC,L0F90
                CALL    L0768
                LD      A,$00
                RST     28H
                JP      C,L0EF6
RESET:          LD      HL,$0000        ;ESTE FRAGMENTO PROVOCA UN RESET
                LD      SP,$0000
                PUSH    HL
                RST     30H

L0FA8:          LD      A,(IX+0)
                CP      $03
                JR      C,L0FB6
                LD      E,(IX+13)
                LD      D,(IX+14)
                RET

L0FB6:          LD      E,(IY+25)
                LD      D,(IY+26)
                RET

L0FBD:          CALL    L08D0
                LD      A,$06
                RST     28H
                CALL    L0768
                XOR     A
                RST     28H
                JP      L0EF6

READ_KBD:       LD      A,$00
                IN      A,($FE)
                XOR     $1F
                AND     $1F
                RET

; IMPORTANTE!:  Ver rutina de copia de archivos
;               a partir de la etiqueta L0EC0
;
; La idea de la siguiente rutina es que presionemos
; las teclas [H] [I] y [W] en secuencia.
;
; Es decir, esta rutina solamente es llamada cuando queremos copiar
; un NMI, y está en pantalla el mensaje "NMI NO SE COPIA".
;
; Entonces:
;
;       1) soltamos cualquier tecla que estuviera pulsada
;       2) pulsamos la [H]
;       3) sin soltar la [H] se pulsa la [I]
;       4) soltamos la [H]
;       5) sin soltar la [I] se pulsa la [W]
;       6) soltamos la [I]
;

; A continuación comento esta rutina por considerla importante:

TEST_HIW:

IS_KEY:         CALL    READ_KBD        ;Lee todo el teclado y se queda en
                JR      NZ,IS_KEY       ;bucle hasta q' no haya teclas pulsadas

WAIT_KEY:       CALL    READ_KBD        ;<-----------------------------------+
                JR      Z,WAIT_KEY      ;bucle hasta que se pulse una tecla _|

                LD      A,$BF           ;selecciona semifila HJKL-enter
                IN      A,($FE)         ;lee el teclado
                BIT     4,A             ;TESTEA TECLA H
                RET     NZ              ;¿estaba pulsada? - no? ==> retornamos

TEST_H:         CALL    READ_KBD        ;<---------------------------------+
                LD      A,$BF           ;                                  |
                IN      A,($FE)         ;                                  |
                BIT     4,A             ;                                  |
                JR      Z,TEST_H        ;bucle mientras siga pulsada la H _|

                LD      A,$DF           ;selecciona semifila YUIOP
                IN      A,($FE)         ;lee el teclado
                BIT     2,A             ;TESTEA TECLA I
                RET     NZ              ;¿estaba pulsada? - no? ==> retornamos

TEST_I:         CALL    READ_KBD        ;<---------------------------------+
                LD      A,$DF           ;                                  |
                IN      A,($FE)         ;                                  |
                BIT     2,A             ;                                  |
                JR      Z,TEST_I        ;bucle mientras siga pulsada la I _|

                LD      A,$FB           ;selecciona semifila QWERT
                IN      A,($FE)         ;lee el teclado
                BIT     1,A             ;TESTEA TECLA W

                RET                     ;se retorna con ZERO si se llegó
                                        ;hasta aquí con la W pulsada
                                        ;En cualquier otro caso retorna con
                                        ;NOZERO (NZ)

L1009:          LD      A,$12           ;Este pequeño fragmento pone FLASH 1
                RST     10H             ;si fuera necesario al imprimir el
                LD      A,$01           ;catálogo.
                RST     10H
                RET

L1010:          LD      A,$12           ;Idem anterior pero para poner FLASH 0
                RST     10H
                XOR     A
                RST     10H
                RET

L1016:          LD      SP,($FFFE)
                LD      HL,L3D14
                LD      DE,$FFC4
                LD      BC,$003C
                LDIR
                CALL    REST_REGS
                RET

L1029:          LD      A,(BORDCR)      ;Esta rutina emite un sonido
                RRA                     ;En el registro B recibe la
                RRA                     ;duración y en HL algún tipo
                RRA                     ;de "frecuencia".
L102F:          DEC     D
                JR      NZ,L1037
                XOR     $10
                OUT     ($FE),A
                LD      D,H
L1037:          DEC     E
                JR      NZ,L103F
                XOR     $10
                OUT     ($FE),A
                LD      E,L
L103F:          DEC     C
                JR      NZ,L102F
                XOR     $10
                OUT     ($FE),A
                LD      C,B
                DJNZ    L102F
                RET

SAVE_REGS:      EX      (SP),HL         ;Este fragmento es usado en muchas
                PUSH    BC              ;partes para preservar los regs.
                PUSH    DE              ;(no vale la pena comentarlo)
                PUSH    AF
                PUSH    HL
                RET

REST_REGS:      POP     HL              ;Idem anterior pero para recuperar
                POP     AF              ;los registros y la pila.
                POP     DE
                POP     BC
                EX      (SP),HL
                RET

L1056:          CALL    SAVE_REGS       ;Emite uno de los sonidos de
                LD      B,$64           ;"movimiento" en la selección
                LD      HL,$1900        ;de archivos o elección de opciones
L105E:          CALL    L1029           ;en las ventanas-menu.
                CALL    REST_REGS
                RET

L1065:          CALL    SAVE_REGS       ;Emite uno de los sonidos de
                LD      B,$64           ;"movimiento" en la selección
                LD      HL,$1400        ;de archivos o elección de opciones
                JR      L105E           ;en las ventanas-menu.

W_SOUND_SPC:    CALL    SAVE_REGS       ;Emite el sonido de cancelación
                LD      B,$00           ;cuando se presiona SPACE
                LD      HL,$3500
                JR      L105E

L1079:          CALL    SAVE_REGS       ;Emite el sonido de aceptación
                LD      B,$96           ;cuando se presiona SHIFT
                LD      HL,$2100
                JR      L105E

L1083:          CALL    SAVE_REGS       ;Emite el sonido de "sirena" cuando
                LD      B,$00           ;se está ejecutando la NMI después de
                LD      HL,$1443        ;haber echo un SAVE "*..."
                JR      L105E

W_SOUND:        CALL    SAVE_REGS       ;Esta rutina emite el sonido de
                LD      A,(BORDCR)      ;"ATENCION" cuando se imprime alguna
                RRA                     ;ventana con mensaje de error.
                RRA
                RRA
                LD      C,$C8
                CALL    L10A9
                LD      C,$50
                CALL    L10B1
                LD      C,$FF
                CALL    L10A9
                CALL    REST_REGS
                RET

L10A9:          LD      B,C             ;rutina asociada al sonido de ATENCION
                DEC     C
                RET     Z
                CALL    L10B9
                JR      L10A9

L10B1:          LD      B,C             ;rutina asociada al sonido de ATENCION
                INC     C
                RET     Z
                CALL    L10B9
                JR      L10B1

L10B9:          XOR     $10             ;rutina asociada al sonido de ATENCION
                OUT     ($FE),A
L10BD:          DJNZ    L10BD
                RET

L10C0:          LD      DE,$0011
                ADD     HL,DE
                LD      B,(HL)
                PUSH    BC
                INC     HL
                PUSH    HL
                EXX
                POP     DE
                POP     BC
                EXX
                LD      A,$01
L10CE:          CALL    L1113
                JR      Z,L10DD
L10D3:          XOR     $80
                CALL    L1113
                JR      Z,L10DD
L10DA:          INC     A
                JR      L10CE

L10DD:          PUSH    AF
                CALL    L1F49
                POP     AF
                EXX
                LD      (DE),A
                INC     DE
                DJNZ    L10E9
                EXX
                RET

L10E9:          EXX
                CALL    L10F1
                JR      C,L10DA
                JR      L10D3

L10F1:          PUSH    AF
                INC     A
                EXX
                PUSH    BC
                EXX
                POP     BC
L10F7:          RES     7,A
                CALL    L1113
                CALL    Z,L110D
                SET     7,A
                CALL    L1113
                CALL    Z,L110D
                INC     A
                JR      NZ,L10F7
                POP     AF
                AND     A
                RET

L110D:          DEC     B
                RET     NZ
                POP     BC
                POP     AF
                SCF
                RET

L1113:          PUSH    BC
                CALL    L1119
                POP     BC
                RET

L1119:          PUSH    AF
                LD      A,(L3BF3)
                LD      B,A
                LD      HL,L3BF5
                POP     AF
L1122:          CP      (HL)
                INC     HL
                RET     Z
                DJNZ    L1122
                INC     B
                RET

L1129:          LD      IX,(L3F2B)
                LD      HL,START_RAM
                LD      (L3F31),HL
                LD      C,$00
                CALL    L1F4F
                JP      Z,L0E31
                JP      RESET

L113E:          CALL    L0947
                LD      A,(L380B)
                CP      $FF
                JR      NZ,L114C
L1148:          CALL    L09A3
                RST     30H

L114C:          CALL    L11A1
                CALL    L11A5
                CALL    L115C
                JR      C,L1172
                CALL    L06A1
                JR      L114C

L115C:          CALL    L1198
                CALL    L0947
                CALL    L0BE7
                LD      A,B
                AND     A
                SCF
                RET     Z
                CALL    L0D4C
                RET     C
                CALL    L11F2
                AND     A
                RET

L1172:          LD      A,$16
                RST     28H
                CALL    W_SOUND
L1178:          LD      A,$7F
                IN      A,($FE)
                RRA
                JR      NC,L1178
                CALL    L0768
                LD      A,$00
                RST     28H
                JR      NC,L118B
                CALL    L0910
                RST     30H

L118B:          LD      A,$0E           ;Esta rutina solicita al usuario
                RST     28H             ;que quite el cassette (o abra la
L118E:          IN      A,(HLWPORT)     ;tapa) y no sale de ella hasta que
                BIT     2,A             ;lo haga.
                JR      NZ,L118E
                LD      A,$00           ;Atención porque la ROM queda
                RST     28H             ;despaginada al retornar.
                RST     30H

L1198:          LD      A,$02           ;Esta rutina abre el canal de imp. #2
L119A:          RST     18H             ;
                DEFW    CH_OPEN         ;Tiene una entrada opcional por L119A
                RET                     ;que abre el canal indicado en A.

L119E:          XOR     A               ;Restituye canal #00 (KEYBOARD)
                JR      L119A

L11A1:          RST     18H             ;Esta rutina borra la pantalla usando
                DEFW    CLRSCR          ;la rutina $0D6B de la ROM normal.
                RET

L11A5:          CALL    L119E
                CALL    L0C4E
                CALL    L0C5E
                CALL    L1198
                RET

L11B2:          PUSH    IX
                CALL    L0947
                CALL    L1F46
                POP     IX
                JR      NZ,L11CA
                LD      A,$19
                RST     28H
                CALL    W_SOUND
                CALL    L09AF
                XOR     A
                RST     28H
                RST     30H

L11CA:          CALL    L11A1
                CALL    L1198
                CALL    L0BE7
                LD      A,B
                AND     A
                JP      Z,L0EBA
                CALL    L0D4C
                JP      C,L0A68
                CALL    L11F2
                PUSH    IX
                POP     DE
                INC     DE
                INC     DE
                INC     HL
                INC     HL
                EX      DE,HL
                LD      BC,$0009
                LDIR
                CALL    L0910
                RST     30H

L11F2:          LD      HL,L37DE
                LD      DE,$002D
L11F8:          ADD     HL,DE
                DJNZ    L11F8
                RET

L11FC:          PUSH    HL              ;Esta rutina es usada para imprimir
                LD      A,H             ;el Copyright del grabador.
                OR      L               ;SI HL=0 el usario solicitó un RESET
                JR      Z,L120D         ;(botón NMI+1)
                CALL    L11A1           ;si no ==> borra pantalla
                CALL    L1198           ;abre canal #02
                CALL    HLW_COPYR       ;imprime logotipo y copyright
                CALL    L09AF           ;queda bucle hasta soltar SPACE
L120D:          RST     30H

SIN_USO1:       DEFS    $B2,$00         ;178 bytes libres

                ; AQUI COMIENZA EL GRAFICO DEL LOGOTIPO DE HILOW

LOGOH:          DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$BF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FD,$A0,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$00,$00,$00,$05,$AF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                DEFB    $F5,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$00,$15,$A8,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$A8
                DEFB    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$15,$A8,$FE,$01,$FC,$1F,$FF,$FC,$FE
                DEFB    $00,$00,$1F,$FF,$C0,$FE,$01,$FC,$15,$A8,$03,$00
                DEFB    $06,$00,$00,$06,$03,$00,$00,$00,$00,$10,$03,$00
                DEFB    $06,$15,$A8,$FF,$01,$FE,$1F,$FF,$FE,$FF,$00,$00
                DEFB    $7F,$FF,$F8,$FF,$01,$FE,$15,$A8,$03,$00,$06,$0F
                DEFB    $81,$FE,$03,$00,$00,$01,$FC,$04,$03,$00,$06,$15
                DEFB    $A8,$FF,$01,$FE,$07,$FF,$FE,$FF,$00,$00,$FF,$FF
                DEFB    $FC,$FF,$01,$FE,$15,$A8,$03,$00,$06,$00,$01,$80
                DEFB    $03,$00,$00,$03,$80,$06,$03,$00,$06,$15,$A8,$FF
                DEFB    $01,$FE,$00,$7F,$80,$FF,$00,$00,$FF,$01,$FE,$FF
                DEFB    $01,$FE,$15,$A8,$00,$00,$06,$00,$01,$80,$03,$00
                DEFB    $00,$03,$00,$06,$03,$00,$06,$15,$A8,$FF,$FF,$FE
                DEFB    $00,$7F,$80,$FF,$00,$00,$FF,$01,$FE,$FF,$01,$FE
                DEFB    $15,$A8,$00,$00,$06,$00,$01,$80,$03,$00,$00,$03
                DEFB    $00,$06,$03,$00,$06,$15,$A8,$FF,$FF,$FE,$00,$7F
                DEFB    $80,$FF,$00,$00,$FF,$01,$FE,$FF,$01,$FE,$15,$A8
                DEFB    $03,$FE,$06,$00,$01,$80,$03,$00,$00,$03,$00,$06
                DEFB    $03,$00,$06,$15,$A8,$FF,$FF,$FE,$00,$7F,$80,$FF
                DEFB    $00,$00,$FF,$01,$FE,$FF,$79,$FE,$15,$A8,$03,$00
                DEFB    $06,$00,$01,$80,$03,$00,$00,$03,$00,$06,$03,$0C
                DEFB    $06,$15,$A8,$FF,$01,$FE,$00,$7F,$80,$FF,$00,$00
                DEFB    $FF,$01,$FE,$FF,$7D,$FE,$15,$A8,$03,$00,$06,$00
                DEFB    $01,$80,$03,$00,$00,$03,$00,$06,$00,$00,$06,$15
                DEFB    $A8,$FF,$01,$FE,$00,$7F,$80,$FF,$00,$00,$FF,$01
                DEFB    $FE,$FF,$FF,$FE,$15,$A8,$03,$00,$06,$00,$01,$80
                DEFB    $03,$00,$00,$03,$00,$06,$00,$00,$06,$15,$A8,$FF
                DEFB    $01,$FE,$00,$7F,$80,$FF,$00,$00,$FF,$01,$FE,$FF
                DEFB    $FF,$FE,$15,$A8,$03,$00,$06,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$0E,$00,$20,$0C,$15,$A8,$FF,$01,$FE
                DEFB    $1F,$FF,$FC,$FF,$FF,$FC,$7F,$FF,$FC,$3F,$FF,$FC
                DEFB    $15,$A8,$03,$00,$06,$00,$00,$06,$00,$00,$06,$00
                DEFB    $00,$3C,$00,$60,$38,$15,$A8,$FF,$01,$FE,$1F,$FF
                DEFB    $FE,$FF,$FF,$FE,$1F,$FF,$F8,$1F,$FF,$F0,$15,$A8
                DEFB    $7F,$00,$FE,$0F,$FF,$FE,$7F,$FF,$FE,$0F,$FF,$F0
                DEFB    $0F,$CF,$E0,$15,$A8,$3F,$00,$7E,$07,$FF,$FE,$3F
                DEFB    $FF,$FE,$03,$FF,$C0,$07,$83,$C0,$15,$A8,$00,$00
                DEFB    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$15,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$00,$00,$15,$AF,$FF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5
                DEFB    $A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$00,$00,$05,$BF,$FF,$FF,$FF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$80,$00
                DEFB    $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                DEFB    $00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                DEFB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

SIN_USO2:       DEFS    $14,$00         ;20 bytes libres

L157C:          LD      HL,$0005
                EXX
                LD      B,$64
                JR      L1592

L1584:          LD      HL,$00C8
                EXX
                LD      B,$00
                JR      L1592

L158C:          LD      HL,$0064
L158F:          EXX
                LD      B,$14
L1592:          EXX
                LD      A,C
L1594:          OUT     (HLWPORT),A
                XOR     $01
                EXX
                LD      C,A
                LD      A,B
                EXX
                LD      B,A
L159D:          DJNZ    L159D
                DEC     HL
                LD      A,H
                OR      L
                EXX
                LD      A,C
                EXX
                JR      NZ,L1594
                RET

L15A8:          LD      A,$02
                OUT     ($FE),A
                CALL    L15B7
                LD      A,C
                OUT     (HLWPORT),A
                LD      A,$05
                OUT     ($FE),A
                RET

L15B7:          LD      A,C
                INC     A
                OUT     (HLWPORT),A
                LD      B,$14
L15BD:          DJNZ    L15BD
                SCF
                JP      L15D7

L15C3:          RL      L
                RET     Z
                LD      A,C
                INC     A
                OUT     (HLWPORT),A
                LD      B,$03
L15CC:          DJNZ    L15CC
                LD      A,C
                ADC     A,B
                OUT     (HLWPORT),A
                LD      B,$0A
L15D4:          DJNZ    L15D4
                RET     C
L15D7:          LD      A,C
                OUT     (HLWPORT),A
                LD      B,$01
L15DC:          DJNZ    L15DC
                NOP
                NOP
                JP      L15C3

L15E3:          LD      H,$26
                LD      L,$0A
                JR      L15F5

L15E9:          LD      H,$22
                LD      L,$1B
                JR      L15F5

L15EF:          LD      H,$62
                LD      L,$1A
                JR      L15F5

L15F5:          LD      A,$7F
                IN      A,($FE)
                SRL     A
                JP      NC,L1A3B
                IN      A,(HLWPORT)
                BIT     0,A
                RET     NZ
                BIT     6,A
                JP      Z,L15F5
                CALL    L161A
                JR      C,L15F5
                CALL    L1627
                JR      NC,L15F5
                CALL    L161A
                JR      C,L15F5
                XOR     A
                SCF
                RET

L161A:          LD      B,H
L161B:          IN      A,(HLWPORT)
                RLA
                RLA
                JR      NC,L1624
                DJNZ    L161B
                RET

L1624:          LD      A,L
                CP      B
                RET

L1627:          LD      B,H
L1628:          IN      A,(HLWPORT)
                RLA
                RLA
                JR      C,L1631
                DJNZ    L1628
                RET

L1631:          LD      A,B
                CP      L
                RET

;=============================================================================
; Las siguientes rutinas aparentemente... leen o escriben un
; byte / sector / registro_de_estado / o_que_se_yo! :) :)
; desde el grabador.
;
; No lo tengo muy claro porque no dispongo de información técnica
; del datadrive.
;=============================================================================

L1634:          LD      C,$40
                LD      L,$01
                LD      B,$FF
L163A:          IN      A,(HLWPORT)
                AND     C
                JR      NZ,L1643
                DJNZ    L163A
                XOR     A
                RET

L1643:          LD      B,$0A
L1645:          IN      A,(HLWPORT)
                AND     C
                JR      Z,L164E
                DJNZ    L1645
                XOR     A
                RET

L164E:          LD      A,B
                CP      $08
                JR      C,L1689
                XOR     A
                RET

L1655:          IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                IN      A,(HLWPORT)
                AND     C
                JR      Z,L1689
                XOR     A
                RET

L1689:          IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                IN      A,(HLWPORT)
                AND     C
                JR      NZ,L16BD
                XOR     A
                RET

L16BD:          LD      B,$07
L16BF:          DJNZ    L16BF
                IN      A,(HLWPORT)
                RLA
                RLA
                RL      L
                RET     C
                AND     %11100111
                OUT     ($FE),A
                JP      L1655

                LD      B,H             ; ¡¿?!

L16D0:          PUSH    AF
                PUSH    IX
                PUSH    DE
                LD      IX,(L3F2B)
                LD      DE,$002D
                LD      A,$FF
                CALL    L1A2D
                CALL    L16E7
                POP     DE
                POP     IX
                POP     AF
L16E7:          SET     4,C
                EX      AF,AF'
                CALL    L158C
                CALL    L157C
                EX      AF,AF'
                LD      H,A
                EX      AF,AF'
                LD      L,H
                CALL    L15A8
L16F7:          LDA_Ix          ; LD A,Ix
                AND     $C0
                JR      NZ,L1706
                LD      A,(L3EF9)
                BIT     7,A
                LD      A,$00
                JR      Z,L1709
L1706:          LD      A,(IX+0)
L1709:          LD      L,A
                XOR     H
                LD      H,A
                CALL    L15A8
                INC     IX
                DEC     DE
                LD      A,D
                OR      E
                JR      NZ,L16F7
                LD      L,H
                CALL    L15A8
                RES     4,C
                LD      A,C
                OUT     (HLWPORT),A
                SCF
L1720:          LD      HL,L3EF9
                RES     7,(HL)
                RET

L1726:          EX      AF,AF'
                CALL    L15E3
                LD      H,$00
                CALL    L1634
                JR      NC,L175A
                LD      A,L
                EX      AF,AF'
                LD      B,A
                EX      AF,AF'
                CP      B
                JR      NZ,L175A
                XOR     H
                LD      H,A
L173A:          CALL    L1634
                JR      NC,L175A
                EX      AF,AF'
                JR      C,L175D
                EX      AF,AF'
                LDA_Ix          ; LD A,Ix
                AND     $C0
                JR      NZ,L174E
                LD      A,(L3EF9)
                BIT     7,A
L174E:          LD      A,L
                JR      NZ,L1755
                CP      $00
                JR      L1758

L1755:          CP      (IX+0)
L1758:          JR      Z,L1771
L175A:          XOR     A
L175B:          JR      L1720

L175D:          EX      AF,AF'
                LDA_Ix          ; LD A,Ix
                AND     $C0
                JR      NZ,L1769
                LD      A,(L3EF9)
                BIT     7,A
L1769:          LD      A,L
                JR      NZ,L176E
                JR      L1771

L176E:          LD      (IX+0),A
L1771:          XOR     H
                LD      H,A
                INC     IX
                DEC     DE
                LD      A,D
                OR      E
                JR      NZ,L173A
                CALL    L1634
                JR      NC,L175A
                LD      A,L
                XOR     H
                JR      NZ,L175A
                SCF
                JR      L175B

L1786:          EXX
                LD      C,$02
                EXX
L178A:          IN      A,(HLWPORT)
                BIT     0,A
                JR      Z,L1798
                XOR     A
                OUT     (HLWPORT),A
                CALL    RETARDO
                JR      L17A8

L1798:          XOR     C
                AND     $02
                JR      Z,L17A8
                LD      A,C
                OR      $08
                OUT     (HLWPORT),A
                LD      HL,RETARDO2
                CALL    L_RETARDO
L17A8:          LD      A,C
                OUT     (HLWPORT),A
                JR      Z,L17B0
                CALL    RETARDO
L17B0:          IN      A,(HLWPORT)
                BIT     0,A
                JR      Z,L17D0
                EXX
                DEC     C
                LD      A,C
                EXX
                AND     A
                JP      Z,L1A33
                XOR     A
                OUT     (HLWPORT),A
                CALL    RETARDO
                LD      A,C
                XOR     $02
                OR      $08
                OUT     (HLWPORT),A
                CALL    RETARDO
                JR      L178A

L17D0:          SCF
                RET

RETARDO:        LD      HL,RETARDO1
L_RETARDO:      DEC     HL
                LD      A,H
                OR      L
                JR      NZ,L_RETARDO
                INC     A
                RET

L17DC:          EXX
                LD      B,$03
                EXX
                EX      AF,AF'
L17E1:          LD      C,$26
                CALL    L1786
L17E6:          CALL    L1830
                JR      Z,L17F1
                LD      L,$02
                LD      B,$00
                JR      L1823

L17F1:          JR      NC,L17E6
                EX      AF,AF'
                LD      B,A
                EX      AF,AF'
                RES     7,B
                LD      A,B
                CP      L
                JR      NZ,L17FE
                SCF
                RET

L17FE:          JR      C,L1823
                SUB     L
                CP      $01
                JR      Z,L17E6
                DEC     A
                LD      B,A
                LD      C,$2E
L1809:          CALL    L1786
                CALL    RETARDO
L180F:          PUSH    BC
                LD      A,$03
                OUT     ($FE),A
                CALL    L15E9
                LD      A,$01
                OUT     ($FE),A
                CALL    RETARDO
                POP     BC
                DJNZ    L180F
                JR      L17E1

L1823:          EXX
                DEC     B
                LD      A,B
                EXX
                AND     A
                RET     Z
                LD      A,L
                SUB     B
                LD      B,A
                LD      C,$2C
                JR      L1809

L1830:          LD      A,$26
                OUT     (HLWPORT),A
                CALL    L15EF
                RET     NZ
                CALL    L15E3
                RET     NZ
                CALL    L1634
                RET     NC
                LD      A,L
                AND     A
                JR      Z,L1846
L1844:          XOR     A
                RET

L1846:          LD      H,A
                LD      B,$04
L1849:          PUSH    BC
                CALL    L1634
                POP     BC
                RET     NC
                LD      A,H
                XOR     L
                LD      H,A
                DJNZ    L1849
                AND     A
                JR      NZ,L1844
                SCF
                RET

L1859:          LD      A,(BORDCR)
                RRA
                RRA
                RRA
                AND     $07
                OUT     ($FE),A
                CALL    L1720
                LD      A,B
                EXX
                EX      DE,HL
                LD      SP,HL
                EX      DE,HL
                EXX
                RET

;=============================================================================

READ_SECTOR:    CALL    L1720           ;RUTINA QUE CARGA UN SECTOR?
                EX      AF,AF'          ;Aparentemente A=indica nr. sector
                EXX                     ;siendo 0 y 1 los que corresponden
                LD      DE,$0000        ;a los 2 directorios.
                EX      DE,HL           ;IX creo que apunta a la dirección
                ADD     HL,SP           ;en donde cargar los 2048 bytes.
                EX      DE,HL
                EXX                     ;Y retornaría con A=0 el resultado
                EX      AF,AF'          ;de la lectura, según la siguiente
                PUSH    AF              ;tabla:
                AND     A               ;
                JP      Z,L18A9         ;FFh = SE PRESIONO BREAK
                POP     AF              ;01h = [ERROR EN LA CINTA]
                CALL    L17DC           ;02h = [ERROR EN LA CINTA]
                JP      NC,L1A3F        ;03h = [ERROR EN EL DIRECTORIO]
                EX      AF,AF'          ;04h = [ESTE CASSETTE NO SIRVE]
                PUSH    AF              ;00h = NO HUBO ERROR
                LD      C,$22
                BIT     7,A
                JR      NZ,L1890
                SET     2,C
L1890:          LD      A,C
                OUT     (HLWPORT),A
                POP     AF
                JR      Z,L18A3
                EX      AF,AF'
                CALL    L15E3
                EX      AF,AF'
                CALL    L1726
                JP      NC,L1A43
                JR      L18A6

L18A3:          CALL    L16D0
L18A6:          JP      L1A4F

L18A9:          POP     AF              ; RUTINA LLAMADA P/CARGA SECTOR
                JP      Z,L19D6
                CALL    L18F3
                CALL    NC,L18F3
                JR      C,L18E1
                LD      HL,(L3D63)
                LD      A,H
                OR      L
                JP      Z,L1A4B
L18BD:          CALL    L1946
                CALL    NC,L1946
                JP      NC,L1A4B
                LD      A,(L3D64)
                AND     A
                JR      NZ,L18D6
                LD      HL,(L3800)
                SET     7,H
                LD      (L3800),HL
                JR      L18DE

L18D6:          LD      HL,(L3800)
                RES     7,H
                LD      (L3800),HL
L18DE:          JP      L19E2

L18E1:          XOR     A
                LD      HL,(L3800)
                RES     7,H
                LD      DE,(L3D65)
                RES     7,D
                SBC     HL,DE
                JR      NC,L18D6
                JR      L18BD

L18F3:          LD      HL,L3D63
                LD      B,$05
                XOR     A
L18F9:          LD      (HL),A
                INC     HL
                DJNZ    L18F9
                CALL    L1BE6
                LD      C,$26
                CALL    L1786
                LD      A,$01
                CALL    L1949
                JR      NC,L1911
                CALL    L1927
                JR      L1913

L1911:          LD      A,$02
L1913:          CALL    L1949
                JR      NC,L191D
                CALL    L1927
                JR      L191F

L191D:          LD      A,$03
L191F:          CALL    L1949
                RET     NC
                CALL    L1927
                RET

L1927:          LD      A,(L3D63)
                AND     A
                JR      NZ,L193D
                LD      A,(L3D6E)
                LD      (L3D63),A
                LD      HL,(L3800)
                LD      (L3D65),HL
                LD      A,(L3BF1)
                RET

L193D:          LD      A,(L3D6E)
                LD      (L3D64),A
                POP     AF
                SCF
                RET

L1946:          LD      A,(L3D63)
L1949:          LD      (L3D6E),A
                CALL    L17DC
                JP      NZ,L1A33
                RET     NC
                JR      NC,L1949
                LD      IX,DIRMSG
                LD      DE,$000E
                LD      A,$FF
                AND     A
                CALL    L1A2D
                CALL    L1726
                RET     NC
                LD      IX,L3800
                LD      DE,$0514
                LD      A,(L3D6E)
                SCF
                CALL    L1A2D
                CALL    L1726
                RET

L1978:          CALL    L1BE6
                LD      C,$26
                CALL    L1786
                LD      A,(L3BF2)
                CALL    L17DC
                RET     NC
                LD      IX,DIRMSG
                LD      DE,$000E
                LD      A,$FF
                LD      C,$26
                CALL    L1A2D
                CALL    L16E7
                LD      IX,L3800
                LD      DE,$0514
                LD      A,(L3BF2)
                CALL    L1A2D
                CALL    L16E7
                LD      A,(L3BF2)
                CALL    L17DC
                RET     NC
                LD      A,$26
                OUT     (HLWPORT),A
                LD      IX,DIRMSG
                LD      DE,$000E
                LD      A,$FF
                AND     A
                CALL    L1A2D
                CALL    L1726
                RET     NC
                LD      IX,L3800
                LD      DE,$0514
                LD      A,(L3BF2)
                AND     A
                CALL    L1A2D
                CALL    L1726
                RET

L19D6:          CALL    L1978           ; Carga sector 0 ???
                CALL    NC,L1978
                CALL    NC,L19F2
                JP      NC,L1A4B
L19E2:          CALL    L19E8
                JP      L1A4F

L19E8:          LD      HL,(L3BF1)
                LD      A,H
                LD      H,L
                LD      L,A
                LD      (L3BF1),HL
                RET

L19F2:          LD      HL,(L3BF1)
                LD      A,H
                CP      L
                RET     Z
                CALL    L1978
                RET     C
                CALL    L1BE6
                LD      A,(L3BF2)
                CALL    L17DC
                JR      NC,L1A0D
                CALL    L1A1E
                CALL    L1A1E
L1A0D:          LD      HL,(L3BF1)
                LD      H,L
                LD      (L3BF1),HL
                LD      HL,(L3800)
                SET     7,H
                LD      (L3800),HL
                XOR     A
                RET

L1A1E:          LD      IX,$0000
                LD      DE,$0064
                LD      A,$FF
                LD      C,$26
                CALL    L16E7
                RET

L1A2D:          LD      HL,L3EF9
                SET     7,(HL)
                RET

; A estas secciones se salta cuando hay errores
; de I/O

L1A33:          LD      B,$02           ; [ERROR EN LA CINTA]
                JR      L1A54

                LD      B,$02           ; ¡REPETICION! (innecesario)
                JR      L1A54

L1A3B:          LD      B,$FF           ; SE PRESIONO BREAK
                JR      L1A54

L1A3F:          LD      B,$01           ; [ERROR EN LA CINTA]
                JR      L1A54

L1A43:          LD      B,$01           ; ¡REPETICION! (innecesario)
                JR      L1A54

L1A47:          LD      B,$04           ; [ESTE CASSETTE NO SIRVE]
                JR      L1A54

L1A4B:          LD      B,$03           ; [ERROR EN EL DIRECTORIO]
                JR      L1A54

L1A4F:          LD      B,$00           ; OPERACION EXITOSA
                JP      L1859

L1A54:          LD      A,$28
                OUT     (HLWPORT),A
                JP      L1859

DD_FORMAT:      CALL    L1720
                CALL    L1D88
                EXX
                LD      DE,$0000
                EX      DE,HL
                ADD     HL,SP
                EX      DE,HL
                EXX
                PUSH    IX
                POP     HL
                INC     HL
                INC     HL
                LD      DE,L3802
                LD      BC,$0009
                LDIR
                LD      HL,L380B
                LD      DE,L380C
                LD      BC,$0509
                LD      (HL),$FF
                LDIR
                LD      HL,$0000
                LD      (L3BF3),HL
                LD      (L3800),HL
                INC     HL
                LD      (L3D6D),HL
                LD      HL,L380B
                LD      (L3F2B),HL
                LD      A,(IX+2)
                CP      $3F
                JP      Z,L1C19
                CALL    L1BE6
                LD      A,(L3EF9)
                BIT     0,A
                JR      Z,L1AB5
                LD      C,$32
                CALL    L1BEF
                LD      C,$34
                CALL    L1BEF
                CALL    L1BE6
L1AB5:          LD      C,$36
                CALL    L1786
                LD      HL,$4E20
                CALL    L158F
L1AC0:          LD      C,$36
                CALL    L1584
                CALL    L157C
                LD      H,$00
                LD      E,$01
                CALL    L1BDA
                LD      A,(L3D6D)
                LD      H,A
                LD      E,$04
                CALL    L1BDA
                LD      IX,$0000
                LD      DE,$0800
                LD      A,(L3D6D)
                CALL    L16D0
                LD      HL,L3D6D
                INC     (HL)
                LD      A,(HL)
                CP      $80
                JR      NC,L1AF6
                CALL    L1BF8
                JR      Z,L1AC0
                LD      HL,L3D6D
L1AF6:          DEC     (HL)
                DEC     (HL)
                LD      A,(L3EF9)
                BIT     1,A
                JR      Z,L1B26
                CALL    L1BE6
                LD      C,$22
                CALL    L1786
L1B07:          CALL    L1830
                JR      NC,L1B07
                LD      C,$22
                LD      A,L
                LD      HL,L3D6D
                CP      (HL)
                JR      NC,L1B26
                SET     7,A
                LD      IX,$0000
                LD      DE,$0800
                CALL    L16D0
                CALL    L1BF8
                JR      Z,L1B07
L1B26:          CALL    L1BE6
                LD      C,$26
                CALL    L1786
                CALL    L1B42
                LD      A,(L3D6E)
                LD      (L3BF1),A
                CALL    L1B42
                LD      A,(L3D6E)
                LD      (L3BF2),A
                JR      L1B5C

L1B42:          CALL    L1830
                JR      NC,L1B42
                LD      C,$26
                LD      A,L
                CP      $04
                JP      NC,L1A47
                CALL    L1BA6
                LD      HL,L3BF3
                LD      A,$01
                CP      (HL)
                JR      NZ,L1B42
                DEC     (HL)
                RET

L1B5C:          CALL    L1830
                JR      NC,L1B5C
                LD      C,$26
                LD      A,L
                LD      HL,L3D6D
                CP      (HL)
                JR      NC,L1B6F
                CALL    L1BA6
                JR      L1B5C

L1B6F:          LD      A,(L3EF9)
                BIT     1,A
                JR      Z,L1B91
                CALL    L1BE6
                LD      C,$22
                CALL    L1786
L1B7E:          CALL    L1830
                JR      NC,L1B7E
                LD      C,$22
                LD      A,L
                LD      HL,L3D6D
                CP      (HL)
                JR      NC,L1B91
                CALL    L1BA4
                JR      L1B7E

L1B91:          LD      A,(L3BF1)
                SET     7,A
                CALL    L1CCE
                LD      A,(L3BF2)
                SET     7,A
                CALL    L1CCE
                JP      L19D6

L1BA4:          SET     7,A
L1BA6:          LD      (L3D6E),A
                LD      A,C
                OUT     (HLWPORT),A
                LD      IX,L380B
                LD      DE,$002D
                LD      A,$FF
                AND     A
                CALL    L1A2D
                CALL    L1726
                RET     NC
                LD      IX,$0000
                LD      DE,$0800
                LD      A,(L3D6E)
                AND     A
                CALL    L1726
                RET     NC
                LD      A,(L3D6E)
                LD      HL,L3BF3
                INC     (HL)
                LD      B,$00
                LD      C,(HL)
                INC     C
                ADD     HL,BC
                LD      (HL),A
                RET

L1BDA:          LD      B,$05
L1BDC:          DJNZ    L1BDC
                LD      L,H
                CALL    L15A8
                DEC     E
                JR      NZ,L1BDA
                RET

L1BE6:          LD      A,$00
                OUT     (HLWPORT),A
                CALL    RETARDO
                LD      C,$28
L1BEF:          CALL    L1786           ; lee un bit?
L1BF2:          CALL    L1BF8
                JR      Z,L1BF2
                RET

L1BF8:          LD      A,$7F
                IN      A,($FE)
                SRL     A
                JP      NC,L1A3B        ; cancela la lectura
                LD      B,$00
L1C03:          IN      A,(HLWPORT)
                BIT     0,A
                RET     NZ
                DJNZ    L1C03
                RET

DIRMSG:         DEFB    "-*DIRECTORIO*-"

L1C19:          CALL    L1BE6
                LD      C,$26
                CALL    L1786
L1C21:          CALL    L1830
                JR      NC,L1C21
                LD      A,L
                LD      (L3BF1),A
L1C2A:          CALL    L1830
                JR      NC,L1C2A
                LD      A,L
                LD      (L3BF2),A
L1C33:          CALL    L1830
                JR      NZ,L1C48
                JR      NC,L1C33
                LD      A,$26
                OUT     (HLWPORT),A
                CALL    L1C91
                JR      NC,L1C33
                CALL    L1C65
                JR      L1C33

L1C48:          CALL    L1BE6
                LD      C,$22
                CALL    L1786
L1C50:          CALL    L1830
                JR      NZ,L1C86
                JR      NC,L1C50
                LD      A,$22
                OUT     (HLWPORT),A
                CALL    L1C91
                JR      NC,L1C50
                CALL    L1C65
                JR      L1C50

L1C65:          LD      IX,L3D65
                CALL    L1CA2
                RET     Z
                LD      HL,L3D65
                LD      A,$04
                CP      (HL)
                RET     C
                LD      DE,(L3F2B)
                LD      BC,$002D
                LDIR
                LD      (L3F2B),DE
                CALL    L1C89
                RET     NZ
                POP     AF
L1C86:          JP      L19D6

L1C89:          LD      HL,L3D6D
                INC     (HL)
                LD      A,(HL)
                CP      $16
                RET

L1C91:          LD      IX,L3D65
                LD      DE,$002D
                LD      A,$FF
                SCF
                CALL    L1A2D
                CALL    L1726
                RET

L1CA2:          LD      HL,L380B
L1CA5:          PUSH    IX
                POP     DE
                INC     DE
                INC     DE
                LD      A,(HL)
                CP      $FF
                JR      Z,L1CC0
                INC     HL
                INC     HL
                PUSH    HL
                LD      B,$09
                CALL    L1CC6
                POP     HL
                JR      Z,L1CC2
                LD      DE,$002B
                ADD     HL,DE
                JR      L1CA5

L1CC0:          DEC     A
                RET

L1CC2:          DEC     HL
                DEC     HL
                LD      A,(HL)
                RET

L1CC6:          LD      A,(DE)
                SUB     (HL)
                RET     NZ
                INC     HL
                INC     DE
                DJNZ    L1CC6
                RET

L1CCE:          CALL    L1CD5
                CALL    C,L1CE7
                RET

L1CD5:          LD      HL,L3BF5
                LD      BC,$0100
                CPIR
                LD      A,B
                OR      C
                RET     Z
                PUSH    HL
                POP     DE
                DEC     DE
                LDIR
                SCF
                RET

L1CE7:          LD      HL,L3BF3
                DEC     (HL)
                RET

L1CEC:          LD      (RUNMI_SP),SP
                LD      SP,AUX_STACK
                PUSH    BC
                LD      A,C
                CP      $01
                JR      Z,L1D02
                CP      $00
                LD      A,$FF
                JR      Z,L1D05
                LD      (IX+44),A
L1D02:          LD      A,(IX+44)
L1D05:          LD      (L3EFB),A
                LD      HL,(L3F31)
                LD      (L3EFD),HL
                POP     AF
                EX      AF,AF'
                LD      L,(IX+11)
                LD      H,(IX+12)
                LD      B,(IX+17)
                PUSH    BC
L1D1A:          INC     IX
                DJNZ    L1D1A
                POP     BC
                LD      C,B
                LD      DE,$FFFF
                PUSH    DE
                PUSH    DE
                LD      DE,$0800
L1D28:          AND     A
                SBC     HL,DE
                JR      C,L1D31
                LD      A,H
                OR      L
                JR      NZ,L1D28
L1D31:          ADD     HL,DE
L1D32:          EX      AF,AF'
                LD      A,(IX+17)
                PUSH    AF
                PUSH    HL
                EX      AF,AF'
                DEC     IX
                LD      HL,$0800
                DJNZ    L1D32
                LD      IX,(L3F31)
L1D44:          POP     DE
                POP     AF
                JP      M,L1D79
                LD      (L3F31),IX
                PUSH    AF
                PUSH    DE
                CALL    READ_SECTOR
                AND     A
                JR      NZ,L1D59
                POP     DE
                POP     DE
                JR      L1D44

L1D59:          LD      IX,(L3F31)
                POP     DE
                POP     AF
                PUSH    AF
                PUSH    DE
                CALL    READ_SECTOR
                AND     A
                JR      NZ,L1D6B
                POP     DE
                POP     DE
                JR      L1D44

L1D6B:          LD      IX,(L3F31)
                POP     DE
                POP     AF
                CALL    READ_SECTOR
                AND     A
                JR      NZ,L1D83
                JR      L1D44

L1D79:          LD      SP,(RUNMI_SP)
                LD      A,$28
                OUT     (HLWPORT),A
                XOR     A
                RET

L1D83:          LD      SP,(RUNMI_SP)
                RET

L1D88:          CALL    EX_SAVEREGS
                LD      DE,$40E4
                LD      HL,LOGOH
                LD      B,$28
L1D93:          PUSH    BC
                PUSH    DE
                LD      BC,$0011
                LDIR
                POP     DE
                CALL    L1DD2
                POP     BC
                DJNZ    L1D93
                LD      A,$68
                LD      HL,$58E4
                LD      DE,$000F
                LD      B,$05
L1DAB:          PUSH    BC
                LD      B,$11
L1DAE:          LD      (HL),A
                INC     HL
                DJNZ    L1DAE
                ADD     HL,DE
                POP     BC
                DJNZ    L1DAB
                LD      A,$02
                CALL    CH_OPEN
                LD      DE,MSGCPR
                CALL    L1DCA
                LD      A,$08
                LD      (SCRCT),A
                CALL    EX_RESTREGS
                RET

L1DCA:          LD      A,(DE)          ;Este fragmento imprime un mensaje
                CP      $00             ;a partir de (DE) y sigue imprimiendo
                RET     Z               ;hasta que (DE)=0
                RST     10H
                INC     DE
                JR      L1DCA

L1DD2:          INC     D               ;Este fragmento calcula el siguiente
                LD      A,D             ;scan de pantalla indicado por DE.
                AND     $07
                RET     NZ
                LD      A,E
                ADD     A,$20
                LD      E,A
                RET     C
                LD      A,D
                SUB     $08
                LD      D,A
                RET

MSGCPR:         DEFB    $16,$05,$04,$10,$09,$11,$08
                DEFB    "GRABADOR DIGITAL"
                DEFB    $16,$0E,$01
                DEFB    "HARD-SOFTWARE Y MANUFACTURA:"
                DEFB    $16,$10,$02
                DEFB    "JUAN J. ARIAS  CARLOS GALUCCI"
                DEFB    $16,$11,$02
                DEFB    "ROBERTO EIMER  RAMIRO ARIAS"
                DEFB    $16,$12,$02
                DEFB    "ALFREDO MUSSIO"
                DEFB    $16,$14,$01
                DEFB    "LIBERTADOR 1886/806 MONTEVIDEO"
                DEFB    $16,$15,$01
                DEFB    "TEL. 91 47 73         VER ",VERSION


SIN_USO3:       DEFS    $98,$00         ; 152 bytes libres

                ; PRIMERA TABLA DE SALTOS
                ; NO COMENTO LA FUNCION DE CADA
                ; RUTINA YA QUE AUN NO LAS ESTUDIE
                ; EN PROFUNDIDAD. (VER NOTA 2!)

EX_RDSECT:      JP      READ_SECTOR     ;Lee un sector (A=nr.SECT)
EX_FORMAT:      JP      DD_FORMAT       ;Rutina principal de formateo
L1F46:          JP      L1CA2           ;Busca un archivo en directorio (Z=SI)
L1F49:          JP      L1CCE
HLW_COPYR:      JP      L1D88           ;Logotipo Hilow y mens. copyright
L1F4F:          JP      L1CEC

SIN_USO4:       DEFS    $20,$00         ; 32 bytes libres

                ; SEGUNDA TABLA DE SALTOS
                ; NO COMENTO LA FUNCION DE CADA
                ; RUTINA YA QUE AUN NO LAS ESTUDIE
                ; EN PROFUNDIDAD. (sorry)

ALT_SYSMSG:     JP      L013F           ;Imprime msg de error. (ver PR_ERRMSG)
L1F75:          JP      L0964           ;Encripta BC bytes desde HL
L1F78:          JP      L06FF           ;Salva un archivo (ver datos en IX)
L1F7B:          JP      L0B94           ;Imprime directorio (ya cargado)
L1F7E:          JP      L0D4C
L1F81:          JP      L10C0
EX_SAVEREGS:    JP      SAVE_REGS       ;Guarda STACK y registros
EX_RESTREGS:    JP      REST_REGS       ;Recupera STACK y registros

SIN_USO5:       DEFS    $76,$00         ;118 bytes libres
LAST_BYTE:      EQU     $

; =======================================================================
;                        FIN DE LA ROM HILOW V1.3
; =======================================================================

; DEFINICION DE PUERTOS
; =====================

HLWPORT:        EQU     $FF             ;Este es el puerto principal
                                        ;usado por el grabador.

START_RAM:      EQU     $4000           ;Dirección de comienzo de la
                                        ;RAM 'normal'

RETARDO1:       EQU     $7530           ;Estos valores son usados para poner
RETARDO2:       EQU     $0BB8           ;retardos en búsqueda y r/w de sects.

; SUBRUTINAS USADAS DE LA ROM NORMAL
; ==================================

SAVE_TAPE:      EQU     $04C5           ;SAVE PROG.
E_INVDEV:       EQU     $15C4           ;J Invalid I/O device
E_BREAKPRG:     EQU     $1B7B           ;L BREAK into program
RET_WHL:        EQU     $007B           ;LD A,(HL) / RET
LOAD_TAPE:      EQU     $0557           ;(0557h) ROM LOAD + 1
STACK_BC:       EQU     $2D2B           ;STACK-BC
PRINT_BC:       EQU     $2DE3           ;PRINT-BC
E_OUTRANGE:     EQU     $1E9F           ;B Integer out of range
CH_OPEN:        EQU     $1601           ;Channel OPEN
CLRSCR:         EQU     $0D6B           ;CLS
E_BREAKCONT:    EQU     $0552           ;D BREAK CONT, repeats
SALO_RET:       EQU     $053F           ;SAVE/LOAD return
LOAD_PRG:       EQU     $0771           ;LOAD PROG.

; VARIABLES DEL SISTEMA UTILIZADAS
; ================================

ATTRT:          EQU     $5C8F           ;ATTR_T
BORDCR:         EQU     $5C48           ;BORDCR
SCRCT:          EQU     $5C8C           ;SCR_CT

;A continuacion viene la definición de las variables del sistema del Hilow,
;no las comento todas ya que aun no estudié en profundidad su manejo y función.

;Por otra parte es muy difícil disernir el uso de c/u ya que una misma variable
;es usada para varias funciones por diferentes rutinas... (tal vez se deba al
;hecho de ahorrar la mayor cantidad posible de memoria)

L37DE:          EQU     LAST_BYTE+$17DE
L3800:          EQU     LAST_BYTE+$1800 ;2 bytes. Nro. de actualizaciones (ver NOTA 1)
L3802:          EQU     LAST_BYTE+$1802
L380B:          EQU     LAST_BYTE+$180B
L380C:          EQU     LAST_BYTE+$180C
L3BF1:          EQU     LAST_BYTE+$1BF1
L3BF2:          EQU     LAST_BYTE+$1BF2
L3BF3:          EQU     LAST_BYTE+$1BF3
L3BF5:          EQU     LAST_BYTE+$1BF5
L3D14:          EQU     LAST_BYTE+$1D14 ;Aqui se guarda el contenido previo de la RAM
                                        ;a partir de LFFC4 cuando va a ser necesario
                                        ;colocar la pila en RAM normal. Hay espacio
                                        ;para $3C bytes
L3D5B:          EQU     LAST_BYTE+$1D5B
ATR_DIR:        EQU     LAST_BYTE+$1D5D ;Dirección atributos en donde se imprimirá
                                        ;el mensaje de error (ver L023D y PR_ERRMSG)
L3D5F:          EQU     LAST_BYTE+$1D5F ;Cuando se imprimen mens. error aqui se guarda
                                        ;ancho del mensaje y luego su nro. (ver L023D)
SCR_DIR:        EQU     LAST_BYTE+$1D61 ;Dirección de pantalla en donde se imprimirá
                                        ;el mensaje de error (ver L023D)
L3D63:          EQU     LAST_BYTE+$1D63
L3D64:          EQU     LAST_BYTE+$1D64
L3D65:          EQU     LAST_BYTE+$1D65
L3D6D:          EQU     LAST_BYTE+$1D6D
L3D6E:          EQU     LAST_BYTE+$1D6E
DIRMSGS:        EQU     LAST_BYTE+$1EE9 ;Dir. tabla de mensajes ver L023D
L3EEB:          EQU     LAST_BYTE+$1EEB
L3EEC:          EQU     LAST_BYTE+$1EEC
L3EED:          EQU     LAST_BYTE+$1EED
L3EEF:          EQU     LAST_BYTE+$1EEF
L3EF0:          EQU     LAST_BYTE+$1EF0
L3EF1:          EQU     LAST_BYTE+$1EF1
L3EF3:          EQU     LAST_BYTE+$1EF3
L3EF5:          EQU     LAST_BYTE+$1EF5
L3EF6:          EQU     LAST_BYTE+$1EF6
L3EF7:          EQU     LAST_BYTE+$1EF7
L3EF9:          EQU     LAST_BYTE+$1EF9
L3EFB:          EQU     LAST_BYTE+$1EFB
L3EFD:          EQU     LAST_BYTE+$1EFD
L3F19:          EQU     LAST_BYTE+$1F19 ;Cuando salva progs. desde C/M aquí se guardan
                                        ;las cabeceras a la espera del bloque $FF.
L3F2B:          EQU     LAST_BYTE+$1F2B
L3F2D:          EQU     LAST_BYTE+$1F2D
L3F2F:          EQU     LAST_BYTE+$1F2F
L3F31:          EQU     LAST_BYTE+$1F31
RUNMI_SP:       EQU     LAST_BYTE+$1F33 ;Aqui se guarda la dirección de retorno de
                                        ;la rutina de servicio al NMI.
AUX_STACK:      EQU     LAST_BYTE+$1FE6 ;Aparantemente aquí se coloca el stack cuando
                                        ;se están cargando o salvando archivos.
COPY_STACK:     EQU     LAST_BYTE+$1FE8 ;Aqui se pone el stack cuando se efectuan
                                        ;copias de archivos.
NMI_STACK:      EQU     LAST_BYTE+$1FFC ;Aqui se guarda el SP cuando se da servicio a
                                        ;un NMI (también es el SP de los juegos).
RAMHLW:         EQU     LAST_BYTE+$1FFF ;Fin de la RAM del sistema.

; NOTA 1:       El HiLow usa dos directorios, uno de ellos contiene el
;               nro.  de actualizaciones+1, es decir, que ese es el más
;               reciente y por lo tanto el que contiene la última
;               actualización, también puede ocurrir que ambos sean
;               iguales.
;
;               En ninguno de estos 2 casos se considera que haya un
;               error en el directorio, pero si uno de ellos contiene un
;               número de actualizaciones mayor a 1, entonces se
;               considera que hay error.
;
;               Para indicar esta condición se pone a 1 el bit 15 del
;               nro.  de actualizaciones.  (ver fragmento con la
;               etiqueta NOTA1)

;               .END
;
; #########################################################################
; # Héctor De Armas -------------------------------- Fidonet : 4:850/3.22 #
; #########################################################################
