CR CR .( MANCALA)
CR .( A GAME BY DOMINIQUE CONTANT) CR

\ This was my first game, called Mancala (also called Oware).
\ It comes from a basic program I had found in a Brazilian magazine. My purpose was to
\ translate in Forth the Minimax algorithm.
\ The rules: You are the Player against the computer. At your turn, you choose one of the
\ six houses under your control, removes all stone from that house, and distribute them,
\ dropping one in each house counter-clockwise from this house. If the last stone was
\ placed into a house (your or computer house) that brought its total to two or three, all
\ the stone in that house are captured and placed in your store. If the previous-to-last
\ stone also brought a house to two or three, these are captured as well, and so on.
\ You can choose any level of difficulty, but the program is very slow above level 4. 
\ Dominique Contant, Fri Nov 20, 2009
\ (message post on RWAP Sinclair ZX80 / ZX81 Forums)

: TASK ;
HEX
: NOT 0= ; .( .)
: 0<> 0= NOT ; .( .)
CODE FAST CD C, 0F23 , NEXT .( .)
CODE SLOW C5 C, CD C, 0F2B , C1 C, NEXT .( .)
: AT  ( n1 n2 -- )              ( set print position to row n1 and column n2 )
   SWAP 21 * + 4092 ( dfile)
   + 43BB ( cur_pos) ! ; DECIMAL .( .)
: #IN
   BEGIN
    ." ?" TIB @ DUP LBP ! INPUT
    BL WORD COUNT NUMBER
   UNTIL DROP ; .( .)
: DIM CREATE 2* 2+ ALLOT DOES> SWAP 2* + ;  .( .)
26 DIM B-STA 
300 DIM P-STA
: M-STA 2* 0 B-STA 28 +  + ; .( .)
24 B-STA CONSTANT B-P-V 
23 B-STA CONSTANT B-C-V 
22 B-STA CONSTANT DEPTH 
25 B-STA CONSTANT BEST-MOVE 
14 B-STA CONSTANT N-P-M  
21 B-STA CONSTANT MOVE-COUNT 
: VARIABLE 0 VARIABLE ;  .( .)
VARIABLE MAX-DEPTH 
VARIABLE MOVE-TO-DO 
VARIABLE HOUSE
VARIABLE PTS 
VARIABLE F-FAST 
VARIABLE P-STA-PTR 
VARIABLE B-STA-PTR 
VARIABLE HAND 
VARIABLE TMP-VA 
VARIABLE REF 11 REF ! .( .)
: CL-TXT 0 0 AT 60 0 DO 32 EMIT LOOP 0 0 AT ; .( .)
: MSG-COMP-W CL-TXT  ." I WON " ; .( .)
: MSG-PLAY-W CL-TXT ." YOU WON " ; .( .)
: MSG-NULL CL-TXT ." DRAWN " ; .( .)
: MSG-C-N-M CL-TXT  ." I CAN'T PLAY " ; .( .)
: MSG-P-N-M CL-TXT ." YOU CAN'T PLAY " ; .( .)
: MSG-COMP-MOVE CL-TXT ." I PLAY " ; .( .)
: MSG-PLAY-MOVE CL-TXT ." WHAT IS YOUR CHOICE ( 1 TO 6)" ; .( .)
: MSG-DEPTH CL-TXT ." LEVEL OF DIFFICULTY " ; .( .)
: MSG-FIRST-PLAY CL-TXT ." DO YOU WANT TO BEGIN? (Y/N) " ; .( .)
: MSG-FAST-M CL-TXT ." FAST  MODE ? (Y/N)" ; .( .)
: MSG-KEY 1 0 AT ." HIT A KEY" KEY DROP ; .( .)
: MSG-BOARD1 AT ." * * M A N C A L A * *" ; .( .)
: MSG-BOARD2 AT ." PTS" ; .( .)
: MSG-BOARD3 AT ." PLAYER" ; .( .)
: MSG-BOARD4 AT ." COMPUTER" ; .( .)
: PRINT-BOX
   REF @ 0
   DO
    31 0
    DO
     2DUP I + AT
     128 EMIT
    LOOP
    SWAP 1+ SWAP
   LOOP ; .( .)
: PRINT-ONE-HOUSE
   3 0 DO
        3 0 DO
             2DUP I + AT 32 EMIT
            LOOP
        SWAP 1+ SWAP
       LOOP ; .( .)
: PRINT-HOUSE
   7 1 DO
        PRINT-ONE-HOUSE
        SWAP 3 - SWAP 4 +
       LOOP 2DROP ;  .( .)
: PRINT-TXT
   REF C@ DUP 2+ 2 MSG-BOARD2
   DUP 2+ 8 MSG-BOARD1 DUP
   5 - 2 MSG-BOARD3
   9 + 2 MSG-BOARD4 ; .( .)
