scr_top         equ     $20000
num_sp          equ     53
num_base        equ     16
ut_con          equ     $c6
ut_mtext        equ     $d0
score_poshi     equ     50
score_pos       equ     480
bas_pos         equ     5
nemalt          equ     15
;
;
;
coldstart
        moveq   #0,d0
        lea     hiscore,a0
        move.l  d0,(a0)
        bsr     save_message
warm    bsr     dimbo
        bsr     clear
        bsr     setbarriers
        bsr     savebarriers
restart lea     bulposx,a0
        move.w  #-1,(a0)
        bsr     clear
        bsr     loadbarriers
        bsr     new_gun
        bsr     paint
        bsr     print_score
        bsr     print_hiscore
        bsr     print_bases
        bsr     print_flags
        bsr     bombs
repeat  bsr     move_gun
        move.b  seq_num,d0
        beq.s   no_bang
        bsr     draws_bang
no_bang bsr     drop_bomb
        bsr     bulmov
        lea     zeke,a0
        subq.b  #1,(a0)
        tst.b   (a0)
        bpl.s   no_mum
        move.b  #2,(a0) 
        move.w  baddyx,d0
        bmi.s   no_mum
        bsr     baddybus
no_mum  lea     in_wait,a0
        subq.b  #1,(a0)
        bne.s   no_inv
        move.b  inv_speed,(a0)
        bsr     rev_bul
        bsr     un_paint
        bsr     slither
        bsr.s   paint
        bsr     rev_bul
        lea     flick,a2
        eor.b   #1,(a2)
        move.w  baddyx,d0
        bpl.s   no_inv
        lea     badwait,a0
        subq.b  #1,(a0)
        bne.s   no_inv
        lea     baddyx,a0
        moveq   #0,d6
        move.w  d6,(a0)
        moveq   #nemalt,d7
        bsr     saver
no_inv  moveq   #3,d1
        bra.s   repeat
;
;
;
paint
        lea     xpos,a0
        lea     ypos,a1
        moveq   #0,d5
        move.b  flick,d5
        moveq   #num_sp-1,d0
brush   move.b  (a1)+,d7
        addq.b  #2,d5
        and.b   #7,d5
        move.w  (a0)+,d6
        bmi.s   dead
        bsr     plot
dead    dbf     d0,brush
        rts
;
;
;
new_gun
        lea     gunpos,a0
        move.w  #256,d6
        move.w  d6,(a0)
        move.b  #240,d7
        moveq   #8,d5
        bra     plot
;
;
;
dimbo
        lea     num_bas,a0
        move.b  #2,(a0)
        lea     accel,a0
        move.w  #4,(a0)
        moveq   #0,d0
        lea     seq_num,a0
        move.b  d0,(a0)
        lea     flick,a0
        move.b  d0,(a0)
        lea     xdir,a0
        move.b  d0,(a0)
        lea     baddyx,a0
        move.w  #-1,(a0)
        lea     sd_flag,a0
        move.b  d0,(a0)
        lea     numflag,a0
        move.b  d0,(a0)
        lea     score,a0
        move.l  d0,(a0)
        lea     invnext,a0
        move.b  #30,(a0)
;
;
;
new_screen
        lea     inv_speed,a0
        move.b  #210,(a0)
        lea     xpos,a0
        lea     ypos,a1
        moveq   #0,d7
        move.b  invnext,d7
        moveq   #3,d0
frog    moveq   #7,d1
        moveq   #30,d6
froglet move.w  d6,(a0)+
        move.b  d7,(a1)+
        add.w   #48,d6
        dbf     d1,froglet
        add.b   #40,d7
        dbf     d0,frog
        move.b  invnext,d7
        add.b   #20,d7
        moveq   #2,d0
newt    moveq   #6,d1
        moveq   #54,d6
newtlet move.w  d6,(a0)+
        move.b  d7,(a1)+
        add.w   #48,d6
        dbf     d1,newtlet
        add.b   #40,d7
        dbf     d0,newt
        rts
