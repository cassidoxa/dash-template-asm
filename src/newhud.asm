;------------------------------------------------------------------------------
; New HUD
;------------------------------------------------------------------------------
; Max ammo display by personitis. Charge HUD by Masshesteria.
;------------------------------------------------------------------------------

InitHUDAmmoExpanded:
        .missiles
        JSR.w HUDDrawThreeDigits
        LDA.w MaxMissiles : LDX.w #$0014
        JSR.w HUDDrawThreeDigits
        RTS
        .supers
        JSR.w HUDDrawTwoDigits
        LDA.w MaxSupers : LDX.w #$001C
        JSR.w HUDDrawTwoDigits
        RTS
        .pbs
        JSR.w HUDDrawTwoDigits
        LDA.w MaxPBs : LDX.w #$0022
        JSR.w HUDDrawTwoDigits
RTS

NewHUDAmmo:
        PHA : PHX : PHY 
        LDA.w MaxMissiles
        BEQ +
                JSR.w .missiles
        +
        LDA.w MaxSupers
        BEQ +
                JSR.w .supers
        +
        LDA.w MaxPBs
        BEQ +
                JSR.w .pbs
        +
        PLY : PLX : PLA
        LDA.w MaxMissiles
RTS

.missiles
        JSR.w NewHUDDivision
        LDA.w HUDItemIndex : CMP.w #$0001 : BEQ +
                LDA.w #$1400 : STA.b $18 : BRA .writemissiles
        +
        LDA.w #$1000 : STA.b $18
        .writemissiles
        LDX.b $12 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC61C
        LDX.b $14 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC61E
        LDX.b $16 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC620
        LDA.w #$0049 : ORA.b $18 : STA.l $7EC65C
        LDA.w #$004A : ORA.b $18 : STA.l $7EC65E
        LDA.w #$004B : ORA.b $18 : STA.l $7EC660
RTS

.supers
        JSR.w NewHUDDivision_by10
        LDA.w HUDItemIndex : CMP.w #$0002 : BEQ +
                LDA.w #$1400 : STA.b $18 : BRA .writesupers
        +
        LDA.w #$1000 : STA.b $18
        .writesupers
        LDX.b $14 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC624
        LDX.b $16 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC626
        LDA.w #$0034 : ORA.b $18 : STA.l $7EC664
        LDA.w #$0035 : ORA.b $18 : STA.l $7EC666
RTS

.pbs
        JSR.w NewHUDDivision_by10
        LDA.w HUDItemIndex : CMP.w #$0003 : BEQ +
                LDA.w #$1400 : STA.b $18 : BRA .writepbs
        +
        LDA.w #$1000 : STA.b $18
        .writepbs
        LDX.b $14 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC62A
        LDX.b $16 : LDA.w AmmoDigits,X : ORA.b $18 : STA.l $7EC62C
        LDA.w #$0036 : ORA.b $18 : STA.l $7EC66A
        LDA.w #$0037 : ORA.b $18 : STA.l $7EC66C
RTS

; TODO: Optimize with a table or something
NewHUDDivision:
        STA.w $4204
        SEP #$20
        LDA.b #$64 : STA.w $4206
        REP #$20
        PHA : PLA : NOP
        LDA.w $4214 : ASL : STA.b $12
        LDA.w $4216
        
        .by10
        STA.w $4204
        SEP #$20
        LDA.b #$0A : STA.w $4206
        REP #$20
        PHA : PLA : NOP
        LDA.w $4214 : ASL : STA.b $14
        LDA.w $4216 : ASL : STA.b $16
RTS

AmmoDigits:
dw $0045, $003C, $003D, $003E, $003F, $0040, $0041, $0042, $0043, $0044

setup_charge_hud:
        LDA.l ChargeMode : CMP.w #$0101 : BCC +
                LDA.w #$2C0F : LDX.w #0000
                -
                        STA.l $7EC68A,X ; Blank tiles
                        INX #2
                        CPX.w #$0008
                BNE -
                LDA.w #$FFFF : STA.w PreviousBeams
        +
        LDA.w VanillaItemsEquipped
RTS

; Routine that draws the charge damage on the HUD
draw_charge_damage:
        LDA.l ChargeMode : CMP.w #$0101 : BCC +
                LDA.w ChargeUpgrades : XBA : ORA.w BeamsEquipped ; 000c-nnnn-0000-psiw
                CMP.w PreviousBeams : BEQ +
                        STA.w PreviousBeams
                        LDA.w #custom_digits : STA.b $00
                        JSL.l external_load_charge_damage
                        CMP.w #0100 : BCS .draw_3
                                .draw_2
                                LDX.w #$00B0
                                JSR.w HUDDrawTwoDigits
                                LDA.w #$2C0F : STA.l $7EC6B6 ; Blank tile
                                BRA +
                        .draw_3
                        LDX.w #$00AE
                        JSR.w HUDDrawThreeDigits
        +
        LDA.w #$9DD3
RTS

; Define custom digits used on the charge HUD
custom_digits: {
        !palette = 3
        !character = 9
        !offset = 00 ; 0 for normal, 60 = color swap
        !priority = $2000
        !zero_digit #= (!priority)|(!character+!offset)|(!palette<<10)

        ;print hex(!zero_digit)
        dw !zero_digit
        !i = 9
        while !i > 0
           ;print hex(!zero_digit-!i)
           dw !zero_digit-!i
           !i #= !i-1
        endif
}
