lorom

!DEBUG ?= 0

org $808000 ; Reserved
dw $8001    ;

org $80FFD8 ; SRAM size
db $05      ;

incsrc ram.asm
incsrc sram.asm
incsrc macros.asm
incsrc vanillalabels.asm
incsrc defines.asm
incsrc hooks.asm

incsrc generalbugfixes.asm
if !DEBUG = 1
    incsrc debugmode.asm
endif

org $81EF1A : fillbyte $FF : fill $10E5 ; Sorry Genji
org $DF8000 : fillbyte $FF : fill $7FFF

;------------------------------------------------------------------------------
; The higher banks don't have access to mirrored work RAM so we prefer to put
; our code in the lower banks. Each bank is generally limited in concerns
; so we can fit most specific code in one or two. This module will leave
; the PC at empty space at the end of a vanilla bank. But any sub-module can
; place code within empty/unused portions in the middle or in another bank with
; pushpc and pullpc.
;------------------------------------------------------------------------------
org $80CD90
incsrc init.asm
incsrc framehook.asm
incsrc stats/stats.asm
incsrc newhud.asm
warnpc $80FFC0 ; SNES ROM Header

org $81EF1A
incsrc save.asm
incsrc fileselect/fileselect.asm
warnpc $828000

org $82F900
incsrc fileselect/gameoptions.asm
incsrc subareas.asm
incsrc roompatching.asm
incsrc stats/stats_doors.asm
warnpc $838000

org $84EFE0
incsrc newplms.asm
incsrc plminject.asm
warnpc $858000

org $859643
incsrc messageboxes.asm
warnpc $868000

org $8BF760
incsrc credits/credits_scroll.asm
warnpc $8C8000

org $8FE9A0
incsrc doors.asm
warnpc $908000

org $90F63A
incsrc newitems.asm
incsrc suits.asm
incsrc beams.asm
incsrc stats/stats_weapons.asm
warnpc $918000

org $93F620
incsrc startercharge.asm
warnpc $948000

org $9AB542
incbin ../data/supericon.bin
org $9AB5C0
incbin ../data/pbicon.bin
org $9AB691
incbin ../data/missileicon.bin

org $A0F7D3
incsrc enemies.asm
warnpc $A18000

org $CEB230
incsrc roomedits.asm
incsrc credits/credits_data.asm
warnpc $CF8000

org $DF8000
incsrc tables.asm ; Keep this first
incsrc roomtables.asm
incsrc credits/credits.asm
warnpc $E08000

if !DEBUG = 1
    incsrc debugmode.asm
endif
