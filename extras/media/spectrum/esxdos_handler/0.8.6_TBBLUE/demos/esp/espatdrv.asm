;
; TBBlue / ZX Spectrum Next project
; Copyright (c) 2010-2018 
;
; ESPAT.DRV - Tim Gilberts based on Sample Driver from Garry Lancaster
;
; All rights reserved
;
; Redistribution and use in source and synthezised forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; Redistributions of source code must retain the above copyright notice,
; this list of conditions and the following disclaimer.
;
; Redistributions in synthesized form must reproduce the above copyright
; notice, this list of conditions and the following disclaimer in the
; documentation and/or other materials provided with the distribution.
;
; Neither the name of the author nor the names of other contributors may
; be used to endorse or promote products derived from this software without
; specific prior written permission.
;
; THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
; THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
; PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
;
; You are responsible for any legal issues arising from your use of this code.
;
;-------------------------------------------------------------------------------

; ***************************************************************************
; * Interrupt driven Driver for ESP8266 with Factory AT command set         *
; * (c) 2018 Infinite Imaginations / T.J.Gilberts			    *
; ***************************************************************************
;
; File version Alpha 10

		DEBUG	EQU	0	; Include debug code
		BORDER	EQU	0	; No border changes if 0
;
; This file is the 512-byte NextOS driver itself, plus relocation table.
;
; Assemble with: pasmo espatdrv.asm espatdrv.bin espatdrv.sym
;
; After this, espatdrv_drv.asm needs to be built to generate the actual
; driver file.
;
; At the moment it requires a 16K page of memory available to bank to
; mmu5 and mmu7 pages before calling setup as part of the open
; this will eventually form part of the install process. This contains the
; Memory Resident TSR code and the command / write buffers.
;
; A000 is the 8K Page of assembly with the JUMP tables - this will move
; to MMC memory especially IF we implement a Spectranet compatible Sockets API
;
; This now replaces the UART driver to improve handling of received IPD packets
; so that they are placed directly on the relevent receive queues.
;
; This will also allow us to support the remote debugging service if a listener
; is setup within this code.
;
; ***************************************************************************
; * Entry points                                                            *
; ***************************************************************************
; Drivers are a fixed length of 512 bytes (although can have external 8K
; banks allocated to them if required).
;
; They are always assembled at origin $0000 and relocated at installation time
;
; The driver always runs with interrupts disabled, and may use any of the
; standard register set (AF,BC,DE,HL). Index registers and alternates must be
; preserved.
;
; No esxDOS hooks or restarts may be used. However, 3 calls are provided
; which drivers may use:
;
;       call    $2000   ; drv_drvswapmmc
;                       ; Used for switching between allocated DivMMC banks
;
;       call    $2003   ; drv_drvrtc
;                       ; Query the RTC. Returns BC=date, DE=time (as M_DATE)
;
;       call    $2006   ; drv_drvapi
;                       ; Access other drivers. Same parameters as M_DRVAPI.
;
; The stack is always located below $4000, so if ZX banks have been allocated
; they may be paged in at any location (MMU2..MMU7). However, when switching
; to other allocated DivMMC banks, the stack cannot be used unless you set
; it up/restore it yourself.
; If you do switch any banks, don't forget to restore the previous MMU setting
; afterwards.

TX_CHKREADY	EQU	4923	;133Bh Write is byte to send, when read status
					;0x01 = RX_AVAIL (1 = data to collect)
					;0x02 - TX_READY (1 = still transmit)
					;0x04 - UART FULL (1 if buffer full)
RX_SETBAUD	EQU	5179	;143Bh Read is byte received, when written set
				;the BAUD rate which is written as two bytes
				;forming a 14bit prescale value
				;First byte Bit 7=0 contains LSBits0-6,
				;2nd BIT7=1 contains MSBits 14-7

; Makes use of the following to save and load MMU registers
; Slot 7 E000-FFFF ; 8K CMD buffer
; Slot 6 C000-DFFF ; 16K IPD buffers
; Slot 5 A000-BFFF ; Used for Main CODE TSR

;   nextreg reg,val   ED 91 reg,val   16Ts  Set a NEXT register (like doing out
;   ($243b),reg then out($253b),val )
;   nextreg reg,a     ED 92 reg       12Ts  Set a NEXT register using A (like 
;   doing out($243b),reg then out($253b),A )

