;------------------------------------------------------------------------------
; New Item PLMS
;------------------------------------------------------------------------------
; Organized for 21 new items. Chozo and hidden offsets identical to vanilla items.
;------------------------------------------------------------------------------
; Bank 84
; Borrowed from total
;------------------------------------------------------------------------------

DashItemPLMs:
        .visible : fillbyte $00 : fill $54
        .chozo   : fillbyte $00 : fill $54
        .hidden  : fillbyte $00 : fill $54
        .loadid  : fillbyte $00 : fill $FC

ItemHandlers:
        .visible : dw ItemTableLoad_visible
        .chozo   : dw ItemTableLoad_chozo   
        .hidden  : dw ItemTableLoad_hidden  

ItemTableLoad:
        .visible : LDY.w #VisibleItemTable : RTS
        .chozo   : LDY.w #ChozoItemTable : RTS
        .hidden  : LDY.w #HiddenItemTable : RTS

; Tables of mostly vectors, or pointers to some code dynamically jumped to, and
; some data for each type of item.
VisibleItemTable:
        dw LoadCustomGraphics
        dw RoomItemArgument, .end
        dw SetGoto, .trigger
        dw PLMPreInstruction, $DF89
        dw StartDrawLoop
        .loop
        dw DrawItemFrame1
        dw DrawItemFrame2
        dw PLMGoto, .loop
        .trigger
        dw SetRoomItem
        dw QueueMusic : db $02
        dw ItemPickup
        .end
        dw PLMGoto, $DFA9

ChozoItemTable:
        dw LoadCustomGraphics
        dw RoomItemArgument, .end
        dw PLMInstruction, $DFAF
        dw PLMInstruction, $DFC7
        dw SetGoto, .trigger
        dw PLMPreInstruction, $DF89
        dw PLMTimer : db $16
        dw StartDrawLoop
        .loop
        dw DrawItemFrame1
        dw DrawItemFrame2
        dw PLMGoto, .loop
        .trigger
        dw SetRoomItem
        dw QueueMusic : db $02
        dw ItemPickup
        .end
        dw $0001, $A2B5
        dw PLMDelete

HiddenItemTable:
        dw LoadCustomGraphics
        .loop2
        dw PLMInstruction, $E007
        dw RoomItemArgument, .end
        dw SetGoto, .trigger
        dw PLMPreInstruction, $DF89
        dw PLMTimer : db $16
        dw StartHiddenDrawLoop
        .loop
        dw DrawItemFrame1
        dw DrawItemFrame2
        dw PLMDecrementTimer, .loop
        dw PLMInstruction, $E020
        dw PLMGoto, .loop2
        .trigger
        dw SetRoomItem
        dw QueueMusic : db $02
        dw ItemPickup
        .end
        dw PLMInstruction, $E032
        dw PLMGoto, .loop2

; New item PLMs
;        id,  label name   visible, chozo, hidden
%ItemPLM($00, DoubleJump) ; $EFE0,  $F034, $F088
%ItemPLM($01, HeatShield) ; $EFE4,  $F038, $F08C
%ItemPLM($02, AquaBoots)  ; $EFE8,  $F03C, $F090

; Graphics pointers for items (by item index)
; The first word is a pointer to a (vanilla) sprite. If we add new sprites
; we'll have to write some new code for indexing the new gfx.
; The bytes here are related to the palette. Sprites are divided into four tiles
; and have dark frame palettes (left four) and light frame palettes (right four.) 
; Each half goes upper left to lower right.
; TODO: Proper palette loading, new gfx (?)
DashItemGraphics:
dw $8600 : db $03, $03, $03, $03, $03, $03, $03, $03    ; $00 - Double Jump
dw $8300 : db $01, $01, $01, $01, $01, $01, $01, $01    ; $01 - Heat Shield
dw $8400 : db $03, $03, $03, $03, $03, $03, $03, $03    ; $02 - Aqua Boots
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $03 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $04 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $05 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $06 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $07 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $08 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $09 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0A - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0B - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0C - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0D - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0E - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $0F - Unused

dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $20 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $21 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $22 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $23 - Unused
dw $0000 : db $00, $00, $00, $00, $00, $00, $00, $00    ; $24 - Unused