: PRINT-BOARD
   CLS 8 0 PRINT-BOX SWAP 10 -
   SWAP 7 + PRINT-HOUSE REF @
   4 + 7 PRINT-HOUSE PRINT-TXT ; .( .)
: PRINT-FIGURE 
   1- AT DUP 10 <
   IF 32 EMIT THEN . ; .( .)
: PRINT-STONE
   13 B-STA @ REF @ 1- 3 PRINT-FIGURE
   0 B-STA @ REF @ 5 + 3 PRINT-FIGURE
   7 1 DO
        13 I - B-STA @ REF @ 1- I 4 * 4 + PRINT-FIGURE
        I B-STA @ REF @ 5 + I 4 * 4 + PRINT-FIGURE
       LOOP ; .( .)
: ASK-FAST-M
   MSG-FAST-M F-FAST KEY 89 =
   IF 1 SWAP !
   ELSE 0 SWAP ! THEN ; .( .)
: ASK-FIRST-PLAY
   MSG-FIRST-PLAY KEY ; .( .)
: ASK-DEPTH
   MSG-DEPTH #IN MAX-DEPTH ! ; .( .)
: LEGAL-MOVE
   13 OVER > OVER 6 >
   AND SWAP B-STA @
   0<> AND ; .( .)
: ASK-PLAY-MOVE
   BEGIN
    MSG-PLAY-MOVE #IN
    6 + DUP MOVE-TO-DO !
    LEGAL-MOVE
   UNTIL ; .( .)
: ?FAST
   F-FAST C@ IF MSG-KEY FAST THEN ; .( .)
: ?SLOW
   F-FAST @ IF SLOW THEN ; .( .)
: POSS-MOVE
   0 N-P-M ! HOUSE @ DUP 6 +
  SWAP DO
        I B-STA  @ 0<>
        IF 1 N-P-M +! 
         I N-P-M  @ M-STA !
        THEN
       LOOP ; .( .)
: INIT-STONE
   0 0 B-STA !
   0 13 B-STA !
   13 1 DO
         4 I B-STA !
        LOOP ; .( .)
: ?NUMB-MOVE
   N-P-M @ ; .( .)
: PRT-COMP-MOVE
   MSG-COMP-MOVE BEST-MOVE @ DUP . MOVE-TO-DO ! ;  .( .)
: PLAY-MOVE 13 PTS ! ; .( .)
: COMP-MOVE 0 PTS ! ; .( .)
: GET-PLAY-MOVE 7 HOUSE ! POSS-MOVE ; .( .)
: GET-COMP-MOVE 1 HOUSE ! POSS-MOVE ; .( .)
: FIX-WIN
   0 B-STA @ 13 B-STA @ 2DUP >
   IF MSG-COMP-W
   ELSE 2DUP <
    IF MSG-PLAY-W
    ELSE MSG-NULL
    THEN
  THEN 2DROP ; .( .)
: COMP-BOARD-SCORE
   0 B-STA @ 13 B-STA @ - TMP-VA ! ; .( .)
: PLAY-BOARD-SCORE
   13 B-STA @ 0 B-STA @ - TMP-VA ! ; .( .)
: THIS-HOUSE
   B-STA-PTR @ B-STA ; .( .)
: ?SCORE-HOUSE
   THIS-HOUSE @ DUP 1 > SWAP 4 < AND ; .( .)
: PRECED-HOUSE
   B-STA-PTR -1 OVER
   +! DUP @ 1 <
   IF 12 OVER ! THEN DROP ; .( .)
: NEXT-HOUSE
   B-STA-PTR 1 OVER
   +! DUP @ 12 >
   IF 1 OVER ! THEN DROP ; .( .)
: SCORE-MOVE
   BEGIN
    ?SCORE-HOUSE
   WHILE
    THIS-HOUSE DUP @ PTS @
    B-STA +! 0 SWAP ! PRECED-HOUSE
   REPEAT ; .( .)
: INIT-MAXIMIZ
   999 B-P-V !
  -999 B-C-V !
  0 DEPTH ! 0 P-STA-PTR ! ; .( .)
: DO-MOVE
   MOVE-TO-DO @ DUP
   B-STA-PTR ! B-STA DUP @
   HAND ! 0 SWAP !
   BEGIN
    HAND @ 0<> 
   WHILE
    NEXT-HOUSE 1
    THIS-HOUSE +!
    -1 HAND +!
   REPEAT SCORE-MOVE ; .( .)
: IN-P-STA
   P-STA-PTR SWAP OVER @ P-STA ! 1 SWAP +! ; .( .)
: PUSH-PARAM
   MOVE-COUNT @ IN-P-STA
   DEPTH @ IN-P-STA
   B-C-V @ IN-P-STA
   B-P-V @ IN-P-STA
   BEST-MOVE @ IN-P-STA ; .( .)
: PUSH-HOUSE
   14 0 DO
         I B-STA @ IN-P-STA
        LOOP ; .( .)