;
;
;
clear
        move.l  #scr_top,a2
        move.w  #8191,d1
resnlw  clr.l   (a2)+
        dbf     d1,resnlw
        rts
;
;
;
plot
        movem.l d2-d3/d5-d7/a0-a1,-(a7)
        bsr.s   calc_addr
        neg.b   d2
        add.b   #8,d2
        lea     sprite_defs,a0
        lsl.w   #4,d5
        add.l   d5,a0
        moveq   #7,d5
loop2   clr.w   d6
        clr.w   d7
        move.b  (a0)+,d6
        move.b  (a0)+,d7
        lsl.w   d2,d6
        lsl.w   d2,d7
        move.w  d6,d3
        lsl.l   #8,d3
        move.w  d7,d3
        move.b  d6,d3
        lsl.l   #8,d3
        move.b  d7,d3
        eor.l   d3,(a1)
        add.w   #128,a1
        dbf     d5,loop2
        movem.l (a7)+,d2-d3/d5-d7/a0-a1
        rts
; This rountine calculates the address of a screen word pointed to
; by d6 (x coord) and d7 (y coord). The address is returned in a1
; d6 and d7 are scrambled d2 returns with the bit number (0 - 7).
calc_addr
        and.l   #$1ff,d6
        and.l   #$ff,d7
        move.w  d6,d2
        lsr.w   #3,d6
        lsl.w   #1,d6
        add.l   #scr_top,d6
        lsl.w   #7,d7
        add.l   d6,d7
        move.l  d7,a1
        and.l   #7,d2
        rts
;
;
;
slither
        lea     sd_flag,a2
        tst.b   (a2)
        bne.s   mo_down
        move.w  accel,d4
        lea     xdir,a1
        move.b  (a1),d0
        move.b  d0,d3
        lea     xpos,a0
        moveq   #0,d5
        moveq   #num_sp-1,d1
shuffl  move.w  (a0),d2
        bmi.s   deader
        tst.b   d0
        bmi.s   mo_left
        sub.w   d4,d2
        bra.s   no_left
mo_left add.w   d4,d2
no_left cmp.w   #499,d2
        bhi.s   dir_ch
        cmp.w   #3,d2
        bhi.s   deader
dir_ch  move.b  d0,d3
        not.b   d3
        moveq   #-1,d5
deader  move.w  d2,(a0)+
        dbf     d1,shuffl
        move.b  d3,(a1)
        move.b  d5,(a2)
        rts
mo_down lea     ypos,a0
        lea     accel,a1
        moveq   #num_sp-1,d0
drop    move.b  (a0),d1
        cmp.b   #-1,d1
        beq.s   notendg
        add.b   #6,d1
        move.b  d1,(a0)
        cmp.b   #224,d1
        bls.s   notendg
        add.w   #4,a7
        bra     endgame
notendg add.w   #1,a0
        dbf     d0,drop
        clr.b   (a2)
        rts
;
;
;
keyrow
        lea     temp,a3
        move.b  d1,6(a3)
        moveq   #17,d0
        trap    #1
        rts
;
;
;
move_gun
        moveq   #1,d1
        bsr.s   keyrow
        btst    #6,d1
        beq.s   notfir
        bsr.s   fire
notfir  lea     gunpos,a0
        move.w  (a0),d0
        move.w  d0,d2
        btst    #1,d1
        beq.s   gnl
        cmp.w   #3,d0
        ble.s   gnl
        subq.w  #2,d0
gnl     btst    #4,d1
        beq.s   gnr
        cmp.w   #499,d0
        bhi.s   gnr
        addq.w  #2,d0
gnr     move.w  d0,(a0)
        moveq   #8,d5
        move.w  d0,d6
        move.b  #240,d7
        bsr     plot
        move.w  d2,d6
        bra     plot
