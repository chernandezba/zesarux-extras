          ORG       $38000

          LEA       LEVEL,A0
          MOVE.L    D1,(A0)

          LEA       GHOSTS,A0
          MOVE.L    D2,(A0)


          LEA       MAZEDIR,A0

          LEA       MAZE2,A1
          MOVE.L    A1,(A0)

          LEA       SPR2,A2
          MOVE.L    A2,10(A1)


          LEA       MAZE3,A1
          MOVE.L    A1,4(A0)

          LEA       SPR3,A2
          MOVE.L    A2,10(A1)


          LEA       MAZE,A1
          MOVE.L    A1,8(A0)

          LEA       SPR1,A2
          MOVE.L    A2,10(A1)

          LEA       MAZE4,A1
          MOVE.L    A1,12(A0)

          LEA       SPR4,A2
          MOVE.L    A2,10(A1)



          MOVEQ     #$20,D0
          MOVE.L    #$00010001,A0
          MOVE.W    #-1,D3
          TRAP      #3

          LEA       MAZENO,A1
          LEA       MAZEDIR,A2
          MOVE.L    (A2),(A1)

          LEA       NOOFMAZE,A1
          MOVE.W    #0,(A1)

          LEA       LIVES,A0
          MOVE.W    #3,(A0)

          LEA       SCORE,A0
          MOVE.L    #0,(A0)

GAME_START
          LEA       MAZENO,A0
          MOVE.L    (A0),A0

          LEA       A,A1
          MOVE.W    (A0),(A1)

          LEA       GHOST_AT,A1
          MOVE.L    2(A0),(A1)
          MOVE.L    6(A0),4(A1)

          LEA       KEY,A1
          MOVE.B    #0,(A1)

          MOVE.L    #$00010001,A0
          MOVE.W    #10,D1
          MOVE.W    #0,D2
          MOVE.W    #-1,D3
          MOVEQ     #$10,D0
          TRAP      #3

          LEA       BOARD,A1
          MOVE.W    $D0,A3
          JSR       (A3)


          MOVE.W    #17,D1
          MOVE.W    #0,D2
          MOVE.W    #-1,D3
          MOVEQ     #$10,D0
          TRAP      #3


          LEA       LIVES,A1
          MOVE.W    (A1),D1
          MOVE.W    $CE,A3
          JSR       (A3)

          BSR       SCORE_BOARD

          MOVE.W    #34,D1
          MOVE.W    #0,D2
          MOVE.W    #-1,D3
          MOVEQ     #$10,D0
          TRAP      #3

          LEA       HISCORE,A1
          MOVE.L    (A1),D1
          MOVE.W    $CE,A3
          JSR       (A3)

          LEA       STACK,A3
          ADD.L     #50,A3

          LEA       X,A0
          MOVE.B    #15,(A0)
          MOVE.B    #40,1(A0)

          LEA       SPRITES,A0
          LEA       MAZENO,A1
          MOVE.L    (A1),A1
          MOVE.L    10(A1),(A0)

          LEA       MAZENO,A2
          MOVE.L    (A2),A2
          ADD.L     #14,A2
          CLR.L     D3

          LEA       COLLECTED,A5
          MOVE.W    #0,(A5)

ACROSS    MOVE.W    #31,D5

START     LEA       X,A4
          MOVE.B    (A4),D1
          LEA       Y,A4
          MOVE.B    (A4),D2
          BSR       AT

          CMP.B     #'/',(A2)
          BEQ       YES

          CMP.B     #'.',(A2)
          BNE       NEXTSTART

YES       ADD.W     #1,(A5)

          MOVE.B    #'.',(A2)

NEXTSTART MOVE.B    (A2)+,D3

          CMP.B     #-1,D3
          BEQ       EXIT

WALL      CMP.B     #'*',D3
          BNE       DOT

          MOVE.B    #4,D3
          BRA       DO

DOT       CMP.B     #'.',D3
          BNE       SPAC

          MOVE.B    #2,D3

          BRA       DO

SPAC      MOVE.B    #3,D3

