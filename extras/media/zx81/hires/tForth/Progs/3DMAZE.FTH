\      3D MAZE version 1.0 for Jupiter ACE
\     Copyright (c) 2007 by Ricardo F. Lopes
\ under the GNU General Public License version 2

CR .( START THE GAME WITH: )
CR .( 3DMAZE )

( Game control keys:  )
(  I = Step forward   )
(  J = Turn left      )
(  L = Turn right     )
(  K = Step backward  )
(  H = 2D map look-up )
(  Q = Quit game      )

( ============= )
(  MISC. WORDS  )
( ============= )

: TASK ; HEX

\ Move n bytes from src to dst
CODE CMOVE ( src dst n -- ) 
  E1 C,          \ pop hl      ; 'dst'
  EB C,          \ ex de,hl    ; DE = 'dst', HL = IP
  E3 C,          \ ex (sp),hl  ; HL = 'src', IP on stack
  ED C, B0 C,    \ ldir        ; move 'n' bytes
  D1 C,          \ pop de      ; restore IP
  C1 C,          \ pop bc      ; new TOS
  NEXT           \ jp next

\ Copy nth cell to top
: PICK  ( Xn .. X1 X0  n -- Xn .. X1 X0 Xn)
   2* SP@ 2+ + @ ;

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
   0 DO LOOP SNDOFF ;

CODE CHR128
  3E C, 31 C,    \ ld a,$31
  ED C, 47 C,    \ ld i,a
  NEXT           \ jp NEXT

DECIMAL

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

: ADDNLS DUP 32 / + ; ( add 1 for each NL at end of screen line )

: 128+ DUP IF 128 OR THEN ;

: 1+! ( adr -- )  1 SWAP +! ;

( Random Number Generator )
0 VARIABLE RND
: RANDOMIZE 16436 @ 32767 AND RND ! ;
: RANDOM RND @ 31421 * 6927 + DUP RND ! ;
: RAND RANDOM UM* SWAP DROP ; ( n1 -- n2 : n2 = random from 0 to n1-1)

( ==================== )
(  GRAPHIC CHARACTERS  )
( ==================== )

CREATE GRAPH HEX ( Graphic characters )

00 C, 00 C, 00 C, 00 C, 00 C, 00 C, 00 C, 00 C, ( Graphics characters )
7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C,
FF C, FF C, FF C, FF C, FF C, FF C, FF C, 00 C,
7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 00 C,
FE C, FE C, FE C, FE C, FE C, FE C, FE C, FE C,
7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C,
FE C, FE C, FE C, FE C, FE C, FE C, FE C, 00 C,
7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 00 C,
00 C, FF C, FF C, FF C, FF C, FF C, FF C, FF C,
00 C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C,
00 C, FF C, FF C, FF C, FF C, FF C, FF C, 00 C,
00 C, 7F C, 7F C, 7F C, 7F C, 7F C, 7F C, 00 C,
00 C, FE C, FE C, FE C, FE C, FE C, FE C, FE C,
00 C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C,
00 C, FE C, FE C, FE C, FE C, FE C, FE C, 00 C,
00 C, 7E C, 7E C, 7E C, 7E C, 7E C, 7E C, 00 C,
FF C, FF C, E7 C, C3 C, C3 C, E7 C, FF C, FF C,
7F C, 7F C, 67 C, 43 C, 43 C, 67 C, 7F C, 7F C,
FF C, FF C, E7 C, C3 C, C3 C, E7 C, FF C, 00 C,
7F C, 7F C, 67 C, 43 C, 43 C, 67 C, 7F C, 00 C,
FE C, FE C, E6 C, C2 C, C2 C, E6 C, FE C, FE C,
7E C, 7E C, 66 C, 42 C, 42 C, 66 C, 7E C, 7E C,
FE C, FE C, E6 C, C2 C, C2 C, E6 C, FE C, 00 C,
7E C, 7E C, 66 C, 42 C, 42 C, 66 C, 7E C, 00 C,
00 C, FF C, E7 C, C3 C, C3 C, E7 C, FF C, FF C,
00 C, 7F C, 67 C, 43 C, 43 C, 67 C, 7F C, 7F C,
00 C, FF C, E7 C, C3 C, C3 C, E7 C, FF C, 00 C,
00 C, 7F C, 67 C, 43 C, 43 C, 67 C, 7F C, 00 C,
00 C, FE C, E6 C, C2 C, C2 C, E6 C, FE C, FE C,
00 C, 7E C, 66 C, 42 C, 42 C, 66 C, 7E C, 7E C,
00 C, FE C, E6 C, C2 C, C2 C, E6 C, FE C, 00 C,
00 C, 7E C, 66 C, 42 C, 42 C, 66 C, 7E C, 00 C,