DashItemTable:
;  pickup,   qty,   msg,   type,  ext2,  ext3,  loop,  hloop
dw ItemSave, $0001, $001D, $0004, $0000, $0000, $0000, $0000  ; $00 - Double Jump
dw ItemSave, $0002, $001E, $0004, $0000, $0000, $0000, $0000  ; $01 - Heat Shield
dw ItemSave, $0004, $001F, $0004, $0000, $0000, $0000, $0000  ; $02 - Aqua Boots
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $03 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $04 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $05 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $06 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $07 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $08 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $09 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0A - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0B - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0C - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0D - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0E - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $0F - Unused

dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $10 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $11 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $12 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $13 - Unused
dw $0000,    $0000, $0000, $0004, $0000, $0000, $0000, $0000  ; $14 - Unused

StartDrawLoop:
        PHY : PHX
        LDA.l ItemPLMBuffer,X ; Load item id
        ASL #4
        CLC : ADC.w #$000C : TAX
        LDA.w DashItemTable,X
        PLX : PLY
RTS

StartHiddenDrawLoop:
        PHY : PHX
        LDA.l ItemPLMBuffer,X ; Load item id
        ASL #4
        CLC : ADC.w #$000E : TAX
        LDA.l DashItemTable,X
        PLX : PLY
RTS

LoadCustomGraphics:
        PHY : PHX
        LDA.l ItemPLMBuffer,X
        ASL : STA.b MultiplyResult
        ASL #2 : CLC : ADC.b MultiplyResult ; Multiply by 10
        ADC.w #DashItemGraphics : TAY ; Add it to the graphics table and transfer into Y
        LDA.w $0000,Y
        JSR.w $8764  ; Jump to original PLM graphics loading routine
        PLX : PLY
RTS

VisibleItemSetup:
        TYX : STA.l ItemPLMBuffer,X
        ASL : STA.b MultiplyResult
        ASL #2 : CLC : ADC.b MultiplyResult ; Multiply by 10
        TAX
        LDA.w DashItemGraphics,X
JMP.w $EE64

HiddenItemSetup:
        TYX : STA.l ItemPLMBuffer,X
        ASL : STA.b MultiplyResult
        ASL #2 : CLC : ADC.b MultiplyResult ; Multiply by 10
        TAX
        LDA.w DashItemGraphics,X
JMP.w $EE8E

ItemPickup:
        PHY : PHX
        LDA.l ItemPLMBuffer,X
        ASL #4
        CLC : ADC.w #DashItemTable
        TAX : TAY : INY #2
        JSR.w ($0000,X)
        PLX : PLY
RTS

ItemSave:
        LDA.w DashItemsCollected : ORA.w $0000,Y : STA.w DashItemsCollected
        LDA.w DashItemsEquipped : ORA.w $0000,Y : STA.w DashItemsEquipped
        LDA.w #$0168
        JSL.l PlayRoomMusic
        LDA.w $0002,Y : AND.w #$00FF : TAX
        JSL.l ShowMessage
        INY #3
RTS

NoopPLM: ; If we need a PLM instruction pointer that does nothing
RTS

; Routine called when a beam is collected.
collect_beam:
        LDA.w $0000,Y : PHA : BIT.w #$1000 : BEQ +
                LDA.l ChargeMode : AND.w #$000F : BEQ +
                    LDA.w BeamsCollected : BIT.w #$1000 : BEQ +
                            INC.w ChargeUpgrades
        +
        PLA
RTS

pushpc

; Special Blocks
org $84D409
SpecialSpeedCollide:
        LDA.w SpeedStepCounter : CMP.w #$03FF : BPL +
                LDA.w SamusPose : CMP.w #$0081 : BEQ ++
                                  CMP.w #$0082 : BEQ ++
        +
        JMP.w $CE83 ; Treat as bomb block
        ++
        LDA.w #$0000 : STA.w PLMIds,Y
        SEC
RTS

SpecialSpeedProjectile:
        LDX.w ProjectileIndex : LDA.w ProjectileType,X : AND.w #$0F00 : CMP #$0500 : BNE +
                JMP.w $CF0C ; Break block
        +
        LDA.w #$0000 : STA.w PLMIds,Y
RTS

SpecialShotProjectile:
        LDX.w ProjectileIndex : LDA.w ProjectileType,X : BIT.w #$0004 : BEQ +
                JMP.w $CF0C ; Break block
        +
        LDA.w #$0000 : STA.w PLMIds,Y ;Else delete PLM
RTS
warnpc $84D490

pullpc