DO        BSR       PRINT

          LEA       X,A0
          ADD.B     #1,(A0)

          DBF       D5,START

          LEA       Y,A0
          ADD.B     #10,(A0)

          LEA       X,A0
          MOVE.B    #15,(A0)

          BRA       ACROSS

EXIT      LEA       X,A0
          MOVE.B    #15,(A0)
          MOVE.B    #40,1(A0)

MOVEMAN   LEA       GHOSTS,A4
          MOVE.L    (A4),D6

MANLOOP   LEA       A,A4
          MOVE.B    (A4),D1
          LEA       B,A4
          MOVE.B    (A4),D2

          LEA       X,A4
          ADD.B     (A4),D1

          MULU      #10,D2

          LEA       Y,A4
          ADD.B     (A4),D2
          BSR       AT

          LEA       S,A4
          MOVE.B    (A4),D3
          BSR       PRINT

KEYCHECK  LEA       TEMP,A3
          MOVE.L    #$09010000,(A3)
          CLR.W     4(A3)
          MOVE.B    #1,D1
          MOVE.B    D1,6(A3)
          MOVE.B    #2,7(A3)
          MOVEQ     #17,D0
          TRAP      #1


          CMP.W     #0,D1
          BEQ       AUTO_MOVE

          LEA       KEY,A0
          MOVE.B    (A0),D5
          MOVE.B    D1,(A0)


AUTO_MOVE LEA       MAZENO,A4
          MOVE.L    (A4),A0
          ADD.L     #14,A0
          LEA       A,A4
          MOVE.B    (A4),D2
          MOVE.B    1(A4),D3
          MULU      #32,D3
          ADD.W     D2,D3
          ADD.L     D3,A0

          CMP.B     #'.',(A0)
          BNE       NEXT_KEY

          MOVEM.L   A0-4/D1-6,-(A7)
          LEA       EAT_SOUND,A3
          BSR       SOUND

          LEA       SCORE,A0
          ADD.L     #10,(A0)
          BSR       SCORE_BOARD
          MOVEM.L   (A7)+,A0-4/D1-6

          LEA       COLLECTED,A2
          SUB.W     #1,(A2)

          CMP.W     #0,(A2)
          BLE       NEXT_SCREEN

          MOVE.B    #'/',(A0)

NEXT_KEY  LEA       KEY,A4
          MOVE.B    (A4),D1

RIGHT     CMP.B     #16,D1
          BNE       LEFT

          CMP.B     #'*',1(A0)
          BEQ       LAST_1

          LEA       A,A0
          ADD.B     #1,(A0)

          LEA       S,A0
          MOVE.B    #0,(A0)

          BRA       LAST

LEFT      CMP.B     #2,D1
          BNE       DOWN

          CMP.B     #'*',-1(A0)
          BEQ       LAST_1

          LEA       A,A0
          SUB.B     #1,(A0)

          LEA       S,A0
          MOVE.B    #1,(A0)

          BRA       LAST

DOWN      CMP.B     #128,D1
          BNE       UP

          CMP.B     #'*',32(A0)
          BEQ       LAST_1

          LEA       B,A0
          ADD.B     #1,(A0)

          LEA       S,A0
          MOVE.B    #9,(A0)

          BRA       LAST

UP        CMP.B     #4,D1
          BNE       LAST

          CMP.B     #'*',-32(A0)
          BEQ       LAST_1

          LEA       B,A0
          SUB.B     #1,(A0)

          LEA       S,A0
          MOVE.B    #10,(A0)

          BRA       LAST

LAST_1    LEA       KEY,A5
          MOVE.B    D5,(A5)
          MOVE.B    #0,D5

          BRA       AUTO_MOVE

LAST      LEA       LEVEL,A4
          MOVE.L    (A4),D5            GAME SPEED CONTROL
PAUSE2    DBF       D5,PAUSE2

          MOVE.B    #3,D3
          BSR       PRINT

          LEA       A,A4
          MOVE.B    (A4),D1
          MOVE.B    1(A4),D2

          LEA       X,A4
          ADD.B     (A4),D1

          MULU      #10,D2

          LEA       Y,A4
          ADD.B     (A4),D2

          BSR       AT

          MOVE.B    #5,D3
          BSR       PRINT

          MOVE.L    D3,-(A3)
          LEA       GHOST_AT,A0

          LEA       A,A4
          MOVE.B    (A4),D1
          MOVE.B    1(A4),D2
          MOVEQ     #3,D3