01 C, 02 C, 04 C, 08 C, 10 C, 20 C, 40 C, 80 C, ( slash )
80 C, 40 C, 20 C, 10 C, 08 C, 04 C, 02 C, 01 C, ( back slash )
DECIMAL

: GR ( Set graphic characters to char generator mem )
 7896        13056  40 CMOVE ( ASCII 123-127 e 96  )
 7984        13104 208 CMOVE ( ASCII 97-122        )
 GRAPH       12800 256 CMOVE ( ASCII 128-159       )
 GRAPH 256 + 12480   8 CMOVE ( ASCII 47, slash     )
 GRAPH 264 + 12352   8 CMOVE ( ASCII 92, backslash )
 CHR128
;

( ====== )
(  MAZE  )
( ====== )

( Maximum Maze dimensions + margins )
32 CONSTANT MAXX  ( must be 32, the screen width )
22 CONSTANT MAXY

( Current maze dimensions )
10 VARIABLE XSIZE
 7 VARIABLE YSIZE

( Add to maze size )
: X+ ( n -- )  XSIZE @ + 3 MAX 30 MIN XSIZE ! ;
: Y+ ( n -- )  YSIZE @ + 3 MAX 20 MIN YSIZE ! ;

CREATE MAZE  MAXX MAXY * ALLOT ( Maze mem )

( Convert room xy coordinates to maze mem address )
: XY>ROOM ( x y -- room )  MAXX * + MAZE + ;

( Room walls as bit masks )
 1 CONSTANT WEST   ( 0001 West wall  )
 2 CONSTANT SOUTH  ( 0010 South wall )
 4 CONSTANT EAST   ( 0100 East wall  )
 8 CONSTANT NORTH  ( 1000 North wall )
15 CONSTANT ALL    ( 1111 All walls  )

2 CONSTANT RIGHT
4 CONSTANT BACK
8 CONSTANT LEFT
: TURN ( facing1 dir -- facing2 : Change Direction )
 OVER 16 * ROT OR ( NESW -> NESWNESW )
 SWAP /           ( Turn )
 15 AND           ( NESWNESW -> NESW )
;

( ============= )
(  DRAW 2D MAP  )
( ============= )

: _MAP ( Draw 2D maze map )
 YSIZE @ 2+ 0     ( line count including margins )
 DO
  0 I XY>ROOM     ( source = maze )
  16530 I 33 * +  ( destination = screen )
  XSIZE @ 2+      ( column count, including margins )
  CMOVE           ( copy maze to screen )
 LOOP
;

: _ROOM ( room -- : Draw one maze room in 2D )
 DUP C@ SWAP       ( Stack: walls room )
 MAZE - ADDNLS
 16530 +          ( Stack: walls screen )
 C!                ( Set screen char )
;

: _POS ( room -- : Show player position in 2D map )
 DUP C@ 144 OR SWAP
 MAZE - ADDNLS
 16530 + C!
;

( ================= )
(  MAZE GENERATION  )
( ================= )

: INIT ( Initialize maze before generate)
 YSIZE @ 2+ 0
 DO
  XSIZE @ 2+ 0
  DO
   ALL 128+ I J XY>ROOM C!                           ( Close rooms )
  LOOP
  0 I XY>ROOM DUP C@ EAST AND 128+ SWAP C!           ( West border )
  XSIZE @ 1+ I XY>ROOM DUP C@ WEST AND 128+ SWAP C!  ( East border )
 LOOP
 XSIZE @ 2+ 0
 DO
  I 0 XY>ROOM DUP C@ SOUTH AND 128+ SWAP C!          ( North border )
  I YSIZE @ 1+ XY>ROOM DUP C@ NORTH AND 128+ SWAP C! ( South border )
 LOOP
;

( Walking to next room )
CREATE WLK ( const table for WALK word )
0 , -1 , MAXX , 0 , 1 , 0 , 0 , 0 , MAXX NEGATE ,
: WALK ( room1 facing -- room2 facing : Walk to facing room )
 DUP 2 * WLK + @ ( displacement )
 ROT + SWAP
