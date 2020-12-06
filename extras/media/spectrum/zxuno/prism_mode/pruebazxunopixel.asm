;Compile with Z88DK with the command:
;z80asm -b pruebazxunopixel.asm
;
; 
;
;
		org 49152

;Entry points

;poke_vram. 49152
        jp poke_vram

;view_prism. 49155
        jp view_prism

;putpixel. 49158
        jp putpixel

;putpixel_prism: 49161
        jp putpixel_prism


enable_prism_mode:
        ld bc,64571
        ld a,80
        out (c),a
        inc b
        ld a,128
        out (c),a
        ret
        
enable_prism_mapping:
        ld bc,64571
        ld a,80
        out (c),a
        inc b
        ld a,64
        out (c),a
        ret        

disable_prism_mode:
        ld bc,64571
        ld a,80
        out (c),a
        inc b
        xor a
        out (c),a
        ret        

set_rom:
        ;bit bajo
        push af
        rlca
        rlca
        rlca
        rlca
        and 16
        ld bc,32765
        out (c),a
        pop af

        ;bit alto
        rlca
        and 4
        ld bc,8189
        out (c),a
        ret

	
	;z80_byte rom_entra=((puerto_32765>>4)&1) + ((puerto_8189>>1)&2);

	;z80_byte rom1f=(puerto_8189>>1)&2;
	;z80_byte rom7f=(puerto_32765>>4)&1;
	
;poke function to desired vram
;set address in 32768
;set vram in 32770
;set value in 32771

;c02f = 49199
poke_vram:
		di


		call enable_prism_mapping

        ld a,(32770)
        call set_rom

        ld hl,(32768)
        ld a,(32771)

        ld (hl),a

        call disable_prism_mode

        ld a,3
        call set_rom

        ei

        ret
;c04e = 49226
view_prism:
        di
        call enable_prism_mode

        call wait_no_key

        call wait_key

        call disable_prism_mode

        ei

        ret



read_all_keys:
        xor a
        in a,(254)
        and 31
        ret

wait_no_key:
                call read_all_keys
                cp 31
                jr nz,wait_no_key
                ret

wait_key:
                call read_all_keys
                cp 31
                jr z,wait_key
                ret      



putpixel:
;32768: x
;32769: y
;32770: a 0 , clear pixel. a no 0, putpixel

;routine from https://github.com/ibancg/zxcircle/blob/master/zxcircle.asm



    push    af
    push    bc
    push    de
    push    hl      ; keep the registers

    ld      hl,tabpow2
    ld      a,(32768)
    and     7       ; x mod 8
    ld      b,0
    ld      c,a
    add     hl,bc


    ld a,(32770)
    or a
    jr nz,putpixel_set
    ;clear pixel
    ld a,(hl)
    cpl
    ld e,a
    jr putpixel_continue

putpixel_set:
    ld      a,(hl)
    ld      e,a     ; e contains one bit set

putpixel_continue:

    ld      hl,tablinidx
    ld      a,(32769)
    ld      b,0
    ld      c,a
    add     hl,bc
    ld      a,(hl)      ; table lookup

    ld      h,0
    ld      l,a
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl       ; x32 (16 bits)

    set     6,h         ; adds the screen start address (16384)

    ld      a,(32768)
    srl     a
    srl     a
    srl     a           ; x/8.

    or      l
    ld      l,a         ; + x/8.


    ld a,(32770)
    or a
    jr nz,putpixel_set_final
    ld a,(hl)
    and e
    jr putpixel_final

putpixel_set_final:

    ld      a,(hl)
    or      e           ; or = superposition mode.

putpixel_final:

    ld      (hl),a      ; set the pixel.

    pop     hl
    pop     de
    pop     bc
    pop     af          ; recovers registers.
    ret


;; screen lines lookup table
tablinidx:
    defb    0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57
    defb    2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59
    defb    4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61
    defb    6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63

    defb    64,72,80,88,96,104,112,120,65,73,81,89,97,105,113,121
    defb    66,74,82,90,98,106,114,122,67,75,83,91,99,107,115,123
    defb    68,76,84,92,100,108,116,124,69,77,85,93,101,109,117,125
    defb    70,78,86,94,102,110,118,126,71,79,87,95,103,111,119,127

    defb    128,136,144,152,160,168,176,184,129,137,145,153,161,169,177,185
    defb    130,138,146,154,162,170,178,186,131,139,147,155,163,171,179,187
    defb    132,140,148,156,164,172,180,188,133,141,149,157,165,173,181,189
    defb    134,142,150,158,166,174,182,190,135,143,151,159,167,175,183,191

tabpow2:
    ;; lookup table with powers of 2
    defb    128,64,32,16,8,4,2,1


;32768: x
;32769: y
;32771: color
putpixel_prism:

		di


		call enable_prism_mapping

        ;get color in c
        ld bc,(32771)
        ;in b we have the rom/vram number

        ld b,0

putpixel_prism_buc:

        ld a,b

        push bc

        call set_rom

        pop bc


        ;get bit
        ld a,c

        rrc c
        
        push bc

        and 1

        ;put/reset pixel
        ld (32770),a

        call putpixel

        pop bc

        inc b

        ld a,b

        cp 4

        jr nz,putpixel_prism_buc

        ld a,3
        call set_rom

        call disable_prism_mode

        ei

        ret