KILL_LOOP CMP.B     (A0),D1
          BNE       NEXT_LOP

          CMP.B     1(A0),D2
          BNE       NEXT_LOP

          BRA       DEAD

NEXT_LOP
          LEA       G,A1
          ADD.B     #1,(A1)
          CMP.B     #8,(A1)
          BLE       G_OK

          MOVE.B    #6,(A1)

G_OK
          MOVEM.L   A0-5/D0-7,-(A7)

          MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          LEA       X,A4
          ADD.B     (A4),D1

          MULU      #10,D2

          LEA       Y,A4
          ADD.B     (A4),D2
          BSR       AT

          LEA       G,A4
          MOVE.B    (A4),D3
          BSR       PRINT

          MOVEM.L   (A7)+,A0-5/D0-7


          ADD.L     #2,A0
          DBF       D3,KILL_LOOP

          MOVE.L    (A3)+,D3
          DBF       D6,MANLOOP          GHOST SPEED CONTROL


GHOST     LEA       GHOST_AT,A0
          MOVEQ     #3,D6

GHOSTLOOP MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          LEA       X,A4
          ADD.B     (A4),D1
          MULU      #10,D2

          LEA       Y,A4
          ADD.B     (A4),D2
          BSR       AT

          MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          LEA       A,A4
          MOVE.B    (A4),D4
          MOVE.B    1(A4),D5


          LEA       MAZENO,A4
          MOVE.L    (A4),A4
          ADD.L     #14,A4
          MULU      #32,D2
          ADD.B     D1,D2
          ADD.W     D2,A4
          MOVE.L    A4,A1


          CMP.B     #'.',(A4)
          BNE       SPACE

          MOVE.B    #2,D3
          BSR       PRINT

          BRA       MOVEGHOST

SPACE     MOVE.B    #3,D3
          BSR       PRINT


MOVEGHOST
          MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          LEA       A,A4
          MOVE.B    (A4),D4
          MOVE.B    1(A4),D5

          CMP.B     D1,D4
          BNE       GHOST_CONTINUE

          CMP.B     D2,D5
          BNE       GHOST_CONTINUE

          BRA       DEAD

GHOST_CONTINUE
          LEA       MAZENO,A1
          MOVE.L    (A1),A1
          ADD.L     #14,A1
          MULU      #32,D2
          ADD.B     (A0),D2
          ADD.W     D2,A1


          MOVE.B    1(A0),D2

          MOVE.W    163886,D7

G_RIGHT   AND.W     #1,D7
          BNE       G_LEFT

          CMP.B     D4,D1
          BGE       G_LEFT

          CMP.B     #'*',1(A1)
          BEQ       G_DOWN

          ADD.B     #1,(A0)
          BRA       MOVED


G_LEFT    MOVE.W    163886,D7

          AND.W     #1,D7
          BNE       G_DOWN

          CMP.B     D4,D1
          BEQ       G_DOWN

          CMP.B     #'*',-1(A1)
          BEQ       G_DOWN

          SUB.B     #1,(A0)
          BRA       MOVED


G_DOWN    MOVE.W    163886,D7

          AND.W     #1,D7
          BNE       G_UP

          CMP.B     D5,D2
          BGT       G_UP

          CMP.B     #'*',32(A1)
          BEQ       MOVED

          ADD.B     #1,1(A0)
          BRA       MOVED

G_UP      MOVE.W    163886,D7

          AND.W     #1,D7
          BNE       MOVED

          CMP.B     D2,D5
          BEQ       MOVED

          CMP.B     #'*',-32(A1)
          BEQ       MOVED

          SUB.B     #1,1(A0)


MOVED
          MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          LEA       X,A4
          ADD.B     (A4),D1
          MULU      #10,D2

          LEA       Y,A4
          ADD.B     (A4),D2
          BSR       AT