;
;
;
fire
        lea     bulposx,a0
        tst.w   (a0)
        bpl.s   no_fire
        move.w  gunpos,d6
        move.w  d6,(a0)
        lea     bulposy,a0
        move.b  #232,d7
        move.b  d7,(a0)
        moveq   #9,d5
        bsr     plot
        lea     zap,a3
        moveq   #17,d0
        trap    #1
no_fire rts
;
;
;
bul_hit_bar
        move.b  d7,d3
        lea     rndpos,a2
        moveq   #7,d1
scruby  move.w  (a2),a1
        move.b  d3,d7
        move.w  (a1),d5
        addq.w  #2,(a2)
        and.w   #7,d5
        sub.b   d5,d7
        move.b  #224,d5
        sub.b   d7,d5
        bsr     vline
        addq.w  #1,d6
        dbf     d1,scruby
        lea     crunch,a3
        moveq   #17,d0
        trap    #1
        rts
;
;
;
bulmov
        lea     bulposx,a0
        move.w  (a0),d6
        bmi.s   no_bul
        lea     bulposy,a1
        move.b  (a1),d7
        moveq   #9,d5
        bsr     plot
        subq.b  #1,d7
        cmp.b   #9,d7
        bhi.s   stilbul
        move.w  #-1,(a0)
no_bul  rts
stilbul move.b  d7,(a1)
        addq.w  #3,d6
        bsr     id_col
        beq     no_hit
        move.w  #-1,(a0)
        cmp.b   #199,d7
        bls.s   notbhb
        and.w   #$ff00,d2
        beq     bul_hit_bar
        bra     endbomb
notbhb  lea     xpos,a0
        lea     ypos,a1
        moveq   #num_sp-1,d4
nextst  move.b  d7,d5
        sub.b   (a1)+,d5
        cmp.b   #10,d5
        bls.s   poss
        addq.l  #2,a0
        bra.s   g_next
poss    move.w  d6,d0
        sub.w   (a0)+,d0
        bpl.s   not_neg
        neg.w   d0
not_neg cmp.w   #10,d0
        bhi.s   g_next
        move.w  -(a0),d6
        move.b  -(a1),d7
        bsr     blank_out
        move.w  #-1,(a0)
        move.b  #-1,(a1)
        bsr     explode
        lea     zam,a3
        moveq   #17,d0
        trap    #1
        bsr     inc_score
        lea     inv_speed,a0
        cmp.b   #2,(a0)
        bne.s   notnew
        lea     invnext,a0
        addq.b  #8,(a0)
        bra     new_screen
notnew  subq.b  #4,(a0)
        rts
g_next  dbf     d4,nextst
        cmp.b   #25,d7
        bhi.s   no_bus
        moveq   #nemalt,d7
        lea     baddyx,a0
        move.w  (a0),d6
        bsr     saver
        bsr     endbad
        bsr     explode
        moveq   #39,d0
morepts bsr     inc_score
        dbf     d0,morepts
no_bus  rts
no_hit  subq.w  #3,d6
        bra     plot
;
;
;
id_col
        movem.l d6-d7/a0-a1,-(a7)
        bsr     calc_addr
        lea     mask_tab,a0
        lsl.b   #1,d2
        add.l   d2,a0
        move.w  (a1),d2
        and.w   (a0),d2
        movem.l (a7)+,d6-d7/a0-a1
        rts
;
;
;
blank_out
        movem.l d2/d6-d7/a1,-(a7)
        bsr     calc_addr
        moveq   #7,d2
wipe    clr.l   (a1)
        add.w   #128,a1
        dbf     d2,wipe
        movem.l (a7)+,d2/d6-d7/a1
        rts
;
;
;
un_paint
        lea     xpos,a0
        lea     ypos,a1
        moveq   #num_sp-1,d2
scruber move.b  (a1)+,d7
        move.w  (a0)+,d6
        bmi.s   nninv
        bsr.s   blank_out
nninv   dbf     d2,scruber
        rts
