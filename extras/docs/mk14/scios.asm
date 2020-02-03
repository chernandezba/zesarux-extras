; ****************************************************************************
;
;                               The SC/MP I/O Monitor.
;
;       Developed from the SCMPKB monitor by D.J.D.
;       Tape routines by N.J.T.
;       Converted to TASM and annotated by Paul Robson (autismuk@aol.com)
;
; ****************************************************************************

#define High(x)         (((x) >> 8) & 15)
#define Low(x)          ((x) & 255)
#define DatPtr(a)       ((a)+1)

Ram     .equ    0F00h                   ; this is where the standard RAM is
Disp    .equ    0D00h                   ; this is where the display is

; ****************************************************************************
;       Offsets into the data structure , from P2
; ****************************************************************************
dl      .equ    0                       ; Segment for Digit 1
dh      .equ    1                       ; Segment for Digit 2
d3      .equ    2                       ; Segment for Digit 3
d4      .equ    3                       ; Segment for Digit 4
adll    .equ    4                       ; Segment for Digit 5
adlh    .equ    5                       ; Segment for Digit 6
adhl    .equ    6                       ; Segment for Digit 7
adhh    .equ    7                       ; Segment for Digit 8
d9      .equ    8                       ; Segment for Digit 9
cnt     .equ    9                       ; Counter
pushed  .equ    10                      ; Key pushed
char    .equ    11                      ; Char Read
adl     .equ    12                      ; Memory Address (low)
word    .equ    13                      ; Memory Word
adh     .equ    14                      ; Memory Address (High)
ddta    .equ    15                      ; first flag
row     .equ    16                      ; row counter
next    .equ    17                      ; flag for now data
; ****************************************************************************
;       Ram areas used by SCIOS. P3 is saved elsewhere
;       The Data macro is used because of the pre-increment of the PC
;       in the processor isn't supported by TASM.
; ****************************************************************************
p1h     .equ    DatPtr(0FF9h)
p1l     .equ    DatPtr(0FFAh)
p2h     .equ    DatPtr(0FFBh)
p2l     .equ    DatPtr(0FFCh)
a       .equ    DatPtr(0FFDh)
e       .equ    DatPtr(0FFEh)
s       .equ    DatPtr(0FFFh)
; ****************************************************************************
;                       Start of monitor listing
; ****************************************************************************
        .org    1000h                   ; stops TASM complaining...
        halt                            ; pulse the H flag
        st      @-1(3)                  ; save A at P3-1,dec it
        jmp     Start                   ; Go to the monitor start
; ****************************************************************************
;                   Debug exit : restore environment
; ****************************************************************************
GoOut:  xpah    3                       ; Save A in P3 (A is Go address High)
        ld      adl(2)
        xpal    3
        ld      @-1(3)                  ; fix go address
        ld      e                       ; restore registers
        xae
        ld      p1l
        xpal    1
        ld      p1h
        xpah    1
        ld      p2l
        xpal    2
        ld      p2h
        xpah    2
        ld      s
        halt                            ; reset single step
        cas
        ld      a
        nop
        ien
        xppc    3
; ****************************************************************************
;                               Debug Entry Point
; ****************************************************************************
Start:  st      a                       ; Copy all registers to memory
        lde
        st      e
        csa
        st      s
        xpah    1
        st      p1h
        xpal    1
        st      p1l
        ldi     High(Ram)               ; Copy P2, make it point to RAM
        xpah    2                       ; at the same time
        st      p2h
        ldi     Low(Ram)
        xpal    2
        st      p2l
        ld      @1(3)                   ; Bump P3 for return
        xpal    3                       ; save it in ADL,ADH so on
        st      adl(2)                  ; exit we are at (end+1)
        xpah    3
        st      adh(2)
        ldi     0                       ; Clear D3 and D4
        st      d3(2)
        st      d4(2)
        ldi     1                       ; P3H = 1
        xpah    3