PAUSE3
          LEA       G,A4
          MOVE.B    (A4),D3
          BSR       PRINT

          LEA       X,A4
          MOVE.B    (A4),D1
          MOVE.B    1(A4),D2

          LEA       A,A4
          MOVE.B    (A4),D4
          MOVE.B    1(A4),D5

          CMP.B     D1,D4
          BNE       GHOST_LOP

          CMP.B     D2,D5
          BEQ       DEAD

GHOST_LOP ADD.L     #2,A0
          DBF       D6,GHOSTLOOP

          BRA       MOVEMAN



AT        MOVEM.L   A0-5/D0-7,-(A7)
          LEA       AT_S,A0
          MOVE.B    D1,(A0)
          MOVE.B    D2,1(A0)
          MOVEM.L   (A7)+,A0-5/D0-7
          RTS


PRINT     MOVEM.L   A0-1/D0-7,-(A3)
          LEA       AT_S,A0
          MOVE.L    #131072,A1

          CLR.L     D1
          CLR.L     D2
          MOVE.B    (A0),D1
          MOVE.B    1(A0),D2

          MULU      #2,D1
          MULU      #128,D2

          ADD.L     D1,A1
          ADD.L     D2,A1

          LEA       SPRITES,A0
          MOVE.L    (A0),A0
          MULU      #20,D3
          ADD.L     D3,A0

          MOVEQ     #9,D4

P_LOOP    MOVE.W    (A0)+,(A1)
          ADD.L     #128,A1
          DBF       D4,P_LOOP


          MOVEM.L   (A3)+,A0-1/D0-7
          RTS

SCORE_BOARD
          MOVE.W    #55,D1
          MOVE.W    #0,D2
          MOVE.W    #-1,D3
          MOVE.L    #$00010001,A0
          MOVEQ     #$10,D0
          TRAP      #3

          LEA       SCORE,A4
          MOVE.L    (A4),D1
          MOVE.W    $CE,A3
          JSR       (A3)

          RTS

DEAD
          LEA       DEATH_SOUND,A3
          BSR       SOUND

          LEA       LIVES,A0
          SUB.W     #1,(A0)

          CMP.W     #0,(A0)
          BGT       GAME_START

          LEA       SCORE,A0
          LEA       HISCORE,A1
          MOVE.L    (A0),D1
          CMP.L     (A1),D1
          BLE       RETURN

          MOVE.L    (A0),(A1)

RETURN    MOVEQ     #0,D0
          RTS


NEXT_SCREEN
          LEA       NOOFMAZE,A0
          ADD.W     #1,(A0)

          LEA       MAZEDIR,A0

          LEA       NOOFMAZE,A4
          MOVE.W    (A4),D1

          SUB.W     #1,D1

SCR_LOOP  ADD.L     #4,A0
          DBF       D1,SCR_LOOP

          LEA       MAZENO,A1
          MOVE.L    (A0),(A1)

          CMP.L     #-1,(A0)
          BNE       OK

          LEA       NOOFMAZE,A0
          MOVE.W    #-1,(A0)
          BRA       NEXT_SCREEN

OK        LEA       SCREEN_SOUND,A3
          BSR       SOUND

          BRA       GAME_START


SOUND     MOVEM.L   A0-5/D0-7,-(A7)
          MOVEQ     #17,D0
          TRAP      #1

          MOVEM.L   (A7)+,A0-5/D0-7
          RTS

EAT_SOUND DC.B      $A,8
          DC.L      $0000AAAA

          DC.B      20,0
          DC.B      0,0
          DC.B      0,1
          DC.B      0,0
          DC.B      1,0

SCREEN_SOUND
          DC.B      $A,8
          DC.L      $0000AAAA

          DC.B      20,200
          DC.B      1,5
          DC.B      39,16
          DC.B      0,0
          DC.B      1,0

DEATH_SOUND
          DC.B      $A,8
          DC.L      $0000AAAA

          DC.B      80,200
          DC.B      1,1
          DC.B      39,16
          DC.B      15,0
          DC.B      1,0


   ;  CALCULATION AREA :

MAZEDIR   DC.L      0
          DC.L      0
          DC.L      0
          DC.L      0
          DC.L      -1

NOOFMAZE  DC.W      1

MAZENO    DC.L      0

