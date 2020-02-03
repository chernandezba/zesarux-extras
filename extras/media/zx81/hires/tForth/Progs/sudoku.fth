\ SUDOKU version 1.0
\ A game for the Jupiter Ace computer
\ copyright (c) 2007 by Ricardo F. Lopes
\ under the GPL (General Public License) v.2

: TASK ;
\ Defining some missing words:

\ Leave greater of two numbes
: MAX  ( n1 n2 -- n3)
   2DUP <
   IF SWAP
   THEN
   DROP ;

\ Leave lesser of two numbes
: MIN  ( n1 n2 -- n3)
   2DUP >
   IF SWAP
   THEN
   DROP ;

\ Set print position to row n1 and column n2
: AT  ( n1 n2 -- )
   SWAP 33 * + 16530
   + 17339 ! ;

\ Output n spaces
: SPACES  ( n -- )  
   ?DUP IF 0 DO SPACE LOOP THEN ;

HEX
CODE CMOVE ( src dst n -- : Move n bytes from src to dst )
  E1 C,          \ POP HL      ; 'dst'
  EB C,          \ EX DE,HL    ; DE = 'dst', HL = IP
  E3 C,          \ EX [SP],HL  ; HL = 'src', IP on stack
  ED C, B0 C,    \ LDIR        ; move 'n' bytes
  D1 C,          \ POP DE      ; restore IP
  C1 C,          \ POP BC      ; new TOS
  NEXT           \ jp NEXT

\ Drive the ZON-X81 sound device.
CODE SND  ( n1 n2 -- )       \ Write n1 to AY register n2
  79 C,          \ ld a,c
  D3 C, DF C,    \ out ($df),a
  E1 C,          \ pop hl
  7D C,          \ ld a,l
  D3 C, 0F C,    \ out ($0f),a
  C1 C,          \ pop bc
  NEXT           \ jp NEXT

\ Turns off all sound on all channels, A,B and C
: SNDOFF  ( -- )
   FF 7 SND ;
: BEEP ( c n -- )
   SWAP 0 SND
   0 1 SND
   FE 7 SND
   0F 8 SND
   2* 0 DO LOOP SNDOFF ;


( ==================== )
(  Graphic Characters  )
( ==================== )

CREATE GRAPH   ( Font buffer )
00 C, 18 C, 38 C, 18 C, 18 C, 18 C, 7E C, 00 C,
00 C, 3C C, 66 C, 0C C, 18 C, 30 C, 7E C, 00 C,
00 C, 7E C, 0C C, 18 C, 0C C, 66 C, 3C C, 00 C,
00 C, 0C C, 1C C, 3C C, 6C C, 7E C, 0C C, 00 C,
00 C, 7E C, 60 C, 7C C, 06 C, 66 C, 3C C, 00 C,
00 C, 3C C, 60 C, 7C C, 66 C, 66 C, 3C C, 00 C,
00 C, 7E C, 06 C, 0C C, 18 C, 30 C, 30 C, 00 C,
00 C, 3C C, 66 C, 3C C, 66 C, 66 C, 3C C, 00 C,
00 C, 3C C, 66 C, 3E C, 06 C, 0C C, 38 C, 00 C,
00 C, 00 C, 00 C, 03 C, 0F C, 0C C, 18 C, 18 C,
00 C, 00 C, 00 C, C0 C, F0 C, 30 C, 18 C, 18 C,
18 C, 18 C, 0C C, 0F C, 03 C, 00 C, 00 C, 00 C,
18 C, 18 C, 30 C, F0 C, C0 C, 00 C, 00 C, 00 C,
00 C, 00 C, 00 C, FF C, FF C, 00 C, 00 C, 00 C,
18 C, 18 C, 18 C, 18 C, 18 C, 18 C, 18 C, 18 C,
18 C, 18 C, 18 C, FF C, FF C, 18 C, 18 C, 18 C,
18 C, 18 C, 18 C, 1F C, 1F C, 18 C, 18 C, 18 C,
18 C, 18 C, 18 C, F8 C, F8 C, 18 C, 18 C, 18 C,
00 C, 00 C, 00 C, FF C, FF C, 18 C, 18 C, 18 C,
18 C, 18 C, 18 C, FF C, FF C, 00 C, 00 C, 00 C,
18 C, 18 C, 18 C, 18 C, BA C, 18 C, 18 C, 18 C,
18 C, 18 C, 18 C, 18 C, 1A C, 18 C, 18 C, 18 C,
\ FF C, 81 C, 81 C, 81 C, 81 C, 81 C, 81 C, FF C,
18 C, 18 C, 18 C, 18 C, B8 C, 18 C, 18 C, 18 C,
08 C, 00 C, 08 C, FF C, FF C, 00 C, 08 C, 00 C,
00 C, 00 C, 00 C, FF C, FF C, 00 C, 08 C, 00 C,
08 C, 00 C, 08 C, FF C, FF C, 00 C, 00 C, 00 C,
08 C, 00 C, 08 C, 00 C, AA C, 00 C, 08 C, 00 C,
00 C, 00 C, 00 C, 00 C, AA C, 00 C, 00 C, 00 C,
08 C, 00 C, 08 C, 00 C, 08 C, 00 C, 08 C, 00 C,