;

: REMOVE ( room facing -- room facing : Remove facing wall )
 2DUP 65407 ( -1) XOR     ( facing bit mask  )
 OVER C@ AND     ( clear facing bit )
 128+
 SWAP C!         ( store it back    )
 OVER _ROOM      ( update screen    )
;

: CUT ( room1 facing -- room2 : Open walls to next room )
 REMOVE     ( remove facing wall )
 WALK       ( go to next room    )
 BACK TURN  ( look back          )
 REMOVE     ( remove back wall   )
 DROP       ( discard facing     )
;

CREATE FACES 4 ALLOT ( direction buffer for neighbor check )

: CHECK ( n room facing -- n : Check & count if next room is closed )
 WALK              ( walk to next room    )
 SWAP C@ 15 AND ALL =     ( is it a closed room? )
 IF
  OVER FACES + C!  ( save facing     )
  1+               ( count as closed )
 ELSE
  DROP             ( discard facing  )
 THEN
;

: CHECKAROUND ( room -- room n : Check around for closed rooms )
 0  ( start counting closed neighbors )
 OVER WEST  CHECK
 OVER NORTH CHECK
 OVER EAST  CHECK
 OVER SOUTH CHECK
;

( Select a random direction toward a closed room )
: RNDFACE ( n -- facing )  RAND FACES + C@ ;

0 VARIABLE REMAINING ( remaining rooms to visit )