;
;
;
print_score
        movem.l d6-d7/a0,-(a7)
        move.w  #score_pos,d6
        moveq   #0,d7
        lea     score,a0
        bsr.s   print_num
        movem.l (a7)+,d6-d7/a0
        rts
;
;
;
print_hiscore
        moveq   #score_poshi,d6
        moveq   #0,d7
        lea     hiscore,a0
;
;
;
print_num
        movem.l d0-d1/d5,-(a7)
        move.w  d6,d5
        moveq   #5,d1
next_w  bsr.s   blank_out
        sub.w   #8,d6
        dbf     d1,next_w
        move.w  d5,d6
        moveq   #0,d5
        moveq   #5,d1
        move.l  (a0),d0
nexdig  move.b  d0,d5
        lsr.l   #4,d0
        and.b   #15,d5
        add.b   #num_base,d5
        bsr     plot
        sub.w   #8,d6
        dbf     d1,nexdig
        movem.l (a7)+,d0-d1/d5
        rts
;
;
;
inc_score
        and.b   #$e7,sr
        lea     score,a0
        lea     mess,a1
        move.l  #$100,(a1)+
        addq.l  #4,a0
        moveq   #3,d0
sub_dig abcd    -(a1),-(a0)
        dbf     d0,sub_dig
        bsr.s   print_score
        move.w  2(a0),d0
        and.w   #$fff,d0
        bne.s   odd
        lea     numflag,a0
        addq.b  #1,(a0)
        cmp.b   #3,(a0)
        bne     print_flags
        clr.b   (a0)
        lea     num_bas,a0
        move.b  (a0),d6
        addq.b  #1,(a0)
        lsl.w   #4,d6
        addq.w  #5,d6
        move.b  #248,d7
        moveq   #8,d5
        bsr     plot
        bsr     rub_flag
odd     rts
;
;
;
bombs
        move.w  gunpos,d6
        moveq   #0,d3
        move.w  #5000,d2
        lea     xpos,a0
        lea     ypos,a1
        moveq   #num_sp-1,d0
thing   cmp.w   #-1,(a0)
        beq.s   grogy
        move.w  d6,d1
        sub.w   (a0),d1
        bpl.s   itspos
        neg.w   d1
itspos  cmp.w   d2,d1
        bhi.s   grogy
        move.w  d1,d2
        move.w  (a0),d4
        move.b  (a1),d3
grogy   addq.l  #1,a1
        addq.l  #2,a0
        dbf     d0,thing
        add.b   #8,d3
        lea     x_bomb,a0
        move.w  d4,(a0)
        lea     y_bomb,a0
        move.b  d3,(a0)
        move.b  d3,d7
        move.w  d4,d6
        moveq   #9,d5
        bra     plot
;
;
;
drop_bomb
        lea     y_bomb,a1
        move.b  (a1),d7
        move.w  x_bomb,d6
        moveq   #9,d5
        bsr     plot
        addq.b  #1,d7
        cmp.b   #240,d7
        beq.s   fred
        move.b  d7,(a1)
        addq.b  #7,d7
        addq.w  #4,d6
        bsr     id_col
        beq.s   ex_drop
        cmp.b   #233,d7
        bhi     base_dead
        and.w   #$ff00,d2
        bne.s   fred
        cmp.b   #199,d7
        bhi.s   hit_barrier
fred    bra     bombs
joe     bsr     rev_bul
        lea     bulposx,a0
        move.w  #-1,(a0)
        bra.s   fred
ex_drop subq.b  #7,d7
        subq.w  #4,d6
        bra     plot
;
;
;
hit_barrier
        subq.w  #4,d6
        move.b  d7,d3
        move.b  #200,d7
        lea     rndpos,a2
        moveq   #7,d1
