* I have joined all files on this folder to this file, to be able to load the entire disassembly of the rom with ZEsarUX remote command: load-source-code 


****************************
*
* start of arithmetic packagebe careful with changes - in this part
* the relativ labels are not calculated best: don't make changes
*
***************************

L04196 MOVE.L  A6,-(A7)
       SUBA.L  A6,A6
       BSR.S   L041AC   * RI.EXEC
       BRA.S   L041A4

L0419E MOVE.L  A6,-(A7)
       SUBA.L  A6,A6
       BSR.S   L041B4
L041A4 BEQ.S   L041A8
       MOVEQ   #0,D2
L041A8 MOVEA.L (A7)+,A6
       RTS

L041AC MOVEM.L D1-D3/A0/A2-A3/A5,-(A7)   * RI.EXEC
       SUBA.L  A5,A5
       BRA.S   L041C0

L041B4 MOVEM.L D1-D3/A0/A2-A3/A5,-(A7)   * RI.EXECB
       MOVEA.L A3,A5
L041BA MOVEQ   #0,D0
       MOVE.B  (A5)+,D0
       BEQ.S   L041F8
L041C0 CMPI.B  #$30,D0
       BHI.S   L041CC      * ->variable
       BSR.S   L041FE      * ->opcode
       BNE.S   L041F8
       BRA.S   L041BA

L041CC ORI.W   #$FF00,D0
       BCLR    #0,D0
       ADDA.W  D0,A4
       BNE.S   L041DE
       SUBQ.W  #6,A1
       BSR.S   L041EA
       BRA.S   L041E6

L041DE EXG     A1,A4
       BSR.S   L041EA
       EXG     A4,A1
       ADDQ.W  #6,A1
L041E6 SUBA.W  D0,A4
       BRA.S   L041BA

L041EA MOVE.W  $00(A6,A4.L),$00(A6,A1.L)
       MOVE.L  $02(A6,A4.L),$02(A6,A1.L)
       RTS

L041F8 MOVEM.L (A7)+,D1-D3/A0/A2-A3/A5
       RTS

* select on opcode
L041FE MOVE.W  L04206-$02(PC,D0.W),D0
       JMP     L04206(PC,D0.W)
       
L04206 DC.W    L04796-L04206        * RI.NINT
       DC.W    L0479A-L04206        * RI.INT
       DC.W    L047A6-L04206        * RI.NLINT
       DC.W    L047B8-L04206        * RI.FLOAT
       DC.W    L04838-L04206        * RI.ADD
       DC.W    L0482A-L04206        * RI.SUB
       DC.W    L048DE-L04206        * RI.MULT
       DC.W    L0497E-L04206        * RI.DIV
       DC.W    L04A06-L04206        * RI.ABS
       DC.W    L04A0C-L04206        * RI.NEG
       DC.W    L04A4A-L04206        * RI.DUP
       DC.W    L0423E-L04206        * RI.COS
       DC.W    L04236-L04206        * RI.SIN
       DC.W    L04262-L04206        * RI.TAN
       DC.W    L0426A-L04206        * RI.COT
       DC.W    L042F2-L04206        * RI.ASIN
       DC.W    L042E4-L04206        * RI.ACOS
       DC.W    L04326-L04206        * RI.ATAN
       DC.W    L0431E-L04206        * RI.ACOT
       DC.W    L0452C-L04206        * RI.SQRT
       DC.W    L04446-L04206        * RI.LN
       DC.W    L0442C-L04206        * RI.LOG10
       DC.W    L044DE-L04206        * RI.EXP
       DC.W    L043C2-L04206        * RI.POWFP
       
L04236 MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #0,D7
       BRA.S   L04248
       
L0423E MOVEM.L D4-D7/A4,-(A7)
       JSR     L04A06(PC)
       MOVEQ   #-1,D7
L04248 JSR     L04684(PC)
       BNE.S   L042B0
       BSR.S   L042B6
       LEA     L045AE(PC),A4
       BSR.S   L042C6
       BTST    #0,D7
       BEQ.S   L042B0
       JSR     L04A0C(PC)
       BRA.S   L042B0

L04262 MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #0,D6
       BRA.S   L04274

L0426A MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #-$01,D6
       JSR     L04A0C(PC)
L04274 MOVEQ   #0,D7
       JSR     L04674(PC)
       BNE.S   L042B0
       EOR.B   D6,D7
       BSR.S   L042B6
       LEA     L045D6(PC),A4
       JSR     L04726(PC)
       ADDQ.W  #6,A1
       BSR.S   L042CA
       SUBQ.W  #6,A1
       MOVE.L  -$0A(A6,A1.L),$02(A6,A1.L)
       MOVE.W  -$0C(A6,A1.L),$00(A6,A1.L)
       BTST    #0,D7
       BEQ.S   L042AA
       JSR     L04A5C(PC)
       JSR     L04A0C       * !!! could be relativ !!!
L042AA JSR     L0497E(PC)
L042AE MOVEQ   #0,D0
L042B0 MOVEM.L (A7)+,D4-D7/A4
       RTS

L042B6 JSR     L04A4A(PC)
L042BA JSR     L04A4A(PC)
       JSR     L04A4A(PC)
       JMP     L048DE(PC)

L042C6 JSR     L0472C(PC)
L042CA JSR     L048DE(PC)
       JMP     L04838(PC)

L042D2 SUBQ.W  #6,A1
       CLR.W   $04(A6,A1.L)
       MOVE.L  #$08014000,$00(A6,A1.L)
       JMP     L04A5C(PC)

L042E4 JSR     L04A0C(PC)
       BSR.S   L042F2
       BNE.S   L0431C
       BSR.S   L0430C
       JMP     L04838(PC)

L042F2 BSR.S   L042BA
       BSR.S   L042D2
       JSR     L0482A(PC)
       BSR     L0452C
       BNE.S   L0431C
       JSR     L0497E(PC)
       BEQ.S   L04326
       BSR.S   L0430C
       JMP     L048DE(PC)

L0430C SUBQ.W  #6,A1
       MOVE.L  #$6487ED51,$02(A6,A1.L)
       MOVE.W  #$0801,$00(A6,A1.L)
L0431C RTS

L0431E MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #$02,D7
       BRA.S   L0432C

L04326 MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #0,D7
L0432C TST.B   $02(A6,A1.L)
       BGE.S   L04338
       ADDQ.B  #4,D7
       JSR     L04A0C(PC)
L04338 CMPI.W  #$0800,$00(A6,A1.L)
       BLE.S   L0434A
       BSR.S   L042D2
       JSR     L0497E(PC)
       BCHG    #1,D7
L0434A JSR     L04A4A(PC)
       SUBQ.W  #6,A1
       MOVE.L  #$4498517A,$02(A6,A1.W)
       MOVE.W  #$07FF,$00(A6,A1.L)
       JSR     L0482A(PC)
       ADDQ.W  #6,A1
       TST.B   -$04(A6,A1.L)
       BLE.S   L04378
       LEA     L045F2(PC),A4
       JSR     L04726(PC)
       JSR     L0497E(PC)
       ADDQ.B  #1,D7
L04378 BSR     L042B6
       LEA     L0461A(PC),A4
       JSR     L04726(PC)
       JSR     L0497E(PC)
       BSR     L042CA
       LSR.B   #1,D7
       BCC.S   L043A4
       SUBQ.W  #6,A1
       MOVE.L  #$430548E1,$02(A6,A1.L)
       MOVE.W  #$0800,$00(A6,A1.L)
       JSR     L04838(PC)
L043A4 LSR.B   #1,D7
       BCC.S   L043B4
       JSR     L04A0C(PC)
       BSR     L0430C
       JSR     L04838(PC)
L043B4 LSR.B   #1,D7
       BCC     L042AE
       JSR     L04A0C(PC)
       BRA     L042B0

L043C2 MOVE.W  $00(A6,A1.L),D1
       BEQ.S   L043E6
       MOVE.W  #$080F,D0
       SUB.W   D1,D0
       BLT.S   L043F0
       CMPI.W  #$F,D0
       BGT.S   L043F0
       MOVE.L  $02(A6,A1.L),D1
       TST.W   D1
       BNE.S   L043F0
       ASR.L   D0,D1
       TST.W   D1
       BNE.S   L043F0
       SWAP    D1
L043E6 ADDQ.W  #4,A1
       MOVE.W  D1,$00(A6,A1.L)
       JMP     L047DC(PC)

L043F0 MOVEM.L D4-D7/A4,-(A7)
       MOVE.W  $00(A6,A1.L),D4
       MOVE.L  $02(A6,A1.L),D5
       ADDQ.W  #6,A1
       TST.B   $02(A6,A1.L)
       BEQ.S   L04420
       BSR.S   L04446
       BNE     L042B0
       SUBQ.W  #6,A1
       MOVE.L  D5,$02(A6,A1.L)
       MOVE.W  D4,$00(A6,A1.L)
       JSR     L048DE(PC)
       BNE     L042B0
       BRA     L044E4

L04420 TST.B   -$04(A6,A1.L)
       BGE     L042AE
       BRA     L044D8

L0442C BSR.S   L04446
       BNE.S   L04444
       SUBQ.W  #6,A1
       MOVE.L  #$6F2DEC55,$02(A6,A1.L)
       MOVE.W  #$07FF,$00(A6,A1.L)
       JSR     L048DE(PC)
L04444 RTS

L04446 MOVEM.L D4-D7/A4,-(A7)
       MOVE.W  $00(A6,A1.L),D4
       MOVE.L  $02(A6,A1.L),D5
       ADDQ.W  #6,A1
       BLE     L044D8
       MOVE.W  #$0800,D0
       MOVE.L  D5,D1
       LSR.L   #1,D5
       CMPI.L  #$5A82799A,D1
       BGT.S   L04476
       SUBQ.W  #1,D4
       ADDI.L  #$20000000,D5
       BCLR    #$1E,D1
       BRA.S   L0447E
L04476 BSET    #$1E,D5
       BSET    #$1F,D1
L0447E TST.L   D1
       JSR     L04830(PC)
       SUBQ.W  #6,A1
       MOVE.L  D5,$02(A6,A1.L)
       MOVE.W  #$800,$00(A6,A1.L)
       JSR     L0497E(PC)
       BSR     L042B6
       JSR     L04A4A(PC)
       LEA     L04636(PC),A4
       MOVE.W  D4,D7
       JSR     L04726(PC)
       JSR     L0497E(PC)
       JSR     L048DE(PC)
       BSR     L042CA
       SUBI.W  #$0800,D7
       SUBQ.W  #2,A1
       MOVE.W  D7,$00(A6,A1.L)
       JSR     L047B8(PC)
       SUBQ.W  #6,A1
       MOVE.L  #$58B90BFC,$02(A6,A1.L)
       MOVE.W  #$800,$00(A6,A1.L)
       BSR     L042CA
       BRA     L042AE

L044D8 MOVEQ   #-$12,D0
L044DA BRA     L042B0

L044DE MOVEM.L D4-D7/A4,-(A7)
       MOVEQ   #0,D7
L044E4 JSR     L04692(PC)
       BNE.S   L044DA
       BSR     L042BA
       LEA     L04658(PC),A4
       JSR     L04726(PC)
       ADDQ.W  #6,A1
       JSR     L048DE(PC)
       JSR     L04A4A(PC)
       SUBQ.W  #6,A1
       JSR     L04A5C(PC)
       JSR     L0482A(PC)
       JSR     L0497E(PC)
       SUBQ.W  #6,A1
       MOVE.L  #$40000000,$02(A6,A1.L)
       MOVE.W  #$0800,$00(A6,A1.L)
       JSR     L04838(PC)
       ADDQ.W  #1,D7
       ADD.W   D7,$00(A6,A1.L)
       BRA     L042AE

L0452C MOVEM.L D4-D7/A4,-(A7)
       MOVE.W  $00(A6,A1.L),D6
       TST.L   $02(A6,A1.L)
       BEQ     L042AE
       BLT.S   L044D8
       LEA     L04666(PC),A4
       MOVE.W  D6,D7
       SUBI.W  #$0800,D7
       SUB.W   D7,$00(A6,A1.L)
       ASR.W   #1,D7
       BCC.S   L04554
       LEA     L04674(PC),A4
L04554 SWAP    D6
       JSR     L0472C(PC)
       SWAP    D6
       ADD.W   D7,$00(A6,A1.L)
       MOVEQ   #1,D7
L04562 JSR     L04A4A(PC)
       SUBQ.W  #6,A1
       MOVE.L  D5,$02(A6,A1.L)
       MOVE.W  D6,$00(A6,A1.L)
       JSR     L04A5C(PC)
       JSR     L0497E(PC)
       JSR     L04838(PC)
       SUBQ.W  #1,$00(A6,A1.L)
       DBF     D7,L04562
L04584 BRA     L042AE
* LABEL WAS SET WRONG !!! CORRECTED

L04588 DC.W    $0000
       DC.W    $0000  * list of parameters for floating nrs
       DC.W    $0000
       DC.W    $07FE
       DC.W    $AAAA
       DC.W    $AAB0
       DC.W    $07FA
       DC.W    $4444
       DC.W    $42DD
       DC.W    $07F4
       DC.W    $97FA
       DC.W    $15C1
       DC.W    $07EE
       DC.W    $5C5A
       DC.W    $E940
       DC.W    $07E7
       DC.W    $997C
       DC.W    $79C0
       DC.W    $0005
L045AE DC.W    $0801
       DC.W    $4000
       DC.W    $0000
       DC.W    $07FF
       DC.W    $8E28
       DC.W    $7BC1
       DC.W    $07FB
       DC.W    $416D
       DC.W    $50CD
       DC.W    $0002
       DC.W    $0000
       DC.W    $0000
       DC.W    $0000
       DC.W    $07FD
       DC.W    $8DF7
       DC.W    $443E
       DC.W    $07F7
       DC.W    $4676
       DC.W    $1A70
       DC.W    $0002
L045D6 DC.W    $0801
       DC.W    $6ED9
       DC.W    $EBA1
       DC.W    $0801
       DC.W    $4000
       DC.W    $0000
       DC.W    $0001
       DC.W    $0800
       DC.W    $8000
       DC.W    $0000
       DC.W    $0801
       DC.W    $6ED9
       DC.W    $EBA1
       DC.W    $0001
L045F2 DC.W    $0803
L045F4 DC.W    $451F
       DC.W    $BEDF
       DC.W    $0803
       DC.W    $4C09
       DC.W    $1DF8
       DC.W    $0801
       DC.W    $4000
       DC.W    $0000
       DC.W    $0002
       DC.W    $0000
       DC.W    $0000
       DC.W    $0000
       DC.W    $0801
       DC.W    $A3D5
       DC.W    $AC3B
       DC.W    $0800
       DC.W    $A3D6
       DC.W    $2904
       DC.W    $0002
L0461A DC.W    $0803
       DC.W    $A6BC
       DC.W    $EEE1
       DC.W    $0801
       DC.W    $4000
       DC.W    $0000
       DC.W    $0001
       DC.W    $07FF
       DC.W    $88FB
       DC.W    $E7C1
       DC.W    $07FA
L04630 DC.W    $6F6B
       DC.W    $44F3
       DC.W    $0001
L04636 DC.W    $0800
       DC.W    $4000
       DC.W    $0000
       DC.W    $07FC
       DC.W    $6DB4
       DC.W    $CE83
       DC.W    $07F5
L04644 DC.W    $4DEF
       DC.W    $09CA
       DC.W    $0002
       DC.W    $07FF
       DC.W    $4000
       DC.W    $0000
       DC.W    $07F9
       DC.W    $617D
       DC.W    $E4BA
       DC.W    $0001
L04658 DC.W    $07FF
       DC.W    $6AD4
       DC.W    $D402
       DC.W    $0800
       DC.W    $4B8A
       DC.W    $5CE6
       DC.W    $0001
L04666 DC.W    $0800
       DC.W    $4B8A
       DC.W    $5CE6
       DC.W    $0800
       DC.W    $6AD4
       DC.W    $D402
       DC.W    $0001

L04674 ADDQ.W  #1,$00(A6,A1.L)
       BSR.S   L04684
       BNE.S   L046EE
       SUBQ.W  #1,$00(A6,A1.L)
       MOVEQ   #0,D0
       RTS

L04684 LEA     L04714(PC),A4
       CMPI.W  #$0810,$00(A6,A1.L)
       BGT.S   L046EC
       BRA.S   L0469E

L04692 LEA     L04726(PC),A4
       CMPI.W  #$0809,$00(A6,A1.L)
       BGT.S   L046EC
L0469E JSR     L04A4A(PC)
       SUBQ.W  #6,A1
       MOVE.L  -(A4),$02(A6,A1.L)
       MOVE.W  -(A4),$00(A6,A1.L)
       JSR     L048DE(PC)
       TST.B   D7
       BNE.S   L046C0
       JSR     L04796(PC)
       MOVE.W  D1,D7
       JSR     L047B8(PC)
       BRA.S   L046D6

L046C0 JSR     L0479A(PC)
       ADD.W   D1,D7
       ADD.W   D1,$00(A6,A1.L)
       ADDQ.W  #1,$00(A6,A1.L)
       JSR     L047B8(PC)
       SUBQ.W  #1,$00(A6,A1.L)
L046D6 MOVE.W  $00(A6,A1.L),D4
       MOVE.L  $02(A6,A1.L),D5
       BSR.S   L046F0
       SUBQ.W  #6,A1
       MOVE.L  D5,$02(A6,A1.L)
       MOVE.W  D4,$00(A6,A1.L)
       BRA.S   L046F0

L046EC MOVEQ   #-$12,D0
L046EE RTS

L046F0 SUBQ.W  #6,A1
       MOVE.L  -(A4),$02(A6,A1.L)
       MOVE.W  -(A4),$00(A6,A1.L)
       JSR     L048DE(PC)
       JMP     L0482A(PC)

L04702 DC.W    $07F0
       DC.W    $B544  * trigonometric params
       DC.W    $42D1
       DC.W    $0802
       DC.W    $6488
       DC.W    $0000
       DC.W    $07FF
       DC.W    $517C
       DC.W    $C1B7
L04714 DC.W    $07F4
       DC.W    $90BF
       DC.W    $BE8F
       DC.W    $0800
       DC.W    $58C0
       DC.W    $0000
       DC.W    $0801
       DC.W    $5C55
L04724 DC.W    $1D95
       
       
L04726 BSR.S   L0472C       
       SUBQ.W  #6,A1
       BRA.S   L04734

L0472C MOVE.W  $00(A6,A1.L),D4
       MOVE.L  $02(A6,A1.L),D5
L04734 MOVE.W  -(A4),D6
       MOVE.L  -(A4),$02(A6,A1.L)
       MOVE.W  -(A4),$00(A6,A1.L)
L0473E SUBQ.W  #6,A1
       MOVE.L  D5,$02(A6,A1.L)
       MOVE.W  D4,$00(A6,A1.L)
       JSR     L048DE(PC)
       SUBQ.W  #6,A1
       MOVE.L  -(A4),$02(A6,A1.L)
       MOVE.W  -(A4),$00(A6,A1.L)
       JSR     L04838(PC)
       SUBQ.W  #1,D6
       BGT.S   L0473E
       RTS

L04760 SUBQ.W  #6,A1
       CLR.W   $04(A6,A1.L)
       MOVE.L  #$08004000,$00(A6,A1.L)
       JSR     L04838(PC)
L04772 MOVE.W  $00(A6,A1.L),D0
       MOVE.L  $02(A6,A1.L),D1
       ADDQ.W  #2,A1
       CLR.L   $00(A6,A1.L)
       SUBI.W  #$0800,D0
       BGE.S   L04788
       MOVEQ   #0,D0
L04788 SUBI.W  #$1F,D0
       NEG.W   D0
       ASR.L   D0,D1
       MOVE.L  D1,$00(A6,A1.L)
       RTS

L04796 BSR.S   L04760
       BRA.S   L0479C

L0479A BSR.S   L04772
L0479C ADDQ.L  #2,A1
       CMPI.W  #$10,D0
       BLT.S   L047B4
       BRA.S   L047B0

L047A6 BSR.S   L04760
       BRA.S   L047AC

L047AA BSR.S   L04772
L047AC TST.W   D0
       BLT.S   L047B4
L047B0 MOVEQ   #0,D0
       RTS

L047B4 MOVEQ   #-$12,D0
       RTS

L047B8 MOVE.W  #$081F,D0
       MOVE.W  $00(A6,A1.L),D1
       ADDQ.W  #2,A1
       EXT.L   D1
       JMP     L04830(PC)

L047C8 SUBQ.W  #6,A1
       CLR.W   $04(A6,A1.L)
       MOVE.L  #$08014000,$00(A6,A1.L)
       JSR     L04A5C(PC)
       RTS

L047DC MOVEM.L D4-D6,-(A7)
       MOVE.W  $00(A6,A1.L),D6
       ADDQ.W  #2,A1
       BGE.S   L047F2
       NEG.W   D6
       BSR.S   L047C8
       JSR     L0497E(PC)
       BNE.S   L04824
L047F2 BSR.S   L047C8
L047F4 LSR.W   #1,D6
       BCC.S   L04810
       MOVE.W  $00(A6,A1.L),D5
       MOVE.L  $02(A6,A1.L),D4
       JSR     L048DE(PC)
       SUBQ.W  #6,A1
       BNE.S   L04822
       MOVE.L  D4,$02(A6,A1.L)
       MOVE.W  D5,$00(A6,A1.L)
L04810 TST.W   D6
       BEQ.S   L04820
       JSR     L04A4A(PC)
       JSR     L048DE(PC)
       BNE.S   L04822
       BRA.S   L047F4

L04820 MOVEQ   #0,D0
L04822 ADDQ.W  #6,A1
L04824 MOVEM.L (A7)+,D4-D6
       RTS

* substraction of two floating point numbers

L0482A JSR     L04A0C(PC)
       BRA.S   L04838

L04830 SUBQ.W  #6,A1
       MOVEQ   #0,D2
       TST.L   D1
       BRA.S   L04870

* addition of two floating point numbers

L04838 ADDQ.W  #6,A1
       MOVE.W  $00(A6,A1.L),D0
       SUB.W   -$06(A6,A1.L),D0         * compare exponents
       BGE.S   L0485C
       NEG.W   D0
       CMPI.W  #$0020,D0                * > 32 bits?
       BGE.S   L048AE
       MOVE.L  $02(A6,A1.L),D1
       BSR.S   L048C2                   * adjust mantisssa
       MOVE.W  -$06(A6,A1.L),D0
       ADD.L   -$04(A6,A1.L),D1         *  add it
       BRA.S   L04870

L0485C CMPI.W  #$20,D0
       BGE.S   L048BE
       MOVE.L  -$04(A6,A1.L),D1
       BSR.S   L048C2
       MOVE.W  $00(A6,A1.L),D0
       ADD.L   $02(A6,A1.L),D1
L04870 BVS.S   L04898                   *
       BEQ.S   L048AA
       MOVE.L  D1,D3
       ADD.L   D3,D3
       BVS.S   L048B6
       SUB.L   D2,D3
       BVC.S   L04880
       ADD.L   D2,D3
L04880 SUBQ.W  #1,D0
       MOVE.L  D3,D1
       MOVEQ   #$10,D2
L04886 MOVE.L  D1,D3
       ASL.L   D2,D3
       BVS.S   L04892
       MOVE.L  D3,D1
       SUB.W   D2,D0
       BLT.S   L048A6
L04892 ASR.L   #1,D2
       BNE.S   L04886
       BRA.S   L048B6

L04898 ROXR.L  #1,D1
       ADDQ.W  #1,D0
       BTST    #$0C,D0
       BEQ.S   L048B6
       MOVEQ   #-$12,D0
       RTS

L048A6 NEG.W   D0
       ASR.L   D0,D1
L048AA CLR.W   D0
       BRA.S   L048B6

L048AE MOVE.W  -$06(A6,A1.L),D0
       MOVE.L  -$04(A6,A1.L),D1
L048B6 MOVE.L  D1,$02(A6,A1.L)
       MOVE.W  D0,$00(A6,A1.L)
L048BE MOVEQ   #0,D0
       RTS

L048C2 MOVEQ   #0,D2
       TST.W   D0
       BEQ.S   L048DC
       ASR.L   D0,D1
       BCC.S   L048DC
       ADDQ.L  #1,D1
       MOVEQ   #$01,D2
       SUBQ.W  #1,D0
       BGT.S   L048DC
       BCLR    #0,D1
       BEQ.S   L048DC
       MOVEQ   #-$01,D2
L048DC RTS

* multiplication of two floating point numbers

L048DE MOVEM.L D4-D6,-(A7)
       SF      D5
       SF      D6
       MOVE.L  $02(A6,A1.L),D3
       BGE.S   L048F4
       JSR     L04A0C(PC)
       MOVE.L  D1,D3
       ST      D6
L048F4 ADDQ.W  #6,A1
       MOVE.L  $02(A6,A1.L),D1
       BGT.S   L04904
       BEQ.S   L0496A
       JSR     L04A0C(PC)
       ST      D5
L04904 LSL.L   #1,D1
       MOVE.L  D1,D0
       SWAP    D0
       LSL.L   #1,D3
L0490C MOVE.L  D3,D2   * label-adressed (Label 13A)
       SWAP    D2
       MOVE.W  D3,D4
       MULU    D1,D4
       CLR.W   D4
       SWAP    D4
       MULU    D0,D3
       MULU    D2,D1
       ADD.L   D4,D3
       ADD.L   D3,D1
       MOVE.W  D1,D4
       CLR.W   D1
       SWAP    D1
       ROXR.W  #1,D1
       ROXL.L  #1,D1
       MULU    D0,D2
       MOVE.W  $00(A6,A1.L),D0
       ADD.W   -$06(A6,A1.L),D0
       SUBI.W  #$0800,D0
       BLT.S   L04956
       ADD.L   D2,D1
       BMI.S   L04948
       BEQ.S   L04956
       SUBQ.W  #1,D0
       BLT.S   L04956
       ASL.W   #1,D4
       BRA.S   L0494A

L04948 LSR.L   #1,D1
L0494A MOVEQ   #0,D4
       ADDX.L  D4,D1
       BPL.S   L0495A
       LSR.L   #1,D1
       ADDQ.W  #1,D0
       BRA.S   L0495A

L04956 CLR.W   D0
       CLR.L   D1
L0495A MOVE.L  D1,$02(A6,A1.L)
       MOVE.W  D0,$00(A6,A1.L)
       CMP.B   D5,D6
       BEQ.S   L0496A
       JSR     L04A0C(PC)
L0496A MOVEM.L (A7)+,D4-D6
       BTST    #$04,$00(A6,A1.L)
       BNE.S   L0497A
       MOVEQ   #0,D0
       RTS

L0497A MOVEQ   #-$12,D0
       RTS


* division of two floating-point numbers

L0497E MOVE.L  D4,-(A7)
       MOVE.L  D5,-(A7)
       SF      D5
       MOVE.L  $02(A6,A1.L),D2      * mantisa1
       BGT.S   L04994
       BEQ.S   L04A00
       JSR     L04A0C(PC)
       MOVE.L  D1,D2
       ST      D5
L04994 ADDQ.W  #6,A1
       MOVE.L  $02(A6,A1.L),D1      * mantisa2
       BGT.S   L049A4
       BEQ.S   L049F6
       JSR     L04A0C(PC)
       NOT.B   D5
L049A4 MOVE.W  $00(A6,A1.L),D0      * exp2
       ADDI.W  #$0800,D0
       SUB.W   -$06(A6,A1.L),D0     *      - exp1
       BGE.S   L049B8
       CLR.W   D0
       CLR.L   D3
       BRA.S   L049E6

L049B8 BTST    #$0C,D0              * exp overflow ?
       BNE.S   L04A02
       MOVEQ   #$1F,D4              * for 32 bits
       MOVEQ   #0,D3                * result

* compute D1/D2
L049C2 SUB.L   D2,D1                * fits D2 into D1?
       BCS.S   L049CA               * no, too much subtracted
       BSET    D4,D3
       BRA.S   L049CC
L049CA ADD.L   D2,D1
L049CC ADD.L   D1,D1                * next bit
       DBEQ    D4,L049C2

       TST.L   D3
       BLT.S   L049DE
       SUB.L   D1,D2
       BHI.S   L049E6
       ADDQ.L  #1,D3
       BVC.S   L049E6
L049DE ADDQ.W  #1,D0
       LSR.L   #1,D3
       MOVEQ   #0,D1
       ADDX.L  D1,D3
L049E6 MOVE.L  D3,$02(A6,A1.L)
       MOVE.W  D0,$00(A6,A1.L)
       TST.B   D5
       BEQ.S   L049F6
       JSR     L04A0C(PC)
L049F6 MOVEQ   #0,D0
L049F8 MOVE.L  (A7)+,D5
       MOVE.L  (A7)+,D4
       TST.L   D0
       RTS

L04A00 ADDQ.W  #6,A1
L04A02 MOVEQ   #-$12,D0
       BRA.S   L049F8

L04A06 TST.B   $02(A6,A1.L)
       BGE.S   L04A46
L04A0C MOVE.L  $02(A6,A1.L),D1
       NEG.L   D1
       BVS.S   L04A2C
       CMPI.L  #$C0000000,D1
       BNE.S   L04A42
       LSL.L   #1,D1
       SUBQ.W  #1,$00(A6,A1.L)
       BGE.S   L04A42
       ASR.L   #1,D1
       CLR.W   $00(A6,A1.L)
       BRA.S   L04A42

L04A2C LSR.L   #1,D1
       ADDQ.W  #1,$00(A6,A1.L)
       BTST    #$04,$00(A6,A1.L)
       BEQ.S   L04A42
       SUBQ.W  #1,$00(A6,A1.L)
       MOVEQ   #-$01,D1
       LSR.L   #1,D1
L04A42 MOVE.L  D1,$02(A6,A1.L)
L04A46 MOVEQ   #0,D0
       RTS

L04A4A SUBQ.W  #6,A1
L04A4C MOVE.W  $06(A6,A1.L),$00(A6,A1.L)
       MOVE.L  $08(A6,A1.L),$02(A6,A1.L)
       MOVEQ   #0,D0
       RTS

L04A5C MOVE.W  $00(A6,A1.L),D2
       MOVE.L  $02(A6,A1.L),D1
       JSR     L04A4C(PC)
       MOVE.W  D2,$06(A6,A1.L)
       MOVE.L  D1,$08(A6,A1.L)
       MOVEQ   #0,D0
o4A72  RTS

**** end of arithmetic package  ****


*******************************
*
*  BASIC1_ASM basic1_asm
*
*******************************

* initialise basic, search for ROMS, display F1/F2 menu
L04A74 BRA.S   L04AAA 
XL04A74 EQU L04A74
L04A76 CMPI.L  #$4AFB0001,(A3)
       BNE.S   L04A9E
       LEA     $0008(A3),A1  * number of commands
       JSR     L039B2(PC)    * link in name table
       MOVE.W  $0004(A3),D0  * number of functions
       BEQ.S   L04A94
       LEA     $00(A3,D0.W),A1  * list of functions
       JSR     L06DA6(PC)
L04A94 MOVE.W  $0006(A3),D0     * initialisation routine
       BEQ.S   L04A9E           * no routine supplied
       JSR     $00(A3,D0.W)     * init routine
L04A9E RTS

L04AA0 JSR     L039F6(PC)       * install window
       MOVE.L  D4,D1            * D1 = #
       JMP     L06646(PC)

* basic init
L04AAA JSR     L0566E(PC)
       JSR     L06DA2(PC)
       LEA     L04BBA(PC),A1    * window def
       MOVEQ   #$00,D4
       BSR.S   L04AA0           * init window 0
       LEA     $0C000,A3        * ROM EXTENSION
       BSR.S   L04A76           * try to initialise extension
       MOVEA.L #$C0000,A3        * EXTENSIONS at C0000 ff 
L04AC8 BSR.S   L04A76           * SAME AS BEFORE
       ADDA.W  #$4000,A3        * add 16 K
       CMPA.L  #$CC000,A3       * till end of RAM

*
* !!! to avoid software - problems caused by bad decoding of ROM-port
* hardware: - modification of ROM-Port 
*           - or make sure to have no expansion at CC000
* software: - omit the first test for C000 (is done when testing CC000)
*           - or set top to $CC000 instead of $100000
*         !!!! (t h a t ' s     w h a t    I  d i d   h e r e !)

       BLT.S   L04AC8
       LEA     L04BC6(PC),A1    * WINDOW 1
       MOVEQ   #$01,D4
       BSR.S   L04AA0
       MOVEQ   #-$19,D0         * START-MESSAGE
       JSR     L03968(PC)
L04AE4 LEA     L04BD2(PC),A1    * WINDOW 2
       MOVEQ   #$02,D4
       BSR.S   L04AA0
       MOVEQ   #-$18,D0         * F1-MONI ETC
       JSR     L03968(PC)       * open START window
GETMOD MOVEQ   #$01,D0          * TRAP NR
       MOVEQ   #-$01,D3         * TIMEOUT
       TRAP    #$03             * NOW INKEY$
       MOVEQ   #$00,D6          * INIT MODE 4
       MOVEQ   #$00,D7
       MOVEQ   #$20,D5
       SUBI.B  #$E8,D1          * F1 ?
       BEQ.S   INIMON
       SUBQ.B  #$4,D1           * F2 ?
       BNE.S   GETMOD
       MOVEQ   #$00,D6
       MOVEQ   #$01,D7
       MOVEQ   #$44,D5          * d5=displacement for windows
INIMON MOVE.B  D6,D1
       MOVE.B  D7,D2
       MOVEQ   #$10,D0
       TRAP    #$01                     * SCREEN-INIT
       LEA     XL04B72-$08(PC,D5.W),A1       * #2 DEFI
       BSR.S   L04B6E
       MOVEA.L #$00010001,A0
       LEA     XL04B72-$14(PC,D5.W),A1       * #1 DEFI
       BSR.S   L04B6E
       SUBA.L  A0,A0
       LEA     XL04B72-$20(PC,D5.W),A1       * #0 DEFI
       BSR.S   L04B6E
       LEA     L04BDE(PC),A0            * boot-definiton
       BSR.S   L04B46                   * try to boot from any device
       BEQ.S   L04B40                   * success
       LEA     L04BE4(PC),A0            * try mdv1_boot
       BSR.S   L04B46
       BNE.S   L04B52                   * nothing
L04B40 CLR.W   $0088(A6)                * clear line-number
       BRA.S   L04B54

L04B46 MOVEQ   #$01,D0          * try to open boot
       MOVEQ   #-$01,D1
       MOVEQ   #$00,D3
       TRAP    #$02
       TST.L   D0
       RTS

L04B52 SUBA.L  A0,A0                * A0=0: no boot actioned
L04B54 MOVE.L  (A6),$0004(A6)
       MOVEQ   #$00,D7
       MOVEQ   #$7E,D1
       JSR     L04E6A(PC)
       MOVE.L  A0,$0084(A6)
       LEA     L04BF0(PC),A5
       MOVE.L  A5,-(A7)
L04B6A JMP     L04C04(PC)       * try to execute line or prog

L04B6E JMP     L03A02(PC)
L04B72
XL04B72 EQU L04B72
* Moni#0
       DC.B    $00,$00,$00,$04  * size border/size colour/paper/ink
       DC.B    $02,$00,$00,'2'  * width hight
       DC.B    $00,$00,$00,$CE  * origin horiz and verti
* Moni#1       
       DC.B    $FF,$01,$02,$07
       DC.B    $01,$00,$00,$CA
       DC.B    $01,$00,$00,$00
* Moni#2
       DC.B    $FF,$01,$02,$07
       DC.B    $01,$00,$00,$CA
       DC.B    $00,$00,$00,$00
* TV#0
       DC.B    $00,$00,$00,$07
       DC.B    $01,$C0,$00,'('
       DC.B    $00,' ',$00,$D8
*TV#1
       DC.B    $00,$00,$02,$07
       DC.B    $01,$C0,$00,$C8
       DC.B    $00,' ',$00,$10
* TV#2     
       DC.B    $00,$00,$01,$07
       DC.B    $01,$C0,$00,$C8
       DC.B    $00,' ',$00,$10
* init window
L04BBA DC.B    $00,$00,$00,$04
       DC.B    $01,$C0,$00,$AA
       DC.B    $00,' ',$00,' '
       
* copyright window
L04BC6 DC.B    $07,$02,$02,$07
       DC.B    $01,'p',$00,$0E
       DC.B    $00,'H',$00,$EE

* window for extensions message
L04BD2 DC.B    $04,$04,$07,$02
       DC.B    $00,$A8,$00,$1C
       DC.B    $00,$AE,$00,$CE

L04BDE DC.W    $0004
       DC.B    'BOOT'
L04BE4 DC.W    $0009
       DC.B    'MDV1_BOOT'
       DC.B    $00
       
L04BF0 JSR     L0A9BA(PC)       * SYSTEM COMMAND
       LEA     L04BF0(PC),A5    * 4BF0 - adrr fo errors
       MOVE.L  A5,-(A7)
L04BFA CLR.L   $0084(A6)
       MOVEQ   #$00,D1
       JSR     L0661E(PC)
L04C04 CLR.L   $0076(A6)
       MOVE.L  (A6),$0004(A6)
       TST.B   $00AA(A6)
       BEQ.S   L04C2C
       MOVE.W  $00AC(A6),D4
       MOVE.W  D4,D6
       SF      $00AB(A6)
       JSR     L07518(PC)
       MOVE.W  $00AE(A6),D0
       SNE     $00AA(A6)
       ADD.W   D0,$00AC(A6)
L04C2C MOVE.L  A0,D0
       JSR     L079C4(PC)
       BEQ.S   L04C64
       BGT.S   L04C3C
       CMPI.B  #$F6,D0
       BEQ.S   L04C50
L04C3C SF      $00AA(A6)
       JSR     L09B9C(PC)       * error-report
L04C44 BSR     L04CFA
       BEQ.S   L04C4E
       MOVEQ   #$02,D0
       TRAP    #$02
L04C4E BRA.S   L04BFA

L04C50 MOVEQ   #$02,D0  * CLOSE MDV1_BOOT
       TRAP    #$02
       CLR.L   $0084(A6)    * command channel=0
       TST.W   $0088(A6)    * LINE TO EXECUTE ?
       BLT     L04D6A       * NO
       BRA     L04D9E       * YES

L04C64 TAS     $008F(A6)    * initialise BREAK
       MOVE.L  A1,D1
       SUB.L   (A6),D1
       SF      $00B9(A6)    * BV.ARROW
       MOVE.B  -$01(A6,A1.L),D0
       SUBI.B  #$D0,D0
       BCS.S   L04C86
       ST      $00B9(A6)    * BV.ARROW
       BEQ.S   L04C86
       MOVE.B  #$01,$00B9(A6)
L04C86 SUBQ.W  #1,D1
       BLE     L04C04
       CMPI.B  #$20,-$02(A6,A1.L)
       BNE.S   L04C98
       SUBQ.W  #1,A1
       BRA.S   L04C86

L04C98 MOVE.B  #$0A,-$01(A6,A1.L)
       MOVE.L  A1,$0004(A6)
L04CA2 JSR     L0890C(PC)
       LEA     L08B5A(PC),A2
       JSR     L087D4(PC)
       BEQ.S   L04CD0
       BLT.S   L04CB8
       JSR     L097DC(PC)
       BRA.S   L04CA2

* error handling of direct commands

L04CB8 TST.L   $0084(A6)   * was it # 0
       BNE.S   L04CCC
       MOVEQ   #-$15,D0    * report bad line
       JSR     L09B9C(PC)
       SUBQ.L  #1,$0004(A6)
       BRA     L04C2C      * edit offending line

* error handling of direct input from other # than 0
L04CCC JSR     L08A4E(PC)
L04CD0 JSR     L08AB4(PC)
       JSR     L08E88(PC)
       BRA.S   L04D02     * ERROR
       SF      $006F(A6)
       ST      $008E(A6)
       MOVE.L  D0,D5
       BSR.S   L04CFA
       BNE     L04C04
       MOVEQ   #$02,D1
       JSR     L0661E(PC)
       BLT.S   L04CF6
       JSR     L08FE6(PC)
L04CF6 BRA     L04BFA

* get input #

L04CFA MOVEA.L $0084(A6),A0
       MOVE.L  A0,D0
       RTS

* supervisor for direct commands
* enter command mode
L04D02 MOVEA.L $0008(A6),A4         * BV.TKBAS
       MOVE.B  #$01,$006C(A6)       * BV.STMNT
       SF      $006E(A6)            * BV.INLIN
       ST      $006D(A6)            * BV.CONT
L04D14 ST      $006F(A6)            * BV.SING
       CLR.L   $0068(A6)            * BV.LINUM
       JSR     L0A4BA(PC)
       JSR     L0A8B8(PC)
       BNE     L04C44
       TST.B   $008B(A6)            * BV.COMLN
       BEQ.S   L04D5E
       SUBQ.W  #4,$008C(A6)         * BV.STOPN
       BEQ.S   L04CF6
       BLT.S   L04D14
       MOVEA.L $0008(A6),A0         * BV.TKBAS
       MOVE.L  $000C(A6),D0         * BV.TKTOP
       SUBA.L  A0,A4
       SUB.L   A0,D0
       MOVE.L  D0,D1
       SUBA.L  D0,A7
L04D46 MOVE.W  $00(A6,A0.L),(A7)+
       ADDQ.W  #2,A0
       SUBQ.W  #2,D1
       BGT.S   L04D46
       SUBA.L  D0,A7
       MOVE.W  D0,-(A7)
       MOVE.W  A4,-(A7)
       MOVE.B  $006C(A6),-(A7)
       MOVE.L  $006E(A6),-(A7)
L04D5E TST.W   $0088(A6)
       BGE.S   L04D98
       BSR.S   L04CFA
L04D66 BNE     L04C04
L04D6A TST.B   $008B(A6)
       BEQ.S   L04CF6
       SF      $008B(A6)
       MOVE.L  (A7)+,$006E(A6)
       MOVE.B  (A7)+,$006C(A6)
       MOVEA.L $0008(A6),A0
       MOVEA.L A0,A4
       ADDA.W  (A7)+,A4
       MOVE.W  (A7)+,D0
L04D86 MOVE.W  (A7)+,$00(A6,A0.L)
       ADDQ.W  #2,A0
       SUBQ.W  #2,D0
       BGT.S   L04D86
       MOVE.L  A0,$000C(A6)
       BRA     L04D14

* execution of Basic progs

L04D98 BSR     L04CFA   * store channel ID
       BNE.S   L04D66   * not #0
L04D9E JSR     L0A4BA(PC)       * init variables and procs
       MOVEA.L $0010(A6),A4     * BV.PFBAS
       SF      $006F(A6)
       CLR.L   $0068(A6)
       MOVE.B  #$01,$006C(A6)
       MOVE.W  $0088(A6),D4
       BEQ.S   L04DD6
       JSR     L09FBE(PC)
       BNE     L04BFA
       MOVE.B  $008A(A6),D4
       BEQ.S   L04DD6
       JSR     L0A96A(PC)       * first instruction in line
       JSR     L0A00A(PC)
L04DD0 JSR     L0A90C(PC)       * execute prog
       BRA.S   L04DDA

L04DD6 JSR     L0A8A8(PC)       * execute prog
L04DDA BNE     L04BFA           * error or end
       TST.W   $008C(A6)        * system command ?
       BNE     L04D5E           * no
       BRA.S   L04DD0           * continue
      
* !! only once needed ??? !!!

L04DE8 JSR     L04E5E(PC)       * reserve memory for name table entry
       MOVEA.L $001C(A6),A2
       ADDQ.L  #8,$001C(A6)
       RTS
       
L04DF6 MOVE.L  D1,-(A7)         * reserve memory for variables
       ADDQ.L  #7,D1
       ANDI.W  #$FFF8,D1
L04DFE MOVEA.W #$0072,A0
       MOVEQ   #$0C,D0
       TRAP    #$01
       TST.L   D0
       BLT.S   L04E0C   * memory insufficient
       BRA.S   L04E26

L04E0C MOVE.L  D1,-(A7)
       JSR     L04E76(PC)
       MOVEA.L $002C(A6),A0
       ADD.L   D1,$002C(A6)
       MOVEA.W #$0072,A1
       MOVEQ   #$0D,D0
       TRAP    #$01
       MOVE.L  (A7)+,D1
       BRA.S   L04DFE

L04E26 MOVE.L  (A7)+,D1
       RTS

L04E2A DC.W    $0100  * table for memory reservation
       DC.W    $0100
       DC.W    $0100
       DC.W    $0100

* !!! table above and command below are fuzzy - in all cases same amount
* of memory is reserved so it can be shortened - instead of 
* first four lines only move.l #$0100,d1 would be sufficient !!!
 
L04E32 LEA     L04E2A(PC),A1
       ADD.W   D0,D0
       MOVEQ   #$00,D1
       MOVE.W  $00(A1,D0.W),D1  * fuzzy
       MOVEQ   #$60,D2
       MOVE.L  A7,$0060(A6)
       MOVE.L  A6,D0
       SUB.L   D0,$0060(A6)
       BRA.S   L04E90           * reserve 256 bytes

L04E4C MOVEQ   #$20,D1          * reserve 32 bytes artihm stack
L04E4E MOVEQ   #$58,D2
       BRA.S   L04E90

L04E52 MOVEQ   #$0C,D1          * 12 Bytes on stack
L04E54 MOVEQ   #$48,D2
       BRA.S   L04E90

* !!! only once needed ??? !!! - YES! AVOID JSR

L04E58 MOVEQ   #4,D1            * reserve 4 BYTES
L04E5A MOVEQ   #$50,D2
       BRA.S   L04E90

L04E5E MOVEQ   #$08,D1         
L04E60 MOVEQ   #$1C,D2
       BRA.S   L04E84

* !!! only once needed ??? !!! - YES! AVOID JSR

L04E64 MOVEQ   #$16,D1
       MOVEQ   #$3C,D2
       BRA.S   L04E84

L04E6A MOVEQ   #$04,D2
       BRA.S   L04E84

* !!! only once needed ??? !!! - YES! AVOID JSR

L04E6E MOVEQ   #$0C,D2
       BRA.S   L04E84

L04E72 MOVEQ   #$24,D2
       BRA.S   L04E84

* !!! only once needed ??? !!! - YES! AVOID JSR

L04E76 MOVEQ   #$2C,D2
       BRA.S   L04E84

* !!! only once needed ??? !!! - YES! AVOID JSR

L04E7A MOVEQ   #$34,D2
       BRA.S   L04E84
       
* !!! only once needed ??? !!! - YES! AVOID JSR
L04E7E MOVEQ   #$44,D2
       BRA.S   L04E84
       
L04E82 MOVEQ   #$14,D2
L04E84 MOVEQ   #$00,D0
       MOVE.L  $04(A6,D2.L),D3
       SUB.L   $00(A6,D2.L),D3
       BRA.S   L04E9A

* RESERVE MEMORY ON BASE OF STACK

L04E90 MOVEQ   #-$01,D0
       MOVE.L  $00(A6,D2.L),D3
       SUB.L   -$04(A6,D2.L),D3
L04E9A CMP.L   D1,D3             * enough memory for reservation
       BGE.S   L04EE2
       MOVEM.L A0-A3,-(A7)
       ADDI.L  #$F,D1
       ANDI.W  #$FFF0,D1
L04EAC MOVE.L  $0048(A6),D3
       SUB.L   $0044(A6),D3
       CMP.L   D1,D3
       BGT.S   L04F14
       MOVEM.L D0-D2,-(A7)
       MOVEQ   #$16,D0
       TRAP    #$01
       TST.L   D0
       BEQ.S   L04EE4
       MOVE.W  #$0012,$008C(A6)
       TRAP    #$00
       MOVEA.L $0064(A6),A5
       ADDA.L  A6,A5
       SUBA.L  $0076(A6),A5
       SUBQ.W  #4,A5
       MOVE.L  A5,USP
       MOVE.W  #$0004,SR
       SF      $006D(A6)
L04EE2 RTS

L04EE4 MOVEA.L $0048(A6),A0
       MOVEA.L $0064(A6),A1
       LEA     $00(A1,D1.L),A2
L04EF0 SUBQ.W  #4,A2
       SUBQ.W  #4,A1
       MOVE.L  $00(A6,A1.L),$00(A6,A2.L)
       CMPA.L  A0,A1
       BGT.S   L04EF0
       MOVEQ   #$48,D0
       MOVEQ   #$64,D2
L04F02 ADD.L   D1,$00(A6,D0.L)
       ADDQ.W  #4,D0
       CMP.L   D2,D0
       BLE.S   L04F02
       ADDA.L  D1,A7
       MOVEM.L (A7)+,D0-D2
       BRA.S   L04EAC

L04F14 TST.B   D0
       BMI.S   L04F54
       CMPI.L  #$44,D2
       BEQ.S   L04F84
       MOVEA.L $44(A6),A1
       MOVEA.L $04(A6,D2.L),A0
       LEA     $00(A1,D1.L),A2
L04F2C SUBQ.W  #4,A1
       SUBQ.W  #4,A2
       MOVE.L  $00(A6,A1.L),$00(A6,A2.L)
       CMPA.L  A0,A1
       BGT.S   L04F2C
       MOVEQ   #$04,D0
       ADD.W   D2,D0
       MOVEQ   #$48,D2
       TST.L   $0072(A6)
       BEQ.S   L04F7A
       CMPI.L  #$28,D0
       BGT.S   L04F7A
       ADD.L   D1,$0072(A6)
       BRA.S   L04F7A

L04F54 CMPI.L  #$48,D2
       BEQ.S   L04F84
       MOVEA.L -$04(A6,D2.L),A1
       MOVEA.L $0048(A6),A0
       NEG.L   D1
       LEA     $00(A0,D1.L),A2
L04F6A MOVE.L  $00(A6,A0.L),$00(A6,A2.L)
       ADDQ.W  #4,A0
       ADDQ.W  #4,A2
       CMPA.L  A1,A0
       BLE.S   L04F6A
       MOVEQ   #$48,D0
L04F7A ADD.L   D1,$00(A6,D0.L)
       ADDQ.W  #4,D0
       CMP.L   D2,D0
       BLT.S   L04F7A
L04F84 MOVEM.L (A7)+,A0-A3
       RTS

L04F8A MOVEQ   #$14,D2
       BRA.S   L04FA0

L04F8E MOVEQ   #$24,D2
       BRA.S   L04FA0

L04F92 MOVEQ   #$1C,D2
       BRA.S   L04FA0

L04F96 MOVEQ   #$2C,D2
       BRA.S   L04FA0

L04F9A MOVEQ   #$34,D2
       BRA.S   L04FA0

L04F9E MOVEQ   #$3C,D2
L04FA0 MOVEA.L $04(A6,D2.L),A1
       MOVE.L  A1,D1
       MOVE.L  $00(A6,D2.L),D0
       ADDQ.W  #1,D0
       BCLR    #$00,D0
       MOVEA.L D0,A0
       SUB.L   A0,D1
       BEQ.S   L04FE6
L04FB6 MOVE.L  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #4,A1
       ADDQ.W  #4,A0
       CMPA.L  $0044(A6),A1
       BLT.S   L04FB6
       MOVEQ   #$04,D0
       ADD.B   D2,D0
       TST.L   $0072(A6)
       BEQ.S   L04FDA
       CMPI.B  #$28,D2
       BGE.S   L04FDA
       SUB.L   D1,$0072(A6)
L04FDA MOVEQ   #$48,D2
L04FDC SUB.L   D1,$00(A6,D0.L)
       ADDQ.B  #4,D0
       CMP.B   D2,D0
       BLT.S   L04FDC
L04FE6 RTS

L04FE8 ADDQ.L  #7,D1
       ANDI.L  #$FFFFFFF8,D1
       BEQ.S   L04FFA
       MOVEA.W #$0072,A1
       MOVEQ   #$0D,D0
       TRAP    #$01
L04FFA RTS

L04FFC DC.W    $4E75
       DC.W    $0000
***End BASIC1_ASM  basic1_asm

**********
*
*  BASIC2_ASM basic2_asm
*
**********


* initialise Basic pointers

L0566E SUBA.L  A3,A3
       MOVEQ   #$48,D0
L05672 MOVE.L  #$100,$00(A6,A3.L)
       ADDQ.W  #4,A3
       CMPA.W  D0,A3
       BLT.S   L05672
       MOVEQ   #$64,D0
L05682 MOVE.L  A5,$00(A6,A3.L)
       ADDQ.W  #4,A3
       CMPA.W  D0,A3
       BLE.S   L05682
       SF      $006E(A6)
       ST      $006D(A6)
       ST      $0082(A6)
       SF      $00AA(A6)
       ST      $00AB(A6)
       MOVE.W  #$FFFF,$0088(A6)
       MOVE.L  #$FFFFFFFF,$00CA(A6)
       MOVEQ   #$00,D0
       MOVE.W  D0,$00C8(A6)
       MOVE.L  D0,$0084(A6)
       MOVE.L  D0,$0072(A6)
       JSR     L04E32(PC)
       MOVEQ   #$7E,D1
       JMP     L04E6A(PC)

* liberate memory 

L056C6 MOVEA.L $0048(A6),A1
       MOVE.L  A1,D1
       SUB.L   $0044(A6),D1
       ANDI.L  #$FFFFFE00,D1
       BEQ.S   L05700
       MOVEA.L A1,A0
       SUBA.L  D1,A0
L056DC MOVE.L  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #4,A1
       ADDQ.W  #4,A0
       CMPA.L  $0064(A6),A1
       BLT.S   L056DC
       MOVEQ   #$48,D0
       MOVEQ   #$64,D2
L056F0 SUB.L   D1,$00(A6,D0.L)
       ADDQ.B  #4,D0
       CMP.B   D2,D0
       BLE.S   L056F0
       SUBA.L  D1,A7
       MOVEQ   #$17,D0
       TRAP    #$01
L05700 RTS


* store value of variable

L05702 CMPA.L  $001C(A6),A5
       BNE.S   L0570C
       MOVE.L  A3,$001C(A6)
L0570C CMPA.L  A5,A3
       BGE     L057EE
       ANDI.B  #$0F,$01(A6,A3.L)
       BEQ.S   L05778
       CMPI.W  #$FFFF,$02(A6,A3.L)
       BNE.S   L05728
       MOVEA.L A3,A2
       BSR.S   L05784
       BRA.S   L05778

L05728 MOVEQ   #$01,D0
       SUB.B   $00(A6,A3.L),D0
       BGE.S   L05778
       MOVE.W  $02(A6,A3.L),D0
       LSL.L   #3,D0
       MOVEA.L $0018(A6),A2
       ADDA.L  D0,A2
       CMPI.B  #$03,$00(A6,A2.L)
       BNE.S   L0576C
       CMPI.B  #$02,$00(A6,A3.L)
       BEQ.S   L05778
       MOVEA.L $04(A6,A3.L),A0
       ADDA.L  $0028(A6),A0
       MOVEQ   #$00,D1
       MOVE.W  $04(A6,A0.L),D1
       LSL.W   #2,D1
       ADDQ.W  #6,D1
       MOVEM.L D2/A1-A3,-(A7)
       JSR     L04FE8(PC)
       MOVEM.L (A7)+,D2/A1-A3
       BRA.S   L05778

L0576C MOVE.L  $04(A6,A3.L),$04(A6,A2.L)
       MOVE.B  $00(A6,A3.L),$00(A6,A2.L)
L05778 MOVE.L  D7,$00(A6,A3.L)
       MOVE.L  D7,$04(A6,A3.L)
       ADDQ.W  #8,A3
       BRA.S   L0570C

* release memory that was occupied by a variable

L05784 MOVEM.L D2/D4/D6/A1-A3,-(A7)
       MOVEA.L $0028(A6),A0
       MOVE.L  $04(A6,A2.L),D1
       BLT.S   L057E8
       ADDA.L  D1,A0
       MOVE.B  $00(A6,A2.L),D0
       SUBQ.B  #2,D0
       BLE.S   L057C0
       SUBQ.B  #1,D0
       BNE.S   L057AC
       MOVE.L  D1,D4
       MOVE.B  $01(A6,A2.L),D6
       JSR     L099FE(PC)
       BRA.S   L057E8

L057AC SUBQ.B  #3,D0
       BEQ.S   L057BC
       SUBQ.B  #1,D0
       BEQ.S   L057B8
       MOVEQ   #-$0C,D0
       BRA.S   L057EA

L057B8 MOVEQ   #$1A,D1
       BRA.S   L057DC

L057BC MOVEQ   #$0C,D1
       BRA.S   L057DC

L057C0 MOVE.B  $01(A6,A2.L),D0
       SUBQ.B  #2,D0
       BLT.S   L057D2
       BEQ.S   L057CE
       MOVEQ   #$02,D1
       BRA.S   L057DC

L057CE MOVEQ   #$06,D1
       BRA.S   L057DC

L057D2 MOVEQ   #$03,D1
       ADD.W   $00(A6,A0.L),D1
       BCLR    #$00,D1
L057DC MOVE.L  #$FFFFFFFF,$04(A6,A2.L)
       JSR     L04FE8(PC)
L057E8 MOVEQ   #$00,D0
L057EA MOVEM.L (A7)+,D2/D4/D6/A1-A3
L057EE RTS

* join strings (&!)
L057F0 MOVE.L  A0,-(A7)
       MOVE.W  $00(A6,A1.L),D0
       ADDQ.W  #2,A1
       MOVEQ   #$00,D1
       MOVE.W  D0,D1
       BEQ     L0588A
       SWAP    D0
       ADDQ.W  #1,D1
       BCLR    #$00,D1
       MOVE.W  D1,D0
       SUBA.L  $005C(A6),A1
       MOVEM.L D0-D2/A1,-(A7)
       JSR     L04DF6(PC)
       MOVEM.L (A7)+,D0-D2/A1
       ADDA.L  $005C(A6),A1
L0581E MOVE.W  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #2,A1
       ADDQ.W  #2,A0
       SUBQ.W  #2,D1
       BGT.S   L0581E
       SUBA.W  D0,A0
       MOVE.W  $00(A6,A1.L),D2
       ADDQ.W  #2,A1
       MOVEA.L A1,A2
       MOVE.W  D2,D1
       ADDQ.W  #1,D1
       BCLR    #$00,D1
       ADDA.W  D1,A1
       MOVE.W  D2,D1
       SWAP    D0
       ADD.W   D0,D1
       ADDQ.W  #1,D1
       BMI.S   L05890
       BCLR    #$00,D1
       SUBA.W  D1,A1
       MOVE.W  D2,D1
       BEQ.S   L05862
L05854 MOVE.B  $00(A6,A2.L),$00(A6,A1.L)
       ADDQ.W  #1,A2
       ADDQ.W  #1,A1
       SUBQ.W  #1,D1
       BGT.S   L05854
L05862 ADD.W   D0,D2
       MOVE.L  D0,D1
L05866 MOVE.B  $00(A6,A0.L),$00(A6,A1.L)
       ADDQ.W  #1,A0
       ADDQ.W  #1,A1
       SUBQ.W  #1,D0
       BGT.S   L05866
       SUBA.W  D1,A0
       SUBA.W  D2,A1
       SUBQ.W  #2,A1
       MOVE.W  D2,$00(A6,A1.L)
       CLR.W   D1
       SWAP    D1
       MOVE.L  A1,-(A7)
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A1
L0588A MOVEQ   #$00,D0
L0588C MOVEA.L (A7)+,A0
       RTS

* joined string was too long
        
L05890 LEA     -$0002(A2),A1
       MOVE.W  D0,D1
       MOVE.L  A1,-(A7)
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A1
       MOVEQ   #-$12,D0
       BRA.S   L0588C

L058A2 DC.L    $00020202
       DC.L    $02050505
       DC.L    $05050505
       DC.L    $03030302
       DC.L    $01020202
       DC.L    $03030102
       DC.L    $02030200
       
L058BE ANDI.B  #$0F,-$07(A6,A5.L)
       MOVEQ   #$00,D0
       MOVE.B  L058A2(PC,D4.W),D0
       CMPI.B  #$16,D4
       BGT     L0598C
       ANDI.B  #$0F,-$0F(A6,A5.L)
       CMP.B   -$07(A6,A5.L),D0
       BEQ.S   L05904
       CMPI.B  #$05,D0
       BNE.S   L058FA
       MOVE.B  -$07(A6,A5.L),D2
       CMP.B   -$0F(A6,A5.L),D2
       BNE.S   L058F8
       SUBQ.B  #1,D2
       BNE.S   L058F8
       SUBQ.W  #8,A5
L058F4 BRA     L05992

L058F8 MOVEQ   #$02,D0
L058FA BSR     L05996
       BNE     L05994
       MOVE.B  D2,D0
L05904 SUBQ.W  #8,A5
       CMP.B   -$07(A6,A5.L),D0
       BEQ.S   L058F4
       MOVE.B  $01(A6,A5.L),D1
       SUBQ.B  #2,D1
       BLT.S   L0592A
       BEQ.S   L0591E
       MOVE.W  $00(A6,A1.L),-(A7)
       ADDQ.W  #2,A1
       BRA.S   L05946

L0591E MOVE.L  $02(A6,A1.L),-(A7)
       MOVE.W  $00(A6,A1.L),-(A7)
       ADDQ.W  #6,A1
       BRA.S   L05946

L0592A MOVEQ   #$03,D2
       ADD.W   $00(A6,A1.L),D2
       BCLR    #$00,D2
       SUBA.L  D2,A7
       MOVE.L  D2,D1
       SUBQ.W  #1,D1
L0593A MOVE.W  $00(A6,A1.L),(A7)+
       ADDQ.W  #2,A1
       SUBQ.W  #2,D1
       BGE.S   L0593A
       SUBA.L  D2,A7
L05946 MOVE.B  D1,-(A7)
       MOVE.L  A1,$0058(A6)
       BSR.S   L05996
       MOVE.B  (A7)+,D2
       BLT.S   L05968
       BEQ.S   L0595C
       SUBQ.W  #2,A1
       MOVE.W  (A7)+,$00(A6,A1.L)
       BRA.S   L05980

L0595C SUBQ.W  #6,A1
       MOVE.W  (A7)+,$00(A6,A1.L)
       MOVE.L  (A7)+,$02(A6,A1.L)
       BRA.S   L05980

L05968 MOVEQ   #$03,D2
       ADD.W   (A7),D2
       BCLR    #$00,D2
       SUBA.L  D2,A1
       MOVE.L  D2,D1
L05974 MOVE.W  (A7)+,$00(A6,A1.L)
       ADDQ.W  #2,A1
       SUBQ.W  #2,D1
       BGT.S   L05974
       SUBA.L  D2,A1
L05980 MOVE.L  A1,$0058(A6)
       TST.L   D0
       BEQ.S   L05994
       ADDQ.W  #8,A5
       RTS
       
* single operator

L0598C CMP.B   -$07(A6,A5.L),D0
       BNE.S   L05996
L05992 MOVEQ   #$00,D0
L05994 RTS

* convert variables

L05996 MOVE.L  D7,-(A7)
       MOVE.L  A0,-(A7)
       MOVE.B  D0,-(A7)
       MOVE.B  -$07(A6,A5.L),D2
       MOVEQ   #$0F,D1
       AND.L   D1,D0
       AND.L   D1,D2
       SUB.B   D2,D0
       BEQ.S   L05A0A
       SUBQ.B  #2,D2
       BLT.S   L059DE
       BEQ.S   L059C4
       ADDQ.B  #1,D0
       BLT.S   L059BA
       JSR     L047B8(PC)
       BRA.S   L05A0A

L059BA MOVEA.L (A6),A0
       JSR     L03E54(PC)
       BSR.S   L05A20
       BRA.S   L05A0A

L059C4 TST.B   D0
       BLT.S   L059D4
       JSR     L04796(PC)
       MOVE.B  #$03,-$07(A6,A5.L)
       BRA.S   L05A0A

L059D4 MOVEA.L (A6),A0
       JSR     L03EF6(PC)
       BSR.S   L05A20
       BRA.S   L05A0A

L059DE SUBQ.B  #1,D0
       BLT.S   L05A0A
       BEQ.S   L059F0
       BSR.S   L05A34
       MOVE.L  A0,-(A7)
       ADDQ.W  #2,A0
       JSR     L03DC2(PC)
       BRA.S   L059FA

L059F0 BSR.S   L05A34
       MOVE.L  A0,-(A7)
       ADDQ.W  #2,A0
       JSR     L03D16(PC)
L059FA MOVEA.L (A7)+,A0
       MOVE.L  D0,-(A7)
       BSR.S   L05A66
       MOVE.L  (A7)+,D0
       BEQ.S   L05A0A
       SUBQ.W  #2,A1
       CLR.W   $00(A6,A1.L)
L05A0A MOVE.B  (A7)+,D2
       MOVEA.L (A7)+,A0
       MOVE.L  (A7)+,D7
       MOVE.L  A1,$0058(A6)
       TST.L   D0
       BNE.S   L05A1E
       MOVE.B  D2,-$07(A6,A5.L)
       MOVEQ   #$00,D0
L05A1E RTS

* copy ASCII on arithmetic stack

L05A20 MOVE.L  A1,$0058(A6)
       MOVE.L  A4,-(A7)
       MOVE.L  A0,D1
       MOVEA.L (A6),A4
       SUB.L   A4,D1
       JSR     L05F88(PC)
       MOVEA.L (A7)+,A4
       BRA.S   L05A62


* copy ASCII in variables zone

L05A34 MOVEQ   #$03,D1
       ADD.W   $00(A6,A1.L),D1
       BCLR    #$00,D1
       JSR     L04DF6(PC)
       MOVEA.L $0058(A6),A1
       MOVE.L  A0,-(A7)
L05A48 MOVE.W  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #2,A0
       ADDQ.W  #2,A1
       SUBQ.L  #2,D1
       BGT.S   L05A48
       MOVEA.L (A7)+,A0
       MOVE.L  A0,D7
       MOVEQ   #$02,D1
       ADD.W   $00(A6,A0.L),D1
       ADD.L   D1,D7
L05A62 MOVEQ   #$00,D0
       RTS


L05A66 MOVE.L  A1,-(A7)
       MOVEQ   #$03,D1
       ADD.W   $00(A6,A0.L),D1
       BCLR    #$00,D1
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A1
       RTS

* handling of expression after variable, function or instruction

       MOVEQ   #$01,D0
       BRA.S   L05A84
       
L05A7E MOVEQ   #$02,D0
       BRA.S   L05A84

L05A82 MOVEQ   #$03,D0
L05A84 MOVE.B  D0,-(A7)
       BSR.S   L05AA0
       BNE.S   L05A9A
       MOVE.B  (A7),D0
       BNE.S   L05A90
       MOVEQ   #$01,D0
L05A90 JSR     L05996(PC)
       SUBQ.L  #8,A5
       MOVE.L  A5,$001C(A6)
L05A9A ADDQ.W  #2,A7
       TST.L   D0
       RTS

L05AA0 BSR.S   L05ABA
       BNE.S   L05AA8
       BSR     L05EC8
L05AA8 RTS

L05AAA 

* labels indicating jump relative to L05AF4

       DC.B    $00
       DC.B    L05B08-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05AF8-L05AF4
       DC.B    L05B78-L05AF4
       DC.B    L05B8C-L05AF4
       DC.B    L05BAC-L05AF4
       DC.B    L05BB6-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05BB2-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    L05B08-L05AF4
       DC.B    $00

L05ABA MOVEA.L $001C(A6),A5
       MOVE.L  A5,-(A7)
       MOVEM.L D4-D6,-(A7)
       ST      -(A7)
       MOVEQ   #$40,D1
       JSR     L04E60(PC)
       MOVEQ   #$02,D0
       JSR     L04E32(PC)
       BRA.S   L05ADC

L05AD4 MOVEQ   #$01,D6
       BRA.S   L05ADE

L05AD8 ST      D6
       BRA.S   L05ADE

L05ADC SF      D6
L05ADE MOVEQ   #$7F,D4
       AND.B   $00(A6,A0.L),D4
       CMPI.B  #$70,D4
       BGE     L05C58
       MOVE.B  L05AAA(PC,D4.W),D4
       JMP     L05AF4(PC,D4.W)

L05AF4 ADDQ.W  #2,A0
       BRA.S   L05ADE

L05AF8 MOVE.B  $01(A6,A0.L),D4
       CMPI.B  #$05,D4
       BEQ.S   L05B0E
       CMPI.B  #$01,D4
       BEQ.S   L05B72
L05B08 MOVEQ   #$00,D5
       BRA     L05D16

L05B0E ADDQ.W  #2,A0
       TST.B   D6
       BEQ.S   L05B42
       BGT     L05BAC
       CMPI.B  #$03,-$08(A6,A5.L)
       BEQ.S   L05B28
       JSR     L063D0(PC)
       BNE.S   L05B2C
       BRA.S   L05AD8

L05B28 JSR     L06272(PC)
L05B2C BNE     L05CA2
       CMPI.B  #$03,-$08(A6,A5.L)

       BEQ.S   L05AD8
L05B38 CMPI.B  #$01,-$07(A6,A5.L)
       BEQ.S   L05AD8
       BRA.S   L05AD4

L05B42 BSR     L05AA0
       BNE     L05CA2
       CMPI.W  #$8406,$00(A6,A0.L)
       BNE.S   L05BAC
       ADDQ.W  #2,A0
       BRA.S   L05B38

* table of priorities of artihmetic operations

L05B56 DC.L    $00050506
       DC.L    $06040404
       DC.L    $04040404
       DC.L    $01020107
       DC.L    $09010201
       DC.L    $0606080B
       DC.L    $0B030300

L05B72 MOVE.W  #$8508,$00(A6,A0.L)
L05B78 TST.B   D6
       BEQ.S   L05BAC
       MOVE.B  $01(A6,A0.L),D4
       ADDQ.W  #2,A0
       MOVE.B  L05B56(PC,D4.W),D5
       SWAP    D4
       BRA     L05D1A

L05B8C MOVEQ   #$16,D4
       ADD.B   $01(A6,A0.L),D4
       ADDQ.W  #2,A0
       MOVE.B  L05B56(PC,D4.W),D5
       BRA.S   L05BA2

L05B9A TST.B   D5
       BEQ     L05D06
       SWAP    D4
L05BA2 MOVE.B  D5,-(A7)
       MOVE.B  D4,$0001(A7)
       BRA     L05ADC

L05BAC MOVEQ   #-$11,D0
       BRA     L05CA2

L05BB2 BRA     L05C6A

L05BB6 MOVEA.L $001C(A6),A5
       ADDQ.L  #8,$001C(A6)
       MOVEQ   #$00,D4
       MOVE.W  $02(A6,A0.L),D4
       MOVE.L  D4,D0
       ADDQ.W  #4,A0
       LSL.L   #3,D4
       MOVEA.L $0018(A6),A3
       ADDA.L  D4,A3
       MOVE.B  $00(A6,A3.L),D4
       CMPI.B  #$09,D4
       BEQ.S   L05C0C
       CMPI.B  #$05,D4
       BEQ.S   L05C12
       CMPI.B  #$08,D4
       BEQ.S   L05BAC
       CMPI.B  #$04,D4
       BEQ.S   L05BAC
       MOVE.W  $00(A6,A3.L),$00(A6,A5.L)
       ANDI.B  #$0F,$01(A6,A5.L)
       MOVE.W  D0,$02(A6,A5.L)
       MOVE.L  $04(A6,A3.L),$04(A6,A5.L)
       ADDQ.W  #8,A5
       SUBQ.B  #3,D4
       BEQ.S   L05C1E
       BRA     L05C94

L05C0C JSR     L060B8(PC)
       BRA.S   L05C16

L05C12 JSR     L06060(PC)
L05C16 BNE     L05CA2
       BRA     L05AD4

L05C1E MOVEQ   #$00,D1
       MOVE.L  -$04(A6,A5.L),D0
       BLT.S   L05BAC
       MOVEA.L $0028(A6),A3
       ADDA.L  D0,A3
       MOVE.W  $04(A6,A3.L),D1
       LSL.W   #2,D1
       ADDQ.W  #6,D1
       MOVE.L  A3,-(A7)
       BSR     L05FC2
       MOVEA.L (A7)+,A3
       MOVE.L  A2,D2
       SUB.L   $0028(A6),D2
       MOVE.L  D2,-$04(A6,A5.L)
L05C46 MOVE.W  $00(A6,A3.L),$00(A6,A2.L)
       ADDQ.W  #2,A3
       ADDQ.W  #2,A2
       SUBQ.W  #2,D1
       BNE.S   L05C46
       BRA     L05AD8

L05C58 MOVEA.L A0,A4
       BSR     L05F6C
       ADDQ.W  #6,A0
       ANDI.B  #$0F,$00(A6,A1.L)
       MOVEQ   #$02,D4
       BRA.S   L05C76

L05C6A ADDQ.W  #2,A0
       MOVEA.L A0,A4
       BSR     L05F80
       MOVEA.L A4,A0
       MOVEQ   #$01,D4
L05C76 MOVEA.L $001C(A6),A5
       ADDQ.L  #8,$001C(A6)
       MOVE.B  #$01,$00(A6,A5.L)
       MOVE.B  D4,$01(A6,A5.L)
       MOVE.W  #$FFFF,$02(A6,A5.L)
       CLR.L   $04(A6,A5.L)
       ADDQ.W  #8,A5
L05C94 CMPI.B  #$01,-$07(A6,A5.L)
       BEQ     L05AD8
       BRA     L05AD4

L05CA2 TST.W   (A7)+
       BGE.S   L05CA2
       MOVEM.L (A7)+,D4-D6
L05CAA CMPA.L  (A7),A5
       BEQ.S   L05CB4
       MOVEQ   #$01,D2
       BSR.S   L05CBC
       BRA.S   L05CAA

L05CB4 MOVE.L  A5,$001C(A6)
       ADDQ.W  #4,A7
       BRA.S   L05D12

L05CBC MOVE.B  -$08(A6,A5.L),D1
       SUBQ.B  #1,D1
       BNE.S   L05CEC
       SUBQ.B  #2,-$07(A6,A5.L)
       BLT.S   L05CD6
       BGT.S   L05CD0
       ADDQ.L  #4,$0058(A6)
L05CD0 ADDQ.L  #2,$0058(A6)
       BRA.S   L05CE8

L05CD6 MOVEA.L $0058(A6),A1
       MOVEQ   #$03,D1
       ADD.W   $00(A6,A1.L),D1
       BCLR    #$00,D1
       ADD.L   D1,$0058(A6)
L05CE8 SUBQ.W  #8,A5
L05CEA RTS

L05CEC TST.B   D2
       BEQ.S   L05CEA
       SUBQ.B  #2,D1
       BNE.S   L05CE8
       MOVE.L  -$04(A6,A5.L),D1
       BLT.S   L05CE8
       MOVEA.L $0028(A6),A3
       ADDA.L  D1,A3
       BSR     L05F30
       BRA.S   L05CE8

L05D06 MOVEQ   #$00,D0
       ADDQ.W  #2,A7
       MOVEM.L (A7)+,D4-D6
       CMPA.L  (A7)+,A5
       SEQ     D0
L05D12 TST.L   D0
       RTS

L05D16 TST.B   (A7)
       BLE.S   L05D06
L05D1A BSR     L05EC8
L05D1E BNE.S   L05CA2
L05D20 CMP.B   (A7),D5
       BGT     L05B9A
       MOVE.W  (A7)+,D4
       ANDI.W  #$00FF,D4
       JSR     L058BE(PC)
       BNE.S   L05D1E
       MOVE.L  A5,$001C(A6)
       ADD.W   D4,D4
       MOVE.W  L05D4E(PC,D4.W),D4
       BEQ     L05BAC
       MOVEQ   #$02,D0
       JSR     L05D4E(PC,D4.W)
       BNE.S   L05D1E
       MOVE.L  A1,$0058(A6)
       BRA.S   L05D20

L05D4E 
* LABEL OF DISPLACEMENTS FOR JUMPS RELATIV TO 5D4E
       DC.W    $0
       DC.W    L04838-L05D4E
       DC.W    L0482A-L05D4E
       DC.W    L048DE-L05D4E
       DC.W    L0497E-L05D4E
       DC.W    XL05D98-L05D4E
       DC.W    XL05D8A-L05D4E
       DC.W    XL05D90-L05D4E
       DC.W    XL05D92-L05D4E
       DC.W    XL05DA4-L05D4E
       DC.W    XL05D9E-L05D4E
       DC.W    XL05D84-L05D4E
       DC.W    XL05E6C-L05D4E
       DC.W    XL05E74-L05D4E
       DC.W    XL05E7C-L05D4E
       DC.W    L043C2-L05D4E
       DC.W    L057F0-L05D4E
       DC.W    XL05E42-L05D4E
       DC.W    XL05E48-L05D4E
       DC.W    XL05E4E-L05D4E
       DC.W    XL05E92-L05D4E
       DC.W    XL05E98-L05D4E
       DC.W    XL05E26-L05D4E
       DC.W    XL05E10-L05D4E
       DC.W    XL05E0C-L05D4E
       DC.W    XL05E84-L05D4E
       DC.W    XL05E54-L05D4E

* operator <       
L05D84 BSR.S   L05DAA
       BLT.S   L05DF4
       BRA.S   L05E04
*operator >
L05D8A BSR.S   L05DAA
       BGT.S   L05DF4
       BRA.S   L05E04
XL05D84 EQU L05D84
XL05D8A EQU L05D8A

L05D90 MOVEQ   #$03,D0
L05D92 BSR.S   L05DAA
       BEQ.S   L05DF4
       BRA.S   L05E04
XL05D90 EQU L05D90
XL05D92 EQU L05D92
* opertor >=
L05D98 BSR.S   L05DAA
       BGE.S   L05DF4
       BRA.S   L05E04
XL05D98 EQU L05D98
* operator<=
L05D9E BSR.S   L05DAA
L05DA0 BLE.S   L05DF4
       BRA.S   L05E04
XL05D9E EQU L05D9E
* operator <>
L05DA4 BSR.S   L05DAA
       BNE.S   L05DF4
       BRA.S   L05E04
XL05DA4 EQU L05DA4

L05DAA CMPI.B  #$01,-$07(A6,A5.L)
       BNE.S   L05DCC
       MOVE.L  A0,-(A7)
       BSR.S   L05E16
       JSR     L03A9C(PC)
       BSR.S   L05E14
       LEA     -$0006(A0),A1
       MOVE.B  #$02,-$07(A6,A5.L)
L05DC6 MOVEA.L (A7)+,A0
       TST.L   D0
       RTS

L05DCC MOVE.W  D0,D4
       JSR     L0482A(PC)
L05DD2 BNE.S   L05DF0
       SUBQ.W  #3,D4
       BEQ.S   L05DDE
       TST.B   $02(A6,A1.L)
       RTS
       
XL05DD2 EQU L05DD2

L05DDE ADDQ.W  #4,A7
       MOVE.W  $00(A6,A1.L),D0
       BEQ.S   L05DF4
       ADDI.W  #$0018,D0
       SUB.W   -$06(A6,A1.L),D0
       BRA.S   L05DA0

L05DF0 ADDQ.W  #4,A7
       RTS

L05DF4 MOVE.W  #$0801,$00(A6,A1.L)
       MOVE.L  #$40000000,$02(A6,A1.L)
       BRA.S   L05E0C

L05E04 CLR.W   $00(A6,A1.L)
       CLR.L   $02(A6,A1.L)
L05E0C MOVEQ   #$00,D0
       RTS
XL05E0C EQU L05E0C

L05E10 JMP     L04A0C(PC)
XL05E10 EQU L05E10

L05E14 MOVEA.L A0,A1
L05E16 MOVE.W  $00(A6,A1.L),D2
       ADDQ.W  #3,D2
       BCLR    #$00,D2
       LEA     $00(A1,D2.W),A0
       RTS

L05E26 MOVEQ   #$01,D0
       MOVE.L  A0,-(A7)
       BSR.S   L05E16
       JSR     L03A6E(PC)
       BSR.S   L05E14
       LEA     -$0002(A0),A1
       MOVE.B  #$03,-$07(A6,A5.L)
       MOVE.W  D1,$00(A6,A1.L)
       BRA.S   L05DC6
XL05E26 EQU L05E26

L05E42 BSR.S   L05E5C
       OR.B    D1,D0
       BRA.S   L05E58
XL05E42 EQU L05E42

L05E48 BSR.S   L05E5C
       AND.B   D1,D0
       BRA.S   L05E58
XL05E48 EQU L05E48

L05E4E BSR.S   L05E5C
       EOR.B   D1,D0
       BRA.S   L05E58
XL05E4E EQU L05E4E

L05E54 BSR.S   L05E64
       NOT.B   D0
L05E58 BEQ.S   L05E04
       BRA.S   L05DF4
XL05E54 EQU L05E54

L05E5C ADDQ.W  #6,A1
       TST.L   -$04(A6,A1.L)
       SNE     D1
L05E64 TST.L   $02(A6,A1.L)
       SNE     D0
       RTS

L05E6C BSR.S   L05E8A
       OR.W    D0,$00(A6,A1.L)
L05E72 BRA.S   L05E0C
XL05E6C EQU L05E6C

L05E74 BSR.S   L05E8A
       AND.W   D0,$00(A6,A1.L)
       BRA.S   L05E0C
XL05E74 EQU L05E74

L05E7C BSR.S   L05E8A
       EOR.W   D0,$00(A6,A1.L)
       BRA.S   L05E0C
XL05E7C EQU L05E7C

L05E84 NOT.W   $00(A6,A1.L)
       BRA.S   L05E0C
XL05E84 EQU L05E84

L05E8A MOVE.W  $00(A6,A1.L),D0
L05E8E ADDQ.W  #2,A1
       RTS

L05E92 BSR.S   L05EA0
       MOVE.W  D0,D3
       BRA.S   L05E9A
XL05E92 EQU L05E92

L05E98 BSR.S   L05EA0
L05E9A MOVE.W  D3,$00(A6,A1.L)
       BRA.S   L05E72
XL05E98 EQU L05E98
L05EA0 MOVE.W  $02(A6,A1.L),D0
       EXT.L   D0
       MOVE.W  $00(A6,A1.L),D1
       BEQ.S   L05EC2
       MOVE.W  D0,D2
       DIVS    D1,D0
       MOVE.W  D0,D3
       SWAP    D0
       EOR.W   D1,D2
       BPL.S   L05E8E
       TST.W   D0
       BEQ.S   L05E8E
       ADD.W   D1,D0
       SUBQ.W  #1,D3
       BRA.S   L05E8E

L05EC2 MOVEQ   #-$12,D0
       ADDQ.W  #4,A7
       BRA.S   L05E8E


L05EC8 ANDI.B  #$0F,-$07(A6,A5.L)
       MOVE.B  -$08(A6,A5.L),D0
       BEQ.S   L05EE8
       SUBQ.B  #1,D0
       BEQ     L05FB4
       SUBQ.B  #2,D0
       BLT.S   L05F42
       BEQ.S   L05EF6
       SUBQ.B  #3,D0
       BLT.S   L05EE8
       SUBQ.B  #1,D0
       BLE.S   L05F42
L05EE8 MOVEQ   #$01,D2
       BSR     L05CBC
       MOVE.L  A5,$001C(A6)
       MOVEQ   #-$11,D0
       RTS

L05EF6 MOVE.B  -$07(A6,A5.L),D0
       SUBQ.B  #1,D0
       BGT.S   L05EE8
       MOVEA.L -$04(A6,A5.L),A3
       ADDA.L  $0028(A6),A3
       MOVEA.L $00(A6,A3.L),A4
       ADDA.L  $0028(A6),A4
       CMPI.W  #$0001,$04(A6,A3.L)

       BGT.S   L05EE8
       MOVE.B  #$01,-$08(A6,A5.L)

       MOVE.B  #$01,-$07(A6,A5.L)

       MOVEQ   #$00,D1
       MOVE.W  $06(A6,A3.L),D1
       BSR.S   L05F30
       TST.B   D0
       BEQ.S   L05F80
       BRA.S   L05F88

L05F30 MOVEM.L D0-D1/A0-A1,-(A7)
       MOVEA.L A3,A0
       MOVEQ   #$0A,D1
       JSR     L04FE8(PC)
       MOVEM.L (A7)+,D0-D1/A0-A1
       RTS

L05F42 MOVE.B  -$07(A6,A5.L),D0
       MOVE.L  -$04(A6,A5.L),D1
       BLT.S   L05EE8
       MOVE.B  #$01,-$08(A6,A5.L)
       MOVEA.L D1,A4
       ADDA.L  $0028(A6),A4
       SUBQ.B  #2,D0
       BLT.S   L05F80
       BEQ.S   L05F6C
       MOVEQ   #$02,D1
       BSR.S   L05FBC
       SUBQ.W  #2,A1
       MOVE.W  $00(A6,A4.L),$00(A6,A1.L)
       BRA.S   L05FB4

L05F6C MOVEQ   #$06,D1
       BSR.S   L05FBC
       SUBQ.W  #6,A1
       MOVE.L  $02(A6,A4.L),$02(A6,A1.L)

       MOVE.W  $00(A6,A4.L),$00(A6,A1.L)

       BRA.S   L05FB4

L05F80 MOVEQ   #$00,D1
       MOVE.W  $00(A6,A4.L),D1
       ADDQ.W  #2,A4
L05F88 MOVE.L  D1,-(A7)
       ADDQ.L  #3,D1
       BSR.S   L05FBC
       MOVE.L  (A7),D1
       BEQ.S   L05FAC
       ADDQ.L  #1,D1
       BCLR    #$00,D1
       MOVE.L  D1,D0
       SUBA.L  D0,A1
L05F9C MOVE.B  $00(A6,A4.L),$00(A6,A1.L)
       ADDQ.W  #1,A1
       ADDQ.W  #1,A4
       SUBQ.L  #1,D0
       BGT.S   L05F9C
       SUBA.L  D1,A1
L05FAC SUBQ.W  #2,A1
       ADDQ.W  #2,A7
       MOVE.W  (A7)+,$00(A6,A1.L)
L05FB4 MOVE.L  A1,$0058(A6)
       MOVEQ   #$00,D0
       RTS

L05FBC JSR     L04E4E(PC)
       BRA.S   L05FCC

L05FC2 MOVE.L  A0,-(A7)
       JSR     L04DF6(PC)
       MOVEA.L A0,A2
       MOVEA.L (A7)+,A0
L05FCC MOVEA.L $0058(A6),A1
       RTS

L05FD2 JSR     L05ABA(PC)
       BNE.S   L06048
       ANDI.B  #$0F,-$07(A6,A5.L)
       MOVE.B  -$08(A6,A5.L),D0
       CMPI.B  #$01,D0
       BNE.S   L06046
       MOVE.W  #$FFFF,-$06(A6,A5.L)

       MOVE.B  #$02,-$08(A6,A5.L)

       MOVE.B  -$07(A6,A5.L),D0
       SUBQ.B  #2,D0
       BLT.S   L06018
       BEQ.S   L06008
       MOVEQ   #$02,D1
       BSR.S   L0604A
       ADDQ.W  #2,A2
       ADDQ.W  #2,A1
       BRA.S   L06042

L06008 MOVEQ   #$06,D1
       BSR.S   L0604A
       MOVE.L  $02(A6,A1.L),$02(A6,A2.L)
       ADDQ.W  #6,A2
       ADDQ.W  #6,A1
       BRA.S   L06042

L06018 MOVEQ   #$03,D1
       ADD.W   $00(A6,A1.L),D1
       BCLR    #$00,D1
       BSR.S   L0604A
       MOVE.W  $00(A6,A1.L),D1
       ADDQ.W  #2,A1
       ADDQ.W  #2,A2
       BEQ.S   L06042
       ADDQ.W  #1,D1
       BCLR    #$00,D1
L06034 MOVE.W  $00(A6,A1.L),$00(A6,A2.L)
       ADDQ.W  #2,A1
       ADDQ.W  #2,A2
       SUBQ.W  #2,D1
       BGT.S   L06034
L06042 MOVE.L  A1,$0058(A6)
L06046 MOVEQ   #$00,D0
L06048 RTS

L0604A JSR     L05FC2(PC)
       MOVE.L  A2,D2
       SUB.L   $0028(A6),D2
       MOVE.L  D2,-$04(A6,A5.L)
       MOVE.W  $00(A6,A1.L),$00(A6,A2.L)
       RTS

L06060 MOVEA.L A3,A2
       BSR.S   L06094
       MOVE.B  $01(A6,A2.L),-$07(A6,A5.L)
       BSR.S   L060A6
       BNE.S   L06074
       ADDQ.W  #2,A0
       MOVEQ   #$02,D5
       BRA.S   L06076

L06074 MOVEQ   #$03,D5
L06076 MOVEA.L A0,A4
       MOVE.L  D0,D4
       SUBA.L  $0008(A6),A0
       MOVE.L  A0,-(A7)
       LEA     L04BFA,A0
       NOP                    * !!! to conform asm - leave it out
       MOVE.L  A0,-(A7)
       LEA     L0A8EA,A0
       MOVE.L  A0,-(A7)
       BRA     L094CA

* initialise entry in name-table

L06094 CLR.W   $00(A6,A5.L)
       MOVE.W  #$FFFF,$02(A6,A5.L)
       CLR.L   $04(A6,A5.L)
       ADDQ.W  #8,A5
       RTS

L060A6 CMPI.B  #$80,$00(A6,A0.L)
       BNE.S   L060B0
       ADDQ.W  #2,A0
L060B0 CMPI.W  #$8405,$00(A6,A0.L)
       RTS

* execute basic's function

L060B8 BSR.S   L06094
       MOVE.L  A5,D0
       SUB.L   $0018(A6),D0
       MOVE.L  D0,-(A7)
       MOVE.L  $04(A6,A3.L),-(A7)
       BSR.S   L060A6
       BEQ.S   L060CC
       BRA.S   L060DE

L060CC ADDQ.W  #2,A0
       JSR     L0614A(PC)
       BNE.S   L06144
       CMPI.W  #$8406,$00(A6,A0.L)
       BNE.S   L06142
       ADDQ.W  #2,A0
L060DE MOVEA.L (A7)+,A2
       MOVEA.L $0018(A6),A3
       MOVE.L  A5,D0
       SUB.L   A3,D0
       ADDA.L  (A7),A3
       MOVE.L  D0,-(A7)
       SUBA.L  $0008(A6),A0
       MOVEA.L $0058(A6),A1
       SUBA.L  $005C(A6),A1
       MOVEM.L D5-D7/A0-A1,-(A7)
       JSR     (A2)
       MOVE.L  D0,D2
       MOVEM.L (A7)+,D5-D7/A0-A1
       ADDA.L  $0008(A6),A0
       BEQ.S   L06112
       ADDA.L  $005C(A6),A1
       MOVE.L  A1,$0058(A6)
L06112 MOVEA.L $0058(A6),A1
       MOVEA.L $0018(A6),A5
       MOVEA.L A5,A3
       ADDA.L  (A7)+,A5
       ADDA.L  (A7)+,A3
       MOVE.L  A0,-(A7)
       MOVE.L  A3,-(A7)
       JSR     L05702(PC)
       MOVEA.L (A7)+,A5
       MOVE.L  D2,D0
       BNE.S   L06146
       MOVE.B  D4,-$07(A6,A5.L)
       MOVE.B  #$01,-$08(A6,A5.L)
       CLR.L   -$04(A6,A5.L)
       MOVEA.L (A7)+,A0
       MOVEQ   #$00,D0
       RTS

L06142 MOVEQ   #-$11,D0
L06144 ADDQ.W  #4,A7
L06146 ADDQ.W  #4,A7
       RTS

* calculate and store value of a function

L0614A MOVE.L  D3,-(A7)
       MOVE.L  D4,-(A7)
       SF      D4
L06150 JSR     L05FD2(PC)
       BLT.S   L061B6
       BGT.S   L06162
       MOVE.B  $00(A6,A0.L),D0
       MOVE.W  $00(A6,A0.L),D1
       BRA.S   L0618C

L06162 MOVE.B  $00(A6,A0.L),D0
       MOVE.W  $00(A6,A0.L),D1
       CMPI.B  #-114,D0
       BEQ.S   L0617C
       CMPI.W  #$8403,D1
       BNE.S   L061AA
       ST      D4
       ADDQ.W  #2,A0
       BRA.S   L06150

L0617C CLR.W   $00(A6,A5.L)
       MOVE.W  #$FFFF,$02(A6,A5.L)
       CLR.L   $04(A6,A5.L)
       ADDQ.W  #8,A5
L0618C MOVE.L  A5,$001C(A6)
       CMPI.B  #$8E,D0
       BNE.S   L061AA
       TST.B   D4
       BEQ.S   L0619E
       BSET    #$03,D1
L0619E SF      D4
       ADDQ.W  #2,A0
       LSL.B   #4,D1
       OR.B    D1,-$07(A6,A5.L)
       BRA.S   L06150

L061AA TST.B   D4
       BEQ.S   L061B4
       BSET    #$07,-$07(A6,A5.L)

L061B4 MOVEQ   #$00,D0
L061B6 MOVE.L  (A7)+,D4
       MOVE.L  (A7)+,D3
       TST.L   D0
       RTS

L061BE BSR.S   L061DA
       BRA.S   L061CC

L061C2 BSR.S   L061E2
       BRA.S   L061CC

L061C6 BSR.S   L061DE
       BRA.S   L061CC

L061CA BSR.S   L061D6
L061CC BNE.S   L061D4
       SUBQ.W  #1,D3
       BEQ.S   L061D4
       MOVEQ   #-$0F,D0
L061D4 RTS

L061D6 MOVEQ   #$01,D0
       BRA.S   L061E6

L061DA MOVEQ   #$03,D0
       BRA.S   L061E6

L061DE MOVEQ   #$02,D0
       BRA.S   L061E6

L061E2 MOVEQ   #$05,D0
       ROR.L   #1,D0
L061E6 MOVEM.L D5/A4-A5,-(A7)
       MOVE.L  A3,-(A7)
       MOVE.L  D0,-(A7)
       MOVEQ   #$00,D5
L061F0 CMPA.L  $0004(A7),A5
       BLE.S   L06228
       MOVEQ   #$0F,D6
       AND.B   -$07(A6,A5.L),D6
       MOVE.B  D6,-$07(A6,A5.L)
       JSR     L05EC8(PC)
       BNE.S   L0622A
       MOVE.L  (A7),D0
       JSR     L05996(PC)
       MOVE.B  D6,-$07(A6,A5.L)
       TST.L   D0
       BNE.S   L0622A
       TST.L   (A7)
       BPL.S   L06222
       JSR     L047AA(PC)
       BNE.S   L0622A
       MOVE.L  A1,$0058(A6)
L06222 ADDQ.W  #1,D5
       SUBQ.W  #8,A5
       BRA.S   L061F0

L06228 MOVEQ   #$00,D0
L0622A ADDQ.W  #4,A7
       MOVE.L  D5,D3
       MOVEA.L (A7)+,A3
       MOVEM.L (A7)+,D5/A4-A5
       TST.L   D0
       RTS

* evaluate characteristics of a table

L06238 ANDI.B  #$0F,-$07(A6,A5.L)
       MOVEA.L -$04(A6,A5.L),A4
       ADDA.L  $0028(A6),A4
       MOVEA.L A4,A2
       MOVE.L  $00(A6,A4.L),D6
       MOVE.W  $04(A6,A4.L),D4
       ADDQ.W  #6,A4
       RTS

* store charecteristics evaluated above

L06254 SUBA.L  $0028(A6),A2
       SUBA.L  $0028(A6),A4
       MOVEM.L A2/A4-A5,-(A7)
       JSR     L05A82(PC)
       MOVEM.L (A7)+,A2/A4-A5
       ADDA.L  $0028(A6),A4
       ADDA.L  $0028(A6),A2
       RTS

L06272 BSR.S   L06238
L06274 MOVEQ   #$00,D5
       BSR.S   L06254
       BLT.S   L062D0
       BEQ.S   L06288
       CMPI.W  #$8E05,$00(A6,A0.L)

       BEQ.S   L06292
L06284 MOVEQ   #-$11,D0
       BRA.S   L062D0

L06288 ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D5
       BLT.S   L062CE
L06292 CMP.W   $00(A6,A4.L),D5
       BGT.S   L062CE
       MOVE.W  D5,D0
       MULU    $02(A6,A4.L),D0
       MOVE.B  -$07(A6,A5.L),D1
       SUBQ.B  #2,D1
       BLT.S   L062B0
       BEQ.S   L062AC
       ADD.L   D0,D0
       BRA.S   L062B0

L062AC MULU    #$0006,D0
L062B0 ADD.L   D0,D6
       MOVEQ   #$00,D0
       MOVE.L  D6,$00(A6,A2.L)
       CMPI.W  #$8E05,$00(A6,A0.L)
       BNE.S   L062E6
       ADDQ.W  #2,A0
       BSR.S   L06254
       BLT.S   L062D0
       BEQ.S   L062D4
       MOVE.W  $00(A6,A4.L),D0
       BRA.S   L062E2

L062CE MOVEQ   #-$04,D0
L062D0 BRA     L063CE

L062D4 ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D0
       CMP.W   $00(A6,A4.L),D0
       BGT.S   L062CE
L062E2 SUB.W   D5,D0
       BLT.S   L062CE
L062E6 MOVE.W  D0,$00(A6,A4.L)
       ADDQ.W  #4,A4
       SUBQ.W  #1,D4
       BNE.S   L0632A
       CMPI.B  #$01,-$07(A6,A5.L)

       BGT.S   L0632A
       BEQ.S   L06308
       SUBQ.L  #1,$00(A6,A2.L)
       ADDQ.W  #1,-$04(A6,A4.L)
       TST.W   D5
       BEQ.S   L062CE
       BRA.S   L0632A

L06308 CLR.B   -$07(A6,A5.L)
       ADDQ.W  #1,-$04(A6,A4.L)
       ADDQ.L  #1,$00(A6,A2.L)
       TST.W   D5
       BNE.S   L0632A
       TST.W   D0
       BNE.S   L062CE
       SUBQ.L  #1,$00(A6,A2.L)
       SUBQ.W  #1,-$04(A6,A4.L)
       MOVE.B  #$03,-$07(A6,A5.L)

L0632A MOVE.W  $00(A6,A0.L),D0
       ADDQ.W  #2,A0
       CMPI.W  #$8406,D0
       BEQ.S   L06346
       CMPI.W  #$8E01,D0
       BNE     L06284
       TST.W   D4
       BGT     L06274
       BRA.S   L062CE

L06346 BSR     L06238
       MOVEA.L (A6),A3
       MOVE.L  $00(A6,A2.L),$00(A6,A3.L)

       ADDQ.W  #6,A3
       MOVEQ   #$00,D0
L06356 TST.W   $00(A6,A4.L)
       BEQ.S   L06366
       MOVE.L  $00(A6,A4.L),$00(A6,A3.L)

       ADDQ.W  #4,A3
       ADDQ.W  #1,D0
L06366 ADDQ.W  #4,A4
       SUBQ.W  #1,D4
       BGT.S   L06356
       MOVEA.L (A6),A3
       MOVE.W  D0,$04(A6,A3.L)
       MOVE.W  $04(A6,A2.L),D1
       LSL.L   #2,D1
       ADDQ.W  #6,D1
       MOVE.L  A0,-(A7)
       MOVE.L  A3,-(A7)
       MOVEA.L A2,A0
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A3
       MOVEA.L (A7)+,A0
       MOVE.W  $04(A6,A3.L),D1
       BGT.S   L063A2
       TST.B   -$07(A6,A5.L)
       BEQ.S   L063A2
       MOVE.L  $00(A6,A3.L),-$04(A6,A5.L)

       MOVE.B  #$02,-$08(A6,A5.L)

       BRA.S   L063CC

L063A2 LSL.L   #2,D1
       ADDQ.W  #6,D1
       MOVE.L  A0,-(A7)
       MOVE.L  A3,-(A7)
       JSR     L04DF6(PC)
       MOVEA.L A0,A2
       MOVEA.L (A7)+,A3
       MOVEA.L (A7)+,A0
       MOVE.L  A2,D0
       SUB.L   $0028(A6),D0
       MOVE.L  D0,-$04(A6,A5.L)
L063BE MOVE.W  $00(A6,A3.L),$00(A6,A2.L)
       ADDQ.W  #2,A3
       ADDQ.W  #2,A2
       SUBQ.L  #2,D1
       BGT.S   L063BE
L063CC MOVEQ   #$00,D0
L063CE RTS

* evaluate substring of type x$( 4 to 8)

L063D0 MOVEM.L D5-D6/A2/A4,-(A7)
       CMPI.B  #$01,-$08(A6,A5.L)
       BEQ.S   L063EE
       MOVE.L  -$04(A6,A5.L),D0
       BLT.S   L063EA
       MOVEA.L $0028(A6),A2
       ADDA.L  D0,A2
       BRA.S   L06404

L063EA MOVEQ   #-$11,D0
       BRA.S   L0643E

L063EE MOVE.L  A0,-(A7)
       JSR     L05A34(PC)
       MOVEQ   #$00,D7
       MOVE.L  A1,$0058(A6)
       MOVEA.L A0,A2
       MOVEA.L (A7)+,A0
       MOVE.L  A2,D0
       SUB.L   $0028(A6),D0
L06404 MOVE.L  D0,-(A7)
       BSR.S   L06446
       MOVEA.L $0028(A6),A2
       ADDA.L  (A7)+,A2
       BNE.S   L06420
       MOVEA.L A2,A4
       ADDQ.W  #2,A4
       SUBQ.W  #1,D5
       ADDA.W  D5,A4
       MOVE.W  D6,D1
       SUB.W   D5,D1
       JSR     L05F88(PC)
L06420 MOVE.L  D0,-(A7)
       CMPI.B  #$01,-$08(A6,A5.L)

       BNE.S   L06434
       MOVE.L  A0,-(A7)
       MOVEA.L A2,A0
       JSR     L05A66(PC)
       MOVEA.L (A7)+,A0
L06434 MOVE.L  (A7)+,D0
       BNE.S   L0643E
       MOVE.B  #$01,-$08(A6,A5.L)

L0643E MOVEM.L (A7)+,D5-D6/A2/A4
       TST.L   D0
       RTS

L06446 MOVE.W  $00(A6,A2.L),-(A7)
       JSR     L05A82(PC)
       BLT.S   L06496
       BGT.S   L0649E
       ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D5
       BLE.S   L0649E
       CMP.W   (A7),D5
       BGT.S   L0649E
       MOVE.W  D5,D6
       CMPI.W  #$8E05,$00(A6,A0.L)
       BNE.S   L06482
       ADDQ.W  #2,A0
       JSR     L05A82(PC)
       BLT.S   L06496
       BGT.S   L06480
       ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D6
       CMP.W   (A7),D6
       BLE.S   L06482
L06480 MOVE.W  (A7),D6
L06482 MOVE.W  D6,D0
       ADDQ.W  #1,D0
       SUB.W   D5,D0
       BLT.S   L0649E
       CMPI.W  #$8406,$00(A6,A0.L)
       BNE.S   L0649A
       ADDQ.W  #2,A0
       MOVEQ   #$00,D0
L06496 ADDQ.W  #2,A7
       RTS


L0649A MOVEQ   #-$11,D0
       BRA.S   L06496

L0649E MOVEQ   #-$04,D0
       BRA.S   L06496

L064A2 MOVE.L  A4,-(A7)
       MOVEQ   #$0F,D0
       AND.B   -$07(A6,A5.L),D0
       SUBQ.B  #1,D0
       BEQ.S   L064D6
       MOVEQ   #$00,D0
       MOVE.W  -$06(A6,A5.L),D0
       BLT.S   L064DC
       MOVEA.L $0018(A6),A1
       LSL.L   #3,D0
       ADDA.L  D0,A1
       MOVEA.L $0020(A6),A0
       ADDA.W  $02(A6,A1.L),A0
       MOVEQ   #$00,D1
       MOVE.B  $00(A6,A0.L),D1
       LEA     $0001(A0),A4
       JSR     L05F88(PC)
       BRA.S   L064DE

L064D6 JSR     L05EC8(PC)
       BRA.S   L064DE

L064DC MOVEQ   #-$0C,D0
L064DE MOVEA.L (A7)+,A4
       RTS

**------------------------ B a u d
LBAUD  JSR     L0803E(PC)       * search for parameter
       BNE.S   L064F6
       MOVE.W  $00(A6,A1.L),D1
       MOVEQ   #$12,D0
       TRAP    #$01
       TST.L   D0
       BMI.S   L064F8
       MOVEQ   #$00,D0
L064F6 RTS

L064F8 MOVEQ   #-$0F,D0
       RTS

**------------------- end BAUD

* desplacements for parameters of BEEP
L064FC DC.L  $00060000
       DC.L  $00020004
       DC.L  $0008000A
       DC.L  $000E000C

* Beeperror

L0650C ADD.L   D3,D3
       ADD.L   D3,$0058(A6)
L06512 ADDA.W  #$0018,A7
       MOVEM.L (A7)+,D4-D7/A3-A5
       TST.L   D0
       RTS

LBEEP  JSR     L061DA(PC)
       MOVEM.L D4-D7/A3-A5,-(A7)
       ADDA.W  #$FFE8,A7
       MOVEA.L A7,A3
       BNE.S   L0650C
       MOVEQ   #-$0F,D0
       CMPI.W  #0,D3
       BEQ.S   L065A8
       CMPI.W  #1,D3
       BEQ.S   L0650C
       CMPI.W  #3,D3
       BEQ.S   L0650C
       CMPI.W  #4,D3
       BEQ.S   L0650C
       CMPI.W  #8,D3
       BGT.S   L0650C
       LEA     L064FC(PC),A5
       MOVEQ   #$01,D2
L06554 MOVE.W  $0(A6,A1.L),D0
       CMPI.W  #2,D2
       BEQ.S   L06564
       CMPI.W  #3,D2
       BNE.S   L06566
L06564 ADDQ.W  #1,D0
L06566 ROR.W   #8,D0
       JSR     L065C0(PC)
       ADDA.W  #2,A1
       CMP.W   D3,D2
       BLE.S   L06554
       CMPI.W  #$0003,D2
       BEQ.S   L06582
L0657A MOVEQ   #0,D0
       CMPI.W  #8,D2
       BGT.S   L06588
L06582 JSR     L065C0(PC)
       BRA.S   L0657A

L06588 MOVE.B  #$0A,(A3)
       MOVE.B  #$10,$0001(A3)
       MOVE.L  #$4444AA66,$0002(A3)
       MOVE.B  #$01,$0016(A3)
       MOVEQ   #$11,D0
       TRAP    #$01
       BRA     L0650C

* stop Beeper

L065A8 MOVE.B  #$0B,(A3)
       MOVE.B  #$00,$0001(A3)
       MOVE.B  #$01,$0006(A3)
       MOVEQ   #$11,D0
       TRAP    #$01
       BRA     L06512

L065C0 MOVEA.W (A5)+,A4
       MOVE.W  D0,$06(A3,A4.W)
       ADDQ.W  #1,D2
       RTS

*-------------- end BEEP

LCALL  JSR     L061E2(PC)
       BNE.S   L065E4
       LSL.L   #2,D3
       BEQ.S   L065E2
       ADD.L   D3,$0058(A6)
       MOVE.L  $00(A6,A1.L),-(A7)
       MOVEM.L $04(A6,A1.L),D1-D7/A0-A5

L065E2 MOVEQ   #-$0F,D0
L065E4 RTS

*------------- end CALL

* evaluate le #id corresponding to a Basic#nr

L065E6 MOVEQ   #$01,D1
L065E8 MOVE.L  A5,-(A7)
       CMPA.L  A3,A5
       BLS.S   L0661C
       BCLR    #$07,$01(A6,A3.L)
       BEQ.S   L0661C
       MOVE.L  A3,-(A7)
       LEA     $0008(A3),A5
       ANDI.B  #$0F,$01(A6,A3.L)
       JSR     L05EC8(PC)
       BNE.S   L06642
       MOVEQ   #$03,D0
       JSR     L05996(PC)
       BNE.S   L06642
       MOVEA.L (A7)+,A3
       ADDQ.W  #8,A3
       MOVE.W  $00(A6,A1.L),D1
       ADDQ.L  #2,$0058(A6)
L0661C MOVEA.L (A7)+,A5

L0661E MOVE.L  D1,D0
       MOVEA.L $0030(A6),A0
       MULU    #$0028,D0
       ADDA.L  D0,A0
       CMPA.L  $0034(A6),A0
       BGE.S   L0663E
       MOVE.L  $00(A6,A0.L),D0
       BLT.S   L0663E
       MOVEA.L A0,A2
       MOVEA.L D0,A0
       MOVEQ   #$00,D0
       RTS

L0663E MOVEQ   #-$06,D0
       RTS

L06642 ADDQ.W  #8,A7
       RTS

* initialise one of the Basic-#

L06646 MOVE.L  A0,-(A7)
       BSR.S   L0661E
       BEQ.S   L0669E
       CMPA.L  $0034(A6),A0
       BLT.S   L06680
       MOVE.L  D1,-(A7)
       MOVE.L  A0,D1
       ADDI.L  #$28,D1
       SUB.L   $34(A6),D1
       JSR     L04E7A(PC)
       MOVE.L  (A7)+,D1
       BSR.S   L0661E
L06668 MOVEA.L $0034(A6),A2
       ADDI.L  #$28,$0034(A6)
       MOVE.L  #$FFFFFFFF,$00(A6,A2.L)
       CMPA.L  A0,A2
       BLT.S   L06668
L06680 MOVEA.L A0,A2
       MOVEQ   #$0A,D0
L06684 CLR.L   $00(A6,A0.L)
       ADDQ.W  #4,A0
       SUBQ.W  #1,D0
       BGT.S   L06684
       MOVEA.L (A7)+,A0
       MOVE.L  A0,$00(A6,A2.L)
       MOVE.W  #$0050,$22(A6,A2.L)
o669A  MOVEQ   #$00,D0
       RTS

L0669E MOVEQ   #-$08,D0
       RTS

*----------------------
LCSIZE JSR     L08038(PC)
       BNE.S   L066C4
       SUBQ.W  #1,D3
       JSR     L08028(PC)
       BNE.S   L066C4
       MOVE.W  -$02(A6,A1.L),D2
       EXG     D1,D2
       CMPI.W  #$0003,D1
       BHI.S   L066C2
       MOVEQ   #$2D,D4
       JMP     L07FC4(PC)

L066C2 MOVEQ   #-$0F,D0
L066C4 RTS

*--------------------
LCURSOR MOVEQ   #-$20,D0
        ADD.L   A5,D0
       SUB.L   A3,D0
       BEQ     L06BE0
       MOVEQ   #$17,D4
       BRA.S   L066D6

LAT    MOVEQ   #$10,D4
L066D6 JSR     L08038(PC)
       BNE.S   L066F8
       CMPI.W  #$0002,D3
       BNE.S   L066F6
       MOVE.W  $00(A6,A1.L),D2
       MOVE.W  -$02(A6,A1.L),D1
       CMPI.B  #$10,D4
       BNE.S   L066F2
       EXG     D1,D2
L066F2 JMP     L07FC4(PC)

L066F6 MOVEQ   #-$0F,D0
L066F8 RTS
*-----------------

* position pointer to next instruction of precompiled Basic

L066FA MOVE.L  $0068(A6),-(A7)
       MOVE.L  $006E(A6),-(A7)
       MOVE.W  $006C(A6),-(A7)
       MOVE.L  A4,-(A7)
       JSR     L0958E(PC)
       BNE.S   L06784
       MOVE.W  $0094(A6),D4
       JSR     L09FA2(PC)
       JSR     L0A96A(PC)
       BNE.S   L06784
       MOVE.B  $0096(A6),D4
       JSR     L0A00A(PC)
       JSR     L0A56C(PC)
       CMPI.W  #$8118,D1
       BNE.S   L0674A
       MOVE.B  $0097(A6),D5
       ADDQ.B  #1,$0097(A6)
L06736 ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       SUBQ.B  #1,D5
       BEQ.S   L0676E
       MOVE.W  #$8404,D4
       JSR     L0A5E0(PC)
       BEQ.S   L06736
L0674A JSR     L0A60E(PC)
       BNE.S   L06784
       JSR     L0A56C(PC)
       CMPI.W  #$8118,D1
       BNE.S   L0674A
       ADDQ.W  #2,A4
       MOVE.W  $0068(A6),$0094(A6)
       MOVE.B  $006C(A6),$0096(A6)
       MOVE.B  #$02,$0097(A6)
L0676E MOVEA.L A4,A0
       MOVEQ   #$00,D0
L06772 MOVEA.L (A7)+,A4
       MOVE.W  (A7)+,$006C(A6)
       MOVE.L  (A7)+,$006E(A6)
       MOVE.L  (A7)+,$0068(A6)
       TST.L   D0
       RTS

L06784 MOVEQ   #-$0A,D0
       BRA.S   L06772
*---------------------
LADATE JSR     L061C2(PC)
       BNE.S   L067AE
       ADDQ.L  #4,$0058(A6)
       MOVE.L  $00(A6,A1.L),D1
       MOVEQ   #$15,D0
       TRAP    #$01
       BRA.S   L0680C
        
LSDATE JSR     L061E2(PC)
       BNE.S   L0680E
       MOVEQ   #-$0F,D0
       LSL.L   #2,D3
       ADD.L   D3,$0058(A6)
       LSR.L   #2,D3
       SUBQ.W  #6,D3
L067AE BNE.S   L0680E
       MOVE.L  $00(A6,A1.L),D0
       SUBI.L  #$7A9,D0
       MOVE.L  D0,D1
       MULU    #$016D,D1
       MOVE.L  $04(A6,A1.L),D2
       DIVU    #$0004,D0
       SWAP    D0
       CMPI.W  #$0003,D0
       BNE.S   L067D8
       CMPI.W  #$0002,D2
       BLE.S   L067D8
       ADDQ.L  #1,D1
L067D8 CLR.W   D0
       SWAP    D0
       ADD.L   D0,D1
       SUBQ.L  #1,D2
       ASL.W   #1,D2
       LEA     L06812(PC,D2.W),A2
       CLR.L   D0
       MOVE.W  (A2),D0
       ADD.L   D0,D1
       ADD.L   $08(A6,A1.L),D1
       SUBQ.W  #1,D1
       MOVEQ   #$18,D0
       BSR.S   L0682A
       ADD.L   $0C(A6,A1.L),D1
       MOVEQ   #$3C,D0
       BSR.S   L0682A
       ADD.L   $10(A6,A1.L),D1
       BSR.S   L0682A
       ADD.L   $14(A6,A1.L),D1
       MOVEQ   #$14,D0
       TRAP    #$01
L0680C MOVEQ   #$00,D0
L0680E TST.L   D0
       RTS
*------------------------
* table of days

L06812 DC.L   $0000001F
       DC.L   $003B005A
       DC.L   $00780097
       DC.L   $00B500D4
       DC.L   $00F30111
       DC.L   $0130014E

* multiply integer long in d0 wit interger long in d1

L0682A BSR.S   L0684E
       MOVE.L  D4,D3
       SWAP    D0
       SWAP    D1
       BSR.S   L0684E
       MOVE.L  D4,D2
       SWAP    D0
       SWAP    D3
       BSR.S   L0684E
       BSR.S   L06854
       SWAP    D0
       SWAP    D1
       BSR.S   L0684E
       BSR.S   L06854
       SWAP    D3
       SWAP    D0
       MOVE.L  D3,D1
       RTS

L0684E MOVE.L  D0,D4
       MULU    D1,D4
       RTS

L06854 ADD.W   D4,D3
       CLR.W   D4
       SWAP    D4
       ADDX.L  D4,D2
       RTS
       
*-----------------------
LREAD  MOVE.L  A5,-(A7)
L06860 CMPA.L  (A7),A3
       BGE.S   L06886
       JSR     L07A8E(PC)
       BNE.S   L06888
       JSR     L066FA(PC)
       BNE.S   L06888
       MOVE.B  $01(A6,A3.L),D0
       MOVE.L  A3,-(A7)
       JSR     L05A84(PC)
       MOVEA.L (A7)+,A3
       BNE.S   L06888
       JSR     L072C2(PC)
       ADDQ.W  #8,A3
       BRA.S   L06860

L06886 MOVEQ   #$00,D0
L06888 MOVEA.L (A7)+,A5
       RTS
*------------------------
LEXEC  MOVEQ   #$00,D5
       BRA.S   L06892

LEXECW MOVEQ   #-$01,D5
L06892 MOVEQ   #$01,D4
       BSR     L069C4
       BNE.S   L068F8
       MOVEQ   #$47,D0
       MOVEQ   #$0E,D2
       MOVEA.L (A6),A1
       BSR     L069A4
       BNE.S   L06912
       CMPI.B  #$01,-$09(A6,A1.L)
       BNE     L06990
       MOVEQ   #$01,D0
       MOVEQ   #-$01,D1
       MOVE.L  -$0E(A6,A1.L),D2
       MOVE.L  -$08(A6,A1.L),D3
       SUBA.L  A1,A1
       MOVEM.L D2/A0/A3,-(A7)
       TRAP    #$01
       MOVEA.L A0,A1
       MOVEM.L (A7)+,D2/A0/A3
       TST.L   D0
       BNE.S   L06912
       MOVE.L  D1,D6
       MOVEQ   #$48,D0
       BSR     L069A6
       BSR     L0693A
       BNE.S   L068FA
       MOVEQ   #$0A,D0
       MOVE.L  D6,D1
       MOVEQ   #$20,D2
       MOVE.L  D5,D3
       TRAP    #$01
       TST.L   D0
       BNE.S   L068FA
       TST.L   D5
       BNE.S   L068F8
       MOVEQ   #$08,D0
       MOVEQ   #-$01,D1
       MOVEQ   #$19,D3
       SUBA.L  A1,A1
       TRAP    #$01
L068F8 RTS

L068FA MOVE.L  D0,D4
       MOVEQ   #$04,D0
       MOVE.L  D6,D1
       TRAP    #$01
       MOVE.L  D4,D0
       RTS
*-----------------------

LLBYTES  MOVEQ   #$01,D4
       BSR     L069C4
       BNE.S   L068F8
       JSR     L061E2(PC)
L06912 BNE.S   L06986
       SUBQ.W  #1,D3
       BNE.S   L06990
       BTST    #$00,$03(A6,A1.L)
       BNE.S   L06990
       MOVEA.L $00(A6,A1.L),A1
       ADDQ.L  #4,$0058(A6)
       MOVEQ   #$47,D0
       MOVEQ   #$0E,D2
       MOVE.L  A1,-(A7)
       BSR.S   L069A6
       MOVEA.L (A7)+,A1
       BNE.S   L06986
       MOVE.L  (A1),D2
       MOVEQ   #$48,D0
       BSR.S   L069A6
L0693A BRA.S   L06986

*------------------
LSEXEC MOVEQ   #$01,D5
       BRA.S   L06942
        
LSBYTES MOVEQ   #$00,D5
L06942 MOVE.L  A3,$00B4(A6)
       MOVEQ   #$02,D4
       BSR.S   L069C4
       BNE.S   L0698E
       JSR     L061E2(PC)
       BNE.S   L06986
       SUBQ.W  #2,D3
       SUB.W   D5,D3
       BNE.S   L0699A
       MOVEA.L $00(A6,A1.L),A2
       ADDQ.W  #2,A1
       MOVE.L  $02(A6,A1.L),$00(A6,A1.L)
       MOVE.W  D5,$04(A6,A1.L)
       MOVEQ   #$46,D0
       MOVE.L  A1,-(A7)
       BSR.S   L069A4
       MOVEA.L (A7)+,A1
       BNE.S   L06986
       MOVE.L  $00(A6,A1.L),D2
       ADDQ.W  #6,A1
       LSL.W   #4,D5
       ADDA.W  D5,A1
       MOVE.L  A1,$0058(A6)
       MOVEA.L A2,A1
       MOVEQ   #$49,D0
       BSR.S   L069A6
L06986 MOVE.L  D0,D4
L06988 MOVEQ   #$02,D0
       TRAP    #$02
L0698C MOVE.L  D4,D0
L0698E RTS

L06990 MOVEQ   #-$0F,D0
       BRA.S   L06986

L06994 ADDQ.W  #4,A7
L06996 MOVEQ   #-$0F,D0
       RTS

L0699A BSR.S   L06988
       MOVEA.L $00B4(A6),A3
       BSR.S   L069E6
       BRA.S   L06996

*----------------
* trap#3 - execution

L069A4 TRAP    #$04
L069A6 MOVEQ   #-$01,D3
       TRAP    #$03
       TST.L   D0
       RTS
*-------------
* entry of variables name
L069AE CMPA.L  A5,A3
       BGE.S   L06994
       MOVE.L  A5,-(A7)
       ADDQ.W  #8,A3
       MOVEA.L A3,A5
       JSR     L064A2(PC)
       MOVEA.L (A7)+,A5
       BEQ.S   L0698E
       ADDQ.W  #4,A7
       RTS
       
* open channel for Basic
L069C4 BSR.S   L069AE
       MOVEQ   #$01,D0
       MOVEQ   #-$01,D1
       MOVE.L  D4,D3
L069CC MOVEA.L A1,A0
       MOVE.W  $00(A6,A1.L),-(A7)
       TRAP    #$04
       TRAP    #$02
       MOVEQ   #$03,D3
       ADD.W   (A7)+,D3
       BCLR    #$00,D3
       ADD.L   D3,$0058(A6)
       TST.L   D0
       RTS
       
*------------
LDELETE
L069E6 BSR.S   L069AE
       MOVEQ   #$04,D0
       BRA.S   L069CC

LDIR   JSR     L065E6(PC)
       BNE.S   L0698E
       MOVEA.L A0,A4
       MOVEQ   #$04,D4
       BSR.S   L069C4
       BNE.S   L0698E
       MOVEA.L A0,A5
       MOVEQ   #$45,D0
       MOVEA.L (A6),A1
       MOVEA.L A5,A0
       BSR.S   L069A4
       BNE.S   L06986
       MOVE.L  D1,-(A7)
       MOVEA.L (A6),A1
       MOVEQ   #$0A,D2
       BSR.S   L06A6A
       MOVEQ   #$05,D0
       MOVEQ   #$0A,D1
       TRAP    #$03
       MOVEM.W (A7)+,D1-D2
       BSR.S   L06A40
L06A1A MOVEQ   #$03,D0
       MOVEQ   #$40,D2
       MOVEA.L (A6),A1
       MOVEA.L A5,A0
       MOVEQ   #$00,D4
       BSR     L069A4
       BNE     L06988
       SUBA.W  #$0030,A1
       MOVE.W  -$02(A6,A1.L),D2
       BEQ.S   L06A1A
       BSR.S   L06A6A
       MOVEQ   #$05,D0
       MOVEQ   #$0A,D1
       TRAP    #$03
       BRA.S   L06A1A

*-- add numbers of sectors

L06A40 MOVE.W  D2,D4
       BSR.S   L06A5A
       MOVEQ   #$05,D0
       MOVE.B  #$2F,D1
       TRAP    #$03
       MOVE.W  D4,D1
       BSR.S   L06A5A
       MOVEQ   #-$17,D0
       JSR     L03968(PC)
       MOVEQ   #$00,D0
       RTS
       
*----------
* Add entire number

L06A5A MOVEA.L (A6),A1
       LEA     $0002(A1),A0
       MOVE.W  D1,$00(A6,A1.L)
       JSR     L03E54(PC)
       MOVE.W  D1,D2
L06A6A MOVEQ   #$07,D0
       MOVEA.L A4,A0
       MOVEQ   #-$01,D3
       BRA     L069A4
*---

LFORMAT JSR     L065E6(PC)
       BNE     L0698E
       MOVEA.L A0,A4
       BSR     L069AE
       MOVEQ   #$03,D0
       BSR     L069CC
       BNE     L0698E
       BRA.S   L06A40

LCOPY  MOVEQ   #$00,D5
       BRA.S   L06A94

LCOPYN MOVEQ   #-$01,D5
L06A94 MOVEQ   #$01,D4
       BSR     L069C4
       BNE     L0698E
       MOVEA.L A0,A4
       MOVEQ   #$02,D4
       BSR     L069C4
       BNE.S   L06B20
       TST.B   D5
       BNE.S   L06ACA
       MOVEQ   #-$01,D5
       MOVEA.L (A6),A1
       MOVEQ   #$47,D0
       MOVEQ   #$0E,D2
       EXG     A4,A0
       BSR     L069A4
       EXG     A4,A0
       BNE.S   L06ACA
       MOVEA.L (A6),A1
       MOVE.L  $00(A6,A1.L),D5
       MOVEQ   #$46,D0
       BSR     L069A4
L06ACA MOVEA.L (A6),A1
       MOVE.L  $0008(A6),D2
       SUB.L   A1,D2
       MOVEQ   #$00,D3
       EXG     A4,A0
       TST.L   D5
       BLE.S   L06AE0
       CMP.L   D5,D2
       BLE.S   L06AE0
       MOVE.L  D5,D2
L06AE0 TAS     $008F(A6)
       BEQ.S   L06B1E
       MOVEQ   #$03,D0
       TRAP    #$04
       TRAP    #$03
       CMPI.L  #$FFFFFFFF,D0
       BNE.S   L06AFA
       TST.W   D1
       BEQ.S   L06AE0
       BRA.S   L06B0C

L06AFA CMPI.L  #$FFFFFFF6,D0
       BNE.S   L06B08
       MOVEQ   #$00,D0
       TST.W   D1
       BEQ.S   L06B1E
L06B08 TST.L   D0
       BNE.S   L06B1E
L06B0C MOVEQ   #$07,D0
       MOVE.W  D1,D2
       EXG     A4,A0
       SUBA.W  D1,A1
       BSR     L069A4
       BNE.S   L06B1E
       SUB.L   D2,D5
       BNE.S   L06ACA
L06B1E BSR.S   L06B22
L06B20 EXG     A4,A0
L06B22 BRA     L06986

LCLOSE
L06B26 CMPA.L  A3,A5
       BLE.S   L06B44
       TST.B   $01(A6,A3.L)
       BPL.S   L06B44
       JSR     L065E6(PC)
       BNE.S   L06B42
       MOVE.L  #$FFFFFFFF,$00(A6,A2.L)
       MOVEQ   #$02,D0
       TRAP    #$02
L06B42 RTS

L06B44 MOVEQ   #-$0F,D0
       BRA.S   L06B42

LOPEN  MOVEQ   #$00,D4
       BRA.S   L06B52

LOPENIN MOVEQ   #$01,D4
       BRA.S   L06B52

LOPENNEW  MOVEQ   #$02,D4
L06B52    BSR.S   L06B26
          TST.L   D0
       BEQ.S   L06B5E
       MOVEQ   #-$06,D2
       CMP.L   D0,D2
       BNE.S   L06B42
L06B5E EXG     D1,D6
       BSR     L069C4
       EXG     D6,D1
       BNE.S   L06B42
       JMP     L06646(PC)

LSAVE  MOVE.L  A3,$00B4(A6)
       MOVEQ   #$02,D4
       BSR     L069C4
       BNE.S   L06B42
       JSR     L07484(PC)
       BEQ.S   L06B22
       MOVE.L  D0,D4
       BSR     L0699A
       BRA     L0698C

LFILL  JSR     L065E6(PC)
       BNE.S   L06BA4
       JSR     L061C2(PC)
       BNE.S   L06BA4
       MOVE.L  $00(A6,A1.L),D1
       ADDQ.L  #4,A1
       MOVE.L  A1,$0058(A6)
       MOVEQ   #$35,D0
       MOVEQ   #-$01,D3
       TRAP    #$03
L06BA4 RTS

LUNDER MOVE.B  #$2B,D4
       BRA.S   L06BB0

LFLASH MOVE.B  #$2A,D4
L06BB0 JSR     L08038(PC)
       BNE.S   L06BC0
       JSR     L08028(PC)
       BNE.S   L06BC0
L06BBC JMP     L07FC4(PC)

L06BC0 RTS

LOVER  JSR     L08038(PC)
       BNE.S   L06BC0
       MOVE.B  #$2C,D4
       MOVE.W  $00(A6,A1.L),D1
       CMPI.W  #$0001,D1
       BGT.S   L06BDC
       CMPI.W  #$FFFF,D1
       BGE.S   L06BBC
L06BDC MOVEQ   #-$0F,D0
       RTS

L06BE0 BSR     L06CB6
       JSR     L061DE(PC)
       BNE.S   L06BF2
       MOVEQ   #$36,D0
       MOVEQ   #-$01,D3
       TRAP    #$04
       TRAP    #$03
L06BF2 BRA     L06CAE

LSCALE MOVEQ   #$34,D4
       BSR     L06CB6
       BSR     L06D42
       BSR     L06D46
       BRA     L06C96

LPOINT MOVEQ   #$30,D4
       BRA.S   L06C10

LPOINTR MOVE.W  #$00B0,D4
L06C10 BSR     L06CB6
       BSR     L06D1C
       BRA.S   L06C96

LLINE  MOVEQ   #$31,D4
       BRA.S   L06C22

LLINER MOVE.W  #$00B1,D4
L06C22 BSR     L06CB6
       BSR     L06D0A
       BNE.S   L06CA4
       BSR     L06D1C
       BRA.S   L06C96
       
LCIRCLE
LELLIPS MOVEQ   #$33,D4
       BRA.S   L06C3A

LELLIPSR
LCIRCLER
       MOVE.W  #$00B3,D4
L06C3A BSR.S   L06CB6
       BSR     L06D1C
       BSR     L06D46
       CMPI.B  #$01,D5
       BNE.S   L06C50
       BSR     L06D42
       BRA.S   L06C68

L06C50 SUBQ.L  #8,A1
       SUBQ.L  #4,A1
       CLR.L   $00(A6,A1.L)
       MOVE.L  #$801,$04(A6,A1.L)
       MOVE.L  #$40000000,$08(A6,A1.L)
L06C68 MOVEM.W $06(A6,A1.L),D0-D2
       MOVE.W  $0C(A6,A1.L),$06(A6,A1.L)
       MOVE.L  $0E(A6,A1.L),$08(A6,A1.L)
       MOVEM.W D0-D2,$0C(A6,A1.L)
       BRA.S   L06C96

LARC   MOVEQ   #$32,D4
       BRA.S   L06C8A
        
LARCR  MOVE.W  #$B2,D4
L06C8A BSR.S   L06CB6
       BSR.S   L06D0A
       BSR     L06D1C
       BSR     L06D46
L06C96 MOVE.L  D4,D0
       SWAP    D0
       BCLR    #$07,D0
       MOVEQ   #-$01,D3
       TRAP    #$04
       TRAP    #$03
L06CA4 CMPA.L  D6,A3
       BGE.S   L06CAC
       MOVE.L  A4,-(A7)
       MOVE.W  D5,D4
L06CAC MOVEQ   #$00,D0
L06CAE MOVE.L  D7,$0058(A6)
       MOVEA.L D7,A1
       RTS

* execution of graphic commands

L06CB6 SWAP    D4
       CLR.W   D4
       CLR.W   D5
       MOVE.L  $0058(A6),D7
       MOVE.L  A5,D6
       CMPA.L  D6,A3
       BLT.S   L06CCA
       MOVEQ   #-$0F,D0
       BRA.S   L06D06

L06CCA MOVE.B  $01(A6,A3.L),D0
       ANDI.B  #$0F,D0
       BNE.S   L06CDC
       JSR     L07452(PC)
       MOVE.W  D5,D4
       BRA.S   L06CEE

L06CDC BTST    #$07,$01(A6,A3.L)
       BEQ.S   L06CEE
       MOVE.B  $01(A6,A3.L),D4
       BCLR    #$07,D4
       LSR.B   #4,D4
L06CEE JSR     L065E6(PC)
       BNE.S   L06D06
       MOVE.W  #$0100,D1
       JSR     L04E4E(PC)
       MOVE.L  $0058(A6),D7
       MOVEA.L D7,A1
       MOVEA.L (A7),A4
       RTS

L06D06 ADDQ.L  #4,A7
       BRA.S   L06CAE

L06D0A CMPI.B  #$05,D4
       BNE.S   L06D1C
       BSR.S   L06D6E
       BSR.S   L06D7E
       MOVE.L  A1,$0058(A6)
       MOVEQ   #$00,D0
       RTS

L06D1C BSR.S   L06D4C
       BNE.S   L06D06
       BTST    #$17,D4
       BEQ.S   L06D2C
       BSR.S   L06D6E
       JSR     L04838(PC)
L06D2C BSR.S   L06D4C
       BNE.S   L06D06
       BTST    #$17,D4
       BEQ.S   L06D3C
       BSR.S   L06D7E
       JSR     L04838(PC)
L06D3C BSR.S   L06D8E
       MOVEQ   #$01,D0
       RTS

L06D42 BSR.S   L06D4C
       BNE.S   L06D06
L06D46 BSR.S   L06D4C
       BNE.S   L06D06
       RTS

L06D4C MOVE.L  A4,-(A7)
       CMPA.L  D6,A3
       BLT.S   L06D56
       MOVEQ   #-$0F,D0
       BRA.S   L06D6A

L06D56 MOVE.W  D5,D4
       JSR     L07452(PC)
       MOVEA.L A3,A5
       JSR     L05EC8(PC)
       BNE.S   L06D6A
       MOVEQ   #$02,D0
       JSR     L05996(PC)
L06D6A MOVEA.L (A7)+,A4
       RTS

L06D6E SUBQ.W  #6,A1
       MOVE.L  $0A(A6,A2.L),$00(A6,A1.L)
       MOVE.W  $0E(A6,A2.L),$04(A6,A1.L)
       RTS

L06D7E SUBQ.W  #6,A1
       MOVE.L  $04(A6,A2.L),$00(A6,A1.L)
       MOVE.W  $08(A6,A2.L),$04(A6,A1.L)
       RTS

L06D8E MOVE.L  $00(A6,A1.L),$04(A6,A2.L)
       MOVE.L  $04(A6,A1.L),$08(A6,A2.L)
       MOVE.L  $08(A6,A1.L),$0C(A6,A2.L)
       RTS

L06DA2 LEA     L06E22(PC),A1
L06DA6 MOVEM.L D1-D2/D5-D7/A0/A2-A3,-(A7)
       MOVEQ   #$08,D6
L06DAC MOVEQ   #$00,D7
       MOVEQ   #$00,D5
       MOVE.W  (A1)+,D5
       LSL.L   #3,D5
       MOVE.L  D5,D1
       MOVE.L  A1,-(A7)
       JSR     L04E60(PC)
       MOVE.L  D5,D1
       JSR     L04E72(PC)
       MOVEA.L (A7)+,A3
L06DC4 MOVEA.L A3,A1
       MOVE.W  (A3)+,D0
       BEQ.S   L06E0C
       ADDA.W  D0,A1
       MOVE.L  A1,-(A7)
       MOVE.B  (A3)+,D5
       MOVE.B  D5,-(A7)
       MOVE.B  D6,-(A7)
       MOVE.B  D5,D1
       MOVEA.L (A6),A1
L06DD8 MOVE.B  (A3)+,$00(A6,A1.L)
       ADDQ.W  #1,A1
       SUBQ.B  #1,D1
       BGT.S   L06DD8
       MOVE.L  A3,-(A7)
       MOVEA.L (A6),A3
       LEA     L08B5A(PC),A2
       MOVEA.L (A2),A2
       JSR     L08622(PC)
       BRA.S   L06E16
       MOVEA.L (A7)+,A3
       MOVE.B  (A7)+,D6
       MOVE.B  (A7)+,D5
       MOVE.L  (A7)+,$04(A6,A2.L)
       MOVE.B  D6,$00(A6,A2.L)
       MOVE.B  D7,$01(A6,A2.L)
       BTST    D7,D5
       BNE.S   L06DC4
       ADDQ.W  #1,A3
       BRA.S   L06DC4

L06E0C SUBQ.W  #8,D6
       BNE.S   L06E1C
       MOVEQ   #$09,D6
       MOVEA.L A3,A1
       BRA.S   L06DAC

L06E16 ADDA.W  #$000C,A7
       MOVEQ   #-$0C,D0
L06E1C MOVEM.L (A7)+,D1-D2/D5-D7/A0/A2-A3
       RTS

*****END BASIC2_ASM basic2_asm

**************
*
* BASIC3_ASM  basic3_asm
*
**************
L072C2 MOVEM.L D4/A0/A3-A5,-(A7)
       MOVE.B  $01(A6,A3.L),D0
       ANDI.B  #$0F,D0
       SUBQ.B  #2,D0
       BGT.S   L072EE
       BEQ.S   L072F8
       CMPI.B  #$03,$00(A6,A3.L)
       BEQ.S   L072E4
       ADDQ.B  #2,D0
       BGT.S   L07350
       BRA     L07396
       
L072E4 ADDQ.B  #2,D0
       BGT     L073B4
       BRA     L073BE
       
L072EE MOVEQ   #$02,D1
       BSR.S   L07308
       ADD.L   D1,$0058(A6)
       BRA.S   L07330
       
L072F8 MOVEQ   #$06,D1
       BSR.S   L07308
       MOVE.L  $02(A6,A1.L),$02(A6,A0.L)
       ADD.L   D1,$0058(A6)
       BRA.S   L07330
       
L07308 MOVE.L  $04(A6,A3.L),D4
       BGE.S   L07310
       BSR.S   L07338
L07310 MOVEA.L $0028(A6),A0
       ADDA.L  D4,A0
       MOVEA.L $0058(A6),A1
       MOVE.W  $00(A6,A1.L),$00(A6,A0.L)
L07320 MOVEQ   #$01,D0
       SUB.B   $00(A6,A3.L),D0
       BLT.S   L07334
       MOVE.B  #$02,$00(A6,A3.L)
       BRA.S   L07334
       
L07330 MOVEM.L (A7)+,D4/A0/A3-A5
L07334 MOVEQ   #$00,D0
       RTS
       
L07338 MOVEM.L A2-A3,-(A7)
       JSR     L04DF6(PC)
       MOVEM.L (A7)+,A2-A3
       MOVE.L  A0,D4
       SUB.L   $0028(A6),D4
       MOVE.L  D4,$04(A6,A3.L)
       RTS
       
L07350 BSR.S   L073C6
       ANDI.L  #$FFFF,D1
       MOVE.L  $04(A6,A3.L),D4
       BLT.S   L07382
       MOVEA.L $0028(A6),A0
       ADDA.L  D4,A0
       MOVEQ   #$01,D2
       ADD.W   $00(A6,A0.L),D2
       BCLR    #$00,D2
       CMP.W   D1,D2
       BEQ.S   L07388
       ADDQ.L  #2,D2
       MOVEM.L D1/A1/A3,-(A7)
       MOVE.L  D2,D1
       JSR     L04FE8(PC)
       MOVEM.L (A7)+,D1/A1/A3
L07382 ADDQ.L  #2,D1
       BSR.S   L07338
       SUBQ.L  #2,D1
L07388 BSR.S   L073DE
       BSR.S   L073EC
       MOVEQ   #$00,D0
       MOVEQ   #$00,D2
       BSR.S   L07400
       BSR.S   L07320
L07394 BRA.S   L07330

L07396 MOVE.B  #$01,$01(A6,A3.L)
       BSR.S   L073C6
       SUBQ.W  #1,D5
       ADDQ.W  #2,A2
       ADDA.W  D5,A2
       MOVEA.L A2,A0
       SUB.W   D5,D6
       MOVE.W  D6,D2
       BSR     L0743C
       ADDQ.W  #2,A1
L073B0 BSR.S   L07400
       BRA.S   L07394
       
L073B4 BSR.S   L073C6
       BSR.S   L0742C
       BSR.S   L073DE
       BSR.S   L073EC
       BRA.S   L073B0
       
L073BE BSR.S   L073C6
       BSR.S   L0742C
       BSR.S   L073DE
       BRA.S   L073B0
       
L073C6 MOVEA.L $0058(A6),A1
       MOVEQ   #$00,D1
       MOVE.W  $00(A6,A1.L),D1
       MOVE.W  D1,D0
       SWAP    D1
       MOVE.W  D0,D1
       ADDQ.W  #1,D1
       BCLR    #$00,D1
       RTS
       
L073DE MOVEA.L $0028(A6),A0
       ADDA.L  D4,A0
       MOVEA.L $0058(A6),A1
       ADDQ.W  #2,A1
       RTS
       
L073EC MOVE.W  -$02(A6,A1.L),$00(A6,A0.L)
       CMP.W   $00(A6,A0.L),D1
       BCC.S   L073FC
       MOVE.W  D1,$00(A6,A0.L)
L073FC ADDQ.W  #2,A0
       RTS
       
L07400 TST.W   D1
L07402 BEQ.S   L07412
       MOVE.B  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #1,A0
       ADDQ.W  #1,A1
       SUBQ.W  #1,D1
       BRA.S   L07402
       
L07412 TST.W   D2
L07414 BEQ.S   L07422
       MOVE.B  #$20,$00(A6,A0.L)
       ADDQ.W  #1,A0
       SUBQ.W  #1,D2
       BRA.S   L07414
       
L07422 ADDA.W  D0,A1
       MOVE.L  A1,$0058(A6)
       MOVEQ   #$00,D0
       RTS
       
L0742C MOVEA.L $04(A6,A3.L),A0
       ADDA.L  $0028(A6),A0
       MOVE.W  $06(A6,A0.L),D2
       MOVE.L  $00(A6,A0.L),D4
L0743C MOVE.W  D1,D0
       SWAP    D1
       CMP.W   D2,D1
       BHI.S   L0744A
       SUB.W   D1,D2
       SUB.W   D1,D0
       RTS
       
L0744A MOVE.W  D2,D1
       SUB.W   D2,D0
       MOVEQ   #$00,D2
       RTS
       
L07452 MOVE.B  $01(A6,A3.L),D5
       LSR.B   #4,D5
       ANDI.B  #$0F,$01(A6,A3.L)
       ADDQ.W  #8,A3
       RTS
       
LDLINE CMPA.L  A5,A3
       BGE     L0750E
       ST      D7
       JSR     L07E30(PC)
       BEQ.S   L07476
       ST      $00B8(A6)
L07474 RTS

L07476 BSR.S   L0747A
       BRA.S   L07492

L0747A MOVEQ   #$02,D1
       JMP     L065E8(PC)
       
LLIST  BSR.S   L0747A
       BLT.S   L07474
L07484 ST      $00AB(A6)
       CLR.W   $00BA(A6)
       CMPA.L  A5,A3
       BGE     L07512
L07492 MOVE.L  A5,-(A7)
L07494 CMPA.L  (A7),A3
       BGE.S   L074DE
       BSR.S   L07452
       BNE.S   L074A0
       MOVEQ   #$00,D4
       BRA.S   L074A6
       
L074A0 BSR.S   L074F0
       BNE.S   L074DA
       MOVE.W  D1,D4
L074A6 SUBQ.B  #5,D5
       BEQ.S   L074B6
       ADDQ.B  #5,D5
       MOVE.W  D4,D6
       BNE.S   L074CE
       TST.B   D7
       BNE.S   L07494
       BRA.S   L074BE
       
L074B6 CMPA.L  (A7),A3
       BGE.S   L074BE
       BSR.S   L07452
       BNE.S   L074C4
L074BE MOVE.W  #$7FFF,D6
       BRA.S   L074CE
       
L074C4 BSR.S   L074F0
       BNE.S   L074DA
       MOVE.W  D1,D6
       CMP.W   D4,D6
       BLT.S   L074DA
L074CE BSR.S   L07518
       CMPI.B  #$01,D5
       BEQ.S   L07494
       TST.B   D5
       BEQ.S   L074DE
L074DA MOVEQ   #-$0F,D0
       BRA.S   L074EC
       
L074DE TST.B   D7
       BEQ.S   L074EA
       MOVEQ   #$00,D2
       MOVEQ   #$00,D5
       JSR     L08FE6(PC)
L074EA MOVEQ   #$00,D0
L074EC MOVEA.L (A7)+,A5
       RTS
       
L074F0 MOVEA.L A3,A5
       JSR     L05EC8(PC)
       BNE.S   L07510
       MOVEQ   #$03,D0
       JSR     L05996(PC)
       BNE.S   L07510
       ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D1
       BGT.S   L0750E
       MOVEQ   #-$0F,D0
       RTS
       
L0750E MOVEQ   #$00,D0
L07510 RTS

L07512 MOVEQ   #$00,D4
       MOVE.W  #$7FFF,D6

L07518 MOVEA.L $0010(A6),A4
XL03518 EQU L07518-$4000
       CLR.L   $0068(A6)
       TST.W   D4
       BEQ.S   L07530
       MOVE.L  A0,-(A7)
       JSR     L09FBE(PC)
       MOVEA.L (A7)+,A0
       MOVE.W  D2,$0068(A6)
L07530 TST.B   D7
       BNE.S   L0753C
       LEA     L08B5A(PC),A2
       JMP     L090B6(PC)
       
L0753C CMP.W   $04(A6,A4.L),D6
       BLT.S   L0750E
       MOVE.L  A4,-(A7)
       MOVE.W  $006A(A6),-(A7)
L07548 CMPA.L  $0014(A6),A4
       BGE.S   L07588
       MOVE.W  $00(A6,A4.L),D1
       ADDQ.W  #2,A4
       ADD.W   D1,$006A(A6)
       ADDA.W  $006A(A6),A4
       CMP.W   $04(A6,A4.L),D6
       BGE.S   L07548
       MOVE.W  $00(A6,A4.L),D1
       ADD.W   $006A(A6),D1
       SUB.W   (A7)+,D1
       MOVE.W  D1,$00(A6,A4.L)
       MOVEA.L (A7)+,A2
L07572 MOVE.W  $00(A6,A4.L),$00(A6,A2.L)
       ADDQ.W  #2,A4
       ADDQ.W  #2,A2
       CMPA.L  $0014(A6),A4
       BLT.S   L07572
       MOVE.L  A2,$0014(A6)
L07586 BRA.S   L0750E

L07588 ADDQ.W  #2,A7
       MOVE.L  (A7)+,$0014(A6)
       BRA.S   L07586
       
*--------end LIST

LMODE  JSR     L061BE(PC)
       BNE.S   L075AC
       ADDQ.L  #2,$0058(A6)
       MOVE.W  #$0108,D1
       AND.W   D1,$00(A6,A1.L)
       BNE.S   L075A6
       MOVEQ   #$00,D1
L075A6 MOVEQ   #-$01,D2
       MOVEQ   #$10,D0
       TRAP    #$01
L075AC RTS


LNET   JSR     L061BE(PC)
       BNE.S   L075C4
       ADDQ.L  #2,$0058(A6)
       MOVE.B  $01(A6,A1.L),D1
       BLE.S   L075C6
       MOVE.B  D1,$00028037
L075C4 RTS

L075C6 MOVEQ   #-$0F,D0
       RTS
       
LINK   MOVEQ   #$29,D4
       BRA.S   L075D4
       
LSTRIP MOVEQ   #$28,D4
       BRA.S   L075D4
       
LPAPER MOVEQ   #$27,D4
L075D4 JSR     L08038(PC)
       BNE.S   L075EE
       BSR     L07FD4
       BNE.S   L075EE
       CMPI.B  #$27,D4
       BNE.S   L075EA
       BSR.S   L075EA
       MOVEQ   #$28,D4
L075EA JMP     L07FC4(PC)

L075EE RTS

LCLS   MOVEQ   #$20,D4
       BRA.S   L075FA
       
LPAN   MOVEQ   #$1B,D4
       BRA.S   L075FA
       
LSCROLL MOVEQ   #$18,D4
L075FA JSR     L08038(PC)
       BNE.S   L07642
       MOVE.W  $00(A6,A1.L),D1
       CMPI.B  #$20,D4
       BEQ.S   L0760E
       SUBQ.L  #2,A1
       SUBQ.L  #1,D3
L0760E SUBQ.W  #1,D3
       BHI.S   L07640
       BLT.S   L0762C
       MOVE.W  D4,D3
       SUBI.W  #$0017,D3
       LSR.W   #2,D3
       LEA     L07644(PC),A2
       BTST    D1,$00(A2,D3.W)
       BEQ.S   L07640
       ADD.L   D1,D4
       MOVE.W  $00(A6,A1.L),D1
L0762C JSR     L090A2(PC)
       BNE.S   L0763C
       MOVE.L  $0040(A6),$0044(A6)
       CLR.W   $009E(A6)
L0763C JMP     L07FC4(PC)

L07640 MOVEQ   #-$0F,D0
L07642 RTS

L07644 BTST    D3,(A1)+
       MOVE.B  D0,-(A7)
LPAUSE JSR     L061DA(PC)
       SUBQ.W  #1,D3
       BLT.S   L0765A
       BGT.S   L07668
       ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),D3
L0765A MOVEQ   #$00,D1
       JSR     L0661E(PC)
       MOVEQ   #$01,D0
       TRAP    #$03
       MOVEQ   #$00,D0
       RTS
       
L07668 MOVEQ   #-$0F,D0
       RTS
       
LPOKE  MOVEQ   #$00,D4
       BSR.S   L07682
       MOVE.B  D1,(A4)
       RTS
       
LPOKEW BSR.S   L07680
       MOVE.W  D1,(A4)
       RTS
       
LPOKEL BSR.S   L07680
       MOVE.L  D1,(A4)
       RTS
       
L07680 MOVEQ   #$01,D4
L07682 JSR     L061E2(PC)
       BNE.S   L076A4
       SUBQ.W  #2,D3
       BNE.S   L076A0
       ADDQ.L  #8,$0058(A6)
       MOVEA.L $00(A6,A1.L),A4
       MOVE.L  $04(A6,A1.L),D1
       MOVE.L  A4,D0
       AND.L   D4,D0
       BNE.S   L076A0
       RTS
L076A0 ADDQ.W  #4,A7
       MOVEQ   #-$0F,D0
L076A4 RTS

LINPUT ST      D7
LPRINT JSR     L04E4C(PC)
       MOVEQ   #$00,D4
       JSR     L065E6(PC)
       BNE     L0784E
       MOVE.L  A5,-(A7)
       MOVEA.L A2,A5
       MOVEQ   #$00,D5
       TST.B   D7
       BEQ.S   L076D0
       MOVEQ   #$0B,D0
       MOVEA.L (A6),A1
       BSR     L0796E
       CMPI.W  #$FFF1,D0
       BNE.S   L076D0
       MOVEQ   #$01,D7
L076D0 CMPA.L  (A7),A3
       BGE     L0783E
       MOVE.B  $01(A6,A3.L),D0
       MOVE.B  D0,D5
       LSR.B   #4,D5
       ANDI.B  #$0F,D0
       BNE.S   L076F2
       TST.B   $00(A6,A3.L)
       BNE.S   L076F2
       BSR     L0795A
       BRA     L07832
       
L076F2 TST.W   $02(A6,A3.L)
       SGE     D1
       AND.B   D7,D1
       BEQ.S   L07714
       MOVE.W  D0,-(A7)
       BSR     L0795A
       MOVE.W  (A7)+,D0
       MOVEA.L (A7),A4
       JSR     L07A0C(PC)
       BNE     L07850
       MOVE.L  A4,(A7)
       BRA     L07832
       
L07714 TST.B   D7
       BGT     L07838
       MOVEA.L $0028(A6),A0
       MOVE.L  $04(A6,A3.L),D1
       BLT     L07828
       ADDA.L  D1,A0
       CMPI.B  #$03,$00(A6,A3.L)
       BNE     L07824
       TST.B   D5
       BEQ.S   L07740
       CMPI.B  #$05,D5
       BNE.S   L07742
       SWAP    D5
       BRA.S   L07742
       
L07740 MOVEQ   #$03,D5
L07742 MOVE.B  D0,-(A7)
       MOVEA.L A0,A2
       BSR     L0781A
       SUBA.L  $0028(A6),A2
       SUBA.L  $0030(A6),A5
       MOVEM.L A2-A3/A5,-(A7)
       JSR     L04DF6(PC)
       MOVEM.L (A7)+,A2-A3/A5
       ADDA.L  $0030(A6),A5
       ADDA.L  $0028(A6),A2
       MOVEA.L A0,A4
L07768 SUBQ.W  #1,D1
       LEA     $00(A4,D1.W),A1
       SF      $00(A6,A1.L)
       BNE.S   L07768
       MOVE.W  $04(A6,A2.L),D1
       MOVE.B  (A7),D0
       SUBQ.B  #2,D0
       BLT.S   L07788
       BEQ.S   L07784
       MOVEQ   #$02,D0
       BRA.S   L0778C
       
L07784 MOVEQ   #$06,D0
       BRA.S   L0778C
       
L07788 SUBQ.W  #1,D1
       MOVEQ   #$01,D0
L0778C MOVE.W  D0,$00(A6,A4.L)
       LSL.W   #1,D1
       MOVE.W  D1,$02(A6,A4.L)
L07796 MOVEA.L $0028(A6),A0
       ADDA.L  $00(A6,A2.L),A0
       MOVE.W  $04(A6,A2.L),D0
       LSL.W   #2,D0
       LEA     $02(A2,D0.W),A1
       MOVE.W  $00(A6,A1.L),D3
       LSR.W   #1,D0
L077AE LEA     $02(A4,D0.W),A1
       MOVE.W  $00(A6,A1.L),D1
       LSL.W   #1,D0
       LEA     $04(A2,D0.W),A1
       LSR.W   #1,D0
       MULU    $00(A6,A1.L),D1
       MULU    $00(A6,A4.L),D1
       ADDA.L  D1,A0
       SUBQ.W  #2,D0
       BNE.S   L077AE
       MOVE.B  (A7),D0
       BSR     L0785E
       BNE.S   L077FE
       MOVE.W  $02(A6,A4.L),D0
       BEQ.S   L077FE
L077DA LSL.W   #1,D0
       LEA     $02(A2,D0.W),A1
       MOVE.W  $00(A6,A1.L),D1
       LSR.W   #1,D0
       LEA     $02(A4,D0.W),A1
       CMP.W   $00(A6,A1.L),D1
       BEQ.S   L077F6
       ADDQ.W  #1,$00(A6,A1.L)
       BRA.S   L07796
       
L077F6 CLR.W   $00(A6,A1.L)
       SUBQ.W  #2,D0
       BNE.S   L077DA
L077FE BSR.S   L0781A
       MOVEA.L A4,A0
       MOVE.L  D0,-(A7)
       MOVE.L  A3,-(A7)
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A3
       MOVE.L  (A7)+,D0
       ADDQ.W  #2,A7
       BNE.S   L0784C
       TST.B   D5
       BNE.S   L07838
       SWAP    D5
       BRA.S   L07832
       
L0781A MOVEQ   #$02,D1
       ADD.W   $04(A6,A2.L),D1
       LSL.W   #1,D1
       RTS
       
L07824 BSR.S   L0785E
       BRA.S   L07836
       
L07828 BSR     L0795A
       MOVEQ   #$2A,D1
       BSR     L07960
L07832 BSR     L078E0
L07836 BNE.S   L0784C
L07838 ADDQ.W  #8,A3
       BRA     L076D0
       
L0783E TST.B   D5
       BNE.S   L0784A
       TST.B   D7
       BGT.S   L0784A
       BSR     L07934
L0784A MOVEQ   #$00,D0
L0784C MOVEA.L (A7)+,A5
L0784E RTS

L07850 MOVE.L  A4,(A7)
       MOVE.L  D0,-(A7)
       MOVEQ   #$0F,D0
       BSR     L07970
       MOVE.L  (A7)+,D0
       BRA.S   L0784C
       
L0785E MOVEA.L $0058(A6),A1
       SUBQ.W  #6,A1
       TST.B   D0
       BEQ.S   L07878
       SUBQ.B  #2,D0
       BGT.S   L0787E
       BEQ.S   L0788E
       MOVE.W  $00(A6,A0.L),D2
       MOVEA.L A0,A1
       ADDQ.W  #2,A1
       BRA.S   L078AA
       
L07878 MOVEA.L A0,A1
       MOVE.W  D3,D2
       BRA.S   L078AA
       
L0787E MOVE.W  $00(A6,A0.L),$00(A6,A1.L)
       MOVEA.L (A6),A0
       ADDQ.W  #1,A0
       JSR     L03E54(PC)
       BRA.S   L078A2
       
L0788E MOVE.L  $02(A6,A0.L),$02(A6,A1.L)
       MOVE.W  $00(A6,A0.L),$00(A6,A1.L)
       MOVEA.L (A6),A0
       ADDQ.W  #1,A0
       JSR     L03EF6(PC)
L078A2 MOVEA.L (A6),A1
       ADDQ.W  #1,A1
       MOVE.L  A0,D2
       SUB.L   A1,D2
L078AA TST.B   D4
       BEQ.S   L078D2
       SWAP    D4
       ADDQ.W  #1,D2
       SUBQ.W  #1,A1
       MOVE.B  $00(A6,A1.L),-(A7)
       SUB.W   D2,D4
       BLT.S   L078C4
       MOVE.B  #$20,$00(A6,A1.L)
       BRA.S   L078D0
       
L078C4 MOVE.B  #$0A,$00(A6,A1.L)
       MOVE.W  #-1,$20(A6,A5.L)
L078D0 SWAP    D4
L078D2 BSR     L07968
       TST.B   D4
       BEQ.S   L078E0
       SUBA.W  D2,A1
       MOVE.B  (A7)+,$00(A6,A1.L)
L078E0 TAS     $008F(A6)
       BNE.S   L078E8
       MOVEQ   #-$01,D0
L078E8 TST.L   D0
       BNE.S   L07958
       TST.B   D7
       BGT.S   L07956
       SF      D4
       CMPI.B  #$01,D5
       BEQ.S   L0793E
       CMPI.B  #$03,D5
       BEQ.S   L07934
       CMPI.B  #$04,D5
       BEQ.S   L07926
       CMPI.B  #$05,D5
       BNE.S   L07956
       MOVE.L  A5,-(A7)
       ADDQ.W  #8,A3
       LEA     $0008(A3),A5
       JSR     L061BE(PC)
       MOVEA.L (A7)+,A5
       BNE.S   L07958
       MOVE.W  $00(A6,A1.L),D2
       ADDQ.L  #2,$0058(A6)
       BSR.S   L0797A
       BRA.S   L0794A
       
L07926 BSR.S   L0797A
       SUB.W   D0,D1
       MOVE.W  D1,D4
       SWAP    D4
       TST.W   D0
       SNE     D4
       BRA.S   L07956
       
L07934 MOVEQ   #$0A,D1
       BSR.S   L07960
       CLR.W   $20(A6,A5.L)
       BRA.S   L07956
       
L0793E BSR.S   L0797A
       MOVE.W  D0,D2
       ADDQ.W  #8,D2
       ANDI.W  #$00F8,D2
       SUBQ.W  #8,D1
L0794A SUB.W   D2,D1
       BLT.S   L07934
       SUB.W   D0,D2
L07950 BSR.S   L0795E
       SUBQ.W  #1,D2
       BGT.S   L07950
L07956 MOVEQ   #$00,D0
L07958 RTS

L0795A TST.B   D4
       BEQ.S   L07958
L0795E MOVEQ   #$20,D1
L07960 MOVEQ   #$05,D0
       ADDQ.W  #1,$20(A6,A5.L)
       BRA.S   L07970
       
L07968 MOVEQ   #$07,D0
       ADD.W   D2,$20(A6,A5.L)
L0796E TRAP    #$04
L07970 MOVEQ   #-$01,D3
       MOVEA.L $00(A6,A5.L),A0
       TRAP    #$03
       RTS

L0797A MOVEQ   #$0B,D0
       MOVEA.L (A6),A1
       BSR.S   L0796E
       TST.L   D0
       BNE.S   L0798E
       MOVE.W  $04(A6,A1.L),D0
       MOVE.W  $00(A6,A1.L),D1
       RTS

L0798E MOVE.W  $22(A6,A5.L),D1
       MOVE.W  $20(A6,A5.L),D0
       RTS
       
LRANDOMISE JSR     L061E2(PC)
       BNE.S   L079BE
       SUBQ.W  #1,D3
       BGT.S   L079C0
       BEQ.S   L079AA
       MOVEQ   #$13,D0
       TRAP    #$01
       BRA.S   L079B4
       
L079AA MOVE.L  $00(A6,A1.L),D1
       ADDQ.L  #4,$0058(A6)
       MOVEQ   #$00,D0
L079B4 MOVE.L  D1,D2
       SWAP    D1
       ADD.L   D2,D1
       MOVE.L  D1,$0080(A6)
L079BE RTS

L079C0 MOVEQ   #-$0F,D0
       RTS

L079C4 MOVE.L  D0,-(A7)
       MOVEQ   #$00,D4
L079C8 MOVEQ   #$04,D0
       TRAP    #$04
       MOVEA.L $0004(A6),A1
       MOVE.L  $0008(A6),D2
       SUB.L   (A6),D2
       MOVE.L  A1,D1
       SUB.L   (A6),D1
       MOVE.W  D1,D4
       MOVE.L  D4,D1
       TST.L   (A7)
       BEQ.S   L079E6
       MOVEQ   #$02,D0
       SUB.W   D1,D2
L079E6 MOVEQ   #-$01,D3
       TRAP    #$03
       TST.L   D0
       BGE.S   L07A06
       CMPI.B  #$FB,D0
       BNE.S   L07A06
       MOVE.L  D1,D4
       MOVE.L  A1,$0004(A6)
       MOVE.L  A0,-(A7)
       MOVEQ   #$7E,D1
       JSR     L04E6A(PC)
       MOVEA.L (A7)+,A0
       BRA.S   L079C8
       
L07A06 ADDQ.W  #4,A7
L07A08 TST.L   D0
       RTS

L07A0C MOVE.L  D7,-(A7)
       MOVE.W  D0,-(A7)
       BSR.S   L07A8E
       BEQ.S   L07A1A
L07A14 ADDQ.W  #2,A7
L07A16 MOVE.L  (A7)+,D7
       BRA.S   L07A08
       
L07A1A MOVEA.L $00(A6,A5.L),A0
       MOVE.L  (A6),$0004(A6)
       TST.B   D7
       SGT     D0
       SUBA.L  $0008(A6),A3
       SUBA.L  $0008(A6),A4
       SUBA.L  $0008(A6),A5
       MOVEM.L A3-A5,-(A7)
       BSR.S   L079C4
       MOVEM.L (A7)+,A3-A5
       ADDA.L  $0008(A6),A3
       ADDA.L  $0008(A6),A4
       ADDA.L  $0008(A6),A5
       BNE.S   L07A14
       MOVE.L  A3,-(A7)
       MOVEQ   #$13,D0
       TRAP    #$03
       MOVEQ   #$14,D0
       TRAP    #$03
       MOVEA.L (A7)+,A3
       MOVEA.L (A6),A0
       MOVE.L  A1,D7
       MOVEA.L $0058(A6),A1
       MOVE.W  (A7)+,D0
       SUBQ.B  #2,D0
       BLT.S   L07A74
       BEQ.S   L07A6C
       JSR     L03DC2(PC)
       BRA.S   L07A70
       
L07A6C JSR     L03D16(PC)
L07A70 BNE.S   L07A16
       BRA.S   L07A7C
       
L07A74 MOVEA.L D7,A0
       SUBQ.W  #1,A0
       JSR     L05A20(PC)
L07A7C MOVE.L  A1,$0058(A6)
       SUBA.L  $0030(A6),A5
       JSR     L072C2(PC)
       ADDA.L  $0030(A6),A5
       BRA.S   L07A16
       
L07A8E MOVE.B  $00(A6,A3.L),D0
       SUBQ.B  #2,D0
       BLE.S   L07AC0
       SUBQ.B  #1,D0
       BNE.S   L07AB8
       MOVE.B  $01(A6,A3.L),D0
       ANDI.B  #$0F,D0
       SUBQ.B  #1,D0
       BGT.S   L07AC8
       MOVEA.L $04(A6,A3.L),A2
       ADDA.L  $0028(A6),A2
       CMPI.W  #$0001,$04(A6,A2.L)
       BGT.S   L07AC8
       BRA.S   L07AC0
       
L07AB8 SUBQ.B  #3,D0
       BLT.S   L07AC4
       SUBQ.B  #1,D0
       BGT.S   L07AC4
L07AC0 MOVEQ   #$00,D0
       RTS

L07AC4 MOVEQ   #-$0C,D0
       RTS

L07AC8 MOVEQ   #-$13,D0
       RTS

LRECOL JSR     L08038(PC)
       BNE.S   L07AF4
       CMPI.W  #$0008,D3
       BNE.S   L07AF2
       MOVEA.L A1,A2
       MOVEQ   #$07,D0
L07ADC MOVE.B  $01(A6,A2.L),$01(A6,A1.L)
       SUBQ.W  #2,A2
       SUBQ.W  #1,A1
       DBF     D0,L07ADC
       ADDQ.W  #2,A1
       MOVEQ   #$26,D4
       JMP     L07FC4(PC)
       
L07AF2 MOVEQ   #-$0F,D0
L07AF4 RTS

LEDIT  MOVEQ   #$00,D4
       BRA.S   L07AFC
       
LAUTO  MOVEQ   #$0A,D4
L07AFC ST      $00AA(A6)
       TST.B   $0090(A6)
       BNE.S   L07B32
       BRA.S   L07B26
       
L07B08 MOVEQ   #$00,D5
       CMPA.L  $0004(A7),A3
       BEQ.S   L07B20
       JSR     L07452(PC)
       BEQ.S   L07B20
       JSR     L074F0(PC)
       BEQ.S   L07B22
       ADDQ.W  #4,A7
       BRA.S   L07B84
       
L07B20 MOVEQ   #$01,D0
L07B22 RTS

LRENUM MOVEQ   #$0A,D4
L07B26 JSR     L07E30(PC)
       BEQ.S   L07B32
       ST      $00B8(A6)
       RTS

L07B32 MOVE.L  A5,-(A7)
       MOVE.W  #$7FFF,D7
       MOVEQ   #$64,D6
       SWAP    D4
       BSR.S   L07B08
       CMPI.B  #$05,D5
       BNE.S   L07B5A
       TST.B   D0
       BNE.S   L07B4A
       MOVE.W  D1,D4
L07B4A BSR.S   L07B08
       CMPI.B  #$02,D5
       BNE.S   L07B84
       TST.B   D0
       BNE.S   L07B66
       MOVE.W  D1,D7
       BRA.S   L07B66
       
L07B5A CMPI.B  #$02,D5
       BNE.S   L07B68
       TST.B   D0
       BNE.S   L07B66
       MOVE.W  D1,D4
L07B66 BSR.S   L07B08
L07B68 TST.B   D0
       BNE.S   L07B6E
       MOVE.W  D1,D6
L07B6E SWAP    D4
       CMPI.B  #$01,D5
       BNE.S   L07B7C
       BSR.S   L07B08
       BNE.S   L07B7C
       MOVE.W  D1,D4
L07B7C MOVE.W  D4,D3
       SWAP    D4
       TST.B   D5
       BEQ.S   L07B94
L07B84 SF      $00AA(A6)
       ADDQ.W  #4,A7
       MOVEQ   #-$0F,D0
       RTS
       
L07B8E ADDQ.W  #2,A7
       MOVEQ   #-$04,D0
       RTS
       
L07B94 MOVE.W  D7,D5
       ADDQ.W  #4,A7
       TST.B   $00AA(A6)
       BEQ.S   L07BAA
       MOVE.W  D6,$00AC(A6)
       MOVE.W  D3,$00AE(A6)
L07BA6 MOVEQ   #$00,D0
       RTS
       
L07BAA MOVEA.L $0010(A6),A4
       CMPA.L  $0014(A6),A4
       BGE.S   L07BA6
       CLR.W   -(A7)
       CLR.L   $0068(A6)
       TST.W   D4
       BEQ.S   L07BD8
       JSR     L09FBE(PC)
       CMPA.L  (A6),A4
       BEQ.S   L07BD8
       SUBA.W  $006A(A6),A4
       MOVE.W  $02(A6,A4.L),D2
       CMP.W   D2,D6
       BLE.S   L07B8E
       ADDA.W  $006A(A6),A4
       MOVE.W  D2,(A7)
L07BD8 MOVEQ   #$00,D0
L07BDA ADDQ.W  #1,D0
       BSR.S   L07C4E
       BEQ.S   L07BDA
       BGT.S   L07BE6
       MOVE.W  #$7FFF,D2
L07BE6 MOVE.L  D0,D1
       SUBQ.W  #1,D1
       MULU    D3,D1
       ADD.L   D6,D1
       EXT.L   D2
       CMP.L   D2,D1
       BGE.S   L07B8E
       MOVE.W  D2,-(A7)
       MOVEQ   #$02,D1
       ADD.L   D0,D1
       LSL.L   #2,D1
       JSR     L04DF6(PC)
       MOVEA.L A0,A3
       SUBA.L  $0028(A6),A3
       MOVE.L  D1,$00(A6,A0.L)
       SUBA.W  $006A(A6),A4
       MOVE.W  $02(A6,A4.L),$0068(A6)
       ADDA.W  $006A(A6),A4
       JSR     L09FBE(PC)
       BSR     L07D56
       MOVE.W  D6,D0
       MOVE.W  $04(A6,A4.L),D2
       MOVE.W  $0002(A7),D6
       SWAP    D4
L07C2C MOVE.W  D2,$00(A6,A0.L)
       MOVE.W  D0,$02(A6,A0.L)
       MOVE.W  D0,$04(A6,A4.L)
       ADDQ.W  #4,A0
       ADD.W   D4,D0
       BSR.S   L07C4E
       BEQ.S   L07C2C
       MOVE.W  (A7),D5
       MOVE.W  D5,$00(A6,A0.L)
       MOVE.W  D5,$02(A6,A0.L)
       ADDQ.W  #4,A7
       BRA.S   L07C7A
       
L07C4E MOVE.W  $00(A6,A4.L),D1
       ADDQ.W  #2,A4
       ADD.W   D1,$006A(A6)
       ADDA.W  $006A(A6),A4
       CMPA.L  $0014(A6),A4
       BGE.S   L07C72
       MOVE.W  $04(A6,A4.L),D2
       CMP.W   D2,D5
       BLT.S   L07C6E
       MOVEQ   #$00,D1
       RTS
       
L07C6E MOVEQ   #$01,D1
       RTS
       
L07C72 MOVEQ   #-$01,D1
       RTS
       
L07C76 JMP     L0A56C(PC)

L07C7A ST      $008E(A6)
       JSR     L0958E(PC)
       BRA.S   L07C8A
       
L07C84 JSR     L0A60E(PC)
       BNE.S   L07D06
L07C8A BSR.S   L07C76
       CMPI.W  #$8111,D1
       BEQ.S   L07CB2
       CMPI.W  #$810A,D1
       BEQ.S   L07CAE
       CMPI.W  #$8115,D1
       BNE.S   L07C84
L07C9E JSR     L09072(PC)
       JSR     L09686(PC)
       BEQ.S   L07C84
       CMPI.W  #$810A,D1
       BNE.S   L07C9E
L07CAE ADDQ.W  #2,A4
       BSR.S   L07C76
L07CB2 ADDQ.W  #2,A4
       BSR.S   L07C76
       CMPI.W  #$840A,D1
       BEQ.S   L07C84
       SUBI.W  #$F000,D1
       BGE.S   L07CCE
L07CC2 MOVE.W  #$8404,D4
       JSR     L0A5E0(PC)
       BNE.S   L07C84
       BRA.S   L07CB2
       

L07CCE MOVEA.L $0058(A6),A1
       SUBQ.W  #6,A1
       MOVE.W  D1,$00(A6,A1.L)
       MOVE.L  $02(A6,A4.L),$02(A6,A1.L)
       JSR     L04796(PC)
       MOVE.W  $00(A6,A1.L),D1
       BSR.S   L07D60
       BLE.S   L07CC2
       MOVE.W  D1,$00(A6,A1.L)
       JSR     L047B8(PC)
       MOVE.W  $00(A6,A1.L),D0
       ADDI.W  #$F000,D0
       MOVE.W  D0,$00(A6,A4.L)
       MOVE.L  $02(A6,A1.L),$02(A6,A4.L)
       BRA.S   L07CC2
       
L07D06 MOVE.W  $009C(A6),D1
       BSR.S   L07D60
       MOVE.W  D1,$009C(A6)
       MOVE.W  $009E(A6),D1
       BSR.S   L07D60
       MOVE.W  D1,$009E(A6)
       MOVE.W  $00A0(A6),D1
       BSR.S   L07D60
       MOVE.W  D1,$00A0(A6)
       MOVEA.L $0040(A6),A1
       MOVE.W  $00(A6,A1.L),D1
       BSR.S   L07D60
       MOVE.W  D1,$00(A6,A1.L)
       ST      $006D(A6)
       BSR.S   L07D56
       SUBQ.W  #4,A0
       MOVE.L  $00(A6,A0.L),D1
       JSR     L04FE8(PC)
       MOVEQ   #$00,D2
       MOVEQ   #$00,D5
       SUBA.L  A0,A0
       JSR     L090A2(PC)
       MOVEA.L D0,A0
       JSR     L08FE6(PC)
       MOVEQ   #$00,D0
       RTS
       
L07D56 MOVEA.L $0028(A6),A0
       ADDA.L  A3,A0
       ADDQ.W  #4,A0
       RTS
       
L07D60 CMP.W   D6,D1
       BLE.S   L07D76
       CMP.W   D1,D5
       BLT.S   L07D76
       BSR.S   L07D56
L07D6A CMP.W   $00(A6,A0.L),D1
       ADDQ.W  #4,A0
       BGT.S   L07D6A
       MOVE.W  -$02(A6,A0.L),D1
L07D76 RTS

LREPORT MOVEQ   #$00,D1
       JSR     L065E8(PC)
       MOVE.L  $00C2(A6),D0
       MOVE.W  $0068(A6),-(A7)
       MOVE.W  $00C6(A6),$0068(A6)
       JSR     L09BDC(PC)
       MOVE.W  (A7)+,$0068(A6)
       MOVEQ   #$00,D0
       RTS
       
LCLEAR MOVEQ   #$00,D6
       MOVEQ   #$00,D0
       MOVE.W  #-1,$0088(A6)
       BRA.S   L07DE0
       
LRUN   JSR     L061DA(PC)
       BNE.S   L07E1E
       MOVEQ   #$06,D6
       MOVE.W  D7,$0088(A6)
       SUBQ.W  #1,D3
       BLT.S   L07E14
       BEQ.S   L07DBA
       MOVEQ   #-$0F,D0
       RTS

L07DBA MOVE.W  $00(A6,A1.L),$0088(A6)
       MOVE.B  D7,$008A(A6)
       ADDQ.L  #2,$0058(A6)
       BRA.S   L07E14

LMERGE BSR.S   L07E30
       MOVEQ   #$0E,D6
       TST.B   $006F(A6)
       BNE.S   L07DF6
LMRUN  BSR.S   L07E30
       MOVEQ   #$0C,D6
       BSR.S   L07E20
       BNE.S   L07E0E
       MOVE.W  D7,$0088(A6)
L07DE0 TST.B   $006F(A6)
       BNE.S   L07E14
       MOVE.W  $0068(A6),$0088(A6)
       MOVE.B  $006C(A6),$008A(A6)
       BRA.S   L07E14
       
LLOAD  MOVEQ   #$0A,D6
L07DF6 BSR.S   L07E20
       BRA.S   L07E0E
       
LLRUN  MOVEQ   #$08,D6
       BSR.S   L07E20
       BNE.S   L07E0E
       MOVE.W  D7,$0088(A6)
       BRA.S   L07E14
       
LNEW   MOVEQ   #$02,D6
       BRA.S   L07E0C
       
LSTOP  MOVEQ   #$04,D6
L07E0C MOVEQ   #$00,D0
L07E0E MOVE.W  #-1,$0088(A6)
L07E14 SF      $006D(A6)
       MOVE.W  D6,$008C(A6)
       TST.L   D0
L07E1E RTS

L07E20 MOVEQ   #$01,D4
       JSR     L069C4(PC)
       BNE.S   L07E1E
       MOVE.L  A0,$0084(A6)
       MOVEQ   #$00,D0
       RTS
       
L07E30 TST.B   $0090(A6)
       BNE.S   L07E44
       MOVE.L  $003C(A6),D0
       SUB.L   $0038(A6),D0
       BEQ.S   L07E44
       ADDQ.W  #4,A7
       MOVEQ   #-$13,D0
L07E44 RTS
       
LRETRY SUBQ.B  #1,$0091(A6)
       BGE.S   L07E50
       SF      $0091(A6)
       
LCONTINUE
L07E50 SF      $00C0(A6)
       MOVEQ   #$10,D6
       BRA.S   L07E0C

LTRA   JSR     L061E2(PC)
       BNE.S   L07E8A
       CLR.L   D2
       SUBQ.W  #1,D3
       BEQ.S   L07E78
       SUBQ.W  #1,D3
       BNE.S   L07E8C
       ADDQ.L  #4,$0058(A6)
       MOVE.L  $04(A6,A1.L),D2
       BNE.S   L07E78
       MOVE.L  $BFE6,D2

L07E78 ADDQ.L  #4,$0058(A6)
       MOVE.L  $00(A6,A1.L),D1
       MOVEQ   #$24,D0
       TRAP    #$01
       TST.L   D0
       BMI.S   L07E8C
       MOVEQ   #$00,D0
L07E8A RTS
L07E8C MOVEQ   #-$0F,D0
       RTS

LTURNTO BSR     L07F24
       BNE.S   L07ED0
       BRA.S   L07EA6
       
LTURN  BSR     L07F24
       BNE.S   L07ED0
       BSR     L07F42
       JSR     L04838(PC)
L07EA6 LEA     L07F52(PC),A3
       LEA     $0006(A1),A4
       SUBQ.W  #6,A1
       MOVE.W  #$0809,$00(A6,A1.L)
       MOVE.L  #$5A000000,$02(A6,A1.L)
       JSR     L041B4(PC)
       MOVE.W  $00(A6,A1.L),$10(A6,A2.L)
       MOVE.L  $02(A6,A1.L),$12(A6,A2.L)
L07ECE MOVEQ   #$00,D0

L07ED0 RTS

LPENUP MOVEQ   #$00,D4
       BRA.S   L07ED8
       
LPENDOWN MOVEQ   #$01,D4
L07ED8 JSR     L065E6(PC)
       BNE.S   L07ED0
       MOVE.B  D4,$16(A6,A2.L)
       BRA.S   L07ECE
       
LMOVE  BSR.S   L07F24
       BNE.S   L07F22
       BSR.S   L07F42
       SUBQ.W  #6,A1
       MOVE.W  #$07FB,$00(A6,A1.L)
       MOVE.L  #$477D1A89,$02(A6,A1.L)
       JSR     L048DE(PC)
       JSR     L06D6E(PC)
       JSR     L06D7E(PC)
       LEA     L07F5A(PC),A3
       LEA     $0018(A1),A4
       JSR     L041B4(PC)
       JSR     L06D8E(PC)
       TST.B   $16(A6,A2.L)
       BEQ.S   L07ECE
       MOVEQ   #$31,D0
       TRAP    #$04
       TRAP    #$03
L07F22 RTS

L07F24 MOVE.W  #$0100,D1
       JSR     L04E4E(PC)
       JSR     L065E6(PC)
       BNE.S   L07F40
       MOVE.L  $0058(A6),-(A7)
       JSR     L061C6(PC)
       MOVE.L  (A7)+,$0058(A6)
       TST.L   D0
L07F40 RTS

L07F42 SUBQ.W  #6,A1
       MOVE.W  $10(A6,A2.L),$00(A6,A1.L)
       MOVE.L  $12(A6,A2.L),$02(A6,A1.L)
       RTS
       
* TABLE FOR TURN OPERATIONS
L07F52 DC.L    $FAF41004
       DC.L    $080E0C00
L07F5A DC.L    $FAF4180E
       DC.L    $EE0AFAF4
       DC.L    $1A0EE80A
       DC.W    $0000

LWIDTH JSR     L08038(PC)
       BNE.S   L07F78
       SUBQ.W  #1,D3
       BNE.S   L07F7A
       MOVE.W  $00(A6,A1.L),$22(A6,A2.L)
L07F78 RTS

L07F7A MOVEQ   #-$0F,D0
       RTS

LWINDOW JSR     L08038(PC)
       BNE.S   L07FA2
       MOVEQ   #$0D,D4
       MOVEQ   #-$80,D1
       CLR.W   D2
       BRA.S   L07F9C

LBLOCK JSR     L08038(PC)
       BNE.S   L07FA2
       MOVEQ   #$2E,D4
       SUBQ.W  #4,D3
       JSR     L07FD4(PC)
       BNE.S   L07FA2
L07F9C SUBQ.W  #6,A1
       JMP     L07FC4(PC)

L07FA2 RTS

LBORDER JSR     L08038(PC)
       BNE.S   L07FA2
       MOVEQ   #$0C,D4
       MOVEQ   #-$80,D1
       CMPI.W  #$0001,D3
       BLS.S   L07FBC
       SUBQ.W  #1,D3
       JSR     L07FD4(PC)
       BNE.S   L07FA2
L07FBC MOVE.W  $00(A6,A1.L),D2
       JMP     L07FC4(PC)

L07FC4 MOVE.L  D4,D0
       MOVEQ   #-$01,D3
       MOVE.L  A1,-(A7)
       TRAP    #$04
       TRAP    #$03
       MOVEA.L (A7)+,A1
       TST.L   D0
       RTS

L07FD4 MOVE.W  $00(A6,A1.L),D1
       SUBQ.L  #2,A1
       SUBQ.W  #1,D3
       BEQ.S   L0801A
       CMPI.W  #$0007,D1
       BHI.S   L08024
       ORI.W   #$0018,D1
       CMPI.W  #$0001,D3
       BEQ.S   L08004
       ANDI.W  #$0007,D1
       MOVE.W  $00(A6,A1.L),D2
       SUBQ.L  #2,A1
       SUBQ.W  #1,D3
       LSL.W   #3,D1
       CMPI.W  #$0007,D2
       BHI.S   L08024
       OR.W    D2,D1
L08004 MOVE.W  $00(A6,A1.L),D2
       SUBQ.L  #2,A1
       SUBQ.W  #1,D3
       BNE.S   L08024
       CMPI.W  #$0007,D2
       BHI.S   L08024
       EOR.W   D2,D1
       LSL.W   #3,D1
       OR.W    D2,D1
L0801A CMPI.W  #$00FF,D1
       BHI.S   L08024
L08020 MOVEQ   #$00,D0
       RTS

L08024 MOVEQ   #-$0F,D0
       RTS

L08028 CMPI.W  #$0001,D3
       BNE.S   L08024
       MOVE.W  $00(A6,A1.L),D1
       CMP.W   D3,D1
       BHI.S   L08024
       BRA.S   L08020
       
L08038 JSR     L065E6(PC)
       BNE.S   L08052
L0803E JSR     L061DA(PC)
       BNE.S   L08052
       ADD.L   D3,D3
       ADD.L   D3,$0058(A6)
       ADDA.L  D3,A1
       SUBQ.L  #2,A1
       LSR.W   #1,D3
       MOVEQ   #$00,D0
L08052 RTS

LACOS  LEA     L042E4(PC),A4
       BRA.S   L080C6
        
LACOT  LEA     L0431E(PC),A4
       BRA.S   L080C6
        
LASIN  LEA     L042F2(PC),A4
       BRA.S   L080C6
        
LATAN  LEA     L04326(PC),A4
       BRA.S   L080C6
        
LCOS   LEA     L0423E(PC),A4
       BRA.S   L080C6

LCOT   LEA     L0426A(PC),A4
       BRA.S   L080C6
        
LEXP   LEA     L044DE(PC),A4
       BRA.S   L080C6
        
LLN    LEA     L04446(PC),A4
       BRA.S   L080C6
        
LLOG10 LEA     L0442C(PC),A4
       BRA.S   L080C6
        
LSIN   LEA     L04236(PC),A4
       BRA.S   L080C6
        
LSQRT  LEA     L0452C(PC),A4
       BRA.S   L080C6
        
LTAN   LEA     L04262(PC),A4
       BRA.S   L080C6
        
LDEG   LEA     L0497E(PC),A4
       BRA.S   L080A6

LRAD    LEA     L048DE(PC),A4
L080A6 JSR     L061C6(PC)
       BNE.S   L080DE
       BSR     L08162
       SUBQ.W  #6,A1
       MOVE.W  #$07FB,$00(A6,A1.L)
       MOVE.L  #$477D1A89,$02(A6,A1.L)
       BRA.S   L080D6

LABS   LEA     L04A06(PC),A4
L080C6 JSR     L061C6(PC)
       BNE.S   L080DE
       MOVEQ   #$30,D1
       JSR     L04E4E(PC)
       MOVEA.L $0058(A6),A1
L080D6 JSR     (A4)
L080D8 MOVEQ   #$02,D4
L080DA MOVE.L  A1,$0058(A6)
L080DE RTS

L080E0 MOVEQ   #$03,D4
       MOVEQ   #$00,D0
       BRA.S   L080DA

o80E6  ADDQ.W  #4,A7
       RTS
       
LRND    MOVEQ   #$01,D5
       OR.L    $0080(A6),D5
       MOVE.L  D5,D6
       MULU    #$0163,D5
       SWAP    D6
       MULU    #$0163,D6
       SWAP    D6
       CLR.W   D6
       ADD.L   D6,D5
       MOVE.L  D5,$0080(A6)
       JSR     L061DA(PC)
       BNE.S   L080DE
       SUBQ.W  #1,D3
       BEQ.S   L0812A
       BGT.S   L08124
       BSR     L08162
       MOVE.L  D5,D1
       LSR.L   #1,D1
       MOVE.W  #$0800,D0
L0811E JSR     L04830(PC)
       BRA.S   L080D8

L08124 MOVE.W  $00(A6,A1.L),D3
       ADDQ.W  #2,A1
L0812A MOVE.W  $00(A6,A1.L),D2
       SUB.W   D3,D2
       BLT.S   L0819E
       ADDQ.W  #1,D2
       SWAP    D5
       MULU    D2,D5
       SWAP    D5
       ADD.W   D3,D5
L0813C MOVE.W  D5,$00(A6,A1.L)
       BRA.S   L080E0

LPI    CMPA.L  A3,A5
       BNE.S   L0819E
       BSR.S   L08162
       MOVE.W  #$0802,D0
       MOVE.L  #$6487ED51,D1
       BRA.S   L0811E

LINT   JSR     L061C2(PC)
       BNE.S   L080DE
       MOVE.L  $00(A6,A1.L),D1
       ADDQ.W  #4,A1
       BRA.S   L08186

L08162 JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       RTS

LPEEK  BSR.S   L0818C
       MOVEQ   #$00,D5
       MOVE.B  (A4),D5
       BRA.S   L0817A

LPEEKW BSR.S   L0818C
       BCS.S   L0819E
       MOVE.W  (A4),D5
L0817A ADDQ.W  #2,A1
       BRA.S   L0813C

LPEEKL BSR.S   L0818C
       BCS.S   L0819E
       MOVE.L  (A4),D1
L08184 ADDQ.W  #4,A1
L08186 MOVE.W  #$081F,D0
       BRA.S   L0811E

L0818C JSR     L061C2(PC)
       BNE     L0821A
       MOVEA.L $00(A6,A1.L),A4
       MOVE.L  A4,D1
       ROR.W   #1,D1
       RTS

L0819E MOVEQ   #-$0F,D0
L081A0 RTS

LRESPR BSR.S   L0818C
       MOVEQ   #$0E,D0
       MOVE.L  $00(A6,A1.L),D1
       MOVEA.L A1,A4
       TRAP    #$01
       MOVE.L  A0,D1
       MOVEA.L A4,A1
       TST.L   D0
       BEQ.S   L08184
       BRA.S   L081A0

LBEEPING CMPA.L  A3,A5
        BNE.S   L0819E
       BSR.S   L08162
       MOVEQ   #$01,D1
       AND.B   $00028096,D1
       BRA.S   L08186

LEOF   CMPA.L  A3,A5
       BNE.S   L081D6
       JSR     L066FA(PC)
       SUBQ.B  #1,$0097(A6)
       BRA.S   L081E0

L081D6 BSR     L0825A
       MOVEQ   #$00,D0
       MOVEQ   #$00,D3
       TRAP    #$03
L081E0 MOVEQ   #-$0A,D4
       SUB.L   D0,D4
       BSR     L08162
       MOVEQ   #$00,D1
       TST.L   D4
       BNE.S   L08186
       MOVEQ   #$01,D1
       BRA.S   L08186

LVERS  CMPA.L  A3,A5
       BNE.S   L0819E
       BSR     L08162
       SUBQ.W  #6,A1
       MOVE.L  $BFFA,$00(A6,A1.L)
       MOVE.W  $BFFE,$04(A6,A1.L)
       BRA.S   L08252

LINKEYS BSR.S   L0825A
        MOVE.L  A0,-(A7)
       BSR     L08162
       JSR     L061DA(PC)
L0821A BNE.S   L08262
       MOVEA.L (A7)+,A0
       CMPI.W  #$0001,D3
       BGT     L0819E
       BLT.S   L0822E
       MOVE.W  $00(A6,A1.L),D3
       ADDQ.W  #2,A1
L0822E MOVEA.L A1,A4
       MOVEQ   #$01,D0
       TRAP    #$03
       MOVEA.L A4,A1
       ADDQ.L  #1,D0
       BEQ.S   L0824C
       SUBQ.L  #1,D0
       BNE.S   L08264
       SUBQ.W  #4,A1
L08240 MOVE.B  D1,$02(A6,A1.L)
       MOVE.W  #$0001,$00(A6,A1.L)
       BRA.S   L08252

L0824C SUBQ.W  #2,A1
       CLR.W   $00(A6,A1.L)
L08252 MOVEQ   #$01,D4
       MOVEQ   #$00,D0
       BRA     L080DA

L0825A MOVEQ   #$00,D1
       JSR     L065E8(PC)
       BEQ.S   L08264
L08262 ADDQ.W  #4,A7
L08264 RTS

LCHRS  BSR     L08162
       JSR     L061BE(PC)
       BNE.S   L08264
       MOVE.W  $00(A6,A1.L),D1
       SUBQ.W  #2,A1
       BRA.S   L08240
       
LFILLS  SUBQ.W  #8,A5
        BSR.S   L082CE
       BEQ     L0819E
       SUBQ.L  #1,D1
       BGT.S   L0828A
       MOVE.B  $02(A6,A1.L),$03(A6,A1.L)
L0828A MOVE.W  $02(A6,A1.L),D5
       ADDQ.L  #4,D1
       BCLR    #$00,D1
       ADDA.L  D1,A1
       MOVE.L  A1,$0058(A6)
       MOVEA.L A5,A3
       ADDQ.W  #8,A5
       JSR     L061BE(PC)
       BNE.S   L08264
       ADDQ.L  #2,$0058(A6)
       MOVEQ   #$00,D4
       MOVE.W  $00(A6,A1.L),D4
       BLT     L0819E
       BEQ.S   L08252
       MOVE.L  D4,D1
       BSR.S   L082F2
L082B8 SUBQ.W  #2,A1
       MOVE.W  D5,$00(A6,A1.L)
       SUBQ.L  #2,D1
       BGT.S   L082B8
       MOVE.W  D4,$00(A6,A1.L)
       BRA.S   L08252

LLEN   BSR.S   L082CE
       MOVE.W  D1,D5
       BRA.S   L082E6

L082CE JSR     L061CA(PC)
       BNE.S   L08262
       MOVEQ   #$00,D5
       MOVEQ   #$00,D1
       MOVE.W  $00(A6,A1.L),D1
       RTS

LCODE  BSR.S   L082CE
       BEQ.S   L082EE
       MOVE.B  $02(A6,A1.L),D5
L082E6 ADDQ.L  #1,D1
       BCLR    #$00,D1
       ADDA.L  D1,A1
L082EE BRA     L0813C

L082F2 ADDQ.L  #3,D1
       BCLR    #$00,D1
       MOVE.L  D1,-(A7)
       JSR     L04E4E(PC)
       MOVEA.L $0058(A6),A1
       MOVE.L  (A7)+,D1
L08304 RTS

LDIMN  MOVE.B  $00(A6,A3.L),D1
       SUBQ.B  #3,D1
       BNE.S   L0834E
       MOVE.L  A3,-(A7)
       ADDQ.W  #8,A3
       JSR     L061DA(PC)
       MOVEA.L (A7)+,A3
       BNE.S   L08304
       SUBQ.W  #1,D3
       BGT.S   L08304
       BEQ.S   L08328
       BSR.S   L0836A
       SUBQ.W  #2,A1
       MOVEQ   #$01,D1
       BRA.S   L0832E

L08328 MOVE.W  $00(A6,A1.L),D1
       BLE.S   L08352
L0832E MOVEA.L $04(A6,A3.L),A2
       ADDA.L  $0028(A6),A2
       MOVE.W  $04(A6,A2.L),D2
       SUB.W   D1,D2
       BLT.S   L08352
       ADDQ.W  #2,A2
       LSL.W   #2,D1
       ADDA.W  D1,A2
       MOVE.W  $00(A6,A2.L),$00(A6,A1.L)
       BRA     L080E0

L0834E BSR.S   L0836A
       SUBQ.W  #2,A1
L08352 MOVEQ   #$00,D5
       BRA.S   L082EE

LDATE  CMPA.L  A3,A5
       BNE     L0819E
       BSR.S   L0836A
       MOVEQ   #$13,D0
       TRAP    #$01
       BCLR    #$1F,D1
       BRA     L08186

L0836A BRA     L08162

LKEYROW JSR     L061BE(PC)
        SUBQ.W  #8,A7
       BNE.S   L083B0
       MOVEA.L A7,A3
       MOVE.B  #$09,(A3)
       MOVE.B  #$01,$0001(A3)
       MOVE.L  #$0000,$0002(A3)
       MOVE.B  $01(A6,A1.L),$0006(A3)
       MOVE.B  #$02,$0007(A3)
       MOVE.L  A1,-(A7)
       MOVEQ   #$11,D0
       TRAP    #$01
       MOVEA.L (A7)+,A1
       MOVE.W  D1,$00(A6,A1.L)
       MOVEQ   #$03,D4
       MOVEA.L $0002804C,A2
       MOVE.L  $000C(A2),$0008(A2)
L083B0 ADDQ.W  #8,A7
       RTS

LDATES LEA     L0405E(PC),A4
       BRA.S   L083BE

LDAYS  LEA     L040BE(PC),A4
L083BE JSR     L04E4C(PC)
       CMPA.L  A3,A5
       BLE.S   L083D4
       JSR     L061C2(PC)
       BNE.S   L083E6
       MOVE.L  $00(A6,A1.L),D1
       ADDQ.L  #4,A1
       BRA.S   L083DC

L083D4 MOVEQ   #$13,D0
       TRAP    #$01
       MOVEA.L $0058(A6),A1
L083DC JSR     (A4)
       MOVEQ   #$01,D4
       MOVE.L  A1,$0058(A6)
       MOVEQ   #$00,D0
L083E6 RTS

LERRBL BSR.S   L08414
LERRRO BSR.S   L08414
LERRNI BSR.S   L08414
LERROV BSR.S   L08414
LERRXP BSR.S   L08414
LERRFE BSR.S   L08414
LERRBP BSR.S   L08414
LERRFF BSR.S   L08414
LERRTE BSR.S   L08414
LERRBN BSR.S   L08414
LERRDF BRA.S   L08414  * !!! ERROR ?  BSR ??!!
LERREF BSR.S   L08414
LERRIU BSR.S   L08414
LERREX BSR.S   L08414
LERRNF BSR.S   L08414
LERRNO BSR.S   L08414
LERRBO BSR.S   L08414
LERROR BSR.S   L08414
LERROM BSR.S   L08414
LERRNJ BSR.S   L08414
LERRNC BSR.S   L08414
       NOP
L08414 PEA     L08414(PC)
       MOVE.L  (A7)+,D4
       SUB.L   (A7)+,D4
       LSR.L   #1,D4
       BSR.S   L08446
       SUBQ.W  #6,A1
       CLR.W   $00(A6,A1.L)
       CLR.L   $02(A6,A1.L)
       ADD.L   $00C2(A6),D4
       BNE.S   L0843C
       MOVE.W  #$0801,$00(A6,A1.L)
       MOVE.B  #$40,$02(A6,A1.L)
L0843C MOVEQ   #$02,D4
L0843E MOVE.L  A1,$0058(A6)
       MOVEQ   #$00,D0
       RTS

L08446 CMPA.L  A3,A5
       BNE.S   L08454
       JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       RTS

L08454 ADDQ.W  #4,A7
       MOVEQ   #-$0F,D0
       RTS

LERNUM BSR.S   L08446
       SUBQ.W  #2,A1
       MOVE.W  $00C4(A6),$00(A6,A1.L)
L08464 MOVEQ   #$03,D4
       BRA.S   L0843E

LERLIN BSR.S   L08446
       SUBQ.W  #2,A1
       MOVE.W  $00C6(A6),$00(A6,A1.L)
       BRA.S   L08464
       
* create coded prog
* code ligne number

L08474 JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       JSR     L03DC2(PC)
       BNE.S   L084A4
       TST.W   $00(A6,A1.L)
       BLE.S   L084A4
       TST.B   $0090(A6)
       BEQ.S   L08496
L0848E ADDA.W  #$000C,A7
       MOVEQ   #$01,D0
       RTS

L08496 MOVEQ   #$04,D1
       MOVEQ   #-$73,D4
       MOVE.W  $00(A6,A1.L),D5
       JSR     L08E0A(PC)
       ADDQ.L  #2,(A7)
L084A4 RTS

L084A6 DC.B    $04,$05,$07,$09,$0C,$01,$2D,$01

L084AE DC.B    $2B,$02,$7E,$7E
       DC.B    $13,$4E,$4F,$54
       
L084B6 LEA     L084A6(PC),A2
       JSR     L08748(PC)
       BRA.S   L084C8
       
L084C0 MOVEQ   #-$7A,D4
       JSR     L08DFA(PC)
       ADDQ.L  #2,(A7)
L084C8 RTS

L084CA MOVEQ   #$01,D3
       BRA.S   L084D0

L084CE MOVEQ   #$00,D3
L084D0 MOVEA.L A0,A3
       JSR     L08706(PC)
       BRA.S   L084F8

L084D8 MOVE.L  A0,D5
       SUB.L   A3,D5
       CMPI.W  #$00FF,D5
       BGT.S   L084F8
       MOVE.L  A0,-(A7)
       JSR     L08622(PC)
       BRA.S   L084F6     * ERROR
L084EA MOVEA.L (A7)+,A0
       MOVEQ   #-$78,D4
       JSR     L08E0A(PC)
       ADDQ.L  #2,(A7)
       RTS

L084F6 MOVEA.L (A7)+,A0
L084F8 RTS



L084FA DC.B    $16          * THERE ARE $16=#22 OPERATORS
* TO EACH OPERATOR IS POINTED WITH ONE BYTE DISPLACEMENT
       DC.B    $17,$19,$1B,$1D  
       DC.B    $1F,$22,$24,$27
       DC.B    $29,$2C,$2F,$31
       DC.B    $34,$37,$3A,$3C
       DC.B    $3E,$41,$45,$49,$4D,$51

* THESE ARE THE OPERATORS - LENGTH AND ASCII
* VALUES LIKE $12 FOR LENGHT MEAN: STRING OPERATOR, LENGHT 2
L08511 DC.B    $01,'+',$01,'-',$01,'*'
       DC.B    $01,'/',$02,'>=',$01,'>'
       DC.B    $02,'==',$01,'=',$02,'<>'
       DC.B    $02,'<=',$01,'<',$02,'||'
       DC.B    $02,'&&',$02,'^^',$01,'^'
       DC.B    $01,'&',$12,'OR'
       DC.B    $13,'AND',$13,'XOR',$13,'MOD'
       DC.B    $13,'DIV',$15,'INSTR'
       DC.B    $00

       
L08552 LEA     L084FA(PC),A2
       JSR     L08748(PC)
       BRA.S   L08564
       MOVEQ   #-123,D4
       JSR     L08DFA(PC)
       ADDQ.L  #2,(A7)
L08564 RTS
       
* TABLE OF 5 SEPARATORS - LIKE ABOVE  JM 7D48
L08566 DC.L    $0506080A
       DC.W    $0C0E
* HERE THEY ARE
       DC.B    $01,',',$01,';',$01,'\'
       DC.B    $01,'!',$12,'TO'
       DC.B    $00
       
L08578 LEA.L   L08566(PC),A2
       JSR     L08748(PC)
       BRA.S   L0858A         * ERROR
       MOVEQ   #-114,D4
       JSR     L08DFA(PC)
       ADDQ.L  #2,(A7)
L0858A RTS
       
L0858C MOVEQ   #0,D1    
       MOVEQ   #0,D5       
L08590 ADDQ.W  #1,D5         
       MOVE.B  $0(A6,A0.L),D1
       ADDQ.W  #1,A0          
       CMPI.B  #$20,D1
       BEQ.S   L08590         
       SUBQ.W  #1,A0          
       SUBQ.W  #1,D5
       BEQ.S   L085AA
       MOVEQ   #-$80,D4
       JSR     L08DFA(PC)
L085AA RTS
       
L085AC MOVE.B  $0(A6,A0.L),D2
       CMPI.B  #$22,D2
       BEQ.S   L085BC
       CMPI.B  #$27,D2
       BNE.S   L085DE
L085BC LEA     $1(A0),A2
       MOVEQ   #-1,D5
       MOVEQ   #$A,D3
L085C4 ADDQ.W  #1,A0
       ADDQ.W  #1,D5
       MOVE.B  $0(A6,A0.L),D1
       CMP.B   D3,D1
       BEQ.S   L085DE
       CMP.B   D2,D1
       BNE.S   L085C4
       ADDQ.W  #1,A0
       MOVEQ   #-117,D4
       JSR     L08E38(PC)
       ADDQ.L  #2,(A7)
L085DE RTS
       
L085E0 JSR    L0872C(PC)
       BNE.S  L085F2
       MOVE.L $C(A6),A3
       CMPI.B #$80,-2(A6,A3.L)
       BNE.S   L0860A
L085F2 MOVE.L  A0,A2
       MOVE.L  4(A6),D5
       SUBQ.L  #1,D5
       MOVEA.L D5,A0
       SUB.L   A2,D5
       BEQ.S   L08608
       MOVEQ   #-$74,D4
       MOVEQ   #$00,D2
       JSR     L08E38(PC)
L08608 ADDQ.L  #2,(A7)
L0860A RTS

L0860C JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       JSR     L03D16(PC)
       BNE.S   L08620
       JSR     L08E12(PC)
       ADDQ.L  #2,(A7)
L08620 RTS

L08622 MOVE.L  A2,-(A7)
       MOVE.B  D5,D2
       MOVE.B  D2,D1
       MOVEQ   #$05,D3
       MOVEA.L $0018(A6),A2
       MOVEA.L A3,A1
L08630 CMPA.L  $001C(A6),A2
       BGE.S   L08684
       TST.L   $00(A6,A2.L)
       BEQ.S   L0864C
       MOVEA.L $0020(A6),A4
       ADDA.W  $02(A6,A2.L),A4
       MOVE.B  $00(A6,A4.L),D5
       CMP.B   D2,D5
       BEQ.S   L08650
L0864C ADDQ.W  #8,A2
       BRA.S   L08630

L08650 TST.B   D2
       BEQ.S   L08672
       MOVE.B  $00(A6,A3.L),D4
       ADDQ.W  #1,A3
       BCLR    D3,D4
       TST.B   D5
       BEQ.S   L0867C
       ADDQ.W  #1,A4
       MOVE.B  $00(A6,A4.L),D6
       BCLR    D3,D6
       CMP.B   D4,D6
       BNE.S   L0867C
       SUBQ.B  #1,D2
       SUBQ.B  #1,D5
       BRA.S   L08650

L08672 TST.B   D5
       BNE.S   L0867C
       MOVE.L  A2,D5
       ADDQ.W  #4,A7
       BRA.S   L086FA

L0867C MOVEA.L A1,A3
       MOVE.B  D1,D2
       ADDQ.W  #8,A2
       BRA.S   L08630

L08684 MOVEQ   #$00,D6
       MOVEA.L A3,A0
       MOVEA.L (A7)+,A2
       JSR     L08966(PC)
       BRA.S   L08692   * ERROR       
       BRA.S   L08704

L08692 TST.B   $0090(A6)
       BEQ.S   L0869E
       ADDQ.W  #8,A7
       JMP     L0848E(PC)
       
L0869E MOVEQ   #$00,D4
       MOVE.B  D2,D4
       JSR     L04DE8(PC)
       MOVE.L  D4,D2
       MOVE.L  #-1,$04(A6,A2.L)
       MOVEA.L $0024(A6),A4
       MOVE.L  A4,D3
       SUB.L   $0020(A6),D3
       MOVE.W  D3,$02(A6,A2.L)
       ADD.L   A3,D2
       MOVE.B  -$01(A6,D2.L),D3
       MOVEQ   #$00,D1
       SUBI.B  #$25,D3
       BLT.S   L086D2
       BGT.S   L086D0
       ADDQ.W  #1,D1
L086D0 ADDQ.W  #1,D1
L086D2 ADDQ.W  #1,D1
       MOVE.W  D1,$00(A6,A2.L)
       MOVE.L  A2,D5
       MOVEQ   #$01,D1
       ADD.W   D4,D1
       JSR     L04E72(PC)
       MOVE.B  D4,$00(A6,A4.L)
L086E6 ADDQ.W  #1,A4
       MOVE.B  $00(A6,A3.L),$00(A6,A4.L)
       ADDQ.W  #1,A3
       SUBQ.B  #1,D4
       BNE.S   L086E6
       ADDQ.W  #1,A4
       MOVE.L  A4,$0024(A6)
L086FA MOVEA.L D5,A2
       SUB.L   $0018(A6),D5
       LSR.L   #3,D5
       ADDQ.L  #2,(A7)
L08704 RTS

L08706 BSR.S   L0872C
       BNE.S   L0872A
       CMPI.B  #$01,D2
       BNE.S   L0872A
L08710 ADDQ.W  #1,A0
       BSR.S   L0872C
       BEQ.S   L08710
       CMPI.B  #$24,D2
       BEQ.S   L08722
       CMPI.B  #$25,D2
       BNE.S   L08728
L08722 TST.B   D3
       BNE.S   L0872A
       ADDQ.W  #1,A0
L08728 ADDQ.L  #2,(A7)
L0872A RTS

L0872C MOVEQ   #$00,D1
       MOVE.B  $00(A6,A0.L),D1
       BLT.S   L08746
       LEA     L03C28(PC),A1
       MOVE.B  $00(A1,D1.W),D2
       CMPI.B  #$01,D2
       BEQ.S   L08746
       CMPI.B  #$02,D2
L08746 RTS

L08748 MOVE.L  A0,-(A7)
       MOVEQ   #$00,D5
L0874C MOVEA.L (A7),A0
       BSR.S   L08794
L08750 ADDQ.W  #1,D5
       MOVEA.L A2,A1
       CMP.B   (A1),D5
       BGT.S   L08790
       MOVEQ   #$00,D1
       MOVE.B  $00(A1,D5.W),D1
       ADDA.W  D1,A1
       MOVE.B  (A1)+,D1
       CMP.B   (A1)+,D0
       BNE.S   L08750
       MOVE.B  D1,D0
       SWAP    D1
       MOVE.B  D0,D1
       ANDI.B  #$0F,D1
L08770 SUBQ.B  #1,D1
       BLE.S   L0877E
       ADDQ.W  #1,A0
       BSR.S   L08794
       CMP.B   (A1)+,D0
       BEQ.S   L08770
       BRA.S   L0874C

L0877E SWAP    D1
       LSR.B   #4,D1
       ADDQ.W  #1,A0
       BEQ.S   L0878C
       JSR     L0872C(PC)
       BEQ.S   L0874C
L0878C ADDQ.L  #2,$0004(A7)
L08790 ADDQ.W  #4,A7
       RTS

L08794 MOVEQ   #$00,D0
       MOVE.B  $00(A6,A0.L),D0
       BLT.S   L087AC
       LEA     L03C28(PC),A3
       CMPI.B  #$01,$00(A3,D0.W)
       BNE.S   L087AC
       BCLR    #$05,D0
L087AC RTS

* DISPLACEMENT - JUMPS RELATIV TO 87C4

L087AE DC.W    L084CE-EDUMMY
       DC.W    L0860C-EDUMMY
       DC.W    L0860C-EDUMMY
* NEXT VALUE IS REST OF JM - LABEL SHOULD POINT TO RTS
* IN JM 4FFC WAS CLOSE TO THESE LABELS - CHANGE IT TO ANY
* OTHER LABEL
       DC.W    L04FFC-EDUMMY
       DC.W    L08552-EDUMMY
       DC.W    L084B6-EDUMMY
       DC.W    L08578-EDUMMY
       DC.W    L085AC-EDUMMY
       DC.W    L085E0-EDUMMY
       DC.W    L08474-EDUMMY
       DC.W    L084CA-EDUMMY
       
L087C4 LSR.B   #1,D6
L087C6 JSR     L0858C(PC)
       ADD.B   D6,D6
       MOVE.W  L087AE-$02(PC,D6.W),D6
L087D0 JMP     EDUMMY(PC,D6.W)

EDUMMY EQU  L087D0-$0C

L087D4 
XL047D4 EQU L087D4-$4000
       MOVEQ   #$00,D7
       MOVEQ   #$00,D6
       MOVE.L  (A2)+,-(A7)
       MOVE.L  (A2),-(A7)
       MOVEA.L (A7),A5
       MOVE.W  (A5),D6
       ADDA.W  D6,A5
       MOVEQ   #$00,D4
       JSR     L08AA0(PC)
       MOVEA.L (A6),A0
       BRA.S   L0880E

L087EC SUBI.B  #$80,D6
       LSR.B   #1,D6
       BNE.S   L087FE
       SUBQ.W  #1,A5
       JSR     L08A7A(PC)
       BRA     L088CE

L087FE MOVE.L  A5,D4
       JSR     L08AA0(PC)
       ADD.B   D6,D6
       MOVEA.L (A7),A5
       MOVE.W  -$02(A5,D6.W),D6
       ADDA.W  D6,A5
L0880E JSR     L08A7E(PC)
L08812 MOVEQ   #$00,D6
       MOVE.B  (A5)+,D6
       BEQ.S   L0887A
       BMI.S   L087EC
       BCLR    #$06,D6
       BEQ.S   L0882C
       MOVEA.L $0004(A7),A2
       JSR     L08966(PC)
       BRA.S   L08846    * ERROR
       BRA.S   L08864

L0882C BCLR    #$05,D6
       BEQ.S   L0883A
       JSR     L08B34(PC)
       BRA.S   L08846     * ERROR       
       BRA.S   L08864

L0883A MOVEA.L $0004(A7),A2
       JSR     L087C4(PC)
       BRA.S   L08846     * ERROR       
       BRA.S   L08864

L08846 MOVEA.L $0048(A6),A2
L0884A MOVEA.L $00(A6,A2.L),A3
       MOVEA.L $04(A6,A2.L),A0
       MOVE.L  $08(A6,A2.L),D3
       ADDA.W  #$000C,A2
       BLT.S   L0884A
       ADDQ.W  #1,A5
       MOVE.L  A3,$000C(A6)
       BRA.S   L08812

L08864 JSR     L08A7A(PC)
L08868 MOVEQ   #$00,D6
       MOVE.B  (A5),D6
       BEQ.S   L088CE
       BMI.S   L08874
       ADDA.W  D6,A5
       BRA.S   L08812

L08874 NEG.B   D6
       SUBA.W  D6,A5
       BRA.S   L08812

L0887A MOVEA.L $0048(A6),A4
       CMPA.L  $004C(A6),A4
       BGT.S   L088B2
       MOVEA.L $00(A6,A4.L),A3
       MOVEA.L $04(A6,A4.L),A0
       MOVEA.L $08(A6,A4.L),A5
       ADDA.W  #$000C,A4
       MOVE.L  A4,$0048(A6)
       MOVE.L  A5,D3
       BGT.S   L088A6
       BEQ.S   L088B8
       MOVE.L  A0,D4
       JSR     L08AA0(PC)
       BRA.S   L0887A

L088A6 BTST    D7,-$0001(A5)
       BEQ.S   L08846
       MOVE.L  -$10(A6,A4.L),D3
       BMI.S   L08846
L088B2 ADDQ.W  #8,A7
       MOVEQ   #-$01,D0
       RTS
L088B8 MOVEA.L $0050(A6),A4
       MOVEA.L $00(A6,A4.L),A5
       ADDQ.W  #4,A4
       MOVE.L  A4,$0050(A6)
       MOVE.L  A5,D3
       BEQ.S   L088B2
       BRA     L08846

L088CE JSR     L04E52(PC)
       MOVEA.L $0048(A6),A4
       MOVEA.L $0050(A6),A2
       SUBQ.W  #8,A4
       MOVE.L  #-1,$04(A6,A4.L)
       MOVE.L  $00(A6,A2.L),$00(A6,A4.L)
       MOVEA.L $00(A6,A4.L),A5
       SUBQ.W  #4,A4
       MOVE.L  $000C(A6),$00(A6,A4.L)
       ADDQ.W  #4,A2
       MOVE.L  A2,$0050(A6)
       MOVE.L  A4,$0048(A6)
       MOVE.L  A5,D3
       BNE     L08868
       ADDQ.W  #8,A7
       MOVEQ   #$00,D0
       RTS

L0890C MOVE.L  $4C(A6),$48(A6)
XL0490C EQU L0890C-$4000
       MOVE.L  $54(A6),$50(A6)
       MOVE.L  $8(A6),$C(A6)
       MOVEQ   #$7E,D1
       JSR     L04E6E(PC)
       MOVEQ   #$20,D1
       JSR     L04E4E(PC)
       MOVE.L  $0058(A6),$0054(A6)
       SUBI.L  #$0020,$0054(A6)
       MOVE.L  $0054(A6),$0050(A6)
       MOVEQ   #$50,D1
       JSR     L04E5A(PC)
       MOVE.L  $0050(A6),$004C(A6)
       SUBI.L  #$0050,$004C(A6)
       MOVE.L  $004C(A6),$0048(A6)
       MOVEQ   #$00,D0
       JSR     L04E32(PC)
       MOVE.W  #$0200,D1
       JMP     L04E54(PC)

L08966 MOVEM.L D0-D5/A1-A5,-(A7)
       MOVEA.L A2,A3
       MOVEA.L A0,A1
       MOVEQ   #$00,D3
       MOVEQ   #$00,D4
       MOVEQ   #$00,D5
       MOVEQ   #$00,D0
       LSR.B   #1,D6
       BEQ.S   L08980
       JSR     L0858C(PC)
       BRA.S   L08986

L08980 ST      D0
       SWAP    D0
       MOVEQ   #$01,D6
L08986 MOVEQ   #$00,D1
       CMP.B   (A2),D6
       BGT     L08A48
       MOVE.B  $00(A2,D6.W),D1
       ADDA.L  D1,A2
       MOVE.B  (A2)+,D1
       ROR.L   #4,D1
       MOVE.B  D1,D4
       SWAP    D1
       ROL.W   #4,D1
       MOVE.B  D1,D3
L089A0 SUBQ.B  #1,D4
       BLT.S   L089FC
       MOVE.B  (A2)+,D2
       CMPI.B  #$60,D2
       BGT.S   L089B2
       ST      D0
       SF      D5
       BRA.S   L089BC

L089B2 SF      D0
       TST.B   D5
       BNE.S   L089A0
       SUBI.B  #$20,D2
L089BC MOVE.B  $00(A6,A0.L),D1
       ADDQ.W  #1,A0
       CMPI.B  #$60,D1
       BLE.S   L089CC
       SUBI.B  #$20,D1
L089CC CMP.B   D2,D1
       BEQ.S   L089A0
       TST.B   D0
       BNE.S   L089DA
       ST      D5
       SUBQ.W  #1,A0
       BRA.S   L089A0

L089DA SWAP    D0
       TST.B   D0
       BEQ.S   L08A48
       SWAP    D5
       TST.B   D5
       SWAP    D5
       BEQ.S   L089EC
       TST.B   D3
       BNE.S   L089F4
L089EC ADDQ.W  #1,D6
       MOVEA.L A1,A0
       MOVEA.L A3,A2
       BRA.S   L08986

L089F4 MOVEA.L A4,A0
       SUBQ.B  #1,D3
       ADDA.L  D4,A2
       BRA.S   L08A30
       
L089FC SWAP    D0
       TST.B   D0
       BEQ.S   L08A38
       MOVE.B  $00(A6,A0.L),D1
       BLT.S   L08A48
       LEA     L03C28(PC),A5
       CMPI.B  #$01,$00(A5,D1.W)
       BEQ.S   L08A1E
       CMPI.B  #$02,$00(A5,D1.W)
       BEQ.S   L08A48
       BRA.S   L08A40

L08A1E SWAP    D5
       TST.B   D5
       BNE.S   L08A48
       TST.B   D3
       BEQ.S   L08A48
       ST      D5
       SWAP    D5
       SUBQ.B  #1,D3
       MOVEA.L A0,A4
L08A30 MOVE.B  (A2)+,D4
       LSR.B   #4,D4
       BRA     L089A0

L08A38 MOVEQ   #-$7F,D4
       MOVE.B  D6,D5
       JSR     L08DFA(PC)
L08A40 MOVEM.L (A7)+,D0-D5/A1-A5
       ADDQ.L  #2,(A7)
       RTS

L08A48 MOVEM.L (A7)+,D0-D5/A1-A5
       RTS

L08A4E MOVE.L  $0008(A6),$000C(A6)
XL04A4E EQU L08A4E-$4000
       MOVEA.L (A6),A0
       JSR     L08474(PC)
       BRA.S   L08A76     *ERROR
o08A5C MOVEQ   #-$7F,D4   *ERROR
       MOVEQ   #$1F,D5
       JSR     L08DFA(PC)
       JSR     L085F2(PC) *SUCCESS
       BRA.S   L08A76

o08A6A MOVEQ   #-$7C,D4
       MOVEQ   #$0A,D5
       JSR     L08DFA(PC)
       MOVEQ   #$00,D0
       RTS

L08A76 MOVEQ   #-$15,D0
       RTS

L08A7A MOVE.L  A5,D4
       BRA.S   L08A80

L08A7E MOVEQ   #$00,D4
L08A80 JSR     L04E52(PC)
       MOVEA.L $0048(A6),A4
       SUBA.W  #$000C,A4
       MOVE.L  D4,$08(A6,A4.L)
       MOVE.L  A0,$04(A6,A4.L)
       MOVE.L  $000C(A6),$00(A6,A4.L)
       MOVE.L  A4,$0048(A6)
       RTS

L08AA0 JSR     L04E58(PC)
       MOVEA.L $0050(A6),A4
       SUBQ.W  #4,A4
       MOVE.L  D4,$00(A6,A4.L)
       MOVE.L  A4,$0050(A6)
       RTS

L08AB4 MOVEA.L $0008(A6),A0
XL04AB4 EQU L08AB4-$4000
L08AB8 CMPA.L  $000C(A6),A0
       BGE.S   L08ADA
       CMPI.B  #$81,$00(A6,A0.L)
       BNE.S   L08ACC
       ADDQ.W  #2,A0
       BSR.S   L08AF4
       BRA.S   L08AB8

L08ACC CMPI.W  #$8409,$00(A6,A0.L)
       ADDQ.W  #2,A0
       BNE.S   L08AB8
       BSR.S   L08B10
       BRA.S   L08AB8

L08ADA MOVEA.L $0008(A6),A0
       CMPI.B  #$80,$00(A6,A0.L)
       BNE.S   L08AEA
       ADDQ.W  #2,A0
       BSR.S   L08B10
L08AEA CMPI.W  #$8D00,$00(A6,A0.L)
XL04AEA EQU L08AEA-$4000
       BNE.S   L08B0E
       ADDQ.W  #4,A0
L08AF4 CMPI.B  #$80,$00(A6,A0.L)
       BNE.S   L08B0E
       MOVE.B  $01(A6,A0.L),D1
       ADDQ.W  #2,A0
       SUBQ.B  #1,D1
       BGT.S   L08B0A
       BSR.S   L08B10
       BRA.S   L08B0E
       
L08B0A MOVE.B  D1,-$01(A6,A0.L)
L08B0E RTS

L08B10 LEA     -$0002(A0),A2
L08B14 MOVE.W  $00(A6,A0.L),-$02(A6,A0.L)
       ADDQ.W  #2,A0
       CMPA.L  $000C(A6),A0
       BLT.S   L08B14
       SUBQ.L  #2,$000C(A6)
       MOVEA.L A2,A0
       RTS
* NOW SEPERATORS =:#,(){} SPACE AND CR
* THIS WAS INTERPRETED AS CODE !!! CORRECTED

L08B2A DC.L $3D3A232C
       DC.L $28297B7D
       DC.W $200A
L08B29 EQU L08B2A-$01

L08B34 LSR.B   #1,D6
L08B36 MOVE.B  $00(A6,A0.L),D1
       CMP.B   L08B29(PC,D6.W),D1  * !!! LABEL REDEFINED
       BEQ.S   L08B4C
       CMPI.B  #$20,D1
       BNE.S   L08B58
       JSR     L0858C(PC)
       BRA.S   L08B36

L08B4C ADDQ.W  #1,A0
       MOVEQ   #-$7C,D4
       MOVE.B  D6,D5
       JSR     L08DFA(PC)
       ADDQ.L  #2,(A7)
L08B58 RTS
        
L08B5A 
XL04B5A EQU L08B5A-$4000
       DC.L    XL08D2B        * BASE OF INSTRUCTION-LIST
       DC.L    XL08B62        * BASE OF SYTAX ANAYSIS
       
L08B62 DC.L    $0022004E
XL08B62 EQU L08B62
       DC.L    $00AE0060
       DC.L    $006600BC
       DC.L    $00C400E3
       DC.L    $00FA0163
       DC.L    $01780185
       DC.L    $019901A2
       DC.L    $01B001BD
       DC.L    $01BE1401
       DC.L    $840F8A12
       DC.L    $861E8809
       DC.L    $68F98C05
       DC.L    $90039201
       DC.L    $25F13500
       DC.L    $00780625
       DC.L    $EA350000
       DC.L    $33E525E3
       DC.L    $35000035
       DC.L    $0025018E
       DC.L    $DA004E02
       DC.L    $00500452
       DC.L    $02003202
       DC.L    $00020200
       DC.L    $80940000
       DC.L    $44084812
       DC.L    $4C164608
       DC.L    $00320200
       DC.L    $17160033
       DC.L    $02009800
       DC.L    $00320200
       DC.L    $0200005C
       DC.L    $0A320200
       DC.L    $02190023
       DC.L    $0C008033
       DC.L    $02009808
       DC.L    $00270900
       DC.L    $960D0080
       DC.L    $28F50098
       DC.L    $0C00809A
       DC.L    $00007A09
       DC.L    $8028EE00
       DC.L    $8028E700
       DC.L    $33020098
       DC.L    $F4004A02
       DC.L    $00320200
       DC.L    $6A041600
       DC.L    $0033FC00
       DC.L    $660A6408
       DC.L    $6C0C6A11
       DC.L    $22150032

L08C2A DC.L    $02000200
       DC.L    $00803202
       DC.L    $00980000
       DC.L    $32020002
       DC.L    $EC006E00
       DC.L    $96020028
       DC.L    $FC800042
       DC.L    $0200480D
       DC.L    $440B4600
       DC.L    $4A004C00
       DC.L    $4E020080
       DC.L    $32020002
       DC.L    $00006216
       DC.L    $704D7219
       DC.L    $74217C2B
       DC.L    $7E29542A
       DC.L    $6A337649
       DC.L    $9E4D0251
       DC.L    $00803202
       DC.L    $00980000
       DC.L    $3202009C
       DC.L    $020028FC
       DC.L    $80003202
       DC.L    $0002049C
       DC.L    $020028FA
o8C8E  DC.L    $80001200
       DC.L    $00560458
       DC.L    $02003202
       DC.L    $00980000
       DC.L    $32020098
       DC.L    $02005402
       DC.L    $00560458
       DC.L    $02003302
       DC.L    $00980200
       DC.L    $28FC8000
       DC.L    $3202009E
       DC.L    $02002202
       DC.L    $00980000
       DC.L    $A000002B
       DC.L    $02000204
       DC.L    $2B070028
       DC.L    $FA2D0000
o8CD2  DC.L    $02020028
       DC.L    $FC2DF700
       DC.L    $98020056
       DC.L    $03800032
       DC.L    $02009800
L08CE6 DC.L    $000C012A
XL04CE7 EQU L08CE6-$3FFF
       DC.L    $08100C04
       DC.L    $0C020800
       DC.L    $9802002C
       DC.L    $04002A05
       DC.L    $800AEB00
       DC.L    $A202002C
       DC.L    $F6000202
       DC.L    $002A0200
       DC.L    $98020028
       DC.L    $FC2C0000
       DC.L    $02020080
       DC.L    $2A0200A2
       DC.L    $02002CF8
       DC.L    $00800EFE
       DC.L    $26019802
       DC.L    $000EF780
       DC.W    $001F       
L08D2C DC.L    $2024282B      
XL08D2B EQU L08D2C-1
       DC.W    $3239
       DC.L    $3E454F58
       DC.L    $5B5E6267
       DC.L    $6D71777F
       DC.L    $84898E91
       DC.L    $98A2A7AB
       DC.L    $B1B5BABF
       DC.W    $C636
       DC.B    'END',$30,'FOR'
       DC.B    $20,'IF',$60,'REPeat'
       DC.B    $60,'SELect',$40,'WHEN'
       DC.B    $62,'DEFine',$90,'PROCedure'
       DC.B    $80,'FuNction',$22,'GO TO'
       DC.B    $30,'SUB',$41,'WHEN',$50,'ERRor'
       DC.B    $30,'END',$50,'ERRor',$70,'RESTORE'

* LABEL L08DAA WAS SET WRONG !!! CORRECTED

L08DAA DC.B    $40,'NEXT',$40,'EXIT',$40,'ELSE'
       DC.B    $20,'ON',$60,'RETurn'
       DC.B    $90,'REMAINDER',$40,'DATA'
       DC.B    $30,'DIM',$50,'LOCal'
       DC.B    $30,'LET',$40,'THEN',$40,'STEP'
       DC.B    $60,'REMark',$70,'MISTake',$00

L08DFA MOVEQ   #$02,D1
       BSR.S   L08E68
       MOVE.B  D4,$00(A6,A3.L)
       MOVE.B  D5,$01(A6,A3.L)
       ADDQ.W  #2,A3
       BRA.S   L08E5E

L08E0A MOVEQ   #$04,D1
       MOVEQ   #$00,D2
       BSR.S   L08E76
L08E10 BRA.S   L08E5E

L08E12 MOVEQ   #$06,D1
L08E14 MOVE.L  A1,$0058(A6)
       BSR.S   L08E68
       MOVEA.L $0058(A6),A1
       ADDQ.L  #6,$0058(A6)
       MOVE.W  $00(A6,A1.L),D2
       ADDI.W  #$F000,D2
       MOVE.W  D2,$00(A6,A3.L)
       MOVE.L  $02(A6,A1.L),$02(A6,A3.L)
       ADDQ.W  #6,A3
       BRA.S   L08E5E

L08E38 MOVEQ   #$01,D1
       ADD.W   D5,D1
       BVS.S   L08E64
L08E3E ADDQ.W  #4,D1
       BSR.S   L08E76
       BEQ.S   L08E5E
       MOVE.W  D5,D1
L08E46 MOVE.B  $00(A6,A2.L),$00(A6,A3.L)
       ADDQ.W  #1,A3
       ADDQ.W  #1,A2
       SUBQ.W  #1,D1
       BNE.S   L08E46
       BTST    D7,D5
       BEQ.S   L08E5E
       MOVE.B  D7,$00(A6,A3.L)
       ADDQ.W  #1,A3
L08E5E MOVE.L  A3,$000C(A6)
L08E62 RTS

L08E64 ADDQ.W  #4,A7
       RTS

L08E68 MOVE.B  D2,-(A7)
       JSR     L04E6E(PC)
       MOVE.B  (A7)+,D2
       MOVEA.L $000C(A6),A3
       RTS

L08E76 BSR.S   L08E68
       MOVE.B  D4,$00(A6,A3.L)
       MOVE.B  D2,$01(A6,A3.L)
       MOVE.W  D5,$02(A6,A3.L)
       ADDQ.W  #4,A3
       RTS

L08E88 MOVEA.L $0008(A6),A1
XL04E88 EQU L08E88-$4000
       CMPI.B  #$8D,$00(A6,A1.L)
       BNE     L08F82
       MOVE.W  $02(A6,A1.L),D2
       MOVE.L  $000C(A6),D1
       SUB.L   A1,D1
       SUBQ.W  #6,D1
       SEQ     D0
       ADDQ.W  #6,D1
       MOVEQ   #$00,D6
       MOVEQ   #$00,D5
       MOVEA.L $0010(A6),A0
       MOVEQ   #$00,D3
       BRA.S   L08EB6

L08EB2 MOVE.W  $02(A6,A0.L),D3
L08EB6 ADD.W   D5,D6
       ADDA.L  D6,A0
       MOVE.W  $00(A6,A0.L),D5
       ADDQ.W  #2,A0
       CMPA.L  $0014(A6),A0
       BLT.S   L08ECE
       ADDQ.B  #1,D0
       BGT.S   L08F44
       SUBQ.W  #2,A0
       BRA.S   L08EFE

* insert new line in prog
        
L08ECE CMP.W   $02(A6,A0.L),D2
       BGT.S   L08EB2
       BEQ.S   L08F00
       SUBQ.W  #2,A0
       TST.B   D0
       BNE.S   L08EFE
       ADDQ.W  #2,D1
       BSR     L08F84
       BSR.S   L08F3A
       SUBQ.W  #2,D1
       MOVE.W  D1,D5
       SUB.W   D6,D5
       MOVE.W  D5,$00(A6,A0.L)
       MOVEQ   #$01,D0
L08EF0 BSR     L08F92
       ADD.W   $00(A6,A0.L),D6
       SUB.W   D1,D6
       MOVE.W  D6,$00(A6,A0.L)
L08EFE BRA.S   L08F5C

* replace existing line in prog

L08F00 TST.B   D0
       BEQ.S   L08F06
       MOVEQ   #-$02,D1
L08F06 ADD.W   D6,D5
       LEA     -$0002(A0),A3
       ADDA.L  D5,A0
       CMPA.L  $0014(A6),A0
       BGE.S   L08F3C
       SUB.W   D5,D1
       BLT.S   L08F1A
       BSR.S   L08F84
L08F1A BSR.S   L08F3A
       MOVEA.L A3,A0
       ADD.W   D5,D1
       BGT.S   L08F2E
       ADD.W   $00(A6,A0.L),D5
       SUB.W   D6,D5
       MOVE.W  D5,$00(A6,A0.L)
       BRA.S   L08F5C

L08F2E MOVE.W  D1,D4
       SUB.W   D6,D4
       MOVE.W  D4,$00(A6,A0.L)
       MOVE.W  D5,D6
       BRA.S   L08EF0

L08F3A BRA.S   L08FA6

L08F3C LEA     $0002(A3),A0
       MOVE.L  A3,$0014(A6)
L08F44 SUBQ.W  #2,A0
       TST.B   D0
       BLT.S   L08F5C
       ADDQ.W  #2,D1
       BSR.S   L08F84
       SUBQ.W  #2,D1
       SUB.W   D6,D1
       MOVE.W  D1,$00(A6,A0.L)
       BSR.S   L08F92
       MOVE.L  A0,$0014(A6)
L08F5C TST.B   $00B9(A6)
       BEQ.S   L08F80
       SF      $00AA(A6)
       BGT.S   L08F70
       MOVE.W  D3,$00AC(A6)
       BNE.S   L08F7C
       BRA.S   L08F80

L08F70 CMPA.L  $0014(A6),A0
       BGE.S   L08F7C
       MOVE.W  $04(A6,A0.L),$00AC(A6)
L08F7C ST      $00AA(A6)
L08F80 ADDQ.L  #2,(A7)
L08F82 RTS

L08F84 MOVEM.L D0-D3/A0-A3,-(A7)
       JSR     L04E82(PC)
       MOVEM.L (A7)+,D0-D3/A0-A3
       RTS

L08F92 ADDQ.W  #2,A0
       MOVE.W  $00(A6,A1.L),$00(A6,A0.L)
       ADDQ.W  #2,A1
       CMPA.L  $000C(A6),A1
       BLT.S   L08F92
       ADDQ.W  #2,A0
       RTS

L08FA6 MOVEM.L D0-D3/A0-A3,-(A7)
       EXT.L   D1
       TST.L   D1
       BEQ.S   L08FE0
       MOVEA.L $0014(A6),A1
       BLT.S   L08FCA
       LEA     $00(A1,D1.W),A2
L08FBA SUBQ.W  #2,A1
       SUBQ.W  #2,A2
       MOVE.W  $00(A6,A1.L),$00(A6,A2.L)
       CMPA.L  A0,A1
       BGT.S   L08FBA
       BRA.S   L08FDC

L08FCA LEA     $00(A0,D1.W),A2
L08FCE MOVE.W  $00(A6,A0.L),$00(A6,A2.L)
       ADDQ.W  #2,A0
       ADDQ.W  #2,A2
       CMPA.L  A1,A0
       BLT.S   L08FCE
L08FDC ADD.L   D1,$0014(A6)
L08FE0 MOVEM.L (A7)+,D0-D3/A0-A3
       RTS

L08FE6 ST      $00AB(A6)
       MOVEA.L $0040(A6),A1
       MOVE.L  $0044(A6),D0
       SUB.L   A1,D0
       BNE.S   L09000
       MOVE.W  D2,D4
       BEQ.S   L09060
       MOVE.W  D2,D6
       BRA.S   L09044

L08FFE MOVE.W  D4,D2
L09000 MOVE.W  $00(A6,A1.L),D4
       TST.W   D2
       BEQ.S   L08FFE
       MOVE.W  $009E(A6),D6
       CMP.W   $009C(A6),D2
       BLT.S   L09060
       CMP.W   D4,D2
       BLT.S   L09032
       CMP.W   $00A0(A6),D2
       BGT.S   L09060
       CMP.W   D6,D2
       BGT.S   L0902A
       TST.B   D5
       BGE.S   L09044
       MOVE.W  $00A0(A6),D6
       BRA.S   L09044

L0902A TST.B   D5
       BLT.S   L09060
       MOVE.W  D2,D6
       BRA.S   L09044

L09032 TST.B   D5
       BLT.S   L09060
       MOVE.W  D2,D4
       MOVE.W  $00A4(A6),D0
       SUB.W   $00A6(A6),D0
       BGT.S   L09044
       SUBQ.W  #1,D6
L09044 MOVE.W  D2,$00BA(A6)
       MOVEQ   #$10,D0
       MOVEQ   #$00,D2
       MOVEQ   #$00,D1
       BSR.S   L0905C
       MOVEQ   #$00,D7
       JSR     L07518(PC)
       MOVEQ   #$24,D0
       BSR.S   L0905C
       MOVEQ   #$22,D0
L0905C MOVEQ   #-$01,D3
       TRAP    #$03
L09060 RTS

L09062 DC.L    $02020404
       DC.L    $02020204
       DC.L    $040204FB
       DC.L    $FB040200

L09072 MOVEQ   #$00,D0
       MOVEQ   #$06,D1
       MOVE.B  $00(A6,A4.L),D0
       BEQ.S   L09098
       SUBI.B  #$80,D0
       CMPI.B  #$70,D0
       BGE.S   L09096
       MOVE.B  L09062(PC,D0.W),D1
       BGE.S   L09096
       NEG.B   D1
       ADD.W   $02(A6,A4.L),D1
       BCLR    #$00,D1
L09096 ADDA.L  D1,A4
L09098 MOVE.B  $00(A6,A4.L),D0
       MOVE.W  $00(A6,A4.L),D1
       RTS

L090A2 MOVE.L  A1,-(A7)
       MOVEA.L $0030(A6),A1
       ADDA.W  #$0050,A1
       MOVE.L  $00(A6,A1.L),D0
       SUB.L   A0,D0
       MOVEA.L (A7)+,A1
       RTS

L090B6 MOVE.L  A5,-(A7)
       MOVEA.L A0,A5
       BSR.S   L090A2
       SEQ     $009B(A6)
       BNE.S   L09108
       MOVEQ   #$0B,D0
       LEA     $00A2(A6),A1
       MOVEQ   #-$01,D3
       TRAP    #$03
       MOVE.L  $0040(A6),$0044(A6)
       CLR.W   $00A6(A6)
       MOVEQ   #$64,D1
       JSR     L04E7E(PC)
       MOVE.W  $0068(A6),$009C(A6)
       MOVE.W  #$7FFF,$00A0(A6)
       BRA.S   L09108

L090EA DC.W    L092F8-L090EA
       DC.W    L09314-L090EA
       DC.W    L09292-L090EA
       DC.W    L09292-L090EA
       DC.W    L09338-L090EA
       DC.W    L0930E-L090EA
       DC.W    L0931A-L090EA
       DC.W    L09292-L090EA
       DC.W    L0929C-L090EA
       DC.W    L09292-L090EA
       DC.W    L09292-L090EA
       DC.W    L092E2-L090EA
       DC.W    L092EC-L090EA
       DC.W    L09238-L090EA
       DC.W    L09308-L090EA
              
L09108 MOVE.L  (A2),-(A7)
       ADDQ.W  #2,A4
       MOVEQ   #$00,D4
       MOVE.B  #$8D,D4
L09112 MOVE.L  (A6),$0004(A6)
L09116 CMPA.L  $0014(A6),A4
       BLT.S   L09130
       TST.B   $00AB(A6)
       BNE     L09202
       TST.B   $00AA(A6)
       BEQ     L09202
       BSR     L09250
L09130 MOVEQ   #$10,D1
       BSR     L092C0
       MOVEA.L (A7),A1
       SUBI.B  #$80,D4
       CMPI.B  #$70,D4
       BGE     L091F2
       ADD.B   D4,D4
       MOVE.W  L090EA(PC,D4.W),D4
       JSR     L090EA(PC,D4.W)
       CMPI.B  #$8D,D4
       BNE     L091F4
       TST.B   $00AB(A6)
       BEQ     L091FE
       TST.B   $009B(A6)
       BEQ.S   L091B8
       MOVEA.L (A6),A1
       MOVE.L  $0004(A6),D2
       SUB.L   A1,D2
       MOVEA.L $0044(A6),A2
       MOVE.W  $009E(A6),$00(A6,A2.L)
       SUBQ.W  #2,D2
       DIVU    $00A2(A6),D2
       ADDQ.W  #1,D2
       MOVE.W  D2,$02(A6,A2.L)
       ADD.W   $00A6(A6),D2
L09186 CMP.W   $00A4(A6),D2
       BLE.S   L091AC
       MOVE.W  $00BA(A6),D0
       BEQ.S   L09198
       CMP.W   $009E(A6),D0
       BLT.S   L091E4
L09198 MOVEA.L $0040(A6),A2
       SUB.W   $02(A6,A2.L),D2
       MOVE.W  $00(A6,A2.L),$009C(A6)
       ADDQ.L  #4,$0040(A6)
       BRA.S   L09186

L091AC MOVE.W  D2,$00A6(A6)
       ADDQ.L  #4,$0044(A6)
       JSR     L04F9E(PC)
L091B8 MOVEQ   #$07,D0
       MOVEA.L (A6),A1
       MOVE.L  $0004(A6),D2
       SUB.L   A1,D2
       MOVEA.L A5,A0
       MOVEQ   #-$01,D3
       TRAP    #$04
       TRAP    #$03
       TST.L   D0
       BNE.S   L09204
       MOVE.L  D1,D2
       MOVEQ   #$24,D0
       TRAP    #$03
       TAS     $008F(A6)
       BNE     L09112
       MOVE.W  $009E(A6),$00A0(A6)
       BRA.S   L09202

L091E4 MOVE.W  $009E(A6),$00A0(A6)
       MOVE.W  -$04(A6,A2.L),$009E(A6)
       BRA.S   L09202

L091F2 BSR.S   L09216
L091F4 JSR     L09072(PC)
       MOVE.W  D0,D4
       BRA     L09116

L091FE SUBQ.L  #1,$0004(A6)
L09202 MOVEQ   #$00,D0
L09204 ADDQ.W  #4,A7
       MOVEA.L A5,A0
       MOVEA.L (A7)+,A5
       RTS

L0920C JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       RTS

L09216 BSR.S   L0920C
       MOVE.W  $00(A6,A4.L),D2
       SUBI.W  #$F000,D2
       SUBQ.W  #6,A1
       MOVE.W  D2,$00(A6,A1.L)
       MOVE.L  $02(A6,A4.L),$02(A6,A1.L)
       MOVEA.L $0004(A6),A0
       JSR     L03EF6(PC)
       BRA     L09364

L09238 BSR.S   L0920C
       MOVE.W  $02(A6,A4.L),D1
       TST.B   $00AB(A6)
       BNE.S   L0925C
       TST.B   $00AA(A6)
       BEQ.S   L0925C
       CMP.W   $00AC(A6),D1
       BEQ.S   L0925C
L09250 BSR.S   L0920C
       MOVE.W  $00AC(A6),D1
       BSR.S   L09276
L09258 ADDQ.W  #4,A7
       BRA.S   L09202

L0925C TST.B   $009B(A6)
       BEQ.S   L09288
       CMP.W   D6,D1
       BLE.S   L09272
       TST.W   $00BA(A6)
       BNE.S   L09272
       MOVE.W  D1,$00A0(A6)
       BRA.S   L09258

L09272 MOVE.W  D1,$009E(A6)
L09276 SUBQ.W  #2,A1
       MOVE.W  D1,$00(A6,A1.L)
       MOVEA.L $0004(A6),A0
       JSR     L03E54(PC)
       BRA     L09316

L09288 CMP.W   D6,D1
       BGT.S   L09258
       BRA.S   L09276
L0928E DC.L    $3F3F3F3F
L09292 MOVEQ   #$04,D1
       LEA     L0928E(PC),A1
       BRA     L0935A

L0929C MOVE.W  $02(A6,A4.L),D2
       LSL.L   #3,D2
       MOVEA.L $0018(A6),A1
       ADDA.W  D2,A1
       MOVE.W  $02(A6,A1.L),D2
       BLT.S   L09292
       MOVEA.L $0020(A6),A1
       ADDA.W  D2,A1
       MOVEQ   #$00,D1
       MOVE.B  $00(A6,A1.L),D1
       ADDQ.W  #1,A1
       BRA     L09354

L092C0 SUBA.L  $0010(A6),A4
       SUBA.L  $0010(A6),A1
       MOVEM.L D1/A1/A4,-(A7)
       JSR     L04E6A(PC)
       MOVEA.L $0004(A6),A0
       MOVEM.L (A7)+,D1/A1/A4
       ADDA.L  $0010(A6),A1
       ADDA.L  $0010(A6),A4
       RTS

L092E2 BSR.S   L092E6
       BSR.S   L092EC
L092E6 MOVE.B  $01(A6,A4.L),D2
       BRA.S   L0934C

L092EC MOVE.W  $02(A6,A4.L),D1
       BEQ.S   L09306
       LEA     $0004(A4),A1
       BRA.S   L09354

L092F8 MOVE.B  $01(A6,A4.L),D1
       BSR.S   L092C0
L092FE MOVEQ   #$20,D2
       BSR.S   L0934C
       SUBQ.B  #1,D1
       BGT.S   L092FE
L09306 RTS

L09308 LEA     L0936C(PC),A1
       BRA.S   L0931E

L0930E LEA     L0938E(PC),A1
       BRA.S   L0931E

L09314 BSR.S   L0931E
L09316 MOVEQ   #$20,D2
       BRA.S   L0934C

L0931A LEA     L0937E(PC),A1
L0931E MOVE.B  $01(A6,A4.L),D1
       MOVE.B  $00(A1,D1.W),D1
       ADDA.L  D1,A1
       MOVE.B  (A1)+,D1
       LSR.L   #4,D1
L0932C BRA.S   L0935A

* SAME BUG AS IN L08B2A - SEPARATORS INSTEAD OF CODE
* CORRECTED

L0932E DC.L $3D3A232C
       DC.L $28297B7D
       DC.W $200A
XL0932D EQU L0932E-$01

L09338 MOVE.B  $01(A6,A4.L),D1
L0933C MOVE.B  XL0932D(PC,D1.W),D2
       MOVEQ   #$00,D4
       SUB.B   D2,D1
       BNE.S   L0934C
       ADDQ.W  #4,A4
       MOVE.B  #$8D,D4
L0934C MOVE.B  D2,$00(A6,A0.L)
       ADDQ.W  #1,A0
       BRA.S   L09364

L09354 BSR     L092C0
       ADDA.L  A6,A1
L0935A MOVE.B  (A1)+,$00(A6,A0.L)
       ADDQ.W  #1,A0
       SUBQ.W  #1,D1
       BGT.S   L0935A
L09364 MOVE.L  A0,$0004(A6)
       MOVEQ   #$00,D0
       RTS

       
* ASCII-CODE FOR SEPARATORS
* THERE ARE 5 -EACH BYTE SHOWS DISPLACEMENT
L0936C DC.B  $05,$06,$08,$0A,$0C,$0E
* HERE THEY ARE - 10 MEANS LENGTH 1
       DC.B    $10,','
       DC.B    $10,';',$10,'\'
       DC.B    $10,'!',$20,'TO',$00
       
* NEXT LIST OF 4 OPERATORS
L0937E DC.B    $04,$05,$07,$09,$0C
       DC.B    $10,'-',$10,'+'
       DC.B    $20,'~~',$30,'NOT'

* NEXT LIST OF $16 OPERATORS 
L0938E DC.L    $1617191B
       DC.L    $1D1F2224
       DC.L    $27292C2F
       DC.L    $3134373A
       DC.L    $3C3E4145
       DC.W    $494D
       DC.B    $51
* HERE THEY COME
       DC.B    $10,'+',$10,'-',$10,'*'
       DC.B    $10,'/',$20,'>=',$10,'>'
       DC.B    $20,'==',$10,'=',$20,'<>',$20,'<='
       DC.B    $10,'<',$20,'||',$20,'&&',$20,'^^'
       DC.B    $10,'^',$10,'&',$20,'OR'
       DC.B    $30,'AND',$30,'XOR',$30,'MOD'
       DC.B    $30,'DIV',$50,'INSTR'
       DC.B    $00

* CREATE ENTRY IN NAME-TABLE AND STORE VALUE

L093E6 ANDI.B  #$0F,$01(A6,A2.L)
       TST.L   $04(A6,A2.L)
       BGE.S   L093F6
       MOVEQ   #-$0C,D0
       RTS

L093F6 JSR     L04E5E(PC)
       MOVEA.L $001C(A6),A3
       ADDQ.L  #8,$001C(A6)
       MOVE.W  $00(A6,A2.L),$00(A6,A3.L)
       MOVE.W  D4,$02(A6,A3.L)
       MOVEA.L $04(A6,A2.L),A2
       ADDA.L  $0028(A6),A2
       MOVE.W  $04(A6,A2.L),D1
       LSL.L   #2,D1
       ADDQ.W  #6,D1
       JSR     L07338(PC)
L09420 MOVE.W  $00(A6,A2.L),$00(A6,A0.L)
       ADDQ.W  #2,A2
       ADDQ.W  #2,A0
       SUBQ.W  #2,D1
       BGT.S   L09420
L0942E JSR     L0A56C(PC)
       CMPI.W  #$8401,D1
       BEQ.S   L09456
       CMPI.W  #$8405,D1
       BNE     L094C2
       ADDQ.W  #2,A4
       MOVEA.L A4,A0
       LEA     $0008(A3),A5
       JSR     L06272(PC)
       LEA     -$0008(A5),A3
       MOVEA.L A0,A4
       BNE.S   L0948E
       BRA.S   L0942E

L09456 ADDQ.W  #2,A4
       CMPI.B  #$02,$00(A6,A3.L)
       BEQ.S   L09478
       CMPI.B  #$01,$01(A6,A3.L)
       BGT.S   L094C6
       MOVEA.L $04(A6,A3.L),A2
       ADDA.L  $0028(A6),A2
       CMPI.W  #$0001,$04(A6,A2.L)
       BGT.S   L094C6
L09478 MOVEA.L A4,A0
       MOVE.B  $01(A6,A3.L),D0
       MOVE.L  A3,-(A7)
       JSR     L05A84(PC)
       MOVEA.L (A7)+,A3
       MOVEA.L A0,A4
       BNE.S   L0948E
       JSR     L072C2(PC)
L0948E CMPI.B  #$03,$00(A6,A3.L)
       BNE.S   L094AA
       MOVEA.L $04(A6,A3.L),A2
       ADDA.L  $0028(A6),A2
       MOVE.L  D0,-(A7)
       MOVE.L  A3,-(A7)
       JSR     L09A3C(PC)
       MOVEA.L (A7)+,A3
       MOVE.L  (A7)+,D0
L094AA CLR.L   $00(A6,A3.L)
       CLR.L   $04(A6,A3.L)
       ADDQ.W  #8,A3
       CMPA.L  $001C(A6),A3
       BNE.S   L094BE
       SUBQ.L  #8,$001C(A6)
L094BE TST.L   D0
       RTS

L094C2 MOVEQ   #-$11,D0
       BRA.S   L0948E

L094C6 MOVEQ   #-$13,D0
       BRA.S   L0948E

L094CA JSR     L04E64(PC)
       MOVEA.L $003C(A6),A5
       TST.B   D5
       BEQ.S   L09504
       MOVE.L  D4,D3
       MOVEA.L $001C(A6),A3
       MOVE.L  A3,$00(A6,A5.L)
       MOVE.L  A3,$04(A6,A5.L)
       MOVE.L  A3,$08(A6,A5.L)
       MOVE.W  $04(A6,A2.L),D4
       BNE.S   L094F2
       MOVEQ   #-$07,D0
       RTS

L094F2 MOVE.W  D4,$0C(A6,A5.L)
       MOVE.B  $01(A6,A2.L),$0E(A6,A5.L)
       SF      $0F(A6,A5.L)
       ADDA.W  #$0010,A5
L09504 MOVE.B  D5,$00(A6,A5.L)
       MOVE.B  $006C(A6),$01(A6,A5.L)
       MOVE.W  $0068(A6),$02(A6,A5.L)
       MOVE.L  $006E(A6),$04(A6,A5.L)
       ADDQ.W  #8,A5
       MOVE.L  A5,$003C(A6)
       TST.B   D5
       BEQ.S   L09580
       CMPI.B  #$03,D5
       BEQ.S   L09578
       MOVEA.L A4,A0
       JSR     L0614A(PC)
       MOVEA.L $003C(A6),A5
       MOVE.L  $001C(A6),-$14(A6,A5.L)
       MOVE.L  $001C(A6),-$10(A6,A5.L)
       TST.L   D0
       BNE.S   L09552
       MOVE.W  $00(A6,A0.L),D1
       CMPI.B  #$02,D5
       BEQ.S   L09562
       BSR.S   L0959E
       BEQ.S   L09576
L09552 BSR     L097C8
       SUBI.L  #$0018,$003C(A6)
       MOVEQ   #-$0F,D0
       RTS

L09562 CMPI.W  #$8406,D1
       BNE.S   L09552
       ADDQ.W  #2,A0
       SUBA.L  $0008(A6),A0
       MOVE.L  A0,$0008(A7)
       ADDA.L  $0008(A6),A0
L09576 MOVEA.L A0,A4
L09578 ST      -$09(A6,A5.L)
       MOVEA.L -$18(A6,A5.L),A3
L09580 TST.B   $006F(A6)
       BEQ.S   L095A2
       BSR.S   L0958E
       BEQ.S   L095A2
       MOVEQ   #-$07,D0
       BRA.S   L095B4

L0958E MOVEA.L $0010(A6),A4
       SF      $006F(A6)
       CLR.W   $006A(A6)
       JMP     L0A966(PC)

L0959E BRA     L09686

L095A2 TST.B   D5
       BEQ     L0A078
       BSR     L09760
       BSR     L09692
L095B0 BSR.S   L0960C
       BEQ.S   L095DC
L095B4 MOVEA.L $003C(A6),A5
       MOVE.L  $001C(A6),-$10(A6,A5.L)
       MOVE.L  $0018(A6),D1
       SUB.L   D1,-$18(A6,A5.L)
       SUB.L   D1,-$14(A6,A5.L)
       SUB.L   D1,-$10(A6,A5.L)
       TST.L   D0
       BNE.S   L095DA
       ADDQ.W  #4,A7
       JMP     L0A8C0(PC)

       MOVEQ   #$00,D0
L095DA RTS

L095DC ADDQ.W  #2,A4
       BSR.S   L0965C
       CMPI.B  #$88,D0
       BNE.S   L095FE
       BSR.S   L09660
       BSR.S   L0965C
       CMPI.W  #$8405,D1
       BNE.S   L095FE
       ADDQ.B  #1,$00(A6,A2.L)
       SUBQ.W  #4,A4
       JSR     L098E8(PC)
       BNE.S   L095B4
       BSR.S   L0965C
L095FE CMPI.W  #$8404,D1
       BEQ.S   L095DC
       BSR.S   L0959E
       BEQ.S   L095B0
       MOVEQ   #-$15,D0
       BRA.S   L095B4

L0960C JSR     L0A60E(PC)
       BNE.S   L09628
       BSR.S   L0965C
       MOVEQ   #$00,D0
       CMPI.W  #$811E,D1
       BEQ.S   L0960C
       CMPI.W  #$8118,D1
       BEQ.S   L0960C
       CMPI.W  #$811A,D1
       RTS

L09628 MOVEQ   #-$0A,D0
       RTS

L0962C MOVEQ   #$00,D0
       MOVE.W  $02(A6,A4.L),D0
       LSL.L   #3,D0
       MOVEA.L $0018(A6),A2
       ADDA.L  D0,A2
       MOVE.W  $00(A6,A2.L),D0
       MOVE.W  $00(A6,A3.L),$00(A6,A2.L)
       MOVE.W  D0,$00(A6,A3.L)
       MOVE.L  $04(A6,A2.L),D0
       MOVE.L  $04(A6,A3.L),$04(A6,A2.L)
       MOVE.L  D0,$04(A6,A3.L)
       ADDQ.W  #8,A3
       ADDQ.W  #4,A4
       RTS

L0965C JMP     L0A56C(PC)

L09660 MOVEA.L $001C(A6),A3
       MOVE.B  #$02,$00(A6,A3.L)
       MOVE.W  #-1,$02(A6,A3.L)
       MOVE.L  #-1,$04(A6,A3.L)
       BSR.S   L0962C
       MOVE.B  -$07(A6,A3.L),$01(A6,A2.L)
       MOVE.L  A3,$001C(A6)
       RTS

L09686 CMPI.W  #$840A,D1
       BEQ.S   L09690
       CMPI.W  #$8402,D1
L09690 RTS

L09692 BSR.S   L0965C
       ADDQ.W  #2,A4
       BSR.S   L0965C
       ADDQ.W  #2,A4
       BSR.S   L0965C
       TST.W   D3
       BLT.S   L096A6
       CMP.W   $02(A6,A4.L),D3
       BNE.S   L096B4
L096A6 ADDQ.W  #4,A4
       BSR.S   L0965C
       CMPI.W  #$8405,D1
       BEQ.S   L096C0
       BSR.S   L09686
       BEQ.S   L096BA
L096B4 ADDQ.W  #4,A7
L096B6 MOVEQ   #-$07,D0
       RTS

L096BA MOVEA.L -$14(A6,A5.L),A3
       RTS

L096C0 ADDQ.W  #2,A4
L096C2 BSR.S   L0965C
       CMPI.B  #$88,D0
       BNE.S   L096DE
       CMPA.L  -$14(A6,A5.L),A3
       BLT.S   L096D8
       BSR.S   L09660
       MOVE.L  A3,-$14(A6,A5.L)
       BRA.S   L096C2

L096D8 BSR     L0962C
       BRA.S   L096C2

L096DE CMPI.W  #$8406,D1
       BNE.S   L096C0
L096E4 RTS

* execute RETURN
L096E6 MOVEA.L $003C(A6),A5
       CMPA.L  $0038(A6),A5
       BLE.S   L096B6
       MOVE.B  -$08(A6,A5.L),D5
       BEQ.S   L09718
       MOVE.B  D5,D0
       SUBQ.B  #2,D0
       BLT.S   L09714
       MOVE.B  -$0A(A6,A5.L),D0
       MOVEA.L A4,A0
       JSR     L05A84(PC)
       MOVEA.L A0,A4
       BLT.S   L096E4
       BEQ.S   L09710
       MOVEQ   #-$11,D0
       RTS

L09710 MOVEA.L $003C(A6),A5
L09714 BSR.S   L09768
       BNE.S   L096E4
L09718 MOVE.L  -$04(A6,A5.L),$006E(A6)
       MOVE.W  -$06(A6,A5.L),D4
       BSR.S   L09760
       MOVE.L  -$04(A6,A5.L),$006E(A6)
       MOVE.B  -$07(A6,A5.L),D4
       JSR     L0A00A(PC)
       SUBQ.W  #8,A5
       TST.B   D5
       BEQ.S   L0973C
       SUBA.W  #$0010,A5
L0973C SF      $0090(A6)
       MOVE.L  A5,$003C(A6)
       MOVEQ   #$00,D0
       SUBQ.B  #2,D5
       BLT.S   L0975C
       MOVEA.L $001C(A6),A5
       MOVE.B  #$01,-$08(A6,A5.L)
       ADDQ.W  #8,A7
       MOVEA.L (A7)+,A0
       ADDA.L  $0008(A6),A0
L0975C TST.L   D0
       RTS
       
L09760 JSR     L09FA2(PC)
       JMP     L0A966(PC)

L09768 MOVE.L  $0018(A6),D0
       ADD.L   D0,-$18(A6,A5.L)
       ADD.L   D0,-$14(A6,A5.L)
       ADD.L   D0,-$10(A6,A5.L)
       CMPA.L  $0010(A6),A4
       BLE.S   L09784
       CMPA.L  $0014(A6),A4
       BLT.S   L09788
L09784 BSR     L0958E
L09788 TST.B   -$09(A6,A5.L)
       BEQ.S   L097C8
       MOVE.W  -$0C(A6,A5.L),D4
       MOVEA.L -$14(A6,A5.L),A3
       BSR.S   L09760
L09798 BSR     L0960C
       BNE.S   L097B0
L0979E MOVE.W  #$8800,D4
       JSR     L0A5E0(PC)
       BNE.S   L09798
       BSR     L0962C
       SUBQ.W  #4,A4
       BRA.S   L0979E

L097B0 MOVE.W  -$0C(A6,A5.L),D4
       MOVEA.L -$18(A6,A5.L),A3
       TST.B   D0
       BEQ.S   L097C0
       BSR     L0958E
L097C0 BSR.S   L09760
       MOVEQ   #-$01,D3
       BSR     L09692
L097C8 MOVEA.L -$18(A6,A5.L),A3
       MOVEA.L -$10(A6,A5.L),A5
       JSR     L05702(PC)
       BNE.S   L0975C
       MOVEA.L $003C(A6),A5
       RTS

L097DC BSR.S   L097E0
       RTS

L097E0 MOVEA.L $0030(A6),A0
       MOVEA.L $00(A6,A0.L),A0
       MOVE.L  D0,-(A7)
       MOVEQ   #-$1B,D0
       JSR     L03968(PC)
       MOVE.L  (A7)+,D0
L097F2 MOVEA.L $003C(A6),A5
       CMPA.L  $0038(A6),A5
       BLE.S   L09828
       MOVE.B  -$08(A6,A5.L),D5
       BEQ.S   L0980A
       BSR     L09768
       SUBA.W  #$0010,A5
L0980A SUBQ.W  #8,A5
       MOVE.L  A5,$003C(A6)
       SUBQ.B  #2,D5
       BLT.S   L097F2
       MOVEA.L $001C(A6),A5
       SUBQ.W  #8,A5
L0981A MOVEQ   #$00,D2
       JSR     L05CBC(PC)
       BNE.S   L0981A
       MOVE.L  A5,$001C(A6)
       BRA.S   L097F2

L09828 SF      $0090(A6)
       MOVEA.L (A7)+,A3
       MOVEA.L (A7)+,A5
       TRAP    #$00
       MOVEA.L $0064(A6),A1
       ADDA.L  A6,A1
       SUBQ.W  #4,A1
       MOVE.L  A1,USP
       MOVE.W  #$0000,SR
       MOVE.L  A5,-(A7)
       MOVE.L  A3,-(A7)
       ST      $006F(A6)
       TST.B   $00B8(A6)
       BNE     L0A6EE
       RTS

L09852 MOVE.L  A4,-(A7)
       JSR     L09B32(PC)
       BLT.S   L09872
L0985A ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       MOVE.L  A4,-(A7)
       JSR     L09B32(PC)
       CMPA.L  (A7)+,A4
       BNE.S   L09870
       TST.B   D0
       BGE.S   L0985A
       BRA.S   L09872

L09870 MOVEQ   #$00,D0
L09872 MOVEA.L (A7)+,A4
       RTS

L09876 MOVEQ   #$00,D6
       MOVE.L  A4,D3
L0987A MOVE.W  $00(A6,A4.L),D1
       CMPI.W  #$810A,D1
       BEQ.S   L098A0
       JSR     L09686(PC)
       BEQ.S   L098A2
       CMPI.W  #$8401,D1
       BNE.S   L0989A
       TST.B   D6
       BNE.S   L0989A
       ADDQ.W  #2,A4
       MOVE.L  A4,D3
       MOVEQ   #$01,D6
L0989A JSR     L09072(PC)
       BRA.S   L0987A

L098A0 MOVEQ   #-$01,D0
L098A2 MOVEA.L D3,A4
       RTS

* execute DEFINE
L098A6 MOVEQ   #$07,D2
L098A8 JSR     L0A60E(PC)
       BNE.S   L098C2
       JSR     L0A56C(PC)
       CMPI.W  #$8101,D1
       BNE.S   L098A8
       ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       CMP.B   D2,D1
       BNE.S   L098A8
L098C2 MOVEQ   #$00,D0
       RTS

* execute DIM
L098C6 MOVEM.L D4-D6/A5,-(A7)
       SUBQ.W  #2,A4
L098CC ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       BSR.S   L098E8
       BNE.S   L098E2
       JSR     L0A56C(PC)
       CMPI.W  #$8404,D1
       BEQ.S   L098CC
       MOVEQ   #$00,D0
L098E2 MOVEM.L (A7)+,D4-D6/A5
       RTS

L098E8 MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L0A56C(PC)
       ADDQ.W  #2,A4
       MOVEQ   #$00,D5
       MOVEA.L (A6),A5
       MOVEA.L A4,A0
L098FC MOVE.L  A5,-(A7)
       JSR     L05A82(PC)
       MOVEA.L (A7)+,A5
       MOVEA.L A0,A4
       BNE.S   L09980
       ADDQ.L  #1,D5
       MOVE.W  $00(A6,A1.L),$00(A6,A5.L)
       BLT.S   L0997A
       ADDQ.W  #4,A5
       ADDQ.L  #2,$0058(A6)
       ADDQ.W  #2,A0
       CMPI.W  #$8404,-$02(A6,A0.L)
       BEQ.S   L098FC
       CMPI.W  #$8406,-$02(A6,A0.L)
       BNE.S   L0997E
       LSL.L   #3,D4
       MOVEA.L $0018(A6),A3
       ADDA.L  D4,A3
       CMPI.B  #$03,$00(A6,A3.L)
       BNE.S   L09982
       MOVE.B  $01(A6,A3.L),D6
       CMPI.B  #$01,D6
       BNE.S   L09958
       MOVE.W  -$04(A6,A5.L),D1
       ADDQ.W  #1,D1
       BCLR    #$00,D1
       MOVE.W  D1,-$04(A6,A5.L)
       BLE.S   L0997A
       MOVEQ   #$02,D1
       BRA.S   L0995A

L09958 MOVEQ   #$01,D1
L0995A MOVE.L  D5,D0
       MOVEQ   #$01,D2
L0995E SUBQ.W  #4,A5
       MOVE.W  D2,$02(A6,A5.L)
       SUBQ.L  #1,D0
       BEQ.S   L09986
       MOVE.L  D1,D3
       MOVEQ   #$01,D1
       ADD.W   $00(A6,A5.L),D3
       MULU    D3,D2
       MOVE.L  D2,D3
       SWAP    D3
       TST.W   D3
       BEQ.S   L0995E
L0997A MOVEQ   #-$04,D0
       RTS

L0997E MOVEQ   #-$11,D0
L09980 RTS

L09982 MOVEQ   #-$0C,D0
       RTS

L09986 MOVEA.L A0,A4
       MOVE.L  $04(A6,A3.L),D4
       BLT.S   L09990
       BSR.S   L099FE
L09990 MOVE.L  D5,D1
       LSL.L   #2,D1
       ADDQ.L  #6,D1
       MOVE.L  A3,-(A7)
       JSR     L04DF6(PC)
       MOVEA.L (A7)+,A3
       MOVE.L  A0,D1
       SUB.L   $0028(A6),D1
       MOVE.L  D1,$04(A6,A3.L)
       MOVE.L  A0,-(A7)
       MOVE.W  D5,$04(A6,A0.L)
       ADDQ.W  #6,A0
L099B0 MOVE.L  $00(A6,A5.L),$00(A6,A0.L)

       ADDQ.W  #4,A5
       ADDQ.W  #4,A0
       SUBQ.L  #1,D5
       BGT.S   L099B0
       MOVEA.L (A6),A5
       MOVEQ   #$01,D1
       ADD.W   $00(A6,A5.L),D1
       MULU    $02(A6,A5.L),D1
       SUBQ.B  #2,D6
       BLT.S   L099DC
       BEQ.S   L099D4
       ADD.L   D1,D1
       BRA.S   L099DC

L099D4 ADD.L   D1,D1
       MOVE.L  D1,D0
       ADD.L   D1,D1
       ADD.L   D0,D1
L099DC MOVE.L  A3,-(A7)
       JSR     L04DF6(PC)
       MOVEA.L (A7)+,A3
       MOVE.L  A0,D2
       SUB.L   $0028(A6),D2
       MOVEA.L (A7)+,A2
       MOVE.L  D2,$00(A6,A2.L)
L099F0 CLR.W   $00(A6,A0.L)
       ADDQ.W  #2,A0
       SUBQ.L  #2,D1
       BGT.S   L099F0
       MOVEQ   #$00,D0
       RTS

L099FE MOVEA.L $0028(A6),A2
       ADDA.L  D4,A2
       MOVEQ   #$01,D2
       ADD.W   $06(A6,A2.L),D2
       MULU    $08(A6,A2.L),D2
       MOVE.B  D6,D1
       SUBQ.B  #2,D1
       BLT.S   L09A22
       BEQ.S   L09A1A
       ADD.L   D2,D2
       BRA.S   L09A22

L09A1A ADD.L   D2,D2
       MOVE.L  D2,D1
       ADD.L   D2,D2
       ADD.L   D1,D2
L09A22 MOVE.L  D2,D1
       MOVEA.L $0028(A6),A0
       ADDA.L  $00(A6,A2.L),A0
       MOVE.L  A3,-(A7)
       MOVE.L  A2,-(A7)
       JSR     L04FE8(PC)
       MOVEA.L (A7)+,A2
       BSR.S   L09A3C
       MOVEA.L (A7)+,A3
       RTS

L09A3C MOVEQ   #$00,D1
       MOVE.W  $04(A6,A2.L),D1
       LSL.L   #2,D1
       ADDQ.L  #6,D1
       MOVEA.L A2,A0
       JMP     L04FE8(PC)

* execute ELSE
L09A4C MOVEQ   #$00,D4
L09A4E JSR     L09B32(PC)
       BGE.S   L09A5A
       TST.B   $006E(A6)
       BNE.S   L09AA4
L09A5A JSR     L0A60E(PC)
       BNE.S   L09AA4
       JSR     L0A56C(PC)
       CMPI.B  #$81,D0
       BNE.S   L09A4E
       ADDQ.W  #2,A4
       CMPI.B  #$03,D1
       BNE.S   L09A8C
       JSR     L09852(PC)
       BLT.S   L09A88
       TST.B   $006E(A6)
       BNE.S   L09A88
L09A7E JSR     L09B32(PC)
       BLT.S   L09A5A
       ADDQ.W  #2,A4
       BRA.S   L09A7E

L09A88 ADDQ.W  #1,D4
       BRA.S   L09A4E

L09A8C CMPI.B  #$01,D1
       BNE.S   L09A4E
       JSR     L0A56C(PC)
       CMPI.W  #$8103,D1
       BNE.S   L09A4E
       TST.B   D4
       BEQ.S   L09AA4
       SUBQ.W  #1,D4
       BRA.S   L09A4E

L09AA4 MOVEQ   #$00,D0
       RTS

* exec END
L09AA8 JSR     L0A56C(PC)
       CMPI.W  #$8107,D1
       BEQ     L096E6
       CMPI.W  #$8106,D1
       BEQ.S   L09AE6
       MOVEQ   #$06,D5
       CMPI.W  #$8104,D1
       BEQ.S   L09ACA
       MOVEQ   #$07,D5
       CMPI.W  #$8102,D1
       BNE.S   L09B28
L09ACA ADDQ.W  #2,A4
       JSR     L0A09E(PC)
       BNE.S   L09B2A
       CMP.B   D5,D1
       BNE.S   L09B2E
       MOVE.W  $0068(A6),$08(A6,A2.L)
       MOVE.B  $006C(A6),$0B(A6,A2.L)
       JMP     L0A37A(PC)

L09AE6 TST.B   $00C0(A6)
       BNE     L07E50           * LCONTINUE
L09AEE MOVE.W  $0068(A6),D4
       MOVEQ   #-$01,D3
       JSR     L0ACC2(PC)
       BNE.S   L09B28
L09AFA MOVE.W  $08(A6,A2.L),D4
       SEQ     $006F(A6)
       MOVE.B  $0A(A6,A2.L),-(A7)
       MOVE.B  $0B(A6,A2.L),$006E(A6)
       MOVE.W  $0C(A6,A2.L),$0070(A6)
       ST      $08(A6,A2.L)
       JSR     L09FA2(PC)
       BNE.S   L09B2C
       JSR     L0A96A(PC)
       BNE.S   L09B2C
       MOVE.B  (A7)+,D4
       JSR     L0A00A(PC)
L09B28 MOVEQ   #$00,D0
L09B2A RTS

L09B2C ADDQ.W  #2,A7
L09B2E MOVEQ   #-$07,D0
       RTS

L09B32 MOVEQ   #$00,D0
       MOVE.W  $00(A6,A4.L),D1
       CMPI.W  #$8402,D1
       BEQ.S   L09B5C
       CMPI.W  #$840A,D1
       BEQ.S   L09B5A
       MOVEQ   #$01,D0
       CMPI.W  #$811C,D1
       BEQ.S   L09B5C
       MOVEQ   #$02,D0
       CMPI.W  #$8114,D1
       BEQ.S   L09B5C
       JSR     L09072(PC)
       BRA.S   L09B32

L09B5A MOVEQ   #-$01,D0
L09B5C RTS

L09B5E MOVE.W  $0068(A6),$0092(A6)

       TST.B   $006F(A6)
       BEQ.S   L09B70
       MOVE.W  #-1,$0092(A6)

L09B70 MOVE.B  $006C(A6),$0091(A6)
       MOVE.B  $006E(A6),$009A(A6)
       MOVE.W  $0070(A6),$0098(A6)
       MOVE.L  $003C(A6),D1
       SUB.L   $0038(A6),D1
       SNE     $0090(A6)
       RTS

L09B90 MOVEQ   #-1,D0
L09B92 TST.B   $00C0(A6)
       BNE.S   L09BB6
       BSR.S   L09B5E
       BRA.S   L09BD4

L09B9C ST      $006F(A6)        * error handling
       CMPI.L  #-21,D0
       BEQ.S   L09B92
L09BA8 CMPI.L  #-1,D0
       BEQ.S   L09B92
       TST.B   $00C0(A6)
       BEQ.S   L09BC0
L09BB6 BSR.S   L09BD4
       MOVEQ   #-26,D0
       JSR     L03968(PC)
       BRA.S   L09C18

L09BC0 BSR.S   L09B5E
       MOVE.W  $0068(A6),$00C6(A6)
       MOVE.L  D0,$00C2(A6)
       BGE.S   L09C18
       MOVE.W  $00BC(A6),D4
       BNE.S   L09C1C
L09BD4 MOVEA.L $0030(A6),A0
       MOVEA.L $00(A6,A0.L),A0
L09BDC MOVE.W  #-1,$0088(A6)
       TST.B   $006F(A6)
       BNE.S   L09C14
       MOVE.L  D0,-(A7)
       MOVEQ   #-$16,D0
       JSR     L03968(PC)
       MOVEA.L A0,A5
       MOVEA.W #$0068,A1
       MOVEA.L (A6),A0
       JSR     L03E54(PC)
       MOVE.B  #$20,$00(A6,A0.L)
       ADDQ.W  #1,D1
       MOVEA.L (A6),A1
       MOVE.W  D1,D2
       MOVEA.L A5,A0
       MOVEQ   #$07,D0
       MOVEQ   #-$01,D3
       TRAP    #$04
       TRAP    #$03
       MOVE.L  (A7)+,D0
L09C14 JSR     L03968(PC)
L09C18 MOVEQ   #-$01,D0
       RTS

L09C1C ST      $00C0(A6)
       MOVE.L  D0,-(A7)
       TST.B   $006F(A6)
       BEQ.S   L09C2E
       JSR     L0958E(PC)
       BNE.S   L09C56
L09C2E JSR     L09FA2(PC)
       JSR     L0A966(PC)
       BNE.S   L09C56
       JSR     L0A56C(PC)
       CMPI.W  #$8106,D1
       BNE.S   L09C56
       ADDQ.W  #4,A7
       MOVE.B  $00BF(A6),$006E(A6)
       MOVE.B  $00BE(A6),D4
       JSR     L0A00A(PC)
       JMP     L0A90C(PC)

L09C56 CLR.W   $00BC(A6)
       SF      $00C0(A6)
       MOVE.L  (A7)+,D0
       BRA     L09BD4

* execute EXIT
L09C64 JSR     L0A09E(PC)
       BNE     L09CFC
       MOVE.W  $08(A6,A2.L),D4
       BEQ.S   L09C88
       JSR     L09FA2(PC)
       BNE.S   L09C86
       JSR     L0A966(PC)
       BNE.S   L09C86
       MOVE.B  $0B(A6,A2.L),D4
       JSR     L0A00A(PC)
L09C86 BRA.S   L09CFA

L09C88 MOVE.W  -$02(A6,A4.L),D4
       MOVEQ   #$07,D5
       SUB.B   D1,D5
L09C90 JSR     L09B32(PC)
       BLT.S   L09C9E
       ADDQ.W  #2,A4
       ADDQ.B  #1,$006C(A6)
       BRA.S   L09CC0

L09C9E TST.B   $006E(A6)
       BEQ.S   L09CB2
       SF      $006E(A6)
       MOVE.W  $0068(A6),D0
       CMP.W   $06(A6,A2.L),D0
       BEQ.S   L09CFA
L09CB2 TST.B   $006F(A6)
       BNE.S   L09CFA
       ADDQ.W  #2,A4
       JSR     L0A966(PC)
       BNE.S   L09CFA
L09CC0 JSR     L0A56C(PC)
       CMPI.W  #$8101,D1
       BNE.S   L09C90
       ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       TST.B   D5
       BEQ.S   L09CDC
       CMPI.W  #$8104,D1
       BNE.S   L09C90
       BRA.S   L09CE2

L09CDC CMPI.W  #$8102,D1
       BNE.S   L09C90
L09CE2 ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       CMP.W   $02(A6,A4.L),D4
       BNE.S   L09C90
       MOVE.W  $0068(A6),$08(A6,A2.L)

       MOVE.B  $006C(A6),$0B(A6,A2.L)

L09CFA MOVEQ   #$00,D0
L09CFC RTS

L09CFE MOVEQ   #$00,D5
L09D00 BSR.S   L09D46
       BNE.S   L09D56
       JSR     L0A56C(PC)
       CMPI.B  #$81,D0
       BNE.S   L09D00
       ADDQ.W  #2,A4
       CMPI.B  #$01,D1
       BNE.S   L09D26
       JSR     L0A56C(PC)
       CMPI.W  #$8105,D1
       BNE.S   L09D00
       SUBQ.W  #1,D5
       BLT.S   L09D56
       BRA.S   L09D00

L09D26 CMPI.B  #$05,D1
       BNE.S   L09D00
       JSR     L09852(PC)
       BLT.S   L09D38
       TST.B   $006E(A6)
       BEQ.S   L09D3C
L09D38 ADDQ.W  #1,D5
       BRA.S   L09D00

L09D3C JSR     L09B32(PC)
       BLT.S   L09D00
       ADDQ.W  #2,A4
       BRA.S   L09D3C

L09D46 JSR     L0A60E(PC)
       BNE.S   L09D64
       TST.B   D0
       BEQ.S   L09D56
       TST.B   $006E(A6)
       BNE.S   L09D5A
L09D56 MOVEQ   #$00,D0
       RTS

L09D5A SUBQ.W  #8,A4
       MOVE.W  $02(A6,A4.L),D0
       SUB.W   D0,$006A(A6)
L09D64 TST.B   $006E(A6)
       BGT.S   L09D6E
       SF      $006E(A6)
L09D6E MOVEQ   #$01,D0
       RTS

L09D72 MOVEQ   #$00,D5
L09D74 JSR     L09D46(PC)
       BNE.S   L09DEC
       JSR     L0A56C(PC)
       CMPI.W  #$8401,D1
       BNE.S   L09D8C
       ADDQ.W  #2,A4
       TST.B   D5
       BEQ.S   L09DEE
       BRA.S   L09D74

L09D8C CMPI.B  #$81,D0
       BNE.S   L09D74
       CMPI.B  #$15,D1
       BNE.S   L09DB6
       TST.B   D5
       BNE.S   L09D74
       JSR     L09876(PC)
       BLT.S   L09D74
       MOVEA.L A4,A3
L09DA4 SUBQ.W  #2,A3
       CMPI.W  #$8800,$00(A6,A3.L)

       BNE.S   L09DA4
       CMP.W   $02(A6,A3.L),D4
       BNE.S   L09D74
       BRA.S   L09DEE

L09DB6 CMPI.B  #$05,D1
       BNE.S   L09DD6
       JSR     L09852(PC)
       BLT.S   L09DC8
       TST.B   $006E(A6)
       BEQ.S   L09DCC
L09DC8 ADDQ.W  #1,D5
       BRA.S   L09D74

L09DCC JSR     L09B32(PC)
       BLT.S   L09D74
       ADDQ.W  #2,A4
       BRA.S   L09DCC

L09DD6 CMPI.B  #$01,D1
       BNE.S   L09D74
       ADDQ.W  #2,A4
       JSR     L0A56C(PC)
       CMPI.W  #$8105,D1
       BNE.S   L09D74
       SUBQ.W  #1,D5
       BGE.S   L09D74
L09DEC RTS

L09DEE MOVEQ   #$00,D0
       RTS

* execute FOR
L09DF2 MOVEA.L A4,A5
       JSR     L0A56C(PC)
       MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L09852(PC)
       BLT.S   L09E10
       MOVE.B  #$01,$006E(A6)
       MOVE.W  D4,$0070(A6)
L09E10 JSR     L09F96(PC)
       MOVE.B  $01(A6,A2.L),D2
       SUBQ.B  #2,D2
       BNE.S   L09E30
       MOVE.B  $00(A6,A2.L),D2
       MOVEQ   #$06,D1
       SUBQ.B  #2,D2
       BEQ.S   L09E34
       MOVEQ   #$0C,D1
       SUBQ.B  #4,D2
       BEQ.S   L09E34
       SUBQ.B  #1,D2
       BEQ.S   L09E5C
L09E30 MOVEQ   #-$0C,D0
       RTS

L09E34 MOVE.L  A2,-(A7)
       MOVE.L  $04(A6,A2.L),D2
       BLT.S   L09E46
       MOVEA.L $0028(A6),A0
       ADDA.L  D2,A0
       JSR     L04FE8(PC)
L09E46 MOVEQ   #$1A,D1
       JSR     L04DF6(PC)
       SUBA.L  $0028(A6),A0
       MOVEA.L (A7)+,A2
       MOVE.B  #$07,$00(A6,A2.L)
       MOVE.L  A0,$04(A6,A2.L)
L09E5C JSR     L0A2FE(PC)
       JSR     L0A56C(PC)
       MOVE.L  A4,D0
       SUB.L   A5,D0
       MOVE.L  D7,$0C(A6,A2.L)
       MOVE.L  D7,$10(A6,A2.L)
       MOVE.L  D7,$14(A6,A2.L)
       MOVE.W  D0,$18(A6,A2.L)
       JSR     L09E88(PC)
       BGT.S   L09E80
       RTS

L09E80 MOVEQ   #$00,D5
       JMP     L09C90(PC)

L09E86 DC.B    $01
L09E87 DC.B    $40
L09E88 MOVE.L  A4,-(A7)
       MOVE.W  $00(A6,A4.L),D1
       JSR     L09686(PC)
       BNE.S   L09E98
       MOVEQ   #$01,D0
       BRA.S   L09EA6

L09E98 CMPI.W  #$8401,D1
       BEQ.S   L09EAA
       CMPI.W  #$8404,D1
       BEQ.S   L09EAA
       MOVEQ   #-$04,D0
L09EA6 ADDQ.W  #4,A7
       RTS

L09EAA ADDQ.W  #2,A4
       MOVEA.L A4,A0
       MOVE.L  D4,D6
       JSR     L05A7E(PC)
       MOVEA.L A0,A4
       BNE.S   L09EA6
       BSR     L09F7E
       MOVE.W  $00(A6,A1.L),$00(A6,A2.L)
       MOVE.L  $02(A6,A1.L),$02(A6,A2.L)
       ADDQ.L  #6,$0058(A6)
       CMPI.W  #$810B,$00(A6,A4.L)
       BEQ.S   L09EF4
       MOVE.W  $00(A6,A2.L),$0C(A6,A2.L)
       MOVE.L  $02(A6,A2.L),$0E(A6,A2.L)
       MOVE.W  D7,$12(A6,A2.L)
       MOVE.L  D7,$14(A6,A2.L)
       MOVE.L  A4,D0
       SUB.L   (A7)+,D0
       ADD.W   D0,$18(A6,A2.L)
       BRA     L09F76

L09EF4 ADDQ.W  #2,A4
       MOVEA.L A4,A0
       JSR     L05A7E(PC)
       MOVEA.L A0,A4
L09EFE BNE.S   L09EA6
       BSR.S   L09F7E
       MOVE.W  $00(A6,A1.L),$0C(A6,A2.L)
       MOVE.L  $02(A6,A1.L),$0E(A6,A2.L)
       ADDQ.L  #6,$0058(A6)
       CMPI.W  #$811D,$00(A6,A4.L)
       BEQ.S   L09F32
       MOVE.B  #$08,$12(A6,A2.L)
       MOVE.B  L09E86(PC),$13(A6,A2.L)
       MOVE.L  D7,$14(A6,A2.L)
       MOVE.B  L09E87(PC),$14(A6,A2.L)
       BRA.S   L09F50

L09F32 ADDQ.W  #2,A4
       MOVEA.L A4,A0
       JSR     L05A7E(PC)
       MOVEA.L A0,A4
       BNE.S   L09EFE
       BSR.S   L09F7E
       MOVE.W  $00(A6,A1.L),$12(A6,A2.L)
       MOVE.L  $02(A6,A1.L),$14(A6,A2.L)
       ADDQ.L  #6,$0058(A6)
L09F50 MOVE.L  A4,D0
       SUB.L   (A7)+,D0
       ADD.W   D0,$18(A6,A2.L)
       JSR     L04E4C(PC)
       MOVEA.L $0058(A6),A1
       SUBQ.W  #6,A1
       MOVE.L  $02(A6,A2.L),$02(A6,A1.L)
       MOVE.W  $00(A6,A2.L),$00(A6,A1.L)
       JSR     L0A404(PC)
       BRA.S   L09F78

       BRA.S   L09F7A

L09F76 MOVEQ   #$00,D0
L09F78 RTS

L09F7A BRA     L09E88

L09F7E MOVE.L  D6,D4
L09F80 BSR.S   L09F96
       MOVE.B  $00(A6,A2.L),D1
       MOVE.B  $01(A6,A2.L),D2
       MOVE.L  $04(A6,A2.L),D0
       MOVEA.L $0028(A6),A2
       ADDA.L  D0,A2
       RTS

L09F96 MOVE.L  D4,D0
       MOVEA.L $0018(A6),A2
       LSL.L   #3,D0
       ADDA.W  D0,A2
       RTS

L09FA2 TST.B   $006F(A6)
       BEQ.S   L09FAE
       MOVEA.L $0008(A6),A4
       BRA.S   L0A006

L09FAE CMPI.W  #$840A,$00(A6,A4.L)
       BEQ.S   L09FBC
       JSR     L09072(PC)
       BRA.S   L09FAE

L09FBC ADDQ.W  #2,A4
L09FBE MOVEQ   #$00,D1
       MOVEQ   #$00,D2
       CMP.W   $0068(A6),D4
       BLE.S   L09FEC
L09FC8 CMPA.L  $0014(A6),A4
       BLT.S   L09FD2
       JMP     L0A994(PC)

L09FD2 CMP.W   $04(A6,A4.L),D4
       BLE.S   L0A006
L09FD8 MOVE.W  $04(A6,A4.L),D2
       MOVE.W  $00(A6,A4.L),D1
       ADDQ.W  #2,A4
       ADD.W   D1,$006A(A6)
       ADDA.W  $006A(A6),A4
       BRA.S   L09FC8

L09FEC SUBA.W  $006A(A6),A4
       SUBQ.W  #2,A4
       MOVE.W  $00(A6,A4.L),D1
       SUB.W   D1,$006A(A6)
       CMP.W   $04(A6,A4.L),D4
       BGT.S   L09FD8
       CMPA.L  $0010(A6),A4
       BGT.S   L09FEC
L0A006 MOVEQ   #$00,D0
       RTS

L0A00A CMP.B   $006C(A6),D4
       BLE.S   L0A01E
       JSR     L09B32(PC)
       BLT.S   L0A01E
       ADDQ.W  #2,A4
       ADDQ.B  #1,$006C(A6)
       BRA.S   L0A00A

L0A01E MOVEQ   #$00,D0
       RTS

* execute GO
L0A022 MOVEQ   #$01,D4
       BRA.S   L0A038

* execute ON ...
L0A026 JSR     L09876(PC)
       BGE     L09CFE
       BSR.S   L0A086
       MOVE.W  $00(A6,A1.L),D4
       BLE.S   L0A082
       ADDQ.W  #2,A4
L0A038 JSR     L0A56C(PC)
       CMPI.B  #$0B,D1
       SEQ     D5
L0A042 MOVE.W  $00(A6,A4.L),D1
       JSR     L09686(PC)
       BEQ.S   L0A082
       ADDQ.W  #2,A4
       BSR.S   L0A086
       BGT.S   L0A042
       SUBQ.W  #1,D4
       BNE.S   L0A042
       MOVE.W  $00(A6,A1.L),D4
       TST.B   D5
       BEQ     L094CA
       SF      $006E(A6)
       TST.B   $006F(A6)
       BEQ.S   L0A078
       SF      $006F(A6)
       MOVEA.L $0010(A6),A4
       JSR     L0A966(PC)
       BNE.S   L0A07E
L0A078 JSR     L09FA2(PC)
       SUBQ.W  #2,A4
L0A07E MOVEQ   #$00,D0
       RTS

L0A082 MOVEQ   #-$04,D0
       RTS

L0A086 MOVEA.L A4,A0
       JSR     L05A82(PC)
       MOVEA.L A0,A4
       BLT.S   L0A09A
       BGT.S   L0A098
       ADDQ.L  #2,$0058(A6)
       MOVEQ   #$00,D0
L0A098 RTS

L0A09A ADDQ.W  #4,A7
       RTS

L0A09E JSR     L0A56C(PC)
       MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
L0A0AA JSR     L09F80(PC)
       MOVEQ   #$00,D0
       MOVE.B  D1,D0
       SUBQ.B  #6,D0
       BEQ.S   L0A0BC
       SUBQ.B  #1,D0
       BEQ.S   L0A0BC
       MOVEQ   #-$07,D0
L0A0BC RTS

* execute IF
L0A0BE MOVEA.L A4,A0
       JSR     L05A7E(PC)
       MOVEA.L A0,A4
       BNE     L0A150
       JSR     L09852(PC)
       BLT.S   L0A0DA
       TST.B   $006E(A6)
       BNE.S   L0A0DA
       ST      $006E(A6)
L0A0DA ADDQ.L  #6,$0058(A6)
       TST.W   $00(A6,A1.L)
       BNE.S   L0A14E
       MOVEQ   #$00,D4
L0A0E6 JSR     L09B32(PC)
       BGE.S   L0A0F2
       TST.B   $006E(A6)
       BNE.S   L0A14E
L0A0F2 JSR     L0A60E(PC)
       BNE.S   L0A14E
       JSR     L0A56C(PC)
       CMPI.B  #$81,D0
       BNE.S   L0A0E6
       ADDQ.W  #2,A4
       CMPI.B  #$03,D1
       BNE.S   L0A124
       JSR     L09852(PC)
       BLT.S   L0A120
       TST.B   $006E(A6)
       BNE.S   L0A120
L0A116 JSR     L09B32(PC)
       BLT.S   L0A0F2
       ADDQ.W  #2,A4
       BRA.S   L0A116

L0A120 ADDQ.W  #1,D4
       BRA.S   L0A0E6

L0A124 CMPI.B  #$01,D1
       BNE.S   L0A13C
       JSR     L0A56C(PC)
       CMPI.W  #$8103,D1
       BNE.S   L0A0E6
       TST.B   D4
       BEQ.S   L0A14E
       SUBQ.W  #1,D4
       BRA.S   L0A0E6

L0A13C CMPI.B  #$14,D1
       BNE.S   L0A0E6
       TST.B   D4
       BEQ.S   L0A14C
       ADDQ.B  #1,$006C(A6)
       BRA.S   L0A0E6

L0A14C SUBQ.W  #2,A4
L0A14E MOVEQ   #$00,D0
L0A150 RTS


* LABELS RELATIV TO A190
* USED TO EXECUTE DEPENDING INSTRUCTIONS 
L0A152 DC.W    L09AA8-L0A190    * END
       DC.W    L09DF2-L0A190    * FOR
       DC.W    L0A0BE-L0A190    * IF
       DC.W    L0A7B6-L0A190    * REPEAT
       DC.W    L0A84A-L0A190    * SELECT
       DC.W    L0AC00-L0A190    * WHEN
       DC.W    L098A6-L0A190    * DEFINE
       DC.W    $0               * PROCEDURE:USELESS IF ALONE
       DC.W    $0               * FUNCTION: USELESS IF ALONE
       DC.W    L0A022-L0A190    * GO
       DC.W    $0               * TO:USELESS IF ALONE
       DC.W    $0               * SUB: USELESS F ALONE
       DC.W    $0               * WHEN: USELESS IF ALONE
       DC.W    $0               * ERROR: USELESS IF ALONE
       DC.W    $0               * EOF
       DC.W    $0               * INPUT
       DC.W    L0A820-L0A190    * RESTORE
       DC.W    L0A372-L0A190    * NEXT
       DC.W    L09C64-L0A190    * EXIT
       DC.W    L09A4C-L0A190    * ELSE
       DC.W    L0A026-L0A190    * ON
       DC.W    L096E6-L0A190    * RETURN
       DC.W    $0               * REMAINDER
       DC.W    L0A7B2-L0A190    * DATA
       DC.W    L098C6-L0A190    * DIM
       DC.W    L0A2FA-L0A190    * LOCAL
       DC.W    L0A332-L0A190    * LET
       DC.W    $0               * THEN
       DC.W    $0               * STEP
       DC.W    L0A7B2-L0A190    * REMARK
       DC.W    L0A2FA-L0A190    * MISTAKE

L0A190 MOVEQ   #0,D0
       MOVE.B  $01(A6,A4.L),D0
       ADDQ.W  #2,A4
       ADD.B   D0,D0
       MOVE.W  L0A150(PC,D0.W),D0
       BEQ.S   L0A1A4
       JMP     L0A190(PC,D0.W)
L0A1A4 MOVEQ   #-7,D0
       RTS

L0A1A8 MOVE.L  A2,A3
       ANDI.B  #$0F,$01(A6,A3.L)
       MOVE.L  A3,-(A7)
       MOVE.B  $1(A6,A3.L),-(A7)
       JSR     L07A8E(PC)
       BNE.S   L0A1E8
       CMPI.W  #$8405,D1
       BNE.S   L0A1F6
       CMPI.B  #$01,$01(A6,A3.L)
       BNE.S   L0A242
       MOVE.L  $04(A6,A3.L),D0
       BLT.S   L0A242
       MOVEA.L $0028(A6),A2
       ADDA.L  D0,A2
       MOVE.L  D0,-(A7)
       LEA     $0002(A4),A0
       JSR     L06446(PC)
       MOVEA.L A0,A4
       MOVEA.L $0028(A6),A2
       ADDA.L  (A7)+,A2
L0A1E8 BNE.S   L0A244
       JSR     L0A56C(PC)
       CMPI.W  #$8401,D1
       BNE.S   L0A242
       SF      (A7)       
L0A1F6 CMPI.W  #$8401,D1
       BNE.S   L0A242
       ADDQ.W  #2,A4
       MOVE.B  (A7),D0
       MOVEA.L A4,A0
       SUBA.L  $0028(A6),A2
       MOVE.L  A2,-(A7)
       JSR     L05A84(PC)
       MOVEA.L $0028(A6),A2
       ADDA.L  (A7)+,A2
       MOVEA.L A0,A4
       BNE.S   L0A23C
       MOVE.B  (A7)+,D0
       MOVEA.L (A7)+,A3
       MOVE.B  D0,$01(A6,A3.L)
       JSR     L072C2(PC)
       BNE.S   L0A23A
       TST.W   $00C8(A6)
       BEQ.S   L0A23A
       MOVE.B  $00(A6,A3.L),D1
       SUBQ.B  #2,D1
       BEQ.S   L0A248
       SUBQ.B  #4,D1
       BEQ.S   L0A248
       SUBQ.B  #1,D1
       BEQ.S   L0A248
L0A23A RTS


L0A23C BLT.S   L0A244
       MOVEQ   #-$11,D0
       BRA.S   L0A244

* handling of MISTAKE and LOCAL
L0A242 MOVEQ   #-$0C,D0
L0A244 ADDQ.W  #6,A7
       RTS

* initialise WHEN

L0A248 MOVE.L  A3,D4
       SUB.L   $0018(A6),D4
       LSR.L   #3,D4
       MOVEQ   #$01,D3
       JSR     L0ACC2(PC)
L0A256 BNE     L0A2DA
       TST.W   $08(A6,A2.L)
       BLT.S   L0A268
L0A260 MOVEQ   #$01,D3
       JSR     L0ACDA(PC)
       BRA.S   L0A256

L0A268 MOVE.W  $0068(A6),$08(A6,A2.L)
       MOVE.B  $006C(A6),$0A(A6,A2.L)
       MOVE.B  $006E(A6),$0B(A6,A2.L)
       MOVE.W  $0070(A6),$0C(A6,A2.L)
       MOVE.W  D4,-(A7)
       MOVE.W  D2,-(A7)
       MOVE.L  D1,-(A7)
       MOVE.W  $02(A6,A2.L),D4
       MOVE.B  $04(A6,A2.L),D1
       SUBA.L  $0028(A6),A2
       MOVE.L  A2,-(A7)
       MOVE.B  D1,-(A7)
       TST.B   $006F(A6)
       BEQ.S   L0A2A0
       JSR     L0958E(PC)
L0A2A0 JSR     L09FA2(PC)
       BNE.S   L0A2F2
       JSR     L0A96A(PC)
       BNE.S   L0A2F2
       MOVE.B  (A7)+,D4
       JSR     L0A00A(PC)
       JSR     L0A56C(PC)
       LEA     $0002(A4),A0
       JSR     L05A7E(PC)
       MOVEA.L A0,A4
       MOVEA.L (A7)+,A2
       BNE.S   L0A2F6
       ADDA.L  $0028(A6),A2
       ADDQ.L  #6,$0058(A6)
       TST.W   $00(A6,A1.L)
       BEQ.S   L0A2DE
       ADDQ.W  #8,A7
       MOVE.B  $0E(A6,A2.L),$006E(A6)

L0A2DA MOVEQ   #$00,D0
       RTS

L0A2DE MOVE.L  A2,-(A7)
       JSR     L09AFA(PC)
       MOVEA.L (A7)+,A2
       BNE.S   L0A2F6
       MOVE.L  (A7)+,D1
       MOVE.W  (A7)+,D2
       MOVE.W  (A7)+,D4
       BRA     L0A260

L0A2F2 MOVEQ   #-$07,D0
       ADDQ.W  #6,A7
L0A2F6 ADDQ.W  #8,A7
       RTS

* execute LOCAL and MISTAKE
L0A2FA MOVEQ   #-$15,D0
       RTS
*---------- END INITIALISE WHEN

* 'STODEBOU'
L0A2FE MOVEA.L $04(A6,A2.L),A2
       ADDA.L  $0028(A6),A2
       MOVE.W  D7,$00(A6,A2.L)
       MOVE.L  D7,$02(A6,A2.L)
       MOVE.W  $0068(A6),D1
       MOVE.B  $006C(A6),D0
       CMP.W   $06(A6,A2.L),D1
       BNE.S   L0A322
       CMP.B   $0A(A6,A2.L),D0
       BEQ.S   L0A32E
L0A322 MOVE.W  D1,$06(A6,A2.L)
       MOVE.L  D7,$08(A6,A2.L)
       MOVE.B  D0,$0A(A6,A2.L)
L0A32E MOVEQ   #$00,D0
       RTS

* handling of LET

L0A332 JSR     L0A56C(PC)
       CMPI.B  #$88,D0
       BNE.S   L0A36E
L0A33C MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L0A56C(PC)
       JSR     L09F96(PC)
       MOVE.B  $00(A6,A2.L),D0
       CMPI.B  #$03,D0
       BEQ     L093E6
       CMPI.B  #$08,D0
       BEQ     L0A6F6
       MOVEQ   #$01,D5
       CMPI.B  #$04,D0
       BEQ     L094CA
       JMP     L0A1A8(PC)

L0A36E MOVEQ   #-$13,D0
       RTS
*-------- end of LET

*-------- NEXT
L0A372 JSR     L0A09E(PC)
       BLT     L0A402
L0A37A MOVE.L  D4,D6
       CMPI.B  #$06,D1
       BEQ.S   L0A3D4
       MOVE.L  A2,-(A7)
       JSR     L04E4C(PC)
       MOVEA.L (A7),A2
       MOVEA.L $0058(A6),A1
       SUBA.W  #$000C,A1
       MOVE.L  $14(A6,A2.L),$02(A6,A1.L)
       BEQ.S   L0A3DE
       MOVE.W  $12(A6,A2.L),$00(A6,A1.L)
       MOVE.W  $00(A6,A2.L),$06(A6,A1.L)
       MOVE.L  $02(A6,A2.L),$08(A6,A1.L)
       JSR     L04838(PC)
       BLT.S   L0A3D6
       MOVE.L  A1,$0058(A6)
       JSR     L04A4A(PC)
       MOVEA.L (A7),A2
       BSR.S   L0A404  * test for end of function
       BRA.S   L0A3D6  * error
       BRA.S   L0A3DA  * end of loop
       
* back to start of loop
       MOVEA.L (A7)+,A2
       MOVE.W  $00(A6,A0.L),$00(A6,A2.L)
       MOVE.L  $02(A6,A0.L),$02(A6,A2.L)
       ADDQ.L  #6,$0058(A6)
L0A3D4 BRA.S   L0A3E4

L0A3D6 ADDQ.W  #4,A7
       RTS
       
*-- end of loop
L0A3DA ADDQ.L  #6,$0058(A6)
L0A3DE MOVEA.L (A7)+,A2
       MOVEQ   #$01,D3
       BRA.S   L0A3E6

L0A3E4 MOVEQ   #$00,D3
L0A3E6 BSR.S   L0A44C
       BNE.S   L0A402
       TST.B   $006E(A6)
       BGT.S   L0A3F4
       SF      $006E(A6)
L0A3F4 CMPI.B  #$7F,$006C(A6)
       BNE.S   L0A400
       SF      $006E(A6)
L0A400 MOVEQ   #$00,D0
L0A402 RTS

* test start and end of a loop

L0A404 MOVE.L  A2,-(A7)
       SUBQ.W  #6,A1
       MOVE.L  $0E(A6,A2.L),$02(A6,A1.L)
       MOVE.W  $0C(A6,A2.L),$00(A6,A1.L)
       JSR     L0482A(PC)
       MOVEA.L (A7)+,A2
       BLT.S   L0A44A
       MOVEQ   #$0D,D1
       ADD.W   $00(A6,A1.L),D1
       CMP.W   $12(A6,A2.L),D1
       BGT.S   L0A42E
       LEA     $000C(A2),A0
       BRA.S   L0A446

L0A42E MOVEA.L $0058(A6),A0
       TST.B   $02(A6,A1.L)
       BLT.S   L0A440
       TST.B   $14(A6,A2.L)
       BLT.S   L0A446
       BRA.S   L0A448

L0A440 TST.B   $14(A6,A2.L)
       BLT.S   L0A448
L0A446 ADDQ.L  #2,(A7)
L0A448 ADDQ.L  #2,(A7)
L0A44A RTS

* ---- positon pointer to code after loop

L0A44C MOVE.B  $006C(A6),-(A7)
       MOVE.L  $0068(A6),-(A7)
       MOVE.L  A4,-(A7)
       MOVE.W  $06(A6,A2.L),D4
       JSR     L09FA2(PC)
       BNE.S   L0A4AA
       JSR     L0A96A(PC)
       BNE.S   L0A4AA
       MOVE.B  $0A(A6,A2.L),D4
       JSR     L0A00A(PC)
       JSR     L0A56C(PC)
       CMPI.W  #$8102,D1
       BEQ.S   L0A47E
       CMPI.W  #$8104,D1
       BNE.S   L0A4AA
L0A47E ADDQ.W  #2,A4
       MOVEA.L A4,A5
       JSR     L0A56C(PC)
       CMP.W   $02(A6,A4.L),D6
       BNE.S   L0A4AA
       TST.B   D3
       BEQ.S   L0A4A4
       MOVEA.L A5,A4
       ADDA.W  $18(A6,A2.L),A4
       MOVE.L  D6,D4
       JSR     L09E88(PC)
       BLT.S   L0A4AC
       BEQ.S   L0A4A4
       MOVEQ   #$00,D0
       BRA.S   L0A4AC

L0A4A4 ADDA.W  #$000A,A7
       RTS

L0A4AA MOVEQ   #-$07,D0
L0A4AC MOVEA.L (A7)+,A4
       MOVE.L  (A7)+,$0068(A6)
       MOVE.B  (A7)+,$006C(A6)
       TST.L   D0
       RTS

*--- initialise all variables tables procs and funcs of prog or line
L0A4BA MOVE.L  A4,-(A7)
       MOVE.B  $006F(A6),D6
       BEQ.S   L0A4CC
       MOVEA.L $0008(A6),A4
       MOVEQ   #$00,D5
       BRA.S   L0A4EE

L0A4CA SF      D6
L0A4CC TST.B   $008E(A6)
       SF      $008E(A6)
       BEQ.S   L0A4EA
       MOVEA.L $0010(A6),A4
L0A4DA TST.B   D6
       BNE.S   L0A4CA
       MOVE.W  $04(A6,A4.L),D5
       ADDQ.W  #6,A4
       CMPA.L  $0014(A6),A4
       BLT.S   L0A4EE
L0A4EA MOVEA.L (A7)+,A4
       RTS

L0A4EE BSR.S   L0A56C   * omit spaces
       CMPI.B  #$88,D0
       BEQ.S   L0A526
       CMPI.B  #$81,D0
       BNE.S   L0A55C
       ADDQ.W  #2,A4
       CMPI.B  #$14,D1
       BEQ.S   L0A4EE
       CMPI.B  #$02,D1
       BNE.S   L0A50E
       BSR.S   L0A56C
       BRA.S   L0A534

L0A50E CMPI.B  #$04,D1
       BNE.S   L0A51E
       BSR.S   L0A56C
       CMPI.B  #$88,D0
       BNE.S   L0A55C
       BRA.S   L0A534

L0A51E CMPI.B  #$1B,D1
       BNE.S   L0A53A
       BSR.S   L0A56C
L0A526 MOVE.L  A4,D4
       ADDQ.W  #4,A4
       BSR.S   L0A56C
       CMPI.W  #$8401,D1
       BNE.S   L0A55C
       MOVEA.L D4,A4
L0A534 MOVEQ   #$02,D1
L0A536 BSR.S   L0A57E
       BRA.S   L0A55C

L0A53A CMPI.B  #$07,D1
       BNE.S   L0A554
       BSR.S   L0A56C
       MOVE.W  D1,D4
       ADDQ.W  #2,A4
       BSR.S   L0A56C
       MOVEQ   #$04,D1
       CMPI.B  #$08,D4
       BEQ.S   L0A536
       MOVEQ   #$05,D1
       BRA.S   L0A536

L0A554 CMPI.B  #$19,D1
       BNE.S   L0A55C
       BSR.S   L0A5CE
L0A55C JSR     L09B32(PC)
       BGE.S   L0A568
       ADDQ.W  #2,A4
       BRA     L0A4DA

L0A568 ADDQ.W  #2,A4
       BRA.S   L0A4EE

L0A56C MOVE.W  $00(A6,A4.L),D1
       MOVE.B  $00(A6,A4.L),D0
       CMPI.B  #$80,D0
       BNE.S   L0A5CC
       JMP     L09072(PC)

L0A57E MOVEQ   #$00,D0
       MOVE.W  $02(A6,A4.L),D0
       LSL.L   #3,D0
       MOVEA.L $0018(A6),A0
       ADDA.L  D0,A0
       MOVE.B  $00(A6,A0.L),D0
       CMP.B   D0,D1
       BEQ.S   L0A5BC
       SUBQ.B  #2,D0
       BLT.S   L0A5BC
       BEQ.S   L0A5AC
       SUBQ.B  #1,D0
       BEQ.S   L0A5CC
       SUBQ.B  #2,D0
       BLE.S   L0A5A6
       SUBQ.B  #3,D0
       BLT.S   L0A5AC
L0A5A6 CMPI.B  #$04,D1
       BGE.S   L0A5BC
L0A5AC MOVEA.L A0,A2
       MOVEM.L D1/A0,-(A7)
       JSR     L05784(PC)
       MOVEM.L (A7)+,D1/A0
       BNE.S   L0A5CC
L0A5BC MOVE.B  D1,$00(A6,A0.L)
       SUBQ.B  #4,D1
       BEQ.S   L0A5C8
       SUBQ.B  #1,D1
       BNE.S   L0A5CC
L0A5C8 MOVE.W  D5,$04(A6,A0.L)
L0A5CC RTS

* initialise variable in name-table

L0A5CE MOVEQ   #$00,D3
       SUBQ.W  #2,A4
L0A5D2 MOVE.W  #$8800,D4
       BSR.S   L0A5E0
       BNE.S   L0A60C
       MOVEQ   #$03,D1
       BSR.S   L0A57E
       BRA.S   L0A5D2
       
* look for first variable without parenthesis

L0A5E0 MOVEQ   #$00,D3
L0A5E2 JSR     L09072(PC)
       CMP.W   D4,D1
       BNE.S   L0A5F0
       TST.B   D3
L0A5ED BEQ.S   L0A60C
       BRA.S   L0A5E2

L0A5F0 CMPI.W  #$8405,D1
       BNE.S   L0A5FA
       ADDQ.B  #1,D3
       BRA.S   L0A5E2

L0A5FA CMPI.W  #$8406,D1
       BNE.S   L0A604
       SUBQ.B  #1,D3
       BRA.S   L0A5E2

L0A604 JSR     L09686(PC)
       BNE.S   L0A5E2
       MOVEQ   #$01,D1
L0A60C RTS

* point to next instruction in line

L0A60E JSR     L09B32(PC)
       BGE.S   L0A640
       TST.B   $006F(A6)
       BNE.S   L0A63E
       ADDQ.W  #2,A4
       CMPA.L  $0014(A6),A4
       BLT.S   L0A626
       JMP     L0A994(PC)

L0A626 MOVE.W  $00(A6,A4.L),D0
       ADD.W   D0,$006A(A6)
       MOVE.W  $04(A6,A4.L),$0068(A6)
       MOVEQ   #$01,D0
       MOVE.B  D0,$006C(A6)
       ADDQ.W  #6,A4
       MOVEQ   #$00,D1
L0A63E RTS

L0A640 ADDQ.W  #2,A4
       ADDQ.B  #1,$006C(A6)
       MOVEQ   #$00,D0
       RTS

* point according to value of SELECT

L0A64A JSR     L0A56C(PC)
       CMPI.W  #$8117,D1
       BEQ.S   L0A6CE
       BSR.S   L0A68C
       CMPI.W  #$810B,$00(A6,A4.L)
       BEQ.S   L0A672
       BSR.S   L0A6D6
       MOVE.W  $00(A6,A1.L),D0
       BEQ.S   L0A6CA
       ADDI.W  #$0018,D0
       SUB.W   -$06(A6,A1.L),D0
       BLE.S   L0A6CA
       BRA.S   L0A6A6

L0A672 BSR.S   L0A6D6
       TST.B   $02(A6,A1.L)
       BGT.S   L0A6A6
       ADDQ.W  #2,A4
       ADDQ.L  #6,$0058(A6)
       BSR.S   L0A68C
       BSR.S   L0A6D6
       TST.B   $02(A6,A1.L)
       BLT.S   L0A6A6
       BRA.S   L0A6CA

L0A68C MOVEA.L A4,A0
       SUBA.L  $0028(A6),A2
       MOVE.L  A2,-(A7)
       JSR     L05A7E(PC)
       MOVEA.L $0028(A6),A2
       ADDA.L  (A7)+,A2
       MOVEA.L A0,A4
       BEQ.S   L0A6D4
       ADDQ.W  #4,A7
       RTS

L0A6A6 ADDQ.L  #6,$0058(A6)
L0A6AA MOVE.W  $00(A6,A4.L),D0
       CMPI.W  #$8404,D0
       BNE.S   L0A6B8
       ADDQ.W  #2,A4
       BRA.S   L0A64A

L0A6B8 CMPI.W  #$840A,D0
       BEQ.S   L0A6D2
       CMPI.W  #$8402,D0
       BEQ.S   L0A6D2
       JSR     L09072(PC)
       BRA.S   L0A6AA

L0A6CA ADDQ.L  #6,$0058(A6)
L0A6CE MOVEQ   #$00,D0
       RTS

L0A6D2 MOVEQ   #-$01,D0
L0A6D4 RTS

L0A6D6 SUBQ.W  #6,A1
       MOVE.L  $02(A6,A2.L),$02(A6,A1.L)
       MOVE.W  $00(A6,A2.L),$00(A6,A1.L)
       JSR     L0482A(PC)
       BEQ.S   L0A6EC
       ADDQ.W  #4,A7
L0A6EC RTS

* execute Basic instruction

L0A6EE MOVEA.L $00B0(A6),A4
       MOVEA.L $00B4(A6),A2
L0A6F6 SF      $00B8(A6)
       MOVE.L  A4,$00B0(A6)
       MOVE.L  A2,$00B4(A6)
       MOVE.L  $04(A6,A2.L),D4
       MOVEA.L A4,A0
       MOVE.L  $001C(A6),D0
       SUB.L   $0018(A6),D0
       MOVE.L  D0,-(A7)
       JSR     L0614A(PC)
       BNE.S   L0A724
       MOVE.W  $00(A6,A0.L),D1
       JSR     L09686(PC)
       BEQ.S   L0A732
       MOVEQ   #-$0F,D0
L0A724 MOVE.L  $0018(A6),D1
       ADD.L   (A7)+,D1
       MOVE.L  D1,$001C(A6)
       TST.L   D0
       RTS

L0A732 MOVE.L  A5,D0
       SUB.L   $0018(A6),D0
       MOVE.L  D0,-(A7)
       MOVEA.L A0,A4
       MOVEA.L $0018(A6),A3
       ADDA.L  $0004(A7),A3
       MOVEA.L D4,A2
       MOVEA.L $0058(A6),A1
       SUBA.L  $005C(A6),A1
       SUBA.L  $0008(A6),A4
       MOVEM.L D5-D7/A1/A4,-(A7)
       MOVE.L  $0068(A6),-(A7)
       MOVE.B  $006C(A6),-(A7)
       MOVE.L  $006E(A6),-(A7)
       JSR     (A2)
       MOVE.L  D0,D2
       MOVE.L  (A7)+,$006E(A6)
       MOVE.B  (A7)+,$006C(A6)
       MOVE.L  (A7)+,$0068(A6)
       MOVEM.L (A7)+,D5-D7/A1/A4
       ADDA.L  $0008(A6),A4
       ADDA.L  $005C(A6),A1
       MOVE.L  A1,$0058(A6)
       MOVEA.L $0018(A6),A5
       MOVEA.L A5,A3
       ADDA.L  (A7)+,A5
       ADDA.L  (A7)+,A3
       JSR     L05702(PC)
       MOVE.L  D2,D0
       TST.B   $00B8(A6)
       BNE     L097E0
       RTS

L0A79C MOVE.B  #$7F,$006C(A6)
       MOVEQ   #$00,D4
       MOVE.W  $0070(A6),D4
       JSR     L0A0AA(PC)
       BGE     L0A37A
       RTS

* execute DATA and REMark lines
L0A7B2 MOVEQ   #$00,D0
       RTS

* execute a conditioned repeat 
L0A7B6 JSR     L0A56C(PC)
       CMPI.B  #$88,D0
       BNE.S   L0A7F0
       MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L09852(PC)
       BLT.S   L0A7D8
       MOVE.B  #$01,$006E(A6)
       MOVE.W  D4,$0070(A6)
L0A7D8 JSR     L09F96(PC)
       MOVE.B  $00(A6,A2.L),D2
       MOVEQ   #$06,D1
       SUBQ.B  #2,D2
       BEQ.S   L0A7F4
       SUBQ.B  #4,D2
       BEQ.S   L0A81C
       MOVEQ   #$1A,D1
       SUBQ.B  #1,D2
       BEQ.S   L0A7F4
L0A7F0 MOVEQ   #-$0C,D0
       RTS

* initialise conditions of repeat-loop

L0A7F4 MOVE.L  A2,-(A7)
       MOVE.L  $04(A6,A2.L),D2
       BLT.S   L0A806
       MOVEA.L $0028(A6),A0
       ADDA.L  D2,A0
       JSR     L04FE8(PC)
L0A806 MOVEQ   #$0C,D1
       JSR     L04DF6(PC)
       SUBA.L  $0028(A6),A0
       MOVEA.L (A7)+,A2
       MOVE.L  A0,$04(A6,A2.L)
       MOVE.B  #$06,$00(A6,A2.L)
L0A81C JMP     L0A2FE(PC)

* Execute RESTore
L0A820 CLR.W   $0094(A6)
       MOVEA.L A4,A0
       JSR     L05A82(PC)
       MOVEA.L A0,A4
       BLT.S   L0A848
       BGT.S   L0A83A
       ADDQ.L  #2,$0058(A6)
       MOVE.W  $00(A6,A1.L),$0094(A6)
L0A83A MOVE.B  #$01,$0096(A6)
       MOVE.B  #$01,$0097(A6)
       MOVEQ   #$00,D0
L0A848 RTS

* Execute conditons for SELECT
L0A84A JSR     L0A56C(PC)
       CMPI.W  #$8115,D1
       BNE.S   L0A85A
       ADDQ.W  #2,A4
       JSR     L0A56C(PC)
L0A85A MOVEQ   #$00,D4
       MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L09F80(PC)
       SUBQ.B  #2,D2
       BNE.S   L0A8A0
       TST.L   D0
       BLT.S   L0A89C
       JSR     L09852(PC)
       BLT.S   L0A88C
       TST.B   $006E(A6)
       BNE.S   L0A87E
       ST      $006E(A6)
L0A87E JSR     L0A56C(PC)
       CMPI.W  #$8401,D1
       BNE.S   L0A88C
       ADDQ.W  #2,A4
       BRA.S   L0A892

L0A88C JSR     L09D72(PC)
       BNE.S   L0A898
L0A892 JSR     L0A64A(PC)
       BLT.S   L0A88C
L0A898 MOVEQ   #$00,D0
       RTS

L0A89C MOVEQ   #-$11,D0
       RTS

L0A8A0 MOVEQ   #-$0C,D0
       RTS

* supervisor of direct or progr lines

L0A8A4 MOVEA.L $0010(A6),A4
L0A8A8 SF      $006E(A6)
       TST.B   $006F(A6)
       BNE.S   L0A8B8
L0A8B2 BSR     L0A966
       BNE.S   L0A8F8
L0A8B8 MOVEQ   #$01,D0
       JSR     L04E32(PC)
       MOVEQ   #$00,D0
L0A8C0 JSR     L0A56C(PC)
       CMPI.B  #$81,D0
       BNE.S   L0A8D0
       JSR     L0A190(PC)
       BRA.S   L0A8EA

L0A8D0 CMPI.B  #$88,D0
       BNE.S   L0A8DC
       JSR     L0A33C(PC)
       BRA.S   L0A8EA

L0A8DC CMPI.B  #$84,D0
       BNE.S   L0A8E8
       JSR     L0ABF0(PC)
       BRA.S   L0A8EA
       
* test for errors and Break

L0A8E8 MOVEQ   #-$13,D0
L0A8EA TST.L   D0
       BNE     L09BA8
       TAS     $008F(A6)
       BEQ     L09B90
L0A8F8 TAS     $006D(A6)
       BEQ     L0A9BA
       TST.B   $006F(A6)
       BNE.S   L0A90C
       CMPA.L  $0010(A6),A4
       BLE.S   L0A8A4
L0A90C JSR     L09B32(PC)
       BGE.S   L0A95C
       TST.B   $006E(A6)
       BEQ.S   L0A94E
       BLT.S   L0A924
       JSR     L0A79C(PC)
       TST.B   $006E(A6)
       BNE.S   L0A8EA
L0A924 TST.B   $00C0(A6)        * WHEN ERROR ?
       BEQ.S   L0A93C
       TST.B   $00BF(A6)
       BEQ.S   L0A94E
       JSR     L07E50(PC)
       ST      $006D(A6)
       JMP     L0A9BA(PC)

L0A93C MOVE.W  $0068(A6),D4
       MOVEQ   #-$01,D3
       JSR     L0ACC2(PC)
       BNE.S   L0A94E
       JSR     L09AEE(PC)
       BRA.S   L0A90C
       
* test for return after lineend
L0A94E TST.B   $006F(A6)
       ADDQ.W  #2,A4
       BEQ     L0A8B2
       BSR.S   L0A998
       BRA.S   L0A990

L0A95C ADDQ.W  #2,A4
       ADDQ.B  #1,$006C(A6)
       BRA     L0A8B8

* point to first instruction in line

L0A966 SF      $006E(A6)
L0A96A CLR.W   $0068(A6)
       TST.B   $006F(A6)
       BNE.S   L0A98A
       CMPA.L  $0014(A6),A4
       BGE.S   L0A994
       MOVE.W  $00(A6,A4.L),D0
       ADD.W   D0,$006A(A6)
       MOVE.W  $04(A6,A4.L),$0068(A6)
       ADDQ.W  #6,A4
L0A98A MOVE.B  #$01,$006C(A6)
L0A990 MOVEQ   #$00,D0
       RTS

* Set flags after end of prog

L0A994 SF      $006D(A6)
L0A998 MOVE.W  #-1,$0088(A6)
       MOVE.W  #$0004,$008C(A6)
       RTS


* execute system commands    JM 9F7E
* Labels relativ to L0A9BA
* NOTE: ALL following commands have been rewritten
* by Tony Tebby - if you use TOOLKIT II you can easily
* omit all the code that is following
        
L0A9A6 DC.W    XL0A9F2-L0A9BA   CLEAR
       DC.W    XL0AADC-L0A9BA   NEW
       DC.W    XL0ABCA-L0A9BA   STOP
       DC.W    XL0AA5E-L0A9BA   RUN
       DC.W    XL0AADC-L0A9BA   LRUN
       DC.W    XL0AADC-L0A9BA   LOAD
       DC.W    XL0ABDC-L0A9BA   MRUN
       DC.W    XL0ABDC-L0A9BA   MERGE
       DC.W    XL0ABA6-L0A9BA   CONNTINUE-RETRY
       DC.W    L0A9C6-L0A9BA    ERROR-RETURN
         
L0A9BA MOVE.W  $008C(A6),D1
       MOVE.W  L0A9A6(PC,D1.W),D1
       JMP     L0A9BA(PC,D1.W)

* restor system and error-return

L0A9C6 JSR     L09BA8(PC)
       MOVEA.L $003C(A6),A0
       SF      $00AA(A6)
L0A9D2 CMPA.L  $0038(A6),A0
       BLE.S   L0A9FC
       MOVE.B  -$08(A6,A0.L),D0
       BEQ.S   L0A9EE
       MOVE.L  -$18(A6,A0.L),D0
       ADD.L   $0018(A6),D0
       MOVE.L  D0,$001C(A6)
       SUBA.W  #$0010,A0
L0A9EE SUBQ.W  #8,A0
       BRA.S   L0A9D2

*system command Clear

sysclear

L0A9F2 TST.B   $0090(A6)
XL0A9F2 EQU L0A9F2
       BEQ.S   L0A9FC
       JSR     L097E0(PC)
L0A9FC BSR     L0AA88
       JSR     L056C6(PC)
       MOVEA.L $0018(A6),A0
L0AA08 MOVE.B  $00(A6,A0.L),D0
       SUBQ.B  #1,D0
       BEQ.S   L0AA4A
       SUBQ.B  #3,D0
       BLT.S   L0AA1C
       SUBQ.B  #2,D0
       BLT.S   L0AA52
       SUBQ.B  #2,D0
       BGE.S   L0AA52
L0AA1C MOVE.W  $02(A6,A0.L),D0
       BLT.S   L0AA4A
       BSR     L0AACC
       MOVE.B  -$01(A6,A1.L),D0
       MOVEQ   #$01,D1
       SUBI.B  #$25,D0
       BLT.S   L0AA38
       BGT.S   L0AA36
       ADDQ.W  #1,D1
L0AA36 ADDQ.W  #1,D1
L0AA38 MOVE.B  D1,$01(A6,A0.L)
       MOVE.B  D7,$00(A6,A0.L)
       MOVE.L  #-1,$04(A6,A0.L)
       BRA.S   L0AA52

L0AA4A MOVE.L  D7,$00(A6,A0.L)
       MOVE.L  D7,$04(A6,A0.L)
L0AA52 ADDQ.W  #8,A0
       CMPA.L  $001C(A6),A0
       BLT.S   L0AA08
       ST      $008E(A6)
       
* execute RUN

L0AA5E 
XL0AA5E EQU L0AA5E
       TST.B   $0090(A6)
       BEQ.S   L0AA80
       MOVE.W  $0088(A6),$00B4(A6)
       MOVE.W  $008C(A6),$00B6(A6)
       JSR     L097E0(PC)
       MOVE.W  $00B4(A6),$0088(A6)
       MOVE.W  $00B6(A6),$008C(A6)
L0AA80 JSR     L0A4BA(PC)
       BRA     L0ABE6

* clear stacks and storage-places

L0AA88 MOVEQ   #$00,D7
       MOVE.L  D7,$0094(A6)
       MOVE.B  #$01,$0097(A6)
       MOVE.L  $0028(A6),$002C(A6)
       MOVE.L  #-1,$00CA(A6)
       MOVE.W  D7,$00C8(A6)
       MOVE.L  $0038(A6),$003C(A6)
       MOVEQ   #$58,D0
L0AAAE MOVE.L  $005C(A6),$00(A6,D0.W)
       SUBQ.W  #4,D0
       CMPI.B  #$48,D0
       BGE.S   L0AAAE
       SF      $0090(A6)
       MOVE.L  D7,$0072(A6)
       JSR     L04F9E(PC)
       JMP     L04F96(PC)

* point to end of namelist

L0AACC MOVEA.L $0020(A6),A1
       ADDA.W  D0,A1
       MOVEQ   #$01,D0
       ADD.B   $00(A6,A1.L),D0
       ADDA.W  D0,A1
       RTS
       
sysload
syslrun
sysnew

L0AADC 
XL0AADC EQU L0AADC
       
       MOVEA.L $0034(A6),A3
       MOVEA.L $0030(A6),A2
       ADDA.W  #$0078,A2
       MOVE.L  A2,$0034(A6)
L0AAEC CMPA.L  A3,A2
       BGE.S   L0AB02
       MOVE.L  $00(A6,A2.L),D0
       BLT.S   L0AAFC
       MOVEA.L D0,A0
       MOVEQ   #$02,D0
       TRAP    #$02
L0AAFC ADDA.W  #$0028,A2
       BRA.S   L0AAEC

L0AB02 MOVEQ   #$10,D0
       MOVEQ   #-$01,D1
       MOVEQ   #-$01,D2
       TRAP    #$01
       MOVEQ   #$10,D0
       TRAP    #$01
       MOVE.L  $0040(A6),$0044(A6)
       CLR.W   $009E(A6)
       BSR     L0AA88
       MOVE.L  $0010(A6),$0014(A6)
       MOVEQ   #$00,D0
       MOVEQ   #$00,D5
       MOVEA.L $0018(A6),A0
       MOVEQ   #$08,D1
L0AB2C CMPA.L  $001C(A6),A0
       BEQ.S   L0AB84
       CMP.B   $00(A6,A0.L),D1
       BGT.S   L0AB42
       TST.B   D5
       BNE.S   L0AB50
       MOVE.W  $02(A6,A0.L),D0
       BRA.S   L0AB80

L0AB42 TST.B   D5
       BNE.S   L0AB80
       MOVEA.L A0,A2
       BSR.S   L0AACC
       MOVEA.L A1,A3
       ST      D5
       BRA.S   L0AB80

L0AB50 MOVE.L  $00(A6,A0.L),$00(A6,A2.L)
       MOVE.L  $04(A6,A0.L),$04(A6,A2.L)
       MOVE.W  $02(A6,A2.L),D0
       BSR     L0AACC
       SUBA.W  D0,A1
       MOVE.L  A3,D2
       SUB.L   $0020(A6),D2
       MOVE.W  D2,$02(A6,A2.L)
       ADDQ.W  #8,A2
L0AB72 MOVE.B  $00(A6,A1.L),$00(A6,A3.L)
       ADDQ.W  #1,A1
       ADDQ.W  #1,A3
       SUBQ.W  #1,D0
       BGT.S   L0AB72
L0AB80 ADDQ.W  #8,A0
       BRA.S   L0AB2C

L0AB84 TST.B   D5
       BEQ.S   L0AB90
       MOVE.L  A2,$001C(A6)
       MOVE.L  A3,$0024(A6)
L0AB90 JSR     L04F9A(PC)
       JSR     L04F8E(PC)
       JSR     L04F92(PC)
       JSR     L04F8A(PC)
       JSR     L056C6(PC)
       BRA.S   L0ABC4


* execute RETRY or CONTINUE

L0ABA6 MOVE.W  $0092(A6),$0088(A6)
       MOVE.B  $0091(A6),$008A(A6)
       MOVE.W  #-1,$0092(A6)
       MOVE.B  $009A(A6),$006E(A6)
       MOVE.W  $0098(A6),$0070(A6)
L0ABC4 SF      $8B(A6)
       BRA.S   L0ABEC
XL0ABA6 EQU L0ABA6

* execute STOP

L0ABCA 
XL0ABCA EQU L0ABCA

       TST.B   $00C0(A6)
       SF      $00C0(A6)
       BNE.S   L0ABE6
       MOVEQ   #$00,D0
       JSR     L09B5E(PC)
       BRA.S   L0ABEC

* execute MRUN or MERGE

L0ABDC TST.B   $0090(A6)
       BEQ.S   L0ABE6
       JSR     L097E0(PC)
L0ABE6 MOVE.B  $006F(A6),$008B(A6)
L0ABEC MOVEQ   #$00,D0
       RTS
XL0ABDC EQU L0ABDC

* handling of lines starting with =

L0ABF0 CMPI.W  #$8401,D1
       BNE.S   L0ABFC
       ADDQ.W  #2,A4
       JMP     L09CFE(PC)       * search end of SELECT
       
L0ABFC MOVEQ   #$00,D0
       RTS

* execute WHEN
L0AC00 JSR     L0A56C(PC)
       CMPI.W  #$810E,D1
       BNE.S   L0AC32
       MOVE.W  $0068(A6),$00BC(A6)
       MOVE.B  $006C(A6),$00BE(A6)
       JSR     L09852(PC)
       SEQ     $00BF(A6)
       BEQ.S   L0AC28
       MOVEQ   #$06,D2
       JMP     L098A8(PC)

L0AC26 ADDQ.W  #2,A4
L0AC28 JSR     L09B32(PC)
       BGE.S   L0AC26
L0AC2E MOVEQ   #$00,D0
       RTS

* WHENvar

L0AC32 MOVE.W  $02(A6,A4.L),D4
       ADDQ.W  #4,A4
       JSR     L0A56C(PC)
       CMPI.B  #$85,D0
       BEQ.S   L0AC54
L0AC42 MOVEQ   #$01,D3
       JSR     L0ACC2(PC)
       BNE.S   L0AC2E
       ST      $00(A6,A2.L)
       SUBQ.W  #1,$00C8(A6)
       BRA.S   L0AC42

L0AC54 MOVEQ   #$01,D3
       JSR     L0ACC2(PC)
L0AC5A BNE.S   L0AC6C
       MOVE.W  $0068(A6),D0
       CMP.W   $02(A6,A2.L),D0
       BEQ.S   L0AC76
       JSR     L0ACDA(PC)
       BRA.S   L0AC5A

L0AC6C MOVEQ   #$00,D3
       JSR     L0ACC2(PC)
       ADDQ.W  #1,$00C8(A6)
L0AC76 MOVE.W  D4,$00(A6,A2.L)
       MOVE.W  $0068(A6),$02(A6,A2.L)
       MOVE.B  $006C(A6),$04(A6,A2.L)
       MOVE.W  $0068(A6),$06(A6,A2.L)
       MOVE.B  #$7F,$05(A6,A2.L)
       CLR.L   $0A(A6,A2.L)
       ST      $08(A6,A2.L)
       MOVE.L  A2,-(A7)
       JSR     L09852(PC)
       MOVEA.L (A7)+,A2
       SEQ     $0E(A6,A2.L)
       BEQ.S   L0AC28
       MOVEQ   #$06,D2
       MOVE.L  A2,-(A7)
       JSR     L098A8(PC)
       MOVE.L  (A7)+,D2
       MOVE.W  $0068(A6),$06(A6,A2.L)
       MOVE.B  $006C(A6),$05(A6,A2.L)
       BRA     L0AC2E

L0ACC2 MOVE.W  $00C8(A6),D2
       BEQ.S   L0AD06
       BSR.S   L0AD10
L0ACCA MOVE.W  $00(A6,A2.L),D0
       BLT.S   L0ACEC
       TST.B   D3
       BLT.S   L0ACF2
       BEQ.S   L0ACDE
       CMP.W   D0,D4
       BEQ.S   L0ACFE
L0ACDA SUBQ.W  #1,D2
       BEQ.S   L0AD02
L0ACDE ADDA.W  #$0010,A2
       SUBI.L  #$0010,D1
       BGE.S   L0ACCA
       BRA.S   L0AD26

L0ACEC TST.B   D3
       BNE.S   L0ACDE
       RTS

L0ACF2 CMP.W   $06(A6,A2.L),D4
       BNE.S   L0ACDA
       TST.W   $08(A6,A2.L)
       BLT.S   L0ACDA
L0ACFE MOVEQ   #$00,D0
       RTS

L0AD02 MOVEQ   #-$01,D0
       RTS

L0AD06 TST.B   D3
       BNE.S   L0AD02
       TST.L   $00CA(A6)
       BLT.S   L0AD26
L0AD10 MOVEA.L $0028(A6),A2
       ADDA.L  $00CA(A6),A2
       MOVE.L  $00(A6,A2.L),D1
       SUBI.L  #$0014,D1
       ADDQ.W  #4,A2
       RTS

L0AD26 MOVE.L  $00CA(A6),D1
       BGE.S   L0AD32
       MOVEQ   #$00,D1
       MOVEQ   #$00,D0
       BRA.S   L0AD3C

L0AD32 MOVEA.L $0028(A6),A2
       ADDA.L  D1,A2
       MOVE.L  $00(A6,A2.L),D0
L0AD3C ADDI.L  #$0140,D1
       MOVE.L  A2,-(A7)
       MOVE.L  D0,-(A7)
       JSR     L04DF6(PC)
       MOVE.L  (A7)+,D0
       MOVEA.L (A7)+,A2
       MOVE.L  D1,$00(A6,A0.L)
       MOVE.L  A0,-(A7)
       SUB.L   D0,D1
L0AD56 ADDQ.W  #4,A2
       ADDQ.W  #4,A0
       SUBQ.W  #4,D0
       BLE.S   L0AD66
       MOVE.L  $00(A6,A2.L),$00(A6,A0.L)
       BRA.S   L0AD56

L0AD66 MOVE.L  A0,-(A7)
L0AD68 ST      $00(A6,A0.L)
       ADDA.W  #$0010,A0
       SUBI.L  #$0010,D1
       BGT.S   L0AD68
       MOVE.L  $00CA(A6),D1
       BLT.S   L0AD8C
       MOVEA.L $0028(A6),A0
       ADDA.L  D1,A0
       MOVE.L  $00(A6,A0.L),D1
       JSR     L04FE8(PC)
L0AD8C MOVEA.L (A7)+,A2
       MOVE.L  (A7)+,D1
       SUB.L   $0028(A6),D1
       MOVE.L  D1,$00CA(A6)
       RTS

***** Ende von Basic BASIC3_ASM basic3_asm

*************************
*
* BASIC_COMMANDS   basic_commands
*
*************************

LBASIC
L06E22 DC.W $0051 
* $51 BEFEHLE
        
    DC.W LPRINT-*  * $0884 = ADRESSE
    DC.B $05
    DC.B 'PRINT'
    DC.W LRUN-*  *$0F78 * = ADRESSE
    DC.B $03
    DC.B 'RUN'
    DC.W LSTOP-*  *$0FD8 * = ADRESSE 
    DC.B $04
    DC.B 'STOP'
    DC.W LINPUT-*  *$5000  
    DC.B $05
    DC.B 'INPUT'
    DC.W LWINDOW-*  *$113C 
    DC.B $06
    DC.B 'WINDOW'
    DC.B $00
    DC.W LBORDER-*  *$1158 * = ADRESSE 
    DC.B $06
    DC.B 'BORDER'
    DC.B $00
    DC.W LINK-*  *$0774 
    DC.B $03
    DC.B 'INK'
    DC.W LSTRIP-*  *$0772 
    DC.B $05
    DC.B 'STRIP'
    DC.W LPAPER-*  *$076E 
    DC.B $05
    DC.B 'PAPER'
    DC.W LBLOCK-*  *$1120 
    DC.B $05
    DC.B 'BLOCK'
    DC.W LPAN-*  *$0780 
    DC.B $03
    DC.B 'PAN'
    DC.W LSCROLL-*  *$077E 
    DC.B $06
    DC.B 'SCROLL'
    DC.B $00
    DC.W LCSIZE-*  * $F81E 
    DC.B $05
    DC.B 'CSIZE'
    DC.W LFLASH-*  * $FD20 
    DC.B $05
    DC.B 'FLASH'
    DC.W LUNDER-*  * $FD12 
    DC.B $05
    DC.B 'UNDER'
    DC.W LOVER-*  *  $FD26 
    DC.B $04
    DC.B 'OVER'
    DC.B $00
    DC.W LCURSOR-*  *  $F822 
    DC.B $06
    DC.B 'CURSOR'
    DC.B $00
    DC.W LAT-*  *  $F826 
    DC.B $02
    DC.B 'AT'
    DC.B $00
    DC.W LSCALE-*  *  $FD42 
    DC.B $05
    DC.B 'SCALE'
    DC.W LPOINT-*  *  $FD4C 
    DC.B $05
    DC.B 'POINT'
    DC.W LLINE-*  *  $FD56 
    DC.B $04
    DC.B 'LINE'
    DC.B $00 
    DC.W LELLIPS-*  *  $FD66 
    DC.B $07
    DC.B 'ELLIPSE'
    DC.W LCIRCLE-*  *  $FD5C 
    DC.B $06
    DC.B 'CIRCLE'
    DC.B $00
    DC.W LARC-*  *  $FDA2 
    DC.B $03
    DC.B 'ARC'
    DC.W LPOINTR-*  *  $FD26 
    DC.B $07
    DC.B 'POINT_R'
    DC.W LTURN-*  *  $0FA8 
    DC.B $04
    DC.B 'TURN'
    DC.B $00 
    DC.W LTURNTO-*  *  $0F98  
    DC.B $06
    DC.B 'TURNTO'
    DC.B $00
    DC.W LPENUP-*  *  $0FD0 
    DC.B $05
    DC.B 'PENUP'
    DC.W LPENDOWN-*  *  $0FCC 
    DC.B $07
    DC.B 'PENDOWN'
    DC.W LMOVE-*  *  $0FD0 
    DC.B $04
    DC.B 'MOVE'
    DC.B $00 
    DC.W LLIST-*  *  $0564 
    DC.B $04
    DC.B 'LIST'
    DC.B $00
    DC.W LOPEN-*  *  $FC24 
    DC.B $04
    DC.B 'OPEN'
    DC.B $00 
    DC.W LCLOSE-*  *  $FBFA 
    DC.B $05
    DC.B 'CLOSE'
    DC.W LFORMAT-*  *  $FB40 
    DC.B $06
    DC.B 'FORMAT'
    DC.B $00 
    DC.W LCOPY-*  *  $FB50 
    DC.B $04
    DC.B 'COPY'
    DC.B $00 
    DC.W LCOPYN-*  *  $FB4C 
    DC.B $06
    DC.B 'COPY_N'
    DC.B $00 
    DC.W LDELETE-*  *  $FA96 
    DC.B $06
    DC.B 'DELETE'
    DC.B $00
    DC.W LDIR-*  *  $FA92
    DC.B $03
    DC.B 'DIR'
    DC.W LEXEC-*  *  $F92C
    DC.B $04
    DC.B 'EXEC'
    DC.B $00 
    DC.W LEXECW-*  *  $F928  
    DC.B $06
    DC.B 'EXEC_W'
    DC.B $00
    DC.W LLBYTES-*  *  $F994 
    DC.B $06
    DC.B 'LBYTES'
    DC.B $00 
    DC.W LSEXEC-*  *  $F9C0 
    DC.B $05
    DC.B 'SEXEC'
    DC.W LSBYTES-*  *  $F9BC 
    DC.B $06
    DC.B 'SBYTES'
    DC.B $00 
    DC.W LSAVE-*  *  $FBDE 
    DC.B $04
    DC.B 'SAVE'
    DC.B $00 
    DC.W LMERGE-*  *  $0E34 
    DC.B $05
    DC.B 'MERGE'
    DC.W LMRUN-*  *  $0E36 
    DC.B $04
    DC.B 'MRUN'
    DC.B $00 
    DC.W LLOAD-*  *  $0E4E 
    DC.B $04
    DC.B 'LOAD'
    DC.B $00 
    DC.W LLRUN-*  *  $0E4C 
    DC.B $04
    DC.B 'LRUN'
    DC.B $00 
    DC.W LNEW-*  *  $0E50 
    DC.B $03
    DC.B 'NEW'
    DC.W LCLEAR-*  *  $0DDC 
    DC.B $05
    DC.B 'CLEAR'
    DC.W LOPENIN-*  *  $FB88 
    DC.B $07
    DC.B 'OPEN_IN'
    DC.W LOPENNEW-*  *  $FB82 
    DC.B $08
    DC.B 'OPEN_NEW'
    DC.B $00  
    DC.W LCLS-*  *  $0616 
    DC.B $03
    DC.B 'CLS'
    DC.W LCALL-*  *  $F5EA
    DC.B $04
    DC.B 'CALL'
    DC.B $00 
    DC.W LRECOL-*  *  $0AE4
    DC.B $05
    DC.B 'RECOL'
    DC.W LRANDOMISE-*  *  $09A8
    DC.B $09
    DC.B 'RANDOMISE'
    DC.W LPAUSE-*  *  $064C 
    DC.B $05
    DC.B 'PAUSE'
    DC.W LPOKE-*  *  $0668
    DC.B $04
    DC.B 'POKE'
    DC.B $00 
    DC.W LPOKEW-*  *  $0668
    DC.B $06
    DC.B 'POKE_W'
    DC.B $00 
    DC.W LPOKEL-*  *  $0664 
    DC.B $06
    DC.B 'POKE_L'
    DC.B $00 
    DC.W LBAUD-*  *  $F4C2
    DC.B $04
    DC.B 'BAUD'
    DC.B $00 
    DC.W LBEEP-*  *  $F4F6
    DC.B $04
    DC.B 'BEEP'
    DC.B $00
    DC.W LCONTINUE-*  *  $0E20
    DC.B $08
    DC.B 'CONTINUE'
    DC.B $00 
    DC.W LRETRY-*  *  $0E0A 
    DC.B $05
    DC.B 'RETRY'
    DC.W LREAD-*  *  $F81A 
    DC.B $04
    DC.B 'READ'
    DC.B $00 
    DC.W LNET-*  *  $0562 
    DC.B $03
    DC.B 'NET'
    DC.W LMODE-*  *  $053E 
    DC.B $04
    DC.B 'MODE'
    DC.B $00
    DC.W LRENUM-*  *  $0ACA 
    DC.B $05
    DC.B 'RENUM'
    DC.W LDLINE-*  *  $0400 
    DC.B $05
    DC.B 'DLINE'
    DC.W LSDATE-*  *  $F732
    DC.B $05
    DC.B 'SDATE'
    DC.W LADATE-*  *  $F716 
    DC.B $05
    DC.B 'ADATE'
    DC.W LLINER-*  *  $FBA4
    DC.B $06
    DC.B 'LINE_R'
    DC.B $00
    DC.W LELLIPSR-*  *  $FBB2
    DC.B $09
    DC.B 'ELLIPSE_R'
    DC.W LCIRCLER-*  *  $FBA6
    DC.B $08
    DC.B 'CIRCLE_R'
    DC.B $00
    DC.W LARCR-*  *  $FBEA 
    DC.B $05
    DC.B 'ARC_R'
    DC.W LAUTO-*  *  $0A56
    DC.B $04
    DC.B 'AUTO'
    DC.B $00 
    DC.W LEDIT-*  *  $0A4A
    DC.B $04
    DC.B 'EDIT'
    DC.B $00
    DC.W LFILL-*  *  $FAD4 
    DC.B $04
    DC.B 'FILL'
    DC.B $00
    DC.W LWIDTH-*  *  $0EAC
    DC.B $05
    DC.B 'WIDTH'
    DC.W LREPORT-*  *  $0CB4 
    DC.B $06
    DC.B 'REPORT'
    DC.B $00
    DC.W LTRA-*  *  $0D8A 
    DC.B $03
    DC.B 'TRA'
    DC.W $0000  * END COMMANDS
    DC.W $003A  * $3A FUNCTIONS
    DC.W LACOS-*  *  $0F7C  
    DC.B $04
    DC.B 'ACOS'
    DC.B $00 
    DC.W LACOT-*  *  $0F7A
    DC.B $04
    DC.B 'ACOT'
    DC.B $00
    DC.W LASIN-*  *  $0F78
    DC.B $04
    DC.B 'ASIN'
    DC.B $00
    DC.W LATAN-*  *  $0F76
    DC.B $04
    DC.B 'ATAN'
    DC.B $00
    DC.W LCOS-*  *  $0F74
    DC.B $03
    DC.B 'COS'
    DC.W LCOT-*  *  $0F74
    DC.B $03
    DC.B 'COT'
    DC.W LEXP-*  *  $0F74
    DC.B $03
    DC.B 'EXP'
    DC.W LLN-*  *  $0F74
    DC.B $02
    DC.B 'LN'
    DC.B $00
    DC.W LLOG10-*  *  $0F74
    DC.B $05
    DC.B 'LOG10'
    DC.W LSIN-*  *  $0F72
    DC.B $03
    DC.B 'SIN'
    DC.W LSQRT-*  *  $0F72
    DC.B $04
    DC.B 'SQRT'
    DC.B $00
    DC.W LTAN-*  *  $0F70 
    DC.B $03
    DC.B 'TAN'
    DC.W LDEG-*  *  $0F70 
    DC.B $03
    DC.B 'DEG'
    DC.W LRAD-*  *  $0F70 
    DC.B $03
    DC.B 'RAD'
    DC.W LRND-*  *  $0FB2
    DC.B $03
    DC.B 'RND'
    DC.W LINT-*  *  $1016 
    DC.B $03
    DC.B 'INT'
    DC.W LABS-*  *  $0F7E
    DC.B $03
    DC.B 'ABS'
    DC.W LPI-*  *  $0FF8
    DC.B $02
    DC.B 'PI'
    DC.B $00
    DC.W LPEEK-*  *  $101C
    DC.B $04
    DC.B 'PEEK'
    DC.B $00
    DC.W LPEEKW-*  *  $101C
    DC.B $06
    DC.B 'PEEK_W'
    DC.B $00
    DC.W LPEEKL-*  *  $101C 
    DC.B $06
    DC.B 'PEEK_L'
    DC.B $00
    DC.W LRESPR-*  *  $1036
    DC.B $05
    DC.B 'RESPR'
    DC.W LEOF-*  *  $1054 
    DC.B $03
    DC.B 'EOF'
    DC.W LINKEYS-*  *  $1094 
    DC.B $06
    DC.B 'INKEY$'
    DC.B $00
    DC.W LCHRS-*  *  $10E2
    DC.B $04
    DC.B 'CHR$'
    DC.B $00
    DC.W LCODE-*  *  $1152 
    DC.B $04
    DC.B 'CODE'
    DC.B $00 
    DC.W LKEYROW-*  *  $11DA 
    DC.B $06
    DC.B 'KEYROW'
    DC.B $00 
    DC.W LBEEPING-*  *  $101A 
    DC.B $07
    DC.B 'BEEPING'
    DC.W LLEN-*  *  $1120
    DC.B $03
    DC.B 'LEN'
    DC.W LDIMN-*  *  $1158 
    DC.B $04
    DC.B 'DIMN'
    DC.B $00 
    DC.W LDAYS-*  *  $1204 
    DC.B $04
    DC.B 'DAY$'
    DC.B $00 
    DC.W LDATE-*  *  $1198
    DC.B $04
    DC.B 'DATE'
    DC.B $00 
    DC.W LDATES-*  *  $11EE 
    DC.B $05
    DC.B 'DATE$'
    DC.W LFILLS-*  *  $10AA 
    DC.B $05
    DC.B 'FILL$'
    DC.W LVERS-*  *  $101C 
    DC.B $04
    DC.B 'VER$'
    DC.B $00 
    DC.W LERRNC-*  *  $1232 
    DC.B $06
    DC.B 'ERR_NC'
    DC.B $00
    DC.W LERRNJ-*  *  $1226
    DC.B $06
    DC.B 'ERR_NJ'
    DC.B $00
    DC.W LERROM-*  *  $121A
    DC.B $06
    DC.B 'ERR_OM'
    DC.B $00
    DC.W LERROR-*  *  $120E 
    DC.B $06
    DC.B 'ERR_OR'
    DC.B $00
    DC.W LERRBO-*  *  $1202
    DC.B $06
    DC.B 'ERR_BO'
    DC.B $00 
    DC.W LERRNO-*  *  $11F6
    DC.B $06
    DC.B 'ERR_NO'
    DC.B $00
    DC.W LERRNF-*  *  $11EA
    DC.B $06
    DC.B 'ERR_NF'
    DC.B $00
    DC.W LERREX-*  *  $11DE 
    DC.B $06
    DC.B 'ERR_EX'
    DC.B $00
    DC.W LERRIU-*  *  $11D2 
    DC.B $06
    DC.B 'ERR_IU'
    DC.B $00
    DC.W LERREF-*  *  $11C6
    DC.B $06
    DC.B 'ERR_EF'
    DC.B $00
    DC.W LERRDF-*  *  $11BA
    DC.B $06
    DC.B 'ERR_DF'
    DC.B $00
    DC.W LERRBN-*  *  $11AE
    DC.B $06
    DC.B 'ERR_BN'
    DC.B $00
    DC.W LERRTE-*  *  $11A2
    DC.B $06
    DC.B 'ERR_TE'
    DC.B $00
    DC.W LERRFF-*  *  $1196
    DC.B $06
    DC.B 'ERR_FF'
    DC.B $00
    DC.W LERRBP-*  *  $118A 
    DC.B $06
    DC.B 'ERR_BP'
    DC.B $00
    DC.W LERRFE-*  *  $117E 
    DC.B $06
    DC.B 'ERR_FE'
    DC.B $00
    DC.W LERRXP-*  *  $1172
    DC.B $06
    DC.B 'ERR_XP'
    DC.B $00
    DC.W LERROV-*  *  $1166
    DC.B $06
    DC.B 'ERR_OV'
    DC.B $00
    DC.W LERRNI-*  *  $115A 
    DC.B $06
    DC.B 'ERR_NI'
    DC.B $00
    DC.W LERRRO-*  *  $114E 
    DC.B $06
    DC.B 'ERR_RO'
    DC.B $00 
    DC.W LERRBL-*  *  $1142  * = ADRESSE
    DC.B $06
    DC.B 'ERR_BL'
    DC.B $00
    DC.W LERNUM-*  *  $11AA * = ADRESSE
    DC.B $05
    DC.B 'ERNUM'
    DC.W LERLIN-*  *  $11B0 * = ADRESSE
    DC.B $05
    DC.B 'ERLIN'
    DC.W $0000

****** END BASIC_COMMANDS basic_commands

****************************
*
* charfount_asm
*
* called from d36 ff // DCE
*
****************************
L0AD9A DC.L    $1F605428
XL0AD9A EQU L0AD9A
      DC.L    $54285428
      DC.L    $54285400
      DC.L    $00000000
      DC.L    $00000000
      DC.L    $10101010
      DC.L    $10001000
      DC.L    $00282800
      DC.L    $00000000
oADBE DC.L    $00002828
      DC.L    $7C287C28
      DC.L    $28000038
      DC.L    $50503814
      DC.L    $14380000
      DC.L    $64640810
      DC.L    $204C4C00
      DC.L    $00205050
      DC.L    $20544834
      DC.L    $00001010
      DC.L    $00000000
      DC.L    $00000004
      DC.L    $08101010
      DC.L    $08040000
      DC.L    $40201010
      DC.L    $10204000
      DC.L    $00105438
      DC.L    $10385410
      DC.L    $00000010
      DC.L    $107C1010
      DC.L    $00000000
      DC.L    $00000000
      DC.L    $18180810
      DC.L    $0000007C
      DC.L    $00000000
      DC.L    $00000000
      DC.L    $00001818
      DC.L    $00000404
      DC.L    $08102040
      DC.L    $40000038
      DC.L    $444C5464
      DC.L    $44380000
      DC.L    $10301010
      DC.L    $10103800
      DC.L    $00384404
      DC.L    $0810207C
      DC.L    $00003844
      DC.L    $04180444
      DC.W    $3800
L0AE58 DC.W   $0008
      DC.L    $1828487C
      DC.L    $08080000
      DC.L    $7C407804
      DC.L    $04443800
      DC.L    $00182040
      DC.L    $78444438
      DC.L    $00007C04
      DC.L    $08102040
      DC.L    $40000038
      DC.L    $44443844
      DC.L    $44380000
      DC.L    $3844443C
      DC.L    $04083000
      DC.L    $00000018
      DC.L    $18001818
      DC.L    $00000000
oAE9A DC.L    $18180018
      DC.L    $18081004
      DC.L    $08102010
      DC.L    $08040000
      DC.L    $00007C00
      DC.L    $7C000000
      DC.L    $00402010
      DC.L    $08102040
      DC.L    $00003844
      DC.L    $04081000
      DC.L    $10000038
      DC.L    $444C544C
      DC.L    $40300000
oAECE DC.L    $3844447C
      DC.L    $44444400
      DC.L    $00784444
      DC.L    $78444478
      DC.L    $00003844
      DC.L    $40404044
      DC.L    $38000078
      DC.L    $44444444
      DC.L    $44780000
      DC.L    $7C404078
      DC.L    $40407C00
oAEFA DC.L    $007C4040
      DC.L    $78404040
      DC.L    $00003844
      DC.L    $40404C44
      DC.L    $38000044
      DC.L    $44447C44
      DC.L    $44440000
      DC.L    $38101010
      DC.L    $10103800
      DC.L    $00040404
      DC.L    $04044438
      DC.L    $00004448
      DC.L    $50605048
      DC.L    $44000040
      DC.L    $40404040
      DC.L    $407C0000
      DC.L    $446C5444
      DC.L    $44444400
oAF42 DC.L    $00444464
      DC.L    $544C4444
      DC.L    $00003844
      DC.L    $44444444
      DC.L    $38000078
      DC.L    $44447840
      DC.L    $40400000
      DC.L    $38444444
      DC.L    $54483400
      DC.L    $00784444
      DC.L    $78504844
      DC.L    $00003844
      DC.L    $40380444
      DC.L    $3800007C
      DC.L    $10101010
      DC.L    $10100000
      DC.L    $44444444
oAF86 DC.L    $44443800
      DC.L    $00444444
      DC.L    $44442810
      DC.L    $00004444
      DC.L    $44445454
      DC.L    $28000044
      DC.L    $44281028
      DC.L    $44440000
      DC.L    $44442810
      DC.L    $10101000
      DC.L    $007C0408
      DC.L    $1020407C
      DC.L    $00001C10
      DC.L    $10101010
      DC.L    $1C000040
      DC.L    $40201008
oAFC6 DC.L    $04040000
      DC.L    $70101010
      DC.L    $10107000
      DC.L    $00102844
      DC.L    $00000000
      DC.L    $00000000
      DC.L    $00000000
      DC.L    $007C0018
      DC.L    $24207020
      DC.L    $207C0000
      DC.L    $0000344C
      DC.L    $444C3400
      DC.L    $00404078
      DC.L    $44444478
      DC.L    $00000000
      DC.L    $3C404040
      DC.L    $3C000004
oB00A DC.L    $043C4444
      DC.L    $443C0000
      DC.L    $00003844
      DC.L    $7C403C00
      DC.L    $00182420
      DC.L    $70202020
      DC.L    $00000000
      DC.L    $38444444
      DC.L    $3C043840
      DC.L    $40784444
      DC.L    $44440000
      DC.L    $10001010
      DC.L    $10100800
      DC.L    $00100010
      DC.L    $10101010
      DC.L    $10204040
      DC.L    $44487048
      DC.L    $44000010
oB052 DC.L    $10101010
      DC.L    $10080000
      DC.L    $00006854
      DC.L    $54545400
      DC.L    $00000078
      DC.L    $44444444
      DC.L    $00000000
      DC.L    $38444444
      DC.L    $38000000
      DC.L    $00784444
      DC.L    $44784040
      DC.L    $00003C44
      DC.L    $44443C04
      DC.L    $04000058
oB08A DC.L    $64404040
      DC.L    $00000000
      DC.L    $38403804
      DC.L    $38000010
      DC.L    $10381010
      DC.L    $100C0000
      DC.L    $00004444
      DC.L    $44443C00
      DC.L    $00000044
      DC.L    $44442810
      DC.L    $00000000
      DC.L    $44444454
oB0BA DC.L    $28000000
      DC.L    $00442810
      DC.L    $28440000
      DC.L    $00004444
      DC.L    $44443C04
      DC.L    $3800007C
      DC.L    $0810207C
      DC.L    $00000810
      DC.L    $10201010
      DC.L    $08000010
      DC.L    $10101010
      DC.L    $10100000
oB0EA DC.L    $20101008
      DC.L    $10102000
      DC.L    $00142800
      DC.L    $00000000
      DC.L    $00003844
      DC.L    $5C645C44
       DC.L    $38000000
L0B106 DC.L    $7F405428
XL0B106 EQU L0B106
       DC.L    $54285428
      DC.L    $54285444
      DC.L    $00344C44
      DC.L    $4C340000
      DC.L    $1428003C
oB11E DC.L    $444C3400
      DC.L    $00102810
      DC.L    $3C444C34
      DC.L    $00000810
      DC.L    $38447C40
      DC.L    $3C000044
      DC.L    $00384444
      DC.L    $44380000
      DC.L    $14280038
      DC.L    $44443800
      DC.L    $0000003C
      DC.L    $4C546478
      DC.L    $00004400
      DC.L    $00444444
      DC.L    $3C000000
oB15A DC.L    $003C4040
      DC.L    $403C1020
      DC.L    $14280078
      DC.L    $44444400
      DC.L    $0000003C
      DC.L    $143C503C
      DC.L    $00000000
      DC.L    $2C505C50
      DC.L    $2C000008
      DC.L    $10344C44
      DC.L    $4C340000
      DC.L    $2010344C
      DC.L    $444C3400
oB18E DC.L    $00102800
      DC.L    $3C444C34
      DC.L    $00004400
      DC.L    $38447C40
      DC.L    $3C000020
      DC.L    $1038447C
      DC.L    $403C0000
      DC.L    $10283844
      DC.L    $7C403C00
      DC.L    $00440000
      DC.L    $10101008
      DC.L    $00000810
oB1BE DC.L    $00101010
      DC.L    $08000020
oB1C6 DC.L    $10001010
      DC.L    $10080000
      DC.L    $10280010
      DC.L    $10100800
      DC.L    $00081038
      DC.L    $44444438
      DC.L    $00002010
      DC.L    $38444444
      DC.L    $38000010
      DC.L    $28003844
      DC.L    $44380000
      DC.L    $08104444
      DC.L    $44443C00
oB1FA DC.L    $00201044
      DC.L    $4444443C
      DC.L    $00001028
      DC.L    $00444444
      DC.L    $3C000038
      DC.L    $44445844
      DC.L    $44584040
      DC.L    $00083C48
      DC.L    $48483C08
      DC.L    $00444428
      DC.L    $107C1038
      DC.L    $00002010
      DC.L    $00000000
      DC.L    $00000044
      DC.L    $1028447C
      DC.L    $44440000
      DC.L    $14281028
      DC.L    $447C4400
oB242 DC.L    $00102810
      DC.L    $28447C44
      DC.L    $00000810
      DC.L    $7C407C40
      DC.L    $7C000044
      DC.L    $38444444
      DC.L    $44380000
      DC.L    $14283844
      DC.L    $44443800
      DC.L    $0034444C
      DC.L    $54644458
      DC.L    $00004400
      DC.L    $44444444
      DC.L    $38000038
      DC.L    $44404044
      DC.L    $38102000
      DC.L    $38004464
      DC.L    $544C4400
      DC.L    $003C4848
      DC.L    $7C48484C
      DC.L    $00003C48
oB296 DC.L    $484C4848
      DC.L    $3C000000
      DC.L    $00245848
      DC.L    $58240000
      DC.L    $38444038
      DC.L    $44443800
      DC.L    $00384444
      DC.L    $7C444438
      DC.L    $00004020
      DC.L    $20101828
      DC.L    $44000000
      DC.L    $00444444
      DC.L    $645C4040
      DC.L    $00003C68
oB2CE DC.L    $28282800
      DC.L    $00101038
      DC.L    $54545438
      DC.L    $10101000
      DC.L    $10101010
      DC.L    $10000010
      DC.L    $00102040
      DC.L    $44380000
      DC.L    $38440438
      DC.L    $40443800
      DC.L    $10384440
      DC.L    $38443804
      DC.L    $44380044
      DC.L    $38444438
      DC.L    $44000000
      DC.L    $14285028
      DC.L    $14000000
      DC.L    $00502814
      DC.L    $28500000
oB31A DC.L    $00102810
      DC.L    $00000000
      DC.L    $00000010
      DC.L    $007C0010
      DC.L    $00000000
      DC.L    $0010307C
      DC.L    $30100000
      DC.L    $00001018
      DC.L    $7C181000
      DC.L    $00001038
      DC.L    $7C101010
      DC.L    $10000010
      DC.L    $1010107C
      DC.L    $38100000

**** end of charfount_asm

**************************
*
* JM2 MDV-ROUTINES EXCEPT THAT D0=28 INSTEAD OF 14
*
***************************

* TRAP 2, D0=3        
L05000 TST.B   $EE(A6)  * Format mdv-Routine: is mdv actif ?
       BEQ.S   L0500A   * yes
       MOVEQ   #-9,D0   * "in use"
       RTS

* OPEN CHANNEL FOR FORMATTING       
L0500A MOVE.L  D1,D7    * SAVE VALUE OF D1 UND A1
       MOVEA.L A1,A4
       MOVE.L  #1152,D1 * reserved space
       JSR     L02FAE   * MM.ALCHP
       BEQ.S   L0501E   * sucess
       RTS              * error out of mem
        
L0501E LEA     $0010(A0),A0   * A0 / A5: BASISADR. FOR FORMATTING
       MOVEA.L A0,A5
       MOVEQ   #-$01,D0
       MOVE.W  D0,(A0)+       
       MOVEQ   #$09,D1
L0502A MOVE.B  #$20,(A0)+     * RESERVE 10*SPACE FOR NAME
       DBF     D1,L0502A
       MOVE.W  $002E(A6),(A0)   * SV.RND
       SUBA.W  #$000A,A0
       MOVE.W  (A4)+,D1
       ADDQ.W  #5,A4
       SUBQ.W  #5,D1
* NOW TRANSFER NAME AND SHORTEN TO MAXIMUM LENGHT 
       CMPI.W  #$000A,D1
       BLS.S   L05048
       MOVEQ   #$0A,D1
L05048 MOVE.B  (A4)+,(A0)+
       SUBQ.W  #1,D1
       BGT.S   L05048
       LEA     $000E(A5),A0
       MOVE.L  #$FD000C10,(A0)+  * FORMAT PARAM.
       ADDQ.W  #6,A0
       MOVE.W  D0,(A0)+
       MOVE.W  #$012A,D1         * LOOP-COUNTER
L05060 MOVE.W  #$AA55,(A0)+      * FORMAT VALUE
       DBF     D1,L05060
       MOVE.W  #$0F0E,$021A(A5)  * END SECTOR VALUE
       MOVE.W  D7,D1
       LEA     $00018020,A3   * A3 status of 8049
       MOVEQ   #$10,D0        * LOOP-COUNTER FOR TRANSMISSION
       JSR     L00420
       ORI.W   #$0700,SR      * interrupts
       JSR     L02C56         * motor on
       MOVE.L  #$0001E848,D0  * COUNTER:  about 0.5 secs
L0508E SUBQ.L  #1,D0
       BNE.S   L0508E
       MOVE.B  #$0A,(A3)
L05096 MOVEA.L A5,A1
       MOVEQ   #$0D,D1
       MOVE.W  #$0479,D0
L0509E DBF     D0,L0509E
       JSR     L051A6(PC)
       MOVE.W  #$0261,D1
       MOVE.W  #$047B,D0
L050AE DBF     D0,L050AE
       JSR     L051A6(PC)     * WRITE SECTOR-HEAD
       SUBQ.B  #1,-$026F(A1)  * ONE SECTOR LESS
       BCC.S   L05096
       MOVE.B  #$02,(A3)
       CLR.L   -(A7)
       MOVEQ   #$00,D5
L050C4 MOVE.W  #$00FF,D5
L050C8 MOVEA.L A5,A1
       JSR     L0523A(PC)   * read sector header
       BRA.S   L050E6   * error - no synchronisation
       BRA.S   L050E2   * read - error
       JSR     L052A4(PC)  * correct - read more
       BRA.S   L050E2   * error
       ADD.W   D7,D7    * next sector
       SUBQ.B  #1,$00(A1,D7.W)   * adapt sector nr.
       TST.W   D7       * sector 0
       BEQ.S   L050EA   * end verifying
L050E2 DBF     D5,L050C8
L050E6 BRA     L05180   * format failed

L050EA TST.L   D5       * 1. verify
       BLT.S   L050F2   * no
       MOVEQ   #-$01,D5
       BRA.S   L050C4

L050F2 MOVEQ   #$00,D5  * list formatted sectors
L050F4 SUBQ.B  #1,(A1)
       CMPI.B  #$FE,(A1) * IS SECTOR CORRECT FORMATTED?
       BGT.S   L05108    * YES BUT NOT SUCCESSFUL
       BEQ.S   L05100    * NO
       ADDQ.W  #1,(A7)   * ADD 1 TO SECTOR-COUNTER
L05100 MOVE.B  D5,$0003(A7) 
       MOVE.B  (A1),D4
       MOVEA.L A1,A4
L05108 ADDQ.W  #2,A1
       ADDQ.B  #1,D5
       BCC.S   L050F4    * CONTINUE TILL CARRY = 255 SECTORS
       ST      (A4)
       ADDQ.B  #2,D4
       BEQ.S   L05116
       SUBQ.W  #1,(A7)
L05116 CMPI.W  #$00C8,(A7) * less than 200 sectors?
       BLT.S   L05180      * error 
       LEA     $000E(A5),A1
       MOVEQ   #$00,D0
L05122 CLR.L   (A1)+
       ADDQ.B  #1,D0
       BPL.S   L05122
       LEA     $0270(A5),A1  * ADRESSE OF SECTOR-LIST
       MOVE.B  #$F8,(A1)
       MOVE.L  (A7),D1
       ADD.W   D1,D1
       SUBI.W  #$0010,D1
L05138 SUBQ.W  #2,D1
       CMPI.B  #$FD,$00(A1,D1.W)
       BNE.S   L05138
       CLR.B   $00(A1,D1.W)
       MOVE.W  D1,$01FE(A1)
       LSR.W   #1,D1
       MOVE.B  D1,(A7)
       MOVEQ   #$00,D2
       JSR     L05222(PC)   * search sector 0
       BRA.S   L05180       * not found - error
       LEA     $0270(A5),A1
       MOVE.W  (A1),-(A7)
       JSR     L051B0(PC)   * write sector catalogue
       ADDQ.W  #2,A7
       MOVE.B  (A7),D2      * last sector in d2
       JSR     L05222(PC)   * read header
       BRA.S   L05180       * failed
       LEA     $000E(A5),A1 * 
       MOVE.L  #$0040,(A1)
       CLR.W   -(A7)
       JSR     L051B0(PC)   * write errors
       ADDQ.W  #2,A7
       MOVEQ   #$00,D7
       BRA.S   L05182       * no errors o.k

L05180 MOVEQ   #-$0E,D7     * format failed
L05182 JSR     L02C50       * stop motor
       LEA     -$0010(A5),A0
       JSR     L0305E
       JSR     L00452
       ANDI.W  #$F0FF,SR
       CLR.B   (A7)
       MOVE.W  (A7)+,D1
       MOVE.W  (A7)+,D2
       MOVE.L  D7,D0
       RTS

L051A6 LEA     L051AC(PC),A4  * ADDR OF WRITING TO SECTOR
       BRA.S   L051E4

L051AC MOVEQ   #$0A,D4
       BRA.S   L051DA

L051B0
XL011B0 EQU L051B0-$4000 
       MOVE.B  #$0A,(A3)   * write a sector
       MOVE.W  #$05C9,D0
L051B8 DBF     D0,L051B8
       MOVEA.L A1,A0
       LEA     $0004(A7),A1
       MOVEQ   #$01,D1
       LEA     L051CA(PC),A4
       BRA.S   L051E4

L051CA MOVEA.L A0,A1       * A0= ADRESSE OF BUFFER
       MOVE.W  #$01FF,D1
       MOVEQ   #$05,D5
       LEA     L051D8(PC),A4
       BRA.S   L051F2

L051D8 MOVEQ   #$02,D4
L051DA MOVEQ   #$30,D0
L051DC DBF     D0,L051DC
       MOVE.B  D4,(A3)
       RTS

L051E4 MOVEQ   #$0E,D0   * common mdv write routine
       MOVE.B  D0,(A3)   * A3 = 8049
       MOVE.B  D0,(A3)
       MOVEQ   #$01,D6
       LEA     $0002(A3),A2
       MOVEQ   #$09,D5
L051F2 MOVEQ   #$00,D4
L051F4 BSR.S   L0521A
       SUBQ.B  #1,D5
       BGE.S   L051F4
       MOVEQ   #-$01,D4
       BSR.S   L0521A
       BSR.S   L0521A
       MOVE.W  #$0F0F,D3
       MOVEQ   #$00,D4
L05206 MOVE.B  (A1)+,D4
       ADD.W   D4,D3
       BSR.S   L0521A
       DBF     D1,L05206
       MOVE.W  D3,D4
       BSR.S   L0521A
       LSR.W   #8,D4
       BSR.S   L0521A
       JMP     (A4)

L0521A BTST    D6,(A3)   * test if 8049 busy
       BNE.S   L0521A
       MOVE.B  D4,(A2)
       RTS

L05222 MOVEQ   #$00,D5   * search mdvsector header - d5 counts sectors
L05224 MOVEA.L A5,A1
       BSR.S   L0523A    * do it
       RTS              * failed
       BRA.S   L05224   * read-error
       CMP.B   D7,D2    * was selected sector?
       BEQ.S   L05236
       ADDQ.B  #1,D5
       BCC.S   L05224   * til 255 sectors read
       RTS              * normal return adress

L05236 ADDQ.L  #2,(A7)  * return addr. + 2
       RTS

L0523A 
XL0123A EQU L0523A-$4000
       JSR     L05448(PC) * read sector header
       RTS                * failed
       ADDQ.L  #2,(A7)    * correct
       MOVEQ   #$0D,D1
       BSR     L052CE     * read 
       BRA.S   L0525A     * failed
       CMPI.B  #$FF,-$000E(A1) * sector nr. ok
       BNE.S   L0525A
       MOVEQ   #$00,D7
       MOVE.B  -$000D(A1),D7   * return sector nr.
       ADDQ.L  #2,(A7)
L0525A RTS

L0525C 
XL0125C EQU L0525C-$4000
       LEA     L052CE(PC),A0   * read sector (addr. in a0)
       BRA.S   L05266

L05262 
XL01262 EQU L05262-$4000
       LEA     L05354(PC),A0   * verify sector addr. in a0
L05266 JSR     L05448(PC)      * do it
       RTS                     * failed
       MOVE.L  A1,-(A7)
       CLR.W   -(A7)
       MOVEA.L A7,A1
       MOVEQ   #$01,D1
       BSR.S   L052CE   * read header
       BRA.S   L05296   * failed
       MOVE.B  #$02,D1  * ok
       MOVE.B  D1,(A3)  * set timing (8049)
       MOVEQ   #$08,D0  * wait a little
L05280 DBF     D0,L05280
       MOVE.B  D1,(A3)  * again timing
       MOVE.W  #$01FF,D1
       MOVEA.L $0002(A7),A1 * a1= buffer address
       JSR     (A0)     * do it
       BRA.S   L05296   * error
       ADDQ.L  #2,$0006(A7)
L05296 MOVEQ   #$00,D1
       MOVEQ   #$00,D2
       MOVE.B  $0001(A7),D2
       MOVE.B  (A7)+,D1
       ADDQ.W  #4,A7
       RTS

L052A4 JSR     L05448(PC)   * verify formatted sector / read header
       RTS                  * failed
       MOVE.W  #$0261,D1
       BSR     L05354       * read sector
       RTS                  * failed
       ADDQ.L  #2,(A7)
       RTS

L052B8 MOVE.W  #$0100,D0   * initialise parameters
       MOVE.W  #$0F0F,D3   * d0=counter, d3=checksum
       MOVEQ   #$00,D4
       MOVEQ   #$02,D6
       LEA     $0002(A3),A2   * to read track 1
       LEA     $0003(A3),A4   * to read track 2
       RTS

L052CE BSR     L052B8     * read number of bits - initialise
L052D0 BTST    D6,(A3)
       DBNE    D0,L052D0  * till buffer is empty
       EXG     A2,A4
       MOVE.B  (A2),D4
       MOVE.B  D4,(A1)+
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$28,D0  * !!! VALUE CHANGED
       SUBQ.W  #1,D1
       BGE.S   L052D0   * try evtl second track
       BRA     L05376

L05354 BSR     L052B8   * verify reading - initialise
L05358 BTST    D6,(A3)
       DBNE    D0,L05358
       EXG     A2,A4
       MOVE.B  (A2),D4
       CMP.B   (A1)+,D4
       BNE     L05446
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$28,D0   * !!! VALUE CHANGED
       SUBQ.W  #1,D1
       BGE     L05358
L05376 BTST    D6,(A3)
       DBNE    L05376 
       EXG     A4,A2
       MOVE.B  (A2),D4 
       ROR.W   #8,D4
       TST.W   D0       * if too long waited
       BLT.S   L05446   * back
       MOVEQ   #$28,D0  * !!! VALUE CHANGED
       ADDQ.W  #1,D1
       BEQ.S   L05376
       CMP.W   D4,D3    * compare checksum
       BNE.S   L05446   * not equal - BACK
       ADDQ.L  #2,(A7)
L05446 RTS

*  adapted from AA94 ff in  JM
*  with one differnce: IN JM is AAB6 : send two times 
*  D1 to (A3)=8049 In JS this is done 1 + 9 times
*  here you have the shortened form of JS

L05448 MOVEQ   #$00,D1   * wait for pulsing interrupts
L0544A SUBQ.W  #1,D1     * 0.38 seconds
       BEQ.S   L05476
       BTST    #$03,(A3) * from 8049
       BEQ.S   L0544A
       MOVEQ   #$00,D1
L05456 SUBQ.W  #1,D1     * wait again 0.38 sec
       BEQ.S   L05476
       MOVEQ   #$14,D0
L0545C BTST    #$03,(A3)
       BNE.S   L05456
       DBF     D0,L0545C
       MOVE.B  #$02,D1
       MOVEQ   #$09,D0
L0546E DBF     D0,L0546E
       MOVE.B  D1,(A3)
       ADDQ.L  #2,(A7)
L05476 RTS

**************************************************
*                                                *
* End MDV_ROUTINES mdv_routines                  *
*                                                *
**************************************************

*****************
*
* JS_KEYBOARD_ASM keyboard_asm
*
*****************
L0B458 
* Tastaturdekodierung - incl. L0B56B

  dc.l $000C008A,$004B00C9,$01080112

* the first bytes are displacements for key, shift key, ctrl_key
* ctrl-shift key, cursor, special keys
* the first 4 sequences start each with $03,$3F
* if you want to split: Take care for even adresses or use
* only dc.b
* THE LAST SEQUENCE IS ONLY IN SOME MG-VERSIONS
* THEY ALLOW YOU TO PRESS ACCENTS ~ ABOVE THE LETTER OR EVEN
* THE TREMA - IF ADDED THEM FOR COMPLETENESS - BUT UNLESS YOU REMOVE
* THE LEADING ASTERIX THEY WILL NOT BE ASSEMBLED

  dc.l $033F7876
  dc.l $886E2E38,$32366165,$30747539,$7A690972
  dc.l $2D796F6C,$33683171,$70646A83,$E06B7366
  dc.l $3D676D90,$773B6362,$FF2C8D0A,$C0D01BC8
  dc.l $9A20D8F4,$E835ECF0,$F8343703,$3F58563F
  dc.l $4E3E2A22,$27414529,$5455285A,$49FD525F
  dc.l $594F4C23,$48215150,$444A5CE4,$4B53462B
  dc.l $474DB657,$3A4342FF,$3C2FFEC4,$D47FCC60
  dc.l $FCDCF6EA,$25EEF2FA,$2426033F,$1816BF0E
  dc.l $8E7C9D40,$01054D14,$155B1ABB,$09127B19
  dc.l $0F0C9308,$91111004,$0ABCE20B,$13067D07
  dc.l $0DBD179B,$03025E8C,$870AC2D2,$00CA7E00
  dc.l $DAF5E997,$EDF1F994,$BA033FB8,$999FAE9E
  dc.l $8AA0BEA1,$A589B4B5,$9298A9FD,$B2BFB9AF
  dc.l $AC91A881,$B1B0A4AA,$96E6ABB3,$A68BA7AD
  dc.l $1DB795A3,$A3A21E9C,$82FEC6D6,$1FCE1C00
  dc.l $F7EB85EF,$F3FB8486,$21E031C0,$32D034C8
  DC.W $37D8
  DC.W $0000
  
* IF YOU WANT TO INTEGRATE THE FOLLOWING CODE:
* YOU MUST REMOVE THE LAST ZERO-WORD

* DC.L $2D05618E
* DC.L $65916995
* DC.L $6F98759B
* DC.L $310841A0
* DC.L $4FA455A7
* DC.L $6180658F
* DC.L $69926F84
* DC.L $758700FF

* LAST BYTE ($FF) PROBABLY HAST OB CONVERT TO $00 !!!!

****** End KEYBOARD_ASM keyboard_asm

**************************
*
*  JS MDV_ROUTINES  mdv_routines
*
***************************
        
L05000 TST.B   $EE(A6)  * Format mdv-Routine: is mdv actif ?
       BEQ.S   L0500A   * yes
       MOVEQ   #-9,D0   * "in use"
       RTS
       
L0500A MOVE.L  D1,D7
       MOVEA.L A1,A4
       MOVE.L  #1152,D1   * reserved space
       JSR     L02FAE   * MM.ALCHP
       NOP              * !!! to overvome asm - remove it !!!
       BEQ.S   L0501E   * sucess
       RTS              * error out of mem
        
L0501E LEA     $0010(A0),A0 
       MOVEA.L A0,A5
       MOVEQ   #-$01,D0
       MOVE.W  D0,(A0)+
       MOVEQ   #$09,D1
L0502A MOVE.B  #$20,(A0)+
       DBF     D1,L0502A
       MOVE.W  $002E(A6),(A0)   * SV.RND
       SUBA.W  #$000A,A0
       MOVE.W  (A4)+,D1
       ADDQ.W  #5,A4
       SUBQ.W  #5,D1
       CMPI.W  #$000A,D1
       BLS.S   L05048
       MOVEQ   #$0A,D1
L05048 MOVE.B  (A4)+,(A0)+
       SUBQ.W  #1,D1
       BGT.S   L05048
       LEA     $000E(A5),A0
       MOVE.L  #$FD000C10,(A0)+
       ADDQ.W  #6,A0
       MOVE.W  D0,(A0)+
       MOVE.W  #$012A,D1
L05060 MOVE.W  #$AA55,(A0)+
       DBF     D1,L05060
       MOVE.W  #$0F0E,$021A(A5)
       MOVE.W  D7,D1
       LEA     $00018020,A3   * A3 status of 8049
       MOVEQ   #$10,D0
       JSR     L00420
       NOP                    * !!! to conform asm leave it !!!
       ORI.W   #$0700,SR      * interrupts
       JSR     L02C56         * motor on
       NOP                    * !!! to conform asm leave it !!!
       MOVE.L  #$0001E848,D0  * time 3750600 about 0.5 secs
L0508E SUBQ.L  #1,D0
       BNE.S   L0508E
       MOVE.B  #$0A,(A3)
L05096 MOVEA.L A5,A1
       MOVEQ   #$0D,D1
       MOVE.W  #$0479,D0
L0509E DBF     D0,L0509E
       JSR     L051A6(PC)
       MOVE.W  #$0261,D1
       MOVE.W  #$047B,D0
L050AE DBF     D0,L050AE
       JSR     L051A6(PC)
       SUBQ.B  #1,-$026F(A1)
       BCC.S   L05096
       MOVE.B  #$02,(A3)
       CLR.L   -(A7)
       MOVEQ   #$00,D5
L050C4 MOVE.W  #$00FF,D5
L050C8 MOVEA.L A5,A1
       JSR     L0523A(PC)   * read sector header
       BRA.S   L050E6   * error - no synchronisation
       BRA.S   L050E2   * read - error
       JSR     L052A4(PC)  * correct - read more
       BRA.S   L050E2   * error
       ADD.W   D7,D7    * next sector
       SUBQ.B  #1,$00(A1,D7.W)   * adapt sector nr.
       TST.W   D7       * sector 0
       BEQ.S   L050EA   * end verifying
L050E2 DBF     D5,L050C8
L050E6 BRA     L05180   * format failed

L050EA TST.L   D5       * 1. verify
       BLT.S   L050F2   * no
       MOVEQ   #-$01,D5
       BRA.S   L050C4

L050F2 MOVEQ   #$00,D5  * list formatted sectors
L050F4 SUBQ.B  #1,(A1)
       CMPI.B  #$FE,(A1)
       BGT.S   L05108
       BEQ.S   L05100
       ADDQ.W  #1,(A7)
L05100 MOVE.B  D5,$0003(A7)
       MOVE.B  (A1),D4
       MOVEA.L A1,A4
L05108 ADDQ.W  #2,A1
       ADDQ.B  #1,D5
       BCC.S   L050F4
       ST      (A4)
       ADDQ.B  #2,D4
       BEQ.S   L05116
       SUBQ.W  #1,(A7)
L05116 CMPI.W  #$00C8,(A7) * less than 200 sectors?
       BLT.S   L05180      * error 
       LEA     $000E(A5),A1
       MOVEQ   #$00,D0
L05122 CLR.L   (A1)+
       ADDQ.B  #1,D0
       BPL.S   L05122
       LEA     $0270(A5),A1
       MOVE.B  #$F8,(A1)
       MOVE.L  (A7),D1
       ADD.W   D1,D1
       SUBI.W  #$0010,D1
L05138 SUBQ.W  #2,D1
       CMPI.B  #$FD,$00(A1,D1.W)
       BNE.S   L05138
       CLR.B   $00(A1,D1.W)
       MOVE.W  D1,$01FE(A1)
       LSR.W   #1,D1
       MOVE.B  D1,(A7)
       MOVEQ   #$00,D2
       JSR     L05222(PC)   * search sector 0
       BRA.S   L05180       * not found - error
       LEA     $0270(A5),A1
       MOVE.W  (A1),-(A7)
       JSR     L051B0(PC)   * write sector catalogue
       ADDQ.W  #2,A7
       MOVE.B  (A7),D2      * last sector in d2
       JSR     L05222(PC)   * read header
       BRA.S   L05180       * failed
       LEA     $000E(A5),A1 * 
       MOVE.L  #$0040,(A1)
       CLR.W   -(A7)
       JSR     L051B0(PC)   * write errors
       ADDQ.W  #2,A7
       MOVEQ   #$00,D7
       BRA.S   L05182       * no errors o.k

L05180 MOVEQ   #-$0E,D7     * format failed
L05182 JSR     L02C50       * stop motor
       NOP                  * !!! to conform asm - leave it out !!!
       LEA     -$0010(A5),A0
       JSR     L0305E
       NOP                  * !!! to conform asm - leave it out !!!
       JSR     L00452
       NOP                  * !!! to conform asm - leave it out !!
       ANDI.W  #$F0FF,SR
       CLR.B   (A7)
       MOVE.W  (A7)+,D1
       MOVE.W  (A7)+,D2
       MOVE.L  D7,D0
       RTS

L051A6 LEA     L051AC(PC),A4
       BRA.S   L051E4

L051AC MOVEQ   #$0A,D4
       BRA.S   L051DA

L051B0
XL011B0 EQU L051B0-$4000 
       MOVE.B  #$0A,(A3)   * write a sector
       MOVE.W  #$05C9,D0
L051B8 DBF     D0,L051B8
       MOVEA.L A1,A0
       LEA     $0004(A7),A1
       MOVEQ   #$01,D1
       LEA     L051CA(PC),A4
       BRA.S   L051E4

L051CA MOVEA.L A0,A1
       MOVE.W  #$01FF,D1
       MOVEQ   #$05,D5
       LEA     L051D8(PC),A4
       BRA.S   L051F2

L051D8 MOVEQ   #$02,D4
L051DA MOVEQ   #$30,D0
L051DC DBF     D0,L051DC
       MOVE.B  D4,(A3)
       RTS

L051E4 MOVEQ   #$0E,D0   * common mdv write routine
       MOVE.B  D0,(A3)
       MOVE.B  D0,(A3)
       MOVEQ   #$01,D6
       LEA     $0002(A3),A2
       MOVEQ   #$09,D5
L051F2 MOVEQ   #$00,D4
L051F4 BSR.S   L0521A
       SUBQ.B  #1,D5
       BGE.S   L051F4
       MOVEQ   #-$01,D4
       BSR.S   L0521A
       BSR.S   L0521A
       MOVE.W  #$0F0F,D3
       MOVEQ   #$00,D4
L05206 MOVE.B  (A1)+,D4
       ADD.W   D4,D3
       BSR.S   L0521A
       DBF     D1,L05206
       MOVE.W  D3,D4
       BSR.S   L0521A
       LSR.W   #8,D4
       BSR.S   L0521A
       JMP     (A4)

L0521A BTST    D6,(A3)   * test if 8049 busy
       BNE.S   L0521A
       MOVE.B  D4,(A2)
       RTS

L05222 MOVEQ   #$00,D5   * search sector header mdv
L05224 MOVEA.L A5,A1
       BSR.S   L0523A
       RTS              * failed
       BRA.S   L05224   * read-error
       CMP.B   D7,D2    * was selected sector?
       BEQ.S   L05236
       ADDQ.B  #1,D5
       BCC.S   L05224   * til 255 sectors read
       RTS              * normal return adress

L05236 ADDQ.L  #2,(A7)  * return addr. + 2
       RTS

L0523A 
XL0123A EQU L0523A-$4000
       JSR     L05448(PC) * read sector header
       RTS                * failed
       ADDQ.L  #2,(A7)    * correct
       MOVEQ   #$0D,D1
       BSR     L052CE     * read 
       BRA.S   L0525A     * failed
       CMPI.B  #$FF,-$000E(A1) * sector nr. ok
       BNE.S   L0525A
       MOVEQ   #$00,D7
       MOVE.B  -$000D(A1),D7   * return sector nr.
       ADDQ.L  #2,(A7)
L0525A RTS

L0525C 
XL0125C EQU L0525C-$4000
       LEA     L052CE(PC),A0   * read sector (addr. in a0)
       BRA.S   L05266

L05262 
XL01262 EQU L05262-$4000
       LEA     L05354(PC),A0   * verify sector addr. in a0
L05266 JSR     L05448(PC)      * do it
       RTS                     * failed
       MOVE.L  A1,-(A7)
       CLR.W   -(A7)
       MOVEA.L A7,A1
       MOVEQ   #$01,D1
       BSR.S   L052CE   * read header
       BRA.S   L05296   * failed
       MOVE.B  #$02,D1  * ok
       MOVE.B  D1,(A3)  * set timing (8049)
       MOVEQ   #$08,D0  * wait a little
L05280 DBF     D0,L05280
       MOVE.B  D1,(A3)  * again timing
       MOVE.W  #$01FF,D1
       MOVEA.L $0002(A7),A1 * a1= buffer address
       JSR     (A0)   * do it
       BRA.S   L05296   * error
       ADDQ.L  #2,$0006(A7)
L05296 MOVEQ   #$00,D1
       MOVEQ   #$00,D2
       MOVE.B  $0001(A7),D2
       MOVE.B  (A7)+,D1
       ADDQ.W  #4,A7
       RTS

L052A4 JSR     L05448(PC)   * verify formatted sector / read header
       RTS                  * failed
       MOVE.W  #$0261,D1
       BSR     L05354       * read sector
       RTS                  * failed
       ADDQ.L  #2,(A7)
       RTS

L052B8 MOVE.W  #$0100,D0   * initialise parameters
       MOVE.W  #$0F0F,D3   * d0=counter, d3=checksum
       MOVEQ   #$00,D4
       MOVEQ   #$02,D6
       LEA     $0002(A3),A2   * to read track 1
       LEA     $0003(A3),A4   * to read track 2
       RTS

L052CE BSR     L052B8   * read number of bits - initialise
L052D0 BTST    D6,(A3)
       DBNE    D0,L052D0  * till buffer is empty
       EXG      A4,A4     * !!! WHAT'S THAT ??? !!!
       MOVE.B   (A2),D4
       EXG      A4,A2     * !!! REALLY NECESSARY ?? !!!
       MOVE.B   D4,(A1)+
       ADD.W    D4,D3
       TST.W    D0
       BLT      L05446
       MOVEQ    #$14,D0
       SUBQ.W   #1,D1
L052EA BTST     D6,(A3)   * !!! better: DBNE D0,L052EA (as in JM ROM
       BNE.S      L05338  * but set D0 for better reliability to 28)
L052EE BTST     D6,(A3)   * then omit the following code)!!!
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
o05336 MOVEQ   #-1,D0
L05338 NOP
       NOP              * including this line but: - reset label!
       MOVE.B  (A2),D4
       EXG     A4,A2
       MOVE.B  D4,(A1)+
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
       BGE.S   L052EA   * try evtl second track
       BRA     L053DE

L05354 BSR     L052B8   * verify reading - initialise
L05358 BTST    D6,(A3)
       DBNE    D0,L05358
       EXG     A4,A4
       MOVE.B  (A2),D4
       EXG     A4,A2
       CMP.B   (A1)+,D4
       BNE     L05446
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
L05376 BTST    D6,(A3)   * again wasting ROM space
       BNE.S   L053C4    * !!! replace with dbne d0,L05376 !!!
       BTST    D6,(A3)   * again d0 set to 28
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       MOVEQ   #-$01,D0
L053C4 NOP
       NOP              * wasting ends here
       MOVE.B  (A2),D4
       EXG     A4,A2
       CMP.B   (A1)+,D4
       BNE.S   L05446
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
       BGE.S   L05376
       
L053DE BTST    D6,(A3)  * !!! again as above: dbne d0,L053DE
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       MOVEQ   #-$01,D0
L0542C NOP
       NOP

L05430 MOVE.B  (A2),D4
       EXG     A4,A2
       ROR.W   #8,D4
       TST.W   D0       * if too long waited
       BLT.S   L05446   * back
       MOVEQ   #$14,D0  * timer
       ADDQ.W  #1,D1
       BEQ.S   L053DE
       CMP.W   D4,D3    * compare checksum
       BNE.S   L05446   * not equal
       ADDQ.L  #2,(A7)
L05446 RTS

L05448 MOVEQ   #$00,D1   * wait for pulsing interrupts
L0544A SUBQ.W  #1,D1     * 0.38 seconds
       BEQ.S   L05476
       BTST    #$03,(A3) * from 8049
       BEQ.S   L0544A
       MOVEQ   #$00,D1
L05456 SUBQ.W  #1,D1     * wait again 0.38 sec
       BEQ.S   L05476
       MOVEQ   #$17,D0
L0545C BTST    #$03,(A3)
       BNE.S   L05456
       DBF     D0,L0545C
       MOVE.B  #$02,D1
       MOVE.B  D1,(A3)
       MOVEQ   #$08,D0
L0546E DBF     D0,L0546E
       MOVE.B  D1,(A3)
       ADDQ.L  #2,(A7)
L05476 RTS

**************************************************
*                                                *
* End MDV_ROUTINES mdv_routines                  *
*                                                *
**************************************************

*****************
*
* JS_KEYBOARD_ASM keyboard_asm
*
*****************
L0B458 
* Tastaturdekodierung - incl. L0B56B

  dc.l $000C008A,$004B00C9,$01080112

* the first bytes are displacements for key, shift key, ctrl_key
* ctrl-shift key, cursor, special keys
* the first 4 sequences start each with $03,$3F
* if you want to split: Take care for even adresses or use
* only dc.b
* THE LAST SEQUENCE IS ONLY IN SOME MG-VERSIONS
* THEY ALLOW YOU TO PRESS ACCENTS ~ ABOVE THE LETTER OR EVEN
* THE TREMA - IF ADDED THEM FOR COMPLETENESS - BUT UNLESS YOU REMOVE
* THE LEADING ASTERIX THEY WILL NOT BE ASSEMBLED

  dc.l $033F7876
  dc.l $886E2E38,$32366165,$30747539,$7A690972
  dc.l $2D796F6C,$33683171,$70646A83,$E06B7366
  dc.l $3D676D90,$773B6362,$FF2C8D0A,$C0D01BC8
  dc.l $9A20D8F4,$E835ECF0,$F8343703,$3F58563F
  dc.l $4E3E2A22,$27414529,$5455285A,$49FD525F
  dc.l $594F4C23,$48215150,$444A5CE4,$4B53462B
  dc.l $474DB657,$3A4342FF,$3C2FFEC4,$D47FCC60
  dc.l $FCDCF6EA,$25EEF2FA,$2426033F,$1816BF0E
  dc.l $8E7C9D40,$01054D14,$155B1ABB,$09127B19
  dc.l $0F0C9308,$91111004,$0ABCE20B,$13067D07
  dc.l $0DBD179B,$03025E8C,$870AC2D2,$00CA7E00
  dc.l $DAF5E997,$EDF1F994,$BA033FB8,$999FAE9E
  dc.l $8AA0BEA1,$A589B4B5,$9298A9FD,$B2BFB9AF
  dc.l $AC91A881,$B1B0A4AA,$96E6ABB3,$A68BA7AD
  dc.l $1DB795A3,$A3A21E9C,$82FEC6D6,$1FCE1C00
  dc.l $F7EB85EF,$F3FB8486,$21E031C0,$32D034C8
  DC.W $37D8
  DC.W $0000
  
* IF YOU WANT TO INTEGRATE THE FOLLOWING CODE:
* YOU MUST REMOVE THE LAST ZERO-WORD

* DC.L $2D05618E
* DC.L $65916995
* DC.L $6F98759B
* DC.L $310841A0
* DC.L $4FA455A7
* DC.L $6180658F
* DC.L $69926F84
* DC.L $758700FF

* LAST BYTE ($FF) PROBABLY HAST OB CONVERT TO $00 !!!!

****** End KEYBOARD_ASM keyboard_asm

************************
*
*    MDV_MAIN
*
**************************

L01230 DC.L    $00000000   * free for link pointer
       DC.L    L01274   * entry input / output
       DC.L    L01730   * entry addr. open channel
       DC.L    L018B8   * entry addr. close channel
       DC.L    L029fC   * service routine
       DC.L    $00      * reserved
       DC.L    $00      * reserved
       DC.L    L05000   * entry addr format
       DC.L    $428     * lenght of physi. def. block
       DC.W    $03
       DC.W    'MDV'
       
L0125A 
       MOVEM.L D0/D2/D4-D7/A4-A5,-(A7) * main mdv
L0125E MOVEM.L (A7),D0/D2
       MOVEQ   #$00,D3
       BSR.S   L01274
       ADDQ.L  #1,D0
       BEQ.S   L0125E
       SUBQ.L  #1,D0
       ADDQ.W  #4,A7
       MOVEM.L (A7)+,D2/D4-D7/A4-A5
       RTS

L01274 MOVEQ   #$00,D6    * select mdv-routine
       MOVE.B  $001D(A0),D6
       LSL.B   #2,D6
       LEA     $0100(A6),A2
       MOVEA.L $00(A2,D6.W),A2
       LSL.B   #2,D6
       CMPI.B  #$40,D0
       BCS     L0135E
       CMPI.B  #$49,D0
       BHI.S   L012A6
       MOVE.B  L0129C-$40(PC,D0.W),D0
       JMP     L0129C(PC,D0.W)

L0129C DC.B     XLVERIF-L0129C
       DC.B     XLTRANS-L0129C 
       DC.B     XLPOSAD-L0129C
       DC.B     XLPOSRAD-L0129C
       DC.B     XLBADPAR-L0129C
       DC.B     XLINFMD-L0129C
       DC.B     XLWRHEAD-L0129C
       DC.B     XLREHEAD-L0129C
       DC.B     XLLOADMD-L0129C
       DC.B     XLSAVEMD-L0129C
       
LBADPAR
XLBADPAR EQU LBADPAR
L012A6 MOVEQ   #-$0F,D0
       RTS

LVERIF 
XLVERIF EQU LVERIF
       MOVEQ   #$03,D4
       MOVEQ   #-$01,D5
       BRA.S   L012B4
       
LTRANS
XLTRANS EQU LTRANS
L012B0 MOVEQ   #$0C,D4
       MOVEQ   #$00,D5
       
L012B4 MOVE.B  $001D(A0),D3
       LSL.B   #4,D3
       BSET    #$00,D3
       MOVE.W  $001E(A0),D2
       MOVEA.L $0058(A6),A4
L012C6 MOVEQ   #-$0F,D0
       AND.B   (A4),D0
       CMP.B   D3,D0
       BNE.S   L012DE
       CMP.W   $0004(A4),D2
       BNE.S   L012DE
       MOVE.B  (A4),D0
       EOR.B   D5,D0
       AND.W   D4,D0
       BNE     L0151C
L012DE ADDQ.W  #8,A4
       CMPA.L  $005C(A6),A4
       BLT.S   L012C6
       MOVEQ   #$00,D0
       RTS

LPOSAD 
XLPOSAD EQU LPOSAD
       JSR     L01926(PC)
       BRA.S   L012F8

LPOSRAD
XLPOSRAD EQU LPOSRAD 
       TST.L   D3
       BNE.S   L012F8
       JSR     L0192C(PC)
L012F8 MOVEQ   #$00,D0
       BRA.S   L01362

LINFMDV
XLINFMD EQU LINFMDV 
       LEA     $0016(A2),A3
       MOVE.L  (A3)+,(A1)+
       MOVE.L  (A3)+,(A1)+
       MOVE.W  (A3)+,(A1)+
       MOVE.W  #$01FC,D0
       MOVEQ   #$00,D1
       MOVEQ   #$01,D2
L0130E CMPI.B  #$FD,$28(A2,D0.W)
       BHI.S   L0131C
       BNE.S   L0131A
       ADDQ.W  #1,D1
L0131A ADDQ.W  #1,D2
L0131C SUBQ.W  #2,D0
       BNE.S   L0130E
       SWAP    D1
       MOVE.W  D2,D1
       RTS

LLOADMD
XLLOADMD EQU LLOADMD
       MOVEQ   #$03,D0
       CMPI.L  #L01000,D2
       BLT.S   L01362
       BSR     L012B0
       BEQ     L015DA
       RTS

LSAVEMDV
XLSAVEMD EQU LSAVEMDV
       MOVEQ   #$07,D0
       BRA.S   L01362

LREHEAD
XLREHEAD EQU LREHEAD
       MOVEQ   #$03,D0
       MOVE.L  A1,-(A7)
       BSR.S   L01350
       MOVEQ   #$40,D4
       MOVEA.L (A7)+,A2
       SUB.L   D4,(A2)
       RTS

LWRHEAD
XLWRHEAD EQU LWRHEAD
       MOVEQ   #$07,D0
       MOVEQ   #$0E,D2
L01350 CLR.L   $0020(A0)
       BSR.S   L0135E
       MOVE.W  #$0040,$0022(A0)
       RTS

L0135E EXT.L   D1
       EXT.L   D2
L01362 CMPI.B  #$07,D0
       BHI     L012A6
       MOVEQ   #$00,D7
       TST.L   D3
       BEQ.S   L01372
       SUB.L   D1,D7
L01372 SUBQ.B  #4,D0
       BEQ     L012A6
       BLT.S   L0138E
       CMPI.B  #$01,$001C(A0)
       BEQ.S   L013BE
       MOVEQ   #-$01,D3
       SUBQ.W  #2,D0
       BEQ     L012A6
       BLT.S   L013AE
       BGT.S   L013A0
L0138E MOVEQ   #$00,D3
       ADDQ.B  #4,D0
       BEQ.S   L013AE
       MOVE.W  #$0100,D3
       SUBQ.B  #2,D0
       BLT.S   L013AE
       BGT.S   L013A0
       MOVEQ   #$0A,D3
L013A0 ADD.L   A1,D7
       MOVE.L  D7,-(A7)
       ADD.L   D2,D7
       BSR.S   L013C2
       MOVE.L  A1,D1
       SUB.L   (A7)+,D1
       RTS

L013AE MOVE.L  D1,-(A7)
       LEA     $0003(A7),A1
       MOVE.L  A1,D7
       ADDQ.L  #1,D7
       BSR.S   L013C2
       MOVE.L  (A7)+,D1
       RTS

L013BE MOVEQ   #-$14,D0
       RTS

L013C2 TST.B   $0023(A2)
       BGE.S   L013CC
L013C8 MOVEQ   #-$10,D0
       RTS

L013CC MOVE.L  $001E(A0),D5
       MOVE.L  $0020(A0),D4
       CMP.L   $0024(A0),D4
       BLT.S   L013E8
       BGT.S   L013E0
       TST.B   D3
       BLT.S   L013E4
L013E0 MOVEQ   #-$0A,D0
L013E2 RTS

L013E4 TST.W   D4
       BEQ.S   L0140C
L013E8 BSR     L014D6
       BNE.S   L013E2
       TST.W   D4
       BNE.S   L01422
       MOVE.L  A4,-(A7)
       ADDQ.W  #1,D5
       MOVEQ   #$00,D2
       MOVE.W  D5,D2
       SWAP    D2
       CMP.L   $0024(A0),D2
       BGE.S   L01406
       BSR     L014E2
L01406 MOVEA.L (A7)+,A4
       SUBQ.W  #1,D5
       BRA.S   L01422

L0140C CMP.L   A1,D7
       BLS     L01496
       BSR     L0159E
       BSR     L01524
       MOVE.W  D0,$0002(A4)
       ORI.B   #$03,(A4)
L01422 MOVE.L  A4,$0028(A0)
       BTST    #$01,(A4)
       BEQ     L0151C
       TST.W   D3
       BEQ.S   L01496
       MOVE.L  A4,D0
       SUB.L   $0058(A6),D0
       LSL.L   #6,D0
       MOVEA.L D0,A5
       ADDA.L  A6,A5
       ADDA.W  D4,A5
       TST.W   D3
       BGT.S   L01464
L01444 CMP.L   A1,D7
       BLS.S   L01452
       MOVE.B  (A1)+,(A5)+
       BSR.S   L014A2
       BNE.S   L01444
       JSR     L029FC(PC)
L01452 ST      $002C(A0)
       BSR.S   L014B6
       CMP.L   $0024(A0),D4
       BLT.S   L0147E
       MOVE.L  D4,$0024(A0)
       BRA.S   L0147E

L01464 MOVEQ   #$00,D0
L01466 CMP.L   A1,D7
       BLS.S   L0147E
       CMP.L   $0024(A0),D4
       BGE.S   L0149A
       MOVE.B  (A5)+,D0
       MOVE.B  D0,(A1)+
       CMP.W   D0,D3
       BNE.S   L0147A
       MOVE.L  A1,D7
L0147A BSR.S   L014A2
       BNE.S   L01466
L0147E MOVE.L  D4,$0020(A0)
       CMP.L   A1,D7
       BHI     L013C2
       CMPI.W  #$000A,D3
       BNE.S   L01496
       CMP.B   D0,D3
       BEQ.S   L01496
       MOVEQ   #-$05,D0
       RTS

L01496 MOVEQ   #$00,D0
       RTS

L0149A MOVE.L  D4,$0020(A0)
       BRA     L013E0

L014A2 ADDQ.W  #1,D4
       BTST    #$09,D4
       BEQ.S   L014B2
       ADDQ.W  #1,D5
       ADDI.L  #$FE00,D4
L014B2 TST.W   D4
       RTS

L014B6 MOVEQ   #$07,D0
       OR.B    D6,D0
       MOVE.B  D0,(A4)
L014BC MOVE.L  A4,D1
       SUB.L   $0058(A6),D1
       LSR.L   #3,D1
       ADDA.W  $0002(A4),A2
       MOVE.W  D1,$0228(A2)
       SUBA.W  $0002(A4),A2
       SF      $0024(A2)
       RTS

L014D6 MOVEA.L $0028(A0),A4
       MOVE.L  A4,D0
       BNE.S   L014E2
       MOVEA.L $0058(A6),A4
L014E2 MOVEA.L A4,A5
L014E4 MOVEQ   #$0E,D0
       AND.B   (A4),D0
       BEQ.S   L014FA
       MOVEQ   #-$10,D0
       AND.B   (A4),D0
       CMP.B   D0,D6
       BNE.S   L014FA
       MOVEQ   #$00,D0
       CMP.L   $0004(A4),D5
       BEQ.S   L01522
L014FA ADDQ.L  #8,A4
       CMPA.L  $005C(A6),A4
       BLT.S   L01506
       MOVEA.L $0058(A6),A4
L01506 CMPA.L  A4,A5
       BNE.S   L014E4
       BSR     L01598
       BSR     L0159E
       MOVE.W  D0,$0002(A4)
       ORI.B   #$09,(A4)
       BSR.S   L014BC
L0151C JSR     L029FC(PC)
L01520 MOVEQ   #-$01,D0
L01522 RTS

L01524 BSR.S   L0157A
       SUBQ.B  #1,D2
       BCC.S   L01532
       MOVEQ   #-$28,D0
       ADD.W   $0226(A2),D0
       BRA.S   L01534

L01532 BSR.S   L01586
L01534 SUBI.W  #$0018,D0
       BGE.S   L0154A
       MOVE.W  #$01FE,D1
L0153E SUBQ.W  #2,D1
       CMPI.B  #$FF,$28(A2,D1.W)

       BEQ.S   L0153E
       ADD.W   D1,D0
L0154A MOVE.W  D0,-(A7)
L0154C SUBQ.W  #2,D0
       BPL.S   L01554
       MOVE.W  #$01FC,D0
L01554 CMPI.B  #$FD,$28(A2,D0.W)
       BEQ.S   L01566
       CMP.W   (A7),D0
       BNE.S   L0154C
       ADDQ.W  #6,A7
       MOVEQ   #-$0B,D0
       RTS

L01566 ADDQ.B  #1,D2
       MOVE.W  D2,$28(A2,D0.W)
       MOVE.W  D0,$0226(A2)
       MOVE.W  #-1,$0228(A2)
       ADDQ.W  #2,A7
       RTS

L0157A MOVE.W  #$01FE,D0
       MOVE.L  D5,D2
       LSL.W   #8,D2
       LSR.L   #8,D2
       RTS

L01586 SUBQ.W  #2,D0
       BLT.S   L01592
       CMP.W   $28(A2,D0.W),D2
       BNE.S   L01586
       RTS

L01592 ADDQ.W  #8,A7
       BRA     L013C8

L01598 BSR.S   L0157A
       BSR.S   L01586
       RTS

L0159E MOVEA.L $0054(A6),A4
       MOVEA.L A4,A5
L015A4 ADDQ.W  #8,A4
       CMPA.L  $005C(A6),A4
       BLT.S   L015B0
       MOVEA.L $0058(A6),A4
L015B0 MOVEQ   #$0F,D1
       AND.B   (A4),D1
       SUBQ.B  #1,D1
       BEQ.S   L015C6
       SUBQ.B  #2,D1
       BEQ.S   L015C6
       CMPA.L  A5,A4
       BNE.S   L015A4
       ADDQ.W  #4,A7
       BRA     L01520

L015C6 MOVE.L  A4,$0054(A6)
       MOVE.L  A4,$0028(A0)
       MOVE.B  D6,(A4)
       ORI.B   #$01,(A4)
       MOVE.L  D5,$0004(A4)
       RTS

L015DA JSR     L0159E(PC)
       SUBQ.L  #8,$0054(A6)
       MOVE.L  A4,D0
       SUB.L   $0058(A6),D0
       LSL.L   #6,D0
       MOVEA.L D0,A4
       ADDA.L  A6,A4
       JSR     L029FC(PC)
       LEA     $00018020,A3
       ANDI.B  #$DF,$0035(A6)
       MOVE.B  $0035(A6),$0001(A3)
       LSL.L   #8,D0
       CMP.B   $00EE(A6),D1
       BEQ.S   L01612
       MOVEQ   #-$01,D0
       BRA     L01724

L01612 MOVEQ   #$07,D0
       LEA     $0058(A0),A5
L01618 CLR.L   (A5)+
       DBF     D0,L01618
       MOVE.L  $0024(A0),D2
       TST.W   D2
       BNE.S   L0162C
       SUBI.L  #$FE00,D2
L0162C MOVE.L  D2,$0020(A0)
       SWAP    D2
       MOVE.W  D2,D0
       LSR.W   #3,D0
       LEA     $0058(A0),A5
       BRA.S   L0163E

L0163C ST      (A5)+
L0163E DBF     D0,L0163C
       MOVE.W  #$FF01,D1
       MOVEQ   #$07,D0
       AND.W   D2,D0
       ROL.W   D0,D1
       MOVE.B  D1,(A5)
       SUBA.W  #$0040,A1
       MOVEM.L A0-A2/A4,-(A7)
L01656 ANDI.W  #$F8FF,SR
       ORI.W   #$0700,SR
L0165E MOVEA.L (A7),A0
       LEA     $0078(A0),A1
       JSR     L0523A
       BRA.S   L016D6           * ERROR
       BRA.S   L01656           * ERROR
       MOVEM.L (A7),A0-A2/A4    * SUCCESS
       ADD.W   D7,D7
       BEQ     L016FC
       MOVE.B  $28(A2,D7.W),D0
       CMP.B   $001F(A0),D0
       BNE.S   L01656
       MOVEQ   #$00,D4
       MOVE.B  $29(A2,D7.W),D4
       MOVE.L  D4,D7
       MOVEQ   #$07,D5
       AND.W   D4,D5
       LSR.W   #3,D4
       BTST    D5,$58(A0,D4.W)
       BEQ.S   L01656
       MOVEA.W D4,A5
       MOVEA.L A4,A1
       JSR     L0525C
       BRA.S   L0165E           * ERROR
       MOVEM.L (A7),A0-A2/A4    * SUCCESS
       BCLR    D5,$58(A0,A5.W)
       MOVE.L  #$00000080,D0
       MOVEA.L A1,A5
       MOVE.L  D7,D1
       LSL.W   #8,D1
       ADD.L   D1,D1
       ADDA.L  D1,A5
       CMP.W   $0020(A0),D7
       BNE.S   L016C6
       MOVE.W  $0022(A0),D0
       ROR.L   #2,D0
L016C6 TST.W   D7
       BNE.S   L016DA
       MOVEQ   #$40,D1
       ADDA.W  D1,A4
       ADDA.W  D1,A5
       SUBI.W  #$0010,D0
       BRA.S   L016DA

L016D6 BRA.S   L0170A

L016D8 MOVE.L  (A4)+,(A5)+
L016DA DBF     D0,L016D8
       CLR.W   D0
       ROL.L   #2,D0
       BRA.S   L016E6

L016E4 MOVE.B  (A4)+,(A5)+
L016E6 DBF     D0,L016E4
       MOVEQ   #$08,D0
       LEA     $0058(A0),A5
L016F0 TST.L   (A5)+
       BNE     L0165E
       SUBQ.W  #1,D0
       BGT.S   L016F0
       BRA.S   L0170C

L016FC ADDQ.B  #1,$0024(A2)
       CMPI.B  #$08,$0024(A2)
       BLT     L01656
L0170A MOVEQ   #-$10,D0
L0170C MOVEM.L (A7)+,A0-A2/A4
       SF      $0024(A2)
       MOVEQ   #$00,D7
       MOVE.W  $0024(A0),D7
       LSL.L   #8,D7
       ADD.L   D7,D7
       ADDA.L  D7,A1
       ADDA.W  $0026(A0),A1
L01724 ORI.B   #$20,$0035(A6)
       ANDI.W  #$F8FF,SR
       RTS

L01730 MOVEA.L A1,A2   * open mdv-channel
       MOVEQ   #$00,D1
       MOVE.B  $0014(A2),D1
       MOVEQ   #$00,D0
       MOVE.B  $001D(A0),D0
       LSL.B   #2,D0
       LEA     $00EE(A6),A4
       MOVE.B  D0,$01(A4,D1.W)
       CMP.B   (A4),D1
       BEQ.S   L01766
       TST.B   $07(A4,D1.W)
       BNE.S   L01766
       MOVE.B  #$01,$0023(A2)
       JSR     L02A00(PC)
L0175C TST.B   $0023(A2)
       BGT.S   L0175C
       BMI     L01844
L01766 LEA     $0058(A0),A4
       MOVEQ   #$40,D2
       MOVE.L  D2,$0024(A0)
       MOVEQ   #-$01,D3
       BSR     L0184C
       MOVE.L  (A4),D4
       MOVE.L  D4,D0
       LSL.L   #7,D0
       LSR.W   #7,D0
       MOVE.L  D0,$0024(A0)
       CMPI.B  #$04,$001C(A0)
       BEQ     L01840
       LSR.L   #6,D4
       MOVEQ   #$00,D5
       MOVEQ   #$00,D6
       BRA.S   L017BE

L01794 BSR     L0184C
       TST.L   (A4)
       BEQ.S   L017B8
       MOVE.L  A0,-(A7)
       MOVE.L  A6,-(A7)
       SUBA.L  A6,A6
       LEA     $000E(A4),A1
       LEA     $0032(A0),A0
       MOVEQ   #$01,D0
       JSR     L03A9C(PC)   * UT.CSTR
       MOVEA.L (A7)+,A6
       MOVEA.L (A7)+,A0
       BEQ.S   L01822
       BRA.S   L017BE

L017B8 TST.W   D6
       BNE.S   L017BE
       MOVE.W  D5,D6
L017BE ADDQ.W  #1,D5
       CMP.W   D4,D5
       BLT.S   L01794
       MOVE.B  $001C(A0),D0
       BLT.S   L01840
       CMPI.B  #$02,D0
       BLT.S   L01844
       TST.W   D6
       BEQ.S   L017E2
       MOVE.L  D6,D0
       LSL.L   #6,D0
       LSL.L   #7,D0
       LSR.W   #7,D0
       MOVE.L  D0,$0020(A0)
       MOVE.L  D6,D5
L017E2 MOVE.L  D2,(A4)+
       CLR.W   (A4)+
       CLR.L   (A4)+
       CLR.L   (A4)+
       MOVEQ   #$09,D0
       LEA     $0032(A0),A5
L017F0 MOVE.L  (A5)+,(A4)+
       DBF     D0,L017F0
       LEA     $0058(A0),A4
       BSR.S   L01850
       TST.W   D6
       BNE.S   L01810
       ADDQ.W  #1,D4
       LSL.L   #6,D4
       MOVE.L  D4,(A4)
       CLR.L   $0020(A0)
       MOVEQ   #$04,D2
       BSR.S   L01850
       MOVEQ   #$40,D2
L01810 MOVE.L  D2,(A4)
       CLR.L   $0020(A0)
       CLR.L   $0024(A0)
       MOVE.W  D5,$001E(A0)
       BSR.S   L01850
       BRA.S   L01840

L01822 MOVE.B  $001C(A0),D0
       BLT.S   L0185E
       CMPI.B  #$02,D0
       BGE.S   L01848
       MOVE.L  (A4),D0
       LSL.L   #7,D0
       LSR.W   #7,D0
       MOVE.L  D0,$0024(A0)
       MOVE.W  D5,$001E(A0)
       MOVE.L  D2,$0020(A0)
L01840 MOVEQ   #$00,D0
       BRA.S   L0184A

L01844 MOVEQ   #-$07,D0
       BRA.S   L0184A

L01848 MOVEQ   #-$08,D0
L0184A RTS

L0184C MOVEQ   #$03,D0
       BRA.S   L01852

L01850 MOVEQ   #$07,D0
L01852 MOVEA.L A4,A1
       JSR     L0125A(PC)
       BEQ.S   L0184A
       ADDQ.W  #4,A7
       RTS

L0185E MOVEQ   #-$40,D1
       JSR     L0192C(PC)
       CLR.L   (A4)
       CLR.W   $000E(A4)
       BSR.S   L01850
       MOVE.W  #$01FE,D0
       LEA     $28(A2,D0.W),A4
L01874 CMP.B   (A4),D5
       BNE.S   L01880
       MOVE.W  #$FD00,(A4)
       CLR.W   $0200(A4)
L01880 SUBQ.W  #2,A4
       SUBQ.W  #2,D0
       BNE.S   L01874
       MOVE.B  $001D(A0),D1
       LSL.B   #4,D1
       ADDQ.W  #1,D1
       MOVEA.L $0058(A6),A4
L01892 MOVEQ   #-$0F,D0
       AND.B   (A4),D0
       CMP.B   D0,D1
       BNE.S   L018A4
       CMP.W   $0004(A4),D5
       BNE.S   L018A4
       MOVE.B  #$01,(A4)
L018A4 ADDQ.W  #8,A4
       CMPA.L  $005C(A6),A4
       BLT.S   L01892
       MOVE.W  #-1,$0228(A2)
       JSR     L029FC(PC)
       BRA.S   L01840

L018B8 TST.B   $002C(A0)   * close mdv-channel
       BEQ.S   L018F0
       MOVE.L  $0024(A0),D0
       LSL.W   #7,D0
       LSR.L   #7,D0
       LEA     $0058(A0),A1
       MOVE.L  D0,(A1)
       CLR.L   $0020(A0)
       BSR.S   L0191A
       MOVEQ   #$00,D0
       MOVE.W  $001E(A0),D0
       LSL.L   #6,D0
       LSL.L   #7,D0
       LSR.W   #7,D0
       MOVE.L  D0,$0020(A0)
       CLR.W   $001E(A0)
       ST      $0025(A0)
       BSR.S   L0191A
       JSR     L029FC(PC)
L018F0 MOVEQ   #$00,D0
       MOVE.B  $001D(A0),D0
       LSL.B   #2,D0
       LEA     $0100(A6),A2
       MOVEA.L $00(A2,D0.W),A2
       SUBQ.B  #1,$0022(A2)
       LEA     $0140(A6),A1
       LEA     $0018(A0),A0
       JSR     L039E2(PC)    * UT.UNLNK
       LEA     -$0018(A0),A0
       JSR     L0305E(PC)    * MT.RECHP
       RTS

L0191A MOVEQ   #$07,D0
       MOVEQ   #$04,D2
       JSR     L0125A(PC)
       SUBA.W  D1,A1
       RTS

L01926 MOVEQ   #$40,D2
       ADD.L   D2,D1
       BRA.S   L01938

L0192C MOVEQ   #$40,D2
       MOVE.L  $0020(A0),D0
L01932 LSL.W   #7,D0
       LSR.L   #7,D0
       ADD.L   D0,D1
L01938 MOVE.L  D1,D0
       LSL.L   #7,D0
       LSR.W   #7,D0
       CMP.L   $0024(A0),D0
       BLE.S   L0194C
       MOVE.L  $0024(A0),D0
       MOVEQ   #$00,D1
       BRA.S   L01932

L0194C SUB.L   D2,D1
       BGE.S   L01954
       MOVE.L  D2,D1
       BRA.S   L01938

L01954 MOVE.L  D0,$0020(A0)
       RTS

*** ---------End MDV_MAIN mdv_main---

**************************
*
*  JS MDV_ROUTINES  mdv_routines
*
***************************
        
L05000 TST.B   $EE(A6)  * Format mdv-Routine: is mdv actif ?
       BEQ.S   L0500A   * yes
       MOVEQ   #-9,D0   * "in use"
       RTS
       
L0500A MOVE.L  D1,D7
       MOVEA.L A1,A4
       MOVE.L  #1152,D1   * reserved space
       JSR     L02FAE   * MM.ALCHP
       NOP              * !!! to overvome asm - remove it !!!
       BEQ.S   L0501E   * sucess
       RTS              * error out of mem
        
L0501E LEA     $0010(A0),A0 
       MOVEA.L A0,A5
       MOVEQ   #-$01,D0
       MOVE.W  D0,(A0)+
       MOVEQ   #$09,D1
L0502A MOVE.B  #$20,(A0)+
       DBF     D1,L0502A
       MOVE.W  $002E(A6),(A0)   * SV.RND
       SUBA.W  #$000A,A0
       MOVE.W  (A4)+,D1
       ADDQ.W  #5,A4
       SUBQ.W  #5,D1
       CMPI.W  #$000A,D1
       BLS.S   L05048
       MOVEQ   #$0A,D1
L05048 MOVE.B  (A4)+,(A0)+
       SUBQ.W  #1,D1
       BGT.S   L05048
       LEA     $000E(A5),A0
       MOVE.L  #$FD000C10,(A0)+
       ADDQ.W  #6,A0
       MOVE.W  D0,(A0)+
       MOVE.W  #$012A,D1
L05060 MOVE.W  #$AA55,(A0)+
       DBF     D1,L05060
       MOVE.W  #$0F0E,$021A(A5)
       MOVE.W  D7,D1
       LEA     $00018020,A3   * A3 status of 8049
       MOVEQ   #$10,D0
       JSR     L00420
       NOP                    * !!! to conform asm leave it !!!
       ORI.W   #$0700,SR      * interrupts
       JSR     L02C56         * motor on
       NOP                    * !!! to conform asm leave it !!!
       MOVE.L  #$0001E848,D0  * time 3750600 about 0.5 secs
L0508E SUBQ.L  #1,D0
       BNE.S   L0508E
       MOVE.B  #$0A,(A3)
L05096 MOVEA.L A5,A1
       MOVEQ   #$0D,D1
       MOVE.W  #$0479,D0
L0509E DBF     D0,L0509E
       JSR     L051A6(PC)
       MOVE.W  #$0261,D1
       MOVE.W  #$047B,D0
L050AE DBF     D0,L050AE
       JSR     L051A6(PC)
       SUBQ.B  #1,-$026F(A1)
       BCC.S   L05096
       MOVE.B  #$02,(A3)
       CLR.L   -(A7)
       MOVEQ   #$00,D5
L050C4 MOVE.W  #$00FF,D5
L050C8 MOVEA.L A5,A1
       JSR     L0523A(PC)   * read sector header
       BRA.S   L050E6   * error - no synchronisation
       BRA.S   L050E2   * read - error
       JSR     L052A4(PC)  * correct - read more
       BRA.S   L050E2   * error
       ADD.W   D7,D7    * next sector
       SUBQ.B  #1,$00(A1,D7.W)   * adapt sector nr.
       TST.W   D7       * sector 0
       BEQ.S   L050EA   * end verifying
L050E2 DBF     D5,L050C8
L050E6 BRA     L05180   * format failed

L050EA TST.L   D5       * 1. verify
       BLT.S   L050F2   * no
       MOVEQ   #-$01,D5
       BRA.S   L050C4

L050F2 MOVEQ   #$00,D5  * list formatted sectors
L050F4 SUBQ.B  #1,(A1)
       CMPI.B  #$FE,(A1)
       BGT.S   L05108
       BEQ.S   L05100
       ADDQ.W  #1,(A7)
L05100 MOVE.B  D5,$0003(A7)
       MOVE.B  (A1),D4
       MOVEA.L A1,A4
L05108 ADDQ.W  #2,A1
       ADDQ.B  #1,D5
       BCC.S   L050F4
       ST      (A4)
       ADDQ.B  #2,D4
       BEQ.S   L05116
       SUBQ.W  #1,(A7)
L05116 CMPI.W  #$00C8,(A7) * less than 200 sectors?
       BLT.S   L05180      * error 
       LEA     $000E(A5),A1
       MOVEQ   #$00,D0
L05122 CLR.L   (A1)+
       ADDQ.B  #1,D0
       BPL.S   L05122
       LEA     $0270(A5),A1
       MOVE.B  #$F8,(A1)
       MOVE.L  (A7),D1
       ADD.W   D1,D1
       SUBI.W  #$0010,D1
L05138 SUBQ.W  #2,D1
       CMPI.B  #$FD,$00(A1,D1.W)
       BNE.S   L05138
       CLR.B   $00(A1,D1.W)
       MOVE.W  D1,$01FE(A1)
       LSR.W   #1,D1
       MOVE.B  D1,(A7)
       MOVEQ   #$00,D2
       JSR     L05222(PC)   * search sector 0
       BRA.S   L05180       * not found - error
       LEA     $0270(A5),A1
       MOVE.W  (A1),-(A7)
       JSR     L051B0(PC)   * write sector catalogue
       ADDQ.W  #2,A7
       MOVE.B  (A7),D2      * last sector in d2
       JSR     L05222(PC)   * read header
       BRA.S   L05180       * failed
       LEA     $000E(A5),A1 * 
       MOVE.L  #$0040,(A1)
       CLR.W   -(A7)
       JSR     L051B0(PC)   * write errors
       ADDQ.W  #2,A7
       MOVEQ   #$00,D7
       BRA.S   L05182       * no errors o.k

L05180 MOVEQ   #-$0E,D7     * format failed
L05182 JSR     L02C50       * stop motor
       NOP                  * !!! to conform asm - leave it out !!!
       LEA     -$0010(A5),A0
       JSR     L0305E
       NOP                  * !!! to conform asm - leave it out !!!
       JSR     L00452
       NOP                  * !!! to conform asm - leave it out !!
       ANDI.W  #$F0FF,SR
       CLR.B   (A7)
       MOVE.W  (A7)+,D1
       MOVE.W  (A7)+,D2
       MOVE.L  D7,D0
       RTS

L051A6 LEA     L051AC(PC),A4
       BRA.S   L051E4

L051AC MOVEQ   #$0A,D4
       BRA.S   L051DA

L051B0
XL011B0 EQU L051B0-$4000 
       MOVE.B  #$0A,(A3)   * write a sector
       MOVE.W  #$05C9,D0
L051B8 DBF     D0,L051B8
       MOVEA.L A1,A0
       LEA     $0004(A7),A1
       MOVEQ   #$01,D1
       LEA     L051CA(PC),A4
       BRA.S   L051E4

L051CA MOVEA.L A0,A1
       MOVE.W  #$01FF,D1
       MOVEQ   #$05,D5
       LEA     L051D8(PC),A4
       BRA.S   L051F2

L051D8 MOVEQ   #$02,D4
L051DA MOVEQ   #$30,D0
L051DC DBF     D0,L051DC
       MOVE.B  D4,(A3)
       RTS

L051E4 MOVEQ   #$0E,D0   * common mdv write routine
       MOVE.B  D0,(A3)
       MOVE.B  D0,(A3)
       MOVEQ   #$01,D6
       LEA     $0002(A3),A2
       MOVEQ   #$09,D5
L051F2 MOVEQ   #$00,D4
L051F4 BSR.S   L0521A
       SUBQ.B  #1,D5
       BGE.S   L051F4
       MOVEQ   #-$01,D4
       BSR.S   L0521A
       BSR.S   L0521A
       MOVE.W  #$0F0F,D3
       MOVEQ   #$00,D4
L05206 MOVE.B  (A1)+,D4
       ADD.W   D4,D3
       BSR.S   L0521A
       DBF     D1,L05206
       MOVE.W  D3,D4
       BSR.S   L0521A
       LSR.W   #8,D4
       BSR.S   L0521A
       JMP     (A4)

L0521A BTST    D6,(A3)   * test if 8049 busy
       BNE.S   L0521A
       MOVE.B  D4,(A2)
       RTS

L05222 MOVEQ   #$00,D5   * search sector header mdv
L05224 MOVEA.L A5,A1
       BSR.S   L0523A
       RTS              * failed
       BRA.S   L05224   * read-error
       CMP.B   D7,D2    * was selected sector?
       BEQ.S   L05236
       ADDQ.B  #1,D5
       BCC.S   L05224   * til 255 sectors read
       RTS              * normal return adress

L05236 ADDQ.L  #2,(A7)  * return addr. + 2
       RTS

L0523A 
XL0123A EQU L0523A-$4000
       JSR     L05448(PC) * read sector header
       RTS                * failed
       ADDQ.L  #2,(A7)    * correct
       MOVEQ   #$0D,D1
       BSR     L052CE     * read 
       BRA.S   L0525A     * failed
       CMPI.B  #$FF,-$000E(A1) * sector nr. ok
       BNE.S   L0525A
       MOVEQ   #$00,D7
       MOVE.B  -$000D(A1),D7   * return sector nr.
       ADDQ.L  #2,(A7)
L0525A RTS

L0525C 
XL0125C EQU L0525C-$4000
       LEA     L052CE(PC),A0   * read sector (addr. in a0)
       BRA.S   L05266

L05262 
XL01262 EQU L05262-$4000
       LEA     L05354(PC),A0   * verify sector addr. in a0
L05266 JSR     L05448(PC)      * do it
       RTS                     * failed
       MOVE.L  A1,-(A7)
       CLR.W   -(A7)
       MOVEA.L A7,A1
       MOVEQ   #$01,D1
       BSR.S   L052CE   * read header
       BRA.S   L05296   * failed
       MOVE.B  #$02,D1  * ok
       MOVE.B  D1,(A3)  * set timing (8049)
       MOVEQ   #$08,D0  * wait a little
L05280 DBF     D0,L05280
       MOVE.B  D1,(A3)  * again timing
       MOVE.W  #$01FF,D1
       MOVEA.L $0002(A7),A1 * a1= buffer address
       JSR     (A0)   * do it
       BRA.S   L05296   * error
       ADDQ.L  #2,$0006(A7)
L05296 MOVEQ   #$00,D1
       MOVEQ   #$00,D2
       MOVE.B  $0001(A7),D2
       MOVE.B  (A7)+,D1
       ADDQ.W  #4,A7
       RTS

L052A4 JSR     L05448(PC)   * verify formatted sector / read header
       RTS                  * failed
       MOVE.W  #$0261,D1
       BSR     L05354       * read sector
       RTS                  * failed
       ADDQ.L  #2,(A7)
       RTS

L052B8 MOVE.W  #$0100,D0   * initialise parameters
       MOVE.W  #$0F0F,D3   * d0=counter, d3=checksum
       MOVEQ   #$00,D4
       MOVEQ   #$02,D6
       LEA     $0002(A3),A2   * to read track 1
       LEA     $0003(A3),A4   * to read track 2
       RTS

L052CE BSR     L052B8   * read number of bits - initialise
L052D0 BTST    D6,(A3)
       DBNE    D0,L052D0  * till buffer is empty
       EXG      A4,A4     * !!! WHAT'S THAT ??? !!!
       MOVE.B   (A2),D4
       EXG      A4,A2     * !!! REALLY NECESSARY ?? !!!
       MOVE.B   D4,(A1)+
       ADD.W    D4,D3
       TST.W    D0
       BLT      L05446
       MOVEQ    #$14,D0
       SUBQ.W   #1,D1
L052EA BTST     D6,(A3)   * !!! better: DBNE D0,L052EA (as in JM ROM
       BNE.S      L05338  * but set D0 for better reliability to 28)
L052EE BTST     D6,(A3)   * then omit the following code)!!!
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
       BTST     D6,(A3)
       BNE.S      L05338
o05336 MOVEQ   #-1,D0
L05338 NOP
       NOP              * including this line but: - reset label!
       MOVE.B  (A2),D4
       EXG     A4,A2
       MOVE.B  D4,(A1)+
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
       BGE.S   L052EA   * try evtl second track
       BRA     L053DE

L05354 BSR     L052B8   * verify reading - initialise
L05358 BTST    D6,(A3)
       DBNE    D0,L05358
       EXG     A4,A4
       MOVE.B  (A2),D4
       EXG     A4,A2
       CMP.B   (A1)+,D4
       BNE     L05446
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
L05376 BTST    D6,(A3)   * again wasting ROM space
       BNE.S   L053C4    * !!! replace with dbne d0,L05376 !!!
       BTST    D6,(A3)   * again d0 set to 28
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       BTST    D6,(A3)
       BNE.S   L053C4
       MOVEQ   #-$01,D0
L053C4 NOP
       NOP              * wasting ends here
       MOVE.B  (A2),D4
       EXG     A4,A2
       CMP.B   (A1)+,D4
       BNE.S   L05446
       ADD.W   D4,D3
       TST.W   D0
       BLT     L05446
       MOVEQ   #$14,D0
       SUBQ.W  #1,D1
       BGE.S   L05376
       
L053DE BTST    D6,(A3)  * !!! again as above: dbne d0,L053DE
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       BTST    D6,(A3)
       BNE.S   L0542C
       MOVEQ   #-$01,D0
L0542C NOP
       NOP

L05430 MOVE.B  (A2),D4
       EXG     A4,A2
       ROR.W   #8,D4
       TST.W   D0       * if too long waited
       BLT.S   L05446   * back
       MOVEQ   #$14,D0  * timer
       ADDQ.W  #1,D1
       BEQ.S   L053DE
       CMP.W   D4,D3    * compare checksum
       BNE.S   L05446   * not equal
       ADDQ.L  #2,(A7)
L05446 RTS

L05448 MOVEQ   #$00,D1   * wait for pulsing interrupts
L0544A SUBQ.W  #1,D1     * 0.38 seconds
       BEQ.S   L05476
       BTST    #$03,(A3) * from 8049
       BEQ.S   L0544A
       MOVEQ   #$00,D1
L05456 SUBQ.W  #1,D1     * wait again 0.38 sec
       BEQ.S   L05476
       MOVEQ   #$17,D0
L0545C BTST    #$03,(A3)
       BNE.S   L05456
       DBF     D0,L0545C
       MOVE.B  #$02,D1
       MOVE.B  D1,(A3)
       MOVEQ   #$08,D0
L0546E DBF     D0,L0546E
       MOVE.B  D1,(A3)
       ADDQ.L  #2,(A7)
L05476 RTS

**************************************************
*                                                *
* End MDV_ROUTINES mdv_routines                  *
*                                                *
**************************************************
       
*******
*
* MDV_System MDV_SYS mdv_sys
*
**********


L029FC SF      $0023(A2)   * mdv: motor on
L02A00 MOVEQ   #$00,D1
       MOVE.B  $0014(A2),D1
       LEA     $00EE(A6),A3
       ST      $09(A3,D1.W)
       TST.B   (A3)
       BNE.S   L02A38
       MOVEQ   #$10,D0
       JSR     L00420(PC)
       MOVE.B  D1,(A3)
       MOVE.B  #$FA,$00EF(A6)
       LEA     $00018020,A3
       JSR     L02C56(PC)
       ORI.B   #$20,$0035(A6)
       MOVE.B  $0035(A6),$00018021
L02A38 RTS

L02A3A MOVE.W  $0008(A7),D0  * update server-block mdv
       LSL.W   #2,D0
       ADDQ.W  #1,D0
       MOVEA.L $0058(A6),A1
L02A46 MOVEQ   #-$0F,D1
       AND.B   (A1),D1
       CMP.B   D1,D0
       BNE.S   L02A52
       MOVE.B  #$01,(A1)
L02A52 ADDQ.W  #8,A1
       CMPA.L  $005C(A6),A1
       BLT.S   L02A46
       LEA     $0228(A5),A1
       MOVEQ   #$7F,D0
L02A60 CLR.L   (A1)+
       DBF     D0,L02A60
       RTS

L02A68 TST.B   $0023(A5) * Test sectortype
       BLE.S   L02A9C
       TST.B   $0022(A5)
       BNE.S   L02A9C
       TST.B   D7
       BNE.S   L02A98
       LEA     $0028(A5),A1
       JSR     L0525C  * read sector 0
       BRA.S   L02A98  * error
       LEA     $0008(A7),A1
       LEA     $0016(A5),A2
       MOVE.L  (A1)+,(A2)+
       MOVE.L  (A1)+,(A2)+
       MOVE.L  (A1)+,(A2)+
       BSR.S   L02A3A
L02A94 SF      $0023(A5)
L02A98 BRA     L02B84  * stop motor


L02A9C LEA     $0016(A5),A1 * a1 = $16 of PDB
       TST.B   (A1)
       BEQ.S   L02AB2
       SUBA.L  A0,A0
       MOVEQ   #$0A,D2
       JSR     L039B4(PC)   * append name
       MOVEQ   #-$10,D0
       JSR     L03968(PC)   * UT.ERR
L02AB2 BSR.S   L02A3A       * update server block
       ST      $0023(A5)
       BRA     L02BE2

L02ABC MOVEM.L D0-D6/A0-A4,-(A7)  * interrupt 2 of mdv
       LEA     $00018020,A3
       MOVEQ   #$00,D0
       MOVE.B  $00EE(A6),D0
       BEQ     L02B88
       SUBA.W  #$000E,A7
       MOVEA.L A7,A1
       LEA     $00F0(A6),A5
       SF      $07(A5,D0.W)
       MOVE.B  -$01(A5,D0.W),D0
       MOVE.W  D0,-(A7)
       MOVEA.L $10(A5,D0.W),A5
       MOVE.L  A5,-(A7)
       MOVE.B  $00EF(A6),D2
       BGE.S   L02AF2
       ADDQ.B  #1,D2
L02AF2 JSR     L0523A   * read header
L02AF8 BRA.S   L02A9C   * error
       BRA.S   L02A98   * mistake
       MOVEQ   #$0B,D0
       LEA     $0022(A5),A2
L02B02 MOVE.B  -(A2),D1
       CMP.B   -(A1),D1
       BNE     L02A68
       DBF     D0,L02B02
       TST.B   $0023(A5)
       BGT.S   L02A94
       ADD.W   D7,D7
       BNE.S   L02B24
       ADDQ.B  #1,$0024(A5)
       CMPI.B  #$08,$0024(A5)
       BGT.S   L02AF8
L02B24 ADDA.W  D7,A5
       MOVEQ   #$00,D1
       MOVE.W  $0228(A5),D1
       BEQ     L02BC4
       TST.B   D2
       BLE.S   L02B36
       SF      D2
L02B36 MOVE.B  D2,$00EF(A6)
       TST.W   D1
       BLT     L02C1C
       LSL.L   #3,D1
       MOVEA.L $0058(A6),A4
       ADDA.L  D1,A4
       MOVE.L  A4,-(A7)
       LSL.L   #6,D1
       LEA     $00(A6,D1.L),A1
       BTST    #$02,(A4)
       BNE.S   L02BA6
       BTST    #$01,(A4)
       BNE.S   L02B66
       JSR     L0525C
       BRA.S   L02B82
       BRA.S   L02B6E


L02B66 JSR     L05262
       BRA.S   L02B7E


L02B6E MOVEQ   #$03,D0
       CLR.W   $0228(A5)
       MOVEA.L $0004(A7),A1
       SF      $0024(A1)
       BRA.S   L02BB8

L02B7E MOVEQ   #$07,D0
       BRA.S   L02BB8


L02B82 ADDQ.W  #4,A7
L02B84 ADDA.W  #$0014,A7
L02B88 MOVE.B  $0035(A6),D7
       ORI.B   #$01,D7
       ANDI.B  #$DF,D7
       MOVE.B  D7,$0001(A3)
       MOVE.B  $0035(A6),$0001(A3)
       MOVEM.L (A7)+,D0-D6/A0-A4
       BRA     L003B6


L02BA6 TST.B   D2       * rewrite-block
       BMI.S   L02B82
       MOVE.W  $0028(A5),-(A7)
       JSR     L051B0
       ADDQ.W  #2,A7
       MOVEQ   #$0B,D0
L02BB8 MOVEQ   #-$10,D1
       MOVEA.L (A7)+,A4
       AND.B   (A4),D1
       OR.B    D0,D1
       MOVE.B  D1,(A4)
       MOVEQ   #$05,D2
L02BC4 TST.B   D2
       BMI.S   L02C14
       ADDQ.B  #1,D2
       CMPI.B  #$08,D2
       BLT.S   L02C14
       MOVEQ   #$00,D2
       MOVEQ   #$00,D0
       MOVEA.L (A7),A5
       LEA     $0228(A5),A5
L02BDA TST.W   (A5)+
       BNE.S   L02C14
       ADDQ.B  #1,D0
       BNE.S   L02BDA
L02BE2 JSR     L02C50
       MOVEQ   #$08,D1
       LEA     $00F8(A6),A5
L02BEE TST.B   -$01(A5,D1.W)
       BNE.S   L02C08
       SUBQ.B  #1,D1
       BNE.S   L02BEE
       CLR.B   $00EE(A6)
       ANDI.B  #$DF,$0035(A6) * mdv inactif
       JSR     L00452(PC)     * 8049 - routine
       BRA.S   L02C18

L02C08 MOVE.B  D1,$00EE(A6)   * check for other mdv waiting
       JSR     L02C56
       MOVEQ   #-$06,D2
L02C14 MOVE.B  D2,$00EF(A6)
L02C18 BRA     L02B84


L02C1C LEA     $0028(A5),A1  * do sectorjob -2 = verify -1 = read
       ADDQ.W  #1,D1
       BNE.S   L02C3A
       TST.B   D2
       BMI     L02B84
       MOVE.W  #$8000,-(A7)
       JSR     L051B0
       ADDQ.W  #2,A7
       MOVEQ   #-$02,D1
       BRA.S   L02C48

L02C3A JSR     L05262  * verify sector
       BRA.S   L02C46  * error
       MOVEQ   #$00,D1
       BRA.S   L02C48
L02C46 MOVEQ   #-$01,D1
L02C48 MOVE.W  D1,$0228(A5)
       BRA     L02B84   * 


L02C50 MOVEQ   #$02,D2  * stop mdv-motor
       MOVEQ   #$07,D1
       BRA.S   L02C5A

L02C56 MOVEQ   #$03,D2 * transmit for mdv-motor control
       SUBQ.W  #1,D1
L02C5A MOVE.B  D2,(A3)
       MOVEQ   #$39,D0
       ROR.L   D0,D0
       BCLR    #$01,D2  * 1 = go 0 = stop
       MOVE.B  D2,(A3)
       MOVEQ   #$39,D0
       ROR.L   D0,D0
       MOVEQ   #$02,D2
       DBF     D1,L02C5A
       RTS
*** END MDV_SYS mdv_sys
************************
*
* MGG-KEYBOARD
*
************************

* LOOK FOR COMMENTS IN JS_KEYBOARD_ASM


L0B614  DC.L    $000C008A
  DC.L  $004B00C9
  DC.L  $01080112
  DC.L  $033F7876
  DC.L  $2D6E2C38
  DC.L  $32367165
  DC.L  $30747539
  DC.L  $77690972
  DC.L  $9C7A6F6C
  DC.L  $33683161
  DC.L  $70646A87
  DC.L  $E06B7366
  DC.L  $2367842B
  DC.L  $792E6362
  DC.L  $5C6D800A
  DC.L  $C0D01BC8
  DC.L  $3C20D8F4
  DC.L  $E835ECF0
  DC.L  $F8343703
  DC.L  $3F58565F
  DC.L  $4E3B2822
  DC.L  $2651453D
  DC.L  $54552957
  DC.L  $49FD523F
  DC.L  $5A4F4CB6
  DC.L  $48214150
  DC.L  $444AA7E0
  DC.L  $4B534627
  DC.L  $47A42A59
  DC.L  $3A43425E
  DC.L  $4DA0FEC4
  DC.L  $D47FCC3E
  DC.L  $FCDCF6EA
  DC.L  $25EEF2FA
  DC.L  $242F033F
  DC.L  $18168F0E
  DC.L  $8C7C9296
  DC.L  $11055D14
  DC.L  $155B1709
  DC.L  $09127B19
  DC.L  $0F0C9308
  DC.L  $91011004
  DC.L  $0ABBE20B
  DC.L  $13067D07
  DC.L  $9BBD1A8E
  DC.L  $0302400D
  DC.L  $990AC2D2
  DC.L  $00CA7E00
  DC.L  $DAF5E995
  DC.L  $EDF1F994
  DC.L  $60033FB8
  DC.L  $909FAE97
  DC.L  $8ABCBEB1
  DC.L  $A589B4B5
  DC.L  $88B7A9FD
  DC.L  $B2BFB9AF
  DC.L  $AC83A881
  DC.L  $A1B098AA
  DC.L  $1BE6ABB3
  DC.L  $A68B9D9A
  DC.L  $1DBA9EA3
  DC.L  $A21EAD82
  DC.L  $FEC6D61F
  DC.L  $CE1C00DE
  DC.L  $F7EB85EF
  DC.L  $F3FB8486

* NOW CURSOR-MOVEMENTS
  DC.L  $21E031C0
  DC.L  $32D034C8
  DC.W  $37D8
  
  DC.W $37D8
  DC.W $00FF
  
* IF YOU WANT TO INTEGRATE THE FOLLOWING CODE:
* YOU MUST REMOVE THE LAST WORD $00FF

* DC.L $2D05618E
* DC.L $65916995
* DC.L $6F98759B
* DC.L $310841A0
* DC.L $4FA455A7
* DC.L $6180658F
* DC.L $69926F84
* DC.L $758700FF

****** End KEYBOARD_ASM keyboard_asm

*********************************************************
*                                                       *
*     NET_ROUTINES   net_routines                       *
*                                                       *
*********************************************************       
        
L05478 BTST    #$04,$00A0(A6)
       BNE.S   L0549A
       LEA     $00018020,A3
       LEA     -$001E(A3),A2
       MOVEQ   #$18,D0
       JSR     L00420
       NOP                 * !!! to conform asm - leave it out !!!
       ORI.W   #$0700,SR
       MOVEQ   #$00,D7
       RTS

L0549A ADDQ.W  #4,A7
       MOVEQ   #-$01,D0
       BRA     L055A8

L054A2 MOVEM.L D4-D7,-(A7)
       CLR.W   $001C(A0)
       BSR.S   L05478
L054AC MOVE.W  #$16E2,D4
L054B0 MOVE.W  #$01B5,D0
L054B4 BTST    D7,(A3)
       BEQ.S   L054BE
       DBF     D4,L054B0
       BRA.S   L05532

L054BE DBF     D0,L054B4
       MOVE.W  #$0C34,D0
L054C6 BTST    D7,(A3)
       BNE.S   L054D0
       DBF     D0,L054C6
       BRA.S   L05532

L054D0 MOVE.W  #$00DA,D0
L054D4 DBF     D0,L054D4
       LEA     $0020(A0),A1
       MOVEQ   #$08,D1
       BSR     L055B4
       BLT.S   L054AC
       SUB.B   -(A1),D3
       CMP.B   (A1),D3
       BNE.S   L054AC
       SUBQ.W  #7,A1
       MOVE.W  $0018(A0),D3
       ROR.W   #8,D3
       TST.B   D3
       BEQ.S   L05500
       CMP.B   $0019(A0),D3
       BEQ.S   L05500
       CMP.W   (A1),D3
       BRA.S   L05504

L05500 DC.L   $B6290000   * ½ CMP.B  $0000(A1),D3
* !!! ABOVE INSERTED 'CAUSE ASM COMPILES SHORT (CORRECT) TO:
* CMP.B  (A1),D3 - 2 BYTES LESS AND FASTER - CHANGE IT !!!
L05504 BNE.S   L05532
       MOVE.W  $0002(A1),D6
       SUB.W   $001A(A0),D6
       BNE.S   L05516
       MOVE.L  $0004(A1),$001C(A0)

L05516 BSR     L0563A
       MOVE.B  $001D(A0),D1
       BSR     L055B4
       BNE.S   L05532
       CMP.B   $001E(A0),D3
       BNE.S   L05532
       BSR     L0563A
       TST.W   D6
       BEQ.S   L05592
L05532 CLR.W   $001C(A0)
       BRA.S   L055A0

L05538 MOVEM.L D4-D7,-(A7)
       BSR     L05478
       MOVE.B  $001D(A0),D1
       MOVEQ   #$00,D3
       LEA     $0020(A0),A1
L0554A ADD.B   (A1)+,D3
       SUBQ.B  #1,D1
       BNE.S   L0554A
       MOVE.B  D3,$001E(A0)
       MOVEQ   #$07,D1
       MOVEQ   #$00,D3
       LEA     $0018(A0),A1
L0555C ADD.B   (A1)+,D3
       SUBQ.B  #1,D1
       BNE.S   L0555C
       MOVE.B  D3,(A1)
       SUBQ.W  #7,A1
       BSR     L055F2
       BNE.S   L055A2
       MOVEQ   #$08,D1
       MOVEQ   #$01,D5
L05570 BSR     L05648
       MOVEQ   #$01,D1
       LEA     $001F(A0),A1
       BSR.S   L055B4
       BEQ.S   L05586
       TST.B   $0018(A0)
       BNE.S   L055A0
       MOVEQ   #$01,D3
L05586 SUBQ.B  #1,D3
       BNE.S   L055A0
       MOVE.B  $001D(A0),D1
       DBF     D5,L05570
L05592 ADDQ.B  #1,$001A(A0)
       BCC.S   L0559C
       ADDQ.B  #1,$001B(A0)
L0559C MOVEQ   #$00,D0
       BRA.S   L055A2

L055A0 MOVEQ   #-$01,D0
L055A2 JSR     L00452
       NOP                * !!! to conform asm - leave it out !!!
L055A8 ANDI.W  #$F8FF,SR
       MOVEM.L (A7)+,D4-D7
       TST.L   D0
       RTS

L055B4 MOVE.W  #$018F,D0
       MOVEQ   #$00,D3
L055BA BTST    D7,(A3)
       BEQ.S   L055C0
       BRA.S   L055C6

L055C0 DBF     D0,L055BA
       BRA.S   L055EE

L055C6 MOVEQ   #$46,D0
L055C8 BTST    D7,(A3)
       DBEQ    D4,L055C8
       BNE.S   L055EE
       MOVEQ   #$07,D4
       MOVEQ   #$13,D0
L055D4 ROR.B   D0,D7
       MOVE.B  (A3),D0
       ROXR.B  #1,D0
       ROXR.B  #1,D2
       MOVEQ   #$06,D0
       DBF     D4,L055D4
       MOVE.B  D2,(A1)+
       ADD.B   D2,D3
       SUBQ.B  #1,D1
       BNE.S   L055C6
L055EA MOVEQ   #$00,D0
       RTS

L055EE MOVEQ   #-$01,D0
       RTS

L055F2 MOVEQ   #$73,D0
       MULU    $002E(A6),D0
       MOVE.W  D0,$002E(A6)
       EXT.W   D0
       ADDI.W  #$0297,D0
L05602 BTST    D7,(A3)
       BNE.S   L055EE
       DBF     D0,L05602
       MOVE.B  $0019(A0),D4
       NOT.B   D4
       MOVE.B  $00A0(A6),D2
       MOVEQ   #$09,D1
L05616 LSL.B   #1,D4
       ROL.B   #1,D2
       ROXR.B  #1,D2
       MOVE.B  D2,(A2)
       BMI.S   L0562E
       MOVEQ   #$05,D0
L05622 BTST    D7,(A3)
       BEQ.S   L05628
       BRA.S   L055EE

L05628 DBF     D0,L05622
       BRA.S   L05634

L0562E MOVEQ   #$10,D0
L05630 DBF     D0,L05630
L05634 DBF     D1,L05616
L05638 BRA.S   L055EA

L0563A TST.B   $0018(A0)
       BEQ.S   L055EA
       MOVEQ   #$01,D1
       MOVE.W  #$FF01,D4
       BRA.S   L0564C

L05648 MOVEQ   #-$01,D4
L0564A MOVE.B  (A1)+,D4
L0564C LSL.W   #1,D4
       ROL.W   #2,D4
       MOVEQ   #$0C,D3
       MOVE.B  $00A0(A6),D0
L05656 ASR.W   #1,D4
       ROL.B   #1,D0
       ROXR.B  #1,D0
       MOVEQ   #$00,D7
       MOVE.B  D0,(A2)
       SUBQ.W  #1,D3
       BGE.S   L05656
       SUBQ.B  #1,D1
       BNE.S   L0564A
       MOVE.B  $00A0(A6),(A2)
       BRA.S   L05638

****** END NET_ROUTINES net_routines

***************
*
*     SYS_MESS sys_mess
*
***************

L0B71C  DC.L $4AFB003C
        DC.W $004C
        DC.W    $005A
        DC.W $006A
        DC.W $007A
        DC.W    $0088
        DC.W    $009C
        DC.W    $00A8
        DC.W    $00BA
        DC.W    $00C4
        DC.W    $00D2
        DC.W $00E0
        DC.W    $00EC
        DC.W    $00FA
        DC.W    $010A
        DC.W    $011A
        DC.W    $0132
        DC.W    $0148
        DC.W    $0154
        DC.W $0166
        DC.W    $0172
        DC.W    $017E
        DC.W    $0188
        DC.W    $0194
        DC.W    $01AC
        DC.W    $01CC
        DC.W    $01E6
        DC.W    $01F8
        DC.W    $020E
        DC.W $000D
        DC.B 'not complete'
        DC.W $0A00
        DC.W $000C 
        DC.B 'invalid Job'
        DC.B $0A
        dc.w $000E 
        DC.B 'out of memory'
        DC.B $0A
        DC.W $000D 
        DC.B 'out of range'
        dc.w $0A00
        DC.W $000C 
        dc.b 'buffer full'
        DC.B $0a
L0B7A4  dc.w $0011 
        dc.b 'channel not open'
        dc.w $0a00
        dc.w $000A 
        dc.b 'not found'
        dc.b $0a
        dc.w $000F 
        dc.b 'already exists'
        dc.w $0A00 
        dc.w $0007 
        dc.b 'in use'
        dc.w $0A00
        dc.w $000c        
        dc.b 'end of file'
        dc.b $0a
        dc.w $000B
        dc.b 'drive full'
        dc.w $0a00
        dc.w $0009
        dc.b 'bad name'
        dc.w $0a00
        dc.w $000b
        dc.b 'Xmit error'
        dc.w $0A00
        dc.w $000E 
        dc.b 'format failed'
        dc.b $0a
        dc.w $000E 
        dc.b 'bad parameter'
        dc.b $0a
        dc.w $0016 
        dc.b 'bad or changed medium'
        dc.b $0a
        dc.w $0014
        dc.b 'error in expression'
        dc.b $0a
L0B864   dc.w $0009
        dc.b 'overflow'
        dc.w $0a00
        dc.w $0010
        dc.b 'not implemented'
        dc.b $0a
        dc.w $000a
        dc.b 'read only'
        dc.b $0a
        dc.w $0009
        dc.b 'bad line'
        dc.w $0A00
        dc.w $0008
        dc.b 'At line '
        dc.w $0009
        dc.b ' sectors'
        dc.w $0a00
        dc.w $0015
ob8b0   dc.b 'F1...monitor'
        dc.b $0a
        dc.b 'F2...TV'
        dc.w $0A00
        dc.w $001E
        dc.b '  1983 Sinclair Research Ltd '
        dc.w $0017
        dc.b 'during WHEN processing'
        dc.w $0a00
        dc.w $0010
        dc.b 'PROC/FN cleared'
        dc.b $0a
oB914   dc.b 'SunMonTueWedThuFriSat'
        dc.b $00
        Dc.b 'JanFebMarAprMayJunJulAugSepOctNovDez'

***** END SYS_MESS  sys_mess
*                   JS - DISASSEMBLY
*
* ---------------------------------------------------------------
* THIS VERSION CONTAINS IN BASIC3_ASM CORRECTIONS THAT HAVE BEEN
* NECESSARY - SORRY I SELDOM USE BASIC, THAT'S WHY I DID NOT NOTICE
* THE BUGS - LOCATION: L08B2A  L0932E  L08DAA
* ALL CORRECTIONS ARE MARKED WITH !!! CORRECTED
*
* SOME ADDITIONAL COMMENTS HAVE BEEN MADE - YET THERE'S FEW
* OF THEM!!
* I hope that this disassembly is correct - if you find any faults:
* Drop me a line. 
* BY INTENSIVE TESTING OF OWN CODE I COULD FIND NO BUG -
* BUT OF COURSE IT'S IMPOSSIBLE TO TEST ANY CONFIGURATION
* THOUGH THERE MIGHT BE SOMEWHERE A WRONG DEFINITION THAT WILL
* BE NOTICED ONLY, IF YOU HAPPEN TO INSERT JUST THERE SOME CODE.
* IN FACT, I'M QUITE SURE THAT NOW EVERYTHING IS WORKING IN ANY 
* CONIGURATION IF YOU KEEP IN MIND THAT SOME CODE RETURNS WITH
* MANIPLUATED STACK - SEE ADDER ON MDV-VECTORS: THERE ARE THREE
* POSSIBLE REUTRNS SOMETIMES.
* Don't write to me with 'just one question' on details.
* I think the disassembly is enough work.
*
* The disassembly is poorly commented - but those who will be
* working with it, know what they are doing anyhow!
*
*                   IMPORTANT
*
* The disassembly is for private use only.
* Any commercial usage is  N O T  allowed.
* QDOS is copyright by SINCLAIR / ARMSTRAD!!!!
*
* Even TONY TEBBY was not allowed to use his QDOS on his
* FUTURA project. He had to rewrite QDOS!
*
* It is evident, that nobody else may use QDOS commercial when even
* he was not entitled to use it.
*
* I was offered to use this disassembly comercial. 
*                I refused to do so.
* 
* Only fools (!!) will try to market any part of this disassembly.
*
* ---------------------------------------------------------------------
* ---------------------------------------------------------------------
*            How to use this disassembly
*
* LOOK and learn from it - you own programming technique might profit.
*
* Don't write progs that access direct the ROM.
*
* Use the defined TRAPS and VECTORS.
*
* If you want to change things ½ hope that you know what you are doing
* 
* REASSEMBLY ONLY WITH GST MACRO ASSEMBLER POSSIBLE
* Minimum configuration: 256 K memory expansion + diskdrive
*
* USE OPTION -NOLIST OR YOU WILL RUN OUT OF DISKSPACE
* 
* ESSENTIAL FOR UNDERSTANDING: ADDER "QL ADVANCED USER GUIDE"
* REFFERENCES TO THIS BOOK IN MY COMMENTS AS ½Adder 
* ---------------------------------------------------------------
* 
* Please note: all values that I've been redifinig for use as Labels
* have significant names: XL-labels are labels that are defined by
* using an EQU somewhere in the Prog.
* Tr -labels are labels for TRAPS e.g. 
* Tr1d03 is label of Trap 1 with d0=3
* Tr3d12 is label of Trap 3 with d0=$12
* labels that start with 'o' have been installed for 
* my own use during the disassembly-work
* any critical comments are marked with '!!'
* any doubts - yes there are some - are marked with '?'
*
* SOME comments might be silly - but have been of any value for
* me when I did the disassembly. I don't want to put them out
* you can enjoy them or erase them as you like.
*
* FOR TESTING PURPOSES I'VE ADDED SOME 'NOP' TO PREVENT THAT
* THE GST-MACRO ASSEMBLER PRODUCES SHORTER CODE - MOST NOP's MIGHT
* BE OMITTED - DO IT YOURSELF - But: Control it thoroughfully:
* Especially in BASIC and MDV-routines returns form subroutines
* manipulate the Stack(a7). Changing code could mean that
* the adress for Return was wrong.
* 
* YOU WILL FIND INCLUDED EVEN KEYBOARD_ASM FOR MGG VERSION
* THE JM_MDV_ROUTINES MIGHT NEED SOME MODIFICATIONS
* IT'S JUST AN ATTEMPT TO REPLACE THE UNNECESSARY LONG JS-
* ROUTINES.
* BUT: THE JM-ROUTINES MIGHT HAVE A BUG. SO TRY IT WITH
* CAUTION. 
* ON TRA_TAB: SINCE I WORK ON MY QL WITH EPROMS AND LOST MY ORIGINAL
* JS-FILE IT MIGHT BE WORTH, ADAPTING THAT PIECE OF BYTES EXACTLS
* TO YOUR PRINTER. AS IT IS, IT WORKS PERFECTLY WELL WITH THE 
* BROTHER EP 44 PRINTER IN T/W MODE - AT LEAST WITH THE VERSION THAT
* HAS BEEN DELIVERED IN SWITZERLAND.
* 
* 
* MY ADRESS:
*             WOLFGANG GOELLER
*             ROSENSTR. 21
*             CH 8105 REGENSDORF
*             SWITZERLAND
*

       org     $00
       NOLIST
       DC.L    $00030000  * RESET supervisor-stack
       DC.W    $0000
       dc.W    XL0016A    * RESET prog - start
       DC.W    $0000
       DC.W    XL0005C    * bus error
       DC.L    $00000028  * adress - error
       DC.L    $0000002A  * ilegal instruction
       DC.L    $0000002C  * divison by zero
       DC.L    $0000002E  * CHK-instruction
       DC.L    $00000030  * TRAPV
       DC.L    $00000032  * privilege violation
       DC.L    $00000034  * trace
o028   BSR.S   L00050     * 1010-  trap * dc.l $61266124
o02a   BSR.S   L00050
o02c   BSR.S   L00050     * 1111-  trap * dc.l $61226120
o02e   BSR.S   L00050
o030   BSR.S   L00050
o032   BSR.S   L00050
o034   BSR.S   L00050
o036   BSR.S   L00050
0o38   BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       BSR.S   L00050
       DC.W    $0000
L00050 BRA     L0013C           * Test Interrupt
L00054 SUBI.L  #$0000002A,(A7)+ * suppress Backaddr
       BNE.S   L0005E           * erroradress 
L0005C ADDQ.W  #8,A7            * yes: restore backaddr. 

XL0005C EQU L0005C

L0005E RTE
oo60    DC.L    L0005E          * 
oo64    DC.L    L0005E          *  interrupt L1
oo68    DC.L    XL00352         *            L2
oo6C    DC.L    L0005E
oo70    DC.L    L0005E
oo74    DC.L    L0005E
oo78    DC.L    L0005E
oo7c    DC.L    $00000036       *  ...       L7
oo80    DC.L    XLTRAP0
oo84    DC.L    XLTRAP1
oo88    DC.L    XLTRAP2
oo8C    DC.L    XLTRAP3
oo90    DC.L    XLTRAP4
        DC.L    $00000038  * vectors for Trap 5 - 15
oo98    DC.L    $0000003A
oo9C    DC.L    $0000003C
ooA0    DC.L    $0000003E
ooA4    DC.L    $00000040
ooA8    DC.L    $00000042
ooAC    DC.L    $00000044
ooB0    DC.L    $00000046
ooB4    DC.L    $00000048
L000B8 DC.L    $0000004A
       DC.L    $0000004C
ooC0   DC.W    L02FAE   * MM.ALCHP
       DC.W    L0305E   * MM.RECHP
ooC4   DC.W    L039F2   * UT.WINDW
       DC.W    L039F6   * UT.CON
ooC8   DC.W    L039FC   * UT.SCR
       DC.W    L0395E   * UT.ERR0
ooCC   DC.W    L03968   * UT.ERR
       DC.W    L03990   * UT.MINT
ooD0   DC.W    L039B2   * UT.MTEXT
       DC.W    L039DC   * UT.LINK
ooD4   DC.W    L039E2   * UT.UNLNK
       DC.W    $0000
oD8    DC.W    L03104   * MM.ALLOC
       DC.W    L03162   * MM.LINKFR
oDC    DC.W    L037F4   * IO.QSET
       DC.W    L0380A   * IO.QTEST
oE0    DC.W    L03838   * IO.QIN
       DC.W    L0385E   * IO.QOUT
oE4    DC.W    L03888   * IO.QEOF
       DC.W    L03A9C   * UT.CSTR
oE8    DC.W    L037CC   * IO.SERQ
       DC.W    L0388C   * IO.SERIO
oEC    DC.W    L0405E   * CN.DATE
       DC.W    L040BE   * CN.DAY
oF0    DC.W    L03EF6   * CN.FTOD
       DC.W    L03E54   * CN.ITOD
L000F4 DC.W    L03EDC   * CN.ITOBB
       DC.W    L03ED8   * CN.ITOBW
       DC.W    L03ED4   * CN.ITOBL
       DC.W    L03EB0   * CN.ITOHB
L000FC DC.W    L03EAC   * CN.ITOHW
       DC.W    L03EA8   * CN.ITOHL
o00100 DC.W    L03D16   * CN.DTOF
       DC.W    L03DC2   * CN.DTOI
o104   DC.W    L03E34   * CN.BTOIB
       DC.W    L03E38   * CN.BTOIW
o108   DC.W    L03E3C   * CN.BTOIL
       DC.W    L03DD4   * CN.HTOIB
o10c   DC.W    L03DD8   * CN.HTOIW
       DC.W    L03DDC   * CN.HTOIL
o110   DC.W    L06DA6   * BP.INIT
       DC.W    L061DA   * CA.GTINT
       DC.W    L061DE   * CA.GTFP
       DC.W    L061D6   * CA.GTSTR
       DC.W    L061E2   * CA.GTLIN
       DC.W    L04E4E   * BV.CHRIX
       DC.W    L041AC   * RI.EXEC
       DC.W    L041B4   * RI.EXECB
       DC.W    L072C2   * BP.LET
o00122 DC.W    L0372C   * IO.DECODE
* from now on: add $4000 to get the correct adress 
* refer to Adder ½ vectors 124 ff

o00124 DC.W    XL0125C   * MD.READ  - 525C
       DC.W    XL011B0   * MD.WRITE - 51B0
       DC.W    XL01262   * MD.VERIN - 5262
       DC.W    XL0123A   * MD.SECTR - 523A
       DC.W    XL047D4   * BASIC SYNTAX ANALYSER               - 87D4
       DC.W    XL04B5A   * FIRST SYNTAX TABLE - COMMANDS       - 8B5A
* next adress is odd!! don't mistrust - it is really odd !!!
       DC.W    XL04CE7   * SECOND SYNTAX TABLE - EXPRESSIONS   - 8CE7
       DC.W    XL04AB4   * FORMAT PRECOMPILED BASIC LINE       - 8AB4
       DC.W    XL04A4E   * ERROR WHEN COMPILING                - 8A4E
       DC.W    XL04E88   * STORE PRECOMPILE LINE               - 8E88
       DC.W    XL03518   * CONVERT PRECOMPILED BASIC TO ASCII  - 7518
       DC.W    XL0490C   * INITIALISE BASIC STACKS             - 890C
       
L0013C TST.L   $00028050   * Test for redirection
       BEQ     L00054      * no
       MOVE.L  A6,-(A7)    * a6 on stack
       MOVEA.W $0006(A7),A6  *  
       ADDA.W  A6,A6
       ADDA.L  $00028050,A6  * a6 pointer to redirect-routine
       MOVE.L  (A6),$0004(A7) 
       MOVEA.L (A7)+,A6      * restore a6
       RTS

Ramerror 
L0015C MOVEA.L A3,A5        * endless loop
L0015E MOVE.W  D7,(A5)+
       CMPA.L  #$00028000,A5
       BNE.S   L0015E
       BRA.S   L0015C

* start QL init/reset
L0016A MOVEA.L #$00040000,A1     * Ramtest
XL0016A EQU L0016A
       MOVEA.L A1,A4
L00172 MOVE.L  A4,(A4)
       CMPA.L  (A4),A4
       BNE.S   L00184            * till A1 = A4 = ramtop + 1
       CMPA.L  (A1),A1
       BNE.S   L00184
       ADDA.L  #$00010000,A4
       BRA.S   L00172

L00184 MOVEQ   #$00,D0   * first writing value
       MOVEQ   #-$01,D1   * second value
       MOVEQ   #-$01,D7   * first colour (white)
L0018A LEA     $00020000,A3  * screenmemory
       MOVEA.L A3,A5
       MOVEA.L D0,A1
       LEA     $1FE4(A1),A2
       SF      -$7F9D(A3)    * initialise sv.jbmax
L0019C CMPA.L  A1,A2
       BNE.S   L001A2        * test whole memory
       MOVEA.L D0,A1

* the ramtes is performed by pokeinig different values in RAM
* and afterwars testing, whether they are still present.
* Sine this is done very fast, only very bad RAM could be detected.
* IBM-compatibles test only for one value
* the questione remains unanswered : what's the use of all this
* shorttime tests. Better: a separate Ram-test prog that tests
* thoroughfully.
* You could as well live without this shorttest.
* The only part of RAM, that should be set to 0 when booting are the 
* systemvariables.
*
L001A2 MOVE.L  (A1)+,D2
       TST.B   D7          * second time only with one value
       BEQ.S   L001C2
       MOVE.L  D0,(A5)     * pokeing
       CMP.L   (A5),D0     * peeking
       BNE.S   L0015C      * Ramerror
       MOVE.L  D1,(A5)
       CMP.L   (A5),D1
       BNE.S   L0015C      * Ramerror
       MOVE.L  D2,(A5)
       CMP.L   (A5)+,D2
       BNE.S   L0015C      * Ramerror
       CMPA.L  A5,A4
       BNE.S   L0019C
       LSL.W   #8,D7
       BRA.S   L0018A

L001C2 CMP.L   (A5),D2
       BNE.S   L0015C      * Ramerror
       CLR.L   (A5)+
       CMPA.L  A4,A5
       BNE.S   L0019C
       MOVE.L  #XL04A74,A1  * Startadress of BASIC
       LEA     $00028000,A6 * Startadress of sysvars
       LEA     $0480(A6),A7 * top of suerivsor-stack
       LEA     $00018020,A3   * statusregister of 8049
       MOVE.B  #$08,$0043(A3) * initialise 8049 to mode 8
       SF      -$001E(A3)
       MOVE.L  #$061F0000,(A3)  * initialise MDV
       MOVE.B  #$1F,$0001(A3)
       MOVE.B  #$01,-$001D(A3)
       MOVE.B  #$C0,$0035(A6)
       JSR     L02C50(PC)       * stop mdv-motor
       MOVE.W  #$D254,(A6)      * mark start of RAM
       MOVE.L  A5,$0020(A6)     * A5=Ramtop
       SUBA.L  #$00000000,A5    * !!! this makes hardly a sense
* might be, that there was a change intended to have different
* values for ramtop and base of resident procs
       MOVE.L  A5,$001C(A6)     * base of resident procs
       MOVE.L  A5,$0014(A6)     * base of transient procs
       MOVE.L  $0020(A6),D0     * !!! look for previous comment !!
* as the ROM is now A5 still is the same as 20(A6) but if value
* of A5 would have been changed this was correct.
       SUB.L   A6,D0            * ramtop-$2800 /64
       LSR.L   #6,D0
       MOVEA.L A7,A3            * A3 = pointer ro supervisor stack
       LEA     $0054(A6),A4     * A4 = SV.BPNT
       BSR.S   L00250           * initialise table of slave-blocks
       LSR.L   #1,D0
       ADD.L   D0,$0054(A6)
       LSR.L   #2,D0            * D0 now ramtop-$2800/512
       ADDI.L  #$20,D0
       CMPI.W  #$01E0,D0        * compare wit 480
       BLS.S   L00246           * if less - use that value
       MOVE.W  #$01E0,D0        * if more: use only 480 (=$1E0)
L00246 BSR.S   L00250           * init job table
       MULU    #$0003,D0        * initalise table of channels
       BSR.S   L00250
       BRA.S   L0025C

L00250 MOVE.L  A3,(A4)+         * initialising-routine
       MOVE.L  A3,(A4)+
       ADDA.W  D0,A3
       MOVE.L  A3,(A4)+
       ADDQ.W  #4,A4
       RTS

L0025C MOVE.L  A3,D0    * init system variables
       SUB.L   A6,D0
       LSR.L   #6,D0
       MOVEA.L D0,A4
       ADDA.L  A7,A4
       MOVEA.L $005C(A6),A3  * A3 = pointer to top of slave-blocks
       MOVE.W  #$0200,D1   * !!! the shortform of this two commands:
       LSR.W   #6,D1     * !!! MOVE.W #8,D1 - since I don't know
* another part in ROM calling this routine MOVEQ #8,D1 was better
       SUBA.W  D1,A3     * !!! best: SUBQ.W #8,A3 / A3 = SV.BTPNT
       MOVEQ   #$01,D0
L00274 MOVE.B  D0,(A4)   * PLACE 0100 0000 0000 0000 in all
       ADDQ.W  #8,A4     * slaveblock tables
       CMPA.L  A3,A4
       BLT.S   L00274
       MOVEA.L $0068(A6),A4  * SV.JBBAS base of Job table
       MOVEA.L $007C(A6),A3  * SV.JBTOP
       MOVEQ   #-$01,D0
L00286 MOVE.B  D0,(A4)       * place FF00 0000 0000 0000 in all
       ADDQ.W  #4,A4         * job and channel tables
       CMPA.L  A3,A4
       BLT.S   L00286
       MOVE.L  A3,$0004(A6)  * SV.CHEAP
       MOVE.L  A3,$000C(A6)  * SV.FREE
       MOVEA.L $001C(A6),A4  * SV.RESPR
       LEA     -$0200(A4),A4 * ADRESS IF RAMTOP-512
       MOVE.L  A4,$0010(A6)  * BASE OF BASIC STACK
       LEA     L02CF8(PC),A5 * start of polled task
       MOVE.L  A5,$003C(A6)  * SV.PLIST
       LEA     L01202(PC),A5
       MOVE.L  A5,$0040(A6)  * SV.SHLIST
       LEA     L00AC0(PC),A5 * pointer to device drivers
       MOVE.L  A5,$0044(A6)
       
       LEA     L01230(PC),A5 * !!! pointer to dir drivers must be
       MOVE.L  A5,$0048(A6)  * omitted or changed when removing MDVs !!
       
       ADDQ.B  #1,$0037(A6)  * network station nr. default 1
       ADDQ.B  #8,$0034(A6)  * mode 8
       ADDQ.B  #1,$00A0(A6)  * ULA TRANSMIT MODE
       ADDQ.W  #1,$00A8(A6)  * SV.TIMVOV baud rate=9600
       MOVE.W  #$001E,$008C(A6)  * autorepeat delay
       ADDQ.W  #2,$008E(A6)  * autorepeat frequency
       ADDQ.W  #3,$0092(A6)  * 
       MOVE.L  $BFE6,$014A(A6)   * BOOT-MESS ETC.
       MOVE.L  $BFE2,$0146(A6)   * TRA-TABELLE
       MOVEA.L $0068(A6),A4  * SV.JBBAS
       MOVE.L  A4,$0064(A6)  * SV.JBPNT
       MOVEA.L $0014(A6),A3  * SV.TRNSP
       CLR.L   -(A3)         * RAMTOP = 0
       MOVEA.L $0010(A6),A0  * SV.BASIC
       MOVE.L  A0,(A4)       * ADRESS OF JOB 0: BASIC
       MOVE.B  #$20,$0013(A0)  * jobs priority increment
       MOVE.L  A3,USP        * pointer of userstack=ramtop-4
       LEA     $0068(A0),A6  * SV.JBBAS 
       MOVEA.L A3,A5 
       SUBA.L  A6,A5         * a5 = zone for basic
       MOVE.W  #$0000,SR     * now user-mode
       JMP     (A1)          * A1 = XL04A74=BASIC-START
*                              find init roms, display F1/F2, do basic

LTRAP0 ADDQ.W  #2,A7         * decrement user stack
       RTS
       
XLTRAP0 EQU LTRAP0
LTRAP1 BSR.S   L00336      * initialise A5 and A6
       BRA     L00460      * Trap 1 continues
XLTRAP1 EQU LTRAP1
LTRAP2 BSR.S   L00336      * initialise A5 and A6
       BRA     L032A2      * Trap2 continues
XLTRAP2 EQU LTRAP2        
LTRAP3 BSR.S   L00336      * initialise A5 and A6
       BRA     L0337C      * Trap3 continues
XLTRAP3 EQU LTRAP3 
LTRAP4 BSR.S   L00336      * initialise A5 and A6
       BRA     L03432      * Trap4 continues
XLTRAP4 EQU LTRAP4

L00336 SUBQ.W  #8,A7       * initialise of A5 and A6
       MOVE.L  $0008(A7),-(A7)
       MOVEM.L D7/A5-A6,$0004(A7)
       MOVEA.L #$00028000,A6
       LEA     $0004(A7),A5
       MOVEQ   #$7F,D7
       AND.L   D7,D0
       RTS

L00352 MOVEM.L D7/A5-A6,-(A7)       *#: ext2int entry
XL00352 EQU L00352
       MOVEA.L A7,A5
       MOVEA.L #$00028000,A6
       MOVE.B  $00018021,D7
       LSR.B   #1,D7
       BCS     L02ABC
       LSR.B   #1,D7
       BCS     L02CCC               * 8049 interrupt
       LSR.B   #1,D7
       BCS     L02CD8
       LSR.B   #1,D7
       BCS     L00900               * do poll loop
       LSR.B   #1,D7
       BCC.S   L003A0
       MOVEM.L D0-D6/A0-A4,-(A7)
       MOVEQ   #$00,D0
       MOVEA.L $0038(A6),A0        * interrupt list
       JSR     L00A9E(PC)          * execute interrupt tasks
       MOVE.B  $0035(A6),D7
       ORI.B   #$10,D7
       MOVE.B  D7,$00018021
       MOVEM.L (A7)+,D0-D6/A0-A4
L003A0 BRA     L003B6              * rte

*#: ret from syscall, clear d0
L003A4 MOVEQ   #$00,D0
*#: ret from syscall
L003A6 BTST    #$05,$000C(A7)  * was it supervisor-mode?
       BNE.S   L003B6
       TST.W   $0030(A6)       * time for a scheduler rerun?
       BNE     L00936
L003B6 MOVEM.L (A7)+,D7/A5-A6
       RTE
       
* returns bas addr. of JOB in A0
*#: D1 jobid(-1)<>A0 base, D1 jobid
L003BC TST.W   D1           * test D1 Job's ID
       BGE.S   L003D8 
       MOVE.L  $0064(A6),D1  * SV.JBPNT
       MOVEA.L D1,A0
       MOVEA.L (A0),A0       * start adress
       SUB.L   $0068(A6),D1  * SV.JBBAS
       LSR.L   #2,D1
       SWAP    D1
       MOVE.W  $0010(A0),D1  * TAG for JOB
       SWAP    D1
L003D6 RTS

L003D8 BSR.S   L003E4  * is valid job?
       BEQ.S   L003D6
       MOVEQ   #-$02,D0  * invalid job
       ADDQ.W  #4,A7
       BRA.L   L003A6  * return

* D1= jobid
* returns JOB.BASE in a0, ^Z flag if fails
L003E4 CMP.W   $0062(A6),D1   * SV.JBMAX
       BHI.S   L003D6
       MOVEA.W D1,A0
       ADDA.W  A0,A0
       ADDA.W  A0,A0
       ADDA.L  $0068(A6),A0  * SV.JBBAS
       TST.B   (A0)
       BLT.S   L003D6
       MOVEA.L (A0),A0
       SWAP    D1
       CMP.W   $0010(A0),D1    * TAG for JOB
       BNE.S   L003D6
       SWAP    D1
       CMP.B   D1,D1
       RTS

* returns ID of CURRENT JOB in in D0
*         base adress in A3
*#: > D0= currjob_id, A3= currjob base
L00408 MOVEA.L $0064(A6),A3  * pointer to current job
       MOVE.L  A3,D0
       SUB.L   $0068(A6),D0  * SV.JBBAS
       LSR.W   #2,D0
       MOVEA.L (A3),A3
       SWAP    D0
       MOVE.W  $0010(A3),D0
       SWAP    D0
       RTS

* initialise transmission through 8049

L00420 MOVE.B  D0,-(A7)
L00422 SUBQ.W  #1,$00A6(A6) * timeout for switching
       BLT.S   L00432
       MOVE.W  #$208B,D0
L0042C DBF     D0,L0042C
       BRA.S   L00422

L00432 CLR.W   $00A6(A6)      * reset timeout
       ANDI.B  #$E7,$00A0(A6)
       MOVE.B  (A7)+,D0
       OR.B    D0,$00A0(A6)
       ANDI.B  #$7F,$0035(A6)
L00448 MOVE.B  $00A0(A6),$00018002
       RTS

* stop transmission through 8049

L00452 BCLR    #$04,$00A0(A6)
       ORI.B   #$80,$0035(A6)
       BRA.S   L00448


* trap 1  jump according to D0

L00460 CMPI.W  #$0024,D0
       BHI.S   L004BC
       MOVE.W  D0,D7
       ADD.W   D7,D7
       MOVE.W  L00472(PC,D7.W),D7
       JMP     ADUMMY(PC,D7.W)
       
L00472        
ADUMMY EQU L00472-$12
       
       DC.W    XLtr1d00-L00460
       DC.W    XLtr1d01-L00460
       DC.W    XLtr1d02-L00460
o78    DC.W    XLtr1d03-L00460
       DC.W    XLtr1d04-L00460
o7c    DC.W    XLtr1d05-L00460
o7e    DC.W    XLtr1d06-L00460
o80    DC.W    XLtr1d07-L00460
       DC.W    XLtr1d08-L00460
       DC.W    XLtr1d09-L00460
       DC.W    XLtr1d0a-L00460
       DC.W    XLtr1d0b-L00460
o8A    DC.W    XLtr1d0c-L00460
       DC.W    XLtr1d0d-L00460
       DC.W    XLtr1d0e-L00460
o90    DC.W    XLtr1d0f-L00460
       DC.W    XLtr1d10-L00460
       DC.W    XLtr1d11-L00460
       DC.W    XLtr1d12-L00460
       DC.W    XLtr1d13-L00460
       DC.W    XLtr1d14-L00460
       DC.W    XLtr1d15-L00460
oA0    DC.W    XLtr1d16-L00460
       DC.W    XLtr1d17-L00460
       DC.W    XLtr1d18-L00460
       DC.W    XLtr1d19-L00460
       DC.W    XLtr1d1a-L00460
       DC.W    XLtr1d1b-L00460
       DC.W    XLtr1d1c-L00460
       DC.W    XLtr1d1d-L00460
       DC.W    XLtr1d1e-L00460
       DC.W    XLtr1d1f-L00460
       DC.W    XLtr1d20-L00460
       DC.W    XLtr1d21-L00460
       DC.W    XLtr1d22-L00460
       DC.W    XLtr1d23-L00460
       DC.W    XLtr1d24-L00460

* If D0=3 or >$25   bad parameter
TR1d03
L004BC MOVEQ   #-$0F,D0
       BRA     L003A6
XLtr1d03  EQU TR1d03

* Info on QDOS
TR1d00
XLtr1d00 EQU TR1d00
o4C2   MOVEQ   #-$01,D1   * get Job-ID
       JSR     L003BC(PC)
       MOVE.L  $BFF6,D2   * D2 = Nr. of version
       MOVEA.L A6,A0
       BRA     L003A4

* Install new table of error messages or tra table
* D2 = adress of error messages or 0
* D1 = adress of tra-table or 0,1
TR1d24
XLtr1d24  EQU TR1d24
o4D4   TST.L   D2
L004D6 BEQ.S   L004EA       * no new message table
       BTST    #$00,D2      * test odd adress
       BNE.S   L0051E       * bad parameter
       MOVEA.L D2,A0
       CMPI.W  #$4AFB,(A0)  * starts with identifier
       BNE.S   L0051E       * errorend
       MOVE.L  A0,$014A(A6) * set new adress
L004EA CLR.B   $0144(A6)    * 
       TST.L   D1           * new tra-table ?
       BEQ.S   L00518       * no: end
       CMPI.L  #$0001,D1    * is it TRA 1
       BNE.S   L00500       * take adress from BFE2       
       MOVE.L  $BFE2,D1     * ADRESSE VON TRA-TABELLE
L00500 BTST    #$00,D1      * odd adress?
       BNE.S   L0051E
       MOVEA.L D1,A0
       CMPI.W  #$4AFB,(A0)  * starts with identifier
       BNE.S   L0051E        * errorend
       MOVE.B  #$01,$0144(A6) * set 
       MOVE.L  A0,$0146(A6)
L00518 MOVEQ   #$00,D0
       BRA     L003A6

L0051E MOVEQ   #-$0F,D0     * bad parameter
       BRA     L003A6

* info on JOB
TR1d02
XLtr1d02  EQU TR1d02
o524   JSR     L003BC(PC) * returns in d1 JOB-ID in a0 addr
       MOVEQ   #$00,D3
       TST.W   $0014(A0)  * JOB status
       BEQ.S   L00532
       MOVEQ   #-$01,D3
L00532 MOVE.B  $0013(A0),D3  * jobs priority increment
       MOVE.L  D2,D0
       MOVE.L  A0,-(A7)
       JSR     L006C6(PC)
       MOVEA.L (A7)+,A0
       MOVE.L  $0008(A0),D2  * owner of job
       LEA     $0068(A0),A0  * prog-start of job
       BRA     L003A4

* create new job
* mt.cjob
TR1d01
XLtr1d01 EQU TR1d01
o54C   TST.L   D1          * identifier<>0
       BEQ.S   L00554
       JSR     L003BC(PC)  * get a0 base
L00554 MOVEM.L D1-D3/A1-A4,-(A7)
       MOVEQ   #$00,D7
       MOVEA.L $0068(A6),A4  * SV.JBBAS
L0055E TST.B   (A4)        * free entry ?
       BLT.S   L00570      * initalise
       ADDQ.W  #1,D7
       ADDQ.W  #4,A4       * next job
       CMPA.L  $006C(A6),A4 * too far
       BLT.S   L0055E       * try next table entry
       MOVEQ   #-$02,D0     * job table too small
       BRA.S   L005E0

* activate job

L00570 MOVEQ   #$68,D1
       ADD.L   D2,D1      * add size of jobs descriptor to length
       ADD.L   D3,D1
       JSR     L02FFA(PC) * reserve d1 Bytes
       BNE.S   L005E0
       MOVEM.L (A7),D1-D3/A1
       MOVE.L  A0,(A4)

* !!! from now on D1-D3,A0-A4 COULD BE USED without problems - see
* end of routine - but only A0 is used !!!

       CMP.W   $0062(A6),D7  * jobnr < highest jobnr?
       BLS.S   L0058C        * old job
       MOVE.W  D7,$0062(A6)  * new job
L0058C ADDQ.W  #4,A0         * a0=jobbas+4
       MOVEQ   #$18,D0       * set job descriptor to 0
L00590 CLR.L   (A0)+
       DBF     D0,L00590
       SUBA.W  #$0060,A0     * again start of job
       MOVE.L  D1,(A0)
       ADDQ.W  #8,A0
       SWAP    D7
       MOVE.W  $0060(A6),D7   * SV.JBTAG current value of job
       MOVE.W  D7,(A0)
       SWAP    D7
       ADDQ.W  #1,$0060(A6)    * increment value of SV.JBMAX
       MOVE.L  $0050(A6),$000C(A0) * pointer to trap redirection table
       ADDA.W  #$0040,A0
       MOVE.L  D2,(A0)+        * length of job
       ADD.L   D2,D3           * + data-aera
       MOVE.L  D3,(A0)+
       MOVEQ   #$10,D0
       ADD.L   A0,D0           * D0 = base of job's prog
       MOVE.L  D0,(A0)+
       ADD.L   D0,D3           * d3 = total length
       EXG     D3,A0
       CLR.L   -(A0)
       EXG     D3,A0
       MOVE.L  D3,(A0)
       ADDQ.W  #6,A0           * start of prog
       MOVE.L  A1,D3
       BEQ.S   L005D4
       MOVE.L  D3,D0
L005D4 MOVE.L  D0,(A0)
       MOVE.L  D0,-$005E(A0)
       LEA     $0006(A0),A0    * start of prog-aera
       MOVEQ   #$00,D0
L005E0 MOVEM.L (A7)+,D1-D3/A1-A4
       MOVE.L  D7,D1
       BRA     L003A6

TR1d04
XLtr1d04 EQU TR1d04
o5EA   JSR     L003BC(PC)    * returns bas addr. in A0; ID in D1
       MOVE.L  D1,D0
L005F0 TST.B   $0013(A0)  * jobs priority increment
       BNE     L006C0        * 'not complete'
       JSR     L006C6(PC)    * look for next job in tree
       TST.L   D1
       BNE.S   L005F0        *   ... for all jobs in tree
       MOVE.L  D0,D1         * restore D1 (JOB-ID)
* none active so far, fall through

* mt.frjob
TR1d05
XLtr1d05 EQU TR1d05
       JSR     L003BC(PC)    * returns bas addr. in A0
       MOVE.L  D1,D0         * IOB-ID
       BEQ     L006C0        * BASIC? 'not complete'
       MOVEA.W D1,A1
       ADDA.W  A1,A1
       ADDA.W  A1,A1
       ADDA.L  $0068(A6),A1  * find table entry
L00616 ADDQ.B  #1,(A1)       * mark table entry
       JSR     L006C6(PC)    * find next job in tree
       TST.L   D1
       BNE.S   L00616        *      ... while any job in tree

       SF      -(A7)         * flag: jobid -1 removed?
       MOVEQ   #$00,D1       * now scan the marked jobs
       MOVEA.L $0068(A6),A1   * SV.JBBAS
L00628 ADDQ.W  #4,A1          * next table entry
       ADDQ.W  #1,D1          * next job nr
       CMP.W   $0062(A6),D1   * SV.JBMAX
       BHI     L006B6
       TST.B   (A1)           * marked ?
       BLE.S   L00628         * no ->
       SF      (A1)           * clear mark
       MOVEA.L (A1),A0
       SWAP    D1
       MOVE.W  $0010(A0),D1    * TAG for JOB
       SWAP    D1
       CMPA.L  $0064(A6),A1  * SV.JBPNT
       BNE.S   L0064C
       ST      (A7)          * set if removed jobid=-1
L0064C TST.B   $0017(A0)     * JOB.WFLAG
       BEQ.S   L00670
       MOVE.L  $0018(A0),D0  * D0 = ID of waiting JOB
       EXG     D0,D1
       JSR     L003E4(PC)    *     get its base, Z flag
       EXG     D1,D0
       BNE.S   L00670        *     ... invalid job
       CMPI.W  #$FFFE,$0014(A0)  * is it really waiting ?
       BNE.S   L00670
       CLR.W   $0014(A0)      *    release it
       MOVE.L  D3,$0020(A0)   *    JOB.D0 = error code
       
* now free jobs resources

L00670 MOVEA.L $0004(A6),A0     * base of common heap
L00674 CMP.L   $0008(A0),D1     * owner of this ?
       BNE.S   L0069A
       MOVEM.L D1/D3/A0-A1,-(A7)
       MOVE.L  $000C(A0),D1
       BEQ.S   L00688
       MOVEA.L D1,A1
       ST      (A1)             * set flag on release
L00688 MOVEA.L $0004(A0),A1
       LEA     -$0018(A1),A3
       MOVEA.L $000C(A1),A1         * dev_close
       JSR     (A1)                 * close channel or release memory
       MOVEM.L (A7)+,D1/D3/A0-A1
L0069A ADDA.L  (A0),A0
       CMPA.L  $000C(A6),A0  * SV.FREE
       BLT.S   L00674        * try next block

       MOVEM.L D1/D3/A1,-(A7)
       MOVEA.L (A1),A0
       JSR     L0308C(PC)      * RELEASE headerblock + program space
       MOVEM.L (A7)+,D1/D3/A1
       ST      (A1)            * invalidate table entry
       BRA     L00628          * remove some more jobs

L006B6 TST.B   (A7)+
       BEQ     L003A4          * return
       BRA     L0093A          * must run through scheduler(job -1 removed)

L006C0 MOVEQ   #-$01,D0        * 'not complete'
       BRA     L003A6

* look for ID of next JOB in tree

L006C6 MOVE.L  D1,D2         * D2 = owner job
       MOVEQ   #$00,D1
L006CA ADDQ.W  #1,D1
       CMP.W   $0062(A6),D1   * SV.JBMAX
       BGT.S   L006E0         * -> try next branch
       BSR.S   L006EE         * get Job base
       TST.B   (A1)           * valid entry?
       BLT.S   L006CA
       CMP.L   $0008(A0),D2   * child of JOB ?
       BEQ.S   L00700
       BRA.S   L006CA         * continue searching

L006E0 CMP.W   D2,D0            * setup for next branch
       BEQ.S   L006FC
       MOVE.W  D2,D1
       BSR.S   L006EE
       MOVE.L  $0008(A0),D2     * owner of JOB
       BRA.S   L006CA           * continue searching

L006EE MOVEA.W D1,A1
       ADDA.W  A1,A1
       ADDA.W  A1,A1
       ADDA.L  $0068(A6),A1  * SV.JBBAS
       MOVEA.L (A1),A0       * a0 = base of JOB
       RTS

L006FC MOVEQ   #$00,D1
       RTS

L00700 SWAP    D1
       MOVE.W  $0010(A0),D1    * get job TAG
       SWAP    D1
       RTS

* mt.trapv set for this job the trap vectors
TR1d07
XLtr1d07 EQU TR1d07

o70A   JSR     L003BC(PC)    * returns bas addr. of JOB in A0
       SUBA.W  #$0054,A1
       MOVE.L  A1,$0050(A6)  * pointer to current trap redir. table
       MOVE.L  A1,$001C(A0)  *        ...   jobs     ...
       BRA     L003A4


* allocate area in a heap
TR1d0c
XLtr1d0c EQU TR1d0c
o71E   ADDA.L  $0008(A5),A0  * a0=pointer to pointer to free space
       JSR     L03104(PC)    * MM.ALLOC
       SUBA.L  $0008(A5),A0  * base of allocated area
       BRA.S   L007A2

* link free space
TR1d0d
XLtr1d0d EQU TR1d0d
o72C   ADDA.L  $0008(A5),A0
       ADDA.L  $0008(A5),A1
       JSR     L03162(PC)    * MM.LINKFR
       BRA.S   L007A2

* allocate common heap area       
TR1d18 
XLtr1d18 EQU TR1d18
L0073A EXG     D2,D1
       JSR     L003BC(PC)    * returns bas addr. in A0, ID in d1
       MOVE.L  D1,-(A7)
       MOVEQ   #$10,D1
       ADD.L   D2,D1        * d2= number of bytes
       JSR     L02FAE(PC)   * allocate memory
       BNE.S   L007BC
       ADDQ.W  #4,A0
L0074E
       MOVE.L  XL0075A,(A0)+   * pseudo driver adress
       MOVE.L  (A7)+,(A0)+     * job id
       CLR.L   (A0)+
       BRA.S   L00766  * !!! there: BRA L003A4


L0075A DC.L    L0305E    * adress for release of heap
XL0075A EQU L0075A-$0C   * that's the value, we need

* release area in common heap
L0075E
TR1d19
XLtr1d19 EQU TR1d19
       LEA     -$0010(A0),A0    * TAG for JOB
       JSR     L0305E(PC)     * MT.RECHP
L00766 BRA     L003A4

* allocation (d0=E) and release (d0=F) of resident proc area
TR1d0e
TR1d0f
XLtr1d0e EQU TR1d0e
XLtr1d0f EQU TR1d0e
L0076A MOVEA.L $001C(A6),A0    * SV.RESPR
       CMPA.L  $0014(A6),A0    * SV.TRNSP 
       BNE.S   L007A0
       CMPI.B  #$0F,D0
       BEQ.S   L00786
       TST.L   D1
       BLE.S   L00766
       JSR     L02FFA(PC)    * reserve d1 bytes
       BLT.S   L007BE
       BRA.S   L00792

L00786 MOVE.L  $0020(A6),D1    * SV.RAMT
       SUB.L   $001C(A6),D1    * SV.RESPR
       JSR     L0308C(PC)      * RELEASE MEMORY
L00792 MOVE.L  $0014(A6),$001C(A6)   * SV TRNSP ½ SV.RESPR
       CLR.L   $0018(A6)       * SV.TRNFR
       BRA     L003A4
L007A0 MOVEQ   #-$01,D0    * 'not complete'
L007A2 BRA.S   L007BE    * !!! Faster: Jump direct - used to save space

* allocate Basic prog aera
TR1d16
XLtr1d16 EQU TR1d16
L007A4 JSR     L031B8(PC)     * allocate memory
       BRA.S   L007BE         * !!! there: BRA L003A6 
* Faster: Jump direct - used to save space

* Release Basic Prog Aera 
TR1d17
XLtr1d17 EQU TR1d17
       MOVE.L  $0014(A6),-(A7)   * SV TRNSP
       SUB.L   D1,$0014(A6)      * SV TRNSP
       JSR     L031C8(PC)        * Release memory
       MOVE.L  (A7)+,$0014(A6)   * SV TRNSP
       BRA.S   L007BE         * !!! memory saving but time waisting
L007BC ADDQ.W  #4,A7
L007BE BRA     L003A6

* set or read display mode according to D1 and D2 ½ Adder
TR1d10
XLtr1d10 EQU TR1d10
o7C0   MOVE.B  $0034(A6),D0     * SV.MCSTA
       TST.B   D1               * read?
       BLT     L0085E           * yes
       ANDI.B  #$F7,D0    * !!! this and next command used for security
       ANDI.B  #$08,D1    * if calling routine did set word
* 'cause all use moveq... not necessary
       OR.B    D1,D0
       MOVE.B  D0,$0034(A6)  * set SV.MCSTA
       MOVE.B  D0,$00018063  * set 8049 according
       MOVE.L  A6,-(A7)      * preserves A6
       MOVE.W  #$1FFF,D0
L007E6 CLR.L   -(A6)         * now cls of whole screen
       DBF     D0,L007E6
       MOVEA.L (A7)+,A6
       
* reinitialisation of screen channels

       MOVEA.L $0078(A6),A4  * SV.CHBAS
L007F2 MOVE.L  (A4)+,D0
       MOVEM.L D1-D6/A0-A6,-(A7)
       BLT.S   L00852        * channel closed?
       MOVEA.L D0,A0
       CMPI.L  #L00D36,$0004(A0)  * is it no screen channel
       BNE.S   L00852        * look for next channels
       MOVE.B  D1,-(A7)
       MOVE.W  $0020(A0),-(A7)
       MOVEQ   #$00,D2
       JSR     L01AFC(PC)    * set border
       LEA     $0036(A0),A1  * paper colour masque
       LEA     $0044(A0),A5  * paper colour byte
       MOVEQ   #$02,D0
L0081C MOVE.B  (A5)+,D1
       JSR     L027D8(PC)    * set paper masque
       ADDQ.W  #4,A1
       DBF     D0,L0081C
       JSR     L01CAE(PC)    * cls
       MOVE.B  (A5),D1
       MOVE.W  (A7)+,D2
       JSR     L01AF8(PC)    * set set border
       SUBQ.W  #5,A5
       ANDI.B  #$00,(A5)    * set char-attributes to 0
       MOVE.L  #$0006000A,$0026(A0) * reset charsize
       TST.B   (A7)+
       BEQ.S   L0084E       * mode 4 ½ yes
       BSET    #$06,(A5)+   * mode 8
       LSL     $0026(A0)
L0084E TST.B   (A5)         * cursor-status
       SNE     (A5)
L00852 MOVEM.L (A7)+,D1-D6/A0-A6
       CMPA.L  $007C(A6),A4  * all channels checked
       BLT.S   L007F2        * no, continue
       BRA.S   L00862

L0085E MOVEQ   #$08,D1
       AND.B   D0,D1         * if mode 4: D1=0, else: D1=8
L00862 TST.B   D2
       BGE.S   L0086A
       MOVE.B  $0032(A6),D2  * SV.TVMOD
L0086A MOVE.B  D2,$0032(A6)
       BRA     L003A4

TR1d11
XLtr1d11 EQU TR1d11

* send command to 8049

L00872 MOVEM.L D4/D6/A0-A1/A3,-(A7)
       JSR     L02C72(PC)    * execute command to 8049
       MOVEM.L (A7)+,D4/D6/A0-A1/A3
       BRA     L003A4
 
TR1d12
XLtr1d12 EQU TR1d12

* MT.BAUD

L00882 MOVEM.L D2/D6/A0-A2,-(A7)
       LEA     L008D6(PC),A0    * table of baudrates
       MOVEQ   #$07,D2
L0088C CMP.W   (A0)+,D1         * compare table with selecte rate
       BEQ.S   L0089E           * match
       DBF     D2,L0088C
       MOVEQ   #-$0F,D0         * no valid baudrate
L00896 MOVEM.L (A7)+,D2/D6/A0-A2
       BRA     L003A6

L0089E MOVE.L  #$4B0,D0         * dezimal 1200
       DIVU    D1,D0            * d0=$4b0/baudrate
       ADDQ.W  #1,D0
       MOVE.W  D0,$00A8(A6)    * SV.TIMOV
       ORI.W   #$0700,SR
       JSR     L02F6E(PC)      * returns D6=6  A0=$18020  A1=$18003
       LEA     $00A0(A6),A2    * SV.TMODE
       ANDI.B  #$F8,(A2)
       OR.B    D2,(A2)
       MOVE.B  (A2),-$0001(A1)
       MOVEQ   #$0D,D0        * cammand 0D = serial settings
       JSR     L02F7C(PC)     * command for 8079
       MOVE.B  D2,D0
       JSR     L02F7C(PC)     * command for 8079
       ANDI.W  #$F8FF,SR
       MOVEQ   #$00,D0
       BRA.S   L00896

L008D6 DC.L    $004B012C        *   75 / 300 BAUD
       DC.L    $025804B0        *  600 /1200 BAUD
       DC.L    $096012C0        * 2400 /4800 BAUD
       DC.L    $25804B00        * 9600 /19200 BAUD

TR1d1a
TR1d1c
TR1d1e
TR1d20
TR1d22
XLtr1d1a EQU TR1d1a
XLtr1d1c EQU TR1d1a
XLtr1d1e EQU TR1d1a
XLtr1d20 EQU TR1d1a
XLtr1d22 EQU TR1d1a       
* link traps
L008E6 ADD.W   D0,D0
       LEA     $04(A6,D0.W),A1
       JSR     L039DC(PC)    * UT.LINK
       BRA.S   L008FC


TR1d1b
TR1d1d
TR1d1f
TR1d21
TR1d23
XLtr1d1b EQU TR1d1b
XLtr1d1d EQU TR1d1b
XLtr1d1f EQU TR1d1b
XLtr1d21 EQU TR1d1b
XLtr1d23 EQU TR1d1b

* task linking traps

L008F2 ADD.W   D0,D0
       LEA     $02(A6,D0.W),A1
       JSR     L039E2(PC)    * UT.UNLNK
L008FC BRA     L003A4


* polled interrupt
L00900 ADDQ.W  #1,$0030(A6)    * SV.POLLM
       BVC.S   L0090A
       SUBQ.W  #1,$0030(A6)
L0090A MOVEM.L D0-D6/A0-A4,-(A7)
       MOVEQ   #-$08,D0
       MOVEQ   #$01,D3
       MOVEA.L $003C(A6),A0    * SV.PLIST
       JSR     L00A9E(PC)      * execute poll tasks
       MOVEM.L (A7)+,D0-D6/A0-A4
       MOVE.B  $0035(A6),D7    * SV.PCINT
       ORI.B   #$08,D7
       MOVE.B  D7,$00018021
       BTST    #$05,$000C(A7)  * supervisor mode?
       BNE     L003B6          * yes -> rte
* else fall through into scheduler
L00936 JSR     L009D4(PC)      * save jobs data
L0093A MOVE.W  $0030(A6),D3    * SV.POLLM
       CLR.W   $0030(A6)
       ADDQ.W  #1,$002E(A6)    * SV.RAND
       MOVEQ   #-$10,D0
       MOVEA.L $0040(A6),A0    * SV.SHLST
       JSR     L00A9E(PC)      * execute sched tasks
       JSR     L00A0C(PC)      * get highest job priority
       TST.L   D0
       BLT.S   L0093A        * no runnable job ->
       MOVE.L  D0,$0064(A6)  * SV.JBPNT: new current job
       JSR     L00A78(PC)    * execute it
       
TR1d08 
XLtr1d08 EQU TR1d08
* suspend job
       JSR     L003BC(PC)    * returns bas addr. in A0
       MOVE.W  D3,$0014(A0)  * JOB status
       MOVE.L  A1,$000C(A0)
       MOVEQ   #$00,D0
       BRA.L   L00936
       
TR1d09
XLtr1d09 EQU TR1d09
* reactivate job
       JSR     L003BC(PC)    * returns bas addr. in A0
       TST.W   $0014(A0)  * JOB status
       BEQ.S   L0098A
       CLR.W   $0014(A0)  * JOB status
       MOVE.L  $000C(A0),D0  * Adder S. 337
       BEQ.S   L0098A
       MOVEA.L D0,A0
       SF      (A0)
L0098A MOVEQ   #$00,D0
       BRA.L   L00936

TR1d0b
XLtr1d0b EQU TR1d0b
* change priority of job
o990   JSR     L003BC(PC)    * returns bas addr. in A0
       MOVE.B  D2,$0013(A0)  * jobs priority increment
       BNE.S   L009CA
       SF      $0012(A0)     * Jobs accumulated priority
       BRA.S   L009CA

TR1d0a
XLtr1d0a EQU TR1d0a
* activate job
o9A0   JSR     L003BC(PC)    * returns bas addr. in A0
       TST.B   $0013(A0)     * jobs priority increment
       BNE.S   L009D0
       MOVE.B  D2,$0013(A0)  * jobs priority increment
       MOVE.L  $0004(A0),$0062(A0)  * START ½ Adder S. 335
       TST.W   D3            * wait ?
       BEQ.S   L009CA        * no ->
       ST      $0017(A0)
       JSR     L00408(PC)
       MOVE.L  D0,$0018(A0)  * JOB.WJOB
       MOVE.W  #$FFFE,$0014(A3)
L009CA MOVEQ   #$00,D0
L009CC BRA     L00936

L009D0 MOVEQ   #-$01,D0
       BRA.S   L009CC

* scheduler aux subroutines

* save jobs registers into jobheader
L009D4 MOVE.L  A6,-(A7)
       MOVEA.L $0064(A6),A6  * SV.JBPNT
       MOVEA.L (A6),A6
       TST.B   $0012(A6)     * accumulated priority
       BEQ.S   L009E8
       MOVE.B  #$01,$0012(A6)
L009E8 MOVEM.L D0-D7/A0-A4,$0020(A6) * save regs into jobheader
       MOVE.L  (A5)+,$003C(A6)    * D7
       MOVE.L  (A5)+,$0054(A6)    * a5
       MOVE.L  (A5)+,$0058(A6)    * a6
       MOVE.L  USP,A0             * a7
       MOVE.L  A0,$005C(A6)       *
       MOVE.W  (A5)+,$0060(A6)    * SR
       MOVE.L  (A5)+,$0062(A6)    * PC
       MOVEA.L (A7)+,A6
       RTS

* get job with highest priority
* D0=-2 if none ready
L00A0C MOVEQ   #-$02,D0
       MOVEQ   #$00,D1
       MOVEA.L $0064(A6),A2   * SV.JBPNT
       MOVEA.L A2,A4          * a4= current job
       MOVE.W  $0062(A6),D2   * SV.JBMAX
       LSL.W   #2,D2
       MOVEA.L $0068(A6),A3   * SV.JBBAS
       ADDA.W  D2,A3

L00A22 ADDQ.W  #4,A2          * a2= currently examined job
       CMPA.L  A3,A2          * >SV.JBMAX ?
       BLE.S   L00A2C
       MOVEA.L $0068(A6),A2   *  ... wrap search
L00A2C TST.B   (A2)           * valid job ?
       BLT.S   L00A72         * no ->
       MOVEA.L (A2),A0
       TST.B   $0013(A0)    * jobs priority increment
       BEQ.S   L00A72       * 0 -> no chance
       TST.W   $0014(A0)    * JOB status
       BEQ.S   L00A54       * -> runnable
       BLT.S   L00A72       * -> indefintely suspended, try next
       SUB.W   D3,$0014(A0)  * decrement timeout by SV.POLLM
       BGT.S   L00A72        * -> still suspended
       CLR.W   $0014(A0)     * make sure it doesn't get suspended by accident
       MOVE.L  $000C(A0),D2  * JOB.HOLD
       BEQ.S   L00A54
       MOVEA.L D2,A1         * release flag
       SF      (A1)
L00A54 MOVE.B  $0012(A0),D2     * Jobs accumulated priority
       BEQ.S   L00A64
       ADD.B   $0013(A0),D2     * jobs priority increment
       BCC.S   L00A66
       ST      D2
       BRA.S   L00A66

L00A64 MOVEQ   #$01,D2
L00A66 MOVE.B  D2,$0012(A0)    * Jobs accumulated priority
       CMP.B   D1,D2
       BLS.S   L00A72          * no chance
       MOVE.L  A2,D0           * best so far
       MOVE.B  D2,D1           * ...         priority
L00A72 CMPA.L  A4,A2
       BNE.S   L00A22
       RTS

* return from scheduler and run job
L00A78 MOVEA.L $0064(A6),A0  * SV.JBPNT
       MOVEA.L (A0),A0
       ADDA.W  #$0016,A7
       MOVE.L  $0062(A0),-(A7)          * JOB.PC
       MOVE.W  $0060(A0),-(A7)          * JOB.SR
       MOVE.L  $001C(A0),$0050(A6)      * SV.TRAPV <- JOB.TRAPV
       MOVEA.L $005C(A0),A1
       MOVE.L  A1,USP                   * JOB.A7
       MOVEM.L $0020(A0),D0-D7/A0-A6
       RTE

*  execute linked tasks (extint,poll,sched)
*  A0= list
L00A9E MOVE.W  D0,-(A7)
L00AA0 MOVEA.L A0,A3
       ADDA.W  (A7),A3        * offset to driver address
       MOVE.L  A0,-(A7)
       BEQ.S   L00ABC
       MOVE.W  D3,-(A7)
       ANDI.W  #$007F,D3
       MOVEA.L $0004(A0),A0   * A0=adress of task
       JSR     (A0)
       MOVE.W  (A7)+,D3
       MOVEA.L (A7)+,A0
       MOVEA.L (A0),A0
       BRA.S   L00AA0

L00ABC ADDQ.L  #6,A7
       RTS

* 'SER' driver
L00AC0 DC.L    L00C88   * pointer to next driver in link
       DC.L    L00BB6   * adress of in / out
       DC.L    L00AD0   * adress to open chan
       DC.L    L00B8E   * adress to close 

L00AD0 SUBQ.W  #8,A7
       MOVEA.L A7,A3
       JSR     L0372C(PC)   * IO.DECODE
       BRA.S   L00B20       * ERROR
       BRA.S   L00B20       * ERROR
       BRA.S   L00B28       * SUCCESS

L00ADE DC.W    $0003
       DC.B    'SER'
       DC.B    $00
       DC.W    $0004   * 4 parameters
       DC.W    $FFFF   * default values
       DC.W    $0001   * = ser1
       DC.W    $0004   * 4 options for second parameter
       DC.B    'OEMS'
       DC.W    $0002   * 2 options for third
       DC.B    'IH'
       DC.W    $0003   * 3 options for fourth
       DC.B    'RZC',$00
L00AFA DC.L    $02000000   * values for 8049 - open ser1
       DC.L    $00000100 
       DC.L    $03000000   * OPEN SER2
       DC.L    $00000100
L00B0A DC.L    $04000000   * close ser1
       DC.L    $00000100
       DC.L    $05000000   * close ser2
       DC.L    $00000100
               
L00B1A MOVEQ   #-$07,D0   * 'not found'
       BRA.S   L00B20
        
L00B1E MOVEQ   #-$09,D0   * 'in use'
L00B20 ADDQ.W  #8,A7
       ANDI.W  #$F8FF,SR
       RTS

* open ser
        
L00B28 ORI.W   #$0700,SR
       MOVE.W  (A7),D4
       BLE.S   L00B1A
       SUBQ.W  #2,D4
       BGT.S   L00B1A
       LEA     $0098(A6),A5    * SV.SER1C
       LEA     L00AFA(PC),A4   * is it a serial channel
       BLT.S   L00B42          * no½ look for next channel
       ADDQ.W  #4,A5
       ADDQ.W  #8,A4
L00B42 MOVE.L  (A5),D0
       BEQ.S   L00B56
       MOVEA.L D0,A0
       SUBA.W  #$0020,A0
       BCLR    #$07,$0082(A0)
       BNE.S   L00B6A
       BRA.S   L00B1E

L00B56 MOVE.W  #$00E4,D1
       JSR     L02FAE(PC) * MM.ALCHP
       BNE.S   L00B20
       MOVEQ   #$51,D1
       LEA     $0082(A0),A2
       JSR     L037F4(PC)     * IO.QSET
L00B6A MOVEQ   #$51,D1
       LEA     $0020(A0),A2   * pointer to buffer
       JSR     L037F4(PC)     * IO.QSET
       MOVE.L  A2,(A5)
       MOVE.L  (A7),$0018(A0)
       MOVE.L  $0004(A7),$001C(A0)
       SUBQ.W  #1,$001C(A0)
       SUBQ.W  #2,$001E(A0)
       BSR.S   L00BAA
       MOVEQ   #$00,D0
       BRA.S   L00B20

L00B8E LEA     L00B0A(PC),A4  * close ser
       BTST    #$01,$0018(A0) * input queue
       BEQ.S   L00B9C
       ADDQ.L  #8,A4
L00B9C BSR.S   L00BAA
       LEA     $0082(A0),A2  *
       JSR     L03888(PC)    * IO.QEOF
       MOVEQ   #$00,D0
       RTS

L00BAA 
       MOVE.L  A0,-(A7)   * serial I/O
       MOVEA.L A4,A3
       JSR     L02C72(PC)    * execute command to 8049
       MOVEA.L (A7)+,A0
       RTS

L00BB6 JSR     L0388C(PC)    * IO.SERIO
       DC.l    L00BC8        * test ser
       DC.L    L00C24        * read from ser
       DC.L    L00BD0        * write to ser
       RTS

L00BC8 LEA     $0020(A0),A2 * pointer to buffer
       JMP     L0380A(PC)   * IO.QTEST
       
* what kind of ser-transmission is to do?

L00BD0 CMPI.B  #$0A,D1
       BNE.S   L00BDE
       TST.B   $001F(A0)
       BLE.S   L00BDE
       MOVEQ   #$0D,D1
L00BDE MOVE.W  $001A(A0),D0
       MOVE.B  L00BEA(PC,D0.W),D0
       JMP     L00BEA(PC,D0.W)  * now its done

L00BEA DC.B    XWNOPAR-L00BEA
       DC.B    XWODD-L00BEA
       DC.B    XWEVEN-L00BEA
       DC.B    XWBIT7-L00BEA
       DC.B    XWBIT8-L00BEA
       
WBIT7  BSET    #7,D1
XWBIT7 EQU WBIT7
WNOPAR
XWNOPAR EQU WNOPAR
L00BF4 LEA     $0082(A0),A2
       TST.B   $0144(A6)
       BEQ.S   L00C0C
       MOVE.L  A3,-(A7)
       MOVEA.L $BFEE,A3   * !!! PROG-LABEL
       JSR     (A3)
       MOVEA.L (A7)+,A3
       BRA.S   L00C74

L00C0C JSR     L03838(PC)    * IO.QIN
       BRA.S   L00C74

WBIT8  BCLR    #$07,D1
       BRA.S   L00BF4
XWBIT8 EQU WBIT8
WODD   BSR.S   L00C76
       BCHG    #$07,D1
       BRA.S   L00BF4
XWODD EQU WODD
WEVEN  BSR.S   L00C76
       BRA.S   L00BF4
XWEVEN EQU WEVEN
L00C24 LEA     $0020(A0),A2  * pointer to buffer
       JSR     L0385E(PC)    * IO.QOUT
       BNE.S   L00C74
       MOVE.W  $001A(A0),D3
       MOVE.B  L00C3A(PC,D3.W),D3
       JMP     L00C3A(PC,D3.W)

L00C3A DC.B    XRNOPAR-L00C3A  * displacement for read-ser
       DC.B    XRIMPAR-L00C3A
       DC.B    XRPAR-L00C3A
       DC.B    XRBIT71-L00C3A
       DC.B    XRBIT70-L00C3A
       DC.B    $00

RBIT71 BCHG    #$07,D1
       BRA.S   L00C4C

RIMPAR BCHG    #$07,D1
RPAR   BSR.S   L00C76
RBIT70
L00C4C BTST    #$07,D1
       BEQ.S   L00C54
       MOVEQ   #-$0D,D0
L00C54
RNOPAR

XRBIT71 EQU RBIT71
XRIMPAR EQU RIMPAR
XRPAR   EQU RPAR
XRBIT70 EQU RBIT70
XRNOPAR EQU RNOPAR

       TST.B   $0144(A6)
       BEQ.S   L00C66
       MOVE.L  A3,-(A7)
       MOVEA.L $BFEA,A3
       JSR     (A3)
       MOVEA.L (A7)+,A3
L00C66 CMPI.B  #$0D,D1
       BNE.S   L00C74
       TST.B   $001F(A0)
       BLE.S   L00C74
       MOVEQ   #$0A,D1
L00C74 RTS

L00C76 MOVEQ   #$06,D3
       MOVE.B  D1,D4
L00C7A ROR.B   #1,D1
       EOR.B   D1,D4
       DBF     D3,L00C7A
       ROXL.B  #1,D4
       ROXR.B  #1,D1
       RTS

* 'PIPE' driver
L00C88 DC.L    L00D36   * pointer to next driver
       DC.L    L037CC   * addr. for pipe I/O
       DC.L    L00C98   * addr. to open pipe#
       DC.L    L00D0A   * addr. to close pipe#
       
L00C98 SUBQ.W  #2,A7    * open pipe#
       MOVEA.L A7,A3
       JSR     L0372C(PC)   * IO.DECODE
       BRA.S   L00D00       * ERROR
       BRA.S   L00D00       * ERROR
       BRA.S   L00CB2       * SUCCESS

o00CA6 DC.W    $0004
       DC.B    'PIPE'
       DC.W    $0001   * 1 parameter
       DC.B    ' _'    * '_' necessary
       DC.W    $0000   * lenght parameter
       
L00CB2 MOVE.W  (A7),D1       * any length ?
       BEQ.S   L00CD2
       ADDI.W  #$31,D1
       JSR     L02FAE(PC)    * MM.ALCHP
       BNE.S   L00D00
       MOVE.W  (A7),D1
       ADDQ.W  #1,D1
       LEA     $0020(A0),A2   * pointer to buffer
       JSR     L037F4(PC)     * IO.QSET
       MOVE.L  A2,$001C(A0)
       BRA.S   L00CFE         * done

* connect to another pipe
L00CD2 MOVEA.W D3,A2          * chan id
       ADDA.L  A2,A2
       ADDA.L  A2,A2
       ADDA.L  $0078(A6),A2
       MOVEA.L (A2),A2        * chan base
       CMPI.L  #L00C88,$0004(A2)  * is it a pipe channel ?
       BNE.S   L00D04             * no ½ error
       MOVE.L  A2,-(A7)           * save its base
       MOVEQ   #$20,D1
       JSR     L02FAE(PC)   *  MM.ALCHP
       MOVEA.L (A7)+,A2
       BNE.S   L00D00        * -> no mem
       LEA     $0020(A2),A2  * pointer to queue
       MOVE.L  A0,(A2)       * link queues
       MOVE.L  A2,$0018(A0)
L00CFE MOVEQ   #$00,D0
L00D00 ADDQ.W  #2,A7
       RTS

L00D04 MOVEQ   #-$0F,D0
       ADDQ.W  #2,A7
       RTS

* close
L00D0A TST.L   $0018(A0)
       BNE.S   L00D1C
       LEA     $0020(A0),A2  * pointer to buffer
       TST.L   (A2)          * queue empty?
       BEQ.S   L00D32        * yes: close channel
       JMP     L03888(PC)    * IO.QEOF

L00D1C MOVE.L  $0018(A0),-(A7)
       BSR.S   L00D32        * close channel
       MOVEA.L (A7)+,A2
       LEA     -$0020(A2),A0
       TST.B   (A2)     * file empty
       BLT.S   L00D32   * yes: close channel
       CLR.L   (A2)
       MOVEQ   #$00,D0
       RTS

L00D32 JMP     L0305E(PC)    * MT.RECHP

* 'CON' driver
L00D36 DC.L    L01104   * ADRESS ON NEXT LINKED DRIVER
       DC.L    L00E76   * I/O OF CON AND SER
       DC.L    L00D46   * OPEN CON OR SER
       DC.L    L00E3A   * CLOSE CON OR SER
       
L00D46 SUBA.W  #$000A,A7
       MOVEA.L A7,A3
       JSR     L0372C(PC)   * IO.DECODE
       BRA.S   L00D9E       * ERROR
       BRA.S   L00DC8       * ERROR
       BRA.S   L00D72       * SUCCESS

o00D56 DC.W    $0003
       DC.B    'CON'
       DC.B    $00
       DC.W    $0005   * 5 parameters
       DC.W    $205F   * needs '_'
       DC.W    448     * wide
       DC.W    $2058   * needs 'X'
       DC.W    180     * high
       DC.W    $2041   * needs 'A' 
       DC.W    32      * x-origin
       DC.W    $2058   * needs 'X'
       DC.W    16      * y-origin
       DC.W    $205F   * needs '_'
       DC.W    $0080   * default buffer:128 Bytes
        
L00D72 MOVEQ   #$7A,D1     * initialise
       ADD.W   $0008(A7),D1
       BSR.S   L00DCE   * open #
       BNE.S   L00DC8   * out of memory
       LEA     $0068(A0),A2   * initialise keyboard buffer
       SUBI.W  #$0078,D1
       JSR     L037F4(PC)     * IO.QSET
       MOVEA.L $004C(A6),A3
       MOVE.L  A3,D3
       BNE.S   L00D98      * if buffer exists: create new one
       MOVE.L  A2,(A2)   
       MOVE.L  A2,$004C(A6)  * store addr of keyboard buffer
       BRA.S   L00DC6

L00D98 MOVE.L  (A3),(A2)   * link buffer-adresses
       MOVE.L  A2,(A3)
       BRA.S   L00DC6      * back without error

L00D9E JSR     L0372C(PC)   * IO.DECODE
       BRA.S   L00DC8       * ERROR
       BRA.S   L00DC8       * ERROR
       BRA.S   L00DC0       * SUCCESS

o00DA8 DC.W    $0003
       DC.B    'SCR',$00
       DC.W    $0004   * 4 parameters
       DC.W    $205F   * needs '_'
       DC.W    448     * wide 
       DC.W    $2058   * needs 'X'
       DC.W    180     * high
       DC.W    $2041   * needs 'A'
       DC.W    32      * x-origin
       DC.W    $2058   * needs 'X'
       DC.W    16      * y-origin


* open screen channel       
L00DC0 MOVEQ   #$6C,D1 * lenght of description
       BSR.S   L00DCE  * open channel
       BRA.S   L00DC8

L00DC6 MOVEQ   #$00,D0
L00DC8 ADDA.W  #$000A,A7
       RTS

* open channel
L00DCE JSR     L02FAE(PC)          * MM.ALCHP
       BNE.S   L00E38
       MOVE.W  D1,-(A7)
       LEA     $0026(A0),A2
       MOVE.L  #$0006000A,(A2)+    * charsize:  6x10 pixels
       MOVE.L  #XL0AD9A,(A2)+      * PIXEL-SCR
       MOVE.L  #XL0B106,(A2)+      * PIXEL-SCR
       MOVE.L  #$00020000,(A2)+    * SCREENMEMORY
       MOVE.W  #$80,$64(A0)        * necessary ? lenght of buffer?
       LEA     $003E(A0),A1        * define paper
       MOVEQ   #$04,D1
       MOVE.B  D1,$0046(A0)
       JSR     L027D8(PC)
       MOVE.L  #$08076400,$56(A0)   * graphic shell
       BTST    #$03,$0034(A6)       * SV.MCSTA - mode 4 ?
       BEQ.S   L00E20
       ADDQ.W  #6,$0026(A0)         * adapt size
       BSET    #$06,$0042(A0)
L00E20 MOVEQ   #$00,D2
       LEA     $0006(A7),A1
       JSR     L01AB6(PC)
       MOVE.W  (A7)+,D1
       TST.L   D0          * error ?
       BEQ.S   L00E38      * no
       MOVE.L  D0,-(A7)
       JSR     L0305E(PC)  * MT.RECHP
       MOVE.L  (A7)+,D0    * report
L00E38 RTS

L00E3A LEA     $0068(A0),A3   * CLOSE CON / SER
       TST.L   (A3)
       BEQ.S   L00E70
       MOVEA.L (A3),A2
       CMPA.L  A2,A3
       BNE.S   L00E4E
       CLR.L   $004C(A6)      * SV.KEYQ
       BRA.S   L00E70

L00E4E CMPA.L  $004C(A6),A3   * SV.KEYQ
       BNE.S   L00E66
L00E54 TST.B   -$0025(A2)
       BNE.S   L00E62
       CMPA.L  (A2),A3
       BEQ.S   L00E62
       MOVEA.L (A2),A2
       BRA.S   L00E54

L00E62 MOVE.L  A2,$004C(A6)  * SV.KEYQ
L00E66 MOVEA.L A3,A2
L00E68 MOVEA.L (A2),A2
       CMPA.L  (A2),A3
       BNE.S   L00E68
       MOVE.L  (A3),(A2)
L00E70 JSR     L0305E(PC)    * MT.RECHP
       RTS

L00E76 TST.B   $0033(A6)     * I/O OF CON/SER screen freezed
       BEQ.S   L00E80
       MOVEQ   #-1,D0        * not complete
       RTS

L00E80 CMPI.B  #$07,D0
       BHI.S   L00EFC
       MOVEQ   #-1,D7
       MOVEQ   #$00,D6
       MOVE.W  D2,D5
       MOVE.L  D1,D4
       MOVEA.L A1,A4
       LEA     $0068(A0),A5
       TST.L   D3
       BLT.S   L00EB0
       CMPI.B  #$04,D0
       BHI.S   L00EB0
       TST.L   (A5)
       BEQ.S   L00EEC
       MOVEA.L $004C(A6),A2    * SV.KEYQ
       TST.B   -$0025(A2)
       BNE.S   L00EB0
       MOVE.L  A5,$004C(A6)
L00EB0 MOVE.B  L00EB8(PC,D0.W),D0
       JMP     L00EB8(PC,D0.W)

L00EB8 DC.B   L00EC0-L00EB8   * test pending input
       DC.B   L00EC6-L00EB8   * put byte
       DC.B   L00F54-L00EB8
       DC.B   L00ECA-L00EB8   * edit line
       DC.B   L00F5A-L00EB8
       DC.B   L00F00-L00EB8   * 
       DC.B   L00EEC-L00EB8   * not used
       DC.B   L00EDE-L00EB8   * put in queue

*------------ general scr I/O       

L00EC0 JMP     L0380A(PC)     * IO.QTEST

L00EC6 MOVEA.L A5,A2         * A2=buffer adress of keyboard
       JMP     L0385E(PC)    * IO.QOUT

L00ECA MOVEQ   #$00,D0
L00ECC CMP.W   D4,D5         * all chars printed
       BLS.S   L00EEE
       MOVEA.L A5,A2
       JSR     L0385E(PC)    * IO.QOUT
       BLT.S   L00EEE
       MOVE.B  D1,(A4)+
       ADDQ.W  #1,D4
       BRA.S   L00ECC

L00EDE MOVEQ   #$00,D0
       CMP.W   D4,D5
       BLS.S   L00EEE
       MOVE.B  (A4)+,D1
       BSR.S   L00F00
       ADDQ.W  #1,D4
       BRA.S   L00EDE

L00EEC MOVEQ   #-$0F,D0
L00EEE MOVE.W  D4,D1
       MOVEA.L A4,A1
L00EF2 BCLR    #$07,$0042(A0)
       RTS

L00EFA MOVEQ   #$05,D0   * add one character to screen
L00EFC JMP     L01992(PC)

L00F00 MOVEQ   #$00,D0
       CMPI.B  #$0A,D1     * CR ?
       BEQ.S   L00F36      * add new line
       TST.B   $0048(A0)   * new line status ½Adder S. 337
       BEQ.S   L00F14      * position cursor
       MOVE.B  D1,-(A7)    * byte to send on stack
       BSR.S   L00F46      * position cursor
       MOVE.B  (A7)+,D1
L00F14 BSR.S   L00EFA      * put byte
       BEQ.S   L00F44      * succeeded ½ end
       MOVE.W  $0026(A0),D0 * if not: increment cursor
       ADD.W   D0,$0022(A0)
       BTST    #$07,$0042(A0)
       BNE.S   L00F42
       MOVE.B  D0,$0048(A0)
       TST.B   $0043(A0)    * cursoff ?
       BEQ.S   L00F42   * end
       BSR.S   L00F46   * position cursor
       BRA.S   L00F42

L00F36 TST.B   $0048(A0) * is curosr at end of line?
       BGE.S   L00F3E
       BSR.S   L00F46   * position cursor
L00F3E ST      $0048(A0)
L00F42 MOVEQ   #$00,D0
L00F44 RTS

* position cursor
L00F46 TST.B   $0043(A0)   * new line - cursor activ
       BLE.S   L00F50      * no
       JSR     L01BA2(PC)  * test position
L00F50 JMP     L01BF8(PC)  * if necessary: NL

L00F54 TST.L   D3
       BEQ.S   L00F6C
       BRA.S   L00F5E

*----------------- Line editor
        
L00F5A MOVEQ   #-$01,D4    
       MOVE.W  D1,D4
L00F5E SWAP    D1
       MOVE.W  D1,D6    * d6=position of cursor
       SUBA.W  D4,A4    * position cursor in buffer
       ADDA.W  D6,A4
       BNE.S   L00F84   * end of buffer
       TST.L   D3
       BLT.S   L00F84
L00F6C TST.B   $0043(A0)    * curson ?
       BLE.S   L00F76
       JSR     L01BA2(PC)   * position cursor ..
L00F76 JSR     L01BF2(PC)   * if neccessary to start
       BSR     L010DC       * of next line
       MOVE.W  D4,D6
       SUB.W   D3,D6
       SUBA.W  D3,A4
L00F84 MOVE.B  $43(A0),-(A7)
L00F88 MOVEA.L A5,A2         * keyboard buffer
       JSR     L0385E(PC)    * IO.QOUT get byte
       BLT     L01018        * EOF ?
       TST.B   $43(A0)       * cursor activ
       BLE.S   L00FA0
       MOVE.B  D1,-(A7)      * received byte
       JSR     L01BA2(PC)    * position cursor
       MOVE.B  (A7)+,D1
L00FA0 CMPI.B  #$0A,D1       * CR?
       BEQ.S   L01002
       CMPI.B  #$1F,D1       * less 31 - do nothing
       BLS.S   L00F88
       CMPI.B  #$BF,D1   * higher 191 - append square
       BHI.S   L00FDA
       MOVE.W  D4,D0   * d4 = length of line
       SUB.W   D6,D0   * actual position
       BRA.S   L00FBE   * store byte

L00FB8 MOVE.B  $00(A4,D0.W),$01(A4,D0.W)   * line out
L00FBE DBF     D0,L00FB8
       ADDQ.W  #1,D6
       ADDQ.W  #1,D4      * correct pointer
       MOVE.B  D1,(A4)+   * store bytes
       MOVEQ   #-$01,D7
       BSR     L010AC
       BSR     L010CE     * scroll ?
       CMP.W   D4,D5
       BHI.S   L00F88     * more bytes editable
       MOVEQ   #-$05,D0   * "buffer full "
       BRA.S   L01022

L00FDA TST.L   D4
       BGE.S   L00FEA
       CMPI.B  #$D0,D1   * cursor up
       BEQ.S   L01002
       CMPI.B  #$D8,D1   * down
       BEQ.S   L01002
L00FEA SUBI.B  #$C0,D1   * left
       BEQ.S   L01030
       SUBQ.B  #2,D1     * ctrl-left
       BEQ     L0107C
       SUBQ.B  #6,D1     * right
       BEQ.S   L01038
       SUBQ.B  #2,D1     * ctrl-right
       BEQ     L01080
L01000 BRA.S   L00F88    * position cursor

L01002 MOVE.B  D1,-(A7)   * output of line - cursor up/down
       MOVEQ   #-$01,D7
       BSR     L010E0
       MOVE.B  (A7)+,(A4)+
       ADDQ.W  #1,D4
       JSR     L01B94(PC)
       BSR     L00F36
       BRA.S   L0102A

L01018 TST.B   (A7)   * end of edit
       BLT.S   L01022
       JSR     L01B86(PC)
       MOVEQ   #-$01,D0
L01022 SUBA.W  D6,A4
       ADDA.W  D4,A4
       MOVE.W  D6,D1
       SWAP    D1
L0102A ADDQ.W  #2,A7
       BRA     L00EEE

L01030 
       BSR.S   L01054   * cursor left previous line ?
       BEQ.S   L01000   * pos. cursor
L01034 ADDQ.W  #1,D6
       BRA.S   L01000
        
L01038 
       ADDQ.W  #1,D6   * cursor right
       CMP.W   D4,D6
       BHI.S   L01050   * end of buffer?
       ADDQ.W  #1,A4
       JSR     L01C48(PC)   * pos cursor right
       BEQ.S   L01000
       JSR     L01BF8(PC)
       BSR     L010CE
       BRA.S   L01000

L01050 SUBQ.W  #1,D6
L01052 BRA.S   L01000

L01054 SUBQ.W  #1,D6   * previous line to edit
       BLT.S   L0107A
       JSR     L01C3E(PC)
       BEQ.S   L01078
       JSR     L01C56(PC)
       BNE.S   L010DA
       MOVE.W  $001C(A0),D0
       DIVU    $0026(A0),D0
       SUBQ.W  #1,D0
       MULU    $0026(A0),D0
       MOVE.W  D0,$0022(A0)
       MOVEQ   #$00,D0
L01078 SUBQ.W  #1,A4
L0107A BRA.S   L010DA

L0107C BSR.S   L01054   * delete one char: ctrl-left-right
       BNE.S   L01034
L01080 CMP.W   D6,D4
       BEQ.S   L01052
       SUBQ.W  #1,D4
       MOVE.W  D4,D0
       SUB.W   D6,D0
       MOVE.W  D0,D1
       BRA.S   L01092

L0108E MOVE.B  $0001(A4),(A4)+
L01092 DBF     D0,L0108E
       SUBA.W  D1,A4
       MOVE.L  $0022(A0),-(A7)
       MOVEQ   #$00,D7
       BSR.S   L010E0
       BNE.S   L010A6
       MOVEQ   #$20,D1
       BSR.S   L010AC
L010A6 MOVE.L  (A7)+,D7
       BSR.S   L010D0
       BRA.S   L01052

L010AC BSR     L00EFA   * position cursor
       BEQ.S   L010DA
       JSR     L01C32(PC)
       BEQ.S   L010DA
       TST.W   D7
       BLT.S   L010C8
       SUB.W   $0028(A0),D7
       BGE.S   L010C8
       ADD.W   $0028(A0),D7
       BRA.S   L01100

L010C8 JSR     L01BF8(PC)   * scroll if needed
       BRA.S   L010D8

L010CE BSR.S   L010DC
L010D0 SUBA.W  D4,A4
       ADDA.W  D6,A4
       MOVE.L  D7,$0022(A0)
L010D8 MOVEQ   #$00,D0
L010DA RTS

L010DC MOVE.L  $0022(A0),D7
L010E0 MOVEQ   #$00,D0
       MOVE.W  D4,D3
       SUB.W   D6,D3
       BRA.S   L010F4

L010E8 MOVE.B  (A4)+,D1
       MOVE.W  D3,-(A7)
       BSR.S   L010AC
       MOVE.W  (A7)+,D3
       TST.L   D0
       BNE.S   L010FC
L010F4 DBF     D3,L010E8
       MOVEQ   #$00,D3
       RTS

L010FC ADDA.W  D3,A4
       ADDQ.W  #1,D3
L01100 TST.L   D0
       RTS
        
* ----------End of line editor
        
L01104 DC.L    $0       * nothing left to link
       DC.L    L01186   * I/O net
       DC.L    L01114   * open net#
       DC.L    L01158   * close net#
       
L01114 SUBQ.W  #4,A7
       MOVEA.L A7,A3
       JSR     L0372C(PC)   * IO.DECODE
       BRA.S   L01154       *  ERROR
       BRA.S   L01154       *  ERROR
       BRA.S   L01132       *  SUCCESS

o1122  DC.W    $0003
       DC.B    'NET'
       DC.B    $00
       DC.W    2   * two parameters
       DC.W    2   * initialise to second 
       DC.B    'OI' 
       DC.B    ' _' 
       DC.W    0   * number
       
L01132 MOVE.W  #$120,D1
       JSR     L02FAE(PC)   * MM.ALCHP
       BNE.S   L01154
       MOVE.B  $0003(A7),$0018(A0)
       MOVE.B  $0037(A6),$0019(A0)  * SV.NETNR
       MOVE.B  $0001(A7),$001C(A0)
       SUBQ.B  #2,$001C(A0)
       MOVEQ   #$00,D0
L01154 ADDQ.W  #4,A7
       RTS

L01158 TST.B   $001C(A0)   * close net
       BGE.S   L0117E
       MOVE.B  #$01,$001C(A0)
       MOVE.B  $011F(A0),$001D(A0)
L0116A TST.B   $00EE(A6)   * SV.MDRUN
       BNE.S   L0116A
       MOVE.W  #$0578,D4
L01174 JSR     L05538
       DBEQ    D4,L01174
L0117E JMP     L0305E(PC)    * MT.RECHP

L01182 MOVEQ   #-$0F,D0
       RTS

L01186 JSR     L0388C(PC)    * IO.SERIO for net#

L0118A
       DC.L   L01198       * test byte
       DC.L   L011C4       * read
       DC.L   L011D0       * write
       RTS                 * if error: back

L01198 MOVE.B  $001C(A0),D0   * test byte
       BLT.S   L01182
       MOVEQ   #$00,D2
       MOVE.B  $011F(A0),D2
       MOVE.B  $20(A0,D2.W),D1
       SUB.B   $001D(A0),D2
       BCS.S   L011CC
       TST.B   D0
       BEQ.S   L011B6
       MOVEQ   #-$0A,D0
       RTS

L011B6 SF      $011F(A0)
       JSR     L054A2
       BEQ.S   L01198
       RTS

L011C4 BSR.S   L01198   * read net#
       BNE.S   L011CE
       ADDQ.B  #1,$011F(A0)
L011CC MOVEQ   #$00,D0
L011CE RTS

L011D0 TST.B   $001C(A0)   * write net#
       BGE.S   L01182
       MOVEQ   #$01,D2
       ADD.B   $011F(A0),D2
       BCC.S   L011F8
       MOVE.B  D1,-(A7)
       MOVE.W  #$00FF,$001C(A0)
       JSR     L05538
       MOVE.B  (A7)+,D1
       ST      $001C(A0)
       TST.L   D0
       BNE.S   L011CE
       MOVEQ   #$01,D2
L011F8 MOVE.B  D1,$1F(A0,D2.W)
       MOVE.B  D2,$011F(A0)
       BRA.S   L011CC

L01202 
       DC.L    L02D00   * pointer to list of scheduler tasks
       DC.L    L0120A   * pointer to first task

L0120A MOVE.L  $004C(A6),D4   * SV.KEYQ
       BEQ.S   L0122E
       MOVEA.L D4,A0
       LEA     -$0068(A0),A0
       MOVE.W  $00AA(A6),D4   * SV.FSTAT
       TST.B   $0043(A0)
       BEQ.S   L01228
       SUB.W   D3,D4
       BGT.S   L0122A
       JSR     L01BA2(PC)     * show cursor (flash)
L01228 MOVEQ   #$0C,D4
L0122A MOVE.W  D4,$00AA(A6)   * SV.FSTAT
L0122E RTS

      include flp1_mdv_main

* clock-traps       

TR1d13
TR1d14
TR1d15
XLtr1d13 EQU TR1d13
XLtr1d14 EQU TR1d13
XLtr1d15 EQU TR1d15

L0195A  LEA     $00018000,A0

L01960 MOVE.L  (A0),D2
       CMP.L   (A0),D2
       BNE.S   L01960
       CMPI.B  #$14,D0
       BGT.S   L01972
       BEQ.S   L01974
       MOVE.L  D2,D1
       BRA.S   L0198E

L01972 ADD.L   D2,D1       * adjust
L01974 SF      (A0)+
       MOVEQ   #-$11,D0
       MOVEQ   #$03,D3
L0197A ROL.L   #8,D1
       MOVEQ   #$00,D2
       MOVE.B  D1,D2
       BRA.S   L01984
L01982 MOVE.B  D0,(A0)
L01984 DBF     D2,L01982
       ROR.B   #1,D0
       DBF     D3,L0197A

L0198E BRA     L003A4


***********************
*
* START SCREEN + CON
*
***********************
*
* screen printing routine for trap 3 d0=5 or d0 = [$09 - $36]
* this routine is extremely slow - it should be speeded up
*
***********************

L01992 MOVE.B  $0043(A0),-(A7) * cursor status 
       BLE.S   L019A4       * cursor inactiv
       MOVEM.W D0-D2,-(A7)  * calling params of TRAP 3
       JSR     L01BA2(PC)   * get cursor positon
       MOVEM.W (A7)+,D0-D2
L019A4 CMPI.B  #$05,D0      * is Trap3 d0=5 ?
       BNE.S   L019B0       * no
       JSR     L01A4C(PC)   * execute trap 
       BRA.S   L019CE

L019B0 CMPI.W  #$0036,D0   * d0>36
       BHI.S   L019EE
       CMPI.W  #$0009,D0   * do<9
       BLT.S   L019EE
       BGT.S   L019C2
       JSR     (A2)        * sd.extop: do userroutine
       BRA.S   L019CE

L019C2 ADD.B   D0,D0       * adjust d0 for displacement
       MOVEA.W L019F2-$14(PC,D0.W),A3   * !!!must depend on 19F2
       LSR.L   #1,D0
       JSR     L019f2-$60(PC,A3.W)      * !!! $60=Tr3disp
L019CE TST.B   (A7)+       * test cursor status
       BLE.S   L019E8      * inactiv
       TST.L   D0          * any errors?
       BNE.S   L019E8
       TST.B   $0043(A0)   * again: test cursor status
       BGE.S   L019E8      * inactiv
       MOVEM.L D0-D2,-(A7) * save cursor status
       JSR     L01B86(PC)  * reposition cursor
       MOVEM.L (A7)+,D0-D2
L019E8 TST.L   D0
       RTS

Tr3D1c
Tr3D1d
XTr3D1c EQU Tr3D1c
XTr3D1d EQU Tr3D1c

L019EC ADDQ.L  #4,A7
L019EE MOVEQ   #-$0F,D0
       BRA.S   L019CE

L019F2 
Tr3disp equ L019F2-$60

       DC.W    XTr3D0a-Tr3disp
       DC.W    XTr3D0b-Tr3disp
       DC.W    XTr3D0c-Tr3disp
       DC.W    XTr3D0d-Tr3disp
       DC.W    XTr3D0e-Tr3disp
       DC.W    XTr3D0f-Tr3disp
       DC.W    XTr3D10-Tr3disp
       DC.W    XTr3D11-Tr3disp
       DC.W    XTr3D12-Tr3disp
       DC.W    XTr3D13-Tr3disp
       DC.W    XTr3D14-Tr3disp
       DC.W    XTr3D15-Tr3disp
       DC.W    XTr3D16-Tr3disp
       DC.W    XTr3D17-Tr3disp
       DC.W    XTr3D18-Tr3disp
       DC.W    XTr3D19-Tr3disp
       DC.W    XTr3D1a-Tr3disp
       DC.W    XTr3D1b-Tr3disp
       DC.W    XTr3D1c-Tr3disp
       DC.W    XTr3D1d-Tr3disp
       DC.W    XTr3D1e-Tr3disp
       DC.W    XTr3D1f-Tr3disp
       DC.W    XTr3D20-Tr3disp
       DC.W    XTr3D21-Tr3disp
       DC.W    XTr3D22-Tr3disp
       DC.W    XTr3D23-Tr3disp
       DC.W    XTr3D24-Tr3disp
       DC.W    XTr3D25-Tr3disp
       DC.W    XTr3D26-Tr3disp
       DC.W    XTr3D27-Tr3disp
       DC.W    XTr3D28-Tr3disp
       DC.W    XTr3D29-Tr3disp
       DC.W    XTr3D2a-Tr3disp
       DC.W    XTr3D2b-Tr3disp
       DC.W    XTr3D2c-Tr3disp
       DC.W    XTr3D2d-Tr3disp
       DC.W    XTr3D2e-Tr3disp
       DC.W    XTr3D2f-Tr3disp
       DC.W    XTr3D30-Tr3disp
       DC.W    XTr3D31-Tr3disp
       DC.W    XTr3D32-Tr3disp
       DC.W    XTr3D33-Tr3disp
       DC.W    XTr3D34-Tr3disp
       DC.W    XTr3D35-Tr3disp
       DC.W    XTr3D36-Tr3disp
             
Tr3D05
XTr3D05 EQU Tr3D05
L01A4C JSR     L01BCE(PC)     * trap#3,D0 = 05
       BLT.S   L01A76
       MOVE.B  D1,D2
       MOVE.L  $0018(A0),D0   * window topleftside
       ADD.L   $0022(A0),D0   * cursor position
       MOVE.W  D0,D1
       SWAP    D0
       MOVE.B  $0042(A0),D3   * arguments for printing like
* underline, strip, colour, size etc. are now in D3

       LEA     $003A(A0),A1    * strip colour mask
       MOVEM.L $002A(A0),A2-A3 * font adress
       JSR     L02840(PC)      * prin char
       BRA     L01C48          * cursor-movement
L01A76 RTS

Tr3D0a
XTr3D0a EQU Tr3D0A
L01A78 
       JSR     L01BF2(PC)      * trap#3,D0 = 0A
       MOVE.L  $001C(A0),(A1)
       MOVE.L  $0022(A0),$0004(A1)
       MOVEQ   #$00,D0
       RTS

Tr3D0b
XTr3D0B EQU Tr3D0B
L01A8A 
       BSR.S   L01A78     * trap#3,D0 = 0B
       MOVE.L  D1,-(A7)
       MOVE.W  $0026(A0),D0
       BSR.S   L01AAA
       BSR.S   L01AAA
       SUBQ.W  #6,A1
       MOVE.W  $0028(A0),D0
       BSR.S   L01AAA
       BSR.S   L01AAA
       MOVE.L  (A7)+,D1
       SUBA.W  #$000A,A1
       MOVEQ   #$00,D0
       RTS

L01AAA MOVEQ   #$00,D1
       MOVE.W  (A1),D1
       DIVU    D0,D1
       MOVE.W  D1,(A1)
       ADDQ.W  #4,A1
       RTS

L01AB6  
Tr3D0d
XTr3D0d EQU Tr3D0d
       MOVEM.W D1-D4,-(A7)     * trap#3,D0 = 0D
       JSR     L01C1C(PC)
       MOVEM.W (A1),D0-D3
       EXG     D0,D2
       EXG     D1,D3
       MOVEQ   #$00,D4
       BCLR    D4,D0
       BCLR    D4,D2
       TST.W   D2
       BEQ     L01B64
       TST.W   D3
       BEQ     L01B64
       MOVE.W  D0,D4
       ADD.W   D2,D4
       BCS     L01B64
       CMPI.W  #$0200,D4
       BHI.S   L01B64
       MOVE.W  D1,D4
       ADD.W   D3,D4
       BCS.S   L01B64
       CMPI.W  #$0100,D4
       BHI.S   L01B64
       CLR.W   $0020(A0)
       BRA.S   L01B12

* set border
Tr3D0c
XTr3D0c equ Tr3D0c
L01AF8 MOVE.B  D1,$0047(A0)     * trap#3,D0 = 0C
L01AFC MOVEM.W D1-D4,-(A7)
       CMP.W   $0020(A0),D2
       BEQ.S   L01B0A
       JSR     L01C1C(PC)
L01B0A MOVEM.W $0018(A0),D0-D4
       BSR.S   L01B6C
L01B12 MOVE.W  $0002(A7),D4
       CMPI.W  #$0100,D4
       BHI.S   L01B64
       BSR.S   L01B6E
       MOVEM.W D0-D4,$0018(A0)
       BEQ.S   L01B60
       MOVE.W  (A7),D1
       CMPI.B  #$80,D1
       BEQ.S   L01B60
       MOVEA.L A7,A1
       JSR     L027D8(PC)
       MOVE.W  $001A(A0),D1
       BSR.S   L01B6C
       NEG.W   D4
       EXG     D4,D3
       JSR     L025BE(PC)
       ADD.W   D4,D1
       SUB.W   D3,D1
       JSR     L025BE(PC)
       ADD.W   D3,D1
       SUB.W   D4,D1
       EXG     D4,D3
       ADD.W   D4,D4
       EXG     D4,D2
       JSR     L025BE(PC)
       ADD.W   D4,D0
       SUB.W   D2,D0
       JSR     L025BE(PC)
L01B60 MOVEQ   #$00,D0
       BRA.S   L01B66

L01B64 MOVEQ   #-$04,D0      * 'out of range'
L01B66 MOVEM.W (A7)+,D1-D4
       RTS
        
L01B6C NEG.W   D4
L01B6E ADD.W   D4,D1
       ADD.W   D4,D4
       SUB.W   D4,D3
       BLE.S   L01B82
       ADD.W   D4,D0
       ADD.W   D4,D4
       SUB.W   D4,D2
       BLE.S   L01B82
       ASR.W   #2,D4
       RTS

L01B82 ADDQ.W  #4,A7
       BRA.S   L01B64

Tr3D0e
XTr3D0e EQU Tr3D0e
L01B86 MOVEQ   #$01,D2
       TST.B   $0043(A0)
       BGT.S   L01BCA
       JSR     L01BF2(PC)
       BRA.S   L01BAA

Tr3D0f
XTr3D0f EQU Tr3D0f
L01B94 MOVEQ   #$00,D2
       TST.B   $0043(A0)
       BGT.S   L01BAA
       MOVE.B  D2,$0043(A0)
       BRA.S   L01BCA

L01BA2 MOVE.B  $0043(A0),D2
       BEQ.S   L01BCA
       NEG.B   D2
L01BAA JSR     L01BCE(PC)
       BLT.S   L01BCC
       MOVE.B  D2,$0043(A0)
       MOVE.L  $0018(A0),D0
       ADD.L   $0022(A0),D0
       MOVE.W  D0,D1
       SWAP    D0
       MOVEM.W $0026(A0),D2-D3
       JSR     L02548(PC)
L01BCA MOVEQ   #$00,D0
L01BCC RTS

L01BCE MOVE.L  $0022(A0),D0     * verify cursor in window
       BMI.S   L01BEE
       TST.W   D0
       BMI.S   L01BEE
       ADD.L   $0026(A0),D0
       CMP.W   $001E(A0),D0
       BHI.S   L01BEE
       SWAP    D0
       CMP.W   $001C(A0),D0
       BHI.S   L01BEE
       MOVEQ   #$00,D0
       RTS

L01BEE MOVEQ   #-$04,D0    * out of range
       RTS

Tr3D2f
XTr3D2f EQU Tr3D2f
L01BF2 TST.B   $0048(A0)
       BEQ.S   L01C1A
L01BF8 MOVEM.L D0-D2/A1,-(A7)
       JSR     L01C32(PC)
       BEQ.S   L01C12
       MOVEQ   #$18,D0
       MOVE.W  $0028(A0),D1
       NEG.W   D1
       JSR     L01CBE(PC)
       CLR.W   $0022(A0)
L01C12 SF      $0048(A0)
       MOVEM.L (A7)+,D0-D2/A1
L01C1A RTS

L01C1C CLR.L   $0022(A0)
       BRA.S   L01C9A

Tr3D10
XTr3D10 EQU Tr3D10
       MULU    $0028(A0),D2
       BRA.S   L01C2C

Tr3D11
XTr3D11 EQU Tr3D11
       MOVE.W  $0024(A0),D2
L01C2C MULU    $0026(A0),D1
       BRA.S   L01C6C

Tr3D12
XTr3D12 EQU Tr3D12
L01C32 MOVEQ   #$00,D1
       MOVE.W  $0024(A0),D2
       ADD.W   $0028(A0),D2
       BRA.S   L01C6C

Tr3D13
XTr3D13 EQU Tr3D13
L01C3E MOVE.W  $0022(A0),D1
       SUB.W   $0026(A0),D1
       BRA.S   L01C50

Tr3D14
XTr3D14 EQU Tr3D14
* cursor-movement
L01C48 MOVE.W  $0022(A0),D1
       ADD.W   $0026(A0),D1
L01C50 MOVE.W  $0024(A0),D2
       BRA.S   L01C6C

Tr3D15
XTr3D15 EQU Tr3D15
L01C56 MOVE.W  $0024(A0),D2
       SUB.W   $0028(A0),D2
       BRA.S   L01C68

Tr3D16
XTr3D16 EQU Tr3D16
       MOVE.W  $0024(A0),D2
       ADD.W   $0028(A0),D2
L01C68 MOVE.W  $0022(A0),D1
Tr3D17
XTr3D17 EQU Tr3D17
L01C6C MOVE.W  D1,D0
       BLT.S   L01CA2
       ADD.W   $0026(A0),D0
       CMP.W   $001C(A0),D0
       BHI.S   L01CA2
       MOVE.W  D2,D0
       BLT.S   L01CA2
       ADD.W   $0028(A0),D0
       CMP.W   $001E(A0),D0
       BHI.S   L01CA2
L01C88 BTST    #$03,$0034(A6)   * SV.MCSTA
       BEQ.S   L01C94
       BCLR    #$00,D1
L01C94 MOVEM.W D1-D2,$0022(A0)
L01C9A SF      $0048(A0)
       MOVEQ   #$00,D0
       RTS

L01CA2 MOVEQ   #-$04,D0
       RTS

Tr3D26
XTr3D26 EQU Tr3D26
       MOVEQ   #$00,D0
       LEA     L025D6(PC),A2
       BRA.S   L01CE0

Tr3D20
XTr3D20 EQU Tr3D20
L01CAE JSR     L01C1C(PC)
       MOVEQ   #$20,D0
Tr3D21
Tr3D22
Tr3D23
Tr3D24
XTr3D21 EQU Tr3D21
XTr3D22 EQU Tr3D22
XTr3D23 EQU Tr3D23
XTr3D24 EQU Tr3D24
       SUBI.W  #$0020,D0
       LEA     L025BE(PC),A2
       BRA.S   L01CDC

Tr3D18
Tr3D19
Tr3D1a
XTr3D18 EQU Tr3D18
XTr3D19 EQU Tr3D19
XTr3D1a EQU Tr3D1a
L01CBE SUBI.W  #$0018,D0
       LEA     L025FE(PC),A2
       BRA.S   L01CDC
Tr3D1b
Tr3D1e
Tr3D1f
XTr3D1b EQU Tr3D1b
XTr3D1e EQU Tr3D1b
XTr3D1f EQU Tr3D1b
       SUBI.W  #$001B,D0
       LEA     L02648(PC),A2
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BEQ.S   L01CDC
       BCLR    #$00,D1
L01CDC LEA     $0036(A0),A1
L01CE0 MOVEM.L D4-D5,-(A7)
       MOVE.W  D1,D4
       MOVE.W  D0,D5
       MOVEM.W $0018(A0),D0-D3
       SUBQ.W  #1,D5
       BLT.S   L01D22
       BGT.S   L01CFA
       MOVE.W  $0024(A0),D3
       BRA.S   L01D22

L01CFA ADD.W   $0024(A0),D1
       SUBQ.W  #2,D5
       BGE.S   L01D12
       SUB.W   $0024(A0),D3
       MOVE.W  $0028(A0),D5
       ADD.W   D5,D1
       SUB.W   D5,D3
       BLE.S   L01D24
       BRA.S   L01D22

L01D12 MOVE.W  $0028(A0),D3
       TST.W   D5
       BEQ.S   L01D22
       ADD.W   $0022(A0),D0
       SUB.W   $0022(A0),D2
L01D22 JSR     (A2)
L01D24 MOVEQ   #$00,D0
       MOVEM.L (A7)+,D4-D5
       RTS
Tr3D2e
XTr3D2e EQU Tr3D2e
       LEA     L025BE(PC),A3
       BTST    #$03,$0042(A0)
       BEQ.S   L01D3C
       LEA     L025CA(PC),A3
L01D3C MOVEA.L A1,A2
       SUBQ.W  #4,A7
       MOVEA.L A7,A1
       JSR     L027D8(PC)
       MOVE.L  #$01FF01FF,D3
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BEQ.S   L01D58
       BCLR    #$10,D3
L01D58 MOVEM.L (A2),D0/D2
       EXG     D0,D2
       AND.L   D3,D0
       AND.L   D3,D2
       MOVE.L  D0,D3
       ADD.L   D2,D3
       CMP.W   $001E(A0),D3
       BGT.S   L01D88
       SWAP    D3
       CMP.W   $001C(A0),D3
       BGT.S   L01D88
       ADD.L   $0018(A0),D0
       MOVE.W  D2,D3
       SWAP    D2
       MOVE.W  D0,D1
       SWAP    D0
       JSR     (A3)
       MOVEQ   #$00,D0
L01D84 ADDQ.W  #4,A7
       RTS

L01D88 MOVEQ   #-$04,D0
       BRA.S   L01D84
       
Tr3D25
XTr3D25 EQU Tr3D25
       MOVE.L  A1,D0
       BGT.S   L01D96
       LEA     L0AD9A,A1        * PIXEL F§R SCREEN
L01D96 MOVE.L  A2,D0
       BGT.S   L01DA0
       LEA     L0B106,A2        * PIXEL-ADRESSEN
L01DA0 MOVEM.L A1-A2,$002A(A0)
       MOVEQ   #$00,D0
       RTS

Tr3D27
Tr3D28
Tr3D29
XTr3D27 EQU Tr3D27
XTr3D28 EQU Tr3D28
XTr3D29 EQU Tr3D29
       SUBI.W  #$0027,D0
       MOVE.B  D1,$44(A0,D0.W)
       LSL.W   #2,D0
       LEA     $36(A0,D0.W),A1
       MOVEQ   #$00,D0
       JMP     L027D8(PC)

Tr3D2a
XTr3D2a EQU Tr3D2a
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BEQ     L01E3C
       MOVEQ   #$02,D0
       BRA.S   L01DD4
Tr3D2c
XTr3D2c EQU Tr3D2c
       MOVEQ   #$0C,D0
       LSL.B   #2,D1
       BRA.S   L01E3E
Tr3D2b
XTr3D2b EQU Tr3D2b
       MOVEQ   #$01,D0
L01DD4 TST.B   D1
       SNE     D1
       BRA.S   L01E3E
Tr3D2d
XTr3D2d EQU Tr3D2d
       JSR     L01BF2(PC)
       ANDI.W  #$0003,D1
       ANDI.W  #$0001,D2
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BEQ.S   L01DF2
       BSET    #$01,D1
L01DF2 
       MOVE.B  L01E4E(PC,D1.W),$0027(A0)  * store horizontal increment
       MOVE.B  L01E52(PC,D2.W),$0029(A0)  * vertical increment
       LSL.B   #1,D1
       OR.B    D2,D1
       LSL.B   #4,D1
       MOVEQ   #$70,D0
       BSR.S   L01E3E
       MOVE.W  $0022(A0),D0
       ADD.W   $0026(A0),D0
       CMP.W   $001C(A0),D0
       BLS.S   L01E1A
       JSR     L01BF8(PC)
L01E1A MOVE.W  $0024(A0),D0
       ADD.W   $0028(A0),D0
       CMP.W   $001E(A0),D0
       BLS.S   L01E4A
       MOVEQ   #$18,D0
       MOVEQ   #-$0A,D1
       JSR     L01CBE(PC)
       SUBI.W  #$000A,$0024(A0)
       BGE.S   L01E4A
       CLR.W   $0024(A0)
L01E3C BRA.S   L01E4A

L01E3E AND.B   D0,D1
       NOT.B   D0
       AND.B   D0,$0042(A0)
       OR.B    D1,$0042(A0)
L01E4A MOVEQ   #$00,D0
       RTS

L01E4E DC.L    $06080C10    * 6,8,12,16 pixels
L01E52 DC.W    $0A14        * 10,20 pixels

Tr3D36
XTr3D36 EQU Tr3D36
       LEA     $0018(A1),A4
       JSR     L021DC(PC)
       MOVE.L  L02242(PC),-(A1)
       MOVE.W  L02240(PC),-(A1)
       JSR     L020D8(PC)
       LEA     L01E90(PC),A3
       JSR     L0419E(PC)
       LEA     $0018(A1),A1
       BSR.S   L01E8A
       MOVE.W  (A1)+,D1
       BSR.S   L01E8A
       MOVE.W  $001E(A0),D2
       SUB.W   (A1)+,D2
       BSET    #$07,$0042(A0)
       JMP     L01C88(PC)

L01E8A MOVEQ   #$02,D0
       JMP     L04196(PC)

* table for calculation of pixel-graphics

L01E90 DC.W    $1210
       DC.W    $16EE
       DC.W    $DC0C
       DC.W    $0EFA
       DC.W    $0CFB
       DC.W    $E8E2
       DC.W    $0C0E
       DC.W    $0EF4
       DC.W    $0AF5
       DC.W    $0000

Tr3D34
XTr3D34 EQU Tr3D34
       LEA     $004A(A0),A2
       MOVEQ   #$12,D0
L01EAA MOVE.W  (A1)+,(A2)+
       SUBQ.W  #2,D0
       BNE.S   L01EAA
       RTS

Tr3D35
XTr3D35 EQU Tr3D35
       MOVEA.L A0,A4
       TST.L   D1
       BNE.S   L01EC2
       BSR.S   L01EFA
       MOVE.B  #$00,$0049(A4)
       BRA.S   L01EF4

L01EC2 CMPI.L  #1,D1
       BNE.S   L01EE4
       BSR.S   L01EFA
       MOVE.B  #$01,$0049(A4)
       MOVE.L  #$410,D1
       JSR     L02FAE(PC)   * MM.ALCHP
       BNE.S   L01EF6
       MOVE.L  A0,$005C(A4)
       BRA.S   L01EF4

L01EE4 BTST    #$00,D1
       BEQ.S   L01EF0
       CLR.L   $0060(A4)
       BRA.S   L01EF4

L01EF0 MOVE.L  D1,$0060(A4)
L01EF4 MOVEQ   #$00,D0
L01EF6 MOVEA.L A4,A0
       RTS

L01EFA TST.B   $0049(A4)
       BEQ.S   L01F08
       MOVEA.L $005C(A4),A0
       JSR     L0305E(PC)    * MT.RECHP
L01F08 RTS

Tr3D30
XTr3D30 EQU Tr3D30
       MOVE.L  A4,-(A7)
       LEA     $000C(A1),A4
       MOVE.L  -(A4),-(A1)
       MOVE.L  -(A4),-(A1)
       MOVE.L  -(A4),-(A1)
       MOVEA.L (A7)+,A4
Tr3D31
XTr3D31 EQU Tr3D31
       MOVEM.L A3/A5,-(A7)
       LEA     L01F26(PC),A3
       SUBQ.L  #6,A1
       BRA     L02100

L01F26 DC.W    $0001       !!! displ. for point and line ROUTINE 1
       DC.W    XL01F45-*   !!! LAST ADDR. OF OPERATION TABLE          
       DC.W    XL0205C-*   !!! first routine for calculation
       DC.W    XL01F38-*   !!! ADRESS OF 2. OP. TABLE
       DC.W    XL02136-*   !!! second routine for calcul.

L01F38
XL01F38 EQU L01F38
       DC.L    $DC16D00C
       DC.L    $16161616
       DC.L    $E8F40CBE
       DC.L    $0EFAEE0C
       DC.L    $BE0EDC16
L01F44 DC.B    $16
       DC.B    $00

XL01F45 EQU L01F44+1  !!! TO HAVE LABELS ON EVEN ADDR.


Tr3D32
XTr3D32 EQU Tr3D32
       MOVEM.L A3/A5,-(A7)
       LEA     $0002(A1),A4
       TST.L   (A4)+
       BGT.S   L01F64
       MOVEQ   #$14,D0
       JSR     L04196(PC)
       MOVEM.L (A4)+,D2-D7
       MOVEM.L D2-D4,-(A4)
       MOVEM.L D5-D7,-(A4)
L01F64 LEA     L01F6C(PC),A3
       BRA     L02100

* displacement for arc-routines

L01F6C DC.W    $0003      ROUTINE AND TABLE
       DC.W    XL01F45-*  LAST ADDR OF OPERATION TABLE
       DC.W    XL0205C-*  first calculation routine
of72   DC.W    XL01F7E-*  table of operators
       DC.W    XL01FA8-*  calcul. routine
of76   DC.W    XL01FD0-*  oper. table
       DC.W    XL01FCE-*  calcul rout (RTS)
of7A   DC.W    XL021EA-*  oper. table
       DC.W    XL02136-*  calcul routine

L01F7E 
XL01F7E EQU L01F7E
       DC.W    $FAEE
       DC.W    $0CE2
       DC.W    $C40E
       DC.W    $B810
       DC.W    $D00A
       DC.W    $F4E8
       DC.W    $0C16
       DC.W    $160E
       DC.W    $A616
       DC.W    $0E0A
       DC.W    $E2CA
       DC.W    $101A
       DC.W    $160A
       DC.W    $160E
       DC.W    $1016
       DC.W    $289A
       DC.W    $A6B2
       DC.W    $0A10
       DC.W    $24E2
       DC.W    $CA10
       DC.W    $0C00

L01FA8 
XL01FA8 EQU L01FA8 
       TST.B   -$0058(A4)
L01FAC BMI.S   L01FBC
       MOVE.L  L0224E(PC),-(A1)
       MOVE.W  L0224C(PC),-(A1)
       MOVEQ   #$0A,D0
       BSR     L04196
L01FBC MOVE.L  -$001E(A4),D0
       SWAP    D0
       SUBQ.W  #1,D0
       SWAP    D0
       CMP.L   L0224C(PC),D0
       BLT.S   L01FCE
       CLR.L   D2
L01FCE RTS
XL01FCE  EQU  L01FCE

L01FD0
XL01FD0 EQU L01FD0
       DC.W    $16E2
       DC.W    $0A16
       DC.W    $0A18
       DC.W    $D00A
       DC.W    $A716
       DC.W    $1816
       DC.W    $8E0E
       DC.W    $CA8E
       DC.W    $1016
       DC.W    $B9B3
       DC.W    $881A
       DC.W    $168E
       DC.W    $0E89
       DC.W    $8F94
       DC.W    $9B00

Tr3D33
XTr3D33 EQU Tr3D33
       MOVEM.L A3/A5,-(A7)
       LEA     L01FFC(PC),A3
       BRA     L02100
L01FFA RTS
XL01FFA EQU L01FFA
L01FFC DC.W    $0003    
o1fe   DC.W    XL0200E-*
       DC.W    XL02018-*
o202   DC.W    XL02017-*
       DC.W    XL0205C-*
o206   DC.W    XL0203A-*
       DC.W    XL01FFA-*
o20a   DC.W    XL021EA-*
       DC.W    XL02136-*

L0200E 
XL0200E EQU L0200E
       DC.W    $E812
       DC.W    $E9EE
       DC.W    $EE12
       DC.W    $E80E
       DC.W    $EF00

L02018
XL02017 EQU L02018-1
XL02018 EQU L02018

       CMPI.W  #$0801,(A1)
       ADDQ.W  #6,A1
       BGE.S   L02032
       MOVE.L  #$6487ED51,-(A1)
       MOVE.W  #$0801,-(A1)
       LEA     L02034(PC),A3
       JSR     L0419E(PC)
L02032 RTS

* table for ellipse-operations
L02034 DC.W    $0AEE
       DC.W    $E8EF
       DC.W    $E900
L0203A
XL0203A EQU L0203A
       DC.W    $DCC4
       DC.W    $160A
       DC.W    $E816
       DC.W    $0EEE
       DC.W    $160E
       DC.W    $E21A
       DC.W    $16E8
       DC.W    $0E16
       DC.W    $FA0A
       DC.W    $16FB
       DC.W    $EFE2
       DC.W    $1816
       DC.W    $E80E
       DC.W    $1614
       DC.W    $F40A
       DC.W    $16F5
       DC.W    $E900

L0205C 
XL0205C EQU L0205C
       MOVEM.L D0-D1/A4,-(A7)
       CLR.L   -(A1)
       CLR.W   -(A1)
       MOVEQ   #$01,D0
       ROR.L   #2,D0
       MOVE.W  #$0800,D1
       MOVEQ   #$04,D2
L0206E MOVE.L  D0,-(A1)
       MOVE.W  D1,-(A1)
       ADDQ.W  #1,D1
       DBF     D2,L0206E
       ADDQ.W  #1,(A1)
       LEA     L02252(PC),A3
       MOVEQ   #$08,D2
L02080 MOVE.W  -(A3),-(A1)
       DBF     D2,L02080
       MOVE.W  $001C(A0),-$001A(A6)
       MOVE.W  $001E(A0),-$001E(A6)
       CLR.W   -$001C(A6)
       CLR.W   -$0020(A6)
       MOVE.W  $0018(A0),-$0034(A6)
       MOVE.W  $001A(A0),-$0038(A6)
       CLR.W   -$0036(A6)
       CLR.W   -$003A(A6)
       MOVE.B  $0042(A0),-$0023(A6)
       MOVE.B  $0049(A0),-$0032(A6)
       MOVE.L  $005C(A0),-$002A(A6)
       MOVE.L  $0060(A0),-$002E(A6)
       MOVEQ   #$01,D2
       BSR.S   L020D8
       LEA     L020EE(PC),A3
       BSR     L0419E
       MOVEM.L (A7)+,D0-D1/A4
       RTS

L020D8 MOVE.W  $001E(A0),-(A1)
       SUBQ.W  #1,(A1)
       MOVEQ   #$08,D0
       BSR     L04196
       MOVE.L  $0058(A0),-(A1)
       MOVE.W  $0056(A0),-(A1)
       RTS

L020EE 
*operation table for coordinates
       DC.L     $121016FA
       DC.L     $0EFB16F4
       DC.L     $0EF516EE
       DC.L     $0EEFE80E
       DC.W     $E900
       
L02100 MOVEM.L D1-D7/A0/A2/A4-A6,-(A7)
       DC.L    $4E56FFC6     * SHOULD BE: LINK A6,$FFC6 WHAT ASM REFUSED
       LEA     $001E(A1),A4
       MOVE.W  (A3)+,D1
L0210E PEA     $0002(A3)
       ADDA.W  (A3),A3
       BSR     L0419E
       MOVEA.L (A7)+,A3
       PEA     $0002(A3)
       ADDA.W  (A3),A3
       JSR     (A3)
       MOVEA.L (A7)+,A3
       DBF     D1,L0210E
       UNLK    A6
       MOVEM.L (A7)+,D1-D7/A0/A2/A4-A6
       MOVEM.L (A7)+,A3/A5
       MOVEQ   #$00,D0
       RTS
       
L02136
XL02136 EQU L02136
       MOVEM.L D0-D1/A3,-(A7)
       TST.L   D2
       BEQ     L021C4
       MOVE.L  D2,-$0010(A6)
       MOVEQ   #-$01,D3
       BTST    #$03,$00028034
       BEQ.S   L02158
       ADD.L   D2,D2
       LSL.L   #1,D3
       ADDQ.W  #1,-$0030(A4)
L02158 MOVE.W  D3,-$0022(A6)
       NEG.L   D2
       MOVE.L  D2,-$0004(A6)
       MOVE.L  D2,-$000C(A6)
       CLR.L   -$0008(A6)
       BSR     L020D8
       MOVEQ   #$10,D0
       BSR     L04196
       BSR.S   L021DC
       LEA     L02218(PC),A3
       BSR     L0419E
       BSR.S   L021CA
       MOVE.L  D1,D2
       BSR.S   L021CA
       MOVE.L  D1,D3
       BSR.S   L021CA
       MOVE.L  D1,D4
       BSR.S   L021CA
       MOVE.L  D1,D6
       BSR.S   L021CA
       MOVE.L  D1,D7
       LEA     -$0060(A4),A1
       BSR.S   L021D6
       MOVEA.W (A1)+,A5
       LEA     -$0018(A4),A1
       BSR.S   L021D2
       MOVE.L  (A1)+,-$0018(A6)
       BSR.S   L021D2
       MOVE.L  (A1)+,D1
       AND.W   -$0022(A6),D1
       MOVE.L  D1,-$0014(A6)
       BSR.S   L021D2
       MOVE.L  (A1)+,D1
       BSR.S   L021D2
       MOVE.L  (A1)+,D0
       AND.W   -$0022(A6),D0
       BSR     L02252
       BSR     L022CA
L021C4 MOVEM.L (A7)+,D0-D1/A3
       RTS

L021CA ADDQ.W  #4,(A1)
       BSR.S   L021D2
       MOVE.L  (A1)+,D1
       RTS

L021D2 MOVEQ   #$06,D0
       BRA.S   L021D8


L021D6 MOVEQ   #$02,D0
L021D8 JMP     L04196(PC)


L021DC MOVE.L  $0052(A0),-(A1)
       MOVE.L  $004E(A0),-(A1)
       MOVE.L  $004A(A0),-(A1)
       RTS

*table to calculate convex. of arc & ellipse
L021EA
XL021EA EQU L021EA
       DC.W    $949A
       DC.W    $0C82
       DC.W    $0E8E
       DC.W    $0E8E
       DC.W    $160E
       DC.W    $169A
       DC.W    $0E82
       DC.W    $160E
       DC.W    $169A
       DC.W    $0E70
       DC.W    $940E
       DC.W    $0A71
       DC.W    $940E
       DC.W    $0A16
       DC.W    $7C0E
       DC.W    $7688
       DC.W    $0E0A
       DC.W    $1470
       DC.W    $880E
       DC.W    $767C
       DC.W    $0E0A
       DC.W    $837D
       DC.W    $0000
L02218 DC.W    $640E
       DC.W    $1416
       DC.W    $F40A
       DC.W    $F5E8
       DC.W    $0AE9
       DC.W    $0E14
       DC.W    $16FA
       DC.W    $0AAC
       DC.W    $0EFB
       DC.W    $EE0A
       DC.W    $AC0E
       DC.W    $EFD0
       DC.W    $AC10
       DC.W    $1676
       DC.W    $0E77
       DC.W    $1682
       DC.W    $0E83
       DC.W    $160E
       DC.W    $700E
       DC.W    $7100
L02240 DC.W    $0801
L02242 DC.W    $56B8
       DC.L    $51EC07f7
       DC.L    $4189374C
L0224C DC.W    $0802
L0224E DC.L    $6487ED51
       
L02252 CMPA.L  #-1,A5
       BEQ.S   L02264
       TST.L   D2
       BEQ.S   L022C0
       TST.L   D3
       BEQ.S   L022C0
       BRA.S   L02266

L02264 SUBA.L  A5,A5
L02266 MOVEA.L D3,A1
       MOVEA.L D4,A2
       ADDA.L  A1,A2
       MOVEA.L D2,A3
       ADDA.L  D4,A3
       ADDA.L  A2,A3
       ADD.L   D4,D3
       NEG.L   D3
       ASR.L   #1,D3
       ADD.L   D7,D3
       MOVE.L  D6,D4
       SUB.L   D3,D4
       ASR.L   #2,D2
       NEG.L   D2
       SUB.L   D6,D2
       ASR.L   #1,D2
       ADD.L   D3,D2
       MOVE.L  A5,-(A7)
       MOVE.L  D2,-(A7)
       MOVE.L  D3,D7
       MOVE.L  D4,D6
       JSR     L02432(PC)
       MOVEA.L (A7)+,A0
       MOVEA.W #$0008,A4
       MOVE.B  #$FF,-$0024(A6)

L022A0 TST.L   D7
       BLT.S   L022A8
       TST.L   D6
       BGE.S   L022C6
L022A8 TST.B   -$0024(A6)
       BGE.S   L022B4
       BSR     L0238A
       BRA.S   L022B8

L022B4 BSR     L023D0
L022B8 CMPA.W  #$0000,A4
       BGT.S   L022A0
       ADDQ.L  #4,A7
L022C0 ADDQ.L  #4,A7
       JMP     L021C4(PC)

L022C6 MOVEA.L (A7)+,A4
       RTS

L022CA BSR     L0248A
       BSR.S   L02330
       MOVE.L  A0,D4
       BGE.S   L022E4
       MOVE.L  -$0004(A6),D4
       MOVE.L  -$0008(A6),D5
       SUB.L   A1,D7
       ADD.L   A2,D6
       ADDA.L  D7,A0
       BRA.S   L022F2


L022E4 MOVE.L  -$000C(A6),D4
       MOVE.L  -$0010(A6),D5
       SUB.L   A2,D7
       ADD.L   A3,D6
       SUBA.L  D6,A0
L022F2 ADD.L   D4,D0
       ADD.L   D5,D1
       TST.L   D5
       BGE.S   L02302
       ADDA.L  #$80,A5
       BRA.S   L0230A


L02302 BEQ.S   L0230C
       SUBA.L  #$80,A5
L0230A SWAP    D3
L0230C MOVEQ   #$01,D5
       BTST    #$03,$00028034
       BEQ.S   L0231A
       MOVEQ   #$02,D5
L0231A TST.L   D4
       BGE.S   L02326
       ROL.W   D5,D2
       BCC.S   L0232E
       SUBQ.L  #2,A5
       BRA.S   L0232E


L02326 BEQ.S   L0232E
       ROR.W   D5,D2
       BCC.S   L0232E
       ADDQ.L  #2,A5
L0232E BRA.S   L022CA


L02330 MOVE.W  A4,D4
       BLT.S   L02386
       SUBQ.W  #2,D4
       BGT.S   L02360
       MOVE.L  D1,D4
       SUB.L   -$0018(A6),D4
       BGE.S   L02342
       NEG.L   D4
L02342 SUBQ.L  #1,D4
       BGT.S   L02360
       MOVE.L  D0,D4
       SUB.L   -$0014(A6),D4
       BGE.S   L02350
       NEG.L   D4
L02350 BTST    #$03,$00028034

       BEQ.S   L0235C
       SUBQ.L  #1,D4
L0235C SUBQ.L  #1,D4
       BLE.S   L02386
L02360 TST.L   D7
       BNE.S   L02368
       TST.L   D6
       BEQ.S   L02386
L02368 BGE.S   L02376
       TST.B   -$0024(A6)
       BGT.S   L02376
       BSR     L0238A
       BRA.S   L02330


L02376 TST.L   D6
       BGE.S   L02388
       TST.B   -$0024(A6)
       BLT.S   L02388
       BSR     L023D0
       BRA.S   L02330


L02386 ADDQ.L  #4,A7
L02388 RTS

L0238A TST.L   -$0004(A6)
       BNE.S   L02394
       NEG.L   -$000C(A6)
L02394 TST.L   -$0008(A6)
       BNE.S   L0239E
       NEG.L   -$0010(A6)
L0239E MOVE.L  A1,D4
       NEG.L   D4
       MOVEA.L D4,A1
       ADD.L   A2,D4
       MOVEA.L D4,A2
       ADDA.L  A1,A2
       MOVE.L  D4,D5
       LSL.L   #2,D5
       SUB.L   A3,D5
       MOVEA.L D5,A3
       NEG.L   D7
       SUB.L   D4,D7
       MOVE.L  A0,D5
       NEG.L   D5
       SUB.L   D6,D5
       ADD.L   D7,D5
       MOVEA.L D5,A0
       SUB.L   D7,D6
       SUB.L   D7,D6
       SUB.L   D4,D6
       SUBQ.L  #1,A4
       MOVE.B  #$01,-$0024(A6)

       RTS

L023D0 TST.L   -$0008(A6)
       BNE.S   L023E2
       CLR.L   -$0004(A6)
       MOVE.L  -$0010(A6),-$0008(A6)

       BRA.S   L023F2


L023E2 TST.L   -$0004(A6)
       BNE.S   L023F2
       CLR.L   -$0008(A6)
       MOVE.L  -$000C(A6),-$0004(A6)

L023F2 MOVE.L  A2,D4
       LSL.L   #1,D4
       SUB.L   A3,D4
       MOVE.L  D4,D5
       SUB.L   A1,D5
       MOVEA.L D5,A1
       SUBA.L  A3,A2
       MOVE.L  A3,D5
       NEG.L   D5
       MOVEA.L D5,A3
       MOVE.L  A2,D5
       ASR.L   #1,D5
       NEG.L   D5
       ADD.L   D6,D5
       ADD.L   D5,D7
       MOVE.L  D6,D5
       ASR.L   #1,D5
       NEG.L   D5
       SUB.L   A0,D5
       ADD.L   D7,D5
       MOVEA.L D5,A0
       MOVE.L  A3,D5
       ASR.L   #3,D5
       ADDA.L  D5,A0
       NEG.L   D6
       ASR.L   #1,D4
       ADD.L   D4,D6
       SUBQ.L  #1,A4
       MOVE.B  #$FF,-$0024(A6)

       RTS

L02432 MOVEM.L D0-D1,-(A7)
       CLR.L   D2
       NEG.L   D1
       SUBQ.L  #1,D1
       MOVE.W  $001E(A0),D2
       ADD.W   $001A(A0),D2
       ADD.L   D2,D1
       MOVE.W  $0018(A0),D2
       ADD.L   D2,D0
       MOVE.L  $003E(A0),D3
       BTST    #$00,D1
       BEQ.S   L02458
       SWAP    D3
L02458 MOVEA.L #$00020000,A5

       LSL.L   #7,D1
       ADDA.L  D1,A5
       MOVE.L  D0,D1
       LSR.L   #3,D1
       LSL.L   #1,D1
       ADDA.L  D1,A5
       ANDI.W  #$000F,D0
       MOVEQ   #$00,D2
       MOVE.W  #$8080,D2
       BTST    #$03,$00028034

       BEQ.S   L02482
       MOVE.W  #$C0C0,D2
L02482 ROR.W   D0,D2
       MOVEM.L (A7)+,D0-D1
       RTS

L0248A CMP.L   -$0020(A6),D1
       BCC     L02546
       TST.B   -$0032(A6)
       BEQ     L0251C
       MOVEM.L D0-D3/A0-A1,-(A7)
       MOVEA.L D1,A0
       ADDA.L  A0,A0
       ADDA.L  A0,A0
       ADDA.L  #$00000010,A0
       ADDA.L  -$002A(A6),A0
       MOVE.L  (A0),D2
       BSET    #$1F,D0
       MOVE.L  D0,(A0)
       LSL.L   #1,D0
       ASR.L   #1,D0
       LSL.L   #1,D2
       BCC.S   L02516
       ASR.L   #1,D2
       MOVE.L  D2,D4
       SUB.L   D0,D4
       BGE.S   L024C8
       EXG     D0,D2
L024C8 TST.L   D0
       BGE.S   L024CE
       MOVEQ   #$00,D0
L024CE TST.L   D2
       BLT.S   L02516
       CMP.L   -$001C(A6),D0
       BGE.S   L02516
       CMP.L   -$001C(A6),D2
       BLT.S   L024E2
       MOVE.L  -$001C(A6),D2
L024E2 SUB.L   D0,D2
       ADD.L   -$0036(A6),D0
       NEG.L   D1
       ADD.L   -$003A(A6),D1
       ADD.L   -$0020(A6),D1
       SUBQ.L  #1,D1
       MOVE.W  D3,-(A7)
       MOVE.W  D3,-(A7)
       SWAP    D3
       MOVE.W  D3,-(A7)
       MOVE.W  D3,-(A7)
       MOVEA.L A7,A1
       MOVEQ   #$01,D3
       BTST    #$03,-$0023(A6)
       BNE.S   L02510
       JSR     L025BE(PC)
       BRA.S   L02514


L02510 JSR     L025CA(PC)
L02514 ADDQ.L  #8,A7
L02516 MOVEM.L (A7)+,D0-D3/A0-A1
       RTS

L0251C CMP.L   -$001C(A6),D0
       BCC.S   L02546
       SWAP    D2
       SWAP    D3
       MOVE.L  D3,D4
       AND.L   D2,D4
       BTST    #$03,-$0023(A6)

       BNE.S   L02540
       MOVE.L  (A5),D5
       NOT.L   D2
       AND.L   D2,D5
       NOT.L   D2
       OR.L    D4,D5
       MOVE.L  D5,(A5)
       BRA.S   L02542


L02540 EOR.L   D4,(A5)
L02542 SWAP    D2
       SWAP    D3
L02546 RTS

L02548 MOVEM.L D0-D7/A0-A6,-(A7)
       BSR.S   L0256A
       MOVE.L  #$00FF00FF,D6
       MOVE.L  D6,D7
       BRA.S   L025D0


L02558 MOVE.L  (A1),D6
       MOVE.W  D6,D7
       SWAP    D7
       MOVE.W  D6,D7
       MOVE.W  (A1),D6
       BTST    #$00,D1
       BNE.S   L0256A
       EXG     D6,D7
L0256A LSL.W   #7,D1
       MOVEA.L #$00020000,A1        * screen mem address
       ADDA.W  D1,A1
       LSL.W   #6,D3
       MOVEA.W D3,A2
       ADDA.L  A2,A2
       MOVE.W  D0,D1
       LSR.W   #4,D1
       LSL.W   #2,D1
       ADDA.W  D1,A1
       ADDA.L  A1,A2
       MOVEA.W #$0080,A3
       LSR.W   #2,D1
       ADD.W   D0,D2
       MOVE.W  D2,D3
       SUBQ.W  #1,D3
       ASR.W   #4,D3
       SUB.W   D1,D3
       MOVEA.W D3,A5
       ADDA.W  A5,A5
       ADDA.W  A5,A5
       BSR.S   L025AA
       MOVE.L  D5,D4
       MOVE.W  D2,D0
       BSR.S   L025AA
       NOT.L   D5
       BNE.S   L025A8
       MOVEQ   #-$01,D5
L025A8 RTS

L025AA MOVEQ   #-$01,D5
       ANDI.W  #$000F,D0
       LSR.W   D0,D5
       MOVE.W  D5,D0
       LSL.L   #8,D5
       MOVE.W  D0,D5
       LSL.L   #8,D5
       MOVE.B  D0,D5
       RTS

L025BE MOVEM.L D0-D7/A0-A6,-(A7)
       BSR.S   L02558
L025C4 LEA     L026EC(PC),A6
       BRA.S   L025F4


L025CA MOVEM.L D0-D7/A0-A6,-(A7)
       BSR.S   L02558
L025D0 LEA     L026F4(PC),A6
       BRA.S   L025F4


L025D6 MOVEM.L D0-D7/A0-A6,-(A7)
       MOVEA.L A1,A4
       BSR.S   L0256A
       ADD.W   D3,D3
       ADDQ.W  #1,D3
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BNE.S   L025F0
       LEA     L0273E(PC),A6
       BRA.S   L025F4


L025F0 LEA     L02708(PC),A6
L025F4 BSR     L026E6
       MOVEM.L (A7)+,D0-D7/A0-A6
       RTS

L025FE MOVEM.L D0-D7/A0-A6,-(A7)
       BSR     L02558
       MOVE.W  $0012(A7),D2
       NEG.W   D2
       LSL.W   #7,D2
       BVS.S   L025C4
       BGT.S   L02630
       EXG     A1,A2
       MOVEA.W #$FF80,A3
       ADDA.L  A3,A1
       ADDA.L  A3,A2
       MOVE.W  A1,D0
       SUB.W   A2,D0
       TST.B   D0
       BNE.S   L02626
       EXG     D6,D7
L02626 LEA     $00(A1,D2.W),A4
       CMPA.L  A2,A4
       BLS.S   L025C4
       BRA.S   L02638


L02630 LEA     $00(A1,D2.W),A4
       CMPA.L  A4,A2
       BLS.S   L025C4
L02638 LEA     L026FC(PC),A6
       SUBA.W  D2,A2
       BSR     L026E6
       ADDA.W  D2,A2
       BRA     L025C4


L02648 MOVEM.L D0-D7/A0-A6,-(A7)
       BSR     L02558
       SWAP    D3
       MOVE.W  $0012(A7),D2
       NEG.W   D2
       BGT.S   L0268A
       NEG.W   D2
       MOVE.W  D2,D3
       ANDI.W  #$000F,D3
       ADDI.W  #$0010,D3
       SWAP    D3
       LSR.W   #4,D2
       CMP.W   D3,D2
       BHI     L025C4
       SUB.W   D2,D3
       MOVEA.W #$FFFC,A0
       ADDA.W  A5,A1
       ADDA.W  A5,A2
       MOVEA.L A1,A4
       LSL.W   #2,D2
       SUBA.W  D2,A4
       MOVE.L  A5,D2
       NEG.L   D2
       MOVEA.L D2,A5
       EXG     D4,D5
       BRA.S   L026AC


L0268A MOVEA.W #$0004,A0
       MOVE.W  D2,D3
       ANDI.W  #$000F,D3
       NEG.W   D3
       ADDI.W  #$0010,D3
       SWAP    D3
       LSR.W   #4,D2
       CMP.W   D3,D2
       BHI     L025C4
       SUB.W   D2,D3
       LSL.W   #2,D2
       LEA     $00(A1,D2.W),A4
L026AC ADDQ.W  #1,D3
       LEA     L02770(PC),A6
       BRA     L025F4


L026B6 MOVE.W  D3,D0
       BMI.S   L026EA
       EXG     D6,D7
       MOVE.L  (A1),-(A7)
       MOVE.L  $00(A1,A5.W),-(A7)
       JMP     (A6)


L026C4 SUBQ.W  #4,A1
L026C6 MOVE.L  (A1),D0
       AND.L   D5,D0
       MOVE.L  D5,D1
       NOT.L   D1
       AND.L   (A7)+,D1
       OR.L    D1,D0
       MOVE.L  D0,(A1)
       SUBA.L  A5,A1
       MOVE.L  (A1),D0
       AND.L   D4,D0
       MOVE.L  D4,D1
       NOT.L   D1
       AND.L   (A7)+,D1
       OR.L    D1,D0
       MOVE.L  D0,(A1)
       ADDA.L  A3,A1
L026E6 CMPA.L  A2,A1
       BNE.S   L026B6
L026EA RTS

L026EC MOVE.L  D6,(A1)+
       DBF     D0,L026EC
       BRA.S   L026C4

L026F4 EOR.L   D6,(A1)+
       DBF     D0,L026F4
       BRA.S   L026C4

L026FC LEA     $00(A1,D2.W),A4
L02700 MOVE.L  (A4)+,(A1)+
       DBF     D0,L02700
       BRA.S   L026C4

L02708 MOVE.B  (A1),D6
       MOVE.B  $0001(A1),D7
       MOVEQ   #$03,D1
L02710 MOVEQ   #$00,D2
       MOVE.B  D6,D2
       LSL.B   #6,D2
       LSL.W   #1,D2
       MOVE.B  D7,D2
       LSL.B   #6,D2
       LSR.W   #6,D2
       MOVE.B  $00(A4,D2.W),D2
       ROXR.B  #1,D2
       ROXR.B  #1,D7
       ROXR.B  #1,D2
       ROXR.B  #1,D7
       ROR.B   #1,D6
       ROXR.B  #1,D2
       ROXR.B  #1,D6
       DBF     D1,L02710
       MOVE.B  D6,(A1)+
       MOVE.B  D7,(A1)+
       DBF     D0,L02708
       BRA.S   L026C4


L0273E MOVE.B  (A1),D6
       MOVE.B  $0001(A1),D7
       MOVEQ   #$07,D1
L02746 MOVEQ   #$00,D2
       MOVE.B  D6,D2
       LSL.B   #7,D2
       LSL.W   #1,D2
       MOVE.B  D7,D2
       LSL.B   #7,D2
       LSR.W   #6,D2
       MOVE.B  $00(A4,D2.W),D2
       ROXR.B  #2,D2
       ROXR.B  #1,D7
       ROXR.B  #1,D2
       ROXR.B  #1,D6
       DBF     D1,L02746
       MOVE.B  D6,(A1)+
       MOVE.B  D7,(A1)+
       DBF     D0,L0273E
       BRA     L026C4


L02770 MOVE.W  A5,-(A7)
       MOVE.L  A4,-(A7)
       MOVE.L  D6,-(A7)
       ADDA.L  A1,A5
       MOVE.L  (A5),D2
       AND.L   D5,D2
       MOVE.L  D5,D1
       NOT.L   D1
       AND.L   D6,D1
       OR.L    D1,D2
       MOVE.L  D2,(A5)
       ADDA.L  A0,A5
       SWAP    D3
       MOVEP.W $0000(A4),D1
       MOVEP.W $0001(A4),D2
       BRA.S   L027B4


L02794 ADDA.L  A0,A4
L02796 SWAP    D1
       SWAP    D2
       MOVEP.W $0000(A4),D1
       MOVEP.W $0001(A4),D2
       MOVE.L  D1,D6
       ROR.L   D3,D6
       MOVEP.W D6,$0000(A1)
       MOVE.L  D2,D6
       ROR.L   D3,D6
       MOVEP.W D6,$0001(A1)
       ADDA.L  A0,A1
L027B4 SUBQ.W  #1,D0
       BGT.S   L02794
       BLT.S   L027BE
       MOVEA.L A7,A4
       BRA.S   L02796


L027BE MOVE.L  (A7)+,D6
       MOVEA.L (A7)+,A4
       SWAP    D3
       BRA.S   L027CA


L027C6 MOVE.L  D6,(A1)
       ADDA.L  A0,A1
L027CA CMPA.L  A1,A5
       BNE.S   L027C6
       MOVEA.W (A7)+,A5
       ADDA.L  A3,A4
       SUBA.L  A0,A1
       BRA     L026C6


L027D8 MOVEM.L D1-D2,-(A7)
       BSR.S   L0281E
       MOVE.W  D2,(A1)
       MOVE.W  D2,$0002(A1)
       LSR.B   #3,D1
       BEQ.S   L02818
       BSR.S   L0281E
       LSR.B   #3,D1
       BTST    #$00,D1
       BEQ.S   L027F6
       EOR.W   D2,$0002(A1)
L027F6 CMPI.B  #$01,D1
       BEQ.S   L02818
       BTST    #$03,$0034(A6)  * SV.MCSTA

       BEQ.S   L0280A
       ANDI.W  #$3333,D2
       BRA.S   L0280E


L0280A ANDI.W  #$5555,D2
L0280E EOR.W   D2,(A1)
       TST.B   D1
       BEQ.S   L02818
       EOR.W   D2,$0002(A1)
L02818 MOVEM.L (A7)+,D1-D2
       RTS

L0281E MOVE.B  D1,D2
       ANDI.W  #$0007,D2
       ROR.L   #2,D2
       LSL.W   #7,D2
       ROL.L   #2,D2
       BTST    #$03,$0034(A6)  * SV.MCSTA
       BEQ.S   L02838
       MULU    #$0055,D2
       BRA.S   L0283E


L02838 LSR.W   #1,D2
       MULU    #$00FF,D2
L0283E RTS

* ROUTINE TO PRINT CHAR ON SCR
* CALLED BY TRAP#3,D0=5

L02840 MOVEM.L D0-D7/A0-A6,-(A7)
       MOVEM.L (A1),D6-D7 * D7=ink mask
       BTST    #$00,D1    * odd adress
       BNE.S   L02852
       SWAP    D6         * invert masque
       SWAP    D7         *
L02852 ANDI.W  #$00FF,D2  * character to print
       MOVEA.L A2,A4      * pointer to first charfont
       SUB.B   (A4)+,D2   * higher?
       CMP.B   (A4)+,D2
       BLS.S   L0286A     * No
       ADD.B   (A2),D2
       MOVEA.L A3,A4      * second char font
       SUB.B   (A4)+,D2
       CMP.B   (A4)+,D2
       BLS.S   L0286A     * ok
       MOVEQ   #$00,D2    * char not printable
L0286A ADDA.W  D2,A4      * get value in charlist
       LSL.W   #3,D2
       ADDA.W  D2,A4
       MOVEA.L #$00020000,A1
       LSL.W   #7,D1
       ADDA.W  D1,A1
       MOVE.W  D0,D1
       LSR.W   #3,D0
       ADD.W   D0,D0
       ADDA.W  D0,A1
       ANDI.W  #$0007,D1
       MOVEA.W #-1,A5
       BTST    #$00,D3  * mode underline ?
       BEQ.S   L02892   * no
       ADDQ.W  #2,A5
L02892 MOVEQ   #$00,D0
       MOVEQ   #$7E,D2
       ADD.W   D2,D2    * D2 = $FC
       MOVEQ   #$00,D5
       BTST    #$06,D3  * mode 8
       BEQ.S   L028B4
       MOVEQ   #-$01,D0
       MOVE.W  #$FFF0,D2
       ADDQ.W  #8,D1
       BTST    #$01,D3  * mode flash?
       BEQ.S   L028B4
       MOVE.W  #$4010,D5
       ROR.L   D1,D5
L028B4 BTST    #$05,D3  * mode extended width
       BEQ.S   L028BC
       ASR.B   #4,D2
L028BC MOVEQ   #$00,D4
       BTST    #$04,D3  * mode double height
       BEQ.S   L028C6
       MOVEQ   #-$01,D4
L028C6 ROR.L   D1,D2
       LEA     L02924(PC),A6  * adress for printing
       BTST    #$02,D3    * mode transparent background
       BEQ.S   L028E0
       LEA     L0293A(PC),A6  * adress for printing
       BTST    #$03,D3    * XOR characters/graphics
       BEQ.S   L028E0
       LEA     L02936(PC),A6  * adress for printing
L028E0 MOVEA.L A1,A2      * adress on screen
       MOVE.B  D2,D0      * copy byte to print in long word
       LSL.W   #8,D2
       MOVE.B  D0,D2
       LSL.W   #8,D5
       MOVE.W  #$0009,D0 * loop counter
       MOVEQ   #$00,D3
       BRA.S   L0291C    * adress to add masque
 

L028F2 MOVEQ   #$00,D3   * loop for printing
       CMP.W   A5,D0     * underline?
       BNE.S   L028FE
       MOVEQ   #-$01,D3
       ADDQ.W  #1,A4
       BRA.S   L02914


L028FE MOVE.B  (A4)+,D3  * char-matrix in d3
       BEQ.S   L0291C
       TST.L   D0        * 6 or 8 pixels size
       BGE.S   L0290C
       LSR.B   #1,D3
       MOVE.W  L0297C(PC,D3.W),D3    * convert-table 6*9 to 12 * 9
L0290C ROR.W   D1,D3     * calculate any pixel depending on size
       MOVE.B  D3,D4     * and char-matrix
       LSL.W   #8,D3
       MOVE.B  D4,D3
L02914 AND.W   D2,D3
       MOVE.W  D3,D4
       SWAP    D3
       MOVE.W  D4,D3
L0291C MOVE.W  D3,D4
       AND.W   D7,D4
       OR.W    D5,D4
       JMP     (A6)

L02924 EOR.W   D2,D3
       AND.W   D6,D3
       OR.W    D4,D3
       MOVE.W  D2,D4
       NOT.W   D4
       AND.W   (A1),D4
       OR.W    D3,D4    * at last - value to print
       MOVE.W  D4,(A1)  * on screen
       BRA.S   L02942   * continue

L02936 EOR.W   D4,(A1)
       BRA.S   L02942

L0293A NOT.W   D3
       AND.W   (A1),D3
       OR.W    D4,D3
       MOVE.W  D3,(A1)
L02942 SWAP    D6
       SWAP    D7
       ADDA.W  #$0080,A1
       TST.L   D4       * normal size
       BGE.S   L02956   * yes
       SWAP    D3
       BCHG    #$1E,D4
       BNE.S   L0291C
L02956 DBF     D0,L028F2
       CLR.W   D2
       ROL.L   #8,D2
       BEQ.S   L02976   * character written ½ end
       CLR.W   D5
       ROL.L   #8,D5
       SUBQ.B  #8,D1
       ANDI.B  #$0F,D1
       MOVEA.L A2,A1
       ADDQ.W  #2,A1
       SUBA.W  #$0009,A4
       BRA     L028E0   * second run

L02976 MOVEM.L (A7)+,D0-D7/A0-A6
       RTS

*
*       sreen-pixel translate code 
*       transfers 6*9 matrix to 12 * 9 matrix
*

L0297C DC.W    $0000
       DC.W    $0030
       DC.W    $00C0
       DC.W    $00F0
       DC.W    $0300
       DC.W    $0330
       DC.W    $03C0
       DC.W    $03F0
       DC.W    $0C00
       DC.W    $0C30
       DC.W    $0CC0
       DC.W    $0CF0
       DC.W    $0F00
       DC.W    $0F30
       DC.W    $0FC0
       DC.W    $0FF0
       DC.W    $3000
       DC.W    $3030
       DC.W    $30C0
       DC.W    $30F0
       DC.W    $3300
       DC.W    $3330
       DC.W    $33C0
       DC.W    $33F0
       DC.W    $3C00
       DC.W    $3C30
       DC.W    $3CC0
       DC.W    $3CF0
       DC.W    $3F00
       DC.W    $3F30
       DC.W    $3FC0
       DC.W    $3FF0
       DC.W    $C000
       DC.W    $C030
       DC.W    $C0C0
       DC.W    $C0F0
       DC.W    $C300
       DC.W    $C330
       DC.W    $C3C0
       DC.W    $C3F0
       DC.W    $CC00
       DC.W    $CC30
       DC.W    $CCC0
       DC.W    $CCF0
       DC.W    $CF00
       DC.W    $CF30
       DC.W    $CFC0
       DC.W    $CFF0
       DC.W    $F000
       DC.W    $F030
       DC.W    $F0C0
       DC.W    $F0F0
       DC.W    $F300
       DC.W    $F330
       DC.W    $F3C0
       DC.W    $F3F0
       DC.W    $FC00
       DC.W    $FC30
       DC.W    $FCC0
       DC.W    $FCF0
       DC.W    $FF00
       DC.W    $FF30
       DC.W    $FFC0
       DC.W    $FFF0

     include flp1_mdv_sys

* execution of command to 8049
L02C72 MOVE    SR,-(A7)    * transmission with 8049 rts=rte
       ORI.W   #$0700,SR   * disable interrupts
       JSR     L02F6E(PC)  * returns D6=6  A0=$18020  A1=$18003
       MOVE.B  (A3)+,D0    * d0 = command-type
       BSR.S   L02CC8      * do it
       MOVE.B  (A3)+,D7    * number of params
       MOVE.L  (A3)+,D4    * sort of params
L02C84 SUBQ.B  #1,D7       * no params
       BLT.S   L02CA4      * go on
       MOVE.B  (A3)+,D0
       BTST    #$00,D4
       BNE.S   L02CA0
       BTST    #$01,D4
       BEQ.S   L02C9E
       MOVE.W  D0,D5
       ROR.W   #4,D0
       BSR.S   L02CC8
       MOVE.W  D5,D0
L02C9E BSR.S   L02CC8
L02CA0 ROR.L   #2,D4
       BRA.S   L02C84


L02CA4 MOVE.B  (A3)+,D4
       BTST    #$00,D4
       BNE.S   L02CBC
       BTST    #$01,D4
       BNE.S   L02CB8
       JSR     L02F96(PC)
       BRA.S   L02CBC


L02CB8 JSR     L02F9A(PC)   * the answer of 8049
L02CBC MOVEQ   #$02,D7
       OR.B    $0035(A6),D7 * SV.PCINT
       MOVE.B  D7,$0001(A0)
       RTE


L02CC8 JMP     L02F7C(PC)     * command for 8079


L02CCC MOVEM.L D0-D6/A0-A4,-(A7)    * interrupt 2 - interface
       MOVEQ   #$00,D3
       BSR.S   L02D20
       MOVEQ   #$02,D7
       BRA.S   L02CE6

L02CD8 MOVEM.L D0-D6/A0-A4,-(A7)    * interrupt 2 - transmission
       MOVEQ   #$00,D3
       ST      D4
       BSR     L02D74
       MOVEQ   #$04,D7
L02CE6 OR.B    $0035(A6),D7  * SV.PCINT
       MOVE.B  D7,$00018021
       MOVEM.L (A7)+,D0-D6/A0-A4
       BRA     L003B6

* table of interrupt tasks
L02CF8 
       DC.L    0        * no following table
       DC.L    L02D08   * interrupt-routines
       
* table of scheduler tasks
L02D00 DC.L    L03480   * List of next linkage
       DC.L    L02D14   * adress of scheduler task

L02D08 MOVE    SR,-(A7)    * RTS=RTE !
       ORI.W   #$0700,SR
       BSR.S   L02D20      * ask 8049
       JMP     L02CBC(PC)  * end


L02D14 MOVE    SR,-(A7)   * serial I/O
       ORI.W   #$0700,SR
       SF      D4         * D4.B = 0
       BSR.S   L02D74
       RTE

L02D20 JSR     L02F6E(PC)    * returns D6=6  A0=$18020  A1=$18003
       MOVEQ   #$01,D0       * command 1 to 8049 = respond
       JSR     L02F7C(PC)    * command for 8079
       JSR     L02F9A(PC)    * receive demands
       MOVE.B  D1,D7         * d7: received byte
       BTST    #$06,D7       * bit 6=0? mdv write not allowed
       SEQ     $0094(A6)     * SV.WP
       BTST    #$01,D7       * bit 1=1 beeper activ
       SNE     $0096(A6)     * SV.SOUND
       BTST    #$00,D7       * bit 0=0 keyboard-buff empty
       BEQ.S   L02D4A
       JSR     L02E58(PC)      * transfer keyboard buff
L02D4A MOVE.L  $0098(A6),D0    * no ser# open
       BEQ.S   L02D5E
       BTST    #$04,D7    * bit 4 = 0 ser# did nothing receive
       BEQ.S   L02D5E
       MOVEA.L D0,A2
       MOVEQ   #$06,D5
       JSR     L02E18(PC)       * receive
L02D5E MOVE.L  $009C(A6),D0     * now same proc with ser2
       BEQ.S   L02D72
       BTST    #$05,D7
       BEQ.S   L02D72
       MOVEA.L D0,A2
       MOVEQ   #$07,D5
       JSR     L02E18(PC)
L02D72 RTS

L02D74 LEA     $00A0(A6),A4  * prepare for ser# - receiving SV.TMODE
       BTST    #$04,(A4)
       BNE.S   L02D88
       LEA     $00018020,A1
       BTST    #$01,(A1)
L02D88 BNE.S   L02E02
       MOVEQ   #$00,D6    * d6=0 : ser1
       MOVE.B  (A4),D6    * d6=1 : ser2
       LSL.B   #4,D6
       LSR.B   #7,D6
       MOVE.W  D6,D7
       ADDQ.B  #4,D7
       LSL.B   #2,D6
       LEA     $0098(A6),A5  *SV.SER1C
       ADDA.W  D6,A5
       MOVE.L  (A5),D0
       BEQ.S   L02E04
       MOVEA.W #$0062,A2    * a2= start addr. of out-file
       ADDA.L  D0,A2
       TST.B   -$0065(A2)
       BEQ.S   L02DB2
       BTST    D7,(A1)
       BNE.S   L02DBE
L02DB2 JSR     L0385E(PC)   * IO.QOUT
       BEQ.S   L02DF6       * correct received
       ADDQ.L  #1,D0
       BEQ.S   L02E04
       BRA.S   L02DD4

L02DBE JSR     L0380A(PC)  * IO.QTEST
       CMPI.W  #$FFF6,D0
       BNE.S   L02E04
       TST.B   -$0063(A2)
       BLT.S   L02DD4
       TST.B   -$0065(A2)
       BNE.S   L02E02
L02DD4 TST.B   D4
       BNE.S   L02E02
       MOVE.B  -$0063(A2),D6
       LEA     -$0082(A2),A0
       JSR     L0305E(PC)    * MT.RECHP
       CLR.L   (A5)
       TST.B   D6
       BLT.S   L02E02
       MOVEQ   #$1A,D1
       BTST    #$00,-$0067(A2)    * parity even?
       BEQ.S   L02DF6
       MOVEQ   #-$66,D1
L02DF6 MOVE.B  D1,$00018022
       MOVE.W  $00A8(A6),$00A6(A6)  * SV.TIMOV
L02E02 RTS
        
L02E04 SUB.W   D3,$00A6(A6)    * ser timing SV.TIMOV
       BGE.S   L02E02
       CLR.W   $00A6(A6)
       BCHG    #$03,(A4)
       MOVE.B  (A4),-$001E(A1)
       RTS

L02E18 JSR     L0380A(PC)    * IO.QTEST  receive ser#
       CMPI.W  #$0019,D2
       BLT.S   L02E56
       MOVE.L  D5,D0
       JSR     L02F7C(PC)     * command for 8079 depending on D0
       JSR     L02F9A(PC)
       MOVE.B  D1,D4
       ANDI.W  #$003F,D4
       BEQ.S   L02E56(PC)
       SUBQ.W  #1,D4
L02E36 JSR     L02F9A(PC)
       TST.B   -$0002(A2)
       BLT.S   L02E4E
       MOVEQ   #$7F,D0
       AND.B   D1,D0
       CMPI.B  #$1A,D0
       BNE.S   L02E4E
       JSR     L03888(PC)    * IO.QEOF
L02E4E JSR     L03838(PC)    * IO.QIN
       DBF     D4,L02E36     * continue reading
L02E56 RTS

L02E58 MOVEA.L $004C(A6),A2  * clear 8049 - keyboard buffer
       MOVE.L  A2,D0
       BEQ.S   L02EC0        * = no con open
       MOVEQ   #$08,D0       * command 8=read keyboard
       JSR     L02F7C(PC)    * command for 8079
       JSR     L02F96(PC)    * receive
       MOVE.B  D1,D5         * d1=d5=d4 : number of bytes in buffer
       MOVE.B  D1,D4
       ANDI.W  #$0007,D4
       BEQ.S   L02E96    * if empty - out
       SUBQ.W  #1,D4
L02E76 CLR.W   $008A(A6)    * autorepeat buffer
       JSR     L02F96(PC)    * receive ctrl alt shift
       MOVE.B  D1,D2
       JSR     L02F9A(PC)
       MOVEA.L $BFF2,A3
       JSR     (A3)      * convert to ASCII 
       BRA.S   L02EC4    * ctrl - space
       BRA.S   L02EC2    * no char implemented !!! change to 2ec0 !!!
       BSR.S   L02EEC
       DBF     D4,L02E76 * look for next bytes in buffer
L02E96 BTST    #$03,D5   * if less then 8 chrs in buffer ½ end
       BEQ.S   L02EBA
       SUB.W   D3,$0090(A6)  * SV.ARCNT
       BGT.S   L02EC0
       JSR     L0380A(PC)    * IO.QTEST
       TST.L   D0            * no new entries
       BEQ.S   L02EB2
       MOVE.W  $008A(A6),D1  * SV.ARBUF
       BEQ.S   L02EB2
       BSR.S   L02EEC
L02EB2 MOVE.W  $008E(A6),$0090(A6) * SV.ARFRQ ½ SV.ARCNT
       RTS

L02EBA MOVE.W  $008C(A6),$0090(A6) * restore autorepeat
L02EC0 RTS

* !!! CHANGE ABOVE AND REMOVE - DOUBLE RTS IS NONSENS !!!

L02EC2 RTS

L02EC4 SF      $0033(A6)     * was ctrl-space ? clear SV.SCRST
       MOVEA.L $0068(A6),A3  * SV.JBBAS
       MOVEA.L (A3),A3       * SuperBasic
       SF      $00F7(A3)        * BV.BRK
       MOVE.W  $0014(A3),D0     * job.stat
       BEQ.S   L02EEA           * ok ->
       ADDQ.W  #1,D0
       BLT.S   L02EEA           * waiting for job ->
       CLR.W   $0014(A3)
       MOVE.L  $000C(A3),D0     * release flag
       BEQ.S   L02EEA
       MOVEA.L D0,A3
       SF      (A3)
L02EEA RTS

L02EEC CMPI.W  #$00F9,D1     * ctrl-f5 ?
       BEQ.S   L02F3A        * invert screen status
       SF      $0033(A6)     * SV.SCRST
       CMP.W   $0092(A6),D1  * ctrl-c ? SV.CQCH
       BEQ.S   L02F40
       CMPI.W  #$00E0,D1    * capslock ?
       BNE.S   L02F12
       NOT.B   $0088(A6)    * invert capslock mode SV.CAPS
       TST.L   $00A2(A6)    * if new: acitvate     SV.CSUB
       BEQ.S   L02EC0
       LEA     $00A2(A6),A5
       JMP     (A5)        * will return 

L02F12 MOVE.W  $008C(A6),$0090(A6)    * SV.ARDEL ½ SV.ARFRQ
       MOVE.W  D1,$008A(A6)           * autorepeat - buffer
       CMPI.B  #-1,D1
       BNE.S   L02F36
       SWAP    D1
       JSR     L0380A(PC)    * IO.QTEST
       CMPI.W  #$0002,D2
       BLT.S   L02EC0
       SWAP    D1
       JSR     L03838(PC)    * IO.QIN
       LSR.W   #8,D1
L02F36 JMP     L03838(PC)    * IO.QIN

L02F3A NOT.B   $0033(A6)    * invert screen status
       RTS

L02F40 LEA     -$0068(A2),A0    * a0 = chbase
       TST.B   $0043(A0)
       BGE.S   L02F54           * cursor activ
       JSR     L01B86           * reactivate
       NOP                      * !!! to conform asm !!!
       LEA     $0068(A0),A2     * pointer to Job-base
L02F54 MOVEA.L (A2),A2
       CMPA.L  $004C(A6),A2     * keyboard-queue ok?
       BEQ.S   L02F6A
       TST.B   -$0025(A2)
       BEQ.S   L02F54
       MOVE.L  A2,$004C(A6)     * SV.KEYQ
       CLR.W   $AA(A6)
       
* omit instruction but let label !!!

L02F6A JMP     L02F6E(PC)    * returns D6=6  A0=$18020  A1=$18003

 
* set parameters for transmission to 8049        
L02F6E LEA     $00018003,A1     * A1 = 8049 - write reg
       LEA     $001D(A1),A0     * A0 = status-control 8049
       MOVEQ   #$06,D6
       RTS
* command for 8079  - depends on value in D0
L02F7C LSL.B   #4,D0    * send command to 8049 D0 * 16
       ORI.B   #$08,D0  * bit 3 = 1
L02F82 LSL.B   #1,D0
       BEQ.S   L02F94
       MOVEQ   #$03,D1
       ROXL.B  #1,D1
       ASL.B   #1,D1
       MOVE.B  D1,(A1)
L02F8E BTST    D6,(A0)  * wait till bit 6 ist 0 - ackn of 8049
       BNE.S   L02F8E
       BRA.S   L02F82
L02F94 RTS

L02F96 MOVEQ   #$10,D1  * decrement counter
       BRA.S   L02F9C   * receive

L02F9A MOVEQ   #$01,D1 
L02F9C MOVE.B  #$0E,(A1) * $0E an 8049 : ready to receive
L02FA0 BTST    D6,(A0)
       BNE.S   L02FA0    * wait
       MOVE.B  (A0),D0   * receive bits
       ROXL.B  #1,D0
       ROXL.B  #1,D1
       BCC.S   L02F9C    * till complete
       RTS

* Vector-handling
 
* allocate memory in common heap
        
L02FAE LEA     $0008(A6),A0     * MM.ALCHP
       MOVEQ   #$0F,D2  
       JSR     L03106(PC)       * reserve D1 bytes
       BLT.S   L02FD6
       LEA     $0004(A6),A2     * SV.CHEAP
       CMPA.L  A1,A2
       BEQ.S   L02FC6
       CLR.L   $0008(A1)
L02FC6 MOVE.L  D1,D0
       ADDQ.W  #4,A0
       SUBQ.L  #4,D0
L02FCC CLR.L   (A0)+
       SUBQ.L  #4,D0
       BGT.S   L02FCC
       SUBA.L  D1,A0    * A0 = base of reserved space
       BRA.S   L02FF8

* allocate memory in transient area

L02FD6 MOVE.L  D1,-(A7)
       ADDA.L  (A0),A1
       CMPA.L  $000C(A6),A1  * SV.FREE
       BNE.S   L02FE2
       SUB.L   (A0),D1
L02FE2 JSR     L0324E(PC)
       BNE.S   L02FF6
       SUBA.L  D1,A0
       LEA     $0008(A6),A1  * SV.CHPFR
       JSR     L0315E(PC)
       MOVE.L  (A7)+,D1
       BRA.S   L02FAE     * MM.ALCHP

L02FF6 ADDQ.W  #4,A7
L02FF8 RTS


* reserve in transient prog aera d1 bytes

L02FFA LEA     $0018(A6),A0  * SV.TRNFR
       MOVEQ   #$0F,D2
       MOVEQ   #$01,D0
       JSR     L03134(PC)
       TST.L   D2
       BGT.S   L03032
       MOVE.L  D1,-(A7)
       LEA     $0014(A6),A1  * SV.TRNSP
       ADDA.L  $0004(A1),A1
       CMPA.L  $0014(A6),A1
       BNE.S   L0301C
       SUB.L   (A1),D1
L0301C JSR     L031B8(PC)     * allocate memory
       BNE.S   L0305A
       SUB.L   D1,$0014(A6)
       LEA     $0018(A6),A1  * SV.TRNFR
       JSR     L0315E(PC)
       MOVE.L  (A7)+,D1
       BRA.S   L02FFA    * reserve d1 bytes
       
* release memory in transient area

L03032 MOVEA.L A2,A0
       ADDA.L  $0004(A2),A0
       MOVE.L  (A0),D3
       CMP.L   D1,D3
       BGT.S   L0304E
       MOVE.L  $0004(A0),D3
       BEQ.S   L03048
       ADD.L   A0,D3
       SUB.L   A2,D3
L03048 MOVE.L  D3,$0004(A2)
       BRA.S   L03056

L0304E SUB.L   D1,D3
       MOVE.L  D3,(A0)
       ADDA.L  D3,A0
       MOVE.L  D1,(A0)
L03056 MOVEQ   #$00,D0
       RTS

L0305A ADDQ.W  #4,A7
       RTS

* MT.FREE find largest free space
L0305E MOVE.L  (A0),D1
       LEA     $0008(A6),A1  * SV.CHPFR
       JSR     L0315E(PC)
       MOVE.L  (A1),D2
       ADDA.L  D2,A1
       CMPA.L  $000C(A6),A1  * SV.FREE
       BNE.S   L03088
       MOVE.L  D2,D1
       JSR     L03282(PC)
       SUB.L   D1,D2
       BEQ.S   L03084
       ADDA.L  $0004(A2),A2
       MOVE.L  D2,(A2)
       BRA.S   L03088

L03084 CLR.L   $0004(A2)
L03088 MOVEQ   #$00,D0
       RTS

* RELEASE MEMORY
L0308C MOVE.L  (A0),D1
       LEA     $0018(A6),A1   * SV.TRNFR
       JSR     L0315E(PC)
       LEA     $0014(A6),A2   * SV.TRNSP
       ADDA.L  $0004(A2),A2
       CMPA.L  $0014(A6),A2
       BNE.S   L030DE
       MOVE.L  $0004(A2),-(A7)
       MOVE.L  (A2),D2
       MOVE.L  D2,D1
       JSR     L031C8(PC)     * Release memory
       ADD.L   D1,$0014(A6)   * SV.TRNSP
       SUB.L   D1,D2
       BEQ.S   L030D2
       MOVEA.L (A7)+,A1
       ADDA.L  D1,A2
       ADD.L   D1,$0018(A6)   * SV.TRNFR
       MOVE.L  D2,(A2)
       CLR.L   $0008(A2)
       MOVE.L  A1,$0004(A2)
       BEQ.S   L030DE
       SUB.L   D1,$0004(A2)
       BRA.S   L030DE

L030D2 MOVE.L  (A7)+,D2
       BEQ.S   L030DA
       ADD.L   $0018(A6),D2   * SV.TRNFR
L030DA MOVE.L  D2,$0018(A6)
L030DE RTS


L030E0 
XLtr1d06 EQU L030E0
       MOVEQ   #$01,D0
       MOVEQ   #$00,D1
       LEA     $0018(A6),A0   * SV.TRNFR
       JSR     L03134(PC)
       MOVEA.L $0010(A6),A0   * SV.BASIC
       SUBA.W  #$0200,A0
       SUBA.L  $000C(A6),A0   * SV.FREE
       MOVE.L  A0,D1
       CMP.L   D1,D2
       BLE.S   L03100
       MOVE.L  D2,D1
L03100 BRA     L003A4

L03104 MOVEQ   #$07,D2    * MM.ALLOC
L03106 MOVEQ   #$00,D0
       JSR     L03134(PC)
       CMP.L   D1,D2
       BEQ.S   L03122
       BGT.S   L03116
       MOVEQ   #-$03,D0
       RTS

L03116 ADD.L   D1,$0004(A1)
       MOVEA.L A0,A1
       ADDA.L  D1,A1
       SUB.L   D1,D3
       MOVE.L  D3,(A1)
L03122 MOVE.L  $0004(A0),D2
       BEQ.S   L0312C
       ADD.L   A0,D2
       SUB.L   A1,D2
L0312C MOVE.L  D2,$0004(A1)
       MOVE.L  D1,(A0)
       RTS

* general memory allocation

L03134 SUBQ.W  #4,A0
       ADD.L   D2,D1
       NOT.B   D2
       AND.B   D2,D1
       MOVEQ   #$00,D2
       MOVEA.L D2,A2
L03140 MOVEA.L A0,A1
       MOVE.L  $0004(A0),D3
       BEQ.S   L0315C
       ADDA.L  D3,A0
       MOVE.L  (A0),D3
       CMP.L   D1,D3
       BLT.S   L03140
       MOVEA.L A1,A2
       CMP.L   D2,D3
       BLE.S   L03158
       MOVE.L  D3,D2
L03158 TST.B   D0
       BNE.S   L03140
L0315C RTS

* link free space to task

L0315E CLR.L   $0008(A0)
L03162 SUBQ.W  #4,A1     * MM.LINKFR
       SUBA.L  A2,A2
L03166 MOVEA.L A2,A3
       MOVEA.L A1,A2
       MOVE.L  $0004(A1),D2
       BEQ.S   L0317A
       ADDA.L  D2,A1
       CMPA.L  A0,A1
       BLE.S   L03166
       SUBA.L  A0,A1
       BRA.S   L0317C

L0317A MOVEA.L D2,A1
L0317C MOVE.L  A0,D2
       SUB.L   A2,D2
       MOVE.L  D2,$0004(A2)
       MOVE.L  D1,(A0)+
       MOVE.L  A1,(A0)
L03188 MOVEA.L A2,A1
       MOVEA.L A3,A2
L0318C MOVE.L  $0004(A1),D2
       BEQ.S   L031B6
       MOVEA.L A2,A3
       MOVEA.L A1,A2
       ADDA.L  D2,A1
       MOVE.L  A3,D2
       BEQ.S   L0318C
       MOVE.L  (A2),D2
       ADD.L   A2,D2
       CMP.L   A1,D2
       BNE.S   L0318C
       MOVE.L  $0004(A1),D2
       BEQ.S   L031AC
       ADD.L   (A2),D2
L031AC MOVE.L  D2,$0004(A2)
       MOVE.L  (A1),D2
       ADD.L   D2,(A2)
       BRA.S   L03188

L031B6 RTS

* test against memory Base
* used to allocate memory
L031B8 JSR     L0323A(PC)
       BNE.S   L031DE
       BSR.S   L031E0
L031C0 MOVE.L  (A1)+,(A0)+
       SUBQ.L  #4,D0
       BNE.S   L031C0
       BRA.S   L031DE

* test against top of memory
* used to Release memory
L031C8 JSR     L03276(PC)
       NEG.L   D1
       BEQ.S   L031DE
       BSR.S   L031E0
       NEG.L   D1
       ADDA.L  D0,A0
       ADDA.L  D0,A1
L031D8 MOVE.L  -(A1),-(A0)
       SUBQ.L  #4,D0
       BNE.S   L031D8
L031DE RTS

* update A6 and A7 for Basic

L031E0 MOVEA.L $0068(A6),A3  * SV.JBBAS
       MOVE.L  A0,(A3)
       ADDA.L  D1,A0
       SUB.L   D1,$0058(A0)
       SUB.L   D1,$005C(A0)
       MOVEA.L A0,A1
       SUBA.L  D1,A0
       MOVE.L  $0014(A6),D0
       SUB.L   A1,D0
       CMPA.L  $0064(A6),A3  * SV.JBPNT
       BNE.S   L0320A
       SUB.L   D1,$0008(A5)
       MOVE.L  USP,A3
       SUBA.L  D1,A3
       MOVE.L  A3,USP
L0320A RTS


L0320C ADDI.L  #$1FF,D1    * 512 Bytes round
L03212 ANDI.W  #$FE00,D1
       RTS

* calculate new position of server block

L03218 MOVEA.L $0010(A6),A0  * SV.BASIC
       MOVEQ   #-$08,D3
       BRA.S   L03226

L03220 MOVEA.L $000C(A6),A0  * SV.FREE
       MOVEQ   #$08,D3
L03226 MOVE.L  A0,D0
       SUB.L   A6,D0
       LSR.L   #6,D0
       MOVEA.L $0058(A6),A1   * SV.BTBAS
       ADDA.W  D0,A1
       MOVE.L  D1,D0
       LSR.L   #6,D0
       LSR.L   #3,D0
       RTS

* update server block

L0323A BSR.S   L0320C
       BSR.S   L03218
       SUBA.L  D1,A0
       CMPA.L  $000C(A6),A0  * SV.FREE
       BLE.S   L0329E
       MOVE.L  A0,$0010(A6)  * SV.BASIC
       ADDA.L  D3,A1
       BRA.S   L03270

L0324E BSR.S   L0320C
       BSR.S   L03220
       ADDA.L  D1,A0
       CMPA.L  $0010(A6),A0
       BGE.S   L0329E
       MOVE.L  A0,$000C(A6)
       BRA.S   L03270

L03260 MOVEQ   #$0C,D2
       AND.B   (A1),D2
       BEQ.S   L0326C
       JSR     L0352A(PC)
       BRA.S   L03260
L0326C CLR.B   (A1)
       ADDA.W  D3,A1
L03270 DBF     D0,L03260

       BRA.S   L0329A

L03276 BSR.S   L03212
       BSR.S   L03218
       ADDA.L  D1,A0
       MOVE.L  A0,$0010(A6)
       BRA.S   L03296

L03282 BSR.S   L03212
       BSR.S   L03220
       SUBA.L  D1,A0
       MOVE.L  A0,$000C(A6)   * SV.FREE
       SUBA.W  D3,A1
       BRA.S   L03296

L03290 MOVE.B  #$01,(A1)
       SUBA.W  D3,A1
L03296 DBF     D0,L03290
L0329A MOVEQ   #$00,D0
       BRA.S   L032A0

L0329E MOVEQ   #-$03,D0    * OUT OF MEMORY
L032A0 RTS


* trap 2 dispatch
L032A2 MOVEA.L $0064(A6),A1  * SV.JBPNT
       MOVEA.L (A1),A1
       BCLR    #$07,$0016(A1)
       BEQ.S   L032B4
       ADDA.L  $0008(A5),A0
L032B4 SUBQ.B  #1,D0
       BEQ.S   L032D0      * open
       SUBQ.B  #1,D0
       BEQ     L03352      * close
       SUBQ.W  #1,D0
       BEQ     L036B6      * format
       SUBQ.W  #1,D0
       BEQ     L03552      * delete
       MOVEQ   #-$0F,D0    * bad parameter
       BRA     L003A6


* trap2, open
L032D0 MOVEM.L A1-A4,-(A7)
       MOVEA.L A0,A1
       JSR     L003BC(PC)    * returns bas addr. in A0, jobid in d1
       EXG     A1,A0
       MOVEA.L $0078(A6),A3  * SV.CHBAS
L032E0 TST.B   (A3)          * find free entry in chan table
       BLT.S   L032F0
       ADDQ.W  #4,A3
       CMPA.L  $007C(A6),A3  * SV.CHTOP
       BLT.S   L032E0
       MOVEQ   #-$06,D0
       BRA.S   L0334C

L032F0 MOVEA.L $0044(A6),A2      * SV.DRLIST
L032F4 MOVEM.L D1-D7/A1-A6,-(A7)
       LEA     -$0018(A2),A3
       MOVEA.L $0008(A2),A4
       JSR     (A4)
       MOVEM.L (A7)+,D1-D7/A1-A6
       TST.L   D0
       BEQ.S   L0331E
       CMPI.W  #$FFF9,D0
       BNE.S   L0334C
       MOVEA.L (A2),A2
       MOVE.L  A2,D0
       BGT.S   L032F4
       JSR     L0355A(PC)           * try directory drivers
       TST.L   D0
       BNE.S   L0334C

* chanel opened without error

L0331E MOVE.L  A0,(A3)
       MOVE.W  $0070(A6),D2   * SV.CHTAG
       ADDQ.W  #1,$0070(A6)
       ADDQ.W  #4,A0
       MOVE.L  A2,(A0)+
       MOVE.L  D1,(A0)+
       MOVE.L  A3,(A0)+
       MOVE.W  D2,(A0)+
       CLR.W   (A0)+
       CLR.L   (A0)+
       SWAP    D2
       SUBA.L  $0078(A6),A3   * SV.CHBAS
       MOVE.W  A3,D2
       LSR.W   #2,D2
       MOVEA.L D2,A0
       CMP.W   $0072(A6),D2   * SV.CHMAX
       BLS.S   L0334C
       MOVE.W  D2,$0072(A6)   * SV.CHMAX
L0334C MOVEM.L (A7)+,A1-A4
       BRA.S   L03378

* maintain channel closing trap 2, d0 = 2
* close channel a0
L03352 MOVE.L  A0,D7
       JSR     L03476(PC)           * channel base ->a0
       MOVEM.L D1-D7/A1-A6,-(A7)
       MOVEA.L $0004(A0),A4
       LEA     -$0018(A4),A3
       MOVEA.L $000C(A4),A4
       JSR     (A4)
       MOVEM.L (A7)+,D1-D7/A1-A6
       LSL.W   #2,D7
       MOVEA.L $0078(A6),A0  * SV.CHBAS
       ADDA.W  D7,A0
       ST      (A0)
L03378 BRA     L003A6               * invalidate table entry

* do trap #3 call
* see also L03480
L0337C MOVE.L  A0,D7
       JSR     L03476(PC)   * channel base ->a0
       TAS     $0012(A0)    * CH.STAT
       BNE     L03414       * blocked ->
       MOVEM.L D2-D7/A2-A6,-(A7)
       CLR.L   -(A7)            * a6 relative offset
       ANDI.L  #$0000007F,D0
       CMPI.B  #$49,D0
       BGT.S   L033B0
       CMPI.B  #$46,D0
       BGE.S   L033AE
       CMPI.B  #$07,D0
       BGT.S   L033B0
       BTST    #$01,D0
       BEQ.S   L033B0
L033AE MOVEQ   #$00,D1
L033B0 MOVEA.L $0064(A6),A3     * SV.JBPNT
       MOVEA.L (A3),A3
       BCLR    #$07,$0016(A3)   * tst&clear trap#4 bit
       BEQ.S   L033C4
       MOVE.L  $0008(A5),(A7)
       ADDA.L  (A7),A1          * adjust for a6 relative
L033C4 MOVEA.L $0004(A0),A4     * CH.DRIVR
       MOVE.B  D0,$0013(A0)     * CH.ACTN
       MOVEQ   #$00,D3          * 1st call
       LEA     -$0018(A4),A3
       MOVEA.L $0004(A4),A4
       JSR     (A4)             * do the I/O
       SUBA.L  (A7),A1
       CMPI.W  #-1,D0           * err.nc?
       BNE.S   L03422
       MOVE.W  $000A(A7),D3
       BEQ.S   L03422           * tmout=0 -> return error
       MOVEA.L $002C(A7),A6     * restore SYS.BASE
       JSR     L00408(PC)       * current jobid,jobheader=d0,a3
       MOVE.L  D0,$0014(A0)     * channel busy with CH.JOBW
       LEA     $0012(A0),A0     * CH.STAT
       TST.L   (A7)+            * already set?
       BNE.S   L033FC
       ST      (A0)             * no: channel busy
L033FC MOVE.L  A0,$000C(A3)     * JOB.HOLD
       MOVE.W  D3,$0014(A3)     * JOB.STAT=timeout
       SF      $0012(A3)        * clear accumulated priority
       MOVEQ   #-$01,D0
       MOVEM.L (A7)+,D2-D7/A2-A6
L0340E MOVEA.L D7,A0
       BRA     L00936

L03414 TST.W   D3                   * timeout ?
       BEQ.S   L0341E               * -> return
       SUBQ.L  #2,$000E(A7)         * adjust jobs PC before the trap#3
       BRA.S   L0340E               * since channel blocked by other job

L0341E MOVEQ   #-$01,D0
       BRA.S   L0342C

L03422 ADDQ.W  #4,A7
       MOVEM.L (A7)+,D2-D7/A2-A6
       SF      $0012(A0)    * clear CH.STAT
L0342C MOVEA.L D7,A0
       BRA     L003A6

* trap 4 execution

L03432 MOVE.L  A3,-(A7)
       MOVEA.L $0064(A6),A3  * SV.JBPNT
       MOVEA.L (A3),A3
       TAS     $0016(A3)
       MOVEA.L (A7)+,A3
       BRA     L003A6

* verify that channel exists and find its base

L03444 MOVE.L  A0,-(A7)
       MOVE.L  D0,-(A7)
L03448 MOVE.L  A0,D0
       CMP.W   $0072(A6),D0   * SV.CHMAX
       BHI.S   L0346E
       LSL.W   #2,D0
       MOVEA.L $0078(A6),A0   * SV.CHBAS
       ADDA.W  D0,A0
       TST.B   (A0)
       BLT.S   L0346E
       MOVEA.L (A0),A0
       SWAP    D0
       CMP.W   $0010(A0),D0    * CH.TAG
       BNE.S   L0346E
       MOVE.L  (A7)+,D0
       ADDQ.W  #4,A7
       CMP.B   D0,D0  * sets equ-flag
L0346C RTS

L0346E ADDQ.W  #4,A7
       MOVEQ   #-$06,D0     * channel not open
       MOVEA.L (A7)+,A0
       RTS

L03476 BSR.S   L03444
       BEQ.S   L0346C
       ADDQ.W  #4,A7
       BRA     L003A6

L03480
       DC.L    0        * no more scheduler tasks
       DC.L    L03488   * adress of task
       
L03488 MOVEA.L $0074(A6),A1   * test for pending I/O on any channel
       MOVEA.W $0072(A6),A2   * SV.CHMAX
       ADDA.W  A2,A2
       ADDA.W  A2,A2
       ADDA.L  $0078(A6),A2
       MOVEA.L A1,A3
L0349A ADDQ.W  #4,A1          * loop
       CMPA.L  A2,A1
       BLE.S   L034A4
       MOVEA.L $0078(A6),A1
L034A4 TST.B   (A1)           * valid entry ?
       BLT.S   L034B0
       MOVEA.L (A1),A0
       MOVE.B  $0012(A0),D4   * channel busy ?
       BNE.S   L034B6         * -> work
L034B0 CMPA.L  A1,A3
       BNE.S   L0349A
       BRA.S   L03522         * rts

L034B6 MOVE.L  A1,$0074(A6)  * SV.CHPNT
       MOVE.L  $0014(A0),D1  * CH.JOBWT
       LSL.W   #2,D1
       MOVEA.L $0068(A6),A4  * SV.JBBAS
       ADDA.W  D1,A4
       TST.B   (A4)
       BLT.S   L03524
       MOVEA.L (A4),A4       * JOB.BASE
       SWAP    D1
       CMP.W   $0010(A4),D1  * JOB.TAG
       BLT.S   L03524
       MOVEQ   #$00,D0           * prepare for trap#3  restart
       MOVE.B  $0013(A0),D0      * CH.ACTN
       MOVEQ   #-$01,D3          * restarted call
       MOVEM.L $0024(A4),D1-D2
       MOVEM.L $0044(A4),A1-A2
       MOVE.L  A4,-(A7)
       CLR.L   -(A7)
       ADDQ.B  #1,D4
       BEQ.S   L034F6            * -> not A6 relative
       MOVE.L  $0058(A4),(A7)    * job.a6
       ADDA.L  (A7),A1
L034F6 MOVEA.L $0004(A0),A4
       LEA     -$0018(A4),A3
       MOVEA.L $0004(A4),A4
       JSR     (A4)
       SUBA.L  (A7)+,A1          * adjust relative
       MOVEA.L (A7)+,A4          * JOB.BASE
       MOVE.L  D1,$0024(A4)
       MOVE.L  A1,$0044(A4)
       CMPI.B  #-1,D0
       BEQ.S   L03522
       MOVE.L  D0,$0020(A4)      * set D0 of job
       CLR.B   $0012(A0)         * CH.STAT
       CLR.W   $0014(A4)         * JOB.STAT
L03522 RTS

L03524 CLR.B   $0012(A0)    * CH.STAT
       RTS


* MDV_Motor on
L0352A MOVEM.L D0-D3/A0-A4,-(A7)
       MOVEQ   #$00,D1
       MOVE.B  (A1),D1
       LSR.B   #4,D1
       LSL.B   #2,D1
       LEA     $0100(A6),A2    * SV.FSDEF
       MOVEA.L $00(A2,D1.W),A2
       MOVEA.L $0010(A2),A4
       LEA     -$0018(A4),A3
       MOVEA.L $0010(A4),A4
       JSR     (A4)
       MOVEM.L (A7)+,D0-D3/A0-A4
       RTS


*#: delete file
L03552 ST      D3
       BSR.S   L03564
       BRA     L003A6


*#: open DDEV channel
L0355A CMPI.B  #$04,D3          * -1,4
       BLS.S   L03564
       MOVEQ   #-$0F,D0
       RTS

L03564 MOVEM.L D1-D6/A3-A6,-(A7)
       MOVEA.L A0,A5
       MOVE.L  #$00A0,D1
       JSR     L02FAE(PC)       * MM.ALCHP
       BNE     L0368A
       ADDA.W  #$0018,A0
       LEA     $0140(A6),A1     * SV.FSLIST
       JSR     L039DC(PC)       * UT.LINK
       LEA     (A5),A1          * ???
       JSR     L036D4(PC)
       BNE     L0366E           * error: unlink, dealloc

       MOVEQ   #$0F,D2          * counter 16
       MOVEQ   #-$01,D0
       LEA     $0140(A6),A4     * SV.FSDEF+$40

L03596 MOVE.L  -(A4),D3
       BNE.S   L0359E
       MOVE.W  D2,D0            * remember free place
       BRA.S   L035AC           * next
L0359E MOVEA.L D3,A1
       CMP.B   $0014(A1),D1     * drive# =?
       BNE.S   L035AC
       CMPA.L  $0010(A1),A2     * this driver ?
       BEQ.S   L035DC
L035AC DBF     D2,L03596

       MOVE.W  D0,D2            * found free pointer ?
       BLT     L0366C
       MOVEM.L D1-D2/A0/A2,-(A7)    * alloc new drive def block
       MOVE.L  $0020(A2),D1
       JSR     L02FAE(PC)   * MM.ALCHP
       MOVEM.L (A7)+,D1-D2/A1-A2
       EXG     A1,A0
       BNE     L0366E
       MOVE.L  A2,$0010(A1)     * driver
       MOVE.B  D1,$0014(A1)     * drive#
       MOVE.W  D2,D0
       LSL.W   #2,D0
       ADDA.W  D0,A4
       MOVE.L  A1,(A4)          * set SV.FSDEF table entry

L035DC MOVE.B  D2,$0005(A0)     * chdef+$18+$5
       MOVE.B  $000B(A7),$0004(A0)  * delete(-1) or D3 code
       LEA     $001A(A0),A4     * +$18, save name in channel defblock
       MOVE.W  (A5)+,D0
       MOVE.W  $0024(A2),D3
       ADDQ.W  #2,D3            * drv namelen
       ADDA.W  D3,A5
       SUB.W   D3,D0
       BLT.S   L03660
       CMPI.W  #$0024,D0        * maxlen 36 + drive#_
       BGT.S   L03660
       MOVE.W  D0,(A4)+
       BRA.S   L03604

L03602 MOVE.B  (A5)+,(A4)+      * copy name
L03604 DBF     D0,L03602
       MOVEA.L A1,A5
       MOVEA.L A0,A1
L0360C MOVEA.L (A1),A1          * next linked  channel
       MOVE.L  A1,D0
       BEQ.S   L03652           * no more ..., find file
       CMP.B   $0005(A1),D2     * same drive?
       BNE.S   L0360C
       MOVEQ   #$01,D0          * compare file names
       MOVEA.W #$001A,A6            * name offset
       JSR     L03A9C(PC)           * UT.CSTR
       MOVEA.L $0024(A7),A6         * restore
       BNE.S   L0360C               * not same file

       CMPI.B  #$02,$0004(A0)
       BEQ.S   L03664               * already exists
       CMPI.B  #$01,$0004(A0)
       BNE.S   L03668               * in use
       CMPI.B  #$01,$0004(A1)
       BNE.S   L03668
       MOVE.W  $0006(A1),$0006(A0)  * read only, copy info
       MOVE.L  $000C(A1),$000C(A0)
       MOVE.W  #$0040,$000A(A0)
L03652 MOVEA.L A5,A1                * drive def
       TST.W   $0006(A0)            * file already located ?
       BEQ.S   L03690               * -> no, find it
       SUBA.W  #$0018,A0
       BRA.S   L03684               * ok, return

L03660 MOVEQ   #-$0C,D0
       BRA.S   L0366E

L03664 MOVEQ   #-$08,D0
       BRA.S   L0366E

L03668 MOVEQ   #-$09,D0
       BRA.S   L0366E

L0366C MOVEQ   #-$06,D0
L0366E LEA     $0140(A6),A1  * SV.FSLST
       JSR     L039E2(PC)    * UT.UNLNK
       SUBA.W  #$0018,A0
       MOVE.L  D0,D4
       JSR     L0305E(PC)    * MT.RECHP
       MOVE.L  D4,D0
       BRA.S   L0368A

L03684 ADDQ.B  #1,$0022(A1)
       MOVEQ   #$00,D0
L0368A MOVEM.L (A7)+,D1-D6/A3-A6
       RTS
       

*#: call ddev_open
L03690 SUBA.W  #$0018,A0            *
       MOVE.L  A1,-(A7)
       MOVE.L  A2,-(A7)
       LEA     -$0018(A2),A3
       MOVEA.L $0008(A2),A4
       JSR     (A4)
       MOVEA.L (A7)+,A2
       MOVEA.L (A7)+,A1
       TST.B   $001C(A0)            * delete file ?
       BLT.S   L036B0
       TST.L   D0
       BEQ.S   L03684               * success
L036B0 ADDA.W  #$0018,A0
       BRA.S   L0366E               * return D0


*#: FORMAT SECTORED MEDIUM
L036B6 MOVEM.L D3-D7/A1-A5,-(A7)
       MOVEA.L A0,A1
       JSR     L036D4(PC)
       BLT.S   L036CC
       LEA     -$0018(A2),A3
       MOVEA.L $001C(A2),A4
       JSR     (A4)                 * dev_format
L036CC MOVEM.L (A7)+,D3-D7/A1-A5
       BRA     L003A6


* VERIFY NAME
*#: find drive a1=file_name< >a2 driver > d1=drive#num
L036D4 MOVEM.L A1/A4,-(A7)
       MOVEA.L $0048(A6),A2   * SV.DDLST
L036DC LEA     $0024(A2),A4   * DRIVE namelen
       MOVE.W  (A4)+,D0
       MOVEA.L (A7),A1
       ADDQ.W  #2,A1
L036E6 MOVE.B  (A1)+,D1
       BCLR    #$05,D1        * uppercase
       CMP.B   (A4)+,D1
       BNE.S   L036F6         * try next driver
       SUBQ.W  #1,D0
       BGT.S   L036E6
       BRA.S   L036FE         * drive name matches

L036F6 MOVEA.L (A2),A2
       MOVE.L  A2,D0          * next driver
       BNE.S   L036DC
       BRA.S   L03718         * no more drivers

L036FE MOVEQ   #$00,D1
       MOVE.B  (A1)+,D1
       SUBI.B  #$30,D1        * 1<=drive number<=8
       BLE.S   L03718
       CMPI.B  #$09,D1
       BGE.S   L03718
       CMPI.B  #$5F,(A1)      * '_'
       BNE.S   L03718
       MOVEQ   #$00,D0
       BRA.S   L0371A         * ok, rts

L03718 MOVEQ   #-$07,D0
L0371A MOVEM.L (A7)+,A1/A4
       RTS


*#: a2= (a2+1)& (not 1)
L03720 MOVE.L  A2,D2
       ADDQ.L  #1,D2
       BCLR    #$00,D2
       MOVEA.L D2,A2
       RTS


* ANALYSE SYNTAX
L0372C MOVEA.L (A7),A2              * IO.DECODE
       ADDQ.W  #6,A2
       MOVEM.L D4/D7/A0/A3,-(A7)
       MOVEQ   #$00,D7
       MOVE.W  (A0)+,D7
       ADD.L   A0,D7
       MOVE.W  (A2)+,D2
L0373C BSR.S   L037B6
       CMP.B   (A2)+,D1
       BNE.S   L037A6
       SUBQ.B  #1,D2
       BNE.S   L0373C
       BSR.S   L03720
       MOVE.W  (A2)+,D4
       BRA.S   L03790

L0374C BSR.S   L03720
       MOVE.B  (A2)+,D1
       BEQ.S   L03778
       BLT.S   L03760
       BSR.S   L037B6
       CMP.B   (A2)+,D1
       BEQ.S   L03762
       SUBQ.W  #1,A0
       MOVE.W  (A2)+,(A3)+
       BRA.S   L03790

L03760 ADDQ.W  #1,A2
L03762 MOVEA.L A7,A1
       MOVE.W  (A2)+,-(A7)
       SUBA.L  A6,A0
       SUBA.L  A6,A1
       SUB.L   A6,D7
       JSR     L03DC2(PC)
       ADDA.L  A6,A0
       ADD.L   A6,D7
       MOVE.W  (A7)+,(A3)+
       BRA.S   L03790

L03778 MOVE.B  (A2)+,D2
       EXT.W   D2
L0377C ADDA.W  D2,A2   * IO.SERQ
       MOVE.L  A2,-(A7)
       BSR.S   L037B6
L03782 CMP.B   -(A2),D1
       BEQ.S   L0378C
       SUBQ.W  #1,D2
       BNE.S   L03782
       SUBQ.W  #1,A0
L0378C MOVE.W  D2,(A3)+
       MOVEA.L (A7)+,A2
L03790 DBF     D4,L0374C
       CMP.L   A0,D7
       BNE.S   L0379C
       MOVEQ   #$04,D1
       BRA.S   L037AE

L0379C MOVEM.L (A7)+,D4/D7/A0/A3
       ADDQ.L  #2,(A7)
       MOVEQ   #-$0C,D0
       RTS

L037A6 MOVEM.L (A7)+,D4/D7/A0/A3
       MOVEQ   #-$07,D0
       RTS

L037AE MOVEM.L (A7)+,D4/D7/A0/A3
       ADDQ.L  #4,(A7)
       RTS

L037B6 MOVEQ   #$00,D1
       CMP.L   A0,D7
       BEQ.S   L037C8
       MOVE.B  (A0),D1
       CMPI.B  #$60,D1
       BLT.S   L037C8
       SUBI.B  #$20,D1
L037C8 ADDQ.W  #1,A0
       RTS


* DIRECT FILE HANDLING
* queue routines
L037CC LEA     $0018(A0),A2   * pipe#  I / O
       CMPI.B  #$03,D0
       BLS.S   L037D8
       ADDQ.W  #4,A2
L037D8 TST.L   (A2)
       BEQ.S   L037F0
       MOVEA.L (A2),A2
       JSR     L0388C(PC)    * IO.SERIO
       DC.L    XL0380A       * ROUTINE TEST FILE
       DC.L    XL0385E       * READ FROM PIPE
       DC.L    XL03838       * WRITE TO PIPE
       RTS

L037F0 MOVEQ   #-$0F,D0
       RTS


L037F4 LEA     $10(A2,D1.W),A3  * IO.QSET
       CLR.L   (A2)+
       MOVE.L  A3,(A2)+
       SUBQ.W  #1,A3
       MOVE.L  A3,(A2)+
       MOVE.L  A3,(A2)+
       SUBA.L  #$10,A2
       RTS


* test status of queue
L0380A 
XL0380A EQU L0380A
       MOVEQ   #-$11,D2         * IO.QTEST
       ADD.L   $0004(A2),D2
       SUB.L   A2,D2
       MOVE.L  $0008(A2),D0
       MOVEA.L $000C(A2),A3
       MOVE.B  (A3),D1
       SUB.L   A3,D0
       BGT.S   L03832
       BLT.S   L0382E
       TST.B   (A2)
       BLT.S   L0382A
       MOVEQ   #-$01,D0
       RTS

L0382A MOVEQ   #-$0A,D0
       RTS

L0382E ADD.L   D2,D0
       ADDQ.L  #1,D0
L03832 SUB.L   D0,D2
       MOVEQ   #$00,D0
       RTS

* put byte into queue
* Vector EA
L03838 
XL03838 EQU L03838
       TST.B   (A2)          * IO.QIN
       BNE.S   L0385A
       MOVEA.L $0008(A2),A3
       MOVE.B  D1,(A3)+
       CMPA.L  $0004(A2),A3
       BLT.S   L0384C
       LEA     $0010(A2),A3
L0384C CMPA.L  $000C(A2),A3
       BNE.S   L03856
       MOVEQ   #-$01,D0
       RTS

L03856 MOVE.L  A3,$0008(A2)
L0385A MOVEQ   #$00,D0
       RTS

* Vector E2 + WRITE TO PIPE

L0385E 
XL0385E EQU L0385E
       MOVEA.L $000C(A2),A3     * IO.QOUT
       CMPA.L  $0008(A2),A3
       BNE.S   L03874
       TST.B   (A2)
       BLT.S   L03870
       MOVEQ   #-$01,D0
       RTS

L03870 MOVEQ   #-$0A,D0
       RTS

L03874 MOVE.B  (A3)+,D1
       CMPA.L  $0004(A2),A3
       BLT.S   L03880
       LEA     $0010(A2),A3
L03880 MOVE.L  A3,$000C(A2)
       MOVEQ   #$00,D0
       RTS

L03882 EQU L03880+2

L03888 TAS     (A2)             * IO.QEOF
       RTS

* Vector EA

L0388C ADDI.L  #$0000000C,(A7)   * IO.SERIO - d0 as trap 3
       MOVEA.L (A7),A4
       MOVE.L  D2,D4
       MOVE.L  D1,D5
       CMPI.W  #$0045,D0
       BHI.S   L038B2
       CMPI.W  #$0007,D0
       BHI.S   L03914
       ANDI.L  #$0000FFFF,D4
       MOVE.B  L038C0(PC,D0.W),D0
       JMP     L038C0(PC,D0.W)
       
L038B2 CMPI.B  #$49,D0
       BHI.S   L03914
       MOVE.B  L038C0-$3E(PC,D0.W),D0
       JMP     L038C0(PC,D0.W)

L038C0 DC.B    XL0390A-L038C0
       DC.B    XL0390C-L038C0
       DC.B    XL038CC-L038C0
       DC.B    XL038F8-L038C0
       DC.B    XL03914-L038C0
       DC.B    XL0390E-L038C0
       DC.B    XL03914-L038C0
       DC.B    XL038E4-L038C0
       DC.B    XL03930-L038C0
       DC.B    XL03944-L038C0
       DC.B    XL038F8-L038C0
       DC.B    XL038E4-L038C0
       
L038CC MOVE.L  -$0008(A4),A4
XL038CC EQU L038CC
L038D0 CMP.L   D5,D4
       BLS.S   L03918
       BSR.S   L03922
       BNE.S   L0391E
       MOVE.B  D1,(A1)+
       ADDQ.L  #1,D5
       CMPI.B  #$0A,D1
       BNE.S   L038D0
       BRA.S   L0391E

L038E4 MOVEA.L -$0004(A4),A4
L038E8 CMP.L   D5,D4
       BLS.S   L0391C
       MOVE.B  (A1),D1
       BSR.S   L03922
       BNE.S   L0391E
       ADDQ.W  #1,A1
       ADDQ.L  #1,D5
       BRA.S   L038E8

XL038E4 EQU L038E4

L038F8 MOVEA.L -$0008(A4),A4
XL038F8 EQU L038F8
L038FC CMP.L   D5,D4
       BLS.S   L0391C
       BSR.S   L03922
       BNE.S   L0391E
       MOVE.B  D1,(A1)+
       ADDQ.L  #1,D5
       BRA.S   L038FC

L0390A SUBQ.W  #4,A4
L0390C SUBQ.W  #4,A4
L0390E MOVEA.L -$0004(A4),A4
       BRA.S   L03922
       
XL0390A EQU L0390A
XL0390C EQU L0390C
XL0390E EQU L0390E

L03914 MOVEQ   #-$0F,D0
       BRA.S   L0392C
XL03914 EQU L03914
L03918 MOVEQ   #-$05,D0
       BRA.S   L0391E

L0391C MOVEQ   #$00,D0
L0391E MOVE.L  D5,D1
       BRA.S   L0392C

L03922 MOVEM.L D4-D5/A1/A4,-(A7)
       JSR     (A4)
       MOVEM.L (A7)+,D4-D5/A1/A4
L0392C TST.L   D0
       RTS

L03930
XL03930 EQU L03930
       MOVEA.L -$0004(A4),A4
       MOVEQ   #$0F,D4
       TST.W   D5
       BGT.S   L038E8
       ST      D1
       BSR.S   L03922
       BNE.S   L0391E
       MOVEQ   #$01,D5
       BRA.S   L038E8

L03944
XL03944 EQU L03944
       MOVEQ   #$0F,D4
       TST.W   D5
       BGT.S   L038F8
       MOVEA.L -$000C(A4),A4
       BSR.S   L03922
       BNE.S   L0391E
       ADDQ.B  #1,D1
       BNE.S   L03914
       MOVEA.L (A7),A4
       BSR.S   L0390C
       MOVEQ   #$01,D5
       BRA.S   L038FC

L0395E MOVE.L  A0,-(A7)  * UT.ERR0
       SUBA.L  A0,A0
       BSR.S   L03968    * UT.ERR
       MOVEA.L (A7)+,A0
       RTS

L03968 TST.L   D0         * UT.ERR
       BGE.S   L0398E
       MOVEM.L D0-D3/A1,-(A7)
       MOVEA.L D0,A1
       ADD.L   D0,D0
       BVS.S   L03986
       NEG.W   D0
       MOVEA.L $0002814A,A1  * TABLE OF ERROR-MESSAGES 
       MOVE.W  $00(A1,D0.W),D0
       LEA     $00(A1,D0.W),A1
L03986 JSR     L039B2(PC)    * UT.MTEXT
       MOVEM.L (A7)+,D0-D3/A1
L0398E RTS

L03990 MOVE.L  A6,-(A7)  * UT.MINT
       SUBA.L  A6,A6
       MOVEA.L A7,A1
       SUBQ.W  #8,A7
       MOVE.L  A0,-(A7)
       LEA     $0004(A7),A0
       MOVE.W  D1,-(A1)
       JSR     L03E54(PC)   * CN.ITOD
       MOVEA.L (A7)+,A0
       MOVEA.L A7,A1
       MOVE.W  D1,D2
       BSR.S   L039B4
       ADDQ.W  #8,A7
       MOVEA.L (A7)+,A6
       RTS

L039B2 MOVE.W  (A1)+,D2   * UT.MTEXT
L039B4 MOVEQ   #$07,D0
       MOVE.L  A0,D3
       BEQ.S   L039BE
       MOVEQ   #-$01,D3
       BRA.S   L039C4

L039BE SF      $00028033

L039C4 TRAP    #$03
       CMPI.W  #$FFFF,D0
       BNE.S   L039D8
       MOVE.L  #$00010001,A0   * scr#1
       MOVEQ   #$07,D0
       TRAP    #$03
       SUBA.L  A0,A0
L039D8 TST.L   D0
       RTS

* vector d2

L039DC MOVE.L  (A1),(A0)    * UT.LINK
       MOVE.L  A0,(A1)
       RTS

* vector d4

L039E2 CMPA.L  (A1),A0      * UT.UNLNK
       BEQ.S   L039EE
       TST.L   (A1)
       BEQ.S   L039F0
       MOVEA.L (A1),A1
       BRA.S   L039E2

L039EE MOVE.L  (A0),(A1)
L039F0 RTS

L039F2 BSR.S   L03A2A    * UT.WINDW
       BRA.S   L03A0C

L039F6 LEA     L03A44(PC),A0    * UT.CON
       BRA.S   L03A00

L039FC LEA     L03A4A(PC),A0   * UT.SCR
L03A00 BSR.S   L03A2A
L03A02 ADDQ.W  #4,A1
       MOVEQ   #$0D,D0
       MOVEQ   #$00,D2
       BSR.S   L03A36
       SUBQ.W  #4,A1
L03A0C MOVEQ   #$0C,D0
       MOVE.B  (A1)+,D1
       MOVE.B  (A1)+,D2
       BSR.S   L03A36
       MOVEQ   #$27,D0
       MOVE.B  (A1),D1
       BSR.S   L03A36
       MOVEQ   #$28,D0
       MOVE.B  (A1)+,D1
       BSR.S   L03A36
       MOVEQ   #$29,D0
       MOVE.B  (A1),D1
       BSR.S   L03A36
       MOVEQ   #$20,D0
       BRA.S   L03A36

* open window#

L03A2A MOVE.L  A1,-(A7)
       MOVEQ   #$01,D0
       MOVEQ   #-$01,D1
       MOVEQ   #$00,D3
       TRAP    #$02
       BRA.S   L03A3A

* windowtrap

L03A36 MOVE.L  A1,-(A7)
       TRAP    #$03
L03A3A MOVEA.L (A7)+,A1
       TST.L   D0
       BEQ.S   L03A42
       ADDQ.W  #4,A7
L03A42 RTS

L03A44 DC.W    $03
       DC.B    'CON',$00
L03A4A DC.W    $03
       DC.B    'SCR',$00
       
* set pointer for string-compa.

L03A50 MOVEQ   #$00,D4
       MOVE.B  D0,D4
       ROR.L   #1,D4
       SUBQ.B  #2,D4
       MOVE.W  $00(A6,A0.L),D0
       ADDQ.W  #2,A0
       LEA     $00(A0,D0.W),A2
       MOVE.W  $00(A6,A1.L),D1
       ADDQ.W  #2,A1
       LEA     $00(A1,D1.W),A3
       RTS

* find pos of string 2 in string 1

L03A6E MOVEM.L D4/A0-A4,-(A7)
       BSR.S   L03A50
       LEA     $00(A1,D0.W),A4
       EXG     A3,A4
       MOVEQ   #$00,D1
L03A7C CMPA.L  A4,A3
       BGT.S   L03A8C
       ADDQ.L  #1,D1
       BSR.S   L03A96
       BEQ.S   L03A90
       ADDQ.W  #1,A1
       ADDQ.W  #1,A3
       BRA.S   L03A7C

* string comparison

L03A8C MOVEQ   #$00,D1
       MOVEQ   #$00,D0
L03A90 MOVEM.L (A7)+,D4/A0-A4
       RTS

L03A96 MOVEM.L D1-D5/A0-A3,-(A7)
       BRA.S   L03AA2

L03A9C MOVEM.L D1-D5/A0-A3,-(A7)
       BSR.S   L03A50
L03AA2 CMPA.L  A2,A0
       BNE.S   L03AAC
       CMPA.L  A3,A1
       BNE.S   L03AC8
       BRA.S   L03ACC

L03AAC CMPA.L  A3,A1
       BEQ.S   L03AD0
       BSR.S   L03AE8
       CMP.B   D4,D0
       BEQ.S   L03B2C
       CMP.B   D3,D2
       BNE.S   L03AC6
       TST.B   D0
       BLE.S   L03AA2
       TST.L   D4
       BLT.S   L03AA2
       CMPI.B  #$02,D0
L03AC6 BGT.S   L03AD0
L03AC8 MOVEQ   #-$01,D0
       BRA.S   L03AD2

L03ACC MOVEQ   #$00,D0
       BRA.S   L03AD2

L03AD0 MOVEQ   #$01,D0
L03AD2 MOVEM.L (A7)+,D1-D5/A0-A3
       RTS
       
* Table of results of string comparison

L03AD8 DC.W    $0000
       DC.W    $0000
       DC.W    $00FF
       DC.W    $0000
       DC.W    $0000
       DC.W    $0001
       DC.W    $0000
       DC.W    $0300

* compare bytes of string
       
L03AE8 EXG     A0,A1
       EXG     A2,A3
       BSR.S   L03B04
       EXG     A0,A1
       EXG     A2,A3
       MOVE.B  D0,D1
       MOVE.B  D2,D3
       BSR.S   L03B04
       LSL.B   #2,D0
       ADD.B   D1,D0
       EXT.W   D0
       MOVE.B  L03AD8(PC,D0.W),D0
       RTS

* correct decimal values (3.5)

L03B04 MOVE.B  $00(A6,A0.L),D2
       ADDQ.W  #1,A0
       BSR     L03BFA
       CMPI.B  #$CE,D2
       BNE.S   L03B2A
       CMPA.L  A2,A0
       BEQ.S   L03B28
       CMPI.B  #$30,$00(A6,A0.L)
       BLT.S   L03B28
       CMPI.B  #$39,$00(A6,A0.L)
       BLE.S   L03B2A
L03B28 CLR.B   D0
L03B2A RTS

* compare two ASCII numbers

L03B2C BSR.S   L03B96
       MOVE.W  D3,D2
       MOVE.W  D1,D3
       EXG     A0,A1
       EXG     A2,A3
       BSR.S   L03B96
       CMP.W   D1,D3
L03B3A BNE.S   L03AC6
       SUBA.W  D1,A0
       SUBA.W  D1,A1
       BRA.S   L03B50

L03B42 MOVE.B  $00(A6,A1.L),D5
       ADDQ.W  #1,A1
       CMP.B   $00(A6,A0.L),D5
       ADDQ.W  #1,A0
       BNE.S   L03B3A
L03B50 DBF     D1,L03B42
       BSR.S   L03BCC
       MOVE.W  D3,-(A7)
       MOVE.W  D1,-(A7)
       EXG     A0,A1
       EXG     A2,A3
       BSR.S   L03BCC
       MOVE.W  (A7)+,D0
       MOVE.W  (A7)+,D2
       SUB.W   D2,D3
       BGT.S   L03B6A
       ADD.W   D3,D2
L03B6A TST.W   D2
       BEQ.S   L03B8C
       SUBA.W  D1,A0
       SUBA.W  D0,A1
       SUB.W   D2,D1
       SUB.W   D2,D0
L03B76 MOVE.B  $00(A6,A0.L),D5
       ADDQ.W  #1,A0
       CMP.B   $00(A6,A1.L),D5
       ADDQ.W  #1,A1
       BNE.S   L03B3A
       SUBQ.W  #1,D2
       BNE.S   L03B76
       ADDA.W  D1,A0
       ADDA.W  D0,A1
L03B8C TST.W   D3
       BNE     L03AC6
       BRA     L03AA2

L03B96 MOVEQ   #$00,D1
L03B98 CMPI.B  #$D0,D2
       BNE.S   L03BB0
       CMPA.L  A2,A0
       BEQ.S   L03BCA
       MOVE.B  $00(A6,A0.L),D2
       ADDQ.W  #1,A0
       BSR.S   L03BFA
       SUBQ.B  #1,D0
       BNE.S   L03BC8
       BRA.S   L03B98

L03BB0 CMPI.B  #$CE,D2
       BEQ.S   L03BC8
       ADDQ.W  #1,D1
       CMPA.L  A2,A0
       BEQ.S   L03BCA
       MOVE.B  $00(A6,A0.L),D2
       ADDQ.W  #1,A0
       BSR.S   L03BFA
       SUBQ.B  #1,D0
       BEQ.S   L03BB0
L03BC8 SUBQ.W  #1,A0
L03BCA RTS

L03BCC MOVEQ   #$00,D1
       MOVEQ   #$00,D3
L03BD0 CMPA.L  A2,A0
       BEQ.S   L03BF8
       MOVE.B  $00(A6,A0.L),D2
       BSR.S   L03BFA
       SUBQ.B  #1,D0
       BNE.S   L03BF8
       CMPI.B  #$CE,D2
       BNE.S   L03BEA
       TST.L   D1
       BNE.S   L03BF8
       MOVEQ   #-$01,D1
L03BEA ADDQ.W  #1,A0
       ADDQ.W  #1,D1
       CMPI.B  #$D0,D2
       BEQ.S   L03BD0
       MOVE.W  D1,D3
       BRA.S   L03BD0

L03BF8 RTS

L03BFA MOVE.B  D2,D0
       BLT.S   L03C14
       CMPI.B  #$2E,D0
       BEQ.S   L03C18
       EXT.W   D0
       ADDI.W  #XVALUE1,D0
       MOVE.B  L03BFA(PC,D0.W),D0
       BEQ.S   L03C14
       SUBQ.B  #2,D0
       BLE.S   L03C18
L03C14 CLR.B   D0
       RTS

L03C18 MOVE.B  D2,D0
       ADDI.B  #$A0,D2
       BCC.S   L03C24
       SUBI.B  #$20,D2
L03C24 LSR.B   #5,D0
       RTS

* this label defines type of ASCII code
L03C28
XVALUE1 EQU L03C28-L03BFA       
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $00000000
       DC.L    $20030000
       DC.L    $24250003
       DC.L    $00000000
       DC.L    $03000000
       DC.L    $02020202
       DC.L    $02020202
       DC.L    $02020003
       DC.L    $00000000
       DC.L    $00010101
       DC.L    $01010101
       DC.L    $01010101
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$00
       DC.B    $00,$00,$00,$01
       DC.B    $00,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$01
       DC.B    $01,$01,$01,$00
       DC.B    $00,$00,$00,$00
       
* test sign of number to convert to floating-point number

L03CA8 CMP.L   A0,D7
       BEQ.S   L03CCA
       ADDQ.W  #1,A0
L03CAE CMPI.B  #$20,$00(A6,A0.L)
       BEQ.S   L03CA8
       MOVEQ   #$00,D5
       MOVEQ   #$2B,D6
       SUB.B   $00(A6,A0.L),D6
       BEQ.S   L03CC8
       ADDQ.B  #2,D6
       BNE.S   L03CCA
       BSET    #$1F,D5
L03CC8 ADDQ.W  #1,A0
L03CCA RTS

* convert ASCII to decimal

L03CCC MOVEQ   #$00,D6
       CMP.L   A0,D7
       BEQ.S   L03CEA
       MOVE.B  $00(A6,A0.L),D6
       SUBI.W  #$0030,D6
       BLT.S   L03CE6
       CMPI.W  #$0009,D6
       BGT.S   L03CE6
       ADDQ.L  #2,(A7)
       BRA.S   L03CEA

L03CE6 ADDI.W  #$0030,D6
L03CEA ADDQ.W  #1,A0
       RTS

* convert entire number from ASCII to decimal

L03CEE BSR.S   L03CAE
       BSR.S   L03CCC
       BRA.S   L03D08    * ERROR
L03CF4 MOVE.L  D6,D3
L03CF6 BSR.S   L03CCC
       BRA.S   L03D0C    * ERROR
L03CFA MULU    #$000A,D3
       ADD.L   D6,D3
       CMPI.L  #$00007FFF,D3
       BLE.S   L03CF6
L03D08 MOVEQ   #-$11,D0
       RTS
       
* TEST SIGN + / -

L03D0C TST.L   D5
       BPL.S   L03D12
       NEG.W   D3
L03D12 MOVEQ   #$00,D0
       RTS

* vector 100 - convert ASCII to floating point

L03D16 MOVEM.L D3-D6/A0-A1,-(A7)   * CN.DTOF
       MOVEQ   #$00,D4
       BSR.S   L03CAE
       SUBQ.W  #6,A1
       CLR.L   $02(A6,A1.L)
       CLR.W   $00(A6,A1.L)
L03D28 BSR.S   L03CCC
       BRA.S   L03D48
L03D2C MOVE.B  #$DF,D5   * CN.DTOI
       TST.W   D4
       BEQ.S   L03D36
       ADDQ.W  #1,D4
L03D36 BSR.S   L03DB6
       JSR     L048DE(PC)
       BNE.S   L03DB0
       MOVE.L  D6,D1
       BSR.S   L03DB8
       JSR     L04838(PC)
       BRA.S   L03D28

L03D48 CMPI.B  #$2E,D6
       BNE.S   L03D56
       TST.W   D4
       BNE.S   L03DAE
       MOVEQ   #$01,D4
       BRA.S   L03D28

L03D56 TST.B   D5
       BEQ.S   L03DAE
       TST.L   D5
       BPL.S   L03D62
       JSR     L04A0C(PC)
L03D62 MOVEQ   #$00,D3
       AND.B   D5,D6
       CMPI.B  #$45,D6
       BNE.S   L03D70
       BSR.S   L03CEE
       BNE.S   L03DB0
L03D70 TST.W   D4
       BEQ.S   L03D76
       SUBQ.W  #1,D4
L03D76 SUB.W   D3,D4
       BVS.S   L03DAE
       BEQ.S   L03DA2
       SGE     D5
       BGE.S   L03D82
       NEG.W   D4
L03D82 BSR.S   L03DB6
       SUBQ.W  #2,A1
       MOVE.W  D4,$00(A6,A1.L)
       JSR     L047DC(PC)
       BNE.S   L03DB0
       TST.B   D5
       BEQ.S   L03D9C
       JSR     L0497E(PC)
       BNE.S   L03DB0
       BRA.S   L03DA2

L03D9C JSR     L048DE(PC)
       BNE.S   L03DB0
L03DA2 MOVEM.L (A7)+,D3-D6
       SUBQ.W  #1,A0
       ADDQ.W  #8,A7
       MOVEQ   #$00,D0
       RTS

L03DAE MOVEQ   #-$11,D0
L03DB0 MOVEM.L (A7)+,D3-D6/A0-A1
       RTS

L03DB6 MOVEQ   #$0A,D1
L03DB8 MOVE.L  #$0000081F,D0
       JMP     L04830(PC)

* vector 102 ASCII to int
* CN.DTOI
L03DC2 MOVEM.L D3-D6/A0-A1,-(A7)
       BSR     L03CEE
       BNE.S   L03DB0
       SUBQ.W  #2,A1
       MOVE.W  D3,$00(A6,A1.L)
       BRA.S   L03DA2

* vector 10A

L03DD4 MOVEQ   #$02,D2   * CN.HTOIB
       BRA.S   L03DDE

* vector 10C

L03DD8 MOVEQ   #$04,D2   * CN.HTOIW
       BRA.S   L03DDE

* vector 10E

L03DDC MOVEQ   #$08,D2   * CN.HTOIL
L03DDE MOVEM.L D3-D6/A0-A1,-(A7)
       MOVE.L  D2,D4
       LSR.B   #1,D4
       SUBQ.W  #2,A1
       MOVE.B  D4,$01(A6,A1.L)
       MOVE.B  #$0F,$00(A6,A1.L)
       MOVEQ   #$04,D4
L03DF4 MOVE.L  D2,D5
       MOVEQ   #$00,D3
L03DF8 BSR     L03CCC
       BRA.S   L03E00    * error
       BRA.S   L03E0E    * ok

L03E00 ANDI.B  #$DF,D6
       SUBI.B  #$41,D6
       BLT.S   L03E1E
       ADDI.B  #$0A,D6
L03E0E CMP.B   $00(A6,A1.L),D6
       BHI.S   L03E1E
       LSL.L   D4,D3
       ADD.L   D6,D3
       DBF     D2,L03DF8
       BRA.S   L03E30

L03E1E MOVE.B  $01(A6,A1.L),D4
       ADDQ.L  #2,A1
       MOVE.L  D3,-$04(A6,A1.L)
       SUBA.L  D4,A1
       CMP.W   D2,D5
       BGT     L03DA2
L03E30 BRA     L03DAE

* vector 104

L03E34 MOVEQ   #$08,D2   * CN.BTOIB
       BRA.S   L03E3E

* vector 106

L03E38 MOVEQ   #$10,D2   * CN.BTOIW
       BRA.S   L03E3E

L03E3C MOVEQ   #$20,D2   * CN.BTOIB
L03E3E MOVEM.L D3-D6/A0-A1,-(A7)
       MOVE.L  D2,D4
       LSR.B   #3,D4
       SUBQ.W  #2,A1
       MOVE.B  D4,$01(A6,A1.L)
       MOVEQ   #$01,D4
       MOVE.B  D4,$00(A6,A1.L)
       BRA.S   L03DF4

* vector F2

L03E54 MOVE.L  A2,-(A7)   * CN.ITOD
       MOVE.L  A0,-(A7)
       MOVEQ   #$00,D0
       MOVE.W  $00(A6,A1.L),D0
       ADDQ.W  #2,A1
       BGE.S   L03E6C
       MOVE.B  #$2D,$00(A6,A0.L)

       ADDQ.W  #1,A0
       NEG.W   D0
L03E6C MOVE.L  A0,-(A7)
       ADDQ.W  #5,A0
L03E70 DIVU    #$000A,D0
       SWAP    D0
       ADDI.B  #$30,D0
       SUBQ.W  #1,A0
       MOVE.B  D0,$00(A6,A0.L)
       CLR.W   D0
       SWAP    D0
       BNE.S   L03E70
       MOVE.L  (A7)+,D1
       SUB.L   A0,D1
       MOVE.W  D1,D0
       ADDQ.W  #4,D0
L03E8E LEA     $00(A0,D1.W),A2
       MOVE.B  $00(A6,A0.L),$00(A6,A2.L)
       ADDQ.W  #1,A0
       DBF     D0,L03E8E
       ADD.L   A0,D1
       MOVEA.L D1,A0
       SUB.L   (A7)+,D1
       MOVEA.L (A7)+,A2
       RTS

L03EA8 BSR     L03EAC            * CN.ITOHL
L03EAC BSR     L03EB0            * CN.ITOHW
L03EB0 MOVE.B  $00(A6,A1.L),D0   * CN.ITOHB
       LSR.B   #4,D0
       BSR.S   L03EC0
       MOVEQ   #$0F,D0
       AND.B   $00(A6,A1.L),D0
       ADDQ.W  #1,A1
L03EC0 ADDI.B  #$30,D0
       CMPI.B  #$39,D0
       BLS.S   L03ECC
       ADDQ.B  #7,D0
L03ECC MOVE.B  D0,$00(A6,A0.L)
       ADDQ.W  #1,A0
       RTS

L03ED4 BSR     L03ED8                   * CN.ITOBL  
L03ED8 BSR     L03EDC                   * CN.ITOBW
L03EDC MOVEQ   #$07,D0                  * CN.ITOBB
L03EDE BTST    D0,$00(A6,A1.L)
       SEQ     $00(A6,A0.L)
       ADDI.B  #$31,$00(A6,A0.L)
       ADDQ.W  #1,A0
       DBF     D0,L03EDE
       ADDQ.W  #1,A1
       RTS

* vector F0
* float to ASCII
L03EF6 MOVEM.L D2-D5,-(A7)   * CN.FTOD
       MOVE.L  A0,-(A7)
       TST.L   $02(A6,A1.L)
       BEQ     L04000
       MOVEQ   #$06,D4
       TST.B   $02(A6,A1.L)
       BGE.S   L03F18
       MOVE.B  #$2D,$00(A6,A0.L)
       ADDQ.W  #1,A0
       JSR     L04A0C(PC)                    * float NEG
L03F18 CMPI.L  #$081B5F60,$00(A6,A1.L)
       BLT.S   L03F2C
       ADDQ.W  #1,D4
       BSR.S   L03F40
       JSR     L0497E(PC)                    * float DIV
       BRA.S   L03F18

L03F2C CMPI.L  #$08184C4C,$00(A6,A1.L)
       BGE.S   L03F6C
       SUBQ.W  #1,D4
       BSR.S   L03F40
       JSR     L048DE(PC)
       BRA.S   L03F2C

L03F40 SUBQ.W  #6,A1
       MOVE.L  #$08045000,$00(A6,A1.L)
       CLR.W   $04(A6,A1.L)
       RTS

L03F50 MOVEQ   #$00,D0
       SWAP    D1
       MOVE.W  D1,D0
       DIVU    #$000A,D0
       SWAP    D0
       MOVE.W  D0,D1
       SWAP    D1
       DIVU    #$000A,D1
       MOVE.W  D1,D0
       SWAP    D1
       EXG     D0,D1
       RTS

L03F6C MOVEQ   #$1F,D0
       SUB.W   $00(A6,A1.L),D0
       MOVE.L  $02(A6,A1.L),D1
       LSR.L   D0,D1
       ADDQ.W  #6,A1
L03F7A ADDQ.L  #5,D1
       BSR.S   L03F50
       ADDQ.W  #1,D4
       CMPI.L  #$00989680,D1
       BGE.S   L03F7A
       ADDQ.W  #8,A0
       MOVEQ   #$06,D2
L03F8C BSR.S   L03F50
       ADDI.B  #$30,D0
       SUBQ.W  #1,A0
       MOVE.B  D0,$00(A6,A0.L)
       DBF     D2,L03F8C
       CMPI.W  #$0005,D4
       BGT.S   L03FAC
       CMPI.W  #$FFFF,D4
       BLT.S   L03FAC
       MOVEQ   #$00,D5
       BRA.S   L03FB0

L03FAC MOVE.L  D4,D5
       MOVEQ   #$00,D4
L03FB0 ADDQ.W  #1,D4
       MOVE.L  A0,D2
       BRA.S   L03FBE

L03FB6 MOVE.B  $00(A6,A0.L),-$01(A6,A0.L)
       ADDQ.W  #1,A0
L03FBE DBF     D4,L03FB6
       MOVE.B  #$2E,-$01(A6,A0.L)
       MOVEA.L D2,A0
       ADDQ.W  #7,A0
L03FCC SUBQ.W  #1,A0
       CMPI.B  #$30,$00(A6,A0.L)
       BEQ.S   L03FCC
       CMPI.B  #$2E,$00(A6,A0.L)
       BEQ.S   L03FE0
       ADDQ.W  #1,A0
L03FE0 TST.W   D5
       BEQ.S   L03FF6
       MOVE.B  #$45,$00(A6,A0.L)
       ADDQ.W  #1,A0
       SUBQ.W  #2,A1
       MOVE.W  D5,$00(A6,A1.L)
       JSR     L03E54(PC)   * CN.ITOD
L03FF6 MOVE.L  A0,D1
       SUB.L   (A7)+,D1
       MOVEM.L (A7)+,D2-D5
       RTS

L04000 MOVE.B  #$30,$00(A6,A0.L)
       ADDQ.W  #1,A0
       ADDQ.W  #6,A1
       BRA.S   L03FF6

L0400C MOVEM.L D0/D5,-(A7)
       CMPI.W  #$000A,D0
       BGE.S   L04034
L04016 SUBQ.W  #1,D5
       BLE.S   L04024
       MOVE.B  #$30,$00(A6,A1.L)
       ADDQ.L  #1,A1
       BRA.S   L04016

L04024 ADDI.W  #$0030,D0
       MOVE.B  D0,$00(A6,A1.L)
       ADDQ.L  #1,A1
       MOVEM.L (A7)+,D0/D5
       RTS

L04034 ANDI.L  #$0000FFFF,D0
       DIVU    #$000A,D0
       SUBQ.W  #1,D5
       BSR.S   L0400C
       SWAP    D0
       BRA.S   L04024

L04046 BSR.S   L0400C
       MOVE.B  #$20,$00(A6,A1.L)
       ADDQ.L  #1,A1
       RTS

L04052 BSR.S   L0400C
       MOVE.B  #$3A,$00(A6,A1.L)
       ADDQ.L  #1,A1
       RTS

* vector CE

L0405E MOVEM.L D1-D5/A2,-(A7)   * CN.DATE
       BSR     L040F6
       SUBA.L  #$16,A1
       MOVE.W  #$0014,$00(A6,A1.L)
       ADDQ.L  #2,A1
       MOVE.W  D2,D0
       MOVEQ   #$04,D5
       BSR.S   L04046
       MULU    #$0003,D4
       MOVEA.L $0002814A,A2  * table of error messages
       MOVE.W  $003A(A2),D0
       LEA     $00(A2,D0.W),A2
       ADDA.W  D4,A2
       BSR.S   L040E8
       MOVE.B  #$20,$00(A6,A1.L)
       ADDQ.L  #1,A1
       MOVEQ   #$02,D5
       MOVE.W  D1,D0
       BSR.S   L04046
       SWAP    D2
       MOVE.W  D2,D0
       BSR.S   L04052
       MOVE.W  D3,D0
       BSR.S   L04052
       SWAP    D3
       MOVE.W  D3,D0
       BSR     L0400C
       SUBA.L  #$00000016,A1
L040B6 MOVEM.L (A7)+,D1-D5/A2
       MOVEQ   #$00,D0
       RTS
       
* vector CE

L040BE MOVEM.L D1-D5/A2,-(A7)   * CN.DAY
       BSR.S   L040F6
       SUBQ.L  #6,A1
       MOVE.W  #$0003,$00(A6,A1.L)
       ADDQ.L  #2,A1
       MULU    #$0003,D0
       MOVEA.L $0002814A,A2
       MOVE.W  $0038(A2),D1
       LEA     $00(A2,D1.W),A2
       ADDA.W  D0,A2
       BSR.S   L040E8
       SUBQ.L  #5,A1
       BRA.S   L040B6

L040E8 MOVEQ   #$02,D0
L040EA MOVE.B  (A2)+,$00(A6,A1.L)
       ADDQ.L  #1,A1
       DBF     D0,L040EA
       RTS

L040F6 MOVE.W  #$003C,D2
       BSR     L0417E
       MOVE.W  D0,D3
       SWAP    D3
       BSR.S   L0417E
       MOVE.W  D0,D3
       DIVU    #$0018,D1
       MOVE.L  D1,D2
       ANDI.L  #$0000FFFF,D1
       MOVE.L  D1,D0
       DIVU    #$0007,D0
       SWAP    D0
       DIVU    #$05B5,D1
       MOVE.W  D1,D2
       ASL.W   #2,D2
       ADDI.W  #$07A9,D2
       CLR.W   D1
       SWAP    D1
       DIVU    #$016D,D1
       MOVEQ   #$00,D4
       CMPI.W  #$0004,D1
       BNE.S   L0413C
       SUBQ.W  #1,D1
       MOVE.W  #$016D,D4
L0413C ADD.W   D1,D2
       SWAP    D1
       ADD.W   D4,D1
       MOVEQ   #$00,D5
       MOVE.W  D2,D4
       ANDI.W  #$0003,D4
       BNE.S   L0414E
       MOVEQ   #$01,D5
L0414E MOVE.W  D5,D4
       ADDI.W  #$003A,D4
       CMP.W   D4,D1
       BLE.S   L0415C
       ADDQ.W  #2,D1
       SUB.W   D5,D1
L0415C MOVE.W  D1,D5
       ADDI.W  #$005C,D5
       MULU    #$0064,D5
       DIVU    #$0BEF,D5
       MOVE.W  D5,D4
       ADDI.W  #$005C,D1
       MULU    #$0BEF,D5
       DIVU    #$0064,D5
       SUB.W   D5,D1
       SUBQ.W  #3,D4
       RTS

L0417E MOVEQ   #$00,D0
       SWAP    D1
       MOVE.W  D1,D0
       DIVU    D2,D0
       SWAP    D0
       MOVE.W  D0,D1
       SWAP    D1
       DIVU    D2,D1
       MOVE.W  D1,D0
       SWAP    D1
       EXG     D0,D1
       RTS

       include flp1_arithm_asm

       include flp1_BASIC1_asm

       include flp1_mdv_routines

       include flp1_net_routines

       include flp1_basic2_asm

       include flp1_basic_commands

       include flp1_basic3_asm

       include flp1_charfount_asm

L0B352 ANDI.W #$0007,D2
       ANDI.W #$003F,D1
       CMPI.B #$36,D1
       BNE.S  L0B368
       BTST   #$01,D2
       BEQ.S  L0B368
       RTS
      
L0B368 movem.l D3/D4/D5/A3,-(A7)
       LEA      L0B458,A3            * keyboard - table
       MOVE.W   $8(A3),D4
       LEA.L    $0(A3,D4.W),A3
       MOVEQ    #$4,D4
L0B37C CMP.B    (A3)+,D1
       BEQ.S    L0B388
       ADDQ.L   #1,A3
       DBF      D4,L0B37C
       BRA.S    L0B392
      
L0B388 MOVE.B   (A3),D1
       OR.B     D2,D1
       JMP      L0B450
      
L0B392 CLR.W    D5
      BCLR     #$0,D2
      BEQ.S    L0B39E
      MOVE.B   #-1,D5
L0B39E LEA      L0B458,A3
      MOVE.W   $0(A3,D2.W),D3
      LEA.L    $0(A3,D3.W),A3
      CLR.L    D3
      MOVE.B   (A3)+,D3
      CMP.B    D3,D1
      BGE.S    L0B3BA
      JMP      L0B446     * !!! PC-RELATIV POSSIBLE !!!
      
L0B3BA CMP.B   (A3)+,D1
       BLE.S    L0B3C4
       JMP      L0B446
L0B3C4 SUBA.W  D3,A3
       MOVE.B  $0(A3,D1.W),D3
       CMPI.B  #-1,D3
       BNE.S   L0B3D8   
       ADD.B    D2,D1
       MOVE.B   D1,$145(A6)
       BRA.S    L0B446
      
L0B3D8 MOVE.B    D3,D1
       MOVE.B     $145(A6),D2
       BEQ.S      L0B414
       CLR.B      $145(A6)
       LEA        L0B458,A3    * !!! PC-RELATIV POSSIBLE !!!
       MOVE.W   $A(A3),D4
       LEA      $0(A3,D4.W),A3
L0B3F2 TST.B   (A3)
       BEQ.S   L0B446
       CMP.B   (A3)+,D2
       BEQ.S   L0B404
       MOVE.B   (A3)+,D4
       ASL.B   #1,D4
       EXT.W   D4
       ADDA.W   D4,A3
       BRA.S   L0B3F2
      
L0B404 MOVE.B   (A3)+,D4
L0B406 BEQ.S   L0B446
      CMP.B   (A3)+,D3
      BEQ.S   L0B412
      ADDQ.L   #1,A3
      SUBQ.B   #1,D4
      BRA.S   L0B406
      
L0B412 MOVE.B   (A3),D1
L0B414 TST.B   $88(A6)    * SV.CAPS
      BEQ.S   L0B43C
      CMPI.B   #$61,D1
      BCS.S   L0B43C
      CMPI.B   #$7A,D1
      BLS.S   L0B438
      CMPI.B   #$80,D1
      BCS.S   L0B43C
      CMPI.B   #$8B,D1
      BHI.S   L0B43C
      BSET   #$5,D1
      BRA.S   L0B43C
      
L0B438 BCLR   #$5,D1
L0B43C TST.B   D5
      BEQ.S   L0B450
      LSL.W   #8,D1
      MOVE.B   D5,D1
      BRA.S   L0B450
      
L0B446 CLR.W    D1
       MOVEM.L (A7)+,D3/D4/D5/A3
       ADDQ.L  #2,(A7)
       RTS
      
L0B450 MOVEM.L   (A7)+,D3/D4/D5/A3
       ADDQ.L     #4,(A7)
oB456 RTS

      include flp1_Keyboard_asm


L0B56C MOVEM.L   D1/D2/D3/A1,-(A7)
       MOVEQ    #$0,D0
       MOVE.L   $146(A6),A1
       MOVE.W   $2(A1),D2
       LEA      $0(A1,D2.W),A1
       TST.B    D1
       BEQ.S    L0B5D6
       MOVE.B   $0(A1,D1.W),D0
       TST.B    D0
       BEQ.S    L0B58E
       MOVE.B   D0,D1
       BRA.S    L0B5D6
L0B58E MOVE.L   D1,D3
       JSR      L0380A
       NOP                * !!! to coform asm !!!
       MOVE.L   D3,D1
       CMPI.W   #$FFF6,D0
       BEQ.S    L0B5DC
       MOVEQ    #$0,D0
       CMPI.W   #$3,D2
       BGE.S    L0B5AA
       MOVEQ    #-1,D0
       BRA.S    L0B5DC
L0B5AA MOVE.L   $146(A6),A1
       MOVE.W   $4(A1),D2
       LEA      $0(A1,D2.W),A1
       MOVE.B   (A1)+,D3
L0B5B8 BEQ.S    L0B5DC
       CMP.B    (A1)+,D1
       BEQ.S    L0B5C4
       ADDQ.L   #3,A1
       SUBQ.B   #1,D3
       BRA.S    L0B5B8
L0B5C4 MOVE.B   (A1)+,D1
       JSR      L03838
       NOP                * !!! to conform asm !!!
       MOVE.B   (A1)+,D1
       JSR      L03838
       NOP                * !!! to conform asm !!!
       MOVE.B   (A1),D1
L0B5D6 JSR      L03838
       NOP                * !!! to conform asm !!!
L0B5DC MOVEM.L (A7)+,D1/D2/D3/A1
       RTS

L0B5E2 MOVEM.L   D0/D1/D2/A1,-(A7)
       MOVE.L   $146(A6),A1
       MOVE.W   $2(A1),D2
       LEA      $0(A1,D2.W),A1
       MOVE.B   $0(A1,D1.W),D0
       TST.B   D0
       BEQ.S   L0B60E
       MOVE.W   D1,D2
L0B5FC MOVE.B   $0(A1,D2.W),D0
       CMP.B   D0,D1
       BEQ.S   L0B60C
       ADDQ.B   #1,D2
       CMP.B   D2,D1
       BNE.S   L0B5FC
       BRA.S   L0B60E
L0B60C MOVE.B   D2,D1
L0B60E MOVEM.L (A7)+,D0/D1/D2/A1
       RTS

       include flp1_tra_tab

       include flp1_sys_mess

        
        ORG $BFE2

L0BFE2 DC.L L0B614
L0BFE6 DC.L L0B71C
L0BFEA DC.L L0B5E2
L0BFEE DC.L L0B56C
L0BFF2 DC.L L0B352

* nr of version

L0BBF6  DC.L $312D3130
L0BBFA  DC.W     $02
        DC.B    'JS'
        DC.W     $00

        END
        
******************
*
* TRA_TAB as delivered in MGG-ROM
*
******************

L0B614  DC.L $4AFB0006
   DC.L $01060001
   DC.L $02030405
   DC.L $06070809
   DC.L $0A0B0C0D
   DC.L $0E0F1011
   DC.L $12131415
   DC.L $16171819
   DC.L $1A1B1C1D
   DC.L $1E1F2021
   DC.L $22232425
   DC.L $26272829
   DC.L $2A2B2C2D
   DC.L $2E2F3031
   DC.L $32333435
   DC.L $36373839
   DC.L $3A3B3C3D
   DC.L $3E3F3F41
   DC.L $42434445
   DC.L $46474849
   DC.L $4A4B4C4D
   DC.L $4E4F5051
   DC.L $52535455
   DC.L $56575859
   DC.L $5A3F3F3F
   DC.L $5E5F3F61
   DC.L $62636465
   DC.L $66676869
   DC.L $6A6B6C6D
   DC.L $6E6F7071
   DC.L $72737475
   DC.L $76777879
   DC.L $7A3F3F3F
   DC.L $3F3F7B81
   DC.L $82837C85
   DC.L $867D8889
   DC.L $8A8B8C8D
   DC.L $8E8F9091
   DC.L $92939495
   DC.L $96979899
   DC.L $9A9B7E9D
   DC.L $9E605BA1
   DC.L $A2A35CA5
   DC.L $A65DA8A9
   DC.L $AAABACAD
   DC.L $AEAFB0B1
   DC.L $B2B3B4B5
   DC.L $40B7B8B9
   DC.L $BABBBCBD
   DC.L $BEBFC0C1
   DC.L $C2C3C4C5
   DC.L $C6C7C8C9
   DC.L $CACBCCCD
   DC.L $CECFD0D1
   DC.L $D2D3D4D5
   DC.L $D6D7D8D9
   DC.L $DADBDCDD
   DC.L $DEDFE0E1
   DC.L $E2E3E4E5
   DC.L $E6E7E8E9
   DC.L $EAEBECED
   DC.L $EEEFF0F1
   DC.L $F2F3F4F5
   DC.L $F6F7F8F9
   DC.L $FAFBFCFD
   DC.L $FEFF00FF