AT_S      DS.B      2

X         DS.B      1
Y         DS.B      1

A         DC.B      0
B         DC.B      0

S         DC.B      0
G         DC.B      6

GHOST_AT  DC.B      0,0
          DC.B      0,0
          DC.B      0,0
          DC.B      0,0


LIVES     DC.W      0

SCORE     DC.L      0

HISCORE   DC.L      2000

COLLECTED DC.W      0

KEY       DC.B      0

SPRITES   DC.L      0

STACK     DS.L      50

TEMP      DS.B      8

GHOSTS    DS.L      1

LEVEL     DC.L      1

   ;  SPRITE DATA FOLLOWS :

SPR1      DC.B      0,0,62,62,119,119,254,254,252,252
          DC.B      252,252,254,254,127,127,62,62,0,0

          DC.B      0,0,124,124,238,238,127,127,63,63
          DC.B      63,63,127,127,254,254,124,124,0,0

          DC.B      0,0,0,0,0,0,24,0,36,24,36,24,24,0,0,0,0,0,0,0

          DC.W      0,0,0,0,0,0,0,0,0,0

          DC.W      255,66,36,24,36,36,24,36,66,255

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      255,255,255,255,126,126,60,60,0,0

          DC.B      60,0,126,0,153,0,153,0,255,0,129,0
          DC.B      129,0,129,0,255,0,255,0

          DC.W      60,126,153,153,255,255,129,129,255,255

          DC.B      60,60,126,126,153,153,153,153,255,255
          DC.B      255,255,255,255,255,255,255,255,255,255

          DC.B      0,0,60,60,126,126,255,255,255,255,253,253
          DC.B      231,231,66,66,0,0,0,0

          DC.B      0,0,66,66,231,231,191,191,255,255,255,255
          DC.B      126,126,60,60,0,0,0,0


SPR2      DC.B      0,0,62,62,119,119,254,254,252,252
          DC.B      252,252,254,254,127,127,62,62,0,0

          DC.B      0,0,124,124,238,238,127,127,63,63
          DC.B      63,63,127,127,254,254,124,124,0,0

          DC.B      0,0,16,60,1,126,3,255,129,255,192
          DC.B      255,136,255,28,126,8,60,0,0

          DC.W      0,0,0,0,0,0,0,0,0,0

          DC.W      0,248,196,162,159,145,81,49,31,0

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      255,255,255,255,126,126,60,60,0,0

          DC.B      24,8,60,48,126,0,255,3,255,12,255
          DC.B      48,255,192,255,0,255,3,255,12

          DC.B      24,0,60,12,126,48,255,192,255,0,255
          DC.B      3,255,12,255,48,255,192,255,0

          DC.B      24,0,60,0,126,12,255,48,255,192,255
          DC.B      0,255,3,255,12,255,48,255,192

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      253,253,231,231,66,66,0,0,0,0

          DC.B      0,0,66,66,231,231,191,191,255,255
          DC.B      255,255,126,126,60,60,0,0,0,0


SPR3      DC.B      0,0,62,62,119,119,254,254,252,252
          DC.B      252,252,254,254,127,127,62,62,0,0

          DC.B      0,0,124,124,238,238,127,127,63,63
          DC.B      63,63,127,127,254,254,124,124,0,0

          DC.B      170,170,85,85,170,170,85,85
          DC.B      170,170,85,85,170,170,85,85,170,170,85,85

          DC.W      170,85,170,85,170,85,170,85,170,85

          DC.W      0,0,0,0,0,0,0,0,0,0

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      255,255,255,255,126,126,60,60,0,0

          DC.B      0,0,0,0,12,0,16,0,16,0,56,0,228,0
          DC.B      250,0,254,0,124,0

          DC.B      0,0,1,1,12,0,16,0,16,0,56,0,228,0
          DC.B      250,0,254,0,124,0

          DC.B      0,0,1,1,12,0,17,1,16,0,56,0,228,0
          DC.B      250,0,254,0,124,0

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      253,253,231,231,66,66,0,0,0,0

          DC.B      0,0,66,66,231,231,191,191,255,255
          DC.B      255,255,126,126,60,60,0,0,0,0