scrub   move.w  (a2),a1
        move.w  (a1),d5
        addq.w  #2,(a2)
        and.w   #7,d5
        add.b   d3,d5
        sub.b   #200,d5
        bsr.s   vline
        addq.w  #1,d6
        dbf     d1,scrub
        lea     crunch,a3
        moveq   #17,d0
        trap    #1
        bra     bombs
;
; This routine draws a line vertically down of length (d5)
; starting at (d6,d7) .
vline
        movem.l d6-d7,-(a7)
        bsr     calc_addr
        lea     mask_tab,a0
        lsl.b   #1,d2
        add.l   d2,a0
        move.w  (a0),d2
        not.w   d2
        and.w   #255,d5
zag     and.w   d2,(a1)
        add.w   #128,a1
        dbf     d5,zag
        movem.l (a7)+,d6-d7
        rts        
;
;
;
base_dead
        lea     base_bang,a3
        moveq   #17,d0
        trap    #1
        addq.l  #4,a7
        move.b  #240,d7
waitexp move.b  seq_num,d0
        beq.s   okexp
        bsr     draws_bang
        bra     waitexp
okexp   bsr     explode
        bsr     rev_bul
grows   bsr     draws_bang
        move.w  #3333,d0
phut    dbf     d0,phut
        move.b  seq_num,d0
        bne.s   grows
        bsr     savebarriers
        lea     baddyx,a0
        move.w  #-1,(a0)
        lea     num_bas,a0
        subq.b  #1,(a0)
        bmi.s   endgame
        bsr     waitkey
        bra     restart
endgame lea     hiscore,a0
        move.l  score,d0
        cmp.l   (a0),d0
        bls.s   not_hi
        move.l  d0,(a0)
not_hi  bsr     load_message
none_p  moveq   #7,d1
        bsr     keyrow
        btst    #6,d1
        bne.s   reset
        moveq   #5,d1
        bsr     keyrow
        btst    #6,d1
        beq.s   none_p
        bra     warm
reset   trap    #0
        move    $0,a7
        pea     $4
        rts

;
;
;
explode
        lea     order,a0
        lea     seq_reg,a1
        move.l  a0,(a1)
        lea     wumpx,a0
        move.w  d6,(a0)
        lea     wumpy,a0
        move.b  d7,(a0)
        lea     seq_num,a0
        move.b  #7,(a0)
        rts
;
;
;
draws_bang
        lea     seq_reg,a3
        move.l  (a3),a2
        lea     wumpx,a1
        move.w  (a1),d6
        lea     wumpy,a1
        move.b  (a1),d7
        lea     seq_num,a1
        subq.b  #1,(a1)
        cmp.b   #3,(a1)
        bls.s   set_4
        bsr     blank_out
        move.b  (a2)+,d5
        bsr     plot
        move.l  a2,(a3)
        rts
set_4   subq.w  #4,d6
        subq.b  #4,d7
        move.w  d6,d0
        move.b  d7,d1
        bsr     blank_out
        add.w   #8,d6
        bsr     blank_out
        add.b   #8,d7
        bsr     blank_out
        move.w  d0,d6
        bsr     blank_out
        tst.b   (a1)
        beq.s   ex_bang
        move.b  d1,d7
        move.b  (a2)+,d5
        bsr     plot
        move.b  (a2)+,d5
        add.w   #8,d6
        bsr     plot
        add.b   #8,d7
        move.b  (a2)+,d5
        bsr     plot
        move.w  d0,d6
        move.b  (a2)+,d5
        bsr     plot
        move.l  a2,(a3)
ex_bang rts
;
;
;
print_flags
        bsr.s   rub_flag
        move.w  #240,d6
        moveq   #37,d5
        moveq   #0,d4
        move.b  numflag,d4
        bra.s   flaged
nexflag bsr     plot
        add.w   #12,d6
flaged  dbf     d4,nexflag
        rts
;
;
;
rub_flag
        moveq   #0,d7
        move.w  #240,d6
        bsr     blank_out
        add.w   #16,d6
        bra     blank_out