; ***************************************************************************
; * Entry points                                                            *
; ***************************************************************************

CMD_WRITE_BUFFER	EQU	$E600   ;$E600
	
        org     $0000

; -- Table of used jump routines in 8K TSR
;
Signature	EQU $A000
APIExtend	EQU Signature+3
IRQExtend 	EQU APIExtend+21

; At $0000 is the entry point for API calls directed to the driver.
; B,DE,HL are available as entry parameters.

api_entry:
        jr      net_api

	defb	0			; Could be flags again

; At $0003 is the entry point for the interrupt handler. This will only be
; called if bit 7 of the driver id byte has been set in your .DRV file, so
; need not be implemented otherwise.

; For the network driver it empties the UART buffers into the various network
; stream buffers (each 8K/16K in size) usually located at $C000-$FFFF (mmu6/7)

;IF BYTE(S) AVAILABLE
;  STORE ERROR STATE / UART FULL FLAG SET
;  IF NOT DISABLED
;    SAVE MMU STATE
;    BANK IN 8K CODE PAGE and 8K CMD BUFFER PAGE
;    DRAIN UART FIFO BUFFER to CURRENT CMD READ BUFFER
;	WHERE char stream contains "+IPD," CALL Extended IRQ for IPD packets
;    Timeout if no more data for a short period...
;RETURN

im1_entry:
	LD BC,TX_CHKREADY		;service routine faster when no data
	IN A,(C)
	BIT 0,A				;Check status but don't damage A
	RET Z				;Return from IRQ if no data in fifo

;SAVE UART FULL - Note this flag must stay set until acknowledged from BASIC
im_reloc_0:
	LD HL,flags
	AND %00000100			;If UART was full.
	OR (HL)
	LD (HL),A
			
;Check if we are disabled (BIT 7 of flags set) - this is done so we do not 
;write data to Page 0 without Authorisation.
;and because users can't set a page other than 0 before we are loaded yet 
;otherwise due to .install not supporting it.
;OR (HL) will set Sign Flag so M means set
	RET M

if BORDER=1
	OR %00011001			;Blue BORDER if we need to page switch  
	OUT (0xFE),A			
endif
						
	PUSH IX				;Setup IX for convenience now

im_reloc_1:
	CALL PAGES_IN
		
	CALL IRQExtend

if BORDER=1
;Use system border colour
	LD A,(23624)			;BORDCR is *8
	RRCA
	RRCA
	RRCA
	AND %00000111
	OR %00011000

;	LD A,%00011000			;Black BORDER when back  
	OUT (0xFE),A
endif

;Note the TSR will come back here to exit any way it wants
;so flags cannot be affected etc.

tsr_api_return:
	
	POP IX

PAGES_OUT:
	DEFB $ED,$91,$55,$05		;NEXTREG r,n ED 91 reg,val
;(By default pages back in Five, old one saved here)
saved_mmu5 equ $-1
	DEFB $ED,$91,$57,$01	
saved_mmu7 equ $-1

	RET


	