DECIMAL

: GR ( Set graphic characters to char generator mem )
 GRAPH       12296 104 CMOVE ( CHR$ 1-13   )
 GRAPH 104 + 12408  96 CMOVE ( CHR$ 15-26  )
 GRAPH 200 + 12648   8 CMOVE ( CHR$ 50     )
 GRAPH 208 + 12768  16 CMOVE ( CHR$ 60-61  )
 GRAPH 224 + 12792   8 CMOVE ( CHR$ 63     )
;

( ================= )
(  Draw Game Board  )
( ================= )


: L0  CR ." ( Z Z ( Z Z ( Z Z (" ; ( cell lines )
: L1  CR ." *XWXWX-XWXWX-XWXWX/" ; ( thin line separator )
: L2  CR ." >?;?;?)?;?;?)?;?;?<" ; ( fat line separator )
: FRAME ( draw board frame )
 CLS
 ." ^?,?,?=?,?,?=?,?,?" 34 EMIT  ( top border  )
 L0 L1 L0 L1 L0 L2               ( lines 1 2 3 )
 L0 L1 L0 L1 L0 L2               ( lines 4 5 6 )
 L0 L1 L0 L1 L0 CR               ( lines 7 8 9 )
 ." _?H?H?+?H?H?+?H?H?$" ;       ( bottom border )

: SCREEN
 FRAME
  0 20 AT ." €sudoku€‘Ž€"
  2 20 AT ." PAGE: 0"
  4 21 AT ." i"
  5 20 AT ." jkl MOVE"
  7 20 AT ." p n PG SEL"
 13 21 AT ." c  CLEAR"
 15 21 AT ." e  EDIT ON"
 17 21 AT ." q  QUIT"
 21 0 AT
 ." €€€c€’—€by€ricardo€fŽ€lopes€€€"
 ."  GNU GENERAL PUBLIC LICENSE V.2" ;

\ ( =================== )
\ (  READ THE KEYBOARD  )
\ ( =================== )
\ 
\ 16 BASE C!
\ CREATE >UPPER ( c -- C : convert a character to uppercase )
\  DF C,             ( RST  18h   ; E = char to convert     )
\  7B C,             ( LD   A,E   ; A = char to convert     )
\  CD C, 07 C, 08 C, ( CALL 0807h ; to-upper ROM routine    )
\  5F C,             ( LD   E,A   ; E = converted char      )
\  D7 C,             ( RST  10h   ; Push char to Data Stack )
\  FD C, E9 C,       ( JP   [IY]  ; end                     )
\ >UPPER DUP 2- !    ( make TOUPPER an executable word )
\ DECIMAL
\ 
\ : KEY ( -- c : wait for a keypress )
\  BEGIN INKEY 0= UNTIL
\  BEGIN INKEY ?DUP UNTIL ;

( =============== )
(  SCREEN CURSOR  )
( =============== )

: CURSOR ( i -- adr : Get screen cursor address )
 9 /MOD ( col lin )
 33 * + 2 * 16564 + ;
: ON  ( adr -- )  DUP C@ 128 OR SWAP C! ;   ( Invert video )
: OFF ( adr -- )  DUP C@ 127 AND SWAP C! ;  ( Normal video )

( =================== )
(  PUZZLE COLLECTION  )
( =================== )
20 CONSTANT #PG            ( Number of puzzles )
CREATE PGS #PG 81 * ALLOT  ( Sudoku collection )
PGS DUP 0 SWAP C! DUP 1+ #PG 81 * CMOVE   ( Clear the buffer )
0 VARIABLE PG              ( Current page )
: PG>  ( pg -- adr )  81 * PGS + ;  ( Get page address )
: IDX> ( i -- adr )   PG @ PG> + ;  ( Get cell address )
: GET ( i -- c )  IDX> C@ ;         ( Get cell content )
: SET ( c i -- : Set cell content )
 OVER OVER IDX> C! ( set cell content )
 CURSOR C! ;       ( update screen )

: LOADPG  ( pg -- : Load puzzle to screen )
 0 MAX #PG 1- MIN ( Limit page range )
 DUP PG !         ( Set as current page )
 DUP 2 26 AT .    ( Show page number )
 PG>              ( Get page address )
 81 0             ( Copy puzzle to screen )
 DO
  DUP C@          ( Get value )
  I CURSOR C!  ( Place it into the screen )
  1+           ( Point to next value )
 LOOP
 DROP ;

( Change current page )
: PG+ ( n -- )  PG @ + LOADPG ;

( ====================== )
(  CHECK ALLOWED VALUES  )
( ====================== )