;
;
;
print_bases
        clr.w   d4
        move.b  num_bas,d4
        subq.b  #1,d4
        bmi.s   ex_prb
        moveq   #8,d5
        moveq   #bas_pos,d6
        move.b  #248,d7
pr_loop bsr     plot
        add.w   #16,d6
        dbf     d4,pr_loop
ex_prb  rts
;
;
;
baddybus
        lea     baddyx,a0
        move.w  (a0),d6
        moveq   #nemalt,d7
        bsr.s   saver
        subq.w  #5,d6
        cmp.w   #495,d6
        bhi.s   endbad
        move.w  d6,(a0)
saver   moveq   #35,d5
        bsr     plot
        add.w   #8,d6
        moveq   #36,d5
        bra     plot
endbad  move.w  #-1,(a0)
        lea     badwait,a0
        lea     rndpos,a1
        move.w  (a1),a2
        move.b  (a2),(a0)
        and.b   #63,(a0)
        or.b    #16,(a0)
        addq.b  #1,(a0)
        addq.w  #2,(a1)
        rts
;
;
;
setbarriers
        moveq   #64,d6
        move.b  #200,d7
        moveq   #2,d3
barloop bsr.s   barrier
        add.w   #176,d6
        dbf     d3,barloop
        rts
;
;
;
barrier
        lea     bar_tab,a0
        move.w  d6,d2
        moveq   #2,d0
rowloop moveq   #3,d1
colloop move.b  (a0)+,d5
        bsr     plot
        add.w   #8,d6
        dbf     d1,colloop
        move.w  d2,d6
        add.b   #8,d7
        dbf     d0,rowloop
        sub.b   #24,d7
        rts
;
;
;
savebarriers
        lea     base_buf, a0
        move.l  #$26410,a3
        moveq   #2,d7
save1   move.l  a3,a1
        moveq   #23,d6
save2   move.l  (a1)+,(a0)+
        move.l  (a1),(a0)+
        add.w   #$7c,a1
        dbf     d6,save2
        add.w   #$2c,a3
        dbf     d7,save1
        rts
;
;
;
loadbarriers
        lea     base_buf, a0
        move.l  #$26410,a3
        moveq   #2,d7
load1   move.l  a3,a1
        moveq   #23,d6
load2   move.l  (a0)+,(a1)+
        move.l  (a0)+,(a1)
        add.w   #$7c,a1
        dbf     d6,load2
        add.w   #$2c,a3
        dbf     d7,load1
        rts
;
;
;
rev_bul
        move.w  bulposx,d6
        bmi.s   no_rev
        move.b  bulposy,d7
        moveq   #9,d5
        bra     plot
no_rev  rts
;
;
;
save_message
        lea     con_block,a1
        move.w  ut_con,a2
        jsr     (a2)
        lea     message,a1
        move.w  ut_mtext,a2
        jsr     (a2)
        moveq   #2,d0
        trap    #2
        move.l  #$2332e,a0
        lea     message_buff,a1
        moveq   #19,d0
mesave1 moveq   #17,d1
mesave2 move.w  (a0)+,(a1)+
        dbf     d1,mesave2
        add.w   #92,a0
        dbf     d0,mesave1
        rts
;
;
;
load_message
        move.l  #$2332e,a1
        lea     message_buff,a0
        moveq   #19,d0
meload1 moveq   #17,d1
meload2 move.w  (a0)+,(a1)+
        dbf     d1,meload2
        add.w   #92,a1
        dbf     d0,meload1
        rts
;
;
;
endbomb
        move.b  y_bomb,d7
        move.w  x_bomb,d6
        moveq   #9,d5
        bsr     plot
        bra     bombs
;
;
;
waitkey
        movem.l d0-d7/a0-a6,-(a7)
no_spc  moveq   #1,d1
        bsr     keyrow
        btst    #3,d1
        bne.s   basic
        btst    #6,d1
        beq.s   no_spc
        btst    #3,d1
        bne.s   endwait