; ***************************************************************************
; * API for NETWORK                                                         *
; ***************************************************************************
; On entry, use B=call id with HL,DE other parameters.
; (NOTE: HL will contain the value that was either provided in HL (when called
;        from dot commands) or IX (when called from a standard program).
;
; When called from the DRIVER command, DE is the first input and HL is the 
; second.
;
; When returning values, the DRIVER command will place the contents of BC into
; the first return variable, then DE and then HL.

net_api:
	ld	a,b
	dec	a			; Temp f9 becomes f8 but we find 1
	jr	z,set_pages     

	add	a,9			; Move into range f9 (f8) becomes 1

	cp 	20			; 1-11 only external calls allowed
	jr	nc,api_error      	; 0 never occurs as that is IRQ vector

	ld 	c,a			; Max of 126 calls so no overflow *2+1
	rlca				; know bit7 = 0 so *2

	push	ix

execute_tsr:
	ld	b,0
	push	hl			; Save parameter on stack
api_reloc_1:
	ld	hl,tsr_api_return	; Where to come back to
	ex	(sp),hl
	push	hl

	ld	l,a
	ld	h,Signature >> 8	; High of jump table
	add	hl,bc			; add in the 3rd value for *3

	xor	a			; a=0 as we came in on the API (def chan)

	push	hl			; Ret to jump table

;Drop through to save current registry and page in the needed pages

PAGES_IN:
im_reloc_2:
	LD IX,stream0
	
	PUSH AF
;PAGE IN Correct TSR and Buffer page....
	LD BC,9275		;$243B Need to Save MMU registers

	IN A,(C)		;Save current registry state
im_reloc_3:
	LD (saved_reg),A
	
	LD A,$55
	OUT (C),A
	INC B			;instead of LD BC,9531 / $253B
	IN A,(C)	
im_reloc_4:
	LD (saved_mmu5),A
	LD A,5
new_mmu5 equ $-1
	OUT (C),A		;New 8K bank for Code **TODO make DIVMMC
							
	DEC B			;$243B
	LD A,$57
	OUT (C),A
	INC B			;$253B
	IN A,(C)
im_reloc_5:
	LD (saved_mmu7),A			
im_reloc_6:
	LD A,(stream0_mmu7)
	OUT (C),A

	DEC B			;$243B
	LD A,2
saved_reg equ $-1	
	OUT (C),A		;just in case IRQ was in between registry work 
				
	POP AF
	RET	


;------
;B=1 set available memory pages to use - values of LSB/MSB must be 0 for mainmem
;from Alpha10 if MSB=255 (i.e. Page set to 65535) then does a disable.
;Converts a 16K BASIC BANK to 8K pages 

set_pages:	

api_reloc_2:
	ld	hl,flags

	ld	a,d
	or	e
	jr	z,start_run
	
	inc	a			; Was MSB 255
	jr	z, stop_run
	ld	a,e
	
	rlca
api_reloc_3:
	ld	(new_mmu5),A
	inc	a
api_reloc_4:
	ld	(stream0_mmu7),A

;They have been explicit they want to use main memory or restart a paused system
;so set the hares running
start_run:
;Set BIT 7 to 0 and start running extended IRQ but not IPD yet as no buffers
	res	7,(hl)			; Start IRQ running
	ret

;Reset BIT 7 to stop IRQ getting any data from the buffer or affecting flags
stop_run:
	set	7,(hl)
	ret

; Unsupported values of B. 

api_error:
        xor     a                       ; A=0, unsupported call id or Invalid IO
        scf                             ; Fc=1, signals error
        ret




; ***************************************************************************
; * Data                                                                    *
; ***************************************************************************
; This structure must be present somewhere in memory that the driver code
; can see.

ipdstring:
	defm	",DPI+"			;(IX-1) etc must be IPD header

stream0:
flags:					
	defb	%11000000		;Also as IX-0 when in IRQ!
;Bit 0 = Colour modifier (RX_AVAIL) 
;Bit 1 = 8K SW command buffer overwrite error state (temp) (TX_READY)
;Bit 2 = UART 512Byte HW FULL error state (temp)
;Bit 3 = internal suppression flag
;Bit 4 = Buffer full flag 
;Bit 5 = IPD packet seen.
;Bit 6 = IPD packet mode receive disable when 1
;Bit 7 = we are disabled when 1
;Note that BIT 7 is buffer full flag normally but, different layout in CMD

stream0_mmu7:
	defb	1			;This forms an 8K buffer at top of main
	defb 	255,255,255		;memory.
	
output_add:
	defw	CMD_WRITE_BUFFER	;Nothing in buffer as yet
    
input_add:
	defw	CMD_WRITE_BUFFER


zzz_end:
	
; ***************************************************************************
; * Relocation table                                                        *
; ***************************************************************************
; This follows directly after the full 512 bytes of the driver.

if ($ > 512)
.ERROR Driver code exceeds 512 bytes 
else
        defs    512-$
endif

; Each relocation is the offset of the high byte of an address to be relocated.

reloc_start:
        defw	im_reloc_0+2
        defw	im_reloc_1+2
        defw	im_reloc_2+3	;IX load
        defw	im_reloc_3+2
        defw	im_reloc_4+2
        defw	im_reloc_5+2 
        defw	im_reloc_6+2
                              
        defw    api_reloc_1+2
        defw    api_reloc_2+2
        defw    api_reloc_3+2
        defw    api_reloc_4+2
reloc_end:




