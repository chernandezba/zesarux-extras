
\ --------------------------------------------------------------------------------------------------
\                                           Compiler
\ --------------------------------------------------------------------------------------------------

\ Compile immediate words
: [COMPILE]  ( -- )
   ' ,
; IMMEDIATE

\ Find word & compile as literal
: [']  ( -- )           \ When encountered in a colon definition, the
   ' LIT LIT , ,        \ phrase  ['] xxx  will cause   LIT,xxt  to be
; IMMEDIATE             \ compiled into the colon definition (where
                        \ (where xxt is the execution token of word xxx).
                        \ When the colon definition executes, xxt will
                        \ be put on the stack.  (All xt's are one cell.)


\ Postpone compile action of word
: POSTPONE  ( -- )
   BL WORD FIND
   DUP 0= IF QUESTION THEN
   0< IF  ( -- xt )    \ non immed: add code to current def'n to compile xt later.
       ['] LIT ,  ,    \  add "LIT,xt,COMMAXT"
       ['] , ,         \ to current definition
      ELSE  ,       \ immed: compile into cur. def'n
      THEN
; IMMEDIATE

\ Append numeric double literal
: DLITERAL  ( d -- )   
   STATE @
   IF SWAP LITERAL LITERAL THEN
;

\ Recurse current definition
: RECURSE  ( -- )
   LATEST CFA ,
; IMMEDIATE

\ "Reveal" latest definition
: REVEAL  ( -- )
   LATEST DUP C@ 127 AND SWAP C!
;



\ --------------------------------------------------------------------------------------------------
\                                         Word Definition
\ --------------------------------------------------------------------------------------------------


\ Create a double variable
: 2VARIABLE  ( d -- )
   CREATE SWAP , , 
;

\ Create a double constant
: 2CONSTANT
   CREATE SWAP , , DOES>
   2@ SWAP
;

\ Create value object
: VALUE ( x "<spaces>name" -- )
   CONSTANT
;

\ Set a value
: TO  ( x "<spaces>name" -- )
   '              ( get the name of the value )
   3 +            ( increment to point at the value )
   STATE @        ( compiling? )
   IF
      COMPILE LIT ( compile LIT )
      ,           ( compile the address of the value )
      COMPILE !   ( compile ! )
   ELSE           ( immediate mode )
      !           ( update it straightaway )
   THEN
; IMMEDIATE

\ define deferred word
: DEFER  ( "name" -- )
   CREATE ['] ABORT ,  \ you should not rely on initialization with noop
DOES>
   @ EXECUTE
;

\ set a deferred word
: IS ( xt "<spaces>name" -- )
   [COMPILE] TO      \ or POSTPONE TO
; IMMEDIATE

\ The JUPITER ACE's DEFINER word
: DEFINER ( -- )
   [COMPILE] : COMPILE CREATE     \ or POSTPONE : POSTPONE CREATE
;



\ --------------------------------------------------------------------------------------------------
\                                       Stack Manipulation
\ --------------------------------------------------------------------------------------------------


\ : NIP  ( x1 x2 -- x2)            ( per stack diagram )
\      SWAP DROP ;
CODE NIP  
  E1 C,          \ pop   hl
  NEXT           \ jp NEXT

\ : TUCK  ( x1 x2 -- x2 x1 x2)     ( per stack diagram )
\      SWAP OVER ;
CODE TUCK
  E1 C,          \ pop hl
  C5 C,          \ push bc	        ; insert top item
  E5 C,          \ push hl
  NEXT           \ jp NEXT

\ : PICK  ( Xn .. X1 X0 n -- Xn .. X1 X0 Xn)  ( Copy nth cell to top )
\      2* SP@ 2+ + @ ;
CODE PICK
  CB C, 21 C,    \ sla c           ;2*
  CB C, 10 C,    \ rl b            ;
  60 C,          \ ld h,b
  69 C,          \ ld l,c
  39 C,          \ add hl,sp
  4E C,          \ ld c,(hl)       ;get element to be PICK'ed
  23 C,          \ inc hl          ;
  46 C,          \ ld b,(hl)       ;
  NEXT           \ jp NEXT

\ Rotate nth cell to top
CODE ROLL ( Xn .. X1 X0 n -- Xn-1 .. X1 X0 Xn )
  C5 C,          \ push bc  
  D9 C,          \ exx             ;save IP
  C1 C,          \ pop bc
  CB C, 21 C,    \ sla c           ;2*
  CB C, 10 C,    \ rl b            ;
  03 C,          \ inc bc          ;1+
  60 C,          \ ld h,b
  69 C,          \ ld l,c
  0B C,          \ dec bc          ;bytes count to be moved
  39 C,          \ add hl,sp
  E5 C,          \ push hl         ;destination
  C5 C,          \ push bc
  56 C,          \ ld d,(hl)       ;get element to be ROLL'ed
  2B C,          \ dec hl          ;
  5E C,          \ ld e,(hl)       ;
  2B C,          \ dec hl          ;HL = origin
  C1 C,          \ pop bc
  EB C,          \ ex de,hl
  E3 C,          \ ex (sp),hl
  EB C,          \ ex de,hl
  78 C,          \ ld a,b
  B1 C,          \ or c            ; count=0?
  28 C, 02 C,    \ jr z,+2         ;
  ED C, B8 C,    \ lddr
  D9 C,          \ exx             ;restore IP
  C1 C,          \ pop bc          ;get TOS
  E1 C,          \ pop hl          ;adjust SP
  NEXT           \ jp NEXT

\ Per stack diagram
\ : 2SWAP  ( x1 x2 x3 x4 -- x3 x4 x1 x2 )
\    ROT >R ROT R> ;
CODE 2SWAP
  E1 C,          \ pop hl          ; bc=x4, hl=x3
  D9 C,          \ exx
  C1 C,          \ pop  bc
  E1 C,          \ pop  hl         ; bc'=x2, hl'=x1
  D9 C,          \ exx
  E5 C,          \ push hl
  C5 C,          \ push bc
  D9 C,          \ exx
  E5 C,          \ push hl
  C5 C,          \ push bc
  D9 C,          \ exx
  C1 C,          \ pop  bc
  NEXT           \ jp NEXT

\ Per stack diagram
\ : 2OVER  ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )
\    >R >R 2DUP
\    R> R> 2SWAP ;
CODE 2OVER
  D9 C,          \ exx
  E1 C,          \ pop hl
  D1 C,          \ pop de
  C1 C,          \ pop bc
  C5 C,          \ push bc
  D5 C,          \ push de
  E5 C,          \ push hl
  D9 C,          \ exx
  C5 C,          \ push bc
  D9 C,          \ exx
  C5 C,          \ push bc
  D5 C,          \ push de
  D9 C,          \ exx
  C1 C,          \ pop  bc
  NEXT           \ jp NEXT



\ --------------------------------------------------------------------------------------------------
\                                           Comparison
\ --------------------------------------------------------------------------------------------------

\ Test not eq
: <>  ( x1 x2 -- flag )
   = 0=
;

\ Leave greater of two numbers
: MAX  ( n1 n2 -- n3)
   2DUP <
   IF SWAP
   THEN DROP
;

\ Leave lesser of two numbers
: MIN  ( n1 n2 -- n3)
   2DUP >
   IF SWAP
   THEN DROP
;

\ Test u1<u2, unsigned
CODE U<  ( u1 u2 -- flag)
  E1 C,          \ pop hl
  B7 C,          \ or a
  ED C, 42 C,    \ sbc hl,bc       ; u1-u2 in HL, SZVC valid
  9F C,          \ sbc a,a         ; propagate cy through A
  47 C,          \ ld b,a          ; put 0000 or FFFF in TOS
  4F C,          \ ld c,a
  NEXT           \ jp NEXT

\ Test u1>u2, unsigned
: U>     ( u1 u2 -- flag)
   SWAP U< ;

\ Unsigned minimum
: UMIN   ( u1 u2 -- u )
   2DUP U>
   IF SWAP
   THEN DROP ;

\ Unsigned maximum
: UMAX   ( u1 u2 -- u )
   2DUP U<
   IF SWAP
   THEN DROP ;


\ n2<=n1<n3?
: WITHIN  ( n1|u1 n2|u2 n3|u3 -- f )
   OVER - >R - R> U<
;


\ --------------------------------------------------------------------------------------------------
\                                       Integer Arithmetic
\ --------------------------------------------------------------------------------------------------

\ Add double length numbers
CODE D+  ( d1 d2 -- d1+d2 )
  D9 C,         \        exx
  C1 C,         \        pop bc          ; BC'=d2lo
  D9 C,         \        exx
  E1 C,         \        pop hl          ; HL=d1hi,BC=d2hi
  D9 C,         \        exx
  E1 C,         \        pop hl          ; HL'=d1lo
  09 C,         \        add hl,bc
  E5 C,         \        push hl         ; 2OS=d1lo+d2lo
  D9 C,         \        exx
  ED C, 4A C,   \        adc hl,bc       ; HL=d1hi+d2hi+cy
  44 C,         \        ld b,h
  4D C,         \        ld c,l
  NEXT          \        jp NEXT

\  Subtract double numbers
\ : D- DNEGATE D+ ;
CODE D-  ( d1 d2 -- d1-d2 )
  D9 C,         \        exx
  C1 C,         \        pop bc          ; BC'=d2lo
  D9 C,         \        exx
  E1 C,         \        pop hl          ; HL=d1hi,BC=d2hi
  D9 C,         \        exx
  E1 C,         \        pop hl          ; HL'=d1lo
  A7 C,         \        and a
  ED C, 42 C,   \        sbc hl,bc
  E5 C,         \        push hl         ; 2OS=d1lo-d2lo
  D9 C,         \        exx
  ED C, 42 C,   \        sbc hl,bc       ; HL=d1hi-d2hi-cy
  44 C,         \        ld b,h
  4D C,         \        ld c,l
  NEXT          \        jp NEXT

\ Add single to double
CODE M+      ( d n -- d )
  EB C,         \         ex de,hl
  D1 C,         \         pop de          ; hi cell
  E3 C,         \         ex (sp),hl      ; lo cell, save IP
  09 C,         \         add hl,bc
  42 C,         \         ld b,d          ; hi result in BC (TOS)
  4B C,         \         ld c,e
  30 C, 01 C,   \         jr nc,mplus1
  03 C,         \         inc bc
  D1 C,         \ mplus1: pop de          ; restore saved IP
  E5 C,         \         push hl         ; push lo result
  NEXT          \         jp NEXT

\ Signed 16*16->32 multiply.
: M*  ( n1 n2 -- d )
   2DUP XOR >R    ( Carries sign of the result )
   SWAP ABS SWAP ABS UM*
   R> ?DNEGATE
;

\  Symmetric signed div
: SM/REM  ( d1 n1 -- n2 n3 )
   2DUP XOR >R             ( sign of quotient )
   OVER >R                 ( sign of remainder )
   ABS >R DABS R> UM/MOD
   SWAP R> ?NEGATE
   SWAP R> ?NEGATE
;

\ Floored signed div'n
: FM/MOD  ( d1 n1 -- n2 n3 )
   DUP >R             ( save divisor )
   SM/REM
   DUP 0< IF          ( if quotient negative, )
       SWAP R> +      (   add divisor to rem'dr )
       SWAP 1-        (   decrement quotient )
   ELSE R> DROP THEN
;

\ Multiply n1 by n2 producing double-cell intermediate,
\ then divide it by n3. Return single-cell remainder and
\ single-cell quotient.
\ : */MOD  ( n1 n2 n3 -- n4 n5 )
\    ROT >R R@ ABS ROT DUP R> XOR >R ABS UM* 
\    ROT DUP R@ XOR >R ABS UM/MOD              \ these two lines is part of /MOD definition and 
\    R> ?NEGATE SWAP R> ?NEGATE SWAP           \ can be replaced by:
\ ;                                            \ BRANCH [ ' /MOD 15 + , REVEAL

: */MOD  ( n1 n2 n3 -- n4 n5 )
   ROT >R R@ ABS ROT DUP R> XOR >R ABS UM* 
   BRANCH [ ' /MOD 15 + ,          \ jump into /MOD definition
   REVEAL                          \ reset the smudge bit (don't has semicolon at the end)

\ Multiply n1 by n2 producing double-cell intermediate,
\ then divide it by n3. Return single-cell quotient.
: */  ( n1 n2 n3 -- n4 )
   */MOD NIP
;

\ Signed remainder
: MOD  ( n1 n2 -- n3 )
   /MOD DROP
;

\ Single -> double prec.
: S>D  ( n -- d )
   DUP 0<
;

\ Bitwise inversion
\ : INVERT  NEGATE 1+ ;
CODE INVERT  ( x1 -- x2 )
  78 C,          \ ld a,b
  2F C,          \ cpl
  47 C,          \ ld b,a
  79 C,          \ ld a,c
  2F C,          \ cpl
  4F C,          \ ld c,a
  NEXT           \ jp NEXT

\ Negate double precision
: DNEGATE    ( d1 -- d2 )
   SWAP INVERT SWAP INVERT 1 M+
;

\ Negate d1 if n negative
: ?DNEGATE   ( d1 n -- d2 )
   0< IF DNEGATE THEN
;

\ Absolute value dbl.prec.
: DABS       ( d1 -- +d2 )
   DUP ?DNEGATE
;

\ Logical L shift u places
CODE LSHIFT  ( x1 u -- x2 )
  41 C,         \         ld b,c        ; b = loop counter
  E1 C,         \         pop hl        ;   NB: hi 8 bits ignored!
  04 C,         \         inc b         ; test for counter=0 case
  18 C, 01 C,   \         jr lsh2
  29 C,         \ .lsh1   add hl,hl     ; left shift HL, n times
  18 C, FD C,   \ .lsh2   djnz lsh1
  44 C,         \         ld b,h        ; result is new TOS
  4D C,         \         ld c,l
  NEXT          \         jp NEXT

\ Logical R shift u places
CODE RSHIFT  ( x1 u -- x2 )
  41 C,         \         ld b,c        ; b = loop counter
  E1 C,         \         pop hl        ;   NB: hi 8 bits ignored!
  04 C,         \         inc b         ; test for counter=0 case
  18 C, 04 C,   \         jr rsh2
  CB C, 3C C,   \ .rsh1   srl h         ; right shift HL, n times
  CB C, 0D C,   \         rr l
  18 C, FA C,   \ .rsh2   djnz rsh1
  44 C,         \         ld b,h        ; result is new TOS
  4D C,         \         ld c,l
  NEXT          \         jp NEXT



\ --------------------------------------------------------------------------------------------------
\                                        Memory and I/O operations
\ --------------------------------------------------------------------------------------------------


\ : 2@  DUP 2+ @ SWAP @ ;
CODE 2@  ( addr -- x1 x2 )           ( fetch 2 cells )
  60 C,          \ ld h,b
  69 C,          \ ld l,c
  4E C,          \ ld c,(hl)
  23 C,          \ inc hl
  46 C,          \ ld b,(hl)
  23 C,          \ inc hl
  7E C,          \ ld a,(hl)
  23 C,          \ inc hl
  6E C,          \ ld h,(hl)
  6F C,          \ ld l,a
  E5 C,          \ push hl
  NEXT           \ jp NEXT

\ : 2!  SWAP OVER ! 2+ ! ;
CODE 2!  ( x1 x2 addr -- )          ( store 2 cells )
  60 C,          \ ld h,b
  69 C,          \ ld l,c
  C1 C,          \ pop bc
  71 C,          \ ld (hl),c
  23 C,          \ inc hl
  70 C,          \ ld (hl),b
  23 C,          \ inc hl
  C1 C,          \ pop bc
  71 C,          \ ld (hl),c
  23 C,          \ inc hl
  70 C,          \ ld (hl),b
  C1 C,          \ pop bc
  NEXT           \ jp NEXT

\ Output char to port
CODE PC!    ( char c-addr -- )
  E1 C,          \ pop hl          ; char in L
  ED C, 69 C,    \ out (c),l       ; to port (BC)
  C1 C,          \ pop bc          ; pop new TOS
  NEXT           \ jp NEXT

\ Input char from port
CODE PC@    ( c-addr -- char )
  EB C, 48 C,    \ in c,(c)        ; read port (BC) to C
  06 C, 00 C,    \ ld b,0
  NEXT           \ jp NEXT


\ --------------------------------------------------------------------------------------------------
\                                        Control Structures
\ --------------------------------------------------------------------------------------------------


\       CASE ( as defined in Jonesforth )
\	CASE...ENDCASE is how we do switch statements in FORTH.  There is no generally
\	agreed syntax for this, so I've gone for the syntax mandated by the ISO standard
\	FORTH (ANS-FORTH).
\
\		( some value on the stack )
\		CASE
\		test1 OF ... ENDOF
\		test2 OF ... ENDOF
\		testn OF ... ENDOF
\		... ( default case )
\		ENDCASE
\
\	The CASE statement tests the value on the stack by comparing it for equality with
\	test1, test2, ..., testn and executes the matching piece of code within OF ... ENDOF.
\	If none of the test values match then the default case is executed.  Inside the ... of
\	the default case, the value is still at the top of stack (it is implicitly DROP-ed
\	by ENDCASE).  When ENDOF is executed it jumps after ENDCASE (ie. there is no "fall-through"
\	and no need for a break statement like in C).
\
\	The default case may be omitted.  In fact the tests may also be omitted so that you
\	just have a default case, although this is probably not very useful.
\

: CASE
   0           ( push 0 to mark the bottom of the stack )
; IMMEDIATE

: OF
   COMPILE OVER         ( compile OVER )
   COMPILE =            ( compile = )
   [COMPILE] IF         ( compile IF )
   COMPILE DROP         ( compile DROP )
; IMMEDIATE

: ENDOF
   [COMPILE] ELSE       ( ENDOF is the same as ELSE )
; IMMEDIATE

: ENDCASE
   COMPILE DROP	( compile DROP )

   ( keep compiling THEN until we get to our zero marker )
   BEGIN
     ?DUP
   WHILE
     [COMPILE] THEN
   REPEAT
; IMMEDIATE



\ --------------------------------------------------------------------------------------------------
\                                      Character Input/Output 
\ --------------------------------------------------------------------------------------------------


\ Reads the keyboard
CODE INKEY  ( -- ASCII code)
  C5 C,          \        push bc         ;save old TOS
  D5 C,          \        push de         ;save IP
  CD C, 02BB ,   \        call $2BB       ;KEYBOARD
  7D C,          \        ld a,l
  3C C,          \        inc a
  28 C, 0A C,    \        jr z,INK1
  44 C,          \        ld b,h
  4D C,          \        ld c,l
  CD C, 07BD ,   \        call $7BD       ;DECODE
  11 C, 4347 ,   \        ld de,$4347     ;K_UNSHIFT - $7E
  19 C,          \        add hl,de
  7E C,          \        ld a,(hl)
  06 C, 00 C,    \ INK1:  ld b,0          ;put the key code in BC
  4F C,          \        ld c,a          ;
  D1 C,          \        pop de          ;restore IP
  NEXT           \        jp NEXT

\ Output n spaces
: SPACES  ( n -- )  
   ?DUP IF 0 DO SPACE LOOP THEN ;

\ Wait for a number to be typed
: #IN
   BEGIN
    ." ?" TIB @ DUP LBP ! INPUT
    BL WORD COUNT NUMBER
   UNTIL DROP ;


\ --------------------------------------------------------------------------------------------------
\                                     Number Input/Output 
\ --------------------------------------------------------------------------------------------------


\ Convert an unsigned number to a string.
: (U.) ( u -- c-addr n )
   <# #S #>
;

\ Print a string, right padded with n1 spaces.
: (.R) ( n1 c-addr n2 -- )
   ROT OVER - 0 MAX SPACES TYPE
;

\ Convert a signed number to a string.
: (.) ( n -- c-addr n )
   <# DUP ABS 0 #S ROT SIGN #>
;

\ Convert a double number to a string.
: (D.)  ( d -- c-addr u )
   SWAP OVER DABS
   <#  #S ROT SIGN #>
;

\ Prints an unsigned number, padded to a certain width
: U.R ( u width -- )
   SWAP 0 (U.) (.R)
;

\ Prints a signed number, padded to a certain width.
: .R ( n width -- )
   SWAP (.) (.R)
;

\ Display d right-justified in field of width n.
: D.R  ( d n -- )
   >R (D.) R> OVER -
   0 MAX SPACES TYPE
;

\ Display d in free field format followed by a space.
: D.  ( d -- )
   (D.) TYPE SPACE
;

\ Display ud in free field format followed by a space.
: UD. ( ud -- )
   (U.) TYPE SPACE
;



\ --------------------------------------------------------------------------------------------------
\                                            Strings
\ --------------------------------------------------------------------------------------------------
     

\  S" string" is used in FORTH to define strings.  It leaves the address of the string and
\  its length on the stack, (length at the top of stack).
\
\  This is tricky to define because it has to do different things depending on whether
\  we are compiling or in immediate mode.  (Thus the word is marked IMMEDIATE so it can
\  detect this and do different things).
\
\  In immediate mode there isn't a particularly good place to put the string, but in this
\  case we put the string at PAD.  This is meant as a temporary location, likely to be
\  overwritten soon after.

\ Run-time code for S"
: (S")    ( -- c-addr u )
   R> COUNT 2DUP + >R
;

\  Get in-line string
: S"   ( -- ) ( -- c-addr u )
   STATE @
   IF
      COMPILE (S")               ( compile mode )
      ASCII " WORD C@ 1+ ALLOT
   ELSE
      ASCII " WORD COUNT         ( immediate mode )
      PAD 2DUP C! 1+
      SWAP 2DUP >R >R
      CMOVE R> R>
   THEN
; IMMEDIATE




\ --------------------------------------------------------------------------------------------------
\                                             Block
\ --------------------------------------------------------------------------------------------------


\ Move from bottom
CODE CMOVE ( c-addr1 c-addr2 u -- )
  E1 C,          \            pop hl            ; destination adrs
  EB C,          \            ex de,hl          ; DE = 'dst', HL = IP
  E3 C,          \            ex (sp),hl        ; HL = 'src', IP on stack
  78 C,          \            ld a,b            ; test for count=0
  B1 C,          \            or c              ;
  28 C, 02 C,    \            jr z,CMOVEDONE    ;  yes
  ED C, B0 C,    \            ldir              ; move 'n' bytes
  D1 C,          \ CMOVEDONE: pop de            ; restore IP
  C1 C,          \            pop bc            ; pop new TOS
  NEXT           \            jp NEXT

\ Move from top
CODE CMOVE>  ( c-addr1 c-addr2 u -- )
  E1 C,          \            pop hl          ; destination adrs
  11 C,          \            add hl,bc       ; last byte in destination
  2B C,          \            dec hl
  EB C,          \            ex de,hl        ; DE = 'dst', HL = IP
  E3 C,          \            ex (sp),hl      ; HL = 'src', IP on stack
  78 C,          \            ld a,b          ; test for count=0
  B1 C,          \            or c            ;
  28 C, 04 C,    \            jr z,UMOVEDONE  ;  yes
  11 C,          \            add hl,bc       ; last byte in source
  2B C,          \            dec hl
  ED C, B8 C,    \            lddr            ; move from top to bottom
  D1 C,          \ UMOVEDONE: pop de          ; restore IP
  C1 C,          \            pop bc          ; pop new TOS
  NEXT           \            jp NEXT

\ Smart move ( version for 1 address unit = 1 char )
: MOVE   ( addr1 addr2 u -- )
   >R 2DUP SWAP DUP R@ +     ( -- ... dst src src+n )
   WITHIN IF    R> CMOVE>    (  src <= dst < src+n )
          ELSE  R> CMOVE
          THEN               ( otherwise )
;

\ Fill memory at the address with the specified quantity of bytes b
CODE FILL ( addr qty b -- )
  C5 C,          \        push    bc         ;save TOS
  D9 C,          \        exx                ;/ save IP
  D1 C,          \        pop     de         ;/ (E)<--byte
  C1 C,          \        pop     bc         ;  (BC)<--quantity
  E1 C,          \        pop     hl         ;/ (HL)<--addr
  78 C,          \ FILL1: ld      a,b
  B1 C,          \        or      c          ;  QTY=0?
  28 C, 05 C,    \        jr      z,FILL2    ;  yes
  73 C,          \        ld      (hl),e     ;/ ((HL))<--byte
  23 C,          \        inc     hl         ;  inc pointer
  0B C,          \        dec     bc         ;  dec counter
  18 C, F8 C,    \        jr      FILL1      ;/
  D9 C,          \ FILL2: exx                ;/ RESTORE IP
  C1 C,          \        pop     bc         ;new TOS
  NEXT           \        jp NEXT

\ --------------------------------------------------------------------------------------------------
\                                          Miscellaneous
\ --------------------------------------------------------------------------------------------------


\ Set the SLOW mode
CODE SLOW  ( -- )
  D9 C,          \ exx
  CD C, F2B ,    \ call $f2b  ;SLOW
  D9 C,          \ exx
  NEXT           \ jp NEXT

\ Set the FAST mode
CODE FAST  ( -- )
  CD C, F23 ,    \ call $f23  ;FAST
  NEXT           \ jp NEXT

\ Set print position to row n1 and column n2
: AT  ( n1 n2 -- )
   SWAP 33 * + 16530 ( dfile)
   + 17339 ( cur_pos) ! ;

\ Set the screen coordinate to line 0 column 0.
: HOME  ( -- )
   16530 17339 !
;

\ End of parameter stack
: S0  ( -- a-addr )
   17323 @
;

\ Number of items on stack
: DEPTH  ( -- +n )
   SP@ S0 SWAP - 2/ 
;

\ Print stack contents
: .S  ( -- )
   SP@ S0 -
   IF  SP@ S0 2- 
       DO I @ U. -2 +LOOP
   THEN
;

\ Drive the ZON-X81 sound device.
CODE SND ( n1 n2 -- )            ( Write n1 to AY register n2 )
  79 C,          \ ld a,c
  D3 C, DF C,    \ out ($df),a
  E1 C,          \ pop hl
  7D C,          \ ld a,l
  D3 C, 0F C,    \ out ($0f),a
  C1 C,          \ pop bc
  NEXT           \ jp NEXT

\ Turns off all sound on all channels, A,B and C
: SNDOFF  ( -- )
   255 7 SND ;

\ "Simulate" the BEEP command of Jupiter ACE
: BEEP ( c n -- )
   SWAP 0 SND
     0 1 SND
   254 7 SND
    15 8 SND
   0 DO LOOP SNDOFF ;

\ ACE PLOT routine
\ Plots pixel (x, y) with plot mode n.
\ n = 0       unplot
\     1       plot
\     2       move
\     3       change

7688 12296 56 CMOVE  \ moves graphics chars from ROM to UDG memory

CODE PLOT  ( x y n -- )
  C5 C,              \ push bc
  D9 C,              \ exx
  C1 C,              \ pop bc         ; n
  D1 C,              \ pop de         ; y
  FD C, 73 C, 36 C,  \ ld (iy+$36),e  ; YCOORD
  3E C, 2F C,        \ ld a,$2F       ; 47-y
  93 C,              \ sub e          ;
  1F C,              \ rra            ; (47-y)/2
  CB C, 11 C,        \ rl c           ; n*2+cy
  D1 C,              \ pop de         ; x
  FD C, 73 C, 37 C,  \ ld (iy+$37),e  ; XCOORD
  CB C, 3B C,        \ srl e          ; x/2
  CB C, 11 C,        \ rl c           ; (n*2)*2
  47 C,              \ ld b,a
  7B C,              \ ld a,e
  04 C,              \ inc b          ; range 1 to 24
  21 C, 4071 ,       \ ld hl,$4071    ; Dfile-33
  11 C, 21 ,         \ ld de,$21      ; (y/2)*33
  19 C,              \ add hl,de      ; 
  10 C, FD C,        \ djnz -3        ; 
  5F C,              \ ld e,a         ; (y/2)*33+x/2
  19 C,              \ add hl,de      ; 
  7E C,              \ ld a,(hl)
  07 C,              \ rlca
  FE C, 10 C,        \ cp $10
  7E C,              \ ld a,(hl)
  38 C, 01 C,        \ jr c,+1
  AF C,              \ xor a
  5F C,              \ ld e,a
  16 C, 87 C,        \ ld d,$87
  79 C,              \ ld a,c
  2F C,              \ cpl
  E6 C, 03 C,        \ and $03
  47 C,              \ ld b,a
  28 C, 07 C,        \ jr z,+7
  2F C,              \ cpl
  C6 C, 02 C,        \ add a,$02
  CE C, 03 C,        \ adc a,$03
  57 C,              \ ld d,a
  43 C,              \ ld b,e
  79 C,              \ ld a,c
  0F C,              \ rrca
  0F C,              \ rrca
  0F C,              \ rrca
  9F C,              \ sbc a,a
  CB C, 59 C,        \ bit 3,c
  20 C, 04 C,        \ jr nz,+4
  AB C,              \ xor e
  07 C,              \ rlca
  9F C,              \ sbc a,a
  A8 C,              \ xor b
  A2 C,              \ and d
  AB C,              \ xor e
  77 C,              \ ld (hl),a
  D9 C,              \ exx
  C1 C,              \ pop bc
  NEXT               \ jp NEXT