no_spc2 moveq   #1,d1
        bsr     keyrow
        btst    #6,d1
        bne.s   no_spc2
endwait movem.l (a7)+,d0-d7/a0-a6
        rts
basic   add.w   #68,a7
        rts
;
;
;
sprite_defs
; Sprite # 0            invader 1a
        dc.w    $1918,$3d3c,$5b7e,$ffff,$d66a,$ea56,$a424,$2424
; Sprite # 1            invader 1b
        dc.w    $9818,$bc3c,$da7e,$ffff,$576a,$6b56,$2524,$4242
; Sprite # 2            invader 2a
        dc.w    $9190,$5258,$1438,$1030,$77ff,$1018,$0008,$0008
; Sprite # 3            invader 2b
        dc.w    $8188,$5258,$341c,$140c,$00fe,$341c,$5212,$9111
; Sprite # 4            invader 3a
        dc.w    $9818,$bc3c,$da7e,$ffff,$576a,$6b56,$2524,$4242
; Sprite # 5            invader 3b
        dc.w    $1918,$3d3c,$5b7e,$ffff,$d66a,$ea56,$a424,$2424
; Sprite # 6            invader 4a
        dc.w    $8188,$5258,$341c,$140c,$00fe,$341c,$5212,$9111
; Sprite # 7            invader 4b
        dc.w    $9190,$5258,$1438,$1030,$77ff,$1018,$0008,$0008
; Sprite # 8            base
        dc.w    $1818,$3c24,$7e5a,$e7bd,$db7e,$bdff,$7eff,$ffff
; Sprite # 9            bomb
        dc.w    $0808,$1010,$0808,$1010,$0808,$1010,$0808,$1010
; Sprite # 10
        dc.w    $0000,$0000,$0000,$1010,$0808,$0000,$0000,$0000
; Sprite # 11
        dc.w    $0000,$0000,$3030,$0404,$0000,$4c4c,$0000,$0000
; Sprite # 12
        dc.w    $0000,$2222,$0808,$0808,$4242,$2424,$2222,$0000
; Sprite # 13
        dc.w    $0000,$0000,$0000,$1414,$0000,$0a0a,$0000,$0000
; Sprite # 14
        dc.w    $0000,$0000,$0000,$4848,$2020,$0000,$1010,$0000
; Sprite # 15
        dc.w    $1414,$0000,$0101,$1010,$0000,$0000,$0000,$0000
; Sprite # 16           Number  '0'
        dc.w    0,15420,26214,28270,30326,26214,15420,0
; Sprite # 17           Number  '1'
        dc.w    0,6168,14392,6168,6168,6168,32382,0
; Sprite # 18           Number  '2'
        dc.w    0,15420,26214,3084,6168,12336,32382,0
; Sprite # 19           Number  '3'
        dc.w    0,32382,3084,6168,3084,26214,15420,0
; Sprite # 20           Number  '4'
        dc.w    0,3084,7196,15420,27756,32382,3084,0
; Sprite # 21           Number  '5'
        dc.w    0,32382,24672,31868,1542,26214,15420,0
; Sprite # 22           Number  '6'
        dc.w    0,15420,24672,31868,26214,26214,15420,0
; Sprite # 23           Number  '7'
        dc.w    0,32382,1542,3084,6168,12336,12336,0
; Sprite # 24           Number  '8'
        dc.w    0,15420,26214,15420,26214,26214,15420,0
; Sprite # 25           Number  '9'
        dc.w    0,15420,26214,15934,1542,3084,14392,0
; Sprite # 26
        dc.w    $0808,$0000,$2020,$0000,$8888,$0000,$0000,$0000
; Sprite # 27
        dc.w    $0000,$0000,$2121,$0808,$0000,$2020,$0000,$0000
; Sprite # 28
        dc.w    $0000,$0000,$2020,$0404,$0000,$0000,$0404,$0000
; Sprite # 29
        dc.w    $2020,$0000,$0000,$2020,$0808,$0202,$0000,$0000
; Sprite # 30
        dc.w    $0000,$0000,$0404,$0808,$0000,$2020,$0000,$0000
; Sprite # 31
        dc.w    $0000,$4040,$0101,$0000,$0000,$0000,$0000,$0000
; Sprite # 32
        dc.w    $0000,$0202,$0404,$0000,$0000,$0000,$0000,$0000
; Sprite # 33
        dc.w    $0000,$4040,$0000,$0000,$0000,$0000,$4040,$0000
; Sprite # 34
        dc.w    $0000,$0808,$0000,$0000,$0202,$4040,$0000,$0000
; Sprite # 35           Nemesis A
        dc.w    $4000,$2700,$1f00,$ff00,$1f00,$3f00,$7f00,$1000
; Sprite # 36           Nemesis B
        dc.w    $0200,$e400,$f800,$ff00,$f800,$fc00,$fe00,$0800
; Sprite # 37
        dc.w    $0010,$0038,$007c,$00fe,$1000,$1000,$1000,$1000
; Sprite # 38
        dc.w    $0001,$0003,$0007,$000f,$001f,$003f,$007f,$00ff
; Sprite # 39
        dc.w    $00ff,$00ff,$00ff,$00ff,$00ff,$00ff,$00ff,$00ff
; Sprite # 40
        dc.w    $0080,$00c0,$00e0,$00f0,$00f8,$00fc,$00fe,$00ff
; Sprite # 41
        dc.w    $00ff,$00ff,$00ff,$00ff,$0000,$0000,$0000,$0000
;
; positions of invaders (-1 = Dead)
;
        align
ypos    ds.b    num_sp
xpos    ds.w    num_sp
        align
accel   dc.w    0
gunpos  dc.w    0
in_wait dc.w    0
xdir    dc.w    1
sd_flag dc.w    0
temp    dc.l    $09010000,$00000002
flick   dc.w    0
bulposx dc.w    0
bulposy dc.b    0
y_bomb  dc.b    0
x_bomb  dc.w    0
inv_speed
        dc.b    0
order   dc.b    10
        dc.b    11
        dc.b    12
        dc.b    13,14,26,15
        dc.b    27,28,30,29
        dc.b    31,32,34,33
        align
seq_reg dc.l    0
wumpx   dc.w    0
wumpy   dc.b    0
seq_num dc.b    0
num_bas dc.b    0
invnext dc.b    0
badwait dc.b    1
numflag dc.b    0
        align
mask_tab
        dc.w    $8080,$4040,$2020,$1010
        dc.w    $0808,$0404,$0202,$0101
mess    dc.l    0
hiscore dc.l    0
score   dc.l    0
baddyx  dc.w    0
rndpos  dc.w    0
base_buf
        ds.b    576
message_buff
        ds.w    360
con_block
        dc.w    $0302,$0007,144,20,184,102
message dc.w    20
        dc.b    "  PLAY  AGAIN  (Y/N)"
        align
        ds.w    360    
zap
        dc.b    $0a,8
        dc.l    $0000aaaa
        dc.b    25,50        
        dc.b    2,0,112,23
        dc.b    18,18,1
        align
zam
        dc.b    $0a,8
        dc.l    $0000aaaa
        dc.b    20,80        
        dc.b    32,3,184,11
        dc.b    16,0,1
        align
crunch
        dc.b    $0a,8
        dc.l    $0000aaaa
        dc.b    250,255        
        dc.b    1,0,184,11
        dc.b    $23,$ff,1
        align
base_bang
        dc.b    $0a,8
        dc.l    $0000aaaa
        dc.b    50,55
        dc.b    10,0,32,78
        dc.b    $a1,$ff,1
nexburp dc.b    0
zeke    dc.b    3
bar_tab dc.b    38,39,39,40,39,39,39,39,39,41,41,39
