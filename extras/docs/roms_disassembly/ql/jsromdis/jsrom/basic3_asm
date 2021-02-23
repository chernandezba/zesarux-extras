
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