SPR4      DC.B      0,0,62,62,119,119,254,254,252,252
          DC.B      252,252,254,254,127,127,62,62,0,0

          DC.B      0,0,124,124,238,238,127,127,63,63
          DC.B      63,63,127,127,254,254,124,124,0,0

          DC.W      0,0,0,0,0,0,0,0,0,0

          DC.W      0,0,0,24,60,126,60,24,0,0

          DC.B      0,0,0,0,0,0,60,60,60,60,60,60,60,60,0,0,0,0,0,0

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      255,255,255,255,126,126,60,60,0,0

          DC.B      224,0,156,0,131,0,141,0,225,0,129,0
          DC.B      131,0,156,0,224,0,0,0

          DC.B      24,0,36,0,36,0,66,0,66,0,66,0,255,0
          DC.B      129,0,129,0,255,0

          DC.B      7,0,57,0,193,0,185,0,135,0,129,0
          DC.B      193,0,57,0,7,0,0,0

          DC.B      0,0,60,60,126,126,255,255,255,255
          DC.B      253,253,231,231,66,66,0,0,0,0

          DC.B      0,0,66,66,231,231,191,191,255,255
          DC.B      255,255,126,126,60,60,0,0,0,0


MAZE      DC.B      15,5                A : B COORDS

          DC.B      1,1                 GHOST COORDS
          DC.B      1,7
          DC.B      30,1
          DC.B      30,7
          DC.L      0

          DC.B      '********************************'
          DC.B      '*//////////////////////////////*'
          DC.B      '*/*/***/*/**/*/**/*/**/*/***/*/*'
          DC.B      '*/*/////*//////////////*/////*/*'
          DC.B      '*///***///**/*/**/*/**///***///*'
          DC.B      '*/*/////*//////////////*/////*/*'
          DC.B      '*/*/***/*/**/*/**/*/**/*/***/*/*'
          DC.B      '*//////////////////////////////*'
          DC.B      '********************************'
          DC.B      -1,0


MAZE2     DC.B      2,1

          DC.B      29,1
          DC.B      29,7
          DC.B      2,7
          DC.B      10,7
          DC.L      0

          DC.B      '  ****************************  '
          DC.B      ' */ / / / / / / / / / / / / / * '
          DC.B      '*/ / * / / / /**** / / / /*/ / *'
          DC.B      '* / /*/ /***/ / / / *** / * / /*'
          DC.B      '*/ / * / / / /**** / / / /*/ / *'
          DC.B      '* / /*/ /***/ / / / *** / * / /*'
          DC.B      '*/ / * / / / /**** / / / /*/ / *'
          DC.B      ' */ / / / / / / / / / / / / / * '
          DC.B      '  ****************************  '
          DC.B      -1,0


MAZE3     DC.B      18,2

          DC.B      30,1
          DC.B      1,1
          DC.B      30,7
          DC.B      1,7
          DC.L      0


          DC.B      '********************************'
          DC.B      '*////////////////****//////////*'
          DC.B      '*/**********/*////////*/******/*'
          DC.B      '*/*////////////****//////////*/*'
          DC.B      '*/*/******/*//****//*/******/*/*'
          DC.B      '*/*//////////****////////////*/*'
          DC.B      '*/******/*////////*/**********/*'
          DC.B      '*//////////****////////////////*'
          DC.B      '********************************'
          DC.B      -1,0


MAZE4     DC.B      17,4

          DC.B      1,1
          DC.B      1,7
          DC.B      29,3
          DC.B      29,5
          DC.L      0

          DC.B      '********************************'
          DC.B      '*//////////////////////////////*'
          DC.B      '*/*/*/*/*/**/*/****/**********/*'
          DC.B      '*/*/*/*/*////*/////////////////*'
          DC.B      '*/*/*/*/*/*******/************/*'
          DC.B      '*/*/*/*/*////*/////////////////*'
          DC.B      '*/*/*/*/*/**/*/****/**********/*'
          DC.B      '*//////////////////////////////*'
          DC.B      '********************************'
          DC.B      -1,0



BOARD     DC.W      45
          DC.B      'LIVES :       HI-SCORE :              SCORE :'

          END