: DFS ( room #rooms -- : Depth-First Search maze generation )
 1- REMAINING !      ( rooms to visit )
 0 SWAP              ( stack a marker )
 BEGIN
  REMAINING @        ( stop when all rooms visited )
 WHILE
  CHECKAROUND ?DUP   ( any closed neighbor? )
  IF
   OVER SWAP         ( stack current room             )
   RNDFACE CUT       ( cut a passage to a closed room )
   REMAINING @ 1-    ( count visited rooms            )
   REMAINING !
  ELSE
   DROP              ( backtrack last visited room )
  THEN
 REPEAT
 BEGIN 0= UNTIL      ( clear stack to marker )
;

: GENERATE ( Start maze generation )
 CLS INIT _MAP
 XSIZE @ 2 /  YSIZE @ 2 /      ( Start from maze center )
 XY>ROOM XSIZE @ YSIZE @ * DFS
;

: SETEXIT ( Set a random maze exit at North border )
 XSIZE @ RAND 1+ 0
 XY>ROOM SOUTH CUT DROP
;

: START ( -- room facing : Generate a random start position at South )
 XSIZE @ RAND 1+ YSIZE @
 XY>ROOM NORTH
;

( ============== )
(  DRAW 3D MAZE  )
( ============== )

0 VARIABLE LOOKUPS  ( Number of 2D map invoking )
0 VARIABLE STEPS    ( Number of steps )

: .SCORE ( Display score and controls )
  0 24 AT ." ˜d€maze"
  2 25 AT ." STEPS"
  3 26 AT STEPS @ .
  5 25 AT ." HELPS"
  6 26 AT LOOKUPS @ .
 15 25 AT ." i"
 16 24 AT ." jkl MOVE"
 18 25 AT ." h  HELP"
 20 25 AT ." q  QUIT"
;

CREATE MRKS ( 3D drawing key screen coordinates )
( A     B )
  0 C, 22 C,
  1 C, 21 C,
  5 C, 17 C,
  8 C, 14 C,
 10 C, 12 C,
 11 C, 11 C,
: MARKS ( n -- A[n] B[n] )  2 * MRKS + DUP C@ SWAP 1+ C@ ;

( Draw Vertical edges: )
(  Left edge column = A[n+1]-1 )
( Right edge column = B[n+1]+1 )
(  1 past Last line = B[n+1]+1 )
(        First line = A[n+1]   )
: _EDGES ( n -- : Draw Vertical Edges )
 1+ MARKS 1+              ( A[n+1]   B[n+1]+1                 )
 OVER 1-                  ( A[n+1]   B[n+1]+1 A[n+1]-1        )
 SWAP ROT                 ( A[n+1]-1 B[n+1]+1 A[n+1]          )
 OVER SWAP                ( A[n+1]-1 B[n+1]+1 B[n+1]+1 A[n+1] )
 DO                       ( A[n+1]-1 B[n+1]+1                 )
  OVER I SWAP AT 134 EMIT ( Draw left edge  )
  I OVER AT 129 EMIT      ( Draw right edge )
 LOOP
 2DROP                    ( discard left & right column coord )
;

( Draw Back Wall: )
(           Top line = A[n+1]-1 )
(        Bottom line = B[n+1]+1 )
( 1 past last column = B[n+1]+1 )
(       First column = A[n+1]   )
: _BACK ( n -- : Draw Back Wall )
 1+ MARKS 1+         ( A[n+1]   B[n+1]+1                 )
 OVER 1-             ( A[n+1]   B[n+1]+1 A[n+1]-1        )
 ROT ROT             ( A[n+1]-1 A[n+1]   B[n+1]+1        )
 DUP ROT             ( A[n+1]-1 B[n+1]+1 B[n+1]+1 A[n+1] )
 DO                  ( A[n+1]-1 B[n+1]+1                 )
  OVER I AT 131 EMIT ( Draw top line    )
  DUP I AT 124 EMIT  ( Draw bottom line )
 LOOP
 2DROP               ( discard top & bottom line coord )
;

( Draw Left Wall: )
(        Bottom line = B[n]   )
(           Top line = A[n]   )
( 1 past last column = A[n+1] )
(       First column = A[n]   )
: _LWALL ( n -- : Draw Left wall )
 DUP MARKS SWAP    ( n    B[n]   A[n]   )
 ROT 1+ MARKS DROP ( B[n] A[n]   A[n+1] )
 SWAP              ( B[n] A[n+1] A[n]   )
 DO                ( B[n]               )
  I I AT 92 EMIT   ( Draw top line \          )
  DUP I AT 47 EMIT ( Draw bottom line /       )
  1-               ( update bottom line coord )
 LOOP
 DROP              ( discard bottom line coord )
;

( Draw Right Wall: )
(        Bottom line = B[n+1]+1   )
(           Top line = A[n+1]-1   )
( 1 past last column = B[n]+1     )
(       First column = B[n+1]+1   )
: _RWALL ( n -- : Draw Right Wall )
 DUP 1+ MARKS 1+ SWAP 1- ( n        B[n+1]+1 A[n+1]-1 )
 ROT MARKS SWAP DROP 1+  ( B[n+1]+1 A[n+1]-1 B[n]+1   )
 ROT                     ( A[n+1]-1 B[n]+1   B[n+1]+1 )
 DO                      ( A[n+1]-1                   )
  DUP I AT 47 EMIT       ( Draw top line /       )
  I I AT 92 EMIT         ( Draw bottom line \    )
  1-                     ( update top line coord )
 LOOP
 DROP                    ( discard top line coord )
;

( Draw Left Back Wall: )
(        Bottom line = B[n+1]+1 )
(           Top line = A[n+1]-1 )
( 1 past last column = A[n+1]   )
(       First column = A[n]     )
: _LBACK ( n -- : Draw Left Back Wall )
 DUP 1+ MARKS 1+     ( n        A[n+1]   B[n+1]+1        )
 ROT MARKS DROP      ( A[n+1]   B[n+1]+1 A[n]            )
 ROT DUP 1-          ( B[n+1]+1 A[n]     A[n+1] A[n+1]-1 )
 SWAP ROT            ( B[n+1]+1 A[n+1]-1 A[n+1] A[n]     )
 DO                  ( B[n+a]+1 A[n+1]-1                 )
  DUP I AT 131 EMIT  ( Draw top line    )
  OVER I AT 124 EMIT ( Draw bottom line )
 LOOP
 2DROP               ( discard top & bottom line coord )
;

( Draw Right Back Wall: )
(        Bottom line = B[n+1]+1 )
(           Top line = A[n+1]-1 )
( 1 past last column = B[n]+1   )
(       First column = B[n+1]+1 )
: _RBACK ( n -- : Draw Right Back Wall )
 DUP 1+ MARKS 1+ SWAP 1-       ( n        B[n+1]+1 A[n+1]-1          )
 SWAP ROT MARKS SWAP DROP 1+   ( A[n+1]-1 B[n+1]+1 B[n]+1            )
 OVER                          ( A[n+1]-1 B[n+1]+1 B[n]+1   B[n+1]+1 )
 DO                            ( A[n+1]-1 B[n+1]+1                   )
  OVER I AT 131 EMIT           ( Draw top line    )
  DUP I AT 124 EMIT            ( Draw bottom line )
 LOOP
 2DROP                         ( discard top & bottom line coord )
;

( Check if facing wall exist )
: WALL? ( room facing -- flag )  SWAP C@ AND ;

: _3D ( room facing -- )
 CLS
 .SCORE
 5 0                    ( max View depth = 5 rooms )
 DO
  I _EDGES              ( Draw vertical edges )
  2DUP LEFT TURN WALL?  ( Is there a wall at left? )
  IF
   I _LWALL             ( draw left wall )
  ELSE
   2DUP LEFT TURN WALK  ( Go to left room )
   RIGHT TURN WALL?     ( Is there a left back wall?)
   IF
    I _LBACK            ( draw left back wall )
   THEN
  THEN
  2DUP RIGHT TURN WALL? ( Is there a wall at right? )
  IF
   I _RWALL             ( draw right wall )
  ELSE
   2DUP RIGHT TURN WALK ( Go to right room )
   LEFT TURN WALL?      ( Is there a right back wall? )
   IF
    I _RBACK            ( draw right back wall )
   THEN
  THEN
  2DUP WALL?            ( Facing a wall? )
  IF
   I _BACK LEAVE        ( Draw back wall and leave loop )
  ELSE
   WALK                 ( Move forward )
   OVER MAZE - 32 <     ( Maze exit? )
   IF
    LEAVE               ( Leave loop )
   THEN
  THEN
 LOOP
 2DROP                  ( Discard room & facing )
;

( ============== )
(  GAME CONTROL  )
( ============== )

( Check if the exit was found )
: EXIT? ( room -- flag )  MAZE - 32 < ;

: .FACE ( facing -- : Print facing direction )
 DUP WEST  = IF ." WEST"  THEN
 DUP SOUTH = IF ." SOUTH" THEN
 DUP EAST  = IF ." EAST"  THEN
 NORTH     = IF ." NORTH" THEN
;

: .INFO ( room facing -- : Print info bar at screen bottom )
 200 600 BEEP
 22 0 AT ." FACING " .FACE
 ." , S:" STEPS @ .
 ." H:" LOOKUPS @ .
 EXIT?
 IF
  100 250 BEEP 60 150 BEEP
  ." exit"
 THEN
;

: _2D ( room facing -- : Draw 2D map and wait for a keypress )
 CLS _MAP OVER _POS .INFO
 KEY DROP                  ( Wait for a keypress )
;

: FORWARD ( room1 facing -- room2 facing : Step forward )
 2DUP WALL? 0=
 IF
  WALK STEPS 1+!
 THEN
;

: BACKWARD ( room1 facing -- room2 facing : Step backward )
 BACK TURN  FORWARD  BACK TURN
;

: PLAY
 0 STEPS !
 0 LOOKUPS !
 GENERATE SETEXIT START
 2DUP _2D
 BEGIN
  2DUP _3D
  KEY ROT ROT
  2 PICK ASCII I = IF FORWARD  THEN
  2 PICK ASCII K = IF BACKWARD  THEN
  2 PICK ASCII J = IF LEFT TURN  THEN
  2 PICK ASCII L = IF RIGHT TURN  THEN
  2 PICK ASCII H = IF 2DUP _2D  LOOKUPS 1+! THEN
  ROT ASCII Q = 2 PICK EXIT? OR
 UNTIL
 _2D
;

: .MENU
 CLS
 ." €€€€€€€€€€€€˜d€maze€€€€€€€v€–”•€"
  4 11 AT ." WIDTH:"
  5 10 AT ." HEIGHT:"
  7 11 AT ." i"
  8 10 AT ." jkl  SET MAZE SIZE"
 10 11 AT ." p   PLAY"
 12 11 AT ." q   QUIT"
 20  3 AT ." (C) 2007 BY RICARDO F. LOPES"
 21  4 AT ." GENERAL PUBLIC LICENSE V.2"
;

: .SIZE
 4 18 AT XSIZE @ .
 5 18 AT YSIZE @ .
;

: 3DMAZE ( Start the 3D game )
 GR RANDOMIZE .MENU
 BEGIN
  .SIZE
  KEY
  DUP ASCII I = IF  1 X+ THEN
  DUP ASCII K = IF -1 X+ THEN
  DUP ASCII J = IF -1 Y+ THEN
  DUP ASCII L = IF  1 Y+ THEN
  DUP ASCII P = IF PLAY .MENU THEN
  ASCII Q =
 UNTIL
 CLS ABORT
;
 