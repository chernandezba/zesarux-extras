;
; TBBlue / ZX Spectrum Next project
; Copyright (c) 2010-2018 
;
; ESPATDRV.DRV - Tim Gilberts based on Sample Driver from Garry Lancaster
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
; * Interrupt driven Driver for Network                                     *
; ***************************************************************************
;
; File Version Alpha 10
;
; This file generates the actual espatdrv.drv file which can be installed or
; uninstalled using the .install/.uninstall commands.
;
; The driver itself (espatdrv.asm) must first be built.
;
; Assemble this file with: pasmo espatdrv_drv.asm espat.drv


; ***************************************************************************
; * Definitions                                                             *
; ***************************************************************************
; Pull in the symbol file for the driver itself and calculate the number of
; relocations used.

        include "espatdrv.sym"

relocs  equ     (reloc_end-reloc_start)/2


; ***************************************************************************
; * .DRV file header                                                        *
; ***************************************************************************
; The driver id must be unique, so current documentation on other drivers
; should be sought before deciding upon an id. This example uses $7f as a
; fairly meaningless value. A network driver might want to identify as 'N'
; for example.

        org     $0000

        defm    "NDRV"          ; .DRV file signature

        defb    'N'+$80         ; 7-bit unique driver id in bits 0..6
                                ; bit 7=1 if to be called on IM1 interrupts

        defb    relocs          ; number of relocation entries (0..255)

        defb    0               ; number of additional 8K DivMMC RAM banks
                                ; required (0..8)

        defb    0               ; number of additional 8K Spectrum RAM banks
                                ; required (0..200)


; ***************************************************************************
; * Driver binary                                                           *
; ***************************************************************************
; The driver + relocation table should now be included.

        incbin  "espatdrv.bin"


; ***************************************************************************
; * Additional bank images and patches                                      *
; ***************************************************************************
; If any 8K DivMMC RAM banks or 8K Spectrum RAM banks were requested, then
; preloaded images and patch lists should be provided.
;
;       First, for each mmcbank requested:
;
;       defb    bnk_patches     ; number of driver patches for this bank id
;       defw    bnk_size        ; size of data to pre-load into bank (0..8191)
;       defs    bnk_size        ; data to pre-load into bank
;       defs    bnk_patches*2   ; for each patch, a 2-byte offset (0..511) in
;                               ; the 512-byte driver to write the bank id to
;       NOTE: The first patch for each mmcbank should never be changed, as
;             .uninstall will use the value for deallocating.
;
;       Then, for each zxbank requested:
;
;       defb    bnk_patches     ; number of driver patches for this bank id
;       defw    bnk_size        ; size of data to pre-load into bank (0..8191)
;       defs    bnk_size        ; data to pre-load into bank
;       defs    bnk_patches*2   ; for each patch, a 2-byte offset (0..511) in
;                               ; the 512-byte driver to write the bank id to
;       NOTE: The first patch for each zxbank should never be changed, as
;             .uninstall will use the value for deallocating.

