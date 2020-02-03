;---------------------------------------------------------------------------
;
;  _____ __ __ ___ ___      _____       _   _        _____         _   _   
; |__   |  |  | . |_  |    |_   _|___ _| |_| |_ _   |   __|___ ___| |_| |_ 
; |   __|-   -| . |_| |_     | | | . | . | . | | |  |   __| . |  _|  _|   |
; |_____|__|__|___|_____|    |_| |___|___|___|_  |  |__|  |___|_| |_| |_|_|
;                                           |___|                         
;                                                              Version 1.0
;
;
; A Direct-Threaded Forth for the ZX81 microcomputer *
; 16 bit cell, 8 bit char, 8 bit (byte) adrs unit
;    Z80 BC = Forth TOS (top Param Stack item)
;        HL =       W    working register
;        DE =       IP   Interpreter Pointer
;        SP =       PSP  Param Stack Pointer
;     (RSP) =       RSP  Return Stack Pointer
;    A, alternate register set = temporaries
;
; * This Forth was developed from the ZX81 Forth published by Micro Sistemas
; magazine and use a lot of ideas and code from Bradford Rodriguez's CamelForth.
;
;
; Memory map:
;
;   4091h             Dfile (start with a HALT code)
;   43ABh             Forth system variables
;   43C5h             Key table
;   4413h             Chars definition table
;   446Bh             ASCII to ZX conversion table
;   44EBh             Forth kernel
;   ? h (DP)          Forth dictionary (user RAM)
;   ? h (DP+44h)      PAD buffer
;   RAMTOP-100h       End of parameter stack (S0), grows down
;                     and start of Terminal Input Buffer (TIB)
;   RAMTOP            Return stack (R0), grows down
;
;
;
; Header structure:
;
;  D7           D0
; +---+-----------+    P - Precedence bit, equals 1 for an IMMEDIATE word.
; |S|P|  length   |    S - Smudge bit, used to prevent FIND from finding this word.
; +-+-+-----------+
; |               |
; |-    name     -|
; |               |
; +---------------+
; |               |
; |-    link     -|    Link - points to the previous word's Length byte.
; |               |
; ~~~~~~~~~~~~~~~~~
; |               |
; |-             -|
; |               |
; +---------------+
;


; TASM cross-assembler definitions

#define db .byte
#define dw .word
#define defb .byte
#define defw .word
#define ds .block
#define org .org
#define equ .equ
#define end .end

; some useful ROM routines

RESET		equ	$0000
SLOWFAST	equ	$0207
KSCAN           equ     $02bb
SETFAST		equ	$02E7
SAVE            equ     $02F6
NEXTLINE	equ	$0676
DECODEKEY	equ	$07bd
PRINTAT		equ	$08f5
MAKEROOM	equ	$099e
CLS		equ	$0a2a
STACK2BC	equ	$0bf5
STACK2A		equ	$0c02
CLASS6		equ	$0d92
FINDINT		equ	$0ea7
FAST		equ	$0f23
SLOW		equ	$0f2b
BREAK_1		equ	$0f46
DEBOUNCE	equ	$0f4b
SETMIN		equ	$14BC


; SYSVARS which aren't saved

ERR_NR		equ	$4000
FLAGS		equ	$4001
ERR_SP		equ	$4002
RAMTOP		equ	$4004
MODE		equ	$4006
PPC		equ	$4007

		org	$4009

; SYSVARS which are. This is the start of the .P

VERSN:		db	0
E_PPC:		dw	0
D_FILE:		dw	dfile
DF_CC:		dw	dfile+1
VARS:		dw	vars
DEST:		dw	0
E_LINE:		dw	last
CH_ADD:		dw	last-1
X_PTR:		dw	0
STKBOT:		dw	last
STKEND:		dw	last
BERG:		db	0
MEM:		dw	MEMBOT
		db	0
DF_SZ:		db	2
S_TOP:		dw	1
LAST_K:		db	$FF,$FF,$FF
MARGIN:		db	55
NXTLIN:		dw	line1
OLDPPC:		dw	0
FLAGX:		db	0
STRLEN:		dw	0
T_ADDR:		dw	$0C8D
SEED:		dw	0
FRAMES:		dw	$FFFF
COORDS:		db	0,0
PR_CC:		db	$BC
S_POSN:		db	33,24
CDFLAG:		db	01000000B

PRTBUF:		ds	33

MEMBOT:		ds	30			      ; calculator's scratch
		ds	2

;= First BASIC line, calls ASM ==================================

line1:
   db $00,$01        ; line number
   dw line2-$-2      ; line length
   db   $f9,$d4                     ; RAND USR
   db   $1c,$7e,$8f,$1d,$e4,$00,$00
   db   $76                         ; N/L


;= Second BASIC line, RUN      ==================================

line2:
   db   0,2                         ; line number
   dw   dfile-$-2                   ; line length
   db   $f7                         ; RUN
   db   $76                         ; N/L

;- Display file --------------------------------------------

dfile:  db      $76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        db      $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$76

;- BASIC-Variables ----------------------------------------

vars:
   db   $80

;- End of program area ----------------------------


; ----------------------
; Forth system variables

S0:             ds      2       ;Base value of the parameter stack
R0:             ds      2       ;Base value of the return stack
RSP:            ds      2       ;Return Stack Pointer
TIB:            ds      2       ; Terminal Input Buffer
LBP:            ds      2       ; Line Buffer Pointer
STATE:          ds      2       ; Contain the compilation state
BASE:           ds      2       ; Current number base, used for input and output
                                ; conversion
HLD:            ds      2       ; Holds the address of the last character during
                                ; numeric output conversion
CUR_POS:        ds      2       ; Position of cursor on the screen
DP:             dw      last    ; Dictionary Pointer
CONTEXT:        dw      LAST    ; A pointer to the vocabulary within which
                                ; dictionary searches will first begin
CURRENT:        dw      LAST    ; A pointer to the vocabulary where new
                                ; definitions are created
LAST:           dw      W_DOTPAREN ; Last word defined in CURRENT vocabulary


; ****************
; ** KEY TABLES **
; ****************

; -------------------------------
; THE 'UNSHIFTED' CHARACTER CODES
; -------------------------------

K_UNSHIFT:
        db    $5a             ; Z
        db    $58             ; X
        db    $43             ; C
        db    $56             ; V
        db    $41             ; A
        db    $53             ; S
        db    $44             ; D
        db    $46             ; F
        db    $47             ; G
        db    $51             ; Q
        db    $57             ; W
        db    $45             ; E
        db    $52             ; R
        db    $54             ; T
        db    $31             ; 1
        db    $32             ; 2
        db    $33             ; 3
        db    $34             ; 4
        db    $35             ; 5
        db    $30             ; 0
        db    $39             ; 9
        db    $38             ; 8
        db    $37             ; 7
        db    $36             ; 6
        db    $50             ; P
        db    $4f             ; O
        db    $49             ; I
        db    $55             ; U
        db    $59             ; Y
        db    $0d             ; NEWLINE
        db    $4c             ; L
        db    $4b             ; K
        db    $4a             ; J
        db    $48             ; H
        db    $20             ; SPACE
        db    $2e             ; .
        db    $4d             ; M
        db    $4e             ; N
        db    $42             ; B

; -----------------------------
; THE 'SHIFTED' CHARACTER CODES
; -----------------------------


K_SHIFT:
        db    $3a             ; :
        db    $3b             ; ;
        db    $3f             ; ?
        db    $2f             ; /
        db    $00             ;
        db    $00             ;
        db    $00             ;
        db    $00             ;
        db    $00             ;
        db    $5b             ; [
        db    $5d             ; ]
        db    $26             ; &
        db    $5e             ; ^
        db    $27             ; '
        db    $21             ; !
        db    $40             ; @
        db    $23             ; #
        db    $25             ; %
        db    $02             ; KEY LEFT
        db    $08             ; BACKSPACE
        db    $74             ; GRAPHICS
        db    $03             ; KEY RIGHT
        db    $01             ; KEY UP
        db    $04             ; KEY DOWN
        db    $22             ; "
        db    $29             ; )
        db    $28             ; (
        db    $24             ; $
        db    $5f             ; _
        db    $00             ;
        db    $3d             ; =
        db    $2b             ; +
        db    $2d             ; -
        db    $5c             ; \
        db    $00             ;
        db    $2c             ; ,
        db    $3e             ; >
        db    $3c             ; <
        db    $2a             ; *




; ------------------
; char-set (symbols)
; ------------------

chars:
; $21 - Character: '!'          CHR$(33)

        db    %00000000
        db    %00010000
        db    %00010000
        db    %00010000
        db    %00010000
        db    %00000000
        db    %00010000
        db    %00000000

; $23 - Character: '#'          CHR$(35)

        db    %00000000
        db    %00001001
        db    %00010010
        db    %01111111
        db    %00100100
        db    %11111110
        db    %01001000
        db    %10010000

; $25 - Character: '%'          CHR$(37)

        db    %00000000
        db    %01100010
        db    %01100100
        db    %00001000
        db    %00010000
        db    %00100110
        db    %01000110
        db    %00000000

; $26 - Character: '&'          CHR$(38)

        db    %00000000
        db    %00010000
        db    %00101000
        db    %00010000
        db    %00101010
        db    %01000100
        db    %00111010
        db    %00000000

; $27 - Character: '''          CHR$(39)

        db    %00000000
        db    %00010000
        db    %00010000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000

; $40 - Character: '@'          CHR$(64)

        db    %00000000
        db    %00111100
        db    %01001010
        db    %01010110
        db    %01011110
        db    %01000000
        db    %00111100
        db    %00000000

; $5B - Character: '['          CHR$(91)

        db    %00000000
        db    %00001110
        db    %00001000
        db    %00001000
        db    %00001000
        db    %00001000
        db    %00001110
        db    %00000000

; $5C - Character: '\'          CHR$(92)

        db    %00000000
        db    %00000000
        db    %01000000
        db    %00100000
        db    %00010000
        db    %00001000
        db    %00000100
        db    %00000000

; $5D - Character: ']'          CHR$(93)

        db    %00000000
        db    %01110000
        db    %00010000
        db    %00010000
        db    %00010000
        db    %00010000
        db    %01110000
        db    %00000000

; $5E - Character: '^'          CHR$(94)

        db    %00000000
        db    %00010000
        db    %00111000
        db    %01010100
        db    %00010000
        db    %00010000
        db    %00010000
        db    %00000000

; $5F - Character: '_'          CHR$(95)

        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %00000000
        db    %11111111

; ----------------------------------------
;  ASCII to ZX character conversion table
; ----------------------------------------
;
asciichar:
  db $00,$01,$0B,$02,$0D,$03,$04,$05,$10,$11,$17,$15,$1A,$16,$1B,$18   ;32-47
  db $1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$0E,$19,$13,$14,$12,$0F   ;48-63
  db $06,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34   ;64-79
  db $35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$07,$08,$09,$0A,$0C   ;80-95
  db $86,$A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4   ;96-111
  db $B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$87,$88,$89,$8A,$8C   ;112-127
  db $80,$81,$8B,$82,$8D,$83,$84,$85,$90,$91,$97,$95,$9A,$96,$9B,$98   ;128-143
  db $9C,$9D,$9E,$9F,$A0,$A1,$A2,$A3,$A4,$A5,$8E,$99,$93,$94,$92,$8F   ;144-159



; -------------------------
;  Wait for a key routines
; -------------------------
;
WAIT_KEY:
        call    KSCAN
        ld      b,h
        ld      c,l
        ld      d,c
        inc     d
        jr      z,WAIT_KEY              ;
        ld      (LAST_K),hl             ;LAST-KEY
        call    DECODEKEY
        jr      nc,WAIT_KEY             ;jump back in case of multiples keys
        ld      de,K_UNSHIFT-$7e
        add     hl,de
        ret


;; Auto Repeat Key
REP_KEY:
        ld      hl,($407b)              ;sv Time - Autorepeat timer
        ld      a,h
        or      l
        call    ST_DLY
        jr      nz,W_DLY
        ld      hl,$0020
W_DLY:  ld      ($407b),hl
R_KEY:  call    KSCAN
        ld      c,l
        inc     c
        jr      z,ST_DLY                ;
        ld      de,(LAST_K)             ;LAST-KEY
        and     a
        sbc     hl,de
        jr      nz,R_KEY                ;
        ld      hl,($407b)
        dec     hl
        ld      ($407b),hl              ;sv Time - Autorepeat timer
        ld      a,h
        or      l
        jr      nz,R_KEY                ;
        ret

ST_DLY:
        ld      hl,$300
        ld      ($407b),hl
        ret

; ---


X_KEY:  exx
NOKEY:  call    REP_KEY
        call    WAIT_KEY
        ld      a,(hl)
        or      a
        jr      z,NOKEY
        ld      hl,MODE
        cp      $0d
        jr      z,CHG
        cp      $20                     ; control key?
        jr      c,NOGR
        cp      $74                     ; GRAPHICS
        jr      nz,NOCHG
        ld      a,(hl)
        xor     $04
        ld      (hl),a
        jr      NOKEY
NOCHG:  bit     2,(hl)
        jr      z,NOGR
        add     a,$20
        cp      $60
        jr      nc,NOGR
        add     a,$40
        jr      NOGR

CHG:    res     2,(hl)
NOGR:   exx
        ret

; ------------------
;  Clear the screen
; ------------------
;
X_CLS:
        ld      hl,dfile+1
        ld      (CUR_POS),hl
        ld      bc,$0418
CLS2:   ld      a,(hl)
        cp      $76
        jr      z,CLS1
        ld      (hl),$00
CLS1:   inc     hl
        dec     c
        jr      nz,CLS2
        djnz    CLS2
        ret

; ---------------------
;  EMIT execution code
; ---------------------
; 
X_EMIT: exx
        ld      hl,(CUR_POS)
        cp      $0d                     ; NEWLINE ?
        jr      z,EMIT_CR               ; Jump if it is NEWLINE
        cp      $08                     ; Backspace ?
        jr      z,BACKSPACE             ; Jump if it is Backspace (shift 0)

        ex de,hl                        ; Convert the ASCII to ZX chr$ code
        sub 32                          ;
        ld hl,asciichar                 ;
        ld c,a                          ;
        ld b,0                          ;
        add hl,bc                       ;
        ld a,(hl)                       ;
        ex de,hl                        ;

        and     $bf                     ; Clear the bit 6 of the ZX chr$ code
        ld      (hl),a
        inc     hl
        ld      a,(hl)
        cp      $76
        jr      nz,AT_CUR_POS
        inc     hl
QSCR:   call    QSCR_UP

AT_CUR_POS:
        ld      (CUR_POS),hl
        exx
        ret

EMIT_CR:
        ld      a,(hl)
        inc     hl
        cp      $76
        jr      nz,EMIT_CR
        jr      QSCR

BACKSPACE:
        dec     hl
        ld      a,(hl)
        cp      $76
        jr      nz,QSTART_DFILE
        dec     hl
QSTART_DFILE:
        ld      de,dfile
        or      a
        ex      de,hl
        sbc     hl,de
        ex      de,hl
        jr      c,CLR_POS               ; Jump if inside of screen
        inc     hl
        inc     hl
CLR_POS:
        ld      (hl),$00                ; Clear the screen position
        jr      AT_CUR_POS

; Scroll the screen ?
QSCR_UP:
        ld      de,(VARS)
        or      a
        ex      de,hl
        sbc     hl,de
        ex      de,hl
        ret     nz

;-------------------
; SCROLL UP routine
;-------------------

SCRUP:  ld      hl,$21
        ld      de,dfile
        add     hl,de
        ld      bc,$2f7
        ldir
        xor     a
        ld      b,$20
        ex      de,hl
        push    hl
SCRUP1:
        inc     hl
        ld      (hl),a
        djnz    SCRUP1
        pop     hl
        inc     hl
        ret

;----------------------
; Print String routine
;----------------------
; Print a string addressed by HL and length given by C
;

PR_STRING:
        ld      a,(hl)
        call    X_EMIT
        inc     hl
        dec     c
        jr      nz,PR_STRING
        ret

; ------------------------------------
;  Set the default characters paterns
; ------------------------------------
;
C_SETCHR:
        exx
        ld hl,$1e00
        ld de,$3000
        ld bc,8
        push bc
        ldir
        ld hl,chars
        ld bc,80
        ldir
        pop bc
        push bc
        push hl
        ld hl,$1e58
        ldir
        pop hl
        pop bc
        ldir
        ld hl,$1e68
        ld bc,$408
        ldir
        exx
        ld a,$30
        ld i,a
        jp NEXT



; DOCOLON, entered by CALL ENTER to enter a new 
; high-level thread (colon def'n.)
; (internal code fragment, not a Forth word)

DOCOLON:
        ld      hl,(RSP)        ;push old IP on ret stack
        dec     hl
        ld      (hl),d
        dec     hl
        ld      (hl),e
        ld      (RSP),hl
        pop     hl              ;pfa -> IP
        ld      e,(hl)          ;inline NEXTHL
        inc     hl
        ld      d,(hl)
        inc     hl
        ex      de,hl
        jp      (hl)

; DODOES, code action of DOES> clause
; entered by       CALL fragment
;                  parameter field
;                       ...
;        fragment: CALL DODOES
;                  high-level thread
; Enters high-level thread with address of
; parameter field on top of stack.
; (internal code fragment, not a Forth word)

C_DODOES:
        ld      hl,(RSP)
        dec     hl
        ld      (hl),d
        dec     hl
        ld      (hl),e
        ld      (RSP),hl
        pop     de              ;adrs of new thread -> IP
        pop     hl              ;adrs of parameter field
        push    bc              ;push old TOS onto stack
        ld      b,h
        ld      c,l
        jp      NEXT

; -------------------------
;  Forth words definitions
; -------------------------

; --------------
; BRANCH  ( -- )
; branch always

W_BRANCH:
        db $06,"BRANCH"
        dw $0000
C_BRANCH:
        ld      a,(de)          ;get inline value -> IP
        ld      l,a
        inc     de
        ld      a,(de)
        ld      h,a
        ld      e,(hl)          ;inline NEXTHL
        inc     hl
        ld      d,(hl)
        inc     hl
        ex      de,hl
        jp      (hl)

; ----------------
; 0BRANCH  (f -- )
; branch if TOS zero

W_0BRANCH:
        db $07,"0BRANCH"
        dw W_BRANCH
C_0BRANCH:
        ld      a,b
        or      c               ; test old TOS
        pop     bc              ; pop new TOS
        jr      z,C_BRANCH      ; if old TOS=0, branch
        inc     de              ; else skip inline value
        inc     de

; The heart of FORTH! The NEXT engine
NEXT:   ex      de,hl
NEXTHL: ld      e,(hl)          ;entry point used when IP is already in HL
        inc     hl
        ld      d,(hl)
        inc     hl
        ex      de,hl
        jp      (hl)

; -----------------
; (DO)  (n1 n2 -- )
; The run-time proceedure compiled by DO which moves the loop control
; parameters to the return stack.
;
W_XDO:
        db $04,"(DO)"
        dw W_0BRANCH
C_XDO:
        ex      de,hl
        ex      (sp),hl   ; IP on stack, limit in HL
        ex      de,hl
        ld      hl,8000h
        or      a
        sbc     hl,de     ; 8000-limit in HL
        ex      de,hl
        ld      hl,(RSP)  ; push this fudge factor
        dec     hl
        ld      (hl),d    ;    onto return stack
        dec     hl        ;    for later use by 'I'
        ld      (hl),e
        ex      de,hl
        add     hl,bc     ; add fudge to start value
        ex      de,hl
        dec     hl        ; push adjusted start value
        ld      (hl),d    ;    onto return stack
        dec     hl        ;    as the loop index.
        ld      (hl),e
        ld      (RSP),hl
        pop     de        ; restore the saved IP
        pop     bc        ; pop new TOS
        jp      NEXT

;---------------
; (LOOP)  ( -- )
; Run-time proceedure compiled by LOOP which increases the index and
; test for loop completion.
;
W_XLOOP:
        db $06,"(LOOP)"
        dw W_XDO
C_XLOOP:
        exx
        ld bc,1
LOOPTST:
        ld      hl,(RSP)
        ld      a,(hl)          ; get the loop index
        or      a
        adc     a,c             ; increment w/overflow test
        ld      (hl),a          ; save the updated index (low byte)
        inc     hl
        ld      a,(hl)
        adc     a,b
        jp      pe,LOOPTERM     ; overflow=loop done
        ; continue the loop
        ld      (hl),a          ; save the updated index (hi byte)
        exx
        jr      C_BRANCH             ; take the inline branch
LOOPTERM: ; terminate the loop
        inc     hl              ; discard the loop info
        inc     hl
        inc     hl
        ld      (RSP),hl
        exx
        inc de                  ; skip the inline branch
        inc de
        jp      NEXT

; ----------------
; (+LOOP)  (n -- )
; The run-time proceedure compiled by +LOOP, which increments the loop
; index by n and tests for loop completion.
;
W_XPLOOP:
        db $07,"(+LOOP)"
        dw W_XLOOP
C_XPLOOP:
        pop hl      ; this will be the new TOS
        push bc
        ld b,h
        ld c,l
        exx
        pop bc      ; old TOS = loop increment
        jr LOOPTST

; ----------
; I  ( -- n)
; Used within a DO-LOOP to copy the loop index to the stack.
;
W_I:
        db $01,"I"
        dw W_XPLOOP
C_I:
        push bc         ; push old TOS
        exx
        ld      hl,(RSP)
GCLI:   ld      e,(hl)  ; get current loop index
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)  ; get fudge factor
        inc     hl
        ld      b,(hl)
        ex      de,hl
        or      a
        sbc     hl,bc   ; subtract fudge factor,
        push    hl
        exx
        pop     bc      ;   returning true index
        jp      NEXT

; ----------
; J  ( -- n)
; Used within a DO-LOOP to copy the loop index for the second innermost
; DO loop to the stack.
;
W_J:
        db $01,"J"
        dw W_I
C_J:
        push    bc
        exx
        ld      hl,(RSP)
        ld      bc,4
        add     hl,bc
        jr      GCLI

; -------------
; LEAVE  ( -- )
; Forces termination of a DO loop at the next LOOP or +LOOP by setting the
; loop counter equal to the limit-1.
;
W_LEAVE:
        db $05,"LEAVE"
        dw W_J
C_LEAVE:
        push    de              ;save IP
        ld      hl,(RSP)
        ld      de,$7fff
        ld      (hl),e
        inc     hl
        ld      (hl),d
        pop     de              ;restore IP
        jp      NEXT


;-------------
; EXIT  ( -- )
; exit a colon definition

W_EXIT:
        db $04,"EXIT"
        dw W_LEAVE
C_EXIT:
        ld      hl,(RSP)        ;pop old IP from ret stack
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      (RSP),hl
        ex      de,hl          ;inline NEXT
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ex      de,hl
        jp      (hl)

;-------------
; LIT  ( -- n)
; fetch inline literal to stack
;
W_LIT:
        db      $03,"LIT"
        dw      W_EXIT
C_LIT:
        push    bc
        ld      a,(de)
        inc     de
        ld      c,a
        ld      a,(de)
        inc     de
        ld      b,a
        jp      NEXT

;--------------------
; EXECUTE  (addr -- )
; execute Forth word at addr
;
W_EXECUTE:
        db      $07,"EXECUTE"
        dw      W_LIT
C_EXECUTE:
        ld     h,b
        ld     l,c
        pop    bc
        jp     (hl)

; -----------------
; VARIABLE  (n -- )
;     CREATE , ;
; define a Forth variable
;
W_VARIABLE:
        db $08,"VARIABLE"
        dw W_EXECUTE
C_VARIABLE:
        call DOCOLON
        dw C_CREATE
        dw C_COMMA
        dw C_EXIT

; DOVAR, code action of VARIABLE, entered by CALL
; DOCREATE, code action of newly created words
DOCREATE:
DOVAR:     ; ( -- addr)
        pop     hl      ; parameter field address
        push    bc      ; push old TOS
        ld      b,h     ; pfa = variable's adrs -> TOS
        ld      c,l
        jp      NEXT

; -----------------
; CONSTANT  (n -- )
;     CREATE , DOES> (machine code fragment)
; define a Forth constant
;
W_CONSTANT:
        db $08,"CONSTANT"
        dw W_VARIABLE
C_CONSTANT:
        call DOCOLON
        dw C_CREATE
        dw C_COMMA
        dw C_XDOES

; DOCON, code action of CONSTANT,
; entered by CALL DOCON
DOCON:  pop     hl              ; parameter field address
        push    bc              ; old TOS
        ld      c,(hl)          ; fetch contents of parameter
        inc     hl              ; field -> TOS
        ld      b,(hl)
        jp      NEXT

; -------------
; EMIT  (c -- )
; output character to console
;
W_EMIT:
        db $04,"EMIT"
        dw W_CONSTANT
C_EMIT:
        ld      a,c
        pop     bc              ;get new TOS
EMIT1:  call    X_EMIT
        jp      NEXT

; ------------
; CLS  ( -- )
; Clear screen
;
W_CLS:
        db $03,"CLS"
        dw W_EMIT
C_CLS:
        push    bc
        call    X_CLS
        pop     bc
        jp      NEXT

; ------------
; KEY  ( -- c)
; get character from keyboard
;
W_KEY:
        db $03,"KEY"
        dw W_CLS
C_KEY:
        push    bc
        call    X_KEY
        ld      b,$00
        ld      c,a
        jp      NEXT

; ---------------
; DUP  (x -- x x)
; duplicate top of stack
;

W_DUP:
        db $03,"DUP"
        dw W_KEY
C_DUP:
        push    bc
        jp      NEXT

; ----------------------------
; ?DUP  (x -- 0) if zero
;       (x -- x x) if nonzero
; DUP if nonzero
;
W_QUERYDUP:
        db $04,"?DUP"
        dw W_DUP
C_QUERYDUP:
        ld      a,b
        or      c
        jr      nz,C_DUP
        jp      NEXT

; -------------
; DROP  (x -- )
; drop top of stack
;
W_DROP:
        db $04,"DROP"
        dw W_QUERYDUP
C_DROP:
        pop     bc
        jp      NEXT

; ----------------------
; SWAP  (x1 x2 -- x2 x1)
; swap top two items
;
W_SWAP:
        db $04,"SWAP"
        dw W_DROP
C_SWAP:
        pop     hl
        push    bc
        ld      b,h
        ld      c,l
        jp      NEXT

; ----------------------------
; OVER  (x1, x2 -- x1, x2, x1)
; per stack diagram
;
W_OVER:
        db $04,"OVER"
        dw W_SWAP
C_OVER:

        pop     hl
        push    hl
        push    bc
        ld      b,h
        ld      c,l
        jp      NEXT

; ---------------------------
; ROT  (x1 x2 x3 -- x2 x3 x1)
; per stack diagram
;
W_ROT:
        db $03,"ROT"
        dw W_OVER
C_ROT:
        pop     hl
        ex      (sp),hl
        push    bc
        ld      b,h
        ld      c,l
        jp      NEXT

; -----------------------
; >R  ( n --   R:  -- n )
; push to return stack
;
W_TOR:
        db $02,">R"
        dw W_ROT
C_TOR:
        ld      hl,(RSP)
        dec     hl
        ld      (hl),b
        dec     hl
        ld      (hl),c                  ;/ (R1)<--(DE)
        ld      (RSP),hl                ;  (RP)<--(RP)-2
        pop     bc
        jp      NEXT

; -----------------------
; R>  ( -- n    R: n -- )
; pop from return stack
;
W_RFROM:
        db $02,"R>"
        dw W_TOR
C_RFROM:
        push    bc
        ld      hl,(RSP)
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      (RSP),hl
        jp      NEXT

; ----------
; R@ ( -- n)
; fetch from rtn stk
;
W_RFETCH:
        db $02,"R@"
        dw W_RFROM
C_RFETCH:
        push    bc
        ld      hl,(RSP)
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        jp      NEXT

; ---------------
; SP@  ( -- addr)
; get data stack pointer
;
W_SPFETCH:
        db $03,"SP@"
        dw W_RFETCH
C_SPFETCH:
        push    bc
        ld      hl,0
        add     hl,sp
        ld      b,h
        ld      c,l
        jp      NEXT

; -----------
; SP!  ( -- )
; set data stack pointer to initial value (S0).
;
W_SPSTORE:
        db $03,"SP!"
        dw W_SPFETCH
C_SPSTORE:
        ld      hl,(S0)
        ld      sp,hl
        pop     hl              ; adjust SP
        jp      NEXT

; -----------
; RP!  ( -- )
; set return stack pointer to initial value (R0).
;
W_RPSTORE:
        db $03,"RP!"
        dw W_SPSTORE
C_RPSTORE:
        ld      hl,(R0)
        ld      (RSP),hl
        jp      NEXT

; ---------------
; !  (n addr -- )
; store cell in memory
;
W_STORE:
        db $01,"!"
        dw W_RPSTORE
C_STORE:
        ld      h,b
        ld      l,c
        pop     bc
        ld      (hl),c
        inc     hl
        ld      (hl),b
        pop     bc              ;new TOS
        jp      NEXT

; -----------------
; C!  (c addr -- )
; store char in memory
;
W_CSTORE:
        db $02,"C!"
        dw W_STORE
C_CSTORE:

        ld      h,b            ;addr in HL
        ld      l,c
        pop     bc             ;char in BC
        ld      (hl),c
        pop     bc             ;new TOS
        jp      NEXT

; -------------
; @ (addr -- n)
; fetch cell from memory
;
W_FETCH:
        db $01,"@"
        dw W_CSTORE
C_FETCH:
        ld      h,b
        ld      l,c
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        jp      NEXT

; ----------------
; C@  (addr -- b)
; fetch char from memory
;
W_CFETCH:
        db $02,"C@"
        dw W_FETCH
C_CFETCH:
        ld      a,(bc)
        ld      c,a
        ld      b,0
        jp      NEXT

; --------------------------
; +  (n1/u1 n2/u2 -- n3/u3)
; add n1+n2
;
W_PLUS:
        db $01,"+"
        dw W_CFETCH
C_PLUS:
        pop     hl
        add     hl,bc
        ld      b,h
        ld      c,l
        jp      NEXT

; -----------------
; -  (n1 n2 -- n3)
; subtract n1-n2
;
W_MINUS:
        db $01,"-"
        dw W_PLUS
C_MINUS:
        pop     hl
        and     a
        sbc     hl,bc
        ld      b,h
        ld      c,l
        jp      NEXT

; ------------------
; AND  (n1 n2 -- n3)
; logical AND
;
W_AND:
        db $03,"AND"
        dw W_MINUS
C_AND:
        pop     hl
        ld      a,b
        and     h
        ld      b,a
        ld      a,c
        and     l
        ld      c,a
        jp      NEXT

; -----------------
; OR  (n1 n2 -- n3)
; logical OR
;
W_OR:
        db $02,"OR"
        dw W_AND
C_OR:
        pop     hl
        ld      a,b
        or      h
        ld      b,a
        ld      a,c
        or      l
        ld      c,a
        jp      NEXT

; ------------------
; XOR  (n1 n2 -- n3)
; logical XOR
;
W_XOR:
        db $03,"XOR"
        dw W_OR
C_XOR:
        pop     hl
        ld      a,b
        xor     h
        ld      b,a
        ld      a,c
        xor     l
        ld      c,a
        jp      NEXT

; ------------------
; NEGATE  (x1 -- x2)
; two's complement
;
W_NEGATE:
        db $06,"NEGATE"
        dw W_XOR
C_NEGATE:
        ld      a,b
        cpl
        ld      b,a
        ld      a,c
        cpl
        ld      c,a
        inc     bc
        jp      NEXT

; ----------------------
; ?NEGATE  (n1 n2 -- n3)
;    0< IF NEGATE THEN ;
; negate n1 if n2 negative
;
W_QNEGATE:
        db $07,"?NEGATE"
        dw W_NEGATE
C_QNEGATE:
        sla     b
        pop     bc
        jr      c,C_NEGATE
        jp      NEXT

; --------------
; 1+  (n1 -- n2)
; add 1 to TOS
;
W_ONEPLUS:
        db $02,"1+"
        dw W_QNEGATE
C_ONEPLUS:

        inc     bc
        jp      NEXT

; --------------
; 2+  (n1 -- n2)
; add 2 to TOS
;
W_TWOPLUS:
        db $02,"2+"
        dw W_ONEPLUS
C_TWOPLUS:

        inc     bc
        inc     bc
        jp      NEXT

; --------------
; 1-  (n1 -- n2)
; subtract 1 from TOS
;

W_ONEMINUS:
        db $02,"1-"
        dw W_TWOPLUS
C_ONEMINUS:

        dec     bc
        jp      NEXT

; --------------
; 2-  (n1 -- n2)
; subtract 2 from TOS
;
W_TWOMINUS:
        db $02,"2-"
        dw W_ONEMINUS
C_TWOMINUS:

        dec     bc
        dec     bc
        jp      NEXT

; --------------
; 2*  (n1 -- n2)
; arithmetic left shift
;
W_2STAR:
        db $02,"2*"
        dw W_TWOMINUS
C_2STAR:

        sla     c
        rl      b
        jp      NEXT

; --------------
; 2/  (n1 -- n2)
; arithmetic right shift
;
W_2SLASH:
        db $02,"2/"
        dw W_2STAR
C_2SLASH:

        sra     b
        rr      c
        jp      NEXT

; ---------------------
; +!  (n addr --  )
; add cell to memory
;
W_PLUSSTORE:
        db $02,"+!"
        dw W_2SLASH
C_PLUSSTORE:

        pop     hl
        ld      a,(bc)
        add     a,l
        ld      (bc),a
        inc     bc
        ld      a,(bc)
        adc     a,h
        ld      (bc),a
        pop     bc               ;new TOS
        jp      NEXT

; ------------
; 0=  (n -- f)
; return true if TOS=0
;
W_0EQUAL:
        db $02,"0="
        dw W_PLUSSTORE
C_0EQUAL:
        ld      a,b
        or      c
        ld      bc,$0000
        jr      nz,ZEQU1
        dec     bc
ZEQU1:  jp      NEXT

; ------------
; 0<  (n -- f)
; true if TOS negative
;
W_ZLESS:
        db $02,"0<"
        dw W_0EQUAL
C_ZLESS:
        sla     b           ; sign bit -> cy flag
        sbc     a,a         ; propagate cy through A
        ld      b,a         ; put 0000 or FFFF in TOS
        ld      c,a
        jp      NEXT

; ---------------
; =  (x1 x2 -- f)
; test x1=x2
;
W_EQUAL:
        db $01,"="
        dw W_ZLESS
C_EQUAL:
        pop     hl
        or      a
        sbc     hl,bc       ; x1-x2 in HL, SZVC valid
        jr      z,TOSTRUE
TOSFALSE:
        ld      bc,0
        jp      NEXT

; ---------------
; <  (n1 n2 -- f)
; test n1<n2, signed
;
W_LESS:
        db $01,"<"
        dw W_EQUAL
C_LESS:
        pop     hl
LESS1:  or      a
        sbc     hl,bc       ; n1-n2 in HL, SZVC valid
; if result negative & not OV, n1<n2
; neg. & OV => n1 +ve, n2 -ve, rslt -ve, so n1>n2
; if result positive & not OV, n1>=n2
; pos. & OV => n1 -ve, n2 +ve, rslt +ve, so n1<n2
; thus OV reverses the sense of the sign bit
        jp      pe,REVSENSE  ; if OV, use rev. sense
        jp      p,TOSFALSE   ;   if +ve, result false
TOSTRUE:
        ld      bc,-1       ;   if -ve, result true
        jp      NEXT
REVSENSE:
        jp      m,TOSFALSE ; OV: if -ve, reslt false
        jr      TOSTRUE      ;     if +ve, result true


; ---------------
; >  (n1 n2 -- f)
; test n1>n2, signed
;
W_GREATER:
        db $01,">"
        dw W_LESS
C_GREATER:
        ld      h,b
        ld      l,c
        pop     bc
        jp      LESS1

; ---------------------------
; (.")  ( -- c-addr u )
;   R> COUNT 2DUP + >R TYPE;
; run-time code for ."
;
W_XDOTQUOTE:
        db $04,"(.",$22,")"
        dw W_GREATER
C_XDOTQUOTE:
        ld      a,(de)         ;load length
        ld      l,a
SPNLP:  inc     de
        ld      a,(de)
        call    X_EMIT
        dec     l
        jr      nz,SPNLP
        inc     de
        jp      NEXT

; ---------------------------------
; ."  ( -- )
;  COMPILE (.")  [ HEX ]
;  22 WORD C@ 1+ ALLOT ; IMMEDIATE
; Compile string to print
;
W_DOTQUOTE:
        db $42,".",$22
        dw W_XDOTQUOTE
C_DOTQUOTE:
        call DOCOLON
        dw C_COMPILE
        dw C_XDOTQUOTE
        dw C_LIT,$22
        dw C_WORD
        dw C_CFETCH
        dw C_ONEPLUS
        dw C_ALLOT
        dw C_EXIT

; -----------
; BL  ( -- c)
; an ASCII space
;
W_BL:
        db $02,"BL"
        dw W_DOTQUOTE
C_BL:
        push    bc
        ld      bc,$0020
        jp      NEXT

; ---------------
; TIB  ( -- addr)
; Terminal Input Buffer
;
W_TIB:
        db $03,"TIB"
        dw W_BL
C_TIB:
        push    bc
        ld      bc,TIB
        jp      NEXT

; ---------------
; LBP  ( -- addr)
; holds a pointer into TIB
; 
W_LBP:
        db $03,"LBP"
        dw W_TIB
C_LBP:
        push    bc
        ld      bc,LBP
        jp      NEXT

; ----------------
; BASE  ( -- addr)
; holds conversion radix
;
W_BASE:
        db $04,"BASE"
        dw W_LBP
C_BASE:
        push    bc
        ld      bc,BASE
        jp      NEXT

; -----------------
; STATE  ( -- addr)
; holds compiler state
; This holds 0 in interpret mode and -1 in compile mode
;
W_STATE:
        db $05,"STATE"
        dw W_BASE
C_STATE:
        push    bc
        ld      bc,STATE
        jp      NEXT

; --------------
; DP  ( -- addr)
; the dictionary pointer, which contains the address of the next
; free memory above the dictionary.
;
W_DP:
        db $02,"DP"
        dw W_STATE
C_DP:
        push    bc
        ld      bc,DP
        jp      NEXT

; ------------------
; LATEST  ( -- addr)
;     CURRENT @ @ ;
; last word in current vocabulary
;
W_LATEST:
        db $06,"LATEST"
        dw W_DP
C_LATEST:
        call DOCOLON
        dw C_CURRENT
        dw C_FETCH
        dw C_FETCH
        dw C_EXIT

; -------------------
; CONTEXT  ( -- addr)
; A system variable  pointing to the context vocabulary
;
W_CONTEXT:
        db $07,"CONTEXT"
        dw W_LATEST
C_CONTEXT:
        push    bc
        ld      bc,CONTEXT
        jp      NEXT

; -------------------
; CURRENT  ( -- addr)
; A system variable  pointing to the current vocabulary
;
W_CURRENT:
        db $07,"CURRENT"
        dw W_CONTEXT
C_CURRENT:
        push    bc
        ld      bc,CURRENT
        jp      NEXT

; ---------------
; HLD  ( -- addr)
; HOLD pointer
;
W_HLD:
        db $03,"HLD"
        dw W_CURRENT
C_HLD:
        push    bc
        ld      bc,HLD
        jp      NEXT

; ---------------
; PAD  ( -- addr)
; user PAD buffer
;    HERE 44 + ;
;
W_PAD:
        db $03,"PAD"
        dw W_HLD
C_PAD:
        call DOCOLON
        dw C_HERE
        dw C_LIT,$44
        dw C_PLUS
        dw C_EXIT

; --------------
; ABS  (n -- +n)
; absolute value
;  DUP ?NEGATE ;
;
W_ABS:
        db $03,"ABS"
        dw W_PAD
C_ABS:
        push bc
        jp C_QNEGATE

; ------------------
; UM*  (u1 u2 -- ud)
; unsigned 16x16->32 multiplication
;
W_UMSTAR:
        db $03,"UM*"
        dw W_ABS
C_UMSTAR:
        push bc
        exx
        pop bc      ; u2 in BC
        pop de      ; u1 in DE
        ld hl,0     ; result will be in HLDE
        ld a,17     ; loop counter
        or a        ; clear cy
umloop: rr h
        rr l
        rr d
        rr e
        jr nc,noadd
        add hl,bc
noadd:  dec a
        jr nz,umloop
        push de     ; lo result
        push hl     ; hi result
        exx
        pop bc      ; put TOS back in BC
        ex de,hl    ; inline NEXT
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc  hl
        ex de,hl
        jp  (hl)

; ----------------
; *  (n1 n2 -- n3)
; signed multiply
; : * UM* DROP ;
;
W_STAR:
        db $01,"*"
        dw W_UMSTAR
C_STAR:
        call DOCOLON
        dw C_UMSTAR
        dw C_DROP
        dw C_EXIT

; ------------------------
; UM/MOD  (ud u1 -- u2 u3)
; unsigned 32/16->16 multiplication
;
W_UMSLASHMOD:
        db $06,"UM/MOD"
        dw W_STAR
C_UMSLASHMOD:
        push bc
        exx
        pop bc      ; BC = divisor
        pop hl      ; HLDE = dividend
        pop de
        ld a,16     ; loop counter
        sla e
        rl d        ; hi bit DE -> carry
udloop: adc hl,hl   ; rot left w/ carry
        jr nc,udiv3
        ; case 1: 17 bit, cy:HL = 1xxxx
        or a        ; we know we can subtract
        sbc hl,bc
        or a        ; clear cy to indicate sub ok
        jr udiv4
        ; case 2: 16 bit, cy:HL = 0xxxx
udiv3:  sbc hl,bc   ; try the subtract
        jr nc,udiv4 ; if no cy, subtract ok
        add hl,bc   ; else cancel the subtract
        scf         ;   and set cy to indicate
udiv4:  rl e        ; rotate result bit into DE,
        rl d        ; and next bit of DE into cy
        dec a
        jr nz,udloop
        ; now have complemented quotient in DE,
        ; and remainder in HL
        ld a,d
        cpl
        ld b,a
        ld a,e
        cpl
        ld c,a
        push hl     ; push remainder
        push bc
        exx
        pop bc      ; quotient remains in TOS
        ex de,hl    ; inline NEXT
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc  hl
        ex de,hl
        jp  (hl)

; ----------------------
; /MOD  (n1 n2 -- n3 n4)
; signed divide/rem'dr
;    SWAP >R R@ ABS 0 ROT 
;    DUP R@ XOR >R ABS UM/MOD
;    R> ?NEGATE SWAP 
;    R> ?NEGATE SWAP ;
;
W_SLASHMOD:
        db $04,"/MOD"
        dw W_UMSLASHMOD
C_SLASHMOD:
        call DOCOLON
        dw C_SWAP
        dw C_TOR
        dw C_RFETCH
        dw C_ABS
        dw C_LIT,0
        dw C_ROT
        dw C_DUP
        dw C_RFETCH
        dw C_XOR
        dw C_TOR
        dw C_ABS
        dw C_UMSLASHMOD
        dw C_RFROM
        dw C_QNEGATE
        dw C_SWAP
        dw C_RFROM
        dw C_QNEGATE
        dw C_SWAP
        dw C_EXIT

; ------------------
; /  (n1 n2 -- quot)
; signed divide
;     /MOD SWAP DROP ;
;
W_SLASH:
        db $01,"/"
        dw W_SLASHMOD
C_SLASH:
        call DOCOLON
        dw C_SLASHMOD
        dw C_SWAP
        dw C_DROP
        dw C_EXIT

; ----------------------------
; 2DUP  (x1 x2 -- x1 x2 x1 x2)
; dup top 2 cells
;    OVER OVER ;
;
W_2DUP:
        db $04,"2DUP"
        dw W_SLASH
C_2DUP:
        pop     hl
        push    hl
        push    bc
        push    hl
        jp      NEXT

; ------------------
; 2DROP  (x1 x2 -- )
; drop top 2 cells
;    DROP DROP
;
W_2DROP:
        db $05,"2DROP"
        dw W_2DUP
C_2DROP:
        pop     bc
        pop     bc
        jp      NEXT

; -------------------------
; COUNT  (addr1 -- addr2 n)
; counted->adr/len
;     DUP 1+ SWAP C@ ;
;
W_COUNT:
        db $05,"COUNT"
        dw W_2DROP
C_COUNT:
        ld      a,(bc)
        inc     bc
        push    bc
        ld      c,a
        ld      b,0
        jp      NEXT

; ------------
; CR  (  --  )
; output newline
;
W_CR:
        db $02,"CR"
        dw W_COUNT
C_CR:
        ld      a,$0d
        call    X_EMIT
        jp      NEXT

; -------------
; SPACE  ( -- )
;   20 EMIT ;
; output a space
;
W_SPACE:
        db $05,"SPACE"
        dw W_CR
C_SPACE:
        ld      a,$20
        jp      EMIT1

; -------------------
; INPUT  (c-addr -- )
; get line from terminal until the ENTER key is pressed
;
W_INPUT:
        db $05,"INPUT"
        dw W_SPACE
C_INPUT:

        push    de              ; save IP
        ld      h,b
        ld      l,c

INP4:   ld      a,$80           ; print cursor
        call    X_EMIT          ;
INP3:   call    X_KEY           ; wait for a key
        cp      $20             ; jump if a printable character
        jr      nc,INP1         ;
        cp      $08             ; Backspace ?
        jr      z,INP2          ;
        sub     $0d             ; ENTER ?
        jr      nz,INP3         ;

;ENTER ($0D) was pressed
        ld      (hl),a          ; terminate the input string with zero
        ld      a,$08           ; Backspace (clear cursor)
        call    X_EMIT          ;
        ld      a,$20           ; print a space
        call    X_EMIT          ;
        pop     de              ; restore IP
        pop     bc              ; new TOS
        jp      NEXT

INP2:   push    hl              ; is in the start of the input buffer?
        and     a               ;
        sbc     hl,bc           ;
        pop     hl              ;
        jr      z,INP3          ;

        dec     hl              ; decrement pointer
        jr      INP5            ;

INP1:   ld      (hl),a          ; save character in input buffer
        inc     hl              ; and increment pointer
INP5:   ld      e,a
        ld      a,$08           ; clear o cursor
        call    X_EMIT
        ld      a,e             ; print character
        call    X_EMIT
        jr      INP4

; ---------------------
; TYPE  (c-addr +n -- )        type line to terminal
;     ?DUP
;     IF OVER + SWAP
;        DO I C@ EMIT LOOP
;     ELSE DROP
;     THEN ;
;
W_TYPE:
        db $04,"TYPE"
        dw W_INPUT
C_TYPE:
        pop     hl
        ld      a,b
        or      c
        jr      z,TYPE1
        call    PR_STRING
TYPE1:  pop      bc
        jp      NEXT

; --------------------------
; UD/MOD  (ud1 u2 -- u3 ud4)    32/16->32 divide
;      >R 0 R@ UM/MOD ROT ROT R> UM/MOD ROT ;
; An unsigned mixed magnitude math operation which leaves a double
; quotient ud4 and remainder u3, from a double dividend ud1 and single
; divisor u2.
;
W_UDSLASHMOD:
        db $06,"UD/MOD"
        dw W_TYPE
C_UDSLASHMOD:
        call DOCOLON
        dw C_TOR
        dw C_LIT,0
        dw C_RFETCH
        dw C_UMSLASHMOD
        dw C_ROT
        dw C_ROT
        dw C_RFROM
        dw C_UMSLASHMOD
        dw C_ROT
        dw C_EXIT

; -------------
; HOLD  (c -- )
; add char to output string
;     -1 HLD +! HLD @ C! ;
; 
W_HOLD:
        db $04,"HOLD"
        dw W_UDSLASHMOD
C_HOLD:
HOLD1:  ld      hl,(HLD)
        dec     hl
        ld      (HLD),hl
        ld      (hl),c
        pop     bc
        jp      NEXT

; ----------
; <#  ( -- )
; begin numeric conversion
;     PAD HLD ! ;
;
W_LESSHARP:
        db $02,"<#"
        dw W_HOLD
C_LESSHARP:
        call DOCOLON
        dw C_PAD
        dw C_HLD
        dw C_STORE
        dw C_EXIT

; -------------
; #  (d1 -- d2)
; convert 1 digit of output
;     BASE @ M/MOD ROT 9 OVER < IF 7 + THEN 30 + HOLD ;
;
W_SHARP:
        db $01,"#"
        dw W_LESSHARP
C_SHARP:
        call DOCOLON
        dw C_BASE
        dw C_FETCH
        dw C_UDSLASHMOD
        dw C_ROT
        dw C_DIG
        dw C_HOLD
        dw C_EXIT

C_DIG:
        ld      a,c                     ; digit in A
        add     a,$30                   ; convert to ASCII
        cp      $3a                     ; test for '9'
        jr      c,DIG1                  ; jump if a number
        add     a,$07                   ; else, it is a letter
DIG1:   ld      c,a                     ;
        jp      NEXT                    ;

; ---------------
; #S   (d1 -- d2)
; convert remaining digits
;     BEGIN # 2DUP OR 0= UNTIL ;
;
W_SHARPS:
        db $02,"#S"
        dw W_SHARP
C_SHARPS:
         call DOCOLON
SHRPS1:  dw C_SHARP             ;BEGIN
         dw C_2DUP
         dw C_OR
         dw C_0EQUAL
         dw C_0BRANCH,SHRPS1    ;UNTIL
         dw C_EXIT

; ------------------------
; #>  (0,0 -- addr, count)
; end conversion, get string
;     2DROP HLD @ PAD OVER - ;
;
W_SHARPGT:
        db $02,"#>"
        dw W_SHARPS
C_SHARPGT:
        call DOCOLON
        dw C_2DROP
        dw C_HLD
        dw C_FETCH
        dw C_PAD
        dw C_OVER
        dw C_MINUS
        dw C_EXIT

; -------------
; SIGN  (n -- ) 
; add minus sign if n<0
;    0< IF ASCII - HOLD THEN ;
;
W_SIGN:
        db $04,"SIGN"
        dw W_SHARPGT
C_SIGN:
        rl      b
        ld      c,'-'
        jp      c,HOLD1
        pop     bc
        jp      NEXT

; -----------
; U.  (u -- )
; display u unsigned
;     <# 0 #S #> TYPE SPACE ;
;
W_UDOT:
        db $02,"U."
        dw W_SIGN
C_UDOT:
        call DOCOLON
        dw C_LESSHARP
        dw C_LIT,0
        dw C_SHARPS
        dw C_SHARPGT
        dw C_TYPE
        dw C_SPACE
        dw C_EXIT

; ----------
; .  (n -- )
; display n signed
;     <# DUP ABS 0 #S ROT SIGN #> TYPE SPACE ;
;
W_DOT:
        db $01,"."
        dw W_UDOT
C_DOT:
        call DOCOLON
        dw C_LESSHARP
        dw C_DUP
        dw C_ABS
        dw C_LIT,0
        dw C_SHARPS
        dw C_ROT
        dw C_SIGN
        dw C_SHARPGT
        dw C_TYPE
        dw C_SPACE
        dw C_EXIT

; ---------------
; DECIMAL  ( -- )
; set number base to decimal
;    0A BASE ! ;
;
W_DECIMAL:
        db $07,"DECIMAL"
        dw W_DOT
C_DECIMAL:
        ld a,$0a
DEC1:   ld (BASE),a             ; assumes base<256 (acceptable)
        jp NEXT
        
; -----------
; HEX  ( -- )
; set number base to hexadecimal
;    10 BASE ! ;
W_HEX:
        db $03,"HEX"
        dw W_DECIMAL
C_HEX:
        ld a,$10
        jr DEC1

; ----------------
; HERE  ( -- addr)
; returns dictionary ptr
;    DP @ ;
;
W_HERE:
        db $04,"HERE"
        dw W_HEX
C_HERE:
        push    bc
        ld      bc,(DP)
        jp      NEXT

; --------------
; ALLOT  (n -- )
; allocate n bytes in dictionary
;    DP +! ;
;
W_ALLOT:
        db $05,"ALLOT"
        dw W_HERE
C_ALLOT:
        call DOCOLON
        dw C_DP
        dw C_PLUSSTORE
        dw C_EXIT

; ----------
; ,  (n -- )
; append cell to dictionary
;
W_COMMA:
        db $01,","
        dw W_ALLOT
C_COMMA:
        ld      hl,(DP)
        ld      (hl),c
        inc     hl
        ld      (hl),b
        inc     hl
        ld      (DP),hl
        pop     bc
        jp      NEXT

; --------------
; C,  ( c --   )
; append char to dictionary
;
W_CCOMMA:
        db $02,"C,"
        dw W_COMMA
C_CCOMMA:

        ld      hl,(DP)
        ld      (hl),c
        inc     hl
        ld      (DP),hl
        pop     bc             ;new TOS
        jp      NEXT

; ----------------------
; WORD  (char -- c-addr)
; word delimited by char
;
W_WORD:
        db $04,"WORD"
        dw W_CCOMMA
C_WORD:
        push    de              ; save IP
        ld      hl,(LBP)        ; save the input buffer pointer in HL
WRD2:   ld      a,(hl)          ; get a character 
        cp      c               ; compare with delimiter
        jr      nz,WRD1
WRD4:   inc     hl
        jr      WRD2            ; ignore delimiters before text

WRD1:   cp      $20             ; check for control characters
        jr      nc,WRD3
        and     a               ; NULL?
        jr      nz,WRD4         ; ignore control chars (CR/LF)
        ld      hl,(DP)         ; a null delimiter was found
        ld      (hl),a
        jr      WRD5

WRD3:   push    hl              ; save the start string address
WRD7:
        inc     b               ; increment counter
        inc     hl              ; increment pointer
        ld      a,(hl)          ; delimiter char?
        cp      c               ;
        jr      z,WRD6          ;
        cp      $20             ; control char?
        jr      nc,WRD7
        dec     hl

WRD6:   inc     hl              ; 
        ld      (LBP),hl        ;
        ld      de,(DP)         ; DE = dest address of string
        ld      a,b             ; save string lenght
        ld      (de),a          ;
        inc     de              ; copie the string
        pop     hl              ;
        ld      c,b             ;
        ld      b,$00           ;
        ldir                    ;
WRD5:   pop     de              ; restore IP
        ld      bc,(DP)         ; TOS = string address
        jp      NEXT

; ----------------------------------------------
; FIND  (c-addr -- c-addr 0)  if name not found
;       (c-addr -- cfa 1)     if immediate
;       (c-addr -- cfa -1)    if normal
;
; Searches the word copied at c-addr, starting from context vocabulary
;

W_FIND:
        db $04,"FIND"
        dw W_WORD
C_FIND:
        push    de              ; save IP
        ld      d,b             ; c-addr to DE
        ld      e,c
        ld      hl,(CONTEXT)    ; get the LFA of the last word in context voc.
        ld      a,(hl)          ;
        inc     hl
        ld      h,(hl)
        ld      l,a

FIND4:  push    de              ; save c-addr
        push    hl              ; save dictionary word address
        ld      c,$00
        ld      a,(de)          ; get the word lenght
        xor     (hl)            ; compare with length of the word in dictionary
        and     $bf             ; mask immed bit
        jr      nz,FIND1        ; if d'nt match, advance to next word in dictionary
        xor     (hl)
        and     $3f
        ld      b,a             ; lenght at B to be a loop counter
FIND2:  inc     hl              ; compare the two words
        inc     de              ;
        ld      a,(de)          ;
        cp      (hl)            ;
        jr      nz,FIND1        ; if d'nt match, advance to next word in dictionary
        djnz    FIND2

        ld      de,$0003        ; word match, get the CFA
        add     hl,de           ;
        pop     de              ; restore dictionary word address
        pop     bc              ; discard c-addr
        ld      a,(de)          ; get length
        and     $40             ; mask immed bit
        ld      bc,1            ; TOS = 1 (immediate word)
        jr      nz,FIND3        ;
        dec     bc              ; TOS = -1 (normal word)
        dec     bc              ;
        jr      FIND3           ;
FIND1:  pop     hl              ; restore dictionary word address
        ld      a,$3f           ; mask immed/precedence bits
        and     (hl)
        ld      d,$00           ; word length in DE
        ld      e,a             ;
        inc     de              ; +1
        add     hl,de           ; HL = LFA
        ld      e,(hl)          ; get the link to next word in dictionary
        inc     hl              ;
        ld      d,(hl)          ;
        ex      de,hl           ;
        pop     de              ; restore c-addr
        ld      a,h             ; test for end o dictionary (link = 0)
        or      l               ;
        jr      nz,FIND4        ; if nonzero, jump to continue the search
        ld      b,l             ; word not found, leave flag = 0 in TOS
        ex      de,hl           ;
FIND3:  ex      (sp),hl         ; leave CFA/c-addr in stack and IP in HL
        ld      d,h             ; restore IP
        ld      e,l             ;
        jp      NEXT

; ------------------------
; NUMBER  (addr u -- d  1)      conv. ok, number with a dot
;         (addr u -- d -1)      conv. ok, number without a dot
;         (       -- 0)         if convert error
; convert string to number
;
W_NUMBER:
        db $06,"NUMBER"
        dw W_FIND
C_NUMBER:

        pop hl                  ; HL=addr, BC=u
        exx
        ld de,0
        ld h,e                  ; D'E'H'L'=ud=0
        ld l,e                  ; 
        ld b,e
        exx
        ld      a,(hl)          ;
        cp      '-'             ; first character is minus signal?
        scf
        jr      nz,NUMB1
        and     a               ; Fc=0 for negative
        dec     bc
        inc     hl
NUMB1:  push    af              ; save signal (Fc)

NUMB5:  ld a,b
        or c
        jr z,NUMB2
        ld a,(hl)
        sub '0'
        jr c,NUMB3
        cp 10
        jr c,OKDIG
        sub 7
        cp 10
        jr c,NUMB4

OKDIG:  exx
        ld c,a
        ld a,(BASE)             ; assumes base<256 (acceptable)
        dec a
        cp c
        exx
        jr c,NUMB4

        exx
        push bc                 ; save C=digit to add in
        push de                 ; udH to stack
        ld b,h
        ld c,l                  ; (SP)HL=DEBC=ud, A=base-1
NUMB6:  add hl,bc
        ex (sp),hl
        adc hl,de
        ex (sp),hl
        dec a
        jr nz,NUMB6             ; (SP)HL=ud*base
        pop de                  ; DEHL=ud*base
        pop bc                  ; restore C=digit to add in
        add hl,bc
        ex de,hl
        ld c,b
        adc hl,bc
        ex de,hl                ; DEHL=ud*BASE+digit
        exx
        inc hl
        dec bc
        jr NUMB5

NUMB2:  dec bc                  ; bc=-1 (will be a single number)
NUMB8:  exx
        pop     af              ; restore signal (Fc)
        jr      c,NUMB7         ; jump to NUMB6 if positive (Fc=1)

        ld a,d
        cpl                     ; negate D'E'
        ld d,a
        ld a,e
        cpl
        ld e,a
        inc de

        ld a,h
        cpl                     ; negate H'L'
        ld h,a
        ld a,l
        cpl
        ld l,a
        inc hl

NUMB7:  push hl
        push de                 ; stack ud
        exx
        jp NEXT

NUMB3:  cp -2                   ; test for a dot at end of string
        jr nz,NUMB4
        ld a,c
        dec a
        jr z,NUMB8
NUMB4:  pop af                  ; error if string not exhausted or digit not valid
        jp TOSFALSE


; -----------------
; INTERPRET  ( -- )       interpret given buffer
;    BEGIN
;       BL WORD DUP C@
;    WHILE
;       FIND ?DUP
;       IF 1+ STATE @ 0= OR IF EXECUTE ELSE , THEN
;       ELSE COUNT NUMBER ?DUP
;          IF 1+ IF STATE @ IF SWAP DLITERAL THEN
;                ELSE DROP LITERAL
;                THEN
;          ELSE QUESTION
;          THEN
;       THEN ?STACK
;    REPEAT DROP ;
;
W_INTERPRET:
        db $09,"INTERPRET"
        dw W_NUMBER
C_INTERPRET:
        call DOCOLON
INTE7:  dw C_BL                         ; BEGIN
        dw C_WORD
        dw C_DUP
        dw C_CFETCH
        dw C_0BRANCH,INTE1              ; WHILE
        dw C_FIND
        dw C_QUERYDUP
        dw C_0BRANCH,INTE2              ; IF
        dw C_ONEPLUS
        dw C_STATE
        dw C_FETCH
        dw C_0EQUAL
        dw C_OR
        dw C_0BRANCH,INTE3              ; IF
        dw C_EXECUTE
        dw C_BRANCH,INTE4               ; ELSE
INTE3:  dw C_COMMA                      ; THEN
        dw C_BRANCH,INTE4               ; ELSE
INTE2:  dw C_COUNT
        dw C_NUMBER
        dw C_QUERYDUP
        dw C_0BRANCH,INTE5              ; IF
        dw C_ONEPLUS
        dw C_0BRANCH,INTE6              ; IF
        dw C_STATE
        dw C_FETCH
        dw C_0BRANCH,INTE4              ; IF
        dw C_SWAP
        dw C_LITERAL
        dw C_LITERAL                    ; THEN
        dw C_BRANCH,INTE4               ; ELSE
INTE6:  dw C_DROP
        dw C_LITERAL                    ; THEN
        dw C_BRANCH,INTE4               ; ELSE
INTE5:  dw C_QUESTION                   ; THEN THEN
INTE4:  dw C_QSTACK
        dw C_BRANCH,INTE7               ; REPEAT
INTE1:  dw C_DROP
        dw C_EXIT

;------------------------------------
; QUIT  ( -- )    
; interpret from keyboard
;    RP! [COMPILE] [
;    BEGIN
;       TIB @ DUP LBP !
;       CR INPUT INTERPRET
;       STATE @ 0= IF CR ." OK" THEN
;    AGAIN ;
;
W_QUIT:
        db $04,"QUIT"
        dw W_INTERPRET
C_QUIT:
        call DOCOLON
        dw C_RPSTORE
        dw C_LEFTBRKT
QLOOP:  dw C_TIB
        dw C_FETCH
        dw C_DUP
        dw C_LBP
        dw C_STORE
        dw C_CR
        dw C_INPUT
        dw C_INTERPRET
        dw C_STATE
        dw C_FETCH
        dw C_0EQUAL
        dw C_0BRANCH,QUIT1      ;IF
        dw C_CR
        dw C_XDOTQUOTE
        db $02,"OK"
QUIT1:  dw C_BRANCH,QLOOP       ;THEN AGAIN

; -------------
; ABORT  ( -- )           clear stk & QUIT
;    SP! DECIMAL setchr
;    CR ." ZX81 TODDY FORTH V1.0"
;    CR MEM
;    QUIT ;
;
W_ABORT:
        db $05,"ABORT"
        dw W_QUIT
C_ABORT:
        call DOCOLON
        dw C_SPSTORE
        dw C_DECIMAL
        dw C_SETCHR
        dw C_CR
        dw C_XDOTQUOTE
        db $16,"ZX81 TODDY FORTH V1.0",$0d
        dw C_MEM
        dw C_QUIT

; ------------
; COLD  ( -- )
; cold start Forth system
;
W_COLD:
        db $04,"COLD"
        dw W_ABORT
C_COLD: ld      hl,(RAMTOP)
        ld      (R0),hl         ;  = top of return stack
        ld      (RSP),hl
        dec     h               ; RAMTOP-100h
        ld      (S0),hl         ;  = top of param stack
        ld      sp,hl
        ld      (TIB),hl
        call    X_CLS
        jp      C_ABORT

; -------------
; '  ( -- addr)
; find word in dictionary
;    BL WORD FIND 0=
;    IF QUESTION THEN
;
W_TICK:
        db $01,"'"
        dw W_COLD
C_TICK:
        call DOCOLON
        dw C_BL
        dw C_WORD
        dw C_FIND
        dw C_0EQUAL
        dw C_0BRANCH,TICK1
        dw C_QUESTION
TICK1:  dw C_EXIT

; --------------
; ASCII  ( -- C)
; parse ASCII character
;    BL WORD 1+ C@ LITERAL ; IMMEDIATE
;
W_ASCII:
        db $45,"ASCII"
        dw W_TICK
C_ASCII:
        call DOCOLON
        dw C_BL
        dw C_WORD
        dw C_ONEPLUS
        dw C_CFETCH
        dw C_LITERAL
ASC1:   dw C_EXIT

; --------------
; CREATE  ( -- )      create an empty definition
;    LATEST
;    HERE CURRENT @ !               new "latest" link
;    BL WORD C@ 1+ ALLOT ,          name and link field
;    CD C, docreate , ;             code field
;
W_CREATE:
        db $06,"CREATE"
        dw W_ASCII
C_CREATE:
        call DOCOLON
        dw C_LATEST
        dw C_HERE
        dw C_CURRENT
        dw C_FETCH
        dw C_STORE
        dw C_BL
        dw C_WORD
        dw C_CFETCH
        dw C_ONEPLUS
        dw C_ALLOT
        dw C_COMMA
        dw C_LIT,$cd
        dw C_CCOMMA
        dw C_LIT,DOCREATE
        dw C_COMMA
        dw C_EXIT

; ---------------
; (DOES>)  ( -- )    run-time action of DOES>
;    R>              adrs of headless DOES> def'n
;    LATEST CFA    code field to fix up
;    !CF ;
;
W_XDOES:
        db $07,"(DOES>)"
        dw W_CREATE
C_XDOES:
        call DOCOLON
        dw C_RFROM
        dw C_LATEST
        dw C_CFA
        dw C_STORECF
        dw C_EXIT

; -------------
; DOES>  ( -- )         change action of latest definition
;    COMPILE (DOES>) dodoes
;    HERE !CF 3 ALLOT ; IMMEDIATE

W_DOES:
        db $45,"DOES>"
        dw W_XDOES
C_DOES:
        call DOCOLON
        dw C_COMPILE
        dw C_XDOES
        dw C_LIT,C_DODOES
        dw C_HERE
        dw C_STORECF
        dw C_LIT,3
        dw C_ALLOT
        dw C_EXIT

; ---------
; [  ( -- )
; enter interpretive state
;    0 STATE ! ; IMMEDIATE
;
W_LEFTBRKT:
        db $41,"["
        dw W_DOES
C_LEFTBRKT:
        ld hl,0
LBKT1:  ld (STATE),hl
        jp NEXT

; ---------
; ]  ( -- )
; enter compiling state
;    -1 STATE ! ;
;
W_RIGHTBRKT:
        db $01,"]"
        dw W_LEFTBRKT
C_RIGHTBRKT:
        ld hl,-1
        jr LBKT1

; -----------------
; IMMEDIATE  ( -- ).
; make last definition immediate
;    LATEST DUP C@ 40 OR SWAP C! ;
;
W_IMMEDIATE:
        db $09,"IMMEDIATE"
        dw W_RIGHTBRKT
C_IMMEDIATE:
        ld hl,(LAST)
        ld a,(hl)
        or $40
        ld (hl),a
        jp NEXT

; ---------
; :  ( -- )      begin a colon definition
;    CURRENT @ CONTEXT ! CREATE
;    LATEST DUP C@ 80 OR SWAP C! ]
;    docolon LATEST CFA 1+ !  ;
;
W_COLON:
        db $01,":"
        dw W_IMMEDIATE
C_COLON:
        call DOCOLON
        dw C_CURRENT
        dw C_FETCH
        dw C_CONTEXT
        dw C_STORE
        dw C_CREATE
        dw C_LATEST
        dw C_DUP
        dw C_CFETCH
        dw C_LIT,$80
        dw C_OR
        dw C_SWAP
        dw C_CSTORE
        dw C_RIGHTBRKT
        dw C_LIT,DOCOLON
        dw C_LATEST
        dw C_CFA
        dw C_ONEPLUS
        dw C_STORE
        dw C_EXIT

; ---------
; ;  ( -- )      end a colon definition
;    LATEST DUP C@ 7F AND SWAP C!
;    COMPILE EXIT [ ; IMMEDIATE
;
W_SEMICOLON:
        db $41,";"
        dw W_COLON
C_SEMICOLON:
        call DOCOLON
        dw C_LATEST
        dw C_DUP
        dw C_CFETCH
        dw C_LIT,$7F
        dw C_AND
        dw C_SWAP
        dw C_CSTORE
        dw C_COMPILE
        dw C_EXIT
        dw C_LEFTBRKT
        dw C_EXIT

; --------------
; IF  ( -- addr)
; conditional forward branch
;    COMPILE 0BRANCH HERE DUP , ; IMMEDIATE
;
W_IF:
        db $42,"IF"
        dw W_SEMICOLON
C_IF:
        call DOCOLON
        dw C_COMPILE
        dw C_0BRANCH
        dw C_HERE
        dw C_DUP
        dw C_COMMA
        dw C_EXIT

; ----------------
; THEN  (addr -- )
; resolve forward branch
;    HERE SWAP ! ; IMMEDIATE
;
W_THEN:
        db $44,"THEN"
        dw W_IF
C_THEN:
        call DOCOLON
        dw C_HERE
        dw C_SWAP
        dw C_STORE
        dw C_EXIT

; ----------------------
; ELSE  (addr1 -- addr2)
; branch for IF..ELSE
;    COMPILE BRANCH HERE DUP ,
;    SWAP [COMPILE] THEN ; IMMEDIATE
;
W_ELSE:
        db $44,"ELSE"
        dw W_THEN
C_ELSE:
        call DOCOLON
        dw C_COMPILE
        dw C_BRANCH
        dw C_HERE
        dw C_DUP
        dw C_COMMA
        dw C_SWAP
        dw C_THEN
        dw C_EXIT

; -----------------
; BEGIN  ( -- addr)
; target for backward branch
;    HERE ; IMMEDIATE
;
W_BEGIN:
        db $45,"BEGIN"
        dw W_ELSE
C_BEGIN:
        call DOCOLON
        dw C_HERE
        dw C_EXIT

; -----------------
; UNTIL  (addr -- )
; conditional backward branch
;    COMPILE 0BRANCH , ; IMMEDIATE
;
W_UNTIL:
        db $45,"UNTIL"
        dw W_BEGIN
C_UNTIL:
        call DOCOLON
        dw C_COMPILE
        dw C_0BRANCH
        dw C_COMMA
        dw C_EXIT

; -----------------
; AGAIN  (addr -- )
; unconditional backward branch
;    COMPILE BRANCH , ; IMMEDIATE
;
W_AGAIN:
        db $45,"AGAIN"
        dw W_UNTIL
C_AGAIN:
        call DOCOLON
        dw C_COMPILE
        dw C_BRANCH
        dw C_COMMA
        dw C_EXIT

; -----------------
; WHILE  ( -- addr)
; branch for WHILE loop
;    COMPILE 0BRANCH HERE DUP , ; IMMEDIATE
;
W_WHILE:
        db $45,"WHILE"
        dw W_AGAIN
C_WHILE:
        jp      C_IF

; -------------------------
; REPEAT  (addr1 addr2 -- )
; resolve WHILE loop
;    SWAP [COMPILE] AGAIN
;    [COMPILE] THEN ; IMMEDIATE
;
W_REPEAT:
        db $46,"REPEAT"
        dw W_WHILE
C_REPEAT:
        call DOCOLON
        dw C_SWAP
        dw C_AGAIN
        dw C_THEN
        dw C_EXIT

; ---------------
; DO  (n1 n2 -- ) at execution
;     (addr -- )  at compilation
;    COMPILE (DO) HERE ; IMMEDIATE
;
W_DO:
        db $42,"DO"
        dw W_REPEAT
C_DO:
        call DOCOLON
        dw C_COMPILE
        dw C_XDO
        dw C_HERE
        dw C_EXIT

; ----------------
; LOOP  (addr -- ) at compilation
;    COMPILE (LOOP) , ; IMMEDIATE
;
W_LOOP:
        db $44,"LOOP"
        dw W_DO
C_LOOP:
        call DOCOLON
        dw C_COMPILE
        dw C_XLOOP
        dw C_COMMA
        dw C_EXIT

; -----------------
; +LOOP  (addr -- )
;    COMPILE (+LOOP) , ; IMMEDIATE
;
W_PLOOP:
        db $45,"+LOOP"
        dw W_LOOP
C_PLOOP:
        call DOCOLON
        dw C_COMPILE
        dw C_XPLOOP
        dw C_COMMA
        dw C_EXIT

; ---------------
; COMPILE  ( -- )
; append inline execution token
;    R> DUP 2+ >R @ , ;
;
W_COMPILE:
        db $07,"COMPILE"
        dw W_PLOOP
C_COMPILE:
        call DOCOLON
        dw C_RFROM
        dw C_DUP
        dw C_TWOPLUS
        dw C_TOR
        dw C_FETCH
        dw C_COMMA
        dw C_EXIT

; -------------------
; LITERAL  ( x --   )
;          ( x -- x )
; append numeric literal if in compilation mode
;    STATE @ IF COMPILE LIT , THEN ; IMMEDIATE
;
W_LITERAL:
        db $47,"LITERAL"
        dw W_COMPILE
C_LITERAL:
        call DOCOLON
        dw C_STATE
        dw C_FETCH
        dw C_0BRANCH,LITRL1
        dw C_COMPILE
        dw C_LIT
        dw C_COMMA
LITRL1: dw C_EXIT

; ----------------
; LOAD  (addr -- )
; interpret the text in the buffer at addr
;    LBP ! INTERPRET ;
;
W_LOAD:
        db $04,"LOAD"
        dw W_LITERAL
C_LOAD:
        call DOCOLON
        dw C_LBP
        dw C_STORE
        dw C_INTERPRET
        dw C_EXIT

; -----------------------------------------
; QUESTION  ( -- )
;    HERE COUNT TYPE 3F EMIT
;    STATE @ IF LATEST DUP DP ! HERE C@ 7F
;               AND + 1+ @ CURRENT @ !
;            THEN
;    SP! QUIT ;
;
W_QUESTION:
        db $08,"QUESTION"
        dw W_LOAD
C_QUESTION:
        call DOCOLON
        dw C_HERE
        dw C_COUNT
        dw C_TYPE
        dw C_LIT,$3F
        dw C_EMIT
QUEST1: dw C_STATE
        dw C_FETCH
        dw C_0BRANCH,QUEST2     ;IF
        dw C_LATEST
        dw C_DUP
        dw C_DP
        dw C_STORE
        dw C_HERE
        dw C_CFETCH
        dw C_LIT,$7f
        dw C_AND
        dw C_PLUS
        dw C_ONEPLUS
        dw C_FETCH
        dw C_CURRENT
        dw C_FETCH
        dw C_STORE                   ;THEN
QUEST2: dw C_SPSTORE
        dw C_QUIT


; --------------------------------------------------------
; LFA   (nfa -- lfa)    name adr -> link field
;   COUNT 3F AND +      mask off 'smudge' and 'immed' bits
;
W_LFA:
        db $03,"LFA"
        dw W_QUESTION
C_LFA:
        call DOCOLON
        dw C_COUNT
        dw C_LIT,$3f
        dw C_AND
        dw C_PLUS
        dw C_EXIT

; --------------------------------------------
; CFA   (nfa -- cfa)    name adr -> code field
;   LFA 2+ ;
;
W_CFA:
        db $03,"CFA"
        dw W_LFA
C_CFA:
        call DOCOLON
        dw C_LFA
        dw C_TWOPLUS
        dw C_EXIT

; test for empty stack
C_QSTACK:
        ld      hl,(S0)
        inc     hl
        inc     hl
        and     a
        sbc     hl,sp
        jp      nc,NEXT
        ld      de,QSTK1
        jp      C_XDOTQUOTE
QSTK1:  db      $0b,"EMPTY STACK"
        dw      QSTK2
QSTK2:  ld      hl,QUEST1
        push    hl
        jp      DOCOLON
;
; test for BREAK key
C_QTERMINAL:
        call    BREAK_1
        push    bc
        ld      bc,0
        jr      c,QTERM1
        dec     bc
QTERM1: jp      NEXT

; ------------------------------------------------
; !CF  (adrs cfa -- )   set code action of a word
;    CD OVER C!        store 'CALL adrs' instr
;    1+ ! ;
;  (internal word)
C_STORECF:
        call DOCOLON
        dw C_LIT,$cd
        dw C_OVER
        dw C_CSTORE
        dw C_ONEPLUS
        dw C_STORE
        dw C_EXIT

; --------------
; FORGET  ( -- )        Delete definition and all entries that follow it
;    CURRENT @ CONTEXT ! '
;    DUP 2 - @ CURRENT @ !
;    DP @ C@ 3 + - DP ! ;
;
W_FORGET:
        db $06,"FORGET"
        dw W_CFA
C_FORGET:
        call DOCOLON
        dw C_CURRENT
        dw C_FETCH
        dw C_CONTEXT
        dw C_STORE
        dw C_TICK
        dw C_DUP
        dw C_LIT,2
        dw C_MINUS
        dw C_FETCH
        dw C_CURRENT
        dw C_FETCH
        dw C_STORE
        dw C_DP
        dw C_FETCH
        dw C_CFETCH
        dw C_LIT,3
        dw C_PLUS
        dw C_MINUS
        dw C_DP
        dw C_STORE
        dw C_EXIT

; --------------
; VLIST  ( -- )         list all words in dict.
;    CR LATEST BEGIN
;       DUP COUNT 3F AND TYPE SPACE
;       BEGIN ?terminal 0= UNTIL
;       LFA @
;    ?DUP 0= UNTIL ;
;
W_VLIST:
        db $05,"VLIST"
        dw W_FORGET
C_VLIST:
        call DOCOLON
        dw C_CR
        dw C_LATEST
VLIST2: dw C_DUP                ; BEGIN
        dw C_COUNT
        dw C_LIT,$3F
        dw C_AND
        dw C_TYPE
        dw C_SPACE
VLIST1: dw C_QTERMINAL          ; BEGIN
        dw C_0EQUAL
        dw C_0BRANCH,VLIST1     ; UNTIL
        dw C_LFA
        dw C_FETCH
        dw C_QUERYDUP
        dw C_0EQUAL
        dw C_0BRANCH,VLIST2     ; UNTIL
        dw C_EXIT

; -----------
; MEM  ( -- )           Print the amount of memory left.
;    SP@ HERE - U. ." BYTES FREE." ;
;
W_MEM:
        db $03,"MEM"
        dw W_VLIST
C_MEM:
        call DOCOLON
        dw C_SPFETCH
        dw C_HERE
        dw C_MINUS
        dw C_UDOT
        dw C_XDOTQUOTE
        db $0b,"BYTES FREE",$0d
        dw C_EXIT

; -------------
; CSAVE  ( -- )
; save the compiler on tape
;
W_CSAVE:
        db $05,"CSAVE"
        dw W_MEM
C_CSAVE:
        ld      hl,(DP)
        ld      ($4014),hl
        exx
        call    SETFAST
        call    SAVE-1
        call    SLOW
        exx
        jp      NEXT

; ----------
; CODE  ( -- )          Create code definition
;    CREATE -3 ALLOT ;
;
W_CODE:
        db $04,"CODE"
        dw W_CSAVE
C_CODE:
        call DOCOLON
        dw C_CREATE
        dw C_LIT,-3
        dw C_ALLOT
        dw C_EXIT

; ----------------
; NEXT  ( -- )          Append "jp NEXT" in a code definition
;    C3 C, next , ;
;
W_NEXT:
        db $04,"NEXT"
        dw W_CODE
C_NEXT:
        call DOCOLON
        dw C_LIT,$C3
        dw C_CCOMMA
        dw C_LIT,NEXT
        dw C_COMMA
        dw C_EXIT

; ---------
; \  ( -- )             Comments to end of line
;    0A WORD DROP ; IMMEDIATE
;
W_BKSLASH:
        db $41,$5c
        dw W_NEXT
C_BKSLASH:
        call DOCOLON
        dw C_LIT,$0a
        dw C_WORD
        dw C_DROP
        dw C_EXIT

; --------------------------------
; (   ( -- )
;   ASCII ) WORD DROP ; IMMEDIATE
; Skip input until )
;
W_PAREN:
        db $41,"("
        dw W_BKSLASH
C_PAREN:
        call DOCOLON
        dw C_LIT,$29
        dw C_WORD
        dw C_DROP
        dw C_EXIT

; ----------------------
; .(   ( -- )
;   ( HERE COUNT TYPE ;
; display comments
;
W_DOTPAREN:
        db $02,".("
        dw W_PAREN
C_DOTPAREN:
        call DOCOLON
        dw C_PAREN
        dw C_HERE
        dw C_COUNT
        dw C_TYPE
        dw C_EXIT


last:             ; DP point here

; Show code statistics when compiling

.ECHO "Lenght: "
.ECHO (last - VERSN)
.ECHO " bytes\n"

    end
