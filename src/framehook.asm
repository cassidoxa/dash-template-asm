; Bank 80

FrameHook:
        ; Beginning of main game loop
        JSL.l HDMAObjectHandler ; What we wrote over
RTL

PostFrameHook:
        ; End of game loop before waiting for NMI
        JSL.l WaitForNMI
RTL

NMIHook:
        ; Beginning of NMI
        LDA.w #$0000 : TCD ; What we wrote over
RTL

PostNMIHook:
        ; End of NMI
        REP #$30
        ;JSR.w PostHUDChangePalette
        JSR.w HandleTimersNMI
        INC.w NMICounter
RTL