CREATE HINTS 10 ALLOT ( List of allowed values )
: HINT@ ( c -- f )  HINTS + C@ ;
: HINT! ( f c -- )  HINTS + C! ;
: HINT0 ( Initialize list allowing all values )
 10 1
 DO
  I I HINT!
 LOOP
 32 0 HINT! ; ( value=0 is always allowed )

: RMV ( c -- c : Remove c from the list of allowed values)
 0 OVER GET DUP 9 >
 IF 28 - THEN ( Mask ASCII 0 out )
 ?DUP              ( Not zero? )
 IF
  HINT!
 ELSE
  DROP
 THEN ;

: LSCN ( lin -- : Scan line )
 9 * ( index )
 9 0
 DO
  RMV 1+
 LOOP
 DROP ;

: CSCN ( col -- : Scan column )
 9 0
 DO
  RMV 9 +
 LOOP
 DROP ;

( Lookup table for square index )
CREATE BC  0 C, 0 C, 0 C,  3 C,  3 C,  3 C,  6 C,  6 C,  6 C,
CREATE BL  0 C, 0 C, 0 C, 27 C, 27 C, 27 C, 54 C, 54 C, 54 C,
: SSCN ( col lin -- : Scan square )
 BL + C@
 SWAP BC + C@ + ( index )
 3 0   ( 3 lines )
 DO
  3 0  ( 3 columns )
  DO
   RMV 1+
  LOOP
  6 +  ( next line )
 LOOP
 DROP ;

: SCAN ( i -- : Scan line, column and square, removing founded values from list )
 9 /MOD ( col lin )
 OVER CSCN ( Check column   )
 DUP  LSCN ( Check line )
 SSCN ;    ( Check square )

: .HINT ( i -- : Show allowed values at cell i )
 HINT0 SCAN
 20 1 AT
 10 1
 DO
  I HINT@ ?DUP
  IF
   .
  ELSE
   2 SPACES
  THEN
 LOOP ;

( ============= )
(  PUZZLE EDIT  )
( ============= )
( ASCII  0 to  9 = locked cells: can be changed only in edit mode )
( ASCII 48 to 57 = unlocked cells: can be changed at will )

ASCII 0 VARIABLE NED ( True when not in Edit Mode )
: XED ( Toogle Edit Mode On/Off )
 15 29 AT
 NED @
 IF
   ." OFF"
  19 1 AT ." €€€€edit€mode€€€€"
  0
 ELSE
  ." ON "
  19 1 AT 17 SPACES
  ASCII 0
 THEN
 NED ! ;

: BZZ  300 50 BEEP ;  ( Not-Ok tone )
: BIP  30 DUP BEEP ;  ( Ok tone )

: WRITE ( i c -- i : Change value, checking if allowed )
 DUP HINT@ ( Is an allowed value?)
 IF
  NED @    ( Is not editing?)
  IF
   OVER GET
   DUP 0 > SWAP  ( Is cell not empty?)
   28 ( ASCII 0) < AND ( Is cell locked? )
   IF            ( Locked cell: Discard value)
    DROP BZZ
   ELSE          ( Unlocked cell: Ok to change)
    DUP IF 28 ( ASCII 0) + THEN ( if not clearing, set as user input )
    OVER SET BIP
   THEN
  ELSE           ( Edit mode: Ok to change)
   OVER SET BIP
  THEN
 ELSE            ( Not an allowed value: Discard it )
  DROP BZZ
 THEN ;

: CLR ( Clear all inputs )
 81 0
 DO
  I 0 WRITE DROP
 LOOP ;

( =========== )
(  Game Play  )
( =========== )

( Changing the current index position )
-9 CONSTANT UP
-1 CONSTANT LF
 1 CONSTANT RG
 9 CONSTANT DN
: GO ( i dir -- i )  + 0 MAX 80 MIN ;

: PLAY ( key i -- key i : Interpret input and take action)
 OVER ASCII I = IF UP GO THEN
 OVER ASCII J = IF LF GO THEN
 OVER ASCII K = IF DN GO THEN
 OVER ASCII L = IF RG GO THEN
 OVER ASCII N = IF RG PG+ THEN
 OVER ASCII P = IF LF PG+ THEN
 OVER ASCII C = IF CLR THEN
 OVER ASCII E = IF XED THEN
 OVER ASCII 0 -
 DUP -1 > OVER 10 < AND
 IF WRITE ELSE DROP THEN ;

: SUDOKU ( Main routine, start the game with this word )
 GR SCREEN         ( Draw screen              )
 ASCII 0 NED !     ( Not in edit mode         )
 0 LOADPG          ( Load first puzzle page   )
 40                ( Set initial cursor index )
 BEGIN
  DUP .HINT        ( Scan for alowed values )
  DUP CURSOR ON
  KEY SWAP         ( Get user input )
  DUP CURSOR OFF
  PLAY
  SWAP ASCII Q =   ( Quit? )
 UNTIL DROP ;
 