: PUSH-M-STA
   N-P-M @ 1+ 1 
   DO
    I M-STA @ IN-P-STA
   LOOP
   N-P-M @ IN-P-STA ; .( .)
: PUSH-BOARD
   PUSH-PARAM PUSH-HOUSE PUSH-M-STA ; .( .)
: OUT-P-STA
   P-STA-PTR -1 OVER +! @ P-STA @ ; .( .)
: POP-M-STA
   OUT-P-STA
   DUP N-P-M !
   1+ DUP 1
   DO
    OUT-P-STA OVER
    I - M-STA !
   LOOP DROP ; .( .)
: POP-HOUSE
   14 0
   DO
    OUT-P-STA
    13 I - B-STA !
   LOOP ; .( .)
: POP-PARAM
   OUT-P-STA BEST-MOVE !
   OUT-P-STA B-P-V !
   OUT-P-STA B-C-V !
   OUT-P-STA DEPTH !
   OUT-P-STA MOVE-COUNT ! ; .( .)
: PLAY-MOVE
   13 PTS ! DO-MOVE ; .( .)
: COMP-MOVE
  0 PTS ! DO-MOVE ; .( .)
: POP-BOARD
   POP-M-STA
   POP-HOUSE
   POP-PARAM ; .( .)
: (LEAVE)
   N-P-M @ MOVE-COUNT ! ; .( .)
: (MAXIMIZ) CR ; 
: LOOP-MIN
   0 MOVE-COUNT !
   BEGIN
    1 MOVE-COUNT +!
    B-P-V @ B-C-V @ > NOT
    IF (LEAVE)
    ELSE PUSH-BOARD
         1 DEPTH +!
         MOVE-COUNT @
         M-STA @ MOVE-TO-DO !
         PLAY-MOVE (MAXIMIZ) POP-BOARD
         B-P-V @ TMP-VA @ >
         IF TMP-VA @ B-P-V !
          MOVE-COUNT @ M-STA @ BEST-MOVE !
         THEN
    THEN
    N-P-M @ MOVE-COUNT @ =
   UNTIL ; .( .)
: ?MAX-DEPTH
   DEPTH @ MAX-DEPTH @ = ; .( .)
: MINIMIZ
   ?MAX-DEPTH
   IF COMP-BOARD-SCORE
   ELSE GET-PLAY-MOVE ?NUMB-MOVE 0=
    IF COMP-BOARD-SCORE
    ELSE 
     999 B-P-V !
     LOOP-MIN B-P-V @
     TMP-VA !
    THEN
   THEN ; .( .)
: LOOP-MAXIM
  0 MOVE-COUNT !
  BEGIN
   1 MOVE-COUNT +!
   B-C-V @ B-P-V @ < NOT
   IF (LEAVE)
   ELSE
    PUSH-BOARD 1 DEPTH +!
    MOVE-COUNT  @ M-STA @
    MOVE-TO-DO ! COMP-MOVE
    MINIMIZ POP-BOARD
    TMP-VA @ B-C-V @ >
    IF TMP-VA @ B-C-V !
     MOVE-COUNT @ M-STA @
     BEST-MOVE !
    THEN
   THEN
   N-P-M @ MOVE-COUNT @ =
  UNTIL ; .( .)
: MAXIMIZ
   ?MAX-DEPTH
   IF COMP-BOARD-SCORE
   ELSE
    GET-COMP-MOVE ?NUMB-MOVE 0=
    IF COMP-BOARD-SCORE
    ELSE
     -999 B-C-V !
     LOOP-MAXIM B-C-V @
     TMP-VA !
    THEN
   THEN ; .( .)
: ?END-GAME
   0 B-STA @ 13 B-STA @ + 46 > ; .( .)
: (PROGRAM-LOOP)
   BEGIN
    GET-COMP-MOVE N-P-M @ 0=
    IF MSG-C-N-M
    ELSE
     INIT-MAXIMIZ ?FAST
     MAXIMIZ ?SLOW
     PRT-COMP-MOVE MSG-KEY
     COMP-MOVE PRINT-STONE
    THEN
    GET-PLAY-MOVE N-P-M @ 0=
    IF MSG-P-N-M
    ELSE
     ASK-PLAY-MOVE PLAY-MOVE
     PRINT-STONE
    THEN
    ?END-GAME
   UNTIL ; .( .)
' MAXIMIZ ' (MAXIMIZ) 3 + !
: MANCALA
   INIT-STONE PRINT-BOARD PRINT-STONE
   ASK-FAST-M ASK-DEPTH ASK-FIRST-PLAY 89 =
   IF ASK-PLAY-MOVE PLAY-MOVE PRINT-STONE THEN
   (PROGRAM-LOOP) FIX-WIN ; .( .)

CR .( TYPE MANCALA TO PLAY) CR
 