Abort:  jmp     Mem                     ; Go to 'Mem' mode handler
; ****************************************************************************
;               Run program from currently displayed address
; ****************************************************************************
GoNow:  ld      adh(2)                  ; A = High Byte of Address
        jmp     GoOut
; ****************************************************************************
;                          Tape Interface Routines.
; ****************************************************************************
Count   .equ    0D5h
Len     .equ    0D6h
; ****************************************************************************
;                 Store to Tape. P1^Data,@Count is the bytes
; ****************************************************************************
ToTape: ld      @1(1)                   ; E := (P1), increment P1
        xae
        ldi     1                       ; A := 1 (the bit pattern)
Next:   st      Count(3)                ; Save in Count (P3)
        ldi     1                       ; set F0 to 1
        cas
        dly     8                       ; Delay 8 Cycles
        ld      Count(3)                ; A = Count & E
        ane                             ; test if bit is set...
        jz      Zero
        dly     018h                    ; (bit is 1) Delay $18 cycles
        ldi     0                       ; set F0 to 0 again
        cas
        jmp     CDone
Zero:   ldi     0                       ; bit is zero (set F0 to 0)
        cas
        dly     018h                    ; Delay $18 Cycles
CDone:  dly     020h                    ; Delay $20 more Cycles
        ld      Count(3)                ; shift the bit pattern left
        add     Count(3)                ; (CYL cleared by CAS !)
        jnz     Next                    ; if non zero we haven't finished
        dld     Len(3)                  ; decrement the length counter
        jnz     ToTape                  ; if non-zero do the next byte
        xppc    3                       ; return from caller
; ****************************************************************************
;            Load from Tape to ^P1. Is broken out via Reset
; ****************************************************************************
FrTape: ldi     8                       ; Count is a bit count here
        st      Count(3)
Loop:   csa                             ; look at the status
        ani     20h                     ; wait for the 'start' bit
        jz      Loop
        dly     01Ch                    ; wait $1C cycles
        sio                             ; shift a bit in
        dly     01Ch                    ; wait a few more cycles
        dld     Count(3)                ; do this 8 times
        jnz     Loop
        lde                             ; get the byte we got
        st      @1(1)                   ; save it, increment the pointer
        jmp     FrTape                  ; and get the next one.
; ****************************************************************************
;                             Offset calculator
; ****************************************************************************
Offset: ld      @-2(2)                  ; Subtract 2 from destination address
        xpal    2                       ; put low byte in AC
        scl
        cad     0D8h(3)                 ; subtract low byte of jump inst addr
        st      1(1)                    ; put in jump operand
        xppc    3                       ; return
        nop                             ; padding
; ****************************************************************************
;                           Bump MSB of address
; ****************************************************************************
DTack:  ild     adh(2)                  ; increment and load ADH
        jmp     Data
; ****************************************************************************
;                            Put Word in Memory
; ****************************************************************************
MemDn:  ld      adh(2)                  ; P1 = ADH/ADL
        xpah    1
        ld      adl(2)
        xpal    1
        ld      word(2)                 ; get and store word
        st      (1)
        jmp     DataCK
; ****************************************************************************
;       Key Check
; ****************************************************************************
MemCK:  xri     06                      ; Check for 'go'
        jz      GoNow
        xri     05                      ; Check for 'term'
        jz      Data
        ild     adl(2)                  ; bump address low
        jnz     Data                    ; no carry-through required
        jmp     DTack                   ; goto bump MSB code
; ****************************************************************************
;                               Mem mode
; ****************************************************************************
Mem:    ldi     -1                      ; Set "First" flag
        st      next(2)                 ; and flag for "address now"
        st      ddta(2)
MemL:   ld      adh(2)                  ; P1 = ADH/L
        xpah    1
        ld      adl(2)
        xpal    1
        ld      0(1)                    ; Get the byte at ADHL
        st      word(2)                 ; save it away in 'work'
        ldi     Low(DispD)-1            ; Fix Data Segment...
        xpal    3                       ; P3 now points to DispD routine
        xppc    3                       ; call it
        jmp     MemCK                   ; command return...
        ldi     Low(Adr)-1              ; call the 'adr' subroutine
        xpal    3
        xppc    3
        jmp     MemL                    ; get next character
; ****************************************************************************
;                               Data Mode
; ****************************************************************************
Data:   ldi     -1                      ; set first flag
        st      ddta(2)
        ld      adh(2)                  ; P1 = ADHL
        xpah    1
        ld      adl(2)
        xpal    1
DataCK: ld      0(1)                    ; get word & save it for display
        st      word(2)
DataL:  ldi     Low(DispD)-1            ; call the display routine
        xpal    3
        xppc    3
        jmp     MemCK                   ; go to the memory routine
        ldi     4                       ; shift it in
        st      cnt(2)
        ild     ddta(2)                 ; if first
        jnz     Dnfst
        ldi     0                       ; zero word if first
        st      word(2)
        st      next(2)                 ; set flag for address done
Dnfst:  ccl                             ; shift left
        ld      word(2)
        add     word(2)
        st      word(2)
        dld     cnt(2)                  ; do it 8 times
        jnz     Dnfst
        ld      word(2)                 ; get the word
        ore                             ; or with the hex pattern
        st      word(2)
        jmp     MemDn                   ; store it and try again
; ****************************************************************************
;                               Segment Data
; ****************************************************************************
SA      .equ    1                       ; Segment bit patterns
SB      .equ    2
SC      .equ    4
SD      .equ    8
SE      .equ    16
SF      .equ    32
SG      .equ    64
; ****************************************************************************
;                    Hex number to seven segment table
; ****************************************************************************
CRom:   .db     SA+SB+SC+SD+SE+SF
        .db     SB+SC
        .db     SA+SB+SD+SE+SG
        .db     SA+SB+SC+SD+SG
        .db     SB+SC+SF+SG
        .db     SA+SC+SD+SF+SG
        .db     SA+SC+SD+SE+SF+SG
        .db     SA+SB+SC
        .db     SA+SB+SC+SD+SE+SF+SG
        .db     SA+SB+SC+SF+SG
        .db     SA+SB+SC+SE+SF+SG
        .db     SC+SD+SE+SF+SG
        .db     SA+SD+SE+SF
        .db     SB+SC+SD+SE+SG
        .db     SA+SD+SE+SF+SG
        .db     SA+SE+SF+SG
; ****************************************************************************
;       Make 4 digit address. Shift left one then add new low hex
;       digit. On entry,digit in E,P2 points to RAM
; ****************************************************************************
Adr:    ldi     4                       ; set number of shifts
        st      cnt(2)
        ild     ddta(2)                 ; check if first
        jnz     notfst                  ; if not skip
        ldi     0                       ; zero address
        st      adh(2)
        st      adl(2)
notfst: ccl                             ; shift ADHL left
        ld      adl(2)
        add     adl(2)
        st      adl(2)
        ld      adh(2)
        add     adh(2)
        st      adh(2)
        dld     cnt(2)                  ; do it 4 times
        jnz     notfst
        ld      adl(2)                  ; or in the digit
        ore
        st      adl(2)
        xppc    3                       ; and return
; ****************************************************************************
;       Convert Hex Data to Segments. P2 Points to RAM. Drops through
;       to hex address conversion
; ****************************************************************************
DispD:  ldi     High(CRom)              ; P1 = Segment conversion Table
        xpah    1
        ldi     Low(CRom)
        xpal    1
        ld      word(2)                 ; get low nibble
        ani     0Fh
        xae
        ld      -128(1)                 ; get CROM+E (low)
        st      dl(2)
        ld      word(2)                 ; get high nibble
        sr
        sr
        sr
        sr
        xae
        ld      -128(1)                 ; get CROM+E
        st      dh(2)                   ; update the display
; ****************************************************************************
;       Convert Hex Address to segment, P2 points to RAM. Drops through
;       to keyboard and display
; ****************************************************************************
DispA:  scl
        ldi     High(CRom)              ; P1 = Segment conversion Table
        xpah    1
        ldi     Low(CRom)
        xpal    1
LoopD:  ld      adl(2)
        ani     0F
        xae
        ld      -128(1)                 ; get CROM+E (low)
        st      adll(2)
        ld      adl(2)                  ; get high nibble
        sr
        sr
        sr
        sr
        xae
        ld      -128(1)                 ; get CROM+E
        st      adlh(2)                 ; update the display
        csa                             ; check if done
        ani     080h
        jz      Done
        ccl                             ; clear carry,done next time !
        ldi     0
        st      d4(2)                   ; zero digit 4
        ld      @2(2)                   ; fix P2 for next time around
        jmp     LoopD
Done:
        ld      @-2(2)                  ; refix P2 on exit
; ****************************************************************************
;       Keyboard and Display Input.
;       JMP Command in A (GO=6,MEM=7,TERM=3,in E +16)
;       Number return, hex number in E reg
;       ABORT key goes to abort
;       all registers used
;       P2 points to RAM,address MUST be xxx0
;       to re-execute do XPPC3
; ****************************************************************************
Kybd:   ldi     0                       ; zero char
        st      char(2)
        ldi     High(Disp)              ; P1 points to the display
        xpah    1
Off:    ldi     -1                      ; Set Row/Digit Address
        st      row(2)
        ldi     10                      ; Set Row Count
        st      cnt(2)
        ldi     0                       ; Zero keyboard input
        st      pushed(2)
        xpal    1                       ; Set display address (low)
KDLoop:
        ild     row(2)                  ; next row ?
        xae                             ; put it in E
        ld      -128(2)                 ; get the segment into A
        st      -128(1)                 ; send it to the display
        dly     0                       ; delay for display,let keys settle
        ld      -128(1)                 ; get keyboard input
        xri     0FFh                    ; invert the input so 1 = pressed
        jnz     Key                     ; jump if a key pushed (save in Pushed)
Back:
        dld     cnt(2)                  ; check if done
        jnz     KDLoop                  ; no if jump
        ld      pushed(2)               ; check if key pressed
        jz      CkMore                  ; if no, then go to try again
        ld      char(2)
        jnz     Off                     ; if yes, wait for release
        ld      pushed(2)               ; released ? set char
        st      char(2)
        jmp     Off
CkMore: ld      char(2)                 ; check if there was a character
        jz      Off                     ; no, keep looking

Command:xae                             ; copy into E
        lde
        ani     020h                    ; check for command
        jnz     Cmnd                    ; jump if command
        ldi     080h                    ; find number (its a digit 0..F)
        ane
        jnz     Lt7                     ; 0 to 7
        ldi     040h
        ane
        jnz     N89                     ; 8, 9
        ldi     0fh                     ; B to F
        ane
        adi     7
        xae
        ld      -128(0)                 ; get number
KeyRtn: xae                             ; save in E
        ld      @2(3)                   ; fix return,add 2
        xppc    3
        jmp     Kybd                    ; allows us to go round again
        .db     0Ah,0Bh,0Ch,0Dh,0,0,0Eh,0Fh
Lt7:    xre                             ; keep low digit (handler for 0..7)
        jmp     KeyRtn
N89:    xre                             ; get low (handler for 8 & 9)
        adi     8                       ; make it 8 or 9
        jmp     KeyRtn

Cmnd:   xre
        xri     4                       ; check if abort
        jz      Abrt                    ; if so,goto abort
        xppc    3                       ; return
        jmp     Kybd                    ; and allow reentry

Key:    ore                             ; make character
        st      pushed(2)               ; save it
        jmp     Back

Abrt:   ldi     High(Abort)             ; goto abort
        xpah    3
        ldi     Low(Abort)-1
        xpal    3
        xppc    3



        